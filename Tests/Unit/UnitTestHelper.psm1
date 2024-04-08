function New-CimInstance
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $ClassName,

        [Parameter(Mandatory = $true)]
        [Hashtable]
        $Property,

        [Parameter()]
        [Switch]
        $ClientOnly
    )
    $cimInstance = [Microsoft.Management.Infrastructure.CimInstance]::new($ClassName)
    foreach ($key in $Property.Keys) {
        $cimInstance.CimInstanceProperties.Add(
            [Microsoft.Management.Infrastructure.CimProperty]::Create(
                $key,
                $Property[$key],
                'Property'
            )
        )
    }
    return $cimInstance
}

function New-M365DscUnitTestHelper
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
        [System.String]
        $GenericStubModule
    )

    $repoRoot = Join-Path -Path $PSScriptRoot -ChildPath "..\..\" -Resolve
    $moduleRoot = Join-Path -Path $repoRoot -ChildPath "Modules\Microsoft365DSC"

    $mainModule = Join-Path -Path $moduleRoot -ChildPath "Microsoft365DSC.psd1"
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
            Import-Module -Name "$GenericStubModule" -WarningAction SilentlyContinue
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
