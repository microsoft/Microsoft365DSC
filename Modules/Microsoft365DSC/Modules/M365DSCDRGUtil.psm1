Initialize-M365DSCDllLoader -ErrorAction SilentlyContinue

function Get-StringFirstCharacterToUpper
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Value
    )

    return $Value.Substring(0, 1).ToUpper() + $Value.Substring(1, $Value.Length - 1)
}

function Get-StringFirstCharacterToLower
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Value
    )

    return $Value.Substring(0, 1).ToLower() + $Value.Substring(1, $Value.Length - 1)
}

function Rename-M365DSCCimInstanceParameter
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable], [System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        $Properties,

        [Parameter(Mandatory = $false)]
        [System.Collections.Hashtable]
        $KeyMapping = @{ 'odataType' = '@odata.type' }
    )

    $result = $Properties
    $type = $Properties.GetType().FullName
    #region Array
    if ($type -like '*[[\]]')
    {
        $values = @()
        foreach ($item in $Properties)
        {
            $itemType = $item.GetType().FullName
            if ($itemType -like '*Hashtable*' -or $itemType -like '*CimInstance*' -or $itemType -like '*Object*')
            {
                try
                {
                    $values += Rename-M365DSCCimInstanceParameter -Properties $item -KeyMapping $KeyMapping
                }
                catch
                {
                    Write-Verbose -Message "Error getting values for item {$item}"
                }
            }
            else
            {
                $values += $item
            }
        }
        $result = $values

        return ,$result
    }
    #endregion

    #region Single
    if ($type -like '*Hashtable')
    {
        $result = [System.Collections.Specialized.CollectionsUtil]::CreateCaseInsensitiveHashtable([Hashtable]$Properties)
    }

    if ($type -like '*CimInstance*' -or $type -like '*Hashtable*' -or $type -like '*Object*')
    {
        $hashProperties = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $result
        $keys = ($hashProperties.Clone()).Keys

        foreach ($key in $keys)
        {
            $keyName = $key.Substring(0, 1).ToLower() + $key.Substring(1, $key.Length - 1)
            if ($key -in $KeyMapping.Keys)
            {
                $keyName = $KeyMapping.$key
            }

            $property = $hashProperties.$key

            if ($null -ne $property)
            {
                $hashProperties.Remove($key)
                try
                {
                    $subValue = Rename-M365DSCCimInstanceParameter $property -KeyMapping $KeyMapping
                    if ($null -ne $subValue)
                    {
                        $hashProperties.Add($keyName, $subValue)
                    }
                }
                catch
                {
                    Write-Verbose -Message "Error adding $property"
                }
            }
        }
        $result = $hashProperties
    }

    return $result
    #endregion
}

function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable], [System.Collections.Hashtable[]])]
    param(
        [Parameter()]
        $ComplexObject
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    if ($ComplexObject -is [array])
    {
        return [Microsoft365DSC.Converter.ComplexObjectConverter]::ToHashtableArray($ComplexObject)
    }

    return [Microsoft365DSC.Converter.ComplexObjectConverter]::ToHashtable($ComplexObject)
}

<#
    Use ComplexTypeMapping to overwrite the type of nested CIM
    Example
    $complexMapping=@(
                    @{
                        Name="ApprovalStages"
                        CimInstanceName="MSFT_MicrosoftGraphapprovalstage1"
                        IsRequired=$false
                    }
                    @{
                        Name="PrimaryApprovers"
                        CimInstanceName="MicrosoftGraphuserset"
                        IsRequired=$false
                    }
                    @{
                        Name="EscalationApprovers"
                        CimInstanceName="MicrosoftGraphuserset"
                        IsRequired=$false
                    }
                )
    With
    Name: the name of the parameter to be overwritten
    CimInstanceName: The type of the CIM instance (can include or not the prefix MSFT_)
    IsRequired: If isRequired equals true, an empty hashtable or array will be returned. Some of the Graph parameters are required even though they are empty
#>
function Get-M365DSCDRGComplexTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String], [System.String[]])]
    param(
        [Parameter()]
        $ComplexObject,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CIMInstanceName,

        [Parameter()]
        [Array]
        $ComplexTypeMapping,

        [Parameter()]
        [System.String]
        $Whitespace = '',

        [Parameter()]
        [System.uint32]
        $IndentLevel = 3,

        [Parameter()]
        [switch]
        $IsArray
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    $typeMappingList = [System.Collections.Generic.List[Microsoft365DSC.Converter.ComplexTypeMapping]]::new()
    if ($PSBoundParameters.ContainsKey('ComplexTypeMapping') -and $ComplexTypeMapping -ne $null)
    {
        foreach ($mapping in $ComplexTypeMapping)
        {
            $typeMappingList.Add($mapping)
        }
    }

    $returnValue = [Microsoft365DSC.Converter.ComplexObjectConverter]::ToDscString($ComplexObject, $CIMInstanceName, $typeMappingList, $Whitespace, $IndentLevel, $IsArray)
    if ($returnValue -is [System.Array])
    {
        return ,$returnValue
    }

    return $returnValue
}

<#
.SYNOPSIS
    Update special characters in a string to be escaped in a DSC configuration.

.DESCRIPTION
    This function updates special characters in a string to be escaped in a DSC configuration.
    The function replaces the following characters:
        - 0x201C = “
        - 0x201D = ”
        - 0x201E = „

.PARAMETER String
    The string to be updated.

.EXAMPLE
    PS> Update-M365DSCSpecialCharacters -String 'This is a test string with special characters: „, “, ”'
#>
function Update-M365DSCSpecialCharacters
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $String
    )

    return [Microsoft365DSC.Utilities.Utilities]::UpdateSpecialCharacters($String)
}

function Test-IsCimInstance
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [System.Object]
        $Object
    )

    return $null -ne $Object -and $Object.GetType().FullName -like '*CimInstance*'
}

function Test-IsHashtable
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [System.Object]
        $Object
    )

    return $null -ne $Object -and ($Object.GetType().FullName -like '*Hashtable' -or $Object.GetType().FullName -like '*OrderedDictionary')
}

function Test-IsObjectArray
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [System.Object]
        $Object
    )

    return $null -ne $Object -and $Object.GetType().Name -eq 'Object[]'
}

function Test-IsComplexArrayCandidate
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [System.Object]
        $Object
    )

    if ($null -eq $Object)
    {
        return $false
    }

    $typeName = $Object.GetType().FullName
    if ($typeName -like '*CimInstance[[\]]' -or $typeName -like '*Hashtable[[\]]')
    {
        return $true
    }

    if ($typeName -like '*Object[[\]]' -and $Object.Count -gt 0)
    {
        return ($Object[0].GetType().FullName -like '*CimInstance*' -or $Object[0].GetType().FullName -like '*Hashtable*')
    }

    return $false
}

function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        $Source,

        [Parameter()]
        $Target,

        [Parameter(Mandatory = $true)]
        [System.String]
        $PropertyName
    )

    if ($null -eq $Global:AllDrifts)
    {
        $Global:AllDrifts = @{
            DriftInfo     = @()
            CurrentValues = @{}
            DesiredValues = @{}
        }
    }

    $tuple = [Microsoft365DSC.Compare.ComplexObjectComparer]::Compare($Source, $Target, $PropertyName, $null)
    if ($tuple.Item1.Count -gt 0)
    {
        $Global:AllDrifts.DriftInfo += $tuple.Item1
    }
    return $tuple.Item2
}

function Write-M365DSCDriftsToEventLog
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.Collections.Hashtable]
        $Drifts,

        [Parameter()]
        [System.String]
        $ResourceName,

        [Parameter()]
        [System.String]
        $TenantName,

        [Parameter(Mandatory = $true)]
        [HashTable]
        $CurrentValues,

        [Parameter(Mandatory = $true)]
        [Object]
        $DesiredValues
    )

    # If ExistingDrifts is null, then this is the main call and not a recursive one. Write to the Event log.
    if ($null -ne $Drifts -and $Drifts.DriftInfo.Length -gt 0)
    {

        # Get LCMState
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

        if (-not $ResourceName.StartsWith('MSFT_'))
        {
            $ResourceName = 'MSFT_' + $ResourceName
        }

        $EventMessage = [System.Text.StringBuilder]::new()
        $EventMessage.Append("<M365DSCEvent>`r`n") | Out-Null
        $EventMessage.Append("    <ConfigurationDrift Source=`"$ResourceName`" TenantId=`"$TenantName`"") | Out-Null
        if (-not [System.String]::IsNullOrEmpty($LCMState))
        {
            $EventMessage.Append(" LCMState=`"" + $LCMState + "`"") | Out-Null
        }
        $EventMessage.Append(">`r`n") | Out-Null
        $EventMessage.Append("        <ParametersNotInDesiredState>`r`n") | Out-Null
        foreach ($drift in $Drifts.DriftInfo)
        {
            $EventMessage.Append("            <Param Name=`"$($drift.PropertyName.Replace('..', '.'))`"><CurrentValue>$($drift.CurrentValue)</CurrentValue><DesiredValue>$($drift.DesiredValue)</DesiredValue></Param>`r`n") | Out-Null
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
            $EventMessage.Append("        <Param Name =`"$($key)`">$Value</Param>`r`n") | Out-Null
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
        }
        $EventMessage.Append("    </CurrentValues>`r`n") | Out-Null
        $EventMessage.Append('</M365DSCEvent>') | Out-Null
        Write-Verbose -Message $EventMessage.ToString()
        Add-M365DSCEvent -Message $EventMessage.ToString() -EventType 'Drift' -EntryType 'Warning' `
            -EventID 1 -Source $ResourceName
    }
}

function Convert-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable], [System.Collections.Hashtable[]])]
    param(
        [Parameter(Mandatory = $true)]
        [AllowNull()]
        $ComplexObject,

        [Parameter()]
        [switch]
        $SingleLevel,

        [Parameter()]
        [switch]
        $ExcludeUnchangedProperties
    )

    if ($null -eq $ComplexObject)
    {
        return @{}
    }

    if ($SingleLevel)
    {
        $returnObject = @{}
        $keys = $ComplexObject.CimInstanceProperties | Where-Object -FilterScript { $_.Name -ne 'PSComputerName' }
        foreach ($key in $keys)
        {
            if ($ExcludeUnchangedProperties -and -not $key.IsValueModified)
            {
                continue
            }
            $propertyName = $key.Name[0].ToString().ToLower() + $key.Name.Substring(1, $key.Name.Length - 1)
            $propertyValue = $ComplexObject.$($key.Name)
            $returnObject.Add($propertyName, $propertyValue)
        }
        return $returnObject
    }

    return [Microsoft365DSC.Converter.ObjectNormalizer]::Normalize($ComplexObject)
}
