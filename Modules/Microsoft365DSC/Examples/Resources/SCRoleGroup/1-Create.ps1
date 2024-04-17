<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SCRoleGroup 'ConfigureRoleGroup'
        {
            Name                      = "Contoso Role Group"
            Description               = "Address Lists Role for Purview Administrators"
            Roles                     = @("Address Lists")
            Ensure                    = "Present"
            Credential                = $Credscredential
        }
    }
}
