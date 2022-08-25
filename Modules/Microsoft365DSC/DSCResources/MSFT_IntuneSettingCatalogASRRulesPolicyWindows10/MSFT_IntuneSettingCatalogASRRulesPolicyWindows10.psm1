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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Checking for the Intune Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta' -ErrorAction Stop

    $context=Get-MgContext
    if($null -eq $context)
    {
        New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters -ErrorAction Stop
    }

    Write-Verbose -Message "Select-MgProfile"
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
        $policy = Get-MgDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Identity -ErrorAction Stop

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Endpoint Protection Attack Surface Protection rules Policy {$Identity} was found"
            return $nullResult
        }

        #Retrieve policy specific settings
        [array]$settings = Get-MgDeviceManagementConfigurationPolicySetting `
            -DeviceManagementConfigurationPolicyId $Identity `
            -ErrorAction Stop

        $settingDefinitionIdBase="device_vendor_msft_policy_config_defender_"
        $returnHashtable=@{}
        $returnHashtable.Add("Identity",$Identity)
        $returnHashtable.Add("DisplayName",$policy.name)
        $returnHashtable.Add("Description",$policy.description)

        #write-host ($settings|out-string)
        foreach ($setting in $settings.SettingInstance.AdditionalProperties)
        {
            switch ($setting."@odata.type")
            {
                "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance" {
                    foreach($settingInstance in $setting.groupSettingCollectionValue.children)
                    {
                        $prefix="attacksurfacereductionrules_"
                        $settingDefinitionIdPrefix=$settingDefinitionIdBase+$prefix
                        $settingName=$settingInstance.settingDefinitionId.replace("$settingDefinitionIdPrefix","")
                        $settingValue= $settingInstance.choiceSettingValue.value.replace("$settingDefinitionIdPrefix$settingName`_","")
                        $returnHashtable.Add($settingName,$settingValue)
                    }
                }
                "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                {
                    $settingName=$setting.settingDefinitionId.replace("$settingDefinitionIdBase","")
                    [String]$settingValue= $setting.choiceSettingValue.value.replace("$settingDefinitionIdBase$settingName`_","")
                    $returnHashtable.Add($settingName,$settingValue)
                }
                "#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance"
                {
                    $settingName=$setting.settingDefinitionId.replace("$settingDefinitionIdBase","")
                    [Array]$settingValue= $setting.simpleSettingCollectionValue.value
                    $returnHashtable.Add($settingName,$settingValue)
                }
                Default {}
            }

        }

        Write-Verbose -Message "Found Endpoint Protection Attack Surface Protection rules Policy {$($policy.name)}"

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

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"

        $settings= Format-M365DSCIntuneSettingCatalogASRRulesPolicySettings `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters) `
            -SettingDefinitionIDBase "device_vendor_msft_policy_config_defender_"

        New-MgDeviceManagementConfigurationPolicy `
            -DisplayName $DisplayName `
            -Description $Description `
            -TemplateReferenceId "e8c053d6-9f95-42b1-a7f1-ebfd71c67a4b_1" `
            -Platforms "windows10" `
            -Technologies "mdm,microsoftSense" `
            -Settings $settings

    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"

        $settings= Format-M365DSCIntuneSettingCatalogASRRulesPolicySettings `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters) `
            -SettingDefinitionIDBase "device_vendor_msft_policy_config_defender_"

        Update-MgDeviceManagementConfigurationPolicy `
            -Identity $Identity `
            -DisplayName $DisplayName `
            -Description $Description `
            -TemplateReferenceId "e8c053d6-9f95-42b1-a7f1-ebfd71c67a4b_1" `
            -Platforms "windows10" `
            -Technologies "mdm,microsoftSense" `
            -Settings $settings

    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"
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
    Write-Verbose -Message "Testing configuration of Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"

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
        $policyTemplateID='e8c053d6-9f95-42b1-a7f1-ebfd71c67a4b_1'
        [array]$policies = Get-MgDeviceManagementConfigurationPolicy `
            -ErrorAction Stop `
            -All:$true `
            -Filter $Filter
        $policies = $policies | Where-Object -FilterScript {$_.TemplateReference.TemplateId -eq $policyTemplateId}

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

function Format-M365DSCParamsToSettingInstance
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $DSCParams,

        [Parameter()]
        [System.String]
        $SettingDefinitionIdBase,

        [Parameter(
            ParameterSetName='GroupSettingCollectionInstance'
        )]
        [System.String]
        $GroupSettingDefinitionIdName,

        [Parameter()]
        [System.String]
        $SettingInstanceTemplateId,

        [Parameter()]
        [System.String]
        $SettingValueTemplateId
    )

    $DSCParams.Remove("Verbose") | Out-Null
    $results = @()

    if(-Not[string]::IsNullOrEmpty($GroupSettingDefinitionIdName))
    {
        $settingInstance=[ordered]@{}
        $settingInstance.add("@odata.type","#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance")
        $settingInstance.add("settingDefinitionId",$GroupSettingDefinitionIdName)
        $settingInstance.add("settingInstanceTemplateReference",@{"settingInstanceTemplateId"=$settingInstanceTemplateId})
        $groupSettingCollectionValues=@()

        $groupSettingCollectionValueChildren= Format-M365DSCParamsToSettingInstance `
            -DSCParams $DSCParams `
            -SettingDefinitionIdBase "$GroupSettingDefinitionIdName`_"

        $groupSettingCollectionValue=@{}
        $groupSettingCollectionValue.add("children",$groupSettingCollectionValueChildren)
        $groupSettingCollectionValues+=$groupSettingCollectionValue
        $settingInstance.add("groupSettingCollectionValue",$groupSettingCollectionValues)
        $results += $settingInstance
        return $results
    }

    foreach ($param in $DSCParams.Keys)
    {
        $settingName= $param
        $settingIdentity=($SettingDefinitionIdBase+$settingName).ToLower()

        $settingDefinition= Get-MgDeviceManagementConfigurationPolicySetting -Identity $settingIdentity

        $settingInstance=[ordered]@{}

        switch ($settingDefinition."@odata.type")
        {
            "#microsoft.graph.deviceManagementConfigurationChoiceSettingDefinition"
            {
                $settingInstance.add("@odata.type","#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance")
                $settingInstance.add("settingDefinitionId",$settingIdentity)
                if(-Not [string]::IsNullOrEmpty($settingInstanceTemplateId))
                {
                    $settingInstance.add("settingInstanceTemplateReference",@{"settingInstanceTemplateId"=$SettingInstanceTemplateId})
                }
                $choiceSettingValue=[ordered]@{}
                $choiceSettingValue.add("children",@())
                if(-Not [string]::IsNullOrEmpty($settingValueTemplateId))
                {
                    $choiceSettingValue.add("settingValueTemplateReference",@{"settingValueTemplateId"=$SettingValueTemplateId})
                }
                $choiceSettingValue.add("value","$settingIdentity`_$($DSCParams.$param)")
                $settingInstance.add("choiceSettingValue",$choiceSettingValue)
                $results+=$settingInstance
            }
            "#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionDefinition"
            {
                $settingInstance.add("@odata.type","#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance")
                $settingInstance.add("settingDefinitionId",$settingIdentity)
                if(-Not [string]::IsNullOrEmpty($settingInstanceTemplateId))
                {
                    $settingInstance.add("settingInstanceTemplateReference",@{"settingInstanceTemplateId"=$SettingInstanceTemplateId})
                }
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
            Default {}
        }
    }
    return $results
}

function Format-M365DSCIntuneSettingCatalogASRRulesPolicySettings
{
    [CmdletBinding()]
    [OutputType([System.Array])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $DSCParams,

        [Parameter(Mandatory = 'true')]
        [System.String]
        $SettingDefinitionIdBase

    )

    $DSCParams.Remove('Identity') | Out-Null
    $DSCParams.Remove('DisplayName') | Out-Null
    $DSCParams.Remove('Description') | Out-Null

    $settings=@()

    #Prepare settings other than attacksurfacereductionrules
    $otherSettings=@(
        'AttackSurfaceReductionOnlyExclusions'
        'ControlledFolderAccessProtectedFolders'
        'ControlledFolderAccessAllowedApplications'
        'EnableControlledFolderAccess'
    )

    foreach ($settingKey in $otherSettings)
    {
        $settingInstanceTemplateId=""
        $settingValueTemplateId=""

        switch ($settingKey)
        {
            "AttackSurfaceReductionOnlyExclusions"{$settingInstanceTemplateId="0eaea6bb-736e-44ed-a450-b2ef5bea1377"}
            "ControlledFolderAccessProtectedFolders"{$settingInstanceTemplateId="8f2096a7-d4f0-430c-9287-b08db7139163"}
            "ControlledFolderAccessAllowedApplications"{$settingInstanceTemplateId="e10f2cf5-121a-4890-af23-d4e91e0fab5f"}
            "EnableControlledFolderAccess"
            {
                $settingInstanceTemplateId="78c83b32-56c0-445a-932a-872d69af6e49"
                $settingValueTemplateId="e57db701-c3c6-4264-ab50-7896cb90dfd6"
            }

        }

        $setting=@{}
        if($null -ne ($DSCParams."$settingKey"))
        {
            $setting.add("@odata.type","#microsoft.graph.deviceManagementConfigurationSetting")
            $formatParams=@{}
            $formatParams.Add('DSCParams',@{$settingKey=$DSCParams."$settingKey"})
            $formatParams.Add('SettingDefinitionIdBase',$settingDefinitionIdBase)
            $formatParams.Add('SettingInstanceTemplateId',$settingInstanceTemplateId)
            if(-Not [string]::IsNullOrEmpty($settingValueTemplateId))
            {
                $formatParams.Add('SettingValueTemplateId',$settingValueTemplateId)
            }
            $myFormattedSetting= Format-M365DSCParamsToSettingInstance @formatParams

            $setting.add('settingInstance',$myFormattedSetting)
            $settings+=$setting
        }
    }

    $DSCParams.Remove('ControlledFolderAccessProtectedFolders') | Out-Null
    $DSCParams.Remove('ControlledFolderAccessAllowedApplications') | Out-Null
    $DSCParams.Remove('EnableControlledFolderAccess') | Out-Null
    $DSCParams.Remove('AttackSurfaceReductionOnlyExclusions') | Out-Null

    #Prepare attacksurfacereductionrules
    $setting=@{}
    $setting.add("@odata.type","#microsoft.graph.deviceManagementConfigurationSetting")
    $ASRSettings = Format-M365DSCParamsToSettingInstance `
        -DSCParams $DSCParams `
        -GroupSettingDefinitionIdName "device_vendor_msft_policy_config_defender_attacksurfacereductionrules" `
        -SettingInstanceTemplateId "19600663-e264-4c02-8f55-f2983216d6d7"
    $setting.add('settingInstance',$ASRSettings)
    $settings+=$setting

    return $settings
}

Export-ModuleMember -Function *-TargetResource
