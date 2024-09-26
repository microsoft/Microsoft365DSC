<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
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
    node localhost
    {
        ADOSecurityPolicy "ADOPolicy"
        {
            AllowAnonymousAccess                    = $True;
            AllowRequestAccessToken                 = $False;
            AllowTeamAdminsInvitationsAccessToken   = $True;
            ApplicationId                           = $ApplicationId;
            ArtifactsExternalPackageProtectionToken = $False;
            CertificateThumbprint                   = $CertificateThumbprint;
            DisallowAadGuestUserAccess              = $True;
            DisallowOAuthAuthentication             = $True;
            DisallowSecureShell                     = $False;
            EnforceAADConditionalAccess             = $False;
            LogAuditEvents                          = $True;
            OrganizationName                        = "O365DSC-Dev";
            TenantId                                = $TenantId;
        }
    }
}
