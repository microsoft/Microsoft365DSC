function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowCommunicationComplianceEndUserReporting,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [System.Boolean]
        $AllowFluidCollaborate,

        [Parameter()]
        [System.Boolean]
        $AllowMemes,

        [Parameter()]
        [System.Boolean]
        $AllowOwnerDeleteMessage,

        [Parameter()]
        [System.Boolean]
        $AllowSecurityEndUserReporting,

        [Parameter()]
        [System.Boolean]
        $AllowStickers,

        [Parameter()]
        [System.Boolean]
        $AllowUrlPreviews,

        [Parameter()]
        [System.Boolean]
        $AllowUserChat,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessage,

        [Parameter()]
        [System.Boolean]
        $AllowUserEditMessage,

        [Parameter()]
        [System.Boolean]
        $AllowSmartCompose,

        [Parameter()]
        [System.Boolean]
        $AllowSmartReply,

        [Parameter()]
        [System.Boolean]
        $AllowUserTranslation,

        [Parameter()]
        [System.Boolean]
        $AllowImmersiveReader,

        [Parameter()]
        [System.Boolean]
        $AllowRemoveUser,

        [Parameter()]
        [System.Boolean]
        $AllowPriorityMessages,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteChat,

        [Parameter()]
        [System.Boolean]
        $AllowVideoMessages,

        [Parameter()]
        [System.String]
        [ValidateSet('DisabledUserOverride', 'EnabledUserOverride')]
        $ChannelsInChatListEnabledType,

        [Parameter()]
        [System.String]
        [ValidateSet('ChatsAndChannels', 'ChatsOnly', 'Disabled')]
        $AudioMessageEnabledType,

        [Parameter()]
        [System.String]
        [ValidateSet('STRICT', 'MODERATE', 'NORESTRICTION')]
        $GiphyRatingType,

        [Parameter()]
        [System.String]
        [ValidateSet('UserPreference', 'Everyone', 'None')]
        $ReadReceiptsEnabledType,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Tenant,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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

    Write-Verbose -Message 'Getting configuration of Teams Messaging Policy'

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

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        $policy = Get-CsTeamsMessagingPolicy -Identity $Identity `
            -ErrorAction SilentlyContinue

        if ($null -eq $policy)
        {
            return $nullReturn
        }
        else
        {
            # Tag: gets prefixed to Identity on Get, need to remove
            $currentPolicy = $policy.Identity
            if ($currentPolicy -like 'Tag:*')
            {
                $currentPolicy = $currentPolicy.Split(':')[1]
            }
            return @{
                Identity                      = $currentPolicy
                AllowCommunicationComplianceEndUserReporting = $policy.AllowCommunicationComplianceEndUserReporting
                AllowGiphy                                   = $policy.AllowGiphy
                AllowFluidCollaborate                        = $policy.AllowFluidCollaborate
                AllowMemes                                   = $policy.AllowMemes
                AllowOwnerDeleteMessage                      = $policy.AllowOwnerDeleteMessage
                AllowSecurityEndUserReporting                = $policy.AllowSecurityEndUserReporting
                AllowStickers                                = $policy.AllowStickers
                AllowUrlPreviews                             = $policy.AllowUrlPreviews
                AllowUserChat                                = $policy.AllowUserChat
                AllowUserDeleteMessage                       = $policy.AllowUserDeleteMessage
                AllowUserEditMessage                         = $policy.AllowUserEditMessage
                AllowSmartCompose                            = $policy.AllowSmartCompose
                AllowSmartReply                              = $policy.AllowSmartReply
                AllowUserTranslation                         = $policy.AllowUserTranslation
                GiphyRatingType                              = $policy.GiphyRatingType
                ReadReceiptsEnabledType                      = $policy.ReadReceiptsEnabledType
                AllowImmersiveReader                         = $policy.AllowImmersiveReader
                AllowRemoveUser                              = $policy.AllowRemoveUser
                AllowPriorityMessages                        = $policy.AllowPriorityMessages
                AllowUserDeleteChat                          = $policy.AllowUserDeleteChat
                AllowVideoMessages                           = $policy.AllowVideoMessages
                ChannelsInChatListEnabledType                = $policy.ChannelsInChatListEnabledType
                AudioMessageEnabledType                      = $policy.AudioMessageEnabledType
                Description                                  = $policy.Description
                Tenant                                       = $policy.Tenant
                Ensure                                       = 'Present'
                Credential                                   = $Credential
                ApplicationId                                = $ApplicationId
                TenantId                                     = $TenantId
                CertificateThumbprint                        = $CertificateThumbprint
                ManagedIdentity                              = $ManagedIdentity.IsPresent
                AccessTokens                                 = $AccessTokens
            }
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
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowCommunicationComplianceEndUserReporting,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [System.Boolean]
        $AllowFluidCollaborate,

        [Parameter()]
        [System.Boolean]
        $AllowMemes,

        [Parameter()]
        [System.Boolean]
        $AllowOwnerDeleteMessage,

        [Parameter()]
        [System.Boolean]
        $AllowSecurityEndUserReporting,

        [Parameter()]
        [System.Boolean]
        $AllowStickers,

        [Parameter()]
        [System.Boolean]
        $AllowUrlPreviews,

        [Parameter()]
        [System.Boolean]
        $AllowUserChat,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessage,

        [Parameter()]
        [System.Boolean]
        $AllowUserEditMessage,

        [Parameter()]
        [System.Boolean]
        $AllowSmartCompose,

        [Parameter()]
        [System.Boolean]
        $AllowSmartReply,

        [Parameter()]
        [System.Boolean]
        $AllowUserTranslation,

        [Parameter()]
        [System.Boolean]
        $AllowImmersiveReader,

        [Parameter()]
        [System.Boolean]
        $AllowRemoveUser,

        [Parameter()]
        [System.Boolean]
        $AllowPriorityMessages,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteChat,

        [Parameter()]
        [System.Boolean]
        $AllowVideoMessages,

        [Parameter()]
        [System.String]
        [ValidateSet('DisabledUserOverride', 'EnabledUserOverride')]
        $ChannelsInChatListEnabledType,

        [Parameter()]
        [System.String]
        [ValidateSet('ChatsAndChannels', 'ChatsOnly', 'Disabled')]
        $AudioMessageEnabledType,

        [Parameter()]
        [System.String]
        [ValidateSet('STRICT', 'MODERATE', 'NORESTRICTION')]
        $GiphyRatingType,

        [Parameter()]
        [System.String]
        [ValidateSet('UserPreference', 'Everyone', 'None')]
        $ReadReceiptsEnabledType,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Tenant,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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

    Write-Verbose -Message 'Setting configuration of Teams Messaging Policy'

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

    $curPolicy = Get-TargetResource @PSBoundParameters

    $SetParams = $PSBoundParameters
    $SetParams.Remove('Credential') | Out-Null
    $SetParams.Remove('ApplicationId') | Out-Null
    $SetParams.Remove('TenantId') | Out-Null
    $SetParams.Remove('CertificateThumbprint') | Out-Null
    $SetParams.Remove('Ensure') | Out-Null
    $SetParams.Remove('ManagedIdentity') | Out-Null
    $SetParams.Remove('AccessTokens') | Out-Null

    if ($curPolicy.Ensure -eq 'Absent' -and 'Present' -eq $Ensure )
    {
        New-CsTeamsMessagingPolicy @SetParams
    }
    elseif (($curPolicy.Ensure -eq 'Present' -and 'Present' -eq $Ensure))
    {
        Set-CsTeamsMessagingPolicy @SetParams
    }
    elseif (($Ensure -eq 'Absent' -and $curPolicy.Ensure -eq 'Present'))
    {
        Remove-CsTeamsMessagingPolicy -Identity $curPolicy.Identity
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
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowCommunicationComplianceEndUserReporting,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [System.Boolean]
        $AllowFluidCollaborate,

        [Parameter()]
        [System.Boolean]
        $AllowMemes,

        [Parameter()]
        [System.Boolean]
        $AllowOwnerDeleteMessage,

        [Parameter()]
        [System.Boolean]
        $AllowSecurityEndUserReporting,

        [Parameter()]
        [System.Boolean]
        $AllowStickers,

        [Parameter()]
        [System.Boolean]
        $AllowUrlPreviews,

        [Parameter()]
        [System.Boolean]
        $AllowUserChat,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessage,

        [Parameter()]
        [System.Boolean]
        $AllowUserEditMessage,

        [Parameter()]
        [System.Boolean]
        $AllowSmartCompose,

        [Parameter()]
        [System.Boolean]
        $AllowSmartReply,

        [Parameter()]
        [System.Boolean]
        $AllowUserTranslation,

        [Parameter()]
        [System.Boolean]
        $AllowImmersiveReader,

        [Parameter()]
        [System.Boolean]
        $AllowRemoveUser,

        [Parameter()]
        [System.Boolean]
        $AllowPriorityMessages,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteChat,

        [Parameter()]
        [System.Boolean]
        $AllowVideoMessages,

        [Parameter()]
        [System.String]
        [ValidateSet('DisabledUserOverride', 'EnabledUserOverride')]
        $ChannelsInChatListEnabledType,

        [Parameter()]
        [System.String]
        [ValidateSet('ChatsAndChannels', 'ChatsOnly', 'Disabled')]
        $AudioMessageEnabledType,

        [Parameter()]
        [System.String]
        [ValidateSet('STRICT', 'MODERATE', 'NORESTRICTION')]
        $GiphyRatingType,

        [Parameter()]
        [System.String]
        [ValidateSet('UserPreference', 'Everyone', 'None')]
        $ReadReceiptsEnabledType,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Tenant,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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

    Write-Verbose -Message 'Testing configuration of Teams messaging policy'

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

    $ValuesToCheck.Remove('Tenant') | Out-Null
    $TestResult = Test-M365DSCParameterState `
        -CurrentValues $CurrentValues `
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
        $i = 1
        [array]$policies = Get-CsTeamsMessagingPolicy -ErrorAction Stop
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.Identity)" -NoNewline
            if ($policy.Identity.ToString().contains(':'))
            {
                $currentIdentity = $policy.Identity.split(':')[1]
            }
            else
            {
                $currentIdentity = $policy.Identity
            }

            $params = @{
                Identity              = $currentIdentity
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
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
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
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
