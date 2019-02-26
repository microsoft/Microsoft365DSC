
$InfoMapping = @(
    @{
        Protocol    = "Local"
        Type        = "SharePoint"
        ProviderID  = "fa947043-6046-4f97-9714-40d4c113963d"
    },
    @{
        Protocol    = "Remote"
        Type        = "SharePoint"
        ProviderID  = "1e0c8601-2e5d-4ccb-9561-53743b5dbde7"
    },
    @{
        Protocol    = "Exchange"
        Type        = "SharePoint"
        ProviderID  = "3a17e140-1574-4093-bad6-e19cdf1c0122"
    },
    @{
        Protocol    = "OpenSearch"
        Type        = "SharePoint"
        ProviderID  = "3a17e140-1574-4093-bad6-e19cdf1c0121"
    },
    @{
        Protocol   = "Local"
        Type       = "People"
        ProviderID = "e4bcc058-f133-4425-8ffc-1d70596ffd33"
    },
    @{
        Protocol   = "Remote"
        Type       = "People"
        ProviderID = "e377caaa-fcaf-4a1b-b7a1-e69a506a07aa"
    }
)
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
        $Description,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Local","Remote","OpenSearch","Exchange")]
        [System.String]
        $Protocol,

        [Parameter()]
        [System.String]
        $SourceURL,

        [Parameter()]
        [ValidateSet("SharePoint","People", "Basic")]
        [System.String]
        $Type,

        [Parameter()]
        [System.String]
        $QueryTransform,

        [Parameter()]
        [System.Boolean]
        $ShowPartialSearch,

        [Parameter()]
        [System.Boolean]
        $UseAutoDiscover,

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

    if ($Ensure -eq "Absent")
    {
        throw "This resource cannot delete Result Sources. Please make sure you set its Ensure value to Present."
    }

    Test-PnPOnlineConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $nullReturn = @{
        Name                = $Name
        Description         = $null
        Protocol            = $null
        Type                = $null
        QueryTransform      = $null
        SourceURL           = $null
        UseAutoDiscover     = $null
        ShowPartialSearch   = $null
        GlobalAdminAccount  = $GlobalAdminAccount
        Ensure              = "Absent"
        CentralAdminUrl     = $CentralAdminUrl
    }

    if ($null -eq $Script:RecentMPExtract)
    {
        $Script:RecentMPExtract = [Xml] (Get-PnPSearchConfiguration -Scope Subscription)
    }
    $source =  $Script:RecentMPExtract.SearchConfigurationSettings.SearchQueryConfigurationSettings.SearchQueryConfigurationSettings.Sources.Source `
                    | Where-Object { $_.Name -eq $Name }

    if ($null -eq $source)
    {
        Write-Verbose "The specified Result Source {$($Name)} doesn't already exist."
        return $nullReturn
    }

    $ExoSource = [string] $source.ConnectionUrlTemplate
    $SourceHasAutoDiscover = $false
    if ("http://auto?autodiscover=true" -eq $ExoSource)
    {
        $SourceHasAutoDiscover = $true
    }

    $allowPartial =  $source.QueryTransform.OverridePropertiesForSeralization.KeyValueOfstringanyType `
                    | Where-Object { $_.Key -eq "AllowPartialResults" }

    $mapping = $InfoMapping | Where-Object {$_.ProviderID -eq $source.ProviderId}

    return @{
        Name                = $Name
        Description         = [string] $source.Description
        Protocol            = $mapping.Protocol
        Type                = $mapping.Type
        QueryTransform      = [string] $source.QueryTransform._QueryTemplate
        SourceURL           = [string] $source.ConnectionUrlTemplate
        UseAutoDiscover     = $SourceHasAutoDiscover
        ShowPartialSearch   = $allowPartial.Value
        GlobalAdminAccount  = $GlobalAdminAccount
        Ensure              = "Absent"
        CentralAdminUrl     = $CentralAdminUrl
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
        $Description,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Local","Remote","OpenSearch","Exchange")]
        [System.String]
        $Protocol,

        [Parameter()]
        [System.String]
        $SourceURL,

        [Parameter()]
        [ValidateSet("SharePoint","People")]
        [System.String]
        $Type,

        [Parameter()]
        [System.String]
        $QueryTransform,

        [Parameter()]
        [System.Boolean]
        $ShowPartialSearch,

        [Parameter()]
        [System.Boolean]
        $UseAutoDiscover,

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

    if ($Ensure -eq "Absent")
    {
        throw "This resource cannot delete Managed Properties. Please make sure you set its Ensure value to Present."
    }

    Test-PnPOnlineConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    $SearchConfigTemplatePath =  Join-Path -Path $PSScriptRoot `
                                           -ChildPath "..\..\Dependencies\SearchConfigurationSettings.xml" `
                                           -Resolve
    $SearchConfigXML = [Xml] (Get-Content $SearchConfigTemplatePath -Raw)

    # Get the managed property back if it already exists.
    if ($null -eq $Script:RecentMPExtract)
    {
        $Script:RecentMPExtract = [XML] (Get-PnpSearchConfiguration -Scope Subscription)
    }

    $property =  $Script:RecentMPExtract.SearchConfigurationSettings.SearchSchemaConfigurationSettings.ManagedProperties.dictionary.KeyValueOfstringManagedPropertyInfoy6h3NzC8 `
                    | Where-Object { $_.Value.Name -eq $Name }
    if ($null -ne $property)
    {
        $currentPID = $property.Value.Pid
    }

    $prop = $SearchConfigXml.ChildNodes[0].SearchSchemaConfigurationSettings.ManagedProperties.dictionary
    $newManagedPropertyElement = $SearchConfigXML.CreateElement("d4p1:KeyValueOfstringManagedPropertyInfoy6h3NzC8", `
                                                                "http://schemas.microsoft.com/2003/10/Serialization/Arrays")
    $keyNode = $SearchConfigXML.CreateElement("d4p1:Key", `
                                              "http://schemas.microsoft.com/2003/10/Serialization/Arrays")
    $keyNode.InnerText = $Name
    $catch = $newManagedPropertyElement.AppendChild($keyNode)

    $valueNode = $SearchConfigXML.CreateElement("d4p1:Value", `
                                              "http://schemas.microsoft.com/2003/10/Serialization/Arrays")

    $node = $SearchConfigXML.CreateElement("d3p1:Name", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $Name
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:CompleteMatching", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $CompleteMatching.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:Context", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $FullTextContext.ToString()
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:DeleteDisallowed", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "false"
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:Description", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")

    $node.InnerText = $Description
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:EnabledForScoping", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "false"
    $catch = $valueNode.AppendChild($node)

    #region EntiryExtractionBitMap
    $node = $SearchConfigXML.CreateElement("d3p1:EntityExtractorBitMap", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")

    if ($CompanyNameExtraction)
    {
        $node.InnerText = "4161"
    }
    else
    {
        $node.InnerText = "0"
    }
    $catch = $valueNode.AppendChild($node)
    #endregion

    $node = $SearchConfigXML.CreateElement("d3p1:ExpandSegments", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $FinerQueryTokenization.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:FullTextIndex", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $FullTextIndex
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:HasMultipleValues", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $AllowMultipleValues.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:IndexOptions", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "0"
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:IsImplicit", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "false"
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:IsReadOnly", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "false"
    $catch = $valueNode.AppendChild($node)

    #region LanguageNeutralWordBreaker
    if ($LanguageNeutralTokenization -and $CompleteMatching)
    {
        throw "You cannot have CompleteMatching set to True if LanguageNeutralTokenization is set to True"
    }
    $node = $SearchConfigXML.CreateElement("d3p1:LanguageNeutralWordBreaker", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $LanguageNeutralTokenization.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)
    #endregion

    $node = $SearchConfigXML.CreateElement("d3p1:ManagedType", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $Type
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:MappingDisallowed", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "false"
    $catch = $valueNode.AppendChild($node)

    #region PID
    if ($null -ne $currentPID)
    {
        $node = $SearchConfigXML.CreateElement("d3p1:Pid", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
        $node.InnerText = $currentPid
        $catch = $valueNode.AppendChild($node)
    }
    #endregion

    $node = $SearchConfigXML.CreateElement("d3p1:Queryable", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $Queryable.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)

    #region Refinable
    $value = $false
    if ($Refinable -eq "Yes")
    {
        $value = $true
    }
    $node = $SearchConfigXML.CreateElement("d3p1:Refinable", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $value.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:RefinerConfiguration", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")

    $subNode = $SearchConfigXML.CreateElement("d3p1:Anchoring", `
                                              "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $subNode.InnerText = "Auto"
    $catch = $node.AppendChild($subNode)

    $subNode = $SearchConfigXML.CreateElement("d3p1:CutoffMaxBuckets", `
                                              "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $subNode.InnerText = "1000"
    $catch = $catch = $node.AppendChild($subNode)

    $subNode = $SearchConfigXML.CreateElement("d3p1:Divisor", `
                                              "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $subNode.InnerText = "1"
    $catch = $node.AppendChild($subNode)

    $subNode = $SearchConfigXML.CreateElement("d3p1:Intervals", `
                                              "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $subNode.InnerText = "4"
    $catch = $node.AppendChild($subNode)

    $subNode = $SearchConfigXML.CreateElement("d3p1:Resolution", `
                                              "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $subNode.InnerText = "1"
    $catch = $node.AppendChild($subNode)

    $subNode = $SearchConfigXML.CreateElement("d3p1:Type", `
                                              "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $subNode.InnerText = "Deep"
    $catch = $node.AppendChild($subNode)

    $catch = $valueNode.AppendChild($node)
    #endregion

    $node = $SearchConfigXML.CreateElement("d3p1:RemoveDuplicates", `
                                              "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "true"
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:RespectPriority", `
                                              "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "false"
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:Retrievable", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $Retrievable.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:SafeForAnonymous", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $Safe.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:Searchable", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $Searchable.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)

    #region Sortable
    $value = $false
    if ($Sortable -eq "Yes")
    {
        $value = $true
    }
    $node = $SearchConfigXML.CreateElement("d3p1:Sortable", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $value.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)
    #endregion

    $node = $SearchConfigXML.CreateElement("d3p1:SortableType", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = "Enabled"
    $catch = $valueNode.AppendChild($node)

    $node = $SearchConfigXML.CreateElement("d3p1:TokenNormalization", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
    $node.InnerText = $TokenNormalization.ToString().Replace("$", "").ToLower()
    $catch = $valueNode.AppendChild($node)

    $newManagedPropertyElement.AppendChild($valueNode)
    $catch = $prop.AppendChild($newManagedPropertyElement)

    $tempPath = Join-Path -Path $ENV:TEMP `
                           -ChildPath ((New-Guid).ToString().Split('-')[0] + ".config")
    $SearchConfigXML.OuterXml | Out-File $tempPath

    # Create the Managed Property if it doesn't already exist
    Set-PnPSearchConfiguration -Scope Subscription -Path $tempPath

    #region Aliases
    if ($null -ne $Aliases)
    {
        $aliasesArray = $Aliases.Split(';')
        $aliasProp = $SearchConfigXml.ChildNodes[0].SearchSchemaConfigurationSettings.Aliases.dictionary

        if ($null -eq $currentPID)
        {
            # Get the managed property back. This is the only way to ensure we have the right PID
            $currentConfigXML = [XML] (Get-PnpSearchCOnfiguration -Scope Subscription)
            $property =  $currentConfigXML.SearchConfigurationSettings.SearchSchemaConfigurationSettings.ManagedProperties.dictionary.KeyValueOfstringManagedPropertyInfoy6h3NzC8 `
                            | Where-Object { $_.Value.Name -eq $Name }
            $currentPID = $property.Value.Pid

            $node = $SearchConfigXML.CreateElement("d3p1:Pid", `
                                                   "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
            $node.InnerText = $currentPID

            # The order in which we list the properties matters. Pid is to appear right after MappingDisallowed.
            $namespaceMgr = New-Object System.Xml.XmlNamespaceManager($SearchConfigXML.NameTable);
            $namespaceMgr.AddNamespace("d3p1", "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
            $previousNode = $SearchConfigXML.SelectSingleNode("//d3p1:MappingDisallowed", $namespaceMgr)
            $catch = $previousNode.ParentNode.InsertAfter($node, $previousNode)
        }

        foreach ($alias in $aliasesArray)
        {
            $mainNode = $SearchConfigXML.CreateElement("d4p1:KeyValueOfstringAliasInfoy6h3NzC8", `
                                                   "http://schemas.microsoft.com/2003/10/Serialization/Arrays")
            $keyNode = $SearchConfigXML.CreateElement("d4p1:Key", `
                                                      "http://schemas.microsoft.com/2003/10/Serialization/Arrays")
            $keyNode.InnerText = $alias

            $valueNode = $SearchConfigXML.CreateElement("d4p1:Value", `
                                                      "http://schemas.microsoft.com/2003/10/Serialization/Arrays")
            $node = $SearchConfigXML.CreateElement("d3p1:Name", `
                                                   "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
            $node.InnerText = $alias
            $catch = $valueNode.AppendChild($node)

            $node = $SearchConfigXML.CreateElement("d3p1:ManagedPid", `
                                                   "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
            $node.InnerText = $currentPID
            $catch = $valueNode.AppendChild($node)

            $node = $SearchConfigXML.CreateElement("d3p1:SchemaId", `
                                                   "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration")
            $node.InnerText = "6408"
            $catch = $valueNode.AppendChild($node)

            $catch = $mainNode.AppendChild($keyNode)
            $catch = $catch = $mainNode.AppendChild($valueNode)
            $aliasProp.AppendChild($mainNode)
        }

        $tempPath = Join-Path -Path $ENV:TEMP `
                              -ChildPath ((New-Guid).ToString().Split('-')[0] + ".config")
        Write-Verbose "Configuring SPO Search Schema with the following XML Document"
        Write-Verbose $SearchConfigXML.OuterXML
        $SearchConfigXML.OuterXml | Out-File $tempPath

        # Create the aliases on the Managed Property
        Set-PnPSearchConfiguration -Scope Subscription -Path $tempPath
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
        $Description,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Local","Remote","OpenSearch","Exchange")]
        [System.String]
        $Protocol,

        [Parameter()]
        [System.String]
        $SourceURL,

        [Parameter()]
        [ValidateSet("SharePoint","People")]
        [System.String]
        $Type,

        [Parameter()]
        [System.String]
        $QueryTransform,

        [Parameter()]
        [System.Boolean]
        $ShowPartialSearch,

        [Parameter()]
        [System.Boolean]
        $UseAutoDiscover,

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
                                                            "Name",
                                                            "Type")
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
        [ValidateSet("Local","Remote","OpenSearch","Exchange")]
        [System.String]
        $Protocol,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    if ($null -eq $result.ShowPartialSearch)
    {
        $result.Remove("ShowPartialSearch")
    }
    $content = "        SPOSearchResultSource " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
