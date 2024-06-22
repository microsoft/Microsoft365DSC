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
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret
    )

    Write-Verbose -Message 'Checking the Power Platform Tenant Settings Configuration'
    $ConnectionMode = New-M365DSCConnection -Workload 'PowerPlatforms' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = @{
        IsSingleInstance = 'Yes'
    }

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
            Credential                                     = $Credential
            ApplicationId                                  = $ApplicationId
            TenantId                                       = $TenantId
            CertificateThumbprint                          = $CertificateThumbprint
            ApplicationSecret                              = $ApplicationSecret
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullReturn
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
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret
    )

    Write-Verbose -Message 'Setting Power Platform Tenant Settings configuration'

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'PowerPlatforms' `
        -InboundParameters $PSBoundParameters

    $SetParameters = $PSBoundParameters
    $RequestBody = Get-M365DSCPowerPlatformTenantSettings -Parameters $SetParameters
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
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
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
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'PowerPlatforms' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $settings = Get-TenantSettings -ErrorAction Stop

        if ($settings.StatusCode -eq 403)
        {
            throw "Invalid permission for the application. If you are using a custom app registration to authenticate, make sure it is defined as a Power Platform admin management application. For additional information refer to https://learn.microsoft.com/en-us/power-platform/admin/powershell-create-service-principal#registering-an-admin-management-application"
        }
        $dscContent = ''

        if ($null -ne $Global:M365DSCExportResourceInstancesCount)
        {
            $Global:M365DSCExportResourceInstancesCount++
        }

        $Params = @{
            IsSingleInstance      = 'Yes'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ApplicationSecret     = $ApplicationSecret
        }
        $Results = Get-TargetResource @Params

        if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
        {
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
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX
        }

        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

function Get-M365DSCPowerPlatformTenantSettings
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Parameters
    )

    $result = @{
        walkMeOptOut                                   = $Parameters.WalkMeOptOut
        disableNPSCommentsReachout                     = $Parameters.DisableNPSCommentsReachout
        disableNewsletterSendout                       = $Parameters.DisableNewsletterSendout
        disableEnvironmentCreationByNonAdminUsers      = $Parameters.DisableEnvironmentCreationByNonAdminUsers
        disablePortalsCreationByNonAdminUsers          = $Parameters.DisablePortalsCreationByNonAdminUsers
        disableSurveyFeedback                          = $Parameters.DisableSurveyFeedback
        disableTrialEnvironmentCreationByNonAdminUsers = $Parameters.DisableTrialEnvironmentCreationByNonAdminUsers
        disableCapacityAllocationByEnvironmentAdmins   = $Parameters.DisableCapacityAllocationByEnvironmentAdmins
        disableSupportTicketsVisibleByAllUsers         = $Parameters.DisableSupportTicketsVisibleByAllUsers
        powerPlatform                                  = @{
            search           = @{
                disableDocsSearch      = $Parameters.DisableDocsSearch
                disableCommunitySearch = $Parameters.DisableCommunitySearch
                disableBingVideoSearch = $Parameters.DisableBingVideoSearch
            }
            powerApps        = @{
                disableShareWithEveryone = $Parameters.DisableShareWithEveryone
                enableGuestsToMake       = $Parameters.EnableGuestsToMake
            }
            teamsIntegration = @{
                shareWithColleaguesUserLimit = $Parameters.ShareWithColleaguesUserLimit
            }
        }
    }

    return $result
}

Export-ModuleMember -Function *-TargetResource
