<#
This example creates a new App ProtectionPolicy for iOS.
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
        IntuneAppProtectionPolicyiOS 'MyCustomiOSPolicy'
        {
            DisplayName                             = 'My DSC iOS App Protection Policy'
            Ensure                                  = 'Absent'
            Credential                              = $Credscredential
        }
    }
}
