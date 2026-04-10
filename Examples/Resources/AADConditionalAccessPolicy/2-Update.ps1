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
        AADConditionalAccessPolicy 'ConditionalAccessPolicy'
        {
            BuiltInControls                          = @("mfa");
            ClientAppTypes                           = @("all");
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            DeviceFilterMode                         = "exclude";
            DeviceFilterRule                         = "device.trustType -eq `"AzureAD`" -or device.trustType -eq `"ServerAD`" -or device.trustType -eq `"Workplace`"";
            DisplayName                              = "Example CAP";
            Ensure                                   = "Present";
            ExcludeUsers                             = @("admin@$Domain");
            GrantControlOperator                     = "OR";
            IncludeApplications                      = @("All");
            IncludeRoles                             = @("Attack Payload Author");
            SignInFrequencyInterval                  = "timeBased";
            SignInFrequencyIsEnabled                 = $True;
            SignInFrequencyType                      = "hours";
            SignInFrequencyValue                     = 2; # Updated Porperty
            State                                    = "disabled";
        }
    }
}
