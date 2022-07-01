# AADTermsOfUse

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Frequency** | Write | String | Represents the frequency at which the terms will expire, after its first expiration as set in startDateTime. ||
| **StartDateTime** | Write | String | The DateTime when the agreement is set to expire for all users. ||
| **AgreementFileId** | Write | String | The identifier of the agreement file accepted by the user. ||
| **AgreementId** | Write | String | The identifier of the agreement. ||
| **DeviceDisplayName** | Write | String | The display name of the device used for accepting the agreement. ||
| **DeviceId** | Write | String | The unique identifier of the device used for accepting the agreement. ||
| **DeviceOSType** | Write | String | The operating system used to accept the agreement. ||
| **DeviceOSVersion** | Write | String | The operating system version of the device used to accept the agreement. ||
| **ExpirationDateTime** | Write | String | The expiration date time of the acceptance. ||
| **RecordedDateTime** | Write | String | The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. ||
| **State** | Write | String | The state of the agreement acceptance. ||
| **UserDisplayName** | Write | String | Display name of the user when the acceptance was recorded. ||
| **UserEmail** | Write | String | Email of the user when the acceptance was recorded. ||
| **UserId** | Write | String | The identifier of the user who accepted the agreement. ||
| **UserPrincipalName** | Write | String | UPN of the user when the acceptance was recorded. ||
| **Id** | Write | String | The identifier of the agreement acceptance. ||
| **Localizations** | Write | InstanceArray[] | The localized version of the terms of use agreement files attached to the agreement. ||
| **CreatedDateTime** | Write | String | The date time representing when the file was created. ||
| **displayName** | Write | String | Localized display name of the policy file of an agreement. ||
| **fileName** | Write | String | Name of the agreement file (for example, TOU.pdf). ||
| **isDefault** | Write | Boolean | If none of the languages matches the client preference, indicates whether this is the default agreement file. ||
| **isMajorVersion** | Write | Boolean | Indicates whether the agreement file is a major version update. Major version updates invalidate the agreement's acceptances on the corresponding language. ||
| **language** | Write | String | The language of the agreement file in the format 'languagecode2-country/regioncode2'. ||
| **id** | Write | String | The identifier of the agreementFileVersion object. ||
| **Versions** | Write | InstanceArray[] | Customized versions of the terms of use agreement in the Azure AD tenant. ||
| **CreatedDateTime** | Write | String | The date time representing when the file was created. ||
| **DisplayName** | Write | String | Localized display name of the policy file of an agreement. ||
| **FileName** | Write | String | Name of the agreement file (for example, TOU.pdf). ||
| **IsDefault** | Write | Boolean | If none of the languages matches the client preference, indicates whether this is the default agreement file. ||
| **IsMajorVersion** | Write | Boolean | Indicates whether the agreement file is a major version update. Major version updates invalidate the agreement's acceptances on the corresponding language. ||
| **Language** | Write | String | The language of the agreement file in the format 'languagecode2-country/regioncode2'. ||
| **Id** | Write | String | The identifier of the agreementFileVersion object. ||
| **CreatedDateTime** | Write | String | The date time representing when the file was created. ||
| **DisplayName** | Write | String | Localized display name of the policy file of an agreement. ||
| **FileData** | Write | Instance | Data that represents the terms of use PDF document. ||
| **FileName** | Write | String | Name of the agreement file (for example, TOU.pdf) ||
| **IsDefault** | Write | Boolean | If none of the languages matches the client preference, indicates whether this is the default agreement file. ||
| **IsMajorVersion** | Write | Boolean | Indicates whether the agreement file is a major version update. Major version updates invalidate the agreement's acceptances on the corresponding language. ||
| **Language** | Write | String | The language of the agreement file in the format 'languagecode2-country/regioncode2'. ||
| **Id** | Write | String | The identifier of the agreementFileVersion object. ||
| **Data** | Write | String | Data that represents the terms of use PDF document. ||
| **Id** | Key | String | The identifier of the agreement. ||
| **DisplayName** | Write | String | Display name of the agreement. ||
| **IsPerDeviceAcceptanceRequired** | Write | Boolean | Indicates whether end users are required to accept this agreement on every device that they access it from. ||
| **IsViewingBeforeAcceptanceRequired** | Write | Boolean | Indicates whether the user has to expand the agreement before accepting. ||
| **TermsExpiration** | Write | Instance | Expiration schedule and frequency of agreement for all users. ||
| **UserReacceptRequiredFrequency** | Write | String | The duration after which the user must re-accept the terms of use. ||
| **Acceptances** | Write | InstanceArray[] | Read-only. Information about acceptances of this agreement. ||
| **File** | Write | Instance | Default PDF linked to this agreement. ||
| **Files** | Write | InstanceArray[] | PDFs linked to this agreement. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Azure Active Directory Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

# AADTermsOfUse

### Description

This resource represents a tenant's customizable terms of use agreement that is created and managed with Azure Active Directory (Azure AD).

## Azure AD Permissions

To authenticate via Azure Active Directory, this resource requires the following Application permissions:

* **Automate**
  * Agreement.Read.All
  * AgreementAcceptance.Read
* **Export**
  * Agreement.ReadWrite.All

NOTE: All permissions listed above require admin consent.

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
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
        AADTermsOfUse 'AADTermsOfUse'
        {
            DisplayName                       = "ToU general 2";
            Files                             = @(
				MSFT_MicrosoftGraphagreementfilelocalization{
					Id = '041b18d7-a318-4d88-abb1-000000000000'
					FileName = 'patch-file.pdf'
					CreatedDateTime = '06/15/2022 17:50:57'
					Language = 'en-GB'
					Versions = @(
						MSFT_MicrosoftGraphagreementfileversion{
							Id = '041b18d7-a318-4d88-abb1-000000000000'
							FileData = MSFT_MicrosoftGraphagreementfiledata{
								data = 'SGVsbG8gd29ybGQ=//truncated-binary'
							}
						}
					)
					DisplayName = 'File uploaded via resource'
				}
			);
            Id                                = "9213cf0b-afbf-4397-b7cb-000000000000";
            IsPerDeviceAcceptanceRequired     = $False;
            IsViewingBeforeAcceptanceRequired = $True;
            Ensure                            = "Present"
            Credential                        = $credsGlobalAdmin
        }
    }
}
```

