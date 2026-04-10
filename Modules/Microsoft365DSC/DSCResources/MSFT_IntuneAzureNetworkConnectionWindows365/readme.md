# IntuneAzureNetworkConnectionWindows365

## Description

Intune Azure Network Connection for Windows365

**NOTE:** To resolve the subscription and resource group name, the identity requires the `Microsoft.Resources/subscriptions/read` Azure permission.
You can either assign it with a built-in role with more permissions, or use a custom Azure RBAC role with this specific permission.
The role scope can be configured at management group or at an individual subscription level, but it must be the subscription where the Azure Network Connection was deployed to.

Make sure that the value of `SubscriptionName` is the same as the one in the subnet and resource group specification.
