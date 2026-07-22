<#
.SYNOPSIS
    Resolves the initial onmicrosoft tenant domain.

.DESCRIPTION
    Retrieves the tenant's initial domain through Microsoft Graph when connection parameters support it.
    When a certificate path is provided and the tenant id already contains onmicrosoft, it returns the tenant id directly.

.PARAMETER ApplicationId
    Specifies the application id used for app-based authentication.

.PARAMETER TenantId
    Specifies the tenant id or tenant domain.

.PARAMETER ApplicationSecret
    Specifies the application secret used for app-based authentication.

.PARAMETER CertificateThumbprint
    Specifies the certificate thumbprint used for app-based authentication.

.PARAMETER CertificatePath
    Specifies the certificate file path used for app-based authentication.

.PARAMETER ManagedIdentity
    Indicates that managed identity authentication should be used.

.FUNCTIONALITY
    Internal

.OUTPUTS
    System.String
#>
function Get-M365DSCTenantDomain
{
    [CmdletBinding(DefaultParameterSetName = 'AppId')]
    [OutputType([System.String])]
    param
    (
        [Parameter(ParameterSetName = 'AppId', Mandatory = $true)]
        [System.String]
        $ApplicationId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId,

        [Parameter(ParameterSetName = 'AppId')]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter(ParameterSetName = 'AppId')]
        [System.String]
        $CertificateThumbprint,

        [Parameter(ParameterSetName = 'AppId')]
        [System.String]
        $CertificatePath,

        [Parameter(ParameterSetName = 'MID')]
        [Switch]
        $ManagedIdentity
    )

    if ([System.String]::IsNullOrEmpty($CertificatePath))
    {
        $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters

        try
        {
            $tenantDetails = (Invoke-MgGraphRequest -Uri '/beta/organization' -Method GET -ErrorAction 'Stop').value
            $defaultDomain = $tenantDetails.verifiedDomains | Where-Object -Property isInitial -EQ $true

            return $defaultDomain.name
        }
        catch
        {
            if ($_.Exception.Message -eq 'Insufficient privileges to complete the operation.')
            {
                New-M365DSCLogEntry `
                    -Message 'Error retrieving Organizational information: Missing Organization.Read.All permission. ' `
                    -Exception $_ `
                    -Source $($MyInvocation.MyCommand.Source) `
                    -TenantId $TenantId `
                    -Credential $Credential

                return [System.String]::Empty
            }

            throw $_
        }
    }

    if ($TenantId.Contains('onmicrosoft'))
    {
        return $TenantId
    }
    else
    {
        throw 'TenantID must be in format contoso.onmicrosoft.com'
    }
}

<#
.SYNOPSIS
    Derives the tenant name from a bound parameter set.

.DESCRIPTION
    Returns the tenant identifier directly when TenantId is present.
    Otherwise, it derives the tenant name from the credential user principal name.

.PARAMETER ParameterSet
    Specifies the bound parameter hashtable to inspect.

.FUNCTIONALITY
    Internal

.OUTPUTS
    System.String
#>
function Get-M365DSCTenantNameFromParameterSet
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true, Position = 1)]
        [System.Collections.HashTable]
        $ParameterSet
    )

    if ($ParameterSet.ContainsKey('TenantId'))
    {
        return $ParameterSet.TenantId
    }
    elseif ($ParameterSet.ContainsKey('Credential'))
    {
        try
        {
            $tenantName = $ParameterSet.Credential.Username.Split('@')[1]
            return $tenantName
        }
        catch
        {
            return $null
        }
    }
}

<#
.SYNOPSIS
    Resolves the organization domain from credential or tenant id.

.DESCRIPTION
    Extracts the DNS domain part from the credential username when available.
    If no credential is provided, it validates and returns the tenant id when it represents a domain value.

.PARAMETER Credential
    Specifies the credential containing a user principal name.

.PARAMETER TenantId
    Specifies the tenant id or domain value to return.

.FUNCTIONALITY
    Internal
#>
function Get-M365DSCOrganization
{
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $TenantId
    )

    if ($null -ne $Credential -and $Credential.UserName.Contains('@'))
    {
        $organization = $Credential.UserName.Split('@')[1]
        return $organization
    }

    if (-not [System.String]::IsNullOrEmpty($TenantId))
    {
        if ($TenantId.Contains('.'))
        {
            $organization = $TenantId
            return $organization
        }
        else
        {
            throw 'Tenant ID must be name of the tenant, e.g. contoso.onmicrosoft.com'
        }

    }
}

<#
.SYNOPSIS
    Retrieves the tenant short name from initial Microsoft Graph domains.

.DESCRIPTION
    Connects to Microsoft Graph and finds the initial onmicrosoft domain.
    Returns the tenant short name portion that is used to build workload-specific endpoints.

.PARAMETER UseMFA
    Indicates that interactive multi-factor authentication should be used.

.PARAMETER Credential
    Specifies the credential used for delegated authentication.

.FUNCTIONALITY
    Internal
#>
function Get-M365TenantName
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [switch]
        $UseMFA,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    $UseMFASwitch = @{}
    if ($UseMFA)
    {
        $UseMFASwitch.Add('UseMFA', $true)
    }

    Write-Verbose -Message 'Connection to Azure AD is required to automatically determine SharePoint Online admin URL...'
    $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters
    Write-Verbose -Message 'Getting SharePoint Online admin URL...'
    $domain = Invoke-MgGraphRequest -Uri 'beta/domains' -Method GET
    [Array]$defaultDomain = $domain | Where-Object { ($_.id -like '*.onmicrosoft.com' -or $_.id -like '*.onmicrosoft.de') -and $_.isInitial -eq $true } # We don't use IsDefault here because the default could be a custom domain

    if ($defaultDomain[0].id -like '*.onmicrosoft.com*')
    {
        $tenantName = $defaultDomain[0].id -replace '.onmicrosoft.com', ''
    }
    elseif ($defaultDomain[0].id -like '*.onmicrosoft.de*')
    {
        $tenantName = $defaultDomain[0].id -replace '.onmicrosoft.de', ''
    }

    Write-Verbose -Message "M365 tenant name is $tenantName"
    return $tenantName
}

<#
.SYNOPSIS
    Resolves API endpoint base URLs for a tenant cloud region.

.DESCRIPTION
    Reads the tenant OpenID metadata to detect regional scope and returns endpoint values used by Microsoft365DSC.
    Currently resolves the Azure management endpoint with sovereign cloud handling.

.PARAMETER TenantId
    Specifies the tenant id or tenant domain used to query OpenID metadata.

.EXAMPLE
    PS> Get-M365DSCAPIEndpoint -TenantId 'contoso.onmicrosoft.com'

.FUNCTIONALITY
    Internal

.OUTPUTS
    System.Collections.Hashtable
#>
function Get-M365DSCAPIEndpoint
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId
    )

    try
    {
        $webrequest = Invoke-WebRequest -Uri "https://login.windows.net/$($TenantId)/.well-known/openid-configuration" -UseBasicParsing
        $response = ConvertFrom-Json $webrequest.Content
        $tenantRegionScope = $response.'tenant_region_scope'

        $endpoints = @{
            AzureManagement = $null
        }

        switch ($tenantRegionScope)
        {
            'USGov'
            {
                if ($null -ne $response.'tenant_region_sub_scope' -and $response.'tenant_region_sub_scope' -eq 'DODCON')
                {
                    $endpoints.AzureManagement = 'https://management.usgovcloudapi.net'
                }
            }
            default
            {
                $endpoints.AzureManagement = 'https://management.azure.com'
            }
        }
        return $endpoints
    }
    catch
    {
        throw $_
    }
}

<#
.SYNOPSIS
    Retrieves the SharePoint Online administration URL.

.DESCRIPTION
    Connects to Microsoft Graph, discovers the initial tenant domain, and builds the SharePoint admin URL.
    Returns the URL in the https://tenant-admin.sharepoint.com format.

.PARAMETER UseMFA
    Indicates that interactive multi-factor authentication should be used.

.PARAMETER Credential
    Specifies the credential used for delegated authentication.

.FUNCTIONALITY
    Internal
#>
function Get-SPOAdministrationUrl
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [switch]
        $UseMFA,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    $UseMFASwitch = @{}
    if ($UseMFA)
    {
        $UseMFASwitch.Add('UseMFA', $true)
    }

    Write-Verbose -Message 'Connection to Azure AD is required to automatically determine SharePoint Online admin URL...'
    $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters
    Write-Verbose -Message 'Getting SharePoint Online admin URL...'
    $domain = Invoke-MgGraphRequest -Uri 'beta/domains' -Method GET
    [Array]$defaultDomain = $domain | Where-Object { ($_.id -like '*.onmicrosoft.com' -or $_.id -like '*.onmicrosoft.de' -or $_.id -like '*.onmicrosoft.us') -and $_.isInitial -eq $true } # We don't use IsDefault here because the default could be a custom domain

    if ($defaultDomain[0].id -like '*.onmicrosoft.com*')
    {
        $global:tenantName = $defaultDomain[0].id -replace '.onmicrosoft.com', ''
    }
    elseif ($defaultDomain[0].id -like '*.onmicrosoft.de*')
    {
        $global:tenantName = $defaultDomain[0].id -replace '.onmicrosoft.de', ''
    }
    $global:AdminUrl = "https://$global:tenantName-admin.sharepoint.com"
    Write-Verbose -Message "SharePoint Online admin URL is $global:AdminUrl"
    return $global:AdminUrl
}

Export-ModuleMember -Function @(
    'Get-M365DSCTenantDomain',
    'Get-M365DSCTenantNameFromParameterSet',
    'Get-M365DSCOrganization',
    'Get-M365TenantName',
    'Get-M365DSCAPIEndpoint',
    'Get-SPOAdministrationUrl'
)
