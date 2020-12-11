<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADConditionalAccessPolicy Allin-example
        {
            GlobalAdminAccount        = $credsGlobalAdmin;
            BuiltInControls           = @("Mfa", "CompliantDevice", "DomainJoinedDevice", "ApprovedApplication", "CompliantApplication");
            ClientAppTypes            = @("ExchangeActiveSync", "Browser", "MobileAppsAndDesktopClients", "Other");
            CloudAppSecurityIsEnabled = $True;
            CloudAppSecurityType      = "MonitorOnly";
            DisplayName               = "Allin-example";
            Ensure                    = "Present";
            ExcludeApplications       = @("803ee9ca-3f7f-4824-bd6e-0b99d720c35c", "00000012-0000-0000-c000-000000000000", "00000007-0000-0000-c000-000000000000", "Office365");
            ExcludeDeviceStates       = @("Compliant", "DomainJoined");
            ExcludeLocations          = @("Blocked Countries");
            ExcludePlatforms          = @("Windows", "WindowsPhone", "MacOS");
            ExcludeRoles              = @("Company Administrator", "Application Administrator", "Application Developer", "Cloud Application Administrator", "Cloud Device Administrator");
            ExcludeUsers              = @("admin@contoso.com", "AAdmin@contoso.com", "CAAdmin@contoso.com", "AllanD@contoso.com", "AlexW@contoso.com", "GuestsOrExternalUsers");
            GrantControlOperator      = "OR";
            IncludeApplications       = @("All");
            IncludeDeviceStates       = @("All");
            IncludeLocations          = @("AllTrusted");
            IncludePlatforms          = @("Android", "IOS");
            IncludeUserActions        = @();
            IncludeUsers              = @("All");
            PersistentBrowserMode     = "";
            SignInFrequencyIsEnabled  = $True;
            SignInFrequencyType       = "Hours";
            SignInFrequencyValue      = 5;
            SignInRiskLevels          = @("High", "Medium");
            State                     = "disabled";
            UserRiskLevels            = @("High", "Medium");
        }
    }
}
