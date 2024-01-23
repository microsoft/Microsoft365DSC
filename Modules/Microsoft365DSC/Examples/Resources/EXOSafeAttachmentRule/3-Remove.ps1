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
        EXOSafeAttachmentRule 'ConfigureSafeAttachmentRule'
        {
            Identity                  = "Research Department Attachment Rule"
            Enabled                   = $False # Updated Property
            ExceptIfSentToMemberOf    = "Research Department Managers"
            SafeAttachmentPolicy      = "Marketing Block Attachments"
            SentToMemberOf            = "Research Department"
            Ensure                    = "Absent"
            Credential                = $Credscredential
        }
    }
}
