Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneWindowsAutopilotDevicePreparationUserDrivenPolicy'

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
        [ValidateSet(0)]
        [System.Int32]
        $DeploymentMode,

        [Parameter()]
        [ValidateSet(0)]
        [System.Int32]
        $DeploymentType,

        [Parameter()]
        [ValidateSet(0)]
        [System.Int32]
        $JoinType,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AccountType,

        [Parameter()]
        [ValidateRange(15, 720)]
        [System.Int32]
        $Timeout,

        [Parameter()]
        [System.String]
        $CustomErrorMessage,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $AllowSkip,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $AllowDiagnostics,

        [Parameter()]
        [System.String]
        $AssignmentTarget,

        [Parameter()]
        [ValidateLength(0, 1000)]
        [System.String[]]
        $AllowedApplications,

        [Parameter()]
        [ValidateLength(0, 1000)]
        [System.String[]]
        $AllowedScripts,

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

    Write-Verbose -Message "Getting configuration for the Intune Windows Autopilot Device Preparation User Driven Policy with Id {$Id} and Name {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Name -ne $DisplayName)
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
                $getValue = Invoke-M365DSCCommand -ScriptBlock {
                    Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Id  -ErrorAction Stop `
                        -ExpandProperty 'settings($expand=settingDefinitions)'
                } -SuppressNotFoundError
                $settings = $getValue.settings
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Windows Autopilot Device Preparation User Driven Policy with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Invoke-M365DSCCommand -ScriptBlock {
                        Get-MgBetaDeviceManagementConfigurationPolicy `
                            -All `
                            -Filter "Name eq '$($DisplayName -replace "'", "''")'" `
                            -ErrorAction SilentlyContinue
                    }
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Windows Autopilot Device Preparation User Driven Policy with Name {$DisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
            $settings = $getValue.settings
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Windows Autopilot Device Preparation User Driven Policy with Id {$Id} and Name {$DisplayName} was found"

        # Retrieve policy specific settings
        if ($null -eq $settings)
        {
            [array]$settings = Get-MgBetaDeviceManagementConfigurationPolicySetting `
                -DeviceManagementConfigurationPolicyId $Id `
                -ExpandProperty 'settingDefinitions' `
                -All `
                -ErrorAction Stop
        }

        $policySettings = @{}
        $policySettings = Export-IntuneSettingCatalogPolicySettings -Settings $settings -ReturnHashtable $policySettings

        $batchRequestsScripts = @()
        $batchRequestsApps = @()

        foreach ($script in $policySettings.AllowedScriptIds)
        {
            $batchRequestsScripts += @{
                id = $script
                method = 'GET'
                url = "/deviceManagement/deviceManagementScripts/$($script)?`$select=id,displayName"
            }
        }
        foreach ($app in $policySettings.AllowedApplicationIds)
        {
            $convertedApp = $app | ConvertFrom-Json
            $batchRequestsApps += @{
                id = $convertedApp.id
                method = 'GET'
                url = "/deviceAppManagement/mobileApps/$($convertedApp.id)?`$select=id,displayName"
            }
        }
        $policySettings.Remove('AllowedScriptIds')
        $policySettings.Remove('AllowedApplicationIds')

        $batchResponsesScripts = Invoke-M365DSCGraphBatchRequest -Requests $batchRequestsScripts
        $batchResponsesApps = Invoke-M365DSCGraphBatchRequest -Requests $batchRequestsApps

        $results = @{
            #region resource generator code
            Description                       = $getValue.Description
            DisplayName                       = $getValue.Name
            RoleScopeTagIds                   = $getValue.RoleScopeTagIds
            Id                                = $getValue.Id
            AllowedApplications               = Get-M365DSCArrayFromProperty -PropertyValue ($batchResponsesApps | ForEach-Object { $_.body.displayName }) -ElementType ([System.String])
            AllowedScripts                    = Get-M365DSCArrayFromProperty -PropertyValue ($batchResponsesScripts | ForEach-Object { $_.body.displayName }) -ElementType ([System.String])
            Ensure                            = 'Present'
            Credential                        = $Credential
            ApplicationId                     = $ApplicationId
            TenantId                          = $TenantId
            ApplicationSecret                 = $ApplicationSecret
            CertificateThumbprint             = $CertificateThumbprint
            CertificatePath                   = $CertificatePath
            CertificatePassword               = $CertificatePassword
            ManagedIdentity                   = $ManagedIdentity.IsPresent
            #endregion
        }
        $results += $policySettings

        $target = Get-MgBetaDeviceManagementConfigurationPolicyEnrollmentTimeDeviceMembershipTarget -DeviceManagementConfigurationPolicyId $Id
        $assignmentResult = ""
        if ($target.enrollmentTimeDeviceMembershipTargetValidationStatuses.Count -gt 0)
        {
            $groupId = $target.enrollmentTimeDeviceMembershipTargetValidationStatuses[0].targetId
            $resolvedGroup = Get-MgGroup -GroupId $groupId -Property "id, displayName"
            $assignmentResult = $resolvedGroup.displayName
        }
        $results.Add('AssignmentTarget', $assignmentResult)

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
        [ValidateSet(0)]
        [System.Int32]
        $DeploymentMode,

        [Parameter()]
        [ValidateSet(0)]
        [System.Int32]
        $DeploymentType,

        [Parameter()]
        [ValidateSet(0)]
        [System.Int32]
        $JoinType,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AccountType,

        [Parameter()]
        [ValidateRange(15, 720)]
        [System.Int32]
        $Timeout,

        [Parameter()]
        [System.String]
        $CustomErrorMessage,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $AllowSkip,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $AllowDiagnostics,

        [Parameter()]
        [System.String]
        $AssignmentTarget,

        [Parameter()]
        [ValidateLength(0, 1000)]
        [System.String[]]
        $AllowedApplications,

        [Parameter()]
        [ValidateLength(0, 1000)]
        [System.String[]]
        $AllowedScripts,

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

    Write-Verbose -Message "Setting configuration of the Intune Windows Autopilot Device Preparation User Driven Policy with Id {$Id} and Name {$DisplayName}"

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
    $boundParameters = Rename-M365DSCCimInstanceParameter -Properties $boundParameters
    $boundParameters.Remove('AssignmentTarget') | Out-Null

    $templateReferenceId = '80d33118-b7b4-40d8-b15f-81be745e053f_1'
    $platforms = 'windows10'
    $technologies = 'enrollment'

    if ($PSBoundParameters.ContainsKey('AllowedScripts'))
    {
        $batchRequestsScripts = @()
        foreach ($script in $AllowedScripts)
        {
            $batchRequestsScripts += @{
                id = $script
                method = 'GET'
                url = "/deviceManagement/deviceManagementScripts?`$filter=displayName eq '$($script -replace "'", "''")'&`$select=id,displayName"
            }
        }
        $batchResponsesScripts = Invoke-M365DSCGraphBatchRequest -Requests $batchRequestsScripts

        $boundParameters.Remove('AllowedScripts') | Out-Null
        $newScripts = @()
        foreach ($script in $batchResponsesScripts.body.value)
        {
            $newScripts += $script.id
        }
        $boundParameters.Add('allowedScriptIds', $newScripts)
    }

    if ($PSBoundParameters.ContainsKey('AllowedApplications'))
    {
        $batchRequestsApps = @()
        foreach ($app in $AllowedApplications)
        {
            $batchRequestsApps += @{
                id = $app
                method = 'GET'
                url = "/deviceAppManagement/mobileApps?`$filter=displayName eq '$($app -replace "'", "''")'&`$select=id,displayName"
            }
        }
        $batchResponsesApps = Invoke-M365DSCGraphBatchRequest -Requests $batchRequestsApps
        $newApps = @()
        foreach ($app in $batchResponsesApps.body.value)
        {
            $newApps += @{
                id = $app.id
                type = $app.'@odata.type'
            } | ConvertTo-Json -Compress
        }
        $boundParameters.Add('allowedApplicationIds', $newApps)
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Windows Autopilot Device Preparation User Driven Policy with Name {$DisplayName}"
        $boundParameters.Remove("Assignments") | Out-Null

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$boundParameters) `
            -TemplateId $templateReferenceId

        $createParameters = @{
            name              = $DisplayName
            description       = $Description
            templateReference = @{ templateId = $templateReferenceId }
            platforms         = $platforms
            technologies      = $technologies
            settings          = $settings
            roleScopeTagIds   = $RoleScopeTagIds
        }

        #region resource generator code
        $policy = New-MgBetaDeviceManagementConfigurationPolicy -BodyParameter $createParameters

        if ($policy.Id -and $PSBoundParameters.ContainsKey('AssignmentTarget'))
        {
            if (-not [System.String]::IsNullOrEmpty($AssignmentTarget))
            {
                $groupId = Get-MgGroup -Filter "displayName eq '$AssignmentTarget'" -Property "id" -ErrorAction Stop
                Set-MgBetaDeviceManagementConfigurationPolicyEnrollmentTimeDeviceMembershipTarget `
                    -DeviceManagementConfigurationPolicyId $policy.Id `
                    -BodyParameter @{
                        enrollmentTimeDeviceMembershipTargets = @(
                            @{
                                targetId = $groupId.Id
                                targetType = 'staticSecurityGroup'
                            }
                        )
                    }
            }
        }

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
        Write-Verbose -Message "Updating the Intune Windows Autopilot Device Preparation User Driven Policy with Id {$($currentInstance.Id)}"
        $boundParameters.Remove("Assignments") | Out-Null

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$boundParameters) `
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

        if ($PSBoundParameters.ContainsKey('AssignmentTarget'))
        {
            if (-not [System.String]::IsNullOrEmpty($AssignmentTarget))
            {
                $group = Get-MgGroup -Filter "displayName eq '$AssignmentTarget'" -Property "id" -ErrorAction Stop
                Set-MgBetaDeviceManagementConfigurationPolicyEnrollmentTimeDeviceMembershipTarget `
                    -DeviceManagementConfigurationPolicyId $currentInstance.Id `
                    -BodyParameter @{
                        enrollmentTimeDeviceMembershipTargets = @(
                            @{
                                targetId = $group.Id
                                targetType = 'staticSecurityGroup'
                            }
                        )
                    }
            }
            else
            {
                Clear-MgBetaDeviceManagementConfigurationPolicyEnrollmentTimeDeviceMembershipTarget -DeviceManagementConfigurationPolicyId $currentInstance.Id
            }
        }

        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/configurationPolicies'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Windows Autopilot Device Preparation User Driven Policy with Id {$($currentInstance.Id)}"
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
        [ValidateSet(0)]
        [System.Int32]
        $DeploymentMode,

        [Parameter()]
        [ValidateSet(0)]
        [System.Int32]
        $DeploymentType,

        [Parameter()]
        [ValidateSet(0)]
        [System.Int32]
        $JoinType,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AccountType,

        [Parameter()]
        [ValidateRange(15, 720)]
        [System.Int32]
        $Timeout,

        [Parameter()]
        [System.String]
        $CustomErrorMessage,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $AllowSkip,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $AllowDiagnostics,

        [Parameter()]
        [System.String]
        $AssignmentTarget,

        [Parameter()]
        [ValidateLength(0, 1000)]
        [System.String[]]
        $AllowedApplications,

        [Parameter()]
        [ValidateLength(0, 1000)]
        [System.String[]]
        $AllowedScripts,

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
        $policyTemplateID = '80d33118-b7b4-40d8-b15f-81be745e053f_1'
        $baseFilter = "templateReference/templateId eq '$policyTemplateID'"
        if (-not [System.String]::IsNullOrEmpty($Filter))
        {
            $Filter = "($Filter) and ($baseFilter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = Get-M365DSCExportCachedConfigurationPolicies `
            -TemplateId $policyTemplateID `
            -Filter $Filter
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
            if (-not [System.String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            elseif (-not [System.String]::IsNullOrEmpty($config.name))
            {
                $displayedKey = $config.name
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                DisplayName           = $config.Name
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
            $rawResults = $Results.Clone()

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
                -NoEscape @('Assignments') `
                -RawResults $rawResults
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
