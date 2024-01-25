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
            RejectMessageReasonText                       = "Updated" # Updated Property
            Enabled                                       = $True
            Ensure                                        = "Present"
            Credential                                    = $Credscredential
        }
    }
}
