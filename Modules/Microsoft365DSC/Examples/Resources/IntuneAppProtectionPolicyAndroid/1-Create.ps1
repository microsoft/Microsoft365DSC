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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneAppProtectionPolicyAndroid 'ConfigureAppProtectionPolicyAndroid'
        {
            DisplayName                             = 'My DSC Android App Protection Policy'
            AllowedDataStorageLocations             = @('sharePoint')
            AllowedInboundDataTransferSources       = 'managedApps'
            AllowedOutboundClipboardSharingLevel    = 'managedAppsWithPasteIn'
            AllowedOutboundDataTransferDestinations = 'managedApps'
            Apps                                    = @('com.cisco.jabberimintune.ios', 'com.pervasent.boardpapers.ios', 'com.sharefile.mobile.intune.ios')
            ContactSyncBlocked                      = $false
            DataBackupBlocked                       = $false
            Description                             = ''
            DeviceComplianceRequired                = $True
            DisableAppPinIfDevicePinIsSet           = $True
            FingerprintBlocked                      = $False
            ManagedBrowserToOpenLinksRequired       = $True
            MaximumPinRetries                       = 5
            MinimumPinLength                        = 4
            OrganizationalCredentialsRequired       = $false
            PinRequired                             = $True
            PrintBlocked                            = $True
            SaveAsBlocked                           = $True
            SimplePinBlocked                        = $True
            Ensure                                  = 'Present'
            Credential                              = $Credscredential
        }
    }
}

