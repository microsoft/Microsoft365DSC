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
        AADGroup 'MyGroups1'
        {
            DisplayName        = "DSCGroup"
            Description        = "Microsoft DSC Group"
            SecurityEnabled    = $True
            GroupTypes         = @()
            MailNickname       = "M365DSCG"
            Ensure             = "Present"
            Credential         = $credsGlobalAdmin
        }
        AADGroup 'MyGroups2'
        {
            DisplayName        = "DSCMemberGroup"
            Description        = "Microsoft DSC Editor"
            SecurityEnabled    = $True
            GroupTypes         = @()
            MailNickname       = "M365DSCMG"
            Ensure             = "Present"
            MemberOf           = @("DSCGroup")
            Credential         = $credsGlobalAdmin
        }
    }
}
