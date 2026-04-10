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

    Node localhost
    {
        AADCrossTenantAccessPolicyConfigurationPartner "AADCrossTenantAccessPolicyConfigurationPartner"
        {
            PartnerTenantId              = "e7a80bcf-696e-40ca-8775-a7f85fbb3ebc"; # O365DSC.onmicrosoft.com
            AutomaticUserConsentSettings = MSFT_AADCrossTenantAccessPolicyAutomaticUserConsentSettings {
                InboundAllowed           = $False # Updated Property
                OutboundAllowed          = $True
            };
            B2BCollaborationOutbound     = MSFT_AADCrossTenantAccessPolicyB2BSetting {
                Applications = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{
                    AccessType = 'allowed'
                    Targets    = @(
                        MSFT_AADCrossTenantAccessPolicyTarget{
                            Target     = 'AllApplications'
                            TargetType = 'application'
                        }
                    )
                }
                UsersAndGroups = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{
                    AccessType = 'allowed'
                    Targets    = @(
                        MSFT_AADCrossTenantAccessPolicyTarget{
                            Target     = '68bafe64-f86b-4c4e-b33b-9d3eaa11544b' # Office 365
                            TargetType = 'user'
                        }
                    )
                }
            };
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            Ensure                       = "Present";
        }
    }
}
