Confirm-M365DSCModuleDependency -ModuleName 'MSFT_TeamsGuestMessagingConfiguration'

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
        [System.Boolean]
        $AllowUserEditMessage,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessage,

        [Parameter()]
        [System.Boolean]
        $AllowUserChat,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteChat,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [System.String]
        [ValidateSet('Moderate', 'Strict', 'NoRestriction')]
        $GiphyRatingType = 'Moderate',

        [Parameter()]
        [System.Boolean]
        $AllowMemes,

        [Parameter()]
        [System.Boolean]
        $AllowStickers,

        [Parameter()]
        [System.Boolean]
        $AllowImmersiveReader,

        [Parameter()]
        [System.Boolean]
        $UsersCanDeleteBotMessages,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message 'Getting configuration of Teams Guest Messaging settings'

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

        $config = Get-CsTeamsGuestMessagingConfiguration -ErrorAction Stop

        return @{
            Identity                  = $Identity
            AllowUserEditMessage      = $config.AllowUserEditMessage
            AllowUserDeleteMessage    = $config.AllowUserDeleteMessage
            AllowUserChat             = $config.AllowUserChat
            AllowUserDeleteChat       = $config.AllowUserDeleteChat
            AllowGiphy                = $config.AllowGiphy
            GiphyRatingType           = $config.GiphyRatingType
            AllowMemes                = $config.AllowMemes
            AllowStickers             = $config.AllowStickers
            AllowImmersiveReader      = $config.AllowImmersiveReader
            UsersCanDeleteBotMessages = $config.UsersCanDeleteBotMessages
            Credential                = $Credential
            ApplicationId             = $ApplicationId
            TenantId                  = $TenantId
            CertificateThumbprint     = $CertificateThumbprint
            ManagedIdentity           = $ManagedIdentity.IsPresent
            AccessTokens              = $AccessTokens
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
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Global')]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowUserEditMessage,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessage,

        [Parameter()]
        [System.Boolean]
        $AllowUserChat,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteChat,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [System.String]
        [ValidateSet('Moderate', 'Strict', 'NoRestriction')]
        $GiphyRatingType = 'Moderate',

        [Parameter()]
        [System.Boolean]
        $AllowMemes,

        [Parameter()]
        [System.Boolean]
        $AllowStickers,

        [Parameter()]
        [System.Boolean]
        $AllowImmersiveReader,

        [Parameter()]
        [System.Boolean]
        $UsersCanDeleteBotMessages,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message 'Setting configuration of Teams Guest Messaging settings'

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

    # Check that at least one optional parameter is specified
    $inputValues = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    foreach ($item in $inputValues.GetEnumerator())
    {
        if ([System.String]::IsNullOrEmpty($item.Value))
        {
            $inputValues.Remove($item.Key) | Out-Null
        }
    }

    if ($inputValues.Count -eq 0)
    {
        throw "You need to specify at least one optional parameter for the Set-TargetResource function `
            of the [TeamsGuestMessagingConfiguration] instance {$Identity}"
    }

    $SetParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    Set-CsTeamsGuestMessagingConfiguration @SetParams
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
        [System.Boolean]
        $AllowUserEditMessage,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessage,

        [Parameter()]
        [System.Boolean]
        $AllowUserChat,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteChat,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [System.String]
        [ValidateSet('Moderate', 'Strict', 'NoRestriction')]
        $GiphyRatingType = 'Moderate',

        [Parameter()]
        [System.Boolean]
        $AllowMemes,

        [Parameter()]
        [System.Boolean]
        $AllowStickers,

        [Parameter()]
        [System.Boolean]
        $AllowImmersiveReader,

        [Parameter()]
        [System.Boolean]
        $UsersCanDeleteBotMessages,

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
        $dscContent = ''
        $params = @{
            Identity              = 'Global'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
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
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName

            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite
        }

        return $dscContent
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
