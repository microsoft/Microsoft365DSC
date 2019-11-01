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
        [ValidateSet("InOrganization","NotInOrganization","None")]
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
        [Microsoft.Management.Infrastructure.CimInstance]
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

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SecurityComplianceCenter

    $PolicyRule = Get-DlpComplianceRule -Identity $Name -ErrorAction SilentlyContinue

    if ($null -eq $PolicyRule)
    {
        Write-Verbose -Message "DLPComplianceRule $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
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

        $result = @{
            Ensure                              = 'Present'
            Name                                = $PolicyRule.Name
            Policy                              = $PolicyRule.ParentPolicyName
            AccessScope                         = $PolicyRule.AccessScope
            BlockAccess                         = $PolicyRule.BlockAccess
            BlockAccessScope                    = $PolicyRule.BlockAccessScope
            Comment                             = $PolicyRule.Comment
            ContentContainsSensitiveInformation = $PolicyRule.ContentContainsSensitiveInformation[0]
            ContentPropertyContainsWords        = $PolicyRule.ContentPropertyContainsWords
            Disabled                            = $PolicyRule.Disabled
            GenerateAlert                       = $PolicyRule.GenerateAlert
            GenerateIncidentReport              = $PolicyRule.GenerateIncidentReport
            IncidentReportContent               = $ArrayIncidentReportContent
            NotifyAllowOverride                 = $PolicyRule.NotifyAllowOverride
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

        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-O365DscHashtableToString -Hashtable $result)"
        return $result
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
        [ValidateSet("InOrganization","NotInOrganization","None")]
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
        [Microsoft.Management.Infrastructure.CimInstance]
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

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SecurityComplianceCenter

    $CurrentRule = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentRule.Ensure))
    {
        Write-Verbose "Rule {$($CurrentRule.Name)} doesn't exists but need to. Creating Rule."
        $CreationParams = $PSBoundParameters
        if ($null -ne $CreationParams.ContentContainsSensitiveInformation)
        {
            $CreationParams.ContentContainsSensitiveInformation = Get-SCDLPSensitiveInformation $CreationParams.ContentContainsSensitiveInformation
        }

        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")

        Write-Verbose -Message "Calling New-DLPComplianceRule with Values: $(Convert-O365DscHashtableToString -Hashtable $CreationParams)"
        New-DLPComplianceRule @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentRule.Ensure))
    {
        Write-Verbose "Rule {$($CurrentRule.Name)} already exists and needs to. Updating Rule."
        $UpdateParams = $PSBoundParameters
        $UpdateParams.ContentContainsSensitiveInformation = Get-SCDLPSensitiveInformation -SensitiveInformation $UpdateParams.ContentContainsSensitiveInformation
        $UpdateParams.Remove("GlobalAdminAccount")
        $UpdateParams.Remove("Ensure")
        $UpdateParams.Remove("Name")
        $UpdateParams.Remove("Policy")
        $UpdateParams.Add("Identity", $Name)

        Write-Verbose "Updating Rule with values: $(Convert-O365DscHashtableToString -Hashtable $UpdateParams)"
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
        [ValidateSet("InOrganization","NotInOrganization","None")]
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
        [Microsoft.Management.Infrastructure.CimInstance]
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

    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
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

    $InformationPreference = "Continue"
    $rules = Get-DLPComplianceRule | Where-Object {$_.Mode -ne 'PendingDeletion'}

    $i = 1
    $DSCContent = ""
    foreach ($rule in $rules)
    {
        Write-Information "    - [$i/$($rules.Length)] $($rule.Name)"
        $result = Get-TargetResource -Name $rule.Name -Policy $rule.ParentPolicyName -GlobalAdminAccount $GlobalAdminAccount
        $result.ContentContainsSensitiveInformation = ConvertTo-SCDLPSensitiveInformationString -SensitiveInformationHash $result.ContentContainsSensitiveInformation
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $partialContent = "        SCDLPComplianceRule " + (New-GUID).ToString() + "`r`n"
        $partialContent += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "ContentContainsSensitiveInformation"

        $partialContent += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $partialContent += "        }`r`n"
        $DSCContent += $partialContent
        $i++
    }

    return $DSCContent
}

function ConvertTo-SCDLPSensitiveInformationString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $SensitiveInformationHash
    )

    $StringContent = "MSFT_SCDLPSensitiveInformation`r`n            {`r`n"
    $StringContent += "                name = '$($SensitiveInformationHash.name)'`r`n"

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

    $StringContent += "            }"
    return $StringContent
}

function Get-SCDLPSensitiveInformation
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SensitiveInformation
    )

    $result = @{
        name           = $SensitiveInformation.name
    }

    if ($null -ne $SensitiveInformation.id)
    {
        $result.Add("id", $SensitiveInformation.id)
    }

    if ($null -ne $SensitiveInformation.maxconfidence)
    {
        $result.Add("maxconfidence", $SensitiveInformation.maxconfidence)
    }

    if ($null -ne $SensitiveInformation.minconfidence)
    {
        $result.Add("minconfidence", $SensitiveInformation.minconfidence)
    }

    if ($null -ne $SensitiveInformation.rulePackId)
    {
        $result.Add("rulePackId", $SensitiveInformation.rulePackId)
    }

    if ($null -ne $SensitiveInformation.classifiertype)
    {
        $result.Add("classifiertype", $SensitiveInformation.classifiertype)
    }

    if ($null -ne $SensitiveInformation.mincount)
    {
        $result.Add("mincount", $SensitiveInformation.mincount)
    }

    if ($null -ne $SensitiveInformation.maxcount)
    {
        $result.Add("maxcount", $SensitiveInformation.maxcount)
    }
    return $result
}

Export-ModuleMember -Function *-TargetResource
