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
            Id                        = 'f84bc63b-a377-4d90-8f4a-1de84d36a429'
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
