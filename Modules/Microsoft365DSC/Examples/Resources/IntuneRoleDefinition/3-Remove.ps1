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
            Ensure                    = 'Absent'
            Credential                = $Credscredential
        }
    }
}
