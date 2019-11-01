function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of SPOPropertyBag for $Key"
    try
    {
        Write-Verbose -Message "Connecting to PnP from the Get method"
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                            -ConnectionUrl $Url `
                            -Platform PnP
        Write-Verbose -Message "Obtaining all properties from the Get method for url {$Url}"
        $property = Get-PnPPropertyBag
        Write-Verbose -Message "Properties obtained correctly"
    }
    catch
    {
        Write-Verbose "GlobalAdminAccount specified does not have admin access to site {$Url}"
    }

    if ($null -eq $property)
    {
        Write-Verbose -Message "SPOPropertyBag $Key does not exist at {$Url}."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $property = $property | Where-Object -FilterScript { $_.Key -eq $Key }
        Write-Verbose "Found existing SPOPropertyBag Key $Key at {$Url}"
        $result = @{
            Ensure             = 'Present'
            Url                = $Url
            Key                = $property.Key
            Value              = $property.Value
            GlobalAdminAccount = $GlobalAdminAccount
        }

        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-O365DscHashtableToString -Hashtable $result)"
        return $result
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of SPOPropertyBag property for $Key at {$Url}"

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -ConnectionUrl $Url `
                      -Platform PnP

    $currentProperty = Get-TargetResource @PSBoundParameters

    if ('Present' -eq $Ensure)
    {
        $CreationParams = @{
            Key   = $Key
            Value = $Value
        }
        Set-PnPPropertyBagValue @CreationParams
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        Remove-PnPPropertyBagValue -Key $Key
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of SPOPropertyBag for $Key at {$Url}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                                  -Source $($MyInvocation.MyCommand.Source) `
                                                  -DesiredValues $PSBoundParameters `
                                                  -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $InformationPreference = "Continue"
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -Platform PnP
    $result = ""

    # Get all Site Collections in tenant;
    $sites = Get-PnPTenantSite

    # Split the complete list of site collections into batches for a maximum of 8 concurrent jobs;
    if ($sites.Length -ge 16)
    {
        $batchSize = $sites.Length / 16
        $sites = Split-Array -Array $sites -BatchSize $batchSize
    }
    else
    {
        $batchSize = 1
    }

    # Define the Path of the Util module. This is due to the fact that inside the Start-Job
    # the module is not imported and simply doing Import-Module Office365DSC doesn't work.
    # Therefore, in order to be able to call into Invoke-O365DSCCommand we need to implicitly
    # load the module.
    $UtilModulePath = $PSScriptRoot + "\..\..\Modules\Office365DSCUtil.psm1"

    # For each batch of 8 items, start and asynchronous background PowerShell job. Each
    # job will be given the name of the current resource followed by its ID;
    $i = 1
    foreach ($batch in $sites)
    {
        Start-Job -Name "SPOPropertyBag$i" -ScriptBlock {
            Param(
                [Parameter(Mandatory = $true)]
                [System.Object[]]
                $sites,

                [Parameter(Mandatory = $true)]
                [System.String]
                $ScriptRoot,

                [Parameter(Mandatory = $true)]
                [System.String]
                $UtilModulePath,

                [Parameter(Mandatory = $true)]
                [System.Management.Automation.PSCredential]
                $GlobalAdminAccount
            )

            # Implicitly load the Office365DSCUtil.psm1 module in order to be able to call
            # into the Invoke-O36DSCCommand cmdlet;
            Import-Module $UtilModulePath -Force

            # Invoke the logic that extracts the all the Property Bag values of the current site using the
            # the invokation wrapper that handles throttling;
            $returnValue = ""
            $returnValue += Invoke-O365DSCCommand -Arguments $PSBoundParameters -InvokationPath $ScriptRoot -ScriptBlock {
                $params = $args[0]
                $content = ""
                foreach ($item in $params.sites)
                {
                    foreach ($site in $item)
                    {
                        $siteUrl = $site.Url
                        try
                        {
                            Test-MSCloudLogin -CloudCredential $params.GlobalAdminAccount `
                                              -ConnectionUrl $siteUrl `
                                              -Platform PnP
                        }
                        catch
                        {
                            throw "O365DSC - Failed to connect to PnP {$siteUrl}: " + $_
                        }

                        try
                        {
                            $properties = Get-PnPPropertyBag
                            foreach($property in $properties)
                            {
                                $getValues = @{
                                    Url                = $siteUrl
                                    Key                = $property.Key
                                    Value              = '*'
                                    GlobalAdminAccount = $params.GlobalAdminAccount
                                }

                                $CurrentModulePath = $params.ScriptRoot + "\MSFT_SPOPropertyBag.psm1"
                                Import-Module $CurrentModulePath -Force
                                $result = Get-TargetResource @getValues
                                $result.Value = [System.String]$result.Value
                                $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
                                $content += "        SPOPropertyBag " + (New-GUID).ToString() + "`r`n"
                                $content += "        {`r`n"
                                $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $params.ScriptRoot
                                $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
                                $content += "        }`r`n"
                            }
                        }
                        catch
                        {
                            throw "O365DSC - Failed to Get-PnPPropertyBag {$siteUrl}: " + $_
                        }
                    }
                }
                return $content
            }
            return $returnValue
        } -ArgumentList @(, $batch, $PSScriptRoot, $UtilModulePath, $GlobalAdminAccount) | Out-Null
        $i++
    }

    Write-Information "    Broke extraction process down into {$($sites.Length)} jobs of {$($sites[0].Length)} item(s) each"
    $totalJobs = $sites.Length
    $jobsCompleted = 0
    $status = "Running..."
    $elapsedTime = 0
    do
    {
        $jobs = Get-Job | Where-Object -FilterScript {$_.Name -like '*SPOPropertyBag*'}
        $count = $jobs.Length
        foreach ($job in $jobs)
        {
            if ($job.JobStateInfo.State -eq "Complete")
            {
                $result += Receive-Job -name $job.name
                Remove-Job -name $job.name
                $jobsCompleted++
            }
            elseif ($job.JobStateInfo.State -eq 'Failed')
            {
                Remove-Job -name $job.name
                Write-Warning "{$($job.name)} failed"
                break
            }

            $status =  "Completed $jobsCompleted/$totalJobs jobs in $elapsedTime seconds"
            $percentCompleted = $jobsCompleted/$totalJobs * 100
            Write-Progress -Activity "SPOPropertyBag Extraction" -PercentComplete $percentCompleted -Status $status
        }
        $elapsedTime ++
        Start-Sleep -Seconds 1
    } while ($count -ne 0)
    Write-Progress -Activity "SPOPropertyBag Extraction" -PercentComplete 100 -Status "Completed" -Completed
    return $result
}

Export-ModuleMember -Function *-TargetResource
