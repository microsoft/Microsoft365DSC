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
        AADGroupEligibilitySchedule 'Example'
        {
            AccessId              = "member";
            Ensure                = "Present";
            GroupDisplayName      = "MyPIMGroup";
            MemberType            = "direct";
            PrincipalDisplayname  = "MyPrincipalGroup";
            PrincipalType         = "group";
            ScheduleInfo          = MSFT_MicrosoftGraphrequestSchedule{
                Expiration = MSFT_MicrosoftGraphExpirationPattern{
                    Type = 'noExpiration'
                }
            };
        }
    }
}
