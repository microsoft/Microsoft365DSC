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
        $credsCredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADAuthenticationContextClassReference "AADAuthenticationContextClassReference-Test"
        {
            Credential           = $credsCredential;
            Description          = "Context test Updated"; # Updated Property
            DisplayName          = "My Context";
            Ensure               = "Absent";
            Id                   = "c3";
            IsAvailable          = $True;
        }
    }
}
