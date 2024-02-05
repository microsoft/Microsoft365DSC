function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $AttackSurfaceReductionOnlyExclusions,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $AttackSurfaceReductionRules,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockAbuseOfExploitedVulnerableSignedDrivers,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockAdobeReaderFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockAllOfficeApplicationsFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockExecutableContentFromEmailClientAndWebmail,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockExecutionOfPotentiallyObfuscatedScripts,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockOfficeApplicationsFromCreatingExecutableContent,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockOfficeApplicationsFromInjectingCodeIntoOtherProcesses,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockOfficeCommunicationAppFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockPersistenceThroughWMIEventSubscription,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockProcessCreationsFromPSExecAndWMICommands,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockUntrustedUnsignedProcessesThatRunFromUSB,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockWebShellCreationForServers,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockWin32APICallsFromOfficeMacros,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $UseAdvancedProtectionAgainstRansomware,

        [Parameter()]
        [System.String[]]
        $ControlledFolderAccessProtectedFolders,

        [Parameter()]
        [System.String[]]
        $ControlledFolderAccessAllowedApplications,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $EnableControlledFolderAccess,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
        $ManagedIdentity
    )

    Write-Verbose -Message "Checking for the Intune Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ErrorAction Stop

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

    $templateReferenceId = 'e8c053d6-9f95-42b1-a7f1-ebfd71c67a4b_1'

    try
    {
        #Retrieve policy general settings
        $policy = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Identity -ErrorAction silentlyContinue

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Endpoint Protection Attack Surface Protection rules Policy {$Identity} was found"
            $policy = Get-MgBetaDeviceManagementConfigurationPolicy | Where-Object -FilterScript { $_.Name -eq "$DisplayName" -and $_.templateReference.TemplateId -eq "$templateReferenceId" }

            if ($policy.Count -gt 1)
            {
                throw "Multiple Endpoint Protection Attack Surface Protection rules Policies with DisplayName '{$DisplayName}' were found!"
            }
        }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Endpoint Protection Attack Surface Protection rules Policy {$DisplayName} was found"
            return $nullResult
        }


        #Retrieve policy specific settings
        [array]$settings = Get-MgBetaDeviceManagementConfigurationPolicySetting `
            -DeviceManagementConfigurationPolicyId $policy.Id `
            -ErrorAction Stop

        $returnHashtable = @{}
        $returnHashtable.Add('Identity', $policy.Id)
        $returnHashtable.Add('DisplayName', $policy.name)
        $returnHashtable.Add('Description', $policy.description)

        foreach ($setting in $settings.SettingInstance)
        {
            switch ($setting.AdditionalProperties.'@odata.type')
            {
                '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                {
                    foreach ($settingInstance in $setting.AdditionalProperties.groupSettingCollectionValue.children)
                    {
                        $settingName = $settingInstance.settingDefinitionId.split('_') | Select-Object -Last 1
                        [String]$settingValue = $settingInstance.choiceSettingValue.value.split('_') | Select-Object -Last 1
                        $returnHashtable.Add($settingName, $settingValue)
                    }
                }
                '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                {
                    $settingName = $setting.settingDefinitionId.split('_') | Select-Object -Last 1
                    [String]$settingValue = $setting.AdditionalProperties.choiceSettingValue.value.split('_') | Select-Object -Last 1
                    $returnHashtable.Add($settingName, $settingValue)
                }
                '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
                {
                    $settingName = $setting.settingDefinitionId.split('_') | Select-Object -Last 1
                    [Array]$settingValue = $setting.AdditionalProperties.simpleSettingCollectionValue.value
                    $returnHashtable.Add($settingName, $settingValue)
                }
                Default
                {
                }
            }
        }

        $returnAssignments = Get-MgBetaDeviceManagementConfigurationPolicyAssignment -DeviceManagementConfigurationPolicyId $policy.Id
        if ($returnAssignments.Count -gt 0)
        {
            $assignmentResult = ConvertFrom-IntunePolicyAssignment -Assignments $returnAssignments
        }
        else
        {
            $assignmentResult = @()
        }
        $returnHashtable.Add('Assignments', $assignmentResult)

        Write-Verbose -Message "Found Endpoint Protection Attack Surface Protection rules Policy {$($policy.name)}"

        $returnHashtable.Add('Ensure', 'Present')
        $returnHashtable.Add('Credential', $Credential)
        $returnHashtable.Add('ApplicationId', $ApplicationId)
        $returnHashtable.Add('TenantId', $TenantId)
        $returnHashtable.Add('ApplicationSecret', $ApplicationSecret)
        $returnHashtable.Add('CertificateThumbprint', $CertificateThumbprint)
        $returnHashtable.Add('ManagedIdentity', $ManagedIdentity.IsPresent)

        return $returnHashtable
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
        [Parameter()]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $AttackSurfaceReductionOnlyExclusions,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $AttackSurfaceReductionRules,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockAbuseOfExploitedVulnerableSignedDrivers,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockAdobeReaderFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockAllOfficeApplicationsFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockExecutableContentFromEmailClientAndWebmail,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockExecutionOfPotentiallyObfuscatedScripts,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockOfficeApplicationsFromCreatingExecutableContent,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockOfficeApplicationsFromInjectingCodeIntoOtherProcesses,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockOfficeCommunicationAppFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockPersistenceThroughWMIEventSubscription,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockProcessCreationsFromPSExecAndWMICommands,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockUntrustedUnsignedProcessesThatRunFromUSB,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockWebShellCreationForServers,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockWin32APICallsFromOfficeMacros,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $UseAdvancedProtectionAgainstRansomware,

        [Parameter()]
        [System.String[]]
        $ControlledFolderAccessProtectedFolders,

        [Parameter()]
        [System.String[]]
        $ControlledFolderAccessAllowedApplications,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $EnableControlledFolderAccess,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
        $ManagedIdentity
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

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null

    $templateReferenceId = 'e8c053d6-9f95-42b1-a7f1-ebfd71c67a4b_1'

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"

        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $settings = Format-M365DSCIntuneSettingCatalogASRRulesPolicySettings `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters) `
            -TemplateReferenceId $templateReferenceId

        $policy = New-IntuneDeviceConfigurationPolicy `
            -Name $DisplayName `
            -Description $Description `
            -Platforms 'windows10' `
            -TemplateReferenceId $templateReferenceId `
            -Technologies 'mdm,microsoftSense' `
            -Settings $settings

        #region Assignments
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        if ($policy.id)
        {
            $intuneAssignments = [Hashtable[]] (ConvertTo-IntunePolicyAssignment -Assignments $assignmentsHash)
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets ([Array]($intuneAssignments.target))
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $settings = Format-M365DSCIntuneSettingCatalogASRRulesPolicySettings `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters) `
            -TemplateReferenceId $templateReferenceId

        #write-verbose -message ($settings|convertto-json -Depth 20)

        Update-IntuneDeviceConfigurationPolicy `
            -DeviceConfigurationPolicyId $currentPolicy.Identity `
            -Name $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
            -Platforms 'windows10' `
            -Technologies 'mdm,microsoftSense' `
            -Settings $settings

        #region Assignments
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        $intuneAssignments = [Hashtable[]] (ConvertTo-IntunePolicyAssignment -Assignments $assignmentsHash)
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $currentPolicy.Identity `
            -Targets ([Array]($intuneAssignments.target))
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"
        Remove-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Identity
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $AttackSurfaceReductionOnlyExclusions,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $AttackSurfaceReductionRules,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockAbuseOfExploitedVulnerableSignedDrivers,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockAdobeReaderFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockAllOfficeApplicationsFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockExecutableContentFromEmailClientAndWebmail,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockExecutionOfPotentiallyObfuscatedScripts,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockOfficeApplicationsFromCreatingExecutableContent,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockOfficeApplicationsFromInjectingCodeIntoOtherProcesses,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockOfficeCommunicationAppFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockPersistenceThroughWMIEventSubscription,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockProcessCreationsFromPSExecAndWMICommands,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockUntrustedUnsignedProcessesThatRunFromUSB,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockWebShellCreationForServers,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $BlockWin32APICallsFromOfficeMacros,

        [Parameter()]
        [ValidateSet('off', 'block', 'audit', 'warn')]
        [System.String]
        $UseAdvancedProtectionAgainstRansomware,

        [Parameter()]
        [System.String[]]
        $ControlledFolderAccessProtectedFolders,

        [Parameter()]
        [System.String[]]
        $ControlledFolderAccessAllowedApplications,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $EnableControlledFolderAccess,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
        $ManagedIdentity
    )
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
    Write-Verbose -Message "Testing configuration of Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

    if ($CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message 'The policy was not found'
        return $false
    }
    #region Assignments
    $testResult = $true

    if ((-not $CurrentValues.Assignments) -xor (-not $ValuesToCheck.Assignments))
    {
        Write-Verbose -Message 'Configuration drift: one the assignment is null'
        return $false
    }

    if ($CurrentValues.Assignments)
    {
        if ($CurrentValues.Assignments.count -ne $ValuesToCheck.Assignments.count)
        {
            Write-Verbose -Message "Configuration drift: Number of assignment has changed - current {$($CurrentValues.Assignments.count)} target {$($ValuesToCheck.Assignments.count)}"
            return $false
        }
        foreach ($assignment in $CurrentValues.Assignments)
        {
            #GroupId Assignment
            if (-not [String]::IsNullOrEmpty($assignment.groupId))
            {
                $source = [Array]$ValuesToCheck.Assignments | Where-Object -FilterScript { $_.groupId -eq $assignment.groupId }
                if (-not $source)
                {
                    Write-Verbose -Message "Configuration drift: groupId {$($assignment.groupId)} not found"
                    $testResult = $false
                    break
                }
                $sourceHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $source
                $testResult = Compare-M365DSCComplexObject -Source $sourceHash -Target $assignment
            }
            #GroupDisplayName Assignment
            if (-not [String]::IsNullOrEmpty($assignment.groupDisplayName))
            {
                $source = [Array]$ValuesToCheck.Assignments | Where-Object -FilterScript { $_.groupDisplayName -eq $assignment.groupDisplayName }
                if (-not $source)
                {
                    Write-Verbose -Message "Configuration drift: groupDisplayName {$($assignment.groupDisplayName)} not found"
                    $testResult = $false
                    break
                }
                $sourceHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $source
                $testResult = Compare-M365DSCComplexObject -Source $sourceHash -Target $assignment
            }
            #AllDevices/AllUsers assignment
            else
            {
                $source = [Array]$ValuesToCheck.Assignments | Where-Object -FilterScript { $_.dataType -eq $assignment.dataType }
                if (-not $source)
                {
                    Write-Verbose -Message "Configuration drift: {$($assignment.dataType)} not found"
                    $testResult = $false
                    break
                }
                $sourceHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $source
                $testResult = Compare-M365DSCComplexObject -Source $sourceHash -Target $assignment
            }

            if (-not $testResult)
            {
                $testResult = $false
                break
            }
        }
    }
    if (-not $testResult)
    {
        return $false
    }
    $ValuesToCheck.Remove('Assignments') | Out-Null
    #endregion

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"
    #return $false
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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
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

    $dscContent = ''
    $i = 1

    try
    {
        $policyTemplateID = 'e8c053d6-9f95-42b1-a7f1-ebfd71c67a4b_1'
        [array]$policies = Get-MgBetaDeviceManagementConfigurationPolicy `
            -ErrorAction Stop `
            -All:$true

        $policies = $policies | Where-Object -FilterScript { $_.TemplateReference.TemplateId -eq $policyTemplateId }

        if ($policies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.Name)" -NoNewline

            $params = @{
                Identity              = $policy.id
                DisplayName           = $policy.Name
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
            }

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

            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

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

function Format-M365DSCParamsToSettingInstance
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $DSCParams,

        [Parameter()]
        $TemplateSetting,

        [Parameter()]
        [System.Boolean]
        $IncludeSettingInstanceTemplateId = $true,

        [Parameter()]
        [System.Boolean]
        $IncludeSettingValueTemplateId = $true
    )

    $DSCParams.Remove('Verbose') | Out-Null
    $results = @()

    foreach ($param in $DSCParams.Keys)
    {
        $settingInstance = [ordered]@{}
        $settingInstance.add('settingDefinitionId', $templateSetting.settingDefinitionId)
        if ($IncludeSettingInstanceTemplateId -and -Not [string]::IsNullOrEmpty($templateSetting.settingInstanceTemplateId))
        {
            $settingInstance.add('settingInstanceTemplateReference', @{'settingInstanceTemplateId' = $templateSetting.settingInstanceTemplateId })
        }

        $odataType = $templateSetting.AdditionalProperties.'@odata.type'
        if ([string]::IsNullOrEmpty($odataType))
        {
            $odataType = $templateSetting.'@odata.type'
        }
        $settingInstance.add('@odata.type', $odataType.replace('Template', ''))

        switch ($odataType)
        {
            '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
            {
                $choiceSettingValue = [ordered]@{}
                $choiceSettingValue.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue')
                $choiceSettingValue.add('children', @())
                $settingValueTemplateId = $templateSetting.AdditionalProperties.choiceSettingValueTemplate.settingValueTemplateId
                if ($IncludeSettingValueTemplateId -and -Not [string]::IsNullOrEmpty($settingValueTemplateId))
                {
                    $choiceSettingValue.add('settingValueTemplateReference', @{'settingValueTemplateId' = $SettingValueTemplateId })
                }
                $choiceSettingValue.add('value', "$($templateSetting.settingDefinitionId)`_$($DSCParams.$param)")
                $settingInstance.add('choiceSettingValue', $choiceSettingValue)
                $results += $settingInstance
            }
            '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstanceTemplate'
            {
                $simpleSettingCollectionValues = @()

                foreach ($value in $DSCParams.$param)
                {
                    $simpleSettingCollectionValue = @{}
                    $settingValueTemplateId = $templateSetting.AdditionalProperties.simpleSettingCollectionValueTemplate.settingValueTemplateId
                    if ($IncludeSettingValueTemplateId -and -Not [string]::IsNullOrEmpty($settingValueTemplateId))
                    {
                        $simpleSettingCollectionValue.add('settingValueTemplateReference', @{'settingValueTemplateId' = $SettingValueTemplateId })
                    }
                    $settingValueDataType = $templateSetting.AdditionalProperties.simpleSettingCollectionValueTemplate.'@odata.type'.replace('Template', '')
                    $simpleSettingCollectionValue.add('@odata.type', $settingValueDataType)
                    $simpleSettingCollectionValue.add('value', $value)
                    $simpleSettingCollectionValues += $simpleSettingCollectionValue
                }
                $settingInstance.add('simpleSettingCollectionValue', $simpleSettingCollectionValues)

                $results += $settingInstance
            }
            '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstanceTemplate'
            {
                $simpleSettingValue = @{}
                $SettingValueType = $templateSetting.AdditionalProperties.simpleSettingValueTemplate.'@odata.type'
                if (-Not [string]::IsNullOrEmpty($SettingValueType))
                {
                    $simpleSettingValue.add('@odata.type', $SettingValueType.replace('Template', ''))
                }
                $simpleSettingValue.add('value', $DSCParams.$param)

                $settingValueTemplateId = $templateSetting.AdditionalProperties.simpleSettingValueTemplate.settingValueTemplateId
                if (-Not [string]::IsNullOrEmpty($settingValueTemplateId))
                {
                    $simpleSettingValue.add('settingValueTemplateReference', @{'settingValueTemplateId' = $settingValueTemplateId })
                }

                $settingInstance.add('simpleSettingValue', $simpleSettingValue)
                $results += $settingInstance
            }
        }
    }

    if ($results.count -eq 1)
    {
        return $results[0]
    }

    return $results
}

function Format-M365DSCIntuneSettingCatalogASRRulesPolicySettings
{
    [CmdletBinding()]
    [OutputType([System.Array])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $DSCParams,

        [Parameter(Mandatory = 'true')]
        [System.String]
        $templateReferenceId
    )

    $DSCParams.Remove('Identity') | Out-Null
    $DSCParams.Remove('DisplayName') | Out-Null
    $DSCParams.Remove('Description') | Out-Null

    $settings = @()

    $templateSettings = Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate -DeviceManagementConfigurationPolicyTemplateId $templateReferenceId

    $simpleSettings = @()
    $simpleSettings += $templateSettings.SettingInstanceTemplate | Where-Object -FilterScript `
    { $_.AdditionalProperties.'@odata.type' -ne '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstanceTemplate' }
    foreach ($templateSetting in $simpleSettings)
    {
        $setting = @{}
        $settingKey = $DSCParams.keys | Where-Object -FilterScript { $templateSetting.settingDefinitionId -like "*$($_)" }
        if ((-not [String]::IsNullOrEmpty($settingKey)) -and $DSCParams."$settingKey")
        {
            $setting.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationSetting')
            $myFormattedSetting = Format-M365DSCParamsToSettingInstance -DSCParams @{$settingKey = $DSCParams."$settingKey" } `
                -TemplateSetting $templateSetting

            $setting.add('settingInstance', $myFormattedSetting)
            $settings += $setting
            $DSCParams.Remove($settingKey) | Out-Null
        }
    }

    #Prepare attacksurfacereductionrules groupCollectionTemplateSettings
    $groupCollectionTemplateSettings = @()
    $groupCollectionTemplateSettings += $templateSettings.SettingInstanceTemplate | Where-Object -FilterScript `
    { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstanceTemplate' }

    foreach ($groupCollectionTemplateSetting in $groupCollectionTemplateSettings)
    {
        $setting = @{}
        $setting.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationSetting')
        $settingInstance = [ordered]@{}
        $settingInstance.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance')
        $settingInstance.add('settingDefinitionId', $groupCollectionTemplateSetting.settingDefinitionId)
        $settingInstance.add('settingInstanceTemplateReference', @{
                '@odata.type'               = '#microsoft.graph.deviceManagementConfigurationSettingInstanceTemplateReference'
                'settingInstanceTemplateId' = $groupCollectionTemplateSetting.settingInstanceTemplateId
            })
        $groupSettingCollectionValues = @()
        $groupSettingCollectionValueChildren = @()
        $groupSettingCollectionValue = @{}
        $groupSettingCollectionValue.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationGroupSettingValue')

        $settingValueTemplateId = $groupCollectionTemplateSetting.AdditionalProperties.groupSettingCollectionValueTemplate.settingValueTemplateId
        if (-Not [string]::IsNullOrEmpty($settingValueTemplateId))
        {
            $groupSettingCollectionValue.add('settingValueTemplateReference', @{'settingValueTemplateId' = $SettingValueTemplateId })
        }

        foreach ($key in $DSCParams.keys)
        {
            $templateValue = $groupCollectionTemplateSetting.AdditionalProperties.groupSettingCollectionValueTemplate.children | Where-Object `
                -FilterScript { $_.settingDefinitionId -like "*$key" }
            if ($templateValue)
            {
                $groupSettingCollectionValueChild = Format-M365DSCParamsToSettingInstance `
                    -DSCParams @{$key = $DSCParams."$key" } `
                    -TemplateSetting $templateValue `
                    -IncludeSettingValueTemplateId $false `
                    -IncludeSettingInstanceTemplateId $false

                $groupSettingCollectionValueChildren += $groupSettingCollectionValueChild
            }
        }
        $groupSettingCollectionValue.add('children', $groupSettingCollectionValueChildren)
        $groupSettingCollectionValues += $groupSettingCollectionValue
        $settingInstance.add('groupSettingCollectionValue', $groupSettingCollectionValues)
        $setting.add('settingInstance', $settingInstance)

        if ($setting.settingInstance.groupSettingCollectionValue.children.count -gt 0)
        {
            $settings += $setting
        }
    }

    return $settings
}

function New-IntuneDeviceConfigurationPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

        [Parameter(Mandatory = 'true')]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Platforms,

        [Parameter()]
        [System.String]
        $Technologies,

        [Parameter()]
        [System.String]
        $TemplateReferenceId,

        [Parameter()]
        [Array]
        $Settings
    )

    try
    {
        $Uri = 'https://graph.microsoft.com/beta/deviceManagement/configurationPolicies'

        $policy = @{
            'name'              = $Name
            'description'       = $Description
            'platforms'         = $Platforms
            'technologies'      = $Technologies
            'templateReference' = @{'templateId' = $TemplateReferenceId }
            'settings'          = $Settings
        }
        $body = $policy | ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $null
    }
}

function Update-IntuneDeviceConfigurationPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Platforms,

        [Parameter()]
        [System.String]
        $Technologies,

        [Parameter()]
        [System.String]
        $TemplateReferenceId,

        [Parameter()]
        [Array]
        $Settings
    )

    try
    {
        $Uri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$DeviceConfigurationPolicyId"

        $policy = @{
            'name'              = $Name
            'description'       = $Description
            'platforms'         = $Platforms
            'templateReference' = @{'templateId' = $TemplateReferenceId }
            'technologies'      = $Technologies
            'settings'          = $Settings
        }
        $body = $policy | ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method PUT -Uri $Uri -Body $body -ErrorAction Stop
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $null
    }
}

Export-ModuleMember -Function *-TargetResource
