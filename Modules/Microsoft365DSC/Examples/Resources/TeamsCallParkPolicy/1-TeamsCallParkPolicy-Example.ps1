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
        TeamsCallParkPolicy 'Example'
        {
            AllowCallPark        = $False;
            Credential           = $Credscredential;
            Ensure               = "Present";
            Identity             = "Global";
            ParkTimeoutSeconds   = 300;
            PickupRangeEnd       = 99;
            PickupRangeStart     = 10;
        }
    }
}
