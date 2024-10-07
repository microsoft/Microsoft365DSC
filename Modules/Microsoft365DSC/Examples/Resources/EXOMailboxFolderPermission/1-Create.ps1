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
        EXOMailboxFolderPermission "EXOMailboxFolderPermission-admin:\Calendar"
        {
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            Ensure                = "Present";
            Identity              = "amdin:\Calendar";
            UserPermissions       = @(MSFT_EXOMailboxFolderUserPermission {
                User                   = 'Default'
                AccessRights           = 'AvailabilityOnly'
            }
            MSFT_EXOMailboxFolderUserPermission {
                User                   = 'Anonymous'
                AccessRights           = 'AvailabilityOnly'
            }
            MSFT_EXOMailboxFolderUserPermission {
                User                          = 'AlexW'
                AccessRights                  = 'Owner'
                SharingPermissionFlags        = 'Delegate'
            }
            );
        }
    }
}