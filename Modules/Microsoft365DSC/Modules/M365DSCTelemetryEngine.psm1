function Get-ApplicationInsightsTelemetryClient
{
    [CmdletBinding()]
    param()

    if ($null -eq $Global:M365DSCTelemetryEngine)
    {
        $AI = "$PSScriptRoot\..\Dependencies\Microsoft.ApplicationInsights.AspNetCore.dll"
        [Reflection.Assembly]::LoadFile($AI) | Out-Null

        $InstrumentationKey = "bc5aa204-0b1e-4499-a955-d6a639bdb4fa"
        if ($null -ne $env:M365DSCTelemetryInstrumentationKey)
        {
            $InstrumentationKey = $env:M365DSCTelemetryInstrumentationKey
        }
        $TelClient = [Microsoft.ApplicationInsights.TelemetryClient]::new()
        $TelClient.InstrumentationKey = $InstrumentationKey

        $Global:M365DSCTelemetryEngine = $TelClient
    }
    return $Global:M365DSCTelemetryEngine
}

function Add-M365DSCTelemetryEvent
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Type = 'Flow',

        [Parameter()]
        [System.Collections.Generic.Dictionary[[System.String], [System.String]]]
        $Data,

        [Parameter()]
        [System.Collections.Generic.Dictionary[[System.String], [System.Double]]]
        $Metrics
    )

    $TelemetryEnabled = [System.Environment]::GetEnvironmentVariable('M365DSCTelemetryEnabled', `
            [System.EnvironmentVariableTarget]::Machine)

    if ($null -eq $TelemetryEnabled -or $TelemetryEnabled -eq $true)
    {
        $TelemetryClient = Get-ApplicationInsightsTelemetryClient

        try
        {
            $ProjectName = [System.Environment]::GetEnvironmentVariable('M365DSCTelemetryProjectName', `
                    [System.EnvironmentVariableTarget]::Machine)

            if ($null -ne $ProjectName)
            {
                $Data.Add("ProjectName", $ProjectName)
            }

            if ($null -ne $Data.Principal)
            {
                if ($Data.Principal -like '*@*.*')
                {
                    $principalValue = $Data.Principal.Split("@")[1]
                    $Data.Add("Tenant", $principalValue)
                }
            }
            elseif ($null -ne $Data.TenantId)
            {
                $principalValue = $Data.TenantId
                $Data.Add("Tenant", $principalValue)
            }

            $Data.Remove("TenandId") | Out-Null
            $Data.Remove("Principal") | Out-Null

            # Capture PowerShell Version Info
            $Data.Add("PSMainVersion", $PSVersionTable.PSVersion.Major.ToString() + "." + $PSVersionTable.PSVersion.Minor.ToString())
            $Data.Add("PSVersion", $PSVersionTable.PSVersion.ToString())
            $Data.Add("PSEdition", $PSVersionTable.PSEdition.ToString())

            # Capture Console/Host Information
            if ($host.Name -eq "ConsoleHost" -and $null -eq $env:WT_SESSION)
            {
                $Data.Add("PowerShellAgent", "Console")
            }
            elseif ($host.Name -eq "Windows PowerShell ISE Host")
            {
                $Data.Add("PowerShellAgent", "ISE")
            }
            elseif ($host.Name -eq "ConsoleHost" -and $null -ne $env:WT_SESSION)
            {
                $Data.Add("PowerShellAgent", "Windows Terminal")
            }
            elseif ($host.Name -eq "ConsoleHost" -and $null -eq $env:WT_SESSION -and `
                    $null -ne $env:BUILD_BUILDID -and $env:SYSTEM -eq "build")
            {
                $Data.Add("PowerShellAgent", "Azure DevOPS")
                $Data.Add("AzureDevOPSPipelineType", "Build")
                $Data.Add("AzureDevOPSAgent", $env:POWERSHELL_DISTRIBUTION_CHANNEL)
            }
            elseif ($host.Name -eq "ConsoleHost" -and $null -eq $env:WT_SESSION -and `
                    $null -ne $env:BUILD_BUILDID -and $env:SYSTEM -eq "release")
            {
                $Data.Add("PowerShellAgent", "Azure DevOPS")
                $Data.Add("AzureDevOPSPipelineType", "Release")
                $Data.Add("AzureDevOPSAgent", $env:POWERSHELL_DISTRIBUTION_CHANNEL)
            }
            elseif ($host.Name -eq "Default Host" -and `
                    $null -ne $env:APPSETTING_FUNCTIONS_EXTENSION_VERSION)
            {
                $Data.Add("PowerShellAgent", "Azure Function")
                $Data.Add("AzureFunctionWorkerVersion", $env:FUNCTIONS_WORKER_RUNTIME_VERSION)
            }
            elseif ($host.Name -eq "CloudShell")
            {
                $Data.Add("PowerShellAgent", "Cloud Shell")
            }

            if ($null -ne $Data.Resource)
            {
                if ($Data.Resource.StartsWith("MSFT_AAD") -or $Data.Resource.StartsWith("AAD"))
                {
                    $Data.Add("Workload", "Azure Active Directory")
                }
                elseif ($Data.Resource.StartsWith("MSFT_EXO") -or $Data.Resource.StartsWith("EXO"))
                {
                    $Data.Add("Workload", "Exchange Online")
                }
                elseif ($Data.Resource.StartsWith("MSFT_Intune") -or $Data.Resource.StartsWith("Intune"))
                {
                    $Data.Add("Workload", "Intune")
                }
                elseif ($Data.Resource.StartsWith("MSFT_O365") -or $Data.Resource.StartsWith("O365"))
                {
                    $Data.Add("Workload", "Office 365 Admin")
                }
                elseif ($Data.Resource.StartsWith("MSFT_OD") -or $Data.Resource.StartsWith("OD"))
                {
                    $Data.Add("Workload", "OneDrive for Business")
                }
                elseif ($Data.Resource.StartsWith("MSFT_Planner") -or $Data.Resource.StartsWith("Planner"))
                {
                    $Data.Add("Workload", "Planner")
                }
                elseif ($Data.Resource.StartsWith("MSFT_PP") -or $Data.Resource.StartsWith("PP"))
                {
                    $Data.Add("Workload", "Power Platform")
                }
                elseif ($Data.Resource.StartsWith("MSFT_SC") -or $Data.Resource.StartsWith("SC"))
                {
                    $Data.Add("Workload", "Security and Compliance Center")
                }
                elseif ($Data.Resource.StartsWith("MSFT_SPO") -or $Data.Resource.StartsWith("SPO"))
                {
                    $Data.Add("Workload", "SharePoint Online")
                }
                elseif ($Data.Resource.StartsWith("MSFT_Teams") -or $Data.Resource.StartsWith("Teams"))
                {
                    $Data.Add("Workload", "Teams")
                }
                $Data.Resource = $Data.Resource.Replace("MSFT_", "")
            }

            [array]$version = (Get-Module 'Microsoft365DSC').Version | Sort-Object -Descending
            $Data.Add("M365DSCVersion", $version[0].ToString())

            # Get Dependencies loaded versions
            try
            {
                $currentPath = Join-Path -Path $PSScriptRoot -ChildPath '..\' -Resolve
                $manifest = Import-PowerShellDataFile "$currentPath/Microsoft365DSC.psd1"
                $dependencies = $manifest.RequiredModules

                $dependenciesContent = ""
                foreach ($dependency in $dependencies)
                {
                    $dependenciesContent += Get-Module $dependency.ModuleName | Out-String
                }
                $Data.Add("DependenciesVersion", $dependenciesContent)
            }
            catch
            {
                Write-Verbose -Message $_
            }

            $TelemetryClient.TrackEvent($Type, $Data, $Metrics)
            $TelemetryClient.Flush()
        }
        catch
        {
            Write-Error $_
        }
    }
}

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
        $ProjectName
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
}

function Get-M365DSCTelemetryOption
{
    [CmdletBinding()]
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
        }
    }
    catch
    {
        throw $_
    }
}
