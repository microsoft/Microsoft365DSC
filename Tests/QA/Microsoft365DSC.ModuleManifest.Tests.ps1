Describe -Name 'Checking Module Manifest' {
    BeforeAll {
        $manifestPath = Join-Path -Path $PSScriptRoot -ChildPath '..\..\Modules\Microsoft365DSC\Microsoft365DSC.psd1'
        $manifest = Import-PowerShellDataFile -Path $manifestPath
    }

    It 'Release Notes property is less than 10.000 characters' {
        $manifest.PrivateData.PSData.ReleaseNotes.Length | Should -BeLessThan 10000
    }
}
