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
        TeamsAIPolicy "TeamsAIPolicy-AIEnabled"
        {
            ApplicationId             = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint     = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Description               = "Teams AI Policy with some AI Features enabled."; # Updated Property
            EnrollFace                = "Disabled"; # Updated Property
            EnrollVoice               = "Enabled";
            Ensure                    = "Present";
            Identity                  = "AIEnabled";
            SpeakerAttributionForBYOD = "Enabled";
            TenantId                  = $OrganizationName;
        }
    }
}
