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
        AADAppManagementPolicy "MyAppManagementPolicy"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Description           = "Cred policy";
            DisplayName           = "AppManagementPolicy";
            Ensure                = "Present";
            IsEnabled             = $True;
            Restrictions          = MSFT_AADAppManagementPolicyRestrictions{
                passwordCredentials = @(
                    MSFT_AADAppManagementPolicyRestrictionsCredential{
                        restrictForAppsCreatedAfterDateTime = "01/01/0001 00:00:00"
                        restrictionType = "passwordAddition"
                        state = "enabled"
                    }
                    MSFT_AADAppManagementPolicyRestrictionsCredential{
                        maxLifetime = "P90DT0H0M0S"
                        restrictForAppsCreatedAfterDateTime = "01/01/0001 00:00:00"
                        restrictionType = "passwordLifetime"
                        state = "enabled"
                    }
                    MSFT_AADAppManagementPolicyRestrictionsCredential{
                        restrictForAppsCreatedAfterDateTime = "01/01/0001 00:00:00"
                        restrictionType = "symmetricKeyAddition"
                        state = "enabled"
                    }
                    MSFT_AADAppManagementPolicyRestrictionsCredential{
                        maxLifetime = "P90DT0H0M0S"
                        restrictForAppsCreatedAfterDateTime = "01/01/0001 00:00:00"
                        restrictionType = "symmetricKeyLifetime"
                        state = "enabled"
                    }
                )
            };
            TenantId              = $TenantId;
        }
    }
}
