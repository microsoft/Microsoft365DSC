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
        IntuneAntivirusPolicyLinux 'myIntuneAntivirusPolicyLinux'
        {
            allowedThreats                     = @("Threat 1");
            Assignments                        = @();
            Description                        = "";
            disallowedThreatActions            = @("Disallowed Thread Action 1");
            DisplayName                        = "Test";
            enabled                            = "true";
            Ensure                             = "Present";
            exclusions                         = @(
                MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions{
                    Exclusions_item_extension = '.vba' # Updated property
                    Exclusions_item_type = 'excludedFileExtension'
                }
                MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions{
                    Exclusions_item_name = 'process1'
                    Exclusions_item_type = 'excludedFileName'
                }
            );
            RoleScopeTagIds                    = @("0");
            threatTypeSettings                 = @(
                MSFT_MicrosoftGraphIntuneSettingsCatalogThreatTypeSettings{
                    ThreatTypeSettings_item_key = 'potentially_unwanted_application'
                    ThreatTypeSettings_item_value = 'audit'
                }
                MSFT_MicrosoftGraphIntuneSettingsCatalogThreatTypeSettings{
                    ThreatTypeSettings_item_key = 'archive_bomb'
                    ThreatTypeSettings_item_value = 'block'
                }
            );
            unmonitoredFilesystems             = @("Filesystem 1");
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
