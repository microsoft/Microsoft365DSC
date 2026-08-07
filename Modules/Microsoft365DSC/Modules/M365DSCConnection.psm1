[hashtable]$Script:M365DSCTelemetryConnectionToGraphParams = @{}

<#
.SYNOPSIS
    Gets all resources that support the specified authentication method and determines the most secure authentication method supported by the resource.

.DESCRIPTION
    This function gets all resources that support the specified authentication method and
    determines the most secure authentication method supported by the resource.

.PARAMETER AuthenticationMethod
    Specifies the authentication method to check for. Valid values are:
    'ApplicationWithSecret', 'CertificateThumbprint', 'CertificatePath', 'Credentials',
    'CredentialsWithTenantId', 'CredentialsWithApplicationId', 'ManagedIdentity', 'AccessTokens'.

.PARAMETER Resources
    Specifies the resources to check. If not specified, all resources will be checked.

.FUNCTIONALITY
    Internal
#>
function Get-M365DSCComponentsWithMostSecureAuthenticationType
{
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.List[System.Collections.Hashtable]])]
    param
    (
        [Parameter()]
        [System.String[]]
        [ValidateSet('ApplicationWithSecret', 'CertificateThumbprint', 'CertificatePath', 'Credentials', 'CredentialsWithTenantId', 'CredentialsWithApplicationId', 'ManagedIdentity', 'AccessTokens')]
        $AuthenticationMethod,

        [Parameter()]
        [System.String[]]
        $Resources
    )

    Initialize-M365DSCDllLoader -ErrorAction Stop

    $dscResourcesPath = Join-Path -Path $PSScriptRoot -ChildPath '../DscResources'
    return [Microsoft365DSC.Connection.ConnectionHelper]::GetComponentsWithMostSecureAuthenticationType(
        $dscResourcesPath,
        $AuthenticationMethod,
        $Resources
    )
}

<#
.SYNOPSIS
    Creates a new connection to the specified M365 workload.

.DESCRIPTION
    This function creates a new connection to the specified M365 workload

.PARAMETER Workload
    Specifies the M365 workload to connect to. Valid values are:
    'AdminAPI', 'Azure', 'AzureDevOPS', 'DefenderForEndpoint', 'EngageHub', 'ExchangeOnline',
    'Fabric', 'Licensing', 'SecurityComplianceCenter', 'PnP', 'PowerPlatforms',
    'PowerPlatformREST', 'MicrosoftTeams', 'MicrosoftGraph', 'SharePointOnlineREST', 'Tasks'.

.PARAMETER InboundParameters
    Specifies a hashtable of parameters to use for the connection. The keys and values in the hashtable should match the parameters of the Connect-M365Tenant function.

.PARAMETER Url
    Specifies the URL to use for the connection. This parameter is optional and can be used to override the default URL for the specified workload.

.PARAMETER EnableSearchOnlySession
    Specifies whether to enable a search-only session for the connection. This parameter is optional and can be used to limit the connection to read-only operations
    for the SecurityComplianceCenter workload.

.FUNCTIONALITY
    Internal
#>
function New-M365DSCConnection
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('AdminAPI', 'Azure', 'AzureDevOPS', 'DefenderForEndpoint', 'EngageHub', 'ExchangeOnline', 'Fabric', 'Licensing', `
                'SecurityComplianceCenter', 'PnP', 'PowerPlatforms', 'PowerPlatformREST', `
                'MicrosoftTeams', 'MicrosoftGraph', 'SharePointOnlineREST', 'Tasks')]
        [System.String]
        $Workload,

        [Parameter(Mandatory = $true)]
        [ValidateScript({
                if ($null -ne $_.Credential)
                {
                    $invalid = $_.Credential.Username -notmatch '.onmicrosoft.'
                    if (-not $invalid)
                    {
                        return $true
                    }
                    else
                    {
                        Write-Warning -Message 'We recommend providing the username in the format of <tenant>.onmicrosoft.* for the Credential property.'
                    }
                }

                if ($null -ne $_.TenantId)
                {
                    $isValid = [System.Guid]::TryParse($_.TenantId, [ref][System.Guid]::Empty)
                    if ($isValid)
                    {
                        throw 'Please provide the tenant name (e.g., contoso.onmicrosoft.com) for TenantId instead of its GUID.'
                    }

                    $isValid = $_.TenantId -match '.onmicrosoft.'
                    if ($isValid)
                    {
                        return $true
                    }
                    else
                    {
                        Write-Warning -Message 'We recommend providing the tenant name in format <tenant>.onmicrosoft.* for TenantId.'
                    }
                }
                return $true
            })]
        [System.Collections.Hashtable]
        $InboundParameters,

        [Parameter()]
        [System.String]
        $Url,

        [Parameter()]
        [switch]
        $EnableSearchOnlySession
    )

    if (-not (Test-IsM365DSCRequiredModulesLoaded))
    {
        $requiredModules = Get-M365DSCRequiredModules
        foreach ($requiredModule in $requiredModules)
        {
            Write-Verbose -Message "Ensuring required module '$requiredModule' is loaded."
            Confirm-M365DSCLoadedModule -ModuleName $requiredModule
        }
        Set-M365DSCRequiredModulesLoaded -Value $true
    }

    if ($Workload -eq 'MicrosoftTeams')
    {
        try
        {
            $null = Get-Command 'Connect-MicrosoftTeams' -ErrorAction Stop
        }
        catch
        {
            Import-Module 'MicrosoftTeams' -Global -Force -Alias @() -Cmdlet @() -Variable @() -DisableNameChecking | Out-Null
        }
    }

    Write-Verbose -Message "Attempting connection to {$Workload} with:"
    Write-Verbose -Message "$($InboundParameters | Out-String)"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[System.String], [System.Object]]]::new()
    $data.Add('Source', 'M365DSCUtil')
    $data.Add('Workload', $Workload)

    $Script:M365DSCTelemetryConnectionToGraphParams = @{}

    # Keep track of workloads we already connected so that we don't send additional Telemetry events.
    if ($null -eq $Script:M365ConnectedToWorkloads)
    {
        Write-Verbose -Message 'Initializing the Connected To Workloads List.'
        $Script:M365ConnectedToWorkloads = @()
    }

    # Convert ApplicationSecret from SecureString to plain string for MSCloudLoginAssistant
    if (-not [System.String]::IsNullOrEmpty($InboundParameters.ApplicationSecret))
    {
        if ($InboundParameters.ApplicationSecret -is [System.Management.Automation.PSCredential])
        {
            $InboundParameters.ApplicationSecret = ConvertFrom-SecureString -SecureString $InboundParameters.ApplicationSecret.Password -AsPlainText
        }
    }

    #region Validation
    if (-not [System.String]::IsNullOrEmpty($InboundParameters.Credential) -and `
            -not [System.String]::IsNullOrEmpty($InboundParameters.CertificateThumbprint))
    {
        $message = 'Both Authentication methods are attempted'
        Write-Verbose -Message $message
        $data.Add('Exception', $message)
        $errorText = "You can't specify both the Credential and CertificateThumbprint"
        $data.Add('CustomMessage', $errorText)
        Add-M365DSCTelemetryEvent -Type 'Error' -Data $data
        throw $errorText
    }

    if ([System.String]::IsNullOrEmpty($InboundParameters.Credential) -and `
            [System.String]::IsNullOrEmpty($InboundParameters.ApplicationId) -and `
            [System.String]::IsNullOrEmpty($InboundParameters.TenantId) -and `
            [System.String]::IsNullOrEmpty($InboundParameters.CertificateThumbprint) -and `
            -not $InboundParameters.ManagedIdentity -and `
            [System.String]::IsNullOrEmpty($InboundParameters.AccessTokens))
    {
        $message = 'No Authentication method was provided'
        Write-Verbose -Message $message
        $message += "`r`nProvided Keys --> $($InboundParameters.Keys)"
        $data.Add('Exception', $message)
        $errorText = 'You must specify either the Credential or ApplicationId, TenantId and CertificateThumbprint parameters.'
        $data.Add('CustomMessage', $errorText)
        Add-M365DSCTelemetryEvent -Type 'Error' -Data $data
        throw $errorText
    }
    #endregion Validation

    # Determine connection mode using the shared helper.
    $connectionMode = Get-M365DSCAuthenticationMode -Parameters $InboundParameters
    if ($connectionMode -eq 'Interactive')
    {
        throw 'Could not determine authentication method'
    }
    Write-Verbose -Message "Connecting via $connectionMode"

    #region Build Connect-M365Tenant splat
    $connectParams = @{
        Workload                = $Workload
        EnableSearchOnlySession = $EnableSearchOnlySession.IsPresent
    }

    if (-not [System.String]::IsNullOrEmpty($Url))
    {
        $connectParams.Url = $Url
    }

    if ($Workload -eq 'Azure' -and -not [System.String]::IsNullOrEmpty($InboundParameters.SubscriptionId))
    {
        $connectParams.SubscriptionId = $InboundParameters.SubscriptionId
    }

    switch ($connectionMode)
    {
        'Credentials'
        {
            $connectParams.Credential = $InboundParameters.Credential
        }
        'CredentialsWithApplicationId'
        {
            $connectParams.ApplicationId = $InboundParameters.ApplicationId
            $connectParams.Credential = $InboundParameters.Credential
        }
        'CredentialsWithTenantId'
        {
            $connectParams.TenantId = $InboundParameters.TenantId
            $connectParams.Credential = $InboundParameters.Credential
        }
        'ServicePrincipalWithPath'
        {
            $connectParams.ApplicationId = $InboundParameters.ApplicationId
            $connectParams.TenantId = $InboundParameters.TenantId
            $connectParams.CertificatePassword = $InboundParameters.CertificatePassword.Password
            $connectParams.CertificatePath = $InboundParameters.CertificatePath
        }
        'ServicePrincipalWithSecret'
        {
            $connectParams.ApplicationId = $InboundParameters.ApplicationId
            $connectParams.TenantId = $InboundParameters.TenantId
            $connectParams.ApplicationSecret = $InboundParameters.ApplicationSecret
        }
        'ServicePrincipalWithThumbprint'
        {
            $connectParams.ApplicationId = $InboundParameters.ApplicationId
            $connectParams.TenantId = $InboundParameters.TenantId
            $connectParams.CertificateThumbprint = $InboundParameters.CertificateThumbprint
        }
        'ManagedIdentity'
        {
            $connectParams.Identity = $true
            $connectParams.TenantId = $InboundParameters.TenantId
        }
        'AccessTokens'
        {
            $connectParams.AccessTokens = $InboundParameters.AccessTokens
            $connectParams.TenantId = $InboundParameters.TenantId
        }
    }
    #endregion

    Connect-M365Tenant @connectParams

    #region Update telemetry cache
    $telemetryCacheKeys = switch ($connectionMode)
    {
        'Credentials'                    { @('Credential') }
        'CredentialsWithApplicationId'   { @('Credential', 'ApplicationId') }
        'CredentialsWithTenantId'        { @('Credential', 'TenantId') }
        'ServicePrincipalWithPath'       { @('ApplicationId', 'TenantId', 'CertificatePath') }
        'ServicePrincipalWithSecret'     { @('ApplicationId', 'TenantId', 'ApplicationSecret') }
        'ServicePrincipalWithThumbprint' { @('ApplicationId', 'TenantId', 'CertificateThumbprint') }
        'ManagedIdentity'                { @('TenantId') }
        'AccessTokens'                   { @('AccessTokens', 'TenantId') }
    }

    foreach ($key in $telemetryCacheKeys)
    {
        if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey($key) -and
            $null -ne $InboundParameters[$key])
        {
            $Script:M365DSCTelemetryConnectionToGraphParams.Add($key, $InboundParameters[$key])
        }
    }

    # Handle special telemetry cache values not directly from InboundParameters.
    if ($connectionMode -eq 'ManagedIdentity' -and
        -not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('Identity'))
    {
        $Script:M365DSCTelemetryConnectionToGraphParams.Add('Identity', $true)
    }
    if ($ConnectionMode -eq 'ServicePrincipalWithSecret' -and
        -not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('ApplicationSecret'))
    {
        $Script:M365DSCTelemetryConnectionToGraphParams.Add('ApplicationSecret', $InboundParameters.ApplicationSecret.Password)
    }
    if ($connectionMode -eq 'ServicePrincipalWithPath' -and
        -not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('CertificatePassword'))
    {
        $Script:M365DSCTelemetryConnectionToGraphParams.Add('CertificatePassword', $InboundParameters.CertificatePassword.Password)
    }
    #endregion

    #region Emit connection telemetry
    # The Credentials mode uses 'Credential' (no trailing 's') as tracking key for backward compatibility.
    $trackingKey = if ($connectionMode -eq 'Credentials') { 'Credential' } else { $connectionMode }
    $workloadTrackingKey = "$Workload-$trackingKey"

    if (-not ($Script:M365ConnectedToWorkloads -contains $workloadTrackingKey))
    {
        $data.Add('ConnectionMode', $connectionMode)

        if (-not $data.ContainsKey('Tenant'))
        {
            if (-not [System.String]::IsNullOrEmpty($InboundParameters.TenantId))
            {
                $data.Add('Tenant', $InboundParameters.TenantId)
            }
            elseif ($null -ne $InboundParameters.Credential)
            {
                try
                {
                    $tenantId = $InboundParameters.Credential.Username.Split('@')[1]
                    $data.Add('Tenant', $tenantId)
                    if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('TenantId'))
                    {
                        $Script:M365DSCTelemetryConnectionToGraphParams.Add('TenantId', $tenantId)
                    }
                }
                catch
                {
                    Write-Verbose -Message $_
                }
            }
        }

        Add-M365DSCTelemetryEvent -Data $data -Type 'Connection'
        $Script:M365ConnectedToWorkloads += $workloadTrackingKey
    }
    #endregion

    return $connectionMode
}

<#
.SYNOPSIS
    Gets the authentication mode based on the specified parameters.

.DESCRIPTION
    This function gets the used authentication mode based on the specified parameters

.PARAMETER Parameters
    Specifies a hashtable of parameters to use for determining the authentication mode. The keys and values in the hashtable should match the parameters of the Connect-M365Tenant function.

.FUNCTIONALITY
    Internal
#>
function Get-M365DSCAuthenticationMode
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Parameters
    )

    # Cache frequently accessed values to reduce hashtable lookups
    $applicationId = $Parameters.ApplicationId
    $tenantId = $Parameters.TenantId
    $credential = $Parameters.Credential

    # Check service principal authentication modes first (most common in automation)
    if ($applicationId -and $tenantId)
    {
        if ($Parameters.CertificateThumbprint)
        {
            return 'ServicePrincipalWithThumbprint'
        }
        if ($Parameters.ApplicationSecret)
        {
            return 'ServicePrincipalWithSecret'
        }
        if ($Parameters.CertificatePath -and $Parameters.CertificatePassword)
        {
            return 'ServicePrincipalWithPath'
        }
    }

    # Check credential-based authentication
    if ($credential)
    {
        if ($applicationId)
        {
            return 'CredentialsWithApplicationId'
        }
        if ($tenantId)
        {
            return 'CredentialsWithTenantId'
        }
        return 'Credentials'
    }

    # Check other authentication modes
    if ($Parameters.ManagedIdentity)
    {
        return 'ManagedIdentity'
    }

    if ($Parameters.AccessTokens)
    {
        return 'AccessTokens'
    }

    # Default to interactive
    return 'Interactive'
}

<#
.SYNOPSIS
    Retrieves the telemetry connection parameters for the current session.

.DESCRIPTION
    This function retrieves the telemetry connection parameters for the current session.

.FUNCTIONALITY
    Internal.
#>
function Get-M365DSCTelemetryConnectionParameter
{
    [CmdletBinding()]
    param ()

    $Script:M365DSCTelemetryConnectionToGraphParams.Clone()
}

<#
.SYNOPSIS
    Sets the telemetry connection parameters for the current session.

.DESCRIPTION
    This function sets the telemetry connection parameters for the current session.

.PARAMETER Parameters
    Specifies a hashtable of parameters to set for the telemetry connection. The keys and values in the hashtable should match the parameters of the Connect-M365Tenant function.

.FUNCTIONALITY
    Internal.
#>
function Set-M365DSCTelemetryConnectionParameter
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [hashtable]$Parameters
    )

    $Script:M365DSCTelemetryConnectionToGraphParams = $Parameters.Clone()
}

Export-ModuleMember -Function @(
    'Get-M365DSCAuthenticationMode',
    'Get-M365DSCComponentsWithMostSecureAuthenticationType',
    'Get-M365DSCFunctionParameterNamesByAST',
    'Get-M365DSCTelemetryConnectionParameter',
    'New-M365DSCConnection',
    'Set-M365DSCTelemetryConnectionParameter'
)
