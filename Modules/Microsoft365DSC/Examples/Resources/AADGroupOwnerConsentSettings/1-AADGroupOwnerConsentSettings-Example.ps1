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
        AADGroupOwnerConsentSettings 'Example'
        {
            IsSingleInstance                                  = "Yes"
            EnableGroupSpecificConsent                        = $false
            BlockUserConsentForRiskyApps                      = $true
            EnableAdminConsentRequests                        = $false
            ConstrainGroupSpecificConsentToMembersOfGroupName = ''      # value is only relevant if EnableGroupSpecificConsent is true. See example 2
            Ensure                                            = 'Present'
            Credential                                        = $Credscredential
        }
    }
}
