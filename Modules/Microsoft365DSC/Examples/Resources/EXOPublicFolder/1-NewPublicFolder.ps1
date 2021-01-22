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
        EXOPublicFolder Demo
        {
            Identity            = "New Public Folder";
            EformsLocaleId      = "en-US"
            Path                = "\Legal\Cases"
            Mailbox             = "My Mailbox"
            GlobalAdminAccount  = $credsGlobalAdmin;
        }
    }
}
