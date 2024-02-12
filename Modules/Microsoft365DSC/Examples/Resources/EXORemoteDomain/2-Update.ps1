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
        EXORemoteDomain 583b0b70-b45d-401f-98a6-0e7fa8434946
        {
            Identity                             = "Integration"
            AllowedOOFType                       = "External"
            AutoForwardEnabled                   = $True
            AutoReplyEnabled                     = $False # Updated Property
            ByteEncoderTypeFor7BitCharsets       = "Undefined"
            CharacterSet                         = "iso-8859-1"
            ContentType                          = "MimeHtmlText"
            DeliveryReportEnabled                = $True
            DisplaySenderName                    = $True
            DomainName                           = "contoso.com"
            IsInternal                           = $False
            LineWrapSize                         = "Unlimited"
            MeetingForwardNotificationEnabled    = $False
            Name                                 = "Integration"
            NonMimeCharacterSet                  = "iso-8859-1"
            PreferredInternetCodePageForShiftJis = "Undefined"
            TargetDeliveryDomain                 = $False
            TrustedMailInboundEnabled            = $False
            TrustedMailOutboundEnabled           = $False
            UseSimpleDisplayName                 = $False
            Ensure                               = "Present"
            Credential                           = $Credscredential
        }
    }
}
