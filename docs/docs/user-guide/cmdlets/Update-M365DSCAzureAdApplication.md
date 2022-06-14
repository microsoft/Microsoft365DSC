# Update-M365DSCAzureAdApplication

## Description

This function creates or updates an application in Azure AD. It assigns permissions,
grants consent and creates a secret or uploads a certificate to the application.

This application can then be used for Application Authentication.

NOTE:
If consent cannot be given for whatever reason, make sure all these permissions are
given Admin Consent by browsing to the App Registration in Azure AD > API Permissions
and clicking the "Grant admin consent for <orgname>" button.

## Output

This function does not generate any output.

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| ApplicationName | False | String | Microsoft365DSC |  |  |
| Permissions | True True | String[] |  |  |  |
| Type | False | String | Secret | Secret, Certificate |  |
| MonthsValid | False | Int32 | 12 |  |  |
| CreateNewSecret | False | SwitchParameter |  |  |  |
| CertificatePath | False | String |  |  |  |
| CreateSelfSignedCertificate | False | SwitchParameter |  |  |  |
| AdminConsent | False | SwitchParameter |  |  |  |
| Message | True | String |  |  |  |
| Type | False | String | Info | Error, Warning, Info |  |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Update-M365DSCAzureAdApplication -ApplicationName 'Microsoft365DSC' -Permissions Sites.FullControl.All -AdminConsent -Type Secret`

-------------------------- EXAMPLE 2 --------------------------

`Update-M365DSCAzureAdApplication -ApplicationName 'Microsoft365DSC' -Permissions Sites.FullControl.All -AdminConsent -Type Certificate -CreateSelfSignedCertificate -CertificatePath c:\Temp\M365DSC.cer`

-------------------------- EXAMPLE 3 --------------------------

`Update-M365DSCAzureAdApplication -ApplicationName 'Microsoft365DSC' -Permissions Sites.FullControl.All -AdminConsent -Type Certificate -CertificatePath c:\Temp\M365DSC.cer`


