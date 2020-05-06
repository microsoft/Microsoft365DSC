# This function tests the configuration of the agent
function Test-M365DSCAgent
{
    [CmdletBinding()]
    param(

    )
    $InformationPreference = 'Continue'

    [array]$Recommendations = @()
    [array]$Issues = @()

    #region PowerShell Version
    Write-Information -MessageData "Scanning PowerShell Version..."
    $CurrentPSVersion = $PSVersionTable.PSVersion

    if ($CurrentPSVersion -lt 5.1)
    {
        $Recommendations += "We recommend installing PowerShell 5.1. You can download and install it from: " + `
                            "https://www.microsoft.com/en-us/download/details.aspx?id=54616"
    }
    elseif ($CurrentPSVersion -ge 6)
    {
        $Issues += "Microsoft365DSC is not supported with PowerShell Version $CurrentPSVersion. Please install version 5.q from: " + `
                   "https://www.microsoft.com/en-us/download/details.aspx?id=54616"
    }
    #endregion

    # We need to do a quick configuration of WinRM in order to be able to obtain configuration information;
    WinRM QuickConfig -Force | Out-Null

    #region MaxEnvelopeSize
    $CurrentMaxEnvelopeSize = (Get-Item -Path WSMan:\localhost\MaxEnvelopeSizekb).Value

    if ($CurrentMaxEnvelopeSize -le 1024)
    {
        $Recommendations += "We recommend increasing the MaxEnvelopeSize of the agent's WinRM to a minimum of 10 Mb." + `
                            " To make the change, run: Set-Item -Path WSMan:\localhost\MaxEnvelopeSizekb -Value 10240"
    }
    #endregion

    if ($Issues.Count -gt 0)
    {
        Write-Information -MessageData "The following issues were detected with the current agent's configuration. Please take " + `
                          "proper action to remediate."
        $i = 1
        foreach ($issue in $Issues)
        {
            Write-Error -Message "    [$i/$($Issues.Count)]$issue"
        }
    }

    if ($Recommendations.Count -gt 0)
    {
        Write-Information -MessageData "The following recommendations were issued. We strongly recommend adressing those: "
        $i = 1
        foreach ($recommendation in $Recommendations)
        {
            Write-Warning "    [$i/$($Recommendations.Count)]$recommendation"
        }
    }

    if ($Recommendations.Count -eq 0 -and $Issues.Count -eq 0)
    {
        Write-Information -MessageData "The agent is properly configured."
    }
}
