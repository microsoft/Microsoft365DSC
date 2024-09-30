<#
.Description
This function tests the configuration of the agent

.Example
Test-M365DSCAgent

.Functionality
Public
#>
function Test-M365DSCAgent
{
    [CmdletBinding()]
    param(

    )
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add('Event', 'TestAgent')
    Add-M365DSCTelemetryEvent -Data $data -Type 'TestAgent'
    #endregion

    [array]$Recommendations = @()
    [array]$Issues = @()
    $TotalSteps = 3

    #region PowerShell Version
    Write-Progress -Activity 'Scanning PowerShell Version...' -PercentComplete (1 / $TotalSteps * 100)
    $CurrentPSVersion = [version]$PSVersionTable.PSVersion

    if ($CurrentPSVersion -lt [version]5.1)
    {
        $Recommendations += @{
            ID      = 'R1'
            Message = 'We recommend installing PowerShell 5.1. You can download and install it from: ' + `
                'https://www.microsoft.com/en-us/download/details.aspx?id=54616'
        }
    }
    elseif ($CurrentPSVersion -ge [version]'6.0')
    {
        $Issues += @{
            ID      = 'I1'
            Message = "Microsoft365DSC is not supported with PowerShell Version $CurrentPSVersion. Please install version 5.1 from: " + `
                'https://www.microsoft.com/en-us/download/details.aspx?id=54616'
        }
    }
    #endregion

    # We need to do a quick configuration of WinRM in order to be able to obtain configuration information;
    Write-Progress -Activity 'Scanning WinRM MaxEnvelopeSize...' -PercentComplete (2 / $TotalSteps * 100)
    WinRM QuickConfig -Force | Out-Null

    #region MaxEnvelopeSize
    $CurrentMaxEnvelopeSize = (Get-Item -Path WSMan:\localhost\MaxEnvelopeSizekb).Value

    if ($CurrentMaxEnvelopeSize -le 1024)
    {
        $Recommendations += @{
            ID      = 'R1'
            Message = "We recommend increasing the MaxEnvelopeSize of the agent's WinRM to a minimum of 10 Mb." + `
                ' To make the change, run: Set-Item -Path WSMan:\localhost\MaxEnvelopeSizekb -Value 10240'
        }
    }
    #endregion

    #region Modules Dependencies
    Write-Progress -Activity 'Scanning Dependencies...' -PercentComplete (3 / $TotalSteps * 100)
    $dependencies = Update-M365DSCDependencies -ValidateOnly
    foreach ($dependency in $dependencies)
    {
        $Issues += @{
            ID      = 'I2'
            Message = "M365DSC has a dependency on module $($dependency.ModuleName) which was not found. You need to install " + `
                "this module by running: Install-Module $($dependency.ModuleName) -RequiredVersion $($dependency.RequiredVersion) -Force"
        }
    }
    #endregion

    Write-Progress -Completed -Activity 'Completed Analysis'
    if ($Issues.Count -gt 0)
    {
        $errorMessage = "The following issues were detected with the current agent's configuration. Please take " + `
            "proper action to remediate. `r`n"
        $i = 1
        foreach ($issue in $Issues)
        {
            $errorMessage += "    [$i/$($Issues.Count)] $($issue.Message)`r`n"
        }
        Write-Error -Message $errorMessage -ErrorAction Continue
    }

    if ($Recommendations.Count -gt 0)
    {
        $warningMessage = 'The following recommendations were issued. We strongly recommend adressing those: '
        $i = 1
        foreach ($recommendation in $Recommendations)
        {
            $warningMessage += "    [$i/$($Recommendations.Count)] $($recommendation.Message)`r`n"
        }
        Write-Warning -Message $warningMessage
    }

    if ($Recommendations.Count -eq 0 -and $Issues.Count -eq 0)
    {
        Write-Host 'The agent is properly configured.'
    }
}

<#
.Description
This function configures the LCM with a self signed encryption certificate

.Parameter KeepCertificate
Specifies that the temporarily created CER file should not be deleted.

.Parameter ForceRenew
Specifies that a new certificate should be forcefully created.

.Parameter GeneratePFX
Specifies that a PFX export should be created for the generated certificate.

.Parameter Password
Specifies the password for the PFX file.

.Example
Set-M365DSCAgentCertificateConfiguration -KeepCertificate

.Example
Set-M365DSCAgentCertificateConfiguration -GeneratePFX -Password 'P@ssword123!'

.Functionality
Public
#>
function Set-M365DSCAgentCertificateConfiguration
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter()]
        [Switch]
        $KeepCertificate,

        [Parameter()]
        [Switch]
        $ForceRenew,

        [Parameter()]
        [Switch]
        $GeneratePFX,

        [Parameter()]
        [System.String]
        $Password = 'Temp!P@ss123'
    )

    $existingCertificate = Get-ChildItem -Path Cert:\LocalMachine\My | `
        Where-Object { $_.Subject -match 'M365DSCEncryptionCert' }

    if ($ForceRenew)
    {
        foreach ($cert in $existingCertificate)
        {
            Remove-Item $cert.PSPath | Out-Null
        }
        $existingCertificate = $null
    }
    if ($null -eq $existingCertificate)
    {
        Write-Verbose -Message 'No existing M365DSC certificate found. Creating one.'
        $certificateFilePath = "$env:Temp\M365DSC.cer"
        $cert = New-SelfSignedCertificate -Type DocumentEncryptionCertLegacyCsp `
            -DnsName 'Microsoft365DSC' `
            -Subject 'M365DSCEncryptionCert' `
            -HashAlgorithm SHA256 `
            -NotAfter (Get-Date).AddYears(10)
        $cert | Export-Certificate -FilePath $certificateFilePath -Force | Out-Null
        Import-Certificate -FilePath $certificateFilePath `
            -CertStoreLocation 'Cert:\LocalMachine\My' -Confirm:$false | Out-Null
        $existingCertificate = Get-ChildItem -Path Cert:\LocalMachine\My | `
            Where-Object { $_.Subject -match 'M365DSCEncryptionCert' }
    }
    else
    {
        Write-Verbose -Message 'An existing M365DSc certificate was found. Re-using it.'
    }
    $thumbprint = $existingCertificate.Thumbprint
    Write-Verbose -Message "Using M365DSCEncryptionCert with thumbprint {$thumbprint}"

    $configOutputFile = $env:Temp + '\M365DSCAgentLCMConfig.ps1'
    $LCMConfigContent = @"
    [DSCLocalConfigurationManager()]
    Configuration M365AgentConfig
    {
        Node Localhost
        {
            Settings
            {
                CertificateID = '$thumbprint'
            }
        }
    }
    M365AgentConfig | Out-Null
    Set-DSCLocalConfigurationManager M365AgentConfig -Force
"@
    $LCMConfigContent | Out-File $configOutputFile
    & $configOutputFile

    if ($KeepCertificate)
    {
        Write-Host "Certificate {$thumbprint} was stored under {$($env:Temp)} with name M365DSC.cer and M365DSC.pfx"
    }
    else
    {
        try
        {
            Remove-Item -Path $configOutputFile -Confirm:$false -ErrorAction SilentlyContinue
            Remove-Item -Path './M365AgentConfig' -Recurse -Confirm:$false -ErrorAction SilentlyContinue
        }
        catch
        {
            Write-Error $_
        }
    }

    if ($GeneratePFX)
    {
        if ($Password -eq $null)
        {
            Throw 'When the GeneratePFX switch is used, you also need to provide a password.'
        }
        $securePassword = ConvertTo-SecureString -String $password -Force -AsPlainText
        Export-PfxCertificate -Cert $existingCertificate.PSPath `
            -FilePath $certificateFilePath.Replace('.cer', '.pfx') `
            -Password $securePassword | Out-Null
        Write-Host "Private Key stored at {$($certificateFilePath.Replace('.cer','.pfx'))}"
    }
    return $thumbprint
}

Export-ModuleMember -Function @(
    'Set-M365DSCAgentCertificateConfiguration',
    'Test-M365DSCAgent'
)
