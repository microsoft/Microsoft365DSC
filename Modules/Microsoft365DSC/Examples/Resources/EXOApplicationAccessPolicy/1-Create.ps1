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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOApplicationAccessPolicy 'ConfigureApplicationAccessPolicy'
        {
            Identity             = "Integration Policy"
            AccessRight          = "DenyAccess"
            AppID                = '3dbc2ae1-7198-45ed-9f9f-d86ba3ec35b5'
            PolicyScopeGroupId   = "IntegrationMailEnabled@$Domain"
            Description          = "Engineering Group Policy"
            Ensure               = "Present"
            Credential           = $Credscredential
        }
    }
}
