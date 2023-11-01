<#
This example adds a new Teams Calling Policy.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsTeamsAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsTemplatesPolicy "TeamsTemplatesPolicy-Example"
        {
            Credential           = $credsTeamsAdmin;
            Description          = "Example Policy";
            Ensure               = "Present";
            HiddenTemplates      = @("Manage a Project","Manage an Event","Adopt Office 365","Organize Help Desk");
            Identity             = "Example Policy";
        }
    }
}
