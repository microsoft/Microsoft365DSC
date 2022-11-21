function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance = 'Yes',

        [Parameter()]
        [System.Boolean]
        $AllowPSTNOnlyMeetingsByDefault,

        [Parameter()]
        [System.Boolean]
        $AutomaticallyMigrateUserMeetings,

        [Parameter()]
        [System.Boolean]
        $AutomaticallyReplaceAcpProvider,

        [Parameter()]
        [System.Boolean]
        $AutomaticallySendEmailsToUsers,

        [Parameter()]
        [System.Boolean]
        $EnableDialOutJoinConfirmation,

        [Parameter()]
        [System.Boolean]
        $EnableEntryExitNotifications,

        [Parameter()]
        [System.String]
        $EntryExitAnnouncementsType,

        [Parameter()]
        [System.String]
        [ValidateSet('MaskedForExternalUsers', 'MaskedForAllUsers', 'NoMasking')]
        $MaskPstnNumbersType,

        [Parameter()]
        [System.UInt32]
        $PinLength,

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

    Write-Verbose -Message "Getting the Teams Dial In Conferencing Tenant Settings"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
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

    $nullReturn = $null

    try
    {
        $instance = Get-CsOnlineDialInConferencingTenantSettings

        return @{
            IsSingleInstance                         = 'Yes'
            AllowPSTNOnlyMeetingsByDefault           = $instance.AllowPSTNOnlyMeetingsByDefault
            AutomaticallyMigrateUserMeetings         = $instance.AutomaticallyMigrateUserMeetings
            AutomaticallyReplaceAcpProvider          = $instance.AutomaticallyReplaceAcpProvider
            AutomaticallySendEmailsToUsers           = $instance.AutomaticallySendEmailsToUsers
            EnableDialOutJoinConfirmation            = $instance.EnableDialOutJoinConfirmation
            EnableEntryExitNotifications             = $instance.EnableEntryExitNotifications
            EntryExitAnnouncementsType               = $instance.EntryExitAnnouncementsType
            MaskPstnNumbersType                      = $instance.MaskPstnNumbersType
            PinLength                                = $instance.PinLength
            Credential                               = $Credential
            ApplicationId                            = $ApplicationId
            TenantId                                 = $TenantId
            CertificateThumbprint                    = $CertificateThumbprint
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
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
        [ValidateSet('Yes')]
        $IsSingleInstance = 'Yes',

        [Parameter()]
        [System.Boolean]
        $AllowPSTNOnlyMeetingsByDefault,

        [Parameter()]
        [System.Boolean]
        $AutomaticallyMigrateUserMeetings,

        [Parameter()]
        [System.Boolean]
        $AutomaticallyReplaceAcpProvider,

        [Parameter()]
        [System.Boolean]
        $AutomaticallySendEmailsToUsers,

        [Parameter()]
        [System.Boolean]
        $EnableDialOutJoinConfirmation,

        [Parameter()]
        [System.Boolean]
        $EnableEntryExitNotifications,

        [Parameter()]
        [System.String]
        $EntryExitAnnouncementsType,

        [Parameter()]
        [System.String]
        [ValidateSet('MaskedForExternalUsers', 'MaskedForAllUsers', 'NoMasking')]
        $MaskPstnNumbersType,

        [Parameter()]
        [System.UInt32]
        $PinLength,

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

    Write-Verbose -Message "Setting Teams Dial In Conferencing Tenant Settings"

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $SetParameters = $PSBoundParameters
    $SetParameters.Remove("Credential") | Out-Null
    $SetParameters.Remove("ApplicationId") | Out-Null
    $SetParameters.Remove("TenantId") | Out-Null
    $SetParameters.Remove("CertificateThumbprint") | Out-Null
    $SetParameters.Remove("IsSingleInstance") | Out-Null

    try
    {
        Set-CsOnlineDialInConferencingTenantSettings @SetParameters
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
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
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance = 'Yes',

        [Parameter()]
        [System.Boolean]
        $AllowPSTNOnlyMeetingsByDefault,

        [Parameter()]
        [System.Boolean]
        $AutomaticallyMigrateUserMeetings,

        [Parameter()]
        [System.Boolean]
        $AutomaticallyReplaceAcpProvider,

        [Parameter()]
        [System.Boolean]
        $AutomaticallySendEmailsToUsers,

        [Parameter()]
        [System.Boolean]
        $EnableDialOutJoinConfirmation,

        [Parameter()]
        [System.Boolean]
        $EnableEntryExitNotifications,

        [Parameter()]
        [System.String]
        $EntryExitAnnouncementsType,

        [Parameter()]
        [System.String]
        [ValidateSet('MaskedForExternalUsers', 'MaskedForAllUsers', 'NoMasking')]
        $MaskPstnNumbersType,

        [Parameter()]
        [System.UInt32]
        $PinLength,

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

    Write-Verbose -Message "Testing configuration of Teams Dial In Conferencing Tenant Settings"

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
        $CertificateThumbprint
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
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
        $dscContent = [System.Text.StringBuilder]::new()
        $params = @{
            IsSingleInstance      = 'Yes'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
        $Results = Get-TargetResource @Params
        $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
            -Results $Results
        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $Results `
            -Credential $Credential
        $dscContent.Append($currentDSCBlock) | Out-Null
        Save-M365DSCPartialExport -Content $currentDSCBlock `
            -FileName $Global:PartialExportFileName
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        $i++
        return $dscContent.ToString()
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
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
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
