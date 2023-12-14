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
        IntuneSettingCatalogASRRulesPolicyWindows10 'myASRRulesPolicy'
        {
            DisplayName                                                                = 'asr 2'
            Assignments                                                                = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments {
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType                                   = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                })
            attacksurfacereductiononlyexclusions                                       = @('Test 10', 'Test2', 'Test3')
            blockabuseofexploitedvulnerablesigneddrivers                               = 'block'
            blockexecutablefilesrunningunlesstheymeetprevalenceagetrustedlistcriterion = 'audit'
            Description                                                                = 'Post'
            Ensure                                                                     = 'Present'
            Credential                                                                 = $Credscredential
        }
    }
}
