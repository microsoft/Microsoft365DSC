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
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Teams Messaging Policy"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SkypeForBusiness

    try
    {
        $policy = Get-CsTeamsMessagingPolicy -Identity $Identity -ErrorAction SilentlyContinue

        if ($null -eq $policy)
        {
            return @{
                Identity           = $Identity
                Ensure             = 'Absent'
                GlobalAdminAccount = $GlobalAdminAccount
            }
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
                GlobalAdminAccount            = $GlobalAdminAccount
            }
        }
    }
    catch
    {
        throw $_
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
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Teams Messaging Policy"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SkypeForBusiness

    $curPolicy = Get-TargetResource @PSBoundParameters

    $SetParams = $PSBoundParameters
    $SetParams.Remove("GlobalAdminAccount") | Out-Null
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
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Teams messaging policy"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('Tenant') | Out-Null
    $TestResult = Test-Microsoft365DSCParameterState `
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
        $GlobalAdminAccount
    )
    $InformationPreference = 'Continue'

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SkypeForBusiness

    $i = 1
    [array]$policies = Get-CsTeamsMessagingPolicy
    $content = ''
    foreach ($policy in $policies)
    {
        Write-Information "    [$i/$($policies.Count)] $($policy.Identity)"
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
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        TeamsMessagingPolicy " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
