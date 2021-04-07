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
        AADNamedLocationPolicy CompanyNetwork
        {
            DisplayName        = "Company Network";
            Ensure             = "Present";
            IpRanges           = @("2.1.1.1/32", "1.2.2.2/32");
            IsTrusted          = $True;
            OdataType          = "#microsoft.graph.ipNamedLocation";
            TenantId           = $ConfigurationData.NonNodeData.TenantId;
            GlobalAdminAccount = $credsGlobalAdmin;
        }
        AADNamedLocationPolicy AllowedCountries
        {
            CountriesAndRegions               = @("GH", "AX", "DZ", "AI", "AM");
            DisplayName                       = "Allowed Countries";
            Ensure                            = "Present";
            IncludeUnknownCountriesAndRegions = $False;
            OdataType                         = "#microsoft.graph.countryNamedLocation";
            TenantId                          = $ConfigurationData.NonNodeData.TenantId;
            GlobalAdminAccount                = $credsGlobalAdmin;
        }
    }
}
