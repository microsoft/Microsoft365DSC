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
        TeamsM365App "TeamsM365App-Update"
        {
            AssignmentType       = "UsersAndGroups";
            Credential           = $Credscredential;
            Groups               = @("Finance Team");
            Id                   = "95de633a-083e-42f5-b444-a4295d8e9314";
            IsBlocked            = $False;
            Users                = @();
        }
    }
}
