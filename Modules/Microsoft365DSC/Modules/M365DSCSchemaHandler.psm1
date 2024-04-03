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
                $propertyMatches = [regex]::Matches($classBody, '\[(Key|Write|Required),\s*Description\("((?:[^"]|\\")*)"\)(?:\s*,\s*(?:ValueMap\{[^}]*\}\s*,\s*Values\{[^}]*\}|Values\{[^}]*\}\s*,\s*ValueMap\{[^}]*\}))?(?:,\s*EmbeddedInstance\("(\w+)"\))?\]?\s*(\w+)\s+(\w+)(\[\])?\s*;', @('Singleline', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase))

                $propertyInfoList = @()

                foreach ($propertyMatch in $propertyMatches)
                {
                    $propertyKeyOrWrite = $propertyMatch.Groups[1].Value
                    $propertyDescription = $propertyMatch.Groups[2].Value
                    $embeddedInstanceType = $propertyMatch.Groups[3].Value
                    $propertyType = $propertyMatch.Groups[4].Value
                    $propertyName = $propertyMatch.Groups[5].Value
                    $isArray = $propertyMatch.Groups[6].Success

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
                        #IsArray    = $isArray
                        Option  = $propertyKeyOrWrite
                    }

                }

                $classInfoList += [ordered] @{
                    ClassName  = $className
                    Parameters = $propertyInfoList
                }
            }
        }

    }

    $jsonContent = ConvertTo-Json $classInfoList -Depth 99
    Set-Content -Value $jsonContent -Path '.\Modules\Microsoft365DSC\SchemaDefinition.json'

}
