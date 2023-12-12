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
        IntuneAccountProtectionPolicy 'myAccountProtectionPolicy'
        {
            Identity                                               = '355e88e2-dd1f-4956-bafe-9000d8267ad5'
            DisplayName                                            = 'test'
            deviceGuardLocalSystemAuthorityCredentialGuardSettings = "notConfigured"
            WindowsHelloForBusinessBlocked                         = $true
            PinMinimumLength                                       = 5
            PinSpecialCharactersUsage                              = 'required'
            Ensure                                                 = 'Present'
            Credential                                             = $Credscredential
        }
    }
}
