# EXOMailboxCalendarFolder

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the calendar folder that you want to modify. | |
| **DetailLevel** | Write | String | The DetailLevel parameter specifies the level of calendar detail that's published and available to anonymous users. | `AvailabilityOnly`, `LimitedDetails`, `FullDetails` |
| **PublishDateRangeFrom** | Write | String | The PublishDateRangeFrom parameter specifies the start date of calendar information to publish (past information). | `OneDay`, `ThreeDays`, `OneWeek`, `OneMonth`, `ThreeMonths`, `SixMonths`, `OneYear` |
| **PublishDateRangeTo** | Write | String | The PublishDateRangeTo parameter specifies the end date of calendar information to publish (future information). | `OneDay`, `ThreeDays`, `OneWeek`, `OneMonth`, `ThreeMonths`, `SixMonths`, `OneYear` |
| **PublishEnabled** | Write | Boolean | The PublishEnabled parameter specifies whether to publish the specified calendar information. | |
| **SearchableUrlEnabled** | Write | Boolean | The SearchableUrlEnabled parameter specifies whether the published calendar URL is discoverable on the web. | |
| **SharedCalendarSyncStartDate** | Write | String | The SharedCalendarSyncStartDate parameter specifies the limit for past events in the shared calendar that are visible to delegates. A copy of the shared calendar within the specified date range is stored in the delegate's mailbox. | |
| **Credential** | Write | PSCredential | Credentials of the Exchange Admin | |
| **Ensure** | Write | String | Determines wether or not the instance exist. | `Present` |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures calendar publishing or sharing settings on a mailbox
for the visibility of calendar information to external users.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Organization Management, Recipient Management

#### Role Groups

- Organization Management, Help Desk

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOMailboxCalendarFolder "JohnCalendarFolder"
        {
            Credential           = $credsCredential;
            DetailLevel          = "AvailabilityOnly";
            Ensure               = "Present";
            Identity             = "AlexW@$Domain" + ":\Calendar";
            PublishDateRangeFrom = "ThreeMonths";
            PublishDateRangeTo   = "ThreeMonths";
            PublishEnabled       = $True; # Updated Property
            SearchableUrlEnabled = $False;
        }
    }
}
```

