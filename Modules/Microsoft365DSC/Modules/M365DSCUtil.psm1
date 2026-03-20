#region Session Objects
$Global:SessionSecurityCompliance = $null
[hashtable]$Script:M365DSCTelemetryConnectionToGraphParams = @{}
#endregion

$Script:M365DSCWorkloads = @('AAD', 'ADO', 'AZURE', 'COMMERCE', 'DEFENDER', 'EXO', 'FABRIC', 'INTUNE', 'O365', 'OD', 'PLANNER', 'PP', 'SC', 'SENTINEL', 'SH', 'SPO', 'TEAMS')
$Script:M365DSCDependenciesValidated = $false
$Script:IsPowerShellCore = $PSVersionTable.PSEdition -eq 'Core'
$Script:IsPsResourceGetAvailable = $null -ne (Get-Module -Name Microsoft.PowerShell.PSResourceGet -ListAvailable)
$Script:M365DSCStringReplacementMap = @{}
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
    foreach ($file in (Get-ChildItem -Path "$PSScriptRoot/../DSCResources" -Filter 'settings.json' -Recurse))
    {
        Write-Verbose -Message "Processing settings.json file at path: $($file.FullName)"
        $jsonContent = [System.IO.File]::ReadAllText($file.FullName) | ConvertFrom-Json
        foreach ($commandMap in $jsonContent.commands)
        {
            $commandToModuleMap[$commandMap.module] += @($commandMap.cmdlets)
        }
        $directoryName = (Split-Path -Path $file.DirectoryName -Leaf).Replace('MSFT_', '')
        $Script:M365DSCResourceSettings.Add($directoryName, @{
            requiredModules = $jsonContent.requiredModules
            commands        = $jsonContent.commands
            mode            = $jsonContent.mode
        })
    }

    Write-Verbose -Message 'Loading current configuration from config.json'
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
    This function retrieves the resources available in the M365DSC project based on the specified export mode.

.FUNCTIONALITY
    Public

.PARAMETER Mode
    Specifies the mode of the export. Valid values are 'Default' and 'Full'.
    - 'Default' includes only configuration resources.
    - 'Full' includes all resources, both configuration and data.

.PARAMETER ExcludeConfigurationResources
    If specified, configuration resources will be excluded from the results. Works only for the 'Full' mode.

.EXAMPLE
    Get-M365DSCResourcesByExportMode -Mode 'Default'

    This command retrieves all resources that are available in the Default export mode.

.EXAMPLE
    Get-M365DSCResourcesByExportMode -Mode 'Full'

    This command retrieves all resources that are available in the Full export mode.

.OUTPUTS
    [System.String[]] - An array of resource names that match the specified export mode.
#>
function Get-M365DSCResourcesByExportMode
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Default', 'Full')]
        [System.String]
        $Mode,

        [Parameter(Mandatory = $false)]
        [switch]
        $ExcludeConfigurationResources
    )

    $resources = [System.Collections.Generic.List[System.String]]::new($Script:M365DSCResourceSettings.Keys.Count)
    foreach ($resource in $Script:M365DSCResourceSettings.Keys)
    {
        if ($Mode -eq 'Default' -and $Script:M365DSCResourceSettings[$resource].mode -eq 'Configuration')
        {
            $resources.Add($resource)
        }
        elseif ($Mode -eq 'Full')
        {
            if ($ExcludeConfigurationResources -and $Script:M365DSCResourceSettings[$resource].mode -eq 'Configuration')
            {
                continue
            }
            $resources.Add($resource)
        }
    }

    return $resources.ToArray()
}

<#
.Description
This function retrieves a Teams team by its name

.Functionality
Internal
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
            $team = Get-Team -DisplayName $TeamName | Where-Object -FilterScript { $_.DisplayName -eq [System.Net.WebUtility]::UrlDecode($TeamName) }
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
.Description
This function converts a parameter hashtable to a string, for outputting to screen

.Functionality
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

    $values = @()
    $parametersToObfuscate = @('ApplicationId', 'ApplicationSecret', 'TenantId', 'CertificateThumbprint', 'CertificatePath', 'CertificatePassword', 'Credential', 'Password')
    foreach ($pair in $Hashtable.GetEnumerator())
    {
        try
        {
            if ($pair.Value -is [System.Array])
            {
                $str = "$($pair.Key)=$(Convert-M365DSCArrayToString -Array $pair.Value)"
            }
            elseif ($pair.Value -is [System.Collections.Hashtable])
            {
                $str = "$($pair.Key)={$(Convert-M365DscHashtableToString -Hashtable $pair.Value)}"
            }
            elseif ($pair.Value -is [Microsoft.Management.Infrastructure.CimInstance])
            {
                $str = "$($pair.Key)=$(Convert-M365DSCCIMInstanceToString -CIMInstance $pair.Value)"
            }
            else
            {
                if ($null -eq $pair.Value)
                {
                    $str = "$($pair.Key)=`$null"
                }
                else
                {
                    if ($parametersToObfuscate.Contains($pair.Key))
                    {
                        $str = "$($pair.Key)=***"
                    }
                    else
                    {
                        $str = "$($pair.Key)=$($pair.Value)"
                    }
                }
            }
            $values += $str
        }
        catch
        {
            Write-Warning "There was an error converting the Hashtable to a string: $_"
        }
    }

    [array]::Sort($values)
    return ($values -join [Environment]::NewLine)
}

<#
.Description
This function converts a parameter array to a string, for outputting to screen

.Functionality
Internal
#>
function Convert-M365DscArrayToString
{
    param
    (
        [Parameter()]
        [System.Array]
        $Array
    )

    $str = '('
    for ($i = 0; $i -lt $Array.Count; $i++)
    {
        $item = $Array[$i]
        if ($item -is [System.Collections.Hashtable])
        {
            $str += '{'
            $str += Convert-M365DscHashtableToString -Hashtable $item
            $str += '}'
        }
        elseif ($Array[$i] -is [Microsoft.Management.Infrastructure.CimInstance])
        {
            $str += Convert-M365DSCCIMInstanceToString -CIMInstance $item
        }
        else
        {
            $str += $item
        }

        if ($i -lt ($Array.Count - 1))
        {
            $str += ','
        }
    }
    $str += ')'

    return $str
}

<#
.Description
This function converts a parameter CimInstance to a string, for outputting to screen

.Functionality
Internal
#>
function Convert-M365DscCIMInstanceToString
{
    param
    (
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CIMInstance
    )

    $str = '{'
    foreach ($prop in $CIMInstance.CimInstanceProperties)
    {
        if ($str -notmatch '{$')
        {
            $str += '; '
        }
        $str += "$($prop.Name)=$($prop.Value)"
    }
    $str += '}'

    return $str
}

<#
.Description
This function checks if the specified cmdlet is available or not

.Functionality
Internal
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
.Description
This function compares two arrays with PSCustomObject objects

.Functionality
Internal, Hidden
#>
function Compare-PSCustomObjectArrays
{
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [System.Object[]]
        $DesiredValues,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [System.Object[]]
        $CurrentValues
    )
    $DriftedProperties = @()
    foreach ($DesiredEntry in $DesiredValues)
    {
        $Properties = $DesiredEntry.PSObject.Properties
        $KeyProperty = $Properties.Name[0]

        $EquivalentEntryInCurrent = $CurrentValues | Where-Object -FilterScript { $_.$KeyProperty -eq $DesiredEntry.$KeyProperty }
        if ($null -eq $EquivalentEntryInCurrent)
        {
            $result = @{
                Property     = $DesiredEntry
                PropertyName = $KeyProperty
                Desired      = $DesiredEntry.$KeyProperty
                Current      = $null
            }
            $DriftedProperties += $result
        }
        else
        {
            foreach ($property in $Properties)
            {
                $propertyName = $property.Name

                if ((-not [System.String]::IsNullOrEmpty($DesiredEntry.$PropertyName) -and -not [System.String]::IsNullOrEmpty($EquivalentEntryInCurrent.$PropertyName)) -and `
                        $DesiredEntry.$PropertyName -ne $EquivalentEntryInCurrent.$PropertyName)
                {
                    $drift = $true
                    if ($DesiredEntry.$PropertyName.GetType().Name -eq 'String' -and $DesiredEntry.$PropertyName.Contains('$OrganizationName'))
                    {
                        if ($DesiredEntry.$PropertyName.Split('@')[0] -eq $EquivalentEntryInCurrent.$PropertyName.Split('@')[0])
                        {
                            $drift = $false
                        }
                    }
                    if ($drift)
                    {
                        $result = @{
                            Property     = $DesiredEntry
                            PropertyName = $PropertyName
                            Desired      = $DesiredEntry.$PropertyName
                            Current      = $EquivalentEntryInCurrent.$PropertyName
                        }
                        $DriftedProperties += $result
                    }
                }
            }
        }
    }

    foreach ($currentEntry in $currentValues)
    {
        if ($currentEntry.GetType().Name -eq 'PSCustomObject')
        {
            $fixedEntry = @{}
            $currentEntry.psobject.properties | ForEach-Object { $fixedEntry[$_.Name] = $_.Value }
        }
        else
        {
            $fixedEntry = $currentEntry
        }
        $KeyProperty = Get-M365DSCCIMInstanceKey -CIMInstance $fixedEntry

        $EquivalentEntryInDesired = $DesiredValues | Where-Object -FilterScript { $_.$KeyProperty -eq $fixedEntry.$KeyProperty }
        if ($null -eq $EquivalentEntryInDesired)
        {
            $result = @{
                Property     = $fixedEntry
                PropertyName = $KeyProperty
                Desired      = $fixedEntry.$KeyProperty
                Current      = $null
            }
            $DriftedProperties += $result
        }
        else
        {
            foreach ($property in $Properties)
            {
                $propertyName = $property.Name

                if ((-not [System.String]::IsNullOrEmpty($fixedEntry.$PropertyName) -and -not [System.String]::IsNullOrEmpty($EquivalentEntryInDesired.$PropertyName)) -and `
                        $fixedEntry.$PropertyName -ne $EquivalentEntryInDesired.$PropertyName)
                {
                    $drift = $true
                    if ($fixedEntry.$PropertyName.GetType().Name -eq 'String' -and $fixedEntry.$PropertyName.Contains('$OrganizationName'))
                    {
                        if ($fixedEntry.$PropertyName.Split('@')[0] -eq $EquivalentEntryInDesired.$PropertyName.Split('@')[0])
                        {
                            $drift = $false
                        }
                    }
                    if ($drift)
                    {
                        $result = @{
                            Property     = $fixedEntry
                            PropertyName = $PropertyName
                            Desired      = $fixedEntry.$PropertyName
                            Current      = $EquivalentEntryInDesired.$PropertyName
                        }
                        $DriftedProperties += $result
                    }
                }
            }
        }
    }

    return $DriftedProperties
}


<#
.Description
This function retrieves the current tenant's name based on received authentication parameters.

.Functionality
Internal
#>
function Get-M365DSCTenantNameFromParameterSet
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true, Position = 1)]
        [System.Collections.HashTable]
        $ParameterSet
    )

    if ($ParameterSet.ContainsKey('TenantId'))
    {
        return $ParameterSet.TenantId
    }
    elseif ($ParameterSet.ContainsKey('Credential'))
    {
        try
        {
            $tenantName = $ParameterSet.Credential.Username.Split('@')[1]
            return $tenantName
        }
        catch
        {
            return $null
        }
    }
}

<#
.DESCRIPTION
    This function converts a property value to an array of specified element type.

.FUNCTIONALITY
    Internal
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
.Description
This function tests if the DSC hashtables have the same values

.Functionality
Public
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

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add('Resource', "$Source")
    $data.Add('Method', 'Test-TargetResource')
    #endregion
    $returnValue = $true

    $TenantName = Get-M365DSCTenantNameFromParameterSet -ParameterSet $DesiredValues

    #region Telemetry - Evaluation
    $dataEvaluation = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $dataEvaluation.Add('Resource', "$Source")
    $dataEvaluation.Add('Method', 'Test-TargetResource')
    $dataEvaluation.Add('Tenant', $TenantName)

    $ConnectionMode = Get-M365DSCAuthenticationMode $DesiredValues
    $dataEvaluation.Add('ConnectionMode', $ConnectionMode)
    $ValuesToCheckData = $ValuesToCheck | Where-Object -FilterScript { $_ -ne 'Verbose' }
    $dataEvaluation.Add('Parameters', $ValuesToCheckData -join "`r`n")
    $dataEvaluation.Add('ParametersCount', $ValuesToCheckData.Length)
    Add-M365DSCTelemetryEvent -Type 'DriftEvaluation' -Data $dataEvaluation
    #endregion

    $DriftedParameters = @{}
    $DriftObject = @{
        DriftInfo     = @{}
        CurrentValues = @{}
        DesiredValues = @{}
    }

    if ($null -ne $IncludedDrifts -and $IncludedDrifts.Keys.Count -gt 0)
    {
        $DriftedParameters = $IncludedDrifts
        foreach ($existingDrift in $IncludedDrifts)
        {
            $propertyName = $existingDrift.Keys[0]
            $value = $existingDrift."$propertyName"
            $start = $value.IndexOf('</CurrentValue>')
            $currentValue = $value.Substring(0, $start).Replace('<CurrentValue>', '')
            $desiredValue = $value.Substring($start + 15, ($value.Length) - ($start + 15)).Replace('<DesiredValue>', '').Replace('</DesiredValue>', '')
            $DriftObject.DriftInfo.Add($propertyName, @{
                PropertyName = $propertyName
                CurrentValue = $currentValue
                DesiredValue = $desiredValue
            })
        }
        $returnValue = $false
    }

    $desiredTypeName = $DesiredValues.GetType().Name
    if (($desiredTypeName -ne 'HashTable') `
            -and ($desiredTypeName -ne 'CimInstance') `
            -and ($desiredTypeName -ne 'PSBoundParametersDictionary'))
    {
        throw ("Property 'DesiredValues' in Test-M365DSCParameterState must be either a " + `
                "Hashtable or CimInstance. Type detected was $($desiredTypeName)")
    }

    if (($desiredTypeName -eq 'CimInstance') -and ($null -eq $ValuesToCheck))
    {
        throw ("If 'DesiredValues' is a CimInstance then property 'ValuesToCheck' must contain " + `
                'a value')
    }

    if (($null -eq $ValuesToCheck) -or ($ValuesToCheck.Count -lt 1))
    {
        $KeyList = $DesiredValues.Keys
    }
    else
    {
        $KeyList = $ValuesToCheck
    }

    # Add default Ensure value if it is not present in the DesiredValues but present in the CurrentValues
    if (-not $KeyList.Contains('Ensure') -and -not $KeyList.Contains('IsSingleInstance') -and $CurrentValues.ContainsKey('Ensure'))
    {
        $KeyList += 'Ensure'
        if (-not $DesiredValues.ContainsKey('Ensure'))
        {
            $DesiredValues.Add('Ensure', 'Present')
        }
    }

    $propertiesToExclude = @('Verbose', 'Credential', 'ApplicationId', 'CertificateThumbprint', 'CertificatePath', 'CertificatePassword', 'TenantId', 'ApplicationSecret', 'ManagedIdentity', 'AccessTokens')
    if ($null -ne $ExcludedProperties)
    {
        $propertiesToExclude += $ExcludedProperties
        $propertiesToExclude = $propertiesToExclude | Select-Object -Unique
    }
    $KeyList | ForEach-Object -Process {
        if ($_ -notin $propertiesToExclude)
        {
            if (-not $CurrentValues.ContainsKey($_) `
                    -or $CurrentValues.$_ -ne $DesiredValues.$_ `
                    -or ($DesiredValues.ContainsKey($_) -eq $true -and ($null -ne $DesiredValues.$_ -and $DesiredValues.$_.GetType().IsArray)))
            {
                if ($desiredTypeName -eq 'HashTable' -or `
                        $desiredTypeName -eq 'PSBoundParametersDictionary')
                {
                    $CheckDesiredValue = $DesiredValues.ContainsKey($_)
                }
                else
                {
                    $CheckDesiredValue = Test-M365DSCObjectHasProperty -Object $DesiredValues -PropertyName $_
                }

                if ($CheckDesiredValue)
                {
                    $desiredValue = $DesiredValues.$_
                    if ($null -eq $desiredValue)
                    {
                        $desiredType = $CurrentValues.$_.GetType()
                    }
                    else
                    {
                        $desiredType = $DesiredValues.$_.GetType()
                    }

                    $fieldName = $_
                    if ($desiredType.IsArray -eq $true)
                    {
                        if (($CurrentValues.ContainsKey($fieldName) -eq $false) `
                                -or ($null -eq $CurrentValues.$fieldName))
                        {
                            Write-Verbose -Message ('Expected to find an array value for ' + `
                                    "property $fieldName in the current " + `
                                    'values, but it was either not present or ' + `
                                    'was null. This has caused the test method ' + `
                                    'to return false.')
                            $DriftObject.DriftInfo.Add($fieldName, '')
                            $DriftedParameters.Add($fieldName, '')
                            $returnValue = $false
                        }
                        elseif ($desiredType.Name -eq 'ciminstance[]')
                        {
                            Write-Verbose "The current property {$_} is a CimInstance[]"
                            $AllDesiredValuesAsArray = @()
                            foreach ($item in $DesiredValues.$_)
                            {
                                $currentEntry = @{ }
                                foreach ($prop in $item.CIMInstanceProperties)
                                {
                                    $value = $prop.Value
                                    if ([System.String]::IsNullOrEmpty($value))
                                    {
                                        $value = $null
                                    }
                                    if (-not $currentEntry.ContainsKey($prop.Name))
                                    {
                                        $currentEntry.Add($prop.Name, $value)
                                    }
                                }
                                $AllDesiredValuesAsArray += [PSCustomObject]$currentEntry
                            }
                            try
                            {
                                $arrayCompare = $null
                                if ($CurrentValues.$fieldName.GetType().Name -ne 'CimInstance' -and `
                                        $CurrentValues.$fieldName.GetType().Name -ne 'CimInstance[]')
                                {
                                    $arrayCompare = Compare-PSCustomObjectArrays -CurrentValues $CurrentValues.$fieldName `
                                        -DesiredValues $AllDesiredValuesAsArray
                                }
                            }
                            catch
                            {
                                Write-Verbose -Message $_
                            }

                            if ($null -ne $arrayCompare)
                            {
                                foreach ($item in $arrayCompare)
                                {
                                    $EventValue = "<CurrentValue>[$($item.PropertyName)]$($item.CurrentValue)</CurrentValue>"
                                    $EventValue += "<DesiredValue>[$($item.PropertyName)]$($item.DesiredValue)</DesiredValue>"

                                    if (-not $DriftedParameters.ContainsKey($fieldName))
                                    {
                                        $DriftObject.DriftInfo.Add($fieldName, @{
                                            PropertyName = $item.PropertyName
                                            CurrentValue = $item.CurrentValue
                                            DesiredValue = $item.DesiredValue
                                        })
                                        $DriftedParameters.Add($fieldName, $EventValue)
                                    }
                                }
                                $returnValue = $false
                            }
                        }
                        else
                        {
                            $desiredValue = $DesiredValues.$fieldName
                            if ($null -eq $desiredValue)
                            {
                                $desiredValue = @()
                            }
                            $arrayCompare = Compare-Object -ReferenceObject $CurrentValues.$fieldName `
                                -DifferenceObject $desiredValue
                            if ($null -ne $arrayCompare -and
                                -not [System.String]::IsNullOrEmpty($arrayCompare.InputObject))
                            {
                                Write-Verbose -Message ("Found an array for property $fieldName " + `
                                        'in the current values, but this array ' + `
                                        'does not match the desired state. ' + `
                                        'Details of the changes are below.')
                                $arrayCompare | ForEach-Object -Process {
                                    Write-Verbose -Message "$($_.InputObject) - $($_.SideIndicator)"
                                }

                                $EventValue = "<CurrentValue>$($CurrentValues.$fieldName -join ', ')</CurrentValue>"
                                $EventValue += "<DesiredValue>$($DesiredValues.$fieldName -join ', ')</DesiredValue>"
                                $DriftObject.DriftInfo.Add($fieldName, @{
                                    CurrentValue = $CurrentValues.$fieldName -join ', '
                                    DesiredValue = $DesiredValues.$fieldName -join ', '
                                })
                                $DriftedParameters.Add($fieldName, $EventValue)
                                $returnValue = $false
                            }
                        }
                    }
                    else
                    {
                        switch ($desiredType.Name)
                        {
                            'String'
                            {
                                if (-not [string]::IsNullOrEmpty($CurrentValues.$fieldName))
                                {
                                    try
                                    {
                                        $CurrentValues.$fieldName = $CurrentValues.$fieldName.Replace("`r`n", "`n")
                                    }
                                    catch
                                    {
                                        Write-Warning -Message "Could not replace line breaks in current value of property $fieldName"
                                    }
                                }
                                if (-not [string]::IsNullOrEmpty($DesiredValues.$fieldName))
                                {
                                    try
                                    {
                                        $DesiredValues.$fieldName = $DesiredValues.$fieldName.Replace("`r`n", "`n")
                                    }
                                    catch
                                    {
                                        Write-Warning -Message "Could not replace line breaks in desired value of property $fieldName"
                                    }
                                }

                                if ([string]::IsNullOrEmpty($CurrentValues.$fieldName) -and
                                    [string]::IsNullOrEmpty($DesiredValues.$fieldName))
                                {
                                }
                                # Align line breaks
                                elseif (-not [string]::IsNullOrEmpty($CurrentValues.$fieldName) -and
                                    -not [string]::IsNullOrEmpty($DesiredValues.$fieldName) -and
                                    [string]::Equals($CurrentValues.$fieldName, $DesiredValues.$fieldName,
                                        [System.StringComparison]::Ordinal))
                                {
                                }
                                else
                                {
                                    Write-Verbose -Message ('String value for property ' + `
                                            "$fieldName does not match. " + `
                                            'Current state is ' + `
                                            "'$($CurrentValues.$fieldName)' " + `
                                            'and desired state is ' + `
                                            "'$($DesiredValues.$fieldName)'")
                                    $EventValue = "<CurrentValue>$($CurrentValues.$fieldName)</CurrentValue>"
                                    $EventValue += "<DesiredValue>$($DesiredValues.$fieldName)</DesiredValue>"
                                    $DriftObject.DriftInfo.Add($fieldName, @{
                                        CurrentValue = $CurrentValues.$fieldName
                                        DesiredValue = $DesiredValues.$fieldName
                                    })
                                    $DriftedParameters.Add($fieldName, $EventValue)
                                    $returnValue = $false
                                }
                            }
                            { $_ -eq 'Int32' -or $_ -eq 'UInt32' }
                            {
                                if (($DesiredValues.$fieldName -eq 0) `
                                        -and ($null -eq $CurrentValues.$fieldName))
                                {
                                }
                                else
                                {
                                    Write-Verbose -Message ('Int32 value for property ' + `
                                            "$fieldName does not match. " + `
                                            'Current state is ' + `
                                            "'$($CurrentValues.$fieldName)' " + `
                                            'and desired state is ' + `
                                            "'$($DesiredValues.$fieldName)'")
                                    $EventValue = "<CurrentValue>$($CurrentValues.$fieldName)</CurrentValue>"
                                    $EventValue += "<DesiredValue>$($DesiredValues.$fieldName)</DesiredValue>"
                                    $DriftObject.DriftInfo.Add($fieldName, @{
                                        CurrentValue = $CurrentValues.$fieldName
                                        DesiredValue = $DesiredValues.$fieldName
                                    })
                                    $DriftedParameters.Add($fieldName, $EventValue)
                                    $returnValue = $false
                                }
                            }
                            'Int16'
                            {
                                if (($DesiredValues.$fieldName -eq 0) `
                                        -and ($null -eq $CurrentValues.$fieldName))
                                {
                                }
                                else
                                {
                                    Write-Verbose -Message ('Int16 value for property ' + `
                                            "$fieldName does not match. " + `
                                            'Current state is ' + `
                                            "'$($CurrentValues.$fieldName)' " + `
                                            'and desired state is ' + `
                                            "'$($DesiredValues.$fieldName)'")
                                    $EventValue = "<CurrentValue>$($CurrentValues.$fieldName)</CurrentValue>"
                                    $EventValue += "<DesiredValue>$($DesiredValues.$fieldName)</DesiredValue>"
                                    $DriftObject.DriftInfo.Add($fieldName, @{
                                        CurrentValue = $CurrentValues.$fieldName
                                        DesiredValue = $DesiredValues.$fieldName
                                    })
                                    $DriftedParameters.Add($fieldName, $EventValue)
                                    $returnValue = $false
                                }
                            }
                            'Boolean'
                            {
                                if ($CurrentValues.$fieldName -ne $DesiredValues.$fieldName)
                                {
                                    Write-Verbose -Message ('Boolean value for property ' + `
                                            "$fieldName does not match. " + `
                                            'Current state is ' + `
                                            "'$($CurrentValues.$fieldName)' " + `
                                            'and desired state is ' + `
                                            "'$($DesiredValues.$fieldName)'")
                                    $EventValue = "<CurrentValue>$($CurrentValues.$fieldName)</CurrentValue>"
                                    $EventValue += "<DesiredValue>$($DesiredValues.$fieldName)</DesiredValue>"
                                    $DriftObject.DriftInfo.Add($fieldName, @{
                                        CurrentValue = $CurrentValues.$fieldName
                                        DesiredValue = $DesiredValues.$fieldName
                                    })
                                    $DriftedParameters.Add($fieldName, $EventValue)
                                    $returnValue = $false
                                }
                            }
                            'Single'
                            {
                                if (($DesiredValues.$fieldName -eq 0) `
                                        -and ($null -eq $CurrentValues.$fieldName))
                                {
                                }
                                else
                                {
                                    Write-Verbose -Message ('Single value for property ' + `
                                            "$fieldName does not match. " + `
                                            'Current state is ' + `
                                            "'$($CurrentValues.$fieldName)' " + `
                                            'and desired state is ' + `
                                            "'$($DesiredValues.$fieldName)'")
                                    $EventValue = "<CurrentValue>$($CurrentValues.$fieldName)</CurrentValue>"
                                    $EventValue += "<DesiredValue>$($DesiredValues.$fieldName)</DesiredValue>"
                                    $DriftObject.DriftInfo.Add($fieldName, @{
                                        CurrentValue = $CurrentValues.$fieldName
                                        DesiredValue = $DesiredValues.$fieldName
                                    })
                                    $DriftedParameters.Add($fieldName, $EventValue)
                                    $returnValue = $false
                                }
                            }
                            'Hashtable'
                            {
                                Write-Verbose -Message "The current property {$fieldName} is a Hashtable"
                                $AllDesiredValuesAsArray = @()
                                foreach ($item in $DesiredValues.$fieldName)
                                {
                                    $currentEntry = @{ }
                                    foreach ($key in $item.Keys)
                                    {
                                        $value = $item.$key
                                        if ([System.String]::IsNullOrEmpty($value))
                                        {
                                            $value = $null
                                        }
                                        $currentEntry.Add($key, $value)
                                    }
                                    $AllDesiredValuesAsArray += [PSCustomObject]$currentEntry
                                }

                                if ($null -ne $DesiredValues.$fieldName -and $null -eq $CurrentValues.$fieldName)
                                {
                                    $returnValue = $false
                                }
                                else
                                {
                                    $AllCurrentValuesAsArray = @()
                                    foreach ($item in $CurrentValues.$fieldName)
                                    {
                                        $currentEntry = @{ }
                                        foreach ($key in $item.Keys)
                                        {
                                            $value = $item.$key
                                            if ([System.String]::IsNullOrEmpty($value))
                                            {
                                                $value = $null
                                            }
                                            $currentEntry.Add($key, $value)
                                        }
                                        $AllCurrentValuesAsArray += [PSCustomObject]$currentEntry
                                    }
                                    $arrayCompare = Compare-PSCustomObjectArrays -CurrentValues $AllCurrentValuesAsArray `
                                        -DesiredValues $AllDesiredValuesAsArray
                                    if ($null -ne $arrayCompare)
                                    {
                                        foreach ($item in $arrayCompare)
                                        {
                                            $EventValue = "<CurrentValue>[$($item.PropertyName)]$($item.CurrentValue)</CurrentValue>"
                                            $EventValue += "<DesiredValue>[$($item.PropertyName)]$($item.DesiredValue)</DesiredValue>"
                                            if (-not $DriftedParameters.ContainsKey($fieldName))
                                            {
                                                $DriftedParameters.Add($fieldName, $EventValue)
                                                $DriftObject.DriftInfo.Add($fieldName, @{
                                                    PropertyName = $item.PropertyName
                                                    CurrentValue = $item.CurrentValue
                                                    DesiredValue = $item.DesiredValue
                                                })
                                            }
                                        }
                                        $returnValue = $false
                                    }
                                }
                            }
                            default
                            {
                                Write-Verbose -Message ("Unable to compare property $fieldName " + `
                                        "as the type ($($desiredType.Name)) is " + `
                                        'not handled by the ' + `
                                        'Test-M365DSCParameterState cmdlet')
                                $EventValue = "<CurrentValue>$($CurrentValues.$fieldName)</CurrentValue>"
                                $EventValue += "<DesiredValue>$($DesiredValues.$fieldName)</DesiredValue>"

                                $DriftObject.DriftInfo.Add($fieldName, @{
                                    CurrentValue = $CurrentValues.$fieldName
                                    DesiredValue = $DesiredValues.$fieldName
                                })
                                $DriftedParameters.Add($fieldName, $EventValue)
                                $returnValue = $false
                            }
                        }
                    }
                }
            }
        }
    }

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
        $EventMessage = [System.Text.StringBuilder]::New()
        $EventMessage.Append("<M365DSCEvent>`r`n") | Out-Null
        Write-Verbose -Message "Found Tenant Name: $TenantName"

        $LCMState = $null
        try
        {
            if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
            {
                $LCMInfo = Get-DscLocalConfigurationManager -ErrorAction Stop

                if ($LCMInfo.LCMStateDetail -eq 'LCM is performing a consistency check.' -or `
                        $LCMInfo.LCMStateDetail -eq 'LCM exécute une vérification de cohérence.' -or `
                        $LCMInfo.LCMStateDetail -eq 'LCM führt gerade eine Konsistenzüberprüfung durch.')
                {
                    $LCMState = 'ConsistencyCheck'
                }
                elseif ($LCMInfo.LCMStateDetail -eq 'LCM is testing node against the configuration.')
                {
                    $LCMState = 'ManualTestDSCConfiguration'
                }
                elseif ($LCMInfo.LCMStateDetail -eq 'LCM is applying a new configuration.' -or `
                        $LCMInfo.LCMStateDetail -eq 'LCM applique une nouvelle configuration.')
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

        $driftedData = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
        $driftedData.Add('Tenant', $TenantName)
        $DriftObject.Add('Tenant', $TenantName)
        $driftedData.Add('Resource', $source.Split('_')[1])
        $DriftObject.Add('Resource', $source.Split('_')[1])

        # If custom App Insights is specified, allow for the current and desired values to be captured;
        # ISSUE #1222
        if ($null -ne $env:M365DSCTelemetryInstrumentationKey -and `
                $env:M365DSCTelemetryInstrumentationKey -ne 'bc5aa204-0b1e-4499-a955-d6a639bdb4fa' -and `
                $env:M365DSCTelemetryInstrumentationKey -ne 'e670af5d-fd30-4407-a796-8ad30491ea7a')
        {
            $driftedData.Add('CurrentValues', $CurrentValues)
            $driftedData.Add('DesiredValues', $DesiredValues)
        }
        #endregion
        $telemetryDriftedParameters = ''
        foreach ($key in $DriftedParameters.Keys)
        {
            Write-Verbose -Message "Detected Drifted Parameter [$Source]$key"
            $telemetryDriftedParameters += $key + "`r`n"
            $EventMessage.Append("            <Param Name=`"$key`">" + $DriftedParameters.$key + "</Param>`r`n") | Out-Null
        }

        $driftedData.Add('Parameters', $telemetryDriftedParameters)
        Add-M365DSCTelemetryEvent -Type 'DriftInfo' -Data $driftedData
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
        foreach ($key in $DriftObject.DriftInfo.Keys)
        {
            $Global:AllDrifts.DriftInfo += @{
                PropertyName = $key
                CurrentValue = $DriftObject.DriftInfo.$key.CurrentValue
                DesiredValue = $DriftObject.DriftInfo.$key.DesiredValue
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
        $EventMessage = [System.Text.StringBuilder]::New()
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

    $timeTaken = [System.DateTime]::Now.Subtract($startTime).TotalMilliseconds
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add('Resource', $Source)
    $data.Add('Method', 'Test-M365DSCParameterState')
    $data.Add('TimeTakenMilliseconds', $timeTaken)
    $data.Add('Tenant', $TenantName)
    $data.Add('ParametersCount', $KeyList.Count)

    Add-M365DSCTelemetryEvent -Type 'ResourceTesting' `
        -Data $data
    return $returnValue
}

<#
.Description
    Centralized method to evaluate the result of the various Test-TargetResource functions

.PARAMETER PostProcessing
    Optional Func delegate that allows custom processing of the DesiredValues, CurrentValues and ValuesToCheck.
    The function receives three hashtable parameters: DesiredValues, CurrentValues (from Get-TargetResource) and ValuesToCheck.
    Additionally, it gets an array of objects as PostProcessingArgs.
    The delegate must return a Tuple[Hashtable, Hashtable, Hashtable] where Item1 is the processed DesiredValues, Item2 is the processed CurrentValues and Item3 is the processed ValuesToCheck.

.FUNCTIONALITY
    Internal
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

    if ($null -eq (Get-Module -Name 'M365DSCCompare'))
    {
        $compareModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'M365DSCCompare.psm1'
        Import-Module -Name $compareModulePath -Force
    }

    # Retrieve the primary keys of the given resource and remove them from the list of values to check.
    $currentPath = $PSScriptRoot
    if ($null -eq $Script:M365DSCSchema)
    {
        $schemaPath = Join-Path -Path $currentPath -ChildPath '..\SchemaDefinition.json'
        $schemaJSON = Get-Content $schemaPath -Raw
        $Script:M365DSCSchema = ConvertFrom-Json $schemaJSON
    }
    $resourceDefinition = $Script:M365DSCSchema | Where-Object -FilterScript { $_.ClassName -eq "MSFT_$ResourceName" }
    $resourceKeys = $resourceDefinition.Parameters | Where-Object -FilterScript { $_.Option -eq 'Key' }

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
.DESCRIPTION
    Sets the script scoped variable that holds all the M365DSC resources.

.PARAMETER DscResourceDictionary
    A dictionary containing all the M365DSC resources.

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
.DESCRIPTION
    Retrieves the script scoped variable that holds all the M365DSC resources.

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
.DESCRIPTION
    Initializes the script scoped variable that holds all the M365DSC resources.

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
        if ($Script:IsPowerShellCore)
        {
            Import-Module -Name 'PSDesiredStateConfiguration' -RequiredVersion 2.0.7 -Prefix 'Pwsh' -Force
            $resources = Get-PwshDscResource -Module 'Microsoft365Dsc'
        }
        else
        {
            $currentModule = Get-Module -Name 'Microsoft365DSC'
            $resources = Get-DscResource -Module 'Microsoft365Dsc' | Where-Object Version -EQ $currentModule.Version
        }
        foreach ($resource in $resources)
        {
            $Script:AllM365DSCResources.Add($resource.Name, $resource)
        }
    }
}

<#
.Description
This is the main Microsoft365DSC.Reverse function that extracts the DSC configuration from an existing Microsoft 365 Tenant.

.Parameter LaunchWebUI
Adding this parameter will open the WebUI in a browser.

.Parameter Path
Specifies the path in which the exported DSC configuration should be stored.

.Parameter FileName
Specifies the name of the file in which the exported DSC configuration should be stored.

.Parameter ConfigurationName
Specifies the name of the configuration that will be generated.

.Parameter Components
Specifies the components for which an export should be created.

.Parameter ExcludeComponents
Specifies the components to skip when creating the export

.Parameter Workloads
Specifies the workload for which an export should be created for all resources.

.Parameter Mode
Specifies the mode of the export: Default or Full.

.Parameter GenerateInfo
Specifies if each exported resource should get a link to the Wiki article of the resource.

.Parameter ApplicationId
Specifies the application id to be used for authentication.

.Parameter ApplicationSecret
Specifies the application secret of the application to be used for authentication.

.Parameter TenantId
Specifies the id of the tenant.

.Parameter CertificateThumbprint
Specifies the thumbprint to be used for authentication.

.Parameter Credential
Specifies the credentials to be used for authentication.

.Parameter CertificatePassword
Specifies the password of the PFX file which is used for authentication.

.Parameter CertificatePath
Specifies the path of the PFX file which is used for authentication.

.Parameter Filters
Specifies resource level filters to apply in order to reduce the number of instances exported.

.PARAMETER AccessTokens
    Specifies the access token to use for authentication.

.Parameter ManagedIdentity
Specifies use of managed identity for authentication.

.Parameter Validate
Specifies that the configuration needs to be validated for conflicts or issues after its extraction is completed.

.PARAMETER Parallel
    Specifies that the export is executed in parallel.

.PARAMETER TokenReplacement
    Specifies the hashtable to use for token replacement. Key is the value to replace, and the value is the variable to use for replacement without the '$' sign.

.PARAMETER WithStatistics
    Specifies that statistics about the export should be shown after completion.

.Example
Export-M365DSCConfiguration -Components @("AADApplication", "AADConditionalAccessPolicy", "AADGroupsSettings") -Credential $Credential

.Example
Export-M365DSCConfiguration -Mode 'Default' -ApplicationId '2560bb7c-bc85-415f-a799-841e10ec4f9a' -TenantId 'contoso.sharepoint.com' -ApplicationSecret 'abcdefghijkl'

.Example
Export-M365DSCConfiguration -Components @("AADApplication", "AADConditionalAccessPolicy", "AADGroupsSettings") -Credential $Credential -Path 'C:\DSC' -FileName 'MyConfig.ps1'

.Example
Export-M365DSCConfiguration -Credential $Credential -Filters @{AADApplication = "DisplayName eq 'MyApp'"} -TokenReplacement @{ 'alternate-email.onmicrosoft.com' = 'AlternateEmail' }

.Example
Export-M365DSCConfiguration -Workloads @("SPO") -ExcludeComponents @("SPOPropertyBag") -Credential $Credential

.Functionality
Public
#>
function Export-M365DSCConfiguration
{
    [CmdletBinding(DefaultParameterSetName = 'Export')]
    param
    (
        [Parameter(ParameterSetName = 'WebUI')]
        [Switch]
        $LaunchWebUI,

        [Parameter(ParameterSetName = 'Export')]
        [System.String]
        $Path,

        [Parameter(ParameterSetName = 'Export')]
        [System.String]
        $FileName,

        [Parameter(ParameterSetName = 'Export')]
        [System.String]
        $ConfigurationName,

        [Parameter(ParameterSetName = 'Export')]
        [System.String[]]
        $Components,

        [Parameter(ParameterSetName = 'Export')]
        [System.String[]]
        $ExcludeComponents,

        [Parameter(ParameterSetName = 'Export')]
        [ValidateSet('AAD', 'ADO', 'AZURE', 'COMMERCE', 'DEFENDER', 'EXO', 'FABRIC', 'INTUNE', 'O365', 'OD', 'PLANNER', 'PP', 'SC', 'SENTINEL', 'SH', 'SPO', 'TEAMS')]
        [System.String[]]
        $Workloads,

        [Parameter(ParameterSetName = 'Export')]
        [ValidateSet('Default', 'Full')]
        [System.String]
        $Mode = 'Default',

        [Parameter(ParameterSetName = 'Export')]
        [System.Boolean]
        $GenerateInfo = $false,

        [Parameter(ParameterSetName = 'Export')]
        [System.Collections.Hashtable]
        $Filters,

        [Parameter(ParameterSetName = 'Export')]
        [System.String]
        $ApplicationId,

        [Parameter(ParameterSetName = 'Export')]
        [ValidateScript({
                $invalid = $false
                $parseGuid = [System.Guid]::Empty
                if ([System.Guid]::TryParse($_, [ref]$parseGuid))
                {
                    throw 'Please provide the tenant name (e.g., contoso.onmicrosoft.com) for TenantId instead of its GUID.'
                }
                $invalid = $_ -notmatch '.onmicrosoft.'
                if ($invalid)
                {
                    Write-Warning -Message 'We recommend providing the TenantId property in the format of <tenant>.onmicrosoft.*'
                }
                return $true
            })]
        [System.String]
        $TenantId,

        [Parameter(ParameterSetName = 'Export')]
        [System.String]
        $ApplicationSecret,

        [Parameter(ParameterSetName = 'Export')]
        [System.String]
        $CertificateThumbprint,

        [Parameter(ParameterSetName = 'Export')]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter(ParameterSetName = 'Export')]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter(ParameterSetName = 'Export')]
        [System.String]
        $CertificatePath,

        [Parameter(ParameterSetName = 'Export')]
        [Switch]
        $ManagedIdentity,

        [Parameter(ParameterSetName = 'Export')]
        [System.String[]]
        $AccessTokens,

        [Parameter(ParameterSetName = 'Export')]
        [Switch]
        $Validate,

        [Parameter(ParameterSetName = 'Export')]
        [Switch]
        $Parallel,

        [Parameter(ParameterSetName = 'Export')]
        [System.Collections.Hashtable]
        $TokenReplacement,

        [Parameter(ParameterSetName = 'Export')]
        [Switch]
        $WithStatistics
    )

    $currentStartDateTime = [System.DateTime]::Now
    $Global:M365DSCExportInProgress = $true
    $Global:MaximumFunctionCount = 32767

    # Define the exported resource instances' names Global variable
    $Global:M365DSCExportedResourceInstancesNames = @()

    # LaunchWebUI specified, launching that now
    if ($LaunchWebUI)
    {
        Write-Output -InputObject "Launching web page 'https://export.microsoft365dsc.com'"
        explorer 'https://export.microsoft365dsc.com'
        return
    }

    # Suppress Progress overlays
    $Global:ProgressPreference = 'SilentlyContinue'

    # Check ErrorActionPreference - Azure DevOps and other Pipeline environments set it to 'Stop' by default
    if ($ErrorActionPreference -eq 'Stop' -and -not $PSBoundParameters.ContainsKey('ErrorAction'))
    {
        $ErrorActionPreference = 'Continue'
    }

    ##### FIRST CHECK AUTH PARAMETERS
    if ($PSBoundParameters.ContainsKey('Credential') -eq $true -and `
            -not [System.String]::IsNullOrEmpty($Credential))
    {
        if ($Credential.Username -notmatch '.onmicrosoft.')
        {
            Write-Warning -Message 'We recommend providing the username in the format of <tenant>.onmicrosoft.* for the Credential property.'
        }
    }

    if ($PSBoundParameters.ContainsKey('CertificatePath') -eq $true -and `
            $PSBoundParameters.ContainsKey('CertificatePassword') -eq $false)
    {
        throw 'You have to specify CertificatePassword when you specify CertificatePath'
    }

    if ($PSBoundParameters.ContainsKey('CertificatePassword') -eq $true -and `
            $PSBoundParameters.ContainsKey('CertificatePath') -eq $false)
    {
        throw 'You have to specify CertificatePath when you specify CertificatePassword'
    }

    if ($PSBoundParameters.ContainsKey('ApplicationId') -eq $true -and `
            $PSBoundParameters.ContainsKey('Credential') -eq $false -and `
            $PSBoundParameters.ContainsKey('TenantId') -eq $false)
    {
        throw 'You have to specify TenantId when you specify ApplicationId'
    }

    if ($PSBoundParameters.ContainsKey('ApplicationId') -eq $true -and `
            $PSBoundParameters.ContainsKey('TenantId') -eq $true -and `
            $PSBoundParameters.ContainsKey('Credential') -eq $false -and `
        ($PSBoundParameters.ContainsKey('CertificateThumbprint') -eq $false -and `
                $PSBoundParameters.ContainsKey('ApplicationSecret') -eq $false -and `
                $PSBoundParameters.ContainsKey('CertificatePath') -eq $false))
    {
        throw 'You have to specify ApplicationSecret, CertificateThumbprint or CertificatePath when you specify ApplicationId/TenantId'
    }

    if (($PSBoundParameters.ContainsKey('ApplicationId') -eq $false -or `
                $PSBoundParameters.ContainsKey('TenantId') -eq $false) -and `
        ($PSBoundParameters.ContainsKey('Credential') -eq $false -and `
                $PSBoundParameters.ContainsKey('CertificateThumbprint') -eq $true -or `
                $PSBoundParameters.ContainsKey('ApplicationSecret') -eq $true -or `
                $PSBoundParameters.ContainsKey('CertificatePath') -eq $true))
    {
        throw 'You have to specify ApplicationId and TenantId when you specify ApplicationSecret, CertificateThumbprint or CertificatePath'
    }

    # Default to Credential if no authentication mechanism were provided
    if ($PSBoundParameters.ContainsKey('Credential') -eq $false -and `
            $ManagedIdentity.IsPresent -eq $false -and `
            $PSBoundParameters.ContainsKey('ApplicationId') -eq $false -and `
            $PSBoundParameters.ContainsKey('AccessTokens') -eq $false)
    {
        $Credential = Get-Credential
    }

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()

    $data.Add('Path', [System.String]::IsNullOrEmpty($Path))
    $data.Add('FileName', $null -ne [System.String]::IsNullOrEmpty($FileName))
    $data.Add('Components', $Components)
    $data.Add('Workloads', $Workloads)
    #endregion

    # Make sure we are not connected to Microsoft Graph on another tenant
    # except if connected through MSCloudLoginAssistant - it will handle the connection
    try
    {
        Confirm-M365DSCLoadedModule -ModuleName 'Microsoft.Graph.Authentication'
        $currentConnectionProfile = Get-MSCloudLoginConnectionProfile -Workload 'MicrosoftGraph'
        if ($null -ne (Get-MgContext) -and -not $currentConnectionProfile.Connected)
        {
            Disconnect-MgGraph -ErrorAction Stop | Out-Null
            Reset-MSCloudLoginConnectionProfileContext -Workload 'MicrosoftGraph'
        }
    }
    catch
    {
        Write-Verbose -Message 'No existing connections to Microsoft Graph'
    }

    $Tenant = Get-M365DSCTenantNameFromParameterSet -ParameterSet $PSBoundParameters
    $ConnectionMode = Get-M365DSCAuthenticationMode $PSBoundParameters
    $data.Add('Tenant', $Tenant)
    $currentExportID = (New-Guid).ToString()
    $data.Add('M365DSCExportId', $currentExportID)
    $data.Add('ConnectionMode', $ConnectionMode)

    # Define connection to Graph parameters because it is required by the telemetry.
    if ($null -eq $Script:M365DSCTelemetryConnectionToGraphParams -or `
        ($null -ne $Script:M365DSCTelemetryConnectionToGraphParams -and `
                $Script:M365DSCTelemetryConnectionToGraphParams.Keys.Count -eq 0))
    {
        $Script:M365DSCTelemetryConnectionToGraphParams = @{
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            Identity              = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
    }

    Add-M365DSCTelemetryEvent -Type 'ExportInitiated' -Data $data
    Initialize-M365DSCAllResourcesDictionary
    if ($PSBoundParameters.ContainsKey('TokenReplacement'))
    {
        Set-M365DSCStringReplacementMap -Map $TokenReplacement
    }

    if ($null -ne $Workloads)
    {
        Write-M365DSCHost -Message "Exporting Microsoft 365 configuration for Workloads: $($Workloads -join ', ')"
        Start-M365DSCConfigurationExtract -Credential $Credential `
            -Workloads $Workloads `
            -ExcludeComponents $ExcludeComponents `
            -Mode $Mode `
            -Path $Path -FileName $FileName `
            -ConfigurationName $ConfigurationName `
            -ApplicationId $ApplicationId `
            -ApplicationSecret $ApplicationSecret `
            -TenantId $TenantId `
            -CertificateThumbprint $CertificateThumbprint `
            -CertificatePath $CertificatePath `
            -CertificatePassword $CertificatePassword `
            -ManagedIdentity:$ManagedIdentity `
            -AccessTokens $AccessTokens `
            -GenerateInfo $GenerateInfo `
            -Filters $Filters `
            -Validate:$Validate `
            -Parallel:$Parallel `
            -ResourceSettings $Script:M365DSCResourceSettings `
            -ErrorAction $ErrorActionPreference `
            -WithStatistics:$WithStatistics
    }
    elseif ($null -ne $Components)
    {
        Write-M365DSCHost -Message "Exporting Microsoft 365 configuration for Components: $($Components -join ', ')"
        Start-M365DSCConfigurationExtract -Credential $Credential `
            -Components $Components `
            -ExcludeComponents $ExcludeComponents `
            -Path $Path -FileName $FileName `
            -ConfigurationName $ConfigurationName `
            -ApplicationId $ApplicationId `
            -ApplicationSecret $ApplicationSecret `
            -TenantId $TenantId `
            -CertificateThumbprint $CertificateThumbprint `
            -CertificatePath $CertificatePath `
            -CertificatePassword $CertificatePassword `
            -ManagedIdentity:$ManagedIdentity `
            -AccessTokens $AccessTokens `
            -GenerateInfo $GenerateInfo `
            -Filters $Filters `
            -Validate:$Validate `
            -Parallel:$Parallel `
            -ResourceSettings $Script:M365DSCResourceSettings `
            -ErrorAction $ErrorActionPreference `
            -WithStatistics:$WithStatistics
    }
    elseif ($null -ne $Mode)
    {
        Write-M365DSCHost -Message "Exporting Microsoft 365 configuration for Mode: $Mode"
        Start-M365DSCConfigurationExtract -Credential $Credential `
            -Mode $Mode `
            -ExcludeComponents $ExcludeComponents `
            -Path $Path -FileName $FileName `
            -ConfigurationName $ConfigurationName `
            -ApplicationId $ApplicationId `
            -ApplicationSecret $ApplicationSecret `
            -TenantId $TenantId `
            -CertificateThumbprint $CertificateThumbprint `
            -CertificatePath $CertificatePath `
            -CertificatePassword $CertificatePassword `
            -ManagedIdentity:$ManagedIdentity `
            -AccessTokens $AccessTokens `
            -GenerateInfo $GenerateInfo `
            -AllComponents `
            -Filters $Filters `
            -Validate:$Validate `
            -Parallel:$Parallel `
            -ResourceSettings $Script:M365DSCResourceSettings `
            -ErrorAction $ErrorActionPreference `
            -WithStatistics:$WithStatistics
    }

    # Clear the exported resource instances' names Global variable
    $Global:M365DSCExportedResourceInstancesNames = $null
    $Global:M365DSCExportInProgress = $false

    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    if ([System.String]::IsNullOrEmpty($data.Tenant) -and -not [System.String]::IsNullOrEmpty($TenantId))
    {
        $data.Add('Tenant', $TenantId)
    }
    else
    {
        $data.Add('Tenant', $Tenant)
    }
    $data.Add('M365DSCExportId', $currentExportID)
    $data.Add('ConnectionMode', $ConnectionMode)
    $timeTaken = [System.DateTime]::Now.Subtract($currentStartDateTime)
    $data.Add('TotalSeconds', $timeTaken.TotalSeconds)
    Add-M365DSCTelemetryEvent -Type 'ExportCompleted' -Data $data
}

<#
.DESCRIPTION
    This function imports all the required M365DSC module dependencies as specified in the M365DSC dependencies manifest.

.EXAMPLE
    PS> Import-M365DSCModuleDependency

.FUNCTIONALITY
    Internal
#>
function Import-M365DSCModuleDependency
{
    [CmdletBinding()]
    param ()

    foreach ($entry in $Script:M365DSCDependencies.GetEnumerator())
    {
        if ($entry.Value.PowerShellCore -and -not $Script:IsPowerShellCore)
        {
            continue
        }

        Write-Verbose -Message "Importing $($entry.Key) with version $($entry.Value.RequiredVersion)"
        $importModuleSplat = @{
            Name                = $entry.Key
            RequiredVersion     = $entry.Value.RequiredVersion
            Global              = $true
            Function            = @('*')
            Cmdlet              = @('*')
            Alias               = @()
            Variable            = @()
            DisableNameChecking = $true
        }
        if ($entry.Value.Commands.Count -gt 0)
        {
            $importModuleSplat.Function = $entry.Value.Commands
            $importModuleSplat.Cmdlet = $entry.Value.Commands
        }
        Import-Module @importModuleSplat -Verbose:$false
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
            Name                = $ModuleName
            RequiredVersion     = $manifestModule.RequiredVersion
            Global              = $true
            Alias               = @()
            Cmdlet              = @()
            Variable            = @()
            DisableNameChecking = $true
        }
        if ($manifestModule.Commands.Count -gt 0)
        {
            $importModuleSplat.Add('Function', $manifestModule.Commands)
            $importModuleSplat.Cmdlet = $manifestModule.Commands
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
.Description
This function checks if all M365DSC dependencies are present

.Functionality
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
This function tests the code page of the current terminal session.

.EXAMPLE
Test-CodePage

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
.Description
This function retrieves the various endpoint urls based on the cloud environment.

.Example
Get-M365DSCAPIEndpoint -TenantId 'contoso.onmicrosoft.com'

.Functionality
Private
#>
function Get-M365DSCAPIEndpoint
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId
    )

    try
    {
        $webrequest = Invoke-WebRequest -Uri "https://login.windows.net/$($TenantId)/.well-known/openid-configuration" -UseBasicParsing
        $response = ConvertFrom-Json $webrequest.Content
        $tenantRegionScope = $response.'tenant_region_scope'

        $endpoints = @{
            AzureManagement = $null
        }

        switch ($tenantRegionScope)
        {
            'USGov'
            {
                if ($null -ne $response.'tenant_region_sub_scope' -and $response.'tenant_region_sub_scope' -eq 'DODCON')
                {
                    $endpoints.AzureManagement = 'https://management.usgovcloudapi.net'
                }
            }
            default
            {
                $endpoints.AzureManagement = 'https://management.azure.com'
            }
        }
        return $endpoints
    }
    catch
    {
        throw $_
    }
}

<#
.Description
This function gets the onmicrosoft.com name of the tenant

.Functionality
Internal
#>
function Get-M365DSCTenantDomain
{
    [CmdletBinding(DefaultParameterSetName = 'AppId')]
    [OutputType([System.String])]
    param
    (
        [Parameter(ParameterSetName = 'AppId', Mandatory = $true)]
        [System.String]
        $ApplicationId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId,

        [Parameter(ParameterSetName = 'AppId')]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter(ParameterSetName = 'AppId')]
        [System.String]
        $CertificateThumbprint,

        [Parameter(ParameterSetName = 'AppId')]
        [System.String]
        $CertificatePath,

        [Parameter(ParameterSetName = 'MID')]
        [Switch]
        $ManagedIdentity
    )

    if ([System.String]::IsNullOrEmpty($CertificatePath))
    {
        $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters

        try
        {
            $tenantDetails = (Invoke-MgGraphRequest -Uri '/beta/organization' -Method GET -ErrorAction 'Stop').value
            $defaultDomain = $tenantDetails.verifiedDomains | Where-Object -FilterScript { $_.isInitial }

            return $defaultDomain.name
        }
        catch
        {
            if ($_.Exception.Message -eq 'Insufficient privileges to complete the operation.')
            {
                New-M365DSCLogEntry `
                    -Message 'Error retrieving Organizational information: Missing Organization.Read.All permission. ' `
                    -Exception $_ `
                    -Source $($MyInvocation.MyCommand.Source) `
                    -TenantId $TenantId `
                    -Credential $Credential

                return [System.String]::Empty
            }

            throw $_
        }
    }

    if ($TenantId.Contains('onmicrosoft'))
    {
        return $TenantId
    }
    else
    {
        throw 'TenantID must be in format contoso.onmicrosoft.com'
    }
}

<#
.Description
This function gets the DNS domain used in the specified credential

.Functionality
Internal
#>
function Get-M365DSCOrganization
{
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $TenantId
    )

    if ($null -ne $Credential -and $Credential.UserName.Contains('@'))
    {
        $organization = $Credential.UserName.Split('@')[1]
        return $organization
    }

    if (-not [System.String]::IsNullOrEmpty($TenantId))
    {
        if ($TenantId.Contains('.'))
        {
            $organization = $TenantId
            return $organization
        }
        else
        {
            throw 'Tenant ID must be name of the tenant, e.g. contoso.onmicrosoft.com'
        }

    }
}

<#
.DESCRIPTION
    This function retrieves the telemetry connection parameters for the current session.

.FUNCTIONALITY
    Internal.
#>
function Get-M365DSCTelemetryConnectionParameter
{
    [CmdletBinding()]
    param ()

    $Script:M365DSCTelemetryConnectionToGraphParams.Clone()
}

<#
.Description
This function creates a new connection to the specified M365 workload

.Functionality
Internal
#>
function New-M365DSCConnection
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('AdminAPI', 'Azure', 'AzureDevOPS', 'DefenderForEndpoint', 'EngageHub', 'ExchangeOnline', 'Fabric', 'Licensing', `
                'SecurityComplianceCenter', 'PnP', 'PowerPlatforms', 'PowerPlatformREST', `
                'MicrosoftTeams', 'MicrosoftGraph', 'SharePointOnlineREST', 'Tasks')]
        [System.String]
        $Workload,

        [Parameter(Mandatory = $true)]
        [ValidateScript({
                if ($null -ne $_.Credential)
                {
                    $invalid = $_.Credential.Username -notmatch '.onmicrosoft.'
                    if (-not $invalid)
                    {
                        return $true
                    }
                    else
                    {
                        Write-Warning -Message 'We recommend providing the username in the format of <tenant>.onmicrosoft.* for the Credential property.'
                    }
                }

                if ($null -ne $_.TenantId)
                {
                    $parseGuid = [System.Guid]::Empty
                    $isValid = [System.Guid]::TryParse($_.TenantId, [ref]$parseGuid)
                    if ($isValid)
                    {
                        throw 'Please provide the tenant name (e.g., contoso.onmicrosoft.com) for TenantId instead of its GUID.'
                    }

                    $isValid = $_.TenantId -match '.onmicrosoft.'
                    if ($isValid)
                    {
                        return $true
                    }
                    else
                    {
                        Write-Warning -Message 'We recommend providing the tenant name in format <tenant>.onmicrosoft.* for TenantId.'
                    }
                }
                return $true
            })]
        [System.Collections.Hashtable]
        $InboundParameters,

        [Parameter()]
        [System.String]
        $Url,

        [Parameter()]
        [switch]
        $EnableSearchOnlySession
    )

    if (-not $Script:M365DSCRequiredModulesLoaded)
    {
        foreach ($requiredModule in $Script:M365DSCRequiredModules)
        {
            Write-Verbose -Message "Ensuring required module '$requiredModule' is loaded."
            Confirm-M365DSCLoadedModule -ModuleName $requiredModule
        }
        $Script:M365DSCRequiredModulesLoaded = $true
    }

    if ($Workload -eq 'MicrosoftTeams')
    {
        try
        {
            $null = Get-Command 'Connect-MicrosoftTeams' -ErrorAction Stop
        }
        catch
        {
            Import-Module 'MicrosoftTeams' -Global -Force -Alias @() -Cmdlet @() -Variable @() -DisableNameChecking | Out-Null
        }
    }

    Write-Verbose -Message "Attempting connection to {$Workload} with:"
    Write-Verbose -Message "$($InboundParameters | Out-String)"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add('Source', 'M365DSCUtil')
    $data.Add('Workload', $Workload)

    $Script:M365DSCTelemetryConnectionToGraphParams = @{}

    # Keep track of workloads we already connected so that we don't send additional Telemetry events.
    if ($null -eq $Script:M365ConnectedToWorkloads)
    {
        Write-Verbose -Message 'Initializing the Connected To Workloads List.'
        $Script:M365ConnectedToWorkloads = @()
    }

    # Get the ApplicationSecret parameter back as a string.
    if ($InboundParameters.ApplicationSecret)
    {
        $InboundParameters.ApplicationSecret = $InboundParameters.ApplicationSecret.GetNetworkCredential().Password
        if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('ApplicationSecret'))
        {
            $Script:M365DSCTelemetryConnectionToGraphParams.Add('ApplicationSecret', $InboundParameters.ApplicationSecret)
        }
    }

    # Case both authentication methods are attempted
    if ($null -ne $InboundParameters.Credential -and `
            -not [System.String]::IsNullOrEmpty($InboundParameters.CertificateThumbprint))
    {
        $message = 'Both Authentication methods are attempted'
        Write-Verbose -Message $message
        $data.Add('Exception', $message)
        $errorText = "You can't specify both the Credential and CertificateThumbprint"
        $data.Add('CustomMessage', $errorText)
        Add-M365DSCTelemetryEvent -Type 'Error' -Data $data
        throw $errorText
    }
    # Case no authentication method is specified
    elseif ($null -eq $InboundParameters.Credential -and `
            [System.String]::IsNullOrEmpty($InboundParameters.ApplicationId) -and `
            [System.String]::IsNullOrEmpty($InboundParameters.TenantId) -and `
            [System.String]::IsNullOrEmpty($InboundParameters.CertificateThumbprint) -and `
            -not $InboundParameters.ManagedIdentity -and `
            $null -eq $InboundParameters.AccessTokens)
    {
        $message = 'No Authentication method was provided'
        Write-Verbose -Message $message
        $message += "`r`nProvided Keys --> $($InboundParameters.Keys)"
        $data.Add('Exception', $message)
        $errorText = 'You must specify either the Credential or ApplicationId, TenantId and CertificateThumbprint parameters.'
        $data.Add('CustomMessage', $errorText)
        Add-M365DSCTelemetryEvent -Type 'Error' -Data $data
        throw $errorText
    }
    # Case only Credential is specified
    elseif ($null -ne $InboundParameters.Credential -and `
            [System.String]::IsNullOrEmpty($InboundParameters.ApplicationId) -and `
            [System.String]::IsNullOrEmpty($InboundParameters.TenantId) -and `
            [System.String]::IsNullOrEmpty($InboundParameters.CertificateThumbprint))
    {
        Write-Verbose -Message 'Credential was specified. Connecting via User Principal'
        if ([System.String]::IsNullOrEmpty($Url))
        {
            if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('Credential'))
            {
                $Script:M365DSCTelemetryConnectionToGraphParams.Add('Credential', $InboundParameters.Credential)
            }
            Connect-M365Tenant -Workload $Workload `
                -Credential $InboundParameters.Credential `
                -EnableSearchOnlySession:$EnableSearchOnlySession

            if (-not $Script:M365ConnectedToWorkloads -contains "$Workload-Credential")
            {
                $data.Add('ConnectionMode', 'Credentials')
                try
                {
                    if (-not $Data.ContainsKey('Tenant'))
                    {
                        $tenantId = $InboundParameters.Credential.Username.Split('@')[1]
                        $data.Add('Tenant', $tenantId)

                        if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('TenantId'))
                        {
                            $Script:M365DSCTelemetryConnectionToGraphParams.Add('TenantId', $tenantId)
                        }
                    }
                }
                catch
                {
                    Write-Verbose -Message $_
                }

                Add-M365DSCTelemetryEvent -Data $data -Type 'Connection'
                $Script:M365ConnectedToWorkloads += "$Workload-Credential"
            }
            return 'Credentials'
        }
        if ($InboundParameters.ContainsKey('Credential') -and
            $null -ne $InboundParameters.Credential)
        {
            if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('Credential'))
            {
                $Script:M365DSCTelemetryConnectionToGraphParams.Add('Credential', $InboundParameters.Credential)
            }
            Connect-M365Tenant -Workload $Workload `
                -Credential $InboundParameters.Credential `
                -Url $Url `
                -EnableSearchOnlySession:$EnableSearchOnlySession

            if (-not $Script:M365ConnectedToWorkloads -contains "$Workload-Credential")
            {
                $data.Add('ConnectionMode', 'Credential')
                try
                {
                    if (-not $Data.ContainsKey('Tenant'))
                    {
                        $tenantId = $InboundParameters.Credential.Username.Split('@')[1]
                        $data.Add('Tenant', $tenantId)
                        if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('TenantId'))
                        {
                            $Script:M365DSCTelemetryConnectionToGraphParams.Add('TenantId', $tenantId)
                        }
                    }
                }
                catch
                {
                    Write-Verbose -Message $_
                }

                Add-M365DSCTelemetryEvent -Data $data -Type 'Connection'
                $Script:M365ConnectedToWorkloads += "$Workload-Credential"
            }
            return 'Credentials'
        }
    }
    # Case only Credential with ApplicationId is specified
    elseif ($null -ne $InboundParameters.Credential -and `
            -not [System.String]::IsNullOrEmpty($InboundParameters.ApplicationId) -and `
            [System.String]::IsNullOrEmpty($InboundParameters.TenantId) -and `
            [System.String]::IsNullOrEmpty($InboundParameters.CertificateThumbprint))
    {
        if ([System.String]::IsNullOrEmpty($Url))
        {
            if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('Credential'))
            {
                $Script:M365DSCTelemetryConnectionToGraphParams.Add('Credential', $InboundParameters.Credential)
            }
            if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('ApplicationId'))
            {
                $Script:M365DSCTelemetryConnectionToGraphParams.Add('ApplicationId', $InboundParameters.ApplicationId)
            }
            Connect-M365Tenant -Workload $Workload `
                -ApplicationId $InboundParameters.ApplicationId `
                -Credential $InboundParameters.Credential `
                -EnableSearchOnlySession:$EnableSearchOnlySession

            if (-not $Script:M365ConnectedToWorkloads -contains "$Workload-CredentialsWithApplicationId")
            {
                $data.Add('ConnectionMode', 'CredentialsWithApplicationId')

                try
                {
                    if (-not $Data.ContainsKey('Tenant'))
                    {
                        $tenantId = $InboundParameters.Credential.Username.Split('@')[1]
                        $data.Add('Tenant', $tenantId)
                        if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('TenantId'))
                        {
                            $Script:M365DSCTelemetryConnectionToGraphParams.Add('TenantId', $tenantId)
                        }
                    }
                }
                catch
                {
                    Write-Verbose -Message $_
                }

                Add-M365DSCTelemetryEvent -Data $data -Type 'Connection'
                $Script:M365ConnectedToWorkloads += "$Workload-CredentialsWithApplicationId"
            }
            return 'CredentialsWithApplicationId'
        }
        else
        {
            if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('ApplicationId'))
            {
                $Script:M365DSCTelemetryConnectionToGraphParams.Add('ApplicationId', $InboundParameters.ApplicationId)
            }
            if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('Credential'))
            {
                $Script:M365DSCTelemetryConnectionToGraphParams.Add('Credential', $InboundParameters.Credential)
            }
            Connect-M365Tenant -Workload $Workload `
                -ApplicationId $InboundParameters.ApplicationId `
                -Credential $InboundParameters.Credential `
                -Url $Url `
                -EnableSearchOnlySession:$EnableSearchOnlySession

            if (-not $Script:M365ConnectedToWorkloads -contains "$Workload-CredentialsWithApplicationId")
            {
                $data.Add('ConnectionMode', 'CredentialsWithApplicationId')

                try
                {
                    if (-not $Data.ContainsKey('Tenant'))
                    {
                        $tenantId = $InboundParameters.Credential.Username.Split('@')[1]
                        $data.Add('Tenant', $tenantId)
                        if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('ApplicationId'))
                        {
                            $Script:M365DSCTelemetryConnectionToGraphParams.Add('ApplicationId', $tenantId)
                        }
                    }
                }
                catch
                {
                    Write-Verbose -Message $_
                }

                Add-M365DSCTelemetryEvent -Data $data -Type 'Connection'
                $Script:M365ConnectedToWorkloads += "$Workload-CredentialsWithApplicationId"
            }
            return 'CredentialsWithApplicationId'
        }
    }
    # Case only the ServicePrincipal with CertificatePath parameters are specified
    elseif ($null -eq $InboundParameters.Credential -and `
            -not [System.String]::IsNullOrEmpty($InboundParameters.ApplicationId) -and `
            -not [System.String]::IsNullOrEmpty($InboundParameters.TenantId) -and `
            -not [System.String]::IsNullOrEmpty($InboundParameters.CertificatePath) -and `
            $null -ne $InboundParameters.CertificatePassword)
    {
        if ([System.String]::IsNullOrEmpty($url))
        {
            Write-Verbose -Message 'ApplicationId, TenantId, CertificatePath & CertificatePassword were specified. Connecting via Service Principal'

            if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('ApplicationId'))
            {
                $Script:M365DSCTelemetryConnectionToGraphParams.Add('ApplicationId', $InboundParameters.ApplicationId)
            }
            if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('TenantId'))
            {
                $Script:M365DSCTelemetryConnectionToGraphParams.Add('TenantId', $InboundParameters.TenantId)
            }
            if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('CertificatePassword'))
            {
                $Script:M365DSCTelemetryConnectionToGraphParams.Add('CertificatePassword', $InboundParameters.CertificatePassword.Password)
            }
            if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('CertificatePath'))
            {
                $Script:M365DSCTelemetryConnectionToGraphParams.Add('CertificatePath', $InboundParameters.CertificatePath)
            }
            Connect-M365Tenant -Workload $Workload `
                -ApplicationId $InboundParameters.ApplicationId `
                -TenantId $InboundParameters.TenantId `
                -CertificatePassword $InboundParameters.CertificatePassword.Password `
                -CertificatePath $InboundParameters.CertificatePath `
                -EnableSearchOnlySession:$EnableSearchOnlySession

            if (-not $Script:M365ConnectedToWorkloads -contains "$Workload-ServicePrincipalWithPath")
            {
                $data.Add('ConnectionMode', 'ServicePrincipalWithPath')
                if (-not $data.ContainsKey('Tenant'))
                {
                    $data.Add('Tenant', $InboundParameters.TenantId)
                    if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('TenantId'))
                    {
                        $Script:M365DSCTelemetryConnectionToGraphParams.Add('TenantId', $InboundParameters.TenantId)
                    }
                }
                Add-M365DSCTelemetryEvent -Data $data -Type 'Connection'
                $Script:M365ConnectedToWorkloads += "$Workload-ServicePrincipalWithPath"
            }
            return 'ServicePrincipalWithPath'
        }
        #endregion

        # Case no authentication method is specified
        if ($null -eq $InboundParameters.Credential -and `
                [System.String]::IsNullOrEmpty($InboundParameters.ApplicationId) -and `
                [System.String]::IsNullOrEmpty($InboundParameters.TenantId) -and `
                [System.String]::IsNullOrEmpty($InboundParameters.CertificateThumbprint))
        {
            $message = 'No Authentication method was provided'
            Write-Verbose -Message $message
            $message += "`r`nProvided Keys --> $($InboundParameters.Keys)"
            $data.Add('Exception', $message)
            $errorText = 'You must specify either the Credential or ApplicationId, TenantId and CertificateThumbprint parameters.'
            $data.Add('CustomMessage', $errorText)
            Add-M365DSCTelemetryEvent -Type 'Error' -Data $data
            throw $errorText
        }
        else
        {
            $data.Add('ConnectionMode', 'ServicePrincipalWithPath')
            if (-not $data.ContainsKey('Tenant'))
            {
                if (-not [System.String]::IsNullOrEmpty($InboundParameters.TenantId))
                {
                    $data.Add('Tenant', $InboundParameters.TenantId)
                }
                elseif ($ null -ne $InboundParameters.Credential)
                {
                    $data.Add('Tenant', $InboundParameters.Credential.Split('@')[1])
                }
            }
            Add-M365DSCTelemetryEvent -Data $data -Type 'Connection'

            return 'ServicePrincipalWithPath'
        }
    }
    # Case only the ApplicationSecret, TenantId and ApplicationID are specified
    elseif ($null -eq $InboundParameters.Credential -and `
            -not [System.String]::IsNullOrEmpty($InboundParameters.ApplicationId) -and `
            -not [System.String]::IsNullOrEmpty($InboundParameters.TenantId) -and `
            -not [System.String]::IsNullOrEmpty($InboundParameters.ApplicationSecret))
    {
        if ([System.String]::IsNullOrEmpty($url))
        {
            Write-Verbose -Message 'ApplicationId, TenantId, ApplicationSecret were specified. Connecting via Service Principal'

            if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('ApplicationId'))
            {
                $Script:M365DSCTelemetryConnectionToGraphParams.Add('ApplicationId', $InboundParameters.ApplicationId)
            }
            if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('TenantId'))
            {
                $Script:M365DSCTelemetryConnectionToGraphParams.Add('TenantId', $InboundParameters.TenantId)
            }
            if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('ApplicationSecret'))
            {
                $Script:M365DSCTelemetryConnectionToGraphParams.Add('ApplicationSecret', $InboundParameters.ApplicationSecret)
            }
            Connect-M365Tenant -Workload $Workload `
                -ApplicationId $InboundParameters.ApplicationId `
                -TenantId $InboundParameters.TenantId `
                -ApplicationSecret $InboundParameters.ApplicationSecret `
                -EnableSearchOnlySession:$EnableSearchOnlySession

            if (-not $Script:M365ConnectedToWorkloads -contains "$Workload-ServicePrincipalWithSecret")
            {
                $data.Add('ConnectionMode', 'ServicePrincipalWithSecret')
                if (-not $data.ContainsKey('Tenant'))
                {
                    $data.Add('Tenant', $InboundParameters.TenantId)
                }
                Add-M365DSCTelemetryEvent -Data $data -Type 'Connection'
                $Script:M365ConnectedToWorkloads += "$Workload-ServicePrincipalWithSecret"
            }
            return 'ServicePrincipalWithSecret'
        }
        else
        {
            if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('ApplicationId'))
            {
                $Script:M365DSCTelemetryConnectionToGraphParams.Add('ApplicationId', $InboundParameters.ApplicationId)
            }
            if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('TenantId'))
            {
                $Script:M365DSCTelemetryConnectionToGraphParams.Add('TenantId', $InboundParameters.TenantId)
            }
            if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('ApplicationSecret'))
            {
                $Script:M365DSCTelemetryConnectionToGraphParams.Add('ApplicationSecret', $InboundParameters.ApplicationSecret)
            }
            Connect-M365Tenant -Workload $Workload `
                -ApplicationId $InboundParameters.ApplicationId `
                -TenantId $InboundParameters.TenantId `
                -ApplicationSecret $InboundParameters.ApplicationSecret `
                -Url $Url `
                -EnableSearchOnlySession:$EnableSearchOnlySession

            if (-not $Script:M365ConnectedToWorkloads -contains "$Workload-ServicePrincipalWithSecret")
            {
                $data.Add('ConnectionMode', 'ServicePrincipalWithSecret')
                if (-not $data.ContainsKey('Tenant'))
                {
                    $data.Add('Tenant', $InboundParameters.TenantId)
                }
                Add-M365DSCTelemetryEvent -Data $data -Type 'Connection'
                $Script:M365ConnectedToWorkloads += "$Workload-ServicePrincipalWithSecret"
            }
            return 'ServicePrincipalWithSecret'
        }
    }
    elseif ($InboundParameters.CertificateThumbprint -and $InboundParameters.ApplicationId -and $InboundParameters.TenantId)
    {
        Write-Verbose -Message 'ApplicationId, TenantId, CertificateThumbprint were specified. Connecting via Service Principal'

        if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('ApplicationId'))
        {
            $Script:M365DSCTelemetryConnectionToGraphParams.Add('ApplicationId', $InboundParameters.ApplicationId)
        }
        if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('TenantId'))
        {
            $Script:M365DSCTelemetryConnectionToGraphParams.Add('TenantId', $InboundParameters.TenantId)
        }
        if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('CertificateThumbprint'))
        {
            $Script:M365DSCTelemetryConnectionToGraphParams.Add('CertificateThumbprint', $InboundParameters.CertificateThumbprint)
        }
        Write-Verbose -Message 'Calling into Connect-M365Tenant'
        Connect-M365Tenant -Workload $Workload `
            -ApplicationId $InboundParameters.ApplicationId `
            -TenantId $InboundParameters.TenantId `
            -CertificateThumbprint $InboundParameters.CertificateThumbprint `
            -Url $Url `
            -EnableSearchOnlySession:$EnableSearchOnlySession

        Write-Verbose -Message 'Connection initiated.'
        if (-not $Script:M365ConnectedToWorkloads -contains "$Workload-ServicePrincipalWithThumbprint")
        {
            $data.Add('ConnectionMode', 'ServicePrincipalWithThumbprint')
            if (-not $data.ContainsKey('Tenant'))
            {
                $data.Add('Tenant', $InboundParameters.TenantId)
            }
            Add-M365DSCTelemetryEvent -Data $data -Type 'Connection'
            $Script:M365ConnectedToWorkloads += "$Workload-ServicePrincipalWithThumbprint"
        }
        return 'ServicePrincipalWithThumbprint'
    }
    # Case only the TenantId and Credentials parameters are specified
    elseif ($null -ne $InboundParameters.Credential -and `
            -not [System.String]::IsNullOrEmpty($InboundParameters.TenantId))
    {
        if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('Credential'))
        {
            $Script:M365DSCTelemetryConnectionToGraphParams.Add('Credential', $InboundParameters.Credential)
        }
        if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('TenantId'))
        {
            $Script:M365DSCTelemetryConnectionToGraphParams.Add('TenantId', $InboundParameters.TenantId)
        }
        Connect-M365Tenant -Workload $Workload `
            -TenantId $InboundParameters.TenantId `
            -Credential $InboundParameters.Credential `
            -Url $Url `
            -EnableSearchOnlySession:$EnableSearchOnlySession

        if (-not $Script:M365ConnectedToWorkloads -contains "$Workload-CredentialsWithTenantId")
        {
            $data.Add('ConnectionMode', 'CredentialsWithTenantId')
            if (-not $data.ContainsKey('Tenant'))
            {
                $data.Add('Tenant', $InboundParameters.TenantId)
            }
            Add-M365DSCTelemetryEvent -Data $data -Type 'Connection'
            $Script:M365ConnectedToWorkloads += "$Workload-CredentialsWithTenantId"
        }
        return 'CredentialsWithTenantId'
    }
    # Case only Managed Identity and TenantId are specified
    elseif ($InboundParameters.ManagedIdentity -and `
            -not [System.String]::IsNullOrEmpty($InboundParameters.TenantId))
    {
        Write-Verbose -Message 'Connecting via managed identity'

        if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('Identity'))
        {
            $Script:M365DSCTelemetryConnectionToGraphParams.Add('Identity', $true)
        }
        if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('TenantId'))
        {
            $Script:M365DSCTelemetryConnectionToGraphParams.Add('TenantId', $InboundParameters.TenantId)
        }
        Connect-M365Tenant -Workload $Workload `
            -Identity `
            -TenantId $InboundParameters.TenantId `
            -EnableSearchOnlySession:$EnableSearchOnlySession

        if (-not $Script:M365ConnectedToWorkloads -contains "$Workload-ManagedIdentity")
        {
            $data.Add('ConnectionMode', 'ManagedIdentity')
            if (-not $data.ContainsKey('Tenant'))
            {
                $data.Add('Tenant', $InboundParameters.TenantId)
            }
            Add-M365DSCTelemetryEvent -Data $data -Type 'Connection'
            $Script:M365ConnectedToWorkloads += "$Workload-ManagedIdentity"
        }
        return 'ManagedIdentity'
    }
    # Case Access Token is Specified
    elseif ($null -ne $InboundParameters.AccessTokens -and `
            -not [System.String]::IsNullOrEmpty($InboundParameters.TenantId))
    {
        Write-Verbose -Message 'Connecting via Access Tokens'

        if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('AccessTokens'))
        {
            $Script:M365DSCTelemetryConnectionToGraphParams.Add('AccessTokens', $InboundParameters.AccessTokens)
        }

        if (-not $Script:M365DSCTelemetryConnectionToGraphParams.ContainsKey('TenantId'))
        {
            $Script:M365DSCTelemetryConnectionToGraphParams.Add('TenantId', $InboundParameters.TenantId)
        }
        Connect-M365Tenant -Workload $Workload `
            -AccessTokens $InboundParameters.AccessTokens `
            -TenantId $InboundParameters.TenantId `
            -EnableSearchOnlySession:$EnableSearchOnlySession

        if (-not $Script:M365ConnectedToWorkloads -contains "$Workload-AccessTokens")
        {
            $data.Add('ConnectionMode', 'AccessTokens')
            if (-not $data.ContainsKey('Tenant'))
            {
                $data.Add('Tenant', $InboundParameters.TenantId)
            }
            Add-M365DSCTelemetryEvent -Data $data -Type 'Connection'
            $Script:M365ConnectedToWorkloads += "$Workload-AccessTokens"
        }
        return 'AccessTokens'
    }
    else
    {
        throw 'Could not determine authentication method'
    }
}

<#
.Description
This function gets the URL of the SPO Administration site

.Functionality
Internal
#>
function Get-SPOAdministrationUrl
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [switch]
        $UseMFA,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    $UseMFASwitch = @{}
    if ($UseMFA)
    {
        $UseMFASwitch.Add('UseMFA', $true)
    }

    Write-Verbose -Message 'Connection to Azure AD is required to automatically determine SharePoint Online admin URL...'
    $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters
    Write-Verbose -Message 'Getting SharePoint Online admin URL...'
    $domain = Invoke-MgGraphRequest -Uri 'beta/domains' -Method GET
    [Array]$defaultDomain = $domain | Where-Object { ($_.id -like '*.onmicrosoft.com' -or $_.id -like '*.onmicrosoft.de' -or $_.id -like '*.onmicrosoft.us') -and $_.isInitial -eq $true } # We don't use IsDefault here because the default could be a custom domain

    if ($defaultDomain[0].id -like '*.onmicrosoft.com*')
    {
        $global:tenantName = $defaultDomain[0].id -replace '.onmicrosoft.com', ''
    }
    elseif ($defaultDomain[0].id -like '*.onmicrosoft.de*')
    {
        $global:tenantName = $defaultDomain[0].id -replace '.onmicrosoft.de', ''
    }
    $global:AdminUrl = "https://$global:tenantName-admin.sharepoint.com"
    Write-Verbose -Message "SharePoint Online admin URL is $global:AdminUrl"
    return $global:AdminUrl
}

<#
.Description
This function gets the name of the M365 tenant

.Functionality
Internal
#>
function Get-M365TenantName
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [switch]
        $UseMFA,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    $UseMFASwitch = @{}
    if ($UseMFA)
    {
        $UseMFASwitch.Add('UseMFA', $true)
    }

    Write-Verbose -Message 'Connection to Azure AD is required to automatically determine SharePoint Online admin URL...'
    $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters
    Write-Verbose -Message 'Getting SharePoint Online admin URL...'
    $domain = Invoke-MgGraphRequest -Uri 'beta/domains' -Method GET
    [Array]$defaultDomain = $domain | Where-Object { ($_.id -like '*.onmicrosoft.com' -or $_.id -like '*.onmicrosoft.de') -and $_.isInitial -eq $true } # We don't use IsDefault here because the default could be a custom domain

    if ($defaultDomain[0].id -like '*.onmicrosoft.com*')
    {
        $tenantName = $defaultDomain[0].id -replace '.onmicrosoft.com', ''
    }
    elseif ($defaultDomain[0].id -like '*.onmicrosoft.de*')
    {
        $tenantName = $defaultDomain[0].id -replace '.onmicrosoft.de', ''
    }

    Write-Verbose -Message "M365 tenant name is $tenantName"
    return $tenantName
}

<#
.Description
This function downloads and installs the Dev branch of Microsoft365DSC on the local machine

.Parameter Scope
Specifies the scope of the update of the module. The default value is AllUsers(needs to run as elevated user).

.Example
Install-M365DSCDevBranch

.Example
Install-M365DSCDevBranch -Scope CurrentUser

.Functionality
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
        $output = "$($env:Temp)\dev.zip"
        $extractPath = $env:Temp + '\O365Dev'
        Write-Host 'Done' -ForegroundColor Green

        Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing

        Expand-Archive $output -DestinationPath $extractPath -Force
        #endregion

        #region Install All Dependencies
        $manifest = Import-PowerShellDataFile "$extractPath\Microsoft365DSC-Dev\Modules\Microsoft365DSC\Microsoft365DSC.psd1"
        $dependencies = $manifest.RequiredModules
        if ((-not(([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) -and ($Scope -eq 'AllUsers'))
        {
            Write-Error 'Cannot update the dependencies for Microsoft365DSC. You need to run this command as a local administrator.'
        }
        else
        {
            foreach ($dependency in $dependencies)
            {
                Write-Host "Installing {$($dependency.ModuleName)}..." -NoNewline
                $existingModule = Get-Module $dependency.ModuleName -ListAvailable | Where-Object -FilterScript { $_.Version -eq $dependency.RequiredVersion }
                if ($null -eq $existingModule)
                {
                    Install-Module $dependency.ModuleName -RequiredVersion $dependency.RequiredVersion -Force -AllowClobber -Scope $Scope | Out-Null
                }
                Import-Module $dependency.ModuleName -Force | Out-Null
                Write-Host 'Done' -ForegroundColor Green
            }
        }
        #endregion

        #region Install M365DSC
        Write-Host 'Updating the Core Microsoft365DSC module...' -NoNewline
        $defaultPath = 'C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\'
        $currentVersionPath = $defaultPath + ([Version]$($manifest.ModuleVersion)).ToString()

        Copy-Item "$extractPath\Microsoft365DSC-Dev\Modules\Microsoft365DSC\*" `
            -Destination $defaultPath -Recurse -Force

        Import-Module ($defaultPath + 'Microsoft365DSC.psd1') -Force | Out-Null
        $oldModule = Get-Module 'Microsoft365DSC' | Where-Object -FilterScript { $_.ModuleBase -eq $currentVersionPath }
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
.Description
This function downloads all apps installed in SPO

.Functionality
Internal
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
.Description
This function removes all items that have a Null value from the provided hashtable

.Functionality
Internal
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
.Description
This function compares a created export with the specified M365DSC Blueprint

.Parameter BluePrintUrl
Specifies the url to the blueprint to which the tenant should be compared.

.Parameter OutputReportPath
Specifies the path of the report that will be created.

.Parameter Credentials
Specifies the credentials that will be used for authentication.

.Parameter ApplicationId
Specifies the application id to be used for authentication.

.Parameter ApplicationSecret
Specifies the application secret of the application to be used for authentication.

.Parameter TenantId
Specifies the id of the tenant.

.Parameter CertificateThumbprint
Specifies the thumbprint to be used for authentication.

.Parameter CertificatePassword
Specifies the password of the PFX file which is used for authentication.

.Parameter CertificatePath
Specifies the path of the PFX file which is used for authentication.

.Parameter HeaderFilePath
Specifies that file that contains a custom header for the report.

.Parameter ExcludedProperties
Specifies the name of parameters that should not be assessed as part of the report. The names speficied will apply to all resources where they are encountered.

.Parameter ExcludedResources
Specifies the name of resources that should not be assessed as part of the report.

.Parameter DriftOnly
Specifies if the report should only show properties drifts and not missing instances.

.Example
Assert-M365DSCBlueprint -BluePrintUrl 'C:\DS\blueprint.m365' -OutputReportPath 'C:\DSC\BlueprintReport.html'

.Example
Assert-M365DSCBlueprint -BluePrintUrl 'C:\DS\blueprint.m365' -OutputReportPath 'C:\DSC\BlueprintReport.html' -Credentials $credentials -HeaderFilePath 'C:\DSC\ReportCustomHeader.html'

.Example
Assert-M365DSCBlueprint -BluePrintUrl 'C:\DS\blueprint.m365' -OutputReportPath 'C:\DSC\BlueprintReport.html' -ApplicationId $clientid -TenantId $tenantId -CertificateThumbprint $certthumbprint -HeaderFilePath 'C:\DSC\ReportCustomHeader.html'

.Functionality
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

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
        $DriftOnly = $true
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add('Event', 'AssertBlueprint')
    $data.Add('BluePrint', $BluePrintUrl)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $TempBluePrintName = 'TempBlueprint_' + (New-Guid).ToString() + '.M365'
    $LocalBluePrintPath = Join-Path -Path $env:Temp -ChildPath $TempBluePrintName
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
            -Path $env:temp `
            -FileName $TempExportName `
            -Credential $Credentials `
            -ApplicationId $ApplicationId `
            -ApplicationSecret $ApplicationSecret `
            -TenantId $TenantId `
            -CertificateThumbprint $CertificateThumbprint `
            -CertificatePath $CertificatePath `
            -CertificatePassword $CertificatePassword

        # Call the New-M365DSCDeltaReport configuration to generate the Delta Report between
        # the BluePrint and the extracted resources;
        $ExportPath = Join-Path -Path $env:Temp -ChildPath $TempExportName
        New-M365DSCDeltaReport -Source $ExportPath `
            -Destination $LocalBluePrintPath `
            -OutputPath $OutputReportPath `
            -DriftOnly $DriftOnly `
            -IsBlueprintAssessment:$true `
            -HeaderFilePath $HeaderFilePath `
            -Type $Type `
            -ExcludedProperties $ExcludedProperties `
            -ExcludedResources $ExcludedResources

        # Clean up the temporary files
        Remove-Item $LocalBluePrintPath -Force -ErrorAction SilentlyContinue
        Remove-Item $ExportPath -Force -ErrorAction SilentlyContinue
    }
    else
    {
        Write-Error "M365DSC Template Path {$LocalBluePrintPath} does not exist."
    }
}

<#
.Description
This function checks if new versions are available for the M365DSC dependencies

.Example
Test-M365DSCDependenciesForNewVersions

.Functionality
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
.Description
This function installs all missing M365DSC dependencies

.Parameter Force
Specifies that all dependencies should be forcefully imported again.

.Parameter ValidateOnly
Specifies that the function should only return the dependencies that are not installed.

.Parameter Scope
Specifies the scope of the update of the module. The default value is AllUsers(needs to run as elevated user).

.PARAMETER Proxy
Specifies the proxy server to use for the module installation.

.PARAMETER Repository
Specifies the PowerShell repository name to use for the installation of the dependencies.

.Example
Update-M365DSCDependencies

.Example
Update-M365DSCDependencies -Force

.Example
Update-M365DSCDependencies -Scope CurrenUser

.Functionality
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
        [ValidateSet('CurrentUser', 'AllUsers')]
        $Scope = 'AllUsers',

        [Parameter()]
        [System.String]
        $Proxy,

        [Parameter()]
        [System.String]
        $Repository = 'PSGallery'
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
                Write-Warning -Message 'Failed to install Microsoft.PowerShell.PSResourceGet, continuing without it...'
            }
        }

        $scopedIsPsResourceGetAvailable = $Script:IsPsResourceGetAvailable
        if ($params.ContainsKey('Proxy'))
        {
            Write-Information -MessageData 'Falling back to Install-Module because Install-PSResource does not support a proxy'
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
                        if ((-not(([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) -and ($Scope -eq 'AllUsers'))
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

                        if ($scopedIsPsResourceGetAvailable)
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
.Description
This function uninstalls all previous M365DSC dependencies and older versions of the module.
.Example
Uninstall-M365DSCOutdatedDependencies
.Functionality
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
                    Remove-Item $($module.ModuleBase) -Force -Recurse
                }
            }
            catch
            {
                New-M365DSCLogEntry -Message "Could not uninstall $($module.Name) Version $($module.Version)" `
                    -Exception $_ `
                    -Source $($MyInvocation.MyCommand.Source)
                Write-Error -Message "Could not uninstall $($module.Name) Version $($module.Version)" -ErrorAction Continue
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
                            Remove-Item $($foundModule.ModuleBase) -Force -Recurse
                        }
                    }
                    catch
                    {
                        New-M365DSCLogEntry -Message "Could not uninstall $($foundModule.Name) Version $($foundModule.Version)" `
                            -Exception $_ `
                            -Source $($MyInvocation.MyCommand.Source)
                        Write-Error -Message "Could not uninstall $($foundModule.Name) Version $($foundModule.Version)" -ErrorAction Continue
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
                    Remove-Item $($foundModule.ModuleBase) -Force -Recurse
                }
            }
            catch
            {
                Write-Error -Message "Could not uninstall $($foundModule.Name) Version $($foundModule.Version)" -ErrorAction Continue
            }
        }
    }
    catch
    {
        Write-Error -Message "Could not uninstall {$($dependency.ModuleName)}" -ErrorAction Continue
    }
}

<#
.Description
This function updates the exported results with the specified authentication method

.Functionality
Internal
#>
function Update-M365DSCExportAuthenticationResults
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('ServicePrincipalWithThumbprint', 'ServicePrincipalWithSecret', 'ServicePrincipalWithPath', 'CredentialsWithTenantId', 'CredentialsWithApplicationId', 'Credentials', 'ManagedIdentity', 'AccessTokens')]
        $ConnectionMode,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Results
    )

    $noEscape = @()
    if ($Results.ContainsKey('ManagedIdentity') -and -not $Results.ManagedIdentity)
    {
        $Results.Remove('ManagedIdentity')
    }
    if ($ConnectionMode -eq 'Credentials')
    {
        $Results.Credential = Resolve-Credentials -UserName 'credential'
        $noEscape += 'Credential'
        if ($Results.ContainsKey('ApplicationId'))
        {
            $Results.Remove('ApplicationId') | Out-Null
        }
        if ($Results.ContainsKey('TenantId'))
        {
            $Results.Remove('TenantId') | Out-Null
        }
        if ($Results.ContainsKey('ApplicationSecret'))
        {
            $Results.Remove('ApplicationSecret') | Out-Null
        }
        if ($Results.ContainsKey('CertificateThumbprint'))
        {
            $Results.Remove('CertificateThumbprint') | Out-Null
        }
        if ($Results.ContainsKey('CertificatePath'))
        {
            $Results.Remove('CertificatePath') | Out-Null
        }
        if ($Results.ContainsKey('CertificatePassword'))
        {
            $Results.Remove('CertificatePassword') | Out-Null
        }
    }
    elseif ($ConnectionMode -eq 'CredentialsWithTenantId')
    {
        $Results.Credential = Resolve-Credentials -UserName 'credential'
        $noEscape += 'Credential'
        if ($Results.ContainsKey('ApplicationId'))
        {
            $Results.Remove('ApplicationId') | Out-Null
        }
        if ($Results.ContainsKey('ApplicationSecret'))
        {
            $Results.Remove('ApplicationSecret') | Out-Null
        }
        if ($Results.ContainsKey('CertificateThumbprint'))
        {
            $Results.Remove('CertificateThumbprint') | Out-Null
        }
        if ($Results.ContainsKey('CertificatePath'))
        {
            $Results.Remove('CertificatePath') | Out-Null
        }
        if ($Results.ContainsKey('CertificatePassword'))
        {
            $Results.Remove('CertificatePassword') | Out-Null
        }
    }
    else
    {
        if ($Results.ContainsKey('Credential') -and $ConnectionMode -ne 'CredentialsWithApplicationId')
        {
            $Results.Remove('Credential') | Out-Null
        }
        elseif ($Results.ContainsKey('Credential') -and $ConnectionMode -eq 'CredentialsWithApplicationId')
        {
            $Results.Credential = Resolve-Credentials -UserName 'credential'
            $noEscape += 'Credential'
        }
        if (-not [System.String]::IsNullOrEmpty($Results.ApplicationId))
        {
            $Results.ApplicationId = "`$ConfigurationData.NonNodeData.ApplicationId"
            $noEscape += 'ApplicationId'
        }
        else
        {
            try
            {
                $Results.Remove('ApplicationId') | Out-Null
            }
            catch
            {
                Write-Verbose -Message 'Error removing ApplicationId from Update-M365DSCExportAuthenticationResults'
            }
        }
        if (-not [System.String]::IsNullOrEmpty($Results.CertificateThumbprint))
        {
            $Results.CertificateThumbprint = "`$ConfigurationData.NonNodeData.CertificateThumbprint"
            $noEscape += 'CertificateThumbprint'
        }
        else
        {
            try
            {
                $Results.Remove('CertificateThumbprint') | Out-Null
            }
            catch
            {
                Write-Verbose -Message 'Error removing CertificateThumbprint from Update-M365DSCExportAuthenticationResults'
            }
        }
        if (-not [System.String]::IsNullOrEmpty($Results.CertificatePath))
        {
            $Results.CertificatePath = "`$ConfigurationData.NonNodeData.CertificatePath"
            $noEscape += 'CertificatePath'
        }
        else
        {
            try
            {
                $Results.Remove('CertificatePath') | Out-Null
            }
            catch
            {
                Write-Verbose -Message 'Error removing CertificatePath from Update-M365DSCExportAuthenticationResults'
            }
        }
        if (-not [System.String]::IsNullOrEmpty($Results.TenantId))
        {
            $Results.TenantId = "`$ConfigurationData.NonNodeData.TenantId"
            $noEscape += 'TenantId'
        }
        else
        {
            try
            {
                $Results.Remove('TenantId') | Out-Null
            }
            catch
            {
                Write-Verbose -Message 'Error removing TenantId from Update-M365DSCExportAuthenticationResults'
            }
        }
        if (-not [System.String]::IsNullOrEmpty($Results.ApplicationSecret))
        {
            $Results.ApplicationSecret = "New-Object System.Management.Automation.PSCredential ('ApplicationSecret', (ConvertTo-SecureString `$ConfigurationData.NonNodeData.ApplicationSecret -AsPlainText -Force))"
            $noEscape += 'ApplicationSecret'
        }
        else
        {
            try
            {
                $Results.Remove('ApplicationSecret') | Out-Null
            }
            catch
            {
                Write-Verbose -Message 'Error removing ApplicationSecret from Update-M365DSCExportAuthenticationResults'
            }
        }
        if ($null -ne $Results.CertificatePassword)
        {
            $Results.CertificatePassword = Resolve-Credentials -UserName 'CertificatePassword'
        }
        else
        {
            try
            {
                $Results.Remove('CertificatePassword') | Out-Null
            }
            catch
            {
                Write-Verbose -Message 'Error removing CertificatePassword from Update-M365DSCExportAuthenticationResults'
            }
        }

        if ($null -ne $Results.AccessTokens)
        {
            $results.AccessTokens = "`$ConfigurationData.NonNodeData.AccessTokens"
            $noEscape += 'AccessTokens'
        }
    }

    return @{
        Results  = $Results
        NoEscape = $noEscape
    }
}

<#
.DESCRIPTION
    This function sets the string replacement map used during export.

.FUNCTIONALITY
    Internal
#>
function Set-M365DSCStringReplacementMap
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Collections.Hashtable]
        $Map,

        [Parameter()]
        [switch]
        $Clear
    )

    if ($Clear)
    {
        $Script:M365DSCStringReplacementMap = @{}
    }

    if ($PSBoundParameters.ContainsKey('Map'))
    {
        foreach ($key in $Map.Keys)
        {
            $Script:M365DSCStringReplacementMap[$key] = $Map[$key]
        }
    }
}

<#
.DESCRIPTION
    This function returns the string replacement map used during export.

.FUNCTIONALITY
    Internal
#>
function Get-M365DSCStringReplacementMap
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return $Script:M365DSCStringReplacementMap.Clone()
}

<#
.Description
This function generates DSC string from an exported result hashtable

.Functionality
Internal
#>
function Get-M365DSCExportContentForResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('ServicePrincipalWithThumbprint', 'ServicePrincipalWithSecret', 'ServicePrincipalWithPath', 'CredentialsWithTenantId', 'CredentialsWithApplicationId', 'Credentials', 'ManagedIdentity', 'AccessTokens')]
        $ConnectionMode,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ModulePath,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Results,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String[]]
        $NoEscape,

        [Parameter()]
        [switch]
        $SkipAuthenticationUpdate,

        [Parameter()]
        [switch]
        $AllowVariablesInStrings
    )

    if (-not $SkipAuthenticationUpdate)
    {
        $withoutAuthentication = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
            -Results $Results
        $Results = $withoutAuthentication.Results
        $NoEscape += $withoutAuthentication.NoEscape
    }
    $NoEscape = $NoEscape | Select-Object -Unique

    $OrganizationName = ''
    if ($ConnectionMode -like 'ServicePrincipal*' -or `
            $ConnectionMode -eq 'ManagedIdentity')
    {
        $OrganizationName = $Results.TenantId
    }
    elseif ($null -ne $Credential.UserName)
    {
        $OrganizationName = $Credential.UserName.Split('@')[1]
    }
    else
    {
        $OrganizationName = ''
    }

    $primaryKey = ''
    $ModuleFullName = 'MSFT_' + $ResourceName
    $Resource = $Script:AllM365DSCResources.$ResourceName
    $Keys = $Resource.Properties.Where({ $_.IsMandatory }) | Select-Object -ExpandProperty Name
    if ($null -eq $keys)
    {
        if (-not (Get-Module $ModuleFullName))
        {
            Import-Module $Resource.Path -Force
        }
        $cmdInfo = Get-Command $ModuleFullName\Get-TargetResource -ErrorAction SilentlyContinue
        $Keys = $cmdInfo.Parameters.Values.Where({ $_.ParameterSets.Values.IsMandatory }).Name
    }

    if ($Keys.Contains('IsSingleInstance'))
    {
        $primaryKey = ''
    }
    elseif ($Keys.Contains('DisplayName') -and -not [System.String]::IsNullOrEmpty($Results.DisplayName))
    {
        $primaryKey = $Results.DisplayName
    }
    elseif ($Keys.Contains('Name'))
    {
        $primaryKey = $Results.Name
    }
    elseif ($Keys.Contains('Title'))
    {
        $primaryKey = $Results.Title
    }
    elseif ($Keys.Contains('Identity'))
    {
        $primaryKey = $Results.Identity
    }
    elseif ($Keys.Contains('Id'))
    {
        $primaryKey = $Results.Id
    }
    elseif ($Keys.Contains('CDNType'))
    {
        $primaryKey = $Results.CDNType
    }
    elseif ($Keys.Contains('WorkspaceName'))
    {
        $primaryKey = $Results.WorkspaceName
    }
    elseif ($Keys.Contains('OrganizationName'))
    {
        $primaryKey = $Results.OrganizationName
    }
    elseif ($Keys.Contains('DomainName'))
    {
        $primaryKey = $Results.DomainName
    }
    elseif ($Keys.Contains('UserPrincipalName'))
    {
        $primaryKey = $Results.UserPrincipalName
    }

    if ([String]::IsNullOrEmpty($primaryKey) -and -not $Keys.Contains('IsSingleInstance'))
    {
        foreach ($Key in $Keys)
        {
            $primaryKey += $Results.$Key
        }
    }

    $instanceName = $ResourceName
    if (-not [System.String]::IsNullOrEmpty($primaryKey))
    {
        if ($AllowVariablesInStrings)
        {
            $primaryKey = $primaryKey.Replace('`', '``').Replace('"', '`"')
        }
        else
        {
            $primaryKey = $primaryKey.Replace('`', '``').Replace('$', '`$').Replace('"', '`"')
        }
        $primaryKey = Update-M365DSCSpecialCharacters -String $primaryKey
        $instanceName += "-$primaryKey"
    }

    if ($Results.ContainsKey('Workload'))
    {
        $instanceName += "-$($Results.Workload)"
    }

    # Check to see if a resource with this exact name was already exported, if so, append a number to the end.
    $i = 2
    $tempName = $instanceName
    while ($null -ne $Global:M365DSCExportedResourceInstancesNames -and `
            $Global:M365DSCExportedResourceInstancesNames.Contains($tempName))
    {
        $tempName = $instanceName + '-' + $i.ToString()
        $i++
    }
    $instanceName = $tempName
    [string[]]$Global:M365DSCExportedResourceInstancesNames += $tempName

    $content = [System.Text.StringBuilder]::New()
    [void]$content.Append("        $ResourceName `"$instanceName`"`r`n")
    [void]$content.Append("        {`r`n")
    $partialContent = Get-DSCBlock -Params $Results -ModulePath $ModulePath -NoEscape $NoEscape -AllowVariablesInStrings:$AllowVariablesInStrings

    if ($partialContent.ToLower().IndexOf($OrganizationName.ToLower()) -gt 0)
    {
        $partialContent = $partialContent -ireplace [regex]::Escape($OrganizationName + ':'), "`$($OrganizationName):"
        $partialContent = $partialContent -ireplace [regex]::Escape($OrganizationName), "`$OrganizationName"
        $partialContent = $partialContent -ireplace [regex]::Escape('@' + $OrganizationName), "@`$OrganizationName"
    }

    # Apply additional string to variable replacements from mapping
    if ($null -ne $Script:M365DSCStringReplacementMap -and $Script:M365DSCStringReplacementMap.Count -gt 0)
    {
        foreach ($entry in $Script:M365DSCStringReplacementMap.GetEnumerator())
        {
            $target = $entry.Key
            $varName = $entry.Value
            if ([System.String]::IsNullOrEmpty($target) -or [System.String]::IsNullOrEmpty($varName))
            {
                Write-Verbose -Message "Skipping invalid string replacement map entry: Key = '$target', VariableName = '$varName'"
                continue
            }
            # Skip if already handled as OrganizationName
            if ($OrganizationName -and ($target -ieq $OrganizationName))
            {
                Write-Verbose -Message "Skipping replacement for target [$target] because it matches the OrganizationName: '$OrganizationName'"
                continue
            }

            if ($partialContent.ToLower().IndexOf($target.ToLower()) -gt 0)
            {
                $partialContent = $partialContent -ireplace [regex]::Escape($target + ':'), "`$(`$ConfigurationData.NonNodeData.$varName):"
                $partialContent = $partialContent -ireplace [regex]::Escape($target), "`$(`$ConfigurationData.NonNodeData.$varName)"
                $partialContent = $partialContent -ireplace [regex]::Escape('@' + $target), "@`$(`$ConfigurationData.NonNodeData.$varName)"
            }
        }
    }

    [void]$content.Append($partialContent)
    [void]$content.Append("        }`r`n")

    return $content.ToString()
}

<#
.Description
This function gets all resources that support the specified authentication method and
determines the most secure authentication method supported by the resource.

.Functionality
Internal
#>
function Get-M365DSCComponentsWithMostSecureAuthenticationType
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    param
    (
        [Parameter()]
        [System.String[]]
        [ValidateSet('ApplicationWithSecret', 'CertificateThumbprint', 'CertificatePath', 'Credentials', 'CredentialsWithTenantId', 'CredentialsWithApplicationId', 'ManagedIdentity', 'AccessTokens')]
        $AuthenticationMethod,

        [Parameter()]
        [System.String[]]
        $Resources
    )

    $modules = Get-ChildItem -Path ($PSScriptRoot + '\..\DSCResources\') -Recurse -Filter '*.psm1'
    $Components = @()
    foreach ($resource in $modules)
    {
        if ($Resources -contains ($resource.Name -replace '.psm1', '' -replace 'MSFT_', ''))
        {
            Import-Module $resource.FullName -Force -Function @('Set-TargetResource') -DisableNameChecking
            $parameters = (Get-Command 'Set-TargetResource').Parameters.Keys

            # Case - Resource supports CertificateThumbprint
            if ($AuthenticationMethod.Contains('CertificateThumbprint') -and `
                    $parameters.Contains('ApplicationId') -and `
                    $parameters.Contains('CertificateThumbprint') -and `
                    $parameters.Contains('TenantId'))
            {
                $Components += @{
                    Resource   = $resource.Name -replace 'MSFT_', '' -replace '.psm1', ''
                    AuthMethod = 'CertificateThumbprint'
                }
            }

            # Case - Resource supports CertificatePath
            elseif ($AuthenticationMethod.Contains('CertificatePath') -and `
                    $parameters.Contains('ApplicationId') -and `
                    $parameters.Contains('CertificatePath') -and `
                    $parameters.Contains('TenantId'))
            {
                $Components += @{
                    Resource   = $resource.Name -replace 'MSFT_', '' -replace '.psm1', ''
                    AuthMethod = 'CertificatePath'
                }
            }

            # Case - Resource supports ApplicationSecret
            elseif ($AuthenticationMethod.Contains('ApplicationWithSecret') -and `
                    $parameters.Contains('ApplicationId') -and `
                    $parameters.Contains('ApplicationSecret') -and `
                    $parameters.Contains('TenantId'))
            {
                $Components += @{
                    Resource   = $resource.Name -replace 'MSFT_', '' -replace '.psm1', ''
                    AuthMethod = 'ApplicationSecret'
                }
            }
            # Case - Resource supports CredentialWithTenantId
            elseif ($AuthenticationMethod.Contains('CredentialsWithTenantId') -and `
                    $parameters.Contains('Credential') -and $parameters.Contains('TenantId') -and `
                    -not $resource.Name.StartsWith('MSFT_SPO') -and `
                    -not $resource.Name.StartsWith('MSFT_OD') -and `
                    -not $resource.Name.StartsWith('MSFT_PP'))
            {
                $Components += @{
                    Resource   = $resource.Name -replace 'MSFT_', '' -replace '.psm1', ''
                    AuthMethod = 'CredentialsWithTenantId'
                }
            }
            # Case - Resource supports Credential using CredentialsWithApplicationId
            elseif ($AuthenticationMethod.Contains('CredentialsWithApplicationId') -and `
                    $parameters.Contains('Credential'))
            {
                $Components += @{
                    Resource   = $resource.Name -replace 'MSFT_', '' -replace '.psm1', ''
                    AuthMethod = 'CredentialsWithApplicationId'
                }
            }
            # Case - Resource supports Credential
            elseif ($AuthenticationMethod.Contains('Credentials') -and `
                    $parameters.Contains('Credential'))
            {
                $Components += @{
                    Resource   = $resource.Name -replace 'MSFT_', '' -replace '.psm1', ''
                    AuthMethod = 'Credentials'
                }
            }
            elseif ($AuthenticationMethod.Contains('ManagedIdentity') -and `
                    $parameters.Contains('ManagedIdentity'))
            {
                $Components += @{
                    Resource   = $resource.Name -replace 'MSFT_', '' -replace '.psm1', ''
                    AuthMethod = 'ManagedIdentity'
                }
            }
            elseif ($AuthenticationMethod.Contains('AccessTokens') -and `
                    $parameters.Contains('AccessTokens'))
            {
                $Components += @{
                    Resource   = $resource.Name -replace 'MSFT_', '' -replace '.psm1', ''
                    AuthMethod = 'AccessTokens'
                }
            }
        }
    }
    return $Components
}

<#
.Description
This function gets all available M365DSC resources in the module

.Example
Get-M365DSCAllResources

.Functionality
Public
#>
function Get-M365DSCAllResources
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    [CmdletBinding()]
    param ()

    $allResources = Get-ChildItem -Path ($PSScriptRoot + '\..\DSCResources\') -Recurse -Filter '*.psm1'
    $result = @()
    foreach ($resource in $allResources)
    {
        $result += $resource.Name -replace 'MSFT_', '' -replace '.psm1', ''
    }

    return $result
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
.Description
    This function returns the connection workloads for the specified DSC resources

.Parameter ResourceNames
    Specifies the resources for which the connection workloads should be determined.
    Either a single string, an array of strings or an object with 'Name' and 'AuthenticationMethod' can be provided.

.Example
    Get-M365DSCConnectedWorkloadList -ResourceNames AADUser

.EXAMPLE
    Get-M365DSCConnectedWorkloadList -ResourceNames @('AADUser', 'AADGroup')

.EXAMPLE
    Get-M365DSCConnectedWorkloadList -ResourceNames @{Name = 'AADUser'; AuthenticationMethod = 'Credentials'}

.Functionality
Public
#>
function Get-M365DSCConnectedWorkloadList
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true, Position = 1)]
        [System.Array]
        $ResourceNames
    )

    [Array] $workloads = @()
    foreach ($resource in $ResourceNames)
    {
        $resourceName = $resource.Name
        $authMethod = $resource.AuthenticationMethod
        if ([System.String]::IsNullOrEmpty($resourceName))
        {
            $resourceName = $resource
        }
        switch ($resourceName.Substring(0, 2).ToUpper())
        {
            'AA'
            {
                if (-not $workloads.Name -or -not $workloads.Name.Contains('MicrosoftGraph'))
                {
                    $workloads += @{
                        Name                 = 'MicrosoftGraph'
                        AuthenticationMethod = $authMethod
                    }
                }
            }
            'EX'
            {
                if (-not $workloads.Name -or -not $workloads.Name.Contains('ExchangeOnline'))
                {
                    $workloads += @{
                        Name                 = 'ExchangeOnline'
                        AuthenticationMethod = $authMethod
                    }
                }
            }
            'In'
            {
                if (-not $workloads.Name -or -not $workloads.Name.Contains('MicrosoftGraph'))
                {
                    $workloads += @{
                        Name                 = 'MicrosoftGraph'
                        AuthenticationMethod = $authMethod
                    }
                }
            }
            'O3'
            {
                if (-not $workloads.Name -or -not $workloads.Name.Contains('MicrosoftGraph') -and $resource.Name -eq 'O365Group')
                {
                    $workloads += @{
                        Name                 = 'MicrosoftGraph'
                        AuthenticationMethod = $authMethod
                    }
                }
                elseif (-not $workloads.Name -or -not $workloads.Name.Contains('ExchangeOnline'))
                {
                    $workloads += @{
                        Name                 = 'ExchangeOnline'
                        AuthenticationMethod = $authMethod
                    }
                }
            }
            'OD'
            {
                if (-not $workloads.Name -or -not $workloads.Name.Contains('PnP'))
                {
                    $workloads += @{
                        Name                 = 'PnP'
                        AuthenticationMethod = $authMethod
                    }
                }
            }
            'Pl'
            {
                if (-not $workloads.Name -or -not $workloads.Name.Contains('MicrosoftGraph'))
                {
                    $workloads += @{
                        Name                 = 'MicrosoftGraph'
                        AuthenticationMethod = $authMethod
                    }
                }
            }
            'SP'
            {
                if (-not $workloads.Name -or -not $workloads.Name.Contains('PnP'))
                {
                    $workloads += @{
                        Name                 = 'PnP'
                        AuthenticationMethod = $authMethod
                    }
                }
            }
            'SC'
            {
                if (-not $workloads.Name -or -not $workloads.Name.Contains('SecurityComplianceCenter'))
                {
                    $workloads += @{
                        Name                 = 'SecurityComplianceCenter'
                        AuthenticationMethod = $authMethod
                    }
                }
            }
            'Te'
            {
                if (-not $workloads.Name -or -not $workloads.Name.Contains('MicrosoftTeams'))
                {
                    $workloads += @{
                        Name                 = 'MicrosoftTeams'
                        AuthenticationMethod = $authMethod
                    }
                }
            }
        }
    }
    return ($workloads | Sort-Object { $_.Name })
}

<#
.Description
    This function returns the workload to which the specified DSC resources belongs.

.Parameter ResourceName
    Specifies the resources for which the workloads should be determined.
    Either a single string or an array of strings.

.Example
    Get-M365DSCWorkloadForResource -ResourceName AADUser

.EXAMPLE
    Get-M365DSCWorkloadForResource -ResourceName @('AADUser', 'AADGroup')

.Functionality
Internal
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
.Description
This function gets the used authentication mode based on the specified parameters

.Functionality
Internal
#>
function Get-M365DSCAuthenticationMode
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Parameters
    )

    if ($Parameters.ApplicationId -and $Parameters.TenantId -and $Parameters.CertificateThumbprint)
    {
        $AuthenticationType = 'ServicePrincipalWithThumbprint'
    }
    elseif ($Parameters.ApplicationId -and $Parameters.TenantId -and $Parameters.ApplicationSecret)
    {
        $AuthenticationType = 'ServicePrincipalWithSecret'
    }
    elseif ($Parameters.ApplicationId -and $Parameters.TenantId -and $Parameters.CertificatePath -and $Parameters.CertificatePassword)
    {
        $AuthenticationType = 'ServicePrincipalWithPath'
    }
    elseif ($Parameters.Credential -and $Parameters.ApplicationId)
    {
        $AuthenticationType = 'CredentialsWithApplicationId'
    }
    elseif ($Parameters.Credential)
    {
        $AuthenticationType = 'Credentials'
    }
    elseif ($Parameters.ManagedIdentity)
    {
        $AuthenticationType = 'ManagedIdentity'
    }
    elseif ($Parameters.AccessTokens)
    {
        $AuthenticationType = 'AccessTokens'
    }
    else
    {
        $AuthenticationType = 'Interactive'
    }
    return $AuthenticationType
}

<#
.Description
This function creates Markdown documentation of all public M365DSC cmdlets
and places these in the correct location of the docs folder.

.Functionality
Internal
#>
function New-M365DSCCmdletDocumentation
{
    param()

    $cmdletDocsRoot = Join-Path -Path $PSScriptRoot -ChildPath '..\..\..\docs\docs\user-guide\cmdlets'

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

                    $paramHelp = $helpInfo.parameters.parameter | Where-Object { $_.Name -eq $paramName }
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

    if ($Script:IsPowerShellCore)
    {
        $resource = Get-PwshDscResource -Name $ResourceName
    }
    else
    {
        $resource = Get-DscResource -Name $ResourceName
    }

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
.Description
This function creates an example from the resource schema, using ReverseDSC code.

.Parameter ResourceName
Specifies the resource name for which the example should be generated.

.Functionality
Internal
#>
function New-M365DSCMissingResourcesExample
{
    $location = $PSScriptRoot

    if ($Script:IsPowerShellCore)
    {
        $m365Resources = Get-PwshDscResource -Module Microsoft365DSC | Select-Object -ExpandProperty Name
    }
    else
    {
        $m365Resources = Get-DscResource -Module Microsoft365DSC | Select-Object -ExpandProperty Name
    }

    $examplesPath = Join-Path $location -ChildPath '..\..\..\Examples\Resources'
    $examples = Get-ChildItem -Path $examplesPath | Where-Object { $_.PsIsContainer } | Select-Object -ExpandProperty Name

    [array]$differences = Compare-Object -ReferenceObject $m365Resources -DifferenceObject $examples

    $count = 1
    $total = $differences.Count

    foreach ($difference in $differences)
    {
        Write-Host "[$count/$total] Processing $($difference.InputObject)"
        $path = Join-Path -Path '.\Examples\Resources' -ChildPath $difference.InputObject
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
.Description
    This function validates there are no updates to the module or it's dependencies and no multiple versions are present on the local system.

.Example
    Test-M365DSCModuleValidity

.Functionality
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
.Description
This function updates the module, dependencies and uninstalls outdated dependencies.

.Parameter Scope
Specifies the scope of the update of the module. The default value is AllUsers(needs to run as elevated user).

.PARAMETER Proxy
Specifies the proxy server to use for the update.

.PARAMETER BaseRepository
Specifies the PowerShell Repository name to use for the installation of the Microsoft365DSC module.

.PARAMETER DependencyRepository
Specifies the PowerShell Repository name to use for the installation of the dependencies of the Microsoft365DSC module.

.PARAMETER NoUninstall
Indicates if outdated dependencies and modules should be uninstalled.

.Example
Update-M365DSCModule

.Example
Update-M365DSCModule -Scope CurrentUser

.Example
Update-M365DSCModule -Scope AllUsers

.Functionality
Public
#>
function Update-M365DSCModule
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('CurrentUser', 'AllUsers')]
        $Scope = 'AllUsers',

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
            Write-Verbose -Message 'The Microsoft365DSC module might have been installed with Install-PSResource'
            if ($null -ne (Get-Module -Name Microsoft.PowerShell.PSResourceGet -ListAvailable))
            {
                Write-Verbose -Message 'Updating the Microsoft365DSC module using Update-PSResource...'
                try
                {
                    Update-PSResource -Name 'Microsoft365DSC' -Scope $Scope `
                        -TrustRepository -AcceptLicense -SkipDependencyCheck `
                        -Repository $BaseRepository -ErrorAction Stop
                }
                catch
                {
                    if ($_.Exception.Message -like '*No installed packages*')
                    {
                        Write-Verbose -Message 'Microsoft365DSC was neither installed using Install-Module nor Install-PSResource. Skipping update check.'
                    }
                    else
                    {
                        New-M365DSCLogEntry -Message 'Error Updating Module:' `
                            -Exception $_ `
                            -Source $($MyInvocation.MyCommand.Source)
                        throw $_
                    }
                }
            }
        }
    }
    try
    {
        Write-Verbose -Message 'Unloading all instances of the Microsoft365DSC module from the current PowerShell session.'
        Remove-Module Microsoft365DSC -Force

        Write-Verbose -Message 'Retrieving all versions of the Microsoft365DSC installed on the machine.'
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

<#
.Description
This function removes the authentication parameters from the hashtable.

.Functionality
Internal
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

    if ($BoundParameters.ContainsKey('Ensure'))
    {
        $BoundParameters.Remove('Ensure') | Out-Null
    }
    if ($BoundParameters.ContainsKey('Credential'))
    {
        $BoundParameters.Remove('Credential') | Out-Null
    }
    if ($BoundParameters.ContainsKey('ApplicationId'))
    {
        $BoundParameters.Remove('ApplicationId') | Out-Null
    }
    if ($BoundParameters.ContainsKey('ApplicationSecret'))
    {
        $BoundParameters.Remove('ApplicationSecret') | Out-Null
    }
    if ($BoundParameters.ContainsKey('TenantId'))
    {
        $BoundParameters.Remove('TenantId') | Out-Null
    }
    if ($BoundParameters.ContainsKey('CertificatePassword'))
    {
        $BoundParameters.Remove('CertificatePassword') | Out-Null
    }
    if ($BoundParameters.ContainsKey('CertificatePath'))
    {
        $BoundParameters.Remove('CertificatePath') | Out-Null
    }
    if ($BoundParameters.ContainsKey('CertificateThumbprint'))
    {
        $BoundParameters.Remove('CertificateThumbprint') | Out-Null
    }
    if ($BoundParameters.ContainsKey('ManagedIdentity'))
    {
        $BoundParameters.Remove('ManagedIdentity') | Out-Null
    }
    if ($BoundParameters.ContainsKey('Verbose'))
    {
        $BoundParameters.Remove('Verbose') | Out-Null
    }
    if ($BoundParameters.ContainsKey('AccessTokens'))
    {
        $BoundParameters.Remove('AccessTokens') | Out-Null
    }
    return $BoundParameters
}

<#
.Description
This function analyzes an M365DSC configuration file and returns information about potential issues (e.g., duplicate primary keys).

.Example
Get-M365DSCConfigurationConflict -ConfigurationContent "content"

.Functionality
Public
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
    if ($Script:IsPowerShellCore)
    {
        $resourcesInModule = Get-PwshDSCResource -Module 'Microsoft365DSC'
    }
    else
    {
        $currentModule = Get-Module -Name 'Microsoft365DSC'
        $resourcesInModule = Get-DscResource -Module 'Microsoft365DSC' | Where-Object Version -EQ $currentModule.Version
    }
    foreach ($component in $parsedContent)
    {
        $resourceDefinition = $resourcesInModule | Where-Object -FilterScript { $_.Name -eq $component.ResourceName }
        [Array]$mandatoryProperties = $resourceDefinition.Properties | Where-Object -FilterScript { $_.IsMandatory }
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
    Joins two or more M365DSC configurations into a single configuration.

.DESCRIPTION
    This function is used to join two or more M365DSC configurations into a single configuration.
    The function reads the configuration from the specified paths and combines them into a single configuration.
    Please note that the function won't be updating the authentication parameters if they differ between the configurations. Make sure that the authentication parameters are the same over all configurations.

.PARAMETER ConfigurationFile
    The name of the first configuration file to use as the base configuration.

.PARAMETER ConfigurationPath
    The directory path to the configuration files to join to the base configuration.

.EXAMPLE
    Join-M365DSCConfiguration -ConfigurationFile 'M365TenantConfig.ps1' -ConfigurationPath 'D:\testbed'
    This example joins the 'M365TenantConfig.ps1' file with all the configuration files in the 'D:\testbed' directory.

.FUNCTIONALITY
    Public
#>
function Join-M365DSCConfiguration
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $ConfigurationFile,

        [Parameter(Mandatory = $true)]
        [string]
        $ConfigurationPath
    )

    if ($ConfigurationFile -notlike '*.ps1')
    {
        throw 'The ConfigurationFile parameter must be a .ps1 file.'
    }

    if (-not (Test-Path -Path $ConfigurationPath))
    {
        throw 'The ConfigurationPath parameter must be a valid path.'
    }

    $ConfigurationFilePath = Join-Path -Path $ConfigurationPath -ChildPath $ConfigurationFile
    $ConfigurationPath = Join-Path -Path $ConfigurationPath -ChildPath '*'

    $baseConfiguration = ConvertTo-DSCObject -Path $ConfigurationFilePath
    $additionalConfigurations = Get-Item -Path $ConfigurationPath -Filter *.ps1 -Exclude $ConfigurationFile | ForEach-Object { ConvertTo-DSCObject -Path $_.FullName }

    $combinedArray = @($baseConfiguration) + @($additionalConfigurations)
    $combinedConfiguration = ConvertFrom-DSCObject -DSCResources $combinedArray

    # Indent all lines by 8 spaces to match the indentation of the configuration file
    $combinedConfiguration = $combinedConfiguration -replace '(?m)^', '        '
    $combinedConfiguration = $combinedConfiguration.TrimEnd()

    # Remove everything in the "Node localhost" part in the configuration file, while excluding the last two closing brackets
    $content = Get-Content -Path $ConfigurationFilePath -Raw
    $content = $content -replace '(?s)(?<=Node localhost\s*\{)(.*\s{8}\}?)(?=\s*\})', ''

    # Append the combined configuration after the "Node localhost" part in the configuration file
    $content = $content -replace '(?s)(?<=Node localhost\s*\{)', "`r`n$combinedConfiguration"

    return $content
}

<#
.DESCRIPTION
    Invokes a script-based DSC resource from a Windows PowerShell 5.1 session into a PowerShell Core session.

.PARAMETER Path
    The path to the module containing the resource.

.PARAMETER FunctionName
    The name of the function to invoke.

.PARAMETER Parameters
    The parameters to pass to the function.

.EXAMPLE
    Invoke-PowerShellCoreResource -Path 'C:\Program Files\...\DSCResources\MSFT_Resource\MSFT_Resource.psm1' -FunctionName Test-TargetResource -Parameters @{ Name = 'Value' }

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
        Import-Module -Name PSDesiredStateConfiguration -MinimumVersion 2.0.7 -ErrorAction SilentlyContinue -DisableNameChecking -SkipEditionCheck
        Import-Module -Name Microsoft365DSC -Alias @() -Cmdlet @() -Variable @() -DisableNameChecking -SkipEditionCheck
        Set-M365DSCLCMConfiguration -LCMConfig $using:lcmConfig
    }
    $script:PSCoreSessionInitialized = $true
}

<#
.Description
This function writes messages to the console or verbose output.

.PARAMETER Message
Specifies the message to write.

.PARAMETER DeferWrite
Specifies if writing the message should be deferred. Adheres to -NoNewLine behavior of Write-Host.

.PARAMETER CommitWrite
Specifies if cached messages of -DeferWrite should be combined and written.
Combining of the messages is done by joining them without any characters between.

.EXAMPLE
Write-M365DSCHost -Message "This is a message."

.Functionality
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
.DESCRIPTION
    This function sends a batch request to the Microsoft Graph API.

.PARAMETER Requests
    An array of hashtables representing the requests to be sent in the batch.
    A request hashtable should contain the following keys:
    - id: A unique identifier for the request.
    - method: The HTTP method to use (e.g., GET, POST).
    - url: The API endpoint URL.

.EXAMPLE
    $requests = @(
        @{
            id = '1'
            method = 'GET'
            url = '/users'
        }
    )
    Invoke-M365DSCGraphBatchRequest -Requests $requests
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
        $AsList
    )

    $batchResponses = [System.Collections.Generic.List[System.Collections.Hashtable]]::new()
    for ($i = 0; $i -lt $Requests.Count; $i += 20)
    {
        $batchRequestSized = $Requests[$i..([Math]::Min($i + 19, $Requests.Count - 1))]

        $request = @{
            requests = $batchRequestSized
        }

        Write-Verbose -Message "Sending BATCH Request with:`r`n$($request | ConvertTo-Json -Depth 10))"
        $batchResponses.AddRange([System.Collections.Hashtable[]](Invoke-MgGraphRequest -Method POST `
            -Uri 'beta/$batch' `
            -Body ($request | ConvertTo-Json -Depth 10) `
            -ErrorAction SilentlyContinue).responses)
    }

    if ($AsList)
    {
        return $batchResponses
    }
    return $batchResponses.ToArray()
}

<#
.DESCRIPTION
    This function splits a large M365DSC configuration file into smaller files based on size and resource count limits.

.PARAMETER Path
    The path to the M365DSC configuration file to split.

.PARAMETER OutputFolder
    The folder where the split configuration files will be saved. Defaults to the same folder as the input file.

.PARAMETER MaxFileSizeMB
    The maximum size (in megabytes) for each split configuration file. Default is 3 MB.

.PARAMETER MaxResources
    The maximum number of resources per split configuration file. Default is 0 (no limit).

.EXAMPLE
    Split-M365DSCConfiguration -Path 'C:\Configs\M365TenantConfig.ps1' -OutputFolder 'C:\Configs\Split' -MaxFileSizeMB 2 -MaxResources 50
    This example splits the 'M365TenantConfig.ps1' file into smaller files, each with a maximum size of 2 MB and a maximum of 50 resources, saving them in the 'C:\Configs\Split' folder.

.FUNCTIONALITY
    Public
#>
function Split-M365DSCConfiguration
{
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter()]
        [System.String]
        $OutputFolder = (Split-Path $Path),

        [Parameter()]
        [System.Double]
        $MaxFileSizeMB = 3,

        [Parameter()]
        [System.Int32]
        $MaxResources = 0  # 0 = ignore resource count limit
    )

    $fileContent = Get-Content -Encoding utf8 -Path $Path -Raw

    # Extract content inside "Node localhost { ... }"
    $pattern = 'Node localhost\s*{([\s\S]*)\s+}(\r|\n)+\s+}'
    $nodeMatch = [regex]::Match($fileContent, $pattern)
    if (-not $nodeMatch.Success)
    {
        throw "Could not find a 'Node localhost { ... }' block in file: $Path"
    }

    $nodeContent = $nodeMatch.Groups[1].Value

    # Extract header (everything before Node localhost)
    $header = ($fileContent -split 'Node localhost')[0] + "Node localhost`n    {`n"
    $footer = "`n    }`n}`n`nM365TenantConfig -ConfigurationData .\ConfigurationData.psd1"

    # Split into DSC resource text blocks using brace-depth parsing
    $resources = @()
    $lines = $nodeContent -split "`r?`n"
    $currentResource = [System.Text.StringBuilder]::new()
    $braceDepth = 0
    $insideResource = $false

    for ($i = 0; $i -lt $lines.Count; $i++)
    {
        $line = $lines[$i]
        # Detect resource start
        if (-not $insideResource -and $line.Trim() -match '^[a-zA-Z0-9_]+\s+"[^"]+"')
        {
            $insideResource = $true
            $null = $currentResource.Clear()
            $null = $currentResource.AppendLine($line)
            # Calculate brace depth
            $braceDepth = ($line -split '{').Count - ($line -split '}').Count
            continue
        }

        if ($insideResource)
        {
            $null = $currentResource.AppendLine($line)

            # Adjust brace depth based on line content
            $braceDepth += ($line -split '{').Count - ($line -split '}').Count

            # End of resource block
            if ($braceDepth -le 0)
            {
                $resources += '        ' + $currentResource.ToString().Trim()
                $insideResource = $false
            }
        }
    }

    if (-not $resources)
    {
        throw 'No DSC resources found in the Node block.'
    }

    # Splitting logic
    $i = 1
    $currentGroup = @()
    $currentSize = 0
    $maxBytes = $MaxFileSizeMB * 1MB

    foreach ($res in $resources)
    {
        # Calculate size of the resource in bytes
        $resBytes = [System.Text.Encoding]::UTF8.GetByteCount($res)
        $resourceCountLimitReached = ($MaxResources -gt 0 -and $currentGroup.Count -ge $MaxResources)
        $sizeLimitReached = ($currentSize + $resBytes) -gt $maxBytes

        # Write current group if limits are reached
        if (($sizeLimitReached -or $resourceCountLimitReached) -and $currentGroup.Count -gt 0)
        {
            $outPath = Join-Path $OutputFolder ('M365TenantConfig_{0}.ps1' -f $i)
            $configText = $header + ($currentGroup -join "`n") + $footer
            Set-Content -Path $outPath -Value $configText -Encoding UTF8 -Force
            Write-M365DSCHost -Message "Created: $outPath" -CommitWrite
            $i++
            $currentGroup = @()
            $currentSize = 0
        }

        $currentGroup += $res
        $currentSize += $resBytes
    }

    # Write final group
    if ($currentGroup.Count -gt 0)
    {
        $outPath = Join-Path $OutputFolder ('M365TenantConfig_{0}.ps1' -f $i)
        $configText = $header + ($currentGroup -join "`n`n") + $footer
        Set-Content -Path $outPath -Value $configText -Encoding UTF8 -Force
        Write-M365DSCHost -Message "Created: $outPath" -CommitWrite
    }
}

<#
.Description
    This function retrieves the comparison metadata for a given M365DSC resource.
    The metadata indicates whether a resource requires custom comparison logic and
    should expose a Get-CompareParameters function.

.Parameter ResourceName
    The name of the M365DSC resource (without MSFT_ prefix).

.Example
    PS> Get-M365DSCResourceComparisonMetadata -ResourceName 'AADRoleAssignmentScheduleRequest'

.Functionality
    Internal
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
        $metadataPath = Join-Path -Path $PSScriptRoot -ChildPath '..\ComparisonMetadata.json'
        if (Test-Path -Path $metadataPath)
        {
            try
            {
                $metadataContent = Get-Content -Path $metadataPath -Raw | ConvertFrom-Json
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
.Description
    This function retrieves the comparison parameters from a resource's Get-CompareParameters function.
    This is used during drift detection and reporting to ensure that resource-specific comparison logic
    (such as PostProcessing scripts and ExcludedProperties) is applied consistently.

.Parameter ResourceName
    The name of the M365DSC resource (without MSFT_ prefix).

.Example
    PS> Get-M365DSCResourceComparisonParameters -ResourceName 'AADRoleAssignmentScheduleRequest'

.Functionality
    Internal
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

        if ($null -eq $module)
        {
            $resourceModulePath = Join-Path -Path $PSScriptRoot -ChildPath "..\DSCResources\$moduleName\$moduleName.psm1"
            if (Test-Path -Path $resourceModulePath)
            {
                $previousValue = (Get-M365DSCModuleConfiguration).skipModuleDependencyValidation
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

Export-ModuleMember -Function @(
    'Assert-M365DSCBlueprint',
    'Confirm-ImportedCmdletIsAvailable',
    'Confirm-M365DSCDependencies',
    'Confirm-M365DSCModuleDependency',
    'Convert-M365DscHashtableToString',
    'ConvertTo-SPOUserProfilePropertyInstanceString',
    'Export-M365DSCConfiguration',
    'Get-AllSPOPackages',
    'Get-M365DSCAllResources',
    'Get-M365DSCAllResourcesDictionary',
    'Get-M365DSCAPIEndpoint',
    'Get-M365DSCArrayFromProperty',
    'Get-M365DSCAuthenticationMode',
    'Get-M365DSCComponentsWithMostSecureAuthenticationType',
    'Get-M365DSCConfigurationConflict',
    'Get-M365DSCConnectedWorkloadList',
    'Get-M365DSCExportContentForResource',
    'Get-M365DSCModuleConfiguration',
    'Get-M365DSCOrganization',
    'Get-M365DSCResourceComparisonMetadata',
    'Get-M365DSCResourceComparisonParameters',
    'Get-M365DSCResourcesByExportMode',
    'Get-M365DSCStringReplacementMap',
    'Get-M365DSCTelemetryConnectionParameter',
    'Get-M365DSCTenantDomain',
    'Get-M365DSCTenantNameFromParameterSet',
    'Get-M365DSCWorkloadForResource',
    'Get-M365TenantName',
    'Get-SPOAdministrationUrl',
    'Get-TeamByName',
    'Initialize-M365DSCAllResourcesDictionary',
    'Install-M365DSCDevBranch',
    'Invoke-M365DSCGraphBatchRequest',
    'Invoke-PowerShellCoreResource',
    'Join-M365DSCConfiguration',
    'New-M365DSCCmdletDocumentation',
    'New-M365DSCConnection',
    'New-M365DSCMissingResourcesExample',
    'Remove-M365DSCAuthenticationParameter',
    'Remove-NullEntriesFromHashtable',
    'Set-M365DSCAllResourcesDictionary',
    'Set-M365DSCModuleConfiguration',
    'Set-M365DSCStringReplacementMap',
    'Split-M365DSCConfiguration',
    'Test-M365DSCDependenciesForNewVersions',
    'Test-M365DSCModuleValidity',
    'Test-M365DSCParameterState',
    'Test-M365DSCTargetResource',
    'Uninstall-M365DSCOutdatedDependencies',
    'Update-M365DSCDependencies',
    'Update-M365DSCExportAuthenticationResults',
    'Update-M365DSCModule',
    'Write-M365DSCHost',
    'Import-M365DSCModuleDependency'
)
