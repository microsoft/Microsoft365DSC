function New-M365DSCSchemaDefinition
{
    [CmdletBinding()]
    param (
    )

    $schemaFiles = Get-ChildItem -Path '.\Modules\Microsoft365DSC\DSCResources\*.schema.mof' -Recurse

    $classInfoList = @()

    $classesList = @()

    foreach ($file in $schemaFiles)
    {
        $readMePath = "$($file.DirectoryName)\ReadMe.md"
        $readMeContent = Get-Content $readMePath -Raw
        $resourceDescription = $readMeContent.Split('## Description')[1].Trim()

        Write-Verbose -Message $file.Name
        $mofContent = Get-Content $file.FullName -Raw

        # Match class definitions
        $classMatches = [regex]::Matches($mofContent, 'class\s+(\w+)(?:\s*:\s*\w+)?\s*(\{.*?\});', 'Singleline')

        foreach ($classMatch in $classMatches)
        {
            $className = $classMatch.Groups[1].Value
            $classBody = $classMatch.Groups[2].Value

            if (-not $classesList.Contains($className))
            {
                $classesList += $className

                # Match property definitions
                $propertyMatches = [regex]::Matches($classBody, '\[(?<propertykeyorwrite>Key|Write|Required),\s*Description\("(?<description>(?:[^"]|\\")*)"\)(?:\s*,\s*(?:(?:ValueMap\{(?<valuemap>[^}]*)\}\s*,\s*Values\{(?<values>[^}]*)\})|(?:Values\{(?<values>[^}]*)\}\s*,\s*ValueMap\{(?<valuemap>[^}]*)\})))?(?:,\s*EmbeddedInstance\("(?<embeddedinstancetype>\w+)"\))?\]?\s*(?<propertytype>\w+)\s+(?<propertyname>\w+)(?<isarray>\[\])?\s*;', @('Singleline', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase))

                $propertyInfoList = @()

                foreach ($propertyMatch in $propertyMatches)
                {
                    $propertyKeyOrWrite = $propertyMatch.Groups["propertykeyorwrite"].Value
                    $propertyDescription = $propertyMatch.Groups["description"].Value
                    $embeddedInstanceType = $propertyMatch.Groups["embeddedinstancetype"].Value
                    $propertyType = $propertyMatch.Groups["propertytype"].Value
                    $propertyName = $propertyMatch.Groups["propertyname"].Value
                    $isArray = $propertyMatch.Groups["isarray"].Success
                    $valueMap = $propertyMatch.Groups["valuemap"].Value
                    $values = $propertyMatch.Groups["values"].Value

                    if ($embeddedInstanceType)
                    {
                        $propertyType = $embeddedInstanceType
                    }

                    if ($isArray)
                    {
                        $propertyType = $propertyType + '[]'
                    }

                    $propertyInfoList += @{
                        CIMType = $propertyType
                        Name    = $propertyName
                        Option  = $propertyKeyOrWrite
                        Description = $propertyDescription
                    }

                    if($ValueMap.Length -gt 0)
                    {
                        $ValueMap = $ValueMap.Split(',')
                        $Values = $Values.Split(',')

                        # Remove \" from the values
                        $ValueMap = $ValueMap | ForEach-Object { $_.Trim().Replace('"', '') }
                        $Values = $Values | ForEach-Object { $_.Trim().Replace('"', '') }

                        if ($propertyType.ToLower().Contains('string')) 
                        {
                            $propertyInfoList[-1].ValueMap = [String[]]$valueMap
                            $propertyInfoList[-1].Values = [String[]]$values
                        }
                        elseif ($propertyType.ToLower().Contains('int')) 
                        {
                            $propertyInfoList[-1].ValueMap = [int[]]$valueMap
                            $propertyInfoList[-1].Values = [int[]]$values
                        }
                    }

                }

                $classInfoList += [ordered] @{
                    ClassName  = $className
                    Parameters = $propertyInfoList
                    Description = $resourceDescription
                }
            }
        }

    }

    $jsonContent = ConvertTo-Json $classInfoList -Depth 99
    Set-Content -Value $jsonContent -Path '.\Modules\Microsoft365DSC\SchemaDefinition.json'

}
