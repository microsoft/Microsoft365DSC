function Get-ApplicationInsightsTelemetryClient
{
    [CmdletBinding()]
    param()

    if ($null -eq $Global:O365DSCTelemetryEngine)
    {
        $AI = "$PSScriptRoot\..\Dependencies\Microsoft.ApplicationInsights.dll"
        [Reflection.Assembly]::LoadFile($AI) | Out-Null

        $InstrumentationKey = "bc5aa204-0b1e-4499-a955-d6a639bdb4fa"
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Type,

        [Parameter(Mandatory = $true)]
        [System.Collections.Generic.Dictionary[[System.String],[System.String]]]
        $Data,

        [Parameter()]
        [System.Collections.Generic.Dictionary[[System.String],[System.Double]]]
        $Metrics
    )

    $TelemetryClient = Get-ApplicationInsightsTelemetryClient

    try
    {
        $TelemetryClient.TrackEvent($Type, $Data, $Metrics)
	    $TelemetryClient.Flush()
    }
    catch
    {
        throw $_
    }
}
