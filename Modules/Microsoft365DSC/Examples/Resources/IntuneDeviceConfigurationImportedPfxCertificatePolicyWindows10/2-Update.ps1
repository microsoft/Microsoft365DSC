<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
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
            Credential                     = $Credscredential;
            DisplayName                    = "PKCS Imported";
            Ensure                         = "Present";
            IntendedPurpose                = "unassigned";
            KeyStorageProvider             = "useSoftwareKsp";
            RenewalThresholdPercentage     = 60; # Updated Property
            SubjectAlternativeNameType     = "emailAddress";
            SubjectNameFormat              = "commonName";
        }
    }
}
