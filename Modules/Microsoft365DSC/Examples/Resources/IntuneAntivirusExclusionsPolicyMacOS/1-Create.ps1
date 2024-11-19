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
        IntuneAntivirusExclusionsPolicyMacOS 'myIntuneAntivirusExclusionsPolicyMacOS'
        {
            Assignments = @();
            Description = "";
            DisplayName = "Test";
            Ensure      = "Present";
            Exclusions  = @(
                MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions{
                    Exclusions_item_extension = '.dmg'
                    Exclusions_item_type = '1'
                }
                MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions{
                    Exclusions_item_name = 'process1'
                    Exclusions_item_type = '2'
                }
            );
            RoleScopeTagIds                    = @("0");
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}