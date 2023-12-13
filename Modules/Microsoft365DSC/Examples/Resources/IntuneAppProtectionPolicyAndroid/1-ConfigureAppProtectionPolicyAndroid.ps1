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
            Assignments                             = @('6ee86c9f-2b3c-471d-ad38-ff4673ed723e')
            ContactSyncBlocked                      = $false
            DataBackupBlocked                       = $false
            Description                             = ''
            DeviceComplianceRequired                = $True
            DisableAppPinIfDevicePinIsSet           = $True
            ExcludedGroups                          = @('3eacc231-d77b-4efb-bb5f-310f68bd6198')
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

