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
        IntuneDeviceConfigurationPkcsCertificatePolicyWindows10 'Example'
        {
            Assignments                    = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            CertificateStore               = "user";
            CertificateTemplateName        = "Template DSC";
            CertificateValidityPeriodScale = "years";
            CertificateValidityPeriodValue = 1;
            CertificationAuthority         = "CA=Name";
            CertificationAuthorityName     = "Test";
            Credential                     = $Credscredential;
            CustomSubjectAlternativeNames  = @(
                MSFT_MicrosoftGraphcustomSubjectAlternativeName{
                    SanType = 'domainNameService'
                    Name = 'certificate.com'
                }
            );
            DisplayName                    = "PKCS";
            Ensure                         = "Present";
            KeyStorageProvider             = "usePassportForWorkKspOtherwiseFail";
            RenewalThresholdPercentage     = 20;
            SubjectAlternativeNameType     = "none";
            SubjectNameFormat              = "custom";
            SubjectNameFormatString        = "CN={{UserName}},E={{EmailAddress}}";
        }
    }
}
