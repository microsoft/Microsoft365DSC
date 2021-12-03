function Get-TargetResource
{
  [CmdletBinding()]
  [OutputType([System.Collections.Hashtable])]
  param (
    [Parameter(Mandatory = $true)]
    [ValidateSet('Yes')]
    [System.String]
    $IsSingleInstance,

    [Parameter()]
    [System.Boolean]
    $WalkMeOptOut,

    [Parameter()]
    [System.Boolean]
    $DisableNPSCommentsReachout,

    [Parameter()]
    [System.Boolean]
    $DisableNewsletterSendout,

    [Parameter()]
    [System.Boolean]
    $DisableEnvironmentCreationByNonAdminUsers,

    [Parameter()]
    [System.Boolean]
    $DisablePortalsCreationByNonAdminUsers,

    [Parameter()]
    [System.Boolean]
    $DisableSurveyFeedback,

    [Parameter()]
    [System.Boolean]
    $DisableTrialEnvironmentCreationByNonAdminUsers,

    [Parameter()]
    [System.Boolean]
    $DisableCapacityAllocationByEnvironmentAdmins,

    [Parameter()]
    [System.Boolean]
    $DisableSupportTicketsVisibleByAllUsers,

    [Parameter()]
    [System.Boolean]
    $DisableDocsSearch,

    [Parameter()]
    [System.Boolean]
    $DisableCommunitySearch,

    [Parameter()]
    [System.Boolean]
    $DisableBingVideoSearch,

    [Parameter()]
    [System.Boolean]
    $DisableShareWithEveryone,

    [Parameter()]
    [System.Boolean]
    $EnableGuestsToMake,

    [Parameter()]
    [ValidateRange(1, 10000)]
    [System.UInt32]
    $ShareWithColleaguesUserLimit,

    [Parameter()]
    [System.Management.Automation.PSCredential]
    $Credential
  )

  Write-Verbose -Message 'Checking the Power Platform Tenant Settings Configuration'
  $ConnectionMode = New-M365DSCConnection -Workload 'PowerPlatforms' `
    -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

  $nullReturn = $PSBoundParameters
  $nullReturn.Ensure = 'Absent'

  try
  {
    $PPTenantSettings = Get-TenantSettings -ErrorAction Stop
    return @{
      IsSingleInstance                               = 'Yes'
      WalkMeOptOut                                   = $PPTenantSettings.walkMeOptOut
      DisableNPSCommentsReachout                     = $PPTenantSettings.disableNPSCommentsReachout
      DisableNewsletterSendout                       = $PPTenantSettings.disableNewsletterSendout
      DisableEnvironmentCreationByNonAdminUsers      = $PPTenantSettings.disableEnvironmentCreationByNonAdminUsers
      DisablePortalsCreationByNonAdminUsers          = $PPTenantSettings.disablePortalsCreationByNonAdminUsers
      DisableSurveyFeedback                          = $PPTenantSettings.disableSurveyFeedback
      DisableTrialEnvironmentCreationByNonAdminUsers = $PPTenantSettings.disableTrialEnvironmentCreationByNonAdminUsers
      DisableCapacityAllocationByEnvironmentAdmins   = $PPTenantSettings.disableCapacityAllocationByEnvironmentAdmins
      DisableSupportTicketsVisibleByAllUsers         = $PPTenantSettings.disableSupportTicketsVisibleByAllUsers
      DisableDocsSearch                              = $PPTenantSettings.powerPlatform.search.disableDocsSearch
      DisableCommunitySearch                         = $PPTenantSettings.powerPlatform.search.disableCommunitySearch
      DisableBingVideoSearch                         = $PPTenantSettings.powerPlatform.search.disableBingVideoSearch
      DisableShareWithEveryone                       = $PPTenantSettings.powerPlatform.powerApps.disableShareWithEveryone
      EnableGuestsToMake                             = $PPTenantSettings.powerPlatform.powerApps.enableGuestsToMake
      ShareWithColleaguesUserLimit                   = $PPTenantSettings.powerPlatform.teamsIntegration.shareWithColleaguesUserLimit
      Credential                             = $Credential
    }
  }
  catch
  {
    try
    {
      Write-Verbose -Message $_
      $tenantIdValue = ''
      if (-not [System.String]::IsNullOrEmpty($TenantId))
      {
        $tenantIdValue = $TenantId
      }
      elseif ($null -ne $Credential)
      {
        $tenantIdValue = $Credential.UserName.Split('@')[1]
      }
      Add-M365DSCEvent -Message $_ -EntryType 'Error' `
        -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
        -TenantId $tenantIdValue
    }
    catch
    {
      Write-Verbose -Message $_
    }
    throw $_
  }
}

function Set-TargetResource
{
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [ValidateSet('Yes')]
    [System.String]
    $IsSingleInstance,

    [Parameter()]
    [System.Boolean]
    $WalkMeOptOut,

    [Parameter()]
    [System.Boolean]
    $DisableNPSCommentsReachout,

    [Parameter()]
    [System.Boolean]
    $DisableNewsletterSendout,

    [Parameter()]
    [System.Boolean]
    $DisableEnvironmentCreationByNonAdminUsers,

    [Parameter()]
    [System.Boolean]
    $DisablePortalsCreationByNonAdminUsers,

    [Parameter()]
    [System.Boolean]
    $DisableSurveyFeedback,

    [Parameter()]
    [System.Boolean]
    $DisableTrialEnvironmentCreationByNonAdminUsers,

    [Parameter()]
    [System.Boolean]
    $DisableCapacityAllocationByEnvironmentAdmins,

    [Parameter()]
    [System.Boolean]
    $DisableSupportTicketsVisibleByAllUsers,

    [Parameter()]
    [System.Boolean]
    $DisableDocsSearch,

    [Parameter()]
    [System.Boolean]
    $DisableCommunitySearch,

    [Parameter()]
    [System.Boolean]
    $DisableBingVideoSearch,

    [Parameter()]
    [System.Boolean]
    $DisableShareWithEveryone,

    [Parameter()]
    [System.Boolean]
    $EnableGuestsToMake,

    [Parameter()]
    [ValidateRange(1, 10000)]
    [System.UInt32]
    $ShareWithColleaguesUserLimit,

    [Parameter()]
    [System.Management.Automation.PSCredential]
    $Credential
  )

  Write-Verbose -Message 'Setting Power Platform Tenant Settings configuration'

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

  $ConnectionMode = New-M365DSCConnection -Workload 'PowerPlatforms' `
    -InboundParameters $PSBoundParameters

  $SetParameters = $PSBoundParameters
  $RequestBody = Get-M365DSCPowerPlatformTenantSettingsJSON -Parameters $SetParameters

  Set-TenantSettings -RequestBody $RequestBody | Out-Null
}

function Test-TargetResource
{
  [CmdletBinding()]
  [OutputType([System.Boolean])]
  param (
    [Parameter(Mandatory = $true)]
    [ValidateSet('Yes')]
    [System.String]
    $IsSingleInstance,

    [Parameter()]
    [System.Boolean]
    $WalkMeOptOut,

    [Parameter()]
    [System.Boolean]
    $DisableNPSCommentsReachout,

    [Parameter()]
    [System.Boolean]
    $DisableNewsletterSendout,

    [Parameter()]
    [System.Boolean]
    $DisableEnvironmentCreationByNonAdminUsers,

    [Parameter()]
    [System.Boolean]
    $DisablePortalsCreationByNonAdminUsers,

    [Parameter()]
    [System.Boolean]
    $DisableSurveyFeedback,

    [Parameter()]
    [System.Boolean]
    $DisableTrialEnvironmentCreationByNonAdminUsers,

    [Parameter()]
    [System.Boolean]
    $DisableCapacityAllocationByEnvironmentAdmins,

    [Parameter()]
    [System.Boolean]
    $DisableSupportTicketsVisibleByAllUsers,

    [Parameter()]
    [System.Boolean]
    $DisableDocsSearch,

    [Parameter()]
    [System.Boolean]
    $DisableCommunitySearch,

    [Parameter()]
    [System.Boolean]
    $DisableBingVideoSearch,

    [Parameter()]
    [System.Boolean]
    $DisableShareWithEveryone,

    [Parameter()]
    [System.Boolean]
    $EnableGuestsToMake,

    [Parameter()]
    [ValidateRange(1, 10000)]
    [System.UInt32]
    $ShareWithColleaguesUserLimit,

    [Parameter()]
    [System.Management.Automation.PSCredential]
    $Credential
  )
      #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
  $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
  $CommandName  = $MyInvocation.MyCommand
  $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
      -CommandName $CommandName `
      -Parameters $PSBoundParameters
  Add-M365DSCTelemetryEvent -Data $data
  #endregion

  Write-Verbose -Message 'Testing configuration for Power Platform Tenant Settings'
  $CurrentValues = Get-TargetResource @PSBoundParameters

  Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
  Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

  $ValuesToCheck = $PSBoundParameters
  $ValuesToCheck.Remove('Credential') | Out-Null
  $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
    -Source $($MyInvocation.MyCommand.Source) `
    -DesiredValues $PSBoundParameters `
    -ValuesToCheck $ValuesToCheck.Keys

  Write-Verbose -Message "Test-TargetResource returned $TestResult"

  return $TestResult
}

function Export-TargetResource
{
  [CmdletBinding()]
  [OutputType([System.String])]
  param
  (
    [Parameter()]
    [System.Management.Automation.PSCredential]
    $Credential,

    [Parameter()]
    [System.String]
    $ApplicationId,

    [Parameter()]
    [System.String]
    $TenantId,

    [Parameter()]
    [System.String]
    $CertificateThumbprint
  )
  $ConnectionMode = New-M365DSCConnection -Workload 'PowerPlatforms' `
    -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

  try
  {
    $settings = Get-TenantSettings -ErrorAction Stop
    $dscContent = ''

    $Params = @{
      IsSingleInstance                               = 'Yes'
      WalkMeOptOut                                   = $settings.walkMeOptOut
      DisableNPSCommentsReachout                     = $settings.disableNPSCommentsReachout
      DisableNewsletterSendout                       = $settings.disableNewsletterSendout
      DisableEnvironmentCreationByNonAdminUsers      = $settings.disableEnvironmentCreationByNonAdminUsers
      DisablePortalsCreationByNonAdminUsers          = $settings.disablePortalsCreationByNonAdminUsers
      DisableSurveyFeedback                          = $settings.disableSurveyFeedback
      DisableTrialEnvironmentCreationByNonAdminUsers = $settings.disableTrialEnvironmentCreationByNonAdminUsers
      DisableCapacityAllocationByEnvironmentAdmins   = $settings.disableCapacityAllocationByEnvironmentAdmins
      DisableSupportTicketsVisibleByAllUsers         = $settings.disableSupportTicketsVisibleByAllUsers
      DisableDocsSearch                              = $settings.powerPlatform.search.disableDocsSearch
      DisableCommunitySearch                         = $settings.powerPlatform.search.disableCommunitySearch
      DisableBingVideoSearch                         = $settings.powerPlatform.search.disableBingVideoSearch
      DisableShareWithEveryone                       = $settings.powerPlatform.powerApps.disableShareWithEveryone
      EnableGuestsToMake                             = $settings.powerPlatform.powerApps.enableGuestsToMake
      ShareWithColleaguesUserLimit                   = $settings.powerPlatform.teamsIntegration.shareWithColleaguesUserLimit
      Credential                             = $Credential
    }
    $Results = Get-TargetResource @Params
    $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
      -Results $Results
    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
      -ConnectionMode $ConnectionMode `
      -ModulePath $PSScriptRoot `
      -Results $Results `
      -Credential $Credential
    $dscContent += $currentDSCBlock

    Save-M365DSCPartialExport -Content $currentDSCBlock `
      -FileName $Global:PartialExportFileName

    Write-Host $Global:M365DSCEmojiGreenCheckMark

    return $dscContent
  }
  catch
  {
    try
    {
      Write-Host $Global:M365DSCEmojiRedX
      Write-Verbose -Message $_
      $tenantIdValue = ''
      if (-not [System.String]::IsNullOrEmpty($TenantId))
      {
        $tenantIdValue = $TenantId
      }
      elseif ($null -ne $Credential)
      {
        $tenantIdValue = $Credential.UserName.Split('@')[1]
      }
      Add-M365DSCEvent -Message $_ -EntryType 'Error' `
        -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
        -TenantId $tenantIdValue
    }
    catch
    {
      Write-Verbose -Message $_
    }
    return ''
  }
}

function Get-M365DSCPowerPlatformTenantSettingsJSON
{
  [CmdletBinding()]
  [OutputType([System.String])]
  param
  (
    [Parameter(Mandatory = $true)]
    [System.Collections.Hashtable]
    $Parameters
  )

  $JsonContent = @"
    {
        "walkMeOptOut" : $($Parameters.WalkMeOptOut),
        "disableNPSCommentsReachout" : $($Parameters.DisableNPSCommentsReachout),
        "disableNewsletterSendout" : $($Parameters.DisableNewsletterSendout),
        "disableEnvironmentCreationByNonAdminUsers" : $($Parameters.DisableEnvironmentCreationByNonAdminUsers),
        "disablePortalsCreationByNonAdminUsers" : $($Parameters.DisablePortalsCreationByNonAdminUsers),
        "disableSurveyFeedback" : $($Parameters.DisableSurveyFeedback),
        "disableTrialEnvironmentCreationByNonAdminUsers" : $($Parameters.DisableTrialEnvironmentCreationByNonAdminUsers),
        "disableCapacityAllocationByEnvironmentAdmins" : $($Parameters.DisableCapacityAllocationByEnvironmentAdmins),
        "disableSupportTicketsVisibleByAllUsers" : $($Parameters.DisableSupportTicketsVisibleByAllUsers),

        "powerPlatform": {
          "search:{
            "disableDocsSearch" : $($Parameters.DisableDocsSearch),
            "disableCommunitySearch" : $($Parameters.DisableCommunitySearch),
            "disableBingVideoSearch" : $($Parameters.DisableBingVideoSearch)
          },
          "powerApps": {
            "disableShareWithEveryone" : $($Parameters.DisableShareWithEveryone),
            "enableGuestsToMake" : $($Parameters.EnableGuestsToMake)
          },
          "teamsIntegration": {
            "shareWithColleaguesUserLimit": $($Parameters.ShareWithColleaguesUserLimit)
          }
        }
    }
"@
  return $JsonContent
}

Export-ModuleMember -Function *-TargetResource
