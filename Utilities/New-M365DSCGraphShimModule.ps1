<#
.SYNOPSIS
    Generates the Microsoft365DSC Graph shim module.

.DESCRIPTION
    Reads cmdlet-mapping.json (URI/method data from Find-MgGraphCommand) and
    function-signatures.json to produce a single .psm1 file that re-exports
    every Graph SDK cmdlet Microsoft365DSC uses as a lightweight wrapper
    around Invoke-MgGraphRequest.

    The generated module depends ONLY on Microsoft.Graph.Authentication and
    eliminates the need to install/import the ~22 heavy Graph SDK sub-modules.

.PARAMETER CmdletMappingPath
    Path to the cmdlet-mapping.json produced by Build-CmdletMapping.ps1.

.PARAMETER FunctionSignaturesPath
    Path to the function-signatures.json produced by Extract-FunctionSignatures.ps1.

.PARAMETER OutputModulePath
    Path for the generated .psm1 file.

.PARAMETER OutputManifestPath
    Path for the generated .psd1 manifest file.

.EXAMPLE
    .\New-M365DSCGraphShimModule.ps1
#>
#Requires -PSEdition Core
param(
    [string]$CmdletMappingPath = "$PSScriptRoot\cmdlet-mapping.json",
    [string]$FunctionSignaturesPath = "$PSScriptRoot\function-signatures.json",
    [string]$OutputModulePath = "$PSScriptRoot\..\Modules\Microsoft365DSC\Modules\M365DSCGraphShim.psm1",
    [string]$OutputManifestPath = "$PSScriptRoot\..\Modules\Microsoft365DSC\Modules\M365DSCGraphShim.psd1"
)

$ErrorActionPreference = 'Stop'

Update-M365DSCDependencies -ValidateOnly -Development

$settingsFiles = Get-ChildItem -Path "$PSScriptRoot\..\Modules\Microsoft365DSC\DSCResources" -Filter 'settings.json' -Recurse
$map = [ordered]@{}
foreach ($file in $settingsFiles)
{
    $json = Get-Content $file.FullName -Raw | ConvertFrom-Json -AsHashtable
    if (-not $json.ContainsKey('commands'))
    {
        continue
    }

    foreach ($command in $json.commands)
    {
        if ($command.module -notlike 'Microsoft.Graph*' -or $command.module -eq 'Microsoft.Graph.Authentication')
        {
            continue
        }
        foreach ($cmd in $command.cmdlets)
        {
            $map[$cmd] = $command.module
        }
    }
}
$map | ConvertTo-Json -Depth 10 | Out-File -FilePath "$PSScriptRoot\cmdlet-source-modules.json" -Encoding UTF8

#& "$PSScriptRoot\Build-CmdletMapping.ps1" -CmdletSourceModulesPath "$PSScriptRoot\cmdlet-source-modules.json" -OutputPath $CmdletMappingPath

#& "$PSScriptRoot\Extract-FunctionSignatures.ps1" -CmdletSourceModulesPath "$PSScriptRoot\cmdlet-source-modules.json" -OutputPath $FunctionSignaturesPath

#region Load data sources
Write-Host 'Loading cmdlet mapping...'
$cmdletMapping = Get-Content $CmdletMappingPath -Raw | ConvertFrom-Json

Write-Host 'Loading function signatures...'
$functionSignatures = Get-Content $FunctionSignaturesPath -Raw | ConvertFrom-Json

$cmdletNames = @($cmdletMapping.PSObject.Properties.Name | Sort-Object)
Write-Host "  $($cmdletNames.Count) cmdlets in mapping"
#endregion

#region Classify parameters
# Parameters that are part of the SDK infrastructure and should NOT be sent in the request body.
$infrastructureParams = @(
    'Headers', 'HttpPipelinePrepend', 'HttpPipelineAppend',
    'Proxy', 'ProxyCredential', 'ProxyUseDefaultCredentials',
    'Break', 'ResponseHeadersVariable', 'InputObject'
)

# Parameters that map to OData query options (used in GET requests).
$odataParams = @(
    'Filter', 'Property', 'ExpandProperty', 'Top', 'Skip',
    'Search', 'Sort', 'CountVariable', 'ConsistencyLevel',
    'All', 'PageSize'
)

# Parameters that are used for body construction in POST/PATCH/PUT
$bodyMetaParams = @(
    'BodyParameter', 'AdditionalProperties'
)
#endregion

#region Helper: convert PascalCase identity param name to URI placeholder
function ConvertTo-UriPlaceholder {
    param([string]$ParamName)
    # Strip trailing 'Id' or '_Id'
    $base = $ParamName -replace 'Id$', '' -replace '_Id$', ''
    # Insert hyphens before uppercase letters (PascalCase → kebab-case)
    $kebab = ($base -creplace '([a-z])([A-Z])', '$1-$2').ToLower()
    return "{$kebab-id}"
}
#endregion

#region Helper: determine identity parameters and their URI placeholders for a cmdlet
function Get-IdentityParamMapping {
    param(
        [string]$CmdletName,
        [array]$Variants,
        [array]$ParamList
    )

    # Find URI variant with placeholders (single-item endpoint)
    $singleItemVariant = $Variants | Where-Object { $_.URI -match '\{[^}]+\}' } | Select-Object -First 1
    if (-not $singleItemVariant) { return @{} }

    $uri = $singleItemVariant.URI
    # Extract all placeholders like {application-id}
    $placeholders = [regex]::Matches($uri, '\{([^}]+)\}') | ForEach-Object { $_.Groups[1].Value }

    $paramMapping = [ordered]@{}
    foreach ($placeholder in $placeholders) {
        # Try to find matching parameter: convert placeholder to PascalCase + 'Id'
        # {application-id} → ApplicationId
        # {conditionalAccessPolicy-id} → ConditionalAccessPolicyId
        $pascalCase = ($placeholder -replace '-id$', '' -split '-' | ForEach-Object {
            $_.Substring(0, 1).ToUpper() + $_.Substring(1)
        }) -join ''
        $paramName = $pascalCase + 'Id'

        # Check if this parameter exists in the stub signature
        $matchingParam = $ParamList | Where-Object { $_.Name -eq $paramName }
        if ($matchingParam) {
            $paramMapping[$paramName] = $placeholder
        }
        else {
            # Try common alternatives: Id, DirectoryObjectId
            foreach ($alt in @('Id', $CmdletName -replace '^(Get|New|Update|Remove|Set|Invoke)-Mg(Beta)?', '' -replace '([A-Z])', '$1' | ForEach-Object { $_ + 'Id' })) {
                $altMatch = $ParamList | Where-Object { $_.Name -eq $alt }
                if ($altMatch) {
                    $paramMapping[$alt] = $placeholder
                    break
                }
            }
        }
    }
    return $paramMapping
}
#endregion

#region Build the module content
$sb = [System.Text.StringBuilder]::new(512KB)

# Module header
[void]$sb.AppendLine(@'
#region Module Header
# =============================================================================
# AUTO-GENERATED FILE — Do not edit manually.
# Generated by: New-M365DSCGraphShimModule.ps1
# Purpose:      Drop-in replacement for Microsoft Graph SDK typed cmdlets.
#               Each function wraps Invoke-MgGraphRequest from
#               Microsoft.Graph.Authentication, eliminating the need for
#               the heavy auto-generated SDK sub-modules.
# =============================================================================
#endregion

#region Shared Helpers

<#
.SYNOPSIS
    Centralized wrapper around Invoke-MgGraphRequest with retry logic.
#>
function Invoke-M365DSCGraphShimRequest
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $Method,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Uri,

        [Parameter()]
        [System.Object]
        $Body,

        [Parameter()]
        [System.Collections.IDictionary]
        $Headers,

        [Parameter()]
        [System.String]
        $OutputType,

        [Parameter()]
        [Switch]
        $PassThru
    )

    $invokeParams = @{
        Method = $Method
        Uri    = $Uri
    }
    if ($PSBoundParameters.ContainsKey('Body') -and $null -ne $Body)
    {
        $invokeParams['Body'] = $Body
        $invokeParams['ContentType'] = 'application/json'
    }
    if ($PSBoundParameters.ContainsKey('Headers') -and $Headers.Keys.Count -gt 0)
    {
        $invokeParams['Headers'] = $Headers
    }
    if ($PSBoundParameters.ContainsKey('OutputType') -and -not [System.String]::IsNullOrEmpty($OutputType))
    {
        $invokeParams['OutputType'] = $OutputType
    }
    if ($ErrorActionPreference -eq 'SilentlyContinue')
    {
        $invokeParams['SkipHttpErrorCheck'] = $true
    }

    $maxRetries = 5
    for ($attempt = 1; $attempt -le $maxRetries; $attempt++)
    {
        try
        {
            $returnValue = Invoke-MgGraphRequest @invokeParams
            if ($null -ne $returnValue -and $returnValue.ContainsKey('value') -and -not $PassThru)
            {
                $returnValue = $returnValue.value
            }
            elseif ($null -ne $returnValue -and $returnValue.ContainsKey('error'))
            {
                $returnValue = $null
            }
            return $returnValue
        }
        catch
        {
            $statusCode = $null
            if ($_.Exception.Response)
            {
                $statusCode = [int]$_.Exception.Response.StatusCode
            }
            elseif ($_.Exception.Message -match '(\d{3})')
            {
                $statusCode = [int]$Matches[1]
            }

            if ($statusCode -in @(429, 503, 504) -and $attempt -lt $maxRetries)
            {
                $retryAfter = 2
                if ($_.Exception.Response.Headers -and $_.Exception.Response.Headers['Retry-After'])
                {
                    $retryAfter = [int]$_.Exception.Response.Headers['Retry-After']
                }
                $delay = [Math]::Max($retryAfter, [Math]::Pow(2, $attempt))
                Write-Verbose "Graph API returned $statusCode. Retrying in $delay seconds (attempt $attempt/$maxRetries)..."
                Start-Sleep -Seconds $delay
            }
            else
            {
                throw
            }
        }
    }
}

<#
.SYNOPSIS
    Follows @odata.nextLink to retrieve all pages of a Graph API collection.
#>
function Get-M365DSCGraphShimAllPages
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $Uri,

        [Parameter()]
        [System.Collections.IDictionary]
        $Headers,

        [Parameter()]
        [System.Int32]
        $Top = 0
    )

    $allResults = [System.Collections.Generic.List[System.Object]]::new()
    $currentUri = $Uri

    if ($Top -gt 0 -and $currentUri -notmatch '[\?&]\$top=')
    {
        $separator = if ($currentUri.Contains('?')) { '&' } else { '?' }
        $currentUri = "$currentUri$separator`$top=$Top"
    }

    $requestParams = @{
        Method = 'GET'
        Uri    = $currentUri
    }
    if ($PSBoundParameters.ContainsKey('Headers') -and $Headers.Keys.Count -gt 0)
    {
        $requestParams['Headers'] = $Headers
    }

    do
    {
        $response = Invoke-M365DSCGraphShimRequest @requestParams -PassThru
        if ($null -eq $response)
        {
            break
        }
        elseif ($response.ContainsKey('value'))
        {
            $allResults.AddRange([array]$response.value)
        }
        elseif ($response -is [System.Collections.IEnumerable] -and $response -isnot [string])
        {
            $allResults.AddRange([array]$response)
        }
        else
        {
            # Single object response, not a collection
            $allResults.Add($response)
        }

        $nextLink = $response.'@odata.nextLink'
        if (-not [System.String]::IsNullOrEmpty($nextLink))
        {
            $requestParams['Uri'] = $nextLink
        }
    }
    while (-not [System.String]::IsNullOrEmpty($nextLink))

    return $allResults
}

<#
.SYNOPSIS
    Builds a Graph API URI from a template, identity parameters, and OData query options.
#>
function ConvertTo-M365DSCGraphShimUri
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $UriTemplate,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String[]]
        $Property,

        [Parameter()]
        [System.String[]]
        $ExpandProperty,

        [Parameter()]
        [System.Int32]
        $Top = 0,

        [Parameter()]
        [System.Int32]
        $Skip = 0,

        [Parameter()]
        [System.String]
        $Search,

        [Parameter()]
        [System.String[]]
        $Sort,

        [Parameter()]
        [System.String]
        $CountVariable
    )

    $uri = $UriTemplate
    $queryParts = [System.Collections.Generic.List[System.String]]::new()
    if (-not [System.String]::IsNullOrEmpty($Filter))
    {
        $queryParts.Add("`$filter=$([System.Web.HttpUtility]::UrlEncode($Filter))")
    }
    if ($Property -and $Property.Count -gt 0)
    {
        $queryParts.Add("`$select=$($Property -join ',')")
    }
    if ($ExpandProperty -and $ExpandProperty.Count -gt 0)
    {
        $queryParts.Add("`$expand=$($ExpandProperty -join ',')")
    }
    if ($Top -gt 0)
    {
        $queryParts.Add("`$top=$Top")
    }
    if ($Skip -gt 0)
    {
        $queryParts.Add("`$skip=$Skip")
    }
    if (-not [System.String]::IsNullOrEmpty($Search))
    {
        $queryParts.Add("`$search=$([System.Web.HttpUtility]::UrlEncode($Search))")
    }
    if ($Sort -and $Sort.Count -gt 0)
    {
        $queryParts.Add("`$orderby=$($Sort -join ',')")
    }
    if (-not [System.String]::IsNullOrEmpty($CountVariable))
    {
        $queryParts.Add('$count=true')
    }

    if ($queryParts.Count -gt 0)
    {
        $uri = "$uri`?$($queryParts -join '&')"
    }
    return $uri
}

<#
.SYNOPSIS
    Assembles a request body from bound parameters, merging AdditionalProperties.
#>
function ConvertTo-M365DSCGraphShimBody
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Object]
        $BodyParameter,

        [Parameter()]
        [System.Collections.Hashtable]
        $AdditionalProperties,

        [Parameter()]
        [System.Collections.Hashtable]
        $NamedParams = @{},

        [Parameter()]
        [System.String[]]
        $ExcludeParams = @()
    )

    # If BodyParameter is provided, use it directly
    if ($null -ne $BodyParameter)
    {
        $body = if ($BodyParameter -is [System.Collections.IDictionary])
        {
            ([System.Collections.Hashtable]$BodyParameter).Clone()
        }
        else
        {
            # Convert PSObject to hashtable
            $ht = @{}
            foreach ($prop in $BodyParameter.PSObject.Properties)
            {
                $ht[$prop.Name] = $prop.Value
            }
            $ht
        }
    }
    else
    {
        # Build body from named parameters
        $body = @{}
        foreach ($entry in $NamedParams.GetEnumerator())
        {
            if ($entry.Key -notin $ExcludeParams -and $null -ne $entry.Value)
            {
                # Convert PascalCase param name to camelCase for Graph API
                $key = $entry.Key.Substring(0, 1).ToLower() + $entry.Key.Substring(1)
                $body[$key] = $entry.Value
            }
        }
    }

    # Merge AdditionalProperties
    if ($null -ne $AdditionalProperties)
    {
        foreach ($entry in $AdditionalProperties.GetEnumerator())
        {
            $body[$entry.Key] = $entry.Value
        }
    }

    return $body
}

# Base set of parameter names that are never sent in a request body.
# Individual functions append their own identity-parameter names before calling helpers.
$script:GraphShimExcludeFromBody = @(
    'Headers', 'HttpPipelinePrepend', 'HttpPipelineAppend',
    'Proxy', 'ProxyCredential', 'ProxyUseDefaultCredentials',
    'Break', 'ResponseHeadersVariable', 'InputObject',
    'Filter', 'Property', 'ExpandProperty', 'Top', 'Skip',
    'Search', 'Sort', 'CountVariable', 'ConsistencyLevel',
    'All', 'PageSize', 'BodyParameter', 'AdditionalProperties',
    'Confirm', 'WhatIf'
)

<#
.SYNOPSIS
    Centralized GET dispatcher that handles single-item vs. collection retrieval,
    OData query options, and paging — replacing the identical code block that was
    duplicated in every Get-* wrapper function.
#>
function Invoke-M365DSCGraphShimGetResource
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]
        $BoundParameters,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CollectionUri,

        [Parameter()]
        [System.String]
        $SingleItemUri
    )

    # Build headers
    $requestHeaders = @{}
    if ($BoundParameters.ContainsKey('Headers')) { $requestHeaders = $BoundParameters['Headers'] }
    if ($BoundParameters.ContainsKey('ConsistencyLevel')) { $requestHeaders['ConsistencyLevel'] = $BoundParameters['ConsistencyLevel'] }

    # Single-item retrieval when a resolved SingleItemUri is supplied
    if (-not [System.String]::IsNullOrEmpty($SingleItemUri))
    {
        $uri = $SingleItemUri
        $queryParts = @()
        if ($BoundParameters['Property']) { $queryParts += "`$select=$($BoundParameters['Property'] -join ',')" }
        if ($BoundParameters['ExpandProperty']) { $queryParts += "`$expand=$($BoundParameters['ExpandProperty'] -join ',')" }
        if ($queryParts.Count -gt 0) { $uri = "$uri`?$($queryParts -join '&')" }

        return Invoke-M365DSCGraphShimRequest -Method GET -Uri $uri -Headers $requestHeaders -ErrorAction $ErrorActionPreference
    }

    # Collection retrieval
    $uriParams = @{ UriTemplate = $CollectionUri }
    if ($BoundParameters['Filter'])         { $uriParams['Filter'] = $BoundParameters['Filter'] }
    if ($BoundParameters['Property'])       { $uriParams['Property'] = $BoundParameters['Property'] }
    if ($BoundParameters['ExpandProperty']) { $uriParams['ExpandProperty'] = $BoundParameters['ExpandProperty'] }
    if ($BoundParameters.ContainsKey('Top') -and $BoundParameters['Top'] -gt 0)   { $uriParams['Top'] = $BoundParameters['Top'] }
    if ($BoundParameters.ContainsKey('Skip') -and $BoundParameters['Skip'] -gt 0) { $uriParams['Skip'] = $BoundParameters['Skip'] }
    if ($BoundParameters['Search'])         { $uriParams['Search'] = $BoundParameters['Search'] }
    if ($BoundParameters['Sort'])           { $uriParams['Sort'] = $BoundParameters['Sort'] }
    if ($BoundParameters['CountVariable'])  { $uriParams['CountVariable'] = $BoundParameters['CountVariable'] }

    $uri = ConvertTo-M365DSCGraphShimUri @uriParams

    if ($BoundParameters.ContainsKey('All') -and $BoundParameters['All'])
    {
        return Get-M365DSCGraphShimAllPages -Uri $uri -Headers $requestHeaders -ErrorAction $ErrorActionPreference
    }

    $response = Invoke-M365DSCGraphShimRequest -Method GET -Uri $uri -Headers $requestHeaders -ErrorAction $ErrorActionPreference
    if ($null -ne $response -and $response -is [hashtable] -and $response.ContainsKey('value'))
    {
        return $response.value
    }
    return $response
}

<#
.SYNOPSIS
    Centralized POST / PATCH / PUT dispatcher that builds the request body
    from BoundParameters, BodyParameter, and AdditionalProperties, then
    invokes the Graph API — replacing the identical code block that was
    duplicated in every New-*, Update-*, and Set-* wrapper function.
#>
function Invoke-M365DSCGraphShimWriteResource
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]
        $BoundParameters,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Uri,

        [Parameter(Mandatory = $true)]
        [ValidateSet('POST', 'PATCH', 'PUT')]
        [System.String]
        $Method,

        [Parameter()]
        [System.String[]]
        $ExtraExcludeParams = @()
    )

    $requestHeaders = @{}
    if ($BoundParameters.ContainsKey('Headers')) { $requestHeaders = $BoundParameters['Headers'] }

    $excludeFromBody = $script:GraphShimExcludeFromBody + $ExtraExcludeParams
    $namedParams = @{}
    foreach ($key in $BoundParameters.Keys)
    {
        if ($key -notin $excludeFromBody)
        {
            $namedParams[$key] = $BoundParameters[$key]
        }
    }

    $body = ConvertTo-M365DSCGraphShimBody `
        -BodyParameter $BoundParameters['BodyParameter'] `
        -AdditionalProperties $BoundParameters['AdditionalProperties'] `
        -NamedParams $namedParams `
        -ExcludeParams $excludeFromBody

    return Invoke-M365DSCGraphShimRequest -Method $Method -Uri $Uri -Body $body -Headers $requestHeaders -ErrorAction $ErrorActionPreference
}

function Invoke-M365DSCGraphShimDeleteResource
{
    <#
    .SYNOPSIS
        Centralized DELETE dispatcher — replacing the identical 3-line code block
        that was duplicated in every Remove-* wrapper function.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]
        $BoundParameters,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Uri
    )

    $requestHeaders = @{}
    if ($BoundParameters.ContainsKey('Headers')) { $requestHeaders = $BoundParameters['Headers'] }
    Invoke-M365DSCGraphShimRequest -Method 'DELETE' -Uri $Uri -Headers $requestHeaders -ErrorAction $ErrorActionPreference
}

#endregion Shared Helpers
'@)

Write-Host 'Generating wrapper functions...'
$generated = 0
$skipped = 0
$exportedFunctions = [System.Collections.Generic.List[string]]::new()

foreach ($cmdletName in $cmdletNames) {
    $mapEntry = $cmdletMapping.PSObject.Properties[$cmdletName].Value
    $functionProp = $functionSignatures.PSObject.Properties[$cmdletName]
    $functionEntry = if ($functionProp) { @($functionProp.Value) } else { @() }

    $variants = @($mapEntry.Variants)
    $apiVersion = $mapEntry.ApiVersion
    $method = $variants[0].Method

    # Find the appropriate URI templates
    $allListUris = $variants | Where-Object { $_.URI.Split('/')[-1] -notmatch '\{[^}]+\}' } | Select-Object -ExpandProperty URI
    if ($allListUris.Count -gt 1) {
        $placeHolders = @()
        foreach ($uri in $allListUris) {
            $phs = [regex]::Matches($uri, '\{([^}]+)\}') | ForEach-Object { $_.Groups[1].Value }
            $placeHolders += $phs
        }
        $cleanedAllListUris = $allListUris | ForEach-Object {
            $cleanUri = $_
            foreach ($ph in $placeHolders) {
                $cleanUri = ($cleanUri -replace [regex]::Escape("{$ph}"), '') -replace '//+', '/'
            }
            $cleanUri
        }
        $singleUri = $variants | Where-Object {
            $uri = $_.URI
            foreach ($cleanUri in $cleanedAllListUris) {
                if ($uri -eq $cleanUri) {
                    return $false
                }
            }
            return $true
        } | Select-Object -First 1 | Select-Object -ExpandProperty URI
        $listUri = $allListUris | Where-Object { $_ -notlike "*{*}*" } | Select-Object -First 1
    } else {
        $listUri = ($allListUris | Select-Object -First 1)?.Replace('$','`$') # The Uri that does not end with a placeholder is likely the list endpoint
        $singleUri = ($variants | Where-Object { $_.URI.Split('/')[-1] -match '\{[^}]+\}' } | Select-Object -First 1)?.URI?.Replace('$','`$') # The Uri that ends with a placeholder is likely the single-item endpoint
    }

    $primaryUri = if ($singleUri) { $singleUri } else { $listUri }
    if (-not $primaryUri) { $primaryUri = $variants[0].URI.Replace('$', '`$') }

    # Determine identity parameter mappings
     $identityMapping = [ordered]@{}
    $placeholders = @()
    if ($singleUri) {
        $placeholders = [regex]::Matches($singleUri, '\{([^}]+)\}') | ForEach-Object { $_.Groups[1].Value }
    } elseif ($listUri) {
        $placeholders = [regex]::Matches($listUri, '\{([^}]+)\}') | ForEach-Object { $_.Groups[1].Value }
    } else {
        # No URI with placeholders, try to find any placeholders in the primary URI
        $placeholders = [regex]::Matches($primaryUri, '\{([^}]+)\}') | ForEach-Object { $_.Groups[1].Value }
    }

    foreach ($ph in $placeholders) {
        # Convert {placeholder-id} to PascalCaseId param name
        $parts = $ph.Split('-')
        $pascalParts = $parts | ForEach-Object { $_.Substring(0, 1).ToUpper() + $_.Substring(1) }
        $paramName = $pascalParts -join ''

        # Verify it exists in function params
        $match = $functionEntry | Where-Object { $_.Name -eq $paramName }
        if ($match) {
            $identityMapping[$paramName] = $ph
        }
        else {
            # Try just 'Id'
            $idMatch = $functionEntry | Where-Object { $_.Name -eq 'Id' }
            if ($idMatch) {
                $identityMapping['Id'] = $ph
            }
        }
    }

    # Build the param block string
    $paramLines = [System.Text.StringBuilder]::new()
    [void]$paramLines.AppendLine('    [CmdletBinding()]')
    [void]$paramLines.AppendLine('    param(')
    $paramEntries = @()
    foreach ($p in $functionEntry) {
        $pName = $p.Name
        $pType = $p.Type

        $entry = [System.Text.StringBuilder]::new()
        [void]$entry.AppendLine('        [Parameter()]')
        [void]$entry.AppendLine("        [$pType]")
        [void]$entry.Append("        `$$pName")
        $paramEntries += $entry.ToString()
    }
    [void]$paramLines.Append(($paramEntries -join ",`r`n`r`n"))
    [void]$paramLines.AppendLine('')
    [void]$paramLines.AppendLine('    )')

    # Build the function body
    $bodyLines = [System.Text.StringBuilder]::new()

    # Determine which params are identity, OData, body-meta, and infrastructure
    $identityParamNames = @($identityMapping.Keys)
    $allExcludeFromBody = $infrastructureParams + $odataParams + $bodyMetaParams + $identityParamNames + @('Confirm', 'WhatIf')

    switch ($method) {
        'GET' {
            # GET requests: delegate to Invoke-M365DSCGraphShimGetResource
            $hasListUri = $null -ne $listUri
            $hasSingleUri = $null -ne $singleUri

            [void]$bodyLines.AppendLine('')

            if ($hasSingleUri -and $identityParamNames.Count -gt 0) {
                # Build the single-item URI expression with variable substitution
                $singleUriExpr = "/$apiVersion$singleUri"
                foreach ($entry in $identityMapping.GetEnumerator()) {
                    $singleUriExpr = $singleUriExpr -replace [regex]::Escape("{$($entry.Value)}"), "`$(`$$($entry.Key))"
                }

                $lastIdParam = $identityParamNames[-1]
                [void]$bodyLines.AppendLine("    `$singleItemUri = if (`$PSBoundParameters.ContainsKey('$lastIdParam') -and -not [System.String]::IsNullOrEmpty(`$$lastIdParam)) { `"$singleUriExpr`" } else { `$null }")
            }

            # Build the collection URI expression (or singleton URI if no list endpoint)
            if ($hasListUri) {
                $listUriExpr = "/$apiVersion$listUri"
                foreach ($entry in $identityMapping.GetEnumerator()) {
                    $listUriExpr = $listUriExpr -replace [regex]::Escape("{$($entry.Value)}"), "`$(`$$($entry.Key))"
                }
                $collectionUriLiteral = $listUriExpr
            }
            else {
                $uriExpr = "/$apiVersion$primaryUri"
                foreach ($entry in $identityMapping.GetEnumerator()) {
                    $uriExpr = $uriExpr -replace [regex]::Escape("{$($entry.Value)}"), "`$(`$$($entry.Key))"
                }
                $collectionUriLiteral = $uriExpr
            }

            if ($hasSingleUri -and $identityParamNames.Count -gt 0) {
                [void]$bodyLines.AppendLine("    return Invoke-M365DSCGraphShimGetResource -BoundParameters `$PSBoundParameters -CollectionUri `"$collectionUriLiteral`" -SingleItemUri `$singleItemUri -ErrorAction `$ErrorActionPreference")
            }
            else {
                [void]$bodyLines.AppendLine("    return Invoke-M365DSCGraphShimGetResource -BoundParameters `$PSBoundParameters -CollectionUri `"$collectionUriLiteral`" -ErrorAction `$ErrorActionPreference")
            }
        }

        { $_ -in @('POST', 'PUT') } {
            # POST/PUT: delegate to Invoke-M365DSCGraphShimWriteResource
            $targetUri = if ($listUri) { $listUri } else { $primaryUri }
            $uriExpr = "/$apiVersion$targetUri"
            foreach ($entry in $identityMapping.GetEnumerator()) {
                $uriExpr = $uriExpr -replace [regex]::Escape("{$($entry.Value)}"), "`$(`$$($entry.Key))"
            }

            $httpMethod = if ($method -eq 'PUT') { 'PUT' } else { 'POST' }
            [void]$bodyLines.AppendLine('')

            if ($identityParamNames.Count -gt 0) {
                $extraExclude = ($identityParamNames | ForEach-Object { "'$_'" }) -join ', '
                [void]$bodyLines.AppendLine("    return Invoke-M365DSCGraphShimWriteResource -BoundParameters `$PSBoundParameters -Uri `"$uriExpr`" -Method '$httpMethod' -ExtraExcludeParams @($extraExclude) -ErrorAction `$ErrorActionPreference")
            }
            else {
                [void]$bodyLines.AppendLine("    return Invoke-M365DSCGraphShimWriteResource -BoundParameters `$PSBoundParameters -Uri `"$uriExpr`" -Method '$httpMethod' -ErrorAction `$ErrorActionPreference")
            }
        }

        'PATCH' {
            # PATCH: delegate to Invoke-M365DSCGraphShimWriteResource
            $targetUri = if ($singleUri) { $singleUri } else { $primaryUri }
            $uriExpr = "/$apiVersion$targetUri"
            foreach ($entry in $identityMapping.GetEnumerator()) {
                $uriExpr = $uriExpr -replace [regex]::Escape("{$($entry.Value)}"), "`$(`$$($entry.Key))"
            }

            [void]$bodyLines.AppendLine('')

            if ($identityParamNames.Count -gt 0) {
                $extraExclude = ($identityParamNames | ForEach-Object { "'$_'" }) -join ', '
                [void]$bodyLines.AppendLine("    return Invoke-M365DSCGraphShimWriteResource -BoundParameters `$PSBoundParameters -Uri `"$uriExpr`" -Method 'PATCH' -ExtraExcludeParams @($extraExclude) -ErrorAction `$ErrorActionPreference")
            }
            else {
                [void]$bodyLines.AppendLine("    return Invoke-M365DSCGraphShimWriteResource -BoundParameters `$PSBoundParameters -Uri `"$uriExpr`" -Method 'PATCH' -ErrorAction `$ErrorActionPreference")
            }
        }

        'DELETE' {
            # DELETE: delegate to Invoke-M365DSCGraphShimDeleteResource
            $targetUri = if ($singleUri) { $singleUri } else { $primaryUri }
            $uriExpr = "/$apiVersion$targetUri"
            foreach ($entry in $identityMapping.GetEnumerator()) {
                $uriExpr = $uriExpr -replace [regex]::Escape("{$($entry.Value)}"), "`$(`$$($entry.Key))"
            }

            [void]$bodyLines.AppendLine('')
            [void]$bodyLines.AppendLine("    Invoke-M365DSCGraphShimDeleteResource -BoundParameters `$PSBoundParameters -Uri `"$uriExpr`" -ErrorAction `$ErrorActionPreference")
        }
    }

    # Assemble the function
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine("function $cmdletName")
    [void]$sb.AppendLine('{')
    [void]$sb.Append($paramLines.ToString())
    [void]$sb.Append($bodyLines.ToString())
    [void]$sb.AppendLine('}')

    $exportedFunctions.Add($cmdletName)
    $generated++
}
#endregion

# Module footer: export functions
[void]$sb.AppendLine('')
[void]$sb.AppendLine('# Export all wrapper functions')
$exportList = ($exportedFunctions | ForEach-Object { "'$_'" }) -join ",`r`n    "
[void]$sb.AppendLine("Export-ModuleMember -Function @(`r`n    $exportList`r`n)")

Write-Host "Writing module to: $OutputModulePath"
$OutputModulePath = [System.IO.Path]::GetFullPath($OutputModulePath)
$sb.ToString() | Set-Content $OutputModulePath -Encoding utf8 -Force

# Generate module manifest
Write-Host "Writing manifest to: $OutputManifestPath"
$OutputManifestPath = [System.IO.Path]::GetFullPath($OutputManifestPath)
$manifestParams = @{
    Path              = $OutputManifestPath
    RootModule        = [System.IO.Path]::GetFileName($OutputModulePath)
    ModuleVersion     = '0.1.0'
    Author            = 'Team Microsoft365DSC'
    Description       = 'Auto-generated Graph SDK shim module for Microsoft365DSC. Replaces typed Graph SDK cmdlets with Invoke-MgGraphRequest wrappers.'
    PowerShellVersion = '5.1'
    FunctionsToExport = $exportedFunctions.ToArray()
    CmdletsToExport   = @()
    AliasesToExport   = @()
    RequiredModules   = @('Microsoft.Graph.Authentication')
    Guid              = '730f252e-c4a5-4290-b1da-5d410df44e2d'
}
New-ModuleManifest @manifestParams

Write-Host "Done. Generated $generated wrappers, skipped $skipped."
Write-Host "Exported functions: $($exportedFunctions.Count)"
