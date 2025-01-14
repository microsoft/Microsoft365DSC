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
                StartDateTime = '2024-12-23T08:59:28.1200000+00:00'
                Expiration = MSFT_MicrosoftGraphExpirationPattern{
                    EndDateTime = '12/23/2025 8:59:00 AM +00:00'
                    Type = 'afterDateTime'
                }
            };
        }
    }
}
