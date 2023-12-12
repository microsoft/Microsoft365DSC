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
        AADAdministrativeUnit 'TestUnit'
        {
            Id                            = '49a843c7-e80c-4bae-8819-825656a108f2'
            DisplayName                   = 'Test-Unit'
            MembershipRule                = "(user.country -eq `"Canada`")"
            MembershipRuleProcessingState = 'On'
            MembershipType                = 'Dynamic'
            Ensure                        = 'Present'
            Credential                    = $Credscredential
        }
    }
}
