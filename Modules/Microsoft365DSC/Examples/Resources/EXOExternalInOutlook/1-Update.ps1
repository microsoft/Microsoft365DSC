<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
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
        EXOExternalInOutlook "EXOExternalInOutlook"
        {
            Identity              = "ExternalInOutlook";
            AllowList             = @("mobile01@contoso.onmicrosoft.com","*contoso.onmicrosoft.com","contoso.com");
            Enabled               = $False;
            Ensure                = "Present";
            Credential            = $Credscredential
        }
    }
}
