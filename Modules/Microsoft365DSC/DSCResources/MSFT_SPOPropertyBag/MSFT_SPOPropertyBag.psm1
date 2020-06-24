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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration of SPOPropertyBag for $Key"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    try
    {
        Write-Verbose -Message "Connecting to PnP from the Get method"
        $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters -connectionUrl $url
        Write-Verbose -Message "Obtaining all properties from the Get method for url {$Url}"
        $property = Get-PnpPropertyBag | Where-Object -FilterScript { $_.Key -ceq $Key }
        Write-Verbose -Message "Properties obtained correctly"
    }
    catch
    {
        Write-Verbose "GlobalAdminAccount or service principal specified does not have admin access to site {$Url}"
    }

    if ($null -eq $property)
    {
        Write-Verbose -Message "SPOPropertyBag $Key does not exist at {$Url}."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        $result.ApplicationId = $ApplicationId
        $result.TenantId = $TenantId
        $result.CertificatePassword = $CertificatePassword
        $result.CertificatePath = $CertificatePath
        CertificateThumbprint = $CertificateThumbprint
        return $result
    }
    else
    {
        Write-Verbose "Found existing SPOPropertyBag Key $Key at {$Url}"
        $result = @{
            Ensure                = 'Present'
            Url                   = $Url
            Key                   = $property.Key
            Value                 = $property.Value
            GlobalAdminAccount    = $GlobalAdminAccount
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
        }

        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration of SPOPropertyBag property for $Key at {$Url}"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters -connectionUrl $Url

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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Testing configuration of SPOPropertyBag for $Key at {$Url}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove("ApplicationId") | Out-Null
    $ValuesToCheck.Remove("TenantId") | Out-Null
    $ValuesToCheck.Remove("CertificatePath") | Out-Null
    $ValuesToCheck.Remove("CertificatePassword") | Out-Null
    $ValuesToCheck.Remove("CertificateThumbprint") | Out-Null

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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
        [Parameter()]
        [ValidateRange(1, 100)]
        $MaxProcesses,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    $InformationPreference = "Continue"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters

    $result = ""

    # Get all Site Collections in tenant;
    $instances = Get-PnPTenantSite
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
        Start-Job -Name "SPOPropertyBag$i" -ScriptBlock {
            Param(
                [Parameter(Mandatory = $true)]
                [System.Object[]]
                $Instances,

                [Parameter(Mandatory = $true)]
                [System.String]
                $ScriptRoot,

                [Parameter()]
                [System.Management.Automation.PSCredential]
                $GlobalAdminAccount,

                [Parameter()]
                [System.String]
                $ApplicationId,

                [Parameter()]
                [System.String]
                $TenantId,

                [Parameter()]
                [System.String]
                $CertificatePath,

                [Parameter()]
                [System.Management.Automation.PSCredential]
                $CertificatePassword,

                [Parameter()]
                [System.String]
                $CertificateThumbprint
            )
            $WarningPreference = 'SilentlyContinue'

            # Implicitly load the M365DSCUtil.psm1 module in order to be able to call
            # into the Invoke-O36DSCCommand cmdlet;
            Import-Module ($ScriptRoot + "\..\..\Modules\M365DSCUtil.psm1") -Force | Out-Null

            # Invoke the logic that extracts the all the Property Bag values of the current site using the
            # the invokation wrapper that handles throttling;
            $returnValue = ""
            $returnValue += Invoke-M365DSCCommand -Arguments $PSBoundParameters -InvokationPath $ScriptRoot -ScriptBlock {
                $VerbosePreference = 'SilentlyContinue'
                $params = $args[0]
                $content = ""
                foreach ($item in $params.instances)
                {
                    foreach ($site in $item)
                    {
                        $siteUrl = $site.Url
                        try
                        {
                            $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters -ConnectionUrl $siteUrl
                        }
                        catch
                        {
                            throw "M365DSC - Failed to connect to PnP {$siteUrl}: " + $_
                        }

                        try
                        {
                            $properties = Get-PnPPropertyBag
                            foreach ($property in $properties)
                            {

                                if ($ConnectionMode -eq 'Credential')
                                {
                                    $getValues = @{
                                        GlobalAdminAccount = $GlobalAdminAccount
                                        Url                = $siteUrl
                                        Key                = $property.Key
                                        Value              = '*'
                                    }
                                }
                                else
                                {
                                    $getValues = @{
                                        Url                   = $siteUrl
                                        Key                   = $property.Key
                                        Value                 = '*'
                                        ApplicationId         = $ApplicationId
                                        TenantId              = $TenantId
                                        CertificatePassword   = $CertificatePassword
                                        CertificatePath       = $CertificatePath
                                        CertificateThumbprint = $CertificateThumbprint
                                    }
                                }

                                $CurrentModulePath = $params.ScriptRoot + "\MSFT_SPOPropertyBag.psm1"
                                Import-Module $CurrentModulePath -Force | Out-Null
                                Import-Module ($params.ScriptRoot + "\..\..\Modules\M365DSCTelemetryEngine.psm1") -Force | Out-Null
                                if ($null -ne $TenantId)
                                {
                                    $organization = $TenantId
                                    $principal = $TenantId.Split(".")[0]
                                }
                                $result = Get-TargetResource @getValues
                                $result.Value = [System.String]$result.Value
                                if (-not [System.String]::IsNullOrEmpty($result.Value))
                                {
                                    if ($ConnectionMode -eq 'Credential')
                                    {
                                        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
                                    }
                                    else
                                    {
                                        if ($null -ne $CertificatePassword)
                                        {
                                            $result.CertificatePassword = Resolve-Credentials -UserName "CertificatePassword"
                                        }
                                    }
                                    $result = Remove-NullEntriesFromHashTable -Hash $result
                                    $content += "        SPOPropertyBag " + (New-GUID).ToString() + "`r`n"
                                    $content += "        {`r`n"
                                    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $params.ScriptRoot
                                    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
                                    if ($ConnectionMode -eq 'Credential')
                                    {
                                        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
                                    }
                                    else
                                    {
                                        if ($null -ne $CertificatePassword)
                                        {
                                            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "CertificatePassword"
                                        }
                                        else
                                        {
                                            $content += $currentDSCBlock
                                        }
                                        $content = Format-M365ServicePrincipalData -configContent $content -applicationid $ApplicationId `
                                            -principal $principal -CertificateThumbprint $CertificateThumbprint
                                    }

                                    $content += "        }`r`n"
                                }
                            }
                        }
                        catch
                        {
                            throw "M365DSC - Failed to Get-PnPPropertyBag {$siteUrl}: " + $_
                        }
                    }
                }
                return $content
            }
            return $returnValue
        } -ArgumentList @($batch, $PSScriptRoot, $GlobalAdminAccount, $ApplicationId, $TenantId, $CertificateThumbprint, $CertificatePassword, $CertificatePath) | Out-Null
        $i++
    }

    Write-Information "    Broke extraction process down into {$MaxProcesses} jobs of {$($instances[0].Length)} item(s) each"
    $totalJobs = $MaxProcesses
    $jobsCompleted = 0
    $status = "Running..."
    $elapsedTime = 0
    do
    {
        $InformationPreference = 'SilentlyContinue'
        $jobs = Get-Job | Where-Object -FilterScript { $_.Name -like '*SPOPropertyBag*' }
        $count = $jobs.Length
        foreach ($job in $jobs)
        {
            if ($job.JobStateInfo.State -eq "Complete")
            {
                $result += Receive-Job -name $job.name
                Remove-Job -name $job.name | Out-Null
                $jobsCompleted++
            }
            elseif ($job.JobStateInfo.State -eq 'Failed')
            {
                Remove-Job -name $job.name | Out-Null
                Write-Warning "{$($job.name)} failed"
                break
            }

            $status = "Completed $jobsCompleted/$totalJobs jobs in $elapsedTime seconds"
            $percentCompleted = $jobsCompleted / $totalJobs * 100
            Write-Progress -Activity "SPOPropertyBag Extraction" -PercentComplete $percentCompleted -Status $status
        }
        $elapsedTime ++
        Start-Sleep -Seconds 1
    } while ($count -ne 0)
    Write-Progress -Activity "SPOPropertyBag Extraction" -PercentComplete 100 -Status "Completed" -Completed
    $organization = ""
    $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
    if ($null -ne $GlobalAdminAccount -and $GlobalAdminAccount.UserName.Contains("@"))
    {
        $organization = $GlobalAdminAccount.UserName.Split("@")[1]

        if ($organization.IndexOf(".") -gt 0)
        {
            $principal = $organization.Split(".")[0]
        }
    }
    else
    {
        $principal = $TenantId.Split(".")[0]
        $organization = $TenantId
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
