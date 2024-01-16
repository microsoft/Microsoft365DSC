function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [validateset('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $EnableGroupSpecificConsent,

        [Parameter()]
        [System.Boolean]
        $BlockUserConsentForRiskyApps,

        [Parameter()]
        [System.Boolean]
        $EnableAdminConsentRequests,

        [Parameter()]
        [system.string]
        $ConstrainGroupSpecificConsentToMembersOfGroupName,

        [Parameter()]
        [System.String]
        [ValidateSet('Present')]
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

    try
    {
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

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        $getValue = $null
        $consentPolicySettingsTemplateId = Get-MSConsentPolicySettingsTemplateId
        write-verbose "Get GroupSettings template with TemplateId $consentPolicySettingsTemplateId"
        $templateSettings = Get-MgGroupSettingTemplateGroupSettingTemplate -GroupSettingTemplateId $consentPolicySettingsTemplateId

        $getValue = Get-MgGroupSetting -All -ErrorAction SilentlyContinue | Where-Object -FilterScript {$_.DisplayName -eq $templateSettings.DisplayName}

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Did not find an Azure AD Group Consent Setting with DisplayName {$($templateSettings.DisplayName)}, using defaults from template"

            # insert default values from template
            $nullresult.EnableGroupSpecificConsent                        = $templateSettings.Values.Where({$_.Name -eq 'EnableGroupSpecificConsent'  }).DefaultValue
            $nullresult.BlockUserConsentForRiskyApps                      = $templateSettings.Values.Where({$_.Name -eq 'BlockUserConsentForRiskyApps'}).DefaultValue
            $nullresult.EnableAdminConsentRequests                        = $templateSettings.Values.Where({$_.Name -eq 'EnableAdminConsentRequests'  }).DefaultValue
            $nullresult.ConstrainGroupSpecificConsentToMembersOfGroupName = $null
             # convert boolean values to [system.boolean]
            if ($nullResult.EnableGroupSpecificConsent)
            {
                $nullResult.EnableGroupSpecificConsent = [system.convert]::ToBoolean($nullResult.EnableGroupSpecificConsent)
            }
            else
            {
                $nullResult.EnableGroupSpecificConsent = $false # value may be null in template, this translates to $false
            }
            if ($nullresult.BlockUserConsentForRiskyApps)
            {
                $nullresult.BlockUserConsentForRiskyApps = [system.convert]::ToBoolean($nullresult.BlockUserConsentForRiskyApps)
            }
            else
            {
                $nullresult.BlockUserConsentForRiskyApps = $false
            }
            if ($nullresult.EnableAdminConsentRequests)
            {
                $nullresult.EnableAdminConsentRequests = [system.convert]::ToBoolean($nullresult.EnableAdminConsentRequests)
            }
            return $nullResult
        }
        $Id = $getValue.Id

        Write-Verbose -Message "An Azure AD Group Consent Setting with DisplayName {$($templateSettings.DisplayName)} was found."

        # translate returned Values array to hashtable
        $groupSettingsValues = @{}
        $getValue.Values | ForEach-Object {
            if ($_.Value -in @('true', 'false'))
            {
                $addValue = [system.convert]::ToBoolean($_.Value)
            }
            else
            {
                $addValue = $_.Value
            }
            $groupSettingsValues.Add($_.Name, $addValue)
        }

        if ($groupSettingsValues.EnableGroupSpecificConsent -eq $true -and -not [string]::IsNullOrEmpty($groupSettingsValues.ConstrainGroupSpecificConsentToMembersOfGroupId))
        {
            write-verbose -message "Get-TargetResource: Get Group for ConstrainGroupSpecificConsentToMembersOfGroupId=$($groupSettingsValues.ConstrainGroupSpecificConsentToMembersOfGroupId)"
            $constrainConsentToGroupName = Get-MgGroup -GroupId $groupSettingsValues.ConstrainGroupSpecificConsentToMembersOfGroupId | Select-Object -ExpandProperty DisplayName
            write-verbose -message "Group DisplayName='$constrainConsentToGroupName'"
        }
        else
        {
            write-verbose -message 'Get-TargetResource: ConstrainGroupSpecificConsentToMembersOfGroupId=$null'
            $constrainConsentToGroupName = $null
        }

        $results = @{
            IsSingleInstance                                  = 'Yes'
            EnableGroupSpecificConsent                        = $groupSettingsValues.EnableGroupSpecificConsent
            BlockUserConsentForRiskyApps                      = $groupSettingsValues.BlockUserConsentForRiskyApps
            EnableAdminConsentRequests                        = $groupSettingsValues.EnableAdminConsentRequests
            ConstrainGroupSpecificConsentToMembersOfGroupName = $constrainConsentToGroupName
            Ensure                                            = 'Present'
            Credential                                        = $Credential
            ApplicationId                                     = $ApplicationId
            TenantId                                          = $TenantId
            ApplicationSecret                                 = $ApplicationSecret
            CertificateThumbprint                             = $CertificateThumbprint
            Managedidentity                                   = $ManagedIdentity.IsPresent
        }

        return [System.Collections.Hashtable] $results
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
        [validateset('Yes')]
        [system.string]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $EnableGroupSpecificConsent,

        [Parameter()]
        [System.Boolean]
        $BlockUserConsentForRiskyApps,

        [Parameter()]
        [System.Boolean]
        $EnableAdminConsentRequests,

        [Parameter()]
        [system.string]
        $ConstrainGroupSpecificConsentToMembersOfGroupName,

        [Parameter()]
        [System.String]
        [ValidateSet('Present')]
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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    write-verbose "Retrieve Group Settings Template"
    $consentPolicySettingsTemplateId = Get-MSConsentPolicySettingsTemplateId
    $templateSettings = Get-MgGroupSettingTemplateGroupSettingTemplate -GroupSettingTemplateId $consentPolicySettingsTemplateId

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present')
    {
        Write-Verbose -Message "Creating an Azure AD Group Consent Setting - common code"
        $valuesParam = @()

        # build array of values - if specified in Set-TargetResource, that value is included otherwise the existing value is used

        if ($PSBoundParameters.ContainsKey('EnableGroupSpecificConsent'))
        {
            $valuesParam += [Microsoft.Graph.PowerShell.Models.MicrosoftGraphSettingValue]::DeserializeFromPSObject([pscustomobject]@{Name='EnableGroupSpecificConsent';   Value=$EnableGroupSpecificConsent})
        }
        else
        {
            $valuesParam += [Microsoft.Graph.PowerShell.Models.MicrosoftGraphSettingValue]::DeserializeFromPSObject([pscustomobject]@{Name='EnableGroupSpecificConsent';   Value=$currentInstance.EnableGroupSpecificConsent})
        }

        if ($PSBoundParameters.ContainsKey('BlockUserConsentForRiskyApps'))
        {
            $valuesParam += [Microsoft.Graph.PowerShell.Models.MicrosoftGraphSettingValue]::DeserializeFromPSObject([pscustomobject]@{Name='BlockUserConsentForRiskyApps'; Value=$BlockUserConsentForRiskyApps})
        }
        else
        {
            $valuesParam += [Microsoft.Graph.PowerShell.Models.MicrosoftGraphSettingValue]::DeserializeFromPSObject([pscustomobject]@{Name='BlockUserConsentForRiskyApps';   Value=$currentInstance.BlockUserConsentForRiskyApps})
        }

        if ($PSBoundParameters.ContainsKey('EnableAdminConsentRequests'))
        {
            $valuesParam += [Microsoft.Graph.PowerShell.Models.MicrosoftGraphSettingValue]::DeserializeFromPSObject([pscustomobject]@{Name='EnableAdminConsentRequests'; Value=$EnableAdminConsentRequests})
        }
        else
        {
            $valuesParam += [Microsoft.Graph.PowerShell.Models.MicrosoftGraphSettingValue]::DeserializeFromPSObject([pscustomobject]@{Name='EnableAdminConsentRequests';   Value=$currentInstance.EnableAdminConsentRequests})
        }

        if ($EnableGroupSpecificConsent -eq $true -and -not [string]::IsNullOrEmpty($ConstrainGroupSpecificConsentToMembersOfGroupName))
        {
            $constrainConsentGroupObj = Get-MgGroup -Filter "DisplayName eq '$ConstrainGroupSpecificConsentToMembersOfGroupName'"
            if ($null -eq $constrainConsentGroupObj -or $constrainConsentGroupObj.securityEnabled -ne $true)
            {
                $message = "ConstrainGroupSpecificConsentToMembersOfGroupName '$ConstrainGroupSpecificConsentToMembersOfGroupName' does not exist or is not a security group"
                Add-M365DscEvent -Message $message `
                    -Source $($MyInvocation.MyCommand.Source) `
                    -EntryType Error `
                    -EventId 2 `
                    -EventType Error `
                    -TenantId $TenantId

                throw $message
            }
            $valuesParam += [Microsoft.Graph.PowerShell.Models.MicrosoftGraphSettingValue]::DeserializeFromPSObject([pscustomobject]@{Name='ConstrainGroupSpecificConsentToMembersOfGroupId'; Value=$constrainConsentGroupObj.Id})
        }
        else
        {
            if (-not [string]::IsNullOrEmpty($ConstrainGroupSpecificConsentToMembersOfGroupName))
            {
                throw "Specified ConstrainGroupSpecificConsentToMembersOfGroupName but EnableGroupSpecificConsent is false"
            }
            $valuesParam += [Microsoft.Graph.PowerShell.Models.MicrosoftGraphSettingValue]::DeserializeFromPSObject([pscustomobject]@{Name='ConstrainGroupSpecificConsentToMembersOfGroupId'; Value=$null})
        }


        $BodyParam = @{
            Values      = $valuesParam
        }

        if ($currentInstance.Ensure -eq 'Absent')
        {
            $BodyParam.Add('TemplateId', $templateSettings.Id)
            $policy = New-MgGroupSetting @BodyParam
        }
        elseif ($currentInstance.Ensure -eq 'Present')
        {
            Write-Verbose -Message "Updating the Azure AD Group Consent Settings"
            # get GroupSettingId - required for update
            $currentInstanceId = (Get-MgGroupSetting -All -Property DisplayName, Id | Where-Object -FilterScript {$_.DisplayName -eq $templateSettings.DisplayName}).Id
            $BodyParam.Add('GroupSettingId', $currentInstanceId)

            Update-MgGroupSetting @BodyParam
        }
    }
    else
    {
        if ($currentInstance.Ensure -eq 'Present')
        {
            Remove-MgGroupSetting -GroupSettingId $currentInstanceId
        }
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [validateset('Yes')]
        [system.string]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $EnableGroupSpecificConsent,

        [Parameter()]
        [System.Boolean]
        $BlockUserConsentForRiskyApps,

        [Parameter()]
        [System.Boolean]
        $EnableAdminConsentRequests,

        [Parameter()]
        [system.string]
        $ConstrainGroupSpecificConsentToMembersOfGroupName,

        [Parameter()]
        [System.String]
        [ValidateSet('Present')]
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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of the Azure AD Group Consent Settings with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($source.getType().Name -like '*CimInstance*')
        {
            $source = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $source

            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.remove('Id') | Out-Null
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion


    try
    {
        $currentDSCBlock = $null

        $consentPolicySettingsTemplateId = Get-MSConsentPolicySettingsTemplateId
        write-verbose "Get GroupSettings template with TemplateId $consentPolicySettingsTemplateId"
        $templateSettings = Get-MgGroupSettingTemplateGroupSettingTemplate -GroupSettingTemplateId $consentPolicySettingsTemplateId

        $params = @{
            IsSingleInstance      = 'Yes'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity
        }
        $results = Get-TargetResource @params

        if ($results -is [System.Collections.Hashtable] -and $results.Count -gt 1)
        {
            Write-Host "`r`n" -NoNewline
            Write-Host "    |---[1/1] $($templateSettings.DisplayName)" -NoNewline
            $results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $results `
                -Credential $Credential
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName

            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX
        }

        return $currentDSCBlock

    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

function Get-MSConsentPolicySettingsTemplateId
{
param()

    # fixed GUID
    return 'dffd5d46-495d-40a9-8e21-954ff55e198a'
}

Export-ModuleMember -Function *-TargetResource
