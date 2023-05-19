# Key Parameters in Desired State Configuration

PowerShell Desired State Configurations (DSC) are used to configure a system in a desired state. This is done by comparing the current state of the system with the desired state and applying the necessary changes to get to the desired state. The state is defined by the configuration. Every part of the configuration needs to be unique. Uniqueness is defined by the keys of the resource. The keys are the parameters that are used to identify a resource. If the keys are not unique, the configuration will not compile.

This is a unique configuration for two users in a tenant:

```powershell

Configuration MyConfig {

    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost {

        # Create a new user 1
        AADUser User1 {
            UserPrincipalName = "User1@tenant.onmicrosoft.com"
            DisplayName       = "User"
        }

        # Create a new user 2
        AADUser User2 {
            UserPrincipalName = "User2@tenant.onmicrosoft.com"
            DisplayName       = "User"
        }
    }
}

```

Whereas this configuration is not unique and will not compile:

```powershell

Configuration MyConfig {

    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost {

        # Create a new user 1
        AADUser User1 {
            UserPrincipalName = "User1@tenant.onmicrosoft.com"
            DisplayName       = "User1"
        }

        # Create a new user 2 - with the same UPN as user 1
        AADUser User2 {
            UserPrincipalName = "User1@tenant.onmicrosoft.com"
            DisplayName       = "User2"
        }
    }
}

```

There are two resources with the same key combination.

User1 and User2 do have the same UserPrincipalName and would configure different DisplayNames. This is not allowed and will not compile. The same is true for other resources. For example, if you would have two AADGroups with the same UserPrincipalName, the configuration would not compile.

There might also be other resources with multiple key parameters. In this case the combination of these key parameters needs to be unique.

Within Microsoft365DSC there are many resources that are not backed by a configurable object in Microsoft 365. These objects will get unique identifiers that are created during the first creation. These identifiers are not configurable and are not exposed to the user. This is a big challenge for DSC, as we need to have a unique identifier prior to the creation of the objects in the tenant.

## The hen and egg problem of having key parameters in Microsoft365DSC and objects in a tenant

Over the last year we have seen various issues that were caused by duplicate keys in a Microsoft365DSC configuration. The root cause for these issues was caused by newly created configurations from M365DSC exports.

To resolve this issue it is important to understand the difference between key parameters and immutable identifiers in Microsoft 365. The key parameters are the parameters that are used to identify a resource. The immutable identifiers are the unique identifiers that are created during the creation of the resource. These identifiers are not configurable and are not exposed to the user. The key parameters are used to identify the resource and the immutable identifiers are used to identify the resource within the platform.

Changing the key parameters of those resource with duplicate keys is not an option as we would create a different configuration. In most cases the root cause is the fact, that we can have objects in Azure and Microsoft 365 with the same display name, but different immutable identifiers.

We can differentiate between two types of resources:

1. Those which have a unique immutable identifier and can be identified by the key parameters. Like the AADUser resource, which has a unique immutable identifier and can be identified by the UserPrincipalName.
2. Those which have a unique immutable identifier, but can not be identified by the key parameters. Like the AADApplication resource, which has a unique immutable identifier, but can not be uniquely identified by the DisplayName. With this knowledge we can conclude that it's recommended to not use duplicate display names for any resource within M365 that should be managed through M365DSC.

For 1. we can change the key parameters and the configuration will compile. We can rely on the immutable identifier to identify the resource. For 2. we can not rely on the immutable identifier to identify the resource. This is a big challenge for DSC, as we need to have a unique identifier prior to the creation of the objects in the tenant.

## The current implementation of key parameters in Microsoft365DSC

With the [April 2023 release](../../blog/april-2023-major-release/index.html) of Microsoft365DSC we have many breaking changes that help to better identify the resources in the configuration. There were several changes to key parameters. This implementation  a new way of handling key parameters. This new implementation is based on the following principles:

1. The key parameters are the parameters that are used to identify a resource.
   There is [more information](https://docs.microsoft.com/en-us/powershell/dsc/authoringresourcekey) available on how to define key parameters in DSC resources:
   >The type qualifier, [Key], on a property indicates that this property will uniquely identify the resource instance. At least one [Key] property is required.
2. The immutable identifiers are the unique identifiers that are created during the creation of the resource. For some resources, these are now exposed through M365DSC. This offers two use cases:
   - During the initial creation of the resource the display name would be used to identify the resource. This is the same as the current implementation.
   - For updates of the resource, the immutable identifier would be used to identify the resource. This is a new implementation.

The new implementation is kind of a heuristic approach to enable exports and imports of configurations. Besides that it is a good practice to better identify the resources in the configuration.
