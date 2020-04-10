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
        SCCaseHoldPolicy CaseHoldPolicy
        {
            Case                 = "Test Case";
            ExchangeLocation     = "DemoGroup@contoso.onmicrosoft.com";
            Name                 = "Demo Hold";
            PublicFolderLocation = "All";
            Comment              = "This is a demo";
            Ensure               = "Present";
            Enabled              = $True;
            GlobalAdminAccount   = $Credsglobaladmin;
        }
    }
}
