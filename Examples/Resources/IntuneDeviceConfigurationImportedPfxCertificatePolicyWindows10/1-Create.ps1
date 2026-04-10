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
        IntuneDeviceConfigurationImportedPfxCertificatePolicyWindows10 'Example'
        {
            Assignments                    = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            CertificateValidityPeriodScale = "years";
            CertificateValidityPeriodValue = 1;
            DisplayName                    = "PKCS Imported";
            Ensure                         = "Present";
            IntendedPurpose                = "unassigned";
            KeyStorageProvider             = "useSoftwareKsp";
            RenewalThresholdPercentage     = 50;
            SubjectAlternativeNameType     = "emailAddress";
            SubjectNameFormat              = "commonName";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
