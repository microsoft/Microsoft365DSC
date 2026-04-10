<#
.DESCRIPTION
    This function gets the onmicrosoft.com name of the tenant

.FUNCTIONALITY
    Internal
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
            $defaultDomain = $tenantDetails.verifiedDomains | Where-Object -FilterScript { $_.isInitial }

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
.DESCRIPTION
    This function retrieves the current tenant's name based on received authentication parameters.

.FUNCTIONALITY
    Internal
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
.DESCRIPTION
    This function gets the DNS domain used in the specified credential

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
.DESCRIPTION
    This function gets the name of the M365 tenant

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
.DESCRIPTION
    This function retrieves the various endpoint urls based on the cloud environment.

.EXAMPLE
    PS> Get-M365DSCAPIEndpoint -TenantId 'contoso.onmicrosoft.com'

.FUNCTIONALITY
    Private
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
.DESCRIPTION
    This function gets the URL of the SPO Administration site

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
