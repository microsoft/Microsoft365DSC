<#
This example updates an existing Device Management Compliance Management Partner.
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
        IntuneDeviceManagementComplianceManagementPartner '6b43c039-c1d0-4a9f-aab9-48c5531acbd6'
        {
            IosEnrollmentAssignments = @(
                MSFT_IntuneDeviceAndAppManagementAssignmentTarget{
                    GroupDisplayName = 'All devices'
                    dataType = "#microsoft.graph.allDevicesAssignmentTarget"
                }
            )
            IosOnboarded          = $True
            DisplayName           = "3rdPartyPartnerIosManagement"
            PartnerState          = "enabled"
            Ensure                = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
