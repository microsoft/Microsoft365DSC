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
        IntuneWindowsUpdateForBusinessFeatureUpdateProfileWindows10 'Example'
        {
            DisplayName          = 'WUfB Feature -dsc'
            Assignments          = @()
            Description          = 'test 2'
            FeatureUpdateVersion = 'Windows 10, version 22H2'
            RolloutSettings = MSFT_MicrosoftGraphwindowsUpdateRolloutSettings {
                OfferStartDateTimeInUTC = '2023-02-05T16:00:00.0000000+00:00' # Updated Property
            }
            Ensure               = 'Present'
            Credential           = $Credscredential
        }
    }
}
