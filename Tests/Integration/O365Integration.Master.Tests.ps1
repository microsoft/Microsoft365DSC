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
        EXOAcceptedDomain EXOAcceptedDomain1
        {
            Identity           = "contoso.com"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
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

Master -ConfigurationData $ConfigurationData
Start-DscConfiguration Master -Wait -Force -Verbose
