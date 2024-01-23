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
        EXOApplicationAccessPolicy 'ConfigureApplicationAccessPolicy'
        {
            Identity             = "Global"
            AccessRight          = "DenyAccess"
            AppID                = @("3dbc2ae1-7198-45ed-9f9f-d86ba3ec35b5", "6ac794ca-2697-4137-8754-d2a78ae47d93")
            PolicyScopeGroupId   = "Engineering Staff"
            Description          = "Engineering Group Policy"
            Ensure               = "Present"
            Credential           = $Credscredential
        }
    }
}
