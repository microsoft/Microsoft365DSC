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

    $MaximumFunctionCount = 9999
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
    $testsToRun = @()

    # Run Unit Tests
    $versionsPath = Join-Path -Path $repoDir -ChildPath "\Tests\Unit\Stubs\"
    # Import the first stub found so that there is a base module loaded before the tests start
    $firstStub = Join-Path -Path $repoDir `
        -ChildPath "\Tests\Unit\Stubs\Microsoft365.psm1"
    Import-Module $firstStub -WarningAction SilentlyContinue

    $stubPath = Join-Path -Path $repoDir `
            -ChildPath "\Tests\Unit\Stubs\Microsoft365.psm1"
    <#$testsToRun += @(@{
            'Path'       = (Join-Path -Path $repoDir -ChildPath "\Tests\Unit")
            'Parameters' = @{
                'CmdletModule' = $stubPath
            }
        })#>

    # DSC Common Tests
    $getChildItemParameters = @{
        Path    = (Join-Path -Path $repoDir -ChildPath "\Tests\Unit")
        Recurse = $true
        Filter  = '*.Tests.ps1'
    }

    # Get all tests '*.Tests.ps1'.
    $commonTestFiles = Get-ChildItem @getChildItemParameters

    # Remove DscResource.Tests unit tests.
    $commonTestFiles = $commonTestFiles | Where-Object -FilterScript {
        $_.FullName -notmatch 'DSCResource.Tests\\Tests'
    }

    $testsToRun += @( $commonTestFiles.FullName )

    $filesToExecute = @()
    foreach ($testToRun in $testsToRun)
    {
        $filesToExecute += $testToRun
    }
    if ($IgnoreCodeCoverage.IsPresent -eq $false)
    {
        $results = Invoke-Pester -Path $filesToExecute -CodeCoverage $testCoverageFiles -CodeCoverageOutputFile  "CodeCov.xml" -PassThru @testResultSettings
    }
    else
    {
        $results = Invoke-Pester -Path $filesToExecute -PassThru @testResultSettings
    }
    return $results
}
