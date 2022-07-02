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
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $AttackSurfaceReductionRules,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockAbuseOfExploitedVulnerableSignedDrivers,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockAdobeReaderFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockAllOfficeApplicationsFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockExecutableContentFromEmailClientAndWebmail,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockExecutionOfPotentiallyObfuscatedScripts,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockOfficeApplicationsFromCreatingExecutableContent,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockOfficeApplicationsFromInjectingCodeIntoOtherProcesses,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockOfficeCommunicationAppFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockPersistenceThroughWMIEventSubscription,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockProcessCreationsFromPSExecAndWMICommands,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockUntrustedUnsignedProcessesThatRunFromUSB,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockWin32APICallsFromOfficeMacros,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $UseAdvancedProtectionAgainstRansomware,

        [Parameter()]
        [System.String[]]
        $ControlledFolderAccessProtectedFolders,

        [Parameter()]
        [System.String[]]
        $ControlledFolderAccessAllowedApplications,

        [Parameter()]
        [ValidateSet("0", "1","2")]
        [System.String]
        $EnableControlledFolderAccess,

        [Parameter(Mandatory = $True)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Checking for the Intune Endpoint Protection Policy {$DisplayName}"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta' -ErrorAction Stop

    $context=Get-MgContext
    if($null -eq $context)
    {
        New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters -ErrorAction Stop
    }

    Select-MgProfile -Name 'beta'
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
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
        $policy = Get-MgDeviceManagementConfigurationPolicy -Identity $Identity -ErrorAction Stop

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Endpoint Protection Policy {$Identity} was found"
            return $nullResult
        }

        #Retrieve policy specific settings
        [array]$settings = Get-MgDeviceManagementConfigurationPolicySetting `
            -DeviceManagementConfigurationPolicyId $Identity `
            -ErrorAction Stop


        $returnHashtable=@{}
        $returnHashtable.Add("Identity",$Identity)
        $returnHashtable.Add("DisplayName",$policy.name)
        $returnHashtable.Add("Description",$policy.description)

        foreach ($setting in $settings)
        {
            $settingName=$setting.settingDefinitionId.Split("_")|Select-Object -Last 1
            switch ($setting."@odata.type")
            {
                "#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance"
                {
                    $values=@()
                    foreach($value in $setting.simpleSettingCollectionValue)
                    {
                        $values+=Get-DeviceManagementConfigurationSettingInstanceValue -Setting $value
                    }
                    $settingValue= $values
                }

                "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance"
                {
                    $values=@()
                    foreach($value in $setting.groupSettingCollectionValue.children)
                    {
                        $settingName=$value.settingDefinitionId.split("_")|Select-Object -Last 1
                        $settingValue= Get-DeviceManagementConfigurationSettingInstanceValue -Setting $value
                        $returnHashtable.Add($settingName,$settingValue)

                    }
                }
                Default
                {
                    $settingValue= Get-DeviceManagementConfigurationSettingInstanceValue -Setting $setting
                }
            }
            if ( $setting."@odata.type" -ne "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance" )
            {
                $returnHashtable.Add($settingName,$settingValue)
            }

        }

        Write-Verbose -Message "Found Endpoint Protection Policy {$($policy.name)}"

        $returnHashtable.Add("Ensure","Present")
        $returnHashtable.Add("Credential",$Credential)
        $returnHashtable.Add("ApplicationId",$ApplicationId)
        $returnHashtable.Add("TenantId",$TenantId)
        $returnHashtable.Add("ApplicationSecret",$ApplicationSecret)
        $returnHashtable.Add("CertificateThumbprint",$CertificateThumbprint)

        return $returnHashtable
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
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
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $AttackSurfaceReductionRules,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockAbuseOfExploitedVulnerableSignedDrivers,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockAdobeReaderFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockAllOfficeApplicationsFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockExecutableContentFromEmailClientAndWebmail,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockExecutionOfPotentiallyObfuscatedScripts,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockOfficeApplicationsFromCreatingExecutableContent,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockOfficeApplicationsFromInjectingCodeIntoOtherProcesses,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockOfficeCommunicationAppFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockPersistenceThroughWMIEventSubscription,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockProcessCreationsFromPSExecAndWMICommands,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockUntrustedUnsignedProcessesThatRunFromUSB,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockWin32APICallsFromOfficeMacros,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $UseAdvancedProtectionAgainstRansomware,

        [Parameter()]
        [System.String[]]
        $ControlledFolderAccessProtectedFolders,

        [Parameter()]
        [System.String[]]
        $ControlledFolderAccessAllowedApplications,

        [Parameter()]
        [ValidateSet("0", "1","2")]
        [System.String]
        $EnableControlledFolderAccess,

        [Parameter(Mandatory = $True)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

    Select-MgProfile -Name 'beta'
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $PSBoundParameters.Remove("Ensure") | Out-Null
    $PSBoundParameters.Remove("Credential") | Out-Null
    $PSBoundParameters.Remove("ApplicationId") | Out-Null
    $PSBoundParameters.Remove("TenantId") | Out-Null
    $PSBoundParameters.Remove("ApplicationSecret") | Out-Null
    $PSBoundParameters.Remove("CertificateThumbprint") | Out-Null

    $templateReferenceId='5dd36540-eb22-4e7e-b19c-2a07772ba627_1'
    $platforms='windows10'
    $technologies='configManager'

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Endpoint Protection Policy {$DisplayName}"

        $settings= Format-M365DSCIntuneSettingCatalogPolicySettings `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters)

        New-MgDeviceManagementConfigurationPolicy `
            -DisplayName $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Policy {$currentPolicy.DisplayName}"

        $settings= Format-M365DSCIntuneSettingCatalogPolicySettings `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters)

        Update-MgDeviceManagementConfigurationPolicy `
            -Identity $Identity `
            -DisplayName $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Endpoint Protection Policy {$currentPolicy.DisplayName}"
        Remove-MgDeviceManagementConfigurationPolicy -Identity $Identity
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
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $AttackSurfaceReductionRules,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockAbuseOfExploitedVulnerableSignedDrivers,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockAdobeReaderFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockAllOfficeApplicationsFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockExecutableContentFromEmailClientAndWebmail,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockExecutionOfPotentiallyObfuscatedScripts,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockOfficeApplicationsFromCreatingExecutableContent,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockOfficeApplicationsFromInjectingCodeIntoOtherProcesses,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockOfficeCommunicationAppFromCreatingChildProcesses,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockPersistenceThroughWMIEventSubscription,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockProcessCreationsFromPSExecAndWMICommands,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockUntrustedUnsignedProcessesThatRunFromUSB,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $BlockWin32APICallsFromOfficeMacros,

        [Parameter()]
        [ValidateSet("off", "block","audit", "warn")]
        [System.String]
        $UseAdvancedProtectionAgainstRansomware,

        [Parameter()]
        [System.String[]]
        $ControlledFolderAccessProtectedFolders,

        [Parameter()]
        [System.String[]]
        $ControlledFolderAccessAllowedApplications,

        [Parameter()]
        [ValidateSet("0", "1","2")]
        [System.String]
        $EnableControlledFolderAccess,

        [Parameter(Mandatory = $True)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
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

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

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
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )


    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload:$true

    Select-MgProfile -Name 'Beta'
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $dscContent = ''
    $i = 1

    try
    {
        $policyTemplateID='5dd36540-eb22-4e7e-b19c-2a07772ba627_1'
        [array]$policies = Get-MgDeviceManagementConfigurationPolicy `
            -ErrorAction Stop `
            -TemplateId $policyTemplateID

        if ($policies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.Name)" -NoNewline

            $params = @{
                Identity                            = $policy.id
                Ensure                              = 'Present'
                Credential                          = $Credential
                ApplicationId                       = $ApplicationId
                TenantId                            = $TenantId
                ApplicationSecret                   = $ApplicationSecret
                CertificateThumbprint               = $CertificateThumbprint
            }

            $Results = Get-TargetResource @params

            if ($Results.Ensure -eq 'Present')
            {
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results

                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
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
        return ""
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

    switch ($setting."@odata.type")
    {
        "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
        {
            $settingValue= $setting.choiceSettingValue.value.split("_")|Select-Object -Last 1

        }
        "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance"
        {
            $settingValue= $setting.simpleSettingValue.value
        }
        "#microsoft.graph.deviceManagementConfigurationStringSettingValue"
        {
            $settingValue=$setting.value
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

    $DSCParams.Remove("Verbose") | Out-Null
    $results = @()

    foreach ($param in $DSCParams.Keys)
    {
        $settingDefinitionId=$SettingDefinitionId.ToLower()

        $settingInstance=[ordered]@{}
        $settingInstance.add("@odata.type",$SettingDefinitionType)
        $settingInstance.add("settingDefinitionId",$settingDefinitionId)
        if(-Not [string]::IsNullOrEmpty($settingInstanceTemplateId))
        {
            $settingInstance.add("settingInstanceTemplateReference",@{"settingInstanceTemplateId"=$SettingInstanceTemplateId})
        }
        switch ($SettingDefinitionType)
        {
            "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
            {
                $choiceSettingValue=[ordered]@{}
                $choiceSettingValue.add("children",@())
                $choiceSettingValue.add("@odata.type","#microsoft.graph.deviceManagementConfigurationChoiceSettingValue")
                if(-Not [string]::IsNullOrEmpty($settingValueTemplateId))
                {
                    $choiceSettingValue.add("settingValueTemplateReference",@{"settingValueTemplateId"=$SettingValueTemplateId})
                }
                $choiceSettingValue.add("value","$settingDefinitionId`_$($DSCParams.$param)")
                $settingInstance.add("choiceSettingValue",$choiceSettingValue)
                $results+=$settingInstance
            }
            "#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance"
            {
                $simpleSettingCollectionValues=@()
                foreach($value in $DSCParams.$param)
                {
                    $simpleSettingCollectionValue=@{}
                    $simpleSettingCollectionValue.add("@odata.type","#microsoft.graph.deviceManagementConfigurationStringSettingValue")
                    $simpleSettingCollectionValue.add("value",$value)
                    $simpleSettingCollectionValues+=$simpleSettingCollectionValue
                }
                $settingInstance.add("simpleSettingCollectionValue",$simpleSettingCollectionValues)
                $results+=$settingInstance
            }
            "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance"
            {
                $simpleSettingValue=@{}
                if(-Not [string]::IsNullOrEmpty($SettingValueType))
                {
                    $simpleSettingValue.add("@odata.type",$SettingValueType)
                }
                $simpleSettingValue.add("value",$DSCParams.$param)
                if(-Not [string]::IsNullOrEmpty($settingValueTemplateId))
                {
                    $simpleSettingValue.add("settingValueTemplateReference",@{"settingValueTemplateId"=$settingValueTemplateId})
                }

                $settingInstance.add("simpleSettingValue",$simpleSettingValue)
                $results+=$settingInstance
            }
            "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance"
            {
                $groupSettingCollectionValues=@()
                $groupSettingCollectionValues+=@{"children"=@()}
                $settingInstance.add("groupSettingCollectionValue",$groupSettingCollectionValues)
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
    $settingDefinitions=@(
        @{
            settingName='AttackSurfaceReductionOnlyExclusions'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductiononlyexclusions'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
            settingInstanceTemplateId='9b3bc064-2726-4abf-8c70-b9cb440c2422'
            settingValueType='#microsoft.graph.deviceManagementConfigurationStringSettingValue'
        }
        @{
            settingName='EnableControlledFolderAccess'
            settingDefinitionId='device_vendor_msft_policy_config_defender_enablecontrolledfolderaccess'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='88286be0-5a51-4238-bcf9-e8db1c3f0023'
            settingValueTemplateId='93eb92ec-85b7-49fa-87df-09ccc59e390f'
        }
        @{
            settingName='ControlledFolderAccessAllowedApplications'
            settingDefinitionId='device_vendor_msft_policy_config_defender_controlledfolderaccessallowedapplications'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
            settingInstanceTemplateId='7b7d300f-40cd-4708-a602-479e41b69647'
            settingValueType='#microsoft.graph.deviceManagementConfigurationStringSettingValue'
        }
        @{
            settingName='ControlledFolderAccessProtectedFolders'
            settingDefinitionId='device_vendor_msft_policy_config_defender_controlledfolderaccessprotectedfolders'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
            settingInstanceTemplateId='081cae44-3f9b-46b1-8eea-f9eb2e1e3031'
            settingValueType='#microsoft.graph.deviceManagementConfigurationStringSettingValue'
        }
        @{
            settingName='AttackSurfaceReductionRules'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
            settingInstanceTemplateId='d770fcd1-62cd-4217-9b20-9ee2a12062ff'
        }
        @{
            settingName='BlockAdobeReaderFromCreatingChildProcesses'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName='BlockExecutionOfPotentiallyObfuscatedScripts'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutionofpotentiallyobfuscatedscripts'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName='BlockWin32APICallsFromOfficeMacros'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName='BlockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName='BlockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutablefilesrunningunlesstheymeetprevalenceagetrustedlistcriterion'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName='BlockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockjavascriptorvbscriptfromlaunchingdownloadedexecutablecontent'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName='BlockOfficeCommunicationAppFromCreatingChildProcesses'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockofficecommunicationappfromcreatingchildprocesses'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName='BlockAllOfficeApplicationsFromCreatingChildProcesses'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName='BlockUntrustedUnsignedProcessesThatRunFromUSB'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockuntrustedunsignedprocessesthatrunfromusb'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName='BlockProcessCreationsFromPSExecAndWMICommands'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockprocesscreationsfrompsexecandwmicommands'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName='BlockPersistenceThroughWMIEventSubscription'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockpersistencethroughwmieventsubscription'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName='BlockOfficeApplicationsFromCreatingExecutableContent'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockofficeapplicationsfromcreatingexecutablecontent'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName='BlockOfficeApplicationsFromInjectingCodeIntoOtherProcesses'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockofficeapplicationsfrominjectingcodeintootherprocesses'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName='UseAdvancedProtectionAgainstRansomware'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules_useadvancedprotectionagainstransomware'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName='BlockExecutableContentFromEmailClientAndWebmail'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutablecontentfromemailclientandwebmail'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
        @{
            settingName='BlockAbuseOfExploitedVulnerableSignedDrivers'
            settingDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockabuseofexploitedvulnerablesigneddrivers'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_attacksurfacereductionrules'
        }
    )

    #write-verbose -Message ( $DSCParams|out-string)
    $settings=@()
    foreach ($settingDefinition in $settingDefinitions)
    {

        $setting=@{}
        $value=$DSCParams["$($settingDefinition.settingName)"]
        if($value)
        {
            write-host $settingDefinition.settingName
            if([string]::IsNullOrEmpty($settingDefinition.groupSettingCollectionDefinitionId))
            {
                $setting.add("@odata.type","#microsoft.graph.deviceManagementConfigurationSetting")
            }
            $formatParams=@{}
            $formatParams.Add('DSCParams',@{$settingDefinition.settingName=$value})
            $formatParams.Add('settingDefinitionId',$settingDefinition.settingDefinitionId)
            $formatParams.Add('settingDefinitionType',$settingDefinition.settingDefinitionType)
            if(-Not [string]::IsNullOrEmpty($settingDefinition.settingInstanceTemplateId))
            {
                $formatParams.Add('settingInstanceTemplateId',$settingDefinition.settingInstanceTemplateId)
            }
            if(-Not [string]::IsNullOrEmpty($settingDefinition.settingValueTemplateId))
            {
                $formatParams.Add('SettingValueTemplateId',$settingDefinition.settingValueTemplateId)
            }
            if(-Not [string]::IsNullOrEmpty($settingDefinition.settingValueType))
            {
                $formatParams.Add('settingValueType',$settingDefinition.settingValueType)
            }
            $myFormattedSetting= Convert-M365DSCParamsToSettingInstance @formatParams

            if(-Not [string]::IsNullOrEmpty($settingDefinition.groupSettingCollectionDefinitionId))
            {
                $mySetting=$settings.settingInstance|Where-Object -FilterScript {$_.settingDefinitionId -eq $settingDefinition.groupSettingCollectionDefinitionId }
                if($null -eq $mySetting)
                {
                    $parentSetting=@{}
                    $parentSetting.add("@odata.type","#microsoft.graph.deviceManagementConfigurationSetting")
                    $mySettingDefinition=$settingDefinitions|Where-Object -FilterScript {$_.settingDefinitionId -eq $settingDefinition.groupSettingCollectionDefinitionId}
                    $mySettingDefinitionFormatted=Convert-M365DSCParamsToSettingInstance `
                        -DSCParams @{$mySettingDefinition.settingName=@{}} `
                        -SettingDefinitionId $mySettingDefinition.settingDefinitionId `
                        -SettingDefinitionType $mySettingDefinition.settingDefinitionType `
                        -SettingInstanceTemplateId $mySettingDefinition.settingInstanceTemplateId
                    $parentSetting.add('settingInstance',$mySettingDefinitionFormatted)
                    $settings+=$parentSetting
                    $mySetting=$settings.settingInstance|Where-Object -FilterScript {$_.settingDefinitionId -eq $settingDefinition.groupSettingCollectionDefinitionId }
                }
                $mySetting.groupSettingCollectionValue[0].children+=$myFormattedSetting
            }
            else
            {
                $setting.add('settingInstance',$myFormattedSetting)
                $settings+=$setting
            }

        }
    }

    return $settings
}

function Get-MgDeviceManagementConfigurationPolicy
{
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = 'true',
            ParameterSetName = 'Identity'
        )]
        [System.String]
        $Identity,
        [Parameter(
            Mandatory = 'true',
            ParameterSetName = 'TemplateId'
        )]
        [System.String]
        $TemplateId
    )
    try
    {
        if(-Not [String]::IsNullOrEmpty($Identity))
        {
            try
            {
                $Uri="https://graph.microsoft.com/beta/deviceManagement/ConfigurationPolicies/$Identity"
                $configurationPolicy=Invoke-MgGraphRequest -Method GET -Uri $Uri -ErrorAction Stop
                return $configurationPolicy
            }
            catch
            {
                return $null
            }
        }
        if(-Not [String]::IsNullOrEmpty($TemplateId))
        {
            $Uri="https://graph.microsoft.com/beta/deviceManagement/ConfigurationPolicies"
            [Array]$configurationPolicies=(Invoke-MgGraphRequest -Method GET -Uri $Uri -ErrorAction Stop).value
            return ($configurationPolicies|Where-Object -FilterScript {$_.templateReference.templateId -eq "$TemplateId" })
        }
    }
    catch
    {
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
        return $null
    }
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

    $templateReference=@{
        "templateId"=$TemplateReferenceId
    }

    $Uri="https://graph.microsoft.com/beta/deviceManagement/ConfigurationPolicies"
    $policy=[ordered]@{
    "name"=$DisplayName
    "description"=$Description
    "platforms"=$Platforms
    "technologies"=$Technologies
    "templateReference"=$templateReference
    "settings"=$Settings
    }
    #write-verbose (($policy|ConvertTo-Json -Depth 20))
    Invoke-MgGraphRequest -Method POST `
        -Uri $Uri `
        -ContentType "application/json" `
        -Body ($policy|ConvertTo-Json -Depth 20)
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

    $templateReference=@{
        "templateId"=$TemplateReferenceId
    }

    $Uri="https://graph.microsoft.com/beta/deviceManagement/ConfigurationPolicies/$Identity"
    $policy=[ordered]@{
    "name"=$DisplayName
    "description"=$Description
    "platforms"=$Platforms
    "technologies"=$Technologies
    "templateReference"=$templateReference
    "settings"=$Settings
    }

    #write-verbose (($policy|ConvertTo-Json -Depth 20))

    Invoke-MgGraphRequest -Method PUT `
        -Uri $Uri `
        -ContentType "application/json" `
        -Body ($policy|ConvertTo-Json -Depth 20)
}

function Remove-MgDeviceManagementConfigurationPolicy
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $Identity
    )

    $Uri="https://graph.microsoft.com/beta/deviceManagement/ConfigurationPolicies/$Identity"

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
        $Uri="https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$DeviceManagementConfigurationPolicyId/settings"
        $configurationPolicySettings=(Invoke-MgGraphRequest -Method GET  -Uri $Uri -ErrorAction Stop).value.settingInstance
        return $configurationPolicySettings
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
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
        $Uri="https://graph.microsoft.com/beta/deviceManagement/ConfigurationSettings/$($Identity.tolower())"
        $configurationPolicySetting=Invoke-MgGraphRequest -Method GET  -Uri $Uri -ErrorAction Stop
        return $configurationPolicySetting
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
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

Export-ModuleMember -Function *-TargetResource,*
