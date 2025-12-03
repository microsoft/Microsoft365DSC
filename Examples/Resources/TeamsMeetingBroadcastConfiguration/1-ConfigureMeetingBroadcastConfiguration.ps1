<#
This example adds a new Teams Meeting Policy.
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
        TeamsMeetingBroadcastConfiguration 'MeetingBroadcastConfiguration'
        {
            Identity                            = 'Global'
            AllowSdnProviderForBroadcastMeeting = $True
            SupportURL                          = "https://support.office.com/home/contact"
            SdnProviderName                     = "hive"
            SdnLicenseId                        = "5c12d0-d52950-e03e66-92b587"
            SdnApiTemplateUrl                   = "https://api.hivestreaming.com/v1/eventadmin?partner_token={0}"
            Credential                          = $Credscredential
        }
    }
}
