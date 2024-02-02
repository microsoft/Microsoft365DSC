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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOMailboxCalendarFolder "JohnCalendarFolder"
        {
            Credential           = $credsCredential;
            DetailLevel          = "AvailabilityOnly";
            Ensure               = "Present";
            Identity             = "AlexW@$Domain" + ":\Calendar";
            PublishDateRangeFrom = "ThreeMonths";
            PublishDateRangeTo   = "ThreeMonths";
            PublishEnabled       = $True; # Updated Property
            SearchableUrlEnabled = $False;
        }
    }
}
