<#
This example creates a new Intune Role Assigment.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        IntuneRoleAssignment "d0dc6002-2131-480b-a70d-a795ebf474f2"
        {
            Description           = "Descrition of the role assignment";
            DisplayName           = "Display name of the role assignment";
            Ensure                = "Present";
            Id                    = "d0dc6002-2131-480b-a70d-a795ebf474f2";
			Roledefinition	      = "c1d9fcbb-cba5-40b0-bf6b-527006585f4b";
            Members               = @("4ecd31fa-5da1-4003-a3c8-da7d86edc674");
            ResourceScopes        = @("7d1bffac-0174-4475-8aac-45dec9fb184f");
        }
    }
}
