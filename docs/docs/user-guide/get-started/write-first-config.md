## Write your First Microsoft365DSC Configuration

With Microsoft365DSC, you write your configuration for an Microsoft 365 tenant just like you'd be writing any other DSC configuration. If you don't feel comfortable writing your configuration from scratch, we recommend starting by extracting the configuration from an existing tenant and using this as a baseline to modify/add your own set of configuration. Please refer to the [Extracting Configuration from an Existing Microsoft 365 Tenant](extract-config.md) for more information.

A Microsoft365DSC configuration is a PowerShell script (.ps1) file that defines a Configuration object. Most Microsoft365DSC configuration should be run on the current machine (localhost) and will have a structure similar to the following:

```sh
  Configuration NameOfTheConfiguration
    {
        Import-DSCResource -ModuleName Microsoft365DSC
        $GlobalAdminAccount = Get-Credential
        Node localhost
        {
            <Insert Configuration Here>
        }
    }
    NameOfTheConfiguration
```

The last line of the above code simply calls into the **Configuration Object** as if it was a function. This will initiate a compilation operation on the current configuration. If you decide to name your configuration something other than "NameOfTheConfiguration" you will need to update that line accordingly as well.

Now that we have the skeleton for our configuration, we need to start populating it with configuration blocks we call DSC Resources Blocks. In the Microsoft365DSC taxonomy, a **resource** is a component of a workload that can be configured. For example, SPOSite is the resource to configure a SharePoint Online site collection, SCDLPComplianceRule is the resource to configure a Security and Compliance Center Data Loss Prevention (DLP) Rule, etc. Each one of these resources further defines properties that they can manage. In the case of the SPOSite resource for example, properties such as the URL, Title, Storage Quota, etc. acan all be managed by the resource. If we build on this example, I can define a new SharePoint Online site collection using the following DSC Resource Block:

```sh
 SPOSite MyHRSite
    {
        Title              = "Human Resources"
        Url                = "https:/<My Domain>/sites/HR"
        Owner              = "admin@<My Domain>"
        Template           = "STS#3"
        GlobalAdminAccount = $GlobalAdminAccount
        Ensure             = "Present"
    }

```
The above DSC Resource Block could be inserted inside the **Node** section of the configuration frame we've convered above. In our example, we are defining a SharePoint Online site collection with title Human Resources and a given URL, owner alias and Template. The DSC Resource Block is given a name of MyHRSite which is meaningless in the bigger scheme of things. DSC simply requires that all instances of a given resource have DSC resource blocks with unique names. Therefore within the same configuration you cannont have two SPOSite DSC Resource Blocks named MyHRSite, but you could have a SPOSite and a SCDLPComplianceRule resource block both named **MyHRSite** without any issues.

You will also notice from the example above that we are defining a **GlobalAdminAccount** property, passing it the obtained credentials for our tenant's admin account. This property is required for every DSC Resource Block and specifies what account to impersonate when configuring or analyzing the Microsoft 365 tenant. The other property in the resource block is **Ensure**. Most resources that can be used to create instances of a component have that property available. It can either be set to **Present** or **Absent**. If the above example had the property set to Absent, it would mean that a site collection should never exist at the specified URL. If there was such an existing site, Microsoft365DSC would remove it. Omitting to specify this property on resources that support it will default to a value of 'Present'.

For a full list of all DSC resources supported by Microsoft365DSC, their associated properties and examples on how to use them, please refer to our [List of Resources](https://github.com/microsoft/Microsoft365DSC/wiki/Resources-List) on the wiki of our GitHub repository.
