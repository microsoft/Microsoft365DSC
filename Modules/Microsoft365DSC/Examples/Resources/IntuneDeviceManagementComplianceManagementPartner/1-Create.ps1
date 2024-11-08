<#
This example creates a new Device Management Compliance Management Partner.
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
            AndroidEnrollmentAssignments = @(
                MSFT_IntuneDeviceAndAppManagementAssignmentTarget{
                    GroupDisplayName = 'All devices'
                    dataType = "#microsoft.graph.allDevicesAssignmentTarget"
                }
            )
            AndroidOnboarded      = $True
            DisplayName           = "3rdPartyPartnerAndroidManagement"
            IosEnrollmentAssignments = @(
                MSFT_IntuneDeviceAndAppManagementAssignmentTarget{
                    GroupDisplayName = 'SomeGroup'
                    dataType = "#microsoft.graph.groupAssignmentTarget"
                }
            )
            IosOnboarded          = $True
            MacOsEnrollmentAssignments = @(
                MSFT_IntuneDeviceAndAppManagementAssignmentTarget{
                    DeviceAndAppManagementAssignmentFilterId = "FakeStringValue"
                    CollectionId = 'SomeCollectionId'
                    dataType = "#microsoft.graph.configurationManagerCollectionAssignmentTarget"
                    DeviceAndAppManagementAssignmentFilterType = "none"
                }
            )
            PartnerState          = "enabled"
            Ensure                = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
