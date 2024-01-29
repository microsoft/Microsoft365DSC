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
            Credential             = $Credscredential
            DisplayDeviceName      = "DisplayDeviceName";
            Ensure                 = 'Absent'
            Identity               = "Hood@$Domain";
        }
    }
}
