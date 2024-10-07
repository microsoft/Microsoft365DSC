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

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ChildApps,


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
            -ErrorAction SilentlyContinue | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.macOSLobApp' }

        if ($null -eq $instance)
        {
            Write-Verbose -Message "No Mobile app with DisplayName {$DisplayName} was found. Search with DisplayName."
            $instance = Get-MgBetaDeviceAppManagementMobileApp `
                -MobileAppId $Id `
                -ExpandProperty "categories,assignments" `
                -ErrorAction Stop | Where-Object `
                -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.macOSLobApp' }
        }

        if ($null -eq $instance)
        {
            Write-Verbose -Message "No Mobile app with {$Id} was found."
            return $nullResult
        }

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
            IgnoreVersionDetection = $instance.AdditionalProperties.ignoreVersionDetection
            #ChildApps             = $instance.AdditionalProperties.childApps

            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ApplicationSecret     = $ApplicationSecret
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }

        #region complex types

        #Categories
        if($null -ne $instance.Categories)
        {
            $results.Add('Categories', $instance.Categories)
        }
        else {
            $results.Add('Categories', "")
        }

        #childApps
        if($null -ne $instance.AdditionalProperties.childApps)
        {
            # foreach ($childApp in $instance.AdditionalProperties.childApps)
            # {
            #     Write-Host "Get- print childApps.............................." $childApp.bundleId
            #     Write-Host "Get- print childApps.............................." $childApp.buildNumber
            #     Write-Host "Get- print childApps.............................." $childApp.versionNumber
            # }

            $results.Add('ChildApps', $instance.AdditionalProperties.childApps)
        }
        else {
            Write-Host "Get- print childApps null.............................."
            $results.Add('ChildApps', "")
        }

        #Assignments
        $resultAssignments = @()
        $appAssignments = Get-MgBetaDeviceAppManagementMobileAppAssignment -MobileAppId $instance.Id
        if ($null -ne $appAssignments -and $appAssignments.count -gt 0)
        {
            $resultAssignments += ConvertFrom-IntuneMobileAppAssignment `
                                -IncludeDeviceFilter:$true `
                                -Assignments ($appAssignments)

            $results.Add('Assignments', $resultAssignments)
        }

        #end region complex types

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

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ChildApps,


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
    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('AccessTokens') | Out-Null
    # $PSBoundParameters.Remove('Categories') | Out-Null
    # $PSBoundParameters.Remove('Assignments') | Out-Null
    # $PSBoundParameters.Remove('childApps') | Out-Null
    # $PSBoundParameters.Remove('IgnoreVersionDetection') | Out-Null

    $CreateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters


    # $AdditionalProperties = Get-M365DSCIntuneMobileMocOSLobAppAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)

    # Write-Host "Before adding cat and chap @setparameters............................." @setParameters
    # Write-Host "Before adding cat and chap @AdditionalProperties............................." @AdditionalProperties

    # #Categories
    # if($null -ne $Categories)
    # {
    #     [System.Object[]]$categoriesValue = ConvertTo-M365DSCIntuneAppCategories -Categories $Categories
    #     $setParameters.Add('Categories', $categoriesValue)
    # }
    # else {
    #      Write-Host "^^^^^^^^^^ Set- categories is null:" $Categories
    # }

    # #childApps
    # if($null -ne $ChildApps)
    # {
    #     foreach ($childApp in $ChildApps)
    #     {
    #         Write-Host "^^^^^^^^^^ Set- childApps.............................." $childApp.bundleId
    #         Write-Host "^^^^^^^^^^^ Set- childApps.............................." $childApp.buildNumber
    #         Write-Host "^^^^^^^^ Set- childApps.............................." $childApp.versionNumber
    #     }

    #     [System.Object[]]$childAppsValue = ConvertTo-M365DSCIntuneAppChildApps -ChildApps $ChildApps
    #     $AdditionalProperties.Add('childApps', $childAppsValue)
    # }
    # else
    # {
    #     Write-Host "^^^^^^^^^^ Set- $ChildApps is null:" $ChildApps
    # }

    # Write-Host "After adding cat and chap @setparameters............................." @setParameters
    # Write-Host "After adding cat and chap @AdditionalProperties............................." @AdditionalProperties


    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Host "Create MacOSLobApp: $DisplayName"

        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters

        $AdditionalProperties = Get-M365DSCIntuneMobileMocOSLobAppAdditionalProperties -Properties ($CreateParameters)
        foreach ($key in $AdditionalProperties.keys)
        {
            if ($key -ne '@odata.type')
            {
                $keyName = $key.substring(0, 1).ToUpper() + $key.substring(1, $key.length - 1)
                $CreateParameters.remove($keyName)
            }
        }

        $CreateParameters.remove('Id') | Out-Null
        $CreateParameters.remove('Ensure') | Out-Null
        $CreateParameters.remove('Categories') | Out-Null
        $CreateParameters.remove('Assignments') | Out-Null
        $CreateParameters.remove('childApps') | Out-Null
        $CreateParameters.remove('IgnoreVersionDetection') | Out-Null
        $CreateParameters.Remove('Verbose') | Out-Null

        foreach ($key in ($CreateParameters.clone()).Keys)
        {
            if ($CreateParameters[$key].getType().Fullname -like '*CimInstance*')
            {
                $CreateParameters[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters[$key]
            }
        }

        if ($AdditionalProperties)
        {
            $CreateParameters.add('AdditionalProperties', $AdditionalProperties)
        }

        $app = New-MgBetaDeviceAppManagementMobileApp @CreateParameters -AdditionalProperties $AdditionalProperties

        #region Assignments
        $assignmentsHash = ConvertTo-IntuneMobileAppAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        if ($app.id)
        {
            Write-host "Assignment updates for MacOSLobApp: $DisplayName"
            Update-MgBetaDeviceAppManagementMobileAppAssignment -MobileAppId $app.id `
                -Targets $assignmentsHash `
                -Repository 'deviceAppManagement/mobileAppAssignments'
        }
        #endregion Assignments
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Host "Update MacOSLobApp: $DisplayName"

        $PSBoundParameters.Remove('Assignments') | Out-Null
        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        Write-Host "^^^^^^ Update Parameters............................." $UpdateParameters

        $AdditionalProperties = Get-M365DSCIntuneMobileMocOSLobAppAdditionalProperties -Properties ($UpdateParameters)

        Write-Host "^^^^^^ Update AdditionalProperties............................." $AdditionalProperties

        foreach ($key in $AdditionalProperties.keys)
        {
            if ($key -ne '@odata.type')
            {
                $keyName = $key.substring(0, 1).ToUpper() + $key.substring(1, $key.length - 1)
                $UpdateParameters.remove($keyName)
                Write-Host "^^^^^^ Removed key ............................." $keyName
            }
        }

        $UpdateParameters.Remove('Id') | Out-Null
        $UpdateParameters.Remove('Verbose') | Out-Null
        $UpdateParameters.Remove('Categories') | Out-Null
        $UpdateParameters.Remove('PublishingState') | Out-Null

        Write-Host "^^^^^^ Removed CAT ONLY ONCE ~~~~~~~~~~~~~~~~~~~~~~"

         Write-Host "^^^^^^ Updated updateParameters (removed, id, verbose, cate, CAT and other props from additionalprops) ............................." $UpdateParameters
        foreach ($key in ($UpdateParameters.clone()).Keys)
        {
            Write-Host "added key-value to updateParameters .............................$key : $value"

            if ($UpdateParameters[$key].getType().Fullname -like '*CimInstance*')
            {
                $value = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters[$key]
                $UpdateParameters[$key] = $value
            }
        }

        if ($AdditionalProperties)
        {
            $UpdateParameters.add('AdditionalProperties', $AdditionalProperties)
        }

        Write-Host "^^^^^^ FINAL: updateParameters: right before Calling update-MgBetaDeviceAppManagementMobileApp ............................." $UpdateParameters


        $updateResult = Update-MgBetaDeviceAppManagementMobileApp -MobileAppId $currentInstance.Id @UpdateParameters

        Write-Host "^^^^^^ Update result............................." $updateResult


        #region Assignments
        $assignmentsHash = ConvertTo-IntuneMobileAppAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        if ($app.id)
        {
            Write-host "Assignment updates for MacOSLobApp: $DisplayName"
            Update-MgBetaDeviceAppManagementMobileAppAssignment -MobileAppId $app.id `
                -Targets $assignmentsHash `
                -Repository 'deviceAppManagement/mobileAppAssignments'
        }
        #endregion Assignments
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Host "Remove MacOSLobApp: $DisplayName"
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

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ChildApps,

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

    Write-Host "start test-TargetResource.............................."
    Write-Debug "start Set-TargetResource.............................."

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
            -Filter "isof('microsoft.graph.macOSLobApp')" `
            -ExpandProperty "categories,assignments" `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.macOSLobApp' }

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
                IgnoreVersionDetection = $config.AdditionalProperties.ignoreVersionDetection
                #ChildApps             = $config.AdditionalProperties.childApps

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

            #Categories
            if($null -eq $Results.Categories -or $Results.Categories.Count -eq 0)
            {
                $Results.Categories = $null
            }
            else
            {
                $Results.Categories = Get-M365DSCIntuneAppCategoriesAsString -Categories $Results.Categories
            }

            #ChildApps
            if($null -eq $Results.childApps -or $Results.childApps.Count -eq 0)
            {
                Write-Host "Export print childApps: IN IF WHERE CHILD APPS NULL.............................."
            }
            else
            {
                Write-Host "Export print childApps: IN ELSE BEFORE FOR LOOP.............................."
                foreach ($childApp in $Results.childApps)
                {
                    Write-Host "Export print childApps.............................." $childApp.bundleId
                    Write-Host "Export print childApps.............................." $childApp.buildNumber
                    Write-Host "Export print childApps.............................." $childApp.versionNumber
                }

                $Results.childApps = Get-M365DSCIntuneAppChildAppsAsString -ChildApps $Results.childApps
            }

            #Assignments
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
                $isCIMArray = $false
                if ($Results.Categories.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }

                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Categories' -IsCIMArray:$isCIMArray
            }

            if ($null -ne $Results.childApps)
            {
                $isCIMArray = $false
                if ($Results.childApps.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }

                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'ChildApps' -IsCIMArray:$isCIMArray
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
            displayName = $category.displayName
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

function ConvertTo-M365DSCIntuneAppChildApps
{
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.ArrayList]
        $ChildApps
    )

    $result = @()
    foreach ($childApp in $ChildApps)
    {
        $currentChildApp = @{
            bundleId  = $childApp.bundleId
            buildNumber = $childApp.buildNumber
            versionNumber = $childApp.VersionNumber
        }

        $result += $currentChildApp
    }

    return $result
}

function Get-M365DSCIntuneAppChildAppsAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $ChildApps
    )

    $StringContent = '@('
    $space = '                '
    $indent = '    '

    $i = 1
    foreach ($childApp in $ChildApps)
    {
        if ($ChildApps.Count -gt 1)
        {
            $StringContent += "`r`n"
            $StringContent += "$space"
        }

        $StringContent += "MSFT_DeviceManagementMobileAppChildApp { `r`n"
        $StringContent += "$($space)$($indent)bundleId  = '" + $childApp.bundleId + "'`r`n"
        $StringContent += "$($space)$($indent)buildNumber = '" + $childApp.buildNumber + "'`r`n"
        $StringContent += "$($space)$($indent)versionNumber  = '" + $childApp.versionNumber + "'`r`n"
        $StringContent += "$space}"

        $i++
    }

    $StringContent += ')'

    return $StringContent
}

function Get-M365DSCIntuneMobileMocOSLobAppAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $additionalProperties = @(
        'IgnoreVersionDetection'
        'ChildApps'
    )

    $results = @{'@odata.type' = '#microsoft.graph.macOSLobApp' }
    $cloneProperties = $Properties.clone()
    foreach ($property in $cloneProperties.Keys)
    {
        if ($property -in $additionalProperties)
        {
            $propertyName = $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            if ($properties.$property -and $properties.$property.getType().FullName -like '*CIMInstance*')
            {
                if ($properties.$property.getType().FullName -like '*[[\]]')
                {
                    $array = @()
                    foreach ($item in $properties.$property)
                    {
                        $array += Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item

                    }
                    $propertyValue = $array
                }
                else
                {
                    $propertyValue = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $properties.$property
                }

            }
            else
            {
                $propertyValue = $properties.$property
            }

            $results.Add($propertyName, $propertyValue)
        }
    }

    if ($results.Count -eq 1)
    {
        return $null
    }
    return $results
}

#endregion Helper functions

Export-ModuleMember -Function *-TargetResource
