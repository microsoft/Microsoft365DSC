Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneSecurityBaselineHoloLens2Standard'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowMicrosoftAccountConnection,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $VideoPowerDownTimeOutAC_2,

        [Parameter()]
        [ValidateRange(0, 4294967295)]
        [System.Int32]
        $EnterVideoACPowerDownTimeOut,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $AllowCookies,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowPasswordManager,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowSmartScreen,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowUSBConnection,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DevicePasswordEnabled,

        [Parameter()]
        [ValidateRange(0, 730)]
        [System.Int32]
        $DevicePasswordExpiration,

        [Parameter()]
        [ValidateRange(4, 16)]
        [System.Int32]
        $MinDevicePasswordLength,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $AlphanumericDevicePasswordRequired,

        [Parameter()]
        [ValidateRange(0, 999)]
        [System.Int32]
        $MaxDevicePasswordFailedAttempts,

        [Parameter()]
        [ValidateSet(1, 2, 3, 4)]
        [System.Int32]
        $MinDevicePasswordComplexCharacters,

        [Parameter()]
        [ValidateRange(0, 999)]
        [System.Int32]
        $MaxInactivityTimeDeviceLock,

        [Parameter()]
        [ValidateRange(0, 50)]
        [System.Int32]
        $DevicePasswordHistory,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowSimpleDevicePassword,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowManualMDMUnenrollment,

        [Parameter()]
        [ValidateSet(0, 1, 65535)]
        [System.Int32]
        $AllowAllTrustedApps,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $AllowAppStoreAutoUpdate,

        [Parameter()]
        [ValidateSet(0, 1, 65535)]
        [System.Int32]
        $AllowDeveloperUnlock,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $BlockThirdPartyCookies,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $ExtensionInstallBlocklist,

        [Parameter()]
        [ValidateLength(0, 2048)]
        [System.String[]]
        $ExtensionInstallBlocklistDesc,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $PasswordManagerEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SmartScreenEnabled,

        [Parameter()]
        [ValidateRange(0, 60)]
        [System.Int32]
        $AADGroupMembershipCacheValidityInDays,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowVPN,

        [Parameter()]
        [ValidateLength(0, 87516)]
        [System.String]
        $PageVisibilityList,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowStorageCard,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $EnablePinRecovery,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $TPM12,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $Digits,

        [Parameter()]
        [ValidateRange(0, 730)]
        [System.Int32]
        $Expiration,

        [Parameter()]
        [ValidateRange(0, 50)]
        [System.Int32]
        $History,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $LowercaseLetters,

        [Parameter()]
        [ValidateRange(4, 127)]
        [System.Int32]
        $MaximumPINLength,

        [Parameter()]
        [ValidateRange(4, 127)]
        [System.Int32]
        $MinimumPINLength,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $SpecialCharacters,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $UppercaseLetters,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $RequireSecurityDevice,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $UseCertificateForOnPremAuth,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $UseHelloCertificatesAsSmartCardCertificates,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $UsePassportForWork,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowUpdateService,

        [Parameter()]
        [ValidateSet(0, 1, 2, 3)]
        [System.Int32]
        $ManagePreviewBuilds,

        [Parameter()]
        [ValidateSet('true', 'false')]
        [System.String]
        $RequireNetworkInOOBE,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

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

    Write-Verbose -Message "Getting configuration for the Intune Security Baseline HoloLens2 Standard with Id {$Id} and Name {$DisplayName}"

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

            $getValue = $null
            #region resource generator code
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Id -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Security Baseline HoloLens2 Standard with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementConfigurationPolicy `
                        -All `
                        -Filter "Name eq '$($DisplayName -replace "'", "''")'" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Security Baseline HoloLens2 Standard with Name {$DisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Security Baseline HoloLens2 Standard with Id {$Id} and Name {$DisplayName} was found"

        # Retrieve policy specific settings
        [array]$settings = Get-MgBetaDeviceManagementConfigurationPolicySetting `
            -DeviceManagementConfigurationPolicyId $Id `
            -ExpandProperty 'settingDefinitions' `
            -All `
            -ErrorAction Stop

        $policySettings = @{}
        $policySettings = Export-IntuneSettingCatalogPolicySettings -Settings $settings -ReturnHashtable $policySettings

        $results = @{
            #region resource generator code
            Description           = $getValue.Description
            DisplayName           = $getValue.Name
            RoleScopeTagIds       = $getValue.RoleScopeTagIds
            Id                    = $getValue.Id
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            #endregion
        }
        $results += $policySettings

        $assignmentsValues = Get-MgBetaDeviceManagementConfigurationPolicyAssignment -DeviceManagementConfigurationPolicyId $Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment -Assignments $assignmentsValues -IncludeDeviceFilter $true
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

        throw
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowMicrosoftAccountConnection,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $VideoPowerDownTimeOutAC_2,

        [Parameter()]
        [ValidateRange(0, 4294967295)]
        [System.Int32]
        $EnterVideoACPowerDownTimeOut,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $AllowCookies,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowPasswordManager,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowSmartScreen,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowUSBConnection,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DevicePasswordEnabled,

        [Parameter()]
        [ValidateRange(0, 730)]
        [System.Int32]
        $DevicePasswordExpiration,

        [Parameter()]
        [ValidateRange(4, 16)]
        [System.Int32]
        $MinDevicePasswordLength,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $AlphanumericDevicePasswordRequired,

        [Parameter()]
        [ValidateRange(0, 999)]
        [System.Int32]
        $MaxDevicePasswordFailedAttempts,

        [Parameter()]
        [ValidateSet(1, 2, 3, 4)]
        [System.Int32]
        $MinDevicePasswordComplexCharacters,

        [Parameter()]
        [ValidateRange(0, 999)]
        [System.Int32]
        $MaxInactivityTimeDeviceLock,

        [Parameter()]
        [ValidateRange(0, 50)]
        [System.Int32]
        $DevicePasswordHistory,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowSimpleDevicePassword,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowManualMDMUnenrollment,

        [Parameter()]
        [ValidateSet(0, 1, 65535)]
        [System.Int32]
        $AllowAllTrustedApps,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $AllowAppStoreAutoUpdate,

        [Parameter()]
        [ValidateSet(0, 1, 65535)]
        [System.Int32]
        $AllowDeveloperUnlock,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $BlockThirdPartyCookies,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $ExtensionInstallBlocklist,

        [Parameter()]
        [ValidateLength(0, 2048)]
        [System.String[]]
        $ExtensionInstallBlocklistDesc,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $PasswordManagerEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SmartScreenEnabled,

        [Parameter()]
        [ValidateRange(0, 60)]
        [System.Int32]
        $AADGroupMembershipCacheValidityInDays,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowVPN,

        [Parameter()]
        [ValidateLength(0, 87516)]
        [System.String]
        $PageVisibilityList,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowStorageCard,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $EnablePinRecovery,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $TPM12,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $Digits,

        [Parameter()]
        [ValidateRange(0, 730)]
        [System.Int32]
        $Expiration,

        [Parameter()]
        [ValidateRange(0, 50)]
        [System.Int32]
        $History,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $LowercaseLetters,

        [Parameter()]
        [ValidateRange(4, 127)]
        [System.Int32]
        $MaximumPINLength,

        [Parameter()]
        [ValidateRange(4, 127)]
        [System.Int32]
        $MinimumPINLength,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $SpecialCharacters,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $UppercaseLetters,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $RequireSecurityDevice,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $UseCertificateForOnPremAuth,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $UseHelloCertificatesAsSmartCardCertificates,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $UsePassportForWork,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowUpdateService,

        [Parameter()]
        [ValidateSet(0, 1, 2, 3)]
        [System.Int32]
        $ManagePreviewBuilds,

        [Parameter()]
        [ValidateSet('true', 'false')]
        [System.String]
        $RequireNetworkInOOBE,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion
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

    Write-Verbose -Message "Setting configuration of the Intune Security Baseline HoloLens2 Standard with Id {$Id} and Name {$DisplayName}"

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

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    $templateReferenceId = '5d030c29-ea8d-4751-ba0d-5e3de7a84cd3_1'
    $platforms = 'windows10'
    $technologies = 'mdm'

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Security Baseline HoloLens2 Standard with Name {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$BoundParameters) `
            -TemplateId $templateReferenceId

        $createParameters = @{
            Name              = $DisplayName
            Description       = $Description
            TemplateReference = @{ templateId = $templateReferenceId }
            Platforms         = $platforms
            Technologies      = $technologies
            Settings          = $settings
            RoleScopeTagIds   = $RoleScopeTagIds
        }

        #region resource generator code
        $policy = New-MgBetaDeviceManagementConfigurationPolicy -BodyParameter $createParameters

        if ($policy.Id)
        {
            $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceConfigurationPolicyAssignment `
                -DeviceConfigurationPolicyId $policy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/configurationPolicies'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Security Baseline HoloLens2 Standard with Id {$($currentInstance.Id)}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$BoundParameters) `
            -TemplateId $templateReferenceId

        Update-IntuneDeviceConfigurationPolicy `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Name $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings `
            -RoleScopeTagIds $RoleScopeTagIds

        #region resource generator code
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/configurationPolicies'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Security Baseline HoloLens2 Standard with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $currentInstance.Id
        #endregion
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowMicrosoftAccountConnection,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $VideoPowerDownTimeOutAC_2,

        [Parameter()]
        [ValidateRange(0, 4294967295)]
        [System.Int32]
        $EnterVideoACPowerDownTimeOut,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $AllowCookies,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowPasswordManager,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowSmartScreen,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowUSBConnection,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DevicePasswordEnabled,

        [Parameter()]
        [ValidateRange(0, 730)]
        [System.Int32]
        $DevicePasswordExpiration,

        [Parameter()]
        [ValidateRange(4, 16)]
        [System.Int32]
        $MinDevicePasswordLength,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $AlphanumericDevicePasswordRequired,

        [Parameter()]
        [ValidateRange(0, 999)]
        [System.Int32]
        $MaxDevicePasswordFailedAttempts,

        [Parameter()]
        [ValidateSet(1, 2, 3, 4)]
        [System.Int32]
        $MinDevicePasswordComplexCharacters,

        [Parameter()]
        [ValidateRange(0, 999)]
        [System.Int32]
        $MaxInactivityTimeDeviceLock,

        [Parameter()]
        [ValidateRange(0, 50)]
        [System.Int32]
        $DevicePasswordHistory,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowSimpleDevicePassword,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowManualMDMUnenrollment,

        [Parameter()]
        [ValidateSet(0, 1, 65535)]
        [System.Int32]
        $AllowAllTrustedApps,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $AllowAppStoreAutoUpdate,

        [Parameter()]
        [ValidateSet(0, 1, 65535)]
        [System.Int32]
        $AllowDeveloperUnlock,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $BlockThirdPartyCookies,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $ExtensionInstallBlocklist,

        [Parameter()]
        [ValidateLength(0, 2048)]
        [System.String[]]
        $ExtensionInstallBlocklistDesc,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $PasswordManagerEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SmartScreenEnabled,

        [Parameter()]
        [ValidateRange(0, 60)]
        [System.Int32]
        $AADGroupMembershipCacheValidityInDays,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowVPN,

        [Parameter()]
        [ValidateLength(0, 87516)]
        [System.String]
        $PageVisibilityList,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowStorageCard,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $EnablePinRecovery,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $TPM12,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $Digits,

        [Parameter()]
        [ValidateRange(0, 730)]
        [System.Int32]
        $Expiration,

        [Parameter()]
        [ValidateRange(0, 50)]
        [System.Int32]
        $History,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $LowercaseLetters,

        [Parameter()]
        [ValidateRange(4, 127)]
        [System.Int32]
        $MaximumPINLength,

        [Parameter()]
        [ValidateRange(4, 127)]
        [System.Int32]
        $MinimumPINLength,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $SpecialCharacters,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $UppercaseLetters,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $RequireSecurityDevice,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $UseCertificateForOnPremAuth,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $UseHelloCertificatesAsSmartCardCertificates,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $UsePassportForWork,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowUpdateService,

        [Parameter()]
        [ValidateSet(0, 1, 2, 3)]
        [System.Int32]
        $ManagePreviewBuilds,

        [Parameter()]
        [ValidateSet('true', 'false')]
        [System.String]
        $RequireNetworkInOOBE,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

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

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        @compareParameters
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
        #region resource generator code
        $policyTemplateID = '5d030c29-ea8d-4751-ba0d-5e3de7a84cd3_1'
        [array]$getValue = Get-MgBetaDeviceManagementConfigurationPolicy `
            -Filter $Filter `
            -All `
            -ErrorAction Stop | Where-Object `
            -FilterScript {
                $_.TemplateReference.TemplateId -eq $policyTemplateID
            }
        #endregion

        $i = 1
        $dscContent = ''
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
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            elseif (-not [string]::IsNullOrEmpty($config.name))
            {
                $displayedKey = $config.name
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.Name
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Assignments -CIMInstanceName DeviceManagementConfigurationPolicyAssignments
                if ($complexTypeStringResult)
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
                -NoEscape @('Assignments')

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
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        PostProcessing     = {
            param($DesiredValues, $CurrentValues, $ValuesToCheck, $PostProcessingArgs)
            $PostProcessingArgs[0] | ForEach-Object {
                if ($_.Key -notlike '*Variable' -or $_.Key -notin @('Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction'))
                {
                    if ($null -ne $CurrentValues[$_.Key] -or $null -ne $DesiredValues[$_.Key])
                    {
                        $ValuesToCheck[$_.Key] = $null
                        if (-not $DesiredValues.ContainsKey($_.Key))
                        {
                            $DesiredValues.Add($_.Key, $null)
                        }
                    }
                }
            }

            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
        PostProcessingArgs = $MyInvocation.MyCommand.Parameters.GetEnumerator()
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
