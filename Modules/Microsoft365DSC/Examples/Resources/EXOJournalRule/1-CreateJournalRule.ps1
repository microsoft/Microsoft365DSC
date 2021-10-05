<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOJournalRule e067a72d-01e2-49ac-9d9f-a21b096d03c9
        {
            Enabled              = $True;
            Ensure               = "Present";
            Credential           = $credsGlobalAdmin;
            JournalEmailAddress  = "John.Smith@contoso.com";
            Name                 = "Send to John"
            RuleScope            = "Global";
        }
    }
}
