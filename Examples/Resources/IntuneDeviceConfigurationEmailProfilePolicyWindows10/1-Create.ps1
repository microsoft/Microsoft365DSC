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
        IntuneDeviceConfigurationEmailProfilePolicyWindows10 'Example'
        {
            AccountName           = "Corp email2";
            Assignments           = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            DisplayName           = "email";
            DurationOfEmailToSync = "unlimited";
            EmailAddressSource    = "primarySmtpAddress";
            EmailSyncSchedule     = "fifteenMinutes";
            Ensure                = "Present";
            HostName              = "outlook.office365.com";
            RequireSsl            = $True;
            SyncCalendar          = $True;
            SyncContacts          = $True;
            SyncTasks             = $True;
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
