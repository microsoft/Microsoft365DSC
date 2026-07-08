Confirm-M365DSCModuleDependency -ModuleName 'MSFT_TeamsMeetingConfiguration'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $LogoURL,

        [Parameter()]
        [System.String]
        $LegalURL,

        [Parameter()]
        [System.String]
        $HelpURL,

        [Parameter()]
        [System.String]
        $CustomFooterText,

        [Parameter()]
        [System.Boolean]
        $DisableAnonymousJoin,

        [Parameter()]
        [System.Boolean]
        $DisableAppInteractionForAnonymousUsers,

        [Parameter()]
        [System.Boolean]
        $EnableQoS,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $FeedbackSurveyForAnonymousUsers,

        [Parameter()]
        [System.Boolean]
        $LimitPresenterRolePermissions,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientAudioPort = 50000,

        [Parameter()]
        [System.UInt32]
        $ClientAudioPortRange = 20,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientVideoPort = 50020,

        [Parameter()]
        [System.UInt32]
        $ClientVideoPortRange = 20,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientAppSharingPort = 50040,

        [Parameter()]
        [System.UInt32]
        $ClientAppSharingPortRange = 20,

        [Parameter()]
        [System.Boolean]
        $ClientMediaPortRangeEnabled,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message 'Getting configuration of Teams Meeting'

    try
    {
        $null = New-M365DSCConnection -Workload 'MicrosoftTeams' `
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

        $config = Get-CsTeamsMeetingConfiguration -ErrorAction Stop

        return @{
            IsSingleInstance                        = 'Yes'
            LogoURL                                = $config.LogoURL
            LegalURL                               = $config.LegalURL
            HelpURL                                = $config.HelpURL
            CustomFooterText                       = $config.CustomFooterText
            DisableAnonymousJoin                   = $config.DisableAnonymousJoin
            EnableQoS                              = $config.EnableQoS
            ClientAudioPort                        = $config.ClientAudioPort
            ClientAudioPortRange                   = $config.ClientAudioPortRange
            ClientVideoPort                        = $config.ClientVideoPort
            ClientVideoPortRange                   = $config.ClientVideoPortRange
            ClientAppSharingPort                   = $config.ClientAppSharingPort
            ClientAppSharingPortRange              = $config.ClientAppSharingPortRange
            ClientMediaPortRangeEnabled            = $config.ClientMediaPortRangeEnabled
            DisableAppInteractionForAnonymousUsers = $config.DisableAppInteractionForAnonymousUsers
            FeedbackSurveyForAnonymousUsers        = $config.FeedbackSurveyForAnonymousUsers
            LimitPresenterRolePermissions          = $config.LimitPresenterRolePermissions
            Credential                             = $Credential
            ApplicationId                          = $ApplicationId
            TenantId                               = $TenantId
            CertificateThumbprint                  = $CertificateThumbprint
            CertificatePath                        = $CertificatePath
            CertificatePassword                    = $CertificatePassword
            ManagedIdentity                        = $ManagedIdentity.IsPresent
            AccessTokens                           = $AccessTokens
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]
        $LogoURL,

        [Parameter()]
        [System.String]
        $LegalURL,

        [Parameter()]
        [System.String]
        $HelpURL,

        [Parameter()]
        [System.String]
        $CustomFooterText,

        [Parameter()]
        [System.Boolean]
        $DisableAnonymousJoin,

        [Parameter()]
        [System.Boolean]
        $DisableAppInteractionForAnonymousUsers,

        [Parameter()]
        [System.Boolean]
        $EnableQoS,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $FeedbackSurveyForAnonymousUsers,

        [Parameter()]
        [System.Boolean]
        $LimitPresenterRolePermissions,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientAudioPort = 50000,

        [Parameter()]
        [System.UInt32]
        $ClientAudioPortRange = 20,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientVideoPort = 50020,

        [Parameter()]
        [System.UInt32]
        $ClientVideoPortRange = 20,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientAppSharingPort = 50040,

        [Parameter()]
        [System.UInt32]
        $ClientAppSharingPortRange = 20,

        [Parameter()]
        [System.Boolean]
        $ClientMediaPortRangeEnabled,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message 'Setting configuration of Teams Meetings'

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

    $null = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    $SetParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $SetParams.Add('Identity', 'Global')
    $SetParams.Remove('IsSingleInstance') | Out-Null
    Set-CsTeamsMeetingConfiguration @SetParams
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $LogoURL,

        [Parameter()]
        [System.String]
        $LegalURL,

        [Parameter()]
        [System.String]
        $HelpURL,

        [Parameter()]
        [System.String]
        $CustomFooterText,

        [Parameter()]
        [System.Boolean]
        $DisableAnonymousJoin,

        [Parameter()]
        [System.Boolean]
        $DisableAppInteractionForAnonymousUsers,

        [Parameter()]
        [System.Boolean]
        $EnableQoS,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $FeedbackSurveyForAnonymousUsers,

        [Parameter()]
        [System.Boolean]
        $LimitPresenterRolePermissions,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientAudioPort = 50000,

        [Parameter()]
        [System.UInt32]
        $ClientAudioPortRange = 20,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientVideoPort = 50020,

        [Parameter()]
        [System.UInt32]
        $ClientVideoPortRange = 20,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientAppSharingPort = 50040,

        [Parameter()]
        [System.UInt32]
        $ClientAppSharingPortRange = 20,

        [Parameter()]
        [System.Boolean]
        $ClientMediaPortRangeEnabled,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
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
        $dscContent = [System.Text.StringBuilder]::new()
        $params = @{
            IsSingleInstance      = 'Yes'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
        $Results = Get-TargetResource @Params
        if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName

            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite
        }

        return $dscContent.ToString()
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
