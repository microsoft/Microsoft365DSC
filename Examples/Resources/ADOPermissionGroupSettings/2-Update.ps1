<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter()]
        [PSCredential]
        $Credential
    )
    Import-DscResource -ModuleName Microsoft365DSC
    node localhost
    {
        ADOPermissionGroupSettings "ADOPermissionGroupSettings-O365DSC-DEV"
        {
            AllowPermissions     = @(
                MSFT_ADOPermission {
                    NamespaceId = '5a27515b-ccd7-42c9-84f1-54c998f03866'
                    DisplayName = 'Edit identity information'
                    Bit         = '2'
                    Token       = 'f6492b10-7ae8-4641-8208-ff5c364a6154\dbe6034e-8fbe-4d6e-a7f3-07a7e70816c9'
                }
            );
            Credential           = $Credential;
            DenyPermissions      = @();
            Descriptor           = "vssgp.Uy0xLTktMTU1MTM3NDI0NS0yNzEyNzI0MzgtMzkwMDMyNjIxNC0yMTgxNjI3NzQwLTkxMDg0NDI0NC0xLTgyODcyNzAzNC0yOTkzNjA0MTcxLTI5MjUwMjk4ODgtNTY0MDg1OTcy";
            GroupName            = "[O365DSC-DEV]\My Test Group";
            OrganizationName     = "O365DSC-DEV";
        }
    }
}
