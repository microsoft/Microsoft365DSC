Confirm-M365DSCModuleDependency -ModuleName "MSFT_IntuneMobileAppsLobAppAndroid"

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

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MinimumSupportedOperatingSystem,

        [Parameter()]
        [System.String]
        $PackageId,

        [Parameter()]
        [ValidateSet('androidDeviceAdministrator','androidOpenSourceProject')]
        [System.String]
        $TargetedPlatforms,

        [Parameter()]
        [System.String]
        $FileName,

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
        [System.String[]]
        $RoleScopeTagIds,

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

    Write-Verbose -Message "Getting configuration for the Intune Mobile Apps Lob App for Android with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {

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

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $getValue = $null

            #region resource generator code
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $Id -ExpandProperty 'Categories' -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Mobile Apps Lob App for Android with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceAppManagementMobileApp `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")' and isof('microsoft.graph.androidLobApp')" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Mobile Apps Lob App for Android with DisplayName {$DisplayName}."
                return $nullResult
            }
            $getValue = Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $getValue.Id -ExpandProperty 'Categories'
        }
        else
        {
            $getValue = Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $Id -ExpandProperty 'Categories'
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Mobile Apps Lob App for Android with Id {$Id} and DisplayName {$DisplayName} was found"

        #region resource generator code
        $complexCategories = @()
        foreach ($category in $getValue.Categories)
        {
            $myCategory = [ordered]@{}
            $myCategory.Add('Id', $category.id)
            $myCategory.Add('DisplayName', $category.displayName)
            $complexCategories += $myCategory
        }

        $complexMinimumSupportedOperatingSystem = [ordered]@{}
        $complexMinimumSupportedOperatingSystem.Add('V4_0', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v4_0)
        $complexMinimumSupportedOperatingSystem.Add('V4_0_3', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v4_0_3)
        $complexMinimumSupportedOperatingSystem.Add('V4_1', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v4_1)
        $complexMinimumSupportedOperatingSystem.Add('V4_2', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v4_2)
        $complexMinimumSupportedOperatingSystem.Add('V4_3', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v4_3)
        $complexMinimumSupportedOperatingSystem.Add('V4_4', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v4_4)
        $complexMinimumSupportedOperatingSystem.Add('V5_0', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v5_0)
        $complexMinimumSupportedOperatingSystem.Add('V5_1', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v5_1)
        $complexMinimumSupportedOperatingSystem.Add('V6_0', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v6_0)
        $complexMinimumSupportedOperatingSystem.Add('V7_0', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v7_0)
        $complexMinimumSupportedOperatingSystem.Add('V7_1', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v7_1)
        $complexMinimumSupportedOperatingSystem.Add('V8_0', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v8_0)
        $complexMinimumSupportedOperatingSystem.Add('V8_1', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v8_1)
        $complexMinimumSupportedOperatingSystem.Add('V9_0', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v9_0)
        $complexMinimumSupportedOperatingSystem.Add('V10_0', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v10_0)
        $complexMinimumSupportedOperatingSystem.Add('V11_0', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v11_0)
        $complexMinimumSupportedOperatingSystem.Add('V12_0', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v12_0)
        $complexMinimumSupportedOperatingSystem.Add('V13_0', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v13_0)
        $complexMinimumSupportedOperatingSystem.Add('V14_0', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v14_0)
        $complexMinimumSupportedOperatingSystem.Add('V15_0', $getValue.AdditionalProperties.minimumSupportedOperatingSystem.v15_0)
        if ($complexMinimumSupportedOperatingSystem.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexMinimumSupportedOperatingSystem = $null
        }

        $complexLargeIcon = $null
        if ($null -ne $getValue.LargeIcon.Value)
        {
            $complexLargeIcon = [ordered]@{}
            $complexLargeIcon.Add('Type', $getValue.LargeIcon.Type)
            $complexLargeIcon.Add('Value', [System.Convert]::ToBase64String($getValue.LargeIcon.Value))
        }
        #endregion

        #region resource generator code
        $enumTargetedPlatforms = $null
        if ($null -ne $getValue.AdditionalProperties.targetedPlatforms)
        {
            $enumTargetedPlatforms = $getValue.AdditionalProperties.targetedPlatforms.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            Categories                      = $complexCategories;
            MinimumSupportedOperatingSystem = $complexMinimumSupportedOperatingSystem
            PackageId                       = $getValue.AdditionalProperties.packageId
            TargetedPlatforms               = $enumTargetedPlatforms
            FileName                        = $getValue.AdditionalProperties.fileName
            Description                     = $getValue.Description
            Developer                       = $getValue.Developer
            DisplayName                     = $getValue.DisplayName
            InformationUrl                  = $getValue.InformationUrl
            IsFeatured                      = $getValue.IsFeatured
            LargeIcon                       = $complexLargeIcon
            Notes                           = $getValue.Notes
            Owner                           = $getValue.Owner
            PrivacyInformationUrl           = $getValue.PrivacyInformationUrl
            Publisher                       = $getValue.Publisher
            RoleScopeTagIds                 = $getValue.RoleScopeTagIds
            Id                              = $getValue.Id
            Ensure                          = 'Present'
            Credential                      = $Credential
            ApplicationId                   = $ApplicationId
            TenantId                        = $TenantId
            ApplicationSecret               = $ApplicationSecret
            CertificateThumbprint           = $CertificateThumbprint
            ManagedIdentity                 = $ManagedIdentity.IsPresent
            #endregion
        }
        $assignmentsValues = Get-MgBetaDeviceAppManagementMobileAppAssignment -MobileAppId $Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntuneMobileAppAssignment -Assignments $assignmentsValues -IncludeDeviceFilter $true
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

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MinimumSupportedOperatingSystem,

        [Parameter()]
        [System.String]
        $PackageId,

        [Parameter()]
        [ValidateSet('androidDeviceAdministrator','androidOpenSourceProject')]
        [System.String]
        $TargetedPlatforms,

        [Parameter()]
        [System.String]
        $FileName,

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
        [System.String[]]
        $RoleScopeTagIds,

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

    Write-Verbose -Message "Setting configuration of the Intune Mobile Apps Lob App for Android with Id {$Id} and DisplayName {$DisplayName}"

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
    $boundParameters.Remove('Categories') | Out-Null

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Mobile Apps Lob App for Android with DisplayName {$DisplayName}"
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
        $createParameters.Add("@odata.type", "#microsoft.graph.androidLobApp")
        $createParameters.Add('versionCode', '20250000')
        $createParameters.Add('versionName', '1.0.0')
        $policy = Invoke-MgGraphRequest -Method POST -Uri "/beta/deviceAppManagement/mobileApps" -Body ($createParameters | ConvertTo-Json -Depth 10)

        Invoke-M365DSCIntuneMobileAppInitialUpload -AppId $policy.Id -OdataType "#microsoft.graph.androidLobApp" -FileExtension "apk"

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
        Write-Verbose -Message "Updating the Intune Mobile Apps Lob App for Android with Id {$($currentInstance.Id)}"
        $boundParameters.Remove("Assignments") | Out-Null

        $updateParameters = ([Hashtable]$boundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters

        $updateParameters.Remove('Id') | Out-Null
        $updateParameters.Remove('TargetedPlatforms') | Out-Null

        $keys = (([Hashtable]$updateParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $updateParameters.$key -and $updateParameters.$key.GetType().Name -like '*CimInstance*')
            {
                $updateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $updateParameters.$key
            }
        }

        #region resource generator code
        $updateParameters.Add("@odata.type", "#microsoft.graph.androidLobApp")
        Invoke-MgGraphRequest -Method PATCH -Uri "/beta/deviceAppManagement/mobileApps/$($currentInstance.Id)" -Body ($updateParameters | ConvertTo-Json -Depth 10)

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
        Write-Verbose -Message "Removing the Intune Mobile Apps Lob App for Android with Id {$($currentInstance.Id)}"
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

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MinimumSupportedOperatingSystem,

        [Parameter()]
        [System.String]
        $PackageId,

        [Parameter()]
        [ValidateSet('androidDeviceAdministrator','androidOpenSourceProject')]
        [System.String]
        $TargetedPlatforms,

        [Parameter()]
        [System.String]
        $FileName,

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
        [System.String[]]
        $RoleScopeTagIds,

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
                                         -ExcludedProperties @('TargetedPlatforms')
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
        $baseFilter = "isof('microsoft.graph.androidLobApp')"
        if (-not [String]::IsNullOrEmpty($Filter))
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
                    -CIMInstanceName 'MicrosoftGraphAndroidMinimumOperatingSystem'
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
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Assignments -CIMInstanceName DeviceManagementMobileAppAssignment
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
                -NoEscape @('Assignments', 'Categories', 'MinimumSupportedOperatingSystem', 'LargeIcon')
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

Export-ModuleMember -Function *-TargetResource
