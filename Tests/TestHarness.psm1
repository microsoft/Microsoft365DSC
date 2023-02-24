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
    Write-Host -Object 'Running all Microsoft365DSC Unit Tests'

    $repoDir = Join-Path -Path $PSScriptRoot -ChildPath '..\' -Resolve

    $oldModPath = $env:PSModulePath
    $env:PSModulePath = $env:PSModulePath + [System.IO.Path]::PathSeparator + (Join-Path -Path $repoDir -ChildPath 'modules\Microsoft365DSC')

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

    Import-Module -Name "$repoDir\modules\Microsoft365DSC\Microsoft365DSC.psd1"
    $testsToRun = @()

    # Run Unit Tests
    $versionsPath = Join-Path -Path $repoDir -ChildPath '\Tests\Unit\Stubs\'
    # Import the first stub found so that there is a base module loaded before the tests start
    $firstStub = Join-Path -Path $repoDir `
        -ChildPath '\Tests\Unit\Stubs\Microsoft365.psm1'
    Import-Module $firstStub -WarningAction SilentlyContinue

    $stubPath = Join-Path -Path $repoDir `
        -ChildPath '\Tests\Unit\Stubs\Microsoft365.psm1'

    # DSC Common Tests
    $getChildItemParameters = @{
        Path    = (Join-Path -Path $repoDir -ChildPath '\Tests\Unit')
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

    $Params = [ordered]@{
        Path = $filesToExecute
    }

    $Container = New-PesterContainer @Params

    $Configuration = [PesterConfiguration]@{
        Run    = @{
            Container = $Container
        }
        Output = @{
            Verbosity = 'Detailed'
        }
    }

    if ($IgnoreCodeCoverage.IsPresent -eq $false)
    {
        $Configuration.CodeCoverage.Enabled = $true
        $Configuration.CodeCoverage.Path = $testCoverageFiles
        $Configuration.CodeCoverage.Path = 'CodeCov.xml'
        $Configuration.CodeCoverage.OutputFormat = 'NUnitXml'
    }

    $results = Invoke-Pester -Configuration $Configuration

    $env:PSModulePath = $oldModPath
    Write-Host -Object 'Completed running all Microsoft365DSC Unit Tests'

    return $results
}

function Invoke-QualityChecksHarness
{
    [CmdletBinding()]
    param ()

    Write-Host -Object 'Running all Quality Check Tests'

    $repoDir = Join-Path -Path $PSScriptRoot -ChildPath '..\' -Resolve

    $oldModPath = $env:PSModulePath
    $env:PSModulePath = $env:PSModulePath + [System.IO.Path]::PathSeparator + (Join-Path -Path $repoDir -ChildPath 'modules\Microsoft365DSC')

    # DSC Common Tests
    $getChildItemParameters = @{
        Path   = (Join-Path -Path $repoDir -ChildPath '\Tests\QA')
        Filter = '*.Tests.ps1'
    }

    # Get all tests '*.Tests.ps1'.
    $commonTestFiles = Get-ChildItem @getChildItemParameters

    $testsToRun = @()
    $testsToRun += @( $commonTestFiles.FullName )

    $filesToExecute = @()
    foreach ($testToRun in $testsToRun)
    {
        $filesToExecute += $testToRun
    }

    $Params = [ordered]@{
        Path = $filesToExecute
    }

    $Container = New-PesterContainer @Params

    $Configuration = [PesterConfiguration]@{
        Run    = @{
            Container = $Container
            PassThru  = $true
        }
        Output = @{
            Verbosity = 'Detailed'
        }
    }

    $results = Invoke-Pester -Configuration $Configuration

    $env:PSModulePath = $oldModPath
    Write-Host -Object 'Completed running all Quality Check Tests'

    return $results
}
