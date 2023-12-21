<#
This example creates a new Intune Role Assigment.
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
        IntuneRoleAssignment 'IntuneRoleAssignment'
        {
            DisplayName                = 'test2'
            Ensure                     = 'Absent'
            Credential                 = $Credscredential
        }
    }
}
