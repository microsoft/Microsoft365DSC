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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOPlace 'TestPlace'
        {
            AudioDeviceName        = "MyAudioDevice";
            Capacity               = 15;
            City                   = "";
            Credential             = $Credscredential
            DisplayDeviceName      = "DisplayDeviceName";
            Ensure                 = 'Present'
            Identity               = "Hood@$Domain";
            IsWheelChairAccessible = $True;
            MTREnabled             = $False;
            ParentType             = "None";
            Phone                  = "555-555-5555";
            Tags                   = @("Tag1", "Tag2");
            VideoDeviceName        = "VideoDevice";
        }
    }
}
