<#
This example adds a new Teams Emergency Call Routing Policy.
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
        TeamsEmergencyCallRoutingPolicy 'EmergencyCallRoutingPolicyExample'
        {
            Identity                       = "Unit Test"
            AllowEnhancedEmergencyServices = $False
            Description                    = "Description"
            EmergencyNumbers               = @(
                MSFT_TeamsEmergencyNumber
                {
                    EmergencyDialString = '123456'
                    EmergencyDialMask   = '123'
                    OnlinePSTNUsage     = ''
                }
            )
            Ensure                         = "Present"
            Credential                     = $Credscredential
        }
    }
}
