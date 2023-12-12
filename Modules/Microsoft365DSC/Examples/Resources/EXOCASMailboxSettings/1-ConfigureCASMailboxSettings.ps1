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
        EXOCASMailboxSettings 'AdeleVCasMailboxSettings'
        {
            ActiveSyncAllowedDeviceIDs              = @()
            ActiveSyncBlockedDeviceIDs              = @()
            ActiveSyncDebugLogging                  = $False
            ActiveSyncEnabled                       = $True
            ActiveSyncMailboxPolicy                 = 'Demo EXO Mobile Device Policy Default'
            ActiveSyncSuppressReadReceipt           = $False
            EwsEnabled                              = $True
            Identity                                = 'AdeleV'
            ImapEnabled                             = $False
            ImapForceICalForCalendarRetrievalOption = $False
            ImapMessagesRetrievalMimeFormat         = 'BestBodyFormat'
            ImapSuppressReadReceipt                 = $False
            ImapUseProtocolDefaults                 = $True
            MacOutlookEnabled                       = $True
            MAPIEnabled                             = $True
            OutlookMobileEnabled                    = $True
            OWAEnabled                              = $True
            OWAforDevicesEnabled                    = $True
            OwaMailboxPolicy                        = 'OwaMailboxPolicy-Default'
            PopEnabled                              = $False
            PopForceICalForCalendarRetrievalOption  = $True
            PopMessagesRetrievalMimeFormat          = 'BestBodyFormat'
            PopSuppressReadReceipt                  = $False
            PopUseProtocolDefaults                  = $True
            PublicFolderClientAccess                = $False
            ShowGalAsDefaultView                    = $True
            UniversalOutlookEnabled                 = $True
            Ensure                                  = 'Present'
            Credential                              = $Credscredential
        }
    }
}
