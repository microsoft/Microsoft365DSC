<#
This example creates a new Intune Role Definition.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        IntuneRoleDefinition "bb52f6f6-d0a7-4a39-afdb-a64709773e4c"
        {
            allowedResourceActions    = @("Microsoft.Intune_Organization_Read","Microsoft.Intune_Roles_Create","Microsoft.Intune_Roles_Read","Microsoft.Intune_Roles_Update");
            Description               = "My 2nd role defined by me.";
            DisplayName               = "This is my 2nd role";
            Ensure                    = "Absent";
            Id                        = "bb52f6f6-d0a7-4a39-afdb-a64709773e4c";
            IsBuiltIn                 = $False;
            notallowedResourceActions = @();
        }
    }
}
