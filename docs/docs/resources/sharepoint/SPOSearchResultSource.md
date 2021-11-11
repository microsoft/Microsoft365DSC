# SPOSearchResultSource

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name of the Result Source. ||
| **Description** | Write | String | Description of the Result Source. ||
| **Protocol** | Required | String | The protocol of the Result Source. |Local, Remote, OpenSearch, Exchange|
| **SourceURL** | Write | String | Address of the root site collection of the remote SharePoint farm or Exchange server. ||
| **Type** | Write | String | Select SharePoint Search Results to search over the entire index. Select People Search Results to enable query processing specific to People Search, such as phonetic name matching or nickname matching. Only people profiles will be returned from a People Search source. |SharePoint, People|
| **QueryTransform** | Write | String | Change incoming queries to use this new query text instead. Include the incoming query in the new text by using the query variable '{searchTerms}'. ||
| **ShowPartialSearch** | Write | Boolean | Show partial search or not ||
| **UseAutoDiscover** | Write | Boolean | Specifies if AutoDiscover should be used for the Exchange Source URL ||
| **Ensure** | Write | String | Present ensures the Search Result Source exists. |Present|
| **Credential** | Write | PSCredential | Credentials of the account to authenticate with. ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

## Description

This resource allows users to create and monitor SharePoint Online Search
Result Sources.

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
        SPOSearchResultSource 'ConfigureSearchResultSource'
        {
            Name        = "MyResultSource"
            Description = "Description of item"
            Protocol    = "Local"
            Type        = "SharePoint"
            Ensure      = "Present"
            Credential  = $credsGlobalAdmin
        }
    }
}
```

