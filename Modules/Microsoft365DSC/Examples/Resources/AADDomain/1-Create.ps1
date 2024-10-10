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
        AADDomain "AADDomain-Contoso"
        {
            ApplicationId                    = $ApplicationId;
            AuthenticationType               = "Managed";
            CertificateThumbprint            = $CertificateThumbprint;
            Ensure                           = "Present";
            Id                               = "contoso.com";
            IsAdminManaged                   = $True;
            IsDefault                        = $True;
            IsRoot                           = $True;
            IsVerified                       = $True;
            PasswordNotificationWindowInDays = 14;
            PasswordValidityPeriodInDays     = 2147483647;
            TenantId                         = $TenantId;
        }
    }
}
