Initialize-M365DSCDllLoader -ErrorAction SilentlyContinue

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

    return [Microsoft365DSC.Intune.SettingsCatalogHelper]::GetSettingName($SettingDefinition, $AllSettingDefinitions)
}

Export-ModuleMember -Function Get-SettingsCatalogSettingName
