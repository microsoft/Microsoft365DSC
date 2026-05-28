Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneMobileAppsBuiltInStoreApp'
$Script:androidExclusive = @('V4_0', 'V4_0_3', 'V4_1', 'V4_2', 'V4_3', 'V4_4', 'V5_0', 'V5_1', 'V6_0', 'V7_0', 'V7_1', 'V8_1')
$Script:iOSExclusive = @('V16_0', 'V17_0', 'V18_0')

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Android', 'IOS')]
        [System.String]
        $TargetPlatform,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ApplicableDeviceType,

        [Parameter()]
        [System.String]
        $AppStoreUrl,

        [Parameter()]
        [System.String]
        $BundleId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Developer,

        [Parameter()]
        [System.String]
        $InformationUrl,

        [Parameter()]
        [System.Boolean]
        $IsFeatured,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LargeIcon,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        $PrivacyInformationUrl,

        [Parameter()]
        [System.String]
        $Publisher,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Categories,

        [Parameter()]
        [System.String]
        $PackageId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MinimumSupportedOperatingSystem,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

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

    Write-Verbose -Message "Getting configuration for the Intune Mobile Apps Built In Store App with Id {$Id} and DisplayName {$DisplayName}"

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
                $getValue = Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $Id -ExpandProperty 'categories' -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Mobile Apps Built In Store App with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceAppManagementMobileApp `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")' and (isof('microsoft.graph.managedAndroidStoreApp') or isof('microsoft.graph.managedIOSStoreApp'))" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Mobile Apps Built In Store App with DisplayName {$DisplayName}."
                return $nullResult
            }

            $getValue = Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $getValue.Id -ExpandProperty 'categories'
        }
        else
        {
            $getValue = Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $Script:exportedInstance.Id `
                -ExpandProperty 'categories'
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Mobile Apps Built In Store App with Id {$Id} and DisplayName {$DisplayName} was found"

        #region resource generator code
        $complexCategories = @()
        foreach ($category in $getValue.Categories)
        {
            $myCategory = [ordered]@{}
            $myCategory.Add('Id', $category.id)
            $myCategory.Add('DisplayName', $category.displayName)
            $complexCategories += $myCategory
        }
        $complexLargeIcon = $null
        if ($null -ne $getValue.LargeIcon.Value)
        {
            $complexLargeIcon = [ordered]@{}
            $complexLargeIcon.Add('Type', $getValue.LargeIcon.Type)
            $complexLargeIcon.Add('Value', $getValue.LargeIcon.Value)
        }
        $complexApplicableDeviceType = [ordered]@{}
        $complexApplicableDeviceType.Add('IPad', $getValue.applicableDeviceType.iPad)
        $complexApplicableDeviceType.Add('IPhoneAndIPod', $getValue.applicableDeviceType.iPhoneAndIPod)
        if ($complexApplicableDeviceType.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexApplicableDeviceType = $null
        }

        $complexMinimumSupportedOperatingSystem = [ordered]@{}
        $complexMinimumSupportedOperatingSystem.Add('V4_0', $getValue.minimumSupportedOperatingSystem.v4_0)
        $complexMinimumSupportedOperatingSystem.Add('V4_0_3', $getValue.minimumSupportedOperatingSystem.v4_0_3)
        $complexMinimumSupportedOperatingSystem.Add('V4_1', $getValue.minimumSupportedOperatingSystem.v4_1)
        $complexMinimumSupportedOperatingSystem.Add('V4_2', $getValue.minimumSupportedOperatingSystem.v4_2)
        $complexMinimumSupportedOperatingSystem.Add('V4_3', $getValue.minimumSupportedOperatingSystem.v4_3)
        $complexMinimumSupportedOperatingSystem.Add('V4_4', $getValue.minimumSupportedOperatingSystem.v4_4)
        $complexMinimumSupportedOperatingSystem.Add('V5_0', $getValue.minimumSupportedOperatingSystem.v5_0)
        $complexMinimumSupportedOperatingSystem.Add('V5_1', $getValue.minimumSupportedOperatingSystem.v5_1)
        $complexMinimumSupportedOperatingSystem.Add('V6_0', $getValue.minimumSupportedOperatingSystem.v6_0)
        $complexMinimumSupportedOperatingSystem.Add('V7_0', $getValue.minimumSupportedOperatingSystem.v7_0)
        $complexMinimumSupportedOperatingSystem.Add('V7_1', $getValue.minimumSupportedOperatingSystem.v7_1)
        $complexMinimumSupportedOperatingSystem.Add('V8_0', $getValue.minimumSupportedOperatingSystem.v8_0)
        $complexMinimumSupportedOperatingSystem.Add('V8_1', $getValue.minimumSupportedOperatingSystem.v8_1)
        $complexMinimumSupportedOperatingSystem.Add('V9_0', $getValue.minimumSupportedOperatingSystem.v9_0)
        $complexMinimumSupportedOperatingSystem.Add('V10_0', $getValue.minimumSupportedOperatingSystem.v10_0)
        $complexMinimumSupportedOperatingSystem.Add('V11_0', $getValue.minimumSupportedOperatingSystem.v11_0)
        $complexMinimumSupportedOperatingSystem.Add('V12_0', $getValue.minimumSupportedOperatingSystem.v12_0)
        $complexMinimumSupportedOperatingSystem.Add('V13_0', $getValue.minimumSupportedOperatingSystem.v13_0)
        $complexMinimumSupportedOperatingSystem.Add('V14_0', $getValue.minimumSupportedOperatingSystem.v14_0)
        $complexMinimumSupportedOperatingSystem.Add('V15_0', $getValue.minimumSupportedOperatingSystem.v15_0)
        $complexMinimumSupportedOperatingSystem.Add('V16_0', $getValue.minimumSupportedOperatingSystem.v16_0)
        $complexMinimumSupportedOperatingSystem.Add('V17_0', $getValue.minimumSupportedOperatingSystem.v17_0)
        $complexMinimumSupportedOperatingSystem.Add('V18_0', $getValue.minimumSupportedOperatingSystem.v18_0)
        if ($complexMinimumSupportedOperatingSystem.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexMinimumSupportedOperatingSystem = $null
        }
        #endregion

        $results = @{
            #region resource generator code
            ApplicableDeviceType            = $complexApplicableDeviceType
            AppStoreUrl                     = $getValue.appStoreUrl
            BundleId                        = $getValue.bundleId
            Categories                      = $complexCategories
            Description                     = $getValue.Description
            Developer                       = $getValue.Developer
            DisplayName                     = $getValue.DisplayName
            InformationUrl                  = $getValue.InformationUrl
            IsFeatured                      = $getValue.IsFeatured
            LargeIcon                       = $complexLargeIcon
            MinimumSupportedOperatingSystem = $complexMinimumSupportedOperatingSystem
            Notes                           = $getValue.Notes
            Owner                           = $getValue.Owner
            PackageId                       = $getValue.packageId
            PrivacyInformationUrl           = $getValue.PrivacyInformationUrl
            Publisher                       = $getValue.Publisher
            RoleScopeTagIds                 = $getValue.RoleScopeTagIds
            TargetPlatform                  = $getValue.'@odata.type'.Replace('#microsoft.graph.managed', '').Replace('StoreApp', '')
            Id                              = $getValue.Id
            Ensure                          = 'Present'
            Credential                      = $Credential
            ApplicationId                   = $ApplicationId
            TenantId                        = $TenantId
            ApplicationSecret               = $ApplicationSecret
            CertificateThumbprint           = $CertificateThumbprint
            CertificatePath                 = $CertificatePath
            CertificatePassword             = $CertificatePassword
            ManagedIdentity                 = $ManagedIdentity.IsPresent
            #endregion
        }
        $assignmentsValues = Get-MgBetaDeviceAppManagementMobileAppAssignment -MobileAppId $Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntuneMobileAppAssignment -Assignments $assignmentsValues -IncludeDeviceFilter $true
        }
        foreach ($assignment in $assignmentResult)
        {
            if ($null -ne $assignment.assignmentSettings -and $null -ne $assignment.assignmentSettings.vpnConfigurationId)
            {
                $vpnConfiguration = Get-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $assignment.assignmentSettings.vpnConfigurationId -Property 'DisplayName' -ErrorAction SilentlyContinue
                if ($null -ne $vpnConfiguration)
                {
                    $assignment.assignmentSettings.vpnConfigurationId = $vpnConfiguration.DisplayName
                }
            }
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
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Android', 'IOS')]
        [System.String]
        $TargetPlatform,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ApplicableDeviceType,

        [Parameter()]
        [System.String]
        $AppStoreUrl,

        [Parameter()]
        [System.String]
        $BundleId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Developer,

        [Parameter()]
        [System.String]
        $InformationUrl,

        [Parameter()]
        [System.Boolean]
        $IsFeatured,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LargeIcon,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        $PrivacyInformationUrl,

        [Parameter()]
        [System.String]
        $Publisher,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Categories,

        [Parameter()]
        [System.String]
        $PackageId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MinimumSupportedOperatingSystem,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

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

    Write-Verbose -Message "Setting configuration of the Intune Mobile Apps Built In Store App with Id {$Id} and DisplayName {$DisplayName}"

    if ($PSBoundParameters.ContainsKey('ApplicableDeviceType') -and $PSBoundParameters.TargetPlatform -ne 'iOS')
    {
        throw 'ApplicableDeviceType is only applicable for iOS Store Apps.'
    }

    if ($PSBoundParameters.ContainsKey('BundleId') -and $PSBoundParameters.TargetPlatform -ne 'iOS')
    {
        throw 'BundleId is only applicable for iOS Store Apps.'
    }

    if ($PSBoundParameters.ContainsKey('MinimumSupportedOperatingSystem'))
    {
        foreach ($keyValuePair in $PSBoundParameters.MinimumSupportedOperatingSystem.CimInstanceProperties.GetEnumerator())
        {
            if ($keyValuePair.Key -in $Script:androidExclusive -and $TargetPlatform -ne 'Android')
            {
                throw "MinimumSupportedOperatingSystem.$($keyValuePair.Key) is only applicable for Android Store Apps."
            }
            if ($keyValuePair.Key -in $Script:iOSExclusive -and $TargetPlatform -ne 'IOS')
            {
                throw "MinimumSupportedOperatingSystem.$($keyValuePair.Key) is only applicable for iOS Store Apps."
            }
        }
    }

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

    foreach ($assignment in $Assignments)
    {
        if ($null -ne $assignment.assignmentSettings -and -not [System.String]::IsNullOrEmpty($assignment.assignmentSettings.vpnConfigurationId))
        {
            if (-not [System.Guid]::TryParse($assignment.assignmentSettings.vpnConfigurationId, [ref][System.Guid]::Empty))
            {
                [array]$vpnConfiguration = Get-MgBetaDeviceManagementDeviceConfiguration -All -Filter "displayName eq '$($assignment.assignmentSettings.vpnConfigurationId)'" | Where-Object {
                    $_.'@odata.type' -like "#microsoft.graph.*VpnConfiguration"
                }
                if ($null -eq $vpnConfiguration -or $vpnConfiguration.Count -eq 0)
                {
                    throw "Could not find a VPN Configuration Policy with DisplayName '$($assignment.assignmentSettings.vpnConfigurationId)'."
                }
                $assignment.assignmentSettings.vpnConfigurationId = $vpnConfiguration.Id
            }
        }
    }

    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $boundParameters.Remove('Categories') | Out-Null
    $boundParameters.Remove('TargetPlatform') | Out-Null

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Mobile Apps Built In Store App with DisplayName {$DisplayName}"
        $boundParameters.Remove('Assignments') | Out-Null

        $createParameters = ([Hashtable]$boundParameters).Clone()
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('Id') | Out-Null

        #region resource generator code
        $createParameters.Add('@odata.type', "#microsoft.graph.managed$($TargetPlatform)StoreApp")
        $policy = Invoke-MgGraphRequest -Method POST -Uri '/beta/deviceAppManagement/mobileApps' -Body $($createParameters | ConvertTo-Json -Depth 10)

        if ($PSBoundParameters.ContainsKey('Categories'))
        {
            Update-DeviceAppManagementAppCategory -App $policy -Categories $Categories
        }

        if ($policy.Id)
        {
            $assignmentsHash = ConvertTo-IntuneMobileAppAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceAppManagementPolicyAssignment `
                -AppManagementPolicyId $policy.Id `
                -Assignments $assignmentsHash
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Mobile Apps Built In Store App with Id {$($currentInstance.Id)}"
        $boundParameters.Remove('AppStoreUrl') | Out-Null
        $boundParameters.Remove('Assignments') | Out-Null

        $updateParameters = ([Hashtable]$boundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters
        $updateParameters.Remove('Id') | Out-Null

        #region resource generator code
        $updateParameters.Add('@odata.type', "#microsoft.graph.managed$($TargetPlatform)StoreApp")
        Invoke-MgGraphRequest -Method PATCH -Uri "/beta/deviceAppManagement/mobileApps/$($currentInstance.Id)" -Body $($updateParameters | ConvertTo-Json -Depth 10)

        if ($PSBoundParameters.ContainsKey('Categories'))
        {
            Update-DeviceAppManagementAppCategory -App $currentInstance -Categories $Categories -Compare
        }

        $assignmentsHash = ConvertTo-IntuneMobileAppAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceAppManagementPolicyAssignment `
            -AppManagementPolicyId $currentInstance.Id `
            -Assignments $assignmentsHash
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Mobile Apps Built In Store App with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceAppManagementMobileApp -MobileAppId $currentInstance.Id
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
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Android', 'IOS')]
        [System.String]
        $TargetPlatform,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ApplicableDeviceType,

        [Parameter()]
        [System.String]
        $AppStoreUrl,

        [Parameter()]
        [System.String]
        $BundleId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Developer,

        [Parameter()]
        [System.String]
        $InformationUrl,

        [Parameter()]
        [System.Boolean]
        $IsFeatured,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LargeIcon,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        $PrivacyInformationUrl,

        [Parameter()]
        [System.String]
        $Publisher,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Categories,

        [Parameter()]
        [System.String]
        $PackageId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MinimumSupportedOperatingSystem,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

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

    if ($PSBoundParameters.ContainsKey('ApplicableDeviceType') -and $PSBoundParameters.TargetPlatform -ne 'iOS')
    {
        throw 'ApplicableDeviceType is only applicable for iOS Store Apps.'
    }

    if ($PSBoundParameters.ContainsKey('BundleId') -and $PSBoundParameters.TargetPlatform -ne 'iOS')
    {
        throw 'BundleId is only applicable for iOS Store Apps.'
    }

    if ($PSBoundParameters.ContainsKey('MinimumSupportedOperatingSystem'))
    {
        foreach ($keyValuePair in $PSBoundParameters.MinimumSupportedOperatingSystem.CimInstanceProperties.GetEnumerator())
        {
            if ($keyValuePair.Key -in $Script:androidExclusive -and $TargetPlatform -ne 'Android')
            {
                throw "MinimumSupportedOperatingSystem.$($keyValuePair.Key) is only applicable for Android Store Apps."
            }
            if ($keyValuePair.Key -in $Script:iOSExclusive -and $TargetPlatform -ne 'IOS')
            {
                throw "MinimumSupportedOperatingSystem.$($keyValuePair.Key) is only applicable for iOS Store Apps."
            }
        }
    }

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
        $baseFilter = "isof('microsoft.graph.managedIOSStoreApp') or isof('microsoft.graph.managedAndroidStoreApp')"
        if (-not [System.String]::IsNullOrEmpty($Filter))
        {
            $Filter = "($Filter) and ($baseFilter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = Get-MgBetaDeviceAppManagementMobileApp `
            -Filter $Filter `
            -All `
            -ErrorAction Stop
        #endregion

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
                DisplayName           = $config.DisplayName
                TargetPlatform        = $config.'@odata.type'.Replace('#microsoft.graph.managed', '').Replace('StoreApp', '')
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

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            if ($null -ne $Results.ApplicableDeviceType)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ApplicableDeviceType `
                    -CIMInstanceName 'MicrosoftGraphiosDeviceType'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ApplicableDeviceType = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ApplicableDeviceType') | Out-Null
                }
            }
            if ($null -ne $Results.Categories)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Categories `
                    -CIMInstanceName 'DeviceManagementMobileAppCategory'

                if (-not [System.String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Categories = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Categories') | Out-Null
                }
            }
            if ($null -ne $Results.MinimumSupportedOperatingSystem)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.MinimumSupportedOperatingSystem `
                    -CIMInstanceName 'MicrosoftGraphMinimumOperatingSystem'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.MinimumSupportedOperatingSystem = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MinimumSupportedOperatingSystem') | Out-Null
                }
            }

            if ($null -ne $Results.LargeIcon)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.LargeIcon `
                    -CIMInstanceName 'DeviceManagementMimeContent'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.LargeIcon = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('LargeIcon') | Out-Null
                }
            }

            if ($Results.Assignments)
            {
                $complexMapping = @(
                    @{
                        Name            = 'AssignmentSettings'
                        CIMInstanceName = 'DeviceManagementBuiltInStoreAppAssignmentSettings'
                        IsRequired      = $false
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Assignments `
                    -CIMInstanceName DeviceManagementBuiltInStoreAppAssignment `
                    -ComplexTypeMapping $complexMapping
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
                -NoEscape @('Assignments', 'ApplicableDeviceType', 'Categories', 'LargeIcon', 'MinimumSupportedOperatingSystem')
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

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        ExcludedProperties = @('AppStoreUrl', 'TargetPlatform')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
