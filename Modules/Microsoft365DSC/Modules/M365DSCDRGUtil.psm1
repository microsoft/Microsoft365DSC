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
        $result = ([Hashtable]$Properties).Clone()
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

    if ($ComplexObject.GetType().FullName -like '*[[\]]')
    {
        $results = @()

        foreach ($item in $ComplexObject)
        {
            if ($item)
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                $results += $hash
            }
        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return ,[System.Collections.Hashtable[]]$results
    }

    if ($ComplexObject.GetType().FullName -like '*Dictionary*')
    {
        $results = @{}

        $ComplexObject = [hashtable]$ComplexObject
        $keys = $ComplexObject.Keys

        foreach ($key in $keys)
        {
            if ($null -ne $ComplexObject.$key)
            {
                $keyName = $key
                $keyType = $ComplexObject.$key.GetType().FullName
                if ($keyType -like '*CimInstance*' -or $keyType -like '*Dictionary*' -or $keyType -like 'Microsoft.Graph.PowerShell.Models.*' -or $keyType -like 'Microsoft.Graph.Beta.PowerShell.Models.*' -or $keyType -like '*[[\]]')
                {
                    $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$key
                    $results.Add($keyName, $hash)
                }
                else
                {
                    $results.Add($keyName, $ComplexObject.$key)
                }
            }
        }
        return $results
    }

    $results = @{}
    if ($ComplexObject.GetType().Fullname -like '*hashtable')
    {
        $keys = $ComplexObject.Keys
    }
    else
    {
        $keys = $ComplexObject | Get-Member | Where-Object -FilterScript { $_.MemberType -eq 'Property' -or $_.MemberType -eq 'NoteProperty' }
    }

    foreach ($key in $keys)
    {
        $keyName = $key
        if ($ComplexObject.GetType().FullName -notlike '*hashtable')
        {
            $keyName = $key.Name
        }

        if ($null -ne $ComplexObject.$keyName)
        {
            $keyType = $ComplexObject.$keyName.GetType().FullName
            if ($keyType -like '*CimInstance*' -or $keyType -like '*Dictionary*' -or $keyType -like 'Microsoft.Graph.*PowerShell.Models.*')
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$keyName

                if ($null -ne $hash -and ($hash.Keys.Count -gt 0 -or $hash.GetType().FullName -like '*[[\]]'))
                {
                    if ($ComplexObject.$keyName.GetType().FullName -like '*[[\]]')
                    {
                        $results.Add($keyName, @($hash))
                    }
                    else
                    {
                        $results.Add($keyName, $hash)
                    }
                }
            }
            else
            {
                $results.Add($keyName, $ComplexObject.$keyName)
            }
        }
    }
    return $results
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
    [OutputType([System.String])]
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

    $indent = ''
    for ($i = 0; $i -lt $IndentLevel; $i++)
    {
        $indent += '    '
    }

    #If ComplexObject is an Array
    if ($ComplexObject.GetType().FullName -like '*[[\]]')
    {
        $currentProperty = @()
        $IndentLevel++
        foreach ($item in $ComplexObject)
        {
            $splat = @{
                'ComplexObject'   = $item
                'CIMInstanceName' = $CIMInstanceName
                'IndentLevel'     = $IndentLevel
            }
            if ($ComplexTypeMapping)
            {
                $splat.Add('ComplexTypeMapping', $ComplexTypeMapping)
            }

            $currentProperty += Get-M365DSCDRGComplexTypeToString -IsArray @splat
        }

        # Add an indented new line after the last item in the array
        if ($currentProperty.Count -gt 0)
        {
            $currentProperty[-1] += "`r`n" + $indent
        }

        #PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , $currentProperty
    }

    $currentProperty = ''
    if ($IsArray)
    {
        $currentProperty += "`r`n"
        $currentProperty += $indent
    }

    $CIMInstanceName = $CIMInstanceName.Replace('MSFT_', '')
    $currentProperty += "MSFT_$CIMInstanceName{`r`n"
    $IndentLevel++
    $indent = '    ' * $IndentLevel
    $keyNotNull = 0

    $keys = $ComplexObject.Keys | Sort-Object
    if ($ComplexObject.Keys.Count -eq 0)
    {
        $properties = $ComplexObject | Get-Member -MemberType Properties
        if ($null -eq $properties)
        {
            return $null
        }
        else
        {
            $keys = $properties.Name
        }
    }

    foreach ($key in $keys)
    {
        if ($null -ne $ComplexObject.$key)
        {
            $keyNotNull++
            if ($ComplexObject.$key.GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*' -or $key -in $ComplexTypeMapping.Name)
            {
                $itemValue = $ComplexObject[$key]
                if ([System.String]::IsNullOrEmpty($itemValue))
                {
                    $itemValue = $ComplexObject.$key
                }
                $hashPropertyType = $itemValue.GetType().Name.ToLower()

                $IsArray = $false
                if ($itemValue.GetType().FullName -like '*[[\]]')
                {
                    $IsArray = $true
                }
                #overwrite type if object defined in mapping complextypemapping
                if ($key -in $ComplexTypeMapping.Name)
                {
                    $hashPropertyType = ([Array]($ComplexTypeMapping | Where-Object -FilterScript { $_.Name -eq $key }).CimInstanceName)[0]
                    $hashProperty = $itemValue
                }
                else
                {
                    $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $itemValue
                }

                if (-not $IsArray)
                {
                    $currentProperty += $indent + $key + ' = '
                }

                if ($IsArray -and $key -in $ComplexTypeMapping.Name)
                {
                    if ($ComplexObject.$key.Count -gt 0)
                    {
                        $currentProperty += $indent + $key + ' = '
                        $currentProperty += '@('
                    }
                }

                if ($IsArray)
                {
                    $IndentLevel++
                    for ($i = 0; $i -lt $itemValue.Count; $i++)
                    {
                        $item = $ComplexObject.$key[$i]
                        if ($ComplexObject.$key.GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*')
                        {
                            $item = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                        }
                        $nestedPropertyString = Get-M365DSCDRGComplexTypeToString `
                            -ComplexObject $item `
                            -CIMInstanceName $hashPropertyType `
                            -IndentLevel $IndentLevel `
                            -ComplexTypeMapping $ComplexTypeMapping `
                            -IsArray
                        if ([string]::IsNullOrWhiteSpace($nestedPropertyString))
                        {
                            $nestedPropertyString = "@()`r`n"
                        }
                        if ($i -ne 0)
                        {
                            # Remove the line break at the start because every item contains a trailing line break
                            # which would lead to two line breaks between each item
                            $nestedPropertyString = $nestedPropertyString.Substring(2)
                        }
                        $currentProperty += $nestedPropertyString
                        if (-not $currentProperty.EndsWith("`r`n"))
                        {
                            $currentProperty += "`r`n"
                        }
                    }
                    $IndentLevel--
                }
                else
                {
                    $nestedPropertyString = Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $hashProperty `
                        -CIMInstanceName $hashPropertyType `
                        -IndentLevel $IndentLevel `
                        -ComplexTypeMapping $ComplexTypeMapping
                    if ([string]::IsNullOrWhiteSpace($nestedPropertyString))
                    {
                        $nestedPropertyString = "`$null`r`n"
                    }
                    $currentProperty += $nestedPropertyString + "`r`n"
                }
                if ($IsArray)
                {
                    if ($ComplexObject.$key.Count -gt 0)
                    {
                        $currentProperty += $indent
                        $currentProperty += ')'
                        $currentProperty += "`r`n"
                    }
                }
                $IsArray = $PSBoundParameters.IsArray
            }
            else
            {
                $currentValue = $ComplexObject[$key]
                if ([System.String]::IsNullOrEmpty($currentValue))
                {
                    $currentValue = $ComplexObject.$key
                }
                if (-not [System.String]::IsNullOrEmpty($currentValue) -and $currentValue.GetType().Name -ne 'Dictionary`2')
                {
                    if ($currentValue.GetType().Name -eq 'String')
                    {
                        $currentValue = $currentValue.Replace('�', "''")
                    }
                    $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $currentValue -Space ($indent)
                }
            }
        }
        else
        {
            $mappedKey = $ComplexTypeMapping | Where-Object -FilterScript { $_.name -eq $key }

            if ($mappedKey -and $mappedKey.isRequired)
            {
                if ($mappedKey.IsArray)
                {
                    $currentProperty += "$indent$key = @()`r`n"
                }
                else
                {
                    $currentProperty += "$indent$key = `$null`r`n"
                }
            }
        }
    }

    $indent = ''
    $indent = '    ' * ($IndentLevel - 1)

    if ($key -in $ComplexTypeMapping.Name -and -not $currentProperty.EndsWith("`r`n"))
    {
        $currentProperty += "`r`n"
    }

    $currentProperty += "$indent}"
    $emptyCIM = $currentProperty.Replace(' ', '').Replace("`r`n", '')
    if ($emptyCIM -eq "MSFT_$CIMInstanceName{}")
    {
        $currentProperty = [string]::Empty
    }

    return $currentProperty
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

    $String = $String.Replace("$([char]0x201C)", "``$([char]0x201C)")
    $String = $String.Replace("$([char]0x201D)", "``$([char]0x201D)")
    $String = $String.Replace("$([char]0x201E)", "``$([char]0x201E)")

    return $String
}

function Get-M365DSCDRGSimpleObjectTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter(Mandatory = $true)]
        $Value,

        [Parameter()]
        [System.String]
        $Space = '                '
    )

    $returnValue = ''
    switch -Wildcard ($Value.GetType().Fullname )
    {
        '*.Boolean'
        {
            $returnValue = $Space + $Key + " = `$" + $Value.ToString() + "`r`n"
        }
        '*.String'
        {
            if ($key -eq '@odata.type')
            {
                $key = 'odataType'
            }

            $newString = $Value.Replace('`', '``').Replace('$', '`$')
            $newString = Update-M365DSCSpecialCharacters -String $newString
            $newString = $newString.Replace('"', '`"')
            $returnValue = $Space + $Key + ' = "' + $newString + """`r`n"
        }
        '*.DateTime'
        {
            $returnValue = $Space + $Key + ' = "' + $Value + """`r`n"
        }
        '*[[\]]'
        {
            $returnValue = $Space + $key + ' = @('
            $whitespace = ''
            $newline = ''
            if ($Value.Count -gt 1)
            {
                $returnValue += "`r`n"
                $whitespace = $Space + '    '
                $newline = "`r`n"
            }
            foreach ($item in ($Value | Where-Object -FilterScript { $null -ne $_ }))
            {
                switch -Wildcard ($item.GetType().Fullname)
                {
                    '*.String'
                    {
                        $item = $item.Replace('`', '``').Replace('$', '`$').Replace('"', '`"')
                        $returnValue += "$whitespace""$item""$newline"
                    }
                    '*.DateTime'
                    {
                        $returnValue += "$whitespace""$item""$newline"
                    }
                    default
                    {
                        $returnValue += "$whitespace$item$newline"
                    }
                }
            }

            if ($Value.Count -gt 1)
            {
                $returnValue += "$Space)`r`n"
            }
            else
            {
                $returnValue += ")`r`n"

            }
        }
        default
        {
            $returnValue = $Space + $Key + ' = ' + $Value + "`r`n"
        }
    }

    return $returnValue
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
        $PropertyName,

        [Parameter()]
        [System.String[]]
        $PrimaryKeys,

        [Parameter()]
        [switch]
        $NoDriftReport
    )

    # Check if global drift variables are initialized. This is usually done in Compare-M365DSCResourceState,
    # but if this function is called directly, they must be initialized to avoid issues when referincing them in ComparePairIterative
    if ($null -eq $Global:AllDrifts)
    {
        $Global:AllDrifts = @{
            DriftInfo     = @()
            CurrentValues = @{}
            DesiredValues = @{}
        }
        $Global:PotentialDrifts = @()
    }

    # Compare two arbitrary objects iteratively (no recursion). Returns $true if identical (no drift).
    # This function will append potential drifts to $Global:PotentialDrifts if $NoDriftReport is $true, otherwise will append to $Global:AllDrifts.DriftInfo on real drifts.
    function ComparePairIterative
    {
        param
        (
            [Parameter()]
            $Left,

            [Parameter()]
            $Right,

            [Parameter()]
            [System.String]
            $PropName,

            [Parameter()]
            [switch]
            $LocalNoDriftReport
        )

        # Use a stack of frames. Each frame describes a comparison that needs processing.
        # Frame fields:
        #   Left, Right, PropName, Stage, KeysEnumerator, TargetKeys, ArrayState
        $workStack = [System.Collections.Stack]::new()

        $workStack.Push(@{
            Left     = $Left
            Right    = $Right
            PropName = $PropName
            # Stage describes what to do: 'compare' for top-level handling
            Stage    = 'compare'
        })

        # result means: if we encounter an unrecoverable drift we return $false
        $result = $true

        while ($workStack.Count -gt 0 -and $result)
        {
            $frame = $workStack.Pop()
            $l = $frame.Left
            $r = $frame.Right
            $p = $frame.PropName

            # Both null => identical for this frame
            if ($null -eq $l -and $null -eq $r)
            {
                continue
            }

            # One null and the other not => drift
            if (($null -eq $l) -xor ($null -eq $r))
            {
                $sourceValue = if ($null -eq $l)
                {
                    'Desired value is null'
                }
                else
                {
                    'Desired value is NOT null'
                }
                $targetValue = if ($null -eq $r)
                {
                    'Current value is null'
                }
                else
                {
                    'Current value is NOT null'
                }

                Write-Verbose -Message "Configuration drift - Complex object: {$sourceValue$targetValue}"
                $drift = @{
                    PropertyName = $p
                    CurrentValue = $targetValue
                    DesiredValue = $sourceValue
                }

                if (-not $LocalNoDriftReport)
                {
                    $Global:AllDrifts.DriftInfo += $drift
                }
                else
                {
                    $Global:PotentialDrifts += $drift
                }

                $result = $false
                break
            }

            # If left is an array of complex objects, handle array logic (order-insensitive)
            if (Test-IsComplexArrayCandidate -Object $l)
            {
                # If counts differ, record drift (original did that)
                if ($l.Count -ne $r.Count)
                {
                    Write-Verbose -Message "Configuration drift - The complex array have different number of items: Source {$($l.Count)}, Target {$($r.Count)}"
                    $Global:AllDrifts.DriftInfo += @{
                        PropertyName = $p
                        CurrentValue = "Current value has {$($r.Count)} items"
                        DesiredValue = "Desired value has {$($l.Count)} items"
                    }
                    $result = $false
                    break
                }

                # Intune special-case: original did type-specific handling
                if ((Test-IsCimInstance $l[0]) -and `
                    ($l[0].CimClass.CimClassName -eq 'MSFT_DeviceManagementConfigurationPolicyAssignments' -or `
                            $l[0].CimClass.CimClassName -eq 'MSFT_DeviceManagementMobileAppAssignment' -or `
                        ($l[0].CimClass.CimClassName -like 'MSFT_Intune*Assignments' -and `
                                $l[0].CimClass.CimClassName -ne 'MSFT_IntuneDeviceRemediationPolicyAssignments')))
                {
                    $compareResult = Compare-M365DSCIntunePolicyAssignment -Source @($l) -Target @($r)
                    if (-not $compareResult)
                    {
                        Write-Verbose -Message "Configuration drift - Intune Policy Assignment: $p"
                        $Global:AllDrifts.DriftInfo += @{
                            PropertyName = $p
                            CurrentValue = $r
                            DesiredValue = $l
                        }
                        $result = $false
                    }
                    continue
                }

                # For arrays: we must find for each source element a matching distinct target element
                # We'll keep a boolean array for consumed target elements
                $consumed = [bool[]]::CreateInstance([bool], $r.Count)
                for ($i = 0; $i -lt $l.Count; $i++)
                {
                    $srcItem = $l[$i]
                    $found = $false
                    $lastCompareResult = $null

                    for ($j = 0; $j -lt $r.Count; $j++)
                    {
                        if ($consumed[$j])
                        {
                            continue
                        }
                        $tgtItem = $r[$j]

                        # snapshot potential drifts count so we can rollback/preserve them according to outcome
                        if ($null -eq $Global:PotentialDrifts)
                        {
                            $potentialStart = 0
                        }
                        else
                        {
                            $potentialStart = $Global:PotentialDrifts.Count
                        }

                        # Compare srcItem vs tgtItem using a *fresh* iterative compare that records potential drifts
                        $pairEqual = ComparePairIterativeInner -Left $srcItem -Right $tgtItem -PropName ("$p[$i]") -LocalNoDriftReport:$true

                        $lastCompareResult = $pairEqual

                        if ($pairEqual)
                        {
                            # Consume this target element
                            $consumed[$j] = $true
                            # Remove any potential drifts produced during this successful attempt
                            if ($Global:PotentialDrifts.Count -gt $potentialStart)
                            {
                                # Delete the appended entries from potential drifts (they were false alarms)
                                $Global:PotentialDrifts = $Global:PotentialDrifts[0..($potentialStart - 1)]
                            }
                            $found = $true
                            break
                        }
                        else
                        {
                            # Attempt failed: if there were potential drifts appended during attempt, promote last to AllDrifts (original logic)
                            if ($Global:PotentialDrifts.Count -gt $potentialStart)
                            {
                                $lastIndex = $Global:PotentialDrifts.Count - 1
                                if ($null -ne $Global:PotentialDrifts[$lastIndex])
                                {
                                    $Global:AllDrifts.DriftInfo += $Global:PotentialDrifts[$lastIndex]
                                }
                                # reset potential drifts
                                $Global:PotentialDrifts = @()
                            }
                            # try next candidate
                        }
                    }

                    if (-not $found)
                    {
                        Write-Verbose -Message 'Configuration drift - The complex array items are not identical'
                        # If no attempts happened (r was empty) or lastCompareResult is $null, record AllDrifts as original did
                        if ($null -eq $lastCompareResult)
                        {
                            $Global:AllDrifts.DriftInfo += @{
                                PropertyName = ("$p[$i]")
                                CurrentValue = $r
                                DesiredValue = $l
                            }
                        }
                        $result = $false
                        break
                    }
                }

                # After finishing array matching loop, continue to next frame
                continue
            }

            # Now handle non-array (single) complex objects or simple objects
            # Build keys for Left (source)
            if (Test-IsCimInstance -Object $l)
            {
                $keys = @()
                $l.CimInstanceProperties | ForEach-Object {
                    if ($_.Name -notin @('PSComputerName', 'CimClass', 'CimInstanceProperties', 'CimSystemProperties') -and $_.IsValueModified)
                    {
                        $keys += $_.Name
                    }
                }
            }
            else
            {
                # hashtable or ordered dictionary
                $keys = $l.Keys | Where-Object { $_ -ne 'PSComputerName' }
            }

            # Determine keys for Right (target)
            if (Test-IsCimInstance -Object $r)
            {
                $targetKeys = @()
                $r.CimInstanceProperties | ForEach-Object {
                    if ($_.Name -notin @('PSComputerName', 'CimClass', 'CimInstanceProperties', 'CimSystemProperties') -and $_.IsValueModified)
                    {
                        $targetKeys += $_.Name
                    }
                }
            }
            elseif (Test-IsHashtable -Object $r)
            {
                $targetKeys = $r.Keys | Where-Object { $_ -ne 'PSComputerName' }
            }
            else
            {
                # Fallback, possibly Microsoft Graph model -> convert
                $r = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $r
                $targetKeys = $r.Keys | Where-Object { $_ -ne 'PSComputerName' }
            }

            foreach ($key in $keys)
            {
                # Check presence in target
                $keyExistsInTarget = (
                    ($r.GetType().Name -eq 'Hashtable' -and $r.ContainsKey($key)) -or `
                    ($r.GetType().Name -eq 'OrderedDictionary' -and $r.Contains($key)) -or `
                    ($r.GetType().Name -eq 'CIMInstance' -and $null -ne $r.$key)
                )

                if (-not $keyExistsInTarget)
                {
                    continue
                }

                $sourceValue = $l.$key
                $targetValue = $null
                if ($key -in $targetKeys)
                {
                    $targetValue = $r.$key
                }

                # One null and the other not => drift
                if (($null -eq $sourceValue) -xor ($null -eq $targetValue))
                {
                    if ($null -eq $sourceValue)
                    {
                        $sv = 'null'
                    }
                    else
                    {
                        $sv = $sourceValue
                    }
                    if ($null -eq $targetValue)
                    {
                        $tv = 'null'
                    }
                    else
                    {
                        $tv = $targetValue
                    }
                    Write-Verbose -Message "Configuration drift - key: $key"
                    Write-Verbose -Message "Source {$sv}"
                    Write-Verbose -Message "Target {$tv}"
                    $drift = @{
                        PropertyName = $p + '.' + $key
                        CurrentValue = $targetValue
                        DesiredValue = $sourceValue
                    }
                    if (-not $LocalNoDriftReport)
                    {
                        $Global:AllDrifts.DriftInfo += $drift
                    }
                    else
                    {
                        $Global:PotentialDrifts += $drift
                    }
                    $result = $false
                    break
                }

                if ($null -ne $sourceValue -and $null -ne $targetValue)
                {
                    # complex nested types
                    if ((Test-IsCimInstance -Object $sourceValue) -or (Test-IsHashtable -Object $sourceValue) -or $sourceValue.GetType().FullName -like '*OrderedDictionary*' -or (Test-IsObjectArray -Object $sourceValue))
                    {
                        # Intune assignment special-case
                        if ((Test-IsCimInstance -Object $sourceValue) -and (
                                $sourceValue.CimClass.CimClassName -eq 'MSFT_DeviceManagementConfigurationPolicyAssignments' -or
                                $sourceValue.CimClass.CimClassName -eq 'MSFT_DeviceManagementMobileAppAssignment' -or
                                $sourceValue.CimClass.CimClassName -like 'MSFT_Intune*Assignments'
                            ))
                        {
                            $compareResult = Compare-M365DSCIntunePolicyAssignment -Source @($sourceValue) -Target @($targetValue)
                            if (-not $compareResult)
                            {
                                Write-Verbose -Message "Configuration drift - Intune Policy Assignment key: $key"
                                $Global:AllDrifts.DriftInfo += @{
                                    PropertyName = ($p + '.' + $key)
                                    CurrentValue = $targetValue
                                    DesiredValue = $sourceValue
                                }
                                $result = $false
                                break
                            }
                            else
                            {
                                continue
                            }
                        }
                        else
                        {
                            # push a new frame to compare nested complex objects
                            $workStack.Push(@{
                                    Left     = $sourceValue
                                    Right    = $targetValue
                                    PropName = ($p + '.' + $key)
                                    Stage    = 'compare'
                                })
                            continue
                        }
                    }

                    # Simple types: do comparisons similar to original
                    $referenceObject = $targetValue
                    $differenceObject = $sourceValue

                    $sourceType = ($sourceValue.GetType()).Name
                    $targetType = ($targetValue.GetType()).Name

                    $compareResult = $null

                    if ($targetType -like '*Date*')
                    {
                        try
                        {
                            $compareResult = ([DateTime]$sourceValue) -eq ([DateTime]$targetValue)
                        }
                        catch
                        {
                            $compareResult = $null
                        }
                    }
                    elseif ($targetType -eq 'String')
                    {
                        if (-not [System.String]::IsNullOrEmpty($referenceObject))
                        {
                            $referenceObject = $referenceObject.Replace("`r`n", "`n")
                        }
                        if (-not [System.String]::IsNullOrEmpty($differenceObject) -and $sourceType -eq 'String')
                        {
                            $differenceObject = $differenceObject.Replace("`r`n", "`n")
                        }

                        $ordinalComparison = [System.String]::Equals($referenceObject, $differenceObject, [System.StringComparison]::OrdinalIgnoreCase)
                        if (-not $ordinalComparison)
                        {
                            $compareResult = $false
                        }
                        else
                        {
                            $compareResult = $true
                        }
                    }
                    else
                    {
                        $diff = Compare-Object -ReferenceObject $referenceObject -DifferenceObject $differenceObject -PassThru
                        $compareResult = $diff.Count -eq 0
                    }

                    if ($null -ne $compareResult -and -not $compareResult)
                    {
                        Write-Verbose -Message "Configuration drift - simple object key: $key"
                        Write-Verbose -Message "Source {$sourceValue}"
                        Write-Verbose -Message "Target {$targetValue}"
                        $drift = @{
                            PropertyName = ($p + '.' + $key)
                            CurrentValue = $targetValue
                            DesiredValue = $sourceValue
                        }
                        if (-not $LocalNoDriftReport)
                        {
                            $Global:AllDrifts.DriftInfo += $drift
                        }
                        else
                        {
                            $Global:PotentialDrifts += $drift
                        }
                        $result = $false
                        break
                    }
                } # end both non-null branch
            } # end foreach key
        } # end while stack

        return $result
    } # end ComparePairIterative

    #
    # Inner worker used for attempts when matching array elements.
    # Important: this is an inner isolated iterator that behaves exactly like ComparePairIterative but is referenced by name so we can call it repeatedly.
    #
    function ComparePairIterativeInner
    {
        param(
            [Parameter()]
            $Left,

            [Parameter()]
            $Right,

            [Parameter()]
            [System.String]
            $PropName,

            [Parameter()]
            [switch]
            $LocalNoDriftReport
        )

        return (ComparePairIterative -Left $Left -Right $Right -PropName $PropName -LocalNoDriftReport:$LocalNoDriftReport)
    }

    # Start the top-level comparison using the iterative comparator
    $final = ComparePairIterative -Left $Source -Right $Target -PropName $PropertyName -LocalNoDriftReport:$NoDriftReport

    return $final
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

    if ($ComplexObject.GetType().Fullname -like '*[[\]]')
    {
        $results = @()
        foreach ($item in $ComplexObject)
        {
            $hash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            $results += $hash
        }

        #Write-Verbose -Message ("Convert-M365DSCDRGComplexTypeToHashtable >>> results: "+(convertTo-JSON $results -Depth 20))
        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return ,[System.Collections.Hashtable[]]$results
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

    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject

    if ($null -ne $hashComplexObject)
    {
        $results = $hashComplexObject.Clone()
        if ($SingleLevel)
        {
            return $results
        }

        $keys = $hashComplexObject.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
        foreach ($key in $keys)
        {
            if ($hashComplexObject[$key] -and $hashComplexObject[$key].GetType().Fullname -like '*CimInstance*')
            {
                $results[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            else
            {
                $propertyName = $key[0].ToString().ToLower() + $key.Substring(1, $key.Length - 1)
                $propertyValue = $results[$key]
                $results.Remove($key) | Out-Null
                $results.Add($propertyName, $propertyValue)
            }
        }
    }

    return $results
}

function ConvertFrom-IntunePolicyAssignment
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable[]])]
    param (
        [Parameter(Mandatory = $true)]
        [Array]
        $Assignments,

        [Parameter()]
        [System.Boolean]
        $IncludeDeviceFilter = $true
    )

    if ($null -eq $Script:IntuneAssignmentFilters)
    {
        $Script:IntuneAssignmentFilters = Get-MgBetaDeviceManagementAssignmentFilter -All -ErrorAction SilentlyContinue | ForEach-Object {
            @{
                FilterId    = $_.Id
                DisplayName = $_.DisplayName
            }
        }
    }

    $assignmentResult = @()
    foreach ($assignment in $Assignments)
    {
        $hashAssignment = [ordered]@{}
        if ($null -ne $assignment.Target.'@odata.type')
        {
            $dataType = $assignment.Target.'@odata.type'
        }
        else
        {
            $dataType = $assignment.Target.AdditionalProperties.'@odata.type'
        }

        if ($null -ne $assignment.Target.groupId)
        {
            $groupId = $assignment.Target.groupId
        }
        else
        {
            $groupId = $assignment.Target.AdditionalProperties.groupId
        }

        if ($null -ne $assignment.Target.collectionId)
        {
            $collectionId = $assignment.Target.collectionId
        }
        else
        {
            $collectionId = $assignment.Target.AdditionalProperties.collectionId
        }

        $hashAssignment.Add('dataType', $dataType)
        if (-not [string]::IsNullOrEmpty($groupId))
        {
            $hashAssignment.Add('groupId', $groupId)

            $group = Get-MgGroup -GroupId ($groupId) -ErrorAction SilentlyContinue
            if ($null -ne $group)
            {
                $groupDisplayName = $group.DisplayName
            }
        }
        if ($dataType -eq '#microsoft.graph.allLicensedUsersAssignmentTarget')
        {
            $groupDisplayName = 'All users'
        }
        if ($dataType -eq '#microsoft.graph.allDevicesAssignmentTarget')
        {
            $groupDisplayName = 'All devices'
        }
        if ($null -ne $groupDisplayName)
        {
            $hashAssignment.Add('groupDisplayName', $groupDisplayName)
        }
        if (-not [string]::IsNullOrEmpty($collectionId))
        {
            $hashAssignment.Add('collectionId', $collectionId)
        }
        if ($IncludeDeviceFilter)
        {
            if ($null -ne $assignment.Target.DeviceAndAppManagementAssignmentFilterType)
            {
                $hashAssignment.Add('deviceAndAppManagementAssignmentFilterType', $assignment.Target.DeviceAndAppManagementAssignmentFilterType.ToString())
            }
            if ($null -ne $assignment.Target.DeviceAndAppManagementAssignmentFilterId)
            {
                $filterId = $assignment.Target.DeviceAndAppManagementAssignmentFilterId
                $hashAssignment.Add('deviceAndAppManagementAssignmentFilterId', $filterId)
                $hashAssignment.Add('deviceAndAppManagementAssignmentFilterDisplayName', (($Script:IntuneAssignmentFilters | Where-Object -FilterScript { $_.FilterId -eq $filterId }).DisplayName))
            }
        }

        $assignmentResult += $hashAssignment
    }

    return ,[System.Collections.Hashtable[]]$assignmentResult
}

function ConvertTo-IntunePolicyAssignment
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param (
        [Parameter(Mandatory = $true)]
        [AllowNull()]
        $Assignments,

        [Parameter()]
        [System.Boolean]
        $IncludeDeviceFilter = $true
    )

    if ($null -eq $Script:IntuneAssignmentFilters)
    {
        $Script:IntuneAssignmentFilters = Get-MgBetaDeviceManagementAssignmentFilter -All -ErrorAction SilentlyContinue | ForEach-Object {
            @{
                FilterId    = $_.Id
                DisplayName = $_.DisplayName
            }
        }
    }

    if ($null -eq $Assignments)
    {
        return ,@()
    }

    $assignmentResult = @()
    foreach ($assignment in $Assignments)
    {
        $target = @{
            '@odata.type' = $assignment.dataType
        }
        if ($IncludeDeviceFilter)
        {
            if ($null -ne $assignment.DeviceAndAppManagementAssignmentFilterType -and $assignment.DeviceAndAppManagementAssignmentFilterType -ne 'none')
            {
                $filter = $Script:IntuneAssignmentFilters | Where-Object -FilterScript { $_.FilterId -eq $assignment.DeviceAndAppManagementAssignmentFilterId }
                if ($null -eq $filter)
                {
                    $filter = $Script:IntuneAssignmentFilters | Where-Object -FilterScript { $_.DisplayName -eq $assignment.DeviceAndAppManagementAssignmentFilterDisplayName }
                    if ($null -eq $filter)
                    {
                        Write-Warning -Message "Assignment filter with DisplayName {$($assignment.DeviceAndAppManagementAssignmentFilterDisplayName)} not found in the directory. Please update your DSC resource extract with the correct filterId or filterDisplayName."
                    }
                }

                if ($null -ne $filter)
                {
                    $target.Add('deviceAndAppManagementAssignmentFilterType', $assignment.DeviceAndAppManagementAssignmentFilterType)
                    $target.Add('deviceAndAppManagementAssignmentFilterId', $filter.FilterId)
                }
            }
        }
        if ($assignment.dataType -like '*CollectionAssignmentTarget')
        {
            $target.Add('collectionId', $assignment.collectionId)
        }
        elseif ($assignment.dataType -like '*GroupAssignmentTarget')
        {
            $group = $null
            if (-not [System.String]::IsNullOrEmpty($assignment.groupId))
            {
                $group = Get-MgGroup -GroupId ($assignment.groupId) -ErrorAction SilentlyContinue
            }
            if ($null -eq $group -and -not [System.String]::IsNullOrEmpty($assignment.groupDisplayName))
            {
                $escapedName = $assignment.groupDisplayName -replace "'", "''"
                $group = Get-MgGroup -Filter "DisplayName eq '$escapedName'" -All -ErrorAction SilentlyContinue
                if ($null -eq $group)
                {
                    Write-Warning "Skipping assignment: groupDisplayName '{$($assignment.groupDisplayName)}' not found."
                    $target = $null
                }
                elseif ($group.Count -gt 1)
                {
                    Write-Warning "Skipping assignment: groupDisplayName '{$($assignment.groupDisplayName)}' is not unique."
                    $target = $null
                }
            }
            # If group found, add its ID
            if ($null -ne $group)
            {
                $target.Add('groupId', $group.Id)
            }
            elseif ($null -eq $group -and [System.String]::IsNullOrEmpty($assignment.groupDisplayName))
            {
                Write-Warning 'Skipping assignment: missing both groupId and groupDisplayName.'
                $target = $null
            }
        }

        if ($target)
        {
            $assignmentResult += @{ target = $target }
        }
    }

    return ,$assignmentResult
}

function ConvertFrom-IntuneMobileAppAssignment
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable[]])]
    param (
        [Parameter(Mandatory = $true)]
        [Array]
        $Assignments,

        [Parameter()]
        [System.Boolean]
        $IncludeDeviceFilter = $true
    )

    if ($null -eq $Script:IntuneAssignmentFilters)
    {
        $Script:IntuneAssignmentFilters = Get-MgBetaDeviceManagementAssignmentFilter -All -ErrorAction SilentlyContinue | ForEach-Object {
            @{
                FilterId    = $_.Id
                DisplayName = $_.DisplayName
            }
        }
    }

    $assignmentResult = @()
    foreach ($assignment in $Assignments)
    {
        $hashAssignment = @{}
        if ($null -ne $assignment.Target.'@odata.type')
        {
            $dataType = $assignment.Target.'@odata.type'
        }
        else
        {
            $dataType = $assignment.Target.AdditionalProperties.'@odata.type'
        }

        if ($null -ne $assignment.Target.groupId)
        {
            $groupId = $assignment.Target.groupId
        }
        else
        {
            $groupId = $assignment.Target.AdditionalProperties.groupId
        }

        $hashAssignment.Add('dataType', $dataType)
        if (-not [string]::IsNullOrEmpty($groupId))
        {
            $hashAssignment.Add('groupId', $groupId)

            $group = Get-MgGroup -GroupId ($groupId) -ErrorAction SilentlyContinue
            if ($null -ne $group)
            {
                $groupDisplayName = $group.DisplayName
            }
        }

        if ($dataType -eq '#microsoft.graph.allLicensedUsersAssignmentTarget')
        {
            $groupDisplayName = 'All users'
        }
        if ($dataType -eq '#microsoft.graph.allDevicesAssignmentTarget')
        {
            $groupDisplayName = 'All devices'
        }
        if ($null -ne $groupDisplayName)
        {
            $hashAssignment.Add('groupDisplayName', $groupDisplayName)
        }

        $hashAssignment.Add('intent', $assignment.intent.ToString())

        if ($IncludeDeviceFilter)
        {
            if ($null -ne $assignment.Target.DeviceAndAppManagementAssignmentFilterType)
            {
                $hashAssignment.Add('deviceAndAppManagementAssignmentFilterType', $assignment.Target.DeviceAndAppManagementAssignmentFilterType.ToString())
            }
            if ($null -ne $assignment.Target.DeviceAndAppManagementAssignmentFilterId)
            {
                $filterId = $assignment.Target.DeviceAndAppManagementAssignmentFilterId
                $hashAssignment.Add('deviceAndAppManagementAssignmentFilterId', $filterId)
                $hashAssignment.Add('deviceAndAppManagementAssignmentFilterDisplayName', (($Script:IntuneAssignmentFilters | Where-Object -FilterScript { $_.FilterId -eq $filterId }).DisplayName))
            }
        }

        if ($null -ne $assignment.settings -and $assignment.settings.AdditionalProperties.Count -gt 0)
        {
            $settings = (Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $assignment.settings.AdditionalProperties)
            $hashAssignment.Add('assignmentSettings', $settings)
        }

        $assignmentResult += $hashAssignment
    }

    return ,[System.Collections.Hashtable[]]$assignmentResult
}

function ConvertTo-IntuneMobileAppAssignment
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param (
        [Parameter(Mandatory = $true)]
        [AllowNull()]
        $Assignments,

        [Parameter()]
        [System.Boolean]
        $IncludeDeviceFilter = $true
    )

    if ($null -eq $Script:IntuneAssignmentFilters)
    {
        $Script:IntuneAssignmentFilters = Get-MgBetaDeviceManagementAssignmentFilter -All -ErrorAction SilentlyContinue | ForEach-Object {
            @{
                FilterId    = $_.Id
                DisplayName = $_.DisplayName
            }
        }
    }

    if ($null -eq $Assignments)
    {
        return ,@()
    }

    $assignmentResult = @()
    foreach ($assignment in $Assignments)
    {
        $formattedAssignment = @{}
        $target = @{
            '@odata.type' = $assignment.dataType
        }

        # Handle Device Filters
        if ($IncludeDeviceFilter)
        {
            if ($null -ne $assignment.DeviceAndAppManagementAssignmentFilterType -and
                $assignment.DeviceAndAppManagementAssignmentFilterType -ne 'none')
            {
                $filter = $Script:IntuneAssignmentFilters | Where-Object {
                    $_.FilterId -eq $assignment.DeviceAndAppManagementAssignmentFilterId
                }

                if ($null -eq $filter)
                {
                    $filter = $Script:IntuneAssignmentFilters | Where-Object {
                        $_.DisplayName -eq $assignment.DeviceAndAppManagementAssignmentFilterDisplayName
                    }
                }

                if ($null -ne $filter)
                {
                    $target.Add('deviceAndAppManagementAssignmentFilterType', $assignment.DeviceAndAppManagementAssignmentFilterType)
                    $target.Add('deviceAndAppManagementAssignmentFilterId', $filter.FilterId)
                }
                else
                {
                    Write-Warning "Assignment filter with DisplayName {$($assignment.DeviceAndAppManagementAssignmentFilterDisplayName)} not found."
                }
            }
        }

        # Add intent (required for app assignments)
        $formattedAssignment.Add('intent', $assignment.intent)

        if ($assignment.dataType -like '*groupAssignmentTarget')
        {
            $group = $null
            if (-not [System.String]::IsNullOrEmpty($assignment.groupId))
            {
                $group = Get-MgGroup -GroupId $assignment.groupId -ErrorAction SilentlyContinue
            }
            # If groupId lookup failed, try by display name
            if ($null -eq $group -and -not [System.String]::IsNullOrEmpty($assignment.groupDisplayName))
            {
                $escapedName = $assignment.groupDisplayName -replace "'", "''"
                $group = Get-MgGroup -Filter "DisplayName eq '$escapedName'" -All -ErrorAction SilentlyContinue
                if ($null -eq $group)
                {
                    Write-Warning "Skipping assignment: groupDisplayName '{$($assignment.groupDisplayName)}' not found."
                    $target = $null
                }
                elseif ($group.Count -gt 1)
                {
                    Write-Warning "Skipping assignment: groupDisplayName '{$($assignment.groupDisplayName)}' is not unique."
                    $target = $null
                }
            }
            # If group found, add its ID
            if ($null -ne $group)
            {
                $target.Add('groupId', $group.Id)
            }
            elseif ($null -eq $group -and [System.String]::IsNullOrEmpty($assignment.groupDisplayName))
            {
                Write-Warning 'Skipping assignment: missing both groupId and groupDisplayName.'
                $target = $null
            }
        }
        # Add target if valid
        if ($target)
        {
            $formattedAssignment.Add('target', $target)
        }
        # Add assignment settings if present
        if ($null -ne $assignment.assignmentSettings)
        {
            $settings = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $assignment.assignmentSettings
            $formattedAssignment.Add('settings', $settings)
            $formattedAssignment.settings.Add('@odata.type', $formattedAssignment.settings.odataType)
            $formattedAssignment.settings.Remove('odataType') | Out-Null
        }
        $assignmentResult += $formattedAssignment
    }
    return ,$assignmentResult
}

function Compare-M365DSCIntunePolicyAssignment
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter()]
        [array]$Source,
        [Parameter()]
        [array]$Target
    )
    $DriftObject = @{
        DriftInfo     = @{}
        CurrentValues = @{}
        DesiredValues = @{}
    }
    $testResult = $Source.Count -eq $Target.Count
    if (-not $testResult)
    {
        $DriftObject.DriftInfo.Add('Assignments.Count', @{
            PropertyName = 'Assignments.Count'
            CurrentValue = $Source.Count
            DesiredValue = $Target.Count
        })
    }
    Write-Verbose "Count: $($Source.Count) - $($Target.Count)"
    if ($testResult)
    {
        foreach ($assignment in $Source)
        {
            if ($assignment.dataType -like '*AssignmentTarget')
            {
                $assignmentTarget = $Target | Where-Object -FilterScript { $_.dataType -eq $assignment.DataType -and $_.groupId -eq $assignment.groupId }
                $testResult = $null -ne $assignmentTarget
                # Check for mobile app assignments with intent
                $testResult = $assignment.intent -eq $assignmentTarget.intent
                # Using assignment groupDisplayName only if the groupId is not found in the directory otherwise groupId should be the key
                if (-not $testResult)
                {
                    Write-Verbose 'Group not found by groupId, looking for group by groupDisplayName'
                    $assignmentTarget = $Target | Where-Object -FilterScript { $_.dataType -eq $assignment.DataType -and $_.groupDisplayName -eq $assignment.groupDisplayName }
                    $testResult = $null -ne $assignmentTarget

                    if (-not $testResult)
                    {
                        $DriftObject.DriftInfo.Add('Assignments.GroupDisplayName', @{
                            PropertyName = 'Assignments.GroupDisplayName'
                            CurrentValue = $assignment.groupDisplayName
                            DesiredValue = $null
                        })
                    }
                }

                if ($testResult)
                {
                    Write-Verbose 'Group found by groupId or groupDisplayName, checking filters'
                    $isFilterTypeSpecified = ($null -ne $assignment.deviceAndAppManagementAssignmentFilterType -and $assignment.deviceAndAppManagementAssignmentFilterType -ne 'none') -or `
                    ($null -ne $assignmentTarget.deviceAndAppManagementAssignmentFilterType -and $assignmentTarget.deviceAndAppManagementAssignmentFilterType -ne 'none')
                    $isFilterIdSpecified = ($null -ne $assignment.deviceAndAppManagementAssignmentFilterId -and $assignment.deviceAndAppManagementAssignmentFilterId -ne '00000000-0000-0000-0000-000000000000') -or `
                    ($null -ne $assignmentTarget.deviceAndAppManagementAssignmentFilterId -and $assignmentTarget.deviceAndAppManagementAssignmentFilterId -ne '00000000-0000-0000-0000-000000000000')
                    if ($isFilterTypeSpecified)
                    {
                        Write-Verbose 'FilterType specified, checking filterType'
                        $testResult = $assignment.deviceAndAppManagementAssignmentFilterType -eq $assignmentTarget.deviceAndAppManagementAssignmentFilterType
                    }
                    if ($testResult -and $isFilterTypeSpecified -and $isFilterIdSpecified)
                    {
                        Write-Verbose 'FilterId specified, checking filterId'
                        $testResult = $assignment.deviceAndAppManagementAssignmentFilterId -eq $assignmentTarget.deviceAndAppManagementAssignmentFilterId

                        if (-not $testResult)
                        {
                            Write-Verbose 'FilterId does not match, checking filterDisplayName'
                            $testResult = $assignment.deviceAndAppManagementAssignmentFilterDisplayName -eq $assignmentTarget.deviceAndAppManagementAssignmentFilterDisplayName
                        }
                    }
                    if (-not $testResult)
                    {
                        $DriftObject.DriftInfo.Add('Assignments.Filters', @{
                            PropertyName = 'Assignments.Filters'
                            CurrentValue = $assignment.deviceAndAppManagementAssignmentFilterType
                            DesiredValue = $assignmentTarget.deviceAndAppManagementAssignmentFilterType
                        })
                    }
                }

                if ($testResult)
                {
                    Write-Verbose 'Group and filters match, checking collectionId'
                    $testResult = $assignment.collectionId -eq $assignmentTarget.collectionId
                    if (-not $testResult)
                    {
                        $DriftObject.DriftInfo.Add('Assignments.collectionId', @{
                            PropertyName = 'Assignments.collectionId'
                            CurrentValue = $assignment.collectionId
                            DesiredValue = $assignmentTarget.collectionId
                        })
                    }
                }
            }
            else
            {
                $testResult = $null -ne ($Target | Where-Object -FilterScript { $_.dataType -eq $assignment.DataType })
                if (-not $testResult)
                {
                    $DriftObject.DriftInfo.Add('Assignments.collectionId', @{
                        PropertyName = 'Assignments.DataType'
                        CurrentValue = $assignment.DataType
                        DesiredValue = $null
                    })
                }
            }
            $Global:CCMCurrentDriftInfo = $DriftObject
            if (-not $testResult)
            {
                break
            }
        }
    }

    $Global:CCMCurrentDriftInfo = $DriftObject
    return $testResult
}

function Update-DeviceConfigurationPolicyAssignment
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter()]
        [Array]
        $Targets,

        [Parameter()]
        [System.String]
        $Repository = 'deviceManagement/configurationPolicies',

        [Parameter()]
        [ValidateSet('v1.0', 'beta')]
        [System.String]
        $APIVersion = 'beta',

        [Parameter()]
        [System.String]
        $RootIdentifier = 'assignments'
    )

    try
    {
        $deviceManagementPolicyAssignments = @()
        $Uri = "/$APIVersion/$Repository/$DeviceConfigurationPolicyId/assign"

        foreach ($target in $targets)
        {
            $targetAssignment = @{}
            $formattedTarget = @{'@odata.type' = $target.dataType }
            if ($null -ne $target.runRemediationScript)
            {
                $targetAssignment.Add('runRemediationScript', $target.runRemediationScript)
            }
            if ($null -ne $target.runSchedule)
            {
                $targetAssignment.Add('runSchedule', $target.runSchedule)
            }
            if ($target.target -is [hashtable])
            {
                $target = $target.target
            }
            if (-not $formattedTarget.'@odata.type' -and $target.'@odata.type')
            {
                $formattedTarget.'@odata.type' = $target.'@odata.type'
            }
            if ($target.groupId)
            {
                $group = Get-MgGroup -GroupId ($target.groupId) -ErrorAction SilentlyContinue
                if ($null -eq $group)
                {
                    if ($target.groupDisplayName)
                    {
                        $group = Get-MgGroup -Filter "DisplayName eq '$($target.groupDisplayName -replace "'", "''")'" -All -ErrorAction SilentlyContinue
                        if ($null -eq $group)
                        {
                            $message = "Skipping assignment for the group with DisplayName {$($target.groupDisplayName)} as it could not be found in the directory.`r`n"
                            $message += 'Please update your DSC resource extract with the correct groupId or groupDisplayName.'
                            Write-Warning -Message $message
                            $target = $null
                        }
                        if ($group -and $group.Count -gt 1)
                        {
                            $message = "Skipping assignment for the group with DisplayName {$($target.groupDisplayName)} as it is not unique in the directory.`r`n"
                            $message += 'Please update your DSC resource extract with the correct groupId or a unique group DisplayName.'
                            Write-Warning -Message $message
                            $group = $null
                            $target = $null
                        }
                    }
                    else
                    {
                        $message = "Skipping assignment for the group with Id {$($target.groupId)} as it could not be found in the directory.`r`n"
                        $message += 'Please update your DSC resource extract with the correct groupId or a unique group DisplayName.'
                        Write-Warning -Message $message
                        $target = $null
                    }
                }
                #Skipping assignment if group not found from either groupId or groupDisplayName
                if ($null -ne $group)
                {
                    $formattedTarget.Add('groupId', $group.Id)
                }
            }
            if ($target.collectionId)
            {
                $formattedTarget.Add('collectionId', $target.collectionId)
            }
            if ($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType', $target.deviceAndAppManagementAssignmentFilterType)
            }
            if ($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId', $target.deviceAndAppManagementAssignmentFilterId)
            }
            $targetAssignment.Add('target', $formattedTarget)
            $deviceManagementPolicyAssignments += $targetAssignment
        }

        $body = @{$RootIdentifier = $deviceManagementPolicyAssignments } | ConvertTo-Json -Depth 20
        Write-Verbose -Message $body

        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $null
    }
}

function Update-DeviceAppManagementPolicyAssignment
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppManagementPolicyId,

        [Parameter()]
        [Array]
        $Assignments,

        [Parameter()]
        [System.String]
        $Repository = 'deviceAppManagement/mobileApps',

        [Parameter()]
        [ValidateSet('v1.0', 'beta')]
        [System.String]
        $APIVersion = 'beta',

        [Parameter()]
        [System.String]
        $RootIdentifier = 'mobileAppAssignments'
    )

    try
    {
        $appManagementPolicyAssignments = @()
        $Uri = "/$APIVersion/$Repository/$AppManagementPolicyId/assign"

        foreach ($assignment in $Assignments)
        {
            $formattedAssignment = @{
                '@odata.type' = '#microsoft.graph.mobileAppAssignment'
                intent        = $assignment.intent
            }
            if ($assignment.settings)
            {
                $formattedAssignment.Add('settings', $assignment.settings)
            }

            if ($assignment.target -is [hashtable])
            {
                $target = $assignment.target
            }

            $formattedTarget = @{'@odata.type' = $target.dataType }
            if (-not $formattedTarget.'@odata.type' -and $target.'@odata.type')
            {
                $formattedTarget.'@odata.type' = $target.'@odata.type'
            }
            if ($target.groupId)
            {
                $group = Get-MgGroup -GroupId ($target.groupId) -ErrorAction SilentlyContinue
                if ($null -eq $group)
                {
                    if ($target.groupDisplayName)
                    {
                        $group = Get-MgGroup -Filter "DisplayName eq '$($target.groupDisplayName -replace "'", "''")'" -All -ErrorAction SilentlyContinue
                        if ($null -eq $group)
                        {
                            $message = "Skipping assignment for the group with DisplayName {$($target.groupDisplayName)} as it could not be found in the directory.`r`n"
                            $message += 'Please update your DSC resource extract with the correct groupId or groupDisplayName.'
                            Write-Warning -Message $message
                            $target = $null
                        }
                        if ($group -and $group.Count -gt 1)
                        {
                            $message = "Skipping assignment for the group with DisplayName {$($target.groupDisplayName)} as it is not unique in the directory.`r`n"
                            $message += 'Please update your DSC resource extract with the correct groupId or a unique group DisplayName.'
                            Write-Warning -Message $message
                            $group = $null
                            $target = $null
                        }
                    }
                    else
                    {
                        $message = "Skipping assignment for the group with Id {$($target.groupId)} as it could not be found in the directory.`r`n"
                        $message += 'Please update your DSC resource extract with the correct groupId or a unique group DisplayName.'
                        Write-Warning -Message $message
                        $target = $null
                    }
                }
                #Skipping assignment if group not found from either groupId or groupDisplayName
                if ($null -ne $group)
                {
                    $formattedTarget.Add('groupId', $group.Id)
                }
            }
            if ($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType', $target.deviceAndAppManagementAssignmentFilterType)
            }
            if ($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId', $target.deviceAndAppManagementAssignmentFilterId)
            }
            $formattedAssignment.Add('target', $formattedTarget)
            $appManagementPolicyAssignments += $formattedAssignment
        }

        $body = @{$RootIdentifier = $appManagementPolicyAssignments } | ConvertTo-Json -Depth 20
        Write-Verbose -Message $body

        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $null
    }
}

function Update-DeviceAppManagementAppCategory
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $App,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [Array]
        $Categories,

        [Parameter()]
        [switch]
        $Compare
    )

    if ($Compare)
    {
        [array]$referenceObject = if ($null -ne $App.Categories.DisplayName)
        {
            $App.Categories.DisplayName
        }
        else
        {
            , @()
        }
        [array]$differenceObject = if ($null -ne $Categories.DisplayName)
        {
            $Categories.DisplayName
        }
        else
        {
            , @()
        }
        $delta = Compare-Object -ReferenceObject $referenceObject -DifferenceObject $differenceObject -PassThru
        foreach ($diff in $delta)
        {
            if ($diff.SideIndicator -eq '=>')
            {
                $category = $Categories | Where-Object { $_.DisplayName -eq $diff }
                if ($category.Id)
                {
                    $currentCategory = Get-MgBetaDeviceAppManagementMobileAppCategory -MobileAppCategoryId $category.Id
                }
                else
                {
                    $currentCategory = Get-MgBetaDeviceAppManagementMobileAppCategory -Filter "DisplayName eq '$($category.DisplayName -replace "'", "''")'"
                }

                if ($null -eq $currentCategory)
                {
                    throw "Mobile App Category with DisplayName $($category.DisplayName) not found."
                }

                Invoke-MgGraphRequest -Uri "/beta/deviceAppManagement/mobileApps/$($App.Id)/categories/`$ref" -Method 'POST' -Body @{
                    '@odata.id' = "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceAppManagement/mobileAppCategories/$($currentCategory.Id)"
                }
            }
            else
            {
                $category = $App.Categories | Where-Object { $_.DisplayName -eq $diff }
                Invoke-MgGraphRequest -Uri "/beta/deviceAppManagement/mobileApps/$($App.Id)/categories/$($category.Id)/`$ref" -Method 'DELETE'
            }
        }
    }
    else
    {
        foreach ($category in $Categories)
        {
            if ($category.Id)
            {
                $currentCategory = Get-MgBetaDeviceAppManagementMobileAppCategory -MobileAppCategoryId $category.Id
            }
            else
            {
                $currentCategory = Get-MgBetaDeviceAppManagementMobileAppCategory -Filter "DisplayName eq '$($category.DisplayName -replace "'", "''")'"
            }

            if ($null -eq $currentCategory)
            {
                throw "Mobile App Category with DisplayName $($category.DisplayName) not found."
            }

            Invoke-MgGraphRequest -Uri "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceAppManagement/mobileApps/$($App.Id)/categories/`$ref" -Method 'POST' -Body @{
                '@odata.id' = "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceAppManagement/mobileAppCategories/$($currentCategory.Id)"
            }
        }
    }
}

function Get-M365DSCIntuneDeviceConfigurationSettings
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties,

        [Parameter()]
        [System.String]
        $TemplateId
    )

    $templateCategoryId = (Get-MgBetaDeviceManagementTemplateCategory -DeviceManagementTemplateId $TemplateId).Id
    $templateSettings = Get-MgBetaDeviceManagementTemplateCategoryRecommendedSetting `
        -DeviceManagementTemplateId $TemplateId `
        -DeviceManagementTemplateSettingCategoryId $templateCategoryId

    $results = @()
    foreach ($setting in $templateSettings)
    {
        $result = @{}
        $settingType = $setting.AdditionalProperties.'@odata.type'
        $settingValue = $null
        $currentValueKey = $Properties.keys | Where-Object -FilterScript { $setting.DefinitionId -like "*$_" }
        if ($null -ne $currentValueKey)
        {
            $settingValue = $Properties.$currentValueKey
        }

        $requiresValueJson = $false
        switch ($settingType)
        {
            {
                ( $_ -eq '#microsoft.graph.deviceManagementStringSettingInstance' ) -or
                ( $_ -eq '#microsoft.graph.deviceManagementBooleanSettingInstance' )
            }
            {
                if ([String]::IsNullOrEmpty($settingValue))
                {
                    $settingValue = $setting.ValueJson | ConvertFrom-Json
                }
            }
            '#microsoft.graph.deviceManagementCollectionSettingInstance'
            {
                $requiresValueJson = $true
                if ($null -eq $settingValue)
                {
                    $settingValue = ConvertTo-Json -InputObject @()
                }
                else
                {
                    $settingValue = ConvertTo-Json -InputObject ([Array]$settingValue)
                }
            }
            default
            {
                if ($null -eq $settingValue)
                {
                    $settingValue = $setting.ValueJson | ConvertFrom-Json
                }
            }
        }

        $result.Add('@odata.type', $settingType)
        $result.Add('Id', $setting.Id)
        $result.Add('definitionId', $setting.DefinitionId)

        if ($requiresValueJson)
        {
            $result.Add('valueJson', $settingValue)
        }
        else
        {
            $result.Add('value', $settingValue)
        }

        $results += $result
    }

    return $results
}

function Get-OmaSettingPlainTextValue
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $SecretReferenceValueId,

        [Parameter()]
        [ValidateSet('v1.0', 'beta')]
        [System.String]
        $APIVersion = 'beta'
    )

    try
    {
        <#
            e.g. PolicyId for SecretReferenceValueId '35ea58ec-2a79-471d-8eea-7e28e6cd2722_bdf6c690-05fb-4d02-835d-5a7406c35d58_abe32712-2255-445f-a35e-0c6f143d82ca'
            is 'bdf6c690-05fb-4d02-835d-5a7406c35d58'
        #>
        $SplitSecretReferenceValueId = $SecretReferenceValueId.Split('_')
        if ($SplitSecretReferenceValueId.Count -eq 3)
        {
            $PolicyId = $SplitSecretReferenceValueId[1]
        }
        else
        {
            return $null
        }
    }
    catch
    {
        return $null
    }

    $Repository = 'deviceManagement/deviceConfigurations'
    $Uri = "/{0}/{1}/{2}/getOmaSettingPlainTextValue(secretReferenceValueId='{3}')" -f $APIVersion, $Repository, $PolicyId, $SecretReferenceValueId

    try
    {
        $Result = Invoke-MgGraphRequest -Method GET -Uri $Uri -ErrorAction Stop
    }
    catch
    {
        $Message = 'Error decrypting OmaSetting with SecretReferenceValueId {0}:' -f $SecretReferenceValueId
        New-M365DSCLogEntry -Message $Message `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $null
    }

    if (![String]::IsNullOrEmpty($Result.Value))
    {
        return $Result.Value
    }
    else
    {
        return $null
    }
}

function Get-IntuneSettingCatalogPolicySetting
{
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $DSCParams,

        [Parameter(
            Mandatory = 'true',
            ParameterSetName = 'Start'
        )]
        [System.String]
        $TemplateId,

        [Parameter(
            Mandatory = 'true',
            ParameterSetName = 'DeviceAndUserSettings'
        )]
        [System.Array]
        $SettingTemplates,

        [Parameter(ParameterSetName = 'Start')]
        [switch]
        $ContainsDeviceAndUserSettings
    )

    if ($null -eq (Get-Command Get-SettingsCatalogSettingName -ErrorAction SilentlyContinue))
    {
        Import-Module -Name (Join-Path $PSScriptRoot M365DSCIntuneSettingsCatalogUtil.psm1) -Force
    }

    $DSCParams.Remove('Identity') | Out-Null
    $DSCParams.Remove('DisplayName') | Out-Null
    $DSCParams.Remove('Description') | Out-Null

    $settingInstances = @()
    if ($PSCmdlet.ParameterSetName -eq 'Start')
    {
        # Prepare setting definitions mapping
        $SettingTemplates = Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate `
            -DeviceManagementConfigurationPolicyTemplateId $TemplateId `
            -ExpandProperty 'SettingDefinitions' `
            -All

        if ($ContainsDeviceAndUserSettings)
        {
            $deviceSettingTemplates = $SettingTemplates | Where-Object -FilterScript {
                $_.SettingInstanceTemplate.SettingDefinitionId.StartsWith('device_')
            }
            $userSettingTemplates = $SettingTemplates | Where-Object -FilterScript {
                $_.SettingInstanceTemplate.SettingDefinitionId.StartsWith('user_')
            }
            $deviceDscParams = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $DSCParams.DeviceSettings -SingleLevel -ExcludeUnchangedProperties
            $userDscParams = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $DSCParams.UserSettings -SingleLevel -ExcludeUnchangedProperties
            $combinedSettingInstances = @()
            $combinedSettingInstances += Get-IntuneSettingCatalogPolicySetting -DSCParams $deviceDscParams -SettingTemplates $deviceSettingTemplates
            $combinedSettingInstances += Get-IntuneSettingCatalogPolicySetting -DSCParams $userDscParams -SettingTemplates $userSettingTemplates

            return ,$combinedSettingInstances
        }
    }

    # Iterate over all setting templates
    foreach ($settingTemplate in $SettingTemplates)
    {
        $settingInstanceTemplate = $settingTemplate.SettingInstanceTemplate
        $settingInstance = @{}
        $settingDefinition = $settingTemplate.SettingDefinitions | Where-Object {
            $_.Id -eq $settingInstanceTemplate.SettingDefinitionId -and `
            ($_.AdditionalProperties.dependentOn.Count -eq 0 -and $_.AdditionalProperties.options.dependentOn.Count -eq 0)
        }
        if ($null -eq $settingDefinition)
        {
            continue
        }
        if ($settingDefinition -is [System.Array])
        {
            $settingDefinition = $settingDefinition[0]
        }

        $settingType = $settingInstanceTemplate.AdditionalProperties.'@odata.type'.Replace('InstanceTemplate', 'Instance')
        $settingInstance.Add('@odata.type', $settingType)
        if (-not [string]::IsNullOrEmpty($settingInstanceTemplate.settingInstanceTemplateId))
        {
            $settingInstance.Add('settingInstanceTemplateReference', @{'settingInstanceTemplateId' = $settingInstanceTemplate.settingInstanceTemplateId })
        }
        $settingValueName = $settingType.Replace('#microsoft.graph.deviceManagementConfiguration', '').Replace('Instance', 'Value')
        $settingValueName = $settingValueName.Substring(0, 1).ToLower() + $settingValueName.Substring(1, $settingValueName.Length - 1 )
        [string]$settingValueType = $settingInstanceTemplate.AdditionalProperties."$($settingValueName)Template".'@odata.type' | Select-Object -Unique
        if (-not [System.String]::IsNullOrEmpty($settingValueType))
        {
            $settingValueType = $settingValueType.Replace('ValueTemplate', 'Value')
        }
        if ([System.String]::IsNullOrEmpty($settingValueType) -and $settingValueName -eq 'choiceSettingValue')
        {
            # Special case for ChoiceSettingValue which does not have a ValueTemplate property
            $settingValueType = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
        }

        $settingValueTemplateId = $settingInstanceTemplate.AdditionalProperties."$($settingValueName)Template".settingValueTemplateId

        # Only happened on property ThreatTypeSettings from IntuneAntivirusPolicyLinux
        # SettingValueTemplateIds are from the child settings and not from the parent setting because it is a groupSettingCollection
        if ($settingValueTemplateId -is [array])
        {
            $settingValueTemplateId = $null
        }

        # Get all the values in the setting instance
        $settingValue = Get-IntuneSettingCatalogPolicySettingInstanceValue `
            -DSCParams $DSCParams `
            -SettingDefinition $settingDefinition `
            -SettingInstanceTemplate $settingInstanceTemplate `
            -AllSettingDefinitions $SettingTemplates.SettingDefinitions `
            -CurrentInstanceDefinitions $settingTemplate.SettingDefinitions `
            -SettingType $settingType `
            -SettingValueName $settingValueName `
            -SettingValueType $settingValueType `
            -SettingValueTemplateId $settingValueTemplateId

        if ($settingValue.Count -gt 0)
        {
            if ($settingValue.Keys -contains 'groupSettingCollectionValue' -and $settingValue.groupSettingCollectionValue.children.Count -eq 0)
            {
                continue
            }

            $settingInstance += [Hashtable]$settingValue
            if ($settingInstance.Keys -notcontains 'settingDefinitionId')
            {
                $settingInstance.Add('settingDefinitionId', $settingInstanceTemplate.settingDefinitionId)
            }
            $settingInstances += @{
                '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationSetting'
                'settingInstance' = $settingInstance
            }
        }
    }

    return ,$settingInstances
}

function Get-IntuneSettingCatalogPolicySettingInstanceValue
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $DSCParams,

        [Parameter()]
        $SettingDefinition,

        [Parameter()]
        $SettingInstanceTemplate,

        [Parameter()]
        [System.Array]
        $AllSettingDefinitions,

        [Parameter()]
        [System.Array]
        $CurrentInstanceDefinitions,

        [Parameter()]
        [System.String]
        $SettingType,

        [Parameter()]
        [System.String]
        $SettingValueName,

        [Parameter()]
        [System.String]
        $SettingValueType,

        [Parameter()]
        [System.String]
        $SettingValueTemplateId,

        [Parameter()]
        [System.String]
        $SettingInstanceName = 'MSFT_MicrosoftGraphIntuneSettingsCatalog',

        [Parameter()]
        [System.Int32]
        $Level = 1
    )

    $settingValuesToReturn = @{}

    # Depending on the setting type, there is other logic involved
    switch ($SettingType)
    {
        # GroupSettingCollections are a collection of settings without a value of their own
        { $_ -eq '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance' -or $_ -eq '#microsoft.graph.deviceManagementConfigurationSettingGroupCollectionDefinition' }
        {
            $groupSettingCollectionValue = @()
            $groupSettingCollectionDefinitionChildren = @()

            $groupSettingCollectionDefinitionChildren += $CurrentInstanceDefinitions | Where-Object {
                ($_.AdditionalProperties.dependentOn.Count -gt 0 -and $_.AdditionalProperties.dependentOn.parentSettingId -contains $SettingDefinition.Id) -or
                ($_.AdditionalProperties.options.dependentOn.Count -gt 0 -and $_.AdditionalProperties.options.dependentOn.parentSettingId -contains $SettingDefinition.Id)
            }

            $instanceCount = 1
            if (($Level -gt 1 -and $groupSettingCollectionDefinitionChildren.Count -gt 1) -or
                ($Level -eq 1 -and $SettingDefinition.AdditionalProperties.maximumCount -gt 1 -and $groupSettingCollectionDefinitionChildren.Count -ge 1 -and $groupSettingCollectionDefinitionChildren.AdditionalProperties.'@odata.type' -notcontains '#microsoft.graph.deviceManagementConfigurationSettingGroupCollectionDefinition'))
            {
                $SettingInstanceName += Get-SettingsCatalogSettingName -SettingDefinition $SettingDefinition -AllSettingDefinitions $AllSettingDefinitions
                $settingInstanceNameAlternate = $SettingInstanceName + '_Intune'
                $cimDSCParams = @()
                $cimDSCParamsName = ''
                $DSCParams.GetEnumerator() | ForEach-Object {
                    if ($_.Value.CimClass.CimClassName -eq $SettingInstanceName -or $_.Value.CimClass.CimClassName -like "$settingInstanceNameAlternate*")
                    {
                        $cimDSCParams += $_.Value
                        $cimDSCParamsName = $_.Key
                    }
                }
                $newDSCParams = @{
                    $cimDSCParamsName = @()
                }
                foreach ($instance in $cimDSCParams)
                {
                    $newInstanceDSCParams = @{}
                    # Preserve CIM instances when converting to hashtable
                    foreach ($property in $instance.CimInstanceProperties)
                    {
                        if ($property.IsValueModified)
                        {
                            $newInstanceDSCParams.Add($property.Name, $property.Value)
                        }
                    }
                    $newDSCParams.$cimDSCParamsName += $newInstanceDSCParams
                }
                $instanceCount = $newDSCParams.$cimDSCParamsName.Count
                $DSCParams = @{
                    $cimDSCParamsName = if ($instanceCount -eq 1)
                    {
                        $newDSCParams.$cimDSCParamsName[0]
                    }
                    else
                    {
                        $newDSCParams.$cimDSCParamsName
                    }
                }
                $AllSettingDefinitions = $groupSettingCollectionDefinitionChildren + $SettingDefinition
            }

            for ($i = 0; $i -lt $instanceCount; $i++)
            {
                $groupSettingCollectionValueChildren = @()
                $currentDSCParams = if ($instanceCount -eq 1)
                {
                    if (-not [System.String]::IsNullOrEmpty($cimDSCParamsName))
                    {
                        $DSCParams.$cimDSCParamsName
                    }
                    else
                    {
                        $DSCParams
                    }
                }
                else
                {
                    if (-not [System.String]::IsNullOrEmpty($cimDSCParamsName))
                    {
                        $DSCParams.$cimDSCParamsName[$i]
                    }
                    else
                    {
                        $DSCParams[$i]
                    }
                }
                if ($null -eq $currentDSCParams)
                {
                    # Should we continue? Let's try out
                    $currentDSCParams = @{}
                }

                foreach ($childDefinition in $groupSettingCollectionDefinitionChildren)
                {
                    $childSettingType = $childDefinition.AdditionalProperties.'@odata.type'.Replace('Definition', 'Instance').Replace('SettingGroup', 'GroupSetting')
                    $childSettingValueName = $childSettingType.Replace('#microsoft.graph.deviceManagementConfiguration', '').Replace('Instance', 'Value')
                    $childSettingValueType = "#microsoft.graph.deviceManagementConfiguration$($childSettingValueName)"
                    $childSettingValueName = $childSettingValueName.Substring(0, 1).ToLower() + $childSettingValueName.Substring(1, $childSettingValueName.Length - 1 )
                    $childSettingInstanceTemplate = if ($null -ne $SettingInstanceTemplate.AdditionalProperties)
                    {
                        $SettingInstanceTemplate.AdditionalProperties.groupSettingCollectionValueTemplate.children | Where-Object { $_.settingDefinitionId -eq $childDefinition.Id } | Select-Object -First 1
                    }
                    else
                    {
                        $SettingInstanceTemplate.groupSettingCollectionValueTemplate.children | Where-Object { $_.settingDefinitionId -eq $childDefinition.Id } | Select-Object -First 1
                    }

                    $childSettingValueTemplateId = $childSettingInstanceTemplate."$($childSettingValueName)Template".settingValueTemplateId

                    $childSettingValue = Get-IntuneSettingCatalogPolicySettingInstanceValue `
                        -DSCParams $currentDSCParams `
                        -SettingDefinition $childDefinition `
                        -SettingInstanceTemplate $childSettingInstanceTemplate `
                        -AllSettingDefinitions $AllSettingDefinitions `
                        -CurrentInstanceDefinitions $CurrentInstanceDefinitions `
                        -SettingType $childDefinition.AdditionalProperties.'@odata.type' `
                        -SettingValueName $childSettingValueName `
                        -SettingValueType $childSettingValueType `
                        -SettingValueTemplateId $childSettingValueTemplateId `
                        -SettingInstanceName $SettingInstanceName `
                        -Level ($Level + 1)

                    if ($childSettingValue.Keys.Count -gt 0)
                    {
                        # If only one child item is allowed but we have multiple values, we need to create an object for each child
                        # Happens e.g. for the IntuneDeviceControlPolicyWindows10 resource --> {ruleid} and {ruleid}_ruledata definitions
                        if ($childSettingValue.groupSettingCollectionValue.Count -gt 1 -and
                            $childDefinition.AdditionalProperties.maximumCount -eq 1 -and
                            $groupSettingCollectionDefinitionChildren.Count -eq 1)
                        {
                            $childSettingValueOld = $childSettingValue
                            $childSettingValue = @()
                            foreach ($childSettingValueItem in $childSettingValueOld.groupSettingCollectionValue)
                            {
                                $childSettingValueInner = @{
                                    children = @()
                                }
                                $childSettingValueItem.Add('@odata.type', $childSettingType)
                                $childSettingValueInner.children += @{
                                    '@odata.type'               = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                    groupSettingCollectionValue = @(
                                        @{
                                            children = $childSettingValueItem.children
                                        }
                                    )
                                    settingDefinitionId         = $childDefinition.Id
                                }
                                <# GroupSettingCollection do not have a setting instance template reference
                                if (-not [string]::IsNullOrEmpty($childSettingInstanceTemplate.settingInstanceTemplateId))
                                {
                                    $childSettingValueInner.children[0].groupSettingCollectionValue.settingInstanceTemplateReference = @{
                                        'settingInstanceTemplateId' = $childSettingInstanceTemplate.settingInstanceTemplateId
                                    }
                                }
                                #>
                                $childSettingValue += $childSettingValueInner
                            }
                            $groupSettingCollectionValue += $childSettingValue
                        }
                        else
                        {
                            if ($childSettingValue.Keys -notcontains 'settingDefinitionId')
                            {
                                $childSettingValue.Add('settingDefinitionId', $childDefinition.Id)
                            }
                            <# GroupSettingCollection do not have a setting instance template reference
                            if (-not [string]::IsNullOrEmpty($childSettingInstanceTemplate.settingInstanceTemplateId))
                            {
                                $childSettingValue.Add('settingInstanceTemplateReference', @{'settingInstanceTemplateId' = $childSettingInstanceTemplate.settingInstanceTemplateId | Select-Object -First 1 })
                            }
                            #>
                            $childSettingValue.Add('@odata.type', $childSettingType)
                            $groupSettingCollectionValueChildren += $childSettingValue
                        }
                    }
                }

                # Does not happen for wrapped children elements
                if ($groupSettingCollectionValueChildren.Count -gt 0)
                {
                    $groupSettingCollectionValue += @{
                        children = @($groupSettingCollectionValueChildren)
                    }
                }
            }

            if ($groupSettingCollectionDefinitionChildren.Count -gt 0 -and $groupSettingCollectionValue.Count -gt 0)
            {
                $settingValuesToReturn.Add('groupSettingCollectionValue', @($groupSettingCollectionValue))
            }
        }
        # ChoiceSetting is a choice (e.g. dropdown) setting that, depending on the choice, can have children settings
        { $_ -eq '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance' -or $_ -eq '#microsoft.graph.deviceManagementConfigurationChoiceSettingDefinition' }
        {
            $choiceSettingValue = @{}
            $choiceSettingValueChildren = @()
            $choiceSettingDefinitionChildren = @()

            # Choice settings almost always have child settings, so we need to fetch those
            if ($null -ne $SettingDefinition)
            {
                $choiceSettingDefinitionChildren += $CurrentInstanceDefinitions | Where-Object {
                    ($_.AdditionalProperties.dependentOn.Count -gt 0 -and $_.AdditionalProperties.dependentOn.parentSettingId.Contains($SettingDefinition.Id)) -or
                    ($_.AdditionalProperties.options.dependentOn.Count -gt 0 -and $_.AdditionalProperties.options.dependentOn.parentSettingId.Contains($SettingDefinition.Id))
                }
            }

            foreach ($childDefinition in $choiceSettingDefinitionChildren)
            {
                $childSettingType = $childDefinition.AdditionalProperties.'@odata.type'.Replace('Definition', 'Instance')
                $childSettingValueName = $childSettingType.Replace('#microsoft.graph.deviceManagementConfiguration', '').Replace('Instance', 'Value')
                $childSettingValueType = "#microsoft.graph.deviceManagementConfiguration$($childSettingValueName)"
                $childSettingValueName = $childSettingValueName.Substring(0, 1).ToLower() + $childSettingValueName.Substring(1, $childSettingValueName.Length - 1 )
                $childSettingInstanceTemplate = if ($null -ne $SettingInstanceTemplate.AdditionalProperties)
                {
                    $SettingInstanceTemplate.AdditionalProperties.choiceSettingValueTemplate.children | Where-Object { $_.settingDefinitionId -eq $childDefinition.Id }
                }
                else
                {
                    $SettingInstanceTemplate.choiceSettingValueTemplate.children | Where-Object { $_.settingDefinitionId -eq $childDefinition.Id }
                }
                $childSettingValueTemplateId = $childSettingInstanceTemplate."$($childSettingValueName)Template" | Where-Object {
                    $_.settingDefinitionId -eq $childDefinition.Id
                } | Select-Object -ExpandProperty settingValueTemplateId
                $childSettingValue = Get-IntuneSettingCatalogPolicySettingInstanceValue `
                    -DSCParams $DSCParams `
                    -SettingDefinition $childDefinition `
                    -AllSettingDefinitions $AllSettingDefinitions `
                    -CurrentInstanceDefinitions $CurrentInstanceDefinitions `
                    -SettingInstanceTemplate $childSettingInstanceTemplate `
                    -SettingType $childDefinition.AdditionalProperties.'@odata.type' `
                    -SettingValueName $childSettingValueName `
                    -SettingValueType $childSettingValueType `
                    -SettingValueTemplateId $childSettingValueTemplateId `
                    -SettingInstanceName $SettingInstanceName

                if ($childSettingValue.Keys.Count -gt 0)
                {
                    if ($childSettingValue.Keys -notcontains 'settingDefinitionId')
                    {
                        $childSettingValue.Add('settingDefinitionId', $childDefinition.Id)
                    }
                    if (-not [string]::IsNullOrEmpty($childSettingInstanceTemplate.settingInstanceTemplateId))
                    {
                        $childSettingValue.Add('settingInstanceTemplateReference', @{'settingInstanceTemplateId' = $childSettingInstanceTemplate.settingInstanceTemplateId })
                    }
                    if ($childSettingType -eq '#microsoft.graph.deviceManagementConfigurationSettingGroupCollectionInstance')
                    {
                        $childSettingType = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                    }
                    $childSettingValue.Add('@odata.type', $childSettingType)
                    $choiceSettingValueChildren += $childSettingValue
                }
            }

            # Depending on the children count, we add the children to the choice setting or an empty array since the children property is required
            if ($choiceSettingDefinitionChildren.Count -gt 0)
            {
                $choiceSettingValue.Add('children', $choiceSettingValueChildren)
            }
            else
            {
                $choiceSettingValue.Add('children', @())
            }

            $valueResult = Get-IntuneSettingCatalogPolicySettingDSCValue `
                -SettingValueType $SettingValueType `
                -AllSettingDefinitions $AllSettingDefinitions `
                -SettingDefinition $SettingDefinition `
                -DSCParams $DSCParams

            $value = $valueResult.Value

            # If there is a value in the DSC params, we add that to the choice setting
            if ($null -ne $value)
            {
                $value = $value
                $choiceSettingValue.Add('value', $value)
                $odataType = $SettingType.Replace('Definition', 'Value').Replace('Instance', 'Value')
                $choiceSettingValue.Add('@odata.type', $odataType)
                if (-not [string]::IsNullOrEmpty($SettingValueTemplateId))
                {
                    $choiceSettingValue.Add('settingValueTemplateReference', @{'settingValueTemplateId' = $SettingValueTemplateId })
                }
            }

            # If there are children or a value is configured, we add the choice setting to the return values
            if ($choiceSettingValue.Children.Count -gt 0 -or $null -ne $choiceSettingValue.value)
            {
                $settingValuesToReturn.Add('choiceSettingValue', $choiceSettingValue)
            }
        }
        # ChoiceSettingCollection is a collection of ChoiceSettings
        { $_ -eq '#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance' -or $_ -eq '#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionDefinition' }
        {
            $choiceSettingValueCollection = @()
            $valueResult = Get-IntuneSettingCatalogPolicySettingDSCValue `
                -SettingValueType $SettingValueType `
                -AllSettingDefinitions $AllSettingDefinitions `
                -SettingDefinition $SettingDefinition `
                -DSCParams $DSCParams

            $values = $valueResult.Value

            if ($null -ne $values)
            {
                # We iterate over all the values in the DSC params and add them to the choice setting collection
                foreach ($value in $values)
                {
                    $choiceSettingValueCollection += @{
                        value         = $value
                        children      = @()
                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                    }
                }

                $settingValuesToReturn.Add('choiceSettingCollectionValue', $choiceSettingValueCollection)
            }
        }
        # SimpleSettingCollections are collections of simple settings, e.g. strings or integers
        { $_ -eq '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance' -or $_ -eq '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionDefinition' }
        {
            $valuesResult = Get-IntuneSettingCatalogPolicySettingDSCValue `
                -SettingValueType $SettingValueType `
                -AllSettingDefinitions $AllSettingDefinitions `
                -SettingDefinition $SettingDefinition `
                -DSCParams $DSCParams

            if ($null -eq $valuesResult)
            {
                return $null
            }

            $values = $valuesResult.Value
            $SettingValueType = $valuesResult.SettingDefinition.AdditionalProperties.valueDefinition.'@odata.type'.Replace('Definition', '')

            $settingValueCollection = @()
            foreach ($v in $values)
            {
                $settingValueCollection += @{
                    value         = $v
                    '@odata.type' = $SettingValueType
                }
            }
            if ($settingValueCollection.Count -gt 0)
            {
                $settingValuesToReturn.Add($SettingValueName, $settingValueCollection)
            }
        }
        # For all other types, e.g. Integer or String, we add the value directly
        default
        {
            $valueResult = Get-IntuneSettingCatalogPolicySettingDSCValue `
                -SettingValueType $SettingValueType `
                -AllSettingDefinitions $AllSettingDefinitions `
                -SettingDefinition $SettingDefinition `
                -DSCParams $DSCParams

            $value = $valueResult.Value
            $SettingValueType = $valueResult.SettingValueType
            $SettingDefinition = $valueResult.SettingDefinition

            if ($null -eq $value)
            {
                return $null
            }

            $settingValue = @{}
            if (-not [string]::IsNullOrEmpty($SettingValueType))
            {
                if ($SettingDefinition.AdditionalProperties.valueDefinition.isSecret)
                {
                    $SettingValueType = '#microsoft.graph.deviceManagementConfigurationSecretSettingValue'
                    $settingValue.Add('valueState', 'NotEncrypted')
                }
                $settingValue.Add('@odata.type', $SettingValueType)
            }
            if (-not [string]::IsNullOrEmpty($settingValueTemplateId))
            {
                $settingValue.Add('settingValueTemplateReference', @{'settingValueTemplateId' = $settingValueTemplateId })
            }
            $settingValue.Add('value', $value)

            $settingValuesToReturn.Add($SettingValueName, $settingValue)
            $settingValuesToReturn.Add('settingDefinitionId', $SettingDefinition.Id)
        }
    }
    return $settingValuesToReturn
}

function Get-IntuneSettingCatalogPolicySettingDSCValue
{
    param
    (
        [Parameter()]
        [System.String]
        $SettingValueType = '',

        [Parameter()]
        $SettingDefinition,

        [Parameter(Mandatory = $true)]
        [System.Array]
        $AllSettingDefinitions,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $DSCParams
    )

    $key = Get-SettingsCatalogSettingName -SettingDefinition $SettingDefinition -AllSettingDefinitions $AllSettingDefinitions

    if ($DSCParams.Keys -notcontains $key)
    {
        return $null
    }

    # Fixes potential case sensitivity issue.
    foreach ($hashKey in $DSCParams.Keys)
    {
        if ($hashKey -eq $key)
        {
            $key = $hashKey
            break
        }
    }

    $isArray = $false
    if ($SettingValueType -like '*Simple*')
    {
        if ($DSCParams[$key] -is [System.String])
        {
            $SettingValueType = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
        }
        elseif ($DSCParams[$key] -is [System.Int32])
        {
            $SettingValueType = '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
        }
        elseif ($DSCParams[$key] -is [System.String[]])
        {
            $SettingValueType = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
            $isArray = $true
        }
        elseif ($DSCParams[$key] -is [System.Int32[]])
        {
            $SettingValueType = '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
            $isArray = $true
        }
    }

    if ($SettingValueType -like '*Simple*' -or $SettingValueType -in @('#microsoft.graph.deviceManagementConfigurationIntegerSettingValue', '#microsoft.graph.deviceManagementConfigurationStringSettingValue'))
    {
        return @{
            SettingDefinition = $SettingDefinition
            SettingValueType  = $SettingValueType
            Value             = if ($isArray)
            {
                , $DSCParams[$key]
            }
            else
            {
                $DSCParams[$key]
            }
        }
    }
    elseif ($SettingValueType -like '*ChoiceSetting*' -and $SettingValueType -notlike '*Collection*')
    {
        $settingValue = ($SettingDefinition.AdditionalProperties.options | Where-Object { $_.optionValue.value -eq $($DSCParams[$key]) }).itemId
        if ([System.String]::IsNullOrEmpty($settingValue))
        {
            $settingValue = ($SettingDefinition.AdditionalProperties.options | Where-Object { $_.itemId -eq "$($SettingDefinition.Id)_$($DSCParams[$key])" }).itemId
        }
        return @{
            SettingDefinition = $SettingDefinition
            SettingValueType  = $SettingValueType
            Value             = $settingValue
        }
    }
    elseif ($SettingValueType -like '*ChoiceSettingCollection*')
    {
        $values = @()
        foreach ($value in $DSCParams[$key])
        {
            $valueToAdd = ($SettingDefinition.AdditionalProperties.options | Where-Object { $_.optionValue.value -eq "$value" }).itemId
            if ([System.String]::IsNullOrEmpty($valueToAdd))
            {
                $valueToAdd = ($SettingDefinition.AdditionalProperties.options | Where-Object { $_.itemId -eq "$($SettingDefinition.Id)_$value" }).itemId
            }
            $values += $valueToAdd
        }

        return @{
            Value = $values
        }
    }
    else
    {
        return @{
            SettingDefinition = $SettingDefinition
            SettingValueType  = $SettingValueType
            Value             = "$($SettingDefinition.Id)_$($DSCParams[$key])"
        }
    }
}

function Export-IntuneSettingCatalogPolicySettings
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Start'
        )]
        $Settings,

        [Parameter(
            Mandatory = $true
        )]
        [System.Collections.Hashtable]$ReturnHashtable,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Setting'
        )]
        $SettingInstance,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Setting'
        )]
        $SettingDefinitions,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Setting'
        )]
        [Parameter(
            ParameterSetName = 'Start'
        )]
        [System.Array]
        $AllSettingDefinitions,

        [Parameter(
            ParameterSetName = 'Setting'
        )]
        [switch]$IsRoot,

        [Parameter(
            ParameterSetName = 'Start'
        )]
        [switch]$ContainsDeviceAndUserSettings
    )
    if ($PSCmdlet.ParameterSetName -eq 'Start')
    {
        if ($ContainsDeviceAndUserSettings)
        {
            $deviceSettingsReturnHashtable = @{}
            $deviceSettings = $Settings | Where-Object -FilterScript {
                $_.SettingInstance.settingDefinitionId.StartsWith('device_')
            }
            if ($AllSettingDefinitions.Count -eq 0)
            {
                $allDeviceSettingDefinitions = $deviceSettings.SettingDefinitions
            }
            else
            {
                $allDeviceSettingDefinitions = $AllSettingDefinitions | Where-Object -FilterScript {
                    $_.Id.StartsWith('device_')
                }
            }
            foreach ($setting in $deviceSettings)
            {
                Export-IntuneSettingCatalogPolicySettings -SettingInstance $setting.SettingInstance -SettingDefinitions $setting.SettingDefinitions -ReturnHashtable $deviceSettingsReturnHashtable -AllSettingDefinitions $allDeviceSettingDefinitions -IsRoot
            }

            $userSettingsReturnHashtable = @{}
            $userSettings = $Settings | Where-Object -FilterScript {
                $_.SettingInstance.settingDefinitionId.StartsWith('user_')
            }
            if ($AllSettingDefinitions.Count -eq 0)
            {
                $allUserSettingDefinitions = $userSettings.SettingDefinitions
            }
            else
            {
                $allUserSettingDefinitions = $AllSettingDefinitions | Where-Object -FilterScript {
                    $_.Id.StartsWith('user_')
                }
            }

            foreach ($setting in $userSettings)
            {
                Export-IntuneSettingCatalogPolicySettings -SettingInstance $setting.SettingInstance -SettingDefinitions $setting.SettingDefinitions -ReturnHashtable $userSettingsReturnHashtable -AllSettingDefinitions $allUserSettingDefinitions -IsRoot
            }

            if ($deviceSettingsReturnHashtable.Keys.Count -gt 0)
            {
                $ReturnHashtable.Add('DeviceSettings', $deviceSettingsReturnHashtable)
            }
            if ($userSettingsReturnHashtable.Keys.Count -gt 0)
            {
                $ReturnHashtable.Add('UserSettings', $userSettingsReturnHashtable)
            }
        }
        else
        {
            if ($AllSettingDefinitions.Count -eq 0)
            {
                $AllSettingDefinitions = $Settings.SettingDefinitions
            }
            foreach ($setting in $Settings)
            {
                Export-IntuneSettingCatalogPolicySettings -SettingInstance $setting.SettingInstance -SettingDefinitions $setting.SettingDefinitions -ReturnHashtable $ReturnHashtable -AllSettingDefinitions $AllSettingDefinitions -IsRoot
            }
        }
        return $ReturnHashtable
    }

    $addToParameters = $true
    $settingDefinition = $SettingDefinitions | Where-Object -FilterScript { $_.Id -eq $SettingInstance.settingDefinitionId }
    $settingName = Get-SettingsCatalogSettingName -SettingDefinition $settingDefinition -AllSettingDefinitions $AllSettingDefinitions
    $odataType = if ($IsRoot)
    {
        $SettingInstance.AdditionalProperties.'@odata.type'
    }
    else
    {
        $SettingInstance.'@odata.type'
    }
    switch ($odataType)
    {
        '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
        {
            $simpleSetting = if ($IsRoot)
            {
                $SettingInstance.AdditionalProperties.simpleSettingValue
            }
            else
            {
                $SettingInstance.simpleSettingValue
            }
            if ($simpleSetting.'@odata.type' -eq '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue')
            {
                $settingValue = [int]$simpleSetting.value
            }
            else
            {
                $settingValue = $simpleSetting.value
            }
        }
        '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
        {
            $options = $settingDefinition.AdditionalProperties.options
            $beforeSettingValue = if ($IsRoot)
            {
                $SettingInstance.AdditionalProperties.choiceSettingValue.value
            }
            else
            {
                $SettingInstance.choiceSettingValue.value
            }

            $settingValue = ($options | Where-Object { $_.itemId -eq $beforeSettingValue }).optionValue.value
            if ($settingValue -like '*=*' -or $settingValue -like '*{*}*')
            {
                # The value is not an actual value, but rather an assignment string. Fall back to the itemId and strip the prefix
                # Examples are IntuneFirewallPolicyWindows10 -> target is a GUID, IntuneAntivirusPolicyWindows10ConfigMgr -> *Severity* is an assignment, e.g. 2=2
                $settingValue = ($options | Where-Object { $_.itemId -eq $beforeSettingValue }).itemId.Replace("$($settingDefinition.Id)_", '')
            }
            $childSettings = if ($IsRoot)
            {
                $SettingInstance.AdditionalProperties.choiceSettingValue.children
            }
            else
            {
                $SettingInstance.choiceSettingValue.children
            }
            foreach ($childSetting in $childSettings)
            {
                Export-IntuneSettingCatalogPolicySettings -SettingInstance $childSetting -SettingDefinitions $SettingDefinitions -ReturnHashtable $ReturnHashtable -AllSettingDefinitions $AllSettingDefinitions
            }
        }
        '#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance'
        {
            $values = @()
            $options = $settingDefinition.AdditionalProperties.options
            $childValues = if ($IsRoot)
            {
                $SettingInstance.AdditionalProperties.choiceSettingCollectionValue.value
            }
            else
            {
                $SettingInstance.choiceSettingCollectionValue.value
            }
            foreach ($value in $childValues)
            {
                $valueToReturn = ($options | Where-Object { $_.itemId -eq $value }).optionValue.value
                if ($valueToReturn -like '*=*' -or $valueToReturn -like '*{*}*')
                {
                    # The value is not an actual value, but rather an assignment string. Fall back to the itemId and strip the prefix
                    # Examples are IntuneFirewallPolicyWindows10 -> target is a GUID, IntuneAntivirusPolicyWindows10ConfigMgr -> *Severity* is an assignment, e.g. 2=2
                    $valueToReturn = ($options | Where-Object { $_.itemId -eq $value }).itemId.Replace("$($settingDefinition.Id)_", '')
                }
                $values += $valueToReturn
            }
            if ($options[0].optionValue.'@odata.type' -like '*Integer*')
            {
                $values = [int[]]$values
            }
            elseif ($options[0].optionValue.'@odata.type' -like '*String*')
            {
                $values = [string[]]$values
            }
            $settingValue = $values
        }
        '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
        {
            $groupSettingCollectionValue = if ($IsRoot)
            {
                $SettingInstance.AdditionalProperties.groupSettingCollectionValue
            }
            else
            {
                $SettingInstance.groupSettingCollectionValue
            }
            [array]$childSettingDefinitions = $SettingDefinitions | Where-Object -FilterScript {
                $settingDefinition.AdditionalProperties.childIds -contains $_.Id
            }
            $parentSettingDefinition = $SettingDefinitions | Where-Object -FilterScript { $_.Id -eq $settingDefinition.AdditionalProperties.dependentOn.parentSettingId }

            if ($settingDefinition.AdditionalProperties.maximumCount -gt 1 -and $childSettingDefinitions.Count -eq 1)
            {
                # Skip GroupSettingCollection with only one child, go straight to the child property
                foreach ($child in $groupSettingCollectionValue)
                {
                    $childInstances = $child.children
                    foreach ($childInstance in $childInstances)
                    {
                        Export-IntuneSettingCatalogPolicySettings -SettingInstance $childInstance -SettingDefinitions $SettingDefinitions -ReturnHashtable $ReturnHashtable -AllSettingDefinitions $AllSettingDefinitions
                    }
                }
                $addToParameters = $false
            }
            elseif (($settingDefinition.AdditionalProperties.maximumCount -gt 1 -or $parentSettingDefinition.AdditionalProperties.maximumCount -gt 1) -and $childSettingDefinitions.Count -gt 1)
            {
                # If the GroupSettingCollection can appear multiple times (either itself or from the parent), we need to add its name as a property
                # and the child settings as its value
                $childValue = $null
                if (-not $IsRoot)
                {
                    $parentSettingDefinition = $SettingDefinitions | Where-Object -FilterScript { $_.Id -eq $settingDefinition.AdditionalProperties.dependentOn.parentSettingId }
                    if ($settingDefinition.AdditionalProperties.maximumCount -gt 1 -or
                        $parentSettingDefinition.AdditionalProperties.maximumCount -gt 1)
                    {
                        $childValue = @()
                    }
                }
                else
                {
                    if ($settingDefinition.AdditionalProperties.maximumCount -gt 1)
                    {
                        $childValue = @()
                    }
                }

                foreach ($child in $groupSettingCollectionValue)
                {
                    $childHashtable = @{}
                    foreach ($childInstance in $child.children)
                    {
                        Export-IntuneSettingCatalogPolicySettings -SettingInstance $childInstance -SettingDefinitions $SettingDefinitions -ReturnHashtable $childHashtable -AllSettingDefinitions $AllSettingDefinitions
                    }
                    $childValue += $childHashtable
                }
                $settingValue = if ($null -eq $childValue)
                {
                    $childHashtable
                }
                else
                {
                    , $childValue
                }
            }
            else
            {
                # Skip GroupSettingCollection that only appears once, go straight to the child properties
                $childSettings = $groupSettingCollectionValue.children
                foreach ($value in $childSettings)
                {
                    Export-IntuneSettingCatalogPolicySettings -SettingInstance $value -SettingDefinitions $SettingDefinitions -ReturnHashtable $ReturnHashtable -AllSettingDefinitions $AllSettingDefinitions
                    $addToParameters = $false
                }
            }
        }
        '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
        {
            $values = @()
            $childValues = if ($IsRoot)
            {
                $SettingInstance.AdditionalProperties.simpleSettingCollectionValue
            }
            else
            {
                $SettingInstance.simpleSettingCollectionValue
            }
            foreach ($value in $childValues)
            {
                if ($value.'@odata.type' -eq '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue')
                {
                    $values += [int]$value.value
                }
                else
                {
                    $values += $value.value
                }
            }
            $settingValue = $values
        }
        default
        {
            if ($SettingInstance.'@odata.type' -eq '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue')
            {
                $settingValue += [int]$SettingInstance.value
            }
            else
            {
                $settingValue = $SettingInstance.value
            }
        }
    }

    if ($addToParameters)
    {
        if (-not $ReturnHashtable.ContainsKey($settingName))
        {
            $ReturnHashtable.Add($settingName, $settingValue)
        }
        else
        {
            # Only happens when it's a GroupCollection(Collection) with multiple entries
            $ReturnHashtable[$settingName] = @($ReturnHashtable[$settingName]) + $settingValue
        }
    }
}

function Update-IntuneDeviceConfigurationPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Platforms,

        [Parameter()]
        [System.String]
        $Technologies,

        [Parameter()]
        [System.String]
        $TemplateReferenceId,

        [Parameter()]
        [AllowNull()]
        [System.String]
        $CreationSource,

        [Parameter()]
        [Array]
        $Settings,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds
    )

    try
    {
        $Uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceManagement/configurationPolicies/$DeviceConfigurationPolicyId"

        $policy = @{
            'name'            = $Name
            'description'     = $Description
            'platforms'       = $Platforms
            'technologies'    = $Technologies
            'settings'        = $Settings
            'roleScopeTagIds' = $RoleScopeTagIds
        }

        if ($PSBoundParameters.ContainsKey('TemplateReferenceId'))
        {
            $policy.Add('templateReference', @{ 'templateId' = $TemplateReferenceId })
        }

        if ($PSBoundParameters.ContainsKey('CreationSource') -and -not [System.String]::IsNullOrEmpty($CreationSource))
        {
            $policy.Add('creationSource', $CreationSource)
        }

        $body = $policy | ConvertTo-Json -Depth 20
        Write-Verbose -Message "Updating policy with:`r`n$body"
        Invoke-MgGraphRequest -Method PUT -Uri $Uri -Body $body -ErrorAction Stop
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Get-ComplexFunctionsFromFilterQuery
{
    [CmdletBinding()]
    [OutputType([System.Array])]
    param (
        [string]$FilterQuery
    )

    $complexFunctionsRegex = "startswith\((.*?),\s*'(.*?)'\)|endswith\((.*?),\s*'(.*?)'\)|contains\((.*?),\s*'(.*?)'\)"
    [array]$complexFunctions = [regex]::Matches($FilterQuery, $complexFunctionsRegex) | ForEach-Object {
        $_.Value
    }

    return $complexFunctions
}

function Remove-ComplexFunctionsFromFilterQuery
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [string]$FilterQuery
    )

    $complexFunctionsRegex = "startswith\((.*?),\s*'(.*?)'\)|endswith\((.*?),\s*'(.*?)'\)|contains\((.*?),\s*'(.*?)'\)"
    $basicFilterQuery = [regex]::Replace($FilterQuery, $complexFunctionsRegex, '').Trim()
    $basicFilterQuery = $basicFilterQuery -replace '^and\s', '' -replace '\sand$', '' -replace '\sand\s+', ' and ' -replace '\sor\s+', ' or '

    return $basicFilterQuery
}

function Find-GraphDataUsingComplexFunctions
{
    [CmdletBinding()]
    [OutputType([System.Array])]
    param (
        [array]$Policies,
        [array]$ComplexFunctions
    )

    foreach ($function in $ComplexFunctions)
    {
        if ($function -match "startswith\((.*?),\s*'(.*?)'")
        {
            $property = $matches[1]
            $value = $matches[2]
            $Policies = $Policies | Where-Object { $_.$property -like "$value*" }
        }
        elseif ($function -match "endswith\((.*?),\s*'(.*?)'")
        {
            $property = $matches[1]
            $value = $matches[2]
            $Policies = $Policies | Where-Object { $_.$property -like "*$value" }
        }
        elseif ($function -match "contains\((.*?),\s*'(.*?)'")
        {
            $property = $matches[1]
            $value = $matches[2]
            $Policies = $Policies | Where-Object { $_.$property -like "*$value*" }
        }
    }

    return $Policies
}

function Invoke-M365DSCIntuneMobileAppInitialUpload
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OdataType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $FileExtension
    )

    $OdataType = $OdataType.Replace('#', '')
    $contentVersionsUri = "beta/deviceAppManagement/mobileApps/$($AppId)/$OdataType/contentVersions"
    $contentVersion = Invoke-MgGraphRequest -Method POST -Uri $contentVersionsUri -Body @{}

    $manifest = $null
    $size = 1
    $sizeEncrypted = 64
    $base64File = '+drh1SKfuLjdp37gfv8EuWqOTt06m0TirqJJ0xQvrd5sm6NkiYBY8vBkFM+9ZwHRskO83NEfsLPtTzLB9FFsKA=='
    $fileDigest = 'ypeBEsobvcr6wjGzmiPcTaeG7/gUfE5yuYB3ha/uSLs='
    $mac = '+drh1SKfuLjdp37gfv8EuWqOTt06m0TirqJJ0xQvrd4='
    switch ($OdataType)
    {
        'microsoft.graph.androidLobApp'
        {
            $size = 3425
            $sizeEncrypted = 3488
            $manifest = $([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('<?xml version="1.0" encoding="utf-8"?><AndroidManifestProperties xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><Package>b.a</Package><PackageVersionCode>1</PackageVersionCode><PackageVersionName></PackageVersionName><ApplicationName>Sample.apk</ApplicationName><MinSdkVersion>3</MinSdkVersion><AWTVersion></AWTVersion></AndroidManifestProperties>')))
            $base64File = 'OXtq10WM7mpJAnbN2AU/cqvKGYeKfTfJirK3weR6Y09sm6NkiYBY8vBkFM+9ZwHRSfslI4iDA4yW3cCL0arh9vMt0sVV8twkoL+DWQX1Q+ughe61l+/j+nfNFdSlZcWn/3cU+FHSLxmb952tZOUGWFhfg9N8492+MWegxrrRxbjR+OC1AziyBV/9ZdwAK4OxVqyEPCKUPXvMohAXrvxZle+GPGzERh3pEXWkCRMPCSwEfHfLRWfoiVb6zIujnWxkfmwLz2pv7Kr+sFbOyxp19jN8n/7HsFxrmHMlwg50dxy81s247M2g0XvklWNMQz/6ayGfVf5ZKWe0qBnlKGdr1Kl9UOTtDEofQzAqTJwIlL7RNlUDMCSd9B8MU1ScEEpFrBMbPozxjv19KpAqL4MWE82Eu0v/4Z9+cXrnFRR0+Ryt1B6bl8cljeaS6i5/inn45BncySdDwNsq7r8aj76U7zfARa+kHEYAQnZH0nVTKbcAPmPvth7+Vf0igoVjholAanoHJH6UD5hpD+Cyr/u8qLTHdva3aLzXf3cu1kdkpRFTcM3hL4zNxS9C58JyZVuMEJwtG+rsRWMTmYGJlzWWnUbCRtGWmIFBF/eSTtOOuY5LOi3RlfCCbuZcAgKL6u+rC0C0g6NO9/Un9791CdYlDTEmvDiGk0u2PvRsF18nZ+V+BiYRgdll8+j27Kv3V8Pm/ytx+HLjvxdRy3GUGEjsnAAzruVPt1Jak3/aD+RmIzpG0YOwqjnyMzHz1F/BzMsPZ5NlNon4pPE4O0S8FcbevaBUYifooIlz7ss5tPmrCT72I1QqqQaMsMVxC/GIBqLSZ3hJUjeiS7XMtrDreqhxrmoC1Yjslhk4ueW4WQ8a2ptsKEGk6NAzSrgJy9an1uj15+RVRX+H7E8MPf0F4zpJSwPit0OJwv60aEfN8YBPR4LnxiqxWkC9otnoatzoLRvJhn4Rbk2VYeh/FhMtRFlKRcsEZcCmA2fVqWiv2YzGzpECLbhmqAHRec8fG1rE1xJWBEGKEEp5MHJgEsNbJYVhlO8FcdX/Kdnhi7usvyuB9+Y41w671pJbmihngOyhwnu7fWjwCMNQx6s5PU0h6a2RGjYKtOdWHP4ndtTqLVXgfzpj9m9m+lahmFOAX/mGShO25dpGG6J2rhGTH58gGSVl7m4ktoXc6HTgXP6bshUsalQxLD5bmZGOAoD4mEizIXHlBng0wiYDDeVytfIJywIpXBeF4YuslsWu6CoObKok9ELghhawnDudltYJMFGT5doKlo1L8sKrzXtnHvkkSXJq9masQy2zONt+rrH9M6FwU7XY8d+FEc5gGNKPNYESDjQ+2JlPQRWCU56GB3mpIVTWXe1xH2z+65fLQlnvkZeJDA7JF0OfZxmeMuktIpPIpVTEwOerc58JyjtHvWisex2ErThegQHjsjy0llpy0MWFL7n7wlQuen0QNcnNss/cfEpAac11DNaL4n7cZz1q4Gm3SRHB+Lxpphrk8pOqyd6LrGLZ72DOHghnKuYSr4xOsqYESVxzSeJ5yYsCveL2zyog58cMrLAnhb+78J18kNDgefKya4Q0SEnOcicB6JPUkBaK0K9v1N8UFp8Hx1rmmEgfvUVYydGjtwMYH/Od59EUkFLDivow6DFdOIowqZ6iChhjFgMbC3CnGINAAWcxFMbDPqCVZLZVhgBg+RXWnWvwxkhgAa0WYMzUBp/r6B/etfA6/K/R77cvY6JFFncXJ03coJhZu0TEtMC+7xJS0m4eGeGFxVdIp3/+J0BUAoCiDYUFPaIvf9OHlarumdXCp0G15LjgtWRAgNi50Xo0rNFy6IAhEJEyCuygF6B0lVFEyG8dn93qWXA0NIJzFx7XVVWndQDJZTH83L3741X1E0p9DxTTrHWfmyb0WMBGVSn3c6C6vSAWxqv8YUHUA78wlHBvr3taf4fX3alTNOBXD3zJfSMbq2WOw9YLl6eKSMxMID0umgb6wPLsSspekKnd4LK+aCUFnIjBVsVTVYoTLjtdTFMBReZ3LFvcJ1Zk1ND33GaI/GkpEwgjWkHNPgX1T2otEZCHKAyhgl9U/KSAHBb/GoRKXD/OdUR0AHzDxqx1xWF6Av5sM6aXDg4D1QGSDHBtwZtB/RL43dXCX8wS5SiTGUTdWicIbspoTyYLoTFV2CtW6Erx3Qrdt5vmDLMBKonKkREL80p7Jl97h4bMFnES2O4+t9e+RrPXha6atPArt3MnQnXtjLU4lX0ejhLWG3CDfkUaoWFgBf0gUhpwLIm6gdgsSkFCcmnVpOSLnC0bkglFpjLJNbqKhjh0r6xx+P9D0ZFndWTviwpH1/lKwOlEtvNydEuqrS9BitcOpd5cQqXq+i6y8zhZAzcBjwfYhuqcEbFrY7pVcMB9NoR3e0zNhKS9GaNMi09Ddi707+tdMlCbCcUyiOnsiC3L26dBnlQTLt9Cn12VyNrFt52m6BEWxY+0Yu69UKdh3+fST8gH2VcCwE9u/4X6VxM4yrCjijZ8d1XVFc/RLmO2pUosq2Zn8aoUIkoxf10wiYODe8PHDCPRU1mZ4AmrP4NnZ0ZvRZJ6Azx/TMRrsWQxNmAuKFi3RUt9Um5oIvWrrLtVeiGUqFMLxbHEGC1WHKh+l5h7zO0WmwUFRAilVipBbCGxfsZ8v4HSFndc2+lcUodKy3d/sDzcnLPQ3pq8WJOd5UVppfaWukD8K7U4GZ7G/u02P0WxXIbYGqWMCjL0OyRh1F7Ss3d86kAjhVLYKye7bjgwYvJc7JAe1xOfhZBUD1IL6QHeYJTHTmJ0tncirvdexNLfi/dwFc04KlqW5ti7z0gBBCipY5feEkwWIeO5CbPWUITHU5u+jk0lyuN7lvOG52Qe3eIVdZIgsxrMzUAJwNK9ZLfCpuiSiE8/yUf+CA6VHtlUapmnse+E4tRRBWTSMh/J6Bhos3QvvP0MceM/16lJaAxrYXIvtTlFfmRC10QYBRNy5AhpYwZd0WQWtFNdYMZFiDc7WZvOOu7adazudrd3fLD9cpuU1dyBczeTgF3J5icirDSlLjIj9yqUFkvKGRZSVCDeUfTz5B6kMQ8E2xZUI4e0QQpfUFqdiUfR3G8jBshgFgzVtZC3oxph/4KiXwDT/+LW0FNZQbSqYwdA5v2WFYCWbWnxhOhVaauvn2iQJuYjsK7HdK8dcNPHx8jxNPCUM8QhuZClSZw9hUnk0kw8D+pZtjde9S75untxrsuQInEwoH5CRHhT0otXK0AbMVzJ7aOjlyjidgsUQG20Xf8EQxZ4yK6gYNmviSIgTq27pr6WegILo9x+6b5euyr+vwWeKf1IgljvWDT9PdpZ4tYQHsEFiaEs2w+hwYxpbBSedl/X4APV0HQK8Wt3emvnsWqN22o18XkhR4dWAnGDbMz3WZ2Pt1s4eoxCC0gOytTnODtmllHXnBoQ633YuB+7AYl64TSQJ423yMiu9O8IrzlnQ9P16lwWV0lqh/HCfI/qI3fam4dRrfZqGbCDZ+VKSfwgevOtphmw/A7zZyYbT5FJVBWbhB0J0W24evAoOGBi72yTXX3ciF1ZXaW/A6YaP+xmJRdBUEG55gltuAmMdxlsXkRfEbVaTfH84i1hXuqiYCMc1GQwbjx4LvfELCiMYX1CFdIwDiSAGVHHlJUHS4WqCZ3vlDtOuiIxV2aDDe9wUF7Zn5thAQAERBXQYsCXMnzwT5TUNEV618OAGKWYDYbrvNrXdgT/t8sBFe4qe1afHX6gc/zyrXNFB5vzdjpcRwfTrAG0IsQkXe5175uz67TcLVRqjXkfTx55BXBDxlliPuCZWkKQzVsAkaYn5pJjFEGvXYjKtE+fmIdMSJAiSRxjteMP4gdrahxo3oXyDZPnJNe1/R5Pc5NlZCLW+F8w13uefQ052WkAsXQBcGPQG+NGFL1adQDt8cc2bMF8pjJ8oyyxmo26+etog+aTpTlHcS5X5ssgs2fa2y58YIyfwVSGn8W38UwQVoXilpXqyKmES5jJykqErS/caGE9WPq0sVrABDNddrps1TmDsylR10wi6CBiFihWDOiQcf6F2vVKZ+jVxOT/6Ag9GynuURSYqoDeO0VJNRtsBBtkT+uSuFIG3qM34/HNNJwt5pGV9IjIUy8HmupGdSi+1mKe8kGSpijWcXUuaXUhzyhoba4y7b9NePx2R1ofJmB3DdV3Nk4J3LTy28ujmTe5RKQSYS/QQ0kCiW3j205Tlc4XlQFAFNIendt8Lo941KkeAkobYmEFmpy/MZ1L9plScKbylQ8RCNa/w2ss0f4KyUPBM85+MqSUhteBjjU5rpwU7V0mISgQ1c6P1okq8fK5iE0IJUCXByF+hCPthG0o/lvP0dqP/xI6+Ishjbu3VV+HfPXBX+Q50GSgIwbH+afZv3u4OmAfaljTkpPdtIChPmtkUKQNuPzuQyZC5dGj5G4vOvioD0wxxWcjbGSZGRhTLt0fQk5Im9gJykkOFLcpZT1oRt5OcfpbIGWOaUlt71Mr4iRBb8p9oTxR97EBVlU4qrPCvw2sLVJeP0RY6m6Dg4hgkxMJ4ah5aMUJHzPG67s7D5CmacAsobU8zkuN8120aEP0DzEsJlOcHRKmz0Okj7iMdcxsJDbe7ReHKRxg0GFvtDeUjuwsFwfr+MY='
            $fileDigest = 'rCQEPUja3DkId6YVFRVWWx/cHasCjuLZXYC9gAhdk3Y='
            $mac = 'OXtq10WM7mpJAnbN2AU/cqvKGYeKfTfJirK3weR6Y08='
        }
        'microsoft.graph.windowsMobileMSI'
        {
            $manifest = $([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('<MobileMsiData MsiExecutionContext="User" MsiRequiresReboot="false" MsiUpgradeCode="{00000000-0000-0000-0000-000000000000}" MsiIsMachineInstall="false" MsiIsUserInstall="true" MsiRequiresLogon="true" MsiIncludesServices="false" MsiContainsSystemRegistryKeys="false" MsiContainsSystemFolders="false"></MobileMsiData>')))
        }
        'microsoft.graph.windowsUniversalAppx'
        {
            $manifest = $([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("Sample.$($FileExtension)".ToUpper())))
        }
    }

    $fileUri = "beta/deviceAppManagement/mobileApps/$($AppId)/$OdataType/contentVersions/$($contentVersion.id)/files"
    $manifest = $null
    if ($OdataType -eq 'microsoft.graph.windowsUniversalAppx')
    {
        # Manifest is required for Windows Universal Appx
        $manifest = $([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("Sample.$($FileExtension)".ToUpper())))
    }
    elseif ($OdataType -eq 'microsoft.graph.windowsMobileMSI')
    {
        # Manifest is required for Windows Mobile MSI
        $manifest = $([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('<MobileMsiData MsiExecutionContext="User" MsiRequiresReboot="false" MsiUpgradeCode="{00000000-0000-0000-0000-000000000000}" MsiIsMachineInstall="false" MsiIsUserInstall="true" MsiRequiresLogon="true" MsiIncludesServices="false" MsiContainsSystemRegistryKeys="false" MsiContainsSystemFolders="false"></MobileMsiData>')))
    }
    $file = Invoke-MgGraphRequest -Method POST `
        -Uri $fileUri `
        -Body @{
        '@odata.type' = '#microsoft.graph.mobileAppContentFile'
        name          = "Sample.$($FileExtension)"
        size          = $size
        sizeEncrypted = $sizeEncrypted
        isDependency  = $false
        manifest      = $manifest
    }

    $file = Wait-ForFileProcessing -AppId $AppId -OdataType $OdataType -FileId $file.id -ContentVersionId $contentVersion.id -UploadStatePrefix 'AzureStorageUriRequest'

    # Upload the encrypted Sample file to Azure Storage
    $success = $false
    $breakCounter = 0
    do
    {
        try
        {
            Write-Verbose "Uploading file to Azure Storage: $($file.azureStorageUri)"
            $base64File = '+drh1SKfuLjdp37gfv8EuWqOTt06m0TirqJJ0xQvrd5sm6NkiYBY8vBkFM+9ZwHRskO83NEfsLPtTzLB9FFsKA=='
            $sasUri = $file.azureStorageUri
            $uri = "$($sasUri)&comp=block&blockid=0001"
            $iso = [System.Text.Encoding]::GetEncoding('iso-8859-1')
            $body = [System.Convert]::FromBase64String($base64File)
            $encodedBody = $iso.GetString($body)
            Invoke-WebRequest -Uri $uri -Method PUT -Body $encodedBody -Headers @{
                'x-ms-blob-type' = 'BlockBlob'
            } -ErrorAction Stop -UseBasicParsing | Out-Null
            Write-Verbose 'File uploaded successfully to Azure Storage.' -Verbose
            $success = $true
        }
        catch
        {
            Write-Warning -Message "Failed to upload file to Azure Storage: $($_.Exception.Message)" -Verbose
            Start-Sleep -Seconds 2
        }
    } while ($success -eq $false -and $breakCounter -lt 5)

    # Finalize the upload to Azure Storage
    $uri = "$($sasUri)&comp=blocklist"
    $xml = '<?xml version="1.0" encoding="utf-8"?><BlockList><Latest>0001</Latest></BlockList>'
    Invoke-RestMethod -Uri $uri -Method PUT -Body $xml

    # Commit the file and update the app
    $jsonCommit = @{
        fileEncryptionInfo = @{
            fileDigestAlgorithm  = 'SHA256'
            encryptionKey        = 'yqjlzT5KYpwU0wkr5eJGGukMB0Ar8iGqYX3B0lJJnKk='
            initializationVector = 'bJujZImAWPLwZBTPvWcB0Q=='
            fileDigest           = $fileDigest
            mac                  = $mac
            profileIdentifier    = 'ProfileVersion1'
            macKey               = 'mGfhTn/0AB3fftWzENQcoU34xghAfvVq23PoiBD81tM='
        }
    }
    $commitUri = "beta/deviceAppManagement/mobileApps/$AppId/$OdataType/contentVersions/$($contentVersion.id)/files/$($file.id)/commit"
    Invoke-MgGraphRequest -Method POST -Uri $commitUri -Body $($jsonCommit | ConvertTo-Json -Depth 10)

    Wait-ForFileProcessing -AppId $AppId -OdataType $OdataType -FileId $file.id -ContentVersionId $contentVersion.id -UploadStatePrefix 'CommitFile'

    # Update the app with the committed content version
    Invoke-MgGraphRequest -Method PATCH -Uri "beta/deviceAppManagement/mobileApps/$AppId" -Body @{
        '@odata.type'           = "#$OdataType"
        committedContentVersion = '1'
    }
}

function Wait-ForFileProcessing
{
    [CmdletBinding()]
    [OutputType([System.Object])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OdataType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $FileId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ContentVersionId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $UploadStatePrefix
    )

    $fileUri = "beta/deviceAppManagement/mobileApps/$($AppId)/$OdataType/contentVersions/$ContentVersionId/files/$($FileId)"

    Write-Verbose "Waiting for file processing to complete for AppId: $AppId, OdataType: $OdataType, FileId: $FileId, ContentVersionId: $ContentVersionId"
    $file = Invoke-MgGraphRequest -Method GET -Uri $fileUri

    while ($file.uploadState -ne "$($UploadStatePrefix)Success")
    {
        if ($file.uploadState -like '*Failed')
        {
            throw "File upload failed with state: $($file.uploadState). Please check the file and try again."
        }

        Start-Sleep -Seconds 1
        Write-Verbose "Current upload state: $($file.uploadState). Waiting for processing to complete..."
        $file = Invoke-MgGraphRequest -Method GET -Uri $fileUri
    }

    $file
}
