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
        [ValidateSet("Text","Integer","Decimal","DateTime","YesNo","Double","Binary")]
        [System.String]
        $Type,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $Searchable,

        [Parameter()]
        [System.String]
        $FullTextIndex,

        [Parameter()]
        [System.Boolean]
        $Queryable,

        [Parameter()]
        [System.Boolean]
        $Retrievable,

        [Parameter()]
        [System.Boolean]
        $AllowMultipleValues,

        [Parameter()]
        [ValidateSet("No", "Yes - latent", "Yes")] 
        [System.String]
        $Refinable,

        [Parameter()]
        [ValidateSet("No", "Yes - latent", "Yes")] 
        [System.String]
        $Sortable,

        [Parameter()]
        [System.Boolean]
        $Safe,

        [Parameter()]
        [System.String[]]
        $Aliases,

        [Parameter()]
        [System.Boolean]
        $TokenNormalization,

        [Parameter()]
        [System.Boolean]
        $CompleteMatching,

        [Parameter()]
        [System.Boolean]
        $LanguageNeutralTokenization,

        [Parameter()]
        [System.Boolean]
        $FinerQueryTokenization,

        [Parameter()]
        [System.Boolean]
        $CompanyNameExtraction,

        [Parameter()] 
        [ValidateSet("Present","Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-PnPOnlineConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $nullReturn = @{
        Name = $Name
        Type = $null
        Description = $null
        Searchable = $null
        FullTextIndex = $null
        Queryable = $null
        Retrievable = $null
        AllowMultipleValues = $null
        Refinable = $null
        Sortable = $null
        Safe = $null
        Aliases = $null
        TokenNormalization = $null
        CompleteMatching = $null
        LanguageNeutralTokenization = $null
        FinerQueryTokenization = $null
        CompanyNameExtraction = $null
        Ensure = "Absent"
        CentralAdminUrl = $CentralAdminUrl
    }

    $SearchConfig = [Xml] (Get-PnPSearchConfiguration -Scope Subscription)
    $property =  $SearchConfig.SearchConfigurationSettings.SearchSchemaConfigurationSettings.ManagedProperties.dictionary.KeyValueOfstringManagedPropertyInfoy6h3NzC8 `
                    | Where-Object { $_.Value.Name -eq $Name }

    if ($null -eq $property)
    {
        Write-Verbose "The specified Managed Property {$($Name)} doesn't already exist."
        return $nullReturn
    }

    $CompanyNameExtraction = $false
    if ($property.Value.EntityExtractorBitMap -eq "4161")
    {
        $CompanyNameExtraction = $true
    }

    return @{
        Name = [string] $property.Value.Name
        Type = [string] $property.Value.ManagedType
        Description = [string] $property.Value.Description
        Searchable = [boolean] $property.Value.Searchable
        FullTextIndex = [string] $property.Value.FullTextIndex
        Queryable = [boolean] $property.Value.Queryable
        Retrievable = [boolean] $property.Value.Retrievable
        AllowMultipleValues = [boolean] $property.Value.HasMultipleValues
        Refinable = [boolean] $property.Value.Refinable
        Sortable = [boolean] $property.Value.Sortable
        Safe = [boolean] $property.Value.SafeForAnonymous
        Aliases = [boolean] $property.Value.Aliases
        TokenNormalization = [boolean] $property.Value.TokenNormalization
        CompleteMatching = [boolean] $property.Value.CompleteMatching
        LanguageNeutralTokenization = [boolean] $property.Value.LanguageNeutralTokenization
        FinerQueryTokenization = [boolean] $property.Value.ExpandSegments
        CompanyNameExtraction = $CompanyNameExtraction
        CentralAdminUrl = $CentralAdminUrl
        Ensure = "Present"
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
        [ValidateSet("Text","Integer","Decimal","DateTime","YesNo","Double","Binary")]
        [System.String]
        $Type,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $Searchable,

        [Parameter()]
        [System.String]
        $FullTextIndex,

        [Parameter()]
        [System.Boolean]
        $Queryable,

        [Parameter()]
        [System.Boolean]
        $Retrievable,

        [Parameter()]
        [System.Boolean]
        $AllowMultipleValues,

        [Parameter()]
        [ValidateSet("No", "Yes - latent", "Yes")] 
        [System.String]
        $Refinable,

        [Parameter()]
        [ValidateSet("No", "Yes - latent", "Yes")] 
        [System.String]
        $Sortable,

        [Parameter()]
        [System.Boolean]
        $Safe,

        [Parameter()]
        [System.String[]]
        $Aliases,

        [Parameter()]
        [System.Boolean]
        $TokenNormalization,

        [Parameter()]
        [System.Boolean]
        $CompleteMatching,

        [Parameter()]
        [System.Boolean]
        $LanguageNeutralTokenization,

        [Parameter()]
        [System.Boolean]
        $FinerQueryTokenization,

        [Parameter()]
        [System.Boolean]
        $CompanyNameExtraction,

        [Parameter()] 
        [ValidateSet("Present","Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    if($Ensure -eq "Present")
    {
        $deletedSite = Get-SPODeletedSite | Where-Object { $_.Url -eq $Url }

        if($deletedSite)
        {
            Write-Verbose "A site with URL $($URL) was found in the Recycle Bin."
            Write-Verbose "Restoring Delete SPOSite $($Url)"
            Restore-SPODeletedSite $deletedSite
        }
        else {
            Write-Verbose -Message "Setting site collection $Url"
            $CurrentParameters = $PSBoundParameters
            $CurrentParameters.Remove("CentralAdminUrl")
            $CurrentParameters.Remove("GlobalAdminAccount")
            $CurrentParameters.Remove("Ensure")
            New-SPOSite @CurrentParameters
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
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Text","Integer","Decimal","DateTime","YesNo","Double","Binary")]
        [System.String]
        $Type,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $Searchable,

        [Parameter()]
        [System.String]
        $FullTextIndex,

        [Parameter()]
        [System.Boolean]
        $Queryable,

        [Parameter()]
        [System.Boolean]
        $Retrievable,

        [Parameter()]
        [System.Boolean]
        $AllowMultipleValues,

        [Parameter()]
        [ValidateSet("No", "Yes - latent", "Yes")] 
        [System.String]
        $Refinable,

        [Parameter()]
        [ValidateSet("No", "Yes - latent", "Yes")] 
        [System.String]
        $Sortable,

        [Parameter()]
        [System.Boolean]
        $Safe,

        [Parameter()]
        [System.String[]]
        $Aliases,

        [Parameter()]
        [System.Boolean]
        $TokenNormalization,

        [Parameter()]
        [System.Boolean]
        $CompleteMatching,

        [Parameter()]
        [System.Boolean]
        $LanguageNeutralTokenization,

        [Parameter()]
        [System.Boolean]
        $FinerQueryTokenization,

        [Parameter()]
        [System.Boolean]
        $CompanyNameExtraction,

        [Parameter()] 
        [ValidateSet("Present","Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                           -DesiredValues $PSBoundParameters `
                                           -ValuesToCheck @("Ensure", `
                                                            "Name")
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
        [ValidateSet("Text","Integer","Decimal","DateTime","YesNo","Double","Binary")]
        [System.String]
        $Type,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        SPOSearchManagedProperty " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
