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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        try
        {
            Write-Verbose -Message "Connecting to PnP from the Get method"

            $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
                    -InboundParameters $PSBoundParameters `
                    -Url $Url

            Write-Verbose -Message "Obtaining all properties from the Get method for url {$Url}"
            [array]$property = Get-PnpPropertyBag -Key $Key -ErrorAction 'Stop'

            Write-Verbose -Message "Properties obtained correctly"
        }
        catch
        {
            Write-Verbose "GlobalAdminAccount or service principal specified does not have admin access to site {$Url}"
            if ($_.Exception -like "*Unable to cast object of type*")
            {
                [array]$property = Get-PnpPropertyBag | Where-Object -FilterScript { $_.Key -ceq $Key }
            }
            elseif ($_.Exception -like "*The underlying connection was closed*")
            {
                $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
                    -InboundParameters $PSBoundParameters `
                    -Url $Url

                Write-Verbose -Message "Obtaining all properties from the Get method for url {$Url}"
                [array]$property = Get-PnpPropertyBag -Key $Key -ErrorAction 'SilentlyContinue'
            }
            else
            {
                New-M365DSCLogEntry -Error $_ -Message "Couldn't get Property Bag for {$Url}" -Source $MyInvocation.MyCommand.ModuleName
                Write-Verbose "GlobalAdminAccount specified does not have admin access to site {$Url}"
            }
        }
        if ($property.Length -ne 1)
        {
            [array]$property = Get-PnpPropertyBag | Where-Object -FilterScript { $_.Key -ceq $Key }
        }
        if ($property.Length -eq 0)
        {
            Write-Verbose -Message "SPOPropertyBag $Key does not exist at {$Url}."
            return $nullReturn
        }
        else
        {
            Write-Verbose "Found existing SPOPropertyBag Key $Key at {$Url}"
            $result = @{
                Ensure                = 'Present'
                Url                   = $Url
                Key                   = $Key
                Value                 = $property[0]
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
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return $nullReturn
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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
                -InboundParameters $PSBoundParameters `
                -Url $Url

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

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
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
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
                -InboundParameters $PSBoundParameters

    try
    {
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
                $dscContent = ""
                foreach ($item in $params.instances)
                {
                    foreach ($site in $item)
                    {
                        $siteUrl = $site.Url
                        try
                        {
                            $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
                                -InboundParameters $PSBoundParameters `
                                -Url $siteUrl
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
                                $Params = @{
                                    Url                   = $siteUrl
                                    Key                   = $property.Key
                                    Value                 = '*'
                                    ApplicationId         = $ApplicationId
                                    TenantId              = $TenantId
                                    CertificatePassword   = $CertificatePassword
                                    CertificatePath       = $CertificatePath
                                    CertificateThumbprint = $CertificateThumbprint
                                    GlobalAdminAccount    = $GlobalAdminAccount
                                }

                                $Results = Get-TargetResource @Params
                                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                                    -Results $Results
                                $dscContent += Get-M365DSCExportContentForResource -ResourceName "SPOPropertyBag" `
                                    -ConnectionMode $ConnectionMode `
                                    -ModulePath $PSScriptRoot `
                                    -Results $Results `
                                    -GlobalAdminAccount $GlobalAdminAccount
                            }
                        }
                        catch
                        {
                            throw "M365DSC - Failed to Get-PnPPropertyBag {$siteUrl}: " + $_
                        }
                    }
                }
                return $dscContent
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
            $organization = $TenantId
            $principal = $organization.Split(".")[0]
        }

        if ($result.ToLower().Contains($organization.ToLower()) -or `
                $result.ToLower().Contains($principal.ToLower()))
        {
            $result = $result -ireplace [regex]::Escape('https://' + $principal + '.sharepoint.com/'), "https://`$(`$OrganizationName.Split('.')[0]).sharepoint.com/"
            $result = $result -ireplace [regex]::Escape("@" + $organization), "@`$(`$OrganizationName)"
        }
        return $result
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
