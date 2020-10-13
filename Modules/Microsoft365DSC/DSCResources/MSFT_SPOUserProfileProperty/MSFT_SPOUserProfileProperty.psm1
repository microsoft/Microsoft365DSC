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
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting SPO Profile Properties for user {$UserName}"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    try
    {
        $currentProperties = Get-PnPUserProfileProperty -Account $UserName -ErrorAction Stop

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
            UserName              = $UserName
            Properties            = $propertiesValue
            GlobalAdminAccount    = $GlobalAdminAccount
            Ensure                = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }

        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"

        return $result
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
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting Profile Properties for user {$UserName}"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters

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
        $CertificateThumbprint
    )

    Write-Verbose -Message "Testing configuration for SPO Sharing settings"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState  -DesiredValues $PSBoundParameters `
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

    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' `
        -InboundParameters $PSBoundParameters
    $result = ""

    try
    {
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
                    $CertificateThumbprint
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
                    $dscContent = ""
                    foreach ($instance in $params.Instances)
                    {
                        foreach ($user in $instance)
                        {
                            $Params = @{
                                UserName              = $user.UserPrincipalName
                                ApplicationId         = $ApplicationId
                                TenantId              = $TenantId
                                CertificateThumbprint = $CertificateThumbprint
                                GlobalAdminAccount    = $GlobalAdminAccount
                            }
                            $CurrentModulePath = $params.ScriptRoot + "\MSFT_SPOUserProfileProperty.psm1"
                            Import-Module $CurrentModulePath -Force | Out-Null

                            $Results = Get-TargetResource @Params

                            if ($result.Ensure -eq "Present")
                            {
                                Import-Module ($params.ScriptRoot + "\..\..\Modules\M365DSCUtil.psm1") -Force | Out-Null
                                Import-Module ($params.ScriptRoot + "\..\..\Modules\M365DSCTelemetryEngine.psm1") -Force | Out-Null

                                $Results.Properties = ConvertTo-SPOUserProfilePropertyInstanceString -Properties $result.Properties
                                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                                    -Results $Results
                                $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                                    -ConnectionMode $ConnectionMode `
                                    -ModulePath $PSScriptRoot `
                                    -Results $Results `
                                    -GlobalAdminAccount $GlobalAdminAccount
                            }
                        }
                    }

                    return $dscContent
                }
                return $returnValue
            } -ArgumentList @($batch, $PSScriptRoot, $GlobalAdminAccount, $ApplicationId, $TenantId, $CertificateThumbprint) | Out-Null
            $i++
        }

        Write-Host "    Broke extraction process down into {$MaxProcesses} jobs of {$batchSize} item(s) each"
        $totalJobs = $MaxProcesses
        $jobsCompleted = 0
        $status = "Running..."
        $elapsedTime = 0
        do
        {
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
        $organization = Get-M365DSCOrganization -GlobalAdminAccount $GlobalAdminAccount -TenantId $Tenantid
        if ($organization.IndexOf(".") -gt 0)
        {
            $principal = $organization.Split(".")[0]
        }
        if ($result.ToLower().Contains($organization.ToLower()) -or `
                $result.ToLower().Contains($principal.ToLower()))
        {
            $result = $result -ireplace [regex]::Escape('https://' + $principal + '.sharepoint.com/'), "https://`$(`$OrganizationName.Split('.')[0]).sharepoint.com/"
            $result = $result -ireplace [regex]::Escape("@" + $organization), "@`$(`$OrganizationName)"
        }
        Write-Host $Global:M365DSCEmojiGreenCheckMark
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
