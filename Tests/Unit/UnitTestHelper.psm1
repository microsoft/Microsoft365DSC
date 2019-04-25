function New-O365DscUnitTestHelper
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $StubModule,

        [Parameter(Mandatory = $true, ParameterSetName = 'DscResource')]
        [String]
        $DscResource,

        [Parameter(Mandatory = $true, ParameterSetName = 'SubModule')]
        [String]
        $SubModulePath,

        [Parameter()]
        [Switch]
        $ExcludeInvokeHelper,

        [Parameter()]
        [Switch]
        $IncludeDistributedCacheStubs
    )

    $repoRoot = Join-Path -Path $PSScriptRoot -ChildPath "..\..\" -Resolve
    $moduleRoot = Join-Path -Path $repoRoot -ChildPath "Modules\Office365Dsc"

    $mainModule = Join-Path -Path $moduleRoot -ChildPath "Office365DSC.psd1"
    Import-Module -Name "MSOnline" -Force -ErrorAction SilentlyContinue
    Remove-Module -Name "AzureAD" -Force -ErrorAction SilentlyContinue
    Import-Module -Name $mainModule -Global

    if ($PSBoundParameters.ContainsKey("SubModulePath") -eq $true)
    {
        $describeHeader = "Sub-module '$SubModulePath'"
        $moduleToLoad = Join-Path -Path $moduleRoot -ChildPath $SubModulePath
        $moduleName = (Get-Item -Path $moduleToLoad).BaseName
    }

    if ($PSBoundParameters.ContainsKey("DscResource") -eq $true)
    {
        $describeHeader = "DSC Resource '$DscResource'"
        $moduleName = "MSFT_$DscResource"
        $modulePath = "DSCResources\MSFT_$DscResource\MSFT_$DscResource.psm1"
        $moduleToLoad = Join-Path -Path $moduleRoot -ChildPath $modulePath
    }

    Import-Module -Name $moduleToLoad -Global

    $initScript = @"
            Remove-Module -Name "AzureAD" -Force -ErrorAction SilentlyContinue
            Import-Module -Name "$StubModule" -WarningAction SilentlyContinue
            Import-Module -Name "$moduleToLoad"

"@

    return @{
        DescribeHeader = $describeHeader
        ModuleName = $moduleName
        CurrentStubModulePath = $StubModule
        InitializeScript = [ScriptBlock]::Create($initScript)
        RepoRoot = $repoRoot
        CleanupScript = [ScriptBlock]::Create(@"

            `$global:DSCMachineStatus = 0

"@)
    }
}
