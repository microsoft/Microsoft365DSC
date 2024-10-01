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
        IntuneDiskEncryptionMacOS "IntuneDiskEncryptionMacOS"
        {
            AllowDeferralUntilSignOut           = $True;
            Assignments                         = @();
            Description                         = "test";
            DisplayName                         = "test";
            Enabled                             = $True;
            Ensure                              = "Present";
            NumberOfTimesUserCanIgnore          = -1;
            PersonalRecoveryKeyHelpMessage      = "eeee";
            PersonalRecoveryKeyRotationInMonths = 3; # Updated property
            RoleScopeTagIds                     = @("0");
            SelectedRecoveryKeyTypes            = @("personalRecoveryKey");
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
