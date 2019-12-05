function Get-ApplicationInsightsTelemetryClient
{
    [CmdletBinding()]
    param()

    if ($null -eq $Global:O365DSCTelemetryEngine)
    {
        $AI = "$PSScriptRoot\..\Dependencies\Microsoft.ApplicationInsights.dll"
        [Reflection.Assembly]::LoadFile($AI) | Out-Null

        $InstrumentationKey = "bc5aa204-0b1e-4499-a955-d6a639bdb4fa"
        if ($null -ne $env:O365DSCTelemetryInstrumentationKey)
        {
            $InstrumentationKey = $env:O365DSCTelemetryInstrumentationKey
        }
        $TelClient = [Microsoft.ApplicationInsights.TelemetryClient]::new()
        $TelClient.InstrumentationKey = $InstrumentationKey

        $Global:O365DSCTelemetryEngine = $TelClient
    }
    return $Global:O365DSCTelemetryEngine
}

function Add-O365DSCTelemetryEvent
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

    if ($env:O365DSCTelemetryEnabled)
    {
        $TelemetryClient = Get-ApplicationInsightsTelemetryClient

        try
        {
            $TelemetryClient.TrackEvent($Type, $Data, $Metrics)
            $TelemetryClient.Flush()
        }
        catch
        {
            Write-Error $_
        }
    }
}

function Set-O365DSCTelemetryOption
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $InstrumentationKey
    )

    if ($null -ne $Enabled)
    {
        [System.Environment]::SetEnvironmentVariable('O365DSCTelemetryEnabled', $Enabled, `
            [System.EnvironmentVariableTarget]::Machine)
    }

    if ($null -ne $InstrumentationKey)
    {
        [System.Environment]::SetEnvironmentVariable('O365DSCTelemetryInstrumentationKey', $InstrumentationKey, `
            [System.EnvironmentVariableTarget]::Machine)
    }
}
