<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOManagementRoleAssignment 'AssignManagementRole'
        {
            Credential           = $credsCredential;
            Ensure               = "Present";
            Name                 = "MyManagementRoleAssignment";
            Role                 = "UserApplication";
            User                 = "AlexW"; # Updated Property
        }
    }
}
