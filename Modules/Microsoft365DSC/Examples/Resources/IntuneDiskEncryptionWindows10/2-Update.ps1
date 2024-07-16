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

    Node localhost
    {
        IntuneDiskEncryptionWindows10 'myDiskEncryption'
        {
            DisplayName        = 'Disk Encryption'
            Assignments        = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allDevicesAssignmentTarget'
                })
            Description        = ''
            IdentificationField_Name = '1'
            IdentificationField = 'IdentificationField'
            SecIdentificationField = 'UpdatedSecIdentificationField' # Updated property
            Ensure             = 'Present'
            Credential         = $Credscredential
        }
    }
}
