<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOActiveSyncDeviceAccessRule 'ConfigureActiveSyncDeviceAccessRule'
        {
            Identity             = "ContosoPhone(DeviceOS)"
            Characteristic       = "DeviceOS"
            QueryString          = "iOS 6.1 10B145"
            AccessLevel          = "Allow"
            Ensure               = "Present"
            Credential           = $credsGlobalAdmin
        }
    }
}
