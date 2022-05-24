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
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOSafeLinksPolicy 'ConfigureSafeLinksPolicy'
        {
            Identity                      = "Marketing Block URL"
            AdminDisplayName              = "Marketing Block URL"
            CustomNotificationText        = "Blocked URLs for Marketing"
            DeliverMessageAfterScan       = $True
            DoNotAllowClickThrough        = $True
            DoNotTrackUserClicks          = $True
            EnableOrganizationBranding    = $True
            EnableSafeLinksForTeams       = $True
            IsEnabled                     = $True
            ScanUrls                      = $True
            UseTranslatedNotificationText = $True
            Ensure                        = "Present"
            Credential                    = $credsGlobalAdmin
        }
    }
}
