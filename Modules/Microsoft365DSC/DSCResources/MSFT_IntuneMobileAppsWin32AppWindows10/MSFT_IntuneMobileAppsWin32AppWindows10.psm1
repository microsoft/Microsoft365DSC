Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneMobileAppsWin32AppWindows10'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Developer,

        [Parameter()]
        [System.String]
        $InformationUrl,

        [Parameter()]
        [System.Boolean]
        $IsFeatured,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LargeIcon,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        $PrivacyInformationUrl,

        [Parameter()]
        [System.String]
        $Publisher,

        [Parameter()]
        [System.String]
        $FileName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Categories,

        [Parameter()]
        [System.String]
        $InstallCommandLine,

        [Parameter()]
        [System.String]
        $UninstallCommandLine,

        [Parameter()]
        [ValidateSet('none', 'x86', 'x64', 'arm64')]
        [System.String[]]
        $AllowedArchitectures,

        [Parameter()]
        [System.Int32]
        $MinimumFreeDiskSpaceInMB,

        [Parameter()]
        [System.Int32]
        $MinimumMemoryInMB,

        [Parameter()]
        [System.Int32]
        $MinimumNumberOfProcessors,

        [Parameter()]
        [System.Int32]
        $MinimumCpuSpeedInMHz,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Rules,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InstallExperience,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ReturnCodes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MsiInformation,

        [Parameter()]
        [System.String]
        $SetupFilePath,

        [Parameter()]
        [System.String]
        $MinimumSupportedWindowsRelease,

        [Parameter()]
        [System.String]
        $DisplayVersion,

        [Parameter()]
        [System.Boolean]
        $AllowAvailableUninstall,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration for the Intune Mobile Apps Win32 App for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {

            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $getValue = $null

            #region resource generator code
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $Id -ExpandProperty 'Categories' -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Mobile Apps Win32 App for Windows10 with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceAppManagementMobileApp `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")' and isof('microsoft.graph.win32LobApp')" `
                        -ExpandProperty 'Categories' `
                        -All `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Mobile Apps Win32 App for Windows10 with DisplayName {$DisplayName}."
                return $nullResult
            }

            $getValue = Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $getValue.Id -ExpandProperty 'Categories'
        }
        else
        {
            $getValue = Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $Script:exportedInstance.Id -ExpandProperty 'Categories'
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Mobile Apps Win32 App for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found"

        #region resource generator code
        $complexCategories = @()
        foreach ($category in $getValue.Categories)
        {
            $myCategory = [ordered]@{}
            $myCategory.Add('Id', $category.id)
            $myCategory.Add('DisplayName', $category.displayName)
            $complexCategories += $myCategory
        }
        $complexLargeIcon = $null
        if ($null -ne $getValue.LargeIcon.Value)
        {
            $complexLargeIcon = [ordered]@{}
            $complexLargeIcon.Add('Type', $getValue.LargeIcon.Type)
            $complexLargeIcon.Add('Value', [System.Convert]::ToBase64String($getValue.LargeIcon.Value))
        }

        $complexRules = @()
        foreach ($rule in $getValue.AdditionalProperties.rules)
        {
            $ruleType = $rule.'@odata.type'.Replace('#microsoft.graph.win32LobApp', '').Replace('Rule', '')
            $baseRule = @{
                OdataType       = $ruleType
                RuleType        = $rule.ruleType
                Operator        = $rule.operator
                ComparisonValue = $rule.comparisonValue
            }
            switch ($ruleType)
            {
                'FileSystem'
                {
                    $baseRule.Add('Check32BitOn64System', $rule.check32BitOn64System)
                    $baseRule.Add('Path', $rule.path)
                    $baseRule.Add('FileOrFolderName', $rule.fileOrFolderName)
                    $baseRule.Add('FileSystemOperationType', $rule.operationType)
                }
                'Registry'
                {
                    $baseRule.Add('Check32BitOn64System', $rule.check32BitOn64System)
                    $baseRule.Add('KeyPath', $rule.keyPath)
                    $baseRule.Add('RegistryOperationType', $rule.operationType)
                    $baseRule.Add('ValueName', $rule.valueName)
                }
                'ProductCode'
                {
                    $baseRule.Add('ProductCode', $rule.productCode)
                    $baseRule.Add('ProductVersionOperator', $rule.productVersionOperator)
                    $baseRule.Add('ProductVersion', $rule.productVersion)
                    $baseRule.Remove('Operator') | Out-Null
                    $baseRule.Remove('ComparisonValue') | Out-Null
                }
                'PowerShellScript'
                {
                    $baseRule.Add('DisplayName', $rule.displayName)
                    $baseRule.Add('Script', [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($rule.scriptContent)))
                    $baseRule.Add('RunAs32Bit', $rule.runAs32Bit)
                    $baseRule.Add('EnforceSignatureCheck', $rule.enforceSignatureCheck)
                    $baseRule.Add('RunAsAccount', $rule.runAsAccount)
                    $baseRule.Add('PowerShellScriptOperationType', $rule.operationType)
                }
            }
            $complexRules += $baseRule
        }

        if ($null -ne $getValue.AdditionalProperties.installExperience)
        {
            $complexInstallExperience = [ordered]@{}
            $complexInstallExperience.Add('DeviceRestartBehavior', $getValue.AdditionalProperties.installExperience.deviceRestartBehavior)
            $complexInstallExperience.Add('MaxRunTimeInMinutes', $getValue.AdditionalProperties.installExperience.maxRunTimeInMinutes)
            $complexInstallExperience.Add('RunAsAccount', $getValue.AdditionalProperties.installExperience.runAsAccount)
        }

        $complexReturnCodes = @()
        foreach ($returnCode in $getValue.AdditionalProperties.returnCodes)
        {
            $complexReturnCodes += @{
                ReturnCode = $returnCode.returnCode
                Type       = $returnCode.type
            }
        }

        if ($null -ne $getValue.AdditionalProperties.msiInformation)
        {
            $complexMsiInformation = [ordered]@{}
            $complexMsiInformation.Add('ProductCode', $getValue.AdditionalProperties.msiInformation.productCode)
            $complexMsiInformation.Add('ProductVersion', $getValue.AdditionalProperties.msiInformation.productVersion)
            $complexMsiInformation.Add('UpgradeCode', $getValue.AdditionalProperties.msiInformation.upgradeCode)
            $complexMsiInformation.Add('RequiresReboot', $getValue.AdditionalProperties.msiInformation.requiresReboot)
            $complexMsiInformation.Add('PackageType', $getValue.AdditionalProperties.msiInformation.packageType)
            $complexMsiInformation.Add('ProductName', $getValue.AdditionalProperties.msiInformation.productName)
            $complexMsiInformation.Add('Publisher', $getValue.AdditionalProperties.msiInformation.publisher)
        }
        #endregion

        [System.String[]]$allowedArchitecturesValue = @()
        foreach ($arch in ($getValue.AdditionalProperties.allowedArchitectures -split ',' | Where-Object { -not [System.String]::IsNullOrEmpty($_) }))
        {
            $allowedArchitecturesValue += $arch
        }

        $results = @{
            #region resource generator code
            AllowedArchitectures           = $allowedArchitecturesValue
            Categories                     = $complexCategories
            Description                    = $getValue.Description
            Developer                      = $getValue.Developer
            DisplayName                    = $getValue.DisplayName
            FileName                       = $getValue.AdditionalProperties.fileName
            InformationUrl                 = $getValue.InformationUrl
            InstallCommandLine             = $getValue.AdditionalProperties.installCommandLine
            UninstallCommandLine           = $getValue.AdditionalProperties.uninstallCommandLine
            MinimumFreeDiskSpaceInMB       = $getValue.AdditionalProperties.minimumFreeDiskSpaceInMB
            MinimumMemoryInMB              = $getValue.AdditionalProperties.minimumMemoryInMB
            MinimumNumberOfProcessors      = $getValue.AdditionalProperties.minimumNumberOfProcessors
            MinimumCpuSpeedInMHz           = $getValue.AdditionalProperties.minimumCpuSpeedInMHz
            InstallExperience              = $complexInstallExperience
            ReturnCodes                    = $complexReturnCodes
            Rules                          = $complexRules
            MsiInformation                 = $complexMsiInformation
            SetupFilePath                  = $getValue.AdditionalProperties.setupFilePath
            MinimumSupportedWindowsRelease = $getValue.AdditionalProperties.minimumSupportedWindowsRelease
            DisplayVersion                 = $getValue.AdditionalProperties.displayVersion
            AllowAvailableUninstall        = $getValue.AdditionalProperties.allowAvailableUninstall
            IsFeatured                     = $getValue.IsFeatured
            LargeIcon                      = $complexLargeIcon
            Notes                          = $getValue.Notes
            Owner                          = $getValue.Owner
            PrivacyInformationUrl          = $getValue.PrivacyInformationUrl
            Publisher                      = $getValue.Publisher
            RoleScopeTagIds                = $getValue.RoleScopeTagIds
            Id                             = $getValue.Id
            Ensure                         = 'Present'
            Credential                     = $Credential
            ApplicationId                  = $ApplicationId
            TenantId                       = $TenantId
            ApplicationSecret              = $ApplicationSecret
            CertificateThumbprint          = $CertificateThumbprint
            ManagedIdentity                = $ManagedIdentity.IsPresent
            #endregion
        }
        $assignmentsValues = Get-MgBetaDeviceAppManagementMobileAppAssignment -MobileAppId $Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntuneMobileAppAssignment -Assignments $assignmentsValues -IncludeDeviceFilter $true
        }
        $results.Add('Assignments', $assignmentResult)

        return $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Developer,

        [Parameter()]
        [System.String]
        $InformationUrl,

        [Parameter()]
        [System.Boolean]
        $IsFeatured,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LargeIcon,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        $PrivacyInformationUrl,

        [Parameter()]
        [System.String]
        $Publisher,

        [Parameter()]
        [System.String]
        $FileName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Categories,

        [Parameter()]
        [System.String]
        $InstallCommandLine,

        [Parameter()]
        [System.String]
        $UninstallCommandLine,

        [Parameter()]
        [ValidateSet('none', 'x86', 'x64', 'arm64')]
        [System.String[]]
        $AllowedArchitectures,

        [Parameter()]
        [System.Int32]
        $MinimumFreeDiskSpaceInMB,

        [Parameter()]
        [System.Int32]
        $MinimumMemoryInMB,

        [Parameter()]
        [System.Int32]
        $MinimumNumberOfProcessors,

        [Parameter()]
        [System.Int32]
        $MinimumCpuSpeedInMHz,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Rules,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InstallExperience,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ReturnCodes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MsiInformation,

        [Parameter()]
        [System.String]
        $SetupFilePath,

        [Parameter()]
        [System.String]
        $MinimumSupportedWindowsRelease,

        [Parameter()]
        [System.String]
        $DisplayVersion,

        [Parameter()]
        [System.Boolean]
        $AllowAvailableUninstall,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of the Intune Mobile Apps Win32 App for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $boundParameters.Remove('Categories') | Out-Null

    if ($boundParameters.ContainsKey('AllowedArchitectures'))
    {
        if ($boundParameters.AllowedArchitectures -contains 'none' -and $boundParameters.AllowedArchitectures.Count -gt 1)
        {
            throw "AllowedArchitectures cannot contain 'none' when other architectures are specified."
        }

        $boundParameters.Remove('AllowedArchitectures') | Out-Null
        $boundParameters.Add('AllowedArchitectures', ($PSBoundParameters.AllowedArchitectures -join ','))
        $PSBoundParameters.Add('ApplicableArchitectures', 'none')
        $boundParameters.Add('ApplicableArchitectures', 'none')

        if ([System.String]::IsNullOrEmpty($boundParameters.AllowedArchitectures))
        {
            $boundParameters.AllowedArchitectures = $null
        }
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Mobile Apps Win32 App for Windows10 with DisplayName {$DisplayName}"
        $boundParameters.Remove('Assignments') | Out-Null

        if (-not $boundParameters.ContainsKey('FileName') -or [System.String]::IsNullOrEmpty($boundParameters.FileName))
        {
            throw 'FileName is required to create an Intune Mobile Apps Win32 App for Windows10.'
        }

        $createParameters = ([Hashtable]$boundParameters).Clone()
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('Id') | Out-Null

        if ($createParameters.ContainsKey('Rules'))
        {
            $rulesToProcess = @()
            $rulesToProcess = $createParameters.Rules

            foreach ($rule in $rulesToProcess)
            {
                $odataType = $rule.'@odata.type'
                $rule.'@odata.type' = "#microsoft.graph.win32LobApp$($odataType)Rule"
                switch ($odataType)
                {
                    'FileSystem'
                    {
                        $rule.Add('operationType', $rule.fileSystemOperationType)
                        $rule.Remove('fileSystemOperationType') | Out-Null
                    }
                    'Registry'
                    {
                        $rule.Add('operationType', $rule.registryOperationType)
                        $rule.Remove('registryOperationType') | Out-Null
                    }
                    'PowerShellScript'
                    {
                        $rule.Add('scriptContent', [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($rule.script)))
                        $rule.Remove('script') | Out-Null
                        $rule.Add('operationType', $rule.powerShellScriptOperationType)
                        $rule.Remove('powerShellScriptOperationType') | Out-Null
                    }
                }
            }

            $createParameters.Rules = $rulesToProcess
        }
        #region resource generator code
        $createParameters.Add('@odata.type', '#microsoft.graph.win32LobApp')
        $policy = Invoke-MgGraphRequest -Method POST -Uri '/beta/deviceAppManagement/mobileApps' -Body ($createParameters | ConvertTo-Json -Depth 10)

        Invoke-M365DSCIntuneMobileAppInitialUpload -AppId $policy.Id -OdataType '#microsoft.graph.win32LobApp' -FileExtension 'intunewin'

        if ($PSBoundParameters.ContainsKey('Categories'))
        {
            Update-DeviceAppManagementAppCategory -App $policy -Categories $Categories
        }

        if ($policy.Id)
        {
            $assignmentsHash = ConvertTo-IntuneMobileAppAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceAppManagementPolicyAssignment `
                -AppManagementPolicyId $policy.Id `
                -Assignments $assignmentsHash
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Mobile Apps Win32 App for Windows10 with Id {$($currentInstance.Id)}"
        $boundParameters.Remove('Assignments') | Out-Null

        $updateParameters = ([Hashtable]$boundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters
        $updateParameters.Remove('Id') | Out-Null

        if ($updateParameters.ContainsKey('Rules'))
        {
            $rulesToProcess = @()
            $rulesToProcess = $updateParameters.Rules

            foreach ($rule in $rulesToProcess)
            {
                $odataType = $rule.'@odata.type'
                $rule.'@odata.type' = "#microsoft.graph.win32LobApp$($odataType)Rule"
                switch ($odataType)
                {
                    'FileSystem'
                    {
                        $rule.Add('operationType', $rule.fileSystemOperationType)
                        $rule.Remove('fileSystemOperationType') | Out-Null
                    }
                    'Registry'
                    {
                        $rule.Add('operationType', $rule.registryOperationType)
                        $rule.Remove('registryOperationType') | Out-Null
                    }
                    'PowerShellScript'
                    {
                        $rule.Add('scriptContent', [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($rule.script)))
                        $rule.Remove('script') | Out-Null
                        $rule.Add('operationType', $rule.powerShellScriptOperationType)
                        $rule.Remove('powerShellScriptOperationType') | Out-Null
                    }
                }
            }

            $updateParameters.Rules = $rulesToProcess
        }

        #region resource generator code
        $updateParameters.Add('@odata.type', '#microsoft.graph.win32LobApp')
        Invoke-MgGraphRequest -Method PATCH -Uri "/beta/deviceAppManagement/mobileApps/$($currentInstance.Id)" -Body ($updateParameters | ConvertTo-Json -Depth 10)

        if ($PSBoundParameters.ContainsKey('Categories'))
        {
            Update-DeviceAppManagementAppCategory -App $currentInstance -Categories $Categories -Compare
        }

        $assignmentsHash = ConvertTo-IntuneMobileAppAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceAppManagementPolicyAssignment `
            -AppManagementPolicyId $currentInstance.Id `
            -Assignments $assignmentsHash
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Mobile Apps Win32 App for Windows10 with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceAppManagementMobileApp -MobileAppId $currentInstance.Id
        #endregion
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Developer,

        [Parameter()]
        [System.String]
        $InformationUrl,

        [Parameter()]
        [System.Boolean]
        $IsFeatured,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LargeIcon,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        $PrivacyInformationUrl,

        [Parameter()]
        [System.String]
        $Publisher,

        [Parameter()]
        [System.String]
        $FileName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Categories,

        [Parameter()]
        [System.String]
        $InstallCommandLine,

        [Parameter()]
        [System.String]
        $UninstallCommandLine,

        [Parameter()]
        [ValidateSet('none', 'x86', 'x64', 'arm64')]
        [System.String[]]
        $AllowedArchitectures,

        [Parameter()]
        [System.Int32]
        $MinimumFreeDiskSpaceInMB,

        [Parameter()]
        [System.Int32]
        $MinimumMemoryInMB,

        [Parameter()]
        [System.Int32]
        $MinimumNumberOfProcessors,

        [Parameter()]
        [System.Int32]
        $MinimumCpuSpeedInMHz,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Rules,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InstallExperience,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ReturnCodes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MsiInformation,

        [Parameter()]
        [System.String]
        $SetupFilePath,

        [Parameter()]
        [System.String]
        $MinimumSupportedWindowsRelease,

        [Parameter()]
        [System.String]
        $DisplayVersion,

        [Parameter()]
        [System.Boolean]
        $AllowAvailableUninstall,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        #region resource generator code
        $baseFilter = "isof('microsoft.graph.win32LobApp')"
        if (-not [String]::IsNullOrEmpty($Filter))
        {
            $Filter = "($Filter) and ($baseFilter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = Get-MgBetaDeviceAppManagementMobileApp `
            -Filter $Filter `
            -All `
            -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            elseif (-not [string]::IsNullOrEmpty($config.name))
            {
                $displayedKey = $config.name
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            if ($null -ne $Results.Categories)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Categories `
                    -CIMInstanceName 'DeviceManagementMobileAppCategory'

                if (-not [System.String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Categories = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Categories') | Out-Null
                }
            }
            if ($null -ne $Results.Rules)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Rules `
                    -CIMInstanceName 'MicrosoftGraphWin32LobAppRule'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Rules = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Rules') | Out-Null
                }
            }
            if ($null -ne $Results.InstallExperience)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.InstallExperience `
                    -CIMInstanceName 'MicrosoftGraphWin32LobAppInstallExperience'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.InstallExperience = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('InstallExperience') | Out-Null
                }
            }
            if ($null -ne $Results.ReturnCodes)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ReturnCodes `
                    -CIMInstanceName 'MicrosoftGraphWin32LobAppReturnCode'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ReturnCodes = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ReturnCodes') | Out-Null
                }
            }
            if ($null -ne $Results.MsiInformation)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.MsiInformation `
                    -CIMInstanceName 'MicrosoftGraphWin32LobAppMsiInformation'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.MsiInformation = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MsiInformation') | Out-Null
                }
            }
            if ($null -ne $Results.LargeIcon)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.LargeIcon `
                    -CIMInstanceName 'DeviceManagementMimeContent'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.LargeIcon = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('LargeIcon') | Out-Null
                }
            }

            if ($Results.Assignments)
            {
                $complexMapping = @(
                    @{
                        Name            = 'AssignmentSettings'
                        CIMInstanceName = 'DeviceManagementWin32MobileAppAssignmentSettings'
                        IsRequired      = $false
                    },
                    @{
                        Name            = 'AutoUpdateSettings'
                        CIMInstanceName = 'DeviceManagementWin32MobileAppAssignmentSettingsAutoUpdateSettings'
                        IsRequired      = $false
                    },
                    @{
                        Name            = 'InstallTimeSettings'
                        CIMInstanceName = 'DeviceManagementWin32MobileAppAssignmentSettingsInstallTimeSettings'
                        IsRequired      = $false
                    },
                    @{
                        Name            = 'RestartSettings'
                        CIMInstanceName = 'DeviceManagementWin32MobileAppAssignmentSettingsRestartSettings'
                        IsRequired      = $false
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Assignments `
                    -CIMInstanceName DeviceManagementWin32MobileAppAssignment `
                    -ComplexTypeMapping $complexMapping
                if ($complexTypeStringResult)
                {
                    $Results.Assignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Assignments') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Assignments', 'Categories', 'Rules', 'LargeIcon', 'InstallExperience', 'ReturnCodes', 'MsiInformation')
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
