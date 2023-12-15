<#
This example sets Power Platform tenant settings.
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
    PPTenantSettings 'PowerPlatformTenantSettings'
    {
      IsSingleInstance                               = 'Yes'
      WalkMeOptOut                                   = $false
      DisableNPSCommentsReachout                     = $false
      DisableNewsletterSendout                       = $false
      DisableEnvironmentCreationByNonAdminUsers      = $true
      DisablePortalsCreationByNonAdminUsers          = $false
      DisableSurveyFeedback                          = $false
      DisableTrialEnvironmentCreationByNonAdminUsers = $false
      DisableCapacityAllocationByEnvironmentAdmins   = $true
      DisableSupportTicketsVisibleByAllUsers         = $false
      DisableDocsSearch                              = $false
      DisableCommunitySearch                         = $false
      DisableBingVideoSearch                         = $false
      DisableShareWithEveryone                       = $false
      EnableGuestsToMake                             = $false
      ShareWithColleaguesUserLimit                   = 10000
      Credential                                     = $Credscredential
    }
  }
}
