Confirm-M365DSCModuleDependency -ModuleName 'MSFT_TeamsMessagingPolicy'

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
        $AllowChatWithGroup,

        [Parameter()]
        [System.Boolean]
        $AllowCustomGroupChatAvatars,

        [Parameter()]
        [System.Boolean]
        $AllowExtendedWorkInfoInSearch,

        [Parameter()]
        [System.Boolean]
        $AllowFullChatPermissionUserToDeleteAnyMessage,

        [Parameter()]
        [System.Boolean]
        $AllowGiphyDisplay,

        [Parameter()]
        [System.Boolean]
        $AllowGroupChatJoinLinks,

        [Parameter()]
        [System.Boolean]
        $AllowPasteInternetImage,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AutoShareFilesInExternalChats,

        [Parameter()]
        [ValidateSet('Full', 'Limited', 'Restricted')]
        [System.String]
        $ChatPermissionRole,

        [Parameter()]
        [System.Boolean]
        $CreateCustomEmojis,

        [Parameter()]
        [System.Boolean]
        $DeleteCustomEmojis,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $DesignerForBackgroundsAndImages,

        [Parameter()]
        [ValidateSet('BlockingDisallowed', 'BlockingAllowed')]
        [System.String]
        $InOrganizationChatControl,

        [Parameter()]
        [System.Boolean]
        $UsersCanDeleteBotMessages,

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
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $UseB2BInvitesToAddExternalUsers,

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

    Write-Verbose -Message 'Getting configuration of Teams Messaging Policy'

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
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

            $nullReturn = $PSBoundParameters
            $nullReturn.Ensure = 'Absent'

            $policy = Get-CsTeamsMessagingPolicy -Identity $Identity `
                -ErrorAction SilentlyContinue
        }
        else
        {
            $policy = $Script:exportedInstance
        }

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

            if ($policy.UseB2BInvitesToAddExternalUsers)
            {
                $useB2BInvitesToAddExternalUsersValue = 'Enabled'
            }
            else
            {
                $useB2BInvitesToAddExternalUsersValue = 'Disabled'
            }
            return @{
                Identity                                      = $currentPolicy
                AllowChatWithGroup                            = $policy.AllowChatWithGroup
                AllowCustomGroupChatAvatars                   = $policy.AllowCustomGroupChatAvatars
                AllowExtendedWorkInfoInSearch                 = $policy.AllowExtendedWorkInfoInSearch
                AllowFullChatPermissionUserToDeleteAnyMessage = $policy.AllowFullChatPermissionUserToDeleteAnyMessage
                AllowGiphyDisplay                             = $policy.AllowGiphyDisplay
                AllowGroupChatJoinLinks                       = $policy.AllowGroupChatJoinLinks
                AllowPasteInternetImage                       = $policy.AllowPasteInternetImage
                AutoShareFilesInExternalChats                 = $policy.AutoShareFilesInExternalChats
                ChatPermissionRole                            = $policy.ChatPermissionRole
                CreateCustomEmojis                            = $policy.CreateCustomEmojis
                DeleteCustomEmojis                            = $policy.DeleteCustomEmojis
                DesignerForBackgroundsAndImages               = $policy.DesignerForBackgroundsAndImages
                InOrganizationChatControl                     = $policy.InOrganizationChatControl
                UsersCanDeleteBotMessages                     = $policy.UsersCanDeleteBotMessages
                AllowCommunicationComplianceEndUserReporting  = $policy.AllowCommunicationComplianceEndUserReporting
                AllowGiphy                                    = $policy.AllowGiphy
                AllowFluidCollaborate                         = $policy.AllowFluidCollaborate
                AllowMemes                                    = $policy.AllowMemes
                AllowOwnerDeleteMessage                       = $policy.AllowOwnerDeleteMessage
                AllowSecurityEndUserReporting                 = $policy.AllowSecurityEndUserReporting
                AllowStickers                                 = $policy.AllowStickers
                AllowUrlPreviews                              = $policy.AllowUrlPreviews
                AllowUserChat                                 = $policy.AllowUserChat
                AllowUserDeleteMessage                        = $policy.AllowUserDeleteMessage
                AllowUserEditMessage                          = $policy.AllowUserEditMessage
                AllowSmartCompose                             = $policy.AllowSmartCompose
                AllowSmartReply                               = $policy.AllowSmartReply
                AllowUserTranslation                          = $policy.AllowUserTranslation
                GiphyRatingType                               = $policy.GiphyRatingType
                ReadReceiptsEnabledType                       = $policy.ReadReceiptsEnabledType
                AllowImmersiveReader                          = $policy.AllowImmersiveReader
                AllowRemoveUser                               = $policy.AllowRemoveUser
                AllowPriorityMessages                         = $policy.AllowPriorityMessages
                AllowUserDeleteChat                           = $policy.AllowUserDeleteChat
                AllowVideoMessages                            = $policy.AllowVideoMessages
                ChannelsInChatListEnabledType                 = $policy.ChannelsInChatListEnabledType
                AudioMessageEnabledType                       = $policy.AudioMessageEnabledType
                UseB2BInvitesToAddExternalUsers               = $useB2BInvitesToAddExternalUsersValue
                Description                                   = $policy.Description
                Tenant                                        = $policy.Tenant
                Ensure                                        = 'Present'
                Credential                                    = $Credential
                ApplicationId                                 = $ApplicationId
                TenantId                                      = $TenantId
                CertificateThumbprint                         = $CertificateThumbprint
                ManagedIdentity                               = $ManagedIdentity.IsPresent
                AccessTokens                                  = $AccessTokens
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
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowChatWithGroup,

        [Parameter()]
        [System.Boolean]
        $AllowCustomGroupChatAvatars,

        [Parameter()]
        [System.Boolean]
        $AllowExtendedWorkInfoInSearch,

        [Parameter()]
        [System.Boolean]
        $AllowFullChatPermissionUserToDeleteAnyMessage,

        [Parameter()]
        [System.Boolean]
        $AllowGiphyDisplay,

        [Parameter()]
        [System.Boolean]
        $AllowGroupChatJoinLinks,

        [Parameter()]
        [System.Boolean]
        $AllowPasteInternetImage,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AutoShareFilesInExternalChats,

        [Parameter()]
        [ValidateSet('Full', 'Limited', 'Restricted')]
        [System.String]
        $ChatPermissionRole,

        [Parameter()]
        [System.Boolean]
        $CreateCustomEmojis,

        [Parameter()]
        [System.Boolean]
        $DeleteCustomEmojis,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $DesignerForBackgroundsAndImages,

        [Parameter()]
        [ValidateSet('BlockingDisallowed', 'BlockingAllowed')]
        [System.String]
        $InOrganizationChatControl,

        [Parameter()]
        [System.Boolean]
        $UsersCanDeleteBotMessages,

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
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $UseB2BInvitesToAddExternalUsers,

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

    $curPolicy = Get-TargetResource @PSBoundParameters
    $SetParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    # TODO: Review during next breaking change for updated documentation - Refactor if necessary
    if ($SetParams.ContainsKey('UseB2BInvitesToAddExternalUsers'))
    {
        if ($UseB2BInvitesToAddExternalUsers -eq 'Enabled')
        {
           $SetParams.UseB2BInvitesToAddExternalUsers = $true
        }
        else
        {
            $SetParams.UseB2BInvitesToAddExternalUsers = $false
        }
    }

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
        $AllowChatWithGroup,

        [Parameter()]
        [System.Boolean]
        $AllowCustomGroupChatAvatars,

        [Parameter()]
        [System.Boolean]
        $AllowExtendedWorkInfoInSearch,

        [Parameter()]
        [System.Boolean]
        $AllowFullChatPermissionUserToDeleteAnyMessage,

        [Parameter()]
        [System.Boolean]
        $AllowGiphyDisplay,

        [Parameter()]
        [System.Boolean]
        $AllowGroupChatJoinLinks,

        [Parameter()]
        [System.Boolean]
        $AllowPasteInternetImage,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AutoShareFilesInExternalChats,

        [Parameter()]
        [ValidateSet('Full', 'Limited', 'Restricted')]
        [System.String]
        $ChatPermissionRole,

        [Parameter()]
        [System.Boolean]
        $CreateCustomEmojis,

        [Parameter()]
        [System.Boolean]
        $DeleteCustomEmojis,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $DesignerForBackgroundsAndImages,

        [Parameter()]
        [ValidateSet('BlockingDisallowed', 'BlockingAllowed')]
        [System.String]
        $InOrganizationChatControl,

        [Parameter()]
        [System.Boolean]
        $UsersCanDeleteBotMessages,

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
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $UseB2BInvitesToAddExternalUsers,

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
        [System.String]
        $Filter = "*",

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
        $i = 1
        [array]$policies = Get-CsTeamsMessagingPolicy -Filter $Filter -ErrorAction Stop
        $dscContent = [System.Text.StringBuilder]::new()
        Write-M365DSCHost -Message "`r`n" -DeferWrite
        foreach ($policy in $policies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($policies.Count)] $($policy.Identity)" -DeferWrite

            $params = @{
                Identity              = $policy.Identity
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $policy
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
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
