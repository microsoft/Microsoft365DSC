$Script:IsPowerShellCore = $PSVersionTable.PSEdition -eq 'Core'
$Script:IsPsResourceGetAvailable = $null -ne (Get-Module -Name Microsoft.PowerShell.PSResourceGet -ListAvailable)
$Script:M365DSCDependenciesValidated = $false
if ($null -eq $Script:M365DSCDependencies)
{
    $Script:M365DSCDependencies = [System.Collections.Generic.Dictionary[System.String, System.Object]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $dependencies = (Import-PowerShellDataFile "$PSScriptRoot/../Dependencies/Manifest.psd1").Dependencies
    foreach ($dependency in $dependencies)
    {
        # TODO: Review again once ModuleFast can work with additional properties
        # https://github.com/microsoft/Microsoft365DSC/pull/6726
        # https://github.com/ykuijs/M365DSC_CICD/issues/53
        if ($dependency.ModuleName -eq 'PnP.PowerShell')
        {
            $dependency.DependsOn = @('Microsoft.Graph.Authentication')
        }
        $Script:M365DSCDependencies.Add($dependency.ModuleName, $dependency)
    }

    $commandToModuleMap = @{}
    $Script:M365DSCResourceSettings = [System.Collections.Generic.Dictionary[System.String, System.Object]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($file in (Get-ChildItem -Path "$PSScriptRoot/../DSCResources" -Filter 'settings.json' -Recurse)) {
        Write-Verbose -Message "Processing settings.json file at path: $($file.FullName)"
        $jsonContent = [System.IO.File]::ReadAllText($file.FullName) | ConvertFrom-Json
        foreach ($commandMap in $jsonContent.commands) {
            $commandToModuleMap[$commandMap.module] += @($commandMap.cmdlets)
        }
        $directoryName = (Split-Path -Path $file.DirectoryName -Leaf).Replace('MSFT_', '')
        $Script:M365DSCResourceSettings.Add($directoryName, @{
            requiredModules = $jsonContent.requiredModules
            commands = $jsonContent.commands
            mode = $jsonContent.mode
        })
    }

    Write-Verbose -Message "Loading current configuration from config.json"
    $Script:M365DSCValidatedDependencies = [System.Collections.Generic.List[System.String]]::new($Script:M365DSCDependencies.Count)
    $configAsPsCustomObject = Get-Content -Path "$PSScriptRoot/../config.json" | ConvertFrom-Json
    $configAsHashtable = @{}
    foreach ($property in $configAsPsCustomObject.PSObject.Properties)
    {
        $configAsHashtable.Add($property.Name, $property.Value)
    }
    $Script:CurrentConfiguration = $configAsHashtable
    $globalRequiredModules = $Script:CurrentConfiguration.requiredModules
    foreach ($entry in $commandToModuleMap.GetEnumerator())
    {
        $sortedFunctions = @($globalRequiredModules.$($entry.Key)) + @($entry.Value) | Sort-Object -Unique
        $Script:M365DSCDependencies[$entry.Key].Commands = $sortedFunctions
    }
    $Script:M365DSCRequiredModules = @($globalRequiredModules.psobject.Properties.Name)
    $Script:M365DSCRequiredModulesLoaded = $false
}

function Get-M365DSCResourceSettings
{
    [CmdletBinding()]
    param()

    return $Script:M365DSCResourceSettings
}

function Get-M365DSCRequiredModules
{
    [CmdletBinding()]
    param()

    return $Script:M365DSCRequiredModules
}

function Set-M365DSCRequiredModulesLoaded
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Boolean]$Value
    )

    $Script:M365DSCRequiredModulesLoaded = $Value
}

function Test-IsM365DSCRequiredModulesLoaded
{
    [CmdletBinding()]
    param()

    return $Script:M365DSCRequiredModulesLoaded
}

function Get-M365DSCModuleConfiguration
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return $Script:CurrentConfiguration.Clone()
}

function Set-M365DSCModuleConfiguration
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [System.Object]
        $Value
    )

    $Script:CurrentConfiguration.$Key = $Value
}

<#
.DESCRIPTION
    This function checks if all M365DSC dependencies are present

.FUNCTIONALITY
    Internal
#>
function Confirm-M365DSCDependencies
{
    [CmdletBinding()]
    param()

    if (-not $Script:M365DSCDependenciesValidated -and ($null -eq $Global:M365DSCSkipDependenciesValidation -or -not $Global:M365DSCSkipDependenciesValidation))
    {
        Write-Verbose -Message 'Dependencies were not already validated.'

        Test-CodePage
        $result = Update-M365DSCDependencies -ValidateOnly

        if ($result.Length -gt 0)
        {
            $ErrorMessage = "The following dependencies need updating:`r`n"
            foreach ($invalidDependency in $result)
            {
                $ErrorMessage += '    * ' + $invalidDependency.ModuleName + "`r`n"
            }
            $ErrorMessage += 'Please run Update-M365DSCDependencies as Administrator. '
            $Script:M365DSCDependenciesValidated = $false
            Add-M365DSCEvent -Message $ErrorMessage -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
            throw $ErrorMessage
        }
        else
        {
            Write-Verbose -Message 'Dependencies were all successfully validated.'
            $Script:M365DSCDependenciesValidated = $true
        }
    }
    else
    {
        Write-Verbose -Message 'Dependencies were already successfully validated.'
    }
}

<#
.DESCRIPTION
    This function checks if a specific module is loaded and validates its version against the required version specified in the M365DSC dependencies manifest.

.PARAMETER ModuleName
    The name of the module to check and validate.

.EXAMPLE
    PS> Confirm-M365DSCLoadedModule -ModuleName 'Microsoft.Graph.Authentication'

.FUNCTIONALITY
    Internal
#>
function Confirm-M365DSCLoadedModule
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $ModuleName
    )

    if ($Script:M365DSCValidatedDependencies.Contains($ModuleName))
    {
        Write-Verbose -Message "Module '$ModuleName' has already been validated."
        return
    }

    $manifestModule = $Script:M365DSCDependencies[$ModuleName]

    if ($null -ne $manifestModule.DependsOn -and $manifestModule.DependsOn.Count -gt 0)
    {
        foreach ($dependency in $manifestModule.DependsOn)
        {
            Write-Verbose -Message "Validating dependency '$dependency' for module '$ModuleName'."
            Confirm-M365DSCLoadedModule -ModuleName $dependency
        }
    }

    $loadedModule = Get-Module -Name $ModuleName
    if ($null -eq $loadedModule)
    {
        Write-Verbose -Message "Module '$ModuleName' is not loaded. Importing it now."
        $importModuleSplat = @{
            Name             = $ModuleName
            RequiredVersion  = $manifestModule.RequiredVersion
            Global           = $true
            Alias            = @()
            Cmdlet           = @()
            Variable         = @()
            DisableNameChecking = $true
        }
        if ($manifestModule.Commands.Count -gt 0)
        {
            $importModuleSplat.Add('Function', $manifestModule.Commands)
            $importModuleSplat.Cmdlet = $manifestModule.Commands
        }
        if ($ModuleName -eq 'PnP.PowerShell' -and $manifestModule.RequiredVersion -eq '1.12.0' -and $Script:IsPowerShellCore)
        {
            $importModuleSplat.Add('UseWindowsPowerShell', $true)
        }
        Import-Module @importModuleSplat
        Write-Verbose -Message "Module '$ModuleName' with version '$($manifestModule.RequiredVersion)' has been imported."
    }
    elseif ($loadedModule.Version -ne $manifestModule.RequiredVersion)
    {
        Write-Verbose -Message "Module '$ModuleName' is loaded but the version '$($loadedModule.Version)' does not match the required version '$($manifestModule.RequiredVersion)'."
        Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
        Write-Verbose -Message "Unloaded module '$ModuleName' with version '$($loadedModule.Version)'."
        Import-Module -Name $ModuleName -RequiredVersion $manifestModule.RequiredVersion -Global -Alias @() -Cmdlet @() -Variable @() -DisableNameChecking
        Write-Verbose -Message "Re-imported module '$ModuleName' with version '$($manifestModule.RequiredVersion)'."
    }
    else
    {
        Write-Verbose -Message "Module '$ModuleName' is already loaded."
    }

    if (-not $Script:M365DSCValidatedDependencies.Contains($ModuleName))
    {
        $Script:M365DSCValidatedDependencies.Add($ModuleName)
    }
}

<#
.DESCRIPTION
    This function checks the required dependencies for a specific M365DSC module and validates that they are loaded.

.PARAMETER ModuleName
    The name of the DSC resource for which to check dependencies.

.EXAMPLE
    PS> Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADApplication'

.FUNCTIONALITY
    Internal
#>
function Confirm-M365DSCModuleDependency
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $ModuleName
    )

    $Global:MaximumFunctionCount = 32767

    if ($Global:IsTestEnvironment -or (Get-M365DSCModuleConfiguration).skipModuleDependencyValidation)
    {
        Write-Verbose -Message "Skipping module dependency validation in test environment for module '$ModuleName'."
        return
    }

    $modulesToCheck = $Script:M365DSCResourceSettings[$ModuleName.Replace('MSFT_', '')].requiredModules
    foreach ($module in $modulesToCheck)
    {
        Write-Verbose -Message "Validating module dependency: $($module)"
        Confirm-M365DSCLoadedModule -ModuleName $module
    }
    Write-Verbose -Message "All dependencies for module '$ModuleName' have been validated."
}

<#
.DESCRIPTION
    This function checks if new versions are available for the M365DSC dependencies

.EXAMPLE
    PS> Test-M365DSCDependenciesForNewVersions

.FUNCTIONALITY
    Public
#>
function Test-M365DSCDependenciesForNewVersions
{
    [CmdletBinding()]
    param ()

    $i = 1
    Import-Module PowerShellGet -Force

    foreach ($dependency in $Script:M365DSCDependencies.Values.GetEnumerator())
    {
        Write-Progress -Activity 'Scanning Dependencies' -PercentComplete ($i / $Script:M365DSCDependencies.Count * 100)
        try
        {
            $moduleInGallery = Find-Module $dependency.ModuleName
            [array]$moduleInstalled = Get-Module $dependency.ModuleName -ListAvailable | Select-Object Version
            if ($moduleInstalled)
            {
                $modules = $moduleInstalled | Sort-Object Version -Descending
            }
            $moduleInstalled = $modules[0]
            if (-not $modules -or [Version]($moduleInGallery.Version) -gt [Version]($moduleInstalled[0].Version))
            {
                Write-Host "New version of {$($dependency.ModuleName)} is available {$($moduleInGallery.Version)}"
            }
        }
        catch
        {
            Write-Host $_
            Write-Host "New version of {$($dependency.ModuleName)} is available"
        }
        $i++
    }

    # The progress bar seems to hang sometimes. Make sure it is no longer displayed.
    Write-Progress -Activity 'Scanning Dependencies' -Completed
}

<#
.DESCRIPTION
    This function validates there are no updates to the module or it's dependencies and no multiple versions are present on the local system.

.EXAMPLE
    Test-M365DSCModuleValidity

.FUNCTIONALITY
    Public
#>
function Test-M365DSCModuleValidity
{
    [CmdletBinding()]
    param()

    if ($Script:IsM365DSCModuleValidated)
    {
        Write-Verbose -Message 'The Microsoft365DSC module has already been validated in this session.'
        Write-Verbose -Message 'If you have updated the module, please restart your PowerShell session to re-validate.'
        return
    }

    if ($env:AZUREPS_HOST_ENVIRONMENT -like 'AzureAutomation*')
    {
        $message = 'Skipping check for newer version of Microsoft365DSC due to Azure Automation Environment restrictions.'
        Write-Verbose -Message $message
        return
    }

    # Validate if only one installation of the module is present and that it's the latest version available
    if ($Script:IsPsResourceGetAvailable)
    {
        $latestVersion = (Find-PSResource -Name 'Microsoft365DSC' -Repository 'PSGallery').Version | Sort-Object -Descending | Select-Object -First 1
    }
    else
    {
        $latestVersion = (Find-Module -Name 'Microsoft365DSC' -Includes 'DSCResource').Version
    }
    $localVersion = (Get-Module -Name 'Microsoft365DSC').Version

    if ($latestVersion -gt $localVersion)
    {
        Write-Host "There is a newer version of the 'Microsoft365DSC' module available on the gallery."
        Write-Host "To update the module and it's dependencies, run the following command:"
        Write-Host 'Update-M365DSCModule' -ForegroundColor Blue
    }

    $Script:IsM365DSCModuleValidated = $true
}

<#
.DESCRIPTION
    This function uninstalls all previous M365DSC dependencies and older versions of the module.

.EXAMPLE
    Uninstall-M365DSCOutdatedDependencies

.FUNCTIONALITY
    Public
#>
function Uninstall-M365DSCOutdatedDependencies
{
    [CmdletBinding()]
    param()

    try
    {
        $InformationPreference = 'Continue'

        [array]$microsoft365DscModules = Get-Module Microsoft365DSC -ListAvailable
        $outdatedMicrosoft365DscModules = $microsoft365DscModules | Sort-Object -Property Version | Select-Object -SkipLast 1

        foreach ($module in $outdatedMicrosoft365DscModules)
        {
            try
            {
                Write-Information -MessageData "Uninstalling $($module.Name) Version {$($module.Version)}"
                if (Test-Path -Path $($module.Path))
                {
                    Remove-Item $($module.ModuleBase) -Force -Recurse -ErrorAction Stop
                }
            }
            catch
            {
                $message = "Could not uninstall $($module.Name) Version $($module.Version)"
                if ($_.Exception.Message -like "*Access to the path* is denied*" -and ($Scope -eq "AllUsers") -and -not
                    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
                {
                    $message += ' You need to run this command as a local administrator.'
                }
                New-M365DSCLogEntry -Message $message `
                    -Exception $_ `
                    -Source $($MyInvocation.MyCommand.Source)
                Write-Error -Message $message -ErrorAction Continue
            }
        }

        $allDependenciesExceptAuth = $Script:M365DSCDependencies.Values.GetEnumerator().Where({ $_.ModuleName -ne 'Microsoft.Graph.Authentication' })

        $i = 1
        foreach ($dependency in $allDependenciesExceptAuth)
        {
            Write-Progress -Activity 'Scanning Dependencies' -PercentComplete ($i / $allDependenciesExceptAuth.Count * 100)
            try
            {
                if ($dependency.PowerShellCore -and -not $Script:IsPowerShellCore)
                {
                    Write-Verbose -Message "Skipping module {$($dependency.ModuleName)} as it is managed by PowerShell Core."
                    continue
                }
                elseif ($dependency.PowerShellCore -eq $false -and $Script:IsPowerShellCore)
                {
                    Write-Verbose -Message "Skipping module {$($dependency.ModuleName)} as it is managed by Windows PowerShell."
                    continue
                }
                $found = Get-Module $dependency.ModuleName -ListAvailable | Where-Object -FilterScript { $_.Version -ne $dependency.RequiredVersion }
                foreach ($foundModule in $found)
                {
                    try
                    {
                        Write-Information -MessageData "Uninstalling $($foundModule.Name) Version {$($foundModule.Version)}"
                        if (Test-Path -Path $($foundModule.Path))
                        {
                            Remove-Item $($foundModule.ModuleBase) -Force -Recurse -ErrorAction Stop
                        }
                    }
                    catch
                    {
                        $message = "Could not uninstall $($foundModule.Name) Version $($foundModule.Version)"
                        if ($_.Exception.Message -like "*Access to the path* is denied*" -and
                            ($Scope -eq "AllUsers") -and -not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
                        {
                            $message += ' You need to run this command as a local administrator.'
                        }
                        New-M365DSCLogEntry -Message $message `
                            -Exception $_ `
                            -Source $($MyInvocation.MyCommand.Source)
                        Write-Error -Message $message -ErrorAction Continue
                    }
                }
            }
            catch
            {
                Write-Error -Message "Could not uninstall {$($dependency.ModuleName)}" -ErrorAction Continue
            }
            $i++
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error uninstalling outdated dependencies:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source)
        Write-Error $_
    }

    $authModule = $Script:M365DSCDependencies['Microsoft.Graph.Authentication']
    try
    {
        Write-Information -MessageData 'Checking Microsoft.Graph.Authentication'
        $found = Get-Module $authModule.ModuleName -ListAvailable | Where-Object -FilterScript { $_.Version -ne $authModule.RequiredVersion }
        foreach ($foundModule in $found)
        {
            try
            {
                Write-Information -MessageData "Uninstalling $($foundModule.Name) version {$($foundModule.Version)}"
                if (Test-Path -Path $($foundModule.Path))
                {
                    Remove-Item $($foundModule.ModuleBase) -Force -Recurse -ErrorAction Stop
                }
            }
            catch
            {
                $message = "Could not uninstall $($foundModule.Name) Version $($foundModule.Version)"
                if ($_.Exception.Message -like "*Access to the path* is denied*" -and
                    ($Scope -eq "AllUsers") -and -not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
                {
                    $message += ' You need to run this command as a local administrator.'
                }
                New-M365DSCLogEntry -Message $message `
                    -Exception $_ `
                    -Source $($MyInvocation.MyCommand.Source)
                Write-Error -Message $message -ErrorAction Continue
            }
        }
    }
    catch
    {
        Write-Error -Message "Could not uninstall {$($dependency.ModuleName)}" -ErrorAction Continue
    }
}

<#
.DESCRIPTION
    This function installs all missing M365DSC dependencies

.PARAMETER Force
    Specifies that all dependencies should be forcefully imported again.

.PARAMETER ValidateOnly
    Specifies that the function should only return the dependencies that are not installed.

.PARAMETER Scope
    Specifies the scope of the update of the module. The default value is AllUsers(needs to run as elevated user).

.PARAMETER Proxy
    Specifies the proxy server to use for the module installation.

.PARAMETER Repository
    Specifies the PowerShell repository name to use for the installation of the dependencies.

.PARAMETER UsePowerShellGet
    Specifies that Install-Module should be used for the installation of the dependencies instead of Install-PSResource.

.EXAMPLE
    PS> Update-M365DSCDependencies

.EXAMPLE
    PS> Update-M365DSCDependencies -Force

.EXAMPLE
    PS> Update-M365DSCDependencies -Scope CurrentUser

.FUNCTIONALITY
    Public
#>
function Update-M365DSCDependencies
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [Switch]
        $Force,

        [Parameter()]
        [Switch]
        $ValidateOnly,

        [Parameter()]
        [ValidateSet("CurrentUser", "AllUsers")]
        $Scope = "AllUsers",

        [Parameter()]
        [System.String]
        $Proxy,

        [Parameter()]
        [System.String]
        $Repository = 'PSGallery',

        [Parameter()]
        [switch]
        $UsePowerShellGet
    )

    try
    {
        $InformationPreference = 'Continue'
        $i = 1

        $returnValue = @()

        $params = @{}
        if (-not [System.String]::IsNullOrEmpty($Proxy))
        {
            $params.Add('Proxy', $Proxy)
        }

        # Check if PSResourceGet is installed or not
        if (-not $Script:IsPsResourceGetAvailable)
        {
            Write-Warning -Message 'Microsoft.PowerShell.PSResourceGet is not installed, installing it now...'
            try
            {
                Install-Module -Name Microsoft.PowerShell.PSResourceGet -Scope $Scope -AllowClobber @params -Force -ErrorAction Stop -Repository PSGallery
                $Script:IsPsResourceGetAvailable = $true
            }
            catch
            {
                Write-Warning -Message "Failed to install Microsoft.PowerShell.PSResourceGet, continuing without it..."
            }
        }

        $scopedIsPsResourceGetAvailable = $Script:IsPsResourceGetAvailable
        if ($params.ContainsKey('Proxy'))
        {
            Write-Information -MessageData "Falling back to Install-Module because Install-PSResource does not support a proxy"
            $scopedIsPsResourceGetAvailable = $false
        }

        foreach ($dependency in $Script:M365DSCDependencies.Values.GetEnumerator())
        {
            Write-Progress -Activity 'Scanning dependencies' -PercentComplete ($i / $Script:M365DSCDependencies.Count * 100)
            try
            {
                if (-not $Force)
                {
                    if ($dependency.PowerShellCore -and -not $Script:IsPowerShellCore)
                    {
                        Write-Verbose -Message "The dependency {$($dependency.ModuleName)} requires PowerShell Core. Skipping."
                        continue
                    }
                    elseif ($dependency.PowerShellCore -eq $false -and $Script:IsPowerShellCore)
                    {
                        Write-Verbose -Message "The dependency {$($dependency.ModuleName)} requires Windows PowerShell. Skipping."
                        continue
                    }
                    $found = Get-Module $dependency.ModuleName -ListAvailable | Where-Object -FilterScript { $_.Version -eq $dependency.RequiredVersion }
                }

                if ((-not $found -or $Force) -and -not $ValidateOnly)
                {
                    $errorFound = $false
                    try
                    {
                        if ((-not(([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) -and ($Scope -eq "AllUsers"))
                        {
                            Write-Error 'Cannot update the dependencies for Microsoft365DSC. You need to run this command as a local administrator.'
                            $errorFound = $true
                        }
                    }
                    catch
                    {
                        Write-Verbose -Message "Couldn't retrieve Windows Principal. One possible cause is that the current environment is not a Windows OS."
                    }
                    if (-not $errorFound)
                    {
                        if (-not $dependency.PowerShellCore -and $Script:IsPowerShellCore)
                        {
                            Write-Warning "The dependency {$($dependency.ModuleName)} does not support PowerShell Core. Please run Update-M365DSCDependencies in Windows PowerShell."
                            continue
                        }
                        elseif ($dependency.PowerShellCore -and -not $Script:IsPowerShellCore)
                        {
                            Write-Warning "The dependency {$($dependency.ModuleName)} requires PowerShell Core. Please run Update-M365DSCDependencies in PowerShell Core."
                            continue
                        }

                        Remove-Module $dependency.ModuleName -Force -ErrorAction SilentlyContinue
                        if ($dependency.ModuleName -like 'Microsoft.Graph*')
                        {
                            Remove-Module 'Microsoft.Graph.Authentication' -Force -ErrorAction SilentlyContinue
                        }
                        Remove-Module $dependency.ModuleName -Force -ErrorAction SilentlyContinue

                        if ($scopedIsPsResourceGetAvailable -and -not $UsePowerShellGet)
                        {
                            Write-Information -MessageData "Using Install-PSResource to install $($dependency.ModuleName) with version {$($dependency.RequiredVersion)}"
                            Install-PSResource -Name $dependency.ModuleName -Version $dependency.RequiredVersion -Scope $Scope -AcceptLicense -SkipDependencyCheck -TrustRepository -Repository $Repository
                        }
                        else
                        {
                            Write-Information -MessageData "Using Install-Module to install $($dependency.ModuleName) with version {$($dependency.RequiredVersion)}"
                            Install-Module $dependency.ModuleName -RequiredVersion $dependency.RequiredVersion -AllowClobber -Force -Scope "$Scope" @Params -Repository $Repository
                        }
                    }
                }

                if ($dependency.ExplicitLoading)
                {
                    Remove-Module $dependency.ModuleName -Force -ErrorAction SilentlyContinue
                    if ($dependency.Prefix)
                    {
                        Import-Module $dependency.ModuleName -Global -Prefix $dependency.Prefix -Force -DisableNameChecking
                    }
                    else
                    {
                        Import-Module $dependency.ModuleName -Global -Force -Alias @() -Cmdlet @() -Variable @() -DisableNameChecking
                    }
                }

                if (-not $found -and $validateOnly)
                {
                    $returnValue += $dependency
                }
            }
            catch
            {
                Write-Error -Message "Could not update or import {$($dependency.ModuleName)}: $($_.Exception.Message)" -ErrorAction Continue
            }

            $i++
        }

        # The progress bar seems to hang sometimes. Make sure it is no longer displayed.
        Write-Progress -Activity 'Scanning dependencies' -Completed

        if ($ValidateOnly)
        {
            return $returnValue
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating dependencies:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source)
        Write-Error $_ -ErrorAction Continue
    }
}

<#
.DESCRIPTION
    This function updates the module, dependencies and uninstalls outdated dependencies.

.PARAMETER Scope
    Specifies the scope of the update of the module. The default value is AllUsers(needs to run as elevated user).

.PARAMETER Proxy
    Specifies the proxy server to use for the update.

.PARAMETER BaseRepository
    Specifies the PowerShell Repository name to use for the installation of the Microsoft365DSC module.

.PARAMETER DependencyRepository
    Specifies the PowerShell Repository name to use for the installation of the dependencies of the Microsoft365DSC module.

.PARAMETER NoUninstall
    Indicates if outdated dependencies and modules should be uninstalled.

.EXAMPLE
    PS> Update-M365DSCModule

.EXAMPLE
    PS> Update-M365DSCModule -Scope CurrentUser

.EXAMPLE
    PS> Update-M365DSCModule -Scope AllUsers

.FUNCTIONALITY
    Public
#>
function Update-M365DSCModule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet("CurrentUser", "AllUsers")]
        $Scope = "AllUsers",

        [Parameter()]
        [System.String]
        $Proxy,

        [Parameter()]
        [System.String]
        $BaseRepository = 'PSGallery',

        [Parameter()]
        [System.String]
        $DependencyRepository = 'PSGallery',

        [Parameter()]
        [switch]
        $NoUninstall
    )

    $params = @{}
    $unloadModule = $true

    if (-not [System.String]::IsNullOrEmpty($proxy))
    {
        $params.Add('Proxy', $Proxy)
    }
    try
    {
        Update-Module -Name 'Microsoft365DSC' @Params -ErrorAction Stop
    }
    catch
    {
        if ($_.Exception.Message -like "*Module 'Microsoft365DSC' was not installed by using Install-Module*")
        {
            Write-Verbose -Message "The Microsoft365DSC module might have been installed with Install-PSResource"
            if ($Script:IsPsResourceGetAvailable)
            {
                Write-Verbose -Message "Updating the Microsoft365DSC module using Update-PSResource..."
                try
                {
                    Update-PSResource -Name 'Microsoft365DSC' -Scope $Scope `
                        -TrustRepository -AcceptLicense -SkipDependencyCheck `
                        -Repository $BaseRepository -ErrorAction Stop
                }
                catch
                {
                    if ($_.Exception.Message -like "*No installed packages*")
                    {
                        Write-Verbose -Message "Microsoft365DSC was neither installed using Install-Module nor Install-PSResource. Trying to install it now..."
                        Install-PSResource -Name 'Microsoft365DSC' -Scope $Scope `
                            -TrustRepository -AcceptLicense -SkipDependencyCheck `
                            -Repository $BaseRepository -ErrorAction Stop
                    }
                    else
                    {
                        New-M365DSCLogEntry -Message 'Error Updating Module:' `
                            -Exception $_ `
                            -Source $($MyInvocation.MyCommand.Source)
                        throw
                    }
                }
            }
        }
        elseif ($_.Exception.Message -like "*was not updated because no valid module was found*")
        {
            Write-Verbose -Message "No valid module was found to update."
            $unloadModule = $false
        }
    }
    try
    {
        if ($unloadModule)
        {
            Write-Verbose -Message "Unloading all instances of the Microsoft365DSC module from the current PowerShell session."
            Remove-Module Microsoft365DSC -Force
        }

        Write-Verbose -Message "Retrieving all versions of the Microsoft365DSC installed on the machine."
        [Array]$instances = Get-Module Microsoft365DSC -ListAvailable | Sort-Object -Property Version -Descending
        if ($instances.Length -gt 0)
        {
            Write-Verbose -Message "Loading version {$($instances[0].Version.ToString())} of the Microsoft365DSC module from {$($instances[0].ModuleBase)}"
            Import-Module Microsoft365DSC -RequiredVersion $instances[0].Version.ToString() -Force
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error Updating Module:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source)
        throw $_
    }

    Update-M365DSCDependencies -Scope $Scope -Proxy $Proxy -Repository $DependencyRepository

    if (-not $NoUninstall)
    {
        Uninstall-M365DSCOutdatedDependencies
    }
}

Export-ModuleMember -Function @(
    'Confirm-M365DSCDependencies',
    'Confirm-M365DSCLoadedModule',
    'Confirm-M365DSCModuleDependency',
    'Get-M365DSCModuleConfiguration',
    'Get-M365DSCRequiredModules',
    'Get-M365DSCResourceSettings',
    'Set-M365DSCModuleConfiguration',
    'Set-M365DSCRequiredModulesLoaded',
    'Test-IsM365DSCRequiredModulesLoaded',
    'Test-M365DSCDependenciesForNewVersions',
    'Test-M365DSCModuleValidity',
    'Uninstall-M365DSCOutdatedDependencies',
    'Update-M365DSCDependencies',
    'Update-M365DSCModule'
)
