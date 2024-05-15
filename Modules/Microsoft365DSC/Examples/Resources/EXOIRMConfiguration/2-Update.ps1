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
        EXOIRMConfiguration 'ConfigureIRMConfiguration'
        {
            IsSingleInstance                           = 'Yes'
            AutomaticServiceUpdateEnabled              = $True
            AzureRMSLicensingEnabled                   = $True
            DecryptAttachmentForEncryptOnly            = $True
            EDiscoverySuperUserEnabled                 = $True
            EnablePdfEncryption                        = $True
            InternalLicensingEnabled                   = $True
            JournalReportDecryptionEnabled             = $True
            RejectIfRecipientHasNoRights               = $True
            SearchEnabled                              = $True
            SimplifiedClientAccessDoNotForwardDisabled = $True
            SimplifiedClientAccessEnabled              = $True
            SimplifiedClientAccessEncryptOnlyDisabled  = $True
            TransportDecryptionSetting                 = 'Mandatory'
            Ensure                                     = 'Present'
            Credential                                 = $Credscredential
        }
    }
}
