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
        EXOMailContact 'TestMailContact'
        {
            Alias                       = 'TestMailContact'
            Credential                  = $Credscredential
            DisplayName                 = 'My Test Contact'
            Ensure                      = 'Present'
            ExternalEmailAddress        = 'SMTP:test@tailspintoys.com'
            MacAttachmentFormat         = 'BinHex'
            MessageBodyFormat           = 'TextAndHtml'
            MessageFormat               = 'Mime'
            ModeratedBy                 = @()
            ModerationEnabled           = $false
            Name                        = 'My Test Contact'
            OrganizationalUnit          = "nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/$Domain"
            SendModerationNotifications = 'Always'
            UsePreferMessageFormat      = $true
            CustomAttribute1            = 'Custom Value 1'
            ExtensionCustomAttribute5   = 'Extension Custom Value 1', 'Extension Custom Value 2'
        }
    }
}
