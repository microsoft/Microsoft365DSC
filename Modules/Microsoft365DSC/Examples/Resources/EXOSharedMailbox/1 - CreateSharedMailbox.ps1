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
        EXOSharedMailbox 'SharedMailbox'
        {
            DisplayName        = "Test"
            PrimarySMTPAddress = "Test@O365DSC1.onmicrosoft.com"
            EmailAddresses     = @("Joufflu@o365dsc1.onmicrosoft.com", "Gilles@O365dsc1.onmicrosoft.com")
            Ensure             = "Present"
            Credential         = $Credscredential
        }
    }
}
