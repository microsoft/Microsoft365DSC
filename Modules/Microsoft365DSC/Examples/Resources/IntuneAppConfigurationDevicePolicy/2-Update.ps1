<#
This example updates an App Configuration Device Policy.
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
        IntuneAppConfigurationDevicePolicy "IntuneAppConfigurationDevicePolicy-Example"
        {
            Credential            = $Credscredential;
            Assignments           = @();
            Description           = "";
            DisplayName           = "Example";
            Ensure                = "Present";
            Id                    = "0000000-0000-0000-0000-000000000000";
            ConnectedAppsEnabled  = $true;
            PackageId             = "app:com.microsoft.office.outlook"
            PayloadJson           = "Base64 encoded settings"
            PermissionActions     = @(
                MSFT_MicrosoftGraphAndroidPermissionAction{
                    Action = "prompt"
                    Permission = "android.permission.READ_CALENDAR"
                }
            ) # Updated property
            ProfileApplicability  = "default"
            RoleScopeTagIds       = @("0");
            TargetedMobileApps    = @("<Mobile App Id>");
            TenantId              = $OrganizationName;
        }
    }
}
