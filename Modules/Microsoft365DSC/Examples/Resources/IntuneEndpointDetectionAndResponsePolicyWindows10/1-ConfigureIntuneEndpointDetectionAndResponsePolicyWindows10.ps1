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
        IntuneEndpointDetectionAndResponsePolicyWindows10 'myEDRPolicy'
        {
            Identity    = 'f6d1d1bc-d78f-4a5a-8f1b-0d95a60b0bc1'
            DisplayName = 'Edr Policy'
            Assignments = @()
            Description = 'My revised description'
            Ensure      = 'Present'
            Credential  = $Credscredential
        }
    }
}
