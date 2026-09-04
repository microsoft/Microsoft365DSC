<#
.SYNOPSIS
    Resolves an Intune settings catalog setting name from its definition.

.DESCRIPTION
    Calls the Microsoft365DSC Intune helper to translate a setting definition object into its display name.
    This helper is used during export and formatting of settings catalog policy data.

.PARAMETER SettingDefinition
    Specifies the setting definition object to resolve.

.PARAMETER AllSettingDefinitions
    Specifies the full set of setting definitions used as lookup context.

.OUTPUTS
    System.String
#>
function Get-SettingsCatalogSettingName
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory = $true)]
        $SettingDefinition,

        [Parameter(Mandatory = $true)]
        [System.Array]
        $AllSettingDefinitions
    )

    Initialize-M365DSCDllLoader -ErrorAction Stop
    return [Microsoft365DSC.Intune.SettingsCatalogHelper]::GetSettingName($SettingDefinition, $AllSettingDefinitions)
}

Export-ModuleMember -Function Get-SettingsCatalogSettingName
