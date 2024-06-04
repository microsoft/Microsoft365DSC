<#
This example deletes a new App Configuration Device Policy.
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
            Credential  = $Credscredential;
            Description = "";
            DisplayName = "Example";
            Ensure      = "Present";
            Id          = "0000000-0000-0000-0000-000000000000";
            TenantId    = $OrganizationName;
        }
    }
}
