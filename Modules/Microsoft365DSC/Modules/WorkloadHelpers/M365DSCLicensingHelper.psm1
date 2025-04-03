function Invoke-M365DSCLicensingWebRequest
{
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $Uri,

        [Parameter()]
        [System.String]
        $Method = 'GET',

        [Parameter()]
        [System.Collections.Hashtable]
        $Body
    )

    $headers = @{
        Authorization = (Get-MSCloudLoginConnectionProfile -Workload 'Licensing').AccessToken
    }

    $bodyValue = $null
    if (-not [System.String]::IsNullOrEmpty($Body))
    {
        $bodyValue = ConvertTo-Json $Body -Depth 10 -Compress
    }

    $response = Invoke-WebRequest -Method $Method `
                                  -Uri $Uri `
                                  -Headers $headers `
                                  -Body $bodyValue `
                                  -ContentType 'application/json' `
                                  -UseBasicParsing
    $result = ConvertFrom-Json $response.Content
    return $result
}
