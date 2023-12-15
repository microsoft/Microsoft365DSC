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
        EXOSafeAttachmentPolicy 'ConfigureSafeAttachmentPolicy'
        {
            Identity             = "Marketing Block Attachments"
            Enable               = $True
            Redirect             = $True
            RedirectAddress      = "admin@contoso.com"
            Ensure               = "Present"
            Credential           = $Credscredential
        }
    }
}
