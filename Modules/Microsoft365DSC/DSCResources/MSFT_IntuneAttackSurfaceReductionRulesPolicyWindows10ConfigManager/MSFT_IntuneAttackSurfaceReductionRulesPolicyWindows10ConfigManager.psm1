function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $True)]
        [System.String]
        $Identity,

        [Parameter()]
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

        [Parameter(Mandatory = $True)]
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
        -ProfileName 'beta' -ErrorAction Stop

    $context = Get-MgContext
    if ($null -eq $context)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters -ErrorAction Stop
    }

    Select-MgProfile -Name 'beta'
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
        $policy = Get-MgDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Identity -ErrorAction Stop

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Endpoint Protection Policy {$Identity} was found"
            return $nullResult
        }

        #Retrieve policy specific settings
        [array]$settings = Get-MgDeviceManagementConfigurationPolicySetting `
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

            switch ($setting.'@odata.type')
            {
                '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
                {
                    $values = @()
                    foreach ($value in $setting.AdditionalProperties.simpleSettingCollectionValue)
                    {
                        $values += Get-DeviceManagementConfigurationSettingInstanceValue -Setting $value
                    }
                    $settingValue = $values
                }

                '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                {
                    $values = @()
                    foreach ($value in $setting.AdditionalProperties.groupSettingCollectionValue.children)
                    {
                        $settingName = $value.settingDefinitionId.split('_') | Select-Object -Last 1
                        $settingValue = Get-DeviceManagementConfigurationSettingInstanceValue -Setting $value
                        $returnHashtable.Add($settingName, $settingValue)
                        $addToParameters = $false
                    }
                }
                Default
                {
                    $settingValue = Get-DeviceManagementConfigurationSettingInstanceValue -Setting $setting.AdditionalProperties
                }
            }
            if ($addToParameters)
            {
                $returnHashtable.Add($settingName, $settingValue)
            }

        }
        $returnAssignments = @()
        $returnAssignments += Get-MgDeviceManagementConfigurationPolicyAssignments -DeviceManagementConfigurationPolicyId $Identity
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
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
            $tenantIdValue = $Credential.UserName.Split('@')[1]
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $True)]
        [System.String]
        $Identity,

        [Parameter()]
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

        [Parameter(Mandatory = $True)]
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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

    Select-MgProfile -Name 'beta'
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

        $settings = Format-M365DSCIntuneSettingCatalogPolicySettings `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters)

        $Template = Get-MgDeviceManagementConfigurationPolicyTemplate -DeviceManagementConfigurationPolicyTemplateId $templateReferenceId
        New-MgDeviceManagementConfigurationPolicy `
            -Name $DisplayName `
            -Description $Description `
            -TemplateReference $templateReference `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

        $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
        Update-MgDeviceManagementConfigurationPolicyAssignments -DeviceManagementConfigurationPolicyId $Identity -Targets $assignmentsHash

    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Policy {$($currentPolicy.DisplayName)}"

        $settings = Format-M365DSCIntuneSettingCatalogPolicySettings `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters)

        $Template = Get-MgDeviceManagementConfigurationPolicyTemplate -DeviceManagementConfigurationPolicyTemplateId $templateReferenceId
        Update-MgDeviceManagementConfigurationPolicy `
            -DeviceManagementConfigurationPolicyId $Identity `
            -Name $DisplayName `
            -Description $Description `
            -TemplateReference $templateReference `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

        $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
        Update-MgDeviceManagementConfigurationPolicyAssignments -DeviceManagementConfigurationPolicyId $currentPolicy.Identity -Targets $assignmentsHash

    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Endpoint Protection Policy {$($currentPolicy.DisplayName)}"
        Remove-MgDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Identity
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
        $Identity,

        [Parameter()]
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

        [Parameter(Mandatory = $True)]
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
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

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
                    break;
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
                    break;
                }
                $sourceHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $source
                $testResult = Compare-M365DSCComplexObject -Source $sourceHash -Target $assignment
            }

            if (-not $testResult)
            {
                $testResult = $false
                break;
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
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload:$true `
        -ProfileName 'beta'

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
        [array]$policies = Get-MgDeviceManagementConfigurationPolicy `
            -All:$true `
            -Filter $Filter | Where-Object -FilterScript { $_.TemplateReference.TemplateId -eq $policyTemplateID }

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
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = $Credential.UserName.Split('@')[1]

            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ''
    }
}

function Get-DeviceManagementConfigurationSettingInstanceValue
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Setting
    )

    switch ($setting.'@odata.type')
    {
        '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
        {
            $settingValue = $setting.choiceSettingValue.value.split('_') | Select-Object -Last 1

        }
        '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
        {
            $settingValue = $setting.simpleSettingValue.value
        }
        Default
        {
            $settingValue = $setting.value
        }
    }
    return $settingValue
}
function Convert-M365DSCParamsToSettingInstance
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $DSCParams,

        [Parameter(Mandatory = 'true')]
        [System.String]
        $SettingDefinitionId,

        [Parameter(Mandatory = 'true')]
        [System.String]
        $SettingDefinitionType,

        [Parameter()]
        [System.String]
        $GroupSettingCollectionDefinitionId,

        [Parameter()]
        [System.String]
        $SettingInstanceTemplateId,

        [Parameter()]
        [System.String]
        $SettingValueType,

        [Parameter()]
        [System.String]
        $SettingValueTemplateId
    )

    $DSCParams.Remove('Verbose') | Out-Null
    $results = @()

    foreach ($param in $DSCParams.Keys)
    {
        $settingDefinitionId = $SettingDefinitionId.ToLower()

        $settingInstance = [ordered]@{}
        $settingInstance.add('@odata.type', $SettingDefinitionType)
        $settingInstance.add('settingDefinitionId', $settingDefinitionId)
        if (-Not [string]::IsNullOrEmpty($settingInstanceTemplateId))
        {
            $settingInstance.add('settingInstanceTemplateReference', @{'settingInstanceTemplateId' = $SettingInstanceTemplateId })
        }
        switch ($SettingDefinitionType)
        {
            '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            {
                $choiceSettingValue = [ordered]@{}
                $choiceSettingValue.add('children', @())
                $choiceSettingValue.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue')
                if (-Not [string]::IsNullOrEmpty($settingValueTemplateId))
                {
                    $choiceSettingValue.add('settingValueTemplateReference', @{'settingValueTemplateId' = $SettingValueTemplateId })
                }
                $choiceSettingValue.add('value', "$settingDefinitionId`_$($DSCParams.$param)")
                $settingInstance.add('choiceSettingValue', $choiceSettingValue)
                $results += $settingInstance
            }
            '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
            {
                $simpleSettingCollectionValues = @()
                foreach ($value in $DSCParams.$param)
                {
                    $simpleSettingCollectionValue = @{}
                    $simpleSettingCollectionValue.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationStringSettingValue')
                    $simpleSettingCollectionValue.add('value', $value)
                    $simpleSettingCollectionValues += $simpleSettingCollectionValue
                }
                $settingInstance.add('simpleSettingCollectionValue', $simpleSettingCollectionValues)
                $results += $settingInstance
            }
            '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
            {
                $simpleSettingValue = @{}
                if (-Not [string]::IsNullOrEmpty($SettingValueType))
                {
                    $simpleSettingValue.add('@odata.type', $SettingValueType)
                }
                $simpleSettingValue.add('value', $DSCParams.$param)
                if (-Not [string]::IsNullOrEmpty($settingValueTemplateId))
                {
                    $simpleSettingValue.add('settingValueTemplateReference', @{'settingValueTemplateId' = $settingValueTemplateId })
                }

                $settingInstance.add('simpleSettingValue', $simpleSettingValue)
                $results += $settingInstance
            }
            '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
            {
                $groupSettingCollectionValues = @()
                $groupSettingCollectionValues += @{'children' = @() }
                $settingInstance.add('groupSettingCollectionValue', $groupSettingCollectionValues)
                $results += $settingInstance
            }
            Default {}
        }
    }
    return $results
}
function Format-M365DSCIntuneSettingCatalogPolicySettings
{
    [CmdletBinding()]
    [OutputType([System.Array])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $DSCParams
    )

    $DSCParams.Remove('Identity') | Out-Null
    $DSCParams.Remove('DisplayName') | Out-Null
    $DSCParams.Remove('Description') | Out-Null

    #Prepare setting definitions mapping
    $settingDefinitions = @(
        @{
            settingName               = 'AttackSurfaceReductionOnlyExclusions'
            settingDefinitionId       = 'device_vendor_msft_policy_config_defender_attacksurfacereductiononlyexclusions'
            settingDefinitionType     = '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
            settingInstanceTemplateId = '9b3bc064-2726-4abf-8c70-b9cb440c2422'
            settingValueType          = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
        }
        @{
            settingName               = 'EnableControlledFolderAccess'
            settingDefinitionId       = 'device_vendor_msft_policy_config_defender_enablecontrolledfolderaccess'
            settingDefinitionType     = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId = '88286be0-5a51-4238-bcf9-e8db1c3f0023'
            settingValueTemplateId    = '93eb92ec-85b7-49fa-87df-09ccc59e390f'
        }
        @{
            settingName               = 'ControlledFolderAccessAllowedApplications'
            settingDefinitionId       = 'device_vendor_msft_policy_config_defender_controlledfolderaccessallowedapplications'
            settingDefinitionType     = '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
            settingInstanceTemplateId = '7b7d300f-40cd-4708-a602-479e41b69647'
            settingValueType          = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
        }
        @{
            settingName               = 'ControlledFolderAccessProtectedFolders'
            settingDefinitionId       = 'device_vendor_msft_policy_config_defender_controlledfolderaccessprotectedfolders'
            settingDefinitionType     = '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
            settingInstanceTemplateId = '081cae44-3f9b-46b1-8eea-f9eb2e1e3031'
            settingValueType          = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
        }
        @{
            settingName               = 'AttackSurfaceReductionRules'
            settingDefinitionId       = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
            settingDefinitionType     = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
            settingInstanceTemplateId = 'd770fcd1-62cd-4217-9b20-9ee2a12062ff'
        }
        @{
            settingName                        = 'BlockAdobeReaderFromCreatingChildProcesses'
            settingDefinitionId                = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses'
            settingDefinitionType              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName                        = 'BlockExecutionOfPotentiallyObfuscatedScripts'
            settingDefinitionId                = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutionofpotentiallyobfuscatedscripts'
            settingDefinitionType              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName                        = 'BlockWin32APICallsFromOfficeMacros'
            settingDefinitionId                = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros'
            settingDefinitionType              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName                        = 'BlockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem'
            settingDefinitionId                = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem'
            settingDefinitionType              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName                        = 'BlockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion'
            settingDefinitionId                = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutablefilesrunningunlesstheymeetprevalenceagetrustedlistcriterion'
            settingDefinitionType              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName                        = 'BlockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent'
            settingDefinitionId                = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockjavascriptorvbscriptfromlaunchingdownloadedexecutablecontent'
            settingDefinitionType              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName                        = 'BlockOfficeCommunicationAppFromCreatingChildProcesses'
            settingDefinitionId                = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockofficecommunicationappfromcreatingchildprocesses'
            settingDefinitionType              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName                        = 'BlockAllOfficeApplicationsFromCreatingChildProcesses'
            settingDefinitionId                = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses'
            settingDefinitionType              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName                        = 'BlockUntrustedUnsignedProcessesThatRunFromUSB'
            settingDefinitionId                = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockuntrustedunsignedprocessesthatrunfromusb'
            settingDefinitionType              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName                        = 'BlockProcessCreationsFromPSExecAndWMICommands'
            settingDefinitionId                = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockprocesscreationsfrompsexecandwmicommands'
            settingDefinitionType              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName                        = 'BlockPersistenceThroughWMIEventSubscription'
            settingDefinitionId                = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockpersistencethroughwmieventsubscription'
            settingDefinitionType              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName                        = 'BlockOfficeApplicationsFromCreatingExecutableContent'
            settingDefinitionId                = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockofficeapplicationsfromcreatingexecutablecontent'
            settingDefinitionType              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName                        = 'BlockOfficeApplicationsFromInjectingCodeIntoOtherProcesses'
            settingDefinitionId                = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockofficeapplicationsfrominjectingcodeintootherprocesses'
            settingDefinitionType              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName                        = 'UseAdvancedProtectionAgainstRansomware'
            settingDefinitionId                = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_useadvancedprotectionagainstransomware'
            settingDefinitionType              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName                        = 'BlockExecutableContentFromEmailClientAndWebmail'
            settingDefinitionId                = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutablecontentfromemailclientandwebmail'
            settingDefinitionType              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName                        = 'BlockAbuseOfExploitedVulnerableSignedDrivers'
            settingDefinitionId                = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockabuseofexploitedvulnerablesigneddrivers'
            settingDefinitionType              = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
    )

    #write-verbose -Message ( $DSCParams|out-string)
    $settings = @()
    foreach ($settingDefinition in $settingDefinitions)
    {

        $setting = @{}
        $value = $DSCParams["$($settingDefinition.settingName)"]
        if ($value)
        {
            if ([string]::IsNullOrEmpty($settingDefinition.groupSettingCollectionDefinitionId))
            {
                $setting.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationSetting')
            }
            $formatParams = @{}
            $formatParams.Add('DSCParams', @{$settingDefinition.settingName = $value })
            $formatParams.Add('settingDefinitionId', $settingDefinition.settingDefinitionId)
            $formatParams.Add('settingDefinitionType', $settingDefinition.settingDefinitionType)
            if (-Not [string]::IsNullOrEmpty($settingDefinition.settingInstanceTemplateId))
            {
                $formatParams.Add('settingInstanceTemplateId', $settingDefinition.settingInstanceTemplateId)
            }
            if (-Not [string]::IsNullOrEmpty($settingDefinition.settingValueTemplateId))
            {
                $formatParams.Add('SettingValueTemplateId', $settingDefinition.settingValueTemplateId)
            }
            if (-Not [string]::IsNullOrEmpty($settingDefinition.settingValueType))
            {
                $formatParams.Add('settingValueType', $settingDefinition.settingValueType)
            }
            $myFormattedSetting = Convert-M365DSCParamsToSettingInstance @formatParams

            if (-Not [string]::IsNullOrEmpty($settingDefinition.groupSettingCollectionDefinitionId))
            {
                $mySetting = $settings.settingInstance | Where-Object -FilterScript { $_.settingDefinitionId -eq $settingDefinition.groupSettingCollectionDefinitionId }
                if ($null -eq $mySetting)
                {
                    $parentSetting = @{}
                    $parentSetting.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationSetting')
                    $mySettingDefinition = $settingDefinitions | Where-Object -FilterScript { $_.settingDefinitionId -eq $settingDefinition.groupSettingCollectionDefinitionId }
                    $mySettingDefinitionFormatted = Convert-M365DSCParamsToSettingInstance `
                        -DSCParams @{$mySettingDefinition.settingName = @{} } `
                        -SettingDefinitionId $mySettingDefinition.settingDefinitionId `
                        -SettingDefinitionType $mySettingDefinition.settingDefinitionType `
                        -SettingInstanceTemplateId $mySettingDefinition.settingInstanceTemplateId
                    $parentSetting.add('settingInstance', $mySettingDefinitionFormatted)
                    $settings += $parentSetting
                    $mySetting = $settings.settingInstance | Where-Object -FilterScript { $_.settingDefinitionId -eq $settingDefinition.groupSettingCollectionDefinitionId }
                }
                $mySetting.groupSettingCollectionValue[0].children += $myFormattedSetting
            }
            else
            {
                $setting.add('settingInstance', $myFormattedSetting)
                $settings += $setting
            }

        }
    }

    return $settings
}



function New-MgDeviceManagementConfigurationPolicy
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
        -Body ($policy | ConvertTo-Json -Depth 20)
}

function Update-MgDeviceManagementConfigurationPolicy
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $Identity,

        [Parameter()]
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

    $Uri = "https://graph.microsoft.com/beta/deviceManagement/ConfigurationPolicies/$Identity"
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
        -Body ($policy | ConvertTo-Json -Depth 20)
}

function Remove-MgDeviceManagementConfigurationPolicy
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $Identity
    )

    $Uri = "https://graph.microsoft.com/beta/deviceManagement/ConfigurationPolicies/$Identity"

    Invoke-MgGraphRequest -Method DELETE -Uri $Uri
}
function Get-MgDeviceManagementConfigurationPolicySetting
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
        $results = Invoke-MgGraphRequest -Method GET  -Uri $Uri -ErrorAction Stop
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
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
            $tenantIdValue = $Credential.UserName.Split('@')[1]
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $null
    }


}
function Get-MgDeviceManagementConfigurationPolicyAssignments
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceManagementConfigurationPolicyId
    )
    try
    {
        $configurationPolicyAssignments = @()

        $Uri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$DeviceManagementConfigurationPolicyId/assignments"
        $results = Invoke-MgGraphRequest -Method GET  -Uri $Uri -ErrorAction Stop
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
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
            $tenantIdValue = $Credential.UserName.Split('@')[1]
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $null
    }


}
function Update-MgDeviceManagementConfigurationPolicyAssignments
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
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
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
            $tenantIdValue = $Credential.UserName.Split('@')[1]
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $null
    }
}
function Get-MgDeviceManagementConfigurationSettingDefinition
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (

        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity
    )
    try
    {
        $Uri = "https://graph.microsoft.com/beta/deviceManagement/ConfigurationSettings/$($Identity.tolower())"
        $configurationPolicySetting = Invoke-MgGraphRequest -Method GET  -Uri $Uri -ErrorAction Stop
        return $configurationPolicySetting
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
            $tenantIdValue = $Credential.UserName.Split('@')[1]
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $null
    }


}
function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    param(
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
    param(
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
    param(
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
Function Get-M365DSCDRGSimpleObjectTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
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
function Get-M365DSCAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{'@odata.type' = '#microsoft.graph.agreement' }
    foreach ($property in $properties.Keys)
    {
        if ($property -ne 'Verbose')
        {
            $propertyName = $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            $propertyValue = $properties.$property
            $results.Add($propertyName, $propertyValue)
        }
    }
    return $results
}
function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
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
    param(
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
