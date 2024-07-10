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
            try
            {
                $values += Rename-M365DSCCimInstanceParameter $item -KeyMapping $KeyMapping
            }
            catch
            {
                Write-Verbose -Message "Error getting values for item {$item}"
            }
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
                try
                {
                    $subValue = Rename-M365DSCCimInstanceParameter $property -KeyMapping $KeyMapping
                    if ($null -ne $subValue)
                    {
                        $hashProperties.add($keyName, $subValue)
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

                if ($null -ne $hash -and $hash.Keys.Count -gt 0)
                {
                    $results.Add($keyName, $hash)
                }
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

    if ($Source.GetType().FullName -like '*CimInstance[[\]]' -or $Source.GetType().FullName -like '*Hashtable[[\]]')
    {
        if ($Source.Count -ne $Target.Count)
        {
            Write-Verbose -Message "Configuration drift - The complex array have different number of items: Source {$($Source.Count)} Target {$($Target.Count)}"
            return $false
        }
        if ($Source.Count -eq 0)
        {
            return $true
        }

        if ($Source[0].CimClass.CimClassName -eq 'MSFT_DeviceManagementConfigurationPolicyAssignments' -or
            $Source[0].CimClass.CimClassName -like 'MSFT_Intune*Assignments')
        {
            $compareResult = Compare-M365DSCIntunePolicyAssignment `
                -Source @($Source) `
                -Target @($Target)

            if (-not $compareResult)
            {
                Write-Verbose -Message "Configuration drift - Intune Policy Assignment: $key Source {$Source} Target {$Target}"
                return $false
            }

            return $true
        }

        foreach ($item in $Source)
        {
            foreach ($targetItem in $Target)
            {
                $compareResult = Compare-M365DSCComplexObject `
                    -Source $item `
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

    if ($Source.GetType().FullName -like "*CimInstance")
    {
        $keys = @()
        $Source.CimInstanceProperties | Foreach-Object {
            if ($_.Name -notin @('PSComputerName', 'CimClass', 'CimInstanceProperties', 'CimSystemProperties') `
                -and $_.IsValueModified)
            {
                $keys += $_.Name
            }
        }
    }
    else
    {
        $keys = $Source.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    }

    if ($Target.GetType().FullName -like "*CimInstance")
    {
        $targetKeys = @()
        $Target.CimInstanceProperties | Foreach-Object {
            if ($_.Name -notin @('PSComputerName', 'CimClass', 'CimInstanceProperties', 'CimSystemProperties') `
                -and $_.IsValueModified)
            {
                $targetKeys += $_.Name
            }
        }
    }
    elseif ($Target.GetType().FullName -like "*Hashtable")
    {
        $targetKeys = $Target.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    }
    else # Most likely a Microsoft Graph Model
    {
        $Target = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Target
        $targetKeys = $Target.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    }

    foreach ($key in $keys)
    {
        #Matching possible key names between Source and Target
        $sourceValue = $Source.$key

        # Some classes might contain default properties that have the same name as the key,
        # so we need to check if the key is present in the target object --> Hashtable <-> IsReadOnly property
        if ($key -in $targetKeys)
        {
            $targetValue = $Target.$key
        }
        else
        {
            $targetValue = $null
        }

        #One of the item is null and not the other
        if (($null -eq $Source.$key) -xor ($null -eq $targetValue))
        {
            if ($null -eq $Source.$key)
            {
                $sourceValue = 'null'
            }

            if ($null -eq $targetValue)
            {
                $targetValue = 'null'
            }

            Write-Verbose -Message "Configuration drift - key: $key Source {$sourceValue} Target {$targetValue}"
            return $false
        }

        #Both keys aren't null or empty
        if (($null -ne $Source.$key) -and ($null -ne $Target.$key))
        {
            if ($Source.$key.GetType().FullName -like '*CimInstance*' -or $Source.$key.GetType().FullName -like '*hashtable*')
            {
                if ($Source.$key.GetType().FullName -like '*CimInstance' -and (
                        $Source.$key.CimClass.CimClassName -eq 'MSFT_DeviceManagementConfigurationPolicyAssignments' -or
                        $Source.$key.CimClass.CimClassName -like 'MSFT_Intune*Assignments'))
                {
                    $compareResult = Compare-M365DSCIntunePolicyAssignment `
                        -Source @($Source.$key) `
                        -Target @($Target.$key)
                }
                else
                {
                    #Recursive call for complex object
                    $compareResult = Compare-M365DSCComplexObject `
                        -Source $Source.$key `
                        -Target $Target.$key
                }

                if (-not $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - complex object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject = $Target.$key
                $differenceObject = $Source.$key

                #Identifying date from the current values
                $targetType = ($Target.$key.GetType()).Name
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
                    Write-Verbose -Message "Configuration drift - simple object key: $key Source {$sourceValue} Target {$targetValue}"
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
        $collectionId = $assignment.Target.AdditionalProperties.collectionId

        $hashAssignment.Add('dataType',$dataType)
        if (-not [string]::IsNullOrEmpty($groupId))
        {
            $hashAssignment.Add('groupId', $groupId)

            $group = Get-MgGroup -GroupId ($groupId) -ErrorAction SilentlyContinue
            if ($null -ne $group)
            {
                $groupDisplayName = $group.DisplayName
            }
        }
        if (-not [string]::IsNullOrEmpty($collectionId))
        {
            $hashAssignment.Add('collectionId', $collectionId)
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
        if ($IncludeDeviceFilter)
        {
            if ($null -ne $assignment.Target.DeviceAndAppManagementAssignmentFilterType)
            {
                $hashAssignment.Add('deviceAndAppManagementAssignmentFilterType', $assignment.Target.DeviceAndAppManagementAssignmentFilterType.ToString())
            }
            if ($null -ne $assignment.Target.DeviceAndAppManagementAssignmentFilterId)
            {
                $hashAssignment.Add('deviceAndAppManagementAssignmentFilterId', $assignment.Target.DeviceAndAppManagementAssignmentFilterId)
            }
        }

        $assignmentResult += $hashAssignment
    }

    return ,$assignmentResult
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

    if ($null -eq $Assignments)
    {
        return ,@()
    }

    $assignmentResult = @()
    foreach ($assignment in $Assignments)
    {
        $target = @{"@odata.type" = $assignment.dataType}
        if ($IncludeDeviceFilter)
        {
            if ($null -ne $assignment.DeviceAndAppManagementAssignmentFilterType)
            {
                $target.Add('deviceAndAppManagementAssignmentFilterType', $assignment.DeviceAndAppManagementAssignmentFilterType)
                $target.Add('deviceAndAppManagementAssignmentFilterId', $assignment.DeviceAndAppManagementAssignmentFilterId)
            }
        }
        if ($assignment.dataType -like '*CollectionAssignmentTarget')
        {
            $target.add('collectionId', $assignment.collectionId)
        }
        elseif ($assignment.dataType -like '*GroupAssignmentTarget')
        {
            $group = Get-MgGroup -GroupId ($assignment.groupId) -ErrorAction SilentlyContinue
            if ($null -eq $group)
            {
                if ($assignment.groupDisplayName)
                {
                    $group = Get-MgGroup -Filter "DisplayName eq '$($assignment.groupDisplayName)'" -ErrorAction SilentlyContinue
                    if ($null -eq $group)
                    {
                        $message = "Skipping assignment for the group with DisplayName {$($assignment.groupDisplayName)} as it could not be found in the directory.`r`n"
                        $message += "Please update your DSC resource extract with the correct groupId or groupDisplayName."
                        Write-Verbose -Message $message
                        $target = $null
                    }
                    if ($group -and $group.Count -gt 1)
                    {
                        $message = "Skipping assignment for the group with DisplayName {$($assignment.groupDisplayName)} as it is not unique in the directory.`r`n"
                        $message += "Please update your DSC resource extract with the correct groupId or a unique group DisplayName."
                        Write-Verbose -Message $message
                        $group = $null
                        $target = $null
                    }
                }
                else
                {
                    $message = "Skipping assignment for the group with Id {$($assignment.groupId)} as it could not be found in the directory.`r`n"
                    $message += "Please update your DSC resource extract with the correct groupId or a unique group DisplayName."
                    Write-Verbose -Message $message
                    $target = $null
                }
            }
            #Skipping assignment if group not found from either groupId or groupDisplayName
            if ($null -ne $group)
            {
                $target.Add('groupId', $group.Id)
            }
        }

        if ($target)
        {
            $assignmentResult += @{target = $target}
        }
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

    $testResult = $Source.Count -eq $Target.Count
    Write-Verbose "Count: $($Source.Count) - $($Target.Count)"
    if ($testResult)
    {
        foreach ($assignment in $Source)
        {
            if ($assignment.dataType -like '*AssignmentTarget')
            {
                $assignmentTarget = $Target | Where-Object -FilterScript { $_.dataType -eq $assignment.DataType -and $_.groupId -eq $assignment.groupId }
                $testResult = $null -ne $assignmentTarget
                # Using assignment groupDisplayName only if the groupId is not found in the directory otherwise groupId should be the key
                if (-not $testResult)
                {
                    Write-Verbose 'Group not found by groupId, checking if group exists by id'
                    $groupNotFound =  $null -eq (Get-MgGroup -GroupId ($assignment.groupId) -ErrorAction SilentlyContinue)
                }
                if (-not $testResult -and $groupNotFound)
                {
                    Write-Verbose 'Group not found by groupId, looking for group by groupDisplayName'
                    $assignmentTarget = $Target | Where-Object -FilterScript { $_.dataType -eq $assignment.DataType -and $_.groupDisplayName -eq $assignment.groupDisplayName }
                    $testResult = $null -ne $assignmentTarget
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
                    }
                }

                if ($testResult)
                {
                    Write-Verbose 'Group and filters match, checking collectionId'
                    $testResult = $assignment.collectionId -eq $assignmentTarget.collectionId
                }
            }
            else
            {
                $testResult = $null -ne ($Target | Where-Object -FilterScript { $_.dataType -eq $assignment.DataType })
            }
            if (-not $testResult) { break }
        }
    }

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
        [ValidateSet('v1.0','beta')]
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
            if ($target.target -is [hashtable])
            {
                $target = $target.target
            }

            $formattedTarget = @{"@odata.type" = $target.dataType}
            if(-not $formattedTarget."@odata.type" -and $target."@odata.type")
            {
                $formattedTarget."@odata.type" = $target."@odata.type"
            }
            if ($target.groupId)
            {
                $group = Get-MgGroup -GroupId ($target.groupId) -ErrorAction SilentlyContinue
                if ($null -eq $group)
                {
                    if ($target.groupDisplayName)
                    {
                        $group = Get-MgGroup -Filter "DisplayName eq '$($target.groupDisplayName)'" -ErrorAction SilentlyContinue
                        if ($null -eq $group)
                        {
                            $message = "Skipping assignment for the group with DisplayName {$($target.groupDisplayName)} as it could not be found in the directory.`r`n"
                            $message += "Please update your DSC resource extract with the correct groupId or groupDisplayName."
                            write-verbose -Message $message
                            $target = $null
                        }
                        if ($group -and $group.count -gt 1)
                        {
                            $message = "Skipping assignment for the group with DisplayName {$($target.groupDisplayName)} as it is not unique in the directory.`r`n"
                            $message += "Please update your DSC resource extract with the correct groupId or a unique group DisplayName."
                            write-verbose -Message $message
                            $group = $null
                            $target = $null
                        }
                    }
                    else
                    {
                        $message = "Skipping assignment for the group with Id {$($target.groupId)} as it could not be found in the directory.`r`n"
                        $message += "Please update your DSC resource extract with the correct groupId or a unique group DisplayName."
                        write-verbose -Message $message
                        $target = $null
                    }
                }
                #Skipping assignment if group not found from either groupId or groupDisplayName
                if ($null -ne $group)
                {
                    $formattedTarget.add('groupId',$group.Id)
                }
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

        $body = @{$RootIdentifier = $deviceManagementPolicyAssignments} | ConvertTo-Json -Depth 20
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

function Get-OmaSettingPlainTextValue
{
    [CmdletBinding()]
    [OutputType([System.String])]
    Param(
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
        $SplitSecretReferenceValueId = $SecretReferenceValueId.Split("_")
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
        $Message = "Error decrypting OmaSetting with SecretReferenceValueId {0}:" -f $SecretReferenceValueId
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
    } else {
        return $null
    }
}

function Get-IntuneSettingCatalogPolicySetting
{
    [CmdletBinding()]
    [OutputType([System.Array])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $DSCParams,
        [Parameter(Mandatory = 'true')]
        [System.String]
        $TemplateId
    )

    $global:excludedDefinitionIds = @()

    $DSCParams.Remove('Identity') | Out-Null
    $DSCParams.Remove('DisplayName') | Out-Null
    $DSCParams.Remove('Description') | Out-Null

    # Prepare setting definitions mapping
    $settingTemplates = Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate -DeviceManagementConfigurationPolicyTemplateId $TemplateId -ExpandProperty 'SettingDefinitions'
    $settingInstances = @()

    # Iterate over all setting instance templates
    foreach ($settingInstanceTemplate in $settingTemplates.SettingInstanceTemplate)
    {
        $settingInstance = @{}
        $settingDefinition = $settingTemplates.SettingDefinitions | Where-Object {
            $_.Id -eq $settingInstanceTemplate.SettingDefinitionId -and `
            ($_.AdditionalProperties.dependentOn.Count -eq 0 -and $_.AdditionalProperties.options.dependentOn.Count -eq 0)
        }
        $settingName = $settingInstanceTemplate.SettingDefinitionId.split('_') | Select-Object -Last 1
        $settingType = $settingInstanceTemplate.AdditionalProperties.'@odata.type'.Replace('InstanceTemplate', 'Instance')
        $settingInstance.Add('@odata.type', $settingType)
        if (-not [string]::IsNullOrEmpty($settingInstanceTemplate.settingInstanceTemplateId))
        {
            $settingInstance.Add('settingInstanceTemplateReference', @{'settingInstanceTemplateId' = $settingInstanceTemplate.settingInstanceTemplateId })
        }
        $settingValueName = $settingType.Replace('#microsoft.graph.deviceManagementConfiguration', '').Replace('Instance', 'Value')
        $settingValueName = $settingValueName.Substring(0, 1).ToLower() + $settingValueName.Substring(1, $settingValueName.length - 1 )
        $settingValueType = $settingInstanceTemplate.AdditionalProperties."$($settingValueName)Template".'@odata.type'
        if ($null -ne $settingValueType)
        {
            $settingValueType = $settingValueType.Replace('ValueTemplate', 'Value')
        }
        $settingValueTemplateId = $settingInstanceTemplate.AdditionalProperties."$($settingValueName)Template".settingValueTemplateId

        # Get all the values in the setting instance
        $settingValue = Get-IntuneSettingCatalogPolicySettingInstanceValue `
            -DSCParams $DSCParams `
            -SettingDefinition $settingDefinition `
            -SettingTemplates $settingTemplates `
            -SettingName $settingName `
            -SettingType $settingType `
            -SettingValueName $settingValueName `
            -SettingValueType $settingValueType `
            -SettingValueTemplateId $settingValueTemplateId

        if ($settingValue.Count -gt 0)
        {
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
        $SettingTemplates,

        [Parameter()]
        [System.String]
        $SettingType,

        [Parameter()]
        [System.String]
        $SettingName,

        [Parameter()]
        [System.String]
        $SettingValueName,

        [Parameter()]
        [System.String]
        $SettingValueType,

        [Parameter()]
        [System.String]
        $SettingValueTemplateId
    )

    $settingValuesToReturn = @{}
    if ($null -eq $global:excludedDefinitionIds)
    {
        $global:excludedDefinitionIds = @()
    }
    if ($null -eq $global:excludedDscParams)
    {
        $global:excludedDscParams = @()
    }

    # Depending on the setting type, there is other logic involved
    switch ($settingType)
    {
        # GroupSettingCollections are a collection of settings without a value of their own
        '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
        {
            $groupSettingCollectionValue = @{}
            $groupSettingCollectionValueChildren = @()

            $groupSettingCollectionDefinitionChildren = $SettingTemplates.SettingDefinitions | Where-Object {
                ($_.AdditionalProperties.dependentOn.Count -gt 0 -and $_.AdditionalProperties.dependentOn.parentSettingId.Contains($SettingDefinition.Id)) -or
                ($_.AdditionalProperties.options.dependentOn.Count -gt 0 -and $_.AdditionalProperties.options.dependentOn.parentSettingId.Contains($SettingDefinition.Id))
            }
            foreach ($childDefinition in $groupSettingCollectionDefinitionChildren)
            {
                $childSettingName = $childDefinition.Name
                $childSettingType = $childDefinition.AdditionalProperties.'@odata.type'.Replace('Definition', 'Instance')
                $childSettingValueName = $childSettingType.Replace('#microsoft.graph.deviceManagementConfiguration', '').Replace('Instance', 'Value')
                $childSettingValueType = "#microsoft.graph.deviceManagementConfiguration$($childSettingValueName)"
                $childSettingValueName = $childSettingValueName.Substring(0, 1).ToLower() + $childSettingValueName.Substring(1, $childSettingValueName.length - 1 )
                $childSettingValue = Get-IntuneSettingCatalogPolicySettingInstanceValue `
                    -DSCParams $DSCParams `
                    -SettingDefinition $childDefinition `
                    -SettingTemplates $SettingTemplates `
                    -SettingName $childSettingName `
                    -SettingType $childDefinition.AdditionalProperties.'@odata.type' `
                    -SettingValueName $childSettingValueName `
                    -SettingValueType $childSettingValueType

                if ($childSettingValue.Keys.Count -gt 0)
                {
                    if ($childSettingValue.Keys -notcontains 'settingDefinitionId')
                    {
                        $childSettingValue.Add('settingDefinitionId', $childDefinition.Id)
                    }
                    $childSettingValue.Add('@odata.type', $childSettingType)
                    $groupSettingCollectionValueChildren += $childSettingValue
                }
            }

            if ($groupSettingCollectionDefinitionChildren.Count -gt 0) {
                $groupSettingCollectionValue.Add('children', $groupSettingCollectionValueChildren)
                $settingValuesToReturn.Add('groupSettingCollectionValue', @($groupSettingCollectionValue))
            }
        }
        # ChoiceSetting is a choice (e.g. dropdown) setting that, depending on the choice, can have children settings
        { $_ -eq '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance' -or $_ -eq '#microsoft.graph.deviceManagementConfigurationChoiceSettingDefinition' }
        {
            $choiceSettingValue = @{}
            $choiceSettingValueChildren = @()

            # Choice settings almost always have children settings, so we need to fetch those
            $choiceSettingDefinitionChildren = $SettingTemplates.SettingDefinitions | Where-Object {
                ($_.AdditionalProperties.dependentOn.Count -gt 0 -and $_.AdditionalProperties.dependentOn.parentSettingId.Contains($SettingDefinition.Id)) -or
                ($_.AdditionalProperties.options.dependentOn.Count -gt 0 -and $_.AdditionalProperties.options.dependentOn.parentSettingId.Contains($SettingDefinition.Id))
            }
            foreach ($childDefinition in $choiceSettingDefinitionChildren)
            {
                $childSettingName = $childDefinition.Name
                $childSettingType = $childDefinition.AdditionalProperties.'@odata.type'.Replace('Definition', 'Instance')
                $childSettingValueName = $childSettingType.Replace('#microsoft.graph.deviceManagementConfiguration', '').Replace('Instance', 'Value')
                $childSettingValueType = "#microsoft.graph.deviceManagementConfiguration$($childSettingValueName)"
                $childSettingValueName = $childSettingValueName.Substring(0, 1).ToLower() + $childSettingValueName.Substring(1, $childSettingValueName.Length - 1 )
                $childSettingValue = Get-IntuneSettingCatalogPolicySettingInstanceValue `
                    -DSCParams $DSCParams `
                    -SettingDefinition $childDefinition `
                    -SettingTemplates $SettingTemplates `
                    -SettingName $childSettingName `
                    -SettingType $childDefinition.AdditionalProperties.'@odata.type' `
                    -SettingValueName $childSettingValueName `
                    -SettingValueType $childSettingValueType

                if ($childSettingValue.Keys.Count -gt 0)
                {
                    if ($childSettingValue.Keys -notcontains 'settingDefinitionId')
                    {
                        $childSettingValue.Add('settingDefinitionId', $childDefinition.Id)
                    }
                    $childSettingValue.Add('@odata.type', $childSettingType)
                    $choiceSettingValueChildren += $childSettingValue
                }
            }

            # Depending on the children count, we add the children to the choice setting or an empty array since the children property is required
            if ($choiceSettingDefinitionChildren.Count -gt 0) {
                $choiceSettingValue.Add('children', $choiceSettingValueChildren)
            } else {
                $choiceSettingValue.Add('children', @())
            }

            $paramKey = $null
            $paramKey = $DSCParams.Keys | Where-Object { $_ -eq $SettingName }
            if ($null -eq $paramKey)
            {
                $paramKey = $SettingName
            }

            # If there is a value in the DSC params, we add that to the choice setting
            if ($null -ne $DSCParams[$paramKey])
            {
                $value = "$($SettingDefinition.Id)_$($DSCParams[$paramKey])"
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
        # SimpleSettingCollections are collections of simple settings, e.g. strings or integers
        { $_ -eq '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance' -or $_ -eq '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionDefinition' }
        {
            [array]$values = @()
            # Go over all the values that have not yet been processed
            foreach ($key in ($DSCParams.Keys | Where-Object { $_ -notin $global:excludedDscParams }))
            {
                $matchCombined = $false
                $matchesId = $false
                $name = $SettingTemplates.SettingDefinitions.Name | Where-Object -FilterScript { $_ -eq $key }
                if ($name.Count -ne 1)
                {
                    # Key might have been combined with parent setting, try to split it
                    if ($key -like "*_*")
                    {
                        $parentSettingName = $key.Split('_')[0]
                        $childSettingName = $key.Replace("$($parentSettingName)_", '')
                        $parentDefinition = $SettingTemplates.SettingDefinitions | Where-Object { $_.Name -eq $parentSettingName }
                        $childDefinition = $SettingTemplates.SettingDefinitions | Where-Object { $_.Name -eq $childSettingName -and $_.AdditionalProperties.dependentOn.parentSettingId.Contains($parentDefinition.Id) }
                        if ($null -ne $parentDefinition -and $null -ne $childDefinition)
                        {
                            # Parent was combined with child setting. Since there can be multiple settings with the same Name, we need to check the Id as well
                            if ($SettingDefinition.Id -eq $childDefinition.Id)
                            {
                                $global:excludedDscParams += $key
                                $matchCombined = $true
                            }
                        }
                    }

                    if (-not $matchCombined)
                    {
                        # Parent was not combined, look for the Id
                        $SettingTemplates.SettingDefinitions | ForEach-Object {
                            if ($_.Id -notin $global:excludedDefinitionIds -and $_.Name -eq $SettingName -and $_.Id -like "*$key")
                            {
                                $global:excludedDefinitionIds += $_.Id
                                $matchesId = $true
                            }
                        }
                    }
                }

                # If there is exactly one setting with the name, the setting is combined or the id matches, we add the DSC value to the values array and update the real setting value type
                if (($name.Count -eq 1 -and $SettingName -eq $key) -or $matchCombined -or $matchesId)
                {
                    if ($SettingValueType -like "*Simple*")
                    {
                        if ($DSCParams[$key] -is [System.String[]])
                        {
                            $SettingValueType = "#microsoft.graph.deviceManagementConfigurationStringSettingValue"
                        }
                        elseif ($DSCParams[$key] -is [System.Int32[]])
                        {
                            $SettingValueType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                        }
                    }
                    $values += $DSCParams[$key]
                    break
                }
            }
            $settingValueCollection = @()
            foreach ($v in $values)
            {
                $settingValueCollection += @{
                    value         = $v
                    '@odata.type' = $SettingValueType
                }
            }
            if ($settingValueCollection.Count -gt 0) {
                $settingValuesToReturn.Add($SettingValueName, $settingValueCollection)
            }
        }
        # For all other types, e.g. Integer, String, Boolean, etc., we add the value directly
        Default
        {
            $value = $null
            # Go over all the values that have not yet been processed
            foreach ($key in ($DSCParams.Keys | Where-Object { $_ -notin $global:excludedDscParams }))
            {
                $matchCombined = $false
                $matchesId = $false
                $name = $SettingTemplates.SettingDefinitions.Name | Where-Object -FilterScript { $_ -eq $key }
                if ($name.Count -ne 1)
                {
                    # Key might have been combined with parent setting, try to split it
                    if ($key -like "*_*")
                    {
                        $parentSettingName = $key.Split('_')[0]
                        $childSettingName = $key.Replace("$($parentSettingName)_", '')
                        $parentDefinition = $SettingTemplates.SettingDefinitions | Where-Object { $_.Name -eq $parentSettingName }
                        $childDefinition = $SettingTemplates.SettingDefinitions | Where-Object { $_.Name -eq $childSettingName }
                        if ($null -ne $parentDefinition -and $null -ne $childDefinition)
                        {
                            # Parent was combined with child setting
                            $global:excludedDscParams += $key
                            $matchCombined = $true
                        }
                    }

                    if (-not $matchCombined)
                    {
                        # Parent was not combined, look for the id
                        $SettingTemplates.SettingDefinitions | ForEach-Object {
                            if ($_.Id -notin $global:excludedDefinitionIds -and $_.Name -eq $SettingName -and $_.Id -like "*$key")
                            {
                                $global:excludedDefinitionIds += $_.Id
                                $matchesId = $true
                                $SettingDefinition = $_
                            }
                        }
                    }
                }

                # If there is exactly one setting with the name, the setting is combined or the id matches, we get the DSC value update the real setting value type
                if (($name.Count -eq 1 -and $SettingName -eq $key) -or $matchCombined -or $matchesId)
                {
                    if ($SettingValueType -like "*Simple*")
                    {
                        if ($DSCParams[$key] -is [System.String])
                        {
                            $SettingValueType = "#microsoft.graph.deviceManagementConfigurationStringSettingValue"
                        }
                        elseif ($DSCParams[$key] -is [System.Int32])
                        {
                            $SettingValueType = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                        }
                    }
                    if ($SettingValueType -like "*Simple*" -or $SettingValueType -in @("#microsoft.graph.deviceManagementConfigurationIntegerSettingValue", "#microsoft.graph.deviceManagementConfigurationStringSettingValue"))
                    {
                        $value = $DSCParams[$key]
                    }
                    else
                    {
                        $value = "$($SettingDefinition.Id)_$($DSCParams[$key])"
                    }
                    break
                }
            }

            if ($null -eq $value)
            {
                return $null
            }

            $settingValue = @{}
            if (-not [string]::IsNullOrEmpty($SettingValueType))
            {
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
            ParameterSetName = 'Setting'
        )]
        [switch]$IsRoot
    )

    if ($PSCmdlet.ParameterSetName -eq 'Start')
    {
        foreach ($setting in $Settings)
        {
            Export-IntuneSettingCatalogPolicySettings -SettingInstance $setting.SettingInstance -SettingDefinitions $setting.SettingDefinitions -ReturnHashtable $ReturnHashtable -IsRoot
        }
        return $ReturnHashtable
    }

    $addToParameters = $true
    $settingDefinition = $SettingDefinitions | Where-Object -FilterScript { $_.Id -eq $SettingInstance.settingDefinitionId }
    $settingName = $settingDefinition.Name

    # Check if the name is unique
    $settingMatches = @($SettingDefinitions | Where-Object -FilterScript { $_.Name -eq $settingName })
    if ($settingMatches.Count -gt 1)
    {
        if ($settingDefinition.AdditionalProperties.dependentOn.parentSettingId.Count -gt 0)
        {
            $parentSetting = $SettingDefinitions | Where-Object -FilterScript { $_.Id -eq $($settingDefinition.AdditionalProperties.dependentOn.parentSettingId | Select-Object -Unique -First 1) }
        }
        elseif ($settingDefinition.AdditionalProperties.options.dependentOn.parentSettingId.Count -gt 0)
        {
            $parentSetting = $SettingDefinitions | Where-Object -FilterScript { $_.Id -eq $($settingDefinition.AdditionalProperties.dependentOn.parentSettingId | Select-Object -Unique -First 1) }
        }

        $combinationMatches = $SettingDefinitions | Where-Object -FilterScript {
            $_.Name -eq $settingName -and `
            (($_.AdditionalProperties.dependentOn.parentSettingId.Count -gt 0 -and $_.AdditionalProperties.dependentOn.parentSettingId.Contains($parentSetting.Id)) -or `
            ($_.AdditionalProperties.options.dependentOn.parentSettingId.Count -gt 0 -and $_.AdditionalProperties.options.dependentOn.parentSettingId.Contains($parentSetting.Id)))
        }

        # If the combination of parent setting and setting name is unique, add the parent setting name to the setting name
        if ($combinationMatches.Count -eq 1)
        {
            $settingName = $($parentSetting.Name) + "_" + $settingName
        }
        # If the combination of parent setting and setting name is still not unique, grab the last part of the setting id
        else
        {
            $parentSettingIdProperty = $parentSetting.Id.Split('_')[-1]
            $parentSettingIdWithoutProperty = $parentSetting.Id.Replace("_$parentSettingIdProperty", "")
            # We can't use the entire setting here, because the child setting id does not have to come after the parent setting id
            $settingName = $settingDefinition.Id.Replace($parentSettingIdWithoutProperty + "_", "").Replace($parentSettingIdProperty + "_", "")
        }
    }

    $odataType = if ($IsRoot) { $SettingInstance.AdditionalProperties.'@odata.type' } else { $SettingInstance.'@odata.type' }
    switch ($odataType)
    {
        '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
        {
            $settingValue = if ($IsRoot) { $SettingInstance.AdditionalProperties.simpleSettingValue.value } else { $SettingInstance.simpleSettingValue.value }
        }
        '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
        {
            $settingValue = if ($IsRoot) { $SettingInstance.AdditionalProperties.choiceSettingValue.value } else { $SettingInstance.choiceSettingValue.value }
            $settingValue = $settingValue.Split('_') | Select-Object -Last 1
            $childSettings = if ($IsRoot) { $SettingInstance.AdditionalProperties.choiceSettingValue.children } else { $SettingInstance.choiceSettingValue.children }
            foreach ($childSetting in $childSettings)
            {
                Export-IntuneSettingCatalogPolicySettings -SettingInstance $childSetting -SettingDefinitions $SettingDefinitions -ReturnHashtable $ReturnHashtable
            }
        }
        '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
        {
            $values = @()
            $childSettings = if ($IsRoot) { $SettingInstance.AdditionalProperties.groupSettingCollectionValue.children } else { $SettingInstance.groupSettingCollectionValue.children }
            foreach ($value in $childSettings)
            {
                Export-IntuneSettingCatalogPolicySettings -SettingInstance $value -SettingDefinitions $SettingDefinitions -ReturnHashtable $ReturnHashtable
                $addToParameters = $false
            }
        }
        '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
        {
            $values = @()
            $childValues = if ($IsRoot) { $SettingInstance.AdditionalProperties.simpleSettingCollectionValue.value } else { $SettingInstance.simpleSettingCollectionValue.value }
            foreach ($value in $childValues)
            {
                $values += $value
            }
            $settingValue = $values
        }
        Default
        {
            $settingValue = $SettingInstance.value
        }
    }

    if ($addToParameters)
    {
        $ReturnHashtable.Add($settingName, $settingValue)
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
        [Array]
        $Settings
    )

    try
    {
        $Uri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$DeviceConfigurationPolicyId"

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

function Get-ComplexFunctionsFromFilterQuery {
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

function Remove-ComplexFunctionsFromFilterQuery {
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [string]$FilterQuery
    )

    $complexFunctionsRegex = "startswith\((.*?),\s*'(.*?)'\)|endswith\((.*?),\s*'(.*?)'\)|contains\((.*?),\s*'(.*?)'\)"
    $basicFilterQuery = [regex]::Replace($FilterQuery, $complexFunctionsRegex, "").Trim()
    $basicFilterQuery = $basicFilterQuery -replace "^and\s","" -replace "\sand$","" -replace "\sand\s+", " and " -replace "\sor\s+", " or "

    return $basicFilterQuery
}

function Find-GraphDataUsingComplexFunctions {
    [CmdletBinding()]
    [OutputType([System.Array])]
    param (
        [array]$Policies,
        [array]$ComplexFunctions
    )

    foreach ($function in $ComplexFunctions) {
        if ($function -match "startswith\((.*?),\s*'(.*?)'") {
            $property = $matches[1]
            $value = $matches[2]
            $Policies = $Policies | Where-Object { $_.$property -like "$value*" }
        } elseif ($function -match "endswith\((.*?),\s*'(.*?)'") {
            $property = $matches[1]
            $value = $matches[2]
            $Policies = $Policies | Where-Object { $_.$property -like "*$value" }
        } elseif ($function -match "contains\((.*?),\s*'(.*?)'") {
            $property = $matches[1]
            $value = $matches[2]
            $Policies = $Policies | Where-Object { $_.$property -like "*$value*" }
        }
    }

    return $Policies
}
