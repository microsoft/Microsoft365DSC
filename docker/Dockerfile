FROM mcr.microsoft.com/powershell:latest
USER ContainerAdministrator
LABEL Name=microsoft365dsc Version=1.21.1006.3
SHELL ["pwsh", "-command"]
RUN Install-Module Microsoft365DSC -Force -SkipPublisherCheck -Scope AllUsers

EXPOSE 22
