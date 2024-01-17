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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        AADUser 'ConfigureJohnSMith'
        {
            UserPrincipalName  = "John.Smith@$Domain"
            DisplayName        = "John J. Smith"
            Ensure             = "Absent"
            Credential         = $Credscredential
        }
    }
}
