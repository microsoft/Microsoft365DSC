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
        IntuneDeviceConfigurationPolicyAndroidOpenSourceProject 'myAndroidOpenSourceProjectPolicy'
        {
            Id                        = '9191730e-6e01-4b77-b23c-9648b5c7bb1e'
            DisplayName               = 'aosp'
            Assignments               = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            )
            CameraBlocked             = $False
            FactoryResetBlocked       = $True
            PasswordRequiredType      = 'deviceDefault'
            ScreenCaptureBlocked      = $True
            StorageBlockExternalMedia = $True
            Ensure                    = 'Present'
            Credential                = $Credscredential
        }
    }
}
