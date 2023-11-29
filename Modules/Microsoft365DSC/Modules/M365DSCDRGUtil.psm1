function Get-StringFirstCharacterToUpper
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Value
    )

    return $Value.Substring(0,1).ToUpper() + $Value.Substring(1,$Value.length-1)
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

    return $Value.Substring(0,1).ToLower() + $Value.Substring(1,$Value.length-1)
}

function Remove-M365DSCCimInstanceTrailingCharacterFromExport
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $DSCBlock
    )

    $DSCBlock = $DSCBlock.replace("    ,`r`n" , "    `r`n" )
    $DSCBlock = $DSCBlock.replace("`r`n;`r`n" , "`r`n" )
    $DSCBlock = $DSCBlock.replace("`r`n,`r`n" , "`r`n" )

    return $DSCBlock
}
function Rename-M365DSCCimInstanceParameter
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable], [System.Collections.Hashtable[]])]
    param(
        [Parameter(Mandatory = $true)]
        $Properties,

        [Parameter(Mandatory = $false)]
        [System.Collections.Hashtable]
        $KeyMapping = @{'odataType' = '@odata.type'}
    )

    $result = $Properties

    $type = $Properties.getType().FullName

    #region Array
    if ($type -like '*[[\]]')
    {
        $values = @()
        foreach ($item in $Properties)
        {
            $values += Rename-M365DSCCimInstanceParameter $item -KeyMapping $KeyMapping
        }
        $result = $values

        return , $result
    }
    #endregion

    #region Single
    if ($type -like '*Hashtable')
    {
        $result = ([Hashtable]$Properties).clone()
    }

    if ($type -like '*CimInstance*' -or $type -like '*Hashtable*' -or $type -like '*Object*')
    {
        $hashProperties = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $result
        $keys = ($hashProperties.clone()).keys
        foreach ($key in $keys)
        {
            $keyName = $key.substring(0, 1).tolower() + $key.substring(1, $key.length - 1)
            if ($key -in $KeyMapping.Keys)
            {
                $keyName = $KeyMapping.$key
            }

            $property = $hashProperties.$key
            if ($null -ne $property)
            {
                $hashProperties.Remove($key)
                $hashProperties.add($keyName, (Rename-M365DSCCimInstanceParameter $property -KeyMapping $KeyMapping))
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
    [OutputType([hashtable], [hashtable[]])]
    param(
        [Parameter()]
        $ComplexObject
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    if ($ComplexObject.gettype().fullname -like '*[[\]]')
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
        return , [hashtable[]]$results
    }


    if ($ComplexObject.getType().fullname -like '*Dictionary*')
    {
        $results = @{}

        $ComplexObject = [hashtable]::new($ComplexObject)
        $keys = $ComplexObject.Keys

        foreach ($key in $keys)
        {
            if ($null -ne $ComplexObject.$key)
            {
                $keyName = $key
                $keyType = $ComplexObject.$key.gettype().fullname
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
        return [hashtable]$results
    }

    $results = @{}

    if ($ComplexObject.getType().Fullname -like '*hashtable')
    {
        $keys = $ComplexObject.keys
    }
    else
    {
        $keys = $ComplexObject | Get-Member | Where-Object -FilterScript { $_.MemberType -eq 'Property' }
    }

    foreach ($key in $keys)
    {
        $keyName = $key
        if ($ComplexObject.getType().Fullname -notlike '*hashtable')
        {
            $keyName = $key.Name
        }

        if ($null -ne $ComplexObject.$keyName)
        {
            $keyType = $ComplexObject.$keyName.gettype().fullname
            if ($keyType -like '*CimInstance*' -or $keyType -like '*Dictionary*' -or $keyType -like 'Microsoft.Graph.*PowerShell.Models.*')
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$keyName

                $results.Add($keyName, $hash)
            }
            else
            {
                $results.Add($keyName, $ComplexObject.$keyName)
            }
        }
    }
    return [hashtable]$results
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
        $isArray = $false
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    $indent = ''
    for ($i = 0; $i -lt $IndentLevel ; $i++)
    {
        $indent += '    '
    }
    #If ComplexObject  is an Array
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
                $splat.add('ComplexTypeMapping', $ComplexTypeMapping)
            }

            $currentProperty += Get-M365DSCDRGComplexTypeToString -isArray:$true @splat
        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , $currentProperty
    }

    $currentProperty = ''
    if ($isArray)
    {
        $currentProperty += "`r`n"
        $currentProperty += $indent
    }

    $CIMInstanceName = $CIMInstanceName.replace('MSFT_', '')
    $currentProperty += "MSFT_$CIMInstanceName{`r`n"
    $IndentLevel++
    $indent = '    ' * $IndentLevel
    $keyNotNull = 0

    if ($ComplexObject.Keys.count -eq 0)
    {
        return $null
    }

    foreach ($key in $ComplexObject.Keys)
    {
        if ($null -ne $ComplexObject.$key)
        {
            $keyNotNull++
            if ($ComplexObject.$key.GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*' -or $key -in $ComplexTypeMapping.Name)
            {
                $hashPropertyType = $ComplexObject[$key].GetType().Name.tolower()

                $isArray = $false
                if ($ComplexObject[$key].GetType().FullName -like '*[[\]]')
                {
                    $isArray = $true
                }
                #overwrite type if object defined in mapping complextypemapping
                if ($key -in $ComplexTypeMapping.Name)
                {
                    $hashPropertyType = ([Array]($ComplexTypeMapping | Where-Object -FilterScript { $_.Name -eq $key }).CimInstanceName)[0]
                    $hashProperty = $ComplexObject[$key]
                    $currentProperty += "`r`n"

                }
                else
                {
                    $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                }

                if (-not $isArray)
                {
                    $currentProperty += $indent + $key + ' = '
                }

                if ($isArray -and $key -in $ComplexTypeMapping.Name)
                {
                    if ($ComplexObject.$key.count -gt 0)
                    {
                        $currentProperty += $indent + $key + ' = '
                        $currentProperty += '@('
                    }
                }

                if ($isArray)
                {
                    $IndentLevel++
                    foreach ($item in $ComplexObject[$key])
                    {
                        if ($ComplexObject.$key.GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*')
                        {
                            $item = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                        }
                        $nestedPropertyString = Get-M365DSCDRGComplexTypeToString `
                            -ComplexObject $item `
                            -CIMInstanceName $hashPropertyType `
                            -IndentLevel $IndentLevel `
                            -ComplexTypeMapping $ComplexTypeMapping `
                            -IsArray:$true
                        if ([string]::IsNullOrWhiteSpace($nestedPropertyString))
                        {
                            $nestedPropertyString = "@()`r`n"
                        }
                        $currentProperty += $nestedPropertyString
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
                    $currentProperty += $nestedPropertyString
                }
                if ($isArray)
                {
                    if ($ComplexObject.$key.count -gt 0)
                    {
                        $currentProperty += $indent
                        $currentProperty += ')'
                        $currentProperty += "`r`n"
                    }
                }
                $isArray = $PSBoundParameters.IsArray
            }
            else
            {
                $currentValue = $ComplexObject[$key]
                if ($currentValue.GetType().Name -eq 'String')
                {
                     $currentValue = $ComplexObject[$key].Replace("'", "''").Replace("�", "''")
                }
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $currentValue -Space ($indent)
            }
        }
        else
        {
            $mappedKey = $ComplexTypeMapping | Where-Object -FilterScript { $_.name -eq $key }

            if ($mappedKey -and $mappedKey.isRequired)
            {
                if ($mappedKey.isArray)
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
    $indent = '    ' * ($IndentLevel -1)
    if ($key -in $ComplexTypeMapping.Name)
    {
        $currentProperty += "`r`n"
    }

    $currentProperty += "$indent}"
    if ($isArray -or $IndentLevel -gt 4)
    {
        $currentProperty += "`r`n"
    }

    #Indenting last parenthesis when the cim instance is an array
    if ($IndentLevel -eq 5)
    {
        $indent = '    ' * ($IndentLevel -2)
        $currentProperty += $indent
    }

    $emptyCIM = $currentProperty.replace(' ', '').replace("`r`n", '')
    if ($emptyCIM -eq "MSFT_$CIMInstanceName{}")
    {
        $currentProperty = $null
    }

    if ($null -ne $currentProperty)
    {
        $fancySingleQuotes = "[\u2019\u2018]"
        $fancyDoubleQuotes = "[\u201C\u201D]"
        $currentProperty = [regex]::Replace($currentProperty, $fancySingleQuotes, "''")
        $currentProperty = [regex]::Replace($currentProperty, $fancyDoubleQuotes, '"')
    }
    return $currentProperty
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
            $returnValue = $Space + $Key + " = '" + $Value + "'`r`n"
        }
        '*.DateTime'
        {
            $returnValue = $Space + $Key + " = '" + $Value + "'`r`n"
        }
        '*[[\]]'
        {
            $returnValue = $Space + $key + ' = @('
            $whitespace = ''
            $newline = ''
            if ($Value.count -gt 1)
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
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    '*.DateTime'
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    Default
                    {
                        $returnValue += "$whitespace$item$newline"
                    }
                }
            }
            if ($Value.count -gt 1)
            {
                $returnValue += "$Space)`r`n"
            }
            else
            {
                $returnValue += ")`r`n"

            }
        }
        Default
        {
            $returnValue = $Space + $Key + ' = ' + $Value + "`r`n"
        }
    }
    return $returnValue
}

function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter()]
        $Source,
        [Parameter()]
        $Target
    )

    #Comparing full objects
    if ($null -eq $Source -and $null -eq $Target)
    {
        return $true
    }

    $sourceValue = ''
    $targetValue = ''
    if (($null -eq $Source) -xor ($null -eq $Target))
    {
        if ($null -eq $Source)
        {
            $sourceValue = 'Source is null'
        }

        if ($null -eq $Target)
        {
            $targetValue = 'Target is null'
        }
        Write-Verbose -Message "Configuration drift - Complex object: {$sourceValue$targetValue}"
        return $false
    }

    if ($Source.getType().FullName -like '*CimInstance[[\]]' -or $Source.getType().FullName -like '*Hashtable[[\]]')
    {
        if ($source.count -ne $target.count)
        {
            Write-Verbose -Message "Configuration drift - The complex array have different number of items: Source {$($source.count)} Target {$($target.count)}"
            return $false
        }
        if ($source.count -eq 0)
        {
            return $true
        }

        foreach ($item in $Source)
        {
            $hashSource = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            foreach ($targetItem in $Target)
            {
                $compareResult = Compare-M365DSCComplexObject `
                    -Source $hashSource `
                    -Target $targetItem

                if ($compareResult)
                {
                    break
                }
            }

            if (-not $compareResult)
            {
                Write-Verbose -Message 'Configuration drift - The complex array items are not identical'
                return $false
            }
        }
        return $true
    }

    $keys = $Source.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    foreach ($key in $keys)
    {
        #Matching possible key names between Source and Target
        $skey = $key
        $tkey = $key

        $sourceValue = $Source.$key
        $targetValue = $Target.$tkey
        #One of the item is null and not the other
        if (($null -eq $Source.$key) -xor ($null -eq $Target.$tkey))
        {

            if ($null -eq $Source.$key)
            {
                $sourceValue = 'null'
            }

            if ($null -eq $Target.$tkey)
            {
                $targetValue = 'null'
            }

            #Write-Verbose -Message "Configuration drift - key: $key Source {$sourceValue} Target {$targetValue}"
            return $false
        }

        #Both keys aren't null or empty
        if (($null -ne $Source.$key) -and ($null -ne $Target.$tkey))
        {
            if ($Source.$key.getType().FullName -like '*CimInstance*' -or $Source.$key.getType().FullName -like '*hashtable*')
            {
                #Recursive call for complex object
                $compareResult = Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source.$key) `
                    -Target $Target.$tkey

                if (-not $compareResult)
                {
                    #Write-Verbose -Message "Configuration drift - complex object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject = $Target.$tkey
                $differenceObject = $Source.$key

                #Identifying date from the current values
                $targetType = ($Target.$tkey.getType()).Name
                if ($targetType -like '*Date*')
                {
                    $compareResult = $true
                    $sourceDate = [DateTime]$Source.$key
                    if ($sourceDate -ne $targetType)
                    {
                        $compareResult = $null
                    }
                }
                else
                {
                    $compareResult = Compare-Object `
                        -ReferenceObject ($referenceObject) `
                        -DifferenceObject ($differenceObject)
                }

                if ($null -ne $compareResult)
                {
                    #Write-Verbose -Message "Configuration drift - simple object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
        }
    }
    return $true
}

function Convert-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable], [hashtable[]])]
    param(
        [Parameter(Mandatory = $true)]
        $ComplexObject
    )

    if ($ComplexObject.getType().Fullname -like '*[[\]]')
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
        return , [hashtable[]]$results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject

    if ($null -ne $hashComplexObject)
    {
        $results = $hashComplexObject.clone()
        $keys = $hashComplexObject.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
        foreach ($key in $keys)
        {
            if ($hashComplexObject[$key] -and $hashComplexObject[$key].getType().Fullname -like '*CimInstance*')
            {
                $results[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            else
            {
                $propertyName = $key[0].ToString().ToLower() + $key.Substring(1, $key.Length - 1)
                $propertyValue = $results[$key]
                $results.remove($key) | Out-Null
                $results.add($propertyName, $propertyValue)
            }
        }
    }
    return [hashtable]$results
}

function Get-SettingCatalogSettingValue
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable],[System.Collections.Hashtable[]])]
    param (
        [Parameter()]
        $SettingValue,
        [Parameter()]
        $SettingValueType

    )

    switch -Wildcard ($SettingValueType)
    {
        '*ChoiceSettingInstance'
        {
            $complexValue = @{}
            $complexValue.Add('odataType',$SettingValue.'@odata.type')
            $complexValue.Add('Value',$SettingValue.value)
            $children = @()
            foreach($child in $SettingValue.children)
            {
                $complexChild = @{}
                $complexChild.Add('SettingDefinitionId', $child.settingDefinitionId)
                $complexChild.Add('odataType', $child.'@odata.type')
                $valueName = $child.'@odata.type'.replace('#microsoft.graph.deviceManagementConfiguration', '').replace('Instance', 'Value')
                $valueName = Get-StringFirstCharacterToLower -Value $valueName
                $rawValue = $child.$valueName
                $childSettingValue = Get-SettingCatalogSettingValue -SettingValue $rawValue -SettingValueType $child.'@odata.type'
                $complexChild.Add($valueName,$childSettingValue)
                $children += $complexChild
            }
            $complexValue.Add('Children',$children)
        }
        '*ChoiceSettingCollectionInstance'
        {
            $complexCollection = @()
            foreach($item in $SettingValue)
            {
                $complexValue = @{}
                $complexValue.Add('Value',$item.value)
                $children = @()
                foreach($child in $item.children)
                {
                    $complexChild = @{}
                    $complexChild.Add('SettingDefinitionId', $child.settingDefinitionId)
                    $complexChild.Add('odataType', $child.'@odata.type')
                    $valueName = $child.'@odata.type'.replace('#microsoft.graph.deviceManagementConfiguration', '').replace('Instance', 'Value')
                    $valueName = Get-StringFirstCharacterToLower -Value $valueName
                    $rawValue = $child.$valueName
                    $childSettingValue = Get-SettingCatalogSettingValue -SettingValue $rawValue  -SettingValueType $child.'@odata.type'
                    $complexChild.Add($valueName,$childSettingValue)
                    $children += $complexChild
                }
                $complexValue.Add('Children',$children)
                $complexCollection += $complexValue
            }
            return ,([hashtable[]]$complexCollection)
        }
        '*SimpleSettingInstance'
        {
            $complexValue = @{}
            $complexValue.Add('odataType',$SettingValue.'@odata.type')
            $valueName = 'IntValue'
            $value = $SettingValue.value
            if($SettingValue.'@odata.type' -ne '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue')
            {
                $valueName = 'StringValue'
            }
            $complexValue.Add($valueName,$value)
            if($SettingValue.'@odata.type' -eq '#microsoft.graph.deviceManagementConfigurationSecretSettingValue')
            {
                $complexValue.Add('ValueState',$SettingValue.valueState)
            }
        }
        '*SimpleSettingCollectionInstance'
        {
            $complexCollection = @()

            foreach($item in $SettingValue)
            {
                $complexValue = @{}
                $complexValue.Add('odataType',$item.'@odata.type')
                $valueName = 'IntValue'
                $value = $item.value
                if($item.'@odata.type' -ne '#microsoft.graph.deviceManagementConfigurationIntegerSettingValue')
                {
                    $valueName = 'StringValue'
                }
                $complexValue.Add($valueName,$value)
                if($item.'@odata.type' -eq '#microsoft.graph.deviceManagementConfigurationSecretSettingValue')
                {
                    $complexValue.Add('ValueState',$item.valueState)
                }
                $complexCollection += $complexValue
            }
            return ,([hashtable[]]$complexCollection)
        }
        '*GroupSettingInstance'
        {
            $complexValue = @{}
            $complexValue.Add('odataType',$SettingValue.'@odata.type')
            $children = @()
            foreach($child in $SettingValue.children)
            {
                $complexChild = @{}
                $complexChild.Add('SettingDefinitionId', $child.settingDefinitionId)
                $complexChild.Add('odataType', $child.'@odata.type')
                $valueName = $child.'@odata.type'.replace('#microsoft.graph.deviceManagementConfiguration', '').replace('Instance', 'Value')
                $valueName = Get-StringFirstCharacterToLower -Value $valueName
                $rawValue = $child.$valueName
                $settingValue = Get-SettingCatalogSettingValue -SettingValue $rawValue  -SettingValueType $child.'@odata.type'
                $complexChild.Add($valueName,$settingValue)
                $children += $complexChild
            }
            $complexValue.Add('Children',$children)
        }
        '*GroupSettingCollectionInstance'
        {
            $complexCollection = @()
            foreach($groupSettingValue in $SettingValue)
            {
                $complexValue = @{}
                #$complexValue.Add('odataType',$SettingValue.'@odata.type')
                $children = @()
                foreach($child in $groupSettingValue.children)
                {
                    $complexChild = @{}
                    $complexChild.Add('SettingDefinitionId', $child.settingDefinitionId)
                    $complexChild.Add('odataType', $child.'@odata.type')
                    $valueName = $child.'@odata.type'.replace('#microsoft.graph.deviceManagementConfiguration', '').replace('Instance', 'Value')
                    $valueName = Get-StringFirstCharacterToLower -Value $valueName
                    $rawValue = $child.$valueName
                    $settingValue = Get-SettingCatalogSettingValue -SettingValue $rawValue  -SettingValueType $child.'@odata.type'
                    $complexChild.Add($valueName,$settingValue)
                    $children += $complexChild
                }
                $complexValue.Add('Children',$children)
                $complexCollection += $complexValue
            }
            return ,([hashtable[]]$complexCollection)
        }
    }
    return $complexValue
}



function Get-SettingCatalogPolicySettingsFromTemplate
{
    [CmdletBinding()]
    [OutputType([System.Array])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $DSCParams,

        [Parameter(Mandatory = $true)]
        [System.String]
        $templateReferenceId
    )

    $DSCParams.Remove('Identity') | Out-Null
    $DSCParams.Remove('DisplayName') | Out-Null
    $DSCParams.Remove('Description') | Out-Null

    $settings = @()

    $templateSettings = Get-MgDeviceManagementConfigurationPolicyTemplateSettingTemplate -DeviceManagementConfigurationPolicyTemplateId $templateReferenceId

    $simpleSettings = @()
    $simpleSettings += $templateSettings.SettingInstanceTemplate | Where-Object -FilterScript `
    { $_.AdditionalProperties.'@odata.type' -ne '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstanceTemplate' }
    foreach ($templateSetting in $simpleSettings)
    {
        $setting = @{}
        $settingKey = $DSCParams.keys | Where-Object -FilterScript { $templateSetting.settingDefinitionId -like "*$($_)" }
        if ((-not [String]::IsNullOrEmpty($settingKey)) -and $DSCParams."$settingKey")
        {
            $setting.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationSetting')
            $myFormattedSetting = Format-M365DSCParamsToSettingInstance -DSCParams @{$settingKey = $DSCParams."$settingKey" } `
                -TemplateSetting $templateSetting

            $setting.add('settingInstance', $myFormattedSetting)
            $settings += $setting
            $DSCParams.Remove($settingKey) | Out-Null
        }
    }

    #Prepare attacksurfacereductionrules groupCollectionTemplateSettings
    $groupCollectionTemplateSettings = @()
    $groupCollectionTemplateSettings += $templateSettings.SettingInstanceTemplate | Where-Object -FilterScript `
    { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstanceTemplate' }

    foreach ($groupCollectionTemplateSetting in $groupCollectionTemplateSettings)
    {
        $setting = @{}
        $setting.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationSetting')
        $settingInstance = [ordered]@{}
        $settingInstance.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance')
        $settingInstance.add('settingDefinitionId', $groupCollectionTemplateSetting.settingDefinitionId)
        $settingInstance.add('settingInstanceTemplateReference', @{
                '@odata.type'               = '#microsoft.graph.deviceManagementConfigurationSettingInstanceTemplateReference'
                'settingInstanceTemplateId' = $groupCollectionTemplateSetting.settingInstanceTemplateId
            })
        $groupSettingCollectionValues = @()
        $groupSettingCollectionValueChildren = @()
        $groupSettingCollectionValue = @{}
        $groupSettingCollectionValue.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationGroupSettingValue')

        $settingValueTemplateId = $groupCollectionTemplateSetting.AdditionalProperties.groupSettingCollectionValueTemplate.settingValueTemplateId
        if (-Not [string]::IsNullOrEmpty($settingValueTemplateId))
        {
            $groupSettingCollectionValue.add('settingValueTemplateReference', @{'settingValueTemplateId' = $SettingValueTemplateId })
        }

        foreach ($key in $DSCParams.keys)
        {
            $templateValue = $groupCollectionTemplateSetting.AdditionalProperties.groupSettingCollectionValueTemplate.children | Where-Object `
                -FilterScript { $_.settingDefinitionId -like "*$key" }
            if ($templateValue)
            {
                $groupSettingCollectionValueChild = Format-M365DSCParamsToSettingInstance `
                    -DSCParams @{$key = $DSCParams."$key" } `
                    -TemplateSetting $templateValue `
                    -IncludeSettingValueTemplateId $false `
                    -IncludeSettingInstanceTemplateId $false

                $groupSettingCollectionValueChildren += $groupSettingCollectionValueChild
            }
        }
        $groupSettingCollectionValue.add('children', $groupSettingCollectionValueChildren)
        $groupSettingCollectionValues += $groupSettingCollectionValue
        $settingInstance.add('groupSettingCollectionValue', $groupSettingCollectionValues)
        $setting.add('settingInstance', $settingInstance)

        if ($setting.settingInstance.groupSettingCollectionValue.children.count -gt 0)
        {
            $settings += $setting
        }
    }

    return $settings
}

function New-IntuneSettingCatalogPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

        [Parameter(Mandatory = $true)]
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
        [Array]
        $Settings
    )

    try
    {
	$BaseUrl = $Global:MSCloudLoginConnectionProfile.Intune.GraphBaseUrl
        $Uri = '$($BaseUrl)/beta/deviceManagement/configurationPolicies'

        $policy = @{
            'name'              = $Name
            'description'       = $Description
            'platforms'         = $Platforms
            'technologies'      = $Technologies
            'templateReference' = @{'templateId' = $TemplateReferenceId }
            'settings'          = $Settings
        }
        $body = $policy | ConvertTo-Json -Depth 20
        #write-verbose -Message $body
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

function Update-IntuneSettingCatalogPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
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
        [Array]
        $Settings
    )

    try
    {
        $BaseUrl = $Global:MSCloudLoginConnectionProfile.Intune.GraphBaseUrl
        $Uri = "$($BaseUrl)/beta/deviceManagement/configurationPolicies/$DeviceConfigurationPolicyId"

        $policy = @{
            'name'              = $Name
            'description'       = $Description
            'platforms'         = $Platforms
            'templateReference' = @{'templateId' = $TemplateReferenceId }
            'technologies'      = $Technologies
            'settings'          = $Settings
        }
        $body = $policy | ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method PUT -Uri $Uri -Body $body -ErrorAction Stop
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

    $assignmentResult = @()
    foreach ($assignment in $Assignments)
    {
        $hashAssignment = @{}
        $dataType = $assignment.Target.AdditionalProperties."@odata.type"
        $groupId = $assignment.Target.AdditionalProperties.groupId

        $hashAssignment.add('dataType',$dataType)
        if (-not [string]::IsNullOrEmpty($groupId))
        {
            $hashAssignment.add('groupId', $groupId)

            $group = Get-MgGroup -GroupId ($groupId) -ErrorAction SilentlyContinue
            if ($null -ne $group)
            {
                $hashAssignment.add('groupDisplayName', $group.DisplayName)
            }
        }
        if ($IncludeDeviceFilter)
        {
            if ($null -ne $assignment.Target.DeviceAndAppManagementAssignmentFilterType)
            {
                $hashAssignment.add('deviceAndAppManagementAssignmentFilterType', $assignment.Target.DeviceAndAppManagementAssignmentFilterType.ToString())
            }
            if ($null -ne $assignment.Target.DeviceAndAppManagementAssignmentFilterId)
            {
                $hashAssignment.add('deviceAndAppManagementAssignmentFilterId', $assignment.Target.DeviceAndAppManagementAssignmentFilterId)
            }
        }

        $assignmentResult += $hashAssignment
    }

    return $assignmentResult
}

function ConvertTo-IntunePolicyAssignment
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param (
        [Parameter(Mandatory = $true)]
        $Assignments,
        [Parameter()]
        [System.Boolean]
        $IncludeDeviceFilter = $true
    )

    $assignmentResult = @()
    foreach ($assignment in $Assignments)
    {
        $target = @{"@odata.type" = $assignment.dataType}
        if ($IncludeDeviceFilter)
        {
            if ($null -ne $assignment.DeviceAndAppManagementAssignmentFilterId)
            {
                $target.add('deviceAndAppManagementAssignmentFilterId', $assignment.DeviceAndAppManagementAssignmentFilterId)
            }
            if ($null -ne $assignment.DeviceAndAppManagementAssignmentFilterType)
            {
                $target.add('deviceAndAppManagementAssignmentFilterType',$assignment.DeviceAndAppManagementAssignmentFilterType)
            }
        }
        if ($assignment.dataType -like '*GroupAssignmentTarget')
        {
            $group = Get-MgGroup -GroupId ($assignment.groupId) -ErrorAction SilentlyContinue
            if ($null -eq $group)
            {
                $group = Get-MgGroup -Filter "DisplayName eq '$($assignment.groupDisplayName)'" -ErrorAction SilentlyContinue
                if ($null -eq $group)
                {
                    $message = "Skipping assignment for the group with DisplayName {$($assignment.groupDisplayName)} as it could not be found in the directory.`r`n"
                    $message += "Please update your DSC resource extract with the correct groupId or groupDisplayName."
                    write-verbose -Message $message
                    $target = $null
                }
                if ($group -and $group.count -gt 1)
                {
                    $message = "Skipping assignment for the group with DisplayName {$($assignment.groupDisplayName)} as it is not unique in the directory.`r`n"
                    $message += "Please update your DSC resource extract with the correct groupId or a unique group DisplayName."
                    write-verbose -Message $message
                    $group = $null
                    $target = $null
                }
            }
            #Skipping assignment if group not found from either groupId or groupDisplayName
            if ($null -ne $group)
            {
                $target.add('groupId',$group.Id)
            }
        }

        if ($target)
        {
            $assignmentResult += @{target = $target}
        }
    }

    return $assignmentResult
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
        [ValidateSet('v1.0','beta')]
        [System.String]
        $APIVersion = 'beta'
    )
    try
    {
        $deviceManagementPolicyAssignments = @()
        $BaseUrl = $Global:MSCloudLoginConnectionProfile.Intune.GraphBaseUrl
        $Uri = "$($BaseUrl)/$APIVersion/$Repository/$DeviceConfigurationPolicyId/assign"

        foreach ($target in $targets)
        {
            $formattedTarget = @{"@odata.type" = $target.dataType}
            if ($target.groupId)
            {
                $formattedTarget.Add('groupId',$target.groupId)
            }
            if ($target.collectionId)
            {
                $formattedTarget.Add('collectionId',$target.collectionId)
            }
            if ($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType',$target.deviceAndAppManagementAssignmentFilterType)
            }
            if ($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId',$target.deviceAndAppManagementAssignmentFilterId)
            }
            $deviceManagementPolicyAssignments += @{'target' = $formattedTarget}
        }
        $body = @{'assignments' = $deviceManagementPolicyAssignments} | ConvertTo-Json -Depth 20
        #write-verbose -Message $body
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
