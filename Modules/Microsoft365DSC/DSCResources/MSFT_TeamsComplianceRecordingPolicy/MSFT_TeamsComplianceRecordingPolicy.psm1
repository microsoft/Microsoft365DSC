Confirm-M365DSCModuleDependency -ModuleName 'MSFT_TeamsComplianceRecordingPolicy'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ComplianceRecordingApplications,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $DisableComplianceRecordingAudioNotificationForCalls,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Boolean]
        $RecordReroutedCalls,

        [Parameter()]
        [System.Boolean]
        $WarnUserOnRemoval,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration for TeamsComplianceRecordingPolicy $Identity"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftTeams' `
                -InboundParameters $PSBoundParameters

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $instance = Get-CsTeamsComplianceRecordingPolicy -Identity $Identity -ErrorAction SilentlyContinue
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        if ($null -eq $instance)
        {
            return $nullResult
        }

        $ComplexComplianceRecordingApplications = @()
        if ($instance.ComplianceRecordingApplications.Count -gt 0)
        {
            foreach ($CurrentComplianceRecordingApplications in $instance.ComplianceRecordingApplications)
            {
                $MyComplianceRecordingApplications = [ordered]@{}
                $ComplianceRecordingPairedApplications = @()
                if ($CurrentComplianceRecordingApplications.ComplianceRecordingPairedApplications.Count -gt 0)
                {
                    foreach ($CurrentComplianceRecordingPairedApplications in $CurrentComplianceRecordingApplications.ComplianceRecordingPairedApplications)
                    {
                        $ComplianceRecordingPairedApplications += $CurrentComplianceRecordingApplications.ComplianceRecordingPairedApplications.Id
                    }
                }
                $MyComplianceRecordingApplications.Add('ComplianceRecordingPairedApplications', $ComplianceRecordingPairedApplications)
                $MyComplianceRecordingApplications.Add('Id', $CurrentComplianceRecordingApplications.Id)
                $MyComplianceRecordingApplications.Add('RequiredBeforeMeetingJoin', $CurrentComplianceRecordingApplications.RequiredBeforeMeetingJoin)
                $MyComplianceRecordingApplications.Add('RequiredBeforeCallEstablishment', $CurrentComplianceRecordingApplications.RequiredBeforeCallEstablishment)
                $MyComplianceRecordingApplications.Add('RequiredDuringMeeting', $CurrentComplianceRecordingApplications.RequiredDuringMeeting)
                $MyComplianceRecordingApplications.Add('RequiredDuringCall', $CurrentComplianceRecordingApplications.RequiredDuringCall)
                $MyComplianceRecordingApplications.Add('ConcurrentInvitationCount', $CurrentComplianceRecordingApplications.ConcurrentInvitationCount)

                if ($MyComplianceRecordingApplications.values.Where({ $null -ne $_ }).Count -gt 0)
                {
                    $ComplexComplianceRecordingApplications += $MyComplianceRecordingApplications
                }
            }
        }

        Write-Verbose -Message "Found an instance with Identity {$Identity}"
        $results = @{
            Identity                                            = $instance.Identity
            ComplianceRecordingApplications                     = $ComplexComplianceRecordingApplications
            Description                                         = $instance.Description
            DisableComplianceRecordingAudioNotificationForCalls = $instance.DisableComplianceRecordingAudioNotificationForCalls
            Enabled                                             = $instance.Enabled
            RecordReroutedCalls                                 = $instance.RecordReroutedCalls
            WarnUserOnRemoval                                   = $instance.WarnUserOnRemoval
            Ensure                                              = 'Present'
            Credential                                          = $Credential
            ApplicationId                                       = $ApplicationId
            TenantId                                            = $TenantId
            CertificateThumbprint                               = $CertificateThumbprint
            ManagedIdentity                                     = $ManagedIdentity.IsPresent
            AccessTokens                                        = $AccessTokens
        }
        return $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ComplianceRecordingApplications,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $DisableComplianceRecordingAudioNotificationForCalls,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Boolean]
        $RecordReroutedCalls,

        [Parameter()]
        [System.Boolean]
        $WarnUserOnRemoval,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $CreateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

        $keys = $CreateParameters.Keys
        foreach ($key in $keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.GetType().Name -like '*cimInstance*')
            {
                $keyName = $key.Substring(0, 1).ToLower() + $key.Substring(1, $key.Length - 1)
                $keyValue = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
                $CreateParameters.Remove($key) | Out-Null
                $CreateParameters.Add($keyName, $keyValue)
            }
        }

        # Before calling Set-CsTeamsComplianceRecordingPolicy, convert IDs (strings) to ComplianceRecordingApplication objects
        if ($CreateParameters.ContainsKey('ComplianceRecordingApplications') -and `
                $null -ne $CreateParameters.ComplianceRecordingApplications)
        {
            # Fetch ComplianceRecordingApplication objects based on provided IDs
            $appObjects = @()
            foreach ($appId in $CreateParameters.ComplianceRecordingApplications)
            {
                $appObj = Get-CsTeamsComplianceRecordingApplication -Identity $appId -ErrorAction Stop
                if ($null -ne $appObj)
                {
                    $appObjects += $appObj
                }
                else
                {
                    throw "Compliance Recording Application with ID '$appId' not found."
                }
            }
            # Replace string IDs with actual application objects
            $CreateParameters['ComplianceRecordingApplications'] = $appObjects
        }

        Write-Verbose -Message "Creating a Teams Compliance Recording Policy with Identity {$Identity}"
        New-CsTeamsComplianceRecordingPolicy @CreateParameters | Out-Null

        if ($ComplianceRecordingApplications.Count -gt 0)
        {
            foreach ($CurrentComplianceRecordingApplications in $ComplianceRecordingApplications)
            {
                $Instance = $CurrentComplianceRecordingApplications.Id
                $RequiredBeforeMeetingJoin = $CurrentComplianceRecordingApplications.RequiredBeforeMeetingJoin
                $RequiredBeforeCallEstablishment = $CurrentComplianceRecordingApplications.RequiredBeforeCallEstablishment
                $RequiredDuringMeeting = $CurrentComplianceRecordingApplications.RequiredDuringMeeting
                $RequiredDuringCall = $CurrentComplianceRecordingApplications.RequiredDuringCall
                $ConcurrentInvitationCount = $CurrentComplianceRecordingApplications.ConcurrentInvitationCount

                $CsTeamsComplianceRecordingApplication = Get-CsTeamsComplianceRecordingApplication -Identity $CsTeamsComplianceRecordingApplicationIdentity -ErrorAction SilentlyContinue
                if ($null -eq $CsTeamsComplianceRecordingApplication)
                {
                    New-CsTeamsComplianceRecordingApplication `
                        -RequiredBeforeMeetingJoin $RequiredBeforeMeetingJoin `
                        -RequiredBeforeCallEstablishment $RequiredBeforeCallEstablishment `
                        -RequiredDuringMeeting $RequiredDuringMeeting `
                        -RequiredDuringCall $RequiredDuringCall `
                        -ConcurrentInvitationCount $ConcurrentInvitationCount `
                        -Parent $Identity -Id $Instance
                }
                else
                {
                    Set-CsTeamsComplianceRecordingApplication `
                        -Identity $CsTeamsComplianceRecordingApplicationIdentity `
                        -RequiredBeforeMeetingJoin $RequiredBeforeMeetingJoin `
                        -RequiredBeforeCallEstablishment $RequiredBeforeCallEstablishment `
                        -RequiredDuringMeeting $RequiredDuringMeeting `
                        -RequiredDuringCall $RequiredDuringCall `
                        -ConcurrentInvitationCount $ConcurrentInvitationCount
                }

                if ($CurrentComplianceRecordingApplications.ComplianceRecordingPairedApplications.Count -gt 0)
                {
                    Set-CsTeamsComplianceRecordingApplication `
                        -Identity "$Identity + '/' + $Instance" `
                        -ComplianceRecordingPairedApplications @(New-CsTeamsComplianceRecordingPairedApplication `
                            -Id $CurrentComplianceRecordingApplications.ComplianceRecordingPairedApplications)
                }
            }
            $NewCsTeamsComplianceRecordingApplication = Get-CsTeamsComplianceRecordingApplication | Where-Object { $_.Identity -match $Identity }
            Set-CsTeamsComplianceRecordingPolicy -Identity $Identity -ComplianceRecordingApplications $NewCsTeamsComplianceRecordingApplication
        }

    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Teams Compliance Recording Policy with Identity {$Identity}"
        $UpdateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

        $keys = $UpdateParameters.Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.GetType().Name -like '*cimInstance*')
            {
                $keyValue = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
                $UpdateParameters.Remove($key) | Out-Null
                $UpdateParameters.Add($keyName, $keyValue)
            }
        }

        # Before calling Set-CsTeamsComplianceRecordingPolicy, convert IDs (strings) to ComplianceRecordingApplication objects
        if ($UpdateParameters.ContainsKey('ComplianceRecordingApplications') -and `
                $null -ne $UpdateParameters.ComplianceRecordingApplications)
        {
            # Fetch ComplianceRecordingApplication objects based on provided IDs
            $appObjects = @()
            foreach ($appId in $UpdateParameters.ComplianceRecordingApplications)
            {
                $appObj = Get-CsTeamsComplianceRecordingApplication -Identity $appId -ErrorAction Stop
                if ($null -ne $appObj)
                {
                    $appObjects += $appObj
                }
                else
                {
                    throw "Compliance Recording Application with ID '$appId' not found."
                }
            }
            # Replace string IDs with actual application objects
            $UpdateParameters['ComplianceRecordingApplications'] = $appObjects
        }

        # Now call the cmdlet with corrected parameters
        Set-CsTeamsComplianceRecordingPolicy @UpdateParameters | Out-Null
        if ($ComplianceRecordingApplications.Count -gt 0)
        {
            foreach ($CurrentComplianceRecordingApplications in $ComplianceRecordingApplications)
            {
                $Instance = $CurrentComplianceRecordingApplications.Id
                $RequiredBeforeMeetingJoin = $CurrentComplianceRecordingApplications.RequiredBeforeMeetingJoin
                $RequiredBeforeCallEstablishment = $CurrentComplianceRecordingApplications.RequiredBeforeCallEstablishment
                $RequiredDuringMeeting = $CurrentComplianceRecordingApplications.RequiredDuringMeeting
                $RequiredDuringCall = $CurrentComplianceRecordingApplications.RequiredDuringCall
                $ConcurrentInvitationCount = $CurrentComplianceRecordingApplications.ConcurrentInvitationCount

                $CsTeamsComplianceRecordingApplicationIdentity = $Identity + '/' + $Instance

                $CsTeamsComplianceRecordingApplication = Get-CsTeamsComplianceRecordingApplication -Identity $CsTeamsComplianceRecordingApplicationIdentity -ErrorAction SilentlyContinue
                if ($null -eq $CsTeamsComplianceRecordingApplication)
                {
                    New-CsTeamsComplianceRecordingApplication `
                        -RequiredBeforeMeetingJoin $RequiredBeforeMeetingJoin `
                        -RequiredBeforeCallEstablishment $RequiredBeforeCallEstablishment `
                        -RequiredDuringMeeting $RequiredDuringMeeting `
                        -RequiredDuringCall $RequiredDuringCall `
                        -ConcurrentInvitationCount $ConcurrentInvitationCount `
                        -Parent $Identity -Id $Instance
                }
                else
                {
                    Set-CsTeamsComplianceRecordingApplication `
                        -Identity $CsTeamsComplianceRecordingApplicationIdentity `
                        -RequiredBeforeMeetingJoin $RequiredBeforeMeetingJoin `
                        -RequiredBeforeCallEstablishment $RequiredBeforeCallEstablishment `
                        -RequiredDuringMeeting $RequiredDuringMeeting `
                        -RequiredDuringCall $RequiredDuringCall `
                        -ConcurrentInvitationCount $ConcurrentInvitationCount
                }

                if ($CurrentComplianceRecordingApplications.ComplianceRecordingPairedApplications.Count -gt 0)
                {
                    [string]$CsTeamsComplianceRecordingApplicationIdentity = $Identity + '/' + $Instance
                    [string]$ComplianceRecordingPairedApplications = $CurrentComplianceRecordingApplications.ComplianceRecordingPairedApplications
                    Set-CsTeamsComplianceRecordingApplication -Identity $CsTeamsComplianceRecordingApplicationIdentity -ComplianceRecordingPairedApplications @(New-CsTeamsComplianceRecordingPairedApplication -Id $ComplianceRecordingPairedApplications)
                }
            }
            $NewCsTeamsComplianceRecordingApplication = Get-CsTeamsComplianceRecordingApplication | Where-Object { $_.Identity -match $Identity }
            Set-CsTeamsComplianceRecordingPolicy -Identity $Identity -ComplianceRecordingApplications $NewCsTeamsComplianceRecordingApplication
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Teams Compliance Recording Policy with Identity {$Identity}"
        Remove-CsTeamsComplianceRecordingPolicy -Identity $currentInstance.Identity
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
        $Identity,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ComplianceRecordingApplications,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $DisableComplianceRecordingAudioNotificationForCalls,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Boolean]
        $RecordReroutedCalls,

        [Parameter()]
        [System.Boolean]
        $WarnUserOnRemoval,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $Filter = "*",

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$getValue = Get-CsTeamsComplianceRecordingPolicy -Filter $Filter -ErrorAction Stop

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Identity
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Identity              = $config.Identity
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

            if ($null -ne $Results.ComplianceRecordingApplications)
            {
                $complexMapping = @(
                    @{
                        Name            = 'ComplianceRecordingApplications'
                        CimInstanceName = 'TeamsComplianceRecordingApplication'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ComplianceRecordingApplications `
                    -CIMInstanceName 'TeamsComplianceRecordingApplication' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ComplianceRecordingApplications = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ComplianceRecordingApplications') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('ComplianceRecordingApplications')
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent.ToString()
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
