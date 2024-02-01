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
    $OrganizationName = $Credscredential.UserName.Split('@')[1]
    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOQuarantinePolicy 'ConfigureQuarantinePolicy'
        {
            EndUserQuarantinePermissionsValue = 87;
            ESNEnabled                        = $True; # Updated Property
            Identity                          = "$Domain\DefaultFullAccessPolicy";
            Ensure                            = "Present"
            Credential                        = $Credscredential
        }
    }
}
