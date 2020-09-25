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
        $ConfigurationName = 'M365TenantConfig',

        [Parameter()]
        [ValidateRange(1, 100)]
        $MaxProcesses = 16,

        [Parameter()]
        [ValidateSet('AAD', 'SPO', 'EXO', 'INTUNE', 'SC', 'OD', 'O365', 'TEAMS', 'PP', 'PLANNER')]
        [System.String[]]
        $Workloads,

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
    $M365DSCExportStartTime = [System.DateTime]::Now
    $InformationPreference = "Continue"
    $VerbosePreference = "SilentlyContinue"
    $WarningPreference = "SilentlyContinue"

    if ($null -eq $ComponentsToExtract -or $ComponentsToExtract.Length -eq 0)
    {
        $ComponentsToExtractSpecified = $false
    }
    else
    {
        $ComponentsToExtractSpecified = $true
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

    # Check to validate that based on the received authentication parameters
    # we are allowed to export the selected components.
    $AuthMethods = @()
    $controlCredentials = @()
    if ($null -ne $GlobalAdminAccount)
    {
        $AuthMethods += "Credentials"
    }
    if (-not [System.String]::IsNullOrEmpty($CertificateThumbprint) -or `
        -not [System.String]::IsNullOrEmpty($CertificatePassword) -or `
        -not [System.String]::IsNullOrEmpty($CertificatePath) -or `
        -not [System.String]::IsNullOrEmpty($TenantId))
    {
        $AuthMethods += "Certificate"
    }
    if (-not [System.String]::IsNullOrEmpty($ApplicationId))
    {
        $AuthMethods += "Application"
    }
    $allSupportedResources = Get-M365DSCComponentsForAuthenticationType -AuthenticationMethod $AuthMethods

    # If some resources are not supported based on the Authentication parameters
    # received, write a warning.
    if ($ComponentsToExtract.Length -eq 0)
    {
        $allResourcesInModule = Get-M365DSCAllResources
        $selectedItems = Compare-Object -ReferenceObject $allResourcesInModule `
            -DifferenceObject $ComponentsToSkip | Where-Object -FilterScript {$_.SideIndicator -eq '<='}
        $selectedResources = @()
        foreach ($item in $selectedItems)
        {
            $selectedResources += $item.InputObject
        }
    }
    else
    {
        $selectedResources = $ComponentsToExtract
    }
    $compareResourcesResult = Compare-Object -ReferenceObject $allSupportedResources `
        -DifferenceObject $selectedResources | Where-Object -FilterScript {$_.SideIndicator -eq '=>'}
    if ($null -ne $compareResourcesResult)
    {
        # The client is trying to extract act least one resource which is not supported
        # using only the provided authentication parameters;
        $resourcesNotSupported = @()
        foreach ($resource in $compareResourcesResult)
        {
            $resourcesNotSupported += $resource.InputObject

            # Skip resources that are not supported;
            $ComponentsToSkip += $resource.InputObject
        }

        Write-Host "[WARNING]" -NoNewLine -ForegroundColor Yellow
        Write-Host " Based on the provided Authentication parameters, the following resources cannot be extracted: " -ForegroundColor Gray
        Write-Host "$resourcesNotSupported" -ForegroundColor Gray
    }

    if (-not $PSBoundParameters.ContainsKey('Quiet'))
    {
        $unattendedCommand = "Export-M365DSCConfiguration -Quiet -ComponentsToExtract @("
        foreach ($resource in $ComponentsToExtract)
        {
            if ($resource -ne 'Credential' -and $resource -ne 'Application' -and `
            $resource -ne 'Certificate')
            {
                $unattendedCommand += "'$resource',"
            }
        }
        $unattendedCommand = $unattendedCommand.Substring(0, $unattendedCommand.Length -1)
        $unattendedCommand += ")"
        Write-Host "[INFO]" -NoNewLine -ForegroundColor Cyan
        Write-Host " You can perform an equivalent unattended Export operation by running the following command:" -ForegroundColor Gray
        Write-Host $unattendedCommand -ForegroundColor Blue
    }

    # Get Tenant Info
    $organization = ""
    $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)

    if ($AuthMethods -Contains 'Application')
    {
        $ConnectionMode = 'ServicePrincipal'
        $organization = Get-M365DSCTenantDomain -ApplicationId $ApplicationId `
            -TenantId $TenantId `
            -CertificateThumbprint $CertificateThumbprint
    }
    elseif ($AuthMethods -Contains 'Certificate')
    {
        $ConnectionMode = 'ServicePrincipal'
        $organization = $TenantId
    }
    elseif ($AuthMethods -Contains 'Credentials')
    {
        $ConnectionMode = 'Credential'
        if ($null -ne $GlobalAdminAccount -and $GlobalAdminAccount.UserName.Contains("@"))
        {
            $organization = $GlobalAdminAccount.UserName.Split("@")[1]
        }
    }
    if ($organization.IndexOf(".") -gt 0)
    {
        $principal = $organization.Split(".")[0]
    }
    $AzureAutomation = $false
    $version = (Get-Module 'Microsoft365DSC').Version
    $DSCContent = "# Generated with Microsoft365DSC version $version`r`n"
    $DSCContent += "# For additional information on how to use Microsoft365DSC, please visit https://aka.ms/M365DSC`r`n"
    if ($ConnectionMode -eq 'Credential')
    {
        $DSCContent += "param (`r`n"
        $DSCContent += "    [parameter()]`r`n"
        $DSCContent += "    [System.Management.Automation.PSCredential]`r`n"
        $DSCContent += "    `$GlobalAdminAccount`r`n"
        $DSCContent += ")`r`n`r`n"
    }
    else
    {
        if (-not [System.String]::IsNullOrEmpty($CertificatePassword))
        {
            $DSCContent += "param (`r`n"
            $DSCContent += "    [parameter()]`r`n"
            $DSCContent += "    [System.Management.Automation.PSCredential]`r`n"
            $DSCContent += "    `$CertificatePassword`r`n"
            $DSCContent += ")`r`n`r`n"
        }
    }

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

    if ($ConnectionMode -eq 'Credential')
    {
        $DSCContent += "    param (`r`n"
        $DSCContent += "        [parameter()]`r`n"
        $DSCContent += "        [System.Management.Automation.PSCredential]`r`n"
        $DSCContent += "        `$GlobalAdminAccount`r`n"
        $DSCContent += "    )`r`n`r`n"
        $DSCContent += "    if (`$null -eq `$GlobalAdminAccount)`r`n"
        $DSCContent += "    {`r`n"
        $DSCContent += "        <# Credentials #>`r`n"
        $DSCContent += "    }`r`n"
        $DSCContent += "    else`r`n"
        $DSCContent += "    {`r`n"
        $DSCContent += "        `$Credsglobaladmin = `$GlobalAdminAccount`r`n"
        $DSCContent += "    }`r`n`r`n"
        $DSCContent += "    `$OrganizationName = `$Credsglobaladmin.UserName.Split('@')[1]`r`n"
    }
    else
    {
        if (-not [System.String]::IsNullOrEmpty($CertificatePassword))
        {
            $DSCContent += "    param (`r`n"
            $DSCContent += "        [parameter()]`r`n"
            $DSCContent += "        [System.Management.Automation.PSCredential]`r`n"
            $DSCContent += "        `$CertificatePassword`r`n"
            $DSCContent += "    )`r`n`r`n"
            $DSCContent += "    if (`$null -eq `$CertificatePassword)`r`n"
            $DSCContent += "    {`r`n"
            $DSCContent += "        <# Credentials #>`r`n"
            $DSCContent += "    }`r`n"
            $DSCContent += "    else`r`n"
            $DSCContent += "    {`r`n"
            $DSCContent += "        `$CredsCertificatePassword = `$CertificatePassword`r`n"
            $DSCContent += "    }`r`n`r`n"
        }

        $DSCContent += "    `$OrganizationName = `$ConfigurationData.NonNodeData.OrganizationName`r`n"
        Add-ConfigurationDataEntry -Node "NonNodeData" `
            -Key "OrganizationName" `
            -Value $organization `
            -Description "Tenant's default verified domain name"
        Add-ConfigurationDataEntry -Node "NonNodeData" `
            -Key "ApplicationId" `
            -Value $ApplicationId `
            -Description "Azure AD Application Id for Authentication"
        if (-not [System.String]::IsNullOrEmpty($TenantId))
        {
            Add-ConfigurationDataEntry -Node "NonNodeData" `
                -Key "TenantId" `
                -Value $TenantId `
                -Description "The Id or Name of the tenant to authenticate against"
        }

        if (-not [System.String]::IsNullOrEmpty($CertificatePath))
        {
            Add-ConfigurationDataEntry -Node "NonNodeData" `
                -Key "CertificatePath" `
                -Value $CertificatePath `
                -Description "Local path to the .pfx certificate to use for authentication"
        }

        if (-not [System.String]::IsNullOrEmpty($CertificateThumbprint))
        {
            Add-ConfigurationDataEntry -Node "NonNodeData" `
                -Key "CertificateThumbprint" `
                -Value $CertificateThumbprint `
                -Description "Thumbprint of the certificate to use for authentication"
        }
    }
    $DSCContent += "    Import-DscResource -ModuleName Microsoft365DSC`r`n`r`n"
    $DSCContent += "    Node localhost`r`n"
    $DSCContent += "    {`r`n"

    Add-ConfigurationDataEntry -Node "localhost" `
        -Key "ServerNumber" `
        -Value "0" `
        -Description "Default Value Used to Ensure a Configuration Data File is Generated"

    if ($ConnectionMode -eq 'Credential')
    {
        # Add the GlobalAdminAccount to the Credentials List
        Save-Credentials -UserName "globaladmin"
    }
    else
    {
        Save-Credentials -UserName "certificatepassword"
    }

    $ResourcesPath = Join-Path -Path $PSScriptRoot `
        -ChildPath "..\DSCResources\" `
        -Resolve
    $AllResources = Get-ChildItem $ResourcesPath -Recurse | Where-Object { $_.Name -like 'MSFT_*.psm1' }

    $i = 1
    $ResourcesToExport = @()
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
                'IN'
                {
                    $currentWorkload = 'INTUNE';
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
                'PL'
                {
                    $currentWorkload = 'PLANNER';
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
                $AllComponents -or ($null -ne $Workloads -and $Workloads -contains $currentWorkload) -or `
                ($null -eq $ComponentsToExtract -and $null -eq $Workloads) -and `
                ($ComponentsToExtractSpecified -or -not $ComponentsToSkip.Contains($resourceName)))
            {
                $ResourcesToExport += $ResourceModule
            }
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message $ResourceModule.Name -Source "[M365DSCReverse]$($ResourceModule.Name)"
        }
    }

    foreach ($resource in $ResourcesToExport)
    {
        Import-Module $resource.FullName | Out-Null
        $MaxProcessesExists = (Get-Command 'Export-TargetResource').Parameters.Keys.Contains("MaxProcesses")
        $AppSecretExists = (Get-Command 'Export-TargetResource').Parameters.Keys.Contains("ApplicationSecret")
        $CertThumbprintExists = (Get-Command 'Export-TargetResource').Parameters.Keys.Contains("CertificateThumbprint")
        $TenantIdExists = (Get-Command 'Export-TargetResource').Parameters.Keys.Contains("TenantId")
        $AppIdExists = (Get-Command 'Export-TargetResource').Parameters.Keys.Contains("ApplicationId")
        $GlobalAdminExists = (Get-Command 'Export-TargetResource').Parameters.Keys.Contains("GlobalAdminAccount")
        $CertPathExists = (Get-Command 'Export-TargetResource').Parameters.Keys.Contains("CertificatePath")
        $CertPasswordExists = (Get-Command 'Export-TargetResource').Parameters.Keys.Contains("CertificatePassword")

        $parameters = @{}
        if ($GlobalAdminExists-and -not [System.String]::IsNullOrEmpty($GlobalAdminAccount))
        {
            $parameters.Add("GlobalAdminAccount", $GlobalAdminAccount)
        }
        if ($MaxProcessesExists -and -not [System.String]::IsNullOrEmpty($MaxProcesses))
        {
            $parameters.Add("MaxProcesses", $MaxProcesses)
        }
        if ($AppSecretExists -and -not [System.String]::IsNullOrEmpty($ApplicationSecret))
        {
            $parameters.Add("AppplicationSecret", $ApplicationSecret)
        }
        if ($CertThumbprintExists -and -not [System.String]::IsNullOrEmpty($CertificateThumbprint))
        {
            $parameters.Add("CertificateThumbprint", $CertificateThumbprint)
        }
        if ($TenantIdExists -and -not [System.String]::IsNullOrEmpty($TenantId))
        {
            $parameters.Add("TenantId", $TenantId)
        }
        if ($AppIdExists -and -not [System.String]::IsNullOrEmpty($ApplicationId))
        {
            $parameters.Add("ApplicationId", $ApplicationId)
        }
        if ($CertPathExists -and -not [System.String]::IsNullOrEmpty($CertificatePath))
        {
            $parameters.Add("CertificatePath", $CertificatePath)
        }
        if ($CertPasswordExists -and $null -ne $CertificatePassword)
        {
            $parameters.Add("CertificatePassword", $CertificatePassword)
        }
        if ($ComponentsToSkip -notcontains $resourceName)
        {
            Write-Host "[$i/$($ResourcesToExport.Length)] Extracting [$($resource.Name.Split('.')[0].Replace('MSFT_', ''))]..." -NoNewline
            $exportString = ""
            if ($GenerateInfo)
            {
                $exportString += "`r`n        # For information on how to use this resource, please refer to:`r`n"
                $exportString += "        # https://github.com/microsoft/Microsoft365DSC/wiki/$resourceName`r`n"
            }
            $exportString += Export-TargetResource @parameters
            $i++
        }
        $DSCContent += $exportString
        $exportString = $null
    }

    # Close the Node and Configuration declarations
    $DSCContent += "    }`r`n"
    $DSCContent += "}`r`n"

    if ($ConnectionMode -eq 'Credential')
    {
        #region Add the Prompt for Required Credentials at the top of the Configuration
        $credsContent = ""
        foreach ($credential in $Global:CredsRepo)
        {
            if (!$credential.ToLower().StartsWith("builtin"))
            {
                if (!$AzureAutomation)
                {
                    $credsContent += "        " + (Resolve-Credentials $credential) + " = Get-Credential -Message `"Global Admin credentials`"`r`n"
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
    }
    else
    {
        if (-not [System.String]::IsNullOrEmpty($CertificatePassword))
        {
            $certCreds =$Global:CredsRepo[0]
            $credsContent = ""
            $credsContent += "        " + (Resolve-Credentials $certCreds) + " = Get-Credential -Message `"Certificate Password`""
            $credsContent += "`r`n"
            $startPosition = $DSCContent.IndexOf("<# Credentials #>") + 19
            $DSCContent = $DSCContent.Insert($startPosition, $credsContent)
            $DSCContent += "$ConfigurationName -ConfigurationData .\ConfigurationData.psd1 -CertificatePassword `$CertificatePassword"
        }
        else
        {
            $DSCContent += "$ConfigurationName -ConfigurationData .\ConfigurationData.psd1"
        }
    }

    #region Benchmarks
    $M365DSCExportEndTime = [System.DateTime]::Now
    $timeTaken = New-Timespan -Start ($M365DSCExportStartTime.ToString()) `
        -End ($M365DSCExportEndTime.ToString())
    Write-Host "$($Global:M365DSCEmojiHourglass) Export took {" -NoNewLine
    Write-Host "$($timeTaken.TotalSeconds) seconds" -NoNewLine -ForegroundColor Cyan
    Write-Host "}"
    #endregion

    $shouldOpenOutputDirectory = !$Quiet
    #region Prompt the user for a location to save the extract and generate the files
    if ([System.String]::IsNullOrEmpty($Path))
    {
        $shouldOpenOutputDirectory = $true
        $OutputDSCPath = Read-Host "`r`nDestination Path"
    }
    else
    {
        $OutputDSCPath = $Path
    }

    if ([System.String]::IsNullOrEmpty($OutputDSCPath))
    {
        $OutputDSCPath = '.'
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
        if ($ConnectionMode -eq 'credential')
        {
            $filesToDownload = Get-AllSPOPackages -GlobalAdminAccount $GlobalAdminAccount
        }
        else
        {
            $filesToDownload = Get-AllSPOPackages -ApplicationId $ApplicationId -CertificateThumbprint $CertificateThumbprint `
                -CertificatePassword $CertificatePassword -TenantId $TenantId -CertificatePath $CertificatePath
        }
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
        $LCMConfig = Get-DscLocalConfigurationManager
        if ($null -ne $LCMConfig.CertificateID)
        {
            try
            {
                # Export the certificate assigned to the LCM
                $certPath = $OutputDSCPath + "M365DSC.cer"
                Export-Certificate -FilePath $certPath `
                    -Cert "cert:\LocalMachine\my\$($LCMConfig.CertificateID)" `
                    -Type CERT `
                    -NoClobber | Out-Null
                Add-ConfigurationDataEntry -Node "localhost" `
                    -Key "CertificateFile" `
                    -Value "M365DSC.cer" `
                    -Description "Path of the certificate used to encrypt credentials in the file."
            }
            catch
            {
                Write-Verbose -Message $_
                Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                    -EventID 1 -Source $($MyInvocation.MyCommand.Source)
            }
        }
        $outputConfigurationData = $OutputDSCPath + "ConfigurationData.psd1"
        New-ConfigurationDataDocument -Path $outputConfigurationData
    }

    if ($shouldOpenOutputDirectory)
    {
        Invoke-Item -Path $OutputDSCPath
    }
}
