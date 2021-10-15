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
        $AllowGiphy,

        [Parameter()]
        [System.Boolean]
        $AllowMemes,

        [Parameter()]
        [System.Boolean]
        $AllowOwnerDeleteMessage,

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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Getting configuration of Teams Messaging Policy"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
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
            if ($currentPolicy -like "Tag:*")
            {
                $currentPolicy = $currentPolicy.Split(':')[1]
            }
            return @{
                Identity                      = $currentPolicy
                AllowGiphy                    = $policy.AllowGiphy
                AllowMemes                    = $policy.AllowMemes
                AllowOwnerDeleteMessage       = $policy.AllowOwnerDeleteMessage
                AllowStickers                 = $policy.AllowStickers
                AllowUrlPreviews              = $policy.AllowUrlPreviews
                AllowUserChat                 = $policy.AllowUserChat
                AllowUserDeleteMessage        = $policy.AllowUserDeleteMessage
                AllowUserEditMessage          = $policy.AllowUserEditMessage
                AllowUserTranslation          = $policy.AllowUserTranslation
                GiphyRatingType               = $policy.GiphyRatingType
                ReadReceiptsEnabledType       = $policy.ReadReceiptsEnabledType
                AllowImmersiveReader          = $policy.AllowImmersiveReader
                AllowRemoveUser               = $policy.AllowRemoveUser
                AllowPriorityMessages         = $policy.AllowPriorityMessages
                ChannelsInChatListEnabledType = $policy.ChannelsInChatListEnabledType
                AudioMessageEnabledType       = $policy.AudioMessageEnabledType
                Description                   = $policy.Description
                Tenant                        = $policy.Tenant
                Ensure                        = "Present"
                Credential            = $Credential
            }
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
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [System.Boolean]
        $AllowMemes,

        [Parameter()]
        [System.Boolean]
        $AllowOwnerDeleteMessage,

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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Setting configuration of Teams Messaging Policy"

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

    $curPolicy = Get-TargetResource @PSBoundParameters

    $SetParams = $PSBoundParameters
    $SetParams.Remove("Credential") | Out-Null
    $SetParams.Remove("Ensure") | Out-Null

    if ($curPolicy.Ensure -eq "Absent" -and "Present" -eq $Ensure )
    {
        New-CsTeamsMessagingPolicy @SetParams -force:$True
    }
    elseif (($curPolicy.Ensure -eq "Present" -and "Present" -eq $Ensure))
    {
        Set-CsTeamsMessagingPolicy @SetParams -force:$True
    }
    elseif (($Ensure -eq "Absent" -and $curPolicy.Ensure -eq "Present"))
    {
        Remove-CsTeamsMessagingPolicy -identity $curPolicy.Identity -force:$True
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
        $AllowGiphy,

        [Parameter()]
        [System.Boolean]
        $AllowMemes,

        [Parameter()]
        [System.Boolean]
        $AllowOwnerDeleteMessage,

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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Teams messaging policy"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
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
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

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
        $i = 1
        [array]$policies = Get-CsTeamsMessagingPolicy -ErrorAction Stop
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.Identity)" -NoNewline
            if ($policy.Identity.ToString().contains(":"))
            {
                $currentIdentity = $policy.Identity.split(":")[1]
            }
            else
            {
                $currentIdentity = $policy.Identity
            }

            $params = @{
                Identity           = $currentIdentity
                Ensure             = 'Present'
                Credential = $Credential
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
