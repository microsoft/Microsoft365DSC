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
        AADGroup 'MyGroups'
        {
            DisplayName        = "DSCGroup"
            Description        = "Microsoft DSC Group"
            SecurityEnabled    = $True
            MailEnabled        = $False
            GroupTypes         = @()
            MailNickname       = "DSCGroup"
            Ensure             = "Present"
            IsAssignableToRole = $True
            AssignedToRole     = "Identity Governance Administrator"
            Credential         = $Credscredential
        }
    }
}
