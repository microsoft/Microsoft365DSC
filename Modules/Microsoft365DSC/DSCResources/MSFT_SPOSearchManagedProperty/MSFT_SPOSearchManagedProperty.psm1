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
        [ValidateSet('Text', 'Integer', 'Decimal', 'DateTime', 'YesNo', 'Double', 'Binary')]
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
        [System.UInt32]
        $FullTextContext,

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
        [ValidateSet('No', 'Yes - latent', 'Yes')]
        [System.String]
        $Refinable,

        [Parameter()]
        [ValidateSet('No', 'Yes - latent', 'Yes')]
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
        [System.String[]]
        $MappedCrawledProperties,

        [Parameter()]
        [System.Boolean]
        $CompanyNameExtraction,

        [Parameter()]
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration for Managed Property instance $Name"

    $ConnectionMode = New-M365DSCConnection -Workload 'PnP' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = @{
        Name   = $Name
        Type   = $Type
        Ensure = 'Absent'
    }

    try
    {
        if ($null -eq $Script:RecentMPExtract)
        {
            $Script:RecentMPExtract = [Xml] (Get-PnPSearchConfiguration -Scope Subscription)
        }
        $property = $Script:RecentMPExtract.SearchConfigurationSettings.SearchSchemaConfigurationSettings.ManagedProperties.dictionary.KeyValueOfstringManagedPropertyInfoy6h3NzC8 `
        | Where-Object -FilterScript { $_.Value.Name -eq $Name }

        [System.Xml.XmlElement]$aliases = $Script:RecentMPExtract.SearchConfigurationSettings.SearchSchemaConfigurationSettings.Aliases.dictionary.KeyValueOfstringAliasInfoy6h3NzC8 `
        | Where-Object -FilterScript { $_.Value.ManagedPid -eq $property.Value.Pid }

        if ($null -eq $property)
        {
            Write-Verbose -Message "The specified Managed Property {$($Name)} doesn't already exist."
            return $nullReturn
        }

        $CompanyNameExtraction = $false
        if ($property.Value.EntityExtractorBitMap -eq '4161')
        {
            $CompanyNameExtraction = $true
        }
        $FullTextIndex = $null
        if ([string] $property.Value.FullTextIndex -ne 'System.Xml.XmlElement')
        {
            $FullTextIndex = [string] $property.Value.FullTextIndex
        }

        # Get Mapped Crawled Properties
        $currentManagedPID = [string] $property.Value.Pid
        $mappedProperties = $Script:RecentMPExtract.SearchConfigurationSettings.SearchSchemaConfigurationSettings.Mappings.dictionary.KeyValueOfstringMappingInfoy6h3NzC8 `
        | Where-Object -FilterScript { $_.Value.ManagedPid -eq $currentManagedPID }

        $mappings = @()
        foreach ($mappedProperty in $mappedProperties)
        {
            $mappings += $mappedProperty.Value.CrawledPropertyName.ToString()
        }

        $fixedRefinable = 'No'
        if ([boolean] $property.Value.Refinable)
        {
            $fixedRefinable = 'Yes'
        }

        $fixedSortable = 'No'
        if ([boolean] $property.Value.Sortable)
        {
            $fixedSortable = 'Yes'
        }
        Write-Verbose -Message 'Retrieved Property'
        return @{
            Name                        = [string] $property.Value.Name
            Type                        = [string] $property.Value.ManagedType
            Description                 = [string] $property.Value.Description
            Searchable                  = [boolean]::Parse($property.Value.Searchable)
            FullTextIndex               = $FullTextIndex
            FullTextContext             = [UInt32] $property.Value.Context
            Queryable                   = [boolean]::Parse($property.Value.Queryable)
            Retrievable                 = [boolean]::Parse($property.Value.Retrievable)
            AllowMultipleValues         = [boolean]::Parse($property.Value.HasMultipleValues)
            Refinable                   = $fixedRefinable
            Sortable                    = $fixedSortable
            Safe                        = [boolean]::Parse($property.Value.SafeForAnonymous)
            Aliases                     = $aliases.Value.Name
            TokenNormalization          = [boolean]::Parse($property.Value.TokenNormalization)
            CompleteMatching            = [boolean]::Parse($property.Value.CompleteMatching)
            LanguageNeutralTokenization = [boolean]::Parse($property.Value.LanguageNeutralWordBreaker)
            FinerQueryTokenization      = [boolean]::Parse($property.Value.ExpandSegments)
            MappedCrawledProperties     = $mappings
            CompanyNameExtraction       = $CompanyNameExtraction
            Credential                  = $Credential
            ApplicationId               = $ApplicationId
            TenantId                    = $TenantId
            ApplicationSecret           = $ApplicationSecret
            CertificatePassword         = $CertificatePassword
            CertificatePath             = $CertificatePath
            CertificateThumbprint       = $CertificateThumbprint
            Managedidentity             = $ManagedIdentity.IsPresent
            Ensure                      = 'Present'
            AccessTokens                = $AccessTokens
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullReturn
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
        [ValidateSet('Text', 'Integer', 'Decimal', 'DateTime', 'YesNo', 'Double', 'Binary')]
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
        [System.UInt32]
        $FullTextContext,

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
        [ValidateSet('No', 'Yes - latent', 'Yes')]
        [System.String]
        $Refinable,

        [Parameter()]
        [ValidateSet('No', 'Yes - latent', 'Yes')]
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
        [System.String[]]
        $MappedCrawledProperties,

        [Parameter()]
        [System.Boolean]
        $CompanyNameExtraction,

        [Parameter()]
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'PnP' `
        -InboundParameters $PSBoundParameters

    if ($Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Removing SPOSearchManagedProperty {$Name}"
        Remove-PnPSearchConfiguration -Configuration $Name -Scope Subscription
        return
    }
    $SearchConfigTemplatePath = Join-Path -Path $PSScriptRoot `
        -ChildPath '..\..\Dependencies\SearchConfigurationSettings.xml' `
        -Resolve
    $SearchConfigXML = [Xml] (Get-Content $SearchConfigTemplatePath -Raw)

    # Get the managed property back if it already exists.
    if ($null -eq $Script:RecentMPExtract)
    {
        $Script:RecentMPExtract = [XML] (Get-PnPSearchConfiguration -Scope Subscription)
    }

    $property = $Script:RecentMPExtract.SearchConfigurationSettings.SearchSchemaConfigurationSettings.ManagedProperties.dictionary.KeyValueOfstringManagedPropertyInfoy6h3NzC8 `
    | Where-Object -FilterScript { $_.Value.Name -eq $Name }
    if ($null -ne $property)
    {
        $currentPID = $property.Value.Pid
    }
    else
    {
        $randomizer = [System.Random]::new()
        $currentPID = $randomizer.Next(1000, 9999)
    }

    $prop = $SearchConfigXml.ChildNodes[0].SearchSchemaConfigurationSettings.ManagedProperties.dictionary
    $newManagedPropertyElement = $SearchConfigXML.CreateElement('d4p1:KeyValueOfstringManagedPropertyInfoy6h3NzC8', `
            'http://schemas.microsoft.com/2003/10/Serialization/Arrays')
    $keyNode = $SearchConfigXML.CreateElement('d4p1:Key', `
            'http://schemas.microsoft.com/2003/10/Serialization/Arrays')
    $keyNode.InnerText = $Name
    $newManagedPropertyElement.AppendChild($keyNode) | Out-Null

    $valueNode = $SearchConfigXML.CreateElement('d4p1:Value', `
            'http://schemas.microsoft.com/2003/10/Serialization/Arrays')

    $node = $SearchConfigXML.CreateElement('d3p1:Name', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = $Name
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:CompleteMatching', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = $CompleteMatching.ToString().Replace('$', '').ToLower()
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:Context', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = $FullTextContext.ToString()
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:DeleteDisallowed', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = 'false'
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:Description', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')

    $node.InnerText = $Description
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:EnabledForScoping', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = 'false'
    $valueNode.AppendChild($node) | Out-Null

    #region EntiryExtractionBitMap
    $node = $SearchConfigXML.CreateElement('d3p1:EntityExtractorBitMap', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')

    if ($CompanyNameExtraction)
    {
        $node.InnerText = '4161'
    }
    else
    {
        $node.InnerText = '0'
    }
    $valueNode.AppendChild($node) | Out-Null
    #endregion

    $node = $SearchConfigXML.CreateElement('d3p1:ExpandSegments', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = $FinerQueryTokenization.ToString().Replace('$', '').ToLower()
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:FullTextIndex', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = $FullTextIndex
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:HasMultipleValues', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = $AllowMultipleValues.ToString().Replace('$', '').ToLower()
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:IndexOptions', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = '0'
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:IsImplicit', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = 'false'
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:IsReadOnly', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = 'false'
    $valueNode.AppendChild($node) | Out-Null

    #region LanguageNeutralWordBreaker
    if ($LanguageNeutralTokenization -and $CompleteMatching)
    {
        throw 'You cannot have CompleteMatching set to True if LanguageNeutralTokenization is set to True'
    }
    $node = $SearchConfigXML.CreateElement('d3p1:LanguageNeutralWordBreaker', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = $LanguageNeutralTokenization.ToString().Replace('$', '').ToLower()
    $valueNode.AppendChild($node) | Out-Null
    #endregion

    $node = $SearchConfigXML.CreateElement('d3p1:ManagedType', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = $Type
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:MappingDisallowed', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = 'false'
    $valueNode.AppendChild($node) | Out-Null

    #region PID
    if ($null -ne $currentPID)
    {
        $node = $SearchConfigXML.CreateElement('d3p1:Pid', `
                'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
        $node.InnerText = $currentPid
        $valueNode.AppendChild($node) | Out-Null
    }
    #endregion

    $node = $SearchConfigXML.CreateElement('d3p1:Queryable', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = $Queryable.ToString().Replace('$', '').ToLower()
    $valueNode.AppendChild($node) | Out-Null

    #region Refinable
    $value = $false
    if ($Refinable -eq 'Yes')
    {
        $value = $true
    }
    $node = $SearchConfigXML.CreateElement('d3p1:Refinable', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = $value.ToString().Replace('$', '').ToLower()
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:RefinerConfiguration', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')

    $subNode = $SearchConfigXML.CreateElement('d3p1:Anchoring', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $subNode.InnerText = 'Auto'
    $node.AppendChild($subNode) | Out-Null

    $subNode = $SearchConfigXML.CreateElement('d3p1:CutoffMaxBuckets', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $subNode.InnerText = '1000'
    $node.AppendChild($subNode) | Out-Null

    $subNode = $SearchConfigXML.CreateElement('d3p1:Divisor', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $subNode.InnerText = '1'
    $node.AppendChild($subNode) | Out-Null

    $subNode = $SearchConfigXML.CreateElement('d3p1:Intervals', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $subNode.InnerText = '4'
    $node.AppendChild($subNode) | Out-Null

    $subNode = $SearchConfigXML.CreateElement('d3p1:Resolution', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $subNode.InnerText = '1'
    $node.AppendChild($subNode) | Out-Null

    $subNode = $SearchConfigXML.CreateElement('d3p1:Type', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $subNode.InnerText = 'Deep'
    $node.AppendChild($subNode) | Out-Null

    $valueNode.AppendChild($node) | Out-Null
    #endregion

    $node = $SearchConfigXML.CreateElement('d3p1:RemoveDuplicates', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = 'true'
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:RespectPriority', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = 'false'
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:Retrievable', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = $Retrievable.ToString().Replace('$', '').ToLower()
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:SafeForAnonymous', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = $Safe.ToString().Replace('$', '').ToLower()
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:Searchable', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = $Searchable.ToString().Replace('$', '').ToLower()
    $valueNode.AppendChild($node) | Out-Null

    #region Sortable
    $value = $false
    if ($Sortable -eq 'Yes')
    {
        $value = $true
    }
    $node = $SearchConfigXML.CreateElement('d3p1:Sortable', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = $value.ToString().Replace('$', '').ToLower()
    $valueNode.AppendChild($node) | Out-Null
    #endregion

    $node = $SearchConfigXML.CreateElement('d3p1:SortableType', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = 'Enabled'
    $valueNode.AppendChild($node) | Out-Null

    $node = $SearchConfigXML.CreateElement('d3p1:TokenNormalization', `
            'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
    $node.InnerText = $TokenNormalization.ToString().Replace('$', '').ToLower()
    $valueNode.AppendChild($node) | Out-Null

    $newManagedPropertyElement.AppendChild($valueNode)
    $prop.AppendChild($newManagedPropertyElement) | Out-Null

    $tempPath = Join-Path -Path $ENV:TEMP `
        -ChildPath ((New-Guid).ToString().Split('-')[0] + '.config')
    $SearchConfigXML.OuterXml | Out-File $tempPath

    # Create the Managed Property if it doesn't already exist
    Write-Verbose -Message "Updating core properties for Search Managed Property {$Name}"
    Set-PnPSearchConfiguration -Scope 'Subscription' -Path $tempPath

    #region Aliases
    if ($null -ne $Aliases)
    {
        $aliasesArray = $Aliases.Split(';')
        $aliasDictNode = $SearchConfigXml.ChildNodes[0].SearchSchemaConfigurationSettings.Aliases.dictionary

        if ([System.String]::IsNullOrEmpty($currentPID))
        {
            # Get the managed property back. This is the only way to ensure we have the right PID
            $currentConfigXML = [XML] (Get-PnPSearchConfiguration -Scope Subscription)
            [System.Xml.XmlElement]$property = $Script:currentConfigXML.SearchConfigurationSettings.SearchSchemaConfigurationSettings.ManagedProperties.dictionary.KeyValueOfstringManagedPropertyInfoy6h3NzC8 `
            | Where-Object -FilterScript { $_.Value.Name -eq $Name }

            $currentPID = $property.Value.Pid
            Write-Verbose -Message "Found current Pid {$currentPID}"

            $node = $SearchConfigXML.CreateElement('d3p1:Pid', `
                    'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
            $node.InnerText = $currentPID

            # The order in which we list the properties matters. Pid is to appear right after MappingDisallowed.
            $namespaceMgr = New-Object System.Xml.XmlNamespaceManager($SearchConfigXML.NameTable)
            $namespaceMgr.AddNamespace('d3p1', 'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
            $previousNode = $SearchConfigXML.SelectSingleNode('//d3p1:MappingDisallowed', $namespaceMgr)
            $previousNode.ParentNode.InsertAfter($node, $previousNode) | Out-Null
        }

        foreach ($alias in $aliasesArray)
        {
            $mainNode = $SearchConfigXML.CreateElement('d4p1:KeyValueOfstringAliasInfoy6h3NzC8', `
                    'http://schemas.microsoft.com/2003/10/Serialization/Arrays')
            $keyNode = $SearchConfigXML.CreateElement('d4p1:Key', `
                    'http://schemas.microsoft.com/2003/10/Serialization/Arrays')
            $keyNode.InnerText = $alias

            $valueNode = $SearchConfigXML.CreateElement('d4p1:Value', `
                    'http://schemas.microsoft.com/2003/10/Serialization/Arrays')
            $node = $SearchConfigXML.CreateElement('d3p1:Name', `
                    'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
            $node.InnerText = $alias
            $valueNode.AppendChild($node) | Out-Null

            $node = $SearchConfigXML.CreateElement('d3p1:ManagedPid', `
                    'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
            $node.InnerText = $currentPID
            $valueNode.AppendChild($node) | Out-Null

            $node = $SearchConfigXML.CreateElement('d3p1:SchemaId', `
                    'http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration')
            $node.InnerText = '794'
            $valueNode.AppendChild($node) | Out-Null

            $mainNode.AppendChild($keyNode) | Out-Null
            $mainNode.AppendChild($valueNode) | Out-Null
            $SearchConfigXml.ChildNodes[0].SearchSchemaConfigurationSettings.Aliases.dictionary.AppendChild($mainNode) | Out-Null
        }

        $tempPath = Join-Path -Path $ENV:TEMP `
            -ChildPath ((New-Guid).ToString().Split('-')[0] + '.config')
        $SearchConfigXML.OuterXml | Out-File $tempPath
        Write-Verbose -Message 'Configuring SPO Search Schema with the following XML Document'
        Write-Verbose $SearchConfigXML.OuterXML

        # Create the aliases on the Managed Property
        Write-Verbose -Message "Updating Aliases for Search Managed Property {$Name}"
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

        [Parameter(Mandatory = $true)]
        [ValidateSet('Text', 'Integer', 'Decimal', 'DateTime', 'YesNo', 'Double', 'Binary')]
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
        [System.UInt32]
        $FullTextContext,

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
        [ValidateSet('No', 'Yes - latent', 'Yes')]
        [System.String]
        $Refinable,

        [Parameter()]
        [ValidateSet('No', 'Yes - latent', 'Yes')]
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
        [System.String[]]
        $MappedCrawledProperties,

        [Parameter()]
        [System.Boolean]
        $CompanyNameExtraction,

        [Parameter()]
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration for Managed Property instance $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"
    $ValuesToCheck = $PSBoundParameters

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
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
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'PnP' `
            -InboundParameters $PSBoundParameters

        #Ensure the proper dependencies are installed in the current environment.
        Confirm-M365DSCDependencies

        #region Telemetry
        $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
        $CommandName = $MyInvocation.MyCommand
        $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
            -CommandName $CommandName `
            -Parameters $PSBoundParameters
        Add-M365DSCTelemetryEvent -Data $data
        #endregion

        $SearchConfig = [Xml] (Get-PnPSearchConfiguration -Scope Subscription -ErrorAction Stop)
        [array]$properties = $SearchConfig.SearchConfigurationSettings.SearchSchemaConfigurationSettings.ManagedProperties.dictionary.KeyValueOfstringManagedPropertyInfoy6h3NzC8

        $dscContent = ''
        $i = 1

        if ($properties.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($property in $properties)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($properties.Length)] $($property.Value.Name)" -NoNewline
            $Params = @{
                Credential            = $Credential
                Name                  = $property.Value.Name
                Type                  = $property.Value.ManagedType
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params

            if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 2)
            {
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName

                Write-Host $Global:M365DSCEmojiGreenCheckmark
            }
            else
            {
                Write-Host $Global:M365DSCEmojiRedX
            }

            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
