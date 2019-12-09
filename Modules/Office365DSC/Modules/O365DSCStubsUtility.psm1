function Get-O365StubFiles
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DestinationFilePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
 
    if ($null -eq $GlobalAdminAccount)
    {
        $GlobalAdminAccount = Get-Credential
    }

    if (Test-Path $DestinationFilePath)
    {
        $answer = $null
        do
        {
            $answer = Read-Host "A file already exists at the specified location. Remove it? (y/n)"
        } while ($answer -ne 'y' -and $answer -ne 'n')

        if ($answer -eq 'y')
        {
            Remove-Item -Path $DestinationFilePath -Confirm:$false
        }
    }

    $Modules = @(
        @{
            Platform   = 'AzureAD'
            ModuleName = 'AzureAD'
        },
        @{
            Platform     = 'ExchangeOnline'
            ModuleName   = $null
            RandomCmdlet = 'Add-AvailabilityAddressSpace'
        },
        @{
            Platform   = 'MicrosoftTeams'
            ModuleName = 'Microsoft.TeamsCmdlets.PowerShell.Custom'
        },
        @{
            Platform   = 'MSOnline'
            ModuleName = 'MSOnline'
        },
        @{
            Platform   = 'PnP'
            ModuleName = 'SharePointPnPPowerShellOnline'
        },
        @{
            Platform   = 'PowerPlatforms'
            ModuleName = 'Microsoft.PowerApps.Administration.PowerShell'
        },
        @{
            Platform     = 'SecurityComplianceCenter'
            ModuleName   = $null
            RandomCmdlet = 'Add-ComplianceCaseMember'
        },
        @{
            Platform   = 'SharePointOnline'
            ModuleName = 'Microsoft.Online.SharePoint.PowerShell'
        },
        @{
            Platform     = 'SkypeForBusiness'
            ModuleName   = $null
            RandomCmdlet = 'Clear-CsOnlineTelephoneNumberReservation'
        }
    )
 
    foreach ($Module in $Modules)
    {
        Write-Host "Generating Stubs for {$($Module.Platform)}..." -NoNewline
        if ($null -eq $Module.ModuleName)
        {
            # Get currently Loaded Modules list, connect to workload, and compare new list to figure out what the new
            # temporary proxy module name is;
            $currentModules = Get-Module | select Name
            Test-MSCloudLogin -Platform $Module.Platform -CloudCredential $GlobalAdminAccount
            $newModules = Get-Module | select Name
            $Diff = Compare-object -ReferenceObject $currentModules -DifferenceObject $newModules
            
            if ($null -eq $Diff)
            {
                $foundModule = Get-Module | Where-Object -FilterScript {$_.ExportedCommands.Values.Name -ccontains $Module.RandomCmdlet}
                $Module.ModuleName = $foundModule.Name
            }
            else
            {
                $Module.ModuleName = $Diff.Name
            }
        }
        else
        {
            Test-MSCloudLogin -Platform $Module.Platform -CloudCredential $GlobalAdminAccount
        }

        $cmdlets = Get-Command | Where-Object -FilterScript { $_.Source -eq $Module.ModuleName }
        $StubContent = ''
        foreach ($cmdlet in $cmdlets)
        {
            $signature = $null
            $metadata = New-Object -TypeName System.Management.Automation.CommandMetaData -ArgumentList $cmdlet
            $definition = [System.Management.Automation.ProxyCommand]::Create($metadata) 
        
            foreach ($line in $definition -split "`n")
            {
                if ($line.Trim() -eq 'begin')
                {
                    break
                }
                $signature += $line
            }
            $StubContent += "function $($cmdlet.Name)`n{`r`n    $signature}`n"
        }
 
        $Content += "#region $($Module.Platform)`r`n"
        foreach ($line in $StubContent.Split([Environment]::NewLine))
        {
            $line = $line -replace "\[System.Nullable\[Microsoft.*]]", "[System.Nullable[object]]"
            $line = $line -replace "\[Microsoft.*.\]", "[object]"
            $Content += $line + "`r`n"
        }
        $Content += "#endregion`r`n"
        Write-Host "Done" -ForegroundColor Green
    }
    $Content | Out-File $DestinationFilePath -Encoding utf8
}
