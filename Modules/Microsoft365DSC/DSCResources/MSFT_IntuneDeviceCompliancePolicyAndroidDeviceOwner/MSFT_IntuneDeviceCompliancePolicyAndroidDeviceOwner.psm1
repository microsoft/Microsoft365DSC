Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneDeviceCompliancePolicyAndroidDeviceOwner'

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
        $Description,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        $MinAndroidSecurityPatchLevel,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLetterCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumNumericCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumUpperCaseCharacters,

        [Parameter()]
        [System.Boolean]
        $RequireNoPendingSystemUpdates,

        [Parameter()]
        [System.String]
        [ValidateSet('basic', 'hardwareBacked')]
        $SecurityRequiredAndroidSafetyNetEvaluationType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ScheduledActionsForRule,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $AdvancedThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireSafetyNetAttestationBasicIntegrity,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireSafetyNetAttestationCertifiedDevice,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'alphabetic', 'alphanumeric', 'alphanumericWithSymbols', 'lowSecurityBiometric', 'numeric', 'numericComplex', 'any')]
        $PasswordRequiredType,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordCountToBlock,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireIntuneAppIntegrity,

        [Parameter()]
        [System.Boolean]
        $SecurityBlockJailbrokenDevices,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Intune Android Work Profile Device Compliance Policy {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

            $devicePolicy = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
                -All `
                -ExpandProperty 'scheduledActionsForRule($expand=scheduledActionConfigurations)' `
                -ErrorAction Stop | Where-Object `
                -FilterScript {
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidDeviceOwnerCompliancePolicy' -and `
                    $_.displayName -eq $($DisplayName)
            }

            if (([array]$devicePolicy).Count -gt 1)
            {
                throw "A policy with a duplicated displayName {'$DisplayName'} was found - Ensure displayName is unique"
            }
            if ($null -eq $devicePolicy)
            {
                Write-Verbose -Message "No Intune Android Device Owner Device Compliance Policy with displayName {$DisplayName} was found"
                return $nullResult
            }
        }
        else
        {
            $devicePolicy = $Script:exportedInstance
        }

        Write-Verbose -Message "Found Intune Android Device Owner Device Compliance Policy with displayName {$DisplayName}"

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
                $scheduledAction.Add('NotificationTemplateId', $notificationTemplate.DisplayName)
            }
            $complexScheduledActionsForRule += $scheduledAction
        }

        $results = @{
            DisplayName                                        = $devicePolicy.DisplayName
            Description                                        = $devicePolicy.Description
            MinAndroidSecurityPatchLevel                       = $devicePolicy.AdditionalProperties.minAndroidSecurityPatchLevel
            PasswordMinimumLetterCharacters                    = $devicePolicy.AdditionalProperties.passwordMinimumLetterCharacters
            PasswordMinimumLowerCaseCharacters                 = $devicePolicy.AdditionalProperties.passwordMinimumLowerCaseCharacters
            PasswordMinimumNonLetterCharacters                 = $devicePolicy.AdditionalProperties.passwordMinimumNonLetterCharacters
            PasswordMinimumNumericCharacters                   = $devicePolicy.AdditionalProperties.passwordMinimumNumericCharacters
            PasswordMinimumSymbolCharacters                    = $devicePolicy.AdditionalProperties.passwordMinimumSymbolCharacters
            PasswordMinimumUpperCaseCharacters                 = $devicePolicy.AdditionalProperties.passwordMinimumUpperCaseCharacters
            RequireNoPendingSystemUpdates                      = $devicePolicy.AdditionalProperties.requireNoPendingSystemUpdates
            SecurityRequiredAndroidSafetyNetEvaluationType     = $devicePolicy.AdditionalProperties.securityRequiredAndroidSafetyNetEvaluationType
            ScheduledActionsForRule                            = $complexScheduledActionsForRule
            DeviceThreatProtectionEnabled                      = $devicePolicy.AdditionalProperties.deviceThreatProtectionEnabled
            DeviceThreatProtectionRequiredSecurityLevel        = $devicePolicy.AdditionalProperties.deviceThreatProtectionRequiredSecurityLevel
            AdvancedThreatProtectionRequiredSecurityLevel      = $devicePolicy.AdditionalProperties.advancedThreatProtectionRequiredSecurityLevel
            SecurityRequireSafetyNetAttestationBasicIntegrity  = $devicePolicy.AdditionalProperties.securityRequireSafetyNetAttestationBasicIntegrity
            SecurityRequireSafetyNetAttestationCertifiedDevice = $devicePolicy.AdditionalProperties.securityRequireSafetyNetAttestationCertifiedDevice
            OsMinimumVersion                                   = $devicePolicy.AdditionalProperties.osMinimumVersion
            OsMaximumVersion                                   = $devicePolicy.AdditionalProperties.osMaximumVersion
            PasswordRequired                                   = $devicePolicy.AdditionalProperties.passwordRequired
            PasswordMinimumLength                              = $devicePolicy.AdditionalProperties.passwordMinimumLength
            PasswordRequiredType                               = $devicePolicy.AdditionalProperties.passwordRequiredType
            PasswordMinutesOfInactivityBeforeLock              = $devicePolicy.AdditionalProperties.passwordMinutesOfInactivityBeforeLock
            PasswordExpirationDays                             = $devicePolicy.AdditionalProperties.passwordExpirationDays
            PasswordPreviousPasswordCountToBlock               = $devicePolicy.AdditionalProperties.passwordPreviousPasswordCountToBlock
            StorageRequireEncryption                           = $devicePolicy.AdditionalProperties.storageRequireEncryption
            SecurityRequireIntuneAppIntegrity                  = $devicePolicy.AdditionalProperties.securityRequireIntuneAppIntegrity
            SecurityBlockJailbrokenDevices                     = $devicePolicy.AdditionalProperties.securityBlockJailbrokenDevices
            RoleScopeTagIds                                    = $devicePolicy.roleScopeTagIds
            Ensure                                             = 'Present'
            Credential                                         = $Credential
            ApplicationId                                      = $ApplicationId
            TenantId                                           = $TenantId
            ApplicationSecret                                  = $ApplicationSecret
            CertificateThumbprint                              = $CertificateThumbprint
            ManagedIdentity                                    = $ManagedIdentity.IsPresent
            AccessTokens                                       = $AccessTokens
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
        $Description,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        $MinAndroidSecurityPatchLevel,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLetterCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumNumericCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumUpperCaseCharacters,

        [Parameter()]
        [System.Boolean]
        $RequireNoPendingSystemUpdates,

        [Parameter()]
        [System.String]
        [ValidateSet('basic', 'hardwareBacked')]
        $SecurityRequiredAndroidSafetyNetEvaluationType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ScheduledActionsForRule,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $AdvancedThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireSafetyNetAttestationBasicIntegrity,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireSafetyNetAttestationCertifiedDevice,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'alphabetic', 'alphanumeric', 'alphanumericWithSymbols', 'lowSecurityBiometric', 'numeric', 'numericComplex', 'any')]
        $PasswordRequiredType,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordCountToBlock,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireIntuneAppIntegrity,

        [Parameter()]
        [System.Boolean]
        $SecurityBlockJailbrokenDevices,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Intune Android Device Owner Device Compliance Policy {$DisplayName}"

    $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

    $currentDeviceAndroidPolicy = Get-TargetResource @PSBoundParameters
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

    if ($Ensure -eq 'Present' -and $currentDeviceAndroidPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Intune Android Work Profile Device Compliance Policy {$DisplayName}"
        $boundParameters.Remove('DisplayName') | Out-Null
        $boundParameters.Remove('Description') | Out-Null
        $boundParameters.Remove('Assignments') | Out-Null

        $AdditionalProperties = Get-M365DSCIntuneDeviceCompliancePolicyAndroidDeviceOwnerAdditionalProperties -Properties ([System.Collections.Hashtable]$boundParameters)
        $policy = New-MgBetaDeviceManagementDeviceCompliancePolicy -DisplayName $DisplayName `
            -Description $Description `
            -AdditionalProperties $AdditionalProperties `complexScheduledActionsForRule `
            -ScheduledActionsForRule $complexScheduledActionsForRule

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
    elseif ($Ensure -eq 'Present' -and $currentDeviceAndroidPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Intune Android Device Owner Device Compliance Policy {$DisplayName}"
        $configDeviceAndroidPolicy = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript {
            $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidDeviceOwnerCompliancePolicy' -and `
                $_.displayName -eq $($DisplayName)
        }

        $boundParameters.Remove('DisplayName') | Out-Null
        $boundParameters.Remove('Description') | Out-Null
        $boundParameters.Remove('Assignments') | Out-Null

        $AdditionalProperties = Get-M365DSCIntuneDeviceCompliancePolicyAndroidDeviceOwnerAdditionalProperties -Properties ([System.Collections.Hashtable]$boundParameters)
        Update-MgBetaDeviceManagementDeviceCompliancePolicy -AdditionalProperties $AdditionalProperties `
            -Description $Description `
            -DeviceCompliancePolicyId $configDeviceAndroidPolicy.Id#`
            #-ScheduledActionsForRule $myScheduledActionsForRule #This does not work even though it is a valid parameter

        #handle ScheduledActionsForRule separately with Invoke-MgGraphRequest
        $Uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceManagement/deviceCompliancePolicies/$($configDeviceAndroidPolicy.Id)/scheduleActionsForRules"
        $mgGraphScheduledActionForRules = @{
            deviceComplianceScheduledActionForRules = $complexScheduledActionsForRule
        }
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $($mgGraphScheduledActionForRules | ConvertTo-Json -Depth 10)

        #region Assignments
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $configDeviceAndroidPolicy.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceCompliancePolicies'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentDeviceAndroidPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Intune Android Device Owner Device Compliance Policy {$DisplayName}"
        $configDeviceAndroidPolicy = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript {
            $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidDeviceOwnerCompliancePolicy' -and `
                $_.displayName -eq $($DisplayName)
        }

        Remove-MgBetaDeviceManagementDeviceCompliancePolicy -DeviceCompliancePolicyId $configDeviceAndroidPolicy.Id
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
        $Description,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        $MinAndroidSecurityPatchLevel,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLetterCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumNumericCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumUpperCaseCharacters,

        [Parameter()]
        [System.Boolean]
        $RequireNoPendingSystemUpdates,

        [Parameter()]
        [System.String]
        [ValidateSet('basic', 'hardwareBacked')]
        $SecurityRequiredAndroidSafetyNetEvaluationType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ScheduledActionsForRule,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $AdvancedThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireSafetyNetAttestationBasicIntegrity,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireSafetyNetAttestationCertifiedDevice,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'alphabetic', 'alphanumeric', 'alphanumericWithSymbols', 'lowSecurityBiometric', 'numeric', 'numericComplex', 'any')]
        $PasswordRequiredType,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordCountToBlock,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireIntuneAppIntegrity,

        [Parameter()]
        [System.Boolean]
        $SecurityBlockJailbrokenDevices,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
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
        [array]$configDeviceAndroidPolicies = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
            -ExpandProperty 'scheduledActionsForRule($expand=scheduledActionConfigurations)' `
            -ErrorAction Stop -All:$true -Filter $Filter | Where-Object `
            -FilterScript {
            $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidDeviceOwnerCompliancePolicy'
        }
        $configDeviceAndroidPolicies = Find-GraphDataUsingComplexFunctions -ComplexFunctions $complexFunctions -Policies $configDeviceAndroidPolicies

        $i = 1
        $dscContent = ''
        if ($configDeviceAndroidPolicies.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($configDeviceAndroidPolicy in $configDeviceAndroidPolicies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($configDeviceAndroidPolicies.Count)] $($configDeviceAndroidPolicy.displayName)" -DeferWrite
            $params = @{
                DisplayName           = $configDeviceAndroidPolicy.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $configDeviceAndroidPolicy
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
                -NoEscape @('Assignments', 'ScheduledActionsForRule')

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
            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            throw
        }
    }
}

function Get-M365DSCIntuneDeviceCompliancePolicyAndroidDeviceOwnerAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{'@odata.type' = '#microsoft.graph.androidDeviceOwnerCompliancePolicy' }
    foreach ($property in $properties.Keys)
    {
        if ($property -ne 'Verbose')
        {
            $propertyName = $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            $propertyValue = $properties.$property
            $results.Add($propertyName, $propertyValue)
        }
    }
    return $results
}

Export-ModuleMember -Function *-TargetResource
