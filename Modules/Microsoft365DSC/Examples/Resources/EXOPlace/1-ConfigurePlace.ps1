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
        $credential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOPlace 'TestPlace'
        {
            AudioDeviceName        = "MyAudioDevice";
            Capacity               = 15; #Drift
            City                   = "";
            Credential             = $credential
            DisplayDeviceName      = "DisplayDeviceName";
            Ensure                 = 'Present'
            Identity               = "MyRoom@$contoso.com";
            IsWheelChairAccessible = $True;
            MTREnabled             = $False;
            ParentType             = "None";
            Phone                  = "555-555-5555";
            Tags                   = @("Tag1", "Tag2");
            VideoDeviceName        = "VideoDevice";
        }
    }
}
