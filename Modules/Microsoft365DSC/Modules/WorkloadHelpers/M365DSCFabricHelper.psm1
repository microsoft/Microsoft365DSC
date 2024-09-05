function Invoke-M365DSCFabricWebRequest
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
        Authorization = $global:MsCloudLoginConnectionProfile.Fabric.AccessToken
    }

    $response = Invoke-WebRequest -Method $Method -Uri $Uri -Headers $headers -Body $Body
    $result = ConvertFrom-Json $response.Content
    return $result
}
