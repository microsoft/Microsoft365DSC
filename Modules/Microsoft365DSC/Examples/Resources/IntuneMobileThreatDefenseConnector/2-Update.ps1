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
        AllowPartnerToCollectIosApplicationMetadata         = $False;
        AllowPartnerToCollectIosPersonalApplicationMetadata = $False;
        AndroidDeviceBlockedOnMissingPartnerData            = $False;
        AndroidEnabled                                      = $False;
        AndroidMobileApplicationManagementEnabled           = $False;
        Credential                                          = $Credscredential;
        Ensure                                              = "Present"; #drift
        Id                                                  = "2c7790de-8b02-4814-85cf-e0c59380dee8";
        IosDeviceBlockedOnMissingPartnerData                = $False;
        IosEnabled                                          = $False;
        IosMobileApplicationManagementEnabled               = $False;
        MicrosoftDefenderForEndpointAttachEnabled           = $False;
        PartnerState                                        = "notSetUp";
        PartnerUnresponsivenessThresholdInDays              = 0;
        PartnerUnsupportedOSVersionBlocked                  = $False;
        WindowsDeviceBlockedOnMissingPartnerData            = $False;
        WindowsEnabled                                      = $False;

    }
}
