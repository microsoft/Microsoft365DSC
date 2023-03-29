function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
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
        $Ensure = $true,

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
        $policy = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Identity -ErrorAction Stop

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
        $returnAssignments += Get-MgBetaDeviceManagementConfigurationPolicyAssignments -DeviceManagementConfigurationPolicyId $Identity
        $returnHashtable.Add('Assignments', $returnAssignments)

        Write-Verbose -Message "Found Endpoint Protection Policy {$($policy.name)}"

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
        [Parameter(Mandatory = $true)]
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
        $Ensure = $true,

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

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null

    $templateReferenceId = '5dd36540-eb22-4e7e-b19c-2a07772ba627_1'
    $platforms = 'windows10'
    $technologies = 'configManager'

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Endpoint Protection Policy {$DisplayName}"

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters) `
            -TemplateId $templateReferenceId

        $Template = Get-MgBetaDeviceManagementConfigurationPolicyTemplate -DeviceManagementConfigurationPolicyTemplateId $templateReferenceId
        New-MgBetaDeviceManagementConfigurationPolicy `
            -Name $DisplayName `
            -Description $Description `
            -TemplateReference $templateReference `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

        $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
        Update-MgBetaDeviceManagementConfigurationPolicyAssignments -DeviceManagementConfigurationPolicyId $Identity -Targets $assignmentsHash

    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Policy {$($currentPolicy.DisplayName)}"

        #format settings from PSBoundParameters for update
        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters) `
            -TemplateId $templateReferenceId

        $Template = Get-MgBetaDeviceManagementConfigurationPolicyTemplate -DeviceManagementConfigurationPolicyTemplateId $templateReferenceId
        Update-MgBetaDeviceManagementConfigurationPolicy `
            -DeviceManagementConfigurationPolicyId $Identity `
            -Name $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

        #region update policy assignments
        $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
        Update-MgBetaDeviceManagementConfigurationPolicyAssignments -DeviceManagementConfigurationPolicyId $currentPolicy.Identity -Targets $assignmentsHash

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
        [Parameter(Mandatory = $true)]
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
        $Ensure = $true,

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
    Write-Verbose -Message "Testing configuration of Endpoint Protection Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Identity') | Out-Null
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
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
        $policyTemplateID = '5dd36540-eb22-4e7e-b19c-2a07772ba627_1'
        [array]$policies = Get-MgBetaDeviceManagementConfigurationPolicy `
            -All:$true `
            -Filter $Filter `
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
        Write-Host $Global:M365DSCEmojiRedX
        if ($_.Exception -like '*401*')
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

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
        $settingType =  $settingDefinition.AdditionalProperties.'@odata.type'.replace('InstanceTemplate','Instance')
        $settingInstance.Add('settingDefinitionId', $settingDefinition.settingDefinitionId)
        $settingInstance.Add('@odata.type', $settingType)
        if (-Not [string]::IsNullOrEmpty($settingDefinition.settingInstanceTemplateId))
        {
            $settingInstance.Add('settingInstanceTemplateReference',@{'settingInstanceTemplateId'=$settingDefinition.settingInstanceTemplateId})
        }
        $settingValueName = $settingType.replace('#microsoft.graph.deviceManagementConfiguration','').replace('Instance','Value')
        $settingValueName = $settingValueName.Substring(0,1).ToLower() + $settingValueName.Substring(1,$settingValueName.length -1 )
        $settingValueType = $settingDefinition.AdditionalProperties."$($settingValueName)Template".'@odata.type'
        if ($null -ne $settingValueType)
        {
            $settingValueType = $settingValueType.replace('ValueTemplate','Value')
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
        $settingInstance+=($settingValue)

        $settingInstances += @{
            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSetting'
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
    switch($settingType)
    {
        '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
        {
            $groupSettingCollectionValue = @{}
            $groupSettingCollectionValueChildren = @()

            $groupSettingCollectionDefinitionChildren = $SettingDefinition.AdditionalProperties.groupSettingCollectionValueTemplate.children
            foreach($childDefinition in $groupSettingCollectionDefinitionChildren)
            {
                $childSettingName = $childDefinition.settingDefinitionId.split('_') | Select-Object -Last 1
                $childSettingType =  $childDefinition.'@odata.type'.replace('InstanceTemplate','Instance')
                $childSettingValueName = $childSettingType.replace('#microsoft.graph.deviceManagementConfiguration','').replace('Instance','Value')
                $childSettingValueType = "#microsoft.graph.deviceManagementConfiguration$($childSettingValueName)"
                $childSettingValueName = $childSettingValueName.Substring(0,1).ToLower() + $childSettingValueName.Substring(1,$childSettingValueName.length -1 )
                $childSettingValueTemplateId = $childDefinition.$childSettingValueName.settingValueTemplateId
                $childSettingValue = Get-IntuneSettingCatalogPolicySettingInstanceValue `
                    -DSCParams $DSCParams `
                    -SettingDefinition $childDefinition `
                    -SettingName $childSettingName `
                    -SettingType $childDefinition.'@odata.type' `
                    -SettingValueName $childSettingValueName `
                    -SettingValueType $childSettingValueType `
                    -SettingValueTemplateId $childSettingValueTemplateId

                $childSettingValue.add('settingDefinitionId', $childDefinition.settingDefinitionId)
                $childSettingValue.add('@odata.type', $childSettingType )
                $groupSettingCollectionValueChildren += $childSettingValue
            }
            $groupSettingCollectionValue.add('children', $groupSettingCollectionValueChildren)
            $settingValueReturn.Add('groupSettingCollectionValue', @($groupSettingCollectionValue))
        }
        '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
        {
            $values = @()
            foreach( $key in $DSCParams.Keys)
            {
                if($settingName -eq ($key.tolower()))
                {
                    $values = $DSCParams[$key]
                    break
                }
            }
            $settingValueCollection = @()
            foreach($v in $values)
            {
                $settingValueCollection += @{
                    value = $v
                    '@odata.type' = $settingValueType
                }
            }
            $settingValueReturn.Add($settingValueName, $settingValueCollection)
        }
        Default
        {
            $value = $null
            foreach( $key in $DSCParams.Keys)
            {
                if($settingName -eq ($key.tolower()))
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
                $settingValue.Add('settingValueTemplateReference',@{'settingValueTemplateId'= $settingValueTemplateId})
            }
            $settingValue.add('value', $value)
            $settingValueReturn.Add($settingValueName, $settingValue)
        }
    }
    return $settingValueReturn
}


function Get-MgBetaDeviceManagementConfigurationPolicySetting
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceManagementConfigurationPolicyId
    )
    try
    {
        $configurationPolicySettings = @()

        $Uri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$DeviceManagementConfigurationPolicyId/settings"
        $results = Invoke-MgGraphRequest -Method GET -Uri $Uri -ErrorAction Stop
        $configurationPolicySettings += $results.value.settingInstance
        while ($results.'@odata.nextLink')
        {
            $Uri = $results.'@odata.nextLink'
            $results = Invoke-MgGraphRequest -Method GET -Uri $Uri -ErrorAction Stop
            $configurationPolicySettings += $results.value.settingInstance
        }
        return $configurationPolicySettings
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

function Get-MgBetaDeviceManagementConfigurationPolicyAssignments
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
        $results = Invoke-MgGraphRequest -Method GET -Uri $Uri -ErrorAction Stop
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
            $results = Invoke-MgGraphRequest -Method GET -Uri $Uri -ErrorAction Stop
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

function Update-MgBetaDeviceManagementConfigurationPolicyAssignments
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceManagementConfigurationPolicyId,

        [Parameter()]
        [Array]
        $Targets
    )

    try
    {
        $configurationPolicyAssignments = @()

        $Uri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$DeviceManagementConfigurationPolicyId/assign"

        foreach ($target in $targets)
        {
            $formattedTarget = @{'@odata.type' = $target.dataType }
            if ($target.groupId)
            {
                $formattedTarget.Add('groupId', $target.groupId)
            }
            if ($target.collectionId)
            {
                $formattedTarget.Add('collectionId', $target.collectionId)
            }
            if ($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType', $target.deviceAndAppManagementAssignmentFilterType)
            }
            if ($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId', $target.deviceAndAppManagementAssignmentFilterId)
            }
            $configurationPolicyAssignments += @{'target' = $formattedTarget }
        }
        $body = @{'assignments' = $configurationPolicyAssignments } | ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop

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

function Get-MgBetaDeviceManagementConfigurationSettingDefinition
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity
    )

    try
    {
        $Uri = "https://graph.microsoft.com/beta/deviceManagement/ConfigurationSettings/$($Identity.tolower())"
        $configurationPolicySetting = Invoke-MgGraphRequest -Method GET -Uri $Uri -ErrorAction Stop
        return $configurationPolicySetting
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

function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        $ComplexObject
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    if ($ComplexObject.gettype().fullname -like '*[[\]]')
    {
        $results = @()

        foreach ($item in $ComplexObject)
        {
            if ($item)
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                $results += $hash
            }
        }
        if ($results.count -eq 0)
        {
            return $null
        }
        return $results
    }

    $results = @{}
    $keys = $ComplexObject | Get-Member | Where-Object -FilterScript { $_.MemberType -eq 'Property' -and $_.Name -ne 'AdditionalProperties' }

    foreach ($key in $keys)
    {
        if ($ComplexObject.$($key.Name))
        {
            $results.Add($key.Name, $ComplexObject.$($key.Name))
        }
    }
    if ($results.count -eq 0)
    {
        return $null
    }
    return $results
}

function Get-M365DSCDRGComplexTypeToString
{
    [CmdletBinding()]
    #[OutputType([System.String])]
    param
    (
        [Parameter()]
        $ComplexObject,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CIMInstanceName,

        [System.String]
        $Whitespace = '',

        [switch]
        $isArray = $false
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    #If ComplexObject  is an Array
    if ($ComplexObject.GetType().FullName -like '*[[\]]')
    {
        $currentProperty = @()
        foreach ($item in $ComplexObject)
        {
            $currentProperty += Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $item `
                -isArray:$true `
                -CIMInstanceName $CIMInstanceName `
                -Whitespace '            '

        }
        if ([string]::IsNullOrEmpty($currentProperty))
        {
            return $null
        }
        return $currentProperty

    }

    #If ComplexObject is a single CIM Instance
    if (-Not (Test-M365DSCComplexObjectHasValues -ComplexObject $ComplexObject))
    {
        return $null
    }
    $currentProperty = "MSFT_$CIMInstanceName{`r`n"
    $keyNotNull = 0
    foreach ($key in $ComplexObject.Keys)
    {
        if ($ComplexObject[$key])
        {
            $keyNotNull++

            if ($ComplexObject[$key].GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*')
            {
                $hashPropertyType = $ComplexObject[$key].GetType().Name.tolower()
                $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]

                if (Test-M365DSCComplexObjectHasValues -ComplexObject $hashProperty)
                {
                    $Whitespace += '            '
                    if (-not $isArray)
                    {
                        $currentProperty += '                ' + $key + ' = '
                    }
                    $currentProperty += Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $hashProperty `
                        -CIMInstanceName $hashPropertyType `
                        -Whitespace $Whitespace
                }
            }
            else
            {
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key]
            }
        }
    }
    $currentProperty += "            }`r`n"

    if ($keyNotNull -eq 0)
    {
        $currentProperty = $null
    }

    return $currentProperty
}

function Test-M365DSCComplexObjectHasValues
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [System.Collections.Hashtable]
        [Parameter()]
        $ComplexObject
    )

    if (-Not $ComplexObject)
    {
        return $false
    }

    $keys = $ComplexObject.keys
    $hasValue = $false
    foreach ($key in $keys)
    {
        if ($ComplexObject[$key])
        {
            if ($ComplexObject[$key].GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*')
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                if (-Not $hash)
                {
                    return $false
                }
                $hasValue = Test-M365DSCComplexObjectHasValues -ComplexObject ($hash)
            }
            else
            {
                $hasValue = $true
                return $hasValue
            }
        }
    }
    return $hasValue
}

function Get-M365DSCDRGSimpleObjectTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $Key,

        [Parameter(Mandatory = 'true')]
        $Value
    )

    $returnValue = ''
    switch -Wildcard ($Value.GetType().Fullname )
    {
        '*.Boolean'
        {
            $returnValue = '                ' + $Key + " = `$" + $Value.ToString() + "`r`n"
        }
        '*.String'
        {
            $delimeter = "'"
            if ($Value.startswith('MSFT_'))
            {
                $delimeter = ''
            }
            $returnValue = '                ' + $Key + " = $delimeter" + $Value + "$delimeter`r`n"
        }
        '*.DateTime'
        {
            $returnValue = '                ' + $Key + " = '" + $Value + "'`r`n"
        }
        '*.Hashtable'
        {
            if ($Value.keys.count -eq 0)
            {
                return ''
            }

            $returnValue = '                ' + $key + " = @{`r`n"
            $whitespace = '                     '
            $newline = "`r`n"
            foreach ($k in $Value.keys)
            {
                switch -Wildcard ($Value[$k].GetType().Fullname )
                {
                    '*.String'
                    {
                        $returnValue += "$whitespace$k = '$($Value[$k])'$newline"
                    }
                    '*.DateTime'
                    {
                        $returnValue += "$whitespace$k = '$($Value[$k])'$newline"
                    }
                    Default
                    {
                        $returnValue += "$whitespace$k = $($Value[$k])$newline"
                    }
                }
            }

            $returnValue += "                }`r`n"
        }
        '*[[\]]'
        {
            $returnValue = '                ' + $key + ' = @('
            $whitespace = ''
            $newline = ''
            if ($Value.count -gt 1)
            {
                $returnValue += "`r`n"
                $whitespace = '                    '
                $newline = "`r`n"
            }
            foreach ($item in $Value)
            {
                switch -Wildcard ($item.GetType().Fullname )
                {
                    '*.String'
                    {
                        $delimeter = "'"
                        if ($Value.startswith('MSFT_'))
                        {
                            $delimeter = ''
                        }
                        $returnValue += "$whitespace$delimeter$item$delimeter$newline"
                    }
                    '*.DateTime'
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    Default
                    {
                        $returnValue += "$whitespace$item$newline"
                    }
                }
            }
            if ($Value.count -gt 1)
            {
                $returnValue += "                )`r`n"
            }
            else
            {
                $returnValue += ")`r`n"

            }
        }
        Default
        {
            $returnValue = '                ' + $Key + ' = ' + $Value + "`r`n"
        }
    }
    return $returnValue
}
function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        $Source,

        [Parameter()]
        $Target
    )

    if (($null -eq $Source) -and ($null -eq $Target))
    {
        return $true
    }

    $keys = $Source.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    foreach ($key in $keys)
    {
        #Marking Target[key] to null if empty complex object or array
        if ($null -ne $Target[$key])
        {
            switch -Wildcard ($Target[$key].getType().Fullname )
            {
                'Microsoft.Graph.PowerShell.Models.*'
                {
                    $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Target[$key]
                    if (-not (Test-M365DSCComplexObjectHasValues -ComplexObject $hashProperty))
                    {
                        $Target[$key] = $null
                    }
                }
                '*[[\]]'
                {
                    if ($Target[$key].count -eq 0)
                    {
                        $Target[$key] = $null
                    }
                }
                '*DateTime'
                {
                    $Target[$key] = $Target[$key].tostring('MM/dd/yyyy HH:mm:ss')
                }
            }
        }

        #One of the item is null
        if (($null -eq $Source[$key]) -xor ($null -eq $Target[$key]))
        {
            if ($null -eq $Target[$key])
            {
                $nullKey = "Source={$($Source[$key]|Out-String)} Target={null}"
            }
            if ($null -eq $Source[$key])
            {
                $nullKey = "Source={null} Target={$($Target[$key]|Out-String)}"
            }
            Write-Verbose -Message "Configuration drift key: $key - one of the object null and not the other: $nullKey"

            return $false
        }
        #Both source and target aren't null or empty
        if (($null -ne $Source[$key]) -and ($null -ne $Target[$key]))
        {
            if ($Source[$key].getType().FullName -like '*CimInstance*')
            {
                #Recursive call for complex object
                $itemSource = @()
                $itemSource += $Source[$key]
                $itemTarget = @()
                $itemTarget += $Target[$key]

                $i = 0
                foreach ($item in $itemSource)
                {
                    if (-not ($itemSource[$i].getType().Fullname -like '*.Hashtable'))
                    {
                        $itemSource[$i] = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $itemSource[$i]
                    }
                    if (-not ($itemTarget[$i].getType().Fullname -like '*.Hashtable'))
                    {
                        $itemTarget[$i] = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $itemTarget[$i]
                    }

                    #Recursive call for complex object
                    $compareResult = Compare-M365DSCComplexObject `
                        -Source ($itemSource[$i]) `
                        -Target ($itemTarget[$i])


                    if (-not $compareResult)
                    {
                        Write-Verbose -Message "Complex Object drift key: $key - Source $($itemSource[$i]|Out-String)"
                        Write-Verbose -Message "Complex Object drift key: $key - Target $($itemTarget[$i]|Out-String)"
                        return $false
                    }
                    $i++
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject = $Target[$key]
                $differenceObject = $Source[$key]

                $compareResult = Compare-Object `
                    -ReferenceObject ($referenceObject) `
                    -DifferenceObject ($differenceObject)

                if ($null -ne $compareResult)
                {
                    Write-Verbose -Message "Simple Object drift key: $key - Source $($referenceObject|Out-String)"
                    Write-Verbose -Message "Simple Object drift key: $key - Target $($differenceObject|Out-String)"
                    return $false
                }
            }
        }
    }

    return $true
}

function Convert-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = 'true')]
        $ComplexObject
    )

    if ($ComplexObject.getType().Fullname -like '*[[\]]')
    {
        $results = @()
        foreach ($item in $ComplexObject)
        {
            $hash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            if (Test-M365DSCComplexObjectHasValues -ComplexObject $hash)
            {
                $results += $hash
            }
        }
        if ($results.count -eq 0)
        {
            return $null
        }
        return $Results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject
    $results = $hashComplexObject.clone()
    $keys = $hashComplexObject.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    foreach ($key in $keys)
    {
        if (($null -ne $hashComplexObject[$key]) -and ($hashComplexObject[$key].getType().Fullname -like '*CimInstance*'))
        {
            $results[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
        }
        if ($null -eq $results[$key])
        {
            $results.remove($key) | Out-Null
        }

    }
    return $results
}

Export-ModuleMember -Function *-TargetResource
