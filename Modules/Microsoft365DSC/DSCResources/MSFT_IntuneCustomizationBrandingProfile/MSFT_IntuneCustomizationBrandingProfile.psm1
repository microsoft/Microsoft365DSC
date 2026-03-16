Confirm-M365DSCModuleDependency -ModuleName "MSFT_IntuneCustomizationBrandingProfile"

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CompanyPortalBlockedActions,

        [Parameter()]
        [System.String]
        $ContactITEmailAddress,

        [Parameter()]
        [System.String]
        $ContactITName,

        [Parameter()]
        [System.String]
        $ContactITNotes,

        [Parameter()]
        [System.String]
        $ContactITPhoneNumber,

        [Parameter()]
        [System.String]
        $CustomCanSeePrivacyMessage,

        [Parameter()]
        [System.String]
        $CustomCantSeePrivacyMessage,

        [Parameter()]
        [System.Boolean]
        $DisableDeviceCategorySelection,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateSet('availableWithPrompts','availableWithoutPrompts','unavailable')]
        [System.String]
        $EnrollmentAvailability,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LandingPageCustomizedImage,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LightBackgroundLogo,

        [Parameter()]
        [System.String]
        $OnlineSupportSiteName,

        [Parameter()]
        [System.String]
        $OnlineSupportSiteUrl,

        [Parameter()]
        [System.String]
        $PrivacyUrl,

        [Parameter()]
        [System.String]
        $ProfileDescription,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ProfileName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $ShowAzureADEnterpriseApps,

        [Parameter()]
        [System.Boolean]
        $ShowConfigurationManagerApps,

        [Parameter()]
        [System.Boolean]
        $ShowDisplayNameNextToLogo,

        [Parameter()]
        [System.Boolean]
        $ShowLogo,

        [Parameter()]
        [System.Boolean]
        $ShowOfficeWebApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ThemeColor,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ThemeColorLogo,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

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

    Write-Verbose -Message "Getting configuration for the Intune Customization Branding Profile with Id {$Id} and ProfileName {$ProfileName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.ProfileName -ne $ProfileName)
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
                $getValue = Get-MgBetaDeviceManagementIntuneBrandingProfile -IntuneBrandingProfileId $Id -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Customization Branding Profile with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementIntuneBrandingProfile `
                        -Filter "ProfileName eq '$($ProfileName -replace "'", "''")'" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Customization Branding Profile with ProfileName {$ProfileName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Customization Branding Profile with Id {$Id} and ProfileName {$ProfileName} was found"

        $batchRequests = @(
            @{
                id = 'themeColorLogo'
                method = 'GET'
                url = "/deviceManagement/intuneBrandingProfiles/$($Id)/themeColorLogo"
            }
            @{
                id = 'lightBackgroundLogo'
                method = 'GET'
                url = "/deviceManagement/intuneBrandingProfiles/$($Id)/lightBackgroundLogo"
            }
            @{
                id = 'landingPageCustomizedImage'
                method = 'GET'
                url = "/deviceManagement/intuneBrandingProfiles/$($Id)/landingPageCustomizedImage"
            }
        )
        $batchResponses = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests
        $themeColorLogoResponse = ($batchResponses | Where-Object { $_.id -eq 'themeColorLogo' }).body
        $lightBackgroundLogoResponse = ($batchResponses | Where-Object { $_.id -eq 'lightBackgroundLogo' }).body
        $landingPageCustomizedImageResponse = ($batchResponses | Where-Object { $_.id -eq 'landingPageCustomizedImage' }).body

        #region resource generator code
        $complexCompanyPortalBlockedActions = @()
        foreach ($currentCompanyPortalBlockedActions in $getValue.companyPortalBlockedActions)
        {
            $myCompanyPortalBlockedActions = [ordered]@{}
            if ($null -ne $currentCompanyPortalBlockedActions.action)
            {
                $myCompanyPortalBlockedActions.Add('Action', $currentCompanyPortalBlockedActions.action.ToString())
            }
            if ($null -ne $currentCompanyPortalBlockedActions.ownerType)
            {
                $myCompanyPortalBlockedActions.Add('OwnerType', $currentCompanyPortalBlockedActions.ownerType.ToString())
            }
            if ($null -ne $currentCompanyPortalBlockedActions.platform)
            {
                $myCompanyPortalBlockedActions.Add('Platform', $currentCompanyPortalBlockedActions.platform.ToString())
            }
            if ($myCompanyPortalBlockedActions.values.Where({$null -ne $_}).Count -gt 0)
            {
                $complexCompanyPortalBlockedActions += $myCompanyPortalBlockedActions
            }
        }

        $complexLandingPageCustomizedImage = [ordered]@{}
        $complexLandingPageCustomizedImage.Add('Type', $landingPageCustomizedImageResponse.type)
        $complexLandingPageCustomizedImage.Add('Value', $landingPageCustomizedImageResponse.value)
        if ($complexLandingPageCustomizedImage.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexLandingPageCustomizedImage = $null
        }

        $complexLightBackgroundLogo = [ordered]@{}
        $complexLightBackgroundLogo.Add('Type', $lightBackgroundLogoResponse.type)
        $complexLightBackgroundLogo.Add('Value', $lightBackgroundLogoResponse.value)
        if ($complexLightBackgroundLogo.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexLightBackgroundLogo = $null
        }

        $complexThemeColor = [ordered]@{}
        $complexThemeColor.Add('B', $getValue.ThemeColor.b)
        $complexThemeColor.Add('G', $getValue.ThemeColor.g)
        $complexThemeColor.Add('R', $getValue.ThemeColor.r)
        if ($complexThemeColor.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexThemeColor = $null
        }

        $complexThemeColorLogo = [ordered]@{}
        $complexThemeColorLogo.Add('Type', $themeColorLogoResponse.type)
        $complexThemeColorLogo.Add('Value', $themeColorLogoResponse.value)
        if ($complexThemeColorLogo.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexThemeColorLogo = $null
        }
        #endregion

        #region resource generator code
        $enumEnrollmentAvailability = $null
        if ($null -ne $getValue.EnrollmentAvailability)
        {
            $enumEnrollmentAvailability = $getValue.EnrollmentAvailability.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            CompanyPortalBlockedActions               = $complexCompanyPortalBlockedActions
            ContactITEmailAddress                     = $getValue.ContactITEmailAddress
            ContactITName                             = $getValue.ContactITName
            ContactITNotes                            = $getValue.ContactITNotes
            ContactITPhoneNumber                      = $getValue.ContactITPhoneNumber
            CustomCanSeePrivacyMessage                = $getValue.CustomCanSeePrivacyMessage
            CustomCantSeePrivacyMessage               = $getValue.CustomCantSeePrivacyMessage
            #CustomPrivacyMessage                      = $getValue.CustomPrivacyMessage
            #DisableClientTelemetry                    = $getValue.DisableClientTelemetry
            DisableDeviceCategorySelection            = $getValue.DisableDeviceCategorySelection
            DisplayName                               = $getValue.DisplayName
            EnrollmentAvailability                    = $enumEnrollmentAvailability
            #IsFactoryResetDisabled                    = $getValue.IsFactoryResetDisabled
            #IsRemoveDeviceDisabled                    = $getValue.IsRemoveDeviceDisabled
            LandingPageCustomizedImage                = $complexLandingPageCustomizedImage
            LightBackgroundLogo                       = $complexLightBackgroundLogo
            OnlineSupportSiteName                     = $getValue.OnlineSupportSiteName
            OnlineSupportSiteUrl                      = $getValue.OnlineSupportSiteUrl
            PrivacyUrl                                = $getValue.PrivacyUrl
            ProfileDescription                        = $getValue.ProfileDescription
            ProfileName                               = $getValue.ProfileName
            RoleScopeTagIds                           = $getValue.RoleScopeTagIds
            #SendDeviceOwnershipChangePushNotification = $getValue.SendDeviceOwnershipChangePushNotification
            ShowAzureADEnterpriseApps                 = $getValue.ShowAzureADEnterpriseApps
            ShowConfigurationManagerApps              = $getValue.ShowConfigurationManagerApps
            ShowDisplayNameNextToLogo                 = $getValue.ShowDisplayNameNextToLogo
            ShowLogo                                  = $getValue.ShowLogo
            ShowOfficeWebApps                         = $getValue.ShowOfficeWebApps
            ThemeColor                                = $complexThemeColor
            ThemeColorLogo                            = $complexThemeColorLogo
            Id                                        = $getValue.Id
            Ensure                                    = 'Present'
            Credential                                = $Credential
            ApplicationId                             = $ApplicationId
            TenantId                                  = $TenantId
            ApplicationSecret                         = $ApplicationSecret
            CertificateThumbprint                     = $CertificateThumbprint
            ManagedIdentity                           = $ManagedIdentity.IsPresent
            #endregion
        }
        $assignmentsValues = Get-MgBetaDeviceManagementIntuneBrandingProfileAssignment -IntuneBrandingProfileId $Id
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

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CompanyPortalBlockedActions,

        [Parameter()]
        [System.String]
        $ContactITEmailAddress,

        [Parameter()]
        [System.String]
        $ContactITName,

        [Parameter()]
        [System.String]
        $ContactITNotes,

        [Parameter()]
        [System.String]
        $ContactITPhoneNumber,

        [Parameter()]
        [System.String]
        $CustomCanSeePrivacyMessage,

        [Parameter()]
        [System.String]
        $CustomCantSeePrivacyMessage,

        [Parameter()]
        [System.Boolean]
        $DisableDeviceCategorySelection,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateSet('availableWithPrompts','availableWithoutPrompts','unavailable')]
        [System.String]
        $EnrollmentAvailability,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LandingPageCustomizedImage,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LightBackgroundLogo,

        [Parameter()]
        [System.String]
        $OnlineSupportSiteName,

        [Parameter()]
        [System.String]
        $OnlineSupportSiteUrl,

        [Parameter()]
        [System.String]
        $PrivacyUrl,

        [Parameter()]
        [System.String]
        $ProfileDescription,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ProfileName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $ShowAzureADEnterpriseApps,

        [Parameter()]
        [System.Boolean]
        $ShowConfigurationManagerApps,

        [Parameter()]
        [System.Boolean]
        $ShowDisplayNameNextToLogo,

        [Parameter()]
        [System.Boolean]
        $ShowLogo,

        [Parameter()]
        [System.Boolean]
        $ShowOfficeWebApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ThemeColor,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ThemeColorLogo,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

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

    Write-Verbose -Message "Setting configuration of the Intune Customization Branding Profile with Id {$Id} and ProfileName {$ProfileName}"

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
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Customization Branding Profile with ProfileName {$ProfileName}"
        $boundParameters.Remove("Assignments") | Out-Null

        $createParameters = ([Hashtable]$boundParameters).Clone()
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$createParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $createParameters.$key -and $createParameters.$key.GetType().Name -like '*CimInstance*')
            {
                $createParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $createParameters.$key
            }
        }
        #region resource generator code
        $policy = New-MgBetaDeviceManagementIntuneBrandingProfile -BodyParameter $createParameters

        # Some properties cannot be set during creation
        # Wait a few seconds for the policy to be created
        Start-Sleep -Seconds 3
        Update-MgBetaDeviceManagementIntuneBrandingProfile `
            -IntuneBrandingProfileId $policy.Id `
            -BodyParameter $createParameters

        if ($policy.Id)
        {
            $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceConfigurationPolicyAssignment `
                -DeviceConfigurationPolicyId $policy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/intuneBrandingProfiles'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Customization Branding Profile with Id {$($currentInstance.Id)}"
        $boundParameters.Remove("Assignments") | Out-Null

        $updateParameters = ([Hashtable]$boundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters
        $updateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$updateParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $updateParameters.$key -and $updateParameters.$key.GetType().Name -like '*CimInstance*')
            {
                $updateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $updateParameters.$key
            }
        }

        #region resource generator code
        Update-MgBetaDeviceManagementIntuneBrandingProfile `
            -IntuneBrandingProfileId $currentInstance.Id `
            -BodyParameter $updateParameters

        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/intuneBrandingProfiles'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Customization Branding Profile with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceManagementIntuneBrandingProfile -IntuneBrandingProfileId $currentInstance.Id
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CompanyPortalBlockedActions,

        [Parameter()]
        [System.String]
        $ContactITEmailAddress,

        [Parameter()]
        [System.String]
        $ContactITName,

        [Parameter()]
        [System.String]
        $ContactITNotes,

        [Parameter()]
        [System.String]
        $ContactITPhoneNumber,

        [Parameter()]
        [System.String]
        $CustomCanSeePrivacyMessage,

        [Parameter()]
        [System.String]
        $CustomCantSeePrivacyMessage,

        [Parameter()]
        [System.Boolean]
        $DisableDeviceCategorySelection,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateSet('availableWithPrompts','availableWithoutPrompts','unavailable')]
        [System.String]
        $EnrollmentAvailability,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LandingPageCustomizedImage,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LightBackgroundLogo,

        [Parameter()]
        [System.String]
        $OnlineSupportSiteName,

        [Parameter()]
        [System.String]
        $OnlineSupportSiteUrl,

        [Parameter()]
        [System.String]
        $PrivacyUrl,

        [Parameter()]
        [System.String]
        $ProfileDescription,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ProfileName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $ShowAzureADEnterpriseApps,

        [Parameter()]
        [System.Boolean]
        $ShowConfigurationManagerApps,

        [Parameter()]
        [System.Boolean]
        $ShowDisplayNameNextToLogo,

        [Parameter()]
        [System.Boolean]
        $ShowLogo,

        [Parameter()]
        [System.Boolean]
        $ShowOfficeWebApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ThemeColor,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ThemeColorLogo,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
                                         -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
                                         -IncludedProperties @('DisplayName')
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
        [array]$getValue = Get-MgBetaDeviceManagementIntuneBrandingProfile `
            -Filter $Filter `
            -All `
            -ErrorAction Stop
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
            if (-not [System.String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            elseif (-not [System.String]::IsNullOrEmpty($config.name))
            {
                $displayedKey = $config.name
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                ProfileName           = $config.ProfileName
                DisplayName           = $config.DisplayName
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
            if ($null -ne $Results.CompanyPortalBlockedActions)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.CompanyPortalBlockedActions `
                    -CIMInstanceName 'MicrosoftGraphcompanyPortalBlockedAction'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.CompanyPortalBlockedActions = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('CompanyPortalBlockedActions') | Out-Null
                }
            }
            if ($null -ne $Results.LandingPageCustomizedImage)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.LandingPageCustomizedImage `
                    -CIMInstanceName 'MicrosoftGraphMimeContent'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.LandingPageCustomizedImage = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('LandingPageCustomizedImage') | Out-Null
                }
            }
            if ($null -ne $Results.LightBackgroundLogo)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.LightBackgroundLogo `
                    -CIMInstanceName 'MicrosoftGraphMimeContent'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.LightBackgroundLogo = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('LightBackgroundLogo') | Out-Null
                }
            }
            if ($null -ne $Results.ThemeColor)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ThemeColor `
                    -CIMInstanceName 'MicrosoftGraphRgbColor'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ThemeColor = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ThemeColor') | Out-Null
                }
            }
            if ($null -ne $Results.ThemeColorLogo)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ThemeColorLogo `
                    -CIMInstanceName 'MicrosoftGraphMimeContent'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ThemeColorLogo = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ThemeColorLogo') | Out-Null
                }
            }

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
                -NoEscape @('Assignments', 'CompanyPortalBlockedActions', 'LandingPageCustomizedImage', 'LightBackgroundLogo', 'ThemeColor', 'ThemeColorLogo')
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
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
