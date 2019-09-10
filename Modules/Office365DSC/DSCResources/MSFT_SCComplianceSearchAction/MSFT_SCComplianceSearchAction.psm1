function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.String[]]
        $SearchNames,

        [Parameter()]
        [System.Boolean]
        $Export = $false,

        [Parameter()]
        [System.String]
        $ActionName,

        [Parameter()]
        [System.String]
        $ArchiveFormat,

        [Parameter()]
        [System.String[]]
        $FileTypeExclusionsForUnindexedItems,

        [Parameter()]
        [Systerm.Boolean]
        $EnableDedupe,

        [Parameter()]
        [System.String]
        [ValidateSet('PerUserPst', 'SinglePst', 'SingleFolderPst', 'IndividualMessage', 'PerUserZip', 'SingleZip')]
        $ExchangeArchiveFormat,

        [Parameter()]
        [System.String]
        [ValidateSet('FxStream', 'Mime', 'Msg')]
        $Format,

        [Parameter()]
        [System.Boolean]
        $IncludeCredential,

        [Parameter()]
        [System.Boolean]
        $IncludeSharePointDocumentVersions,

        [Parameter()]
        [System.String]
        $NotifyEmail,

        [Parameter()]
        [System.String]
        $NotifyEmailCC,

        [Parameter()]
        [System.Boolean]
        $Preview,

        [Parameter()]
        [System.Boolean]
        $Purge,

        [Parameter()]
        [System.String]
        [ValidateSet('SoftDelete', 'HardDelete')]
        $PurgeType,

        [Parameter()]
        [System.Boolean]
        $Report,

        [Parameter()]
        [System.Boolean]
        $RetentionReport,

        [Parameter()]
        [System.Boolean]
        $RetryOnError,

        [Parameter()]
        [System.String]
        [ValidateSet('AnalyzeWithZoom', 'General', 'GeneralReportsOnly', 'Inventory', 'RetentionReports', 'TriagePreview')]
        $Scenario,

        [Parameter()]
        [System.String]
        [ValidateSet('IndexedItemsOnly', 'UnindexedItemsOnly', 'BothIndexedAndUnindexedItems')]
        $Scope,

        [Parameter()]
        [System.String]
        [ValidateSet('IndividualMessage', 'PerUserZip', 'SingleZip')]
        $SharePointArchiveFormat,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of ComplianceTag for $Name"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SecurityComplianceCenter

    $tagObjects = Get-ComplianceTag
    $tagObject = $tagObjects | Where-Object { $_.Name -eq $Name }

    if ($null -eq $tagObject)
    {
        Write-Verbose -Message "ComplianceTag $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        Write-Verbose "Found existing ComplianceTag $($Name)"
        $result = @{
            Name               = $tagObject.Name
            Comment            = $tagObject.Comment
            RetentionDuration  = $tagObject.RetentionDuration
            IsRecordLabel      = $tagObject.IsRecordLabel
            Regulatory         = $tagObject.Regulatory
            Notes              = $tagObject.Notes
            ReviewerEmail      = $tagObject.ReviewerEmail
            RetentionAction    = $tagObject.RetentionAction
            EventType          = $tagObject.EventType
            RetentionType      = $tagObject.RetentionType
            GlobalAdminAccount = $GlobalAdminAccount
            Ensure             = 'Present'
        }

        if (-not [System.String]::IsNullOrEmpty($tagObject.FilePlanMetadata))
        {
            $ConvertedFilePlanProperty = Get-SCFilePlanProperty $tagObject.FilePlanMetadata
            $result.Add("FilePlanProperty", $ConvertedFilePlanProperty)
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
        [Parameter(Mandatory=$true)]
        [System.String[]]
        $SearchNames,

        [Parameter()]
        [System.Boolean]
        $Export = $false,

        [Parameter()]
        [System.String]
        $ActionName,

        [Parameter()]
        [System.String]
        $ArchiveFormat,

        [Parameter()]
        [System.String[]]
        $FileTypeExclusionsForUnindexedItems,

        [Parameter()]
        [Systerm.Boolean]
        $EnableDedupe,

        [Parameter()]
        [System.String]
        [ValidateSet('PerUserPst', 'SinglePst', 'SingleFolderPst', 'IndividualMessage', 'PerUserZip', 'SingleZip')]
        $ExchangeArchiveFormat,

        [Parameter()]
        [System.String]
        [ValidateSet('FxStream', 'Mime', 'Msg')]
        $Format,

        [Parameter()]
        [System.Boolean]
        $IncludeCredential,

        [Parameter()]
        [System.Boolean]
        $IncludeSharePointDocumentVersions,

        [Parameter()]
        [System.String]
        $NotifyEmail,

        [Parameter()]
        [System.String]
        $NotifyEmailCC,

        [Parameter()]
        [System.Boolean]
        $Preview,

        [Parameter()]
        [System.Boolean]
        $Purge,

        [Parameter()]
        [System.String]
        [ValidateSet('SoftDelete', 'HardDelete')]
        $PurgeType,

        [Parameter()]
        [System.Boolean]
        $Report,

        [Parameter()]
        [System.Boolean]
        $RetentionReport,

        [Parameter()]
        [System.Boolean]
        $RetryOnError,

        [Parameter()]
        [System.String]
        [ValidateSet('AnalyzeWithZoom', 'General', 'GeneralReportsOnly', 'Inventory', 'RetentionReports', 'TriagePreview')]
        $Scenario,

        [Parameter()]
        [System.String]
        [ValidateSet('IndexedItemsOnly', 'UnindexedItemsOnly', 'BothIndexedAndUnindexedItems')]
        $Scope,

        [Parameter()]
        [System.String]
        [ValidateSet('IndividualMessage', 'PerUserZip', 'SingleZip')]
        $SharePointArchiveFormat,

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
        [System.String[]]
        $SearchNames,

        [Parameter()]
        [System.Boolean]
        $Export = $false,

        [Parameter()]
        [System.String]
        $ActionName,

        [Parameter()]
        [System.String]
        $ArchiveFormat,

        [Parameter()]
        [System.String[]]
        $FileTypeExclusionsForUnindexedItems,

        [Parameter()]
        [Systerm.Boolean]
        $EnableDedupe,

        [Parameter()]
        [System.String]
        [ValidateSet('PerUserPst', 'SinglePst', 'SingleFolderPst', 'IndividualMessage', 'PerUserZip', 'SingleZip')]
        $ExchangeArchiveFormat,

        [Parameter()]
        [System.String]
        [ValidateSet('FxStream', 'Mime', 'Msg')]
        $Format,

        [Parameter()]
        [System.Boolean]
        $IncludeCredential,

        [Parameter()]
        [System.Boolean]
        $IncludeSharePointDocumentVersions,

        [Parameter()]
        [System.String]
        $NotifyEmail,

        [Parameter()]
        [System.String]
        $NotifyEmailCC,

        [Parameter()]
        [System.Boolean]
        $Preview,

        [Parameter()]
        [System.Boolean]
        $Purge,

        [Parameter()]
        [System.String]
        [ValidateSet('SoftDelete', 'HardDelete')]
        $PurgeType,

        [Parameter()]
        [System.Boolean]
        $Report,

        [Parameter()]
        [System.Boolean]
        $RetentionReport,

        [Parameter()]
        [System.Boolean]
        $RetryOnError,

        [Parameter()]
        [System.String]
        [ValidateSet('AnalyzeWithZoom', 'General', 'GeneralReportsOnly', 'Inventory', 'RetentionReports', 'TriagePreview')]
        $Scenario,

        [Parameter()]
        [System.String]
        [ValidateSet('IndexedItemsOnly', 'UnindexedItemsOnly', 'BothIndexedAndUnindexedItems')]
        $Scope,

        [Parameter()]
        [System.String]
        [ValidateSet('IndividualMessage', 'PerUserZip', 'SingleZip')]
        $SharePointArchiveFormat,

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
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $result.FilePlanProperty = Get-SCFilePlanPropertyAsString $result.FilePlanProperty
    $content = "        SCComplianceTag " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "FilePlanProperty"
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
