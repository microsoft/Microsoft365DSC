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
        IntuneApplicationControlPolicyWindows10 'ConfigureApplicationControlPolicyWindows10'
        {
            DisplayName                      = 'Windows 10 Desktops'
            Description                      = 'All windows 10 Desktops'
            Ensure                           = 'Absent'
            Credential                       = $Credscredential
        }
    }
}
