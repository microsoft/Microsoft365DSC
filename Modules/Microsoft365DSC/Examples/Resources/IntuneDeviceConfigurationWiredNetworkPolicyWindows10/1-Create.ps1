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
        IntuneDeviceConfigurationWiredNetworkPolicyWindows10 'Example'
        {
            Assignments                                           = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments
                {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            )
            AuthenticationBlockPeriodInMinutes                    = 5
            AuthenticationMethod                                  = 'usernameAndPassword'
            AuthenticationPeriodInSeconds                         = 60
            AuthenticationRetryDelayPeriodInSeconds               = 5
            AuthenticationType                                    = 'machine'
            CacheCredentials                                      = $True
            Credential                                            = $Credscredential
            DisplayName                                           = 'Wired Network'
            EapolStartPeriodInSeconds                             = 5
            EapType                                               = 'teap'
            Enforce8021X                                          = $True
            Ensure                                                = 'Present'
            MaximumAuthenticationFailures                         = 5
            MaximumEAPOLStartMessages                             = 5
            SecondaryAuthenticationMethod                         = 'certificate'
            TrustedServerCertificateNames                         = @('srv.domain.com')
            RootCertificatesForServerValidationIds                = @('a485d322-13cd-43ef-beda-733f656f48ea', '169bf4fc-5914-40f4-ad33-48c225396183')
            SecondaryIdentityCertificateForClientAuthenticationId = '0b9aef2f-1671-4260-8eb9-3ab3138e176a'
        }
    }
}
