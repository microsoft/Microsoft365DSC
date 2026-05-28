Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneUserSettingsPolicyWindows365'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CrossRegionDisasterRecoverySetting,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $LocalAdminEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $NotificationSetting,

        [Parameter()]
        [System.Boolean]
        $ResetEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RestorePointSetting,

        [Parameter(Mandatory = $true)]
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

    Write-Verbose -Message "Getting configuration for the Intune User Settings Policy for Windows365 with Id {$Id} and DisplayName {$DisplayName}"

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
                $getValue = Get-MgBetaDeviceManagementVirtualEndpointUserSetting -CloudPcUserSettingId $Id -ExpandProperty 'assignments' -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune User Settings Policy for Windows365 with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementVirtualEndpointUserSetting `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" `
                        -ExpandProperty 'assignments' `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune User Settings Policy for Windows365 with DisplayName {$DisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune User Settings Policy for Windows365 with Id {$Id} and DisplayName {$DisplayName} was found"

        #region resource generator code
        $complexCrossRegionDisasterRecoverySetting = @{}
        $complexDisasterRecoveryNetworkSetting = @{}
        if ($null -ne $getValue.CrossRegionDisasterRecoverySetting.DisasterRecoveryNetworkSetting.onPremisesConnectionId)
        {
            $onPremisesConnectionDisplayName = (Get-MgBetaDeviceManagementVirtualEndpointOnPremiseConnection -CloudPcOnPremisesConnectionId $getValue.CrossRegionDisasterRecoverySetting.DisasterRecoveryNetworkSetting.onPremisesConnectionId -ErrorAction SilentlyContinue).DisplayName
            $complexDisasterRecoveryNetworkSetting.Add('OnPremisesConnectionId', $onPremisesConnectionDisplayName)
        }
        if ($null -ne $getValue.CrossRegionDisasterRecoverySetting.DisasterRecoveryNetworkSetting.regionGroup)
        {
            $complexDisasterRecoveryNetworkSetting.Add('RegionGroup', $getValue.CrossRegionDisasterRecoverySetting.DisasterRecoveryNetworkSetting.regionGroup)
        }
        if ($null -ne $getValue.CrossRegionDisasterRecoverySetting.DisasterRecoveryNetworkSetting.regionName)
        {
            $complexDisasterRecoveryNetworkSetting.Add('RegionName', $getValue.CrossRegionDisasterRecoverySetting.DisasterRecoveryNetworkSetting.regionName)
        }
        if ($null -ne $getValue.CrossRegionDisasterRecoverySetting.DisasterRecoveryNetworkSetting.'@odata.type')
        {
            $complexDisasterRecoveryNetworkSetting.Add('odataType', $getValue.CrossRegionDisasterRecoverySetting.DisasterRecoveryNetworkSetting.'@odata.type'.ToString())
        }
        if ($complexDisasterRecoveryNetworkSetting.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexDisasterRecoveryNetworkSetting = $null
        }
        $complexCrossRegionDisasterRecoverySetting.Add('DisasterRecoveryNetworkSetting', $complexDisasterRecoveryNetworkSetting)
        if ($null -ne $getValue.CrossRegionDisasterRecoverySetting.disasterRecoveryType)
        {
            $complexCrossRegionDisasterRecoverySetting.Add('DisasterRecoveryType', $getValue.CrossRegionDisasterRecoverySetting.disasterRecoveryType)
        }
        if ($null -ne $getValue.CrossRegionDisasterRecoverySetting.MaintainCrossRegionRestorePointEnabled)
        {
            $complexCrossRegionDisasterRecoverySetting.Add('MaintainCrossRegionRestorePointEnabled', $getValue.CrossRegionDisasterRecoverySetting.MaintainCrossRegionRestorePointEnabled)
        }
        if ($null -ne $getValue.CrossRegionDisasterRecoverySetting.userInitiatedDisasterRecoveryAllowed)
        {
            $complexCrossRegionDisasterRecoverySetting.Add('UserInitiatedDisasterRecoveryAllowed', $getValue.CrossRegionDisasterRecoverySetting.userInitiatedDisasterRecoveryAllowed)
        }
        if ($complexCrossRegionDisasterRecoverySetting.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexCrossRegionDisasterRecoverySetting = $null
        }

        $complexNotificationSetting = @{}
        $complexNotificationSetting.Add('RestartPromptsDisabled', $getValue.NotificationSetting.restartPromptsDisabled)
        if ($complexNotificationSetting.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexNotificationSetting = $null
        }

        $complexRestorePointSetting = @{}
        if ($null -ne $getValue.RestorePointSetting.frequencyType)
        {
            $complexRestorePointSetting.Add('FrequencyType', $getValue.RestorePointSetting.frequencyType)
        }
        $complexRestorePointSetting.Add('UserRestoreEnabled', $getValue.RestorePointSetting.userRestoreEnabled)
        if ($complexRestorePointSetting.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexRestorePointSetting = $null
        }
        #endregion

        $results = @{
            #region resource generator code
            CrossRegionDisasterRecoverySetting = $complexCrossRegionDisasterRecoverySetting
            DisplayName                        = $getValue.DisplayName
            LocalAdminEnabled                  = $getValue.LocalAdminEnabled
            NotificationSetting                = $complexNotificationSetting
            ResetEnabled                       = $getValue.ResetEnabled
            RestorePointSetting                = $complexRestorePointSetting
            Id                                 = $getValue.Id
            Ensure                             = 'Present'
            Credential                         = $Credential
            ApplicationId                      = $ApplicationId
            TenantId                           = $TenantId
            ApplicationSecret                  = $ApplicationSecret
            CertificateThumbprint              = $CertificateThumbprint
            CertificatePath                    = $CertificatePath
            CertificatePassword                = $CertificatePassword
            ManagedIdentity                    = $ManagedIdentity.IsPresent
            #endregion
        }
        $assignmentsValues = $getValue.Assignments
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
        [Microsoft.Management.Infrastructure.CimInstance]
        $CrossRegionDisasterRecoverySetting,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $LocalAdminEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $NotificationSetting,

        [Parameter()]
        [System.Boolean]
        $ResetEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RestorePointSetting,

        [Parameter(Mandatory = $true)]
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

    Write-Verbose -Message "Setting configuration of the Intune User Settings Policy for Windows365 with Id {$Id} and DisplayName {$DisplayName}"

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

    if ($CrossRegionDisasterRecoverySetting.UserInitiatedDisasterRecoveryAllowed -and $CrossRegionDisasterRecoverySetting.DisasterRecoveryType -ne 'premium')
    {
        throw "The property UserInitiatedDisasterRecoveryAllowed can only be set to 'True' when DisasterRecoveryType is configured as 'premium'."
    }

    $currentInstance = Get-TargetResource @PSBoundParameters
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if (-not [System.String]::IsNullOrEmpty($boundParameters.CrossRegionDisasterRecoverySetting.DisasterRecoveryNetworkSetting.OnPremisesConnectionId))
    {
        $onPremisesConnection = Get-MgBetaDeviceManagementVirtualEndpointOnPremiseConnection -Filter "DisplayName eq '$($boundParameters.CrossRegionDisasterRecoverySetting.DisasterRecoveryNetworkSetting.OnPremisesConnectionId -replace "'", "''")'" -ErrorAction SilentlyContinue
        if ($null -ne $onPremisesConnection)
        {
            $boundParameters.CrossRegionDisasterRecoverySetting.DisasterRecoveryNetworkSetting.OnPremisesConnectionId = $onPremisesConnection.Id
        }
        else
        {
            throw "Could not find an On-Premises Connection with DisplayName {$($boundParameters.CrossRegionDisasterRecoverySetting.DisasterRecoveryNetworkSetting.OnPremisesConnectionId)}"
        }
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune User Settings Policy for Windows365 with DisplayName {$DisplayName}"
        $boundParameters.Remove('Assignments') | Out-Null

        $createParameters = ([Hashtable]$boundParameters).Clone()
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('Id') | Out-Null

        if ($createParameters.crossRegionDisasterRecoverySetting.disasterRecoveryType -eq 'crossRegion')
        {
            $createParameters.crossRegionDisasterRecoverySetting.Add('crossRegionDisasterRecoveryEnabled', $true)
        }

        if ($null -ne $createParameters.crossRegionDisasterRecoverySetting.disasterRecoveryNetworkSetting -and $createParameters.crossRegionDisasterRecoverySetting.disasterRecoveryNetworkSetting.ContainsKey('@odata.type'))
        {
            # The api does not like odataType to be present
            $createParameters.crossRegionDisasterRecoverySetting.disasterRecoveryNetworkSetting.Remove('@odata.type') | Out-Null
        }
        #region resource generator code
        $policy = New-MgBetaDeviceManagementVirtualEndpointUserSetting -BodyParameter $createParameters

        if ($policy.Id)
        {
            $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceConfigurationPolicyAssignment `
                -DeviceConfigurationPolicyId $policy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/virtualEndpoint/userSettings'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune User Settings Policy for Windows365 with Id {$($currentInstance.Id)}"
        $boundParameters.Remove('Assignments') | Out-Null

        $updateParameters = ([Hashtable]$boundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters
        $updateParameters.Remove('Id') | Out-Null

        if ($updateParameters.crossRegionDisasterRecoverySetting.disasterRecoveryType -eq 'crossRegion')
        {
            $updateParameters.crossRegionDisasterRecoverySetting.Add('crossRegionDisasterRecoveryEnabled', $true)
        }

        if ($null -ne $updateParameters.crossRegionDisasterRecoverySetting.disasterRecoveryNetworkSetting -and $updateParameters.crossRegionDisasterRecoverySetting.disasterRecoveryNetworkSetting.ContainsKey('@odata.type'))
        {
            # The api does not like odataType to be present
            $updateParameters.crossRegionDisasterRecoverySetting.disasterRecoveryNetworkSetting.Remove('@odata.type') | Out-Null
        }

        #region resource generator code
        Update-MgBetaDeviceManagementVirtualEndpointUserSetting `
            -CloudPcUserSettingId $currentInstance.Id `
            -BodyParameter $updateParameters
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/virtualEndpoint/userSettings'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune User Settings Policy for Windows365 with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceManagementVirtualEndpointUserSetting -CloudPcUserSettingId $currentInstance.Id
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
        $CrossRegionDisasterRecoverySetting,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $LocalAdminEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $NotificationSetting,

        [Parameter()]
        [System.Boolean]
        $ResetEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RestorePointSetting,

        [Parameter(Mandatory = $true)]
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

    if ($CrossRegionDisasterRecoverySetting.UserInitiatedDisasterRecoveryAllowed -and $CrossRegionDisasterRecoverySetting.DisasterRecoveryType -ne 'premium')
    {
        throw "The property UserInitiatedDisasterRecoveryAllowed can only be set to 'True' when DisasterRecoveryType is configured as 'premium'."
    }

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
        #region resource generator code
        [array]$getValue = Get-MgBetaDeviceManagementVirtualEndpointUserSetting `
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
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            if ($null -ne $Results.CrossRegionDisasterRecoverySetting)
            {
                $complexMapping = @(
                    @{
                        Name            = 'CrossRegionDisasterRecoverySetting'
                        CimInstanceName = 'MicrosoftGraphCloudPcCrossRegionDisasterRecoverySetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'DisasterRecoveryNetworkSetting'
                        CimInstanceName = 'MicrosoftGraphCloudPcDisasterRecoveryNetworkSetting'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.CrossRegionDisasterRecoverySetting `
                    -CIMInstanceName 'MicrosoftGraphcloudPcCrossRegionDisasterRecoverySetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.CrossRegionDisasterRecoverySetting = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('CrossRegionDisasterRecoverySetting') | Out-Null
                }
            }
            if ($null -ne $Results.NotificationSetting)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.NotificationSetting `
                    -CIMInstanceName 'MicrosoftGraphcloudPcNotificationSetting'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.NotificationSetting = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('NotificationSetting') | Out-Null
                }
            }
            if ($null -ne $Results.RestorePointSetting)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.RestorePointSetting `
                    -CIMInstanceName 'MicrosoftGraphcloudPcRestorePointSetting'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.RestorePointSetting = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('RestorePointSetting') | Out-Null
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
                -NoEscape @('Assignments', 'CrossRegionDisasterRecoverySetting', 'NotificationSetting', 'RestorePointSetting')
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
