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
        [System.String]
        $AdvancedSettings,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $LocaleSettings,

        [Parameter()]
        [System.String]
        $ParentId,

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String]
        $Tooltip,

        [Parameter()]
        [System.Boolean]
        $Disabled,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Sensitiivity Label for $Name"

    Write-Verbose -Message "Calling Test-SecurityAndComplianceConnection function:"
    Test-SecurityAndComplianceConnection -GlobalAdminAccount $GlobalAdminAccount

    $label = Get-Label -Identity $Name

    if ($null -eq $label)
    {
        Write-Verbose -Message "Sensitiivity label $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        Write-Verbose "Found existing Sensitiivity Label $($Name)"
        $result = @{
            Name               = $label.Name
            Comment            = $label.Comment
            ParentId           = $label.ParentId
            AdvancedSettings   = $label.AdvancedSettings
            DisplayName        = $label.DisplayName
            LocaleSettings     = $label.LocaleSettings
            Priority           = $label.Priority
            Tooltip            = $label.Tooltip
            Disabled           = $label.Disabled
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
        [System.String]
        $AdvancedSettings,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $LocaleSettings,

        [Parameter()]
        [System.String]
        $ParentId,

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String]
        $Tooltip,

        [Parameter()]
        [System.Boolean]
        $Disabled,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Sensitiivity label for $Name"

    Test-SecurityAndComplianceConnection -GlobalAdminAccount $GlobalAdminAccount
    $label = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $label.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")
        $CreationParams.Remove("Priority")
        $CreationParams.Remove("Disabled")

        Write-Verbose "Creating new Sensitiivity label $Name calling the New-Label cmdlet."
        New-Label @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $label.Ensure))
    {
        $SetParams = $PSBoundParameters

        #Remove unused parameters for Set-Label cmdlet
        $SetParams.Remove("GlobalAdminAccount")
        $SetParams.Remove("Ensure")
        Set-Label @SetParams -Identity $Name
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $label.Ensure))
    {
        # If the label exists and it shouldn't, simply remove it;
        Remove-Label -Identity $Name -Confirm:$false
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
        [System.String]
        $AdvancedSettings,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $LocaleSettings,

        [Parameter()]
        [System.String]
        $ParentId,

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String]
        $Tooltip,

        [Parameter()]
        [System.Boolean]
        $Disabled,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Sensitiivity label for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null


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
    $content = "        SCSensitivityLabel " + (New-GUID).ToString() + "`r`n"
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
        Settings = @(
            @{Key = "FilePlanPropertyDepartment"; Value = $properties.FilePlanPropertyDepartment },
            @{Key = "FilePlanPropertyCategory"; Value = $properties.FilePlanPropertyCategory },
            @{Key = "FilePlanPropertySubcategory"; Value = $properties.FilePlanPropertySubcategory },
            @{Key = "FilePlanPropertyCitation"; Value = $properties.FilePlanPropertyCitation },
            @{Key = "FilePlanPropertyReferenceId"; Value = $properties.FilePlanPropertyReferenceId },
            @{Key = "FilePlanPropertyAuthority"; Value = $properties.FilePlanPropertyAuthority }
        )
    }

    return $result
}

function Get-SCFilePlanProperty
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
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
