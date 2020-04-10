[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]
    $UnitTestFilePath,

    [Parameter(Mandatory = $true)]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Microsoft365.psm1" `
            -Resolve)
)

if ($UnitTestFilePath.EndsWith("Tests.ps1"))
{

    $pesterParameters = @{
        Path       = $unitTestFilePath
        Parameters = @{
            CmdletModule = $CmdletModule
        }
    }

    $unitTest = Get-Item -Path $UnitTestFilePath
    $unitTestName = "$($unitTest.Name.Split('.')[1])"

    $unitTestFilePath = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Modules\Microsoft365DSC\DSCResources\MSFT_$($unitTestName)\MSFT_$($unitTestName).psm1" `
            -Resolve)

    Invoke-Pester -Script $pesterParameters -CodeCoverage $UnitTestFilePath -Verbose
}
