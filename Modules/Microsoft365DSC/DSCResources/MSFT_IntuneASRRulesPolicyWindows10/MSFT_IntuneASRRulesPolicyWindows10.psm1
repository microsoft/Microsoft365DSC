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
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ProcessCreationType,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode")]
        [System.String]
        $AdvancedRansomewareProtectionType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $BlockPersistenceThroughWmiType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ScriptObfuscatedMacroCodeType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeMacroCodeAllowWin32ImportsType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsLaunchChildProcessType,

        [Parameter()]
        [ValidateSet("userDefined", "enable","auditMode", "blockDiskModification", "auditDiskModification")]
        [System.String]
        $GuardMyFoldersType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $UntrustedUSBProcessType,

        [Parameter()]
        [System.String[]]
        $AttackSurfaceReductionExcludedPaths,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $UntrustedExecutableType,

        [Parameter()]
        [ValidateSet("notConfigured", "enable","auditMode", "warn", "disable")]
        [System.String]
        $OfficeCommunicationAppsLaunchChildProcess,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $EmailContentExecutionType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ScriptDownloadedPayloadExecutionType,

        [Parameter()]
        [System.String[]]
        $AdditionalGuardedFolders,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode", "warn")]
        [System.String]
        $AdobeReaderLaunchChildProcess,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsExecutableContentCreationOrLaunchType,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode", "warn")]
        [System.String]
        $PreventCredentialStealingType,

        [Parameter()]
        [ValidateSet("userDefined","block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsOtherProcessInjectionType,

        [Parameter()]
        [System.String[]]
        $GuardedFoldersAllowedAppPaths,

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
        try
        {
            $policy = Get-MgDeviceManagementIntent -DeviceManagementIntentId $Identity -ErrorAction Stop
        }
        catch
        {
            Write-Verbose -Message "No Endpoint Protection Attack Surface Protection rules Policy {$DisplayName} was found"
            return $nullResult
        }

        #Retrieve policy specific settings
        [array]$settings = Get-MgDeviceManagementIntentSetting `
            -DeviceManagementIntentId $Identity `
            -ErrorAction Stop

        $definitionIdPrefix="windows10EndpointProtectionConfiguration_defender"
        $returnHashtable=@{}
        $returnHashtable.Add("Identity",$Identity)
        $returnHashtable.Add("DisplayName",$policy.DisplayName)
        $returnHashtable.Add("Description",$policy.Description)

        foreach ($setting in $settings)
        {
            $settingName=$setting.definitionId.replace("deviceConfiguration--$definitionIdPrefix","")
            $settingValue= ($settings|Where-Object `
                -FilterScript {$_.DefinitionId -like "*$settingName"}).ValueJson| ConvertFrom-Json
            $returnHashtable.Add($settingName,$settingValue)
        }

        Write-Verbose -Message "Found Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"

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
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ProcessCreationType,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode")]
        [System.String]
        $AdvancedRansomewareProtectionType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $BlockPersistenceThroughWmiType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ScriptObfuscatedMacroCodeType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeMacroCodeAllowWin32ImportsType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsLaunchChildProcessType,

        [Parameter()]
        [ValidateSet("userDefined", "enable","auditMode", "blockDiskModification", "auditDiskModification")]
        [System.String]
        $GuardMyFoldersType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $UntrustedUSBProcessType,

        [Parameter()]
        [System.String[]]
        $AttackSurfaceReductionExcludedPaths,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $UntrustedExecutableType,

        [Parameter()]
        [ValidateSet("notConfigured", "enable","auditMode", "warn", "disable")]
        [System.String]
        $OfficeCommunicationAppsLaunchChildProcess,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $EmailContentExecutionType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ScriptDownloadedPayloadExecutionType,

        [Parameter()]
        [System.String[]]
        $AdditionalGuardedFolders,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode", "warn")]
        [System.String]
        $AdobeReaderLaunchChildProcess,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsExecutableContentCreationOrLaunchType,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode", "warn")]
        [System.String]
        $PreventCredentialStealingType,

        [Parameter()]
        [ValidateSet("userDefined","block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsOtherProcessInjectionType,

        [Parameter()]
        [System.String[]]
        $GuardedFoldersAllowedAppPaths,

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

    $policyTemplateID='0e237410-1367-4844-bd7f-15fb0f08943b'
    $definitionIdPrefix="windows10EndpointProtectionConfiguration_defender"

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"
        $PSBoundParameters.Remove('Identity') | Out-Null
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null

        $settings = Get-M365DSCIntuneDeviceConfigurationSettings `
            -Properties ([System.Collections.Hashtable]$PSBoundParameters) `
            -DefinitionIdPrefix $definitionIdPrefix

        New-MgDeviceManagementIntent -DisplayName $DisplayName `
            -Description $Description `
            -TemplateId $policyTemplateID `
            -Settings $settings
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"

        $PSBoundParameters.Remove('Identity') | Out-Null
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null

        $settings = Get-M365DSCIntuneDeviceConfigurationSettings `
            -Properties ([System.Collections.Hashtable]$PSBoundParameters) `
            -DefinitionIdPrefix $definitionIdPrefix

        Update-MgDeviceManagementIntent -ErrorAction Stop `
            -DisplayName $DisplayName `
            -Description $Description `
            -DeviceManagementIntentId $Identity

        $currentSettings=Get-MgDeviceManagementIntentSetting `
            -DeviceManagementIntentId $Identity `
            -ErrorAction Stop

        foreach($setting in $settings)
        {
            $mySetting=$currentSettings|Where-Object{$_.DefinitionId -eq $setting.DefinitionId}
            $setting.add("id",$mySetting.Id)
        }
        $Uri="https://graph.microsoft.com/beta/deviceManagement/intents/$Identity/updateSettings"
        $body=@{"settings"=$settings}
        write-verbose -message ($body|ConvertTo-Json -Depth 20)
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body ($body|ConvertTo-Json -Depth 20) -ContentType "application/json" -ErrorAction Stop
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"
        Remove-MgDeviceManagementIntent -DeviceManagementIntentId $Identity -Confirm:$false -ErrorAction Stop
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
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ProcessCreationType,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode")]
        [System.String]
        $AdvancedRansomewareProtectionType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $BlockPersistenceThroughWmiType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ScriptObfuscatedMacroCodeType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeMacroCodeAllowWin32ImportsType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsLaunchChildProcessType,

        [Parameter()]
        [ValidateSet("userDefined", "enable","auditMode", "blockDiskModification", "auditDiskModification")]
        [System.String]
        $GuardMyFoldersType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $UntrustedUSBProcessType,

        [Parameter()]
        [System.String[]]
        $AttackSurfaceReductionExcludedPaths,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $UntrustedExecutableType,

        [Parameter()]
        [ValidateSet("notConfigured", "enable","auditMode", "warn", "disable")]
        [System.String]
        $OfficeCommunicationAppsLaunchChildProcess,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $EmailContentExecutionType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ScriptDownloadedPayloadExecutionType,

        [Parameter()]
        [System.String[]]
        $AdditionalGuardedFolders,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode", "warn")]
        [System.String]
        $AdobeReaderLaunchChildProcess,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsExecutableContentCreationOrLaunchType,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode", "warn")]
        [System.String]
        $PreventCredentialStealingType,

        [Parameter()]
        [ValidateSet("userDefined","block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsOtherProcessInjectionType,

        [Parameter()]
        [System.String[]]
        $GuardedFoldersAllowedAppPaths,

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
        $policyTemplateID='0e237410-1367-4844-bd7f-15fb0f08943b'
        [array]$policies = Get-MgDeviceManagementIntent `
            -ErrorAction Stop `
            -Filter "TemplateId eq '$policyTemplateID'"

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
            Write-Host "    |---[$i/$($policies.Count)] $($policy.DisplayName)" -NoNewline

            $params = @{
                Identity                            = $policy.Id
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

function Get-M365DSCIntuneDeviceConfigurationSettings
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties,
        [Parameter()]
        [System.String]
        $DefinitionIdPrefix
    )

    $results = @()
    foreach ($property in $properties.Keys)
    {
        if ($property -ne 'Verbose')
        {
            $setting=@{}
            switch (($properties.$property.gettype()).name) {
                "String" {$settingType="#microsoft.graph.deviceManagementStringSettingInstance"}
                "Boolean" {$settingType="#microsoft.graph.deviceManagementBooleanSettingInstance"}
                "Int32" {$settingType="#microsoft.graph.deviceManagementIntegerSettingInstance"}
                "String[]" {$settingType="#microsoft.graph.deviceManagementCollectionSettingInstance"}
                Default {$settingType="#microsoft.graph.deviceManagementComplexSettingInstance"}
            }
            $settingDefinitionIdPrefix="deviceConfiguration--$DefinitionIdPrefix"
            $settingDefinitionId =$settingDefinitionIdPrefix + $property
            $setting.Add("@odata.type",$settingType)
            $setting.Add("definitionId", $settingDefinitionId)
            if("String[]" -eq ($properties.$property.gettype()).name -and $properties.$property.count -eq 0 )
            {
                $setting.Add("valueJson", "[]")
            }
            else
            {
                $setting.Add("valueJson", ($properties.$property|ConvertTo-Json))
            }

            $results+=$setting
        }
    }
    return $results
}

Export-ModuleMember -Function *-TargetResource
