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

    node localhost
    {
        EXOQuarantinePolicy 'ConfigureQuarantinePolicy'
        {
            EndUserQuarantinePermissionsValue = 87;
            ESNEnabled                        = $False;
            Identity                          = "$OrganizationName\DefaultFullAccessPolicy";
            Ensure                            = "Present"
            Credential                        = $Credscredential
        }
    }
}
