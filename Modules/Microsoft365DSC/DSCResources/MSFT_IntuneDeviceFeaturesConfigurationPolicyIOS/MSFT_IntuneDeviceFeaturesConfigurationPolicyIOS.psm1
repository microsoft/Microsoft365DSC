
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
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceManagementApplicabilityRuleOsEdition,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceManagementApplicabilityRuleOsVersion,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceManagementApplicabilityRuleDeviceMode,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AirPrintDestinations,

        [Parameter()]
        [System.String]
        $AssetTagTemplate,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ContentFilterSettings,

        [Parameter()]
        [System.String]
        $LockScreenFootnote,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $HomeScreenDockIcons,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $HomeScreenPages,

        [Parameter()]
        [System.Int32]
        $HomeScreenGridWidth,

        [Parameter()]
        [System.Int32]
        $HomeScreenGridHeight,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NotificationSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $SingleSignOnSettings,

        [Parameter()]
        [ValidateSet("notConfigured", "lockScreen", "homeScreen", "lockAndHomeScreens")]
        [System.String]
        $WallpaperDisplayLocation,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $WallpaperImage,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IosSingleSignOnExtension,

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

    try
    {
        if (-not $Script:exportedInstance)
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

            if (-not [string]::IsNullOrWhiteSpace($Id))
            { 
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $Id -ErrorAction SilentlyContinue 
            }

            #region resource generator code
            if ($null -eq $getValue)
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -All -Filter "DisplayName eq '$Displayname'" -ErrorAction SilentlyContinue | Where-Object `
                -FilterScript { `
                    $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.iosDeviceFeaturesConfiguration' `
                }
            }
            #endregion

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "No Intune Device Features Policy for iOS with Id {$Id} was found"
                return $nullResult
            }

            $Id = $getValue.Id

            Write-Verbose -Message "An Intune Device Features Policy for iOS with id {$Id} and DisplayName {$DisplayName} was found"
        }
        else
        {
            $getValue = $Script:exportedInstance
        }

        $results = @{
            #region resource generator code
            Id                       = $getValue.Id
            Description              = $getValue.Description
            DisplayName              = $getValue.DisplayName
            Ensure                   = 'Present'
            Credential               = $Credential
            ApplicationId            = $ApplicationId
            TenantId                 = $TenantId
            ApplicationSecret        = $ApplicationSecret
            CertificateThumbprint    = $CertificateThumbprint
            Managedidentity          = $ManagedIdentity.IsPresent
            AccessTokens             = $AccessTokens
            AirPrintDestinations     = Convert-ComplexObjectToHashtableArray $getValue.AdditionalProperties.airPrintDestinations
            AssetTagTemplate         = $getValue.AdditionalProperties.assetTagTemplate
            ContentFilterSettings    = Convert-ComplexObjectToHashtableArray_ExportDataType $getValue.AdditionalProperties.contentFilterSettings
            LockScreenFootnote       = $getValue.AdditionalProperties.lockScreenFootnote
            HomeScreenDockIcons      = Convert-ComplexObjectToHashtableArray $getValue.AdditionalProperties.homeScreenDockIcons
            HomeScreenPages          = Convert-ComplexObjectToHashtableArray $getValue.AdditionalProperties.homeScreenPages
            HomeScreenGridWidth      = $getValue.AdditionalProperties.homeScreenGridWidth
            HomeScreenGridHeight     = $getValue.AdditionalProperties.homeScreenGridHeight
            NotificationSettings     = Convert-ComplexObjectToHashtableArray $getValue.AdditionalProperties.notificationSettings
            SingleSignOnSettings     = Convert-ComplexObjectToHashtableArray $getValue.AdditionalProperties.singleSignOnSettings
            WallpaperDisplayLocation = $getValue.AdditionalProperties.wallpaperDisplayLocation 
            WallpaperImage           = Convert-ComplexObjectToHashtableArray $getValue.AdditionalProperties.wallpaperImage
            IosSingleSignOnExtension = Convert-ComplexObjectToHashtableArray_ExportDataType $getValue.AdditionalProperties.iosSingleSignOnExtension
        }
                                          
        $assignmentsValues = Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $Results.Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment `
                                -IncludeDeviceFilter:$true `
                                -Assignments ($assignmentsValues)
        }
        $results.Add('Assignments', $assignmentResult)
        Write-Verbose -Message "Returning {$DisplayName}"
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
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceManagementApplicabilityRuleOsEdition,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceManagementApplicabilityRuleOsVersion,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceManagementApplicabilityRuleDeviceMode,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AirPrintDestinations,

        [Parameter()]
        [System.String]
        $AssetTagTemplate,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ContentFilterSettings,

        [Parameter()]
        [System.String]
        $LockScreenFootnote,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $HomeScreenDockIcons,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $HomeScreenPages,

        [Parameter()]
        [System.Int32]
        $HomeScreenGridWidth,

        [Parameter()]
        [System.Int32]
        $HomeScreenGridHeight,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NotificationSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $SingleSignOnSettings,

        [Parameter()]
        [ValidateSet("notConfigured", "lockScreen", "homeScreen", "lockAndHomeScreens")]
        [System.String]
        $WallpaperDisplayLocation,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $WallpaperImage,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IosSingleSignOnExtension,

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
    Write-Verbose -Message "Getting configuration of the Intune Device Features Configuration Policy for iOS with Id {$Id} and DisplayName {$DisplayName}"
    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters
    }
    catch
    {
        Write-Verbose -Message $_
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
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    $allTargetValues = Convert-M365DscHashtableToString -Hashtable $BoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Features Configuration Policy for iOS with DisplayName {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null
        $CreateParameters = ([Hashtable]$BoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null

        foreach ($key in ($CreateParameters.clone()).Keys)
        {
            if ($CreateParameters[$key].getType().Fullname -like '*CimInstance*')
            {
                $CreateParameters[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters[$key]
            }
        }
        
        #create params need some processing to get payload in correct format
        $CreateParameters.Add('@odata.type', '#microsoft.graph.iosDeviceFeaturesConfiguration') #add odata type or payload will be rejected
        if($CreateParameters.WallpaperImage)
        {
            $CreateParameters['WallpaperImage'] = $CreateParameters.WallpaperImage[0] #needs the hashtable not embedded in array
            $CreateParameters.WallpaperImage['value'] = [Convert]::FromBase64String($CreateParameters.WallpaperImage['value'])
        }
        if ($CreateParameters.HomeScreenPages)
        {
            foreach ($homeScreenPage in $CreateParameters.HomeScreenPages){
                foreach ($icon in $homeScreenPage.icons){
                    $icon.Add('@odata.type',"#microsoft.graph.iosHomeScreenApp")
                }
            }
        }
        if ($CreateParameters.HomeScreenDockIcons)
        {
            foreach ($homeScreenDockIcon in $CreateParameters.HomeScreenDockIcons){
                $homeScreenDockIcon.Add('@odata.type',"#microsoft.graph.iosHomeScreenApp")
            }
        }
        if ($CreateParameters.ContentFilterSettings)
        {
            Convert-DataTypeFormat $CreateParameters.ContentFilterSettings
            $CreateParameters['ContentFilterSettings'] = $CreateParameters.ContentFilterSettings[0] #needs the hashtable not embedded in array
        }
        if ($CreateParameters.SingleSignOnSettings)
        {
            $CreateParameters['SingleSignOnSettings'] = $CreateParameters.SingleSignOnSettings[0] #needs the hashtable not embedded in array
        }
        if ($CreateParameters.IosSingleSignOnExtension)
        {
            Convert-DataTypeFormat $CreateParameters.IosSingleSignOnExtension 
            if ($null -ne $CreateParameters.IosSingleSignOnExtension.configurations)
            {
                Convert-StringToBooleans $CreateParameters.IosSingleSignOnExtension.configurations
            }
            $CreateParameters['iosSingleSignOnExtension'] = $CreateParameters.IosSingleSignOnExtension[0] #needs the hashtable not embedded in array
        }
        #finished processing create parameters 
           
        #region resource generator code
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments

        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceConfigurations'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating {$DisplayName}"

        $BoundParameters.Remove('Assignments') | Out-Null
        $UpdateParameters = ([Hashtable]$BoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters
        $UpdateParameters.Remove('Id') | Out-Null
        
        foreach ($key in ($UpdateParameters.clone()).Keys)
        {
            if ($UpdateParameters[$key].getType().Fullname -like '*CimInstance*')
            {
            Write-Verbose -Message "Converting CIM {$UpdateParameters[$key]}"
                $UpdateParameters[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters[$key]
            }
        }

        #update params need some processing to get payload in correct format
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.iosDeviceFeaturesConfiguration') #add odata type or payload will be rejected
        if($UpdateParameters.WallpaperImage)
        {
            $UpdateParameters['WallpaperImage'] = $UpdateParameters.WallpaperImage[0] #needs the hashtable not embedded in array
            $UpdateParameters.WallpaperImage['value'] = [Convert]::FromBase64String($UpdateParameters.WallpaperImage['value'])
        }
        if ($UpdateParameters.HomeScreenPages)
        {
            foreach ($homeScreenPage in $UpdateParameters.HomeScreenPages){
                foreach ($icon in $homeScreenPage.icons){
                    $icon.Add('@odata.type',"#microsoft.graph.iosHomeScreenApp")
                }
            }
        }
        if ($UpdateParameters.HomeScreenDockIcons)
        {
            foreach ($homeScreenDockIcon in $UpdateParameters.HomeScreenDockIcons){
                $homeScreenDockIcon.Add('@odata.type',"#microsoft.graph.iosHomeScreenApp")
            }
        }
        if ($UpdateParameters.ContentFilterSettings)
        {
            Convert-DataTypeFormat $UpdateParameters.ContentFilterSettings
            $UpdateParameters['ContentFilterSettings'] = $UpdateParameters.ContentFilterSettings[0] #needs the hashtable not embedded in array
        }
        if ($UpdateParameters.SingleSignOnSettings)
        {
            $UpdateParameters['SingleSignOnSettings'] = $UpdateParameters.SingleSignOnSettings[0] #needs the hashtable not embedded in array
        }
        if ($UpdateParameters.IosSingleSignOnExtension)
        {
            Convert-DataTypeFormat $UpdateParameters.IosSingleSignOnExtension 
            if ($null -ne $UpdateParameters.IosSingleSignOnExtension.configurations)
            {
                Convert-StringToBooleans $UpdateParameters.IosSingleSignOnExtension.configurations
            }
            $UpdateParameters['IosSingleSignOnExtension'] = $UpdateParameters.IosSingleSignOnExtension[0] #needs the hashtable not embedded in array
        }
        #finished processing update parameters 

        #region resource generator code
        Update-MgBetaDeviceManagementDeviceConfiguration  -BodyParameter $UpdateParameters `
            -DeviceConfigurationId $currentInstance.Id
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceConfigurations'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing {$DisplayName}"
        #region resource generator code
        Remove-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $currentInstance.Id
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
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceManagementApplicabilityRuleOsEdition,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceManagementApplicabilityRuleOsVersion,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DeviceManagementApplicabilityRuleDeviceMode,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AirPrintDestinations,

        [Parameter()]
        [System.String]
        $AssetTagTemplate,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ContentFilterSettings,

        [Parameter()]
        [System.String]
        $LockScreenFootnote,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $HomeScreenDockIcons,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $HomeScreenPages,

        [Parameter()]
        [System.Int32]
        $HomeScreenGridWidth,

        [Parameter()]
        [System.Int32]
        $HomeScreenGridHeight,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NotificationSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $SingleSignOnSettings,

        [Parameter()]
        [ValidateSet("notConfigured", "lockScreen", "homeScreen", "lockAndHomeScreens")]
        [System.String]
        $WallpaperDisplayLocation,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $WallpaperImage,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IosSingleSignOnExtension,

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

    Write-Verbose -Message "Testing configuration of {$Id}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -ne $Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key

        if ($source.GetType().Name -like '*CimInstance*')
        {
            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-not $testResult) { break }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.Remove('Id') | Out-Null
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    #Convert any DateTime to String
    foreach ($key in $ValuesToCheck.Keys)
    {
        if (($null -ne $CurrentValues[$key]) `
                -and ($CurrentValues[$key].getType().Name -eq 'DateTime'))
        {
            $CurrentValues[$key] = $CurrentValues[$key].toString()
        }
    }

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
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
        [array]$getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter $Filter -All `
            -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.iosDeviceFeaturesConfiguration'  `
        }
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $getValue)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($getValue.Count)] $($config.DisplayName)" -NoNewline
            $params = @{
                Id                    = $config.id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
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
            
            if ($null -ne $Results.airPrintDestinations)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.AirPrintDestinations `
                    -CIMInstanceName 'MSFT_airPrintDestination' 
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.AirPrintDestinations = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AirPrintDestinations') | Out-Null
                }
            }
            
            if ($null -ne $Results.ContentFilterSettings)
            {
                $complexMapping = @(
                    @{
                        Name = 'websiteList'
                        CimInstanceName = 'iosWebContentFilterBase'
                        IsRequired = $false
                    }
                    @{
                        Name = 'specificWebsitesOnly'
                        CimInstanceName = 'iosWebContentFilterBase'
                        IsRequired = $false
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ContentFilterSettings `
                    -CIMInstanceName 'MSFT_iosWebContentFilterSpecificWebsitesAccess' `
                    -ComplexTypeMapping $complexMapping
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ContentFilterSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('contentFilterSettings') | Out-Null
                }
            }
            
            if ($null -ne $Results.HomeScreenDockIcons)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.HomeScreenDockIcons `
                    -CIMInstanceName 'MSFT_iosHomeScreenApp' 
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.HomeScreenDockIcons = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('HomeScreenDockIcons') | Out-Null
                }
            }

            if ($null -ne $Results.HomeScreenPages)
            {
                $complexMapping = @(
                    @{
                        Name = 'icons'
                        CimInstanceName = 'iosHomeScreenApp'
                        IsRequired = $false
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.HomeScreenPages `
                    -CIMInstanceName 'MSFT_iosHomeScreenItem' `
                    -ComplexTypeMapping $complexMapping
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.HomeScreenPages = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('HomeScreenPages') | Out-Null
                }
            }

            if ($null -ne $Results.WallpaperImage)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.WallpaperImage `
                    -CIMInstanceName 'MSFT_mimeContent' 
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.WallpaperImage = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('WallpaperImage') | Out-Null
                }
            }
            
            if ($null -ne $Results.IosSingleSignOnExtension)
            {
                $complexMapping = @(
                    @{
                        Name = 'configurations'
                        CimInstanceName = 'keyTypedValuePair'
                        IsRequired = $false
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.IosSingleSignOnExtension `
                    -CIMInstanceName 'MSFT_iosSingleSignOnExtension' `
                    -ComplexTypeMapping $complexMapping
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.IosSingleSignOnExtension = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('IosSingleSignOnExtension') | Out-Null
                }
            }

            if ($null -ne $Results.NotificationSettings)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.NotificationSettings `
                    -CIMInstanceName 'MSFT_iosNotificationSettings' 
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.NotificationSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('NotificationSettings') | Out-Null
                }
            }

            if ($null -ne $Results.SingleSignOnSettings)
            {
                $complexMapping = @(
                    @{
                        Name = 'allowedAppsList'
                        CimInstanceName = 'appListItem'
                        IsRequired = $false
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.SingleSignOnSettings `
                    -CIMInstanceName 'MSFT_iosSingleSignOnSettings' `
                    -ComplexTypeMapping $complexMapping
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.SingleSignOnSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('SingleSignOnSettings') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Assignments', 'AirPrintDestinations', 'ContentFilterSettings', 'HomeScreenDockIcons', 'HomeScreenPages', 'WallpaperImage', 'IosSingleSignOnExtension', 'NotificationSettings', 'SingleSignOnSettings')

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
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
        $_.Exception -like "*Request not applicable to target tenant*")
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

function Convert-ComplexObjectToHashtableArray {
    param (
        [Parameter()]
        [Object]$InputObject
        
    )

    $resultArray = @()

    foreach ($item in $InputObject) {
        $hashTable = @{}
        
        foreach ($key in $item.Keys) {
            $keyValue = $item.$key
            if ($key -ne '@odata.type')
            {
                if ($keyValue -is [array])
                {
                    $elementTypes = $keyValue | ForEach-Object { $_.GetType().Name }
                    if($elementTypes -contains 'Dictionary`2') #another embedded complex type, not a string array
                    {
                        $keyValue = Convert-ComplexObjectToHashtableArray $keyValue #recurse the function
                    }
                }
                $hashTable.Add($key, $keyValue)
            }
        }
        
        # Add the hash table to the result array only if it contains non-null values       
        if ($hashTable.Values.Where({ $null -ne $_ }).Count -gt 0) {
            $resultArray += $hashTable
        }
    }

    return ,$resultArray
}

function Convert-ComplexObjectToHashtableArray_ExportDataType {
    param (
        [Parameter()]
        [Object]$InputObject
        
    )

    $resultArray = @()

    foreach ($item in $InputObject) {
        $hashTable = @{}
        
        foreach ($key in $item.Keys) {
            $keyValue = $item.$key
            if ($key -ne '@odata.type')
            {
                if ($keyValue -is [array])
                {
                    $elementTypes = $keyValue | ForEach-Object { $_.GetType().Name }
                    if($elementTypes -contains 'Dictionary`2') #another embedded complex type, not a string array
                    {
                        $keyValue = Convert-ComplexObjectToHashtableArray_ExportDataType $keyValue #recurse the function
                    }
                }
                $hashTable.Add($key, $keyValue)
            }else{
                $hashTable.Add('dataType', $item.$key)
            }
        }
        
        # Add the hash table to the result array only if it contains non-null values       
        if ($hashTable.Values.Where({ $null -ne $_ }).Count -gt 0) {
            $resultArray += $hashTable
        }
    }

    return ,$resultArray
}

function Convert-StringToBooleans {
    param(
        [Parameter(Mandatory = $true)]
        [array]$Configurations
    )
    
    foreach ($config in $Configurations) {
        if ($config.ContainsKey("value")) {
            switch ($config.value) {
                "True"  { $config.value = $true }
                "False" { $config.value = $false }
            }
        }
    }
    return $Configurations
}

function Convert-DataTypeFormat {
    param (
        [Parameter()]
        [Object]$InputObject
    )
    foreach ($item in $InputObject) {        
        $keysToModify = @()
        $keysToRecurse = @()
        foreach ($key in $item.Keys) {
            if ($key -eq 'dataType') {
                $keysToModify += $key
            }
            if ($item.$key -is [array] -and ($item.$key | Where-Object { $_ -is [hashtable] }))
            {
            $keysToRecurse += $key
            } 
        }
        foreach ($key in $keysToModify) {
            
            $item['@odata.type'] = $item.$key
            $item.Remove($key)
        }
        foreach ($key in $keysToRecurse) {
            
            $item[$key] = Convert-DataTypeFormat $item.$key            
        }
    }
    return $InputObject
}

Export-ModuleMember -Function *-TargetResource
