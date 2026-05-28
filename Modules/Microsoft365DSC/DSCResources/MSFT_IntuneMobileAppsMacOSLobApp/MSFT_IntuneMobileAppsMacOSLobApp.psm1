Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneMobileAppsMacOSLobApp'

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

    Write-Verbose -Message "Getting configuration of the Intune MacOS Lob App with Id {$Id} and DisplayName {$DisplayName}"

    try
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

        if (-not [System.String]::IsNullOrEmpty($Id))
        {
            $instance = Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $Id -ExpandProperty 'categories' -ErrorAction SilentlyContinue
        }

        if ($null -eq $instance)
        {
            Write-Verbose -Message "Could not find an Intune MacOS Lob App with Id {$Id}."

            if (-not [System.String]::IsNullOrEmpty($DisplayName))
            {
                $instance = Get-MgBetaDeviceAppManagementMobileApp `
                    -All `
                    -Filter "(isof('microsoft.graph.macOSLobApp') and DisplayName eq '$($DisplayName -replace "'", "''")')" `
                    -ErrorAction SilentlyContinue
            }

            if ($null -ne $instance)
            {
                $instance = Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $instance.Id `
                    -ExpandProperty 'categories' `
                    -ErrorAction SilentlyContinue
            }
        }
        $Id = $instance.Id

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
            $myCategory = [ordered]@{}
            $myCategory.Add('Id', $category.id)
            $myCategory.Add('DisplayName', $category.displayName)
            $complexCategories += $myCategory
        }

        $complexChildApps = @()
        foreach ($childApp in $instance.childApps)
        {
            $myChildApp = [ordered]@{}
            $myChildApp.Add('BundleId', $childApp.bundleId)
            $myChildApp.Add('BuildNumber', $childApp.buildNumber)
            $myChildApp.Add('VersionNumber', $childApp.versionNumber)
            $complexChildApps += $myChildApp
        }

        $complexLargeIcon = [ordered]@{}
        if ($null -ne $instance.LargeIcon.Value)
        {
            $complexLargeIcon.Add('Type', $instance.LargeIcon.Type)
            $complexLargeIcon.Add('Value', $instance.LargeIcon.Value)
        }

        $complexMinimumSupportedOperatingSystem = [ordered]@{}
        if ($null -ne $instance.minimumSupportedOperatingSystem)
        {
            $instance.minimumSupportedOperatingSystem.GetEnumerator() | ForEach-Object {
                if ($_.Value) # Values are either true or false. Only export the true value.
                {
                    $complexMinimumSupportedOperatingSystem.Add($_.Key, $_.Value)
                }
            }
        }

        $results = @{
            Id                              = $instance.Id
            BundleId                        = $instance.bundleId
            BuildNumber                     = $instance.buildNumber
            Categories                      = $complexCategories
            ChildApps                       = $complexChildApps
            Description                     = $instance.Description
            Developer                       = $instance.Developer
            DisplayName                     = $instance.DisplayName
            IgnoreVersionDetection          = $instance.ignoreVersionDetection
            InformationUrl                  = $instance.InformationUrl
            IsFeatured                      = $instance.IsFeatured
            InstallAsManaged                = $instance.installAsManaged
            LargeIcon                       = $complexLargeIcon
            MinimumSupportedOperatingSystem = $complexMinimumSupportedOperatingSystem
            Notes                           = $instance.Notes
            Owner                           = $instance.Owner
            PrivacyInformationUrl           = $instance.PrivacyInformationUrl
            Publisher                       = $instance.Publisher
            RoleScopeTagIds                 = $instance.RoleScopeTagIds
            VersionNumber                   = $instance.versionNumber
            Ensure                          = 'Present'
            Credential                      = $Credential
            ApplicationId                   = $ApplicationId
            TenantId                        = $TenantId
            ApplicationSecret               = $ApplicationSecret
            CertificateThumbprint           = $CertificateThumbprint
            CertificatePath                 = $CertificatePath
            CertificatePassword             = $CertificatePassword
            ManagedIdentity                 = $ManagedIdentity.IsPresent
            AccessTokens                    = $AccessTokens
        }

        #Assignments
        $resultAssignments = @()
        $appAssignments = Get-MgBetaDeviceAppManagementMobileAppAssignment -MobileAppId $instance.Id
        if ($null -ne $appAssignments -and $appAssignments.Count -gt 0)
        {
            $resultAssignments += ConvertFrom-IntuneMobileAppAssignment `
                -IncludeDeviceFilter:$true `
                -Assignments ($appAssignments)
        }
        $results.Add('Assignments', $resultAssignments)

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

        $CreateParameters.Add('@odata.type', '#microsoft.graph.macOSLobApp')
        $CreateParameters.Add('fileName', "$DisplayName.pkg")
        $app = New-MgBetaDeviceAppManagementMobileApp -BodyParameter $CreateParameters

        Invoke-M365DSCIntuneMobileAppInitialUpload -AppId $app.Id -OdataType '#microsoft.graph.macOSLobApp' -FileExtension 'pkg'

        if ($PSBoundParameters.ContainsKey('Categories'))
        {
            Update-DeviceAppManagementAppCategory -App $app -Categories $Categories
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
        Write-Verbose -Message "Updating the Intune MacOS Lob App with DisplayName {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = ([Hashtable]$BoundParameters).Clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters
        $UpdateParameters.Remove('Id') | Out-Null
        $UpdateParameters.Remove('Categories') | Out-Null

        $UpdateParameters.Add('@odata.type', '#microsoft.graph.macOSLobApp')
        Update-MgBetaDeviceAppManagementMobileApp -MobileAppId $currentInstance.Id -BodyParameter $UpdateParameters

        if ($PSBoundParameters.ContainsKey('Categories'))
        {
            Update-DeviceAppManagementAppCategory -App $currentInstance -Categories $Categories
        }

        #Assignments
        $assignmentsHash = ConvertTo-IntuneMobileAppAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceAppManagementPolicyAssignment -AppManagementPolicyId $currentInstance.Id `
            -Assignments $assignmentsHash
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Remove the Intune MacOS Lob App with Id {$($currentInstance.Id)}"
        Remove-MgBetaDeviceAppManagementMobileApp -MobileAppId $currentInstance.Id
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
        $baseFilter = "isof('microsoft.graph.macOSLobApp')"
        if (-not [String]::IsNullOrEmpty($Filter))
        {
            $Filter = "($Filter) and ($baseFilter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array] $getValue = Get-MgBetaDeviceAppManagementMobileApp `
            -All `
            -Filter $Filter `
            -ErrorAction Stop

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
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
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
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

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

            if ($Results.Assignments)
            {
                $complexMapping = @(
                    @{
                        Name            = 'AssignmentSettings'
                        CIMInstanceName = 'DeviceManagementMacOSLobAppAssignmentSettings'
                        IsRequired      = $false
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Assignments `
                    -CIMInstanceName DeviceManagementMacOSLobAppAssignment `
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
            #endregion complex types

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Categories', 'ChildApps', 'LargeIcon', 'MinimumSupportedOperatingSystem', 'Assignments')

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

Export-ModuleMember -Function *-TargetResource
