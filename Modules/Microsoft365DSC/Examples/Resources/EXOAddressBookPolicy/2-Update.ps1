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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOAddressBookPolicy 'ConfigureAddressBookPolicy'
        {
            Name                 = "All Fabrikam ABP"
            AddressLists         = "\All Fabrikam","\All Fabrikam Mailboxes","\All Fabrikam Contacts" # Updated Property
            RoomList             = "\All Fabrikam-Rooms"
            OfflineAddressBook   = "\Fabrikam-All-OAB"
            GlobalAddressList    = "\All Fabrikam"
            Ensure               = "Present"
            Credential           = $Credscredential
        }
    }
}
