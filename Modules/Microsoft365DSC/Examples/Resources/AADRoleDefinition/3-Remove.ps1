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
        AADRoleDefinition 'AADRoleDefinition1'
        {
            IsEnabled                     = $true
            RolePermissions               = "microsoft.directory/applicationPolicies/allProperties/read"
            DisplayName                   = "DSCRole1"
            Ensure                        = "Absent"
            Credential                    = $Credscredential
        }
    }
}
