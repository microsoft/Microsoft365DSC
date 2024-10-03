<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOMailContact 'TestMailContact'
        {
            Alias                       = 'TestMailContact'
            DisplayName                 = 'My Test Contact'
            Ensure                      = 'Present'
            ExternalEmailAddress        = 'SMTP:test@tailspintoys.com'
            MacAttachmentFormat         = 'BinHex'
            MessageBodyFormat           = 'TextAndHtml'
            MessageFormat               = 'Mime'
            ModeratedBy                 = @()
            ModerationEnabled           = $false
            Name                        = 'My Test Contact'
            OrganizationalUnit          = $TenantId
            SendModerationNotifications = 'Always'
            UsePreferMessageFormat      = $true
            CustomAttribute1            = 'Custom Value 1'
            ExtensionCustomAttribute5   = 'Extension Custom Value 1', 'Extension Custom Value 2'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
