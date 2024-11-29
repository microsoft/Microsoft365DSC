<#
.SYNOPSIS
    Use correct method casing in the method name.
.DESCRIPTION
    Methods called on an object should use the correct casing (PascalCase) for the method name.
.EXAMPLE
    $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $MyInvocation.MyCommand.ModuleName.replace('MSFT_', '')
    The first example is correct, the second example is incorrect.
#>

function Use-CorrectMethodCasing {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst]
        $ScriptBlockAst
    )

    Process
    {
        $results = @()
        try
        {
            [System.Management.Automation.Language.InvokeMemberExpressionAst[]]$memberAst = $ScriptBlockAst.FindAll({$Args[0].GetType().Name -eq 'InvokeMemberExpressionAst'}, $true)
            
            foreach ($member in $memberAst)
            {
                if ($member.Member.Value -cmatch '^[a-z]') {
                    [int]$startLineNumber =  $member.Extent.StartLineNumber
                    [int]$endLineNumber = $member.Extent.EndLineNumber
                    [int]$startColumnNumber = $member.Extent.StartColumnNumber
                    [int]$endColumnNumber = $member.Extent.EndColumnNumber
                    [string]$file = $MyInvocation.MyCommand.Definition

                    $correctedString = $member.Member.Value.Substring(0, 1).ToUpper() + $member.Member.Value.Substring(1)
                    [string]$correction = $member.Extent.Text.Replace($member.Member.Value, $correctedString)
                    [string]$optionalDescription = "Replace '$($member.Member.Value)' with '$($member.Member.Value.Substring(0, 1).ToUpper() + $member.Member.Value.Substring(1))'."
                    $objParams = @{
                        TypeName = 'Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.CorrectionExtent'
                        ArgumentList = $startLineNumber, $endLineNumber, $startColumnNumber,
                                       $endColumnNumber, $correction, $file, $optionalDescription
                    }
                    $correctionExtent = New-Object @objParams
                    $suggestedCorrections = New-Object System.Collections.ObjectModel.Collection[$($objParams.TypeName)]
                    $suggestedCorrections.Add($correctionExtent) | Out-Null
                    
                    $results += [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]@{
                        Message = 'Use correct method casing in the method name.'
                        Extent = $member.Extent
                        RuleName = $PSCmdlet.MyInvocation.InvocationName
                        Severity = 'Warning'
                        SuggestedCorrections = $suggestedCorrections
                    }
                }
            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $_ )
        }

        return $results
    }
}