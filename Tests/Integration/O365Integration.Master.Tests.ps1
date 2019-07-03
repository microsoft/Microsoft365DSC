param
(
    [Parameter()]
    [System.String]
    $GlobalAdminUser,

    [Parameter()]
    [System.String]
    $GlobalAdminPassword
)

Configuration Master
{
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdmin
    )

    Import-DscResource -ModuleName Office365DSC

    Node Localhost
    {
        TeamsTeam TeamAlpha
        {
            DisplayName = "AlphaTeam"
            GlobalAdminAccount = $GlobalAdmin
            Ensure = "Present"
        }
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

$password = ConvertTo-SecureString $GlobalAdminPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($GlobalAdminUser, $password)
Master -ConfigurationData $ConfigurationData -GlobalAdmin $credential
Start-DscConfiguration Master -Wait -Force -Verbose
