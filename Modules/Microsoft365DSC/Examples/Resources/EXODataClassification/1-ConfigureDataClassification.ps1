<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXODataClassification 'ConfigureDataClassification'
        {
            Identity    = 'Contoso Confidential'
            Name        = 'Contoso Confidentiel'
            Description = 'Ce message contient des informations confidentielles.'
            Locale      = 'fr'
            IsDefault   = $true
            Ensure      = "Present"
            Credential  = $credsGlobalAdmin
        }
    }
}
