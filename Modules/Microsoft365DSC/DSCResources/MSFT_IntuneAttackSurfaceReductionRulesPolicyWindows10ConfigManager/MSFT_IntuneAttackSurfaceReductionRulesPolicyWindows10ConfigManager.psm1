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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Checking for the Intune Endpoint Protection Policy {$DisplayName}"

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

    try
    {
        #Retrieve policy general settings
        if (-not [System.String]::IsNullOrEmpty($Identity))
        {
            $policy = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Identity -ErrorAction Stop
        }
        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Endpoint Protection Policy {id: '$Identity'} was found"
            $policy = Get-MgBetaDeviceManagementConfigurationPolicy -Filter "name eq '$DisplayName'" -ErrorAction SilentlyContinue
            if ($null -eq $policy)
            {
                Write-Verbose -Message "No Endpoint Protection Policy {displayName: '$DisplayName'} was found"
                return $nullResult
            }
        }

        $Identity = $policy.Id

        Write-Verbose -Message "Found Endpoint Protection Policy {$($policy.id):$($policy.Name)}"

        #Retrieve policy specific settings
        [array]$settings = Get-MgBetaDeviceManagementConfigurationPolicySetting `
            -DeviceManagementConfigurationPolicyId $Identity `
            -ErrorAction Stop

        $returnHashtable = @{}
        $returnHashtable.Add('Identity', $Identity)
        $returnHashtable.Add('DisplayName', $policy.name)
        $returnHashtable.Add('Description', $policy.description)

        foreach ($setting in $settings.settingInstance)
        {
            $addToParameters = $true
            $settingName = $setting.settingDefinitionId.Split('_') | Select-Object -Last 1

            switch ($setting.AdditionalProperties.'@odata.type')
            {

                '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                {
                    $settingValue = $setting.AdditionalProperties.simpleSettingValue.value
                }
                '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                {
                    $settingValue = $setting.AdditionalProperties.choiceSettingValue.value.split('_') | Select-Object -Last 1
                }
                '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                {
                    $values = @()
                    foreach ($value in $setting.AdditionalProperties.groupSettingCollectionValue.children)
                    {
                        $settingName = $value.settingDefinitionId.split('_') | Select-Object -Last 1
                        $settingValue = $value.choiceSettingValue.value.split('_') | Select-Object -Last 1
                        $returnHashtable.Add($settingName, $settingValue)
                        $addToParameters = $false
                    }
                }
                '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
                {
                    $values = @()
                    foreach ($value in $setting.AdditionalProperties.simpleSettingCollectionValue.value)
                    {
                        $values += $value
                    }
                    $settingValue = $values
                }
                Default
                {
                    $settingValue = $setting.value
                }
            }

            if ($addToParameters)
            {
                $returnHashtable.Add($settingName, $settingValue)
            }

        }
        $returnAssignments = @()
        $returnAssignments += Get-DeviceManagementConfigurationPolicyAssignment -DeviceManagementConfigurationPolicyId $Identity
        $returnHashtable.Add('Assignments', $returnAssignments)

        Write-Verbose -Message "Found Endpoint Protection Policy {$($policy.name)}"

        $returnHashtable.Add('Ensure', 'Present')
        $returnHashtable.Add('Credential', $Credential)
        $returnHashtable.Add('ApplicationId', $ApplicationId)
        $returnHashtable.Add('TenantId', $TenantId)
        $returnHashtable.Add('ApplicationSecret', $ApplicationSecret)
        $returnHashtable.Add('CertificateThumbprint', $CertificateThumbprint)
        $returnHashtable.Add('ManagedIdentity', $ManagedIdentity.IsPresent)
        $returnHashtable.Add('AccessTokens', $AccessTokens)

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('AccessTokens') | Out-Null

    $templateReferenceId = '5dd36540-eb22-4e7e-b19c-2a07772ba627_1'
    $platforms = 'windows10'
    $technologies = 'configManager'

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Endpoint Protection Policy {$DisplayName}"

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters) `
            -TemplateId $templateReferenceId

        $createParameters = @{
            Name              = $DisplayName
            Description       = $Description
            TemplateReference = @{templateId = $templateReferenceId }
            Platforms         = $platforms
            Technologies      = $technologies
            Settings          = $settings
        }
        New-MgBetaDeviceManagementConfigurationPolicy -bodyParameter $createParameters

        $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $Identity `
            -Targets $assignmentsHash

    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Policy {$($currentPolicy.DisplayName)}"

        #format settings from PSBoundParameters for update
        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters) `
            -TemplateId $templateReferenceId

        Update-DeviceManagementConfigurationPolicy `
            -DeviceManagementConfigurationPolicyId $currentPolicy.Identity `
            -DisplayName $DisplayName `
            -Description $Description `
            -TemplateReference $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

        #region update policy assignments
        $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentPolicy.Identity `
            -Targets $assignmentsHash
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Endpoint Protection Policy {$($currentPolicy.DisplayName)}"
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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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
    Write-Verbose -Message "Testing configuration of Endpoint Protection Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Identity') | Out-Null

    $testResult = $true
    if ([Array]$Assignments.count -ne $CurrentValues.Assignments.count)
    {
        Write-Verbose -Message "Configuration drift:Number of assignments does not match: Source=$([Array]$Assignments.count) Target=$($CurrentValues.Assignments.count)"
        $testResult = $false
    }
    if ($testResult)
    {
        foreach ($assignment in $CurrentValues.Assignments)
        {
            if ($null -ne $Assignment)
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
            }

            if (-not $testResult)
            {
                $testResult = $false
                break
            }

        }

    }
    $ValuesToCheck.Remove('Assignments') | Out-Null

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
        $policyTemplateID = '5dd36540-eb22-4e7e-b19c-2a07772ba627_1'
        [array]$policies = Get-MgBetaDeviceManagementConfigurationPolicy -Filter $Filter -All:$true `
            -ErrorAction Stop | Where-Object -FilterScript { $_.TemplateReference.TemplateId -eq $policyTemplateID } `

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
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @params

            if ($Results.Ensure -eq 'Present')
            {
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results

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

                Write-Host $Global:M365DSCEmojiGreenCheckMark
                $i++
            }
        }
        return $dscContent
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
            $_.Exception -like "*Unable to perform redirect as Location Header is not set in response*" -or `
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
function Get-IntuneSettingCatalogPolicySetting
{
    [CmdletBinding()]
    [OutputType([System.Array])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $DSCParams,
        [Parameter(Mandatory = 'true')]
        [System.String]
        $TemplateId
    )

    $DSCParams.Remove('Identity') | Out-Null
    $DSCParams.Remove('DisplayName') | Out-Null
    $DSCParams.Remove('Description') | Out-Null

    #Prepare setting definitions mapping
    $settingDefinitions = Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate -DeviceManagementConfigurationPolicyTemplateId $TemplateId
    $settingInstances = @()
    foreach ($settingDefinition in $settingDefinitions.SettingInstanceTemplate)
    {

        $settingInstance = @{}
        $settingName = $settingDefinition.SettingDefinitionId.split('_') | Select-Object -Last 1
        $settingType = $settingDefinition.AdditionalProperties.'@odata.type'.replace('InstanceTemplate', 'Instance')
        $settingInstance.Add('settingDefinitionId', $settingDefinition.settingDefinitionId)
        $settingInstance.Add('@odata.type', $settingType)
        if (-Not [string]::IsNullOrEmpty($settingDefinition.settingInstanceTemplateId))
        {
            $settingInstance.Add('settingInstanceTemplateReference', @{'settingInstanceTemplateId' = $settingDefinition.settingInstanceTemplateId })
        }
        $settingValueName = $settingType.replace('#microsoft.graph.deviceManagementConfiguration', '').replace('Instance', 'Value')
        $settingValueName = $settingValueName.Substring(0, 1).ToLower() + $settingValueName.Substring(1, $settingValueName.length - 1 )
        $settingValueType = $settingDefinition.AdditionalProperties."$($settingValueName)Template".'@odata.type'
        if ($null -ne $settingValueType)
        {
            $settingValueType = $settingValueType.replace('ValueTemplate', 'Value')
        }
        $settingValueTemplateId = $settingDefinition.AdditionalProperties."$($settingValueName)Template".settingValueTemplateId
        $settingValue = Get-IntuneSettingCatalogPolicySettingInstanceValue `
            -DSCParams $DSCParams `
            -SettingDefinition $settingDefinition `
            -SettingName $settingName `
            -SettingType $settingType `
            -SettingValueName $settingValueName `
            -SettingValueType $settingValueType `
            -SettingValueTemplateId $settingValueTemplateId
        if ($null -ne $settingValue)
        {
            $settingInstance += [Hashtable]$settingValue
        }

        $settingInstances += @{
            '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationSetting'
            'settingInstance' = $settingInstance
        }
    }

    return $settingInstances
}
function Get-IntuneSettingCatalogPolicySettingInstanceValue
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $DSCParams,

        [Parameter()]
        $SettingDefinition,

        [Parameter()]
        [System.String]
        $SettingType,

        [Parameter()]
        [System.String]
        $SettingName,

        [Parameter()]
        [System.String]
        $SettingValueName,

        [Parameter()]
        [System.String]
        $SettingValueType,

        [Parameter()]
        [System.String]
        $SettingValueTemplateId
    )

    $settingValueReturn = @{}
    switch ($settingType)
    {
        '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
        {
            $groupSettingCollectionValue = @{}
            $groupSettingCollectionValueChildren = @()

            $groupSettingCollectionDefinitionChildren = $SettingDefinition.AdditionalProperties.groupSettingCollectionValueTemplate.children
            foreach ($childDefinition in $groupSettingCollectionDefinitionChildren)
            {
                $childSettingName = $childDefinition.settingDefinitionId.split('_') | Select-Object -Last 1
                $childSettingType = $childDefinition.'@odata.type'.replace('InstanceTemplate', 'Instance')
                $childSettingValueName = $childSettingType.replace('#microsoft.graph.deviceManagementConfiguration', '').replace('Instance', 'Value')
                $childSettingValueType = "#microsoft.graph.deviceManagementConfiguration$($childSettingValueName)"
                $childSettingValueName = $childSettingValueName.Substring(0, 1).ToLower() + $childSettingValueName.Substring(1, $childSettingValueName.length - 1 )
                $childSettingValueTemplateId = $childDefinition.$childSettingValueName.settingValueTemplateId
                $childSettingValue = Get-IntuneSettingCatalogPolicySettingInstanceValue `
                    -DSCParams $DSCParams `
                    -SettingDefinition $childDefinition `
                    -SettingName $childSettingName `
                    -SettingType $childDefinition.'@odata.type' `
                    -SettingValueName $childSettingValueName `
                    -SettingValueType $childSettingValueType `
                    -SettingValueTemplateId $childSettingValueTemplateId

                if ($null -ne $childSettingValue)
                {
                    $childSettingValue.add('settingDefinitionId', $childDefinition.settingDefinitionId)
                    $childSettingValue.add('@odata.type', $childSettingType )
                    $groupSettingCollectionValueChildren += $childSettingValue
                }
            }
            $groupSettingCollectionValue.add('children', $groupSettingCollectionValueChildren)
            $settingValueReturn.Add('groupSettingCollectionValue', @($groupSettingCollectionValue))
        }
        '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
        {
            $values = @()
            foreach ( $key in $DSCParams.Keys)
            {
                if ($settingName -eq ($key.tolower()))
                {
                    $values = $DSCParams[$key]
                    break
                }
            }
            $settingValueCollection = @()
            foreach ($v in $values)
            {
                $settingValueCollection += @{
                    value         = $v
                    '@odata.type' = $settingValueType
                }
            }
            $settingValueReturn.Add($settingValueName, $settingValueCollection)
        }
        Default
        {
            $value = $null
            foreach ( $key in $DSCParams.Keys)
            {
                if ($settingName -eq ($key.tolower()))
                {
                    $value = "$($SettingDefinition.settingDefinitionId)_$($DSCParams[$key])"
                    break
                }
            }
            $settingValue = @{}

            if (-Not [string]::IsNullOrEmpty($settingValueType))
            {
                $settingValue.add('@odata.type', $settingValueType)
            }
            if (-Not [string]::IsNullOrEmpty($settingValueTemplateId))
            {
                $settingValue.Add('settingValueTemplateReference', @{'settingValueTemplateId' = $settingValueTemplateId })
            }
            $settingValue.add('value', $value)
            if ($null -eq $value)
            {
                return $null
            }
            $settingValueReturn.Add($settingValueName, $settingValue)
        }
    }
    return $settingValueReturn
}

function New-DeviceManagementConfigurationPolicy
{
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = 'true')]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $TemplateReferenceId,

        [Parameter()]
        [System.String]
        $Platforms,

        [Parameter()]
        [System.String]
        $Technologies,

        [Parameter()]
        [System.Array]
        $Settings
    )

    $templateReference = @{
        'templateId' = $TemplateReferenceId
    }

    $Uri = 'https://graph.microsoft.com/beta/deviceManagement/ConfigurationPolicies'
    $policy = [ordered]@{
        'name'              = $DisplayName
        'description'       = $Description
        'platforms'         = $Platforms
        'technologies'      = $Technologies
        'templateReference' = $templateReference
        'settings'          = $Settings
    }
    #write-verbose (($policy|ConvertTo-Json -Depth 20))
    Invoke-MgGraphRequest -Method POST `
        -Uri $Uri `
        -ContentType 'application/json' `
        -Body ($policy | ConvertTo-Json -Depth 20) 4> out-null
}
function Update-DeviceManagementConfigurationPolicy
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceManagementConfigurationPolicyId,

        [Parameter(Mandatory = 'true')]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $TemplateReferenceId,

        [Parameter()]
        [System.String]
        $Platforms,

        [Parameter()]
        [System.String]
        $Technologies,

        [Parameter()]
        [System.Array]
        $Settings
    )

    $templateReference = @{
        'templateId' = $TemplateReferenceId
    }

    $Uri = "https://graph.microsoft.com/beta/deviceManagement/ConfigurationPolicies/$DeviceManagementConfigurationPolicyId"
    $policy = [ordered]@{
        'name'              = $DisplayName
        'description'       = $Description
        'platforms'         = $Platforms
        'technologies'      = $Technologies
        'templateReference' = $templateReference
        'settings'          = $Settings
    }
    #write-verbose (($policy|ConvertTo-Json -Depth 20))
    Invoke-MgGraphRequest -Method PUT `
        -Uri $Uri `
        -ContentType 'application/json' `
        -Body ($policy | ConvertTo-Json -Depth 20) 4> out-null
}


function Get-DeviceManagementConfigurationPolicyAssignment
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceManagementConfigurationPolicyId
    )

    try
    {
        $configurationPolicyAssignments = @()

        $Uri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$DeviceManagementConfigurationPolicyId/assignments"
        $results = Invoke-MgGraphRequest -Method GET -Uri $Uri -ErrorAction Stop 4> out-null
        foreach ($result in $results.value.target)
        {
            $configurationPolicyAssignments += @{
                dataType                                   = $result.'@odata.type'
                groupId                                    = $result.groupId
                collectionId                               = $result.collectionId
                deviceAndAppManagementAssignmentFilterType = $result.deviceAndAppManagementAssignmentFilterType
                deviceAndAppManagementAssignmentFilterId   = $result.deviceAndAppManagementAssignmentFilterId
            }
        }

        while ($results.'@odata.nextLink')
        {
            $Uri = $results.'@odata.nextLink'
            $results = Invoke-MgGraphRequest -Method GET -Uri $Uri -ErrorAction Stop 4> out-null
            foreach ($result in $results.value.target)
            {
                $configurationPolicyAssignments += @{
                    dataType                                   = $result.'@odata.type'
                    groupId                                    = $result.groupId
                    collectionId                               = $result.collectionId
                    deviceAndAppManagementAssignmentFilterType = $result.deviceAndAppManagementAssignmentFilterType
                    deviceAndAppManagementAssignmentFilterId   = $result.deviceAndAppManagementAssignmentFilterId
                }
            }
        }
        return $configurationPolicyAssignments
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $null
    }
}

Export-ModuleMember -Function *-TargetResource
