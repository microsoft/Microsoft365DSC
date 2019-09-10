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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
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
    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    $label = Get-Label -Identity $Name -ErrorAction SilentlyContinue

    ### Testing
    $advanced = Convert-CimInstancesToHashtable $AdvancedSettings
    # $locales = Convert-CimInstancesToHashtable $LocaleSettings
    Write-Verbose -Message "ADVANCED SETTTINGS: $(Convert-O365DscHashtableToString -Hashtable $advanced)"
    # Write-Verbose -Message "LOCALE SETTTINGS: $(Convert-O365DscHashtableToString -Hashtable $locales)"
    #####

    if ($null -eq $label)
    {
        Write-Verbose -Message "Sensitiivity label $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $parentLabel = Get-Label -Identity $label.ParentId -ErrorAction SilentlyContinue

        Write-Verbose "Found existing Sensitiivity Label $($Name)"
        $result = @{
            Name               = $label.Name
            Comment            = $label.Comment
            ParentId           = $parentLabel.Name
            AdvancedSettings   = $AdvancedSettings
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
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

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    $label = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $label.Ensure))
    {
        if ($null -ne $label.Priority)
        {
            throw "SCSensitivityLabel can't set Priortity property on " + `
                "new label {$Name} to $label.Priority." + `
                "You will need to set priority property once label is created."
        }

        if ($null -ne $label.Disabled)
        {
            throw "SCSensitivityLabel can't set disabled property on " + `
                "new label {$Name} to $label.Disabled." + `
                "You will need to set disabled property once label is created."
        }

        $CreationParams = $PSBoundParameters
        if ($PSBoundParameters.ContainsKey("AdvancedSettings"))
        {
            $advanced = Convert-CimInstancesToHashtable $AdvancedSettings
            $CreationParams["AdvancedSettings"] = $advanced
        }

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
        if ($PSBoundParameters.ContainsKey("AdvancedSettings"))
        {
            $advanced = Convert-CimInstancesToHashtable $AdvancedSettings
            $SetParams["AdvancedSettings"] = $advanced
        }

        #Remove unused parameters for Set-Label cmdlet
        $SetParams.Remove("GlobalAdminAccount")
        $SetParams.Remove("Ensure")
        $SetParams.Remove("Name")
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
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
    $labelSettings = Convert-CimInstancesToHashtable $AdvancedSettings

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('AdvancedSettings') | Out-Null

    if ($null -ne $labelSettings)
    {
        Write-Verbose -Message "Testing advanced settings for Label $Name"
        $TestAdvancedSettings = Test-AdvancedSettings -DesiredProperty $labelSettings
        if ($false -eq $TestAdvancedSettings)
        {
            return $false
        }
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

function Convert-CimInstancesToHashtable([Microsoft.Management.Infrastructure.CimInstance[]] $Pairs)
{
    $hash = @{ }
    foreach ($pair in $Pairs)
    {
        $hash[$pair.Key] = $pair.Value
    }

    return $hash
}

function Test-AdvancedSettings
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter (Mandatory = $true)]
        [Hashtable]
        $DesiredProperty
    )

    $foundSetting = $false
    #Check to see if advanced settings are in Label settings property of current label
    $label = Get-Label -Identity $Name
    if ($null -ne $label)
    {
        foreach ($key in $DesiredProperty.Keys)
        {
            foreach ($setting in $label.settings)
            {
                if ($setting.contains($key.tolower()) -and $setting.contains($DesiredProperty[$key]))
                {
                    $foundSetting = $true
                    Write-Verbose -Message "Found advanced setting in Label settings with $key and value of $($DesiredProperty[$key])"
                    break
                }
                $foundSetting = $false
            }
        }
    }
    return $foundSetting
}

Export-ModuleMember -Function *-TargetResource
