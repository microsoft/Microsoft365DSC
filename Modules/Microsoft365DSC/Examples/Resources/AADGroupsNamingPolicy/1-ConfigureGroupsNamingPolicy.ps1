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
        AADGroupsNamingPolicy GroupsNamingPolicy
        {
            CustomBlockedWordsList        = @("CEO", "President");
            Credential                    = $credsGlobalAdmin;
            IsSingleInstance              = "Yes";
            PrefixSuffixNamingRequirement = "[Title]Test[Company][GroupName][Office]Redmond";
            Ensure                        = "Present";
        }
    }
}
