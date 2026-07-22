<#
.SYNOPSIS
    Every parameter on every function in the target *.psm1 files
    must be documented via .PARAMETER in that function's comment-based help.

.DESCRIPTION
    Discovers all *.psm1 files, parses each with the PowerShell AST, and
    generates one Pester test per function that has parameters. The test
    fails if the function has no comment-based help, or if any parameter is not
    covered by a .PARAMETER entry. Files that fail to parse also produce a failing
    test rather than being silently skipped.

    Because each function gets its own test, CI output (console, NUnit XML, etc.)
    shows exactly which file/function/line is missing documentation.
#>

BeforeDiscovery {
    function Get-FunctionParameterName {
        # Parameters live either directly on the FunctionDefinitionAst (inline
        # syntax: function Foo($a)) or on Body.ParamBlock (param() block syntax) -
        # never both.
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $true)]
            [System.Management.Automation.Language.FunctionDefinitionAst]
            $FunctionAst
        )

        if ($FunctionAst.Parameters)
        {
            $paramAsts = $FunctionAst.Parameters
        }
        elseif ($FunctionAst.Body.ParamBlock)
        {
            $paramAsts = $FunctionAst.Body.ParamBlock.Parameters
        }
        else
        {
            $paramAsts = @()
        }

        $paramAsts | ForEach-Object { $_.Name.VariablePath.UserPath }
    }

    $resolvedPath = Join-Path -Path $PSScriptRoot -ChildPath '../../Modules/Microsoft365DSC/Modules' -Resolve

    $files = @(Get-ChildItem -Path $resolvedPath -Filter '*.psm1' -File -Recurse -Exclude 'M365DSCGraphShim.psm1')

    $AnalysisResults = foreach ($file in $files)
    {
        $relativeFile = $file.FullName.Substring($resolvedPath.Length).TrimStart('\', '/')

        Import-Module -Name $file.FullName
        $exportedFunctions = @(Get-Module -Name $file.BaseName).ExportedFunctions.Keys
        if ($exportedFunctions.Count -eq 0)
        {
            Write-Warning "No exported functions found in $relativeFile - skipping"
            continue
        }

        $tokens = $null
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile(
            $file.FullName, [ref]$tokens, [ref]$parseErrors
        )

        if ($parseErrors -and $parseErrors.Count -gt 0)
        {
            @{
                RelativeFile  = $relativeFile
                Function      = '<parse error>'
                Line          = 0
                ActualParams  = @()
                MissingParams = @()
                HasHelp       = $false
                ParseError    = ($parseErrors | ForEach-Object { $_.Message }) -join '; '
            }
            continue
        }

        $functionAsts = $ast.FindAll(
            { param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] },
            $true
        )

        foreach ($functionAst in $functionAsts)
        {
            if (-not ($exportedFunctions -contains $functionAst.Name))
            {
                Write-Verbose "Skipping non-exported function $($functionAst.Name) in $relativeFile"
                continue
            }
            $actualParams = @(Get-FunctionParameterName -FunctionAst $functionAst)

            # Nothing to document - don't generate a test for it.
            if ($actualParams.Count -eq 0)
            {
                continue
            }

            $help = $functionAst.GetHelpContent()
            if ($null -ne $help)
            {
                $documentedParams = @($help.Parameters.Keys)
            }
            else
            {
                $documentedParams = @()
            }

            $missing = @($actualParams | Where-Object {
                $name = $_
                -not ($documentedParams | Where-Object { $_ -eq $name })
            })

            @{
                RelativeFile  = $relativeFile
                Function      = $functionAst.Name
                Line          = $functionAst.Extent.StartLineNumber
                ActualParams  = $actualParams
                MissingParams = $missing
                HasHelp       = [bool]$help
                ParseError    = $null
            }
        }
    }
}

Describe 'PSM1 comment-based help coverage' {

    It "<RelativeFile> :: <Function>() [line <Line>] documents all parameters" -ForEach $AnalysisResults {

        if ($ParseError)
        {
            throw "File failed to parse: $ParseError"
        }

        $HasHelp | Should -BeTrue -Because "it has parameter(s) [$($ActualParams -join ', ')] but no comment-based help block"

        $MissingParams.Count | Should -Be 0 -Because "parameter(s) [$($MissingParams -join ', ')] have no .PARAMETER entry"
    }
}
