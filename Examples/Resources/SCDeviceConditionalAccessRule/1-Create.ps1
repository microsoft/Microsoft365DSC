<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC
    node localhost
    {
        SCDeviceConditionalAccessRule "MyDeviceConditionalAccessRule"
        {
            AllowAppStore             = $True;
            AllowAssistantWhileLocked = $True;
            AllowConvenienceLogon     = $True;
            AllowDiagnosticSubmission = $True;
            AllowiCloudBackup         = $True;
            AllowiCloudDocSync        = $True;
            AllowiCloudPhotoSync      = $True;
            AllowJailbroken           = $True;
            AllowPassbookWhileLocked  = $True;
            AllowScreenshot           = $True;
            AllowSimplePassword       = $True;
            AllowVideoConferencing    = $True;
            AllowVoiceAssistant       = $True;
            AllowVoiceDialing         = $True;
            ApplicationId             = $ApplicationId;
            BluetoothEnabled          = $True;
            CameraEnabled             = $True;
            CertificateThumbprint     = $CertificateThumbprint;
            EnableRemovableStorage    = $True;
            Ensure                    = "Present";
            ForceAppStorePassword     = $False;
            ForceEncryptedBackup      = $False;
            Name                      = "MyPolicy{394b}";
            PasswordRequired          = $False;
            PhoneMemoryEncrypted      = $False;
            Policy                    = "MyPolicy";
            RequireEmailProfile       = $False;
            SmartScreenEnabled        = $False;
            SystemSecurityTLS         = $False;
            TargetGroups              = @("Communications");
            TenantId                  = $TenantId;
            WLANEnabled               = $True;
        }
    }
}
