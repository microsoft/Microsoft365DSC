function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.String]
        [ValidateSet('Export', 'Purge', 'Retention')]
        $Action,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SearchName,

        [Parameter()]
        [System.String[]]
        $FileTypeExclusionsForUnindexedItems,

        [Parameter()]
        [System.Boolean]
        $EnableDedupe,

        [Parameter()]
        [System.Boolean]
        $IncludeCredential,

        [Parameter()]
        [System.Boolean]
        $IncludeSharePointDocumentVersions,

        [Parameter()]
        [System.String]
        [ValidateSet('SoftDelete', 'HardDelete')]
        $PurgeType,

        [Parameter()]
        [System.Boolean]
        $RetryOnError,

        [Parameter()]
        [System.String]
        [ValidateSet('IndexedItemsOnly', 'UnindexedItemsOnly', 'BothIndexedAndUnindexedItems')]
        $ActionScope,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of SCComplianceSearchAction for $Name"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SecurityComplianceCenter

    $currentAction = Get-ComplianceSearchAction -Details | Where-Object {$_.SearchName -eq $SearchName -and $_.Action -eq $Action}

    if ($null -eq $currentAction)
    {
        Write-Verbose -Message "SCComplianceSearchAction $ActionName does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        if ('Purge' -ne $Action)
        {
            $Scenario = 'GenerateReportsOnly'
            if ('Retention' -eq $Action)
            {
                $Scenario = 'RetentionReports'
            }

            $currentAction = $currentAction | Where-Object {$_.Results -like "*Scenario: $($Scenario)*"}

            $FileTypeExclusion = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "File type exclusions for unindexed"
            $EnableDedupe      = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "Enable dedupe"
            $IncludeCreds      = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "SAS token"
            $IncludeSP         = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "Include SharePoint versions"
            $ScopeValue        = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "Scope"

            $result = @{
                Action                              = $currentAction.Action
                SearchName                          = $currentAction.SearchName
                FileTypeExclusionsForUnindexedItems = $FileTypeExclusion
                EnableDedupe                        = $EnableDedupe
                IncludeSharePointDocumentVersions   = $IncludeSP
                RetryOnError                        = $currentAction.Retry
                ActionScope                         = $ScopeValue
                GlobalAdminAccount                  = $GlobalAdminAccount
                Ensure                              = 'Present'
            }
        }
        else
        {
            $PurgeTP           = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "Purge Type"
            $result = @{
                Action                              = $currentAction.Action
                SearchName                          = $currentAction.SearchName
                PurgeType                           = $PurgeTP
                RetryOnError                        = $currentAction.Retry
                GlobalAdminAccount                  = $GlobalAdminAccount
                Ensure                              = 'Present'
            }
        }

        if ('<Specify -IncludeCredential parameter to show the SAS token>' -eq $IncludeCreds)
        {
            $result.Add("IncludeCredential", $false)
        }
        else
        {
            $result.Add("IncludeCredential", $true)
        }

        Write-Verbose "Found existing $Action SCComplianceSearchAction for Search $SearchName"

        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-O365DscHashtableToString -Hashtable $result)"
        return $result
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.String]
        [ValidateSet('Export', 'Purge', 'Retention')]
        $Action,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SearchName,

        [Parameter()]
        [System.String[]]
        $FileTypeExclusionsForUnindexedItems,

        [Parameter()]
        [System.Boolean]
        $EnableDedupe,

        [Parameter()]
        [System.Boolean]
        $IncludeCredential,

        [Parameter()]
        [System.Boolean]
        $IncludeSharePointDocumentVersions,

        [Parameter()]
        [System.String]
        [ValidateSet('SoftDelete', 'HardDelete')]
        $PurgeType,

        [Parameter()]
        [System.Boolean]
        $RetryOnError,

        [Parameter()]
        [System.String]
        [ValidateSet('IndexedItemsOnly', 'UnindexedItemsOnly', 'BothIndexedAndUnindexedItems')]
        $ActionScope,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of ComplianceTag for $Name"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SecurityComplianceCenter

    $CurrentTag = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentTag.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")

        #Convert File plan to JSON before Set
        if ($FilePlanProperty)
        {
            Write-Verbose -Message "Converting FilePlan to JSON"
            $FilePlanPropertyJSON = ConvertTo-JSON (Get-SCFilePlanPropertyObject $FilePlanProperty)
            $CreationParams.FilePlanProperty = $FilePlanPropertyJSON
        }
        Write-Verbose "Creating new Compliance Tag $Name calling the New-ComplianceTag cmdlet."
        New-ComplianceTag @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentTag.Ensure))
    {
        $SetParams = $PSBoundParameters

        #Remove unused parameters for Set-ComplianceTag cmdlet
        $SetParams.Remove("GlobalAdminAccount")
        $SetParams.Remove("Ensure")
        $SetParams.Remove("Name")
        $SetParams.Remove("IsRecordLabel")
        $SetParams.Remove("Regulatory")
        $SetParams.Remove("RetentionAction")
        $SetParams.Remove("RetentionType")

        # Once set, a label can't be removed;
        if ($SetParams.IsRecordLabel -eq $false -and $CurrentTag.IsRecordLabel -eq $true)
        {
            throw "Can't remove label on the existing Compliance Tag {$Name}. " + `
                  "You will need to delete the tag and recreate it."
        }

        if ($null -ne $PsBoundParameters["Regulatory"] -and
            $Regulatory -ne $CurrentTag.Regulatory)
        {
            throw "SPComplianceTag can't change the Regulatory property on " + `
                  "existing tags {$Name} from $Regulatory to $($CurrentTag.Regulatory)." + `
                  " You will need to delete the tag and recreate it."
        }

        if ($RetentionAction -ne $CurrentTag.RetentionAction)
        {
            throw "SPComplianceTag can't change the RetentionAction property on " + `
                  "existing tags {$Name} from $RetentionAction to $($CurrentTag.RetentionAction)." + `
                  " You will need to delete the tag and recreate it."
        }

        if ($RetentionType -ne $CurrentTag.RetentionType)
        {
            throw "SPComplianceTag can't change the RetentionType property on " + `
                  "existing tags {$Name} from $RetentionType to $($CurrentTag.RetentionType)." + `
                  " You will need to delete the tag and recreate it."
        }

        #Convert File plan to JSON before Set
        if ($FilePlanProperty)
        {
            Write-Verbose -Message "Converting FilePlan properties to JSON"
            $FilePlanPropertyJSON = ConvertTo-JSON (Get-SCFilePlanPropertyObject $FilePlanProperty)
            $SetParams["FilePlanProperty"] = $FilePlanPropertyJSON
        }
        Set-ComplianceTag @SetParams -Identity $Name
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentTag.Ensure))
    {
        # If the Rule exists and it shouldn't, simply remove it;
        Remove-ComplianceTag -Identity $Name -Confirm:$false
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.String]
        [ValidateSet('Export', 'Purge', 'Retention')]
        $Action,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SearchName,

        [Parameter()]
        [System.String[]]
        $FileTypeExclusionsForUnindexedItems,

        [Parameter()]
        [System.Boolean]
        $EnableDedupe,

        [Parameter()]
        [System.Boolean]
        $IncludeCredential,

        [Parameter()]
        [System.Boolean]
        $IncludeSharePointDocumentVersions,

        [Parameter()]
        [System.String]
        [ValidateSet('SoftDelete', 'HardDelete')]
        $PurgeType,

        [Parameter()]
        [System.Boolean]
        $RetryOnError,

        [Parameter()]
        [System.String]
        [ValidateSet('IndexedItemsOnly', 'UnindexedItemsOnly', 'BothIndexedAndUnindexedItems')]
        $ActionScope,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of ComplianceTag for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove("FilePlanProperty") | Out-Null

    $TestFilePlanProperties = Test-SCFilePlanProperties -CurrentProperty $CurrentValues `
                                -DesiredProperty $PSBoundParameters

    if ($false -eq $TestFilePlanProperties)
    {
        return $false
    }

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
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

    $InformationPreference = "Continue"
    Test-MSCloudLogin -Platform SecurityComplianceCenter `
                      -CloudCredential $GlobalAdminAccount

    $actions = Get-ComplianceSearchAction

    $i = 1
    $content = ""
    foreach ($action in $actions)
    {
        Write-Information "    [$i/$($actions.Length)] $($action.Name)"
        $params = @{
            Action             = $action.Action
            SearchName         = $action.SearchName
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        SCComplianceSearchAction " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $i++
    }
    return $content
}

function Get-ResultProperty
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResultString,

        [Parameter(Mandatory = $true)]
        [System.String]
        $PropertyName
    )

    $start = $ResultString.IndexOf($PropertyName) + $PropertyName.Length + 2
    $end   = $ResultString.IndexOf(';', $start)

    $result = $null
    if ($end -gt $start)
    {
        $result = $ResultString.SubString($start, $end - $start).Trim()

        if ('<null>' -eq $result)
        {
            $result = $null
        }
        elseif ('True' -eq $result)
        {
            $result = $true
        }
        elseif ('False' -eq $result)
        {
            $result = $false
        }
    }

    return $result
}

Export-ModuleMember -Function *-TargetResource
