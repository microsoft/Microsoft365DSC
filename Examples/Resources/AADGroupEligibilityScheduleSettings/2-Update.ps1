<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADGroupEligibilityScheduleSettings 'Example'
        {
            ApplicationId         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint = $ConfigurationData.NonNodeData.CertificateThumbprint;
            expirationRule        = MSFT_AADRoleManagementPolicyExpirationRule{
                isExpirationRequired = $False
                maximumDuration = "PT8H"
            };
            groupDisplayName      = "MyPIMGroup";
            id                    = "Expiration_EndUser_Assignment";
            PIMGroupRole          = "member";
            ruleType              = "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule";
            TenantId              = $OrganizationName;
        }
    }
}
