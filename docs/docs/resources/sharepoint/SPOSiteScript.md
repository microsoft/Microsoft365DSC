﻿# SPOSiteScript

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Title** | Key | String | The title of the site script. ||
| **Identity** | Write | String | ID of the site Script ||
| **Description** | Write | String | The description of the site script. ||
| **Content** | Write | String | A JSON string containing the site script. ||
| **Ensure** | Write | String | Present ensures the site script exists, absent ensures it is removed |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the account to authenticate with. ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

# SPOSiteScript

### Description

This resource allows users to manage JSON files that specify an ordered list of actions to run when creating the new sites.

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
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SPOSiteScript 'ConfigureSiteScript'
        {
            Identity             = "5c73382d-9643-4aa0-9160-d0cba35e40fd"
            Title                = "My Site Script"
            Content              = '{
                "$schema": "schema.json",
                "actions": [
                    {
                      "verb": "setSiteLogo",
                      "url": "https://contoso.sharepoint.com/SiteAssets/company-logo.png"
                    }
                ]
            }'
            Description          = "My custom site script"
            Ensure               = "Present"
            Credential           = $credsGlobalAdmin
        }
    }
}
```

