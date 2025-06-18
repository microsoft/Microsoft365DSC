function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Boolean]
        $PasswordRequiredToUnlockFromIdle,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault', 'Alphanumeric', 'Numeric')]
        $PasswordRequiredType,

        [Parameter()]
        [System.Boolean]
        $RequireHealthyDeviceReport,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMinimumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $EarlyLaunchAntiMalwareDriverEnabled,

        [Parameter()]
        [System.Boolean]
        $BitLockerEnabled,

        [Parameter()]
        [System.Boolean]
        $SecureBootEnabled,

        [Parameter()]
        [System.Boolean]
        $CodeIntegrityEnabled,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $ActiveFirewallRequired,

        [Parameter()]
        [System.Boolean]
        $DefenderEnabled,

        [Parameter()]
        [System.String]
        $DefenderVersion,

        [Parameter()]
        [System.Boolean]
        $SignatureOutOfDate,

        [Parameter()]
        [System.Boolean]
        $RtpEnabled,

        [Parameter()]
        [System.Boolean]
        $AntivirusRequired,

        [Parameter()]
        [System.Boolean]
        $AntiSpywareRequired,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ConfigurationManagerComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $TpmRequired,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceCompliancePolicyScript,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ValidOperatingSystemBuildRanges,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ScheduledActionsForRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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

    Write-Verbose -Message "Getting configuration of the Intune Device Compliance Windows 10 Policy {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $devicePolicy = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
                -All `
                -Filter "DisplayName eq '$($DisplayName -replace "'", "''")' and isof('microsoft.graph.windows10CompliancePolicy')" `
                -ExpandProperty 'scheduledActionsForRule($expand=scheduledActionConfigurations)' `
                -ErrorAction SilentlyContinue
            if (([array]$devicePolicy).Count -gt 1)
            {
                throw "A policy with a duplicated displayName {'$DisplayName'} was found - Ensure displayName is unique"
            }
            if ($null -eq $devicePolicy)
            {
                Write-Verbose -Message "No Windows 10 Device Compliance Policy with displayName {$DisplayName} was found"
                return $nullResult
            }
        }
        else
        {
            $devicePolicy = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
                -DeviceCompliancePolicyId $Script:exportedInstance.Id `
                -ExpandProperty 'scheduledActionsForRule($expand=scheduledActionConfigurations)' `
                -ErrorAction SilentlyContinue
        }

        $complexValidOperatingSystemBuildRanges = @()
        foreach ($currentValidOperatingSystemBuildRanges in $devicePolicy.AdditionalProperties.validOperatingSystemBuildRanges)
        {
            $myValidOperatingSystemBuildRanges = @{}
            if ($null -ne $currentValidOperatingSystemBuildRanges.lowestVersion)
            {
                $myValidOperatingSystemBuildRanges.Add('LowestVersion', $currentValidOperatingSystemBuildRanges.lowestVersion.ToString())
            }
            if ($null -ne $currentValidOperatingSystemBuildRanges.highestVersion)
            {
                $myValidOperatingSystemBuildRanges.Add('HighestVersion', $currentValidOperatingSystemBuildRanges.highestVersion.ToString())
            }
            if ($null -ne $currentValidOperatingSystemBuildRanges.description)
            {
                $myValidOperatingSystemBuildRanges.Add('Description', $currentValidOperatingSystemBuildRanges.description)
            }
            if ($myValidOperatingSystemBuildRanges.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexValidOperatingSystemBuildRanges += $myValidOperatingSystemBuildRanges
            }
        }

        $complexDeviceCompliancePolicyScript = @{}
        if ($null -ne $devicePolicy.AdditionalProperties.deviceCompliancePolicyScript)
        {
            Write-Verbose -Message "Resolving Device Compliance Policy Script with Id {$($devicePolicy.AdditionalProperties.deviceCompliancePolicyScript.deviceComplianceScriptId)}"
            $policyScript = Invoke-MgGraphRequest -Uri "/beta/deviceManagement/deviceComplianceScripts/$($devicePolicy.AdditionalProperties.deviceCompliancePolicyScript.deviceComplianceScriptId)" -Method GET
            $complexDeviceCompliancePolicyScript.Add('DisplayName', $policyScript.displayName)
            $complexDeviceCompliancePolicyScript.Add('RulesContent', [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($devicePolicy.AdditionalProperties.deviceCompliancePolicyScript.rulesContent)))
        }
        if ($complexDeviceCompliancePolicyScript.Keys.Count -eq 0)
        {
            $complexDeviceCompliancePolicyScript = $null
        }

        $complexScheduledActionsForRule = @()
        foreach ($actionConfiguration in $devicePolicy.ScheduledActionsForRule.ScheduledActionConfigurations)
        {
            $scheduledAction = @{
                ActionType    = [string]$actionConfiguration.ActionType
                GracePeriodHours = $actionConfiguration.GracePeriodHours
            }
            if ($null -ne $actionConfiguration.NotificationMessageCCList -and `
                $actionConfiguration.NotificationMessageCCList.Count -gt 0)
            {
                $groups = @()
                foreach ($group in $actionConfiguration.NotificationMessageCCList)
                {
                    $groups += Get-MgGroup -GroupId $group -ErrorAction SilentlyContinue | Select-Object -ExpandProperty DisplayName
                }
                $scheduledAction.Add('NotificationMessageCCList', $groups)
            }
            if ($null -ne $actionConfiguration.NotificationTemplateId -and `
                $actionConfiguration.NotificationTemplateId -ne '00000000-0000-0000-0000-000000000000')
            {
                $notificationTemplate = Get-MgBetaDeviceManagementNotificationMessageTemplate `
                    -NotificationMessageTemplateId $actionConfiguration.NotificationTemplateId `
                    -ErrorAction SilentlyContinue
                $scheduledAction.Add('NotificationTemplate', $notificationTemplate.DisplayName)
            }
            $complexScheduledActionsForRule += $scheduledAction
        }

        Write-Verbose -Message "Found Windows 10 Device Compliance Policy with displayName {$DisplayName}"
        $results = @{
            Id                                          = $devicePolicy.Id
            DisplayName                                 = $devicePolicy.DisplayName
            Description                                 = $devicePolicy.Description
            RoleScopeTagIds                             = $devicePolicy.RoleScopeTagIds
            PasswordRequired                            = $devicePolicy.AdditionalProperties.passwordRequired
            PasswordBlockSimple                         = $devicePolicy.AdditionalProperties.passwordBlockSimple
            PasswordRequiredToUnlockFromIdle            = $devicePolicy.AdditionalProperties.passwordRequiredToUnlockFromIdle
            PasswordMinutesOfInactivityBeforeLock       = $devicePolicy.AdditionalProperties.passwordMinutesOfInactivityBeforeLock
            PasswordExpirationDays                      = $devicePolicy.AdditionalProperties.passwordExpirationDays
            PasswordMinimumLength                       = $devicePolicy.AdditionalProperties.passwordMinimumLength
            PasswordMinimumCharacterSetCount            = $devicePolicy.AdditionalProperties.passwordMinimumCharacterSetCount
            PasswordRequiredType                        = $devicePolicy.AdditionalProperties.passwordRequiredType
            PasswordPreviousPasswordBlockCount          = $devicePolicy.AdditionalProperties.passwordPreviousPasswordBlockCount
            RequireHealthyDeviceReport                  = $devicePolicy.AdditionalProperties.requireHealthyDeviceReport
            OsMinimumVersion                            = $devicePolicy.AdditionalProperties.osMinimumVersion
            OsMaximumVersion                            = $devicePolicy.AdditionalProperties.osMaximumVersion
            MobileOsMinimumVersion                      = $devicePolicy.AdditionalProperties.mobileOsMinimumVersion
            MobileOsMaximumVersion                      = $devicePolicy.AdditionalProperties.mobileOsMaximumVersion
            EarlyLaunchAntiMalwareDriverEnabled         = $devicePolicy.AdditionalProperties.earlyLaunchAntiMalwareDriverEnabled
            BitLockerEnabled                            = $devicePolicy.AdditionalProperties.bitLockerEnabled
            SecureBootEnabled                           = $devicePolicy.AdditionalProperties.secureBootEnabled
            CodeIntegrityEnabled                        = $devicePolicy.AdditionalProperties.codeIntegrityEnabled
            StorageRequireEncryption                    = $devicePolicy.AdditionalProperties.storageRequireEncryption
            ActiveFirewallRequired                      = $devicePolicy.AdditionalProperties.activeFirewallRequired
            DefenderEnabled                             = $devicePolicy.AdditionalProperties.defenderEnabled
            DefenderVersion                             = $devicePolicy.AdditionalProperties.defenderVersion
            SignatureOutOfDate                          = $devicePolicy.AdditionalProperties.signatureOutOfDate
            RTPEnabled                                  = $devicePolicy.AdditionalProperties.rtpEnabled
            AntivirusRequired                           = $devicePolicy.AdditionalProperties.antivirusRequired
            AntiSpywareRequired                         = $devicePolicy.AdditionalProperties.antiSpywareRequired
            DeviceThreatProtectionEnabled               = $devicePolicy.AdditionalProperties.deviceThreatProtectionEnabled
            DeviceThreatProtectionRequiredSecurityLevel = $devicePolicy.AdditionalProperties.deviceThreatProtectionRequiredSecurityLevel
            ConfigurationManagerComplianceRequired      = $devicePolicy.AdditionalProperties.configurationManagerComplianceRequired
            TpmRequired                                 = $devicePolicy.AdditionalProperties.tpmRequired
            ScheduledActionsForRule                     = $complexScheduledActionsForRule
            DeviceCompliancePolicyScript                = $complexDeviceCompliancePolicyScript
            ValidOperatingSystemBuildRanges             = $complexValidOperatingSystemBuildRanges
            Ensure                                      = 'Present'
            Credential                                  = $Credential
            ApplicationId                               = $ApplicationId
            TenantId                                    = $TenantId
            ApplicationSecret                           = $ApplicationSecret
            CertificateThumbprint                       = $CertificateThumbprint
            Managedidentity                             = $ManagedIdentity.IsPresent
            AccessTokens                                = $AccessTokens
        }

        $returnAssignments = @()
        $graphAssignments = Get-MgBetaDeviceManagementDeviceCompliancePolicyAssignment -DeviceCompliancePolicyId $devicePolicy.Id
        if ($graphAssignments.Count -gt 0)
        {
            $returnAssignments += ConvertFrom-IntunePolicyAssignment `
                -IncludeDeviceFilter:$true `
                -Assignments ($graphAssignments)
        }
        $results.Add('Assignments', $returnAssignments)

        return [System.Collections.Hashtable] $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Boolean]
        $PasswordRequiredToUnlockFromIdle,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault', 'Alphanumeric', 'Numeric')]
        $PasswordRequiredType,

        [Parameter()]
        [System.Boolean]
        $RequireHealthyDeviceReport,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMinimumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $EarlyLaunchAntiMalwareDriverEnabled,

        [Parameter()]
        [System.Boolean]
        $BitLockerEnabled,

        [Parameter()]
        [System.Boolean]
        $SecureBootEnabled,

        [Parameter()]
        [System.Boolean]
        $CodeIntegrityEnabled,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $ActiveFirewallRequired,

        [Parameter()]
        [System.Boolean]
        $DefenderEnabled,

        [Parameter()]
        [System.String]
        $DefenderVersion,

        [Parameter()]
        [System.Boolean]
        $SignatureOutOfDate,

        [Parameter()]
        [System.Boolean]
        $RtpEnabled,

        [Parameter()]
        [System.Boolean]
        $AntivirusRequired,

        [Parameter()]
        [System.Boolean]
        $AntiSpywareRequired,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ConfigurationManagerComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $TpmRequired,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceCompliancePolicyScript,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ValidOperatingSystemBuildRanges,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ScheduledActionsForRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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

    Write-Verbose -Message "Intune Device Compliance Windows 10 Policy {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentDeviceWindows10Policy = Get-TargetResource @PSBoundParameters
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($null -ne $BoundParameters.DeviceCompliancePolicyScript)
    {
        $script = $BoundParameters.DeviceCompliancePolicyScript
        $scriptName = $script.Displayname
        $scriptRulesContent = $script.RulesContent

        $complianceScript = (Invoke-MgGraphRequest -Uri "/beta/deviceManagement/deviceComplianceScripts?`$filter=DisplayName eq '$($scriptName -replace "'", "''")'" -Method GET).value
        if ($complianceScript.Count -eq 0)
        {
            throw "The referenced Intune Device Compliance Script with DisplayName {$scriptName} was not found"
        }

        $script = @{
            deviceComplianceScriptId = $complianceScript.id
            rulesContent             = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($scriptRulesContent))
        }
        $BoundParameters.Remove('DeviceCompliancePolicyScript') | Out-Null
        $BoundParameters.Add('DeviceCompliancePolicyScript', $script)
    }

    $notificationTemplates = Get-MgBetaDeviceManagementNotificationMessageTemplate -All | Where-Object -FilterScript {
        $_.Id -ne '8ca486fc-bee8-4ef2-983b-21e8908d11b8' # Exclude the second, unused default template
    }
    $complexScheduledActionsForRule = @(
        @{
            ruleName      = "PasswordRequired"
            scheduledActionConfigurations = @()
        }
    )
    foreach ($scheduledAction in $BoundParameters.ScheduledActionsForRule)
    {
        $actionConfiguration = @{
            actionType = $scheduledAction.ActionType
            gracePeriodHours = $scheduledAction.GracePeriodHours
        }

        $ccList = @()
        if ($null -ne $scheduledAction.NotificationMessageCCList)
        {
            foreach ($group in $scheduledAction.NotificationMessageCCList)
            {
                $groupObject = Get-MgGroup -Filter "displayName eq '$group'" -ErrorAction SilentlyContinue
                if ($null -eq $groupObject)
                {
                    throw "The referenced Intune Group with DisplayName {$group} was not found for NotificationMessageCCList"
                }
                $ccList += $groupObject.Id
            }
        }
        $actionConfiguration.notificationMessageCCList = $ccList

        $template = [System.Guid]::Empty
        if (-not [string]::IsNullOrEmpty($scheduledAction.NotificationTemplate))
        {
            $template = $notificationTemplates | Where-Object -FilterScript { $_.DisplayName -eq $scheduledAction.NotificationTemplate }
            if ($null -eq $template)
            {
                throw "The referenced Intune Notification Template with DisplayName {$($scheduledAction.NotificationTemplate)} was not found"
            }
            $template = $template.Id
        }
        $actionConfiguration.notificationTemplateId = [string]$template
        $complexScheduledActionsForRule[0].scheduledActionConfigurations += $actionConfiguration
    }
    $BoundParameters.Remove('ScheduledActionsForRule') | Out-Null

    if ($Ensure -eq 'Present' -and $currentDeviceWindows10Policy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Intune Device Compliance Windows 10 Policy {$DisplayName}"
        $BoundParameters.Remove('DisplayName') | Out-Null
        $BoundParameters.Remove('Description') | Out-Null
        $BoundParameters.Remove('Assignments') | Out-Null

        $AdditionalProperties = Get-M365DSCIntuneDeviceCompliancePolicyWindows10AdditionalProperties -Properties ([System.Collections.Hashtable]$BoundParameters)
        $policy = New-MgBetaDeviceManagementDeviceCompliancePolicy -DisplayName $DisplayName `
            -Description $Description `
            -AdditionalProperties $AdditionalProperties `
            -ScheduledActionsForRule $complexScheduledActionsForRule

        if ($Assignments.Count -gt 0)
        {
            $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceCompliancePolicies'
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentDeviceWindows10Policy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Intune Device Compliance Windows 10 Policy {$DisplayName}"
        $BoundParameters.Remove('DisplayName') | Out-Null
        $BoundParameters.Remove('Description') | Out-Null
        $BoundParameters.Remove('Assignments') | Out-Null

        $AdditionalProperties = Get-M365DSCIntuneDeviceCompliancePolicyWindows10AdditionalProperties -Properties ([System.Collections.Hashtable]$BoundParameters)
        Update-MgBetaDeviceManagementDeviceCompliancePolicy -AdditionalProperties $AdditionalProperties `
            -Description $Description `
            -DeviceCompliancePolicyId $currentDeviceWindows10Policy.Id

        $body = @{
            deviceComplianceScheduledActionForRules = $complexScheduledActionsForRule
        } | ConvertTo-Json -Depth 10
        Invoke-MgGraphRequest -Method POST -Uri "beta/deviceManagement/deviceCompliancePolicies/$($currentDeviceWindows10Policy.Id)/scheduleActionsForRules" -Body $body

        if ($Assignments.Count -gt 0)
        {
            $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $currentDeviceWindows10Policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceCompliancePolicies'
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentDeviceWindows10Policy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Intune Device Compliance Windows 10 Policy {$DisplayName}"
        Remove-MgBetaDeviceManagementDeviceCompliancePolicy -DeviceCompliancePolicyId $currentDeviceWindows10Policy.Id
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Boolean]
        $PasswordRequiredToUnlockFromIdle,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault', 'Alphanumeric', 'Numeric')]
        $PasswordRequiredType,

        [Parameter()]
        [System.Boolean]
        $RequireHealthyDeviceReport,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMinimumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $EarlyLaunchAntiMalwareDriverEnabled,

        [Parameter()]
        [System.Boolean]
        $BitLockerEnabled,

        [Parameter()]
        [System.Boolean]
        $SecureBootEnabled,

        [Parameter()]
        [System.Boolean]
        $CodeIntegrityEnabled,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $ActiveFirewallRequired,

        [Parameter()]
        [System.Boolean]
        $DefenderEnabled,

        [Parameter()]
        [System.String]
        $DefenderVersion,

        [Parameter()]
        [System.Boolean]
        $SignatureOutOfDate,

        [Parameter()]
        [System.Boolean]
        $RtpEnabled,

        [Parameter()]
        [System.Boolean]
        $AntivirusRequired,

        [Parameter()]
        [System.Boolean]
        $AntiSpywareRequired,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ConfigurationManagerComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $TpmRequired,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceCompliancePolicyScript,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ValidOperatingSystemBuildRanges,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ScheduledActionsForRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Intune Device Compliance Windows 10 Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($null -ne $source -and $source.GetType().Name -like '*CimInstance*')
        {
            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-not $testResult)
            {
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    if ($testResult)
    {
        $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }
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
        [System.String]
        $Filter,

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
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        if (-not [string]::IsNullOrEmpty($Filter))
        {
            $complexFunctions = Get-ComplexFunctionsFromFilterQuery -FilterQuery $Filter
            $Filter = Remove-ComplexFunctionsFromFilterQuery -FilterQuery $Filter
        }
        [array]$configDeviceWindowsPolicies = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop -All:$true -Filter $Filter | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10CompliancePolicy' }
        $configDeviceWindowsPolicies = Find-GraphDataUsingComplexFunctions -ComplexFunctions $complexFunctions -Policies $configDeviceWindowsPolicies

        $i = 1
        $dscContent = ''
        if ($configDeviceWindowsPolicies.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }

        foreach ($configDeviceWindowsPolicy in $configDeviceWindowsPolicies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($configDeviceWindowsPolicies.Count)] $($configDeviceWindowsPolicy.displayName)" -DeferWrite
            $params = @{
                DisplayName           = $configDeviceWindowsPolicy.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $configDeviceWindowsPolicy
            $Results = Get-TargetResource @params

            if ($null -ne $Results.ValidOperatingSystemBuildRanges)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ValidOperatingSystemBuildRanges `
                    -CIMInstanceName 'MicrosoftGraphOperatingSystemVersionRange' `
                    -IsArray
                if (-not [string]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ValidOperatingSystemBuildRanges = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ValidOperatingSystemBuildRanges') | Out-Null
                }
            }
            if ($null -ne $Results.DeviceCompliancePolicyScript)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.DeviceCompliancePolicyScript `
                    -CIMInstanceName 'MicrosoftGraphDeviceCompliancePolicyScript'
                if (-not [string]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.DeviceCompliancePolicyScript = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('DeviceCompliancePolicyScript') | Out-Null
                }
            }
            if ($null -ne $Results.ScheduledActionsForRule)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ScheduledActionsForRule `
                    -CIMInstanceName 'MicrosoftGraphDeviceComplianceScheduledActionsForRuleConfiguration' `
                    -IsArray
                if (-not [string]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ScheduledActionsForRule = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ScheduledActionsForRule') | Out-Null
                }
            }
            if ($null -ne $Results.Assignments)
            {
                $complexMapping = @(
                    @{
                        Name            = 'Assignments'
                        CimInstanceName = 'MSFT_DeviceManagementConfigurationPolicyAssignments'
                            sRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Assignments `
                    -CIMInstanceName 'MSFT_DeviceManagementConfigurationPolicyAssignments' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Assignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Assignments') | Out-Null
                }
            }
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('ValidOperatingSystemBuildRanges', 'DeviceCompliancePolicyScript', 'ScheduledActionsForRule', 'Assignments')

            $dscContent += $currentDSCBlock

            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
                $_.Exception -like '*Request not applicable to target tenant*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }

        return ''
    }
}

function Get-M365DSCIntuneDeviceCompliancePolicyWindows10AdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{ '@odata.type' = '#microsoft.graph.windows10CompliancePolicy' }
    foreach ($property in $properties.Keys)
    {
        if ($property -ne 'Verbose')
        {
            $propertyName = $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            $propertyValue = $properties.$property
            if ($null -ne $propertyValue -and $propertyValue.GetType().Name -like '*cimInstance*')
            {
                $propertyValue = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $propertyValue
            }
            $results.Add($propertyName, $propertyValue)
        }
    }
    Write-Verbose -Message ($results | Out-String)
    return $results
}

Export-ModuleMember -Function *-TargetResource
