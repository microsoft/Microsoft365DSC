Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneSecurityBaselineMicrosoftEdge'

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
        $InternetExplorerIntegrationReloadInIEModeAllowed,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SSLErrorOverrideAllowed,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $InternetExplorerIntegrationZoneIdentifierMhtFileAllowed,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $BrowserLegacyExtensionPointsBlockingEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SitePerProcess,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $EdgeEnhanceImagesEnabled,

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
        $WebSQLAccess,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $BasicAuthOverHttpEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $MicrosoftEdge_HTTPAuthentication_AuthSchemes,

        [Parameter()]
        [System.String]
        $AuthSchemes_AuthSchemes,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $NativeMessagingUserLevelHosts,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $InsecurePrivateNetworkRequestsAllowed,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $InternetExplorerModeToolbarButtonEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SmartScreenEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SmartScreenPuaEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $PreventSmartScreenPromptOverride,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $PreventSmartScreenPromptOverrideForFiles,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SharedArrayBufferUnrestrictedAccessAllowed,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $TyposquattingCheckerEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $edge_DynamicCodeSettings,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DynamicCodeSettings_DynamicCodeSettings,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $ApplicationBoundEncryptionEnabled,

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

    Write-Verbose -Message "Getting configuration of the Intune Security Baseline Microsoft Edge with Id {$Id} and Name {$DisplayName}"

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
                Write-Verbose -Message "Could not find an Intune Security Baseline Microsoft Edge with Id {$Id}"

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
                Write-Verbose -Message "Could not find an Intune Security Baseline Microsoft Edge with Name {$DisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Security Baseline Microsoft Edge with Id {$Id} and Name {$DisplayName} was found"

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
        $InternetExplorerIntegrationReloadInIEModeAllowed,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SSLErrorOverrideAllowed,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $InternetExplorerIntegrationZoneIdentifierMhtFileAllowed,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $BrowserLegacyExtensionPointsBlockingEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SitePerProcess,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $EdgeEnhanceImagesEnabled,

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
        $WebSQLAccess,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $BasicAuthOverHttpEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $MicrosoftEdge_HTTPAuthentication_AuthSchemes,

        [Parameter()]
        [System.String]
        $AuthSchemes_AuthSchemes,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $NativeMessagingUserLevelHosts,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $InsecurePrivateNetworkRequestsAllowed,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $InternetExplorerModeToolbarButtonEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SmartScreenEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SmartScreenPuaEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $PreventSmartScreenPromptOverride,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $PreventSmartScreenPromptOverrideForFiles,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SharedArrayBufferUnrestrictedAccessAllowed,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $TyposquattingCheckerEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $edge_DynamicCodeSettings,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DynamicCodeSettings_DynamicCodeSettings,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $ApplicationBoundEncryptionEnabled,

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

    Write-Verbose -Message "Setting configuration of the Intune Security Baseline Microsoft Edge with Id {$Id} and Name {$Name}"

    if ($PSBoundParameters.ContainsKey('WebSQLAccess'))
    {
        Write-Warning -Message 'The WebSQLAccess parameter is deprecated and will be removed in a future version. It will not be used in the current operation.'
        $PSBoundParameters.Remove('WebSQLAccess') | Out-Null
    }

    if ($PSBoundParameters.ContainsKey('EdgeEnhanceImagesEnabled'))
    {
        Write-Warning -Message 'The EdgeEnhanceImagesEnabled parameter is deprecated and will be removed in a future version. It will not be used in the current operation.'
        $PSBoundParameters.Remove('EdgeEnhanceImagesEnabled') | Out-Null
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

    $templateReferenceId = 'c66347b7-8325-4954-a235-3bf2233dfbfd_3'
    $platforms = 'windows10'
    $technologies = 'mdm'

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Security Baseline Microsoft Edge with Name {$DisplayName}"
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
        Write-Verbose -Message "Updating the Intune Security Baseline Microsoft Edge with Id {$($currentInstance.Id)}"
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
        Write-Verbose -Message "Removing the Intune Security Baseline Microsoft Edge with Id {$($currentInstance.Id)}"
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
        $InternetExplorerIntegrationReloadInIEModeAllowed,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SSLErrorOverrideAllowed,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $InternetExplorerIntegrationZoneIdentifierMhtFileAllowed,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $BrowserLegacyExtensionPointsBlockingEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SitePerProcess,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $EdgeEnhanceImagesEnabled,

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
        $WebSQLAccess,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $BasicAuthOverHttpEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $MicrosoftEdge_HTTPAuthentication_AuthSchemes,

        [Parameter()]
        [System.String]
        $AuthSchemes_AuthSchemes,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $NativeMessagingUserLevelHosts,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $InsecurePrivateNetworkRequestsAllowed,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $InternetExplorerModeToolbarButtonEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SmartScreenEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SmartScreenPuaEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $PreventSmartScreenPromptOverride,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $PreventSmartScreenPromptOverrideForFiles,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $SharedArrayBufferUnrestrictedAccessAllowed,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $TyposquattingCheckerEnabled,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $edge_DynamicCodeSettings,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DynamicCodeSettings_DynamicCodeSettings,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $ApplicationBoundEncryptionEnabled,

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

    if ($PSBoundParameters.ContainsKey('WebSQLAccess'))
    {
        Write-Warning -Message 'The WebSQLAccess parameter is deprecated and will be removed in a future version. It will not be used in the current operation.'
        $PSBoundParameters.Remove('WebSQLAccess') | Out-Null
    }

    if ($PSBoundParameters.ContainsKey('EdgeEnhanceImagesEnabled'))
    {
        Write-Warning -Message 'The EdgeEnhanceImagesEnabled parameter is deprecated and will be removed in a future version. It will not be used in the current operation.'
        $PSBoundParameters.Remove('EdgeEnhanceImagesEnabled') | Out-Null
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
        $policyTemplateID = 'c66347b7-8325-4954-a235-3bf2233dfbfd_3'
        $baseFilter = "templateReference/templateId eq '$policyTemplateID'"
        if (-not [System.String]::IsNullOrEmpty($Filter))
        {
            $Filter = "($Filter) and ($baseFilter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = Get-MgBetaDeviceManagementConfigurationPolicy `
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
        ExcludedProperties = @('WebSQLAccess', 'EdgeEnhanceImagesEnabled')
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
