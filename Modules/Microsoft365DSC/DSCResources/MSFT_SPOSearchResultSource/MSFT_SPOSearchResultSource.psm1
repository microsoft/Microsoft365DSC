
$InfoMapping = @(
    @{
        Protocol   = "Local"
        Type       = "SharePoint"
        ProviderID = "fa947043-6046-4f97-9714-40d4c113963d"
    },
    @{
        Protocol   = "Remote"
        Type       = "SharePoint"
        ProviderID = "1e0c8601-2e5d-4ccb-9561-53743b5dbde7"
    },
    @{
        Protocol   = "Exchange"
        Type       = "SharePoint"
        ProviderID = "3a17e140-1574-4093-bad6-e19cdf1c0122"
    },
    @{
        Protocol   = "OpenSearch"
        Type       = "SharePoint"
        ProviderID = "3a17e140-1574-4093-bad6-e19cdf1c0121"
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
        [ValidateSet("Local", "Remote", "OpenSearch", "Exchange")]
        [System.String]
        $Protocol,

        [Parameter()]
        [System.String]
        $SourceURL,

        [Parameter()]
        [ValidateSet("SharePoint", "People")]
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
        [ValidateSet("Present")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for Result Source instance $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $nullReturn = @{
        Name               = $Name
        Description        = $null
        Protocol           = $null
        Type               = $null
        QueryTransform     = $null
        SourceURL          = $null
        UseAutoDiscover    = $null
        ShowPartialSearch  = $null
        GlobalAdminAccount = $GlobalAdminAccount
        Ensure             = "Absent"
    }

    if ($null -eq $Script:RecentExtract)
    {
        $Script:RecentExtract = [Xml] (Get-PnPSearchConfiguration -Scope Subscription)
    }
    $source = $Script:RecentExtract.SearchConfigurationSettings.SearchQueryConfigurationSettings.SearchQueryConfigurationSettings.Sources.Source `
    | Where-Object -FilterScript { $_.Name -eq $Name }

    if ($null -eq $source)
    {
        Write-Verbose -Message "The specified Result Source {$($Name)} doesn't already exist."
        return $nullReturn
    }

    $ExoSource = [string] $source.ConnectionUrlTemplate
    $SourceHasAutoDiscover = $false
    if ("http://auto?autodiscover=true" -eq $ExoSource)
    {
        $SourceHasAutoDiscover = $true
    }

    $allowPartial = $source.QueryTransform.OverridePropertiesForSeralization.KeyValueOfstringanyType `
    | Where-Object -FilterScript { $_.Key -eq "AllowPartialResults" }

    $mapping = $InfoMapping | Where-Object -FilterScript { $_.ProviderID -eq $source.ProviderId }

    $returnValue = @{
        Name               = $Name
        Description        = [string] $source.Description
        Protocol           = $mapping.Protocol
        Type               = $mapping.Type
        QueryTransform     = [string] $source.QueryTransform._QueryTemplate
        SourceURL          = [string] $source.ConnectionUrlTemplate
        UseAutoDiscover    = $SourceHasAutoDiscover
        GlobalAdminAccount = $GlobalAdminAccount
        Ensure             = "Present"
    }

    if ($null -ne $allowPartial)
    {
        $returnValue.Add("ShowPartialSearch", [System.Boolean]$allowPartial.Value.InnerText)
    }

    return $returnValue
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
        [ValidateSet("Local", "Remote", "OpenSearch", "Exchange")]
        [System.String]
        $Protocol,

        [Parameter()]
        [System.String]
        $SourceURL,

        [Parameter()]
        [ValidateSet("SharePoint", "People")]
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
        [ValidateSet("Present")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for Result Source instance $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    Write-Verbose -Message "Reading SearchConfigurationSettings XML file"
    $SearchConfigTemplatePath = Join-Path -Path $PSScriptRoot `
        -ChildPath "..\..\Dependencies\SearchConfigurationSettings.xml" `
        -Resolve
    $SearchConfigXML = [Xml] (Get-Content $SearchConfigTemplatePath -Raw)

    # Get the result source back if it already exists.
    if ($null -eq $Script:RecentExtract)
    {
        $Script:RecentExtract = [XML] (Get-PnpSearchConfiguration -Scope Subscription)
    }

    $source = $Script:RecentExtract.SearchConfigurationSettings.SearchQueryConfigurationSettings.SearchQueryConfigurationSettings.Sources.Source `
    | Where-Object -FilterScript { $_.Name -eq $Name }
    if ($null -ne $source)
    {
        $currentID = $source.Id
    }

    Write-Verbose -Message "Generating new SearchConfigurationSettings XML file"
    $newSource = $SearchConfigXML.CreateElement("d4p1:Source", `
            "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration.Query")

    Write-Verbose -Message "Setting ConnectionUrlTemplate"
    $node = $SearchConfigXML.CreateElement("d4p1:ConnectionUrlTemplate", `
            "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration.Query")
    $node.InnerText = $SourceUrl
    $newSource.AppendChild($node) | Out-Null

    Write-Verbose -Message "Setting CreatedDate"
    $node = $SearchConfigXML.CreateElement("d4p1:CreatedDate", `
            "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration.Query")
    $node.InnerText = [DateTime]::Now.ToString("yyyy-MM-ddThh:mm:ss.00")
    $newSource.AppendChild($node) | Out-Null

    Write-Verbose -Message "Setting Description"
    $node = $SearchConfigXML.CreateElement("d4p1:Description", `
            "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration.Query")
    $node.InnerText = $Description
    $newSource.AppendChild($node) | Out-Null

    Write-Verbose -Message "Setting Existing Id"
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

    Write-Verbose -Message "Setting Name"
    $node = $SearchConfigXML.CreateElement("d4p1:Name", `
            "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration.Query")
    $node.InnerText = $Name
    $newSource.AppendChild($node) | Out-Null

    Write-Verbose -Message "Setting ProviderId"
    $mapping = $InfoMapping | Where-Object -FilterScript { $_.Protocol -eq $Protocol -and $_.Type -eq $Type }
    $node = $SearchConfigXML.CreateElement("d4p1:ProviderId", `
            "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration.Query")
    $node.InnerText = $mapping.ProviderID
    $catch = $newSource.AppendChild($node)

    Write-Verbose -Message "Setting QueryTransform"
    $queryTransformNode = $SearchConfigXML.CreateElement("d4p1:QueryTransform", `
            "http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration.Query")
    $queryTransformNode.SetAttribute("xmlns:d6p1", "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")

    Write-Verbose -Message "Setting QueryTransform:Id"
    $node = $SearchConfigXML.CreateElement("d6p1:Id", `
            "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")
    $node.InnerText = (New-Guid).ToString()
    $queryTransformNode.AppendChild($node)

    Write-Verbose -Message "Setting QueryTransform:ParentType"
    $queryTransformNode = $SearchConfigXML.CreateElement("d6p1:ParentType", `
            "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")
    $node.InnerText = "Source"
    $queryTransformNode.AppendChild($node)

    Write-Verbose -Message "Setting QueryTransform:QueryPropertyExpressions"
    $QueryPropertyExpressions = $SearchConfigXML.CreateElement("d6p1:QueryPropertyExpressions", `
            "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")

    Write-Verbose -Message "Setting QueryTransform:QueryPropertyExpressions:MaxSize"
    $node = $SearchConfigXML.CreateElement("d6p1:MaxSize", `
            "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")
    $node.InnerText = "2147483647"
    $QueryPropertyExpressions.AppendChild($node)

    Write-Verbose -Message "Setting QueryTransform:QueryPropertyExpressions:OrderedItems"
    $node = $SearchConfigXML.CreateElement("d6p1:OrderedItems", `
            "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")
    $QueryPropertyExpressions.AppendChild($node)

    $queryTransformNode.AppendChild($QueryPropertyExpressions)

    Write-Verbose -Message "Setting QueryTransform:_IsReadOnly"
    $node = $SearchConfigXML.CreateElement("d6p1:_IsReadOnly", `
            "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")
    $node.InnerText = "true"
    $queryTransformNode.AppendChild($node)

    Write-Verbose -Message "Setting QueryTransform:_QueryTemplate"
    $node = $SearchConfigXML.CreateElement("d6p1:_QueryTemplate", `
            "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")
    $node.InnerText = $QueryTransform
    $queryTransformNode.AppendChild($node) | Out-Null

    Write-Verbose -Message "Setting QueryTransform:_SourceId"
    $node = $SearchConfigXML.CreateElement("d6p1:_SourceId", `
            "http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08")
    $node.SetAttribute("i:nil", "true")
    $queryTransformNode.AppendChild($node)

    Write-Verbose -Message "Inserting QueryTransform"
    $newSource.AppendChild($queryTransformNode) | Out-Null

    Write-Verbose -Message "Inserting new Source Node"
    $xmlNode = $SearchConfigXML.SearchConfigurationSettings.SearchQueryConfigurationSettings.SearchQueryConfigurationSettings.Sources.OwnerDocument.ImportNode($newSource, $true)
    $SearchConfigXML.SearchConfigurationSettings.SearchQueryConfigurationSettings.SearchQueryConfigurationSettings.Sources.AppendChild($xmlNode)

    Write-Verbose -Message "Saving XML file in a temporary location"
    $tempPath = Join-Path -Path $ENV:TEMP `
        -ChildPath ((New-Guid).ToString().Split('-')[0] + ".config")
    $SearchConfigXML.OuterXml | Out-File $tempPath

    # Create the Result Source if it doesn't already exist
    Write-Verbose -Message "Applying new Search Configuration back to the Office365 Tenant"
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
        [ValidateSet("Local", "Remote", "OpenSearch", "Exchange")]
        [System.String]
        $Protocol,

        [Parameter()]
        [System.String]
        $SourceURL,

        [Parameter()]
        [ValidateSet("SharePoint", "People")]
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
        [ValidateSet("Present")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for Result Source instance $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters

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
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP
    $SearchConfig = [Xml] (Get-PnPSearchConfiguration -Scope Subscription)
    $sources = $SearchConfig.SearchConfigurationSettings.SearchQueryConfigurationSettings.SearchQueryConfigurationSettings.Sources.Source

    $content = ''
    $i = 1
    $sourcesLength = $sources.Length
    if ($null -eq $sourcesLength)
    {
        $sourcesLength = 1
    }
    foreach ($source in $sources)
    {
        $mapping = $InfoMapping | Where-Object -FilterScript { $_.ProviderID -eq $source.ProviderId }
        Write-Information "    [$i/$($sourcesLength)] $($source.Name)"

        $params = @{
            Name               = $source.Name
            Protocol           = $mapping.Protocol
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        if ($null -eq $result.ShowPartialSearch)
        {
            $result.Remove("ShowPartialSearch")
        }
        $content += "        SPOSearchResultSource " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
