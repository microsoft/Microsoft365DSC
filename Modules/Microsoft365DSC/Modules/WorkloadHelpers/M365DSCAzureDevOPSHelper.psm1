function Invoke-M365DSCAzureDevOPSWebRequest
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
        [System.String]
        $Body
    )

    $headers = @{
        Authorization = $global:MsCloudLoginConnectionProfile.AzureDevOPS.AccessToken
        'Content-Type' = 'application/json-patch+json'
    }

    $params = @{
        Headers = $headers
        Uri     = $Uri
        Method  = $Method

    }

    if ($Method -ne 'GET')
    {
        $params.Add('Body', $Body)
    }

    $response = Invoke-WebRequest @params -UseBasicParsing
    $result = $null
    if (-not [System.String]::IsNullOrEmpty($response.Content))
    {
        $result = ConvertFrom-Json $response.Content
    }
    return $result
}
