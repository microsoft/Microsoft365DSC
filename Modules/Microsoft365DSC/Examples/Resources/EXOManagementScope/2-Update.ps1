<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC
    node localhost
    {
        EXOManagementScope "EXOManagementScope-Test New DGs"
        {
            Credential                 = $Credscredential;
            Ensure                     = "Present";
            Exclusive                  = $False;
            Identity                   = "Test New DGs";
            Name                       = "Test New DGs";
            RecipientRestrictionFilter = "Name -like 'NewTest*'";
        }
    }
}
