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
        EXORoleAssignmentPolicy 'ConfigureRoleAssignmentPolicy'
        {
            Name                 = "Integration Policy"
            Description          = "This policy grants end users the permission to set their options in Outlook on the web and perform other self-administration tasks."
            IsDefault            = $True
            Roles                = @("My Marketplace Apps","MyVoiceMail","MyDistributionGroups","MyRetentionPolicies","MyContactInformation","MyBaseOptions","MyTextMessaging","MyDistributionGroupMembership","MyProfileInformation","My Custom Apps","My ReadWriteMailbox Apps")
            Ensure               = "Present"
            Credential           = $Credscredential
        }
    }
}
