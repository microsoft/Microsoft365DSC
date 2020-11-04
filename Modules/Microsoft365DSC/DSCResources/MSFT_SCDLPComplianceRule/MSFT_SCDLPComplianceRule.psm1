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
        [ValidateSet("All", "Default", "DetectionDetails", "Detections", "DocumentAuthor", "DocumentLastModifier", "MatchedItem", "OriginalContent", "RulesMatched", "Service", "Severity", "Title")]
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
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of DLPCompliancePolicy for $Name"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

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

            [array] $SensitiveInfo = @($PolicyRule.ContentContainsSensitiveInformation[0])

            if ($null -ne $SensitiveInfo.groups)
            {
                $groups = $SensitiveInfo.groups
                $SensitiveInfo = @()
                foreach ($group in $groups)
                {
                    foreach ($siEntry in $group.sensitivetypes)
                    {
                        $SensitiveInfo += [System.Collections.Hashtable]$siEntry
                    }
                }
            }

            $result = @{
                Ensure                              = 'Present'
                Name                                = $PolicyRule.Name
                Policy                              = $PolicyRule.ParentPolicyName
                AccessScope                         = $PolicyRule.AccessScope
                BlockAccess                         = $PolicyRule.BlockAccess
                BlockAccessScope                    = $PolicyRule.BlockAccessScope
                Comment                             = $PolicyRule.Comment
                ContentContainsSensitiveInformation = $SensitiveInfo
                ContentPropertyContainsWords        = $PolicyRule.ContentPropertyContainsWords
                Disabled                            = $PolicyRule.Disabled
                GenerateAlert                       = $PolicyRule.GenerateAlert
                GenerateIncidentReport              = $PolicyRule.GenerateIncidentReport
                IncidentReportContent               = $ArrayIncidentReportContent
                NotifyAllowOverride                 = $NotifyAllowOverrideValue
                NotifyEmailCustomText               = $PolicyRule.NotifyEmailCustomText
                NotifyPolicyTipCustomText           = $PolicyRule.NotifyPolicyTipCustomText
                NotifyUser                          = $PolicyRule.NotifyUser
                ReportSeverityLevel                 = $PolicyRule.ReportSeverityLevel
                RuleErrorAction                     = $PolicyRule.RuleErrorAction
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
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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
        [ValidateSet("All", "Default", "DetectionDetails", "Detections", "DocumentAuthor", "DocumentLastModifier", "MatchedItem", "OriginalContent", "RulesMatched", "Service", "Severity", "Title")]
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
        [ValidateSet("All", "Default", "DetectionDetails", "Detections", "DocumentAuthor", "DocumentLastModifier", "MatchedItem", "OriginalContent", "RulesMatched", "Service", "Severity", "Title")]
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
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of DLPComplianceRule for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Name",
        "Policy",
        "AccessScope",
        "BlockAccess",
        "BlockAccessScope",
        "Comment",
        "ContentPropertyContainsWords",
        "Disabled",
        "GenerateAlert",
        "GenerateIncidentReport",
        "IncidentReportContent",
        "NotifyAllowOverride",
        "NotifyEmailCustomText",
        "NotifyPolicyTipCustomText",
        "NotifyUser",
        "ReportSeverityLevel",
        "RuleErrorAction",
        "Ensure")

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
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$rules = Get-DLPComplianceRule -ErrorAction Stop | Where-Object { $_.Mode -ne 'PendingDeletion' }

        $i = 1
        $dscContent = ""
        Write-Host "`r`n" -NoNewLine
        foreach ($rule in $rules)
        {
            Write-Host "    |---[$i/$($rules.Length)] $($rule.Name)" -NoNewLine
            $Params = @{
                Name                  = $rule.name
                Policy                = $rule.ParentPolicyName
                GlobalAdminAccount    = $GlobalAdminAccount
            }
            $Results = Get-TargetResource @Params

            $IsCIMArray = $false
            if ($Results.ContentContainsSensitiveInformation.Length -gt 1)
            {
                $IsCIMArray = $true
            }
            $Results.ContentContainsSensitiveInformation = ConvertTo-SCDLPSensitiveInformationString -InformationArray $Results.ContentContainsSensitiveInformation

            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -GlobalAdminAccount $GlobalAdminAccount
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "ContentContainsSensitiveInformation" -IsCIMArray $IsCIMArray

            $dscContent += $currentDSCBlock
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }

        return $dscContent
    }
    catch
    {
        Write-verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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
