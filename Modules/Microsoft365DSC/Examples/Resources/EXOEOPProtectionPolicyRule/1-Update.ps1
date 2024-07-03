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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOEOPProtectionPolicyRule "EXOEOPProtectionPolicyRule-Strict Preset Security Policy"
        {
            ApplicationId             = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint     = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Ensure                    = "Present";
            ExceptIfRecipientDomainIs = @("sandrodev.onmicrosoft.com");
            Identity                  = "Strict Preset Security Policy";
            Name                      = "Strict Preset Security Policy";
            Priority                  = 0;
            State                     = "Enabled";
            TenantId                  = $OrganizationName;
        }
    }
}
