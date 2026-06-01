<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC
    node localhost
    {
        AzureRoleDefinition "AzureRoleDefinition-CustomRoleName"
        {
            Actions               = @("Microsoft.Compute/virtualMachines/read","Microsoft.Compute/virtualMachines/start/action","Microsoft.Compute/virtualMachines/restart/action");
            ApplicationId         = $ApplicationId;
            AssignableScopes      = @("/subscriptions/00000000-0000-0000-0000-000000000000");
            CertificateThumbprint = $CertificateThumbprint;
            CustomRoleName        = "My Custom Role";
            Description           = "A custom role for managing virtual machines.";
            Ensure                = "Present";
            TenantId              = $TenantId;
        }
    }
}
