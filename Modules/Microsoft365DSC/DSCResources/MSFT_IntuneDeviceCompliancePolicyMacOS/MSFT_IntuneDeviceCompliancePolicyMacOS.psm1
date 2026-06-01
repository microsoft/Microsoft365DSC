Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneDeviceCompliancePolicyMacOS'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

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
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

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
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $OsMinimumBuildVersion,

        [Parameter()]
        [System.String]
        $OsMaximumBuildVersion,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ScheduledActionsForRule,

        [Parameter()]
        [System.Boolean]
        $SystemIntegrityProtectionEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $AdvancedThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.String]
        [ValidateSet('notConfigured', 'macAppStore', 'macAppStoreAndIdentifiedDevelopers', 'anywhere')]
        $GatekeeperAllowedAppSource,

        [Parameter()]
        [System.Boolean]
        $FirewallEnabled,

        [Parameter()]
        [System.Boolean]
        $FirewallBlockAllIncoming,

        [Parameter()]
        [System.Boolean]
        $FirewallEnableStealthMode,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Intune Device Compliance MacOS Policy {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $devicePolicy = Get-MgBetaDeviceManagementDeviceCompliancePolicy -DeviceCompliancePolicyId $Id -ErrorAction SilentlyContinue
            }

            if ($null -eq $devicePolicy)
            {
                $devicePolicy = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
                    -All `
                    -Filter "DisplayName eq '$($DisplayName -replace "'", "''")' and isof('microsoft.graph.macOSCompliancePolicy')" `
                    -ErrorAction Stop
            }

            if (([array]$devicePolicy).Count -gt 1)
            {
                throw "A policy with a duplicated displayName {'$DisplayName'} was found - Ensure displayName is unique"
            }
            if ($null -eq $devicePolicy)
            {
                Write-Verbose -Message "No MacOS Device Compliance Policy with displayName {$DisplayName} was found"
                return $nullResult
            }
        }
        else
        {
            $devicePolicy = $Script:exportedInstance
        }

        $complexScheduledActionsForRule = @()
        foreach ($actionConfiguration in $devicePolicy.ScheduledActionsForRule.ScheduledActionConfigurations)
        {
            $scheduledAction = [ordered]@{
                ActionType       = [string]$actionConfiguration.ActionType
                GracePeriodHours = $actionConfiguration.GracePeriodHours
            }
            if ($null -ne $actionConfiguration.NotificationMessageCCList -and `
                    $actionConfiguration.NotificationMessageCCList.Count -gt 0)
            {
                [System.String[]]$groups = @()
                foreach ($group in $actionConfiguration.NotificationMessageCCList)
                {
                    $groups += (Get-MgGroup -GroupId $group -ErrorAction SilentlyContinue).DisplayName
                }
                $scheduledAction.Add('NotificationMessageCCList', $groups)
            }
            if ($null -ne $actionConfiguration.NotificationTemplateId -and `
                    $actionConfiguration.NotificationTemplateId -ne '00000000-0000-0000-0000-000000000000')
            {
                $notificationTemplate = Get-MgBetaDeviceManagementNotificationMessageTemplate `
                    -NotificationMessageTemplateId $actionConfiguration.NotificationTemplateId `
                    -ErrorAction SilentlyContinue
                $scheduledAction.Add('NotificationTemplateId', $notificationTemplate.DisplayName)
            }
            $complexScheduledActionsForRule += $scheduledAction
        }

        Write-Verbose -Message "Found MacOS Device Compliance Policy with displayName {$DisplayName}"
        $results = @{
            DisplayName                                   = $devicePolicy.DisplayName
            Id                                            = $devicePolicy.Id
            Description                                   = $devicePolicy.Description
            RoleScopeTagIds                               = $devicePolicy.RoleScopeTagIds
            PasswordRequired                              = $devicePolicy.passwordRequired
            PasswordBlockSimple                           = $devicePolicy.passwordBlockSimple
            PasswordExpirationDays                        = $devicePolicy.passwordExpirationDays
            PasswordMinimumLength                         = $devicePolicy.passwordMinimumLength
            PasswordMinutesOfInactivityBeforeLock         = $devicePolicy.passwordMinutesOfInactivityBeforeLock
            PasswordPreviousPasswordBlockCount            = $devicePolicy.passwordPreviousPasswordBlockCount
            PasswordMinimumCharacterSetCount              = $devicePolicy.passwordMinimumCharacterSetCount
            PasswordRequiredType                          = $devicePolicy.passwordRequiredType
            OsMinimumVersion                              = $devicePolicy.osMinimumVersion
            OsMaximumVersion                              = $devicePolicy.osMaximumVersion
            OsMinimumBuildVersion                         = $devicePolicy.osMinimumBuildVersion
            OsMaximumBuildVersion                         = $devicePolicy.osMaximumBuildVersion
            ScheduledActionsForRule                       = $complexScheduledActionsForRule
            SystemIntegrityProtectionEnabled              = $devicePolicy.systemIntegrityProtectionEnabled
            DeviceThreatProtectionEnabled                 = $devicePolicy.deviceThreatProtectionEnabled
            DeviceThreatProtectionRequiredSecurityLevel   = $devicePolicy.deviceThreatProtectionRequiredSecurityLevel
            AdvancedThreatProtectionRequiredSecurityLevel = $devicePolicy.advancedThreatProtectionRequiredSecurityLevel
            StorageRequireEncryption                      = $devicePolicy.storageRequireEncryption
            GatekeeperAllowedAppSource                    = $devicePolicy.gatekeeperAllowedAppSource
            FirewallEnabled                               = $devicePolicy.firewallEnabled
            FirewallBlockAllIncoming                      = $devicePolicy.firewallBlockAllIncoming
            FirewallEnableStealthMode                     = $devicePolicy.firewallEnableStealthMode
            Ensure                                        = 'Present'
            Credential                                    = $Credential
            ApplicationId                                 = $ApplicationId
            TenantId                                      = $TenantId
            ApplicationSecret                             = $ApplicationSecret
            CertificateThumbprint                         = $CertificateThumbprint
            CertificatePath                               = $CertificatePath
            CertificatePassword                           = $CertificatePassword
            ManagedIdentity                               = $ManagedIdentity.IsPresent
            AccessTokens                                  = $AccessTokens
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

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
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

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
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $OsMinimumBuildVersion,

        [Parameter()]
        [System.String]
        $OsMaximumBuildVersion,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ScheduledActionsForRule,

        [Parameter()]
        [System.Boolean]
        $SystemIntegrityProtectionEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $AdvancedThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.String]
        [ValidateSet('notConfigured', 'macAppStore', 'macAppStoreAndIdentifiedDevelopers', 'anywhere')]
        $GatekeeperAllowedAppSource,

        [Parameter()]
        [System.Boolean]
        $FirewallEnabled,

        [Parameter()]
        [System.Boolean]
        $FirewallBlockAllIncoming,

        [Parameter()]
        [System.Boolean]
        $FirewallEnableStealthMode,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Intune Device Compliance MacOS Policy {$DisplayName}"

    $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

    $currentDeviceMacOsPolicy = Get-TargetResource @PSBoundParameters
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    $notificationTemplates = Get-MgBetaDeviceManagementNotificationMessageTemplate -All | Where-Object -FilterScript {
        $_.Id -ne '8ca486fc-bee8-4ef2-983b-21e8908d11b8' # Exclude the second, unused default template
    }
    $complexScheduledActionsForRule = @(
        @{
            ruleName                      = 'PasswordRequired'
            scheduledActionConfigurations = @()
        }
    )
    $baseScheduledActionConfiguration = @{
        ActionType       = 'block'
        GracePeriodHours = 0
        NotificationMessageCCList = @()
        NotificationTemplateId = ""
    }
    if ($null -eq $boundParameters.ScheduledActionsForRule -or $boundParameters.ScheduledActionsForRule.Count -eq 0)
    {
        $boundParameters.ScheduledActionsForRule = @($baseScheduledActionConfiguration)
    }
    foreach ($scheduledAction in $boundParameters.ScheduledActionsForRule)
    {
        $actionConfiguration = @{
            actionType       = $scheduledAction.ActionType
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
        if (-not [string]::IsNullOrEmpty($scheduledAction.NotificationTemplateId))
        {
            $template = $notificationTemplates | Where-Object -FilterScript { $_.DisplayName -eq $scheduledAction.NotificationTemplateId }
            if ($null -eq $template)
            {
                throw "The referenced Intune Notification Template with DisplayName {$($scheduledAction.NotificationTemplateId)} was not found"
            }
            $template = $template.Id
        }
        $actionConfiguration.notificationTemplateId = [string]$template
        $complexScheduledActionsForRule[0].scheduledActionConfigurations += $actionConfiguration
    }
    $boundParameters.Remove('ScheduledActionsForRule') | Out-Null

    if ($Ensure -eq 'Present' -and $currentDeviceMacOsPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Intune Device Compliance MacOS Policy {$DisplayName}"
        $boundParameters.Remove('Assignments') | Out-Null
        $boundParameters.Remove('Id') | Out-Null
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $boundParameters
        $createParameters.Add('@odata.type', '#microsoft.graph.macOSCompliancePolicy')
        $createParameters.Add('scheduledActionsForRule', $complexScheduledActionsForRule)
        $policy = New-MgBetaDeviceManagementDeviceCompliancePolicy -BodyParameter $createParameters

        #region Assignments
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceCompliancePolicies'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentDeviceMacOsPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Intune Device Compliance MacOS Policy {$DisplayName}"
        $boundParameters.Remove('Assignments') | Out-Null
        $boundParameters.Remove('Id') | Out-Null
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $boundParameters
        $updateParameters.Add('@odata.type', '#microsoft.graph.macOSCompliancePolicy')
        Update-MgBetaDeviceManagementDeviceCompliancePolicy -BodyParameter $updateParameters `
            -DeviceCompliancePolicyId $currentDeviceMacOsPolicy.Id

        $Uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceManagement/deviceCompliancePolicies/$($currentDeviceMacOsPolicy.Id)/scheduleActionsForRules"
        $mgGraphScheduledActionForRules = @{
            deviceComplianceScheduledActionForRules = $complexScheduledActionsForRule
        }
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $($mgGraphScheduledActionForRules | ConvertTo-Json -Depth 10)

        #region Assignments
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $currentDeviceMacOsPolicy.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceCompliancePolicies'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentDeviceMacOsPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Intune Device Compliance MacOS Policy {$DisplayName}"
        Remove-MgBetaDeviceManagementDeviceCompliancePolicy -DeviceCompliancePolicyId $currentDeviceMacOsPolicy.Id
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

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
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

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
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $OsMinimumBuildVersion,

        [Parameter()]
        [System.String]
        $OsMaximumBuildVersion,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ScheduledActionsForRule,

        [Parameter()]
        [System.Boolean]
        $SystemIntegrityProtectionEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $AdvancedThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.String]
        [ValidateSet('notConfigured', 'macAppStore', 'macAppStoreAndIdentifiedDevelopers', 'anywhere')]
        $GatekeeperAllowedAppSource,

        [Parameter()]
        [System.Boolean]
        $FirewallEnabled,

        [Parameter()]
        [System.Boolean]
        $FirewallBlockAllIncoming,

        [Parameter()]
        [System.Boolean]
        $FirewallEnableStealthMode,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        $baseFilter = "isof('microsoft.graph.macOSCompliancePolicy')"
        if (-not [string]::IsNullOrEmpty($Filter))
        {
            $complexFunctions = Get-ComplexFunctionsFromFilterQuery -FilterQuery $Filter
            $Filter = Remove-ComplexFunctionsFromFilterQuery -FilterQuery $Filter
            $Filter = "($baseFilter) and ($Filter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$configDeviceMacOsPolicies = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
            -ExpandProperty 'scheduledActionsForRule($expand=scheduledActionConfigurations)' `
            -ErrorAction Stop -All -Filter $Filter
        $configDeviceMacOsPolicies = Find-GraphDataUsingComplexFunctions -ComplexFunctions $complexFunctions -Policies $configDeviceMacOsPolicies

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($configDeviceMacOsPolicies.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }

        foreach ($configDeviceMacOsPolicy in $configDeviceMacOsPolicies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($configDeviceMacOsPolicies.Count)] $($configDeviceMacOsPolicy.displayName)" -DeferWrite
            $params = @{
                DisplayName           = $configDeviceMacOsPolicy.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $configDeviceMacOsPolicy
            $Results = Get-TargetResource @params

            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ([Array]$Results.Assignments) -CIMInstanceName DeviceManagementConfigurationPolicyAssignments

                if ($complexTypeStringResult)
                {
                    $Results.Assignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Assignments') | Out-Null
                }
            }

            if ($Results.ScheduledActionsForRule)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ScheduledActionsForRule `
                    -CIMInstanceName MSFT_scheduledActionConfigurations
                if ($complexTypeStringResult)
                {
                    $Results.ScheduledActionsForRule = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ScheduledActionsForRule') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Assignments')

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
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
                $_.Exception -like '*Request not applicable to target tenant*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            throw
        }
    }
}

Export-ModuleMember -Function *-TargetResource
