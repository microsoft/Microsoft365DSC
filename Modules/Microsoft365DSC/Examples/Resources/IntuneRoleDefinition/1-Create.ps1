<#
This example creates a new Intune Role Definition.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
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
            Credential                = $Credscredential
        }
    }
}
