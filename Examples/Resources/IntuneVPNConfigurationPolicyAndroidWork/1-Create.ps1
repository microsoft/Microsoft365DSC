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
        IntuneVPNConfigurationPolicyAndroidWork "IntuneVPNConfigurationPolicyAndroidWork-Example"
        {
            ApplicationId                      = $ApplicationId;
            TenantId                           = $TenantId;
            CertificateThumbprint              = $CertificateThumbprint;
            Assignments                        = @();
            authenticationMethod               = "usernameAndPassword";
            connectionName                     = "IntuneVPNConfigurationPolicyAndroidWork ConnectionName";
            connectionType                     = "ciscoAnyConnect";
            Description                        = "IntuneVPNConfigurationPolicyAndroidWork Description";
            DisplayName                        = "IntuneVPNConfigurationPolicyAndroidWork DisplayName";
            Ensure                             = "Present";
            Id                                 = "12345678-1234-abcd-1234-12345678ABCD";
            servers                            = @(
                MSFT_MicrosoftGraphvpnServer{
                    isDefaultServer            = $True
                    description                = 'server'
                    address                    = 'vpn.test.com'
                }
            );
        }
    }
}
