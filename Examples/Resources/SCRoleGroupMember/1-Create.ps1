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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SCRoleGroupMember 'InformationProtectionAnalysts'
        {
            Description = 'Access and manage DLP alerts and activity explorer. View-only access to DLP policies, sensitivity labels and their policies, and all classifier types.'
            Ensure      = 'Present'
            Members     = @('user 1', 'User 2', 'Group1')
            Name        = 'InformationProtectionAnalysts'
            TenantId    = $OrganizationName
            Credential  = $Credscredential
        }
    }
}
