param
(
    [Parameter()]
    [System.String]
    $GlobalAdminUser,

    [Parameter()]
    [System.String]
    $GlobalAdminPassword,

    [Parameter(Mandatory=$true)]
    [System.String]
    $Domain
)

Configuration Master
{
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdmin,

        [Parameter(Mandatory=$true)]
        [System.String]
        $Domain
    )

    Import-DscResource -ModuleName Office365DSC

    Node Localhost
    {
        EXOAcceptedDomain O365DSCDomain
        {
            Identity           = $Domain
            DomainType         = "Authoritative"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }

        EXOAntiPhishPolicy AntiPhishPolicy
        {
            Identity                 = "Test AntiPhish Policy"
            AdminDisplayName         = "Default Monitoring Policy"
            AuthenticationFailAction = "Quarantine"
            GlobalAdminAccount       = $GlobalAdmin
            Ensure                   = "Present"
        }

        EXOAntiPhishRule AntiPhishRule
        {
            Identity           = "Test AntiPhish Rule"
            AntiPhishPolicy    = "Test AntiPhish Policy"
            Comments           = "This is a test Rule"
            SentToMemberOf     = @("O365DSCCore@o365dsc.onmicrosoft.com")
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
            DependsOn          = "[O365Group]O365DSCCoreTeam"
        }

        <#EXOAtpPolicyForO365 AntiPhishPolicy
        {
            IsSingleInstance        = "Yes"
            AllowClickThrough       = $false
            BlockUrls               = "https://badurl.contoso.com"
            EnableATPForSPOTeamsODB = $true
            GlobalAdminAccount      = $GlobalAdmin
            Ensure                  = "Present"
        }#>

        O365User JohnSmith
        {
            UserPrincipalName  = "John.Smith@$Domain"
            DisplayName        = "John Smith"
            FirstName          = "John"
            LastName           = "Smith"
            City               = "Gatineau"
            Country            = "Canada"
            Office             = "HQ"
            PostalCode         = "5K5 K5K"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }

        O365Group O365DSCCoreTeam
        {
            DisplayName          = "Office365DSC Core Team"
            MailNickName         = "O365DSCCore"
            ManagedBy            = "admin@$Domain"
            Description          = "Group for all the Core Team members"
            Members              = @("John.Smith@$Domain")
            GlobalAdminAccount   = $GlobalAdmin
            Ensure               = "Present"
            DependsOn            = "[O365User]JohnSmith"
        }

        TeamsTeam TeamAlpha
        {
            DisplayName          = "Alpha Team"
            AllowAddRemoveApps   = $true
            AllowChannelMentions = $false
            GlobalAdminAccount   = $GlobalAdmin
            Ensure               = "Present"
        }

        TeamsChannel ChannelAlpha1
        {
            DisplayName        = "Channel Alpha"
            Description        = "Test Channel"
            TeamName           = "Alpha Team"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
            DependsON          = "[TeamsTeam]TeamAlpha"
        }

        TeamsUser MemberJohn
        {
            TeamName           = "Alpha Team"
            User               = "John.Smith@$($Domain)"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
            DependsON          = @("[O365User]JohnSmith","[TeamsTeam]TeamAlpha")
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

# Compile and deploy configuration
$password = ConvertTo-SecureString $GlobalAdminPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($GlobalAdminUser, $password)
Master -ConfigurationData $ConfigurationData -GlobalAdmin $credential -Domain $Domain
Start-DscConfiguration Master -Wait -Force -Verbose
