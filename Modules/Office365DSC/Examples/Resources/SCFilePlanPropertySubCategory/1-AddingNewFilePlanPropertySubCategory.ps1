<#
This example shows how to create a new File Plan Property Sub-Category.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Office365DSC

    node localhost
    {
        SCFilePlanPropertyCategory FilePlanPropertySubCategory
        {
            Name               = "My Sub-Category"
            Parent             = "My Category"
            Ensure             = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
        }
    }
}
