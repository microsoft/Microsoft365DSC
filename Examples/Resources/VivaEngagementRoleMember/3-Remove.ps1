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
        VivaEngagementRoleMember "VivaEngagementRoleMember-Network Admin"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Members               = @("admin@contoso.com");
            Role                  = "Network Admin";
            TenantId              = $TenantId;
        }
        VivaEngagementRoleMember "VivaEngagementRoleMember-Verified Admin"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Members               = @("admin@contoso.com","NestorW@M365x73318397.OnMicrosoft.com");
            Role                  = "Verified Admin";
            TenantId              = $TenantId;
        }
        VivaEngagementRoleMember "VivaEngagementRoleMember-Corporate Communicator"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Members               = @("NestorW@contoso.com"); #Removed Allan
            Role                  = "Corporate Communicator";
            TenantId              = $TenantId;
        }
    }
}
