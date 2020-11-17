function Format-M365DSCString
{
    [CmdletBinding()]
    [OutputType([System.Collections.HashTable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Properties,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName
    )

    $InvalidCharacters = @(
        @{
            # Tilted Apostrophe
            InvalidCharacter = "[\u2019]"
            MainReplaceBy    = "'"
            CimReplaceBy     = "''"
        },
        @{
            # Tilted Left Quotes
            InvalidCharacter = "[\u201C]"
            MainReplaceBy    = "`""
            CimReplaceBy     = '"'
        },
        @{
            # Tilted Right Quotes
            InvalidCharacter = "[\u201D]"
            MainReplaceBy    = "`""
            CimReplaceBy     = '"'
        }
    )

    $DSCResource = Get-DSCResource -Module 'Microsoft365DSC' `
        -Name $ResourceName

    # For each invalid character, look for an instance in the string,
    # if an instance is found, 
    $newProperties = @{}
    foreach ($key in $Properties.Keys)
    {
        $newProperties.Add($key, $Properties.$key)
        if (-not [System.String]::IsNullOrEmpty($newProperties.$key) -and `
            $newProperties.$key.GetType().ToString() -eq 'System.String')
        {
            # Obtain the type for this property from the module;
            $foundProperty = $DSCResource.Properties | Where-Object -FilterScript {$_.Name -eq $key}
            foreach ($entry in $InvalidCharacters)
            {
                $found = $newProperties.$key -match $entry.InvalidCharacter
                
                while ($found)
                {
                    if ($foundProperty.PropertyType -eq '[string]')
                    {
                        $newProperties.$key = $newProperties.$key -replace $entry.InvalidCharacter, $entry.MainReplaceBy
                    }
                    elseif ($foundProperty.PropertyType -like '`[MSFT_*`]')
                    {
                        # Case property is a CIMInstance
                        $newProperties.$key = $newProperties.$key -replace $entry.InvalidCharacter, $entry.CimReplaceBy
                    }
                    else
                    {
                        break
                    }
                    $found = $newProperties.$key -match $entry.InvalidCharacter
                }
            }
        }
    }

    return $newProperties
}
