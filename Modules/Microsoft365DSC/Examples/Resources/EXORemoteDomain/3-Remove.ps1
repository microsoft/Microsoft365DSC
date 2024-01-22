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
        EXORemoteDomain 583b0b70-b45d-401f-98a6-0e7fa8434946
        {
            Identity                             = "Integration"
            Ensure                               = "Absent"
            Credential                           = $Credscredential
        }
    }
}
