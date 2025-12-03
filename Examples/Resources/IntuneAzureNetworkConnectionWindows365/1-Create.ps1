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
        IntuneAzureNetworkConnectionWindows365 "IntuneAzureNetworkConnectionWindows365-IntuneWindows365AzureNetworkConnection_Hybrid"
        {
            AdDomainName          = "contoso.com";
            AdDomainUsername      = "username@contoso.com";
            AdDomainPassword      = "securePassword";
            ConnectionType        = "hybridAzureADJoin";
            DisplayName           = "IntuneWindows365AzureNetworkConnection_Hybrid";
            Ensure                = "Present";
            OrganizationalUnit    = "OU=Test,DC=contoso,DC=com";
            ResourceGroupId       = "/subscriptions/subscription-name/resourceGroups/resource-group-name";
            RoleScopeTagIds       = @("0");
            SubnetId              = "/subscriptions/subscription-name/resourceGroups/resource-group-name/providers/Microsoft.Network/virtualNetworks/virtual-network-name/subnets/default";
            SubscriptionName      = "subscription-name";
            VirtualNetworkId      = "/subscriptions/subscription-name/resourceGroups/resource-group-name/providers/Microsoft.Network/virtualNetworks/virtual-network-name";
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            TenantId              = $TenantId;
        }
        IntuneAzureNetworkConnectionWindows365 "IntuneAzureNetworkConnectionWindows365-IntuneWindows365AzureNetworkConnection_Entra"
        {
            ConnectionType        = "azureADJoin";
            DisplayName           = "IntuneWindows365AzureNetworkConnection_Entra_1";
            Ensure                = "Present";
            ResourceGroupId       = "/subscriptions/subscription-name/resourceGroups/resource-group-name";
            RoleScopeTagIds       = @("0");
            SubnetId              = "/subscriptions/subscription-name/resourceGroups/resource-group-name/providers/Microsoft.Network/virtualNetworks/virtual-network-name/subnets/default";
            SubscriptionName      = "subscription-name";
            VirtualNetworkId      = "/subscriptions/subscription-name/resourceGroups/resource-group-name/providers/Microsoft.Network/virtualNetworks/virtual-network-name";
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            TenantId              = $TenantId;
        }
    }
}
