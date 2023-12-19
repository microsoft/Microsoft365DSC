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
        EXOTransportRule 'ConfigureTransportRule'
        {
            Name                                          = "Ethical Wall - Sales and Brokerage Departments"
            BetweenMemberOf1                              = "Sales Department"
            BetweenMemberOf2                              = "Brokerage Department"
            ExceptIfFrom                                  = "Tony Smith","Pilar Ackerman"
            ExceptIfSubjectContainsWords                  = "Press Release","Corporate Communication"
            RejectMessageReasonText                       = "Messages sent between the Sales and Brokerage departments are strictly prohibited."
            Enabled                                       = $True
            Ensure                                        = "Present"
            Credential                                    = $Credscredential
        }
    }
}
