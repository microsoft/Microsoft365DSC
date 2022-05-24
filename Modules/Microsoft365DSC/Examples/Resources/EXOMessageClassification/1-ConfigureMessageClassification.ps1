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
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOMessageClassification 'ConfigureMessageClassification'
        {
            Identity                    = "Contoso Message Classification"
            Name                        = "Contoso Message Classification"
            DisplayName                 = "Contoso Message Classification"
            DisplayPrecedence           = "Highest"
            PermissionMenuVisible       = $True
            RecipientDescription        = "Shown to receipients"
            SenderDescription           = "Shown to senders"
            RetainClassificationEnabled = $True
            Ensure                      = "Present"
            Credential                  = $credsGlobalAdmin
        }
    }
}
