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
            DisplayName                   = 'Test-Unit'
            Description                   = 'Test Description'
            MembershipRule                = "(user.country -eq `"Canada`")"
            MembershipRuleProcessingState = 'On'
            MembershipType                = 'Dynamic'
            Ensure                        = 'Present'
            Credential                    = $Credscredential
        }
    }
}
