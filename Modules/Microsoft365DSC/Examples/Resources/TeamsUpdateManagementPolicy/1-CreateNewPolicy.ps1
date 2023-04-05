<#
This example demonstrates how to assign users to a Teams Upgrade Policy.
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
        TeamsUpdateManagementPolicy TestPolicy
        {
            AllowManagedUpdates  = $False;
            AllowPreview         = $False;
            AllowPublicPreview   = "Enabled";
            Credential           = $Credscredential;
            Description          = "Test";
            Ensure               = "Present";
            Identity             = "MyTestPolicy";
            UpdateDayOfWeek      = 1;
            UpdateTime           = "18:00";
            UpdateTimeOfDay      = "2022-05-06T18:00:00";
            UseNewTeamsClient    = 'MicrosoftChoice'
        }
    }
}
