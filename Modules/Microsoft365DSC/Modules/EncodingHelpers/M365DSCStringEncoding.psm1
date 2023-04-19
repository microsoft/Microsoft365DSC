<#
.Description
This function replaces all special characters by their correct counterparts

.Functionality
Internal
#>
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
            InvalidCharacter = [char]0x2019
            MainReplaceBy    = "``" + [char]0x2019
            CimReplaceBy     = "'" + [char]0x2019
        },
        @{
            # Tilted Left Quotes
            InvalidCharacter = [char]0x201C
            MainReplaceBy    = "``" + [char]0x201C
            CimReplaceBy     = [char]0x201C
        },
        @{
            # Tilted Right Quotes
            InvalidCharacter = [char]0x201D
            MainReplaceBy    = "``" + [char]0x201D
            CimReplaceBy     = [char]0x201D
        }
    )

    # Cache the DSC resource to a script-scope variable.
    # This avoids fetching the definition multiple times for the same resource, increasing overall speed.
    if (-not ($DSCResource.Name -eq $ResourceName)) {
        $Script:DSCResource = Get-DscResource -Module 'Microsoft365DSC' -Name $ResourceName
    }

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
            $foundProperty = $DSCResource.Properties | Where-Object -FilterScript { $_.Name -eq $key }
            foreach ($entry in $InvalidCharacters)
            {
                if ($foundProperty.PropertyType -eq '[string]')
                {
                    $newProperties.$key = $newProperties.$key.Replace($entry.InvalidCharacter.ToString(), $entry.MainReplaceBy.ToString())
                }
                elseif ($foundProperty.PropertyType -like '`[MSFT_*`]')
                {
                    # Case property is a CIMInstance
                    $newProperties.$key = $newProperties.$key.Replace($entry.InvalidCharacter.ToString(), $entry.CimReplaceBy.ToString())
                }
                else
                {
                    break
                }
            }
        }
    }

    return $newProperties
}

Export-ModuleMember -Function @(
    'Format-M365DSCString'
)
