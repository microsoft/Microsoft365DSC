$Script:M365DSCStringReplacementMap = @{}
$Script:M365DSCMandatoryKeyCache = @{}
$Script:M365DSCCompiledRegexCache = @{}
$Script:M365DSCAuthenticationParameterSet = @{
    ServicePrincipalWithThumbprint = @('ApplicationId', 'CertificateThumbprint', 'TenantId')
    ServicePrincipalWithSecret = @('ApplicationId', 'ApplicationSecret', 'TenantId')
    ServicePrincipalWithPath = @('ApplicationId', 'CertificatePath', 'CertificatePassword', 'TenantId')
    CredentialsWithTenantId = @('Credential', 'TenantId')
    CredentialsWithApplicationId = @('Credential', 'ApplicationId')
    Credentials = @('Credential')
    ManagedIdentity = @('ManagedIdentity', 'TenantId')
    AccessTokens = @('AccessTokens', 'TenantId')
}
$templatesPath = Join-Path -Path $PSScriptRoot -ChildPath 'M365DSCRelationTemplates.json'
$jsonContent = Get-Content -Path $templatesPath -Raw | ConvertFrom-Json
$Script:RelationTemplates = @{
    templates = @{}
}
foreach ($template in $jsonContent.templates.psobject.Properties)
{
    $Script:RelationTemplates.templates[$template.Name] = $template.Value
}
$allResourcesArgumentCompleter = Get-ChildItem -Path ($PSScriptRoot + '/../DscResources/') -Recurse -Filter '*.psm1' -File | Foreach-Object {
    $_.Name -replace 'MSFT_', '' -replace '.psm1', ''
}
Register-ArgumentCompleter -CommandName Export-M365DSCConfiguration -ParameterName Components -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $resources = $allResourcesArgumentCompleter -like "$wordToComplete*"
    foreach ($resource in $resources)
    {
        [System.Management.Automation.CompletionResult]::new($resource, $resource, 'ParameterValue', $resource)
    }
}

<#
.SYNOPSIS
    Exports tenant configuration to Microsoft365DSC configuration content.

.DESCRIPTION
    Entry point for ReverseDSC export.
    Validates authentication inputs, resolves target resources, executes extraction, and returns the generated configuration content.

.PARAMETER LaunchWebUI
    Indicates that the export Web UI should be launched.

.PARAMETER Path
    Specifies the output path for exported configuration files.

.PARAMETER FileName
    Specifies the output configuration file name.

.PARAMETER ConfigurationName
    Specifies the generated DSC configuration name.

.PARAMETER Components
    Specifies component names to export.

.PARAMETER ExcludeComponents
    Specifies component names to exclude.

.PARAMETER Workloads
    Specifies workloads used to derive components.

.PARAMETER Mode
    Specifies the export mode.

.PARAMETER GenerateInfo
    Indicates whether informational metadata should be generated in export output.

.PARAMETER Filters
    Specifies resource-level filters used during export.

.PARAMETER ApplicationId
    Specifies the application id used for app-based authentication.

.PARAMETER TenantId
    Specifies the tenant id or tenant domain used for authentication.

.PARAMETER ApplicationSecret
    Specifies the application secret used for app-based authentication.

.PARAMETER CertificateThumbprint
    Specifies the certificate thumbprint used for app-based authentication.

.PARAMETER Credential
    Specifies delegated credentials used for authentication.

.PARAMETER CertificatePassword
    Specifies the password used to read the certificate file.

.PARAMETER CertificatePath
    Specifies the certificate file path used for app-based authentication.

.PARAMETER ManagedIdentity
    Indicates that managed identity authentication should be used.

.PARAMETER AccessTokens
    Specifies one or more pre-acquired access tokens.

.PARAMETER SubscriptionId
    Specifies the Azure subscription id used by Azure resources.

.PARAMETER Validate
    Indicates whether the exported configuration should be validated.

.PARAMETER Parallel
    Indicates whether export should execute in parallel.

.PARAMETER TokenReplacement
    Specifies token replacement mappings applied to exported content.

.PARAMETER WithStatistics
    Indicates whether export statistics should be collected.

.PARAMETER IncludeDependencies
    Indicates whether dependency extraction and DependsOn generation should run.

.EXAMPLE
    PS> Export-M365DSCConfiguration -Components @("AADApplication", "AADConditionalAccessPolicy", "AADGroupsSettings") -Credential $Credential

.EXAMPLE
    PS> Export-M365DSCConfiguration -Mode 'Default' -ApplicationId '2560bb7c-bc85-415f-a799-841e10ec4f9a' -TenantId 'contoso.sharepoint.com' -ApplicationSecret 'abcdefghijkl'

.EXAMPLE
    PS> Export-M365DSCConfiguration -Components @("AADApplication", "AADConditionalAccessPolicy", "AADGroupsSettings") -Credential $Credential -Path 'C:\DSC' -FileName 'MyConfig.ps1'

.EXAMPLE
    PS> Export-M365DSCConfiguration -Credential $Credential -Filters @{AADApplication = "DisplayName eq 'MyApp'"} -TokenReplacement @{ 'alternate-email.onmicrosoft.com' = 'AlternateEmail' }

.EXAMPLE
    PS> Export-M365DSCConfiguration -Workloads @("SPO") -ExcludeComponents @("SPOPropertyBag") -Credential $Credential

.EXAMPLE
    PS> Export-M365DSCConfiguration -Workloads @("SPO") -ApplicationId $clientId -TenantId $tenantName -CertificateThumbprint $certThumbprint -IncludeDependencies

.FUNCTIONALITY
    Public
#>
function Export-M365DSCConfiguration
{
    [CmdletBinding(DefaultParameterSetName = 'Export')]
    param
    (
        [Parameter(ParameterSetName = 'WebUI')]
        [Switch]
        $LaunchWebUI,

        [Parameter(ParameterSetName = 'Export')]
        [System.String]
        $Path,

        [Parameter(ParameterSetName = 'Export')]
        [System.String]
        $FileName,

        [Parameter(ParameterSetName = 'Export')]
        [System.String]
        $ConfigurationName,

        [Parameter(ParameterSetName = 'Export')]
        [System.String[]]
        $Components,

        [Parameter(ParameterSetName = 'Export')]
        [System.String[]]
        $ExcludeComponents,

        [Parameter(ParameterSetName = 'Export')]
        [ValidateSet('AAD', 'ADO', 'AZURE', 'COMMERCE', 'DEFENDER', 'EXO', 'FABRIC', 'INTUNE', 'O365', 'OD', 'PLANNER', 'PP', 'SC', 'SENTINEL', 'SH', 'SPO', 'TEAMS', 'VIVA')]
        [System.String[]]
        $Workloads,

        [Parameter(ParameterSetName = 'Export')]
        [ValidateSet('Default', 'Full')]
        [System.String]
        $Mode = 'Default',

        [Parameter(ParameterSetName = 'Export')]
        [System.Boolean]
        $GenerateInfo = $false,

        [Parameter(ParameterSetName = 'Export')]
        [System.Collections.Hashtable]
        $Filters,

        [Parameter(ParameterSetName = 'Export')]
        [System.String]
        $ApplicationId,

        [Parameter(ParameterSetName = 'Export')]
        [ValidateScript({
                $invalid = $false
                if ([System.Guid]::TryParse($_, [ref][System.Guid]::Empty))
                {
                    throw 'Please provide the tenant name (e.g., contoso.onmicrosoft.com) for TenantId instead of its GUID.'
                }
                $invalid = $_ -notmatch '.onmicrosoft.'
                if ($invalid)
                {
                    Write-Warning -Message 'We recommend providing the TenantId property in the format of <tenant>.onmicrosoft.*'
                }
                return $true
            })]
        [System.String]
        $TenantId,

        # TODO: Change to PSCredential during next breaking change
        [Parameter(ParameterSetName = 'Export')]
        [System.String]
        $ApplicationSecret,

        [Parameter(ParameterSetName = 'Export')]
        [System.String]
        $CertificateThumbprint,

        [Parameter(ParameterSetName = 'Export')]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter(ParameterSetName = 'Export')]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter(ParameterSetName = 'Export')]
        [System.String]
        $CertificatePath,

        [Parameter(ParameterSetName = 'Export')]
        [Switch]
        $ManagedIdentity,

        [Parameter(ParameterSetName = 'Export')]
        [System.String[]]
        $AccessTokens,

        [Parameter(ParameterSetName = 'Export')]
        [System.String]
        $SubscriptionId,

        [Parameter(ParameterSetName = 'Export')]
        [Switch]
        $Validate,

        [Parameter(ParameterSetName = 'Export')]
        [Switch]
        $Parallel,

        [Parameter(ParameterSetName = 'Export')]
        [System.Collections.Hashtable]
        $TokenReplacement,

        [Parameter(ParameterSetName = 'Export')]
        [Switch]
        $WithStatistics,

        [Parameter(ParameterSetName = 'Export')]
        [Switch]
        $IncludeDependencies
    )

    if ($IncludeDependencies.IsPresent)
    {
        Write-Warning -Message "The -IncludeDependencies parameter is currently in preview. Please review the generated configuration to ensure it captures the dependencies as expected.
         If you encounter any issues or have feedback, please report it at https://github.com/Microsoft365DSC/Microsoft365DSC."
    }

    $currentStartDateTime = [System.DateTime]::Now
    $Global:M365DSCExportInProgress = $true
    $Global:MaximumFunctionCount = 32767

    Clear-M365DSCHostMessageCache

    # Define the exported resource instances' names Global variable
    $Global:M365DSCExportedResourceInstancesNames = [System.Collections.Generic.HashSet[System.String]]::new([System.StringComparer]::OrdinalIgnoreCase)

    # Clear performance caches for fresh export
    $Script:M365DSCMandatoryKeyCache = @{}
    $Script:M365DSCCompiledRegexCache = @{}

    # Define the exported resource instances registry for DependsOn tracking
    $Global:M365DSCExportedResourceInstances = @{}

    # Define the export dependencies collector
    $Global:M365DSCExportDependencies = @()

    # LaunchWebUI specified, launching that now
    if ($LaunchWebUI)
    {
        Write-Output -InputObject "Launching web page 'https://export.microsoft365dsc.com'"
        explorer 'https://export.microsoft365dsc.com'
        return
    }

    # Suppress Progress overlays
    $Global:ProgressPreference = 'SilentlyContinue'

    # Check ErrorActionPreference - Azure DevOps and other Pipeline environments set it to 'Stop' by default
    if ($ErrorActionPreference -eq 'Stop' -and -not $PSBoundParameters.ContainsKey('ErrorAction'))
    {
        $ErrorActionPreference = 'Continue'
    }

    ##### FIRST CHECK AUTH PARAMETERS
    if ($PSBoundParameters.ContainsKey('Credential') -eq $true -and `
            -not [System.String]::IsNullOrEmpty($Credential))
    {
        if ($Credential.Username -notmatch '.onmicrosoft.')
        {
            Write-Warning -Message 'We recommend providing the username in the format of <tenant>.onmicrosoft.* for the Credential property.'
        }
    }

    if ($PSBoundParameters.ContainsKey('CertificatePath') -eq $true -and `
            $PSBoundParameters.ContainsKey('CertificatePassword') -eq $false)
    {
        throw 'You have to specify CertificatePassword when you specify CertificatePath'
    }

    if ($PSBoundParameters.ContainsKey('CertificatePassword') -eq $true -and `
            $PSBoundParameters.ContainsKey('CertificatePath') -eq $false)
    {
        throw 'You have to specify CertificatePath when you specify CertificatePassword'
    }

    if ($PSBoundParameters.ContainsKey('ApplicationId') -eq $true -and `
            $PSBoundParameters.ContainsKey('Credential') -eq $false -and `
            $PSBoundParameters.ContainsKey('TenantId') -eq $false)
    {
        throw 'You have to specify TenantId when you specify ApplicationId'
    }

    if ($PSBoundParameters.ContainsKey('ApplicationId') -eq $true -and `
            $PSBoundParameters.ContainsKey('TenantId') -eq $true -and `
            $PSBoundParameters.ContainsKey('Credential') -eq $false -and `
        ($PSBoundParameters.ContainsKey('CertificateThumbprint') -eq $false -and `
                $PSBoundParameters.ContainsKey('ApplicationSecret') -eq $false -and `
                $PSBoundParameters.ContainsKey('CertificatePath') -eq $false))
    {
        throw 'You have to specify ApplicationSecret, CertificateThumbprint or CertificatePath when you specify ApplicationId/TenantId'
    }

    if (($PSBoundParameters.ContainsKey('ApplicationId') -eq $false -or `
                $PSBoundParameters.ContainsKey('TenantId') -eq $false) -and `
        ($PSBoundParameters.ContainsKey('Credential') -eq $false -and `
                $PSBoundParameters.ContainsKey('CertificateThumbprint') -eq $true -or `
                $PSBoundParameters.ContainsKey('ApplicationSecret') -eq $true -or `
                $PSBoundParameters.ContainsKey('CertificatePath') -eq $true))
    {
        throw 'You have to specify ApplicationId and TenantId when you specify ApplicationSecret, CertificateThumbprint or CertificatePath'
    }

    # Default to Credential if no authentication mechanism were provided
    if ($PSBoundParameters.ContainsKey('Credential') -eq $false -and `
            $ManagedIdentity.IsPresent -eq $false -and `
            $PSBoundParameters.ContainsKey('ApplicationId') -eq $false -and `
            $PSBoundParameters.ContainsKey('AccessTokens') -eq $false)
    {
        $Credential = Get-Credential
    }

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[System.String], [System.Object]]]::new()

    $data.Add('Path', [System.String]::IsNullOrEmpty($Path))
    $data.Add('FileName', $null -ne [System.String]::IsNullOrEmpty($FileName))
    $data.Add('Components', $Components)
    $data.Add('Workloads', $Workloads)
    #endregion

    Confirm-M365DSCDependencies

    # Make sure we are not connected to Microsoft Graph on another tenant
    # except if connected through MSCloudLoginAssistant - it will handle the connection
    try
    {
        Confirm-M365DSCLoadedModule -ModuleName 'Microsoft.Graph.Authentication'
        $currentConnectionProfile = Get-MSCloudLoginConnectionProfile -Workload 'MicrosoftGraph'
        if ($null -ne (Get-MgContext) -and -not $currentConnectionProfile.Connected)
        {
            Disconnect-MgGraph -ErrorAction Stop | Out-Null
            Reset-MSCloudLoginConnectionProfileContext -Workload 'MicrosoftGraph'
        }
    }
    catch
    {
        Write-Verbose -Message 'No existing connections to Microsoft Graph'
    }

    $Tenant = Get-M365DSCTenantNameFromParameterSet -ParameterSet $PSBoundParameters
    $Script:ConnectionMode = Get-M365DSCAuthenticationMode $PSBoundParameters
    $data.Add('Tenant', $Tenant)
    $currentExportID = (New-Guid).ToString()
    $data.Add('M365DSCExportId', $currentExportID)
    $data.Add('ConnectionMode', $Script:ConnectionMode)

    $telemetryParams = Get-M365DSCTelemetryConnectionParameter
    # Define connection to Graph parameters because it is required by the telemetry.
    if ($null -eq $telemetryParams -or `
        ($null -ne $telemetryParams -and `
                $telemetryParams.Keys.Count -eq 0))
    {
        $telemetryParams = @{
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            Identity              = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
        Set-M365DSCTelemetryConnectionParameter -Parameters $telemetryParams
    }

    Add-M365DSCTelemetryEvent -Type 'ExportInitiated' -Data $data
    Initialize-M365DSCAllResourcesDictionary
    if ($PSBoundParameters.ContainsKey('TokenReplacement'))
    {
        Set-M365DSCStringReplacementMap -Map $TokenReplacement
    }

    $resourceSettings = Get-M365DSCResourceSettings
    if ($null -ne $Workloads)
    {
        Write-M365DSCHost -Message "Exporting Microsoft 365 configuration for Workloads: $($Workloads -join ', ')"
        Start-M365DSCConfigurationExtract -Credential $Credential `
            -Workloads $Workloads `
            -ExcludeComponents $ExcludeComponents `
            -Mode $Mode `
            -Path $Path -FileName $FileName `
            -ConfigurationName $ConfigurationName `
            -ApplicationId $ApplicationId `
            -ApplicationSecret $ApplicationSecret `
            -TenantId $TenantId `
            -CertificateThumbprint $CertificateThumbprint `
            -CertificatePath $CertificatePath `
            -CertificatePassword $CertificatePassword `
            -ManagedIdentity:$ManagedIdentity.IsPresent `
            -AccessTokens $AccessTokens `
            -SubscriptionId $SubscriptionId `
            -GenerateInfo $GenerateInfo `
            -Filters $Filters `
            -Validate:$Validate.IsPresent `
            -Parallel:$Parallel.IsPresent `
            -ResourceSettings $resourceSettings `
            -ErrorAction $ErrorActionPreference `
            -WithStatistics:$WithStatistics.IsPresent `
            -IncludeDependencies:$IncludeDependencies.IsPresent
    }
    elseif ($null -ne $Components)
    {
        Write-M365DSCHost -Message "Exporting Microsoft 365 configuration for Components: $($Components -join ', ')"
        Start-M365DSCConfigurationExtract -Credential $Credential `
            -Components $Components `
            -ExcludeComponents $ExcludeComponents `
            -Path $Path -FileName $FileName `
            -ConfigurationName $ConfigurationName `
            -ApplicationId $ApplicationId `
            -ApplicationSecret $ApplicationSecret `
            -TenantId $TenantId `
            -CertificateThumbprint $CertificateThumbprint `
            -CertificatePath $CertificatePath `
            -CertificatePassword $CertificatePassword `
            -ManagedIdentity:$ManagedIdentity.IsPresent `
            -AccessTokens $AccessTokens `
            -SubscriptionId $SubscriptionId `
            -GenerateInfo $GenerateInfo `
            -Filters $Filters `
            -Validate:$Validate.IsPresent `
            -Parallel:$Parallel.IsPresent `
            -ResourceSettings $resourceSettings `
            -ErrorAction $ErrorActionPreference `
            -WithStatistics:$WithStatistics.IsPresent `
            -IncludeDependencies:$IncludeDependencies.IsPresent
    }
    elseif ($null -ne $Mode)
    {
        Write-M365DSCHost -Message "Exporting Microsoft 365 configuration for Mode: $Mode"
        Start-M365DSCConfigurationExtract -Credential $Credential `
            -Mode $Mode `
            -ExcludeComponents $ExcludeComponents `
            -Path $Path -FileName $FileName `
            -ConfigurationName $ConfigurationName `
            -ApplicationId $ApplicationId `
            -ApplicationSecret $ApplicationSecret `
            -TenantId $TenantId `
            -CertificateThumbprint $CertificateThumbprint `
            -CertificatePath $CertificatePath `
            -CertificatePassword $CertificatePassword `
            -ManagedIdentity:$ManagedIdentity.IsPresent `
            -AccessTokens $AccessTokens `
            -SubscriptionId $SubscriptionId `
            -GenerateInfo $GenerateInfo `
            -AllComponents `
            -Filters $Filters `
            -Validate:$Validate.IsPresent `
            -Parallel:$Parallel.IsPresent `
            -ResourceSettings $resourceSettings `
            -ErrorAction $ErrorActionPreference `
            -WithStatistics:$WithStatistics.IsPresent `
            -IncludeDependencies:$IncludeDependencies.IsPresent
    }

    # Clear the exported resource instances' names Global variable
    $Global:M365DSCExportedResourceInstancesNames = $null
    $Global:M365DSCExportedResourceInstances = $null
    $Global:M365DSCExportDependencies = $null
    $Global:M365DSCExportInProgress = $false

    $data = [System.Collections.Generic.Dictionary[[System.String], [System.Object]]]::new()
    if ([System.String]::IsNullOrEmpty($data.Tenant) -and -not [System.String]::IsNullOrEmpty($TenantId))
    {
        $data.Add('Tenant', $TenantId)
    }
    else
    {
        $data.Add('Tenant', $Tenant)
    }
    $data.Add('M365DSCExportId', $currentExportID)
    $data.Add('ConnectionMode', $Script:ConnectionMode)
    $timeTaken = [System.DateTime]::Now.Subtract($currentStartDateTime)
    $data.Add('TotalSeconds', $timeTaken.TotalSeconds)
    Add-M365DSCTelemetryEvent -Type 'ExportCompleted' -Data $data
}

<#
.SYNOPSIS
    Returns exportable resource names for a selected export mode.

.DESCRIPTION
    Filters resource settings by mode and optionally excludes configuration resources when Full mode is used.

.PARAMETER Mode
    Specifies the export mode used to select resources.

.PARAMETER ExcludeConfigurationResources
    Indicates that configuration-only resources should be excluded in Full mode.

.EXAMPLE
    Get-M365DSCResourcesByExportMode -Mode 'Default'

    This command retrieves all resources that are available in the Default export mode.

.EXAMPLE
    Get-M365DSCResourcesByExportMode -Mode 'Full'

    This command retrieves all resources that are available in the Full export mode.

.OUTPUTS
    System.String[]
#>
function Get-M365DSCResourcesByExportMode
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Default', 'Full')]
        [System.String]
        $Mode,

        [Parameter(Mandatory = $false)]
        [switch]
        $ExcludeConfigurationResources
    )

    $resourceSettings = Get-M365DSCResourceSettings
    $resources = [System.Collections.Generic.List[System.String]]::new($resourceSettings.Keys.Count)
    foreach ($resource in $resourceSettings.Keys)
    {
        if ($Mode -eq 'Default' -and $resourceSettings[$resource].mode -eq 'Configuration')
        {
            $resources.Add($resource)
        }
        elseif ($Mode -eq 'Full')
        {
            if ($ExcludeConfigurationResources -and $resourceSettings[$resource].mode -eq 'Configuration')
            {
                continue
            }
            $resources.Add($resource)
        }
    }

    return $resources.ToArray()
}

<#
.SYNOPSIS
    Builds DSC resource block content for a single exported resource instance.

.DESCRIPTION
    Converts resource export results into DSC text content.
    It normalizes authentication fields, handles escaping rules, and emits resource block content for the target module.

.PARAMETER ResourceName
    Specifies the resource name being rendered.

.PARAMETER ConnectionMode
    Specifies the resolved authentication connection mode.

.PARAMETER ModulePath
    Specifies the path to the resource module used during export rendering.

.PARAMETER Results
    Specifies exported resource values to render.

.PARAMETER Credential
    Specifies delegated credentials used for contextual rendering.

.PARAMETER NoEscape
    Specifies property names that should not be string-escaped.

.PARAMETER SkipAuthenticationUpdate
    Indicates that authentication fields should not be transformed.

.PARAMETER AllowVariablesInStrings
    Indicates that variable placeholders may be preserved inside strings.

.PARAMETER RawResults
    Specifies the original unprocessed export result values.

.OUTPUTS
    System.String
#>
function Get-M365DSCExportContentForResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('ServicePrincipalWithThumbprint', 'ServicePrincipalWithSecret', 'ServicePrincipalWithPath', 'CredentialsWithTenantId', 'CredentialsWithApplicationId', 'Credentials', 'ManagedIdentity', 'AccessTokens')]
        $ConnectionMode,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ModulePath,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Results,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String[]]
        $NoEscape,

        [Parameter()]
        [switch]
        $SkipAuthenticationUpdate,

        [Parameter()]
        [switch]
        $AllowVariablesInStrings,

        [Parameter()]
        [System.Collections.Hashtable]
        $RawResults
    )

    $OrganizationName = ''
    if ($ConnectionMode -like 'ServicePrincipal*' -or `
            $ConnectionMode -eq 'ManagedIdentity')
    {
        $OrganizationName = $Results.TenantId
    }
    elseif ($null -ne $Credential.UserName)
    {
        $OrganizationName = $Credential.UserName.Split('@')[1]
    }
    else
    {
        $OrganizationName = ''
    }

    if (-not $SkipAuthenticationUpdate)
    {
        $withoutAuthentication = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
            -Results $Results
        $Results = $withoutAuthentication.Results
        $NoEscape += $withoutAuthentication.NoEscape
    }
    $NoEscape = $NoEscape | Select-Object -Unique

    $primaryKey = ''
    if ($Script:M365DSCMandatoryKeyCache.ContainsKey($ResourceName))
    {
        $Keys = $Script:M365DSCMandatoryKeyCache[$ResourceName]
    }
    else
    {
        $Resource = (Get-M365DSCAllResourcesDictionary).$ResourceName
        $Keys = $Resource.Properties.Where({ $_.IsMandatory }) | Select-Object -ExpandProperty Name
        if ($null -eq $Keys)
        {
            $moduleFullName = 'MSFT_' + $ResourceName
            if (-not (Get-Module $moduleFullName))
            {
                $m365dscModuleBase = (Get-Module -Name 'Microsoft365DSC').ModuleBase
                $moduleFullNamePath = Join-Path -Path $m365dscModuleBase -ChildPath "DscResources/$moduleFullName/$moduleFullName.psm1"
                Import-Module $moduleFullNamePath -Force
            }
            $cmdInfo = Get-Command $moduleFullName\Get-TargetResource -ErrorAction SilentlyContinue
            $Keys = $cmdInfo.Parameters.Values.Where({ $_.ParameterSets.Values.IsMandatory }).Name
        }
        $Script:M365DSCMandatoryKeyCache[$ResourceName] = $Keys
    }

    if ($Keys.Contains('IsSingleInstance'))
    {
        $primaryKey = ''
    }
    elseif ($Keys.Contains('DisplayName') -and -not [System.String]::IsNullOrEmpty($Results.DisplayName))
    {
        $primaryKey = $Results.DisplayName
    }
    elseif ($Keys.Contains('Name'))
    {
        $primaryKey = $Results.Name
    }
    elseif ($Keys.Contains('Title'))
    {
        $primaryKey = $Results.Title
    }
    elseif ($Keys.Contains('Identity'))
    {
        $primaryKey = $Results.Identity
    }
    elseif ($Keys.Contains('Id'))
    {
        $primaryKey = $Results.Id
    }
    elseif ($Keys.Contains('CDNType'))
    {
        $primaryKey = $Results.CDNType
    }
    elseif ($Keys.Contains('WorkspaceName'))
    {
        $primaryKey = $Results.WorkspaceName
    }
    elseif ($Keys.Contains('OrganizationName'))
    {
        $primaryKey = $Results.OrganizationName
    }
    elseif ($Keys.Contains('DomainName'))
    {
        $primaryKey = $Results.DomainName
    }
    elseif ($Keys.Contains('UserPrincipalName'))
    {
        $primaryKey = $Results.UserPrincipalName
    }

    if ([String]::IsNullOrEmpty($primaryKey) -and -not $Keys.Contains('IsSingleInstance'))
    {
        foreach ($Key in $Keys)
        {
            $primaryKey += $Results.$Key
        }
    }

    $instanceName = $ResourceName
    if (-not [System.String]::IsNullOrEmpty($primaryKey))
    {
        if ($AllowVariablesInStrings)
        {
            $primaryKey = $primaryKey.Replace('`', '``').Replace('"', '`"')
        }
        else
        {
            $primaryKey = $primaryKey.Replace('`', '``').Replace('$', '`$').Replace('"', '`"')
        }
        $primaryKey = Update-M365DSCSpecialCharacters -String $primaryKey
        $instanceName += "-$primaryKey"
    }

    if ($Results.ContainsKey('Workload'))
    {
        $instanceName += "-$($Results.Workload)"
    }

    # Check to see if a resource with this exact name was already exported, if so, append a number to the end.
    $i = 2
    $tempName = $instanceName
    if ($null -eq $Global:M365DSCExportedResourceInstancesNames)
    {
        $Global:M365DSCExportedResourceInstancesNames = [System.Collections.Generic.HashSet[System.String]]::new([System.StringComparer]::OrdinalIgnoreCase)
    }
    while ($null -ne $Global:M365DSCExportedResourceInstancesNames -and `
            $Global:M365DSCExportedResourceInstancesNames.Contains($tempName))
    {
        $tempName = $instanceName + '-' + $i.ToString()
        $i++
    }
    $instanceName = $tempName
    [void]$Global:M365DSCExportedResourceInstancesNames.Add($tempName)

    # Register this instance in the dependency tracking registry
    if ($null -ne $Global:M365DSCExportedResourceInstances)
    {
        $registryKey = "[$ResourceName]$instanceName"
        $Global:M365DSCExportedResourceInstances[$registryKey] = @{
            InstanceName = $instanceName
            ResourceName = $ResourceName
            PrimaryKey   = $primaryKey
            Results      = $Results
        }
    }

    # Resolve cross-resource relations and register dependencies
    if ($null -ne $Global:M365DSCExportDependencies)
    {
        $resolveResults = $Results
        if ($null -ne $RawResults)
        {
            $resolveResults = $RawResults
        }
        Resolve-M365DSCExportRelations -ResourceName $ResourceName `
            -InstanceName $instanceName `
            -Results $resolveResults
    }

    $content = [System.Text.StringBuilder]::new()
    [void]$content.Append("        $ResourceName `"$instanceName`"`r`n")
    [void]$content.Append("        {`r`n")
    $partialContent = Get-DSCBlock -Params $Results -ModulePath $ModulePath -NoEscape $NoEscape -AllowVariablesInStrings:$AllowVariablesInStrings

    if ($partialContent.ToLower().IndexOf($OrganizationName.ToLower()) -gt 0)
    {
        if (-not $Script:M365DSCCompiledRegexCache.ContainsKey("OrgColon_$OrganizationName"))
        {
            $Script:M365DSCCompiledRegexCache["OrgColon_$OrganizationName"] = [regex]::new([regex]::Escape($OrganizationName + ':'), 'IgnoreCase, Compiled')
            $Script:M365DSCCompiledRegexCache["OrgAt_$OrganizationName"] = [regex]::new([regex]::Escape('@' + $OrganizationName), 'IgnoreCase, Compiled')
            $Script:M365DSCCompiledRegexCache["Org_$OrganizationName"] = [regex]::new([regex]::Escape($OrganizationName), 'IgnoreCase, Compiled')
        }
        $partialContent = $Script:M365DSCCompiledRegexCache["OrgColon_$OrganizationName"].Replace($partialContent, "`$(`$OrganizationName):")
        $partialContent = $Script:M365DSCCompiledRegexCache["OrgAt_$OrganizationName"].Replace($partialContent, "@`$OrganizationName")
        $partialContent = $Script:M365DSCCompiledRegexCache["Org_$OrganizationName"].Replace($partialContent, "`$OrganizationName")
    }

    # Apply additional string to variable replacements from mapping
    if ($Global:M365DSCStringReplacementMap)
    {
        Set-M365DSCStringReplacementMap -Map $Global:M365DSCStringReplacementMap
    }
    if ($null -ne $Script:M365DSCStringReplacementMap -and $Script:M365DSCStringReplacementMap.Count -gt 0)
    {
        foreach ($entry in $Script:M365DSCStringReplacementMap.GetEnumerator())
        {
            $target = $entry.Key
            $varName = $entry.Value
            if ([System.String]::IsNullOrEmpty($target) -or [System.String]::IsNullOrEmpty($varName))
            {
                Write-Verbose -Message "Skipping invalid string replacement map entry: Key = '$target', VariableName = '$varName'"
                continue
            }
            # Skip if already handled as OrganizationName
            if ($OrganizationName -and ($target -ieq $OrganizationName))
            {
                Write-Verbose -Message "Skipping replacement for target [$target] because it matches the OrganizationName: '$OrganizationName'"
                continue
            }

            if ($partialContent.ToLower().IndexOf($target.ToLower()) -gt 0)
            {
                $cacheKeyBase = "Map_$target"
                if (-not $Script:M365DSCCompiledRegexCache.ContainsKey("${cacheKeyBase}_colon"))
                {
                    $Script:M365DSCCompiledRegexCache["${cacheKeyBase}_colon"] = [regex]::new([regex]::Escape($target + ':'), 'IgnoreCase, Compiled')
                    $Script:M365DSCCompiledRegexCache["${cacheKeyBase}_at"] = [regex]::new([regex]::Escape('@' + $target), 'IgnoreCase, Compiled')
                    $Script:M365DSCCompiledRegexCache["${cacheKeyBase}_plain"] = [regex]::new([regex]::Escape($target), 'IgnoreCase, Compiled')
                }
                $partialContent = $Script:M365DSCCompiledRegexCache["${cacheKeyBase}_colon"].Replace($partialContent, "`$(`$ConfigurationData.NonNodeData.$varName):")
                $partialContent = $Script:M365DSCCompiledRegexCache["${cacheKeyBase}_at"].Replace($partialContent, "@`$(`$ConfigurationData.NonNodeData.$varName)")
                $partialContent = $Script:M365DSCCompiledRegexCache["${cacheKeyBase}_plain"].Replace($partialContent, "`$(`$ConfigurationData.NonNodeData.$varName)")
            }
        }
    }

    [void]$content.Append($partialContent)
    [void]$content.Append("        }`r`n")

    return $content.ToString()
}

<#
.SYNOPSIS
    Updates the export string replacement map.

.DESCRIPTION
    Merges replacement entries into the module string replacement map and optionally clears existing mappings first.

.PARAMETER Map
    Specifies replacement mappings where key is source text and value is replacement token.

.PARAMETER Clear
    Indicates that existing mappings should be cleared before applying Map.
#>
function Set-M365DSCStringReplacementMap
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Collections.Hashtable]
        $Map,

        [Parameter()]
        [switch]
        $Clear
    )

    if ($Clear)
    {
        $Script:M365DSCStringReplacementMap = @{}
    }

    if ($PSBoundParameters.ContainsKey('Map'))
    {
        foreach ($key in $Map.Keys)
        {
            $Script:M365DSCStringReplacementMap[$key] = $Map[$key]
        }
    }
}

<#
.SYNOPSIS
    Returns the current export string replacement map.

.DESCRIPTION
    Returns a clone of the in-memory map used for token replacement in exported content.

.OUTPUTS
    System.Collections.Hashtable
#>
function Get-M365DSCStringReplacementMap
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return $Script:M365DSCStringReplacementMap.Clone()
}

<#
.SYNOPSIS
    Joins split DSC configuration files into a single configuration content block.

.DESCRIPTION
    This function is used to join two or more M365DSC configurations into a single configuration.
    The function reads the configuration from the specified paths and combines them into a single configuration.
    Please note that the function won't be updating the authentication parameters if they differ between the configurations. Make sure that the authentication parameters are the same over all configurations.

.PARAMETER ConfigurationFile
    Specifies the base configuration file name.

.PARAMETER ConfigurationPath
    Specifies the folder containing configuration files to merge.

.EXAMPLE
    Join-M365DSCConfiguration -ConfigurationFile 'M365TenantConfig.ps1' -ConfigurationPath 'D:\testbed'
    This example joins the 'M365TenantConfig.ps1' file with all the configuration files in the 'D:\testbed' directory.

.FUNCTIONALITY
    Public
#>
function Join-M365DSCConfiguration
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $ConfigurationFile,

        [Parameter(Mandatory = $true)]
        [string]
        $ConfigurationPath
    )

    if ($ConfigurationFile -notlike '*.ps1')
    {
        throw 'The ConfigurationFile parameter must be a .ps1 file.'
    }

    if (-not (Test-Path -Path $ConfigurationPath))
    {
        throw 'The ConfigurationPath parameter must be a valid path.'
    }

    $ConfigurationFilePath = Join-Path -Path $ConfigurationPath -ChildPath $ConfigurationFile
    $ConfigurationPath = Join-Path -Path $ConfigurationPath -ChildPath '*'

    $baseConfiguration = ConvertTo-DSCObject -Path $ConfigurationFilePath
    $additionalConfigurations = Get-Item -Path $ConfigurationPath -Filter *.ps1 -Exclude $ConfigurationFile | ForEach-Object { ConvertTo-DSCObject -Path $_.FullName }

    $combinedArray = @($baseConfiguration) + @($additionalConfigurations)
    $combinedConfiguration = ConvertFrom-DSCObject -DSCResources $combinedArray

    # Indent all lines by 8 spaces to match the indentation of the configuration file
    $combinedConfiguration = $combinedConfiguration -replace '(?m)^', '        '
    $combinedConfiguration = $combinedConfiguration.TrimEnd()

    # Remove everything in the "Node localhost" part in the configuration file, while excluding the last two closing brackets
    $content = Get-Content -Path $ConfigurationFilePath -Raw
    $content = $content -replace '(?s)(?<=Node localhost\s*\{)(.*\s{8}\}?)(?=\s*\})', ''

    # Append the combined configuration after the "Node localhost" part in the configuration file
    $content = $content -replace '(?s)(?<=Node localhost\s*\{)', "`r`n$combinedConfiguration"

    return $content
}

<#
.SYNOPSIS
    Splits a large DSC configuration file into smaller files.

.DESCRIPTION
    Parses Node localhost resource blocks and writes chunked configuration files based on maximum file size and optional resource count limits.

.PARAMETER Path
    Specifies the source configuration file path.

.PARAMETER OutputFolder
    Specifies the destination folder for split files.

.PARAMETER MaxFileSizeMB
    Specifies the maximum file size per output file in megabytes.

.PARAMETER MaxResources
    Specifies the maximum number of resource blocks per output file.

.EXAMPLE
    Split-M365DSCConfiguration -Path 'C:\Configs\M365TenantConfig.ps1' -OutputFolder 'C:\Configs\Split' -MaxFileSizeMB 2 -MaxResources 50
    This example splits the 'M365TenantConfig.ps1' file into smaller files, each with a maximum size of 2 MB and a maximum of 50 resources, saving them in the 'C:\Configs\Split' folder.

.FUNCTIONALITY
    Public
#>
function Split-M365DSCConfiguration
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter()]
        [System.String]
        $OutputFolder = (Split-Path $Path),

        [Parameter()]
        [System.Double]
        $MaxFileSizeMB = 3,

        [Parameter()]
        [System.Int32]
        $MaxResources = 0  # 0 = ignore resource count limit
    )

    $fileContent = Get-Content -Encoding utf8 -Path $Path -Raw

    # Extract content inside "Node localhost { ... }"
    $pattern = 'Node localhost\s*{([\s\S]*)\s+}(\r|\n)+\s+}'
    $nodeMatch = [regex]::Match($fileContent, $pattern)
    if (-not $nodeMatch.Success)
    {
        throw "Could not find a 'Node localhost { ... }' block in file: $Path"
    }

    $nodeContent = $nodeMatch.Groups[1].Value

    # Extract header (everything before Node localhost)
    $header = ($fileContent -split 'Node localhost')[0] + "Node localhost`n    {`n"
    $footer = "`n    }`n}`n`nM365TenantConfig -ConfigurationData .\ConfigurationData.psd1"

    # Split into DSC resource text blocks using brace-depth parsing
    $resources = @()
    $lines = $nodeContent -split "`r?`n"
    $currentResource = [System.Text.StringBuilder]::new()
    $braceDepth = 0
    $insideResource = $false

    for ($i = 0; $i -lt $lines.Count; $i++)
    {
        $line = $lines[$i]
        # Detect resource start
        if (-not $insideResource -and $line.Trim() -match '^[a-zA-Z0-9_]+\s+"[^"]+"')
        {
            $insideResource = $true
            $null = $currentResource.Clear()
            $null = $currentResource.AppendLine($line)
            # Calculate brace depth
            $braceDepth = ($line -split '{').Count - ($line -split '}').Count
            continue
        }

        if ($insideResource)
        {
            $null = $currentResource.AppendLine($line)

            # Adjust brace depth based on line content
            $braceDepth += ($line -split '{').Count - ($line -split '}').Count

            # End of resource block
            if ($braceDepth -le 0)
            {
                $resources += '        ' + $currentResource.ToString().Trim()
                $insideResource = $false
            }
        }
    }

    if (-not $resources)
    {
        throw 'No DSC resources found in the Node block.'
    }

    # Splitting logic
    $i = 1
    $currentGroup = @()
    $currentSize = 0
    $maxBytes = $MaxFileSizeMB * 1MB

    foreach ($res in $resources)
    {
        # Calculate size of the resource in bytes
        $resBytes = [System.Text.Encoding]::UTF8.GetByteCount($res)
        $resourceCountLimitReached = ($MaxResources -gt 0 -and $currentGroup.Count -ge $MaxResources)
        $sizeLimitReached = ($currentSize + $resBytes) -gt $maxBytes

        # Write current group if limits are reached
        if (($sizeLimitReached -or $resourceCountLimitReached) -and $currentGroup.Count -gt 0)
        {
            $outPath = Join-Path $OutputFolder ('M365TenantConfig_{0}.ps1' -f $i)
            $configText = $header + ($currentGroup -join "`n") + $footer
            Set-Content -Path $outPath -Value $configText -Encoding UTF8 -Force
            Write-M365DSCHost -Message "Created: $outPath" -CommitWrite
            $i++
            $currentGroup = @()
            $currentSize = 0
        }

        $currentGroup += $res
        $currentSize += $resBytes
    }

    # Write final group
    if ($currentGroup.Count -gt 0)
    {
        $outPath = Join-Path $OutputFolder ('M365TenantConfig_{0}.ps1' -f $i)
        $configText = $header + ($currentGroup -join "`n`n") + $footer
        Set-Content -Path $outPath -Value $configText -Encoding UTF8 -Force
        Write-M365DSCHost -Message "Created: $outPath" -CommitWrite
    }
}

<#
.SYNOPSIS
    Normalizes authentication fields in exported resource results.

.DESCRIPTION
    Transforms authentication-related properties into configuration-data references and returns updated results with no-escape property metadata.

.PARAMETER ConnectionMode
    Specifies the authentication mode used for transformation rules.

.PARAMETER Results
    Specifies exported resource values to normalize.

.OUTPUTS
    System.Collections.Hashtable
#>
function Update-M365DSCExportAuthenticationResults
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('ServicePrincipalWithThumbprint', 'ServicePrincipalWithSecret', 'ServicePrincipalWithPath', 'CredentialsWithTenantId', 'CredentialsWithApplicationId', 'Credentials', 'ManagedIdentity', 'AccessTokens')]
        [System.String]
        $ConnectionMode,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Results
    )

    $noEscape = @()
    if ($Results.ContainsKey('ManagedIdentity') -and -not $Results.ManagedIdentity)
    {
        $Results.Remove('ManagedIdentity')
    }

    if ($ConnectionMode -in @('Credentials', 'CredentialsWithTenantId'))
    {
        $Results.Credential = '$CredsCredential'
        $noEscape += 'Credential'

        # Credentials mode removes TenantId; CredentialsWithTenantId keeps it.
        $keysToRemove = @('ApplicationId', 'ApplicationSecret', 'CertificateThumbprint', 'CertificatePath', 'CertificatePassword')
        if ($ConnectionMode -eq 'Credentials')
        {
            $keysToRemove += 'TenantId'
        }

        foreach ($key in $keysToRemove)
        {
            if ($Results.ContainsKey($key))
            {
                $Results.Remove($key) | Out-Null
            }
        }
    }
    else
    {
        # Handle Credential based on CredentialsWithApplicationId mode
        if ($Results.ContainsKey('Credential'))
        {
            if ($ConnectionMode -eq 'CredentialsWithApplicationId')
            {
                $Results.Credential = '$CredsCredential'
                $noEscape += 'Credential'
            }
            else
            {
                $Results.Remove('Credential') | Out-Null
            }
        }

        # Keys that map to a simple ConfigurationData reference when non-empty
        $configDataKeys = @('ApplicationId', 'CertificateThumbprint', 'CertificatePath', 'TenantId')
        foreach ($key in $configDataKeys)
        {
            if (-not [System.String]::IsNullOrEmpty($Results.$key))
            {
                $Results.$key = "`$ConfigurationData.NonNodeData.$key"
                $noEscape += $key
            }
            else
            {
                try
                {
                    $Results.Remove($key) | Out-Null
                }
                catch
                {
                    Write-Verbose -Message "Error removing $key from Update-M365DSCExportAuthenticationResults"
                }
            }
        }

        # ApplicationSecret gets a PSCredential wrapper
        if (-not [System.String]::IsNullOrEmpty($Results.ApplicationSecret))
        {
            $Results.ApplicationSecret = "New-Object System.Management.Automation.PSCredential ('ApplicationSecret', (ConvertTo-SecureString `$ConfigurationData.NonNodeData.ApplicationSecret -AsPlainText -Force))"
            $noEscape += 'ApplicationSecret'
        }
        else
        {
            try
            {
                $Results.Remove('ApplicationSecret') | Out-Null
            }
            catch
            {
                Write-Verbose -Message 'Error removing ApplicationSecret from Update-M365DSCExportAuthenticationResults'
            }
        }

        # CertificatePassword gets resolved as credentials
        if ($null -ne $Results.CertificatePassword)
        {
            $Results.CertificatePassword = '$CredsCertificatePassword'
            $noEscape += 'CertificatePassword'
        }
        else
        {
            try
            {
                $Results.Remove('CertificatePassword') | Out-Null
            }
            catch
            {
                Write-Verbose -Message 'Error removing CertificatePassword from Update-M365DSCExportAuthenticationResults'
            }
        }

        if ($null -ne $Results.AccessTokens)
        {
            $Results.AccessTokens = "`$ConfigurationData.NonNodeData.AccessTokens"
            $noEscape += 'AccessTokens'
        }
    }

    return @{
        Results  = $Results
        NoEscape = $noEscape
    }
}

<#
.SYNOPSIS
    Registers a discovered resource dependency during export.

.DESCRIPTION
    Adds a source-target dependency record to the global export dependency collector.

.PARAMETER SourceInstanceName
    Specifies the source resource instance name.

.PARAMETER SourceResourceName
    Specifies the source resource type name.

.PARAMETER TargetResourceType
    Specifies the target resource type name.

.PARAMETER TargetKey
    Specifies the target key value used to resolve the dependency target instance.
#>
function Register-M365DSCExportDependency
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SourceInstanceName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SourceResourceName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TargetResourceType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TargetKey
    )

    if ($null -ne $Global:M365DSCExportDependencies)
    {
        $Global:M365DSCExportDependencies += @{
            SourceInstanceName = $SourceInstanceName
            SourceResourceName = $SourceResourceName
            TargetResourceType = $TargetResourceType
            TargetKey          = $TargetKey
        }
    }
}

<#
.SYNOPSIS
    Resolves relation templates into concrete export dependencies.

.DESCRIPTION
    Evaluates configured relation templates for the resource instance and registers dependencies for referenced target resources.

.PARAMETER ResourceName
    Specifies the source resource type name.

.PARAMETER InstanceName
    Specifies the source resource instance name.

.PARAMETER Results
    Specifies exported property values used to evaluate relation definitions.
#>
function Resolve-M365DSCExportRelations
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $InstanceName,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Results
    )

    # Determine relations from template
    $relations = @()
    foreach ($template in $Script:RelationTemplates.templates.GetEnumerator())
    {
        if ($template.Value.resources.Contains($ResourceName))
        {
            $resourceRelations = $template.Value.relations
            foreach ($relation in $resourceRelations)
            {
                if ($null -ne $relation.'$ref')
                {
                    $templateName = $relation.'$ref'.Split("/")[-1]
                    $relations += $Script:RelationTemplates.templates.$templateName.relations
                    continue
                }
                $relations += $relation
            }
        }
    }

    if ($relations.Count -eq 0)
    {
        return
    }

    foreach ($relation in $relations)
    {
        $propertyValue = $Results
        $splittedProperty = $relation.property.Split('.')
        for ($i = 0; $i -lt $splittedProperty.Count; $i++)
        {
            $propertyName = $splittedProperty[$i]
            if ($propertyValue -is [System.Array])
            {
                if ($propertyValue.Count -eq 0)
                {
                    continue
                }

                $found = $false
                $propertyValue | Foreach-Object {
                    if ($_ -is [System.Collections.IDictionary] -and $_.Contains($propertyName))
                    {
                        $found = $true
                    }
                }
                if (-not $found)
                {
                    continue
                }
            }
            else
            {
                if (-not $propertyValue.ContainsKey($propertyName))
                {
                    continue
                }
            }

            $propertyValue = $propertyValue.$propertyName
            if ($null -eq $propertyValue)
            {
                continue
            }
        }

        # Handle array of complex objects (e.g., Assignments)
        if ($propertyValue -is [System.Array])
        {
            foreach ($item in $propertyValue)
            {
                $targetKey = Get-M365DSCRelationTargetKey -Item $item -Relation $relation
                if (-not [System.String]::IsNullOrEmpty($targetKey))
                {
                    Register-M365DSCExportDependency -SourceInstanceName $InstanceName `
                        -SourceResourceName $ResourceName `
                        -TargetResourceType $relation.targetResource `
                        -TargetKey $targetKey
                }
            }
        }
        elseif ($propertyValue -is [System.Collections.IDictionary] -or $propertyValue -is [Microsoft.Management.Infrastructure.CimInstance])
        {
            $targetKey = Get-M365DSCRelationTargetKey -Item $propertyValue -Relation $relation
            if (-not [System.String]::IsNullOrEmpty($targetKey))
            {
                Register-M365DSCExportDependency -SourceInstanceName $InstanceName `
                    -SourceResourceName $ResourceName `
                    -TargetResourceType $relation.targetResource `
                    -TargetKey $targetKey
            }
        }
        else
        {
            # Simple string property referencing a target resource key directly
            Register-M365DSCExportDependency -SourceInstanceName $InstanceName `
                -SourceResourceName $ResourceName `
                -TargetResourceType $relation.targetResource `
                -TargetKey $propertyValue.ToString()
        }
    }
}

<#
.Description
    Extracts the target key value from a complex item based on the relation definition.

.Functionality
    Internal
#>
function Get-M365DSCRelationTargetKey
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $Item,

        [Parameter(Mandatory = $true)]
        [System.Object]
        $Relation
    )

    # If there's a condition, check it first
    if (-not [System.String]::IsNullOrEmpty($Relation.condition))
    {
        $conditionMet = Test-M365DSCRelationCondition -Item $Item -Condition $Relation.condition
        if (-not $conditionMet)
        {
            return $null
        }
    }

    # Extract the child property value
    $childProperty = $Relation.childProperty
    $value = $null

    if ($Item -is [System.Collections.IDictionary])
    {
        if ($Item.Contains($childProperty))
        {
            $value = $Item[$childProperty]
        }
    }
    elseif ($null -ne $Item)
    {
        $value = $Item.$childProperty
    }

    if ([System.String]::IsNullOrEmpty($value))
    {
        return $null
    }

    return $value.ToString()
}

<#
.Description
    Evaluates a simple condition expression against a complex object item.
    Supports: "propertyName in ['value1', 'value2']"

.Functionality
    Internal
#>
function Test-M365DSCRelationCondition
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $Item,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Condition
    )

    # Parse "propertyName in ['value1', 'value2']" pattern
    if ($Condition -match "^(\w+)\s+in\s+\[(.+)\]$")
    {
        $propName = $Matches[1]
        $valuesString = $Matches[2]
        $allowedValues = $valuesString -split ',\s*' | ForEach-Object { $_.Trim().Trim("'").Trim('"') }

        $itemValue = $null
        if ($Item -is [System.Collections.Hashtable])
        {
            if ($Item.ContainsKey($propName))
            {
                $itemValue = $Item[$propName]
            }
        }
        elseif ($null -ne $Item)
        {
            $itemValue = $Item.$propName
        }

        if ($null -eq $itemValue)
        {
            return $false
        }

        return ($allowedValues -contains $itemValue.ToString())
    }

    # Unknown condition format - default to true
    return $true
}

<#
.SYNOPSIS
    Injects DependsOn statements into exported DSC content.

.DESCRIPTION
    Resolves collected dependencies to exported instances, injects DependsOn arrays into source resource blocks, and generates minimal stub blocks for unresolved targets.

.PARAMETER DSCContent
    Specifies the exported DSC content to enrich with dependency data.

.OUTPUTS
    System.String
#>
function Add-M365DSCExportDependsOn
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DSCContent
    )

    if ($null -eq $Global:M365DSCExportDependencies -or $Global:M365DSCExportDependencies.Count -eq 0)
    {
        return $DSCContent
    }

    if ($null -eq $Global:M365DSCExportedResourceInstances)
    {
        return $DSCContent
    }

    # Build a lookup from target resource+key to instance reference
    $targetLookup = @{}
    foreach ($entry in $Global:M365DSCExportedResourceInstances.GetEnumerator())
    {
        $inst = $entry.Value
        $lookupKey = "$($inst.ResourceName)|$($inst.PrimaryKey)"
        $targetLookup[$lookupKey] = $entry.Key
    }

    # Group dependencies by source instance
    $dependenciesBySource = @{}
    $unresolvedTargets = @{}

    foreach ($dep in $Global:M365DSCExportDependencies)
    {
        $lookupKey = "$($dep.TargetResourceType)|$($dep.TargetKey)"
        $targetRef = $targetLookup[$lookupKey]

        if ($null -ne $targetRef)
        {
            # Target was exported - add DependsOn reference
            $sourceRef = "[$($dep.SourceResourceName)]$($dep.SourceInstanceName)"
            if (-not $dependenciesBySource.ContainsKey($sourceRef))
            {
                $dependenciesBySource[$sourceRef] = @()
            }
            if ($dependenciesBySource[$sourceRef] -notcontains $targetRef)
            {
                $dependenciesBySource[$sourceRef] += $targetRef
            }
        }
        else
        {
            # Target was NOT exported - needs a stub
            $stubKey = "$($dep.TargetResourceType)|$($dep.TargetKey)"
            if (-not $unresolvedTargets.ContainsKey($stubKey))
            {
                $unresolvedTargets[$stubKey] = @{
                    ResourceType = $dep.TargetResourceType
                    TargetKey    = $dep.TargetKey
                }
            }

            # Still record the dependency for injection after stub is created
            $sourceRef = "[$($dep.SourceResourceName)]$($dep.SourceInstanceName)"
            if (-not $dependenciesBySource.ContainsKey($sourceRef))
            {
                $dependenciesBySource[$sourceRef] = @()
            }
            $stubInstanceName = "$($dep.TargetResourceType)-$($dep.TargetKey)"
            $stubRef = "[$($dep.TargetResourceType)]$stubInstanceName"
            if ($dependenciesBySource[$sourceRef] -notcontains $stubRef)
            {
                $dependenciesBySource[$sourceRef] += $stubRef
            }
        }
    }

    # Inject DependsOn into each source block
    foreach ($sourceEntry in $dependenciesBySource.GetEnumerator())
    {
        $sourceRef = $sourceEntry.Key
        $targets = $sourceEntry.Value

        # Parse resource name and instance name from "[ResourceName]InstanceName"
        if ($sourceRef -match '^\[([^\]]+)\](.+)$')
        {
            $srcResourceName = $Matches[1]
            $srcInstanceName = $Matches[2]

            # Build DependsOn line
            $dependsOnEntries = Get-M365DSCArrayFromProperty -PropertyValue ($targets | ForEach-Object { "`"$_`"" }) -ElementType ([System.String])
            if ($dependsOnEntries.Count -eq 1)
            {
                $dependsOnLine = "            DependsOn = @($($dependsOnEntries[0]))"
            }
            else
            {
                $dependsOnLine = "            DependsOn = @($($dependsOnEntries -join ', '))"
            }

            # Find the closing brace of this resource block and inject DependsOn before it
            $blockPattern = "        $srcResourceName `"$srcInstanceName`""
            $blockStart = $DSCContent.IndexOf($blockPattern)
            if ($blockStart -ge 0)
            {
                # Find the closing "        }" for this block
                $searchFrom = $blockStart + $blockPattern.Length
                $closingBrace = $DSCContent.IndexOf("`r`n        }`r`n", $searchFrom)
                if ($closingBrace -gt 0)
                {
                    $DSCContent = $DSCContent.Insert($closingBrace + 1, $dependsOnLine)
                }
            }
        }
    }

    # Generate stub blocks for unresolved targets
    if ($unresolvedTargets.Count -gt 0)
    {
        $stubContent = Get-M365DSCMinimalExportBlocks -UnresolvedTargets $unresolvedTargets
        if (-not [System.String]::IsNullOrEmpty($stubContent))
        {
            # Insert stubs before the closing "    }" of the Node block
            # Just after the last resource block's closing brace
            $nodeClose = $DSCContent.LastIndexOf("        }`r`n")
            if ($nodeClose -gt 0)
            {
                $DSCContent = $DSCContent.Insert($nodeClose + 11, $stubContent)
            }
        }
    }

    return $DSCContent
}

<#
.SYNOPSIS
    Builds minimal DSC stub blocks for unresolved dependency targets.

.DESCRIPTION
    Generates placeholder resource blocks with mandatory keys and authentication fields so unresolved dependency references can still compile.

.PARAMETER UnresolvedTargets
    Specifies unresolved target definitions keyed by resource type and target key.

.OUTPUTS
    System.String
#>
function Get-M365DSCMinimalExportBlocks
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $UnresolvedTargets
    )

    $stubBuilder = [System.Text.StringBuilder]::new()
    [void]$stubBuilder.Append("`r`n        # Dependency stubs - minimal resource blocks for referenced resources`r`n")

    $dictionary = $null
    try
    {
        $dictionary = Get-M365DSCAllResourcesDictionary
    }
    catch
    {
        Write-Verbose -Message "Unable to load resource dictionary for stub generation: $_"
        return ''
    }

    foreach ($target in $UnresolvedTargets.GetEnumerator())
    {
        $resourceType = $target.Value.ResourceType
        $targetKey = $target.Value.TargetKey
        $instanceName = "$resourceType-$targetKey"

        # Get key properties from the resource dictionary
        $resourceInfo = $null
        if ($null -ne $dictionary -and $dictionary.ContainsKey($resourceType))
        {
            $resourceInfo = $dictionary[$resourceType]
        }

        [void]$stubBuilder.Append("        $resourceType `"$instanceName`"`r`n")
        [void]$stubBuilder.Append("        {`r`n")

        if ($null -ne $resourceInfo)
        {
            $keyProps = $resourceInfo.Properties | Where-Object -Property IsMandatory -EQ $true
            foreach ($prop in $keyProps)
            {
                if ($prop.Name -eq 'IsSingleInstance')
                {
                    [void]$stubBuilder.Append("            IsSingleInstance = `"Yes`"`r`n")
                }
                elseif ($prop.Name -eq 'MailEnabled')
                {
                    [void]$stubBuilder.Append("            $($prop.Name) = `$false`r`n")
                }
                elseif ($prop.Name -eq 'SecurityEnabled')
                {
                    [void]$stubBuilder.Append("            $($prop.Name) = `$true`r`n")
                }
                elseif ($prop.Name -in @('DisplayName', 'MailNickName', 'Name', 'Title', 'Identity', 'Id'))
                {
                    [void]$stubBuilder.Append("            $($prop.Name) = `"$targetKey`"`r`n")
                }
            }

            foreach ($prop in $Script:M365DSCAuthenticationParameterSet.$($Script:ConnectionMode))
            {
                if ($prop -eq 'ManagedIdentity')
                {
                    [void]$stubBuilder.Append("            $($prop) = `$true`r`n")
                }
                else
                {
                    [void]$stubBuilder.Append("            $($prop) = `$ConfigurationData.NonNodeData.$($prop)`r`n")
                }
            }
        }
        else
        {
            # Fallback: assume DisplayName is the key
            [void]$stubBuilder.Append("            DisplayName = `"$targetKey`"`r`n")
        }

        [void]$stubBuilder.Append("            Ensure      = `"Present`"`r`n")
        [void]$stubBuilder.Append("        }`r`n")
    }

    return $stubBuilder.ToString()
}

Export-ModuleMember -Function @(
    'Export-M365DSCConfiguration',
    'Get-M365DSCExportContentForResource',
    'Get-M365DSCResourcesByExportMode',
    'Join-M365DSCConfiguration',
    'Split-M365DSCConfiguration',
    'Set-M365DSCStringReplacementMap',
    'Get-M365DSCStringReplacementMap',
    'Update-M365DSCExportAuthenticationResults',
    'Register-M365DSCExportDependency',
    'Resolve-M365DSCExportRelations',
    'Add-M365DSCExportDependsOn',
    'Get-M365DSCMinimalExportBlocks'
)
