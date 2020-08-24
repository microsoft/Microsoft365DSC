<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADMSGroup MyGroups
        {
            DisplayName                   = "DSCGroup"
            Description                   = "Microsoft DSC Group"
            SecurityEnabled               = $True
            MailEnabled                   = $True
            GroupTypes                    = @("Unified")
            MailNickname                  = "M365DSC"
            Visibility                    = "Private"
            GlobalAdminAccount            = $credsGlobalAdmin
            Ensure                        = "Present"
        }
    }
}
