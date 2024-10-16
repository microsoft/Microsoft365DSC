using namespace System.Management.Automation.Language

function New-M365DSCIntegrationTest
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $Workload,

        [Parameter(Mandatory = $true)]
        [ValidateSet('1-Create', '2-Update', '3-Remove')]
        [System.String]
        $Step
    )
    # Initialize Master Integration configuration
    $masterIntegrationConfig = @'
    param
    (
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Configuration Master
    {
        param
        (
            [Parameter()]
            [System.String]
            $ApplicationId,

            [Parameter()]
            [System.String]
            $TenantId,

            [Parameter()]
            [System.String]
            $CertificateThumbprint
        )

        Import-DscResource -ModuleName Microsoft365DSC
        $Domain = $TenantId
        Node Localhost
        {

'@

    # Fetching examples
    $exampleFiles = Get-ChildItem -Path ".\Modules\Microsoft365DSC\Examples\Resources\*$Step.ps1" -Recurse
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
        Master -ConfigurationData $ConfigurationData -ApplicationId $ApplicationId -TenantId $TenantId -CertificateThumbprint $CertificateThumbprint
        Start-DscConfiguration Master -Wait -Force -Verbose -ErrorAction Stop
    }
    catch
    {
        throw $_
    }
'@

    # Saving Master Integration configuration to file
    $StepValue = $Step.Split('-')[1]
    Set-Content -Value $masterIntegrationConfig -Path ".\Tests\Integration\Microsoft365DSC\M365DSCIntegration.$Workload.$StepValue.Tests.ps1"
}

Export-ModuleMember -Function @(
    'New-M365DSCIntegrationTest'
)
