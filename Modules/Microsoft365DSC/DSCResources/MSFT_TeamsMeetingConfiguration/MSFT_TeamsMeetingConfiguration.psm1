function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Global')]
        $Identity,

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
        $EnableQoS,

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
        [Switch]
        $ManagedIdentity
    )

    Write-Verbose -Message 'Getting configuration of Teams Meeting'

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

    $nullReturn = @{
        Identity = 'Global'
    }

    try
    {
        $config = Get-CsTeamsMeetingConfiguration -ErrorAction Stop

        return @{
            Identity                    = $Identity
            LogoURL                     = $config.LogoURL
            LegalURL                    = $config.LegalURL
            HelpURL                     = $config.HelpURL
            CustomFooterText            = $config.CustomFooterText
            DisableAnonymousJoin        = $config.DisableAnonymousJoin
            EnableQoS                   = $config.EnableQoS
            ClientAudioPort             = $config.ClientAudioPort
            ClientAudioPortRange        = $config.ClientAudioPortRange
            ClientVideoPort             = $config.ClientVideoPort
            ClientVideoPortRange        = $config.ClientVideoPortRange
            ClientAppSharingPort        = $config.ClientAppSharingPort
            ClientAppSharingPortRange   = $config.ClientAppSharingPortRange
            ClientMediaPortRangeEnabled = $config.ClientMediaPortRangeEnabled
            Credential                  = $Credential
            ApplicationId               = $ApplicationId
            TenantId                    = $TenantId
            CertificateThumbprint       = $CertificateThumbprint
            ManagedIdentity             = $ManagedIdentity.IsPresent
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
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Global')]
        $Identity,

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
        $EnableQoS,

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
        [Switch]
        $ManagedIdentity
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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    $SetParams = $PSBoundParameters
    $SetParams.Remove('Credential') | Out-Null
    $SetParams.Remove('ApplicationId') | Out-Null
    $SetParams.Remove('TenantId') | Out-Null
    $SetParams.Remove('CertificateThumbprint') | Out-Null
    $SetParams.Remove('ManagedIdentity') | Out-Null

    Set-CsTeamsMeetingConfiguration @SetParams
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Global')]
        $Identity,

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
        $EnableQoS,

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
        [Switch]
        $ManagedIdentity
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

    Write-Verbose -Message 'Testing configuration of Teams Client'

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

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
        [Switch]
        $ManagedIdentity
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
        $dscContent = ''
        $params = @{
            Identity              = 'Global'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
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

Export-ModuleMember -Function *-TargetResource
