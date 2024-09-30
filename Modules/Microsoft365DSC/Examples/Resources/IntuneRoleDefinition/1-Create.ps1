<#
This example creates a new Intune Role Definition.
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
        IntuneRoleDefinition 'IntuneRoleDefinition'
        {
            DisplayName               = 'This is my role'
            allowedResourceActions    = @('Microsoft.Intune_Organization_Read', 'Microsoft.Intune_Roles_Create', 'Microsoft.Intune_Roles_Read', 'Microsoft.Intune_Roles_Update')
            Description               = 'My role defined by me.'
            IsBuiltIn                 = $False
            notallowedResourceActions = @()
            roleScopeTagIds           = @('0', '1')
            Ensure                    = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
