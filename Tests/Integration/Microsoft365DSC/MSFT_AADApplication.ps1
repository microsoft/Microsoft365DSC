param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [String]
        $ApplicationId,

        [Parameter(Mandatory = $true)]
        [String]
        $TenantId,

        [Parameter(Mandatory = $true)]
        [String]
        $CertificateThumbprint,

        [Parameter(Mandatory = $true)]
        [PSCredential]
        $ApplicationSecret
)

Configuration AADApplication-New
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [String]
        $ApplicationId,

        [Parameter(Mandatory = $true)]
        [String]
        $TenantId,

        [Parameter(Mandatory = $true)]
        [String]
        $CertificateThumbprint,

        [Parameter(Mandatory = $true)]
        [PSCredential]
        $ApplicationSecret
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADApplication 'AADApplication-Creds'
        {
            DisplayName               = "AADAppicationIntegrationCreds"
            AvailableToOtherTenants   = $false
            GroupMembershipClaims     = "0"
            Homepage                  = "https://office365dsc.com"
            IdentifierUris            = "https://office365dsc.com/Creds"
            KnownClientApplications   = ""
            LogoutURL                 = "https://office365dsc.com/logout"
            PublicClient              = $false
            ReplyURLs                 = "https://office365dsc.com"
            Permissions               = @(
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $false
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.ReadWrite.All'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read.All'
                    Type                = 'AppOnly'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
            )
            Ensure                    = "Present"
            Credential                = $Credential
        }

        AADApplication 'AADApplication-Cert'
        {
            DisplayName               = "AADAppicationIntegrationCert"
            AvailableToOtherTenants   = $false
            GroupMembershipClaims     = "0"
            Homepage                  = "https://office365dsc.com"
            IdentifierUris            = "https://office365dsc.com/Cert"
            KnownClientApplications   = ""
            LogoutURL                 = "https://office365dsc.com/logout"
            PublicClient              = $false
            ReplyURLs                 = "https://office365dsc.com"
            Permissions               = @(
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $false
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.ReadWrite.All'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read.All'
                    Type                = 'AppOnly'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
            )
            Ensure                    = "Present"
            ApplicationId             = $ApplicationId
            TenantId                  = $TenantId
            CertificateThumbprint     = $CertificateThumbprint
        }

        AADApplication 'AADApplication-Secret'
        {
            DisplayName               = "AADAppicationIntegrationSecret"
            AvailableToOtherTenants   = $false
            GroupMembershipClaims     = "0"
            Homepage                  = "https://office365dsc.com"
            IdentifierUris            = "https://office365dsc.com/Secret"
            KnownClientApplications   = ""
            LogoutURL                 = "https://office365dsc.com/logout"
            PublicClient              = $false
            ReplyURLs                 = "https://office365dsc.com"
            Permissions               = @(
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $false
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.ReadWrite.All'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read.All'
                    Type                = 'AppOnly'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
            )
            Ensure                    = "Present"
            ApplicationId             = $ApplicationId
            TenantId                  = $TenantId
            ApplicationSecret         = $ApplicationSecret
        }
    }
}

Configuration AADApplication-Update
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [String]
        $ApplicationId,

        [Parameter(Mandatory = $true)]
        [String]
        $TenantId,

        [Parameter(Mandatory = $true)]
        [String]
        $CertificateThumbprint,

        [Parameter(Mandatory = $true)]
        [PSCredential]
        $ApplicationSecret
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADApplication 'AADApplication-Creds'
        {
            DisplayName               = "AADAppicationIntegrationCreds"
            AvailableToOtherTenants   = $true #Drift
            GroupMembershipClaims     = "0"
            Homepage                  = "https://office365dsc.com"
            IdentifierUris            = "https://office365dsc.com/Creds"
            KnownClientApplications   = ""
            LogoutURL                 = "https://office365dsc.com/logout"
            PublicClient              = $false
            ReplyURLs                 = "https://office365dsc.com"
            Permissions               = @(
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $false
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.ReadWrite.All'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read.All'
                    Type                = 'AppOnly'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
            )
            Ensure                    = "Present"
            Credential                = $Credential
        }

        AADApplication 'AADApplication-Cert'
        {
            DisplayName               = "AADAppicationIntegrationCert"
            AvailableToOtherTenants   = $true #Drift
            GroupMembershipClaims     = "0"
            Homepage                  = "https://office365dsc.com"
            IdentifierUris            = "https://office365dsc.com/Cert"
            KnownClientApplications   = ""
            LogoutURL                 = "https://office365dsc.com/logout"
            PublicClient              = $false
            ReplyURLs                 = "https://office365dsc.com"
            Permissions               = @(
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $false
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.ReadWrite.All'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read.All'
                    Type                = 'AppOnly'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
            )
            Ensure                    = "Present"
            ApplicationId             = $ApplicationId
            TenantId                  = $TenantId
            CertificateThumbprint     = $CertificateThumbprint
        }

        AADApplication 'AADApplication-Secret'
        {
            DisplayName               = "AADAppicationIntegrationSecret"
            AvailableToOtherTenants   = $true #drift
            GroupMembershipClaims     = "0"
            Homepage                  = "https://office365dsc.com"
            IdentifierUris            = "https://office365dsc.com/Secret"
            KnownClientApplications   = ""
            LogoutURL                 = "https://office365dsc.com/logout"
            PublicClient              = $false
            ReplyURLs                 = "https://office365dsc.com"
            Permissions               = @(
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $false
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.ReadWrite.All'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read.All'
                    Type                = 'AppOnly'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
            )
            Ensure                    = "Present"
            ApplicationId             = $ApplicationId
            TenantId                  = $TenantId
            ApplicationSecret         = $ApplicationSecret
        }
    }
}

Configuration AADApplication-Remove
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [String]
        $ApplicationId,

        [Parameter(Mandatory = $true)]
        [String]
        $TenantId,

        [Parameter(Mandatory = $true)]
        [String]
        $CertificateThumbprint,

        [Parameter(Mandatory = $true)]
        [PSCredential]
        $ApplicationSecret
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADApplication 'AADApplication-Creds'
        {
            DisplayName               = "AADAppicationIntegrationCreds"
            AvailableToOtherTenants   = $true
            GroupMembershipClaims     = "0"
            Homepage                  = "https://office365dsc.com"
            IdentifierUris            = "https://office365dsc.com/Creds"
            KnownClientApplications   = ""
            LogoutURL                 = "https://office365dsc.com/logout"
            PublicClient              = $false
            ReplyURLs                 = "https://office365dsc.com"
            Permissions               = @(
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $false
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.ReadWrite.All'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read.All'
                    Type                = 'AppOnly'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
            )
            Ensure                    = "Absent"
            Credential                = $Credential
        }

        AADApplication 'AADApplication-Cert'
        {
            DisplayName               = "AADAppicationIntegrationCert"
            AvailableToOtherTenants   = $true
            GroupMembershipClaims     = "0"
            Homepage                  = "https://office365dsc.com"
            IdentifierUris            = "https://office365dsc.com/Cert"
            KnownClientApplications   = ""
            LogoutURL                 = "https://office365dsc.com/logout"
            PublicClient              = $false
            ReplyURLs                 = "https://office365dsc.com"
            Permissions               = @(
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $false
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.ReadWrite.All'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read.All'
                    Type                = 'AppOnly'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
            )
            Ensure                    = "Absent"
            ApplicationId             = $ApplicationId
            TenantId                  = $TenantId
            CertificateThumbprint     = $CertificateThumbprint
        }

        AADApplication 'AADApplication-Secret'
        {
            DisplayName               = "AADAppicationIntegrationSecret"
            AvailableToOtherTenants   = $true
            GroupMembershipClaims     = "0"
            Homepage                  = "https://office365dsc.com"
            IdentifierUris            = "https://office365dsc.com/Secret"
            KnownClientApplications   = ""
            LogoutURL                 = "https://office365dsc.com/logout"
            PublicClient              = $false
            ReplyURLs                 = "https://office365dsc.com"
            Permissions               = @(
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $false
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.ReadWrite.All'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read.All'
                    Type                = 'AppOnly'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
            )
            Ensure                    = "Absent"
            ApplicationId             = $ApplicationId
            TenantId                  = $TenantId
            ApplicationSecret         = $ApplicationSecret
        }
    }
}
$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName                    = "Localhost"
            PSDSCAllowPlaintextPassword = $true
            PSDscAllowDomainUser        = $true
        }
    )
}

AADApplication-New -Credential $Credential `
    -ApplicationId $ApplicationId `
    -TenantId $TenantId `
    -CertificateThumbprint $CertificateThumbprint `
    -ApplicationSecret $ApplicationSecret `
    -ConfigurationData $ConfigurationData

Start-DSCConfiguration AADApplication-New -Force -Wait -Verbose
$results = Test-DSCConfiguration
if (-not $results)
{
    throw "Couldn't properly create new instance"
}

AADApplication-Update -Credential $Credential `
    -ApplicationId $ApplicationId `
    -TenantId $TenantId `
    -CertificateThumbprint $CertificateThumbprint `
    -ApplicationSecret $ApplicationSecret `
    -ConfigurationData $ConfigurationData

Start-DSCConfiguration AADApplication-Update -Force -Wait -Verbose
$results = Test-DSCConfiguration
if (-not $results)
{
    throw "Couldn't properly update existing instance"
}

AADApplication-Remove -Credential $Credential `
    -ApplicationId $ApplicationId `
    -TenantId $TenantId `
    -CertificateThumbprint $CertificateThumbprint `
    -ApplicationSecret $ApplicationSecret `
    -ConfigurationData $ConfigurationData
Start-DSCConfiguration AADApplication-Remove -Force -Wait -Verbose
$results = Test-DSCConfiguration
if (-not $results)
{
    throw "Couldn't properly remove existing instance"
}
