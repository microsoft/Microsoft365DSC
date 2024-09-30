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
        IntuneRoleAssignment 'IntuneRoleAssignment'
        {
            DisplayName                = 'test2'
            Description                = 'test Updated' # Updated Property
            Members                    = @('')
            MembersDisplayNames        = @('SecGroup2')
            ResourceScopes             = @('6eb76881-f56f-470f-be0d-672145d3dcb1')
            ResourceScopesDisplayNames = @('')
            ScopeType                  = 'resourceScope'
            RoleDefinition             = '2d00d0fd-45e9-4166-904f-b76ac5eed2c7'
            RoleDefinitionDisplayName  = 'This is my role'
            Ensure                     = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
