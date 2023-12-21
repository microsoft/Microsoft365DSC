<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADConditionalAccessPolicy 'Allin-example'
        {
            ApplicationEnforcedRestrictionsIsEnabled = $False;
            BuiltInControls                          = @("mfa");
            ClientAppTypes                           = @("all");
            CloudAppSecurityIsEnabled                = $True; # Updated Porperty
            Credential                               = $Credscredential;
            DeviceFilterMode                         = "exclude";
            DeviceFilterRule                         = "device.trustType -eq `"AzureAD`" -or device.trustType -eq `"ServerAD`" -or device.trustType -eq `"Workplace`"";
            DisplayName                              = "Example CAP";
            Ensure                                   = "Present";
            ExcludeUsers                             = @("admin@$Domain");
            GrantControlOperator                     = "OR";
            IncludeApplications                      = @("All");
            IncludeRoles                             = @("Attack Payload Author");
            PersistentBrowserIsEnabled               = $False;
            SignInFrequencyInterval                  = "timeBased";
            SignInFrequencyIsEnabled                 = $True;
            SignInFrequencyType                      = "hours";
            SignInFrequencyValue                     = 1;
            State                                    = "disabled";
        }
    }
}
