function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Autopatch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AutopilotConfiguration,

        [Parameter()]
        [System.String]
        $CloudPcNamingTemplate,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DomainJoinConfigurations,

        [Parameter()]
        [System.Boolean]
        $EnableSingleSignOn,

        [Parameter()]
        [System.String]
        $ImageDisplayName,

        [Parameter()]
        [System.String]
        $ImageId,

        [Parameter()]
        [ValidateSet('gallery', 'custom')]
        [System.String]
        $ImageType,

        [Parameter()]
        [System.Boolean]
        $LocalAdminEnabled,

        [Parameter()]
        [ValidateSet('dedicated', 'shared', 'sharedByUser', 'sharedByEntraGroup', 'reserve')]
        [System.String]
        $ProvisioningType,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [ValidateSet('cloudPc', 'cloudApp')]
        [System.String]
        $UserExperienceType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsSettings,

        [Parameter()]
        [System.String]
        $Id,

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

    Write-Verbose -Message "Getting configuration for the Intune Cloud Provisioning Policy for Windows365 with Id {$Id} and DisplayName {$DisplayName}"

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
                $getValue = Get-MgBetaDeviceManagementVirtualEndpointProvisioningPolicy `
                    -CloudPcProvisioningPolicyId $Id `
                    -ExpandProperty 'Assignments' `
                    -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Cloud Provisioning Policy for Windows365 with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementVirtualEndpointProvisioningPolicy `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" `
                        -ExpandProperty 'Assignments' `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Cloud Provisioning Policy for Windows365 with DisplayName {$DisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Cloud Provisioning Policy for Windows365 with Id {$Id} and DisplayName {$DisplayName} was found"

        #region resource generator code
        $complexAutopatch = @{}
        $complexAutopatch.Add('AutopatchGroupId', $getValue.Autopatch.autopatchGroupId)
        # TODO: Add support for AutopatchGroupDisplayName when this information is available in Microsoft Graph
        # $autopatchGroupDisplayName = <#<DisplayName>#>
        # $complexAutopatch.Add('AutopatchGroupDisplayName', $autopatchGroupDisplayName)
        if ($complexAutopatch.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexAutopatch = $null
        }

        $complexAutopilotConfiguration = @{}
        $complexAutopilotConfiguration.Add('ApplicationTimeoutInMinutes', $getValue.AutopilotConfiguration.applicationTimeoutInMinutes)
        $complexAutopilotConfiguration.Add('DevicePreparationProfileId', $getValue.AutopilotConfiguration.devicePreparationProfileId)
        $complexAutopilotConfiguration.Add('OnFailureDeviceAccessDenied', $getValue.AutopilotConfiguration.onFailureDeviceAccessDenied)
        if ($complexAutopilotConfiguration.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexAutopilotConfiguration = $null
        }

        $complexDomainJoinConfigurations = @()
        foreach ($currentDomainJoinConfigurations in $getValue.domainJoinConfigurations)
        {
            $myDomainJoinConfigurations = @{}
            if ($null -ne $currentDomainJoinConfigurations.domainJoinType)
            {
                $myDomainJoinConfigurations.Add('DomainJoinType', $currentDomainJoinConfigurations.domainJoinType.ToString())
            }
            $myDomainJoinConfigurations.Add('OnPremisesConnectionId', $currentDomainJoinConfigurations.onPremisesConnectionId)
            if ($null -ne $currentDomainJoinConfigurations.regionGroup)
            {
                $myDomainJoinConfigurations.Add('RegionGroup', $currentDomainJoinConfigurations.regionGroup.ToString())
            }
            $myDomainJoinConfigurations.Add('RegionName', $currentDomainJoinConfigurations.regionName)
            if ($null -ne $currentDomainJoinConfigurations.type)
            {
                $myDomainJoinConfigurations.Add('Type', $currentDomainJoinConfigurations.type.ToString())
            }
            if ($null -ne $currentDomainJoinConfigurations.AdditionalProperties.geographicLocationType)
            {
                $myDomainJoinConfigurations.Add('GeographicLocationType', $currentDomainJoinConfigurations.AdditionalProperties.geographicLocationType)
            }
            if ($myDomainJoinConfigurations.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexDomainJoinConfigurations += $myDomainJoinConfigurations
            }
        }

        $complexWindowsSetting = @{}
        $complexWindowsSetting.Add('Locale', $getValue.WindowsSetting.locale)
        if ($complexWindowsSetting.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexWindowsSetting = $null
        }

        $complexWindowsSettings = @{}
        $complexWindowsSettings.Add('Language', $getValue.WindowsSettings.language)
        if ($complexWindowsSettings.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexWindowsSettings = $null
        }
        #endregion

        #region resource generator code
        $enumImageType = $null
        if ($null -ne $getValue.ImageType)
        {
            $enumImageType = $getValue.ImageType.ToString()
        }

        $enumProvisioningType = $null
        if ($null -ne $getValue.ProvisioningType)
        {
            $enumProvisioningType = $getValue.ProvisioningType.ToString()
        }

        $enumUserExperienceType = $null
        if ($null -ne $getValue.UserExperienceType)
        {
            $enumUserExperienceType = $getValue.UserExperienceType.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            Autopatch                = $complexAutopatch
            AutopilotConfiguration   = $complexAutopilotConfiguration
            CloudPcNamingTemplate    = $getValue.CloudPcNamingTemplate
            Description              = $getValue.Description
            DisplayName              = $getValue.DisplayName
            DomainJoinConfigurations = $complexDomainJoinConfigurations
            EnableSingleSignOn       = $getValue.EnableSingleSignOn
            ImageDisplayName         = $getValue.ImageDisplayName
            ImageId                  = $getValue.ImageId
            ImageType                = $enumImageType
            LocalAdminEnabled        = $getValue.LocalAdminEnabled
            ProvisioningType         = $enumProvisioningType
            RoleScopeTagIds          = $getValue.ScopeIds
            UserExperienceType       = $enumUserExperienceType
            WindowsSetting           = $complexWindowsSetting
            WindowsSettings          = $complexWindowsSettings
            Id                       = $getValue.Id
            Ensure                   = 'Present'
            Credential               = $Credential
            ApplicationId            = $ApplicationId
            TenantId                 = $TenantId
            ApplicationSecret        = $ApplicationSecret
            CertificateThumbprint    = $CertificateThumbprint
            ManagedIdentity          = $ManagedIdentity.IsPresent
            #endregion
        }
        $assignmentsValues = $getValue.Assignments
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment -Assignments $assignmentsValues -IncludeDeviceFilter $true
        }
        $results.Add('Assignments', $assignmentResult)

        return [System.Collections.Hashtable] $results
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
        [Microsoft.Management.Infrastructure.CimInstance]
        $Autopatch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AutopilotConfiguration,

        [Parameter()]
        [System.String]
        $CloudPcNamingTemplate,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DomainJoinConfigurations,

        [Parameter()]
        [System.Boolean]
        $EnableSingleSignOn,

        [Parameter()]
        [System.String]
        $ImageDisplayName,

        [Parameter()]
        [System.String]
        $ImageId,

        [Parameter()]
        [ValidateSet('gallery', 'custom')]
        [System.String]
        $ImageType,

        [Parameter()]
        [System.Boolean]
        $LocalAdminEnabled,

        [Parameter()]
        [ValidateSet('dedicated', 'shared', 'sharedByUser', 'sharedByEntraGroup', 'reserve')]
        [System.String]
        $ProvisioningType,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [ValidateSet('cloudPc', 'cloudApp')]
        [System.String]
        $UserExperienceType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsSettings,

        [Parameter()]
        [System.String]
        $Id,

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

    Write-Verbose -Message "Setting configuration of the Intune Cloud Provisioning Policy for Windows365 with Id {$Id} and DisplayName {$DisplayName}"

    if (-not $PSBoundParameters.ContainsKey('Credential') -and -not [System.String]::IsNullOrEmpty($Autopatch.AutopatchGroupId))
    {
        throw 'Credential authentication is required when deploying with Autopatch configuration'
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
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    if ($boundParameters.ContainsKey('RoleScopeTagIds'))
    {
        $boundParameters.Add('ScopeIds', $boundParameters['RoleScopeTagIds'])
        $boundParameters.Remove('RoleScopeTagIds') | Out-Null
    }
    $managedDesktopType = 'notManaged'
    if ($boundParameters.ContainsKey('Autopatch') -and -not [System.String]::IsNullOrEmpty($boundParameters.Autopatch.AutopatchGroupId))
    {
        $managedDesktopType = 'starterManaged'
    }
    $boundParameters.Add('MicrosoftManagedDesktop', @{
        managedType = $managedDesktopType
        type        = $managedDesktopType
    })

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Cloud Provisioning Policy for Windows365 with DisplayName {$DisplayName}"
        $boundParameters.Remove('Assignments') | Out-Null

        $createParameters = ([Hashtable]$boundParameters).Clone()
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('Id') | Out-Null

        #region resource generator code
        $policy = New-MgBetaDeviceManagementVirtualEndpointProvisioningPolicy -BodyParameter $createParameters

        if ($policy.Id)
        {
            $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceConfigurationPolicyAssignment `
                -DeviceConfigurationPolicyId $policy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/virtualEndpoint/provisioningPolicies'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Cloud Provisioning Policy for Windows365 with Id {$($currentInstance.Id)}"
        $boundParameters.Remove('Assignments') | Out-Null
        $boundParameters.Remove('ProvisioningType') | Out-Null
        $boundParameters.Add('managedBy', 'Windows365')

        $updateParameters = ([Hashtable]$boundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters
        $updateParameters.Remove('Id') | Out-Null

        #region resource generator code
        Update-MgBetaDeviceManagementVirtualEndpointProvisioningPolicy `
            -CloudPcProvisioningPolicyId $currentInstance.Id `
            -BodyParameter $UpdateParameters

        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/virtualEndpoint/provisioningPolicies'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Cloud Provisioning Policy for Windows365 with Id {$($currentInstance.Id)}"
        #region resource generator code
        # Remove all assignments before deleting the policy
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Targets @() `
            -Repository 'deviceManagement/virtualEndpoint/provisioningPolicies'
        Remove-MgBetaDeviceManagementVirtualEndpointProvisioningPolicy -CloudPcProvisioningPolicyId $currentInstance.Id
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
        [Microsoft.Management.Infrastructure.CimInstance]
        $Autopatch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AutopilotConfiguration,

        [Parameter()]
        [System.String]
        $CloudPcNamingTemplate,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DomainJoinConfigurations,

        [Parameter()]
        [System.Boolean]
        $EnableSingleSignOn,

        [Parameter()]
        [System.String]
        $ImageDisplayName,

        [Parameter()]
        [System.String]
        $ImageId,

        [Parameter()]
        [ValidateSet('gallery', 'custom')]
        [System.String]
        $ImageType,

        [Parameter()]
        [System.Boolean]
        $LocalAdminEnabled,

        [Parameter()]
        [ValidateSet('dedicated', 'shared', 'sharedByUser', 'sharedByEntraGroup', 'reserve')]
        [System.String]
        $ProvisioningType,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [ValidateSet('cloudPc', 'cloudApp')]
        [System.String]
        $UserExperienceType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsSettings,

        [Parameter()]
        [System.String]
        $Id,

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
        [array]$getValue = Get-MgBetaDeviceManagementVirtualEndpointProvisioningPolicy `
            -Filter $Filter `
            -ExpandProperty 'assignments' `
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
            if ($null -ne $Results.Autopatch)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Autopatch `
                    -CIMInstanceName 'MicrosoftGraphCloudPcProvisioningPolicyAutopatch'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Autopatch = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Autopatch') | Out-Null
                }
            }
            if ($null -ne $Results.AutopilotConfiguration)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.AutopilotConfiguration `
                    -CIMInstanceName 'MicrosoftGraphCloudPcAutopilotConfiguration'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.AutopilotConfiguration = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AutopilotConfiguration') | Out-Null
                }
            }
            if ($null -ne $Results.DomainJoinConfigurations)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.DomainJoinConfigurations `
                    -CIMInstanceName 'MicrosoftGraphCloudPcDomainJoinConfiguration'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.DomainJoinConfigurations = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('DomainJoinConfigurations') | Out-Null
                }
            }
            if ($null -ne $Results.MicrosoftManagedDesktop)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.MicrosoftManagedDesktop `
                    -CIMInstanceName 'MicrosoftGraphMicrosoftManagedDesktop'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.MicrosoftManagedDesktop = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MicrosoftManagedDesktop') | Out-Null
                }
            }
            if ($null -ne $Results.WindowsSetting)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.WindowsSetting `
                    -CIMInstanceName 'MicrosoftGraphCloudPcWindowsSetting'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.WindowsSetting = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('WindowsSetting') | Out-Null
                }
            }
            if ($null -ne $Results.WindowsSettings)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.WindowsSettings `
                    -CIMInstanceName 'MicrosoftGraphCloudPcWindowsSettings'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.WindowsSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('WindowsSettings') | Out-Null
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
                -NoEscape @('Assignments', 'Autopatch', 'AutopilotConfiguration', 'DomainJoinConfigurations', 'MicrosoftManagedDesktop', 'WindowsSetting', 'WindowsSettings')
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
        ExcludedProperties = @('GeographicLocationType', 'ProvisioningType', 'UserExperienceType')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
