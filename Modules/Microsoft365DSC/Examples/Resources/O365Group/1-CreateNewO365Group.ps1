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
        O365Group 'OttawaTeamGroup'
        {
            DisplayName        = "Ottawa Employees"
            MailNickName       = "OttawaEmployees"
            Description        = "This is only for employees of the Ottawa Office"
            ManagedBy          = "TenantAdmin@contoso.onmicrosoft.com"
            Members            = @("Bob.Houle", "John.Smith")
            Ensure             = "Present"
            Credential         = $Credscredential
        }
    }
}
