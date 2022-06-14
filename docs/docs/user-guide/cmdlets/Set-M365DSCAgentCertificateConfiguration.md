# Set-M365DSCAgentCertificateConfiguration

## Description

This function configures the LCM with a self signed encryption certificate

## Output

This function outputs information as the following type:
**System.String**

## Parameters

| Parameter | Required | DataType | Default Value | Allowed Values | Description |
| --- | --- | --- | --- | --- | --- |
| KeepCertificate | False | SwitchParameter |  |  | Specifies that the temporarily created CER file should not be deleted. |
| ForceRenew | False | SwitchParameter |  |  | Specifies that a new certificate should be forcefully created. |
| GeneratePFX | False | SwitchParameter |  |  | Specifies that a PFX export should be created for the generated certificate. |
| Password | False | String | Temp!P@ss123 |  | Specifies the password for the PFX file. |

## Examples

-------------------------- EXAMPLE 1 --------------------------

`Set-M365DSCAgentCertificateConfiguration -KeepCertificate`

-------------------------- EXAMPLE 2 --------------------------

`Set-M365DSCAgentCertificateConfiguration -GeneratePFX -Password 'P@ssword123!'`


