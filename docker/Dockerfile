# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2019 AS installer-env
USER ContainerAdministrator
LABEL Name=microsoft365dsc Version=1.21.1006.3

ARG PS_VERSION=7.1.4
ARG PS_PACKAGE_URL=https://github.com/PowerShell/PowerShell/releases/download/v${PS_VERSION}/PowerShell-${PS_VERSION}-win-x64.zip

SHELL ["C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe", "-command"]

ARG PS_PACKAGE_URL_BASE64

RUN Write-host "Verifying valid Version..."; `
    if (!($env:PS_VERSION -match '^\d+\.\d+\.\d+(-\w+(\.\d+)?)?$' )) { `
        throw ('PS_Version ({0}) must match the regex "^\d+\.\d+\.\d+(-\w+(\.\d+)?)?$"' -f $env:PS_VERSION) `
    } `
    $ProgressPreference = 'SilentlyContinue'; `
    if($env:PS_PACKAGE_URL_BASE64){ `
        Write-host "decoding: $env:PS_PACKAGE_URL_BASE64" ;`
        $url = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($env:PS_PACKAGE_URL_BASE64)) `
    } else { `
        Write-host "using url: $env:PS_PACKAGE_URL" ;`
        $url = $env:PS_PACKAGE_URL `
    } `
    Write-host "downloading: $url"; `
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12; `
    Invoke-WebRequest -Uri $url -outfile /powershell.zip -verbose; `
    Expand-Archive powershell.zip -DestinationPath  \PowerShell

FROM mcr.microsoft.com/windows/servercore:ltsc2019
ENV ProgramFiles="C:\Program Files" `
    # set a fixed location for the Module analysis cache
    PSModuleAnalysisCachePath="C:\Users\Public\AppData\Local\Microsoft\Windows\PowerShell\docker\ModuleAnalysisCache" `
    # Persist %PSCORE% ENV variable for user convenience
    PSCORE="$ProgramFiles\PowerShell\pwsh.exe" `
    POWERSHELL_DISTRIBUTION_CHANNEL="PSDocker-WindowsServerCore-1909" `
    POWERSHELL_TELEMETRY_OPTOUT="1"

# Copy PowerShell Core from the installer container
COPY --from=installer-env ["\\PowerShell\\", "$ProgramFiles\\PowerShell\\latest"]

# Set the path
RUN setx /M PATH "%ProgramFiles%\PowerShell\latest;%PATH%;"

# intialize powershell module cache
RUN pwsh `
        -NoLogo `
        -NoProfile `
        -Command " `
          $stopTime = (get-date).AddMinutes(15); `
          $ErrorActionPreference = 'Stop' ; `
          $ProgressPreference = 'SilentlyContinue' ; `
          while(!(Test-Path -Path $env:PSModuleAnalysisCachePath)) {  `
            Write-Host "'Waiting for $env:PSModuleAnalysisCachePath'" ; `
            if((get-date) -gt $stopTime) { throw 'timout expired'} `
            Start-Sleep -Seconds 6 ; `
          }"

# re-enable telemetry
ENV POWERSHELL_TELEMETRY_OPTOUT="0"

COPY Extract.ps1 /M365DSC/Extract.ps1

SHELL ["powershell", "-command"]
RUN Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
RUN Install-Module Microsoft365DSC -Force
