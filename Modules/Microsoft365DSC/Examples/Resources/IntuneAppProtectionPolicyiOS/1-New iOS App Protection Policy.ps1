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
            Identity                                = '1352a41f-bd32-4ee3-b227-2f11b17b8614'
            DisplayName                             = 'My DSC iOS App Protection Policy'
            AllowedDataStorageLocations             = @('sharePoint')
            AllowedInboundDataTransferSources       = 'managedApps'
            AllowedOutboundClipboardSharingLevel    = 'managedAppsWithPasteIn'
            AllowedOutboundDataTransferDestinations = 'managedApps'
            AppDataEncryptionType                   = 'whenDeviceLocked'
            Apps                                    = @('com.cisco.jabberimintune.ios', 'com.pervasent.boardpapers.ios', 'com.sharefile.mobile.intune.ios')
            Assignments                             = @('6ee86c9f-2b3c-471d-ad38-ff4673ed723e')
            ContactSyncBlocked                      = $False
            DataBackupBlocked                       = $False
            Description                             = ''
            DeviceComplianceRequired                = $True
            ExcludedGroups                          = @('3eacc231-d77b-4efb-bb5f-310f68bd6198')
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
