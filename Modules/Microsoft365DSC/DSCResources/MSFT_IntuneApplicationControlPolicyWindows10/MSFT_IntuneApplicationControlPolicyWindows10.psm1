Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneApplicationControlPolicyWindows10'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [ValidateSet('notConfigured', 'enforceComponentsAndStoreApps', 'auditComponentsAndStoreApps', 'enforceComponentsStoreAppsAndSmartlocker', 'auditComponentsStoreAppsAndSmartlocker')]
        [System.String]
        $AppLockerApplicationControl,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableInShell,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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

    Write-Verbose -Message "Getting configuration of the Intune Endpoint Protection Application Control Policy with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters -ErrorAction Stop

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $policy = $null
            #Retrieve policy general settings
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $policy = Get-MgBetaDeviceManagementIntent -DeviceManagementIntentId $Id -ErrorAction SilentlyContinue
            }

            if ($null -eq $policy)
            {
                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $policy = Get-MgBetaDeviceManagementIntent -All -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" -ErrorAction Stop | Where-Object -FilterScript { $_.TemplateId -eq '63be6324-e3c9-4c97-948a-e7f4b96f0f20' }
                }
            }

            if (([array]$policy).Count -gt 1)
            {
                throw "A policy with a duplicated displayName {'$DisplayName'} was found - Ensure displayName is unique"
            }

            if ($null -eq $policy)
            {
                Write-Verbose -Message "No Endpoint Protection Application Control Policy {$DisplayName} was found"
                return $nullResult
            }
        }
        else
        {
            $policy = $Script:exportedInstance
        }

        #Retrieve policy specific settings
        [array]$settings = Get-MgBetaDeviceManagementIntentSetting -DeviceManagementIntentId $policy.Id -ErrorAction Stop
        $settingAppLockerApplicationControl = ($settings | Where-Object -FilterScript { $_.DefinitionId -like '*appLockerApplicationControl' }).ValueJson.Replace("`"", '')
        $settingSmartScreenBlockOverrideForFiles = [System.Convert]::ToBoolean(($settings | Where-Object -FilterScript { $_.DefinitionId -like '*smartScreenBlockOverrideForFiles' }).ValueJson)
        $settingSmartScreenEnableInShell = [System.Convert]::ToBoolean(($settings | Where-Object -FilterScript { $_.DefinitionId -like '*smartScreenEnableInShell' }).ValueJson)
        Write-Verbose -Message "Found Endpoint Protection Application Control Policy {$DisplayName}"

        $returnHashtable = @{
            Description                      = $policy.Description
            DisplayName                      = $policy.DisplayName
            RoleScopeTagIds                  = $policy.RoleScopeTagIds
            AppLockerApplicationControl      = $settingAppLockerApplicationControl
            SmartScreenBlockOverrideForFiles = $settingSmartScreenBlockOverrideForFiles
            SmartScreenEnableInShell         = $settingSmartScreenEnableInShell
            Ensure                           = 'Present'
            Credential                       = $Credential
            ApplicationId                    = $ApplicationId
            TenantId                         = $TenantId
            ApplicationSecret                = $ApplicationSecret
            CertificateThumbprint            = $CertificateThumbprint
            AccessTokens                     = $AccessTokens
        }

        $returnAssignments = @()
        $graphAssignments = Get-MgBetaDeviceManagementIntentAssignment -DeviceManagementIntentId $policy.Id
        if ($graphAssignments.Count -gt 0)
        {
            $returnAssignments += ConvertFrom-IntunePolicyAssignment -Assignments $graphAssignments -IncludeDeviceFilter:$true
        }
        $returnHashtable.Add('Assignments', $returnAssignments)
        return $returnHashtable
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
        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [ValidateSet('notConfigured', 'enforceComponentsAndStoreApps', 'auditComponentsAndStoreApps', 'enforceComponentsStoreAppsAndSmartlocker', 'auditComponentsStoreAppsAndSmartlocker')]
        [System.String]
        $AppLockerApplicationControl,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableInShell,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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

    Write-Warning -Message "This resource is deprecated. Please use 'IntuneDeviceConfigurationEndpointProtectionPolicyWindows10'."

    Write-Verbose -Message "Setting configuration of the Intune Application Control Policy for Windows10 with DisplayName {$DisplayName}"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $policyTemplateID = '63be6324-e3c9-4c97-948a-e7f4b96f0f20'
    $currentPolicy = Get-TargetResource @PSBoundParameters
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Endpoint Protection Application Control Policy {$DisplayName}"
        $boundParameters.Remove('DisplayName') | Out-Null
        $boundParameters.Remove('Description') | Out-Null
        $boundParameters.Remove('Assignments') | Out-Null

        $settings = Get-M365DSCIntuneDeviceConfigurationSettings `
            -Properties ([System.Collections.Hashtable]$boundParameters) `
            -TemplateId $policyTemplateID

        $policy = New-MgBetaDeviceManagementIntent -DisplayName $DisplayName `
            -Description $Description `
            -TemplateId $policyTemplateID `
            -Settings $Settings

        #region Assignments
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/intents'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Application Control Policy {$DisplayName}"
        $appControlPolicy = Get-MgBetaDeviceManagementIntent `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.TemplateId -eq $policyTemplateID -and `
                $_.displayName -eq $($DisplayName) }

        $boundParameters.Remove('DisplayName') | Out-Null
        $boundParameters.Remove('Description') | Out-Null
        $boundParameters.Remove('Assignments') | Out-Null

        Update-MgBetaDeviceManagementIntent -ErrorAction Stop `
            -Description $Description `
            -DeviceManagementIntentId $appControlPolicy.Id

        $settings = Get-M365DSCIntuneDeviceConfigurationSettings `
            -Properties ([System.Collections.Hashtable]$boundParameters) `
            -TemplateId $policyTemplateID

        $Uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceManagement/intents/$($appControlPolicy.Id)/updateSettings"
        $body = @{'settings' = $settings }
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body ($body | ConvertTo-Json -Depth 20) -ContentType 'application/json' 4> $null

        #region Assignments
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $appControlPolicy.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/intents'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Endpoint Protection Application Control Policy {$DisplayName}"
        $appControlPolicy = Get-MgBetaDeviceManagementIntent `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.TemplateId -eq '63be6324-e3c9-4c97-948a-e7f4b96f0f20' -and `
                $_.displayName -eq $($DisplayName) }

        Remove-MgBetaDeviceManagementIntent -DeviceManagementIntentId $appControlPolicy.Id -ErrorAction Stop
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [ValidateSet('notConfigured', 'enforceComponentsAndStoreApps', 'auditComponentsAndStoreApps', 'enforceComponentsStoreAppsAndSmartlocker', 'auditComponentsStoreAppsAndSmartlocker')]
        [System.String]
        $AppLockerApplicationControl,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableInShell,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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

    Write-Warning -Message "This resource is deprecated. Please use 'IntuneDeviceConfigurationEndpointProtectionPolicyWindows10'."

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $dscContent = [System.Text.StringBuilder]::new()
    $i = 1

    try
    {
        $policyTemplateID = '63be6324-e3c9-4c97-948a-e7f4b96f0f20'
        [array]$policies = Get-MgBetaDeviceManagementIntent -All -Filter $Filter `
            -ErrorAction Stop | Where-Object -FilterScript { $_.TemplateId -eq $policyTemplateID }
        if ($policies.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($policy in $policies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($policies.Count)] $($policy.DisplayName)" -DeferWrite

            $params = @{
                DisplayName           = $policy.DisplayName
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

            $Script:exportedInstance = $policy
            $Results = Get-TargetResource @params

            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ([Array]$Results.Assignments) -CIMInstanceName DeviceManagementConfigurationPolicyAssignments

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

            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName

            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
        }
        return $dscContent.ToString()
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
                $_.Exception -like '*Unable to perform redirect as Location Header is not set in response*' -or `
                $_.Exception -like '*Request not applicable to target tenant*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            throw
        }
    }
}

Export-ModuleMember -Function *-TargetResource
