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
        SPOAccessControlSettings 'ConfigureAccessControlSettings'
        {
            IsSingleInstance             = "Yes"
            DisplayStartASiteOption      = $false
            StartASiteFormUrl            = "https://contoso.sharepoint.com"
            IPAddressEnforcement         = $false
            IPAddressWACTokenLifetime    = 15
            CommentsOnSitePagesDisabled  = $false
            SocialBarOnSitePagesDisabled = $false
            DisallowInfectedFileDownload = $false
            ExternalServicesEnabled      = $true
            EmailAttestationRequired     = $false
            EmailAttestationReAuthDays   = 30
            Ensure                       = "Present"
            Credential                   = $Credscredential
        }
    }
}
