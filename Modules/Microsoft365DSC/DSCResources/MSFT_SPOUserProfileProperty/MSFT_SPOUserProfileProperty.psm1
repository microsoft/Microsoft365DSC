function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Properties,

        [Parameter()]
        [ValidateSet("Present")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting SPO Profile Properties for user {$UserName}"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $nullReturn = @{
        UserName           = $UserName
        Properties         = $Properties
        GlobalAdminAccount = $GlobalAdminAccount
        Ensure             = 'Absent'
    }

    try
    {

        $currentProperties = Get-PnPUserProfileProperty -Account $UserName

        if ($null -eq $currentProperties.AccountName)
        {
            return $nullReturn
        }
        $currentProperties = $currentProperties.UserProfileProperties
        $propertiesValue = @()

        foreach ($key in $currentProperties.Keys)
        {
            $convertedProperty = Get-SPOUserProfilePropertyInstance -Key $key -Value $currentProperties[$key]
            $propertiesValue += $convertedProperty
        }

        $result = @{
            UserName           = $UserName
            Properties         = $propertiesValue
            GlobalAdminAccount = $GlobalAdminAccount
            Ensure             = "Present"
        }

        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"

        return $result
    }
    catch
    {
        return $nullReturn
    }
}
function Set-TargetResource
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Properties,

        [Parameter()]
        [ValidateSet("Present")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Profile Properties for user {$UserName}"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $currentProperties = Get-TargetResource @PSBoundParameters

    foreach ($property in $Properties)
    {
        if ($currentProperties.Properties[$property.Key] -ne $property.Value)
        {
            Write-Verbose "Setting Profile Property {$($property.Key)} as {$($property.Value)}"
            try
            {
                Set-PnPUserProfileProperty -Account $UserName -PropertyName $property.Key -Value $property.Value -ErrorAction Stop
            }
            catch
            {
                Write-Warning "Cannot update property {$($property.Key)}. This value of that key cannot be modified."
            }
        }
    }
}
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Properties,

        [Parameter()]
        [ValidateSet("Present")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for SPO Sharing settings"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Microsoft365DSCParameterState  -DesiredValues $PSBoundParameters `
        -Source $($MyInvocation.MyCommand.Source) `
        -CurrentValues $CurrentValues

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [ValidateRange(1, 100)]
        $MaxProcesses = 16,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    $InformationPreference = 'Continue'

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -Platform AzureAD -CloudCredential $GlobalAdminAccount
    $result = ""

    # Get all instances;
    $instances = Get-AzureADUser

    # Split the complete list of instances into batches;
    if ($instances.Length -ge $MaxProcesses)
    {
        $instances = Split-ArrayByParts -Array $instances -Parts $MaxProcesses
        $batchSize = $instances[0].Length
    }
    else
    {
        $MaxProcesses = $instances.Length
        $batchSize = 1
    }

    # For each batch of 8 items, start and asynchronous background PowerShell job. Each
    # job will be given the name of the current resource followed by its ID;
    $i = 1
    foreach ($batch in $instances)
    {
        Start-Job -Name "SPOUserProfileProperty$i" -ScriptBlock {
            Param(
                [Parameter(Mandatory = $true)]
                [System.Object[]]
                $Instances,

                [Parameter(Mandatory = $true)]
                [System.String]
                $ScriptRoot,

                [Parameter(Mandatory = $true)]
                [System.Management.Automation.PSCredential]
                $GlobalAdminAccount
            )
            $WarningPreference = 'SilentlyContinue'

            # Implicitly load the M365DSCUtil.psm1 module in order to be able to call
            # into the Invoke-O36DSCCommand cmdlet;
            Import-Module ($ScriptRoot + "\..\..\Modules\M365DSCUtil.psm1") -Force | Out-Null

            # Invoke the logic that extracts the all the Property Bag values of the current site using the
            # the invokation wrapper that handles throttling;
            $returnValue = Invoke-M365DSCCommand -Arguments $PSBoundParameters -InvokationPath $ScriptRoot -ScriptBlock {
                $WarningPreference = 'SilentlyContinue'
                $params = $args[0]
                $content = ""
                foreach ($instance in $params.Instances)
                {
                    foreach ($user in $instance)
                    {
                        $getValues = @{
                            UserName           = $user.UserPrincipalName
                            GlobalAdminAccount = $GlobalAdminAccount
                        }
                        $CurrentModulePath = $params.ScriptRoot + "\MSFT_SPOUserProfileProperty.psm1"
                        Import-Module $CurrentModulePath -Force | Out-Null

                        $result = Get-TargetResource @getValues

                        if ($result.Ensure -eq "Present")
                        {
                            Import-Module ($params.ScriptRoot + "\..\..\Modules\M365DSCUtil.psm1") -Force | Out-Null
                            Import-Module ($params.ScriptRoot + "\..\..\Modules\M365DSCTelemetryEngine.psm1") -Force | Out-Null

                            $result.Properties = ConvertTo-SPOUserProfilePropertyInstanceString -Properties $result.Properties
                            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
                            $content += "        SPOUserProfileProperty " + (New-GUID).ToString() + "`r`n"
                            $content += "        {`r`n"

                            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $params.ScriptRoot
                            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Properties" -IsCIMArray $true
                            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
                            $content += $currentDSCBlock
                            $content += "        }`r`n"
                        }
                    }
                }

                return $content
            }
            return $returnValue
        } -ArgumentList @($batch, $PSScriptRoot, $GlobalAdminAccount) | Out-Null
        $i++
    }

    Write-Information "    Broke extraction process down into {$MaxProcesses} jobs of {$batchSize} item(s) each"
    $totalJobs = $MaxProcesses
    $jobsCompleted = 0
    $status = "Running..."
    $elapsedTime = 0
    do
    {
        $InformationPreference = 'SilentlyContinue'
        $jobs = Get-Job | Where-Object -FilterScript { $_.Name -like '*SPOUserProfileProperty*' }
        $count = $jobs.Length
        foreach ($job in $jobs)
        {
            if ($job.JobStateInfo.State -eq "Complete")
            {
                $currentContent = Receive-Job -name $job.name
                $result += $currentContent
                Remove-Job -name $job.name
                $jobsCompleted++
            }
            elseif ($job.JobStateInfo.State -eq 'Failed')
            {
                Remove-Job -name $job.name
                Write-Warning "{$($job.name)} failed"
                break
            }

            $status = "Completed $jobsCompleted/$totalJobs jobs in $elapsedTime seconds"
            $percentCompleted = $jobsCompleted / $totalJobs * 100
            Write-Progress -Activity "SPOUserProfileProperty Extraction" -PercentComplete $percentCompleted -Status $status
        }
        $elapsedTime ++
        Start-Sleep -Seconds 1
    } while ($count -ne 0)
    Write-Progress -Activity "SPOUserProfileProperty Extraction" -PercentComplete 100 -Status "Completed" -Completed
    $organization = ""
    $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
    if ($GlobalAdminAccount.UserName.Contains("@"))
    {
        $organization = $GlobalAdminAccount.UserName.Split("@")[1]

        if ($organization.IndexOf(".") -gt 0)
        {
            $principal = $organization.Split(".")[0]
        }
    }
    if ($result.ToLower().Contains($organization.ToLower()) -or `
            $result.ToLower().Contains($principal.ToLower()))
    {
        $result = $result -ireplace [regex]::Escape('https://' + $principal + '.sharepoint.com/'), "https://`$(`$OrganizationName.Split('.')[0]).sharepoint.com/"
        $result = $result -ireplace [regex]::Escape("@" + $organization), "@`$(`$OrganizationName)"
    }
    return $result
}

Export-ModuleMember -Function *-TargetResource
