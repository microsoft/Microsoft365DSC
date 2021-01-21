function Start-M365DSCConfigurationExtract
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter()]
        [Switch]
        $Quiet,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String[]]
        $ComponentsToExtract,

        [Parameter()]
        [Switch]
        $AllComponents,

        [Parameter()]
        [System.String]
        $Path,

        [Parameter()]
        [System.String]
        $FileName,

        [Parameter()]
        [System.String]
        $ConfigurationName = 'O365TenantConfig',

        [Parameter()]
        [ValidateRange(1, 100)]
        $MaxProcesses = 16,

        [Parameter()]
        [ValidateSet('AAD', 'SPO', 'EXO', 'SC', 'OD', 'O365', 'TEAMS', 'PP')]
        [System.String[]]
        $Workloads,

        [Parameter()]
        [System.Uint32]
        $Start,

        [Parameter()]
        [System.Uint32]
        $End,

        [Parameter()]
        [ValidateSet('Lite', 'Default', 'Full')]
        [System.String]
        $Mode,

        [Parameter()]
        [System.Boolean]
        $GenerateInfo = $false,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    $InformationPreference = "Continue"
    $VerbosePreference = "SilentlyContinue"
    $WarningPreference = "SilentlyContinue"

    $organization = ""
    $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
    if ($null -eq $TenantId -and $GlobalAdminAccount.UserName.Contains("@"))
    {
        $organization = $GlobalAdminAccount.UserName.Split("@")[1]

        if ($organization.IndexOf(".") -gt 0)
        {
            $principal = $organization.Split(".")[0]
        }
    }

    $ComponentsToSkip = @()
    if ($Mode -eq 'Default')
    {
        $ComponentsToSkip = $Global:FullComponents
    }
    elseif ($Mode -eq 'Lite')
    {
        $ComponentsToSkip = $Global:DefaultComponents + $Global:FullComponents
    }

    $AzureAutomation = $false

    $DSCContent = "param (`r`n"
    $DSCContent += "    [parameter()]`r`n"
    $DSCContent += "    [System.Management.Automation.PSCredential]`r`n"
    $DSCContent += "    `$GlobalAdminAccount`r`n"
    $DSCContent += ")`r`n`r`n"

    if (-not [System.String]::IsNullOrEmpty($FileName))
    {
        $FileParts = $FileName.Split('.')

        if ([System.String]::IsNullOrEmpty($ConfigurationName))
        {
            $ConfigurationName = $FileName.Replace('.' + $FileParts[$FileParts.Length - 1], "")
        }
    }
    if ([System.String]::IsNullOrEmpty($ConfigurationName))
    {
        $ConfigurationName = 'M365TenantConfig'
    }
    $DSCContent += "Configuration $ConfigurationName`r`n{`r`n"
    $DSCContent += "    param (`r`n"
    $DSCContent += "        [parameter()]`r`n"
    $DSCContent += "        [System.Management.Automation.PSCredential]`r`n"
    $DSCContent += "        `$GlobalAdminAccount`r`n"
    $DSCContent += "    )`r`n`r`n"
    $DSCContent += "    Import-DscResource -ModuleName Microsoft365DSC`r`n`r`n"
    $DSCContent += "    if (`$null -eq `$GlobalAdminAccount)`r`n"
    $DSCContent += "    {`r`n"
    $DSCContent += "        <# Credentials #>`r`n"
    $DSCContent += "    }`r`n"
    $DSCContent += "    else`r`n"
    $DSCContent += "    {`r`n"
    $DSCContent += "        `$Credsglobaladmin = `$GlobalAdminAccount`r`n"
    $DSCContent += "    }`r`n`r`n"
    $DSCContent += "    `$OrganizationName = `$Credsglobaladmin.UserName.Split('@')[1]`r`n"
    $DSCContent += "    Node localhost`r`n"
    $DSCContent += "    {`r`n"

    Add-ConfigurationDataEntry -Node "localhost" `
        -Key "ServerNumber" `
        -Value "0" `
        -Description "Default Value Used to Ensure a Configuration Data File is Generated"

    # Add the GlobalAdminAccount to the Credentials List
    Save-Credentials -UserName "globaladmin"

    $ResourcesPath = Join-Path -Path $PSScriptRoot `
        -ChildPath "..\DSCResources\" `
        -Resolve
    $AllResources = Get-ChildItem $ResourcesPath -Recurse | Where-Object { $_.Name -like 'MSFT_*.psm1' }

    foreach ($ResourceModule in $AllResources)
    {
        try
        {
            $resourceName = $ResourceModule.Name.Split('.')[0].Replace('MSFT_', '')
            [array]$currentWorkload = $ResourceName.Substring(0, 2)
            switch ($currentWorkload.ToUpper())
            {
                'AA'
                {
                    $currentWorkload = 'AAD';
                    break
                }
                'EX'
                {
                    $currentWorkload = 'EXO';
                    break
                }
                'O3'
                {
                    $currentWorkload = 'O365';
                    break
                }
                'OD'
                {
                    $currentWorkload = 'OD';
                    break
                }
                'PP'
                {
                    $currentWorkload = 'PP';
                    break
                }
                'SC'
                {
                    $currentWorkload = 'SC';
                    break
                }
                'SP'
                {
                    $currentWorkload = 'SPO';
                    break
                }
                'TE'
                {
                    $currentWorkload = 'Teams';
                    break
                }
                default
                {
                    $currentWorkload = $null;
                    break
                }
            }
            if (($null -ne $ComponentsToExtract -and
                    ($ComponentsToExtract -contains $resourceName -or $ComponentsToExtract -contains ("chck" + $resourceName))) -or
                $AllComponents -or ($null -ne $Workloads -and $Workloads -contains $currentWorkload) -or ![System.String]::IsNullOrEmpty($Mode))
            {
                Import-Module $ResourceModule.FullName | Out-Null

                if ($ComponentsToSkip -notcontains $resourceName)
                {
                    Write-Information "Extracting [$resourceName]..."
                    $MaxProcessesExists = (Get-Command 'Export-TargetResource').Parameters.Keys.Contains("MaxProcesses")
                    if ($MaxProcessesExists)
                    {
                        $exportString = Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount -MaxProcesses $MaxProcesses
                    }
		    elseif (-not [System.String]::IsNullOrEmpty($ApplicationID))
		    {
			$exportString = Export-TargetResource -ApplicationId $ApplicationId -TenantId $TenantId -CertificateThumbprint $CertificateThumbprint
		    }
                    else
                    {
                        $exportString = Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount -Start $Start -End $End
                    }
                }
                $DSCContent += $exportString
            }
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message $ResourceModule.Name -Source "[M365DSCReverse]$($ResourceModule.Name)"
        }
    }

    # Close the Node and Configuration declarations
    $DSCContent += "    }`r`n"
    $DSCContent += "}`r`n"

    #region Add the Prompt for Required Credentials at the top of the Configuration
    $credsContent = ""
    foreach ($credential in $Global:CredsRepo)
    {
        if (!$credential.ToLower().StartsWith("builtin"))
        {
            if (!$AzureAutomation)
            {
                $credsContent += "        " + (Resolve-Credentials $credential) + " = Get-Credential -Message `"Global Admin credentials`""
            }
            else
            {
                $resolvedName = (Resolve-Credentials $credential)
                $credsContent += "    " + $resolvedName + " = Get-AutomationPSCredential -Name " + ($resolvedName.Replace("$", "")) + "`r`n"
            }
        }
    }
    $credsContent += "`r`n"
    $startPosition = $DSCContent.IndexOf("<# Credentials #>") + 19
    $DSCContent = $DSCContent.Insert($startPosition, $credsContent)
    $DSCContent += "$ConfigurationName -ConfigurationData .\ConfigurationData.psd1 -GlobalAdminAccount `$GlobalAdminAccount"
    #endregion

    $shouldOpenOutputDirectory = !$Quiet
    #region Prompt the user for a location to save the extract and generate the files
    if ([System.String]::IsNullOrEmpty($Path))
    {
        $shouldOpenOutputDirectory = $true
        $OutputDSCPath = Read-Host "Destination Path"
    }
    else
    {
        $OutputDSCPath = $Path
    }

    while ((Test-Path -Path $OutputDSCPath -PathType Container -ErrorAction SilentlyContinue) -eq $false)
    {
        try
        {
            Write-Information "Directory `"$OutputDSCPath`" doesn't exist; creating..."
            New-Item -Path $OutputDSCPath -ItemType Directory | Out-Null
            if ($?)
            {
                break
            }
        }
        catch
        {
            Write-Warning "$($_.Exception.Message)"
            Write-Warning "Could not create folder $OutputDSCPath!"
        }
        $OutputDSCPath = Read-Host "Please Provide Output Folder for DSC Configuration (Will be Created as Necessary)"
    }
    <## Ensures the path we specify ends with a Slash, in order to make sure the resulting file path is properly structured. #>
    if (!$OutputDSCPath.EndsWith("\") -and !$OutputDSCPath.EndsWith("/"))
    {
        $OutputDSCPath += "\"
    }
    #endregion

    #region Copy Downloaded files back into output folder
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOApp")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains('SPO')))
    {
        $filesToDownload = Get-AllSPOPackages -GlobalAdminAccount $GlobalAdminAccount
        if ($filesToDownload.Count -gt 0)
        {
            foreach ($fileToCopy in $filesToDownload)
            {
                $filePath = Join-Path $env:Temp $fileToCopy.Name -Resolve
                $destPath = Join-Path $OutputDSCPath $fileToCopy.Name
                Copy-Item -Path $filePath -Destination $destPath
            }
        }
    }
    #endregion

    if (-not [System.String]::IsNullOrEmpty($FileName))
    {
        $outputDSCFile = $OutputDSCPath + $FileName
    }
    else
    {
        $outputDSCFile = $OutputDSCPath + "M365TenantConfig.ps1"
    }
    $DSCContent | Out-File $outputDSCFile

    if (!$AzureAutomation)
    {
        $outputConfigurationData = $OutputDSCPath + "ConfigurationData.psd1"
        New-ConfigurationDataDocument -Path $outputConfigurationData
    }

    if ($shouldOpenOutputDirectory)
    {
        Invoke-Item -Path $OutputDSCPath
    }
}
