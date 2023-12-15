using namespace System.Management.Automation.Language

function New-M365DSCIntegrationTest
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Workload
    )
    # Initialize Master Integration configuration
    $masterIntegrationConfig = @'
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Configuration Master
    {
        param
        (
            [Parameter(Mandatory = $true)]
            [System.Management.Automation.PSCredential]
            $Credscredential
        )

        Import-DscResource -ModuleName Microsoft365DSC
        $Domain = $Credscredential.Username.Split('@')[1]
        Node Localhost
        {

'@

    # Fetching examples
    $exampleFiles = Get-ChildItem -Path ".\Modules\Microsoft365DSC\Examples\Resources\*.ps1" -Recurse
    foreach ($file in $exampleFiles)
    {
        if ($file.FullName -like "*Modules\Microsoft365DSC\Examples\Resources\$Workload*")
        {
            # Fetching DSC resources from example file
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($file, [ref]$null, [ref]$null)
            $predicate = {
                param( [Ast] $AstObject )

                if ($AstObject -is [DynamicKeywordStatementAst] -and `
                        $AstObject.CommandElements[0].Value -notin ('configuration', 'node', 'Import-DscResource') -and `
                        $AstObject.CommandElements[0].Value -notlike "MSFT_*")
                {
                    return $true
                }
                else
                {
                    return $false
                }
            }

            $resources = $ast.FindAll($predicate, $true)

            $allDscExamples = ""
            foreach ($resource in $resources)
            {
                $dscResourceString = @"
                {0} '{1}'
                {2}

"@
                $allDscExamples += $dscResourceString -f $resource.CommandElements[0].Value, $resource.CommandElements[1].Value, $resource.CommandElements[2].Extent.Text.Trim().Replace("`r`n", "`r`n        ")
            }

            $masterIntegrationConfig += $allDscExamples
        }
    }

    # Initialize Master Integration configuration
    $masterIntegrationConfig += @'
        }
    }

    $ConfigurationData = @{
        AllNodes = @(
            @{
                NodeName                    = "Localhost"
                PSDSCAllowPlaintextPassword = $true
            }
        )
    }

    # Compile and deploy configuration
    try
    {
        Master -ConfigurationData $ConfigurationData -Credscredential $Credential
        Start-DscConfiguration Master -Wait -Force -Verbose
    }
    catch
    {
        throw $_
    }
'@

    # Saving Master Integration configuration to file
    Set-Content -Value $masterIntegrationConfig -Path ".\Tests\Integration\Microsoft365DSC\M365DSCIntegration.$Workload.Tests.ps1"
}

Export-ModuleMember -Function @(
    'New-M365DSCIntegrationTest'
)
