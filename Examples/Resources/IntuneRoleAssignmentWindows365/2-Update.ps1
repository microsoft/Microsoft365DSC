<#
This example creates a new Intune Role Assigment.
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        IntuneRoleAssignmentWindows365 "IntuneRoleAssignmentWindows365_1"
        {
            AppScopeIds           = @("0");
            Description           = "";
            DirectoryScopes       = @("AADGroup_1");
            DisplayName           = "IntuneRoleAssignmentWindows365_1";
            Ensure                = "Present";
            Principals            = @("AADGroup_2"); # Updated property
            RoleDefinition        = "IntuneRoleDefinitionWindows365_1";
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            TenantId              = $TenantId;
        }
    }
}
