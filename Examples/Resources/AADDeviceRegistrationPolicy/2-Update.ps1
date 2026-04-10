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
        AADDeviceRegistrationPolicy "MyDeviceRegistrationPolicy"
        {
            ApplicationId                           = $ApplicationId;
            AzureADAllowedToJoin                    = "Selected";
            AzureADAllowedToJoinGroups              = @();
            AzureADAllowedToJoinUsers               = @("AlexW@M365x73318397.OnMicrosoft.com");
            AzureAdJoinLocalAdminsRegisteringGroups = @();
            AzureAdJoinLocalAdminsRegisteringMode   = "Selected";
            AzureAdJoinLocalAdminsRegisteringUsers  = @("AllanD@M365x73318397.OnMicrosoft.com");
            CertificateThumbprint                   = $CertificateThumbprint;
            IsSingleInstance                        = "Yes";
            LocalAdminPasswordIsEnabled             = $False;
            LocalAdminsEnableGlobalAdmins           = $True;
            MultiFactorAuthConfiguration            = $False;
            TenantId                                = $TenantId;
            UserDeviceQuota                         = 50;
        }
    }
}
