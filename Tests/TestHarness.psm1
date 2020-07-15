function Invoke-TestHarness
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]
        $TestResultsFile,

        [Parameter()]
        [System.String]
        $DscTestsPath,

        [Parameter()]
        [Switch]
        $IgnoreCodeCoverage
    )


    Write-Verbose -Message 'Starting all Microsoft365DSC tests'

    $repoDir = Join-Path -Path $PSScriptRoot -ChildPath '..\' -Resolve

    $testCoverageFiles = @()
    if ($IgnoreCodeCoverage.IsPresent -eq $false)
    {
        Get-ChildItem -Path "$repoDir\modules\Microsoft365DSC\DSCResources\**\*.psm1" -Recurse | ForEach-Object {
            if ($_.FullName -notlike '*\DSCResource.Tests\*')
            {
                $testCoverageFiles += $_.FullName
            }
        }
    }

    $testResultSettings = @{ }
    if ([String]::IsNullOrEmpty($TestResultsFile) -eq $false)
    {
        $testResultSettings.Add('OutputFormat', 'NUnitXml' )
        $testResultSettings.Add('OutputFile', $TestResultsFile)
    }
    Import-Module -Name "$repoDir\modules\Microsoft365DSC\Microsoft365DSC.psd1"

    # Run Unit Tests
    $versionsPath = Join-Path -Path $repoDir -ChildPath "\Tests\Unit\Stubs\"
    # Import the first stub found so that there is a base module loaded before the tests start
    $firstStub = Join-Path -Path $repoDir `
        -ChildPath "\Tests\Unit\Stubs\Microsoft365.psm1"
    Import-Module $firstStub -WarningAction SilentlyContinue

    # DSC Common Tests
    $TestFolderPath = (Join-Path -Path $repoDir -ChildPath "\Tests\Unit\Microsoft365DSC\")
    if ($IgnoreCodeCoverage.IsPresent -eq $false)
    {
        $results = Invoke-Pester -Script $TestFolderPath -PassThru -CodeCoverage $testCoverageFiles -CodeCoverageOutputFile '.\TestOutput.xml' @$testResultSettings
    }
    else
    {
        $results = Invoke-Pester -Script $TestFolderPath -PassThru @$testResultSettings
    }
    return $results
}
