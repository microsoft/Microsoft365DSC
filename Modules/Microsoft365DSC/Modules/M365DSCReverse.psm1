<#
.Description
This function orchestrate the export process between Export-M365DSCConfiguration
and the ReverseDSC module.

.Functionality
Internal
#>
function Start-M365DSCConfigurationExtract
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String[]]
        $Components,

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
        $Mode = 'Default',

        [Parameter()]
        [System.Boolean]
        $GenerateInfo = $false,

        [Parameter()]
        [System.Collections.Hashtable]
        $Filters,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    # Start by checking to see if a new Version of the tool is available in the
    # PowerShell Gallery
    try
    {
        Test-M365DSCNewVersionAvailable
    }
    catch
    {
        Add-M365DSCEvent -Message $_ -Source 'M365DSCReverse::Test-M365DSCNewVersionAvailable'
    }
    try
    {
        $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
        $M365DSCExportStartTime = [System.DateTime]::Now
        $InformationPreference = 'Continue'
        $VerbosePreference = 'SilentlyContinue'
        $WarningPreference = 'SilentlyContinue'

        if ($null -ne $Workloads)
        {
            $Components = Get-M365DSCResourcesByWorkloads -Workloads $Workloads `
                -Mode $Mode
        }

        if ($null -eq $Components -or $Components.Length -eq 0)
        {
            $ComponentsSpecified = $false
        }
        else
        {
            $ComponentsSpecified = $true
        }

        $ComponentsToSkip = @()
        if ($Mode -eq 'Default' -and $null -eq $Components)
        {
            $ComponentsToSkip = $Global:FullComponents
        }
        elseif ($Mode -eq 'Lite' -and $null -eq $Components)
        {
            $ComponentsToSkip = $Global:DefaultComponents + $Global:FullComponents
        }

        # Check to validate that based on the received authentication parameters
        # we are allowed to export the selected components.
        $AuthMethods = @()

        Write-Host -Object ' '
        Write-Host -Object 'Authentication methods specified:'
        if ($null -ne $Credential)
        {
            Write-Host -Object '- Credentials'
            $AuthMethods += 'Credentials'
        }
        if (-not [System.String]::IsNullOrEmpty($CertificateThumbprint))
        {
            Write-Host -Object '- Service Principal with Certificate Thumbprint'
            $AuthMethods += 'CertificateThumbprint'
        }

        if (-not [System.String]::IsNullOrEmpty($CertificatePath))
        {
            Write-Host -Object '- Service Principal with Certificate Path'
            $AuthMethods += 'CertificatePath'
        }

        if (-not [System.String]::IsNullOrEmpty($ApplicationSecret))
        {
            Write-Host -Object '- Service Principal with Application Secret'
            $AuthMethods += 'ApplicationWithSecret'
        }

        if ($ManagedIdentity.IsPresent)
        {
            Write-Host -Object '- Managed Identity'
            $AuthMethods += 'ManagedIdentity'
        }

        Write-Host -Object ' '

        $allSupportedResourcesWithMostSecureAuthMethod = Get-M365DSCComponentsWithMostSecureAuthenticationType -AuthenticationMethod $AuthMethods

        # If some resources are not supported based on the Authentication parameters
        # received, write a warning.
        if ($Components.Length -eq 0)
        {
            $allResourcesInModule = Get-M365DSCAllResources
            $selectedItems = Compare-Object -ReferenceObject $allResourcesInModule `
                -DifferenceObject $ComponentsToSkip | Where-Object -FilterScript { $_.SideIndicator -eq '<=' }
            $selectedResources = @()
            foreach ($item in $selectedItems)
            {
                $selectedResources += $item.InputObject
            }
        }
        else
        {
            $selectedResources = $Components
        }

        try
        {
            if ($allSupportedResources.Length -eq 0)
            {
                $allSupportedResources = @()
            }
            if ($selectedResources.Length -eq 0)
            {
                $selectedResources = @()
            }
            [Array]$compareResourcesResult = Compare-Object -ReferenceObject $allSupportedResourcesWithMostSecureAuthMethod.Resource `
                -DifferenceObject $selectedResources | Where-Object -FilterScript { $_.SideIndicator -eq '=>' }
        }
        catch
        {
            Write-Verbose -Message $_
        }

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

            Write-Host '[WARNING]' -NoNewline -ForegroundColor Yellow
            Write-Host ' Based on the provided Authentication parameters, the following resources cannot be extracted: ' -ForegroundColor Gray
            Write-Host "$resourcesNotSupported" -ForegroundColor Gray

            # If all selected resources are not valid based on the authentication method used, simply return.
            if ($ComponentsToSkip.Length -eq $selectedResources.Length)
            {
                return
            }
        }

        # Get Tenant Info
        $organization = ''
        if ($AuthMethods -contains 'CertificateThumbprint' -or `
                $AuthMethods -contains 'CertificatePath' -or `
                $AuthMethods -contains 'ApplicationWithSecret')
        {
            $organization = Get-M365DSCTenantDomain -ApplicationId $ApplicationId `
                -TenantId $TenantId
        }
        elseif ($AuthMethods -Contains 'Credentials')
        {
            if ($null -ne $Credential -and $Credential.UserName.Contains('@'))
            {
                $organization = $Credential.UserName.Split('@')[1]
            }
        }
        elseif ($AuthMethods -contains 'ManagedIdentity')
        {
            $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' -InboundParameters @{'ManagedIdentity' = $true }
            $TenantId = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.TenantId
            $organization = $TenantId
        }

        $AzureAutomation = $false
        if ($organization.IndexOf('.') -gt 0)
        {
            $principal = $organization.Split('.')[0]
        }

        [array] $version = Get-Module 'Microsoft365DSC'
        $version = $version[0].Version
        $DSCContent = [System.Text.StringBuilder]::New()
        $DSCContent.Append("# Generated with Microsoft365DSC version $version`r`n") | Out-Null
        $DSCContent.Append("# For additional information on how to use Microsoft365DSC, please visit https://aka.ms/M365DSC`r`n") | Out-Null
        $DSCContent.Append("param (`r`n") | Out-Null

        # Add script parameters, only add PSCredential parameters. All other information
        # is placed in the Configuration Data file.
        $newline = $false
        switch ($AuthMethods)
        {
            'CertificatePath'
            {
                if ($newline)
                {
                    $DSCContent.Append("`r`n") | Out-Null
                }
                $DSCContent.Append("    [parameter()]`r`n") | Out-Null
                $DSCContent.Append("    [System.Management.Automation.PSCredential]`r`n") | Out-Null
                $DSCContent.Append("    `$CertificatePassword`r`n") | Out-Null
                $newline = $true
            }
            'Credentials'
            {
                if ($newline)
                {
                    $DSCContent.Append("`r`n") | Out-Null
                }
                $DSCContent.Append("    [parameter()]`r`n") | Out-Null
                $DSCContent.Append("    [System.Management.Automation.PSCredential]`r`n") | Out-Null
                $DSCContent.Append("    `$Credential`r`n") | Out-Null
                $newline = $true
            }
        }

        $DSCContent.Append(")`r`n`r`n") | Out-Null

        # Create Configuration section
        if (-not [System.String]::IsNullOrEmpty($FileName))
        {
            $FileParts = $FileName.Split('.')

            if ([System.String]::IsNullOrEmpty($ConfigurationName))
            {
                $ConfigurationName = $FileName.Replace('.' + $FileParts[$FileParts.Length - 1], '')
            }
        }
        if ([System.String]::IsNullOrEmpty($ConfigurationName))
        {
            $ConfigurationName = 'M365TenantConfig'
        }
        $DSCContent.Append("Configuration $ConfigurationName`r`n{`r`n") | Out-Null

        # Adding Parameter section
        $DSCContent.Append("    param (`r`n") | Out-Null

        $newline = $false
        $postParamContent = [System.Text.StringBuilder]::New()
        switch ($AuthMethods)
        {
            { $_ -in 'CertificateThumbprint', 'CertificatePath', 'ApplicationWithSecret' }
            {
                $postParamContent.Append("    `$OrganizationName = `$ConfigurationData.NonNodeData.OrganizationName`r`n") | Out-Null

                Add-ConfigurationDataEntry -Node 'NonNodeData' `
                    -Key 'OrganizationName' `
                    -Value $organization `
                    -Description "Tenant's default verified domain name"
                Add-ConfigurationDataEntry -Node 'NonNodeData' `
                    -Key 'ApplicationId' `
                    -Value $ApplicationId `
                    -Description 'Azure AD Application Id for Authentication'
                Add-ConfigurationDataEntry -Node 'NonNodeData' `
                    -Key 'TenantId' `
                    -Value $TenantId `
                    -Description 'The Id or Name of the tenant to authenticate against'
            }
            'CertificateThumbprint'
            {
                Add-ConfigurationDataEntry -Node 'NonNodeData' `
                    -Key 'CertificateThumbprint' `
                    -Value $CertificateThumbprint `
                    -Description 'Thumbprint of the certificate to use for authentication'
            }
            'CertificatePath'
            {
                if ($newline)
                {
                    $DSCContent.Append("`r`n") | Out-Null
                }
                $DSCContent.Append("        [parameter()]`r`n") | Out-Null
                $DSCContent.Append("        [System.Management.Automation.PSCredential]`r`n") | Out-Null
                $DSCContent.Append("        `$CertificatePassword`r`n") | Out-Null

                if ($newline)
                {
                    $postParamContent.Append("`r`n") | Out-Null
                }
                $postParamContent.Append("    if (`$null -eq `$CertificatePassword)`r`n") | Out-Null
                $postParamContent.Append("    {`r`n") | Out-Null
                $postParamContent.Append("        <# Credentials #>`r`n") | Out-Null
                $postParamContent.Append("    }`r`n") | Out-Null
                $postParamContent.Append("    else`r`n") | Out-Null
                $postParamContent.Append("    {`r`n") | Out-Null
                $postParamContent.Append("        `$CredsCertificatePassword = `$CertificatePassword`r`n") | Out-Null
                $postParamContent.Append("    }`r`n`r`n") | Out-Null

                Add-ConfigurationDataEntry -Node 'NonNodeData' `
                    -Key 'CertificatePath' `
                    -Value $CertificatePath `
                    -Description 'Local path to the .pfx certificate to use for authentication'

                $newline = $true

                # Add the Certificate Password to the Credentials List
                Save-Credentials -UserName 'certificatepassword'
            }
            'ApplicationWithSecret'
            {
                Add-ConfigurationDataEntry -Node 'NonNodeData' `
                    -Key 'ApplicationSecret' `
                    -Value $ApplicationSecret `
                    -Description 'Azure AD Application Secret for Authentication'
            }
            'Credentials'
            {
                if ($newline)
                {
                    $DSCContent.Append("`r`n") | Out-Null
                }
                $DSCContent.Append("        [parameter()]`r`n") | Out-Null
                $DSCContent.Append("        [System.Management.Automation.PSCredential]`r`n") | Out-Null
                $DSCContent.Append("        `$Credential`r`n") | Out-Null

                if ($newline)
                {
                    $postParamContent.Append("`r`n") | Out-Null
                }
                $postParamContent.Append("    if (`$null -eq `$Credential)`r`n") | Out-Null
                $postParamContent.Append("    {`r`n") | Out-Null
                $postParamContent.Append("        <# Credentials #>`r`n") | Out-Null
                $postParamContent.Append("    }`r`n") | Out-Null
                $postParamContent.Append("    else`r`n") | Out-Null
                $postParamContent.Append("    {`r`n") | Out-Null
                $postParamContent.Append("        `$CredsCredential = `$Credential`r`n") | Out-Null
                $postParamContent.Append("    }`r`n`r`n") | Out-Null
                $postParamContent.Append("    `$OrganizationName = `$CredsCredential.UserName.Split('@')[1]`r`n") | Out-Null

                $newline = $true

                # Add the Credential to the Credentials List
                Save-Credentials -UserName 'credential'
            }
        }
        $DSCContent.Append("    )`r`n`r`n") | Out-Null
        $DSCContent.Append($postParamContent.ToString()) | Out-Null
        $DSCContent.Append("`r`n") | Out-Null

        # Create Node section
        $DSCContent.Append("    Import-DscResource -ModuleName 'Microsoft365DSC' -ModuleVersion '$version'`r`n`r`n") | Out-Null
        $DSCContent.Append("    Node localhost`r`n") | Out-Null
        $DSCContent.Append("    {`r`n") | Out-Null

        Add-ConfigurationDataEntry -Node 'localhost' `
            -Key 'ServerNumber' `
            -Value '0' `
            -Description 'Default Value Used to Ensure a Configuration Data File is Generated'

        $ResourcesPath = Join-Path -Path $PSScriptRoot `
            -ChildPath '..\DSCResources\' `
            -Resolve
        $AllResources = Get-ChildItem $ResourcesPath -Recurse | Where-Object { $_.Name -like 'MSFT_*.psm1' }

        $i = 1
        $ResourcesToExport = @()
        $ResourcesPath = @()
        foreach ($ResourceModule in $AllResources)
        {
            try
            {
                $resourceName = $ResourceModule.Name.Split('.')[0] -replace 'MSFT_', ''

                if ((($Components -and ($Components -contains $resourceName)) -or $AllComponents -or `
                        (-not $Components -and $null -eq $Workloads)) -and `
                    ($ComponentsSpecified -or ($ComponentsToSkip -notcontains $resourceName)) -and `
                        $resourcesNotSupported -notcontains $resourceName)
                {
                    $ResourcesToExport += $ResourceName
                    $ResourcesPath += $ResourceModule
                }
            }
            catch
            {
                New-M365DSCLogEntry -Error $_ -Message $ResourceModule.Name -Source "[M365DSCReverse]$($ResourceModule.Name)"
            }
        }

        # Retrieve the list of Workloads represented by the resources to export and pre-authenticate to each one;
        if ($ResourcesToExport.Length -gt 0)
        {
            $WorkloadsToConnectTo = Get-M365DSCWorkloadsListFromResourceNames -ResourceNames $ResourcesToExport
        }
        foreach ($Workload in $WorkloadsToConnectTo)
        {
            Write-Host "Connecting to {$Workload}..." -NoNewline
            $ConnectionParams = @{
                Workload              = $Workload
                ApplicationId         = $ApplicationId
                ApplicationSecret     = $ApplicationSecret
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword.Password
                Credential            = $Credential
                Identity              = $ManagedIdentity.IsPresent
            }
            try
            {
                Connect-M365Tenant @ConnectionParams | Out-Null
                Write-Host $Global:M365DSCEmojiGreenCheckmark
            }
            catch
            {
                Write-Host $Global:M365DSCEmojiRedX
                throw $_
            }
        }

        foreach ($resource in $ResourcesPath)
        {
            $resourceName = $resource.Name.Split('.')[0] -replace 'MSFT_', ''
            $mostSecureAuthMethod = ($allSupportedResourcesWithMostSecureAuthMethod | Where-Object { $_.Resource -eq $resourceName }).AuthMethod

            Import-Module $resource.FullName | Out-Null
            $MaxProcessesExists = (Get-Command 'Export-TargetResource').Parameters.Keys.Contains('MaxProcesses')
            $FilterExists = (Get-Command 'Export-TargetResource').Parameters.Keys.Contains('Filter')

            $parameters = @{}
            switch ($mostSecureAuthMethod)
            {
                { $_ -in 'CertificateThumbprint', 'CertificatePath', 'ApplicationSecret' }
                {
                    $parameters.Add('ApplicationId', $ApplicationId)
                    $parameters.Add('TenantId', $TenantId)
                }
                'CertificateThumbprint'
                {
                    $parameters.Add('CertificateThumbprint', $CertificateThumbprint)
                }
                'CertificatePath'
                {
                    $parameters.Add('CertificatePath', $CertificatePath)
                    $parameters.Add('CertificatePassword', $CertificatePassword)
                }
                'ApplicationSecret'
                {
                    $parameters.Add('ApplicationSecret', $ApplicationSecret)
                }
                'Credentials'
                {
                    $parameters.Add('Credential', $Credential)
                }
                'ManagedIdentity'
                {
                    $parameters.Add('ManagedIdentity', $ManagedIdentity)
                }
            }

            if ($MaxProcessesExists -and -not [System.String]::IsNullOrEmpty($MaxProcesses))
            {
                $parameters.Add('MaxProcesses', $MaxProcesses)
            }

            if ($FilterExists -and -not [System.String]::IsNullOrEmpty($Filter))
            {
                $parameters.Add('Filter', $Filter)
            }

            if ($ComponentsToSkip -notcontains $resourceName)
            {
                Write-Host "[$i/$($ResourcesToExport.Length)] Extracting [$resourceName] using {$mostSecureAuthMethod}..." -NoNewline
                $exportString = [System.Text.StringBuilder]::New()
                if ($GenerateInfo)
                {
                    $exportString.Append("`r`n        # For information on how to use this resource, please refer to:`r`n") | Out-Null
                    $exportString.Append("        # https://github.com/microsoft/Microsoft365DSC/wiki/$($resource.Name.Split('.')[0] -replace 'MSFT_', '')`r`n") | Out-Null
                }

                # Check if filters for the current resource were specified.
                $resourceFilter = $null
                $resourceName = $resource.Name.Split('.')[0] -replace 'MSFT_', ''
                if ($filters -ne $null -and $filters.Keys.Contains($resourceName))
                {
                    $resourceFilter = $Filters.($resource.Name.Split('.')[0] -replace 'MSFT_', '')
                    if ($FilterExists)
                    {
                        $parameters.Add('Filter', $resourceFilter)
                    }
                    elseif ($null -ne $resourceFilter)
                    {
                        Write-Host "    `r`n$($Global:M365DSCEmojiYellowCircle) You specified a filter for resource {$resourceName} but it doesn't support filters. Filter will be ignored and all instances of the resource will be captured."
                    }
                }

                $exportString.Append((Export-TargetResource @parameters)) | Out-Null
                $i++
            }
            $DSCContent.Append($exportString.ToString()) | Out-Null
        }

        # Close the Node and Configuration declarations
        $DSCContent.Append("    }`r`n") | Out-Null
        $DSCContent.Append("}`r`n") | Out-Null

        # Azure Automation Check
        $AzureAutomation = $false
        if ('AzureAutomation/' -eq $env:AZUREPS_HOST_ENVIRONMENT)
        {
            $AzureAutomation = $true
        }

        $launchCommand = "$ConfigurationName -ConfigurationData .\ConfigurationData.psd1"
        switch ($AuthMethods)
        {
            'CertificatePath'
            {
                $certCreds = $Global:CredsRepo[0]
                $credsContent = ''
                $credsContent += '        ' + (Resolve-Credentials $certCreds) + " = Get-Credential -Message `"Certificate Password`""
                $credsContent += "`r`n"
                $startPosition = $DSCContent.IndexOf('<# Credentials #>') + 19
                $DSCContent = $DSCContent.Insert($startPosition, $credsContent)
                $launchCommand += " -CertificatePassword `$CertificatePassword"
            }
            'Credentials'
            {
                #region Add the Prompt for Required Credentials at the top of the Configuration
                $credsContent = ''
                foreach ($credEntry in $Global:CredsRepo)
                {
                    if (!$credEntry.ToLower().StartsWith('builtin'))
                    {
                        if (!$AzureAutomation)
                        {
                            $credsContent += '        ' + (Resolve-Credentials $credEntry) + " = Get-Credential -Message `"Credentials`"`r`n"
                        }
                        else
                        {
                            $resolvedName = (Resolve-Credentials $credEntry)
                            $credsContent += '    ' + $resolvedName + ' = Get-AutomationPSCredential -Name ' + ($resolvedName.Replace('$', '')) + "`r`n"
                        }
                    }
                }
                $credsContent += "`r`n"
                $startPosition = $DSCContent.ToString().IndexOf('<# Credentials #>') + 19
                $DSCContent = $DSCContent.Insert($startPosition, $credsContent)
                $launchCommand += " -Credential `$Credential"
                #endregion
            }
        }

        $DSCContent.Append("`r`n") | Out-Null
        $DSCContent.Append($launchCommand) | Out-Null

        #region Benchmarks
        $M365DSCExportEndTime = [System.DateTime]::Now
        $timeTaken = New-TimeSpan -Start ($M365DSCExportStartTime.ToString()) `
            -End ($M365DSCExportEndTime.ToString())
        Write-Host "$($Global:M365DSCEmojiHourglass) Export took {" -NoNewline
        Write-Host "$($timeTaken.TotalSeconds) seconds" -NoNewline -ForegroundColor Cyan
        Write-Host '}'
        #endregion

        $sessions = Get-PSSession | Where-Object -FilterScript { $_.Name -like 'SfBPowerShellSessionViaTeamsModule_*' -or `
                $_.Name -like 'ExchangeOnlineInternalSession*' }
        foreach ($session in $sessions)
        {
            try
            {
                Write-Verbose -Message "Closing PSSession {$($session.Name)}"
                Remove-PSSession $session | Out-Null
            }
            catch
            {
                Write-Verbose -Message $_
            }
        }

        $shouldOpenOutputDirectory = $false
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
                Write-Host "Directory `"$OutputDSCPath`" doesn't exist; creating..."
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
            $OutputDSCPath = Read-Host 'Please Provide Output Folder for DSC Configuration (Will be Created as Necessary)'
        }
        <## Ensures the path we specify ends with a Slash, in order to make sure the resulting file path is properly structured. #>
        if (!$OutputDSCPath.EndsWith('\') -and !$OutputDSCPath.EndsWith('/'))
        {
            $OutputDSCPath += '\'
        }
        #endregion

        #region Copy Downloaded files back into output folder
        if (($null -ne $Components -and
                $Components.Contains('SPOApp')) -or
            $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains('SPO')))
        {
            if ($ConnectionMode -eq 'credential')
            {
                $filesToDownload = Get-AllSPOPackages -Credential $Credential
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
            $outputDSCFile = $OutputDSCPath + 'M365TenantConfig.ps1'
        }
        $DSCContent.ToString() | Out-File $outputDSCFile

        if (!$AzureAutomation)
        {
            if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
            {
                $LCMConfig = Get-DscLocalConfigurationManager
                if ($null -ne $LCMConfig.CertificateID)
                {
                    try
                    {
                        # Export the certificate assigned to the LCM
                        $certPath = $OutputDSCPath + 'M365DSC.cer'
                        Export-Certificate -FilePath $certPath `
                            -Cert "cert:\LocalMachine\my\$($LCMConfig.CertificateID)" `
                            -Type CERT `
                            -NoClobber | Out-Null
                    }
                    catch
                    {
                        Write-Verbose -Message $_
                        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
                    }

                    Add-ConfigurationDataEntry -Node 'localhost' `
                        -Key 'CertificateFile' `
                        -Value 'M365DSC.cer' `
                        -Description 'Path of the certificate used to encrypt credentials in the file.'
                }
            }
            else
            {
                Write-Host "$($Global:M365DSCEmojiYellowCircle) Warning {" -NoNewline
                Write-Host "Cannot export Local Configuration Manager settings. This process isn't executed with Administrative Privileges!" -NoNewline -ForegroundColor DarkCyan
                Write-Host '}'
            }
            $outputConfigurationData = $OutputDSCPath + 'ConfigurationData.psd1'
            New-ConfigurationDataDocument -Path $outputConfigurationData
        }

        if ($shouldOpenOutputDirectory)
        {
            try
            {
                Invoke-Item -Path $OutputDSCPath
            }
            catch
            {
                Write-Verbose -Message $_
            }
        }
    }
    catch
    {
        Write-Host $_
        $partialPath = Join-Path $env:TEMP -ChildPath "$($Global:PartialExportFileName)"
        Write-Host "Partial Export file was saved at: $partialPath"
    }
}

<#
.Description
This function gets all resources for the specified workloads

.Functionality
Internal, Hidden
#>
function Get-M365DSCResourcesByWorkloads
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String[]]
        $Workloads,

        [Parameter()]
        [ValidateSet('Lite', 'Default', 'Full')]
        [System.String]
        $Mode = 'Default'
    )

    $modules = Get-ChildItem -Path ($PSScriptRoot + '\..\DSCResources\') -Recurse -Filter '*.psm1'
    $Components = @()
    foreach ($Workload in $Workloads)
    {
        Write-Host "Finding all resources for workload {$Workload} and Mode {$Mode}" -ForegroundColor Gray

        foreach ($resource in $modules)
        {
            $ResourceName = $resource.Name -replace 'MSFT_', '' -replace '.psm1', ''

            if ($ResourceName.StartsWith($Workload, 'CurrentCultureIgnoreCase') -and
                ($Mode -eq 'Full' -or `
                ($Mode -eq 'Default' -and -not $Global:FullComponents.Contains($ResourceName)) -or `
                ($Mode -eq 'Lite' -and -not $Global:FullComponents.Contains($ResourceName) -and -not $Global:DefaultComponents.Contains($ResourceName))))
            {
                $Components += $ResourceName
            }
        }
    }
    return $Components
}

Export-ModuleMember -Function @(
    'Start-M365DSCConfigurationExtract'
)
