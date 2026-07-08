$Script:TelemetryEnabled = [System.Environment]::GetEnvironmentVariable('M365DSCTelemetryEnabled', `
            [System.EnvironmentVariableTarget]::Machine)

<#
.DESCRIPTION
    This function tests if telemetry is enabled for M365DSC.

.FUNCTIONALITY
    Internal
#>
function Test-IsM365DSCTelemetryEnabled
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param()

    if ($null -eq $Script:TelemetryEnabled -or $Script:TelemetryEnabled -eq $true)
    {
        return $true
    }
    else
    {
        return $false
    }
}

<#
.DESCRIPTION
    This function gets the Application Insights key to be used for storing telemetry

.FUNCTIONALITY
    Internal, Hidden
#>
function Get-M365DSCApplicationInsightsTelemetryClient
{
    [CmdletBinding()]
    param()

    if ($null -eq $Global:M365DSCTelemetryEngine)
    {
        $AI = "$PSScriptRoot/../Dependencies/Microsoft.ApplicationInsights.dll"
        [Reflection.Assembly]::LoadFile($AI) | Out-Null

        $TelClient = [Microsoft.ApplicationInsights.TelemetryClient]::new()

        $connectionString = [System.Environment]::GetEnvironmentVariable('M365DSCTelemetryConnectionString', `
            [System.EnvironmentVariableTarget]::Machine)
        if (-not [System.String]::IsNullOrEmpty($connectionString))
        {
            $TelClient.TelemetryConfiguration.ConnectionString = $connectionString
        }
        else
        {
            $InstrumentationKey = [System.Environment]::GetEnvironmentVariable('M365DSCTelemetryInstrumentationKey', `
                    [System.EnvironmentVariableTarget]::Machine)

            if ($null -eq $InstrumentationKey)
            {
                $InstrumentationKey = 'e670af5d-fd30-4407-a796-8ad30491ea7a'
            }
            $TelClient.InstrumentationKey = $InstrumentationKey
        }

        $Global:M365DSCTelemetryEngine = $TelClient
    }
    return $Global:M365DSCTelemetryEngine
}

<#
.DESCRIPTION
    This function sets the LCM configuration for the current session.

.PARAMETER LCMConfig
    The Local Configuration Manager configuration to set for the session.

.EXAMPLE
    PS> $lcmConfig = Get-DscLocalConfigurationManager
    PS> Set-M365DSCLCMConfiguration -LCMConfig $lcmConfig
#>
function Set-M365DSCLCMConfiguration
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $LCMConfig
    )

    $Script:LCMConfig = $LCMConfig
}

<#
.DESCRIPTION
    This function sends telemetry information to Application Insights

.FUNCTIONALITY
    Internal
#>
function Add-M365DSCTelemetryEvent
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Type,

        [Parameter()]
        [System.Collections.Generic.Dictionary[[System.String], [System.Object]]]
        $Data,

        [Parameter()]
        [System.Collections.Generic.Dictionary[[System.String], [System.Double]]]
        $Metrics
    )

    $dataNew = [System.Collections.Generic.Dictionary[[System.String], [System.String]]]::new()
    foreach ($key in $Data.Keys)
    {
        $dataNew.Add($key, $Data[$key])
    }

    if ($null -eq $Script:TelemetryEnabled -or $Script:TelemetryEnabled -eq $true)
    {
        if ($Type -eq 'DriftEvaluation')
        {
            try
            {
                $hostId = (Get-Host).InstanceId
                if ($null -eq $Script:M365DSCCountResourceInstance -or $hostId -ne $Script:M365DSCExecutionContextId)
                {
                    $Script:M365DSCCountResourceInstance = 1
                }
                else
                {
                    $Script:M365DSCCountResourceInstance++
                }
                if ($null -eq $Script:M365DSCOperationStartTime -or $hostId -ne $Script:M365DSCExecutionContextId)
                {
                    $Script:M365DSCOperationStartTime = [System.DateTime]::Now
                }

                $Script:M365DSCOperationTimeTaken = [System.DateTime]::Now.Subtract($Script:M365DSCOperationStartTime)

                if ($hostId -ne $Script:M365DSCExecutionContextId)
                {
                    $Script:M365DSCExecutionContextId = $hostId
                }
                $dataNew.Add('ResourceInstancesCount', $Script:M365DSCCountResourceInstance)
                $dataNew.Add('M365DSCExecutionContextId', $hostId)
                $dataNew.Add('M365DSCOperationTotalTime', $Script:M365DSCOperationTimeTaken.TotalSeconds)
            }
            catch
            {
                Write-Verbose -Message $_
            }
        }

        try
        {
            $telemetryParameters = Get-M365DSCTelemetryConnectionParameter
            if ($null -eq $telemetryParameters -or $telemetryParameters.Count -eq 0)
            {
                $null = New-M365DSCConnection -Workload 'MicrosoftGraph' -InboundParameters $Data.PSBoundParameters
            }

            if ($null -ne $dataNew.ConnectionMode -and $dataNew.ConnectionMode.StartsWith('Credential'))
            {
                if ($null -eq $Script:M365DSCCurrentRoles -or $Script:M365DSCCurrentRoles.Length -eq 0)
                {
                    $telemetryParameters = Get-M365DSCTelemetryConnectionParameter
                    Connect-M365Tenant -Workload 'MicrosoftGraph' @telemetryParameters -ErrorAction SilentlyContinue
                    $Script:M365DSCCurrentRoles = @()

                    $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + 'v1.0/me?$select=id'
                    $currentUser = Invoke-MgGraphRequest -Uri $uri -Method GET
                    $currentUserId = $currentUser.id

                    $assignments = Get-MgBetaRoleManagementDirectoryRoleAssignment -Filter "principalId eq '$currentUserId'" `
                        -Property @('RoleDefinitionId', 'DirectoryScopeId') -ExpandProperty 'roleDefinition($select=displayName)' -All -ErrorAction 'SilentlyContinue'

                    if ($null -ne $assignments)
                    {
                        foreach ($assignment in $assignments)
                        {
                            if ($null -ne $assignment.RoleDefinition)
                            {
                                $Script:M365DSCCurrentRoles += $assignment.RoleDefinition.DisplayName + '|' + $assignment.DirectoryScopeId
                            }
                        }
                        $dataNew.Add('M365DSCCurrentRoles', $Script:M365DSCCurrentRoles -join ',')
                    }
                }
                else
                {
                    $dataNew.Add('M365DSCCurrentRoles', $Script:M365DSCCurrentRoles -join ',')
                }
            }
            elseif ($null -ne $dataNew.ConnectionMode -and $dataNew.ConnectionMode.StartsWith('ServicePrincipal'))
            {
                if ($null -eq $Script:M365DSCCurrentRoles -or $Script:M365DSCCurrentRoles.Length -eq 0)
                {
                    try
                    {
                        $telemetryParameters = Get-M365DSCTelemetryConnectionParameter
                        Connect-M365Tenant -Workload 'MicrosoftGraph' @telemetryParameters -ErrorAction Stop

                        $Script:M365DSCCurrentRoles = @()
                        $sp = Get-MgServicePrincipal -Filter "AppId eq '$($telemetryParameters.ApplicationId)'" `
                            -ErrorAction 'SilentlyContinue'
                        if ($null -ne $sp)
                        {
                            $assignments = Get-MgBetaRoleManagementDirectoryRoleAssignment -Filter "principalId eq '$($sp.Id)'" `
                                -Property @('RoleDefinitionId', 'DirectoryScopeId') -ExpandProperty 'roleDefinition($select=displayName)' -All -ErrorAction 'SilentlyContinue'
                            if ($null -ne $assignments)
                            {
                                foreach ($assignment in $assignments)
                                {
                                    if ($null -ne $assignment.RoleDefinition)
                                    {
                                        $Script:M365DSCCurrentRoles += $assignment.RoleDefinition.DisplayName + '|' + $assignment.DirectoryScopeId
                                    }
                                }
                                $dataNew.Add('M365DSCCurrentRoles', $Script:M365DSCCurrentRoles -join ',')
                            }
                        }
                    }
                    catch
                    {
                        Write-Verbose -Message $_
                    }
                }
                else
                {
                    $dataNew.Add('M365DSCCurrentRoles', $Script:M365DSCCurrentRoles -join ',')
                }
            }
        }
        catch
        {
            Write-Verbose -Message $_
        }

        $TelemetryClient = Get-M365DSCApplicationInsightsTelemetryClient

        try
        {
            $ProjectName = [System.Environment]::GetEnvironmentVariable('M365DSCTelemetryProjectName', `
                    [System.EnvironmentVariableTarget]::Machine)

            if ($null -ne $ProjectName)
            {
                $dataNew.Add('ProjectName', $ProjectName)
            }

            if (-not $dataNew.ContainsKey('Tenant'))
            {
                if (-not [System.String]::IsNullOrEmpty($dataNew.Principal))
                {
                    if ($dataNew.Principal -like '*@*.*')
                    {
                        $principalValue = $dataNew.Principal.Split('@')[1]
                        $dataNew.Add('Tenant', $principalValue)
                    }
                }
                elseif (-not [System.String]::IsNullOrEmpty($dataNew.TenantId))
                {
                    $principalValue = $dataNew.TenantId
                    $dataNew.Add('Tenant', $principalValue)
                }
            }

            $dataNew.Remove('TenandId') | Out-Null
            $dataNew.Remove('Principal') | Out-Null

            # Capture PowerShell Version Info
            if (-not $dataNew.Keys.Contains('PSMainVersion'))
            {
                $dataNew.Add('PSMainVersion', $PSVersionTable.PSVersion.Major.ToString() + '.' + $PSVersionTable.PSVersion.Minor.ToString())
            }
            if (-not $dataNew.Keys.Contains('PSVersion'))
            {
                $dataNew.Add('PSVersion', $PSVersionTable.PSVersion.ToString())
            }
            if (-not $dataNew.Keys.Contains('PSEdition'))
            {
                $dataNew.Add('PSEdition', $PSVersionTable.PSEdition.ToString())
            }

            if ($null -ne $PSVersionTable.BuildVersion -and -not $dataNew.Keys.Contains('PSBuildVersion'))
            {
                $dataNew.Add('PSBuildVersion', $PSVersionTable.BuildVersion.ToString())
            }

            if ($null -ne $PSVersionTable.CLRVersion -and -not $dataNew.Keys.Contains('PSCLRVersion'))
            {
                $dataNew.Add('PSCLRVersion', $PSVersionTable.CLRVersion.ToString())
            }

            # Capture Console/Host Information
            if ($host.Name -eq 'ConsoleHost' -and $null -eq $env:WT_SESSION -and -not $dataNew.Keys.Contains('PowerShellAgent'))
            {
                $dataNew.Add('PowerShellAgent', 'Console')
            }
            elseif ($host.Name -eq 'Windows PowerShell ISE Host' -and -not $dataNew.Keys.Contains('PowerShellAgent'))
            {
                $dataNew.Add('PowerShellAgent', 'ISE')
            }
            elseif ($host.Name -eq 'ConsoleHost' -and $null -ne $env:WT_SESSION -and -not $dataNew.Keys.Contains('PowerShellAgent'))
            {
                $dataNew.Add('PowerShellAgent', 'Windows Terminal' -and -not $dataNew.Keys.Contains('PowerShellAgent'))
            }
            elseif ($host.Name -eq 'ConsoleHost' -and $null -eq $env:WT_SESSION -and `
                    $null -ne $env:BUILD_BUILDID -and $env:SYSTEM -eq 'build' -and -not $dataNew.Keys.Contains('PowerShellAgent'))
            {
                $dataNew.Add('PowerShellAgent', 'Azure DevOPS')
                $dataNew.Add('AzureDevOPSPipelineType', 'Build')
                $dataNew.Add('AzureDevOPSAgent', $env:POWERSHELL_DISTRIBUTION_CHANNEL)
            }
            elseif ($host.Name -eq 'ConsoleHost' -and $null -eq $env:WT_SESSION -and `
                    $null -ne $env:BUILD_BUILDID -and $env:SYSTEM -eq 'release' -and -not $dataNew.Keys.Contains('PowerShellAgent'))
            {
                $dataNew.Add('PowerShellAgent', 'Azure DevOPS')
                $dataNew.Add('AzureDevOPSPipelineType', 'Release')
                $dataNew.Add('AzureDevOPSAgent', $env:POWERSHELL_DISTRIBUTION_CHANNEL)
            }
            elseif ($host.Name -eq 'Default Host' -and `
                    $null -ne $env:APPSETTING_FUNCTIONS_EXTENSION_VERSION -and -not $dataNew.Keys.Contains('PowerShellAgent'))
            {
                $dataNew.Add('PowerShellAgent', 'Azure Function')
                $dataNew.Add('AzureFunctionWorkerVersion', $env:FUNCTIONS_WORKER_RUNTIME_VERSION)
            }
            elseif ($host.Name -eq 'CloudShell' -and -not $dataNew.Keys.Contains('PowerShellAgent'))
            {
                $dataNew.Add('PowerShellAgent', 'Cloud Shell')
            }

            if ($null -ne $dataNew.Resource -and $dataNew.Keys.Contains('Resource'))
            {
                if ($dataNew.Resource.StartsWith('MSFT_AAD') -or $dataNew.Resource.StartsWith('AAD'))
                {
                    $dataNew.Add('Workload', 'Azure Active Directory')
                }
                elseif ($dataNew.Resource.StartsWith('MSFT_Intune') -or $dataNew.Resource.StartsWith('Defender'))
                {
                    $dataNew.Add('Workload', 'Defender')
                }
                elseif ($dataNew.Resource.StartsWith('MSFT_EXO') -or $dataNew.Resource.StartsWith('EXO'))
                {
                    $dataNew.Add('Workload', 'Exchange Online')
                }
                elseif ($dataNew.Resource.StartsWith('MSFT_Intune') -or $dataNew.Resource.StartsWith('Intune'))
                {
                    $dataNew.Add('Workload', 'Intune')
                }
                elseif ($dataNew.Resource.StartsWith('MSFT_O365') -or $dataNew.Resource.StartsWith('O365'))
                {
                    $dataNew.Add('Workload', 'Office 365 Admin')
                }
                elseif ($dataNew.Resource.StartsWith('MSFT_OD') -or $dataNew.Resource.StartsWith('OD'))
                {
                    $dataNew.Add('Workload', 'OneDrive for Business')
                }
                elseif ($dataNew.Resource.StartsWith('MSFT_Planner') -or $dataNew.Resource.StartsWith('Planner'))
                {
                    $dataNew.Add('Workload', 'Planner')
                }
                elseif ($dataNew.Resource.StartsWith('MSFT_PP') -or $dataNew.Resource.StartsWith('PP'))
                {
                    $dataNew.Add('Workload', 'Power Platform')
                }
                elseif ($dataNew.Resource.StartsWith('MSFT_SC') -or $dataNew.Resource.StartsWith('SC'))
                {
                    $dataNew.Add('Workload', 'Security and Compliance Center')
                }
                elseif ($dataNew.Resource.StartsWith('MSFT_SPO') -or $dataNew.Resource.StartsWith('SPO'))
                {
                    $dataNew.Add('Workload', 'SharePoint Online')
                }
                elseif ($dataNew.Resource.StartsWith('MSFT_Teams') -or $dataNew.Resource.StartsWith('Teams'))
                {
                    $dataNew.Add('Workload', 'Teams')
                }
                $dataNew.Resource = $dataNew.Resource.Replace('MSFT_', '')
            }

            if ($Type -eq 'ExportCompleted')
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $dataNew.Add('ExportedResourceInstancesCount', $Global:M365DSCExportResourceInstancesCount)
                }
                if ($null -ne $Global:M365DSCExportResourceTypes)
                {
                    $dataNew.Add('ExportedResourceTypes', $Global:M365DSCExportResourceTypes)
                    $dataNew.Add('ExportedResourceTypesCount', $Global:M365DSCExportResourceTypes.Length)
                }
                if ($null -ne $Global:M365DSCExportContentSize)
                {
                    $dataNew.Add('ExportedContentSize', $Global:M365DSCExportContentSize)
                }
            }

            [array]$version = (Get-Module 'Microsoft365DSC').Version | Sort-Object -Descending
            $dataNew.Add('M365DSCVersion', $version[0].ToString())

            # OS Version
            try
            {
                if ($null -eq $Global:M365DSCOSInfo)
                {
                    $Global:M365DSCOSInfo = (Get-CimInstance -ClassName Win32_OperatingSystem -Property Caption -ErrorAction SilentlyContinue).Caption
                }
                $dataNew.Add('M365DSCOSVersion', $Global:M365DSCOSInfo)
            }
            catch
            {
                Write-Verbose -Message $_
            }

            # LCM Metadata Information
            try
            {
                if ($null -eq $Script:M365DSCCurrentPrincipalIsAdmin -and ($PSEdition -eq 'Desktop' -or $IsWindows))
                {
                    $currentPrincipal = New-Object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())
                    $Script:M365DSCCurrentPrincipalIsAdmin = $currentPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
                }

                if ($Script:M365DSCCurrentPrincipalIsAdmin)
                {
                    if ($null -eq $Script:LCMInfo)
                    {
                        $Script:LCMInfo = Get-DscLocalConfigurationManager -ErrorAction Stop
                    }

                    $certificateConfigured = $false
                    if (-not [System.String]::IsNullOrEmpty($LCMInfo.CertificateID))
                    {
                        $certificateConfigured = $true
                    }

                    $partialConfiguration = $false
                    if (-not [System.String]::IsNullOrEmpty($Script:LCMInfo.PartialConfigurations))
                    {
                        $partialConfiguration = $true
                    }
                    $dataNew.Add('LCMUsesPartialConfigurations', $partialConfiguration)
                    $dataNew.Add('LCMCertificateConfigured', $certificateConfigured)
                    $dataNew.Add('LCMConfigurationMode', $Script:LCMInfo.ConfigurationMode)
                    $dataNew.Add('LCMConfigurationModeFrequencyMins', $Script:LCMInfo.ConfigurationModeFrequencyMins)
                    $dataNew.Add('LCMRefreshMode', $Script:LCMInfo.RefreshMode)
                    $dataNew.Add('LCMState', $Script:LCMInfo.LCMState)
                    $dataNew.Add('LCMStateDetail', $Script:LCMInfo.LCMStateDetail)

                    if ([System.String]::IsNullOrEmpty($Type))
                    {
                        if ($Global:M365DSCExportInProgress)
                        {
                            $Type = 'Export'
                        }
                        elseif ($Script:LCMInfo.LCMStateDetail -eq 'LCM is performing a consistency check.' -or `
                                $Script:LCMInfo.LCMStateDetail -eq 'LCM exécute une vérification de cohérence.' -or `
                                $Script:LCMInfo.LCMStateDetail -eq 'LCM führt gerade eine Konsistenzüberprüfung durch.')
                        {
                            $Type = 'MonitoringScheduled'
                        }
                        elseif ($Script:LCMInfo.LCMStateDetail -eq 'LCM is testing node against the configuration.')
                        {
                            $Type = 'MonitoringManual'
                        }
                        elseif ($Script:LCMInfo.LCMStateDetail -eq 'LCM is applying a new configuration.' -or `
                                $Script:LCMInfo.LCMStateDetail -eq 'LCM applique une nouvelle configuration.')
                        {
                            $Type = 'ApplyingConfiguration'
                        }
                        else
                        {
                            $Type = 'Undetermined'
                        }
                    }
                }
            }
            catch
            {
                Write-Verbose -Message $_
            }

            $M365DSCTelemetryEventId = (New-Guid).ToString()
            $dataNew.Add('M365DSCTelemetryEventId', $M365DSCTelemetryEventId)

            if ([System.String]::IsNullOrEMpty($Type))
            {
                if ((-not [System.String]::IsNullOrEmpty($dataNew.Method) -and $dataNew.Method -eq 'Export-TargetResource') -or $Global:M365DSCExportInProgress)
                {
                    $Type = 'Export'
                }
            }

            $TelemetryClient.TrackEvent($Type, $dataNew, $Metrics)
        }
        catch
        {
            try
            {
                $TelemetryClient.TrackEvent('Error', $dataNew, $Metrics)
            }
            catch
            {
                Write-Error $_
            }
        }
    }
}

<#
.Description
This function configures the telemetry feature of M365DSC

.Parameter Enabled
Enables or disables telemetry collection.

.Parameter InstrumentationKey
Specifies the Instrumention Key to be used to send the telemetry to.

.Parameter ProjectName
Specifies the name of the project to store the telemetry data under.

.Example
Set-M365DSCTelemetryOption -Enabled $false

.Functionality
Public
#>
function Set-M365DSCTelemetryOption
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $InstrumentationKey,

        [Parameter()]
        [System.String]
        $ProjectName,

        [Parameter()]
        [System.String]
        $ConnectionString
    )

    if ($null -ne $Enabled)
    {
        [System.Environment]::SetEnvironmentVariable('M365DSCTelemetryEnabled', $Enabled, `
                [System.EnvironmentVariableTarget]::Machine)
    }

    if ($null -ne $InstrumentationKey)
    {
        [System.Environment]::SetEnvironmentVariable('M365DSCTelemetryInstrumentationKey', $InstrumentationKey, `
                [System.EnvironmentVariableTarget]::Machine)
    }

    if ($null -ne $ProjectName)
    {
        [System.Environment]::SetEnvironmentVariable('M365DSCTelemetryProjectName', $ProjectName, `
                [System.EnvironmentVariableTarget]::Machine)
    }

    if ($null -ne $ConnectionString)
    {
        [System.Environment]::SetEnvironmentVariable('M365DSCTelemetryConnectionString', $ConnectionString, `
                [System.EnvironmentVariableTarget]::Machine)
    }
}

<#
.Description
This function gets the configuration for the M365DSC telemetry feature

.Example
Get-M365DSCTelemetryOption

.Functionality
Public
#>
function Get-M365DSCTelemetryOption
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    try
    {
        return @{
            Enabled            = [System.Environment]::GetEnvironmentVariable('M365DSCTelemetryEnabled', `
                    [System.EnvironmentVariableTarget]::Machine)
            InstrumentationKey = [System.Environment]::GetEnvironmentVariable('M365DSCTelemetryInstrumentationKey', `
                    [System.EnvironmentVariableTarget]::Machine)
            ProjectName        = [System.Environment]::GetEnvironmentVariable('M365DSCTelemetryProjectName', `
                    [System.EnvironmentVariableTarget]::Machine)
            ConnectionString   = [System.Environment]::GetEnvironmentVariable('M365DSCTelemetryConnectionString', `
                    [System.EnvironmentVariableTarget]::Machine)
        }
    }
    catch
    {
        throw $_
    }
}

<#
.Description
This function converts the data which is send to Application Insights to the correct format.

.Functionality
Internal
#>
function Format-M365DSCTelemetryParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.Dictionary[[System.String], [System.Object]]])]
    param(
        [parameter(Mandatory = $true)]
        [System.String]
        $ResourceName,

        [parameter(Mandatory = $true)]
        [System.String]
        $CommandName,

        [parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Parameters
    )
    $data = [System.Collections.Generic.Dictionary[[System.String], [System.Object]]]::new()

    try
    {
        $data.Add('Resource', $ResourceName)
        $data.Add('Method', $CommandName)
        if ($Parameters.Credential)
        {
            try
            {
                $data.Add('Principal', $Parameters.Credential.UserName)
                $data.Add('Tenant', $Parameters.Credential.UserName.Split('@')[1])
            }
            catch
            {
                Write-Verbose -Message $_
            }
        }
        elseif ($Parameters.ApplicationId)
        {
            $data.Add('Principal', $Parameters.ApplicationId)
            $data.Add('Tenant', $Parameters.TenantId)
        }
        elseif (-not [System.String]::IsNullOrEmpty($TenantId))
        {
            $data.Add('Tenant', $Parameters.TenantId)
        }
        $connectionMode = Get-M365DSCAuthenticationMode -Parameters $Parameters
        $data.Add('ConnectionMode', $connectionMode)
        $data.Add('PSBoundParameters', $Parameters)
    }
    catch
    {
        Write-Verbose -Message $_
    }
    return $data
}

Export-ModuleMember -Function @(
    'Add-M365DSCTelemetryEvent',
    'Format-M365DSCTelemetryParameters',
    'Get-M365DSCTelemetryOption',
    'Set-M365DSCTelemetryOption',
    'Set-M365DSCLCMConfiguration',
    'Test-IsM365DSCTelemetryEnabled',
    'Get-M365DSCConnectionParametersFromTelemetry'
)
