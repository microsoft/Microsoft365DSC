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

    $sw = [System.Diagnostics.StopWatch]::startnew()

    $MaximumFunctionCount = 32767
    Write-Host -Object 'Running all Microsoft365DSC Unit Tests'

    $repoDir = Join-Path -Path $PSScriptRoot -ChildPath '..\' -Resolve

    $oldModPath = $env:PSModulePath
    $env:PSModulePath = $env:PSModulePath + [System.IO.Path]::PathSeparator + (Join-Path -Path $repoDir -ChildPath 'Modules\Microsoft365DSC')

    $testCoverageFiles = @()
    if ($IgnoreCodeCoverage.IsPresent -eq $false)
    {
        Get-ChildItem -Path "$repoDir\Modules\Microsoft365DSC\DSCResources\**\*.psm1" -Recurse | ForEach-Object {
            if ($_.FullName -notlike '*\DSCResource.Tests\*')
            {
                $testCoverageFiles += $_.FullName
            }
        }
    }

    Import-Module -Name "$repoDir/Modules/Microsoft365DSC/Microsoft365DSC.psd1"
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
    if ($DscTestsPath -ne '')
    {
        $filesToExecute += $DscTestsPath
    }
    else
    {
        foreach ($testToRun in $testsToRun)
        {
            $filesToExecute += $testToRun
        }
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
            Verbosity = 'Normal'
        }
        Should = @{
            ErrorAction = 'Continue'
        }
    }

    if ([String]::IsNullOrEmpty($TestResultsFile) -eq $false)
    {
        $Configuration.Output.Enabled = $true
        $Configuration.Output.OutputFormat = 'NUnitXml'
        $Configuration.Output.OutputFile = $TestResultsFile
    }

    if ($IgnoreCodeCoverage.IsPresent -eq $false)
    {
        $Configuration.CodeCoverage.Enabled = $true
        $Configuration.CodeCoverage.Path = $testCoverageFiles
        $Configuration.CodeCoverage.OutputPath = 'CodeCov.xml'
        $Configuration.CodeCoverage.OutputFormat = 'JaCoCo'
        $Configuration.CodeCoverage.UseBreakpoints = $false
    }

    $results = Invoke-Pester -Configuration $Configuration

    $message = 'Running the tests took {0} hours, {1} minutes, {2} seconds' -f $sw.Elapsed.Hours, $sw.Elapsed.Minutes, $sw.Elapsed.Seconds
    Write-Host -Object $message

    $env:PSModulePath = $oldModPath
    Write-Host -Object 'Completed running all Microsoft365DSC Unit Tests'

    return $results
}

function Get-M365DSCAllGraphPermissionsList
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    param()

    $allModules = Get-module Microsoft.graph.* -ListAvailable
    $allPermissions = @()
    foreach ($module in $allModules)
    {
        $cmds = Get-Command -Module $module.Name
        foreach ($cmd in $cmds)
        {
            $graphInfo = Find-MgGraphCommand -Command $cmd.Name -ErrorAction SilentlyContinue
            if ($null -ne $graphInfo)
            {
                $permissions = $graphInfo.Permissions | Where-Object -FilterScript {$_.PermissionType -eq 'Application'}
                $allPermissions += $permissions.Name
            }
        }
    }

    $allPermissions+= @('OrgSettings-Microsoft365Install.Read.All', `
                        'OrgSettings-Forms.Read.All', `
                        'OrgSettings-Todo.Read.All', `
                        'OrgSettings-AppsAndServices.Read.All', `
                        'OrgSettings-DynamicsVoice.Read.All', `
                        'ReportSettings.Read.All', `
                        'RoleManagementPolicy.Read.Directory', `
                        'RoleEligibilitySchedule.Read.Directory', `
                        'Agreement.Read.All')
    $roles = $allPermissions | Select-Object -Unique | Sort-Object -Descending:$false
    return $roles
}

function Invoke-QualityChecksHarness
{
    [CmdletBinding()]
    param ()

    $sw = [System.Diagnostics.StopWatch]::startnew()

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
        Should = @{
            ErrorAction = 'Continue'
        }
    }

    $results = Invoke-Pester -Configuration $Configuration

    $message = 'Running the tests took {0} hours, {1} minutes, {2} seconds' -f $sw.Hours, $sw.Minutes, $sw.Seconds
    Write-Host -Object $message

    $env:PSModulePath = $oldModPath
    Write-Host -Object 'Completed running all Quality Check Tests'

    return $results
}
