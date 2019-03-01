
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
        $Type = "SharePoint",

        [Parameter()]
        [System.String]
        $QueryTransform,

        [Parameter()]
        [System.Boolean]
        $ShowPartialSearch = $true,

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

    if ($null -eq $Script:RecentExtract)
    {
        $Script:RecentExtract = [Xml] (Get-PnPSearchConfiguration -Scope Subscription)
    }
    $source =  $Script:RecentExtract.SearchConfigurationSettings.SearchQueryConfigurationSettings.SearchQueryConfigurationSettings.Sources.Source `
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
        Ensure              = "Present"
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
        $Type = "SharePoint",

        [Parameter()]
        [System.String]
        $QueryTransform,

        [Parameter()]
        [System.Boolean]
        $ShowPartialSearch = $true,

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
    Write-Verbose "Reading SearchConfigurationSettings XML file"
    $SearchConfigTemplatePath =  Join-Path -Path $PSScriptRoot `
                                           -ChildPath "..\..\Dependencies\SearchConfigurationSettings.xml" `
                                           -Resolve
    $SearchConfigXML = [Xml] (Get-Content $SearchConfigTemplatePath -Raw)

    # Get the result source back if it already exists.
    if ($null -eq $Script:RecentExtract)
    {
        $Script:RecentExtract = [XML] (Get-PnpSearchConfiguration -Scope Subscription)
    }

    $source =  $Script:RecentExtract.SearchConfigurationSettings.SearchQueryConfigurationSettings.SearchQueryConfigurationSettings.Sources.Source `
                    | Where-Object { $_.Name -eq $Name }
    if ($null -ne $source)
    {
        $currentID = $source.Id
    }

    Write-Verbose "Generating new SearchConfigurationSettings XML file"
    $newSource = $SearchConfigXML.CreateElement("d4p1:Source", `
                                                "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration.Query")

    Write-Verbose "Setting ConnectionUrlTemplate"
    $node = $SearchConfigXML.CreateElement("d4p1:ConnectionUrlTemplate", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration.Query")
    $node.InnerText = $SourceUrl
    $newSource.AppendChild($node) | Out-Null

    Write-Verbose "Setting CreatedDate"
    $node = $SearchConfigXML.CreateElement("d4p1:CreatedDate", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration.Query")
    $node.InnerText = [DateTime]::Now.ToString("yyyy-MM-ddThh:mm:ss.00")
    $newSource.AppendChild($node) | Out-Null

    Write-Verbose "Setting Description"
    $node = $SearchConfigXML.CreateElement("d4p1:Description", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration.Query")
    $node.InnerText = $Description
    $newSource.AppendChild($node) | Out-Null

    Write-Verbose "Setting Existing Id"
    $node = $SearchConfigXML.CreateElement("d4p1:Id", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration.Query")

    if ($null -ne $currentID)
    {
        $node.InnerText = $currentId
    }
    else
    {
        $node.InnerText = (New-Guid).ToString()
    }
    $newSource.AppendChild($node) | Out-Null

    Write-Verbose "Setting Name"
    $node = $SearchConfigXML.CreateElement("d4p1:Name", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration.Query")
    $node.InnerText = $Name
    $newSource.AppendChild($node) | Out-Null

    Write-Verbose "Setting ProviderId"
    $mapping = $InfoMapping | Where-Object {$_.Protocol -eq $Protocol -and $_.Type -eq $Type}
    $node = $SearchConfigXML.CreateElement("d4p1:ProviderId", `
                                           "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration.Query")
    $node.InnerText = $mapping.ProviderID
    $catch = $newSource.AppendChild($node)

    Write-Verbose "Setting QueryTransform"
    $queryTransformNode = $SearchConfigXML.CreateElement("d4p1:QueryTransform", `
                                                         "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration.Query")
    $queryTransformNode.SetAttribute("xmlns:d6p1", "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")

    Write-Verbose "Setting QueryTransform:Id"
    $node = $SearchConfigXML.CreateElement("d6p1:Id", `
                                           "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")
    $node.InnerText = (New-Guid).ToString()
    $queryTransformNode.AppendChild($node)

    Write-Verbose "Setting QueryTransform:ParentType"
    $queryTransformNode = $SearchConfigXML.CreateElement("d6p1:ParentType", `
                                                         "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")
    $node.InnerText = "Source"
    $queryTransformNode.AppendChild($node)

    Write-Verbose "Setting QueryTransform:QueryPropertyExpressions"
    $QueryPropertyExpressions = $SearchConfigXML.CreateElement("d6p1:QueryPropertyExpressions", `
                                           "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")

    Write-Verbose "Setting QueryTransform:QueryPropertyExpressions:MaxSize"
    $node = $SearchConfigXML.CreateElement("d6p1:MaxSize", `
                                           "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")
    $node.InnerText = "2147483647"
    $QueryPropertyExpressions.AppendChild($node)

    Write-Verbose "Setting QueryTransform:QueryPropertyExpressions:OrderedItems"
    $node = $SearchConfigXML.CreateElement("d6p1:OrderedItems", `
                                           "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")
    $QueryPropertyExpressions.AppendChild($node)

    $queryTransformNode.AppendChild($QueryPropertyExpressions)

    Write-Verbose "Setting QueryTransform:_IsReadOnly"
    $node = $SearchConfigXML.CreateElement("d6p1:_IsReadOnly", `
                                           "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")
    $node.InnerText = "true"
    $queryTransformNode.AppendChild($node)

    Write-Verbose "Setting QueryTransform:_QueryTemplate"
    $node = $SearchConfigXML.CreateElement("d6p1:_QueryTemplate", `
                                           "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")
    $node.InnerText = $QueryTransform
    $queryTransformNode.AppendChild($node) | Out-Null

    Write-Verbose "Setting QueryTransform:_SourceId"
    $node = $SearchConfigXML.CreateElement("d6p1:_SourceId", `
                                           "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")
    $node.SetAttribute("i:nil", "true")
    $queryTransformNode.AppendChild($node)

    Write-Verbose "Inserting QueryTransform"
    $newSource.AppendChild($queryTransformNode) | Out-Null

    Write-Verbose "Inserting new Source Node"
    $xmlNode = $SearchConfigXML.SearchConfigurationSettings.SearchQueryConfigurationSettings.SearchQueryConfigurationSettings.Sources.OwnerDocument.ImportNode($newSource, $true)
    $SearchConfigXML.SearchConfigurationSettings.SearchQueryConfigurationSettings.SearchQueryConfigurationSettings.Sources.AppendChild($xmlNode)

    Write-Verbose "Saving XML file in a temporary location"
    $tempPath = Join-Path -Path $ENV:TEMP `
                           -ChildPath ((New-Guid).ToString().Split('-')[0] + ".config")
    $SearchConfigXML.OuterXml | Out-File $tempPath

    # Create the Result Source if it doesn't already exist
    Write-Verbose "Applying new Search Configuration back to the Office365 Tenant"
    Set-PnPSearchConfiguration -Scope Subscription -Path $tempPath
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
        $Type = "SharePoint",

        [Parameter()]
        [System.String]
        $QueryTransform,

        [Parameter()]
        [System.Boolean]
        $ShowPartialSearch = $true,

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
