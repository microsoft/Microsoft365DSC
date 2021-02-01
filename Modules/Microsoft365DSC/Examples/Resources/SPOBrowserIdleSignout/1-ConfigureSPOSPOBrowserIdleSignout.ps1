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
        SPOBrowserIdleSignout MyTenant
        {
            Enabled            = $True;
            GlobalAdminAccount = $Credsglobaladmin;
            IsSingleInstance   = "Yes";
            SignOutAfter       = "04:00:00";
            WarnAfter          = "03:30:00";
        }
    }
}
