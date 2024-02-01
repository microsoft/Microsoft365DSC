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
        EXODataClassification 'ConfigureDataClassification'
        {
            Description          = "Detects formatted and unformatted Canadian social insurance number.";
            Ensure               = "Present";
            Identity             = "a2f29c85-ecb8-4514-a610-364790c0773e";
            IsDefault            = $True;
            Locale               = "en-US";
            Name                 = "Canada Social Insurance Number";
            Credential           = $Credscredential
        }
    }
}
