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
        [System.Boolean]
        $IgnoreVersionDetection,

        [Parameter()]
        [System.Boolean]
        $InstallAsManaged,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MinimumSupportedOperatingSystem,

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
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $BundleId,

        [Parameter()]
        [System.String]
        $BuildNumber,

        [Parameter()]
        [System.String]
        $VersionNumber,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Categories,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ChildApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LargeIcon,

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
        $instance = Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $Id `
            -ExpandProperty "categories" `
            -ErrorAction SilentlyContinue

        if ($null -eq $instance)
        {
            Write-Verbose -Message "Could not find an Intune MacOS Lob App with Id {$Id}."

            if (-not [System.String]::IsNullOrEmpty($DisplayName))
            {
                $instance = Get-MgBetaDeviceAppManagementMobileApp `
                    -Filter "(isof('microsoft.graph.macOSLobApp') and displayName eq '$DisplayName')" `
                    -ErrorAction SilentlyContinue
            }

            if ($null -ne $instance)
            {
                $instance = Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $instance.Id `
                    -ExpandProperty "categories" `
                    -ErrorAction SilentlyContinue
                $Id = $instance.Id
            }
        }

        if ($null -eq $instance)
        {
            Write-Verbose -Message "Could not find an Intune MacOS Lob App with DisplayName {$DisplayName} was found."
            return $nullResult
        }

        Write-Verbose "An Intune MacOS Lob App with Id {$Id} and DisplayName {$DisplayName} was found."

        #region complex types
        $complexCategories = @()
        foreach ($category in $instance.Categories)
        {
            $myCategory = @{}
            $myCategory.Add('Id', $category.id)
            $myCategory.Add('DisplayName', $category.displayName)
            $complexCategories += $myCategory
        }

        $complexChildApps = @()
        foreach ($childApp in $instance.AdditionalProperties.childApps)
        {
            $myChildApp = @{}
            $myChildApp.Add('BundleId', $childApp.bundleId)
            $myChildApp.Add('BuildNumber', $childApp.buildNumber)
            $myChildApp.Add('VersionNumber', $childApp.versionNumber)
            $complexChildApps += $myChildApp
        }

        $complexLargeIcon = @{}
        if ($null -ne $instance.LargeIcon.Value)
        {
            $complexLargeIcon.Add('Value', [System.Convert]::ToBase64String($instance.LargeIcon.Value))
            $complexLargeIcon.Add('Type', $instance.LargeIcon.Type)
        }

        $complexMinimumSupportedOperatingSystem = @{}
        if ($null -ne $instance.AdditionalProperties.minimumSupportedOperatingSystem)
        {
            $instance.AdditionalProperties.minimumSupportedOperatingSystem.GetEnumerator() | Foreach-Object {
                if ($_.Value) # Values are either true or false. Only export the true value.
                {
                    $complexMinimumSupportedOperatingSystem.Add($_.Key, $_.Value)
                }
            }
        }

        $results = @{
            Id                              = $instance.Id
            BundleId                        = $instance.AdditionalProperties.bundleId
            BuildNumber                     = $instance.AdditionalProperties.buildNumber
            Categories                      = $complexCategories
            ChildApps                       = $complexChildApps
            Description                     = $instance.Description
            Developer                       = $instance.Developer
            DisplayName                     = $instance.DisplayName
            IgnoreVersionDetection          = $instance.AdditionalProperties.ignoreVersionDetection
            InformationUrl                  = $instance.InformationUrl
            IsFeatured                      = $instance.IsFeatured
            InstallAsManaged                = $instance.AdditionalProperties.installAsManaged
            LargeIcon                       = $complexLargeIcon
            MinimumSupportedOperatingSystem = $complexMinimumSupportedOperatingSystem
            Notes                           = $instance.Notes
            Owner                           = $instance.Owner
            PrivacyInformationUrl           = $instance.PrivacyInformationUrl
            Publisher                       = $instance.Publisher
            RoleScopeTagIds                 = $instance.RoleScopeTagIds
            VersionNumber                   = $instance.AdditionalProperties.versionNumber
            Ensure                          = 'Present'
            Credential                      = $Credential
            ApplicationId                   = $ApplicationId
            TenantId                        = $TenantId
            CertificateThumbprint           = $CertificateThumbprint
            ApplicationSecret               = $ApplicationSecret
            ManagedIdentity                 = $ManagedIdentity.IsPresent
            AccessTokens                    = $AccessTokens
        }

        #Assignments
        $resultAssignments = @()
        $appAssignments = Get-MgBetaDeviceAppManagementMobileAppAssignment -MobileAppId $instance.Id
        if ($null -ne $appAssignments -and $appAssignments.count -gt 0)
        {
            $resultAssignments += ConvertFrom-IntuneMobileAppAssignment `
                                -IncludeDeviceFilter:$true `
                                -Assignments ($appAssignments)
        }
        $results.Add('Assignments', $resultAssignments)

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
        [System.Boolean]
        $IgnoreVersionDetection,

        [Parameter()]
        [System.Boolean]
        $InstallAsManaged,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MinimumSupportedOperatingSystem,

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
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $BundleId,

        [Parameter()]
        [System.String]
        $BuildNumber,

        [Parameter()]
        [System.String]
        $VersionNumber,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Categories,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ChildApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LargeIcon,

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
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune MacOS Lob App with DisplayName {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$BoundParameters).Clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null
        $CreateParameters.Remove('Categories') | Out-Null

        foreach ($key in ($CreateParameters.Clone()).Keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.GetType().Name -like '*CimInstance*')
            {
                $CreateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
            }
        }

        $CreateParameters.Add('@odata.type', '#microsoft.graph.macOSLobApp')
        $app = New-MgBetaDeviceAppManagementMobileApp -BodyParameter $CreateParameters

        foreach ($category in $Categories)
        {
            if ($category.Id)
            {
                $currentCategory = Get-MgBetaDeviceAppManagementMobileAppCategory -CategoryId $category.Id
            }
            else
            {
                $currentCategory = Get-MgBetaDeviceAppManagementMobileAppCategory -Filter "displayName eq '$($category.DisplayName)'"
            }

            if ($null -eq $currentCategory)
            {
                throw "Mobile App Category with DisplayName $($category.DisplayName) not found."
            }

            Invoke-MgBetaGraphRequest -Uri "/beta/deviceAppManagement/mobileApps/$($app.Id)/categories/`$ref" -Method 'POST' -Body @{
                '@odata.id' = "https://graph.microsoft.com/beta/deviceAppManagement/mobileAppCategories/$($currentCategory.Id)"
            }
        }

        #Assignments
        if ($app.Id)
        {
            $assignmentsHash = ConvertTo-IntuneMobileAppAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceAppManagementPolicyAssignment -AppManagementPolicyId $app.Id `
                -Assignments $assignmentsHash
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Host "Updating the Intune MacOS Lob App with DisplayName {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = ([Hashtable]$BoundParameters).Clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters
        $UpdateParameters.Remove('Id') | Out-Null
        $UpdateParameters.Remove('Categories') | Out-Null

        foreach ($key in ($UpdateParameters.Clone()).Keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.GetType().Name -like '*CimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
        }

        $UpdateParameters.Add('@odata.type', '#microsoft.graph.macOSLobApp')
        Update-MgBetaDeviceAppManagementMobileApp -MobileAppId $currentInstance.Id -BodyParameter $UpdateParameters

        [array]$referenceObject = if ($null -ne $currentInstance.Categories.DisplayName) { $currentInstance.Categories.DisplayName } else { ,@() }
        [array]$differenceObject = if ($null -ne $Categories.DisplayName) { $Categories.DisplayName } else { ,@() }
        $delta = Compare-Object -ReferenceObject $referenceObject -DifferenceObject $differenceObject -PassThru
        foreach ($diff in $delta)
        {
            if ($diff.SideIndicator -eq '=>')
            {
                $category = $Categories | Where-Object { $_.DisplayName -eq $diff }
                if ($category.Id)
                {
                    $currentCategory = Get-MgBetaDeviceAppManagementMobileAppCategory -MobileAppCategoryId $category.Id
                }
                else
                {
                    $currentCategory = Get-MgBetaDeviceAppManagementMobileAppCategory -Filter "displayName eq '$($category.DisplayName)'"
                }

                if ($null -eq $currentCategory)
                {
                    throw "Mobile App Category with DisplayName $($category.DisplayName) not found."
                }

                Invoke-MgGraphRequest -Uri "/beta/deviceAppManagement/mobileApps/$($currentInstance.Id)/categories/`$ref" -Method 'POST' -Body @{
                    '@odata.id' = "https://graph.microsoft.com/beta/deviceAppManagement/mobileAppCategories/$($currentCategory.Id)"
                }
            }
            else
            {
                $category = $currentInstance.Categories | Where-Object { $_.DisplayName -eq $diff }
                Invoke-MgGraphRequest -Uri "/beta/deviceAppManagement/mobileApps/$($currentInstance.Id)/categories/$($category.Id)/`$ref" -Method 'DELETE'
            }
        }

        #Assignments
        $assignmentsHash = ConvertTo-IntuneMobileAppAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceAppManagementPolicyAssignment -AppManagementPolicyId $currentInstance.Id `
            -Assignments $assignmentsHash
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Host "Remove the Intune MacOS Lob App with Id {$($currentInstance.Id)}"
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
        [System.Boolean]
        $IgnoreVersionDetection,

        [Parameter()]
        [System.Boolean]
        $InstallAsManaged,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MinimumSupportedOperatingSystem,

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
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $BundleId,

        [Parameter()]
        [System.String]
        $BuildNumber,

        [Parameter()]
        [System.String]
        $VersionNumber,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Categories,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ChildApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LargeIcon,
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

    Write-Verbose -Message "Testing configuration of the Intune MacOS Lob App with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

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

    # Prevent screen from filling up with the LargeIcon value
    # Comparison will already be done because it's a CimInstance
    $CurrentValues.Remove('LargeIcon') | Out-Null
    $PSBoundParameters.Remove('LargeIcon') | Out-Null

    $ValuesToCheck.Remove('Id') | Out-Null
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck

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
        [array] $Script:getInstances = Get-MgBetaDeviceAppManagementMobileApp `
            -Filter "isof('microsoft.graph.macOSLobApp')" `
            -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($Script:getInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }

        foreach ($config in $Script:getInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            Write-Host "    |---[$i/$($Script:getInstances.Count)] $displayedKey" -NoNewline

            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
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
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            #region complex types
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

            if ($null -ne $Results.ChildApps)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ChildApps `
                    -CIMInstanceName 'DeviceManagementMobileAppChildApp'

                if (-not [System.String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ChildApps = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ChildApps') | Out-Null
                }
            }

            if ($null -ne $Results.LargeIcon)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.LargeIcon `
                    -CIMInstanceName 'DeviceManagementMimeContent'

                if (-not [System.String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.LargeIcon = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('LargeIcon') | Out-Null
                }
            }

            if ($null -ne $Results.MinimumSupportedOperatingSystem)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.MinimumSupportedOperatingSystem `
                    -CIMInstanceName 'DeviceManagementMinimumOperatingSystem'

                if (-not [System.String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.MinimumSupportedOperatingSystem = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MinimumSupportedOperatingSystem') | Out-Null
                }
            }

            if ($null -ne $Results.Assignments)
            {
                if ($Results.Assignments)
                {
                    $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $Results.Assignments `
                        -CIMInstanceName DeviceManagementMobileAppAssignment

                    if ($complexTypeStringResult)
                    {
                        $Results.Assignments = $complexTypeStringResult
                    }
                    else
                    {
                        $Results.Remove('Assignments') | Out-Null
                    }
                }
            }
            #endregion complex types

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            #region complex types
            if ($null -ne $Results.Categories)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Categories' -IsCIMArray:$true
            }

            if ($null -ne $Results.ChildApps)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'ChildApps' -IsCIMArray:$true
            }

            if ($null -ne $Results.LargeIcon)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'LargeIcon' -IsCIMArray:$false
            }

            if ($null -ne $Results.MinimumSupportedOperatingSystem)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'MinimumSupportedOperatingSystem' -IsCIMArray:$false
            }

            if ($null -ne $Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$true
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

Export-ModuleMember -Function *-TargetResource
