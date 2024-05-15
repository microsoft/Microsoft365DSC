When you have decided which authentication method to use and made sure all prerequisites (created an application registration and granted/consented permissions) are in place, you are ready to use the authentication method in a DSC configuration. This chapter shows examples of each of the Authentication Methods.

### Example 1: Credentials

This method is using credentials (username / password combination) for authentication and requires that the used credential is **NOT** configured to use Multi-Factor Authentication!

When using credentials you have to specify a PSCredential object in the Credential parameter. The PSCredential object contains the username and password for the user that you want to connect with.

```PowerShell
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

### Example 2: Service Principal with Application Secret

This method is using a service principal with an application secret for authentication. In this case you have to specify the Application ID (found on the Application Registration page in the Azure Admin Portal), the Tenant ID (<tenantname>.onmicrosoft.com of your tenant) and application secret (generated value when creating a new secrets on the Application Registration page in the Azure Admin Portal).

```PowerShell
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

### Example 3: Service Principal with Certificate Thumbprint

This method is using a service principal with a certificate thumbprint for authentication and requires that the used certificate is already imported into the local computer certificate store! With this method you have to specify the Application ID (found on the Application Registration page in the Azure Admin Portal), the Tenant ID (<tenantname>.onmicrosoft.com of your tenant) and the tumbprint of the certificate you added to the certificates page of the Application Registration in the Azure Admin Portal.

```PowerShell
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

### Example 4: Service Principal with Certificate PFX file

This method is using a service principal with a certificate PFX file and file password for authentication. To use this method you need to have an export of the certificate that was added to the certificates page of the Application Registration in the Azure Admin Portal. Then you have to specify the Application ID (found on the Application Registration page in the Azure Admin Portal), the Tenant ID (<tenantname>.onmicrosoft.com of your tenant), the path of the PFX file and the password of this PFX file.

```PowerShell
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
