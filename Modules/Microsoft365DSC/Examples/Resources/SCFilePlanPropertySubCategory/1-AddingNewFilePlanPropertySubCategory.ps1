<#
This example shows how to create a new File Plan Property Sub-Category.
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
        SCFilePlanPropertySubCategory 'FilePlanPropertySubCategory'
        {
            Name       = "My Sub-Category"
            Category   = "My Category"
            Ensure     = "Present"
            Credential = $Credscredential
        }
    }
}
