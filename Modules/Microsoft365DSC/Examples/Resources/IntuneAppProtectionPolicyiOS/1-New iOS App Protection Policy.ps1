<#
This example creates a new App ProtectionPolicy for iOS.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneAppProtectionPolicyiOS MyCustomiOSPolicy
        {
            AllowedDataStorageLocations             = @("sharePoint");
            AllowedInboundDataTransferSources       = "managedApps";
            AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn";
            AllowedOutboundDataTransferDestinations = "managedApps";
            AppDataEncryptionType                   = "whenDeviceLocked";
            Apps                                    = @("com.cisco.jabberimintune.ios","com.pervasent.boardpapers.ios","com.sharefile.mobile.intune.ios");
            Assignments                             = @("6ee86c9f-2b3c-471d-ad38-ff4673ed723e");
            ContactSyncBlocked                      = $False;
            DataBackupBlocked                       = $False;
            Description                             = "";
            DeviceComplianceRequired                = $True;
            DisplayName                             = "My DSC iOS App Protection Policy";
            ExcludedGroups                          = @("3eacc231-d77b-4efb-bb5f-310f68bd6198");
            FingerprintBlocked                      = $False;
            ManagedBrowserToOpenLinksRequired       = $True;
            MaximumPinRetries                       = 5;
            MinimumPinLength                        = 4;
            OrganizationalCredentialsRequired       = $False;
            PeriodOfflineBeforeAccessCheck          = "PT12H";
            PeriodOfflineBeforeWipeIsEnforced       = "P90D";
            PeriodOnlineBeforeAccessCheck           = "PT30M";
            PinCharacterSet                         = "alphanumericAndSymbol";
            PinRequired                             = $True;
            PrintBlocked                            = $False;
            SaveAsBlocked                           = $True;
            SimplePinBlocked                        = $False;
            Ensure                                  = 'Present'
            GlobalAdminAccount                      = $credsGlobalAdmin;
        }
    }
}
