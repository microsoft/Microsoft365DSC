function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockFaceUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockIrisUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockTrustAgents,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'lowSecurityBiometric', 'required', 'atLeastNumeric', 'numericComplex', 'atLeastAlphabetic', 'atLeastAlphanumeric', 'alphanumericWithSymbols')]
        $PasswordRequiredType,

        [Parameter()]
        [System.String]
        [ValidateSet('none', 'low', 'medium', 'high')]
        $RequiredPasswordComplexity,

        [Parameter()]
        [System.Boolean]
        $WorkProfileAllowAppInstallsFromUnknownSources,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'preventAny', 'allowPersonalToWork', 'noRestrictions')]
        $WorkProfileDataSharingType,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockNotificationsWhileDeviceLocked,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockAddingAccounts,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBluetoothEnableContactSharing,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockScreenCapture,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileCallerId,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCamera,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileContactsSearch,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileCopyPaste,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'prompt', 'autoGrant', 'autoDeny')]
        $WorkProfileDefaultAppPermissionPolicy,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockFaceUnlock,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockIrisUnlock,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockTrustAgents,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinNumericCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinUpperCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'lowSecurityBiometric', 'required', 'atLeastNumeric', 'numericComplex', 'atLeastAlphabetic', 'atLeastAlphanumeric', 'alphanumericWithSymbols')]
        $WorkProfilePasswordRequiredType,

        [Parameter()]
        [System.String]
        [ValidateSet('none', 'low', 'medium', 'high')]
        $WorkProfileRequiredPasswordComplexity,

        [Parameter()]
        [System.Boolean]
        $WorkProfileRequirePassword,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireVerifyApps,

        [Parameter()]
        [System.String]
        $VpnAlwaysOnPackageIdentifier,

        [Parameter()]
        [System.Boolean]
        $VpnEnableAlwaysOnLockdownMode,

        [Parameter()]
        [System.Boolean]
        $WorkProfileAllowWidgets,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockPersonalAppInstallsFromUnknownSources,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
        $ManagedIdentity
    )

    Write-Verbose -Message "Checking for the Intune Device Configuration Policy {$DisplayName}"

    $M365DSCConnectionSplat = @{
        Workload          = 'MicrosoftGraph'
        InboundParameters = $PSBoundParameters
        ProfileName       = 'Beta'
    }
    $ConnectionMode = New-M365DSCConnection @M365DSCConnectionSplat

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add('Resource', $ResourceName)
    $data.Add('Method', $MyInvocation.MyCommand)
    $data.Add('Principal', $Credential.UserName)
    $data.Add('TenantId', $TenantId)
    $data.Add('ConnectionMode', $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        $policy = Get-MgDeviceManagementDeviceConfiguration -Filter "displayName eq '$DisplayName'" `
            -ErrorAction Stop | Where-Object -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration' }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Device Configuration Policy {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found Device Configuration Policy {$DisplayName}"
        $results = @{
            Description                                               = $policy.Description
            DisplayName                                               = $policy.DisplayName
            PasswordBlockFaceUnlock                                   = $policy.AdditionalProperties.passwordBlockFaceUnlock
            PasswordBlockFingerprintUnlock                            = $policy.AdditionalProperties.passwordBlockFingerprintUnlock
            PasswordBlockIrisUnlock                                   = $policy.AdditionalProperties.passwordBlockIrisUnlock
            PasswordBlockTrustAgents                                  = $policy.AdditionalProperties.passwordBlockTrustAgents
            PasswordExpirationDays                                    = $policy.AdditionalProperties.passwordExpirationDays
            PasswordMinimumLength                                     = $policy.AdditionalProperties.passwordMinimumLength
            PasswordMinutesOfInactivityBeforeScreenTimeout            = $policy.AdditionalProperties.passwordMinutesOfInactivityBeforeScreenTimeout
            PasswordPreviousPasswordBlockCount                        = $policy.AdditionalProperties.passwordPreviousPasswordBlockCount
            PasswordSignInFailureCountBeforeFactoryReset              = $policy.AdditionalProperties.passwordSignInFailureCountBeforeFactoryReset
            PasswordRequiredType                                      = $policy.AdditionalProperties.passwordRequiredType
            RequiredPasswordComplexity                                = $policy.AdditionalProperties.requiredPasswordComplexity
            WorkProfileAllowAppInstallsFromUnknownSources             = $policy.AdditionalProperties.workProfileAllowAppInstallsFromUnknownSources
            WorkProfileDataSharingType                                = $policy.AdditionalProperties.workProfileDataSharingType
            WorkProfileBlockNotificationsWhileDeviceLocked            = $policy.AdditionalProperties.WorkProfileBlockNotificationsWhileDeviceLocked
            WorkProfileBlockAddingAccounts                            = $policy.AdditionalProperties.workProfileBlockAddingAccounts
            WorkProfileBluetoothEnableContactSharing                  = $policy.AdditionalProperties.workProfileBluetoothEnableContactSharing
            WorkProfileBlockScreenCapture                             = $policy.AdditionalProperties.workProfileBlockScreenCapture
            WorkProfileBlockCrossProfileCallerId                      = $policy.AdditionalProperties.workProfileBlockCrossProfileCallerId
            WorkProfileBlockCamera                                    = $policy.AdditionalProperties.workProfileBlockCamera
            WorkProfileBlockCrossProfileContactsSearch                = $policy.AdditionalProperties.workProfileBlockCrossProfileContactsSearch
            WorkProfileBlockCrossProfileCopyPaste                     = $policy.AdditionalProperties.workProfileBlockCrossProfileCopyPaste
            WorkProfileDefaultAppPermissionPolicy                     = $policy.AdditionalProperties.workProfileDefaultAppPermissionPolicy
            WorkProfilePasswordBlockFaceUnlock                        = $policy.AdditionalProperties.workProfilePasswordBlockFaceUnlock
            WorkProfilePasswordBlockFingerprintUnlock                 = $policy.AdditionalProperties.workProfilePasswordBlockFingerprintUnlock
            WorkProfilePasswordBlockIrisUnlock                        = $policy.AdditionalProperties.workProfilePasswordBlockIrisUnlock
            WorkProfilePasswordBlockTrustAgents                       = $policy.AdditionalProperties.workProfilePasswordBlockTrustAgents
            WorkProfilePasswordExpirationDays                         = $policy.AdditionalProperties.workProfilePasswordExpirationDays
            WorkProfilePasswordMinimumLength                          = $policy.AdditionalProperties.workProfilePasswordMinimumLength
            WorkProfilePasswordMinNumericCharacters                   = $policy.AdditionalProperties.workProfilePasswordMinNumericCharacters
            WorkProfilePasswordMinNonLetterCharacters                 = $policy.AdditionalProperties.workProfilePasswordMinNonLetterCharacters
            WorkProfilePasswordMinLetterCharacters                    = $policy.AdditionalProperties.workProfilePasswordMinLetterCharacters
            WorkProfilePasswordMinLowerCaseCharacters                 = $policy.AdditionalProperties.workProfilePasswordMinLowerCaseCharacters
            WorkProfilePasswordMinUpperCaseCharacters                 = $policy.AdditionalProperties.workProfilePasswordMinUpperCaseCharacters
            WorkProfilePasswordMinSymbolCharacters                    = $policy.AdditionalProperties.workProfilePasswordMinSymbolCharacters
            WorkProfilePasswordMinutesOfInactivityBeforeScreenTimeout = $policy.AdditionalProperties.workProfilePasswordMinutesOfInactivityBeforeScreenTimeout
            WorkProfilePasswordPreviousPasswordBlockCount             = $policy.AdditionalProperties.workProfilePasswordPreviousPasswordBlockCount
            WorkProfilePasswordSignInFailureCountBeforeFactoryReset   = $policy.AdditionalProperties.workProfilePasswordSignInFailureCountBeforeFactoryReset
            WorkProfilePasswordRequiredType                           = $policy.AdditionalProperties.workProfilePasswordRequiredType
            WorkProfileRequiredPasswordComplexity                     = $policy.AdditionalProperties.workProfileRequiredPasswordComplexity
            WorkProfileRequirePassword                                = $policy.AdditionalProperties.workProfileRequirePassword
            SecurityRequireVerifyApps                                 = $policy.AdditionalProperties.securityRequireVerifyApps
            VpnAlwaysOnPackageIdentifier                              = $policy.AdditionalProperties.vpnAlwaysOnPackageIdentifier
            VpnEnableAlwaysOnLockdownMode                             = $policy.AdditionalProperties.vpnEnableAlwaysOnLockdownMode
            WorkProfileAllowWidgets                                   = $policy.AdditionalProperties.workProfileAllowWidgets
            WorkProfileBlockPersonalAppInstallsFromUnknownSources     = $policy.AdditionalProperties.workProfileBlockPersonalAppInstallsFromUnknownSources
            Ensure                                                    = 'Present'
            Credential                                                = $Credential
            ApplicationId                                             = $ApplicationId
            TenantId                                                  = $TenantId
            ApplicationSecret                                         = $ApplicationSecret
            CertificateThumbprint                                     = $CertificateThumbprint
            Managedidentity                                           = $ManagedIdentity.IsPresent
        }

        $returnAssignments = @()
        $returnAssignments += Get-MgDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $policy.Id
        $assignmentResult = @()
        foreach ($assignmentEntry in $returnAssignments)
        {
            $assignmentValue = @{
                dataType                                   = $assignmentEntry.Target.AdditionalProperties.'@odata.type'
                deviceAndAppManagementAssignmentFilterType = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType.toString()
                deviceAndAppManagementAssignmentFilterId   = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterId
                groupId                                    = $assignmentEntry.Target.AdditionalProperties.groupId
            }
            $assignmentResult += $assignmentValue
        }
        $results.Add('Assignments', $assignmentResult)

        return $results
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
    param
    (
        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockFaceUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockIrisUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockTrustAgents,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'lowSecurityBiometric', 'required', 'atLeastNumeric', 'numericComplex', 'atLeastAlphabetic', 'atLeastAlphanumeric', 'alphanumericWithSymbols')]
        $PasswordRequiredType,

        [Parameter()]
        [System.String]
        [ValidateSet('none', 'low', 'medium', 'high')]
        $RequiredPasswordComplexity,

        [Parameter()]
        [System.Boolean]
        $WorkProfileAllowAppInstallsFromUnknownSources,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'preventAny', 'allowPersonalToWork', 'noRestrictions')]
        $WorkProfileDataSharingType,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockNotificationsWhileDeviceLocked,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockAddingAccounts,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBluetoothEnableContactSharing,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockScreenCapture,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileCallerId,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCamera,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileContactsSearch,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileCopyPaste,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'prompt', 'autoGrant', 'autoDeny')]
        $WorkProfileDefaultAppPermissionPolicy,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockFaceUnlock,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockIrisUnlock,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockTrustAgents,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinNumericCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinUpperCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'lowSecurityBiometric', 'required', 'atLeastNumeric', 'numericComplex', 'atLeastAlphabetic', 'atLeastAlphanumeric', 'alphanumericWithSymbols')]
        $WorkProfilePasswordRequiredType,

        [Parameter()]
        [System.String]
        [ValidateSet('none', 'low', 'medium', 'high')]
        $WorkProfileRequiredPasswordComplexity,

        [Parameter()]
        [System.Boolean]
        $WorkProfileRequirePassword,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireVerifyApps,

        [Parameter()]
        [System.String]
        $VpnAlwaysOnPackageIdentifier,

        [Parameter()]
        [System.Boolean]
        $VpnEnableAlwaysOnLockdownMode,

        [Parameter()]
        [System.Boolean]
        $WorkProfileAllowWidgets,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockPersonalAppInstallsFromUnknownSources,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
        $ManagedIdentity
    )

    $M365DSCConnectionSplat = @{
        Workload          = 'MicrosoftGraph'
        InboundParameters = $PSBoundParameters
        ProfileName       = 'Beta'
    }
    $ConnectionMode = New-M365DSCConnection @M365DSCConnectionSplat

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add('Resource', $ResourceName)
    $data.Add('Method', $MyInvocation.MyCommand)
    $data.Add('Principal', $Credential.UserName)
    $data.Add('TenantId', $TenantId)
    $data.Add('ConnectionMode', $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Device Configuration Policy {$DisplayName}"
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $AdditionalProperties = Get-M365DSCIntuneDeviceConfigurationPolicyAndroidWorkProfileAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        $policy = New-MgDeviceManagementDeviceConfiguration -DisplayName $DisplayName `
            -Description $Description `
            -AdditionalProperties $AdditionalProperties

        #region Assignments
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignments -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Device Configuration Policy {$DisplayName}"
        $configDevicePolicy = Get-MgDeviceManagementDeviceConfiguration -Filter "DisplayName eq '$Displayname'" -ErrorAction SilentlyContinue | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration' `
            }

        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $AdditionalProperties = Get-M365DSCIntuneDeviceConfigurationPolicyAndroidWorkProfileAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        Update-MgDeviceManagementDeviceConfiguration -AdditionalProperties $AdditionalProperties `
            -Description $Description `
            -DeviceConfigurationId $configDevicePolicy.Id

        #region Assignments
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        Update-DeviceConfigurationPolicyAssignments -DeviceConfigurationPolicyId $configDevicePolicy.Id `
            -Targets $assignmentsHash
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Device Configuration Policy {$DisplayName}"
        $configDevicePolicy = Get-MgDeviceManagementDeviceConfiguration -Filter "DisplayName eq '$Displayname'" -ErrorAction SilentlyContinue | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration' `
            }

        Remove-MgDeviceManagementDeviceConfiguration -DeviceConfigurationId $configDevicePolicy.Id
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockFaceUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockIrisUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockTrustAgents,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'lowSecurityBiometric', 'required', 'atLeastNumeric', 'numericComplex', 'atLeastAlphabetic', 'atLeastAlphanumeric', 'alphanumericWithSymbols')]
        $PasswordRequiredType,

        [Parameter()]
        [System.String]
        [ValidateSet('none', 'low', 'medium', 'high')]
        $RequiredPasswordComplexity,

        [Parameter()]
        [System.Boolean]
        $WorkProfileAllowAppInstallsFromUnknownSources,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'preventAny', 'allowPersonalToWork', 'noRestrictions')]
        $WorkProfileDataSharingType,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockNotificationsWhileDeviceLocked,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockAddingAccounts,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBluetoothEnableContactSharing,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockScreenCapture,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileCallerId,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCamera,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileContactsSearch,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockCrossProfileCopyPaste,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'prompt', 'autoGrant', 'autoDeny')]
        $WorkProfileDefaultAppPermissionPolicy,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockFaceUnlock,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockIrisUnlock,

        [Parameter()]
        [System.Boolean]
        $WorkProfilePasswordBlockTrustAgents,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinNumericCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinNonLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinLetterCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinLowerCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinUpperCaseCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinSymbolCharacters,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $WorkProfilePasswordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'lowSecurityBiometric', 'required', 'atLeastNumeric', 'numericComplex', 'atLeastAlphabetic', 'atLeastAlphanumeric', 'alphanumericWithSymbols')]
        $WorkProfilePasswordRequiredType,

        [Parameter()]
        [System.String]
        [ValidateSet('none', 'low', 'medium', 'high')]
        $WorkProfileRequiredPasswordComplexity,

        [Parameter()]
        [System.Boolean]
        $WorkProfileRequirePassword,

        [Parameter()]
        [System.Boolean]
        $SecurityRequireVerifyApps,

        [Parameter()]
        [System.String]
        $VpnAlwaysOnPackageIdentifier,

        [Parameter()]
        [System.Boolean]
        $VpnEnableAlwaysOnLockdownMode,

        [Parameter()]
        [System.Boolean]
        $WorkProfileAllowWidgets,

        [Parameter()]
        [System.Boolean]
        $WorkProfileBlockPersonalAppInstallsFromUnknownSources,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
        $ManagedIdentity
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add('Resource', $ResourceName)
    $data.Add('Method', $MyInvocation.MyCommand)
    $data.Add('Principal', $Credential.UserName)
    $data.Add('TenantId', $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Write-Verbose -Message "Testing configuration of Device Configuration Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

    if ($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    #region Assignments
    $testResult = $true

    if ((-not $CurrentValues.Assignments) -xor (-not $ValuesToCheck.Assignments))
    {
        Write-Verbose -Message 'Configuration drift: one the assignment is null'
        return $false
    }

    if ($CurrentValues.Assignments)
    {
        if ($CurrentValues.Assignments.count -ne $ValuesToCheck.Assignments.count)
        {
            Write-Verbose -Message "Configuration drift: Number of assignment has changed - current {$($CurrentValues.Assignments.count)} target {$($ValuesToCheck.Assignments.count)}"
            return $false
        }
        foreach ($assignment in $CurrentValues.Assignments)
        {
            #GroupId Assignment
            if (-not [String]::IsNullOrEmpty($assignment.groupId))
            {
                $source = [Array]$ValuesToCheck.Assignments | Where-Object -FilterScript { $_.groupId -eq $assignment.groupId }
                if (-not $source)
                {
                    Write-Verbose -Message "Configuration drift: groupId {$($assignment.groupId)} not found"
                    $testResult = $false
                    break
                }
                $sourceHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $source
                $testResult = Compare-M365DSCComplexObject -Source $sourceHash -Target $assignment
            }
            #AllDevices/AllUsers assignment
            else
            {
                $source = [Array]$ValuesToCheck.Assignments | Where-Object -FilterScript { $_.dataType -eq $assignment.dataType }
                if (-not $source)
                {
                    Write-Verbose -Message "Configuration drift: {$($assignment.dataType)} not found"
                    $testResult = $false
                    break
                }
                $sourceHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $source
                $testResult = Compare-M365DSCComplexObject -Source $sourceHash -Target $assignment
            }

            if (-not $testResult)
            {
                $testResult = $false
                break
            }

        }
    }
    if (-not $testResult)
    {
        return $false
    }
    $ValuesToCheck.Remove('Assignments') | Out-Null
    #endregion

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
        $ManagedIdentity
    )

    $M365DSCConnectionSplat = @{
        Workload          = 'MicrosoftGraph'
        InboundParameters = $PSBoundParameters
        ProfileName       = 'Beta'
    }
    $ConnectionMode = New-M365DSCConnection @M365DSCConnectionSplat

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add('Resource', $ResourceName)
    $data.Add('Method', $MyInvocation.MyCommand)
    $data.Add('Principal', $Credential.UserName)
    $data.Add('TenantId', $TenantId)
    $data.Add('ConnectionMode', $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$policies = Get-MgDeviceManagementDeviceConfiguration `
            -ErrorAction Stop -All:$true -Filter $Filter | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration' }
        $i = 1
        $dscContent = ''
        if ($policies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.DisplayName)" -NoNewline
            $params = @{
                DisplayName           = $policy.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
            }
            $Results = Get-TargetResource @Params

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

            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            if ($Results.Assignments)
            {
                $isCIMArray = $false
                if ($Results.Assignments.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$isCIMArray
            }

            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*")
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX

            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }

        return ''
    }
}

function Get-M365DSCIntuneDeviceConfigurationPolicyAndroidWorkProfileAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{'@odata.type' = '#microsoft.graph.androidWorkProfileGeneralDeviceConfiguration' }
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

function Update-DeviceConfigurationPolicyAssignments
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter()]
        [Array]
        $Targets
    )

    try
    {
        $configurationPolicyAssignments = @()

        $Uri = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$DeviceConfigurationPolicyId/assign"

        foreach ($target in $targets)
        {
            $formattedTarget = @{'@odata.type' = $target.dataType }
            if ($target.groupId)
            {
                $formattedTarget.Add('groupId', $target.groupId)
            }
            if ($target.collectionId)
            {
                $formattedTarget.Add('collectionId', $target.collectionId)
            }
            if ($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType', $target.deviceAndAppManagementAssignmentFilterType)
            }
            if ($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId', $target.deviceAndAppManagementAssignmentFilterId)
            }
            $configurationPolicyAssignments += @{'target' = $formattedTarget }
        }
        $body = @{'assignments' = $configurationPolicyAssignments } | ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop

    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $null
    }
}

function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        $ComplexObject
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    if ($ComplexObject.gettype().fullname -like '*[[\]]')
    {
        $results = @()

        foreach ($item in $ComplexObject)
        {
            if ($item)
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                $results += $hash
            }
        }
        if ($results.count -eq 0)
        {
            return $null
        }
        return $results
    }

    $results = @{}
    $keys = $ComplexObject | Get-Member | Where-Object -FilterScript { $_.MemberType -eq 'Property' -and $_.Name -ne 'AdditionalProperties' }

    foreach ($key in $keys)
    {
        if ($ComplexObject.$($key.Name))
        {
            $results.Add($key.Name, $ComplexObject.$($key.Name))
        }
    }
    if ($results.count -eq 0)
    {
        return $null
    }
    return $results
}

function Get-M365DSCDRGComplexTypeToString
{
    [CmdletBinding()]
    #[OutputType([System.String])]
    param
    (
        [Parameter()]
        $ComplexObject,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CIMInstanceName,

        [Parameter()]
        [System.String]
        $Whitespace = '',

        [Parameter()]
        [switch]
        $isArray = $false
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    #If ComplexObject  is an Array
    if ($ComplexObject.GetType().FullName -like '*[[\]]')
    {
        $currentProperty = @()
        foreach ($item in $ComplexObject)
        {
            $currentProperty += Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $item `
                -isArray:$true `
                -CIMInstanceName $CIMInstanceName `
                -Whitespace '                '

        }
        if ([string]::IsNullOrEmpty($currentProperty))
        {
            return $null
        }
        return $currentProperty
    }

    #If ComplexObject is a single CIM Instance
    if (-Not (Test-M365DSCComplexObjectHasValues -ComplexObject $ComplexObject))
    {
        return $null
    }
    $currentProperty = ''
    if ($isArray)
    {
        $currentProperty += "`r`n"
    }
    $currentProperty += "$whitespace`MSFT_$CIMInstanceName{`r`n"
    $keyNotNull = 0
    foreach ($key in $ComplexObject.Keys)
    {
        if ($ComplexObject[$key])
        {
            $keyNotNull++

            if ($ComplexObject[$key].GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*')
            {
                $hashPropertyType = $ComplexObject[$key].GetType().Name.tolower()
                $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]

                if (Test-M365DSCComplexObjectHasValues -ComplexObject $hashProperty)
                {
                    $Whitespace += '            '
                    if (-not $isArray)
                    {
                        $currentProperty += '                ' + $key + ' = '
                    }
                    $currentProperty += Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $hashProperty `
                        -CIMInstanceName $hashPropertyType `
                        -Whitespace $Whitespace
                }
            }
            else
            {
                if (-not $isArray)
                {
                    $Whitespace = '            '
                }
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key] -Space ($Whitespace + '    ')
            }
        }
    }
    $currentProperty += '            }'

    if ($keyNotNull -eq 0)
    {
        $currentProperty = $null
    }

    return $currentProperty
}

function Test-M365DSCComplexObjectHasValues
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $ComplexObject
    )
    $keys = $ComplexObject.keys
    $hasValue = $false
    foreach ($key in $keys)
    {
        if ($ComplexObject[$key])
        {
            if ($ComplexObject[$key].GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*')
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                if (-Not $hash)
                {
                    return $false
                }
                $hasValue = Test-M365DSCComplexObjectHasValues -ComplexObject ($hash)
            }
            else
            {
                $hasValue = $true
                return $hasValue
            }
        }
    }
    return $hasValue
}

function Get-M365DSCDRGSimpleObjectTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $Key,

        [Parameter(Mandatory = 'true')]
        $Value,

        [Parameter()]
        [System.String]
        $Space = '                '
    )

    $returnValue = ''
    switch -Wildcard ($Value.GetType().Fullname )
    {
        '*.Boolean'
        {
            $returnValue = $Space + $Key + " = `$" + $Value.ToString() + "`r`n"
        }
        '*.String'
        {
            if ($key -eq '@odata.type')
            {
                $key = 'odataType'
            }
            $returnValue = $Space + $Key + " = '" + $Value + "'`r`n"
        }
        '*.DateTime'
        {
            $returnValue = $Space + $Key + " = '" + $Value + "'`r`n"
        }
        '*[[\]]'
        {
            $returnValue = $Space + $key + ' = @('
            $whitespace = ''
            $newline = ''
            if ($Value.count -gt 1)
            {
                $returnValue += "`r`n"
                $whitespace = $Space + '    '
                $newline = "`r`n"
            }
            foreach ($item in $Value)
            {
                switch -Wildcard ($item.GetType().Fullname )
                {
                    '*.String'
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    '*.DateTime'
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    Default
                    {
                        $returnValue += "$whitespace$item$newline"
                    }
                }
            }
            if ($Value.count -gt 1)
            {
                $returnValue += "$Space)`r`n"
            }
            else
            {
                $returnValue += ")`r`n"

            }
        }
        Default
        {
            $returnValue = $Space + $Key + ' = ' + $Value + "`r`n"
        }
    }
    return $returnValue
}

function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.Collections.Hashtable]
        $Source,

        [Parameter()]
        [System.Collections.Hashtable]
        $Target
    )

    $keys = $Source.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    foreach ($key in $keys)
    {
        Write-Verbose -Message "Comparing key: {$key}"
        $skey = $key
        if ($key -eq 'odataType')
        {
            $skey = '@odata.type'
        }

        #Marking Target[key] to null if empty complex object or array
        if ($null -ne $Target[$key])
        {
            switch -Wildcard ($Target[$key].getType().Fullname )
            {
                'Microsoft.Graph.PowerShell.Models.*'
                {
                    $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Target[$key]
                    if (-not (Test-M365DSCComplexObjectHasValues -ComplexObject $hashProperty))
                    {
                        $Target[$key] = $null
                    }
                }
                '*[[\]]'
                {
                    if ($Target[$key].count -eq 0)
                    {
                        $Target[$key] = $null
                    }
                }
            }
        }
        $sourceValue = $Source[$key]
        $targetValue = $Target[$key]
        #One of the item is null
        if (($null -eq $Source[$skey]) -xor ($null -eq $Target[$key]))
        {
            if ($null -eq $Source[$skey])
            {
                $sourceValue = 'null'
            }

            if ($null -eq $Target[$key])
            {
                $targetValue = 'null'
            }
            Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
            return $false
        }
        #Both source and target aren't null or empty
        if (($null -ne $Source[$skey]) -and ($null -ne $Target[$key]))
        {
            if ($Source[$skey].getType().FullName -like '*CimInstance*')
            {
                #Recursive call for complex object
                $compareResult = Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source[$skey]) `
                    -Target (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Target[$key])

                if (-not $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject = $Target[$key]
                $differenceObject = $Source[$skey]

                $compareResult = Compare-Object `
                    -ReferenceObject ($referenceObject) `
                    -DifferenceObject ($differenceObject)

                if ($null -ne $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
                    return $false
                }
            }
        }
    }

    return $true
}

function Convert-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = 'true')]
        $ComplexObject
    )

    if ($ComplexObject.getType().Fullname -like '*[[\]]')
    {
        $results = @()
        foreach ($item in $ComplexObject)
        {
            $hash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            if (Test-M365DSCComplexObjectHasValues -ComplexObject $hash)
            {
                $results += $hash
            }
        }
        if ($results.count -eq 0)
        {
            return $null
        }
        return $Results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject
    if ($hashComplexObject)
    {
        $results = $hashComplexObject.clone()
        $keys = $hashComplexObject.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
        foreach ($key in $keys)
        {
            if (($null -ne $hashComplexObject[$key]) -and ($hashComplexObject[$key].getType().Fullname -like '*CimInstance*'))
            {
                $results[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            if ($null -eq $results[$key])
            {
                $results.remove($key) | Out-Null
            }
        }
    }
    return $results
}

Export-ModuleMember -Function *-TargetResource
