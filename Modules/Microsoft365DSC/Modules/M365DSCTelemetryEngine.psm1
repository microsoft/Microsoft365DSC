function Get-ApplicationInsightsTelemetryClient
{
    [CmdletBinding()]
    param()

    if ($null -eq $Global:M365DSCTelemetryEngine)
    {
        $AI = "$PSScriptRoot\..\Dependencies\Microsoft.ApplicationInsights.dll"
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
        [System.Collections.Generic.Dictionary[[System.String],[System.String]]]
        $Data,

        [Parameter()]
        [System.Collections.Generic.Dictionary[[System.String],[System.Double]]]
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
            Enabled = [System.Environment]::GetEnvironmentVariable('<365DSCTelemetryEnabled', `
                [System.EnvironmentVariableTarget]::Machine)
            InstrumentationKey = [System.Environment]::GetEnvironmentVariable('M365DSCTelemetryInstrumentationKey', `
                [System.EnvironmentVariableTarget]::Machine)
            ProjectName = [System.Environment]::GetEnvironmentVariable('M365DSCTelemetryProjectName', `
            [System.EnvironmentVariableTarget]::Machine)
        }
    }
    catch {
        throw $_
    }
}
