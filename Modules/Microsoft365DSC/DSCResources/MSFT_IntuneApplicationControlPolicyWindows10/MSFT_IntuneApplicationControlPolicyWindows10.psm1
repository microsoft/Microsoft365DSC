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
        [ValidateSet("notConfigured", "enforceComponentsAndStoreApps","auditComponentsAndStoreApps", "enforceComponentsStoreAppsAndSmartlocker", "auditComponentsStoreAppsAndSmartlocker")]
        [System.String]
        $AppLockerApplicationControl,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableInShell,

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

    Write-Verbose -Message "Checking for the Intune Endpoint Protection Application Control Policy {$DisplayName}"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' -InboundParameters $PSBoundParameters -ProfileName 'beta' -ErrorAction Stop
    $context=Get-MgContext
    if($null -eq $context)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' -InboundParameters $PSBoundParameters -ErrorAction Stop -ProfileName 'beta'
    }

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
        Write-Verbose -Message "Get-MgDeviceManagementIntent"
        $policy = Get-MgDeviceManagementIntent -Filter "displayName eq '$DisplayName'" -ErrorAction Stop | Where-Object -FilterScript { $_.TemplateId -eq '63be6324-e3c9-4c97-948a-e7f4b96f0f20' }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Endpoint Protection Application Control Policy {$DisplayName} was found"
            return $nullResult
        }

        #Retrieve policy specific settings
        [array]$settings = Get-MgDeviceManagementIntentSetting -DeviceManagementIntentId $policy.Id -ErrorAction Stop
        $settingAppLockerApplicationControl= ($settings|Where-Object -FilterScript {$_.DefinitionId -like "*appLockerApplicationControl"}).ValueJson.Replace("`"","")
        $settingSmartScreenBlockOverrideForFiles= [System.Convert]::ToBoolean(($settings|Where-Object -FilterScript {$_.DefinitionId -like "*smartScreenBlockOverrideForFiles"}).ValueJson)
        $settingSmartScreenEnableInShell= [System.Convert]::ToBoolean(($settings|Where-Object -FilterScript {$_.DefinitionId -like "*smartScreenEnableInShell"}).ValueJson)
        Write-Verbose -Message "Found Endpoint Protection Application Control Policy {$DisplayName}"

        return @{
            Description                                             = $policy.Description
            DisplayName                                             = $policy.DisplayName
            AppLockerApplicationControl                             = $settingAppLockerApplicationControl
            SmartScreenBlockOverrideForFiles                        = $settingSmartScreenBlockOverrideForFiles
            SmartScreenEnableInShell                                = $settingSmartScreenEnableInShell
            Ensure                                                  = "Present"
            Credential                                              = $Credential
            ApplicationId                                           = $ApplicationId
            TenantId                                                = $TenantId
            ApplicationSecret                                       = $ApplicationSecret
            CertificateThumbprint                                   = $CertificateThumbprint
        }
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet("notConfigured", "enforceComponentsAndStoreApps","auditComponentsAndStoreApps", "enforceComponentsStoreAppsAndSmartlocker", "auditComponentsStoreAppsAndSmartlocker")]
        [System.String]
        $AppLockerApplicationControl,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableInShell,

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
        Write-Verbose -Message "Creating new Endpoint Protection Application Control Policy {$DisplayName}"
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $Settings = Get-M365DSCIntuneEndpointProtectionPolicyWindowsSettings -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        New-MgDeviceManagementIntent -DisplayName $DisplayName `
            -Description $Description `
            -TemplateId "63be6324-e3c9-4c97-948a-e7f4b96f0f20" `
            -Settings $Settings `
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Application Control Policy {$DisplayName}"
        $appControlPolicy = Get-MgDeviceManagementIntent `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.TemplateId -eq '63be6324-e3c9-4c97-948a-e7f4b96f0f20' -and `
                $_.displayName -eq $($DisplayName) }

        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $Settings = Get-M365DSCIntuneEndpointProtectionPolicyWindowsSettings -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        $currentSettings=Get-MgDeviceManagementIntentSetting -DeviceManagementIntentId $appControlPolicy.Id -ErrorAction Stop
        Update-MgDeviceManagementIntent -ErrorAction Stop `
            -Description $Description `
            -DeviceManagementIntentId $appControlPolicy.Id

        foreach($setting in $Settings)
        {
            $s=$currentSettings|Where-Object{$_.DefinitionId -eq $setting.DefinitionId}
            Update-MgDeviceManagementIntentSetting -ErrorAction Stop `
                -DeviceManagementIntentId $appControlPolicy.Id `
                -DeviceManagementSettingInstanceId $s.Id `
                -ValueJson ($setting.value|ConvertTo-Json) `
                -AdditionalProperties @{"@odata.type"=$setting."@odata.type"}
        }

    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Endpoint Protection Application Control Policy {$DisplayName}"
        $appControlPolicy = Get-MgDeviceManagementIntent `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.TemplateId -eq '63be6324-e3c9-4c97-948a-e7f4b96f0f20' -and `
                $_.displayName -eq $($DisplayName) }

        Remove-MgDeviceManagementIntent -DeviceManagementIntentId $appControlPolicy.Id -ErrorAction Stop
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
        [ValidateSet("notConfigured", "enforceComponentsAndStoreApps","auditComponentsAndStoreApps", "enforceComponentsStoreAppsAndSmartlocker", "auditComponentsStoreAppsAndSmartlocker")]
        [System.String]
        $AppLockerApplicationControl,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableInShell,

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
    Write-Verbose -Message "Testing configuration of Endpoint Protection Application Control Policy {$DisplayName}"

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' -InboundParameters $PSBoundParameters -SkipModuleReload:$true -ProfileName 'beta'

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

        [array]$policies = Get-MgDeviceManagementIntent -All:$true -Filter $Filter `
            -ErrorAction Stop | Where-Object -FilterScript { $_.TemplateId -eq '63be6324-e3c9-4c97-948a-e7f4b96f0f20' }
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
                DisplayName                         = $policy.DisplayName
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

function Get-M365DSCIntuneEndpointProtectionPolicyWindowsSettings
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @()
    foreach ($property in $properties.Keys)
    {
        if ($property -ne 'Verbose')
        {
            $setting=@{}
            $settingType=($properties.$property.gettype()).name
            switch ($settingType) {
                "String" {$setting.Add("@odata.type","#microsoft.graph.deviceManagementStringSettingInstance")}
                "Boolean" {$setting.Add("@odata.type","#microsoft.graph.deviceManagementBooleanSettingInstance")}
                "Int32" {$setting.Add("@odata.type","#microsoft.graph.deviceManagementIntegerSettingInstance")}
                Default {$setting.Add("@odata.type","#microsoft.graph.deviceManagementComplexSettingInstance")}
            }
            $settingDefinitionIdPrefix="deviceConfiguration--windows10EndpointProtectionConfiguration_"
            $settingDefinitionId =$settingDefinitionIdPrefix + $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            $setting.Add("DefinitionId", $settingDefinitionId)
            $settingValue = $properties.$property
            $setting.Add("value", $settingValue)
            $results+=$setting
        }
    }
    return $results
}

Export-ModuleMember -Function *-TargetResource
