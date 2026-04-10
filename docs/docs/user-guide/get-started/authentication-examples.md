# Authentication Examples

When you have decided which authentication method to use and made sure all prerequisites (created an application registration and granted/consented permissions) are in place, you are ready to use the authentication method in a DSC configuration. This chapter shows examples of each of the Authentication Methods.

## Example 1: Credentials

This method is using credentials (username / password combination) for authentication and requires that the used credential is **NOT** configured to use Multi-Factor Authentication!

When using credentials you have to specify a PSCredential object in the Credential parameter. The PSCredential object contains the username and password for the user that you want to connect with.

```powershell
Configuration CredentialsExample
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SPOSite 'SiteWithCredentials'
        {
            Url        = "https://contoso.sharepoint.com/sites/credentialssite"
            Owner      = "admin@contoso.onmicrosoft.com"
            Title      = "TestSite"
            Template   = "STS#3"
            TimeZoneId = 13
            Ensure     = "Present"
            Credential = $Credscredential
        }
    }
}
```

**NOTE:** It is possible to use Conditional Access to restrict the locations from where this account is able to log into Microsoft 365. See <a href="https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/howto-conditional-access-policy-location" target="_blank">here for more information on Conditional Access</a>.

## Example 2: Service Principal with Application Secret

This method is using a service principal with an application secret for authentication. In this case you have to specify the Application ID (found on the Application Registration page in the Azure Admin Portal), the Tenant ID (<tenantname>.onmicrosoft.com of your tenant) and application secret (generated value when creating a new secrets on the Application Registration page in the Azure Admin Portal).

```powershell
Configuration ApplicationSecretExample
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ApplicationId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ApplicationSecret
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SPOSite 'SiteWithApplicationSecret'
        {
            Url               = "https://contoso.sharepoint.com/sites/applicationsecretsite"
            Owner             = "admin@contoso.onmicrosoft.com"
            Title             = "TestSite"
            Template          = "STS#3"
            TimeZoneId        = 13
            Ensure            = "Present"
            ApplicationId     = $ApplicationId
            TenantId          = $TenantId
            ApplicationSecret = $ApplicationSecret
        }
    }
}
```

## Example 3: Service Principal with Certificate Thumbprint

This method is using a service principal with a certificate thumbprint for authentication and requires that the used certificate is already imported into the local computer certificate store! With this method you have to specify the Application ID (found on the Application Registration page in the Azure Admin Portal), the Tenant ID (`<tenantname>.onmicrosoft.com` of your tenant) and the tumbprint of the certificate you added to the certificates page of the Application Registration in the Azure Admin Portal.

```powershell
Configuration CertificateThumbprintExample
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ApplicationId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificateThumbprint
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SPOSite 'SiteWithCertificateThumbprint'
        {
            Url                   = "https://contoso.sharepoint.com/sites/certificatethumbprintsite"
            Owner                 = "admin@contoso.onmicrosoft.com"
            Title                 = "TestSite"
            Template              = "STS#3"
            TimeZoneId            = 13
            Ensure                = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

## Example 4: Service Principal with Certificate PFX file

This method is using a service principal with a certificate PFX file and file password for authentication. To use this method you need to have an export of the certificate that was added to the certificates page of the Application Registration in the Azure Admin Portal. Then you have to specify the Application ID (found on the Application Registration page in the Azure Admin Portal), the Tenant ID (<tenantname>.onmicrosoft.com of your tenant), the path of the PFX file and the password of this PFX file.

```powershell
Configuration CertificatePathExample
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ApplicationId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificatePath,

        [Parameter(Mandatory = $true)]
        [PSCredential]
        $CertificatePassword
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SPOSite 'SiteWithCertificatePathAndPassword'
        {
            Url                 = "https://contoso.sharepoint.com/sites/certificatepathsite"
            Owner               = "admin@contoso.onmicrosoft.com"
            Title               = "TestSite"
            Template            = "STS#3"
            TimeZoneId          = 13
            Ensure              = "Present"
            ApplicationId       = $ApplicationId
            TenantId            = $TenantId
            CertificatePath     = $CertificatePath
            CertificatePassword = $CertificatePassword
        }
    }
}
```

## Example 5: Managed Identity

This method is using a Managed Identity instance. To use this method you need to have a Managed Identity set up (e.g. from an Azure Automation Account) and with the appropriate permissions assigned. Next, you need to specify the Tenant ID (<tenantname>.onmicrosoft.com of your tenant) in combination with the `ManagedIdentity` switch parameter.

```powershell
Configuration ManagedIdentityExample
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADVerifiedIdAuthority 'VerifiedIdAuthorityWithManagedIdentity'
        {
            DidMethod        = "web";
            KeyVaultMetadata = MSFT_AADVerifiedIdAuthorityKeyVaultMetadata{
                SubscriptionId = '2ff65b89-ab22-4489-b84d-e60d1dc30a62'
                ResourceName = 'xtakeyvault'
                ResourceUrl = 'https://xtakeyvault.vault.azure.net/'
                ResourceGroup = 'TBD'
            };
            LinkedDomainUrl  = "https://nik-charlebois.com/";
            Name             = "Contoso";
            Ensure           = "Present"
            ManagedIdentity  = $true
            TenantId         = $TenantId
        }
    }
}
```

## Example 6: Access Tokens

This method is using an Access Token. To use this method you need to first get the access token using e.g. `Get-AzAccessToken -ResourceUrl <resource or url>` for the type of resources you want to manage. For almost all of the AAD and all of the Intune resources, the `https://graph.microsoft.com` resource url is sufficient. However, for resources that require an additional connection (for example the `AADVerifiedIdAuthority` resource, it depends on the `AdminAPI` connection), you might need another scope. In the `AdminAPI` example, the resource url is `6a8b4b39-c021-437c-b060-5a14a3fd65f3` for an application access because it targets the `https://verifiedid.did.msidentity.com` endpoint. Next, you need to specify the Tenant ID (<tenantname>.onmicrosoft.com of your tenant) in combination with the `AccessTokens` parameter.

```powershell
# Fetch access token
Connect-AzAccount
$accessToken = (ConvertFrom-SecureString -SecureString (Get-AzAccessToken -ResourceUrl "6a8b4b39-c021-437c-b060-5a14a3fd65f3").Token -AsPlainText)

Configuration AccessTokensExample
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $AccessTokens
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADVerifiedIdAuthority 'VerifiedIdAuthorityWithManagedIdentity'
        {
            DidMethod        = "web";
            KeyVaultMetadata = MSFT_AADVerifiedIdAuthorityKeyVaultMetadata{
                SubscriptionId = '2ff65b89-ab22-4489-b84d-e60d1dc30a62'
                ResourceName = 'xtakeyvault'
                ResourceUrl = 'https://xtakeyvault.vault.azure.net/'
                ResourceGroup = 'TBD'
            };
            LinkedDomainUrl  = "https://nik-charlebois.com/";
            Name             = "Contoso";
            Ensure           = "Present"
            AccessTokens     = $AccessTokens
            TenantId         = $TenantId
        }
    }
}
```
