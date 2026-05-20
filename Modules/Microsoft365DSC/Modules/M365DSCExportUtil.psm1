$Script:M365DSCStringReplacementMap = @{}
$Script:M365DSCMandatoryKeyCache = @{}
$Script:M365DSCCompiledRegexCache = @{}

<#
.Description
This is the main Microsoft365DSC.Reverse function that extracts the DSC configuration from an existing Microsoft 365 Tenant.

.Parameter LaunchWebUI
Adding this parameter will open the WebUI in a browser.

.Parameter Path
Specifies the path in which the exported DSC configuration should be stored.

.Parameter FileName
Specifies the name of the file in which the exported DSC configuration should be stored.

.Parameter ConfigurationName
Specifies the name of the configuration that will be generated.

.Parameter Components
Specifies the components for which an export should be created.

.Parameter ExcludeComponents
Specifies the components to skip when creating the export

.Parameter Workloads
Specifies the workload for which an export should be created for all resources.

.Parameter Mode
Specifies the mode of the export: Default or Full.

.Parameter GenerateInfo
Specifies if each exported resource should get a link to the Wiki article of the resource.

.Parameter ApplicationId
Specifies the application id to be used for authentication.

.Parameter ApplicationSecret
Specifies the application secret of the application to be used for authentication.

.Parameter TenantId
Specifies the id of the tenant.

.Parameter CertificateThumbprint
Specifies the thumbprint to be used for authentication.

.Parameter Credential
Specifies the credentials to be used for authentication.

.Parameter CertificatePassword
Specifies the password of the PFX file which is used for authentication.

.Parameter CertificatePath
Specifies the path of the PFX file which is used for authentication.

.Parameter Filters
Specifies resource level filters to apply in order to reduce the number of instances exported.

.PARAMETER AccessTokens
    Specifies the access token to use for authentication.

.Parameter ManagedIdentity
Specifies use of managed identity for authentication.

.Parameter Validate
Specifies that the configuration needs to be validated for conflicts or issues after its extraction is completed.

.PARAMETER Parallel
    Specifies that the export is executed in parallel.

.PARAMETER TokenReplacement
    Specifies the hashtable to use for token replacement. Key is the value to replace, and the value is the variable to use for replacement without the '$' sign.

.PARAMETER WithStatistics
    Specifies that statistics about the export should be shown after completion.

.Example
Export-M365DSCConfiguration -Components @("AADApplication", "AADConditionalAccessPolicy", "AADGroupsSettings") -Credential $Credential

.Example
Export-M365DSCConfiguration -Mode 'Default' -ApplicationId '2560bb7c-bc85-415f-a799-841e10ec4f9a' -TenantId 'contoso.sharepoint.com' -ApplicationSecret 'abcdefghijkl'

.Example
Export-M365DSCConfiguration -Components @("AADApplication", "AADConditionalAccessPolicy", "AADGroupsSettings") -Credential $Credential -Path 'C:\DSC' -FileName 'MyConfig.ps1'

.Example
Export-M365DSCConfiguration -Credential $Credential -Filters @{AADApplication = "DisplayName eq 'MyApp'"} -TokenReplacement @{ 'alternate-email.onmicrosoft.com' = 'AlternateEmail' }

.Example
Export-M365DSCConfiguration -Workloads @("SPO") -ExcludeComponents @("SPOPropertyBag") -Credential $Credential

.Functionality
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
        $WithStatistics
    )

    $currentStartDateTime = [System.DateTime]::Now
    $Global:M365DSCExportInProgress = $true
    $Global:MaximumFunctionCount = 32767

    Clear-M365DSCHostMessageCache

    # Define the exported resource instances' names Global variable
    $Global:M365DSCExportedResourceInstancesNames = [System.Collections.Generic.HashSet[System.String]]::new([System.StringComparer]::OrdinalIgnoreCase)

    # Clear performance caches for fresh export
    $Script:M365DSCMandatoryKeyCache = @{}
    $Script:M365DSCCompiledRegexCache = @{}

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
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()

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
    $ConnectionMode = Get-M365DSCAuthenticationMode $PSBoundParameters
    $data.Add('Tenant', $Tenant)
    $currentExportID = (New-Guid).ToString()
    $data.Add('M365DSCExportId', $currentExportID)
    $data.Add('ConnectionMode', $ConnectionMode)

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
            -ManagedIdentity:$ManagedIdentity `
            -AccessTokens $AccessTokens `
            -GenerateInfo $GenerateInfo `
            -Filters $Filters `
            -Validate:$Validate `
            -Parallel:$Parallel `
            -ResourceSettings $resourceSettings `
            -ErrorAction $ErrorActionPreference `
            -WithStatistics:$WithStatistics
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
            -ManagedIdentity:$ManagedIdentity `
            -AccessTokens $AccessTokens `
            -GenerateInfo $GenerateInfo `
            -Filters $Filters `
            -Validate:$Validate `
            -Parallel:$Parallel `
            -ResourceSettings $resourceSettings `
            -ErrorAction $ErrorActionPreference `
            -WithStatistics:$WithStatistics
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
            -ManagedIdentity:$ManagedIdentity `
            -AccessTokens $AccessTokens `
            -GenerateInfo $GenerateInfo `
            -AllComponents `
            -Filters $Filters `
            -Validate:$Validate `
            -Parallel:$Parallel `
            -ResourceSettings $resourceSettings `
            -ErrorAction $ErrorActionPreference `
            -WithStatistics:$WithStatistics
    }

    # Clear the exported resource instances' names Global variable
    $Global:M365DSCExportedResourceInstancesNames = $null
    $Global:M365DSCExportInProgress = $false

    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    if ([System.String]::IsNullOrEmpty($data.Tenant) -and -not [System.String]::IsNullOrEmpty($TenantId))
    {
        $data.Add('Tenant', $TenantId)
    }
    else
    {
        $data.Add('Tenant', $Tenant)
    }
    $data.Add('M365DSCExportId', $currentExportID)
    $data.Add('ConnectionMode', $ConnectionMode)
    $timeTaken = [System.DateTime]::Now.Subtract($currentStartDateTime)
    $data.Add('TotalSeconds', $timeTaken.TotalSeconds)
    Add-M365DSCTelemetryEvent -Type 'ExportCompleted' -Data $data
}

<#
.DESCRIPTION
    This function retrieves the resources available in the M365DSC project based on the specified export mode.

.FUNCTIONALITY
    Public

.PARAMETER Mode
    Specifies the mode of the export. Valid values are 'Default' and 'Full'.
    - 'Default' includes only configuration resources.
    - 'Full' includes all resources, both configuration and data.

.PARAMETER ExcludeConfigurationResources
    If specified, configuration resources will be excluded from the results. Works only for the 'Full' mode.

.EXAMPLE
    Get-M365DSCResourcesByExportMode -Mode 'Default'

    This command retrieves all resources that are available in the Default export mode.

.EXAMPLE
    Get-M365DSCResourcesByExportMode -Mode 'Full'

    This command retrieves all resources that are available in the Full export mode.

.OUTPUTS
    [System.String[]] - An array of resource names that match the specified export mode.
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
.DESCRIPTION
    This function generates DSC string from an exported result hashtable

.FUNCTIONALITY
    Internal
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
        $AllowVariablesInStrings
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
    $ModuleFullName = 'MSFT_' + $ResourceName
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
            if (-not (Get-Module $ModuleFullName))
            {
                Import-Module $Resource.Path -Force
            }
            $cmdInfo = Get-Command $ModuleFullName\Get-TargetResource -ErrorAction SilentlyContinue
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

    $content = [System.Text.StringBuilder]::New()
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
.DESCRIPTION
    This function sets the string replacement map used during export.

.FUNCTIONALITY
    Internal
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
.DESCRIPTION
    This function returns the string replacement map used during export.

.FUNCTIONALITY
    Internal
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
    Joins two or more M365DSC configurations into a single configuration.

.DESCRIPTION
    This function is used to join two or more M365DSC configurations into a single configuration.
    The function reads the configuration from the specified paths and combines them into a single configuration.
    Please note that the function won't be updating the authentication parameters if they differ between the configurations. Make sure that the authentication parameters are the same over all configurations.

.PARAMETER ConfigurationFile
    The name of the first configuration file to use as the base configuration.

.PARAMETER ConfigurationPath
    The directory path to the configuration files to join to the base configuration.

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
.DESCRIPTION
    This function splits a large M365DSC configuration file into smaller files based on size and resource count limits.

.PARAMETER Path
    The path to the M365DSC configuration file to split.

.PARAMETER OutputFolder
    The folder where the split configuration files will be saved. Defaults to the same folder as the input file.

.PARAMETER MaxFileSizeMB
    The maximum size (in megabytes) for each split configuration file. Default is 3 MB.

.PARAMETER MaxResources
    The maximum number of resources per split configuration file. Default is 0 (no limit).

.EXAMPLE
    Split-M365DSCConfiguration -Path 'C:\Configs\M365TenantConfig.ps1' -OutputFolder 'C:\Configs\Split' -MaxFileSizeMB 2 -MaxResources 50
    This example splits the 'M365TenantConfig.ps1' file into smaller files, each with a maximum size of 2 MB and a maximum of 50 resources, saving them in the 'C:\Configs\Split' folder.

.FUNCTIONALITY
    Public
#>
function Split-M365DSCConfiguration
{
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
.Description
This function updates the exported results with the specified authentication method

.Functionality
Internal
#>
function Update-M365DSCExportAuthenticationResults
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('ServicePrincipalWithThumbprint', 'ServicePrincipalWithSecret', 'ServicePrincipalWithPath', 'CredentialsWithTenantId', 'CredentialsWithApplicationId', 'Credentials', 'ManagedIdentity', 'AccessTokens')]
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
        $Results.Credential = Resolve-Credentials -UserName 'credential'
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
                $Results.Credential = Resolve-Credentials -UserName 'credential'
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
            $Results.CertificatePassword = Resolve-Credentials -UserName 'CertificatePassword'
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

Export-ModuleMember -Function @(
    'Export-M365DSCConfiguration',
    'Get-M365DSCExportContentForResource',
    'Get-M365DSCResourcesByExportMode',
    'Join-M365DSCConfiguration',
    'Split-M365DSCConfiguration',
    'Set-M365DSCStringReplacementMap',
    'Get-M365DSCStringReplacementMap',
    'Update-M365DSCExportAuthenticationResults'
)
