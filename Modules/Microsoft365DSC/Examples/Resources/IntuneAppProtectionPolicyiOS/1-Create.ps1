<#
This example creates a new App ProtectionPolicy for iOS.
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
        IntuneAppProtectionPolicyiOS 'MyCustomiOSPolicy'
        {
            DisplayName                             = 'My DSC iOS App Protection Policy'
            AllowedDataStorageLocations             = @('sharePoint')
            AllowedInboundDataTransferSources       = 'managedApps'
            AllowedOutboundClipboardSharingLevel    = 'managedAppsWithPasteIn'
            AllowedOutboundDataTransferDestinations = 'managedApps'
            AppDataEncryptionType                   = 'whenDeviceLocked'
            Apps                                    = @('com.cisco.jabberimintune.ios', 'com.pervasent.boardpapers.ios', 'com.sharefile.mobile.intune.ios')
            ContactSyncBlocked                      = $False
            DataBackupBlocked                       = $False
            Description                             = ''
            DeviceComplianceRequired                = $True
            FingerprintBlocked                      = $False
            ManagedBrowserToOpenLinksRequired       = $True
            MaximumPinRetries                       = 5
            MinimumPinLength                        = 4
            OrganizationalCredentialsRequired       = $False
            PeriodOfflineBeforeAccessCheck          = 'PT12H'
            PeriodOfflineBeforeWipeIsEnforced       = 'P90D'
            PeriodOnlineBeforeAccessCheck           = 'PT30M'
            PinCharacterSet                         = 'alphanumericAndSymbol'
            PinRequired                             = $True
            PrintBlocked                            = $False
            SaveAsBlocked                           = $True
            SimplePinBlocked                        = $False
            Ensure                                  = 'Present'
            Credential                              = $Credscredential
        }
    }
}
