function New-M365DSCSchemaDefinition
{
    [CmdletBinding()]
    Param()

    $schemaFiles = Get-ChildItem -Path ".\Modules\Microsoft365DSC\DSCResources\*.schema.mof" -Recurse

    $classDefinitions = @()
    $classesList = @()
    foreach ($file in $schemaFiles)
    {
        Write-Verbose -Message $file.Name
        $content = Get-Content $file.FullName -Raw
        $start = 0
        $start = $content.IndexOf("`r`nclass ", $start) + 8
        # For each classes in the current file.
        $classesInFile = @()
        while ($start -gt 8)
        {
            $end = $content.IndexOf("`r", $start)

            $className = $content.Substring($start, $end-$start).Replace(' : OMI_BaseResource', '')
            if (-not $classesList.Contains($className))
            {
                $classesList += $className
                $currentClassItem = @{
                    ClassName = $className
                    Parameters = @()
                }
                $classStart = $content.IndexOf('{', $end) + 1
                $classEnd = $content.IndexOf('};', $start)
                $classContent = $content.Substring($classStart, $classEnd-$classStart)
                $lines = $classContent.Split("`r`n")

                foreach ($line in $lines)
                {
                    if (-not [System.String]::IsNullOrEmpty($line))
                    {
                        $itemStart = $line.IndexOf('[') + 1
                        $itemEnd = $line.IndexOf(',', $itemStart)
                        $parameterOption = $line.Substring($itemStart, $itemEnd-$itemStart)

                        if ($line.Contains('EmbeddedInstance("'))
                        {
                            $itemStart = $line.IndexOf('EmbeddedInstance("') + 18
                            $itemEnd = $line.IndexOf('")]', $itemStart)
                            $parameterType = $line.Substring($itemStart, $itemEnd-$itemStart)

                            $itemStart = $line.IndexOf(']') + 2
                            $itemEnd = $line.IndexOf(' ', $itemStart)
                            $parentType = $line.Substring($itemStart, $itemEnd-$itemStart)
                        }
                        else
                        {
                            $itemStart = $line.IndexOf(']') + 2
                            $itemEnd = $line.IndexOf(' ', $itemStart)
                            $parameterType = $line.Substring($itemStart, $itemEnd-$itemStart)
                        }

                        $itemStart = $line.IndexOf(' ', $itemEnd) + 1
                        $itemEnd = $line.IndexOf(';', $itemStart)
                        $parameterName = $line.Substring($itemStart, $itemEnd-$itemStart)

                        if ($parameterName.Contains('[]'))
                        {
                            $parameterType += '[]'
                            $parameterName = $parameterName.Replace('[]', '')
                        }

                        $currentProperty = @{
                            Option  = $parameterOption
                            CIMType = $parameterType
                            Name    = $parameterName
                        }
                        $currentClassItem.Parameters += $currentProperty
                    }
                }
                if ($null -ne $currentClassItem)
                {
                    $classesInFile += $currentClassItem
                }
            }
            $start = $content.IndexOf("`r`nclass ", $start) + 8
        }
        $classDefinitions += $classesInFile
    }

    $jsonContent = ConvertTo-Json $classDefinitions -Depth 99
    Set-Content -Value $jsonContent -Path ".\Modules\Microsoft365DSC\SchemaDefinition.json"
}
