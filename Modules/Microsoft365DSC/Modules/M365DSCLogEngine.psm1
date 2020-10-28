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

        Write-EventLog -LogName $LogName -Source $Source `
            -EventID $EventID -Message $Message -EntryType $EntryType
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
