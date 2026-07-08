[CmdletBinding()]
param(
    [Parameter()]
    [switch]
    $IsSDK
)

$isWindowsPlatform = [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform(
    [System.Runtime.InteropServices.OSPlatform]::Windows)

try
{
    Write-Output "Detecting current platform"
    $message = "Platform detected: "
    if ($isWindowsPlatform)
    {
        $message += "Windows"
    }
    else
    {
        $message += "Other"
    }
    if ($IsSDK.IsPresent)
    {
        $message += " (.NET SDK)"
    }
    else
    {
        $message += " (.NET Runtime)"
    }
    Write-Output $message

    $nugetProvider = Get-PackageProvider -Name "NuGet" -ErrorAction SilentlyContinue
    if (-not $nugetProvider)
    {
        Write-Output "NuGet package provider not found. Installing..."
        $null = Install-PackageProvider -Name "NuGet" -Force
    }

    Write-Output "Setting PSGallery InstallationPolicy to Trusted"
    Set-PSRepository -Name "PSGallery" -InstallationPolicy "Trusted"

    Write-Output "Installing PSResourceGet module"
    $parameters = @{
        Name                = "Microsoft.PowerShell.PSResourceGet"
        Repository          = "PSGallery"
        Scope               = "AllUsers"
        Force               = [Switch]$true
        SkipPublisherCheck  = [Switch]$true
    }
    Install-Module @parameters

    Write-Output "Installing PSDesiredStateConfiguration module"
    $Parameters = @{
        Name                = "PSDesiredStateConfiguration"
        Repository          = "PSGallery"
        Scope               = "AllUsers"
        SkipDependencyCheck = [Switch]$true
        TrustRepository     = [Switch]$true
        AcceptLicense       = [Switch]$true
        Prerelease          = [Switch]$true
    }
    Install-PSResource @Parameters

    if (-not $IsSDK.IsPresent)
    {
        Write-Output "Installing Microsoft365DSC module"
        $Parameters = @{
            Name                = "Microsoft365DSC"
            Repository          = "PSGallery"
            Scope               = "AllUsers"
            Force               = [Switch]$true
            SkipPublisherCheck  = [Switch]$true
        }
        Install-Module @Parameters
    }
    else
    {
        Write-Output "Adding symbolic link from repository folder to module path"
        $Parameters = @{
            ItemType = "SymbolicLink"
            Force    = [Switch]$true
        }
        if ($isWindowsPlatform)
        {
            $Parameters.Add("Path", "C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC")
            $Parameters.Add("Target", "C:\DSC\Modules\Microsoft365DSC")
        }
        else
        {
            $Parameters.Add("Path", "/usr/share/powershell/.store/powershell.linux.x64/7.6.2/powershell.linux.x64/7.6.2/tools/net10.0/any/Modules/Microsoft365DSC")
            $Parameters.Add("Target", "/DSC/Modules/Microsoft365DSC")
        }
        $null = New-Item @Parameters
    }

    Write-Output "Installing Pester module"
    $Parameters = @{
        Name                = "Pester"
        Repository          = "PSGallery"
        Scope               = "AllUsers"
        Version            = "5.7.1"
        SkipDependencyCheck = [Switch]$true
        TrustRepository     = [Switch]$true
        AcceptLicense       = [Switch]$true
        Prerelease          = [Switch]$true
    }
    Install-PSResource @Parameters

    Write-Output "Installing Microsoft365DSC module dependencies"
    Update-M365DSCDependencies

    if ($isWindowsPlatform)
    {
        Write-Output "Testing if PowerShell 7 is installed"
        $pwshPath = (Get-Command pwsh -ErrorAction SilentlyContinue).Source
        if (-not $pwshPath)
        {
            $ProgressPreference = 'SilentlyContinue'
            Write-Output "PowerShell 7 not found, installing it now"
            Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.6.3/PowerShell-7.6.3-win-x64.zip" -OutFile "PowerShell-7.6.3-win-x64.zip"
            Unblock-File "PowerShell-7.6.3-win-x64.zip"
            $null = New-Item -ItemType Directory -Path "C:\Program Files\PowerShell\7" -Force
            Expand-Archive "PowerShell-7.6.3-win-x64.zip" -DestinationPath "C:\Program Files\PowerShell\7"
            Remove-Item "PowerShell-7.6.3-win-x64.zip" -Force
            [System.Environment]::SetEnvironmentVariable('PATH', $env:PATH + ";C:\Program Files\PowerShell\7", [System.EnvironmentVariableTarget]::Machine)
            $env:PATH += ";C:\Program Files\PowerShell\7"
        }

        Write-Output "Installing Microsoft365DSC module dependencies in PowerShell 7"
        & pwsh -Command {
            Update-M365DSCDependencies
        }
        if ($LASTEXITCODE -ne 0)
        {
            throw "Could not install Microsoft365DSC module dependencies in PowerShell 7"
        }

        Write-Output "Configuring Windows PowerShell environment"
        Set-ExecutionPolicy Unrestricted -Force

        Get-ChildItem "C:\Program Files\WindowsPowerShell\Modules" -Recurse | Unblock-File
        $null = New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WSMAN\Client' -Name MaxEnvelopeSizekb -Value 1039440 -PropertyType DWORD -Force

        $computerSystem = Get-CimInstance -ClassName "Win32_ComputerSystem"
        $totalPhysicalMemory = $computerSystem.TotalPhysicalMemory
        $quotaConfiguration = Get-CimInstance -Namespace Root -ClassName "__ProviderHostQuotaConfiguration"
        $quotaConfiguration.MemoryAllHosts = $totalPhysicalMemory # Adjust the memory for all processes combined
        $quotaConfiguration.MemoryPerHost  = $totalPhysicalMemory # Adjust the memory for a single wmiprvse.exe process
        Set-CimInstance -InputObject $quotaConfiguration

        [System.Environment]::SetEnvironmentVariable('M365DSCTelemetryEnabled', $false, [System.EnvironmentVariableTarget]::Machine)
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "ACP" -Value 65001 -Force
        $null = New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force

        Write-Output "Configuring PowerShell 7 environment"
        & pwsh -Command {
            param(
                [Parameter()]
                [System.Boolean]
                $IsSDK
            )
            if ($IsSDK)
            {
                Write-Output "Copying pwrshplugin.dll to PowerShell 7 module path"
                $PSVersion = [System.String]$PSVersionTable.PSVersion
                $SDK = dotnet --list-sdks
                if ($LASTEXITCODE -ne 0)
                {
                    throw "Could not get .NET SDK version"
                }
                $SDKVersion = $SDK.Split(' ')[0].SubString(0, 4)
                $destinationPath = "C:\Program Files\powershell\.store\powershell.windows.x64\{0}\powershell.windows.x64\{1}\tools\net{2}\any" `
                    -f $PSVersion, $PSVersion, $SDKVersion
                $path = Join-Path -Path $destinationPath -ChildPath "runtimes\win-x64\native\pwrshplugin.dll"
                Copy-Item -Path $path -Destination $destinationPath -Force
            }
            $null = Enable-PSRemoting -Force -SkipNetworkProfileCheck
        } -args $IsSDK.IsPresent
        if ($LASTEXITCODE -ne 0)
        {
            throw "Could not configure PowerShell 7 environment"
        }

        $RemoveAliases = @"
Write-Output "Removing aliases gacfg and sacfg if they exist and importing PSDesiredStateConfiguration module"
if (Get-Alias gacfg -ErrorAction SilentlyContinue) {
    Remove-Item Alias:gacfg -Force
}
if (Get-Alias sacfg -ErrorAction SilentlyContinue) {
    Remove-Item Alias:sacfg -Force
}
Import-Module PSDesiredStateConfiguration -Force
"@

        $profileFolderPath = "C:\Users\ContainerAdministrator\Documents\PowerShell"
        $profileFilePath = Join-Path -Path $profileFolderPath -ChildPath "Microsoft.PowerShell_profile.ps1"
        if (-not (Test-Path -Path $profileFolderPath))
        {
            $message = "Creating PowerShell 7 profile folder at {0}" -f $profileFolderPath
            Write-Output $message
            $null = New-Item -ItemType Directory -Path $profileFolderPath -Force
        }
        Write-Output "Setting `$PROFILE for PowerShell 7"
        Set-Content -Path $profileFilePath -Value $RemoveAliases -Force
    }
    else
    {
        Write-Output "Configuring OS environment"
        [System.Environment]::SetEnvironmentVariable('M365DSCTelemetryEnabled', $false, [System.EnvironmentVariableTarget]::Process)

        if ($IsSDK.IsPresent)
        {
            $PSVersion = [System.String]$PSVersionTable.PSVersion
            $SDK = dotnet --list-sdks
            if ($LASTEXITCODE -ne 0)
            {
                throw "Could not get .NET SDK version"
            }
            $SDKVersion = $SDK.Split(' ')[0].SubString(0, 4)
            $moduleBasePath = "/DSC/Modules/Microsoft365DSC"
            $destinationPath = "/usr/share/powershell/.store/powershell.linux.x64/{0}/powershell.linux.x64/{1}/tools/net{2}/any/Modules/Microsoft365DSC" `
                -f $PSVersion, $PSVersion, $SDKVersion

            Write-Output "Generating SchemaDefinition.json"
            $M365DSCSchemaHandlerPath = Join-Path -Path $moduleBasePath -ChildPath "Modules/M365DSCSchemaHandler.psm1"
            Import-Module $M365DSCSchemaHandlerPath
            New-M365DSCSchemaDefinition

            Write-Output "Building DLL files"
            & "/DSC/Utilities/Build-DllFiles.ps1" -Configuration Release
            if ($LASTEXITCODE -ne 0)
            {
                throw "Could not build DLL files"
            }
        }
        else
        {
            $moduleBasePath = (Get-Module -Name Microsoft365DSC).ModuleBase
            $DSCResourcesPath = Join-Path -Path $moduleBasePath -ChildPath "DSCResources"
            if (Test-Path -Path $DSCResourcesPath)
            {
                Rename-Item -Path $DSCResourcesPath -NewName "DscResources" -Force
            }
        }
    }
}
catch
{
    throw $_
}

Write-Output ' '
$message = "Finished installing Microsoft365DSC, dependencies and configuration " + `
    "successfully {0}" -f [Char]::ConvertFromUtf32(0x2705)
Write-Output $message
