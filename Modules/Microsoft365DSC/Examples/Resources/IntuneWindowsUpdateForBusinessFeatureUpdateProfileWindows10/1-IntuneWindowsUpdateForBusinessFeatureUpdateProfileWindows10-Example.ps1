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
            Id                   = 'b5d1020d-f641-42a0-a882-82f3358bf4c5'
            DisplayName          = 'WUfB Feature -dsc'
            Assignments          = @()
            Description          = 'test 2'
            FeatureUpdateVersion = 'Windows 10, version 22H2'
            RolloutSettings = MSFT_MicrosoftGraphwindowsUpdateRolloutSettings {
                OfferStartDateTimeInUTC = '2023-02-03T16:00:00.0000000+00:00'
            }
            Ensure               = 'Present'
            Credential           = $Credscredential
        }
    }
}
