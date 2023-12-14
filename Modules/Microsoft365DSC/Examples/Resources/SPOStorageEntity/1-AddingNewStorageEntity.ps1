<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SPOStorageEntity 'ConfigureDSCStorageEntity'
        {
            Key         = "DSCKey"
            Value       = "Test storage entity"
            EntityScope = "Tenant"
            Description = "Description created by DSC"
            Comment     = "Comment from DSC"
            SiteUrl     = "https://contoso-admin.sharepoint.com"
            Ensure      = "Present"
            Credential  = $Credscredential
        }
    }
}
