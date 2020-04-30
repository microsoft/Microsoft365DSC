function Get-M365DSCDataFromGraph
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AccessToken,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Uri
    )

    # Check if authentication was successfull.
    if (-not [System.String]::IsNullOrEmpty($AccessToken))
    {
        if ($AccessToken -notlike 'Bearer *')
        {
            $AccessToken = "Bearer " + $AccessToken
        }

        # Format headers.
        $Headers = @{
            'Authorization' = $AccessToken
        }

        # Create an empty array to store the result.
        $QueryResults = @()

        # Invoke REST method and fetch data until there are no pages left.
        $Results = ""
        $StatusCode = ""

        do
        {
            try
            {
                $Results = Invoke-RestMethod -Headers $Headers -Uri $Uri -UseBasicParsing -Method "GET" -ContentType "application/json"
                $StatusCode = $Results.StatusCode
            }
            catch
            {
                $StatusCode = $_.Exception.Response.StatusCode.value__

                if ($StatusCode -eq 429)
                {
                    Write-Warning "Got throttled by Microsoft. Sleeping for 45 seconds..."
                    Start-Sleep -Seconds 45
                }
                else
                {
                    Write-Error $_.Exception
                }
            }
        } while ($StatusCode -eq 429)

        if ($Results.value)
        {
            $QueryResults += $Results.value
        }
        else
        {
            $QueryResults += $Results
        }

        # Return the result.
        $QueryResults
    }
    else
    {
        Write-Error "No Access Token"
    }
}
