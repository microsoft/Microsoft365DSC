# EXOOrganizationRelationship

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the organization relationship. The maximum length is 64 characters. ||
| **ArchiveAccessEnabled** | Write | Boolean | The ArchiveAccessEnabled parameter specifies whether the organization relationship has been configured to provide remote archive access. ||
| **DeliveryReportEnabled** | Write | Boolean | The DeliveryReportEnabled parameter specifies whether Delivery Reports should be shared over the organization relationship. ||
| **DomainNames** | Write | StringArray[] | The DomainNames parameter specifies the SMTP domains of the external organization. You can specify multiple domains separated by commas. ||
| **Enabled** | Write | Boolean | The Enabled parameter specifies whether to enable the organization relationship. ||
| **FreeBusyAccessEnabled** | Write | Boolean | The FreeBusyAccessEnabled parameter specifies whether the organization relationship should be used to retrieve free/busy information from the external organization. ||
| **FreeBusyAccessLevel** | Write | String | The FreeBusyAccessLevel parameter specifies the maximum amount of detail returned to the requesting organization. Valid values are: None, AvailabilityOnly or LimitedDetails |None, AvailabilityOnly, LimitedDetails|
| **FreeBusyAccessScope** | Write | String | The FreeBusyAccessScope parameter specifies a mail-enabled security group in the internal organization that contains users whose free/busy information is accessible by an external organization. You can use any value that uniquely identifies the group. ||
| **MailboxMoveEnabled** | Write | Boolean | The MailboxMoveEnabled parameter specifies whether the organization relationship enables moving mailboxes to or from the external organization. ||
| **MailTipsAccessEnabled** | Write | Boolean | The MailTipsAccessEnabled parameter specifies whether MailTips for users in this organization are returned over this organization relationship. ||
| **MailTipsAccessLevel** | Write | String | The MailTipsAccessLevel parameter specifies the level of MailTips data externally shared over this organization relationship. This parameter can have the following values: All, Limited, None |None, All, Limited|
| **MailTipsAccessScope** | Write | String | The MailTipsAccessScope parameter specifies a mail-enabled security group in the internal organization that contains users whose free/busy information is accessible by an external organization. You can use any value that uniquely identifies the group. ||
| **OrganizationContact** | Write | String | The OrganizationContact parameter specifies the email address that can be used to contact the external organization (for example, administrator@fourthcoffee.com). ||
| **PhotosEnabled** | Write | Boolean | The PhotosEnabled parameter specifies whether photos for users in the internal organization are returned over the organization relationship. ||
| **TargetApplicationUri** | Write | String | The TargetApplicationUri parameter specifies the target Uniform Resource Identifier (URI) of the external organization. The TargetApplicationUri parameter is specified by Exchange when requesting a delegated token to retrieve free and busy information, for example, mail.contoso.com. ||
| **TargetAutodiscoverEpr** | Write | String | The TargetAutodiscoverEpr parameter specifies the Autodiscover URL of Exchange Web Services for the external organization. Exchange uses Autodiscover to automatically detect the correct Exchangeserver endpoint to use for external requests. ||
| **TargetOwaURL** | Write | String | The TargetOwaURL parameter specifies the Outlook on the web (formerly Outlook Web App) URL of the external organization that's defined in the organization relationship. It is used for Outlook on the web redirection in a cross-premise Exchange scenario. Configuring this attribute enables users in the organization to use their current Outlook on the web URL to access Outlook on the web in the external organization. ||
| **TargetSharingEpr** | Write | String | The TargetSharingEpr parameter specifies the URL of the target Exchange Web Services for the external organization. ||
| **Ensure** | Write | String | Specify if the OrganizationRelationship should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOOrganizationRelationship

### Description

This resource configures the Organization Relationship in Exchange Online.


