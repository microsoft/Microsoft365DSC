using namespace System.Management.Automation.Language

# Initialize Master Integration configuration
$masterIntegrationConfig = @'
param
(
    [Parameter()]
    [System.String]
    $GlobalAdminUser,

    [Parameter()]
    [System.String]
    $GlobalAdminPassword,

    [Parameter()]
    [System.String]
    [ValidateSet('Public', 'GCC', 'GCCH', 'Germany', 'China')]
    $Environment = 'Public'
)

Configuration Master
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $credsGlobalAdmin,

        [Parameter()]
        [System.String]
        [ValidateSet('Public', 'GCC', 'GCCH', 'Germany', 'China')]
        $Environment = 'Public'
    )

    Import-DscResource -ModuleName Microsoft365DSC
    $Domain = $credsGlobalAdmin.Username.Split('@')[1]
    Node Localhost
    {

'@

# Fetching examples
$exampleFiles = Get-ChildItem -Path ..\..\Modules\Microsoft365DSC\Examples\Resources\*.ps1 -Recurse
foreach ($file in $exampleFiles)
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
        $allDscExamples += $dscResourceString -f $resource.CommandElements[0].Value, $resource.CommandElements[1].Value, $resource.CommandElements[2].Extent.Text
    }

    $masterIntegrationConfig += $allDscExamples
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
$password = ConvertTo-SecureString $GlobalAdminPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($GlobalAdminUser, $password)
Master -ConfigurationData $ConfigurationData -credsGlobalAdmin $credential -Environment $Environment
Start-DscConfiguration Master -Wait -Force -Verbose

'@

# Saving Master Integration configuration to file
Set-Content -Value $masterIntegrationConfig -Path ".\M365DSCIntegrationTEMP.Master.Tests.ps1"
