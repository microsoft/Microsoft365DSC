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
        IntuneDeviceConfigurationScepCertificatePolicyWindows10 'Example'
        {
            Assignments                    = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            CertificateStore               = "user";
            CertificateValidityPeriodScale = "years";
            CertificateValidityPeriodValue = 5;
            Credential                     = $Credscredential;
            CustomSubjectAlternativeNames  = @(
                MSFT_MicrosoftGraphcustomSubjectAlternativeName{
                    SanType = 'domainNameService'
                    Name = 'dns'
                }
            );
            DisplayName                    = "SCEP";
            Ensure                         = "Present";
            ExtendedKeyUsages              = @(
                MSFT_MicrosoftGraphextendedKeyUsage{
                    ObjectIdentifier = '1.3.6.1.5.5.7.3.2'
                    Name = 'Client Authentication'
                }
            );
            HashAlgorithm                  = "sha2";
            KeySize                        = "size2048";
            KeyStorageProvider             = "useTpmKspOtherwiseUseSoftwareKsp";
            KeyUsage                       = "digitalSignature";
            RenewalThresholdPercentage     = 25;
            ScepServerUrls                 = @("https://mydomain.com/certsrv/mscep/mscep.dll");
            SubjectAlternativeNameType     = "none";
            SubjectNameFormat              = "custom";
            SubjectNameFormatString        = "CN={{UserName}},E={{EmailAddress}}";
            RootCertificateId              = "169bf4fc-5914-40f4-ad33-48c225396183";
        }
    }
}
