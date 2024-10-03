function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region Intune resource parameters

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
        [System.String]
        $Developer,

        [Parameter()]
        [System.String]
        $InformationUrl,

        [Parameter()]
        [System.Boolean]
        $IsFeatured,

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
        [System.String]
        [ValidateSet('notPublished', 'processing','published')]
        $PublishingState,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Categories,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters | Out-Null

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
    try
    {
        $instance = Get-MgBetaDeviceAppManagementMobileApp `
            -Filter "(isof('microsoft.graph.macOSLobApp') and displayName eq '$DisplayName')" `
            -ExpandProperty "categories,assignments" `
            -ErrorAction SilentlyContinue

        if ($null -eq $instance)
        {
            Write-Verbose -Message "No Mobile app with DisplayName {$DisplayName} was found. Search with DisplayName."
            $instance = Get-MgBetaDeviceAppManagementMobileApp `
                -MobileAppId $Id `
                -ExpandProperty "categories,assignments" `
                -ErrorAction Stop
        }

        if ($null -eq $instance)
        {
            Write-Verbose -Message "No Mobile app with {$Id} was found."
            return $nullResult
        }

        Write-Verbose -Message "Found Mobile app with {$DisplayName}."

        $results = @{
            Id                    = $instance.Id
            Description           = $instance.Description
            Developer             = $instance.Developer
            DisplayName           = $instance.DisplayName
            InformationUrl        = $instance.InformationUrl
            IsFeatured            = $instance.IsFeatured
            Notes                 = $instance.Notes
            Owner                 = $instance.Owner
            PrivacyInformationUrl = $instance.PrivacyInformationUrl
            Publisher             = $instance.Publisher
            PublishingState       = $instance.PublishingState.ToString()
            RoleScopeTagIds       = $instance.RoleScopeTagIds

            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ApplicationSecret     = $ApplicationSecret
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }

        if($null -ne $instance.Categories)
        {
            $results.Add('Categories', $instance.Categories)
        }
        else {
            $results.Add('Categories', "")
        }

        $resultAssignments = @()
        $appAssignments = Get-MgBetaDeviceAppManagementMobileAppAssignment -MobileAppId $instance.Id
        if ($null -ne $appAssignments -and $appAssignments.count -gt 0)
        {
            $resultAssignments += ConvertFrom-IntuneMobileAppAssignment `
                                -IncludeDeviceFilter:$true `
                                -Assignments ($appAssignments)

            $results.Add('Assignments', $resultAssignments)
        }

        return [System.Collections.Hashtable] $results
    }
    catch
    {
        Write-Verbose -Message $_
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
        #region Intune resource parameters

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
        [System.String]
        $Developer,

        [Parameter()]
        [System.String]
        $InformationUrl,

        [Parameter()]
        [System.Boolean]
        $IsFeatured,

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
        [System.String]
        [ValidateSet('notPublished', 'processing','published')]
        $PublishingState,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Categories,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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
    $PSBoundParameters.Remove('Categories') | Out-Null
    $PSBoundParameters.Remove('Assignments') | Out-Null

    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $setParameters.remove('Id') | Out-Null
    $setParameters.remove('Ensure') | Out-Null
    $setParameters.remove('Categories') | Out-Null
    $setParameters.remove('Assignments') | Out-Null

    if($null -ne $Categories)
    {
        [System.Object[]]$categoriesValue = ConvertTo-M365DSCIntuneAppCategories -Categories $Categories
        $setParameters.Add('Categories', $categoriesValue)
    }

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $app = New-MgBetaDeviceAppManagementMobileApp @setParameters

        $assignmentsHash = ConvertTo-IntuneMobileAppAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        if ($app.id)
        {
            Update-MgBetaDeviceAppManagementMobileAppAssignment -MobileAppId $app.id `
                -Targets $assignmentsHash `
                -Repository 'deviceAppManagement/mobileAppAssignments'
        }
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Update-MgBetaDeviceAppManagementMobileApp -MobileAppId $currentInstance.Id @setParameters

        $assignmentsHash = ConvertTo-IntuneMobileAppAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        if ($app.id)
        {
            Update-MgBetaDeviceAppManagementMobileAppAssignment -MobileAppId $app.id `
                -Targets $assignmentsHash `
                -Repository 'deviceAppManagement/mobileAppAssignments'
        }
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Remove-MgBetaDeviceAppManagementMobileApp -MobileAppId $currentInstance.Id -Confirm:$false
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource parameters

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
        [System.String]
        $Developer,

        [Parameter()]
        [System.String]
        $InformationUrl,

        [Parameter()]
        [System.Boolean]
        $IsFeatured,

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
        [System.String]
        [ValidateSet('notPublished', 'processing','published')]
        $PublishingState,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Categories,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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

    Write-Verbose -Message "Testing configuration of Intune Mobile MacOS App: {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    if (-not (Test-M365DSCAuthenticationParameter -BoundParameters $CurrentValues))
    {
        Write-Verbose "An error occured in Get-TargetResource, the app {$displayName} will not be processed"
        throw "An error occured in Get-TargetResource, the app {$displayName} will not be processed. Refer to the event viewer logs for more information."
    }
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck
    $ValuesToCheck.Remove('Id') | Out-Null

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

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
        if ($source.getType().Name -like '*CimInstance*')
        {
            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = Get-MgBetaDeviceAppManagementMobileApp `
            -Filter "microsoft.graph.managedApp/appAvailability eq null" `
            -ExpandProperty "categories,assignments" `
            -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $Script:exportedInstances)
        {
            $displayedKey = $config.Id
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline
            $params = @{
                Id                    = $config.Id
                Description           = $config.Description
                Developer             = $config.Developer
                DisplayName           = $config.DisplayName
                InformationUrl        = $config.InformationUrl
                IsFeatured            = $config.IsFeatured
                Notes                 = $config.Notes
                Owner                 = $config.Owner
                PrivacyInformationUrl = $config.PrivacyInformationUrl
                Publisher             = $config.Publisher
                PublishingState       = $config.PublishingState.ToString()
                RoleScopeTagIds       = $config.RoleScopeTagIds
                # LargeIcon             = $config.LargeIcon
                # ChildApps             = $config.ChildApps

                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ApplicationSecret     = $ApplicationSecret
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @params

            if (-not (Test-M365DSCAuthenticationParameter -BoundParameters $Results))
            {
                Write-Verbose "An error occured in Get-TargetResource, the app {$($params.displayName)} will not be processed."
                throw "An error occured in Get-TargetResource, the app {$($params.displayName)} will not be processed. Refer to the event viewer logs for more information."
            }

            #region complex types

            if($null -eq $Results.Categories -or $Results.Categories.Count -eq 0)
            {
                $Results.Categories = $null
            }
            else
            {
                $Results.Categories = Get-M365DSCIntuneAppCategoriesAsString -Categories $Results.Categories
            }

            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ([Array]$Results.Assignments) -CIMInstanceName DeviceManagementMobileAppAssignment

                if ($complexTypeStringResult)
                {
                    $Results.Assignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Assignments') | Out-Null
                }
            }

            #endregion complex types

            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            #region complex types

            if ($null -ne $Results.Categories)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Categories'
            }

            if ($Results.Assignments)
            {
                $isCIMArray = $false
                if ($Results.Assignments.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$isCIMArray
            }

            #endregion complex types

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
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

#region Helper functions

function ConvertTo-M365DSCIntuneAppAssignmentSettings
{
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.ArrayList]
        $Settings
    )

    $result = @()
    foreach ($setting in $Settings)
    {
        $currentSetting = @{
            name  = $setting.odataType
            value = $setting.uninstallOnDeviceRemoval
        }
        $result += $currentSetting
    }

    return $result
}

function Get-M365DSCIntuneAppAssignmentSettingsAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $Settings
    )

    $StringContent = '@('
    $space = '                '
    $indent = '    '

    $i = 1
    foreach ($setting in $Settings)
    {
        if ($Settings.Count -gt 1)
        {
            $StringContent += "`r`n"
            $StringContent += "$space"
        }

        $StringContent += "MSFT_DeviceManagementMobileAppAssignmentSettings { `r`n"
        $StringContent += "$($space)$($indent)odataType  = '" + $setting.odataType + "'`r`n"
        $StringContent += "$($space)$($indent)uninstallOnDeviceRemoval = '" + $setting.uninstallOnDeviceRemoval + "'`r`n"
        $StringContent += "$space}"

        $i++
    }

    $StringContent += ')'
    return $StringContent
}

function ConvertTo-M365DSCIntuneAppCategories
{
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.ArrayList]
        $Categories
    )

    $result = @()
    foreach ($category in $Categories)
    {
        $currentCategory = @{
            id  = $category.id
            displayName = $category.displayName # This 'displayName' property has to exist in microsoft.management.services.api.mobileAppCategory
        }

        $result += $currentCategory
    }

    return $result
}

function Get-M365DSCIntuneAppCategoriesAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $Categories
    )

    $StringContent = '@('
    $space = '                '
    $indent = '    '

    $i = 1
    foreach ($category in $Categories)
    {
        if ($Categories.Count -gt 1)
        {
            $StringContent += "`r`n"
            $StringContent += "$space"
        }

        $StringContent += "MSFT_DeviceManagementMobileAppCategory { `r`n"
        $StringContent += "$($space)$($indent)id  = '" + $category.id + "'`r`n"
        $StringContent += "$($space)$($indent)displayName = '" + $category.displayName + "'`r`n"
        $StringContent += "$space}"

        $i++
    }

    $StringContent += ')'
    return $StringContent
}

#endregion Helper functions

Export-ModuleMember -Function *-TargetResource
