FROM mcr.microsoft.com/powershell:latest as base
USER ContainerAdministrator
LABEL Name=microsoft365dsc Version=1.21.1006.3

SHELL ["powershell", "-command"]
RUN Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
RUN Install-Module MicrosoftTeams -Force
RUN Install-Module PnP.PowerShell -Force

SHELL ["pwsh", "-command"]
RUN Install-Module Microsoft365DSC -Force -Scope AllUsers
RUN Import-Module MicrosoftTeams -Global -Force -SkipEditionCheck
RUN Import-Module PnP.PowerShell -Global -Force -UseWindowsPowerShell
RUN Import-Module Microsoft365DSC -Force

EXPOSE 22
