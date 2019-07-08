function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FilePlanProperty,

        [Parameter()]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [System.Boolean]
        $IsRecordLabel,

        [Parameter()]
        [System.Boolean]
        $Regulatory,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $ReviewerEmail,

        [Parameter()]
        [ValidateSet("Delete", "Keep", "KeepAndDelete")]
        [System.String]
        $RetentionAction,

        [Parameter()]
        [System.String]
        $EventType,

        [Parameter()]
        [ValidateSet("CreationAgeInDays", "EventAgeInDays", "ModificationAgeInDays", "TaggedAgeInDays")]
        [System.String]
        $RetentionType,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of ComplianceTag for $Name"

    Write-Verbose -Message "Calling Test-SecurityAndComplianceConnection function:"
    Test-SecurityAndComplianceConnection -GlobalAdminAccount $GlobalAdminAccount

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
        $ConvertedFilePlanProperty = Get-SCFilePlanProperty $tagObject.FilePlanMetadata
        $result = @{
            Name               = $tagObject.Name
            Comment            = $tagObject.Comment
            FilePlanProperty   = $ConvertedFilePlanProperty
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

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FilePlanProperty,

        [Parameter()]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [System.Boolean]
        $IsRecordLabel,

        [Parameter()]
        [System.Boolean]
        $Regulatory,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $ReviewerEmail,

        [Parameter()]
        [ValidateSet("Delete", "Keep", "KeepAndDelete")]
        [System.String]
        $RetentionAction,

        [Parameter()]
        [System.String]
        $EventType,

        [Parameter()]
        [ValidateSet("CreationAgeInDays", "EventAgeInDays", "ModificationAgeInDays", "TaggedAgeInDays")]
        [System.String]
        $RetentionType,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of ComplianceTag for $Name"

    Test-SecurityAndComplianceConnection -GlobalAdminAccount $GlobalAdminAccount
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FilePlanProperty,

        [Parameter()]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [System.Boolean]
        $IsRecordLabel,

        [Parameter()]
        [System.Boolean]
        $Regulatory,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $ReviewerEmail,

        [Parameter()]
        [ValidateSet("Delete", "Keep", "KeepAndDelete")]
        [System.String]
        $RetentionAction,

        [Parameter()]
        [System.String]
        $EventType,

        [Parameter()]
        [ValidateSet("CreationAgeInDays", "EventAgeInDays", "ModificationAgeInDays", "TaggedAgeInDays")]
        [System.String]
        $RetentionType,

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
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        SCComplianceTag " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

function Get-SCFilePlanPropertyObject
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter()]
        $Properties
    )

    if ($null -eq $Properties)
    {
        return $null
    }

    $result = [PSCustomObject]@{
        Settings=@(
            @{Key="FilePlanPropertyDepartment"; Value=$properties.FilePlanPropertyDepartment},
            @{Key="FilePlanPropertyCategory";   Value=$properties.FilePlanPropertyCategory},
            @{Key="FilePlanPropertySubcategory";Value=$properties.FilePlanPropertySubcategory},
            @{Key="FilePlanPropertyCitation";   Value=$properties.FilePlanPropertyCitation},
            @{Key="FilePlanPropertyReferenceId";Value=$properties.FilePlanPropertyReferenceId},
            @{Key="FilePlanPropertyAuthority";  Value=$properties.FilePlanPropertyAuthority}
        )}

    return $result
}

function Get-SCFilePlanProperty
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory=$true)]
        [System.String]
        $Metadata
    )

    if ($null -eq $Metadata)
    {
        return $null
    }
    $JSONObject = ConvertFrom-JSON $Metadata
    $result = @{
        FilePlanPropertyDepartment  = $JSONObject.Settings["FilePlanPropertyDepartment"].Value
        FilePlanPropertyCategory    = $JSONObject.Settings["FilePlanPropertyCategory"].Value
        FilePlanPropertySubcategory = $JSONObject.Settings["FilePlanPropertySubcategory"].Value
        FilePlanPropertyCitation    = $JSONObject.Settings["FilePlanPropertyCitation"].Value
        FilePlanPropertyReferenceId = $JSONObject.Settings["FilePlanPropertyReferenceId"].Value
        FilePlanPropertyAuthority   = $JSONObject.Settings["FilePlanPropertyAuthority"].Value
    }

    return $result
}

function Test-SCFilePlanProperties
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter(Mandatory = $true)] $CurrentProperty,
        [Parameter(Mandatory = $true)] $DesiredProperty
    )

    if ($CurrentProperty.FilePlanPropertyDepartment -ne $DesiredProperty.FilePlanPropertyDepartment -or `
        $CurrentProperty.FilePlanPropertyCategory -ne $DesiredProperty.FilePlanPropertyCategory -or `
        $CurrentProperty.FilePlanPropertySubcategory -ne $DesiredProperty.FilePlanPropertySubcategory -or `
        $CurrentProperty.FilePlanPropertyCitation -ne $DesiredProperty.FilePlanPropertyCitation -or `
        $CurrentProperty.FilePlanPropertyReferenceId -ne $DesiredProperty.FilePlanPropertyReferenceId -or `
        $CurrentProperty.FilePlanPropertyAuthority -ne $DesiredProperty.FilePlanPropertyAuthority)
    {
        return $false
    }

    return $true
}

Export-ModuleMember -Function *-TargetResource
