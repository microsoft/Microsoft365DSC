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
        IntuneRoleDefinition "IntuneRoleDefinition"
        {
            allowedResourceActions    = @("Microsoft.Intune_Organization_Read","Microsoft.Intune_Roles_Create","Microsoft.Intune_Roles_Read","Microsoft.Intune_Roles_Update");
            Description               = "My role defined by me.";
            DisplayName               = "This is my role";
            Ensure                    = "Present";
            Id                        = "";
            IsBuiltIn                 = $False;
            notallowedResourceActions = @();
            roleScopeTagIds           = @("0","1");
            Credential                = $credsGlobalAdmin
        }
    }
}
