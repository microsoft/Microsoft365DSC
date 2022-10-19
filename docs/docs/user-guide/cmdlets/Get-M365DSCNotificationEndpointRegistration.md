# Get-M365DSCNotificationEndPointRegistration

## Description

This function returns and instance of or all notification endpoints in registry.

## Output

Array of notification endpoints.

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| Url | False | String |  |  | Represents the Url of the endpoint to be contacted when events are detected. |
| EventType | False | String |  |  Drift, Error, Warning | Represents the type of events that need to be reported to the endpoint. |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Get-M365DSCNotificationEndPointRegistration -Url https://contoso.com/api/ -EventType Drift`

-------------------------- EXAMPLE 2 --------------------------

`Get-M365DSCNotificationEndPointRegistration -Url https://contoso.com/api/

-------------------------- EXAMPLE 3 --------------------------

`Get-M365DSCNotificationEndPointRegistration -EventType Drift`

-------------------------- EXAMPLE 4 --------------------------

`Get-M365DSCNotificationEndPointRegistration


