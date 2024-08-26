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
        [ValidateSet('0', '1', '2', '3', '4')]
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

    try
    {

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

        $templateReferenceId = '5dd36540-eb22-4e7e-b19c-2a07772ba627_1'
        # Retrieve policy general settings
        $policy = $null
        $policy = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Identity -ErrorAction SilentlyContinue

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Intune Attack Surface Reduction Rules Policy for Windows10 Config Manager with Id {$Identity} was found"

            if (-not [System.String]::IsNullOrEmpty($DisplayName))
            {
                $policy = Get-MgBetaDeviceManagementConfigurationPolicy `
                    -Filter "Name eq '$DisplayName' and templateReference/TemplateId eq '$templateReferenceId'" `
                    -ErrorAction SilentlyContinue
            }

            if ($null -eq $policy)
            {
                Write-Verbose -Message "No Intune Attack Surface Reduction Rules Policy for Windows10 Config Manager with Name {$DisplayName} was found"
                return $nullResult
            }
        }

        $Identity = $policy.Id

        Write-Verbose -Message "Found Intune Attack Surface Reduction Rules Policy for Windows10 Config Manager with Id {$($Identity) and Name $($policy.Name)}"

        # Retrieve policy specific settings
        [array]$settings = Get-MgBetaDeviceManagementConfigurationPolicySetting `
            -DeviceManagementConfigurationPolicyId $Identity `
            -ExpandProperty 'settingDefinitions' `
            -ErrorAction Stop

        $returnHashtable = @{}
        $returnHashtable.Add('Identity', $Identity)
        $returnHashtable.Add('DisplayName', $policy.Name)
        $returnHashtable.Add('Description', $policy.Description)

        $returnHashtable = Export-IntuneSettingCatalogPolicySettings -Settings $settings -ReturnHashtable $returnHashtable

        $returnAssignments = @()
        $graphAssignments = Get-MgBetaDeviceManagementConfigurationPolicyAssignment -DeviceManagementConfigurationPolicyId $Identity
        if ($graphAssignments.Count -gt 0)
        {
            $returnAssignments += ConvertFrom-IntunePolicyAssignment `
                                -IncludeDeviceFilter:$true `
                                -Assignments ($graphAssignments)
        }
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
        [ValidateSet('0', '1', '2', '3', '4')]
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
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    $templateReferenceId = '5dd36540-eb22-4e7e-b19c-2a07772ba627_1'
    $platforms = 'windows10'
    $technologies = 'configManager'

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Intune Attack Surface Reduction Rules Policy for Windows10 Config Manager {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null
        $BoundParameters.Remove('Identity') | Out-Null

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$BoundParameters) `
            -TemplateId $templateReferenceId

        $createParameters = @{
            Name              = $DisplayName
            Description       = $Description
            TemplateReference = @{templateId = $templateReferenceId }
            Platforms         = $platforms
            Technologies      = $technologies
            Settings          = $settings
        }
        $policy = New-MgBetaDeviceManagementConfigurationPolicy -BodyParameter $createParameters

        if ($policy.Id)
        {
            $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceConfigurationPolicyAssignment `
                -DeviceConfigurationPolicyId $policy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/configurationPolicies'
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Intune Attack Surface Reduction Rules Policy for Windows10 Config Manager {$($currentPolicy.DisplayName)}"
        $BoundParameters.Remove('Assignments') | Out-Null
        $BoundParameters.Remove('Identity') | Out-Null

        #format settings from PSBoundParameters for update
        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$BoundParameters) `
            -TemplateId $templateReferenceId

        Update-IntuneDeviceConfigurationPolicy `
            -DeviceConfigurationPolicyId $currentPolicy.Identity `
            -Name $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

        #region update policy assignments
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentPolicy.Identity `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/configurationPolicies'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Intune Attack Surface Reduction Rules Policy for Windows10 Config Manager {$($currentPolicy.DisplayName)}"
        Remove-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $currentPolicy.Identity
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
        [ValidateSet('0', '1', '2', '3', '4')]
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
    Write-Verbose -Message "Testing configuration of Intune Attack Surface Reduction Rules Policy for Windows10 Config Manager {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    [Hashtable]$ValuesToCheck = @{}
    $MyInvocation.MyCommand.Parameters.GetEnumerator() | ForEach-Object {
        if ($_.Key -notlike '*Variable' -or $_.Key -notin @('Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction'))
        {
            if ($null -ne $CurrentValues[$_.Key] -or $null -ne $PSBoundParameters[$_.Key])
            {
                $ValuesToCheck.Add($_.Key, $null)
                if (-not $PSBoundParameters.ContainsKey($_.Key))
                {
                    $PSBoundParameters.Add($_.Key, $null)
                }
            }
        }
    }

    if ($CurrentValues.Ensure -ne $Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult = $true

    # Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($null -ne $source -and $source.GetType().Name -like '*CimInstance*')
        {
            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-not $testResult)
            {
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.Remove('Identity') | Out-Null
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
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
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

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
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$true
            }

            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName

            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
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

Export-ModuleMember -Function *-TargetResource
