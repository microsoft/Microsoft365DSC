#region Session Objects
$Global:SessionSecurityCompliance = $null
#endregion

#region Push Notifications
$Global:M365DSCPushNotificationsURI = $null
$Global:M365DSCPushNotificationsHeaders = $null
$Global:M365DSCPushNotificationsBody = $null
#endregion

$Script:M365DSCWorkloads = @('AAD', 'ADO', 'AZURE', 'COMMERCE', 'DEFENDER', 'EXO', 'FABRIC', 'INTUNE', 'O365', 'OD', 'PLANNER', 'PP', 'SC', 'SENTINEL', 'SH', 'SPO', 'TEAMS')

<#
.Description
The Get-TemporaryPath function will return the temporary
path specific to the OS. It will return $env:TEMP when run
on Windows OS, '/tmp' when run in Linux and $env:TMPDIR when
run on MacOS.

.Example
Get-TemporaryPath

Get the temporary path (which will differ between operating system).

.Functionality
Internal,Hidden
#>
function Get-TemporaryPath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param ()

    $temporaryPath = $null

    switch ($true)
    {
        (-not (Test-Path -Path variable:IsWindows) -or ((Get-Variable -Name 'IsWindows' -ValueOnly -ErrorAction SilentlyContinue) -eq $true))
        {
            # Windows PowerShell or PowerShell 6+
            $temporaryPath = (Get-Item -Path env:TEMP).Value
        }

        ((Get-Variable -Name 'IsMacOs' -ValueOnly -ErrorAction SilentlyContinue) -eq $true)
        {
            $temporaryPath = (Get-Item -Path env:TMPDIR).Value
        }

        ((Get-Variable -Name 'IsLinux' -ValueOnly -ErrorAction SilentlyContinue) -eq $true)
        {
            $temporaryPath = '/tmp'
        }

        default
        {
            throw 'Cannot set the temporary path. Unknown operating system.'
        }
    }

    return $temporaryPath
}

$env:TEMP = Get-TemporaryPath

<#
.SYNOPSIS
    Retrieves a Microsoft Teams team by display name.

.DESCRIPTION
    Queries Teams for a team matching the provided display name.
    Retries briefly to account for eventual consistency and returns null when the team cannot be resolved.

.PARAMETER TeamName
    Specifies the display name of the team to resolve.

.FUNCTIONALITY
    Internal

.OUTPUTS
    Hashtable
#>
function Get-TeamByName
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $TeamName
    )

    try
    {
        $loopCounter = 0
        do
        {
            $team = Get-Team -DisplayName $TeamName | Where-Object -Property DisplayName -EQ [System.Net.WebUtility]::UrlDecode($TeamName)
            if ($null -eq $team)
            {
                Start-Sleep 5
            }
            $loopCounter += 1
            if ($loopCounter -gt 5)
            {
                break
            }
        } while ($null -eq $team)

        if ($null -eq $team)
        {
            throw "Team with Name $TeamName doesn't exist in tenant"
        }
        elseif ($teams.Length -gt 1)
        {
            Write-Warning -Message "More than one Team with name {$TeamName} was found. This could prevent your configuration from compiling properly."
        }
        return $team
    }
    catch
    {
        return $null
    }
}

<#
.SYNOPSIS
    Converts a hashtable to Microsoft365DSC string format.

.DESCRIPTION
    Uses the Microsoft365DSC converter assembly to serialize a hashtable into the string representation used by logging and display helpers.

.PARAMETER Hashtable
    Specifies the hashtable to convert.

.FUNCTIONALITY
    Internal
#>
function Convert-M365DscHashtableToString
{
    param
    (
        [Parameter()]
        [System.Collections.Hashtable]
        $Hashtable
    )

    Initialize-M365DSCDllLoader -ErrorAction Stop
    return [Microsoft365DSC.Converter.HashtableConverter]::ToString($Hashtable)
}

<#
.SYNOPSIS
    Tests whether an imported cmdlet is available in the current session.

.DESCRIPTION
    Checks command discovery for a cmdlet name and returns a boolean result.

.PARAMETER CmdletName
    Specifies the cmdlet name to look up.

.FUNCTIONALITY
    Internal

.OUTPUTS
    System.Boolean
#>
function Confirm-ImportedCmdletIsAvailable
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $CmdletName
    )

    try
    {
        $CmdletIsAvailable = (Get-Command -Name $CmdletName -ErrorAction SilentlyContinue)
        if ($CmdletIsAvailable)
        {
            return $true
        }
        else
        {
            return $false
        }
    }
    catch
    {
        return $false
    }
}

<#
.SYNOPSIS
    Normalizes an enumerable property value into a typed array.

.DESCRIPTION
    Creates an array of the requested element type from the provided property value.
    Used to ensure stable array typing in generated and compared values.

.PARAMETER PropertyValue
    Specifies the input value to convert to an array.

.PARAMETER ElementType
    Specifies the element type to use for the output array.

.FUNCTIONALITY
    Internal

.OUTPUTS
    System.Array
#>
function Get-M365DSCArrayFromProperty
{
    [CmdletBinding()]
    [OutputType([System.Array])]
    param
    (
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [AllowNull()]
        [System.Object]
        $PropertyValue,

        [Parameter(Mandatory = $false)]
        [System.Type]
        $ElementType = [System.Object]
    )

    $array = [System.Array]::CreateInstance($ElementType, 0)
    foreach ($item in $PropertyValue)
    {
        $array += $item
    }

    ,$array
}

<#
.SYNOPSIS
    Compares desired and current parameter values for drift.

.DESCRIPTION
    Performs drift evaluation between desired and current values, records drift details, emits telemetry, and can write event log entries for drift and non-drift states.

.PARAMETER CurrentValues
    Specifies the current values retrieved from the tenant.

.PARAMETER DesiredValues
    Specifies the desired values to compare against.

.PARAMETER ValuesToCheck
    Specifies the property names that should be compared.

.PARAMETER Source
    Specifies the resource/source name used for logging and telemetry.

.PARAMETER IncludedDrifts
    Specifies precomputed drift details to include in comparison output.

.PARAMETER NoEventMessage
    Indicates that event log messages should not be written.

.PARAMETER NoDriftReset
    Indicates that global drift collections should not be reset before comparison.

.PARAMETER ExcludedProperties
    Specifies property names to skip during comparison.

.FUNCTIONALITY
    Public

.OUTPUTS
    System.Boolean
#>
function Test-M365DSCParameterState
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true, Position = 1)]
        [HashTable]
        $CurrentValues,

        [Parameter(Mandatory = $true, Position = 2)]
        [Object]
        $DesiredValues,

        [Parameter(Position = 3)]
        [Array]
        $ValuesToCheck,

        [Parameter(Position = 4)]
        [System.String]
        $Source = 'Generic',

        [Parameter(Position = 5)]
        [System.Collections.Hashtable]
        $IncludedDrifts,

        [Parameter(Position = 6)]
        [switch]
        $NoEventMessage,

        [Parameter(Position = 7)]
        [switch]
        $NoDriftReset,

        [Parameter(Position = 8)]
        [System.String[]]
        $ExcludedProperties
    )

    $startTime = [System.DateTime]::Now
    if ($null -eq $Global:AllDrifts -or -not $NoDriftReset)
    {
        $Global:AllDrifts = @{
            DriftInfo     = @()
            CurrentValues = @{}
            DesiredValues = @{}
        }
        $Global:PotentialDrifts = @()
    }

    $returnValue = $true
    $TenantName = Get-M365DSCTenantNameFromParameterSet -ParameterSet $DesiredValues

    #region Telemetry
    if (Test-IsM365DSCTelemetryEnabled)
    {
        $dataEvaluation = [System.Collections.Generic.Dictionary[[System.String], [System.Object]]]::new()
        $dataEvaluation.Add('Resource', "$Source")
        $dataEvaluation.Add('Method', 'Test-TargetResource')
        $dataEvaluation.Add('Tenant', $TenantName)

        $ConnectionMode = Get-M365DSCAuthenticationMode $DesiredValues
        $dataEvaluation.Add('ConnectionMode', $ConnectionMode)
        $dataEvaluation.Add('Parameters', $ValuesToCheck -join "`r`n")
        $dataEvaluation.Add('ParametersCount', $ValuesToCheck.Length)
        Add-M365DSCTelemetryEvent -Type 'DriftEvaluation' -Data $dataEvaluation
    }

    Initialize-M365DSCDllLoader -ErrorAction Stop
    $compareResult = [Microsoft365DSC.Compare.SimpleObjectComparer]::Compare($CurrentValues, $DesiredValues, $ValuesToCheck, $IncludedDrifts, $NoEventMessage, $NoDriftReset, $ExcludedProperties)
    $driftedParameters = $compareResult.DriftedParameters
    $driftObject = $compareResult.DriftObject
    $returnValue = $compareResult.TestResult

    $includeNonDriftsInformation = $false
    try
    {
        $includeNonDriftsInformation = [System.Environment]::GetEnvironmentVariable('M365DSCEventLogIncludeNonDrifted', `
                [System.EnvironmentVariableTarget]::Machine)
    }
    catch
    {
        Write-Verbose -Message $_
    }

    if ($returnValue -eq $false -or $DriftedParameters.Keys.Length -gt 0)
    {
        $EventMessage = [System.Text.StringBuilder]::new()
        $EventMessage.Append("<M365DSCEvent>`r`n") | Out-Null
        Write-Verbose -Message "Found Tenant Name: $TenantName"

        $LCMState = $null
        try
        {
            if (($PSEdition -eq 'Desktop' -or $IsWindows) -and ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) `
                -and $null -eq $Script:LCMInfo )
            {
                $Script:LCMInfo = Get-DscLocalConfigurationManager -ErrorAction Stop

                if ($Script:LCMInfo.LCMStateDetail -eq 'LCM is performing a consistency check.' -or `
                        $Script:LCMInfo.LCMStateDetail -eq 'LCM exécute une vérification de cohérence.' -or `
                        $Script:LCMInfo.LCMStateDetail -eq 'LCM führt gerade eine Konsistenzüberprüfung durch.')
                {
                    $LCMState = 'ConsistencyCheck'
                }
                elseif ($Script:LCMInfo.LCMStateDetail -eq 'LCM is testing node against the configuration.')
                {
                    $LCMState = 'ManualTestDSCConfiguration'
                }
                elseif ($Script:LCMInfo.LCMStateDetail -eq 'LCM is applying a new configuration.' -or `
                        $Script:LCMInfo.LCMStateDetail -eq 'LCM applique une nouvelle configuration.')
                {
                    $LCMState = 'Initial'
                }
            }
            else
            {
                $LCMState = 'Unauthorized'
            }
        }
        catch
        {
            Write-Verbose -Message $_.Exception
        }
        $EventMessage.Append("    <ConfigurationDrift Source=`"$Source`" TenantId=`"$TenantName`"") | Out-Null
        if (-not [System.String]::IsNullOrEmpty($LCMState))
        {
            $EventMessage.Append(" LCMState=`"" + $LCMState + "`"") | Out-Null
        }
        $EventMessage.Append(">`r`n") | Out-Null
        $EventMessage.Append("        <ParametersNotInDesiredState>`r`n") | Out-Null

        $DriftObject.Add('Tenant', $TenantName)
        $DriftObject.Add('Resource', $source.Split('_')[1])

        #endregion
        $telemetryDriftedParameters = ''
        foreach ($key in $DriftedParameters.Keys)
        {
            Write-Verbose -Message "Detected Drifted Parameter [$Source]$key"
            $telemetryDriftedParameters += $key + "`r`n"
            $EventMessage.Append("            <Param Name=`"$key`">" + $DriftedParameters.$key + "</Param>`r`n") | Out-Null
        }

        if (Test-IsM365DSCTelemetryEnabled)
        {
            $driftedData = [System.Collections.Generic.Dictionary[[System.String], [System.Object]]]::new()
            $driftedData.Add('Resource', $source.Split('_')[1])
            $driftedData.Add('Tenant', $TenantName)

            # If custom App Insights is specified, allow for the current and desired values to be captured;
            # ISSUE #1222
            if ($null -ne $env:M365DSCTelemetryInstrumentationKey -and `
                    $env:M365DSCTelemetryInstrumentationKey -ne 'bc5aa204-0b1e-4499-a955-d6a639bdb4fa' -and `
                    $env:M365DSCTelemetryInstrumentationKey -ne 'e670af5d-fd30-4407-a796-8ad30491ea7a')
            {
                $driftedData.Add('CurrentValues', $CurrentValues)
                $driftedData.Add('DesiredValues', $DesiredValues)
            }
            $driftedData.Add('Parameters', $telemetryDriftedParameters)
            Add-M365DSCTelemetryEvent -Type 'DriftInfo' -Data $driftedData
        }
        $EventMessage.Append("        </ParametersNotInDesiredState>`r`n") | Out-Null
        $EventMessage.Append("    </ConfigurationDrift>`r`n") | Out-Null
        $EventMessage.Append("    <DesiredValues>`r`n") | Out-Null
        foreach ($Key in $DesiredValues.Keys)
        {
            $Value = $DesiredValues.$Key
            if ([System.String]::IsNullOrEmpty($Value))
            {
                $Value = "`$null"
            }
            $EventMessage.Append("        <Param Name =`"$key`">$Value</Param>`r`n") | Out-Null
            $DriftObject.DesiredValues.Add($key, $value)
        }
        $EventMessage.Append("    </DesiredValues>`r`n") | Out-Null
        $EventMessage.Append("    <CurrentValues>`r`n") | Out-Null
        foreach ($Key in $CurrentValues.Keys)
        {
            $Value = $CurrentValues.$Key
            if ([System.String]::IsNullOrEmpty($Value))
            {
                $Value = "`$null"
            }
            $EventMessage.Append("        <Param Name =`"$key`">$Value</Param>`r`n") | Out-Null
            $DriftObject.CurrentValues.Add($key, $value)
        }
        $EventMessage.Append("    </CurrentValues>`r`n") | Out-Null
        $EventMessage.Append('</M365DSCEvent>') | Out-Null
        foreach ($drift in $DriftObject.DriftInfo)
        {
            $Global:AllDrifts.DriftInfo += @{
                PropertyName = $drift.PropertyName
                CurrentValue = $drift.CurrentValue
                DesiredValue = $drift.DesiredValue
            }
        }
        if (-not $NoEventMessage)
        {
            Add-M365DSCEvent -Message $EventMessage.ToString() -EventType 'Drift' -EntryType 'Warning' `
                -EventID 1 -Source $Source
        }
        $Global:CCMCurrentDriftInfo = $DriftObject
    }
    elseif ($includeNonDriftsInformation -eq $true)
    {
        # Include details about non-drifted resources.
        $EventMessage = [System.Text.StringBuilder]::new()
        $EventMessage.Append("<M365DSCEvent>`r`n") | Out-Null
        $EventMessage.Append("    <ConfigurationDrift Source=`"$Source`" />`r`n") | Out-Null
        $EventMessage.Append("    <DesiredValues>`r`n") | Out-Null
        foreach ($Key in $DesiredValues.Keys)
        {
            $Value = $DesiredValues.$Key
            if ([System.String]::IsNullOrEmpty($Value))
            {
                $Value = "`$null"
            }
            $EventMessage.Append("        <Param Name =`"$key`">$Value</Param>`r`n") | Out-Null
        }
        $EventMessage.Append("    </DesiredValues>`r`n") | Out-Null
        $EventMessage.Append('</M365DSCEvent>') | Out-Null
        Add-M365DSCEvent -Message $EventMessage.ToString() -EventType 'NonDrift' -EntryType 'Information' `
            -EventID 2 -Source $Source
    }

    if (Test-IsM365DSCTelemetryEnabled)
    {
        $timeTaken = [System.DateTime]::Now.Subtract($startTime).TotalMilliseconds
        $data = [System.Collections.Generic.Dictionary[[System.String], [System.Object]]]::new()
        $data.Add('Resource', $Source)
        $data.Add('Method', 'Test-M365DSCParameterState')
        $data.Add('TimeTakenMilliseconds', $timeTaken)
        $data.Add('Tenant', $TenantName)
        $data.Add('ParametersCount', $KeyList.Count)

        Add-M365DSCTelemetryEvent -Type 'ResourceTesting' `
            -Data $data
    }
    return $returnValue
}

<#
.SYNOPSIS
    Executes standardized target resource testing for a DSC resource.

.DESCRIPTION
    Retrieves current resource state, compares it with desired values, and returns the test result.
    Optionally returns a detailed pass-through object and writes drift details to event logs.

.PARAMETER DesiredValues
    Specifies desired parameter values passed to the target resource.

.PARAMETER ResourceName
    Specifies the DSC resource name to test.

.PARAMETER ExcludedProperties
    Specifies property names to exclude from comparison.

.PARAMETER IncludedProperties
    Specifies the explicit property names to compare.

.PARAMETER PostProcessing
    Specifies an optional callback to transform compare inputs before evaluation.

.PARAMETER PostProcessingArgs
    Specifies arguments passed to the post-processing callback.

.PARAMETER PassThru
    Indicates that a detailed result object should be returned instead of only a boolean.

.FUNCTIONALITY
    Internal

.OUTPUTS
    System.Boolean
    System.Collections.Hashtable
#>
function Test-M365DSCTargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    [OutputType([System.Collections.Hashtable], ParameterSetName = 'PassThru')]
    param(
        [Parameter()]
        $DesiredValues,

        [Parameter()]
        [System.String]
        $ResourceName,

        [Parameter()]
        [System.String[]]
        $ExcludedProperties,

        [Parameter()]
        [System.String[]]
        $IncludedProperties,

        [Parameter()]
        [System.Func[Hashtable, Hashtable, Hashtable, [Object[]], Tuple[Hashtable, Hashtable, Hashtable]]]
        $PostProcessing,

        [Parameter()]
        [System.Object[]]
        $PostProcessingArgs = @(),

        [Parameter(
            ParameterSetName = 'PassThru'
        )]
        [switch]
        $PassThru
    )

    $Global:AllDrifts = @{
        DriftInfo     = @()
        CurrentValues = @{}
        DesiredValues = @{}
    }
    $Global:PotentialDrifts = @()

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies
    Initialize-M365DSCDllLoader -ErrorAction Stop

    if ($null -eq (Get-Module -Name 'M365DSCCompare'))
    {
        $compareModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'M365DSCCompare.psm1'
        Import-Module -Name $compareModulePath -Force
    }

    # Retrieve the primary keys of the given resource and remove them from the list of values to check.
    $currentPath = $PSScriptRoot
    if (-not [Microsoft365DSC.Cache.CacheManager]::IsSchemaLoaded)
    {
        $schemaPath = Join-Path -Path $currentPath -ChildPath '../SchemaDefinition.json'
        if (-not (Test-Path -Path $schemaPath))
        {
            throw "SchemaDefinition.json not found at expected path: $schemaPath. Ensure that the schema was properly included during module build and that the module is not being run from a non-standard location."
        }
        $schemaContent = [System.IO.File]::ReadAllText($schemaPath) | ConvertFrom-Json
        [Microsoft365DSC.Cache.CacheManager]::LoadSchema($schemaContent)
    }
    $resourceDefinition = [Microsoft365DSC.Utilities.Utilities]::FilterLoadedCimClassesByName("MSFT_$ResourceName")
    $resourceKeys = $resourceDefinition.Parameters | Where-Object -Property Option -EQ 'Key'

    $keyStrings = @()
    foreach ($resourceKey in $resourceKeys)
    {
        $keyName = $resourceKey.Name
        $keyStrings += "$keyName {$($DesiredValues.$keyName)}"
    }
    $finalString = $keyStrings -join ' and '

    $Verbose = $false
    if ($DesiredValues.Verbose -eq $true)
    {
        $Verbose = $true
    }

    Write-Verbose -Message "Testing configuration of the $ResourceName with $finalString" -Verbose:$Verbose

    $CurrentValues = & MSFT_$ResourceName\Get-TargetResource @DesiredValues

    $testTargetResource = Compare-M365DSCResourceState -ResourceName $ResourceName `
        -DesiredValues $DesiredValues `
        -CurrentValues $CurrentValues `
        -ExcludedProperties $ExcludedProperties `
        -IncludedProperties $IncludedProperties `
        -PostProcessing $PostProcessing `
        -PostProcessingArgs $PostProcessingArgs

    if (-not $testTargetResource)
    {
        $TenantName = Get-M365DSCTenantNameFromParameterSet -ParameterSet $DesiredValues
        Write-M365DSCDriftsToEventLog -Drifts $Global:AllDrifts `
            -ResourceName $ResourceName `
            -TenantName $TenantName `
            -CurrentValues $CurrentValues `
            -DesiredValues $DesiredValues `
            -Verbose:$Verbose
    }

    Write-Verbose -Message "Test-M365DSCTargetResource returned $testTargetResource" -Verbose:$Verbose

    if ($PassThru)
    {
        return @{
            ResourceName       = $ResourceName
            CurrentValues      = $CurrentValues
            DesiredValues      = $DesiredValues
            TestTargetResource = $testTargetResource
        }
    }

    return $testTargetResource
}

<#
.SYNOPSIS
    Stores the DSC resource dictionary in module scope.

.DESCRIPTION
    Sets the cached dictionary of resource metadata used by other helper functions.

.PARAMETER DscResourceDictionary
    Specifies the resource dictionary to cache.

.FUNCTIONALITY
    Internal
#>
function Set-M365DSCAllResourcesDictionary
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $DscResourceDictionary
    )

    $Script:AllM365DSCResources = $DscResourceDictionary
}

<#
.SYNOPSIS
    Returns the cached DSC resource dictionary.

.DESCRIPTION
    Returns the module-scoped dictionary containing loaded Microsoft365DSC resource metadata.

.FUNCTIONALITY
    Internal
#>
function Get-M365DSCAllResourcesDictionary
{
    [CmdletBinding()]
    param()

    $Script:AllM365DSCResources
}

<#
.SYNOPSIS
    Initializes the cached DSC resource dictionary.

.DESCRIPTION
    Loads Microsoft365DSC resource metadata into a module-scoped dictionary when not already initialized.

.FUNCTIONALITY
    Internal
#>
function Initialize-M365DSCAllResourcesDictionary
{
    [CmdletBinding()]
    param()

    if ($null -eq $Script:AllM365DSCResources -and -not $Global:IsTestEnvironment)
    {
        $Script:AllM365DSCResources = [System.Collections.Generic.Dictionary[System.String, System.Object]]::new([System.StringComparer]::InvariantCultureIgnoreCase)
        $resources = Get-DscResourceV2 -Module 'Microsoft365DSC'
        foreach ($resource in $resources)
        {
            $Script:AllM365DSCResources.Add($resource.Name, $resource)
        }
    }
}

<#
.SYNOPSIS
    Warns when the current code page is not UTF-8.

.DESCRIPTION
    Checks the active code page and emits guidance when UTF-8 is not configured, because non-UTF8 sessions can cause Unicode issues in exported content.

.EXAMPLE
    PS> Test-CodePage

.FUNCTIONALITY
    Private
#>
function Test-CodePage
{
    if ([System.Text.Encoding]::Default.CodePage -ne 65001)
    {
        Write-Warning -Message 'The code page of the current session is not set to UTF-8. This may cause issues with Unicode characters.
         To change the code page to UTF-8, you have the following options:
         * Using the control panel: intl.cpl --> Administrative --> Change system locale --> Beta: Use Unicode UTF-8 for worldwide language support
         * Using PowerShell: Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "ACP" -Value 65001
         After that, you need to restart the PowerShell session.'
    }
}

<#
.SYNOPSIS
    Installs the Microsoft365DSC Dev branch package.

.DESCRIPTION
    Downloads the Dev branch archive from GitHub, installs required dependencies, and updates the local Microsoft365DSC module files.

.PARAMETER Scope
    Specifies the installation scope used for dependency installation.

.EXAMPLE
    Install-M365DSCDevBranch

.EXAMPLE
    Install-M365DSCDevBranch -Scope CurrentUser

.FUNCTIONALITY
    Public
#>
function Install-M365DSCDevBranch
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('CurrentUser', 'AllUsers')]
        $Scope = 'AllUsers'
    )

    try
    {

        $longPathsEnabled = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem').LongPathsEnabled -eq 1
        if (-not $longPathsEnabled)
        {
            $message = 'Long paths are not enabled on this system. You may encounter issues with the installation of Microsoft365DSC because of long file names.'
            $message += 'To enable long paths, set the registry LongPathsEnabled DWORD entry to 1 in HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem.'
            Write-Warning -Message $message
        }

        #region Download and Extract Dev branch's ZIP
        Write-Host 'Downloading the Zip package...' -NoNewline
        $url = 'https://github.com/microsoft/Microsoft365DSC/archive/Dev.zip'
        $output = "$($env:TEMP)/dev.zip"
        $extractPath = "$($env:TEMP)/O365Dev"
        Write-Host 'Done' -ForegroundColor Green

        Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing

        Expand-Archive $output -DestinationPath $extractPath -Force
        #endregion

        #region Install All Dependencies
        $manifest = Import-PowerShellDataFile "$extractPath\Microsoft365DSC-Dev\Modules\Microsoft365DSC\Microsoft365DSC.psd1"
        $dependencies = $manifest.RequiredModules
        if (($PSEdition -eq 'Desktop' -or $IsWindows) -and (-not(([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) -and ($Scope -eq 'AllUsers'))
        {
            throw 'Cannot update the dependencies for Microsoft365DSC. You need to run this command as a local administrator.'
        }

        foreach ($dependency in $dependencies)
        {
            Write-Host "Installing {$($dependency.ModuleName)}..." -NoNewline
            $existingModule = Get-Module $dependency.ModuleName -ListAvailable | Where-Object -Property Version -EQ $dependency.RequiredVersion
            if ($null -eq $existingModule)
            {
                Install-Module $dependency.ModuleName -RequiredVersion $dependency.RequiredVersion -Force -AllowClobber -Scope $Scope | Out-Null
            }
            Import-Module $dependency.ModuleName -Force | Out-Null
            Write-Host 'Done' -ForegroundColor Green
        }
        #endregion

        #region Install M365DSC
        Write-Host 'Updating the Core Microsoft365DSC module...' -NoNewline
        $defaultPath = 'C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\'
        $currentVersionPath = $defaultPath + ([Version]$($manifest.ModuleVersion)).ToString()

        Copy-Item "$extractPath\Microsoft365DSC-Dev\Modules\Microsoft365DSC\*" `
            -Destination $defaultPath -Recurse -Force

        Import-Module ($defaultPath + 'Microsoft365DSC.psd1') -Force | Out-Null
        $oldModule = Get-Module 'Microsoft365DSC' | Where-Object -Property ModuleBase -EQ $currentVersionPath
        Remove-Module $oldModule -Force | Out-Null
        if (Test-Path $currentVersionPath)
        {
            try
            {
                Remove-Item $currentVersionPath -Recurse -Confirm:$false -Force `
                    -ErrorAction Stop
            }
            catch
            {
                Write-Verbose -Message $_
            }
        }
        Write-Host 'Done' -ForegroundColor Green
        #endregion
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error installing Dev Branch:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source)
        Write-Error $_
    }
}

<#
.SYNOPSIS
    Retrieves package files from the SharePoint tenant app catalog.

.DESCRIPTION
    Connects to SharePoint Online, enumerates app catalog package files, and returns package metadata used by export and validation routines.

.PARAMETER Credential
    Specifies delegated credentials used for SharePoint connection.

.PARAMETER ApplicationId
    Specifies the application id used for app-based authentication.

.PARAMETER TenantId
    Specifies the tenant id or tenant domain used for authentication.

.PARAMETER CertificatePath
    Specifies the certificate path used for app-based authentication.

.PARAMETER CertificatePassword
    Specifies the certificate password used for app-based authentication.

.PARAMETER CertificateThumbprint
    Specifies the certificate thumbprint used for app-based authentication.

.PARAMETER ManagedIdentity
    Indicates that managed identity authentication should be used.

.FUNCTIONALITY
    Internal

.OUTPUTS
    System.Collections.Hashtable[]
#>
function Get-AllSPOPackages
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable[]])]
    param
    (
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    try
    {
        $null = New-M365DSCConnection -Workload 'PnP' `
            -InboundParameters $PSBoundParameters

        $tenantAppCatalogUrl = Get-PnPTenantAppCatalogUrl -ErrorAction Stop

        $null = New-M365DSCConnection -Workload 'PnP' `
            -InboundParameters $PSBoundParameters `
            -Url $tenantAppCatalogUrl

        $filesToDownload = @()
        $allFiles = @()
        if ($null -ne $tenantAppCatalogUrl)
        {
            try
            {
                [Array]$spfxFiles = @(Find-PnPFile -List 'AppCatalog' -Match '*.sppkg' -ErrorAction Stop)
                [Array]$appFiles = @(Find-PnPFile -List 'AppCatalog' -Match '*.app' -ErrorAction Stop)

                $allFiles = $spfxFiles + $appFiles

                foreach ($file in $allFiles)
                {
                    $filesToDownload += @{
                        Name  = $file.Name
                        Site  = $tenantAppCatalogUrl
                        Title = $file.Title
                    }
                }
            }
            catch
            {
                New-M365DSCLogEntry -Message $_.Exception.Message `
                    -Exception $_ `
                    -Source $($MyInvocation.MyCommand.Source) `
                    -TenantId $TenantId `
                    -Credential $Credential
            }
        }

        return $filesToDownload
    }
    catch
    {
        Write-Verbose -Message $_
    }

    return $null
}

<#
.SYNOPSIS
    Removes null or empty values from a hashtable.

.DESCRIPTION
    Scans a hashtable and removes keys whose values are null or empty strings.

.PARAMETER Hash
    Specifies the hashtable to clean.

.FUNCTIONALITY
    Internal

.OUTPUTS
    System.Collections.Hashtable
#>
function Remove-NullEntriesFromHashtable
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.COllections.HashTable]
        $Hash
    )

    $keysToRemove = @()
    foreach ($key in $Hash.Keys)
    {
        if ([System.String]::IsNullOrEmpty($Hash.$key))
        {
            $keysToRemove += $key
        }
    }

    foreach ($key in $keysToRemove)
    {
        $Hash.Remove($key) | Out-Null
    }

    return $Hash
}

<#
.SYNOPSIS
    Compares a tenant export against a blueprint configuration.

.DESCRIPTION
    Downloads or opens a blueprint file, exports matching tenant resources, and generates a delta report showing drift between blueprint and tenant state.

.PARAMETER BluePrintUrl
    Specifies the blueprint URL or local path.

.PARAMETER OutputReportPath
    Specifies the output path of the generated report.

.PARAMETER Credentials
    Specifies delegated credentials used for authentication.

.PARAMETER ApplicationId
    Specifies the application id used for app-based authentication.

.PARAMETER TenantId
    Specifies the tenant id or tenant domain used for authentication.

.PARAMETER ApplicationSecret
    Specifies the application secret used for app-based authentication.

.PARAMETER CertificatePath
    Specifies the certificate path used for app-based authentication.

.PARAMETER CertificatePassword
    Specifies the certificate password used for app-based authentication.

.PARAMETER CertificateThumbprint
    Specifies the certificate thumbprint used for app-based authentication.

.PARAMETER ManagedIdentity
    Indicates that managed identity authentication should be used.

.PARAMETER AccessTokens
    Specifies access tokens used for authentication.

.PARAMETER HeaderFilePath
    Specifies a custom report header file path.

.PARAMETER Type
    Specifies the delta report output type.

.PARAMETER ExcludedProperties
    Specifies property names to exclude from comparison.

.PARAMETER ExcludedResources
    Specifies resource names to exclude from comparison.

.PARAMETER DriftOnly
    Indicates that only drifts should be included in the report.

.PARAMETER KeepExport
    Indicates that the temporary export should be retained.

.PARAMETER UseVariableSubstitution
    Indicates that variable substitution should be applied during comparison.

.PARAMETER SourceConfigurationDataPath
    Specifies source configuration data for variable substitution.

.PARAMETER DestinationConfigurationDataPath
    Specifies destination configuration data for variable substitution.

.PARAMETER ExcludedSubstitutionProperties
    Specifies properties excluded from substitution.

.PARAMETER Parallel
    Indicates that export should run in parallel.

.EXAMPLE
    PS> Assert-M365DSCBlueprint -BluePrintUrl 'C:\DS\blueprint.m365' -OutputReportPath 'C:\DSC\BlueprintReport.html'

.EXAMPLE
    PS> Assert-M365DSCBlueprint -BluePrintUrl 'C:\DS\blueprint.m365' -OutputReportPath 'C:\DSC\BlueprintReport.html' -Credentials $credentials -HeaderFilePath 'C:\DSC\ReportCustomHeader.html'

.EXAMPLE
    PS> Assert-M365DSCBlueprint -BluePrintUrl 'C:\DS\blueprint.m365' -OutputReportPath 'C:\DSC\BlueprintReport.html' -ApplicationId $clientid -TenantId $tenantId -CertificateThumbprint $certthumbprint -HeaderFilePath 'C:\DSC\ReportCustomHeader.html'

.EXAMPLE
    PS> Assert-M365DSCBlueprint -BluePrintUrl 'C:\DS\blueprint.m365' -OutputReportPath 'C:\DSC\BlueprintReport.html' -KeepExport $true

.FUNCTIONALITY
    Public

#>
function Assert-M365DSCBlueprint
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $BluePrintUrl,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OutputReportPath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credentials,

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens,

        [Parameter()]
        [System.String]
        $HeaderFilePath,

        [Parameter()]
        [System.String]
        [ValidateSet('HTML', 'JSON')]
        $Type = 'HTML',

        [Parameter()]
        [System.String[]]
        $ExcludedProperties,

        [Parameter()]
        [System.String[]]
        $ExcludedResources,

        [Parameter()]
        [System.Boolean]
        $DriftOnly = $true,

        [Parameter()]
        [System.Boolean]
        $KeepExport = $false,

        [Parameter()]
        [Switch]
        $UseVariableSubstitution,

        [Parameter()]
        [System.String]
        $SourceConfigurationDataPath,

        [Parameter()]
        [System.String]
        $DestinationConfigurationDataPath,

        [Parameter()]
        [System.String[]]
        $ExcludedSubstitutionProperties,

        [Parameter()]
        [Switch]
        $Parallel
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[System.String], [System.Object]]]::new()
    $data.Add('Event', 'AssertBlueprint')
    $data.Add('BluePrint', $BluePrintUrl)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $TempBluePrintName = 'TempBlueprint_' + (New-Guid).ToString() + '.M365'
    $LocalBluePrintPath = Join-Path -Path $env:TEMP -ChildPath $TempBluePrintName
    try
    {
        # Download the BluePrint locally in a temp location
        Invoke-WebRequest -Uri $BluePrintUrl -OutFile $LocalBluePrintPath -UseBasicParsing
    }
    catch
    {
        # If the download failed, we assume the provided Url was a local path
        # and we try copying the item instead.
        try
        {
            Copy-Item -Path $BluePrintUrl -Destination $LocalBluePrintPath
        }
        catch
        {
            throw $_
        }
    }

    if (Test-Path -Path $LocalBluePrintPath)
    {
        # Parse the content of the BluePrint into an array of PowerShell Objects
        $fileContent = Get-Content $LocalBluePrintPath -Raw
        $startPosition = $fileContent.IndexOf(' -ModuleVersion')
        if ($startPosition -gt 0)
        {
            $endPosition = $fileContent.IndexOf("`r", $startPosition)
            $fileContent = $fileContent.Remove($startPosition, $endPosition - $startPosition)
        }

        try
        {
            $parsedBluePrint = ConvertTo-DSCObject -Content $fileContent
        }
        catch
        {
            throw $_
        }

        # Generate an Array of Resource Types contained in the BluePrint
        $ResourcesInBluePrint = @()
        foreach ($resource in $parsedBluePrint)
        {
            if ($resource.ResourceName -in $ExcludedResources)
            {
                continue
            }
            if ($ResourcesInBluePrint -notcontains $resource.ResourceName)
            {
                $ResourcesInBluePrint += $resource.ResourceName
            }
        }

        if ([String]::IsNullOrEmpty($ResourcesInBluePrint))
        {
            if (![String]::IsNullOrEmpty($ExcludedResources))
            {
                Write-Host 'All resources were excluded from BluePrint, aborting'
            }
            else
            {
                Write-Host 'Malformed BluePrint, aborting'
            }
            break
        }

        Write-Host "Selected BluePrint contains ($($ResourcesInBluePrint.Length)) components to assess."

        # Call the Export-M365DSCConfiguration cmdlet to extract only the resource
        # types contained within the BluePrint;
        Write-Host "Initiating the Export of those ($($ResourcesInBluePrint.Length)) components from the tenant..."
        $TempExportName = 'TempExport_' + (New-Guid).ToString() + '.ps1'
        Export-M365DSCConfiguration -Components $ResourcesInBluePrint `
            -Path $env:TEMP `
            -FileName $TempExportName `
            -Parallel:$Parallel.IsPresent `
            -Credential $Credentials `
            -ApplicationId $ApplicationId `
            -ApplicationSecret $ApplicationSecret `
            -TenantId $TenantId `
            -CertificateThumbprint $CertificateThumbprint `
            -CertificatePath $CertificatePath `
            -CertificatePassword $CertificatePassword `
            -ManagedIdentity:$ManagedIdentity.IsPresent `
            -AccessTokens $AccessTokens

        # Call the New-M365DSCDeltaReport configuration to generate the Delta Report between
        # the BluePrint and the extracted resources;
        $ExportPath = Join-Path -Path $env:TEMP -ChildPath $TempExportName
        $deltaReportParams = @{
            Source                = $ExportPath
            Destination           = $LocalBluePrintPath
            OutputPath            = $OutputReportPath
            DriftOnly             = $DriftOnly
            IsBlueprintAssessment = $true
            HeaderFilePath        = $HeaderFilePath
            Type                  = $Type
            ExcludedProperties    = $ExcludedProperties
            ExcludedResources     = $ExcludedResources
        }

        if ($UseVariableSubstitution)
        {
            $deltaReportParams.UseVariableSubstitution = $true
            if (-not [System.String]::IsNullOrEmpty($SourceConfigurationDataPath))
            {
                $deltaReportParams.SourceConfigurationDataPath = $SourceConfigurationDataPath
            }
            if (-not [System.String]::IsNullOrEmpty($DestinationConfigurationDataPath))
            {
                $deltaReportParams.DestinationConfigurationDataPath = $DestinationConfigurationDataPath
            }
            if ($null -ne $ExcludedSubstitutionProperties -and $ExcludedSubstitutionProperties.Count -gt 0)
            {
                $deltaReportParams.ExcludedSubstitutionProperties = $ExcludedSubstitutionProperties
            }
        }

        New-M365DSCDeltaReport @deltaReportParams

        # Clean up the temporary files
        Remove-Item $LocalBluePrintPath -Force -ErrorAction SilentlyContinue
        if (!$KeepExport)
        {
            Remove-Item $ExportPath -Force -ErrorAction SilentlyContinue
        }
    }
    else
    {
        Write-Error "M365DSC Template Path {$LocalBluePrintPath} does not exist."
    }
}

<#
.SYNOPSIS
    Returns all Microsoft365DSC resource names in the module.

.DESCRIPTION
    Enumerates resource module files and returns resource names without MSFT_ prefix.

.FUNCTIONALITY
    Public

.OUTPUTS
    System.String[]
#>
function Get-M365DSCAllResources
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    [CmdletBinding()]
    param ()

    if ($null -eq $Script:allResourcesPath)
    {
        $Script:allResourcesPath = Get-M365DSCAllResourcesPath
    }

    return $Script:allResourcesPath.Name -replace 'MSFT_', '' -replace '.psm1', ''
}

<#
.SYNOPSIS
    Returns the Microsoft365DSC DSC resource module files from the DscResources folder.

.DESCRIPTION
    Enumerates the Microsoft365DSC DscResources directory and returns the PowerShell module files for all DSC resources.

.FUNCTIONALITY
    Internal

.OUTPUTS
    System.IO.FileInfo[]

.NOTES
    This helper is used by Get-M365DSCAllResources to discover available resources.
#>
function Get-M365DSCAllResourcesPath
{
    [CmdletBinding()]
    [OutputType([System.IO.FileInfo[]])]
    [CmdletBinding()]
    param ()

    $Script:allResourcesPath = Get-ChildItem -Path ($PSScriptRoot + '/../DscResources/') -Recurse -Filter '*.psm1' -File

    return $Script:allResourcesPath
}

<#
.SYNOPSIS
    Compares resources between two installed Microsoft365DSC versions.

.DESCRIPTION
    Resolves two installed module versions and returns added and removed resource names by comparing their DscResources folders.

.PARAMETER PreviousVersion
    Specifies the older Microsoft365DSC version to compare.

.PARAMETER CurrentVersion
    Specifies the newer Microsoft365DSC version to compare. When omitted, the latest installed version is used.

.EXAMPLE
    PS> Get-M365DSCNewResources -PreviousVersion '1.24.501.1' -CurrentVersion '1.24.515.1'

.EXAMPLE
    PS> Get-M365DSCNewResources -PreviousVersion '1.24.501.1'

.OUTPUTS
    A hashtable with two keys: 'Added' and 'Removed'. Each key contains an array of resource names that were added or removed in the current version compared to the previous version.

.FUNCTIONALITY
    Public
#>
function Get-M365DSCResourceDifferences
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $PreviousVersion,

        [Parameter()]
        [System.String]
        $CurrentVersion
    )

    [Array]$installedModules = Get-Module 'Microsoft365DSC' -ListAvailable | Sort-Object -Property Version -Descending

    if ($installedModules.Count -eq 0)
    {
        Write-Error -Message 'No installed versions of Microsoft365DSC were found.'
        return ,@()
    }

    # Resolve current version
    if ([System.String]::IsNullOrEmpty($CurrentVersion))
    {
        $currentModule = $installedModules[0]
    }
    else
    {
        $currentModule = $installedModules | Where-Object -Property Version -EQ $CurrentVersion
    }

    if ($null -eq $currentModule)
    {
        throw "Microsoft365DSC version '$CurrentVersion' is not installed."
    }

    # Resolve previous version
    $previousModule = $installedModules | Where-Object -Property Version -EQ $PreviousVersion
    if ($null -eq $previousModule)
    {
        throw "Microsoft365DSC version '$PreviousVersion' is not installed."
    }

    # Get resources from each version by scanning their DscResources folders
    $currentResourcesPath = Join-Path -Path $currentModule.ModuleBase -ChildPath 'DscResources'
    $previousResourcesPath = Join-Path -Path $previousModule.ModuleBase -ChildPath 'DscResources'

    $currentResources = Get-ChildItem -Path $currentResourcesPath -Recurse -Filter '*.psm1' -File |
        ForEach-Object { $_.Name -replace 'MSFT_', '' -replace '\.psm1', '' }

    $previousResources = Get-ChildItem -Path $previousResourcesPath -Recurse -Filter '*.psm1' -File |
        ForEach-Object { $_.Name -replace 'MSFT_', '' -replace '\.psm1', '' }

    # Return resources present in current but not in previous
    $newResources = $currentResources | Where-Object -FilterScript { $_ -notin $previousResources } | Sort-Object
    $removedResources = $previousResources | Where-Object -FilterScript { $_ -notin $currentResources } | Sort-Object
    return @{
        Added = $newResources
        Removed = $removedResources
    }
}

<#
.Description
This function checks if the specified object has the specified property

.Functionality
Internal, Hidden
#>
function Test-M365DSCObjectHasProperty
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true, Position = 1)]
        [Object]
        $Object,

        [Parameter(Mandatory = $true, Position = 2)]
        [String]
        $PropertyName
    )

    if (([bool]($Object.PSobject.Properties.Name -contains $PropertyName)) -eq $true)
    {
        if ($null -ne $Object.$PropertyName)
        {
            return $true
        }
    }
    return $false
}

<#
.SYNOPSIS
    Derives workload names from resource names.

.DESCRIPTION
    Maps resource name prefixes to known workload identifiers and returns distinct workload values.

.PARAMETER ResourceName
    Specifies resource names to map to workloads.

.EXAMPLE
    PS> Get-M365DSCWorkloadForResource -ResourceName AADUser

.EXAMPLE
    PS> Get-M365DSCWorkloadForResource -ResourceName @('AADUser', 'AADGroup')

.FUNCTIONALITY
    Internal

.OUTPUTS
    System.String[]
#>
function Get-M365DSCWorkloadForResource
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    param
    (
        [Parameter(Mandatory = $true, Position = 1)]
        [System.String[]]
        $ResourceName
    )

    $workloads = @()
    foreach ($resource in $ResourceName)
    {
        foreach ($workload in $Script:M365DSCWorkloads)
        {
            if ($resource -like "$($workload)*")
            {
                if ($workloads -notcontains $workload)
                {
                    $workloads += $workload
                    break
                }
            }
        }
    }

    return $workloads | Sort-Object
}

<#
.SYNOPSIS
    Generates Markdown documentation for public Microsoft365DSC cmdlets.

.DESCRIPTION
    Reads module help and command metadata, then creates per-cmdlet Markdown files in the docs cmdlets folder.

.FUNCTIONALITY
    Internal
#>
function New-M365DSCCmdletDocumentation
{
    param()

    $cmdletDocsRoot = Join-Path -Path $PSScriptRoot -ChildPath '../../../docs/docs/user-guide/cmdlets'

    if ((Test-Path -Path $cmdletDocsRoot) -eq $false)
    {
        $null = New-Item -Path $cmdletDocsRoot -ItemType Directory
    }

    $filesInFolder = Get-ChildItem -Path $cmdletDocsRoot
    if ($filesInFolder.Count -ne 0)
    {
        Remove-Item -Path $filesInFolder.FullName -Confirm:$false
    }

    Write-Host -Object ' '
    Write-Host -Object 'Creating Markdown documentation for M365DSC cmdlets:' -ForegroundColor Gray

    $counter = 0
    foreach ($command in (Get-Module Microsoft365DSC).ExportedCommands.GetEnumerator())
    {
        $commandName = $command.Key
        $helpInfo = Get-Help $commandName
        $functionality = $helpInfo.Functionality -split ', '
        if ('Public' -in $functionality)
        {
            Write-Host -Object "  * $commandName " -ForegroundColor Gray -NoNewline

            $output = New-Object -TypeName System.Text.StringBuilder

            $null = $output.AppendLine("# $($commandName)")
            $null = $output.AppendLine()

            $helpInfo = Get-Help -Name $commandName
            if ($helpInfo.description.Count -ne 0)
            {
                $null = $output.AppendLine('## Description')
                $null = $output.AppendLine()
                $null = $output.AppendLine($helpInfo.Description[0].Text)
                $null = $output.AppendLine()
            }

            $cmd = Get-Command -Name $commandName
            if ([String]::IsNullOrEmpty($cmd.OutputType) -eq $false)
            {
                $null = $output.AppendLine('## Output')
                $null = $output.AppendLine()
                $null = $output.AppendLine('This function outputs information as the following type:')
                $null = $output.AppendLine("**$($cmd.OutputType)**")
                $null = $output.AppendLine()
            }
            else
            {
                $null = $output.AppendLine('## Output')
                $null = $output.AppendLine()
                $null = $output.AppendLine('This function does not generate any output.')
                $null = $output.AppendLine()
            }

            $ast = $cmd.ScriptBlock.Ast
            $parameters = $null
            $parameters = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.ParameterAst] }, $true)

            $null = $output.AppendLine('## Parameters')
            $null = $output.AppendLine()
            if ($parameters.Count -gt 0)
            {
                $null = $output.AppendLine('| Parameter | Required | DataType | Default Value | Allowed Values | Description |')
                $null = $output.AppendLine('| --- | --- | --- | --- | --- | --- |')

                $ast = $cmd.ScriptBlock.Ast
                $parameters = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.ParameterAst] }, $true)
                foreach ($parameter in $parameters)
                {
                    $paramName = $parameter.Name.VariablePath.UserPath

                    $paramHelp = $helpInfo.parameters.parameter | Where-Object -Property Name -EQ $paramName
                    $description = ''
                    if ($paramHelp.description.Count -gt 0)
                    {
                        $description = $paramHelp.description[0].Text
                    }
                    $mandatory = $parameter.Attributes.Where({ $_.TypeName.FullName -eq 'Parameter' }).NamedArguments.Where({ $_.ArgumentName -eq 'Mandatory' }).Argument.VariablePath.UserPath
                    if ($null -eq $mandatory)
                    {
                        $mandatory = 'False'
                    }
                    $mandatory = (Get-Culture).TextInfo.ToTitleCase($mandatory.ToLower())

                    $defaultValue = " $($parameter.DefaultValue.Value) "
                    if ($defaultValue -eq '  ')
                    {
                        $defaultValue = ' '
                    }
                    $validateSetValue = " $($parameter.Attributes.Where({$_.TypeName.FullName -eq 'ValidateSet'}).PositionalArguments.Value -join ', ') "
                    if ($validateSetValue -eq '  ')
                    {
                        $validateSetValue = ' '
                    }
                    $description = " $($description.Split("`n") -join ' ') "
                    if ($description -eq '  ')
                    {
                        $description = ' '
                    }
                    $null = $output.AppendLine("| $($paramName) | $($mandatory) | $($parameter.StaticType.Name) |$defaultValue|$validateSetValue|$description|")
                }
                $null = $output.AppendLine()
            }
            else
            {
                $null = $output.AppendLine('This function does not have any input parameters.')
                $null = $output.AppendLine()
            }

            if ($helpInfo.examples.example.Count -ne 0)
            {
                $null = $output.AppendLine('## Examples')
                $null = $output.AppendLine()
                foreach ($example in $helpInfo.examples.example)
                {
                    $null = $output.AppendLine($example.title)
                    $null = $output.AppendLine()
                    $null = $output.AppendLine("``$($example.code)``")
                    $null = $output.AppendLine()
                }
            }

            $savePath = Join-Path -Path $cmdletDocsRoot -ChildPath "$commandName.md"
            $null = Out-File `
                -InputObject ($output.ToString() -replace '\r?\n', "`r`n").TrimEnd("`r`n") `
                -FilePath $savePath `
                -Encoding utf8 `
                -Force:$Force
            Write-Host -Object $Global:M365DSCEmojiGreenCheckmark -ForegroundColor Gray
            $counter++
        }
    }

    Write-Host -Object ' '
    Write-Host -Object "Total number files created: $counter" -ForegroundColor Gray
    Write-Host -Object ' '
}

<#
.Description
This function creates an example from the resource schema, using ReverseDSC code.

.Parameter ResourceName
Specifies the resource name for which the example should be generated.

.Functionality
Internal, Hidden
#>
function New-M365DSCResourceExample
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName
    )

    $resource = Get-DscResourceV2 -Name $ResourceName
    $params = Get-DSCFakeParameters -ModulePath $resource.Path
    $params.Credential = '$Credscredential'

    if ($params.ContainsKey('ApplicationId'))
    {
        $params.Remove('ApplicationId')
    }

    if ($params.ContainsKey('TenantId'))
    {
        $params.Remove('TenantId')
    }

    if ($params.ContainsKey('ApplicationSecret'))
    {
        $params.Remove('ApplicationSecret')
    }

    if ($params.ContainsKey('CertificateThumbprint'))
    {
        $params.Remove('CertificateThumbprint')
    }

    if ($params.ContainsKey('CertificatePath'))
    {
        $params.Remove('CertificatePath')
    }

    if ($params.ContainsKey('CertificatePassword'))
    {
        $params.Remove('CertificatePassword')
    }

    [string]$userName = 'admin@contoso.onmicrosoft.com'
    [string]$userPassword = 'dummypassword'
    [securestring]$secStringPassword = ConvertTo-SecureString $userPassword -AsPlainText -Force
    [pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($userName, $secStringPassword)

    $resourceExample = Get-M365DSCExportContentForResource -ResourceName $ResourceName -ModulePath $resource.Path -Results $params -ConnectionMode Credentials -Credential $credObject

    $resourceExample = $resourceExample.TrimEnd() -replace ';', ''

    $exampleText = @"
<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = `$true)]
        [PSCredential]
        `$Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
$resourceExample
    }
}
"@

    return $exampleText
}

<#
.SYNOPSIS
    Creates missing resource examples and removes stale example folders.

.DESCRIPTION
    Compares available resources and existing example folders, generates missing examples, and removes examples for resources that no longer exist.

.FUNCTIONALITY
    Internal
#>
function New-M365DSCMissingResourcesExample
{
    $location = $PSScriptRoot

    $m365Resources = Get-DscResourceV2 -Module 'Microsoft365DSC' | Select-Object -ExpandProperty Name
    $examplesPath = Join-Path $location -ChildPath '../../../Examples/Resources'
    $examples = Get-ChildItem -Path $examplesPath | Where-Object -Property PsIsContainer -EQ $true | Select-Object -ExpandProperty Name

    [array]$differences = Compare-Object -ReferenceObject $m365Resources -DifferenceObject $examples

    $count = 1
    $total = $differences.Count

    foreach ($difference in $differences)
    {
        Write-Host "[$count/$total] Processing $($difference.InputObject)"
        $path = Join-Path -Path './Examples/Resources' -ChildPath $difference.InputObject
        switch ($difference.SideIndicator)
        {
            '<='
            {
                Write-Host '  - Example missing, generating!'
                $null = New-Item -Path $path -ItemType Directory
                $exampleFile = Join-Path -Path $path -ChildPath '1-Configure.ps1'
                Set-Content -Path $exampleFile -Value (New-M365DSCResourceExample -ResourceName $difference.InputObject)
            }
            '=>'
            {
                Write-Host '  - No resource for existing example, removing!'
                Remove-Item -Path $path -Force -Confirm:$false
            }
        }
        $count++
    }
}

<#
.SYNOPSIS
    Removes authentication parameters from a bound parameter hashtable.

.DESCRIPTION
    Removes common authentication and runtime keys from a hashtable before comparison or serialization.

.PARAMETER BoundParameters
    Specifies the hashtable to sanitize.

.FUNCTIONALITY
    Internal

.OUTPUTS
    System.Collections.Hashtable
#>
function Remove-M365DSCAuthenticationParameter
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $BoundParameters
    )

    $keysToRemove = @(
        'Ensure',
        'Credential',
        'ApplicationId',
        'ApplicationSecret',
        'TenantId',
        'CertificatePassword',
        'CertificatePath',
        'CertificateThumbprint',
        'ManagedIdentity',
        'Verbose',
        'AccessTokens'
    )

    foreach ($key in $keysToRemove)
    {
        if ($BoundParameters.ContainsKey($key))
        {
            $BoundParameters.Remove($key) | Out-Null
        }
    }

    return $BoundParameters
}

<#
.SYNOPSIS
    Masks sensitive authentication values in a hashtable.

.DESCRIPTION
    Replaces sensitive authentication-related property values with placeholder text for safe logging and reporting.

.PARAMETER BoundParameters
    Specifies the hashtable whose sensitive values should be masked.

.FUNCTIONALITY
    Internal

.OUTPUTS
    System.Collections.Hashtable
#>
function Set-M365DSCAuthenticationParameterMask
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $BoundParameters
    )

    $keysToReplace = @(
        'ApplicationSecret',
        'Credential',
        'CertificatePassword',
        'CertificatePath',
        'CertificateThumbprint',
        'Password'
    )

    foreach ($key in $keysToReplace)
    {
        if ($BoundParameters.ContainsKey($key))
        {
            $BoundParameters[$key] = '***'
        }
    }

    return $BoundParameters
}

<#
.SYNOPSIS
    Detects duplicate primary-key resource instances in configuration content.

.DESCRIPTION
    Parses configuration content, computes each resource primary identity, and returns conflicts where duplicate primary keys are found.

.PARAMETER ConfigurationContent
    Specifies DSC configuration content to analyze.

.EXAMPLE
    PS> Get-M365DSCConfigurationConflict -ConfigurationContent "content"

.FUNCTIONALITY
    Public

.OUTPUTS
    Array
#>
function Get-M365DSCConfigurationConflict
{
    [CmdletBinding()]
    [OutputType([Array])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ConfigurationContent
    )

    $results = @()
    Write-Verbose -Message "Converting configuration's content into a PowerShell Object using DSCParser"
    $parsedContent = ConvertTo-DSCObject -Content $ConfigurationContent

    $resourcesPrimaryIdentities = @()
    $resourcesInModule = Get-DscResourceV2 -Module 'Microsoft365DSC'
    foreach ($component in $parsedContent)
    {
        $resourceDefinition = $resourcesInModule | Where-Object -Property Name -EQ $component.ResourceName
        [Array]$mandatoryProperties = $resourceDefinition.Properties | Where-Object -Property IsMandatory -EQ $true
        $primaryKeyValues = ''
        foreach ($mandatoryKey in $mandatoryProperties.Name)
        {
            $primaryKeyValues += "$($component.$mandatoryKey)|"
        }
        $entryValue = "[$($component.ResourceName)]$primaryKeyValues"
        if ($resourcesPrimaryIdentities.Contains($entryValue))
        {
            Write-Verbose -Message "Found primary key conflict in resource {$($component.ResourceInstanceName)}"
            $currentEntry = @{
                ResourceName         = $component.ResourceName
                InstanceName         = $component.ResourceInstanceName
                AdditionalProperties = @{}
                Reason               = 'DuplicatePrimaryKey'
            }

            foreach ($mandatoryKey in $mandatoryProperties.Name)
            {
                $currentEntry.AdditionalProperties.Add($mandatoryKey, $component.$mandatoryKey)
            }
            $results += $currentEntry
        }
        else
        {
            $resourcesPrimaryIdentities += $entryValue
        }
    }
    return $results
}

<#
.SYNOPSIS
    Invokes a DSC resource function in a PowerShell 7 session.

.DESCRIPTION
    Ensures a PowerShell Core remoting session exists, imports the target resource module, and invokes the selected resource function with provided parameters.

.PARAMETER Path
    Specifies the resource module path to import in the Core session.

.PARAMETER FunctionName
    Specifies the target resource function to invoke.

.PARAMETER Parameters
    Specifies parameters passed to the invoked function.

.EXAMPLE
    Invoke-PowerShellCoreResource -Path 'C:\Program Files\...\DscResources\MSFT_Resource\MSFT_Resource.psm1' -FunctionName Test-TargetResource -Parameters @{ Name = 'Value' }

.EXAMPLE
    # From inside of a DSC resource
    Invoke-PowerShellCoreResource -Path $PSCommandPath -FunctionName $MyInvocation.MyCommand.Name -Parameters $PSBoundParameters

.FUNCTIONALITY
    Internal

.OUTPUTS
    Result of the invoked function.
#>
function Invoke-PowerShellCoreResource
{
    [CmdletBinding()]
    [OutputType([System.Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Path', Justification = 'Using statement not detected')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'FunctionName', Justification = 'Using statement not detected')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Parameters', Justification = 'Using statement not detected')]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]$Path,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Get-TargetResource', 'Set-TargetResource', 'Test-TargetResource', 'Export-TargetResource')]
        [System.String]$FunctionName,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]$Parameters
    )

    if (-not $script:PSCoreSessionInitialized)
    {
        Initialize-PowerShellCoreSession
    }

    $output = Invoke-Command -Session $PSCoreSession -ScriptBlock {
        Import-Module -Name $using:Path
        & $using:FunctionName @using:Parameters
    }

    return $output
}

<#
.DESCRIPTION
    Initializes a PowerShell Core session for use with Invoke-PowerShellCoreResource.

.FUNCTIONALITY
    Private

.EXAMPLE
    Initialize-PowerShellCoreSession
#>
function Initialize-PowerShellCoreSession
{
    [CmdletBinding()]
    param ()

    $script:PSCoreSession = New-PSSession -ComputerName localhost -ConfigurationName PowerShell.7 -EnableNetworkAccess
    $lcmConfig = Get-DscLocalConfigurationManager
    Invoke-Command -Session $script:PSCoreSession -ScriptBlock {
        Import-Module -Name Microsoft365DSC -Alias @() -Cmdlet @() -Variable @() -DisableNameChecking -SkipEditionCheck
        Set-M365DSCLCMConfiguration -LCMConfig $using:lcmConfig
    }
    $script:PSCoreSessionInitialized = $true
}

<#
.SYNOPSIS
    Clears deferred host message cache entries.

.DESCRIPTION
    Resets the in-memory message cache used by Write-M365DSCHost deferred writes.

.FUNCTIONALITY
    Internal
#>
function Clear-M365DSCHostMessageCache
{
    $Script:M365DSCHostMessages = @()
}

<#
.SYNOPSIS
    Writes Microsoft365DSC host output with optional deferred batching.

.DESCRIPTION
    Writes messages to host output in interactive sessions and to verbose output in non-interactive sessions.
    Supports deferred message accumulation and explicit commit behavior.

.PARAMETER Message
    Specifies the message text to write.

.PARAMETER ForegroundColor
    Specifies the foreground color for interactive host output.

.PARAMETER DeferWrite
    Indicates that the message should be queued instead of written immediately.

.PARAMETER CommitWrite
    Indicates that queued deferred messages should be flushed before writing the current message.

.EXAMPLE
    PS> Write-M365DSCHost -Message "This is a message."

.FUNCTIONALITY
    Internal
#>
function Write-M365DSCHost
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param
    (
        [Parameter(Position = 0)]
        [System.String]
        $Message,

        [Parameter()]
        [ConsoleColor]
        $ForegroundColor = [System.Console]::ForegroundColor,

        [Parameter(ParameterSetName = 'DeferWrite')]
        [switch]
        $DeferWrite,

        [Parameter(ParameterSetName = 'CommitWrite')]
        [switch]
        $CommitWrite
    )

    if ([int]$ForegroundColor -eq -1)
    {
        $ForegroundColor = [System.ConsoleColor]::Gray
    }

    if (-not [System.String]::IsNullOrEmpty($Message))
    {
        if ($null -eq $Script:M365DSCHostMessages)
        {
            $Script:M365DSCHostMessages = @()
        }

        if ($DeferWrite)
        {
            $Script:M365DSCHostMessages += @{
                Message         = $Message
                ForegroundColor = $ForegroundColor
            }
            return
        }

        if ([Environment]::UserInteractive)
        {
            if ($CommitWrite -and $Script:M365DSCHostMessages.Count -gt 0)
            {
                for ($i = 0; $i -lt $Script:M365DSCHostMessages.Count - 1; $i++)
                {
                    Write-Host -Object $Script:M365DSCHostMessages[$i].Message -ForegroundColor $Script:M365DSCHostMessages[$i].ForegroundColor -NoNewline
                }
                Write-Host -Object $Script:M365DSCHostMessages[-1].Message -ForegroundColor $Script:M365DSCHostMessages[-1].ForegroundColor -NoNewline
                $Script:M365DSCHostMessages = @()
            }

            if (-not [System.String]::IsNullOrEmpty($Message))
            {
                Write-Host -Object $Message -ForegroundColor $ForegroundColor
            }
        }
        else
        {
            $outputMessage = ''
            if ($CommitWrite)
            {
                $outputMessage += $Script:M365DSCHostMessages.Message -join ''
                $Script:M365DSCHostMessages = @()
            }
            $finalMessage = $outputMessage + $Message
            if (-not [System.String]::IsNullOrEmpty($Message))
            {
                Write-Verbose -Message $finalMessage -Verbose
            }
        }
    }
}

<#
.SYNOPSIS
    Sends Microsoft Graph batch requests with throttling backoff handling.

.DESCRIPTION
    Splits requests into batch payloads, sends them to Graph, detects throttling responses, and retries with reduced batch size when needed.

.PARAMETER Requests
    An array of hashtables representing the requests to be sent in the batch.
    A request hashtable should contain the following keys:
    - id: A unique identifier for the request.
    - method: The HTTP method to use (e.g., GET, POST).
    - url: The API endpoint URL.

.PARAMETER AsList
    Indicates that results should be returned as a generic list.

.PARAMETER ThrottlingDelayInSeconds
    Specifies delay before retrying throttled batches.

.PARAMETER BatchRequestSize
    Specifies maximum number of sub-requests per batch call.

.EXAMPLE
    $requests = @(
        @{
            id = '1'
            method = 'GET'
            url = '/users'
        }
    )
    Invoke-M365DSCGraphBatchRequest -Requests $requests

.OUTPUTS
    System.Collections.Hashtable[]
#>
function Invoke-M365DSCGraphBatchRequest
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable[]])]
    param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [System.Collections.Hashtable[]]
        $Requests,

        [Parameter()]
        [switch]
        $AsList,

        [Parameter()]
        [System.Int32]
        $ThrottlingDelayInSeconds = 5,

        [Parameter()]
        [System.Int32]
        $BatchRequestSize = 20
    )

    $batchResponses = [System.Collections.Generic.List[System.Collections.Hashtable]]::new()
    $halfBatchSize = [Math]::Ceiling($BatchRequestSize / 2)
    :outer for ($i = 0; $i -lt $Requests.Count; $i += $BatchRequestSize)
    {
        $batchRequestSized = $Requests[$i..([Math]::Min($i + $BatchRequestSize - 1, $Requests.Count - 1))]

        $request = @{
            requests = $batchRequestSized
        }

        Write-Verbose -Message "Sending BATCH Request with $($request.requests.Count) sub-requests (starting at index $i)..."
        $apiResponse = Invoke-MgGraphRequest -Method POST `
            -Uri 'beta/$batch' `
            -Body ($request | ConvertTo-Json -Depth 10) `
            -ErrorAction SilentlyContinue

        :inner foreach ($response in $apiResponse.responses)
        {
            switch ($response.status)
            {
                200 {
                    if ($null -ne $response.body.'@odata.nextLink')
                    {
                        $value = [System.Collections.Generic.List[System.Object]]::new($response.body.value)
                        $nextLink = $response.body.'@odata.nextLink'
                        while ($nextLink)
                        {
                            Write-Verbose -Message "Fetching next page of results from $nextLink..."
                            $nextPageResponse = Invoke-MgGraphRequest -Method GET -Uri $nextLink -ErrorAction SilentlyContinue
                            $value.AddRange($nextPageResponse.value)
                            $nextLink = $nextPageResponse.'@odata.nextLink'
                        }
                        $response.body.value = $value.ToArray()
                    }
                }
                429 {
                    Write-Warning -Message "Throttling encountered, pausing and repeating request..."
                    Start-Sleep -Seconds $ThrottlingDelayInSeconds
                    $BatchRequestSize = [Math]::Max($halfBatchSize, [Math]::Floor($BatchRequestSize / 2))
                    $i = if ($i -ge $BatchRequestSize) { $i - $BatchRequestSize } else { 0 }
                    continue outer
                }
            }
        }

        $batchResponses.AddRange([System.Collections.Hashtable[]]$apiResponse.responses)
    }

    if ($AsList)
    {
        return $batchResponses
    }
    return $batchResponses.ToArray()
}

<#
.SYNOPSIS
    Returns comparison metadata for a resource.

.DESCRIPTION
    Loads and caches comparison metadata from ComparisonMetadata.json and returns metadata for the requested resource.

.PARAMETER ResourceName
    Specifies the resource name to retrieve metadata for.

.EXAMPLE
    PS> Get-M365DSCResourceComparisonMetadata -ResourceName 'AADRoleAssignmentScheduleRequest'

.FUNCTIONALITY
    Internal

.OUTPUTS
    System.Collections.Hashtable
#>
function Get-M365DSCResourceComparisonMetadata
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName
    )

    if ($null -eq $Script:M365DSCComparisonMetadata)
    {
        $metadataPath = Join-Path -Path $PSScriptRoot -ChildPath '../ComparisonMetadata.json'
        if (Test-Path -Path $metadataPath)
        {
            try
            {
                $metadataContent = [System.IO.File]::ReadAllText($metadataPath) | ConvertFrom-Json
                $Script:M365DSCComparisonMetadata = @{}
                foreach ($resource in $metadataContent.Resources.PSObject.Properties)
                {
                    $Script:M365DSCComparisonMetadata[$resource.Name] = @{
                        HasCustomComparison = $resource.Value.HasCustomComparison
                        Description         = $resource.Value.Description
                    }
                }
            }
            catch
            {
                Write-Warning -Message "Failed to load comparison metadata from $metadataPath : $_"
                $Script:M365DSCComparisonMetadata = @{}
            }
        }
        else
        {
            Write-Verbose -Message "Comparison metadata file not found at $metadataPath"
            $Script:M365DSCComparisonMetadata = @{}
        }
    }

    if ($Script:M365DSCComparisonMetadata.ContainsKey($ResourceName))
    {
        return $Script:M365DSCComparisonMetadata[$ResourceName]
    }

    return @{
        HasCustomComparison = $false
    }
}

<#
.SYNOPSIS
    Retrieves custom comparison parameters for a resource.

.DESCRIPTION
    Loads the resource module when needed, invokes Get-CompareParameters when available, and caches returned compare parameters.

.PARAMETER ResourceName
    Specifies the resource name to retrieve compare parameters for.

.EXAMPLE
    PS> Get-M365DSCResourceComparisonParameters -ResourceName 'AADRoleAssignmentScheduleRequest'

.FUNCTIONALITY
    Internal

.OUTPUTS
    System.Collections.Hashtable
#>
function Get-M365DSCResourceComparisonParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName
    )

    $compareParameters = @{}

    try
    {
        # Check if this resource has custom comparison logic
        $metadata = Get-M365DSCResourceComparisonMetadata -ResourceName $ResourceName

        if (-not $metadata.HasCustomComparison)
        {
            Write-Verbose -Message "Resource $ResourceName does not have custom comparison logic."
            return $compareParameters
        }

        # Import the resource module if not already loaded
        $moduleName = "MSFT_$ResourceName"
        $module = Get-Module -Name $moduleName
        $moduleConfig = Get-M365DSCModuleConfiguration

        if ($null -eq $module)
        {
            $resourceModulePath = Join-Path -Path $PSScriptRoot -ChildPath "../DscResources/$moduleName/$moduleName.psm1"
            if (Test-Path -Path $resourceModulePath)
            {
                $previousValue = $moduleConfig.skipModuleDependencyValidation
                if (-not $metadata.RequiresModuleCheck)
                {
                    Set-M365DSCModuleConfiguration -Key 'skipModuleDependencyValidation' -Value $true
                }
                Import-Module -Name $resourceModulePath -Force -Global -Function Get-CompareParameters -Alias @() -Cmdlet @() -Variable @() -DisableNameChecking
                Set-M365DSCModuleConfiguration -Key 'skipModuleDependencyValidation' -Value $previousValue
                Write-Verbose -Message "Imported module $moduleName from $resourceModulePath"
            }
            else
            {
                Write-Warning -Message "Resource module not found at $resourceModulePath"
                return $compareParameters
            }
        }

        if ($null -eq $Script:CompareParametersCache)
        {
            $Script:CompareParametersCache = @{}
        }

        if ($Script:CompareParametersCache.ContainsKey($ResourceName))
        {
            return $Script:CompareParametersCache[$ResourceName]
        }

        # Check if the Get-CompareParameters function exists
        $getCompareParamsCommand = Get-Command -Name "$moduleName\Get-CompareParameters" -ErrorAction SilentlyContinue

        if ($null -eq $getCompareParamsCommand)
        {
            Write-Warning -Message "Resource $ResourceName is marked as having custom comparison, but Get-CompareParameters function not found."
            return $compareParameters
        }

        # Invoke the Get-CompareParameters function
        $compareParameters = & "$moduleName\Get-CompareParameters"

        # Cache the retrieved parameters
        $Script:CompareParametersCache[$ResourceName] = $compareParameters
    }
    catch
    {
        Write-Warning -Message "Failed to retrieve comparison parameters for $ResourceName : $_"
    }

    return $compareParameters
}

<#
.SYNOPSIS
    Resolves a group display name from its group id.

.DESCRIPTION
    Queries Microsoft Graph for a group by id and returns its display name.

.PARAMETER GroupId
    Specifies the group id to resolve.

.OUTPUTS
    System.String
#>
function Get-M365DSCGroupDisplayNameById
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupId
    )

    try
    {
        $group = Get-MgGroup -GroupId $GroupId -Property DisplayName -ErrorAction Stop
        return $group.DisplayName
    }
    catch
    {
        $message = "Could not find a group with id $($GroupId). Skipping group display name resolution for this id."
        New-M365DSCLogEntry -Message $message `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential
    }
}

<#
.SYNOPSIS
    Resolves a group id from its display name.

.DESCRIPTION
    Queries Microsoft Graph for a group by display name and returns its id.

.PARAMETER GroupDisplayName
    Specifies the group display name to resolve.

.OUTPUTS
    System.String
#>
function Get-M365DSCGroupIdByDisplayName
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupDisplayName
    )

    try
    {
        $group = Get-MgGroup -Filter "displayName eq '$GroupDisplayName'" -Property Id -ErrorAction Stop
        return $group.Id
    }
    catch
    {
        $message = "Could not find a group with display name $($GroupDisplayName). Skipping group ID resolution for this display name."
        New-M365DSCLogEntry -Message $message `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential
    }
}

<#
.SYNOPSIS
    Resolves a user principal name from user id.

.DESCRIPTION
    Queries Microsoft Graph for a user by id and returns UserPrincipalName.

.PARAMETER UserId
    Specifies the user id to resolve.

.OUTPUTS
    System.String
#>
function Get-M365DSCUserPrincipalNameById
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserId
    )

    try
    {
        $user = Get-MgUser -UserId $UserId -Property UserPrincipalName -ErrorAction Stop
        return $user.UserPrincipalName
    }
    catch
    {
        $message = "Could not find a user with id $($UserId). Skipping user principal name resolution for this id."
        New-M365DSCLogEntry -Message $message `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential
    }
}

<#
.SYNOPSIS
    Resolves a user id from user principal name.

.DESCRIPTION
    Queries Microsoft Graph for a user by principal name and returns the user id.

.PARAMETER UserPrincipalName
    Specifies the user principal name to resolve.

.OUTPUTS
    System.String
#>
function Get-M365DSCUserIdByPrincipalName
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserPrincipalName
    )

    try
    {
        $user = Get-MgUser -UserId $UserPrincipalName -Property Id -ErrorAction Stop
        return $user.Id
    }
    catch
    {
        $message = "Could not find a user with principal name $($UserPrincipalName). Skipping user ID resolution for this principal name."
        New-M365DSCLogEntry -Message $message `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential
    }
}

<#
.SYNOPSIS
    Rewrites authentication target identities to directory object ids.

.DESCRIPTION
    Updates target entries by resolving group display names and user principal names to their corresponding directory object ids.

.PARAMETER Targets
    Specifies authentication target objects to normalize.
#>
function Update-M365DSCAuthenticationTargets
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [AllowNull()]
        [System.Object[]]
        $Targets
    )

    if ($null -eq $targets)
    {
        return
    }

    foreach ($target in $targets)
    {
        if ($target.ContainsKey('Id') -and $target.ContainsKey('TargetType'))
        {
            if ($target.Id -eq '0000000-0000-0000-0000-000000000000' -or $target.Id -eq 'all_users' `
                -or $target.Id -match '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')
            {
                continue
            }

            if ($target.TargetType -eq 'Group')
            {
                $groupId = Get-M365DSCGroupIdByDisplayName -GroupDisplayName $($target.Id -replace "'", "''")
                if ($null -ne $groupId)
                {
                    $target.Id = $groupId
                }
            }
            elseif ($target.TargetType -eq 'User')
            {
                $userId = Get-M365DSCUserIdByPrincipalName -UserPrincipalName $($target.Id -replace "'", "''")
                if ($null -ne $userId)
                {
                    $target.Id = $userId
                }
            }
        }
    }
}

<#
.SYNOPSIS
    Sends a push notification using configured global endpoint settings.

.DESCRIPTION
    Sends a POST request to the configured push notification endpoint with optional global body and header overrides.

.PARAMETER Body
    Specifies the request body sent to the endpoint.

.EXAMPLE
    PS> Send-M365DSCPushNotification -Body "This is a test"

.FUNCTIONALITY
    Internal

.OUTPUTS
    $null
#>
function Send-M365DSCPushNotification
{
    [CmdletBinding()]
    [OutputType($null)]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Body
    )

    if (-not [System.String]::IsNullOrEmpty($Global:M365DSCPushNotificationsURI))
    {
        if (-not [System.String]::IsNullOrEmpty($Global:M365DSCPushNotificationsBody))
        {
            $Body = $Global:M365DSCPushNotificationsBody
        }
        $postRequest = @{
            Method      = "Post"
            URI         = $Global:M365DSCPushNotificationsURI
            Body        = $Body
            ErrorAction = "SilentlyContinue"
        }
        if (-not [System.String]::IsNullOrEmpty($Global:M365DSCPushNotificationsHeaders))
        {
            $postRequest.Add("Headers", $Global:M365DSCPushNotificationsHeaders)
        }
        $null = Invoke-RestMethod @postRequest
    }
}

Export-ModuleMember -Function @(
    'Assert-M365DSCBlueprint',
    'Clear-M365DSCHostMessageCache',
    'Confirm-ImportedCmdletIsAvailable',
    'Convert-M365DscHashtableToString',
    'Get-AllSPOPackages',
    'Get-M365DSCAllResources',
    'Get-M365DSCAllResourcesPath',
    'Get-M365DSCAllResourcesDictionary',
    'Get-M365DSCArrayFromProperty',
    'Get-M365DSCAuthenticationMode',
    'Get-M365DSCConfigurationConflict',
    'Get-M365DSCExportContentForResource',
    'Get-M365DSCGroupDisplayNameById',
    'Get-M365DSCGroupIdByDisplayName',
    'Get-M365DSCResourceDifferences',
    'Get-M365DSCResourceComparisonMetadata',
    'Get-M365DSCResourceComparisonParameters',
    'Get-M365DSCUserIdByPrincipalName',
    'Get-M365DSCUserPrincipalNameById',
    'Get-M365DSCWorkloadForResource',
    'Get-TeamByName',
    'Initialize-M365DSCAllResourcesDictionary',
    'Install-M365DSCDevBranch',
    'Invoke-M365DSCGraphBatchRequest',
    'Invoke-PowerShellCoreResource',
    'New-M365DSCCmdletDocumentation',
    'New-M365DSCMissingResourcesExample',
    'Remove-M365DSCAuthenticationParameter',
    'Remove-NullEntriesFromHashtable',
    'Set-M365DSCAuthenticationParameterMask',
    'Send-M365DSCPushNotification',
    'Set-M365DSCAllResourcesDictionary',
    'Test-CodePage',
    'Test-M365DSCParameterState',
    'Test-M365DSCTargetResource',
    'Update-M365DSCAuthenticationTargets',
    'Write-M365DSCHost'
)
