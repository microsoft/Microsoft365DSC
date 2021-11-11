<iframe width="560" height="315" src="https://www.youtube.com/embed/Bax6eVshfwY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Before getting ready to contribute a resource to the project, make sure you've read and followed the steps described in [Setting up your Environment to Contribute to the Project](../getting-started).

## Select the Resource to Add

DSC resources need to support CRUD operations, meaning that we need to be able to read them, create (or set) instances of them, update them and sometimes remove them. In that regards, your first step in selecting a resource to add should be to make sure there are associated PowerShell cmdlets (or APIs) available to support your resource.

For example, the SCComplianceCase resource has the following cmdlets available in the Security and Compliance Powershell module: **New-ComplianceCase**, **Set-ComplianceCase**, **Get-ComplianceCase** and **Remove-ComplianceCase**. It is therefore a candidate to be added as a resource to the project.

A few rules also apply to your resource selection:
* For SharePoint Online, where possible, prioritize using the PnP module over the Microsoft.Online.SharePoint.PowerShell one. We are slowly transitioning over an exclusive use of the PnP module and will eventually phase out the use of the SharePoint Online Management Shell.

* Some cmdlets in the Exchange and Security and Compliance modules are only available to certain SKUs, you will need to make sure that executing a configuration that uses your resource against a SKU that doesn’t support its underlying cmdlets or API is gracefully handled, and does not throw a blocking error.

## Create the Resource Files

The best way to get started here is to simply copy and existing resource, and then to rename and modify it. All resources are found under **/Modules/Microsoft365DSC/DSCResources**. Each resource is represented by a folder, a .psm1 file which contains the logic of the resource, a .schema.mof file which is a class defining the properties of the resource as well as with a readme.md file which describes what the resource is for.

The Folder, module and schema files need to be named based on the following pattern:
- Need to start with **MSFT_** to indicate that this is for a project under the Microsoft organization.
- Need to then contain letters representing the workload associated to the resource (EXO for Exchange Online, SPO for SharePoint Online, OD for OneDrive, SC for Security and Compliance, TEAMS for teams, and O365 for generic admin resources).
- The rest of the name should normally follow the same naming convention as the cmdlet it represents. For example, because the cmdlet to create a new compliance case is New-ComplianceCase, the associated resource would be named **MSFT_SCComplianceCase**.

## Start with the Parameters

Now that you've identified what resource you wish to work on, take a look at the documentation for the associated cmdlets or APIs. For example, the MSFT_SCComplianceCase cmdlet information is found at [https://docs.microsoft.com/en-us/powershell/module/exchange/policy-and-compliance-ediscovery/new-compliancecase?view=exchange-ps](https://docs.microsoft.com/en-us/powershell/module/exchange/policy-and-compliance-ediscovery/new-compliancecase?view=exchange-ps).

Take a look at the list of parameters and figure out which one should be implemented by your resource. For the Compliance Case example, the documentation lists the following properties:

```PowerShell
New-ComplianceCase
   [-Name] String
   [-Confirm]
   [-Description] String
   [-DomainController]FQDN
   [-Sources] Object[]
   [-WhatIf]
   [CommonParameters]
```

Some of these parameters can be ignored since they do not make sense to implement in a resource or for Office 365 altogether. From the list of parameters above, we can see that parameter **Name** should be our key indicator. We can also see that we won't need to implement the Confirm, WhatIf and CommonParameters properties in our resources since they don't make sense in the context of DSC. On top of that, if we read through the documentation, we can see that the **DomainController** and **Sources** properties are reserved for internal Microsoft use. Therefore we won't be implementing them within our resource.

The list of parameters is not yet complete at this point. If we take a look at the update cmdlet **Set-ComplianceCase**, we can see from its documentation that it accepts a **-Close** and **-Reopen** property to define if a case is opened or closed. We will add this property to our resource as **Status** and will accept **Active** or **Closed** as values.

We now need to write the list of parameters our Get, Set, and Test functions will accept. Note that the list of parameters for these three functions need to be **exactly the same** otherwise the resource validation will fail. In the Compliance Case example, the properties will translate to the following:

```PowerShell
[Parameter(Mandatory = $true)]
[System.String]
$Name,

[Parameter()]
[System.String]
$Description,

[Parameter()]
[ValidateSet("Active", "Closed")]
[System.String]
$Status = "Active"
```

On top of these resources specific parameters, each resource should define the **Ensure** when they support removing instances of the resource. Every resource is  also required to define the **GlobalAdminAccount**. By adding these two additional properties, the function signature of our resource then becomes:

```PowerShell
function Get|Set|Test-TargetResource
[CmdletBinding()]
[OutputType([Hashtable|void|Boolean])]
param
(
    [Parameter(Mandatory = $true)]
    [System.String]
    $Name,

    [Parameter()]
    [System.String]
    $Description,

    [Parameter()]
    [ValidateSet("Active", "Closed")]
    [System.String]
    $Status = "Active",

    [Parameter()]
    [ValidateSet('Present', 'Absent')]
    [System.String]
    $Ensure = 'Present',

    [Parameter(Mandatory = $true)]
    [System.Management.Automation.PSCredential]
    $GlobalAdminAccount
)
```

Microsoft365DSC also supports [ReverseDSC](https://github.com/Microsoft/ReverseDSC) natively, which means that it needs to define a fourth function named **Export-TargetResource** in each resources. This function should only ever accept the **GlobalAdminAccount** property. The logic of this function should loop through each instances of your resources in the tenant, and convert them into DSC strings. Please refer to existing resources to better understand the logic of this function.

## Define the Schema

Next is the schema file where we will define what properties are expected by our resources in the public scope. You need to make sure you clearly identify the requirement type of each parameter in our resources. These can be:

- **Key**: Represents a unique identifier of the resource. There can be more than one key parameter for your resource. Any given configuration cannot define duplicates of the same instance of key parameters. These need to be unique inside a node in your configuration.
- **Required**: Represents a property that is mandatory. These are not primary keys and can have duplicate values inside your configuration.
- **Write**: Represents optional properties.

Some properties can also define a restricted set of accepted values. These can be identified as **ValueMap** in the parameter definition (see example below). You will also need to provide a description for each parameter. Ideally you should simply copy the description of the property from the official documentation on [docs.microsoft.com](https://docs.microsoft.com).

If we take our previous example, the schema file for our MSFT_SCComplianceCase resource would become:

```PowerShell
[ClassVersion("1.0.0.0"), FriendlyName("SCComplianceCase")]
class MSFT_SCComplianceCase : OMI_BaseResource
{
    [Key, Description("The Name parameter specifies the unique name of the compliance case.")] String Name;
    [Write, Description("The description of the case.")] String Description;
    [Write, Description("Specify if this case should exist or not."), ValueMap{"Present","Absent"}, Values{"Present","Absent"}] String Ensure;
    [Write, Description("Status for the case. Can either be 'Active' or 'Closed'"), ValueMap{"Active","Closed"}, Values{"Active","Closed"}] String Status;
    [Required, Description("Credentials of the Global Admin Account"), EmbeddedInstance("MSFT_Credential")] String GlobalAdminAccount;
};
```

From the example above, note that the class name reflects the full resource name with the **MSFT_** prefix. We are however defining a friendly name in the metadata. This should only reflect the short name (without prefix) of the resource. This will allow us to use this alias within our configurations to represent the resource.
