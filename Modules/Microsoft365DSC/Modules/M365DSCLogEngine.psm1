<#
.Description
This function creates a new error log file for each session, whenever an error
is encountered, and appends valuable troubleshooting information to the file

.Functionality
Internal
#>
function New-M365DSCLogEntry
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Source,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Message,

        [Parameter()]
        [System.Object]
        $Exception,

        [Parameter()]
        [PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $TenantId
    )

    try
    {
        $tenantIdValue = ''
        if (-not [System.String]::IsNullOrEmpty($TenantId))
        {
            $tenantIdValue = $TenantId
        }
        elseif ($null -ne $Credential)
        {
            $tenantIdValue = $Credential.UserName.Split('@')[1]
        }

        #region Verbose message
        $outputMessage = $Message
        if ($PSBoundParameters.ContainsKey('Exception'))
        {
            $exceptionMessage = '{ ' + $Exception.Exception.Message + ' } \ ' + $Exception.ScriptStackTrace -replace '\n', ' \ '
            $outputMessage += ' ' + $exceptionMessage
        }
        Write-Verbose -Message $outputMessage
        #endregion

        #region Event Log logging
        $errorMessage = $Message
        if ($PSBoundParameters.ContainsKey('Exception'))
        {
            $errorMessage += "`n`n" + $exceptionMessage
        }

        if ($tenantIdValue -eq '')
        {
            Add-M365DSCEvent -Message $errorMessage `
                -EntryType 'Error' `
                -EventID 1 `
                -Source $Source
        }
        else
        {
            Add-M365DSCEvent -Message $errorMessage `
                -EntryType 'Error' `
                -EventID 1 `
                -Source $Source `
                -TenantId $tenantIdValue
        }
        #endregion

        #region Telemetry
        $driftedData = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
        $driftedData.Add('CustomMessage', $Message)
        $driftedData.Add('Source', $Source)

        if ($PSBoundParameters.ContainsKey('Exception'))
        {
            $driftedData.Add('Category', $Exception.CategoryInfo.Category.ToString())
            $driftedData.Add('Exception', $Exception.Exception.ToString())
            $driftedData.Add('StackTrace', $Exception.ScriptStackTrace)
        }

        if ($tenantIdValue -ne '')
        {
            $driftedData.Add('TenantId', $tenantIdValue)
        }
        Add-M365DSCTelemetryEvent -Type 'Error' -Data $driftedData
        #endregion

        #region Error log file

        # Obtain the ID of the current PowerShell session. While this may
        # not be unique, it will result in varying file names
        $SessionID = [System.Diagnostics.Process]::GetCurrentProcess().Id.ToString()

        # Generate the Error log file name based on the SessionID;
        $LogFileName = $SessionID + '-M365DSC-ErrorLog.log'

        # Build up the Error message to append to our log file;
        $LogContent = '[' + [System.DateTime]::Now.ToString('yyyy/MM/dd hh:mm:ss') + "]`r`n"
        if ($PSBoundParameters.ContainsKey('Exception'))
        {
            $LogContent += '{' + $Exception.CategoryInfo.Category.ToString() + "}`r`n"
            $LogContent += $Exception.Exception.ToString() + "`r`n"
        }
        $LogContent += "`"" + $Message + "`"`r`n"
        if ($PSBoundParameters.ContainsKey('Exception'))
        {
            $LogContent += $Exception.ScriptStackTrace + "`r`n"
        }
        if ($null -ne $Credential)
        {
            $LogContent += $Credential.UserName + "`r`n"
        }
        if ($tenantIdValue -ne '')
        {
            $LogContent += 'TenantId: ' + $tenantIdValue + "`r`n"
        }
        $LogContent += "`r`n`r`n"

        # Write the error content into the log file;
        $LogFileName = Join-Path -Path (Get-Location).Path -ChildPath $LogFileName
        $LogFileName = $LogFileName.Replace('\', '/')
        $LogContent | Out-File $LogFileName -Append
        if (Assert-M365DSCIsNonInteractiveShell)
        {
            Write-Verbose -Message "Error Log created at {file://$LogFileName}"
        }
        else
        {
            Write-Host "Error Log created at {file://$LogFileName}" -ForegroundColor Red
        }
        #endregion
    }
    catch
    {
        Write-Warning -Message "An error occured logging an exception: $_"
    }
}

<#
.Description
This function creates a new entry in the M365DSC event log, based on the provided information

.Functionality
Internal
#>
function Add-M365DSCEvent
{
    [CmdletBinding()]
    param
    (
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
        [ValidateSet('Drift', 'Error', 'Warning', 'NonDrift', 'RuleEvaluation')]
        $EventType,

        [Parameter()]
        [System.String]
        $TenantId
    )
    $LogName = 'M365DSC'

    try
    {
        if ([System.Diagnostics.EventLog]::SourceExists($Source))
        {
            $sourceLogName = [System.Diagnostics.EventLog]::LogNameFromSourceName($Source, '.')
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

        # Limit the size of the message. Maximum is about 32,766
        $outputMessage = $Message
        if ($PSBoundParameters.ContainsKey('TenantId'))
        {
            $outputMessage += "`n`nTenantId: " + $TenantId
        }

        if ($PSBoundParameters.ContainsKey('Credential'))
        {
            $outputMessage += "`n`nCredential: " + $Credential.UserName
        }

        if ($outputMessage.Length -gt 32766)
        {
            $outputMessage = $outputMessage.Substring(0, 32766)
        }

        if (-not [System.String]::IsNullOrEmpty($EventType))
        {
            Send-M365DSCNotificationEndPointMessage -EventDetails $outputMessage `
                -EventType $EventType
        }

        try
        {
            Write-EventLog -LogName $LogName -Source $Source `
                -EventId $EventID -Message $outputMessage -EntryType $EntryType -ErrorAction Stop
        }
        catch
        {
            Write-Verbose -Message $_
        }
    }
    catch
    {
        Write-Verbose -Message $_

        $MessageText = "Could not write to event log Source {$Source} EntryType {$EntryType} Message {$Message}"
        # Check call stack to prevent indefinite loop between New-M365DSCLogEntry and this function
        if ((Get-PSCallStack)[1].FunctionName -ne 'New-M365DSCLogEntry' -and `
            -not $_.ToString().Contains('EventLog access is not supported on this platform.'))
        {
            New-M365DSCLogEntry -Exception $_ -Message $MessageText `
                -Source '[M365DSCLogEngine]' `
                -TenantId $TenantId
        }
        else
        {
            Write-Verbose -Message $MessageText
        }
    }
}

<#
.Description
This function creates a ZIP package with a collection of troubleshooting information,
like Verbose logs, M365DSC event log, PowerShell version, OS versions and LCM config.
It is also able to anonymize this information (as much as possible), so important
information isn't shared.

.Parameter ExportFilePath
The file path to the ZIP file that should be created.

.Parameter NumberOfDays
The number of days of logs that should be exported.

.Parameter Anonymize
Specify if the results should be anonymized.

.Parameter Server
(Anonymize=True) The server name that should be renamed.

.Parameter Domain
(Anonymize=True) The domain that should be renamed.

.Parameter Url
(Anonymize=True) The url that should be renamed.

.Example
Export-M365DSCDiagnosticData -ExportFilePath C:\Temp\DSCLogsExport.zip -NumberOfDays 3

.Example
Export-M365DSCDiagnosticData -ExportFilePath C:\Temp\DSCLogsExport.zip -Anonymize -Server spfe -Domain contoso.com -Url sharepoint.contoso.com

.Functionality
Public
#>
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

    if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator') -eq $false)
    {
        throw 'You need to run this cmdlet with Administrator privileges!'
    }

    $afterDate = (Get-Date).AddDays(($NumberOfDays * -1))

    # Create Temp folder
    $guid = [Guid]::NewGuid()
    $tempPath = Join-Path -Path $env:TEMP -ChildPath $guid
    $null = New-Item -Path $tempPath -ItemType 'Directory'

    # Copy DSC Verbose Logs
    Write-Host '  * Copying DSC Verbose Logs' -ForegroundColor Gray
    $logPath = Join-Path -Path $tempPath -ChildPath 'DSCLogs'
    $null = New-Item -Path $logPath -ItemType 'Directory'

    $sourceLogPath = Join-Path -Path $env:windir -ChildPath 'System32\Configuration\ConfigurationStatus'
    $items = Get-ChildItem -Path "$sourceLogPath\*.json" | Where-Object { $_.LastWriteTime -gt $afterDate }
    Copy-Item -Path $items -Destination $logPath -ErrorAction 'SilentlyContinue' #-ErrorVariable $err

    if ($Anonymize)
    {
        Write-Host '    * Anonymizing DSC Verbose Logs' -ForegroundColor Gray
        foreach ($file in (Get-ChildItem -Path $logPath))
        {
            $content = Get-Content -Path $file.FullName -Raw -Encoding Unicode
            $content = $content -replace $Domain, '[DOMAIN]' -replace $Url, 'fqdn.com' -replace $Server, '[SERVER]'
            Set-Content -Path $file.FullName -Value $content
        }
    }

    # Export M365Dsc event log
    Write-Host '  * Exporting DSC Event Log' -ForegroundColor Gray
    $evtExportLog = Join-Path -Path $tempPath -ChildPath 'M365Dsc.csv'

    try
    {
        Write-Host '    * Anonymizing DSC Event Log' -ForegroundColor Gray
        Get-EventLog -LogName 'M365Dsc' -After $afterDate | Export-Csv $evtExportLog -NoTypeInformation
        if ($Anonymize)
        {
            $newLog = Import-Csv $evtExportLog
            foreach ($entry in $newLog)
            {
                $entry.MachineName = '[SERVER]'
                $entry.UserName = '[USER]'
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
    Write-Host '  * Exporting PowerShell Version info' -ForegroundColor Gray
    $psInfoFile = Join-Path -Path $tempPath -ChildPath 'PSInfo.txt'
    $PSVersionTable | Out-File -FilePath $psInfoFile

    # OS Version
    Write-Host '  * Exporting OS Version info' -ForegroundColor Gray
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
    Write-Host '  * Exporting LCM Configuration info' -ForegroundColor Gray
    $lcmInfoFile = Join-Path -Path $tempPath -ChildPath 'LCMInfo.txt'
    Get-DscLocalConfigurationManager | Out-File -FilePath $lcmInfoFile

    # Creating export package
    Write-Host '  * Creating Zip file with all collected information' -ForegroundColor Gray
    Compress-Archive -Path $tempPath -DestinationPath $ExportFilePath -Force

    # Cleaning up temporary data
    Write-Host '  * Removing temporary data' -ForegroundColor Gray
    Remove-Item $tempPath -Recurse -Force -Confirm:$false

    Write-Host ('Completed with export. Information exported to {0}' -f $ExportFilePath) -ForegroundColor Yellow
}

<#
.Description
This function attempts to register a new notification endpoint in registry.

.Parameter Url
Represents the Url of the endpoint to be contacted when events are detected.

.Parameter EventType
Represents the type of events that need to be reported to the endpoint.

.Functionality
Public
#>
function New-M365DSCNotificationEndPointRegistration
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Drift', 'Error', 'Warning', 'NonDrift', 'RuleEvaluation')]
        $EventType
    )

    # Get current notification endpoint registrations from registry and parse them into an object.
    $CurrentNotificationEndpoints = ([System.Environment]::GetEnvironmentVariable('M365DSCNotificationEndPointRegistrations', `
                [System.EnvironmentVariableTarget]::Machine))
    if ($null -ne $CurrentNotificationEndpoints)
    {
        $template = '{Url*:https://contoso.com}|{EventType:Error};{Url*:https://contoso.com}|{EventType:Error};'
        $CurrentNotificationEndpointsAsObject = ConvertFrom-String $CurrentNotificationEndpoints -TemplateContent $template
    }

    # Check to see if a notification endpoint registration with the same url and for the same event type already exists or not
    $existingInstance = $CurrentNotificationEndpointsAsObject | Where-Object -FilterScript { $_.Url -eq $url -and $_.EventType -eq $EventType }
    if ($null -ne $existingInstance)
    {
        throw "An existing endpoint notification registration on {$url} for {$EventType} already exists."
    }

    # If no exisiting instances, add the current one to the registry entry
    $CurrentNotificationEndpoints += "$($Url.Replace('|','').Replace(';',''))|$EventType;"
    [System.Environment]::SetEnvironmentVariable('M365DSCNotificationEndPointRegistrations', $CurrentNotificationEndpoints, `
            [System.EnvironmentVariableTarget]::Machine)
}

<#
.Description
This function attempts to remove a new notification endpoint in registry.

.Parameter Url
Represents the Url of the endpoint to be contacted when events are detected.

.Parameter EventType
Represents the type of events that need to be reported to the endpoint.

.Functionality
Public
#>
function Remove-M365DSCNotificationEndPointRegistration
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Drift', 'Error', 'Warning', 'NonDrift', 'RuleEvaluation')]
        $EventType
    )

    # Get current notification endpoint registrations from registry and parse them into an object.
    $CurrentNotificationEndpoints = ([System.Environment]::GetEnvironmentVariable('M365DSCNotificationEndPointRegistrations', `
                [System.EnvironmentVariableTarget]::Machine))
    if ($null -ne $CurrentNotificationEndpoints)
    {
        $template = '{Url*:https://contoso.com}|{EventType:Error};{Url*:https://contoso.com}|{EventType:Error};'
        $CurrentNotificationEndpointsAsObject = ConvertFrom-String $CurrentNotificationEndpoints -TemplateContent $template
    }

    # Check to see if a notification endpoint registration with the same url and for the same event type already exists or not
    $existingInstance = $CurrentNotificationEndpointsAsObject | Where-Object -FilterScript { $_.Url -eq $url -and $_.EventType -eq $EventType }
    if ($null -eq $existingInstance)
    {
        throw "No existing endpoint notification registration on {$url} for {$EventType} were found."
    }

    $valueToRemove += "$($Url.Replace('|','').Replace(';',''))|$EventType;"
    $CurrentNotificationEndpoints = $CurrentNotificationEndpoints.Replace($valueToRemove, '')

    # If we found an exisiting instance, remove it from registry entry's value.
    [System.Environment]::SetEnvironmentVariable('M365DSCNotificationEndPointRegistrations', $CurrentNotificationEndpoints, `
            [System.EnvironmentVariableTarget]::Machine)
}

<#
.Description
This function returns all or a specific notification endpoint registration.

.Parameter Url
Represents the Url of the endpoint to be contacted when events are detected.

.Parameter EventType
Represents the type of events that need to be reported to the endpoint.

.Functionality
Public
#>
function Get-M365DSCNotificationEndPointRegistration
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]
        $Url,

        [Parameter()]
        [System.String]
        [ValidateSet('Drift', 'Error', 'Warning', 'NonDrift', 'RuleEvaluation')]
        $EventType
    )

    # Get current notification endpoint registrations from registry and parse them into an object.
    $CurrentNotificationEndpoints = ([System.Environment]::GetEnvironmentVariable('M365DSCNotificationEndPointRegistrations', `
                [System.EnvironmentVariableTarget]::Machine))
    if ($null -ne $CurrentNotificationEndpoints)
    {
        $template = '{Url*:https://contoso.com}|{EventType:Error};{Url*:https://contoso.com}|{EventType:Error};'
        $CurrentNotificationEndpointsAsObject = ConvertFrom-String $CurrentNotificationEndpoints -TemplateContent $template

        # If both Url and EventType are null, return all endpoints
        if ([System.String]::IsNullOrEmpty($Url) -and [System.String]::IsNullOrEmpty($EventType))
        {
            return $CurrentNotificationEndpointsAsObject
        }
        elseif ([System.String]::IsNullOrEmpty($EventType) -and -not[System.String]::IsNullOrEmpty($Url))
        {
            # If Url is specified but EventType is null, return all endpoints on the given Url, no matter the EventType.
            return $CurrentNotificationEndpointsAsObject | Where-Object -FilterScript { $_.Url -eq $Url }
        }
        elseif (-not [System.String]::IsNullOrEmpty($EventType) -and [System.String]::IsNullOrEmpty($Url))
        {
            # If EventType is specified but $Url is null, return all endpoints matching the specified EventType.
            return $CurrentNotificationEndpointsAsObject | Where-Object -FilterScript { $_.EventType -eq $EventType }
        }
        elseif (-not [System.String]::IsNullOrEmpty($EventType) -and -not [System.String]::IsNullOrEmpty($Url))
        {
            # If both Url and EventType are specified, return endpoints that match both.
            return $CurrentNotificationEndpointsAsObject | Where-Object -FilterScript { $_.EventType -eq $EventType -and $Url -eq $Url }
        }
    }
    return $null
}

<#
.Description
This function receives an event, will loop through all registered notification endpoints
and will send a message to them if they have a registration on the given EventType of
the message.

.Functionality
Private
#>
function Send-M365DSCNotificationEndPointMessage
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]
        $EventDetails,

        [Parameter()]
        [System.String]
        [ValidateSet('Drift', 'Error', 'Warning', 'NonDrift', 'RuleEvaluation')]
        $EventType
    )

    # Get all notification endpoints that are registered for the given EventType
    [Array]$endpointsToContact = Get-M365DSCNotificationEndPointRegistration -EventType $EventType

    $messageBody = @{
        Details   = $EventDetails
        EventType = $EventType
    }

    $Parameters = @{
        Method      = 'POST'
        Uri         = ''
        Body        = ($messageBody | ConvertTo-Json)
        Headers     = $null
        ContentType = 'application/json'
    }

    foreach ($endpoint in $endpointsToContact)
    {
        try
        {
            $variableValue = Get-Variable -Name ('M365DSCNotificationEndpointBearer' + $domain) -Scope Global -ErrorAction SilentlyContinue

            if (-not [System.String]::IsNullOrEMpty($variableValue))
            {
                $domain = $endpoint.Url.Replace('https://', '').Replace('http://', '').Split('/')[0].Split('.')[0]
                $bearerTokenValue = (Get-Variable -Name ('M365DSCNotificationEndpointBearer' + $domain) -Scope Global).Value
                $Parameters.Headers = @{'Authorization' = "Bearer $bearerTokenValue" }
            }
            else
            {
                $Parameters.Headers = $null
            }
            $Parameters.Uri = $endpoint.url
            Invoke-RestMethod @Parameters | Out-Null
        }
        catch
        {
            Write-Verbose -Message "$_"
        }
    }
}

<#
.Description
This function determines if the process is running interactively or unattended.

.Functionality
Private
#>
function Assert-M365DSCIsNonInteractiveShell
{
    param ()

    # Test each Arg for match of abbreviated '-NonInteractive' command.
    $NonInteractive = [Environment]::GetCommandLineArgs() | Where-Object -FilterScript { $_ -like '-NonI*' }

    if ([Environment]::UserInteractive -and -not $NonInteractive)
    {
        # We are in an interactive shell.
        return $false
    }

    return $true
}

<#
.Description
This function configures the option for logging events into the Event Log.

.Parameter IncludeNonDrifted
Determines whether or not we should log information about resource's instances that don't have drifts.

.Functionality
Public
#>
function Set-M365DSCLoggingOption
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Boolean]
        $IncludeNonDrifted
    )

    if ($null -ne $IncludeNonDrifted)
    {
        [System.Environment]::SetEnvironmentVariable('M365DSCEventLogIncludeNonDrifted', $IncludeNonDrifted, `
                [System.EnvironmentVariableTarget]::Machine)
    }
}

<#
.Description
This function returns information about the option for logging events into the Event Log.

.Functionality
Public
#>
function Get-M365DSCLoggingOption
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    try
    {
        return @{
            IncludeNonDrifted = [Boolean]([System.Environment]::GetEnvironmentVariable('M365DSCEventLogIncludeNonDrifted', `
                    [System.EnvironmentVariableTarget]::Machine))
        }
    }
    catch
    {
        throw $_
    }
}

Export-ModuleMember -Function @(
    'Add-M365DSCEvent',
    'Assert-M365DSCIsNonInteractiveShell',
    'Export-M365DSCDiagnosticData',
    'Get-M365DSCLoggingOption',
    'New-M365DSCLogEntry',
    'Get-M365DSCNotificationEndPointRegistration',
    'New-M365DSCNotificationEndPointRegistration',
    'Remove-M365DSCNotificationEndPointRegistration',
    'Set-M365DSCLoggingOption'
)
