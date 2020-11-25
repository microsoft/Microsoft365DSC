<# This method creates a new error log file for each session,
   whenever an error is encountered, and appends valuable
   troubleshooting information to the file;
#>
function New-M365DSCLogEntry
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $Error,

        [Parameter()]
        [System.String]
        $Message,

        [Parameter()]
        [System.String]
        $Source,

        [Parameter()]
        [System.String]
        $TenantId
    )

    try
    {
        $VerbosePreference = 'Continue'
        Write-Host "$($Global:M365DSCEmojiRedX)"

        #region Telemetry
        $driftedData = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
        $driftedData.Add("Event", "Error")
        $driftedData.Add("Category", $Error.CategoryInfo.Category.ToString())
        $driftedData.Add("Exception", $Error.Exception.ToString())
        $driftedData.Add("CustomMessage", $Message)
        $driftedData.Add("Source", $Source)
        $driftedData.Add("StackTrace", $Error.ScriptStackTrace)

        if ($null -ne $TenantId)
        {
            $driftedData.Add("TenantId", $TenantId)
        }
        Add-M365DSCTelemetryEvent -Type "Error" -Data $driftedData
        #endregion

        # Obtain the ID of the current PowerShell session. While this may
        # not be unique, it will;
        $SessionID = [System.Diagnostics.Process]::GetCurrentProcess().Id.ToString()

        # Generate the Error log file name based on the SessionID;
        $LogFileName = $SessionID + "-M365DSC-ErrorLog.log"

        # Build up the Error message to append to our log file;
        $LogContent = "[" + [System.DateTime]::Now.ToString("yyyy/MM/dd hh:mm:ss") + "]`r`n"
        $LogContent += "{" + $Error.CategoryInfo.Category.ToString() + "}`r`n"
        $LogContent += $Error.Exception.ToString() + "`r`n"
        $LogContent += "`"" + $Message + "`"`r`n"
        $LogContent += $Error.ScriptStackTrace + "`r`n"
        $LogContent += "`r`n`r`n"

        # Write the error content into the log file;
        $LogFileName = Join-Path -Path (Get-Location).Path -ChildPath $LogFileName
        $LogContent | Out-File $LogFileName -Append
        Write-Host "Error Log created at {$LogFileName}" -ForegroundColor Cyan
    }
    catch
    {
        Write-Warning -Message "An error occured logging an exception: $_"
    }
}

function Add-M365DSCEvent
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $Message,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Source,

        [Parameter()]
        [ValidateSet('Error', 'Information', 'FailureAudit', 'SuccessAudit', 'Warning')]
        [System.String]
        $EntryType = 'Information',

        [Parameter()]
        [System.UInt32]
        $EventID = 1,

        [Parameter()]
        [System.String]
        $TenantId
    )

    $LogName = 'M365DSC'

    try
    {
        if ([System.Diagnostics.EventLog]::SourceExists($Source))
        {
            $sourceLogName = [System.Diagnostics.EventLog]::LogNameFromSourceName($Source, ".")
            if ($LogName -ne $sourceLogName)
            {
                Write-Verbose -Message "[ERROR] Specified source {$Source} already exists on log {$sourceLogName}"
                return
            }
        }
        else
        {
            if ([System.Diagnostics.EventLog]::Exists($LogName) -eq $false)
            {
                #Create event log
                $null = New-EventLog -LogName $LogName -Source $Source
            }
            else
            {
                [System.Diagnostics.EventLog]::CreateEventSource($Source, $LogName)
            }
        }

        <#Write-EventLog -LogName $LogName -Source $Source `
            -EventId $EventID -Message $Message -EntryType $EntryType#>
    }
    catch
    {
        Write-Verbose -Message $_
        $MessageText = "Could not write to event log Source {$Source} EntryType {$EntryType} Message {$Message}"
        New-M365DSCLogEntry -Error $_ -Message $MessageText `
            -Source "[M365DSCLogEngine]" `
            -TenantId $TenantId
    }
}

function Export-M365DSCDiagnosticData
{
    [CmdletBinding(DefaultParametersetName = 'None')]
    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [System.String]
        $ExportFilePath,

        [Parameter()]
        [System.UInt32]
        $NumberOfDays = 7,

        [Parameter(ParameterSetName = 'Anon')]
        [Switch]
        $Anonymize,

        [Parameter(ParameterSetName = 'Anon', Mandatory = $true)]
        [System.String]
        $Server,

        [Parameter(ParameterSetName = 'Anon', Mandatory = $true)]
        [System.String]
        $Domain,

        [Parameter(ParameterSetName = 'Anon', Mandatory = $true)]
        [System.String]
        $Url
    )
    Write-Host 'Exporting logging information' -ForegroundColor Yellow

    if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") -eq $false)
    {
        Write-Host -Object "[ERROR] You need to run this cmdlet with Administrator privileges!" -ForegroundColor Red
        return
    }

    $afterDate = (Get-Date).AddDays(($NumberOfDays * -1))

    # Create Temp folder
    $guid = [Guid]::NewGuid()
    $tempPath = Join-Path -Path $env:TEMP -ChildPath $guid
    $null = New-Item -Path $tempPath -ItemType 'Directory'

    # Copy DSC Verbose Logs
    Write-Host '  * Copying DSC Verbose Logs' -ForegroundColor Grey
    $logPath = Join-Path -Path $tempPath -ChildPath 'DSCLogs'
    $null = New-Item -Path $logPath -ItemType 'Directory'

    $sourceLogPath = Join-Path -Path $env:windir -ChildPath 'System32\Configuration\ConfigurationStatus'
    $items = Get-ChildItem -Path "$sourceLogPath\*.json" | Where-Object { $_.LastWriteTime -gt $afterDate }
    Copy-Item -Path $items -Destination $logPath -ErrorAction 'SilentlyContinue' #-ErrorVariable $err

    if ($Anonymize)
    {
        Write-Host '    * Anonymizing DSC Verbose Logs' -ForegroundColor Grey
        foreach ($file in (Get-ChildItem -Path $logPath))
        {
            $content = Get-Content -Path $file.FullName -Raw -Encoding Unicode
            $content = $content -replace $Domain, '[DOMAIN]' -replace $Url, 'fqdn.com' -replace $Server, '[SERVER]'
            Set-Content -Path $file.FullName -Value $content
        }
    }

    # Export M365Dsc event log
    Write-Host '  * Exporting DSC Event Log' -ForegroundColor Grey
    $evtExportLog = Join-Path -Path $tempPath -ChildPath 'M365Dsc.csv'

    try
    {
        Write-Host '    * Anonymizing DSC Event Log' -ForegroundColor Grey
        Get-EventLog -LogName 'M365Dsc' -After $afterDate | Export-Csv $evtExportLog -NoTypeInformation
        if ($Anonymize)
        {
            $newLog = Import-Csv $evtExportLog
            foreach ($entry in $newLog)
            {
                $entry.MachineName = "[SERVER]"
                $entry.UserName = "[USER]"
                $entry.Message = $entry.Message -replace $Domain, '[DOMAIN]' -replace $Url, 'fqdn.com' -replace $Server, '[SERVER]'
            }

            $newLog | Export-Csv -Path $evtExportLog -NoTypeInformation
        }
    }
    catch
    {
        $txtExportLog = Join-Path -Path $tempPath -ChildPath 'M365Dsc.txt'
        Add-Content -Value 'M365Dsc event log does not exist!' -Path $txtExportLog
    }

    # PowerShell Version
    Write-Host '  * Exporting PowerShell Version info' -ForegroundColor Grey
    $psInfoFile = Join-Path -Path $tempPath -ChildPath 'PSInfo.txt'
    $PSVersionTable | Out-File -FilePath $psInfoFile

    # OS Version
    Write-Host '  * Exporting OS Version info' -ForegroundColor Grey
    $computerInfoFile = Join-Path -Path $tempPath -ChildPath 'OSInfo.txt'

    Get-ComputerInfo -Property @(
        'OsName',
        'OsOperatingSystemSKU',
        'OSArchitecture',
        'WindowsVersion',
        'WindowsBuildLabEx',
        'OsLanguage',
        'OsMuiLanguages') | Out-File -FilePath $computerInfoFile

    # LCM settings
    Write-Host '  * Exporting LCM Configuration info' -ForegroundColor Grey
    $lcmInfoFile = Join-Path -Path $tempPath -ChildPath 'LCMInfo.txt'
    Get-DscLocalConfigurationManager | Out-File -FilePath $lcmInfoFile

    # Creating export package
    Write-Host '  * Creating Zip file with all collected information' -ForegroundColor Grey
    Compress-Archive -Path $tempPath -DestinationPath $ExportFilePath -Force

    # Cleaning up temporary data
    Write-Host '  * Removing temporary data' -ForegroundColor Grey
    Remove-Item $tempPath -Recurse -Force -Confirm:$false

    Write-Host ('Completed with export. Information exported to {0}' -f $ExportFilePath) -ForegroundColor Yellow
}
