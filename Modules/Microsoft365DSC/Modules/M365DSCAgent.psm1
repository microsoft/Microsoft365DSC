# This function tests the configuration of the agent
function Test-M365DSCAgent
{
    [CmdletBinding()]
    param(

    )
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Event", "TestAgent")
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    [array]$Recommendations = @()
    [array]$Issues = @()
    $TotalSteps = 3

    #region PowerShell Version
    Write-Progress -Activity "Scanning PowerShell Version..." -PercentComplete (1/$TotalSteps*100)
    $CurrentPSVersion = [version]$PSVersionTable.PSVersion

    if ($CurrentPSVersion -lt [version]5.1)
    {
        $Recommendations += @{
            ID = 'R1'
            Message = "We recommend installing PowerShell 5.1. You can download and install it from: " + `
                "https://www.microsoft.com/en-us/download/details.aspx?id=54616"
            }
    }
    elseif ($CurrentPSVersion -ge [version]"6.0")
    {
        $Issues += @{
            ID = 'I1'
            Message = "Microsoft365DSC is not supported with PowerShell Version $CurrentPSVersion. Please install version 5.1 from: " + `
                   "https://www.microsoft.com/en-us/download/details.aspx?id=54616"
        }
    }
    #endregion

    # We need to do a quick configuration of WinRM in order to be able to obtain configuration information;
    Write-Progress -Activity "Scanning WinRM MaxEnvelopeSize..." -PercentComplete (2/$TotalSteps*100)
    WinRM QuickConfig -Force | Out-Null

    #region MaxEnvelopeSize
    $CurrentMaxEnvelopeSize = (Get-Item -Path WSMan:\localhost\MaxEnvelopeSizekb).Value

    if ($CurrentMaxEnvelopeSize -le 1024)
    {
        $Recommendations += @{
            ID = 'R1'
            Message ="We recommend increasing the MaxEnvelopeSize of the agent's WinRM to a minimum of 10 Mb." + `
                " To make the change, run: Set-Item -Path WSMan:\localhost\MaxEnvelopeSizekb -Value 10240"
        }
    }
    #endregion

    #region Modules Dependencies
    Write-Progress -Activity "Scanning Dependencies..." -PercentComplete (3/$TotalSteps*100)
    $M365DSC = Get-Module Microsoft365DSC
    $ManifestPath = Join-Path -Path $M365DSC.ModuleBase -ChildPath 'Microsoft365DSC.psd1'
    $manifest = Import-PowerShellDataFile $ManifestPath
    $dependencies = $manifest.RequiredModules
    foreach ($dependency in $dependencies)
    {
        $module = Get-Module $dependency.ModuleName -ListAvailable | `
                        Where-Object -FilterScript {$_.Version -eq $dependency.RequiredVersion }
        if ($null -eq $module)
        {
            $Issues += @{
                ID = 'I2'
                Message ="M365DSC has a dependency on module $($dependency.ModuleName) which was not found. You need to install " + `
                    "this module by running: Install-Module $($dependency.ModuleName) -RequiredVersion $($dependency.RequiredVersion) -Force"
            }
        }
    }
    #endregion

    Write-Progress -Completed -Activity "Completed Analysis"
    if ($Issues.Count -gt 0)
    {
        Write-Information -MessageData ("The following issues were detected with the current agent's configuration. Please take " + `
                          "proper action to remediate.")
        $i = 1
        foreach ($issue in $Issues)
        {
            Write-Error -Message "    [$i/$($Issues.Count)] $($issue.Message)"
        }
    }

    if ($Recommendations.Count -gt 0)
    {
        Write-Information -MessageData "The following recommendations were issued. We strongly recommend adressing those: "
        $i = 1
        foreach ($recommendation in $Recommendations)
        {
            Write-Warning "    [$i/$($Recommendations.Count)] $($recommendation.Message)"
        }
    }

    if ($Recommendations.Count -eq 0 -and $Issues.Count -eq 0)
    {
        Write-Information -MessageData "The agent is properly configured."
    }
}
