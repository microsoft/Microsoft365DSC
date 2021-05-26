function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Policy,

        [Parameter()]
        [ValidateSet("InOrganization", "NotInOrganization", "None")]
        [System.String[]]
        $AccessScope,

        [Parameter()]
        [System.Boolean]
        $BlockAccess,

        [Parameter()]
        [ValidateSet("All", "PerUser")]
        [System.String]
        $BlockAccessScope,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ContentContainsSensitiveInformation,

        [Parameter()]
        [System.String[]]
        $ContentPropertyContainsWords,

        [Parameter()]
        [System.Boolean]
        $Disabled,

        [Parameter()]
        [System.String[]]
        $GenerateAlert,

        [Parameter()]
        [System.String[]]
        $GenerateIncidentReport,

        [Parameter()]
        [ValidateSet("All", "Default", "DetectionDetails", "Detections", "DocumentAuthor", "DocumentLastModifier", "MatchedItem", "OriginalContent", "RulesMatched", "Service", "Severity", "Title", "RetentionLabel", "SensitivityLabel")]
        [System.String[]]
        $IncidentReportContent,

        [Parameter()]
        [ValidateSet("FalsePositive", "WithoutJustification", "WithJustification")]
        [System.String[]]
        $NotifyAllowOverride,

        [Parameter()]
        [System.String]
        $NotifyEmailCustomText,

        [Parameter()]
        [System.String]
        $NotifyPolicyTipCustomText,

        [Parameter()]
        [System.String[]]
        $NotifyUser,

        [Parameter()]
        [ValidateSet("Low", "Medium", "High", "None")]
        [System.String]
        $ReportSeverityLevel,

        [Parameter()]
        [ValidateSet("Ignore", "RetryThenBlock")]
        [System.String]
        $RuleErrorAction,

        [Parameter()]
        [System.String[]]
        $AnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $AnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ContentExtensionMatchesWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfContentExtensionMatchesWords,

        [Parameter()]
        [System.Boolean]
        $RemoveRMSTemplate,

        [Parameter()]
        [System.Boolean]
        $StopPolicyProcessing,

        [Parameter()]
        [System.Boolean]
        $DocumentIsUnsupported,

        [Parameter()]
        [System.Boolean]
        $ExceptIfDocumentIsUnsupported,

        [Parameter()]
        [System.Boolean]
        $HasSenderOverride,

        [Parameter()]
        [System.Boolean]
        $ExceptIfHasSenderOverride,

        [Parameter()]
        [System.Boolean]
        $ProcessingLimitExceeded,

        [Parameter()]
        [System.Boolean]
        $ExceptIfProcessingLimitExceeded,

        [Parameter()]
        [System.Boolean]
        $DocumentIsPasswordProtected,

        [Parameter()]
        [System.Boolean]
        $ExceptIfDocumentIsPasswordProtected,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of DLPCompliancePolicy for $Name"
    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters
    }

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        $PolicyRule = Get-DlpComplianceRule -Identity $Name -ErrorAction SilentlyContinue

        if ($null -eq $PolicyRule)
        {
            Write-Verbose -Message "DLPComplianceRule $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            Write-Verbose "Found existing DLPComplianceRule $($Name)"

            # Cmdlet returns a string, but in order to properly validate valid values, we need to convert
            # to a String array
            $ArrayIncidentReportContent = @()

            if ($null -ne $PolicyRule.IncidentReportContent)
            {
                $ArrayIncidentReportContent = $PolicyRule.IncidentReportContent.Replace(' ', '').Split(',')
            }

            if ($null -ne $PolicyRule.NotifyAllowOverride)
            {
                $NotifyAllowOverrideValue = $PolicyRule.NotifyAllowOverride.Replace(' ', '').Split(',')
            }

            if ($null -ne $PolicyRule.AnyOfRecipientAddressContainsWords -and $PolicyRule.AnyOfRecipientAddressContainsWords.count -gt 0)
            {
                $AnyOfRecipientAddressContainsWords = $PolicyRule.AnyOfRecipientAddressContainsWords.Replace(' ', '').Split(',')
            }

            if ($null -ne $PolicyRule.AnyOfRecipientAddressMatchesPatterns -and $PolicyRule.AnyOfRecipientAddressMatchesPatterns -gt 0)
            {
                $AnyOfRecipientAddressMatchesPatterns = $PolicyRule.AnyOfRecipientAddressMatchesPatterns.Replace(' ', '').Split(',')
            }

            if ($null -ne $PolicyRule.ContentExtensionMatchesWords -and $PolicyRule.ContentExtensionMatchesWords.count -gt 0)
            {
                $ContentExtensionMatchesWords = $PolicyRule.ContentExtensionMatchesWords.Replace(' ', '').Split(',')
            }

            if ($null -ne $PolicyRule.ExceptIfContentExtensionMatchesWords -and $PolicyRule.ExceptIfContentExtensionMatchesWords.count -gt 0)
            {
                $ExceptIfContentExtensionMatchesWords = $PolicyRule.ExceptIfContentExtensionMatchesWords.Replace(' ', '').Split(',')
            }

            [array] $SensitiveInfo = @()

            foreach ($si in $PolicyRule.ContentContainsSensitiveInformation)
            {

                $SensitiveInfo += [System.Collections.Hashtable]$si
            }

            $result = @{
                Ensure                               = 'Present'
                Name                                 = $PolicyRule.Name
                Policy                               = $PolicyRule.ParentPolicyName
                AccessScope                          = $PolicyRule.AccessScope
                BlockAccess                          = $PolicyRule.BlockAccess
                BlockAccessScope                     = $PolicyRule.BlockAccessScope
                Comment                              = $PolicyRule.Comment
                ContentContainsSensitiveInformation  = $SensitiveInfo
                ContentPropertyContainsWords         = $PolicyRule.ContentPropertyContainsWords
                Disabled                             = $PolicyRule.Disabled
                GenerateAlert                        = $PolicyRule.GenerateAlert
                GenerateIncidentReport               = $PolicyRule.GenerateIncidentReport
                IncidentReportContent                = $ArrayIncidentReportContent
                NotifyAllowOverride                  = $NotifyAllowOverrideValue
                NotifyEmailCustomText                = $PolicyRule.NotifyEmailCustomText
                NotifyPolicyTipCustomText            = $PolicyRule.NotifyPolicyTipCustomText
                NotifyUser                           = $PolicyRule.NotifyUser
                ReportSeverityLevel                  = $PolicyRule.ReportSeverityLevel
                RuleErrorAction                      = $PolicyRule.RuleErrorAction
                RemoveRMSTemplate                    = $PolicyRule.RemoveRMSTemplate
                StopPolicyProcessing                 = $PolicyRule.StopPolicyProcessing
                DocumentIsUnsupported                = $PolicyRule.DocumentIsUnsupported
                ExceptIfDocumentIsUnsupported        = $PolicyRule.ExceptIfDocumentIsUnsupported
                HasSenderOverride                    = $PolicyRule.HasSenderOverride
                ExceptIfHasSenderOverride            = $PolicyRule.ExceptIfHasSenderOverride
                ProcessingLimitExceeded              = $PolicyRule.ProcessingLimitExceeded
                ExceptIfProcessingLimitExceeded      = $PolicyRule.ExceptIfProcessingLimitExceeded
                DocumentIsPasswordProtected          = $PolicyRule.DocumentIsPasswordProtected
                ExceptIfDocumentIsPasswordProtected  = $PolicyRule.ExceptIfDocumentIsPasswordProtected
                AnyOfRecipientAddressContainsWords   = $AnyOfRecipientAddressContainsWords
                AnyOfRecipientAddressMatchesPatterns = $AnyOfRecipientAddressMatchesPatterns
                ContentExtensionMatchesWords         = $ContentExtensionMatchesWords
                ExceptIfContentExtensionMatchesWords = $ExceptIfContentExtensionMatchesWords
            }

            $paramsToRemove = @()
            foreach ($paramName in $result.Keys)
            {
                if ($null -eq $result[$paramName] -or "" -eq $result[$paramName] -or @() -eq $result[$paramName])
                {
                    $paramsToRemove += $paramName
                }
            }

            foreach ($paramName in $paramsToRemove)
            {
                $result.Remove($paramName)
            }

            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $GlobalAdminAccount)
            {
                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Policy,

        [Parameter()]
        [ValidateSet("InOrganization", "NotInOrganization", "None")]
        [System.String[]]
        $AccessScope,

        [Parameter()]
        [System.Boolean]
        $BlockAccess,

        [Parameter()]
        [ValidateSet("All", "PerUser")]
        [System.String]
        $BlockAccessScope,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ContentContainsSensitiveInformation,

        [Parameter()]
        [System.String[]]
        $ContentPropertyContainsWords,

        [Parameter()]
        [System.Boolean]
        $Disabled,

        [Parameter()]
        [System.String[]]
        $GenerateAlert,

        [Parameter()]
        [System.String[]]
        $GenerateIncidentReport,

        [Parameter()]
        [ValidateSet("All", "Default", "DetectionDetails", "Detections", "DocumentAuthor", "DocumentLastModifier", "MatchedItem", "OriginalContent", "RulesMatched", "Service", "Severity", "Title", "RetentionLabel", "SensitivityLabel")]
        [System.String[]]
        $IncidentReportContent,

        [Parameter()]
        [ValidateSet("FalsePositive", "WithoutJustification", "WithJustification")]
        [System.String[]]
        $NotifyAllowOverride,

        [Parameter()]
        [System.String]
        $NotifyEmailCustomText,

        [Parameter()]
        [System.String]
        $NotifyPolicyTipCustomText,

        [Parameter()]
        [System.String[]]
        $NotifyUser,

        [Parameter()]
        [ValidateSet("Low", "Medium", "High", "None")]
        [System.String]
        $ReportSeverityLevel,

        [Parameter()]
        [ValidateSet("Ignore", "RetryThenBlock")]
        [System.String]
        $RuleErrorAction,


        [Parameter()]
        [System.String[]]
        $AnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $AnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ContentExtensionMatchesWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfContentExtensionMatchesWords,

        [Parameter()]
        [System.Boolean]
        $RemoveRMSTemplate,

        [Parameter()]
        [System.Boolean]
        $StopPolicyProcessing,

        [Parameter()]
        [System.Boolean]
        $DocumentIsUnsupported,

        [Parameter()]
        [System.Boolean]
        $ExceptIfDocumentIsUnsupported,

        [Parameter()]
        [System.Boolean]
        $HasSenderOverride,

        [Parameter()]
        [System.Boolean]
        $ExceptIfHasSenderOverride,

        [Parameter()]
        [System.Boolean]
        $ProcessingLimitExceeded,

        [Parameter()]
        [System.Boolean]
        $ExceptIfProcessingLimitExceeded,

        [Parameter()]
        [System.Boolean]
        $DocumentIsPasswordProtected,

        [Parameter()]
        [System.Boolean]
        $ExceptIfDocumentIsPasswordProtected,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of DLPComplianceRule for $Name"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters

    $CurrentRule = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentRule.Ensure))
    {
        Write-Verbose "Rule {$($CurrentRule.Name)} doesn't exists but need to. Creating Rule."
        $CreationParams = $PSBoundParameters
        if ($null -ne $CreationParams.ContentContainsSensitiveInformation)
        {
            $value = @()
            foreach ($item in $CreationParams.ContentContainsSensitiveInformation)
            {
                $value += Get-SCDLPSensitiveInformation $item
            }
            $CreationParams.ContentContainsSensitiveInformation = $value
        }

        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")

        Write-Verbose -Message "Calling New-DLPComplianceRule with Values: $(Convert-M365DscHashtableToString -Hashtable $CreationParams)"
        New-DLPComplianceRule @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentRule.Ensure))
    {
        Write-Verbose "Rule {$($CurrentRule.Name)} already exists and needs to. Updating Rule."
        $UpdateParams = $PSBoundParameters

        $value = @()
        foreach ($item in $UpdateParams.ContentContainsSensitiveInformation)
        {
            $value += Get-SCDLPSensitiveInformation $item
        }
        $UpdateParams.ContentContainsSensitiveInformation = Get-SCDLPSensitiveInformation -SensitiveInformation $value
        $UpdateParams.Remove("GlobalAdminAccount") | Out-Null
        $UpdateParams.Remove("Ensure") | Out-Null
        $UpdateParams.Remove("Name") | Out-Null
        $UpdateParams.Remove("Policy") | Out-Null
        $UpdateParams.Add("Identity", $Name)

        Write-Verbose "Updating Rule with values: $(Convert-M365DscHashtableToString -Hashtable $UpdateParams)"
        Set-DLPComplianceRule @UpdateParams
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentRule.Ensure))
    {
        Write-Verbose "Rule {$($CurrentRule.Name)} already exists but shouldn't. Deleting Rule."
        Remove-DLPComplianceRule -Identity $CurrentRule.Name -Confirm:$false
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
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Policy,

        [Parameter()]
        [ValidateSet("InOrganization", "NotInOrganization", "None")]
        [System.String[]]
        $AccessScope,

        [Parameter()]
        [System.Boolean]
        $BlockAccess,

        [Parameter()]
        [ValidateSet("All", "PerUser")]
        [System.String]
        $BlockAccessScope,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ContentContainsSensitiveInformation,

        [Parameter()]
        [System.String[]]
        $ContentPropertyContainsWords,

        [Parameter()]
        [System.Boolean]
        $Disabled,

        [Parameter()]
        [System.String[]]
        $GenerateAlert,

        [Parameter()]
        [System.String[]]
        $GenerateIncidentReport,

        [Parameter()]
        [ValidateSet("All", "Default", "DetectionDetails", "Detections", "DocumentAuthor", "DocumentLastModifier", "MatchedItem", "OriginalContent", "RulesMatched", "Service", "Severity", "Title", "RetentionLabel", "SensitivityLabel")]
        [System.String[]]
        $IncidentReportContent,

        [Parameter()]
        [ValidateSet("FalsePositive", "WithoutJustification", "WithJustification")]
        [System.String[]]
        $NotifyAllowOverride,

        [Parameter()]
        [System.String]
        $NotifyEmailCustomText,

        [Parameter()]
        [System.String]
        $NotifyPolicyTipCustomText,

        [Parameter()]
        [System.String[]]
        $NotifyUser,

        [Parameter()]
        [ValidateSet("Low", "Medium", "High", "None")]
        [System.String]
        $ReportSeverityLevel,

        [Parameter()]
        [ValidateSet("Ignore", "RetryThenBlock")]
        [System.String]
        $RuleErrorAction,

        [Parameter()]
        [System.String[]]
        $AnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $AnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ContentExtensionMatchesWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfContentExtensionMatchesWords,

        [Parameter()]
        [System.Boolean]
        $RemoveRMSTemplate,

        [Parameter()]
        [System.Boolean]
        $StopPolicyProcessing,

        [Parameter()]
        [System.Boolean]
        $DocumentIsUnsupported,

        [Parameter()]
        [System.Boolean]
        $ExceptIfDocumentIsUnsupported,

        [Parameter()]
        [System.Boolean]
        $HasSenderOverride,

        [Parameter()]
        [System.Boolean]
        $ExceptIfHasSenderOverride,

        [Parameter()]
        [System.Boolean]
        $ProcessingLimitExceeded,

        [Parameter()]
        [System.Boolean]
        $ExceptIfProcessingLimitExceeded,

        [Parameter()]
        [System.Boolean]
        $DocumentIsPasswordProtected,

        [Parameter()]
        [System.Boolean]
        $ExceptIfDocumentIsPasswordProtected,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of DLPComplianceRule for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    #region Test Sensitive Information Type
    # For each Desired SIT check to see if there is an existing rule with the same name
    if ($null -ne $ValuesToCheck['ContentContainsSensitiveInformation'])
    {
        $contentSITS = Get-SCDLPSensitiveInformation -SensitiveInformation $ValuesToCheck['ContentContainsSensitiveInformation']
    }

    foreach ($sit in $contentSITS)
    {
        Write-Verbose -Message "Trying to find existing Sensitive Information Action matching name {$($sit.name)}"
        $matchingExistingRule = $CurrentValues.ContentContainsSensitiveInformation | Where-Object -FilterScript { $_.name -eq $sit.name }

        if ($null -ne $matchingExistingRule)
        {
            Write-Verbose -Message "Sensitive Information Action {$($sit.name)} was found"
            $propertiesTocheck = @("id", "maxconfidence", "minconfidence", "classifiertype", "mincount", "maxcount")

            foreach ($property in $propertiesToCheck)
            {
                Write-Verbose -Message "Checking property {$property} for Sensitive Information Action {$($sit.name)}"
                if ($sit.$property -ne $matchingExistingRule.$property)
                {
                    Write-Verbose -Message "Property {$property} is set to {$($matchingExistingRule.$property)} and is expected to be {$($sit.$property)}."
                    $EventMessage = "DLP Compliance Rule {$Name} was not in the desired state.`r`n" + `
                        "Sensitive Information Action {$($sit.name)} has invalid value for property {$property}. " + `
                        "Current value is {$($matchingExistingRule.$property)} and is expected to be {$($sit.$property)}."
                    Add-M365DSCEvent -Message $EventMessage -EntryType 'Warning' `
                        -EventID 1 -Source $($MyInvocation.MyCommand.Source)
                    return $false
                }
            }
        }
        else
        {
            Write-Verbose -Message "Sensitive Information Action {$($sit.name)} was not found"
            $EventMessage = "DLP Compliance Rule {$Name} was not in the desired state.`r`n" + `
                "An action on {$($sit.name)} Sensitive Information Type is missing."
            Add-M365DSCEvent -Message $EventMessage -EntryType 'Warning' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source)
            return $false
        }
    }
    #endregion
    $ValuesToCheck.Remove('ContentContainsSensitiveInformation') | Out-Null

    Write-Verbose "Completed SIT check"

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
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$rules = Get-DLPComplianceRule -ErrorAction Stop | Where-Object { $_.Mode -ne 'PendingDeletion' }

        $i = 1
        $dscContent = ""
        Write-Host "`r`n" -NoNewline
        foreach ($rule in $rules)
        {
            Write-Host "    |---[$i/$($rules.Length)] $($rule.Name)" -NoNewline
            $Params = @{
                Name               = $rule.name
                Policy             = $rule.ParentPolicyName
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $Results = Get-TargetResource @Params

            $IsCIMArray = $false
            if ($Results.ContentContainsSensitiveInformation.Length -gt 1)
            {
                $IsCIMArray = $true
            }
            if ($null -ne $Results.ContentContainsSensitiveInformation )
            {
                $Results.ContentContainsSensitiveInformation = ConvertTo-SCDLPSensitiveInformationString -InformationArray $Results.ContentContainsSensitiveInformation
            }

            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
            if ($null -ne $Results.ContentContainsSensitiveInformation )
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "ContentContainsSensitiveInformation" -IsCIMArray $IsCIMArray
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
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $GlobalAdminAccount)
            {
                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
            }
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

function ConvertTo-SCDLPSensitiveInformationString
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $InformationArray
    )
    $result = @()

    foreach ($SensitiveInformationHash in $InformationArray)
    {
        $StringContent = "MSFT_SCDLPSensitiveInformation`r`n            {`r`n"
        $StringContent += "                name = '$($SensitiveInformationHash.name.Replace("'", "''"))'`r`n"

        if ($null -ne $SensitiveInformationHash.id)
        {
            $StringContent += "                id = '$($SensitiveInformationHash.id)'`r`n"
        }

        if ($null -ne $SensitiveInformationHash.maxconfidence)
        {
            $StringContent += "                maxconfidence = '$($SensitiveInformationHash.maxconfidence)'`r`n"
        }

        if ($null -ne $SensitiveInformationHash.minconfidence)
        {
            $StringContent += "                minconfidence = '$($SensitiveInformationHash.minconfidence)'`r`n"
        }

        if ($null -ne $SensitiveInformationHash.classifiertype)
        {
            $StringContent += "                classifiertype = '$($SensitiveInformationHash.classifiertype)'`r`n"
        }

        if ($null -ne $SensitiveInformationHash.mincount)
        {
            $StringContent += "                mincount = '$($SensitiveInformationHash.mincount)'`r`n"
        }

        if ($null -ne $SensitiveInformationHash.maxcount)
        {
            $StringContent += "                maxcount = '$($SensitiveInformationHash.maxcount)'`r`n"
        }

        $StringContent += "            }`r`n"
        $result += $StringContent
    }
    return $result
}

function Get-SCDLPSensitiveInformation
{
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $SensitiveInformation
    )

    $returnValue = @()

    foreach ($item in $SensitiveInformation)
    {
        $result = @{
            name = $item.name
        }

        if ($null -ne $item.id)
        {
            $result.Add("id", $item.id)
        }

        if ($null -ne $item.maxconfidence)
        {
            $result.Add("maxconfidence", $item.maxconfidence)
        }

        if ($null -ne $item.minconfidence)
        {
            $result.Add("minconfidence", $item.minconfidence)
        }

        if ($null -ne $item.rulePackId)
        {
            $result.Add("rulePackId", $item.rulePackId)
        }

        if ($null -ne $item.classifiertype)
        {
            $result.Add("classifiertype", $item.classifiertype)
        }

        if ($null -ne $item.mincount)
        {
            $result.Add("mincount", $item.mincount)
        }

        if ($null -ne $item.maxcount)
        {
            $result.Add("maxcount", $item.maxcount)
        }
        $returnValue += $result
    }
    return $returnValue
}

Export-ModuleMember -Function *-TargetResource
