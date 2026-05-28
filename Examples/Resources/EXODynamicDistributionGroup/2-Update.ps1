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
        EXODynamicDistributionGroup "EXODynamicDistributionGroup-EXODynamicDistributionGroup_1"
        {
            AcceptMessagesOnlyFrom               = @();
            AcceptMessagesOnlyFromDLMembers      = @();
            Alias                                = "dynamicdistributiongroup_1";
            ApplicationId                        = $ConfigurationData.NonNodeData.ApplicationId;
            BypassModerationFromSendersOrMembers = @();
            CertificateThumbprint                = $ConfigurationData.NonNodeData.CertificateThumbprint;
            DisplayName                          = "EXODynamicDistributionGroup_1";
            EmailAddresses                       = @("SMTP:dynamicdistributiongroup_1@contoso.onmicrosoft.com");
            Ensure                               = "Present";
            ExtensionCustomAttribute1            = @();
            ExtensionCustomAttribute2            = @();
            ExtensionCustomAttribute3            = @();
            ExtensionCustomAttribute4            = @();
            ExtensionCustomAttribute5            = @();
            GrantSendOnBehalfTo                  = @();
            HiddenFromAddressListsEnabled        = $True; # Updated property
            Identity                             = "EXODynamicDistributionGroup_1";
            MailTipTranslations                  = @();
            ManagedBy                            = "admin@contoso.onmicrosoft.com";
            ModeratedBy                          = @("admin2@contoso.onmicrosoft.com");
            ModerationEnabled                    = $True;
            Name                                 = "EXODynamicDistributionGroup_1";
            PrimarySmtpAddress                   = "dynamicdistributiongroup_1@contoso.onmicrosoft.com";
            RecipientContainer                   = "contoso.onmicrosoft.com";
            RecipientFilter                      = "((Title -eq 'Architect') -or (Title -eq 'Title'))";
            RejectMessagesFrom                   = @();
            RejectMessagesFromDLMembers          = @();
            ReportToManagerEnabled               = $False;
            ReportToOriginatorEnabled            = $True;
            RequireSenderAuthenticationEnabled   = $True;
            SendModerationNotifications          = "Always";
            SendOofMessageToOriginatorEnabled    = $False;
            SimpleDisplayName                    = "";
            TenantId                             = $OrganizationName;
            WindowsEmailAddress                  = "dynamicdistributiongroup_1@contoso.onmicrosoft.com";
        }
    }
}
