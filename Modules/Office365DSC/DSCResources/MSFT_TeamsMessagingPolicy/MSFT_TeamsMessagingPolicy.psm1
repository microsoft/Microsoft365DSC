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
        [System.String]
        [ValidateSet('STRICT', 'MODERATE', 'NORESTRICTION')]
        $GiphyRatingType,

        [Parameter()]
        [System.String]
        [ValidateSet('UserPreference', 'Everyone', 'None')]
        $ReadReceiptsEnabledType,

        [Parameter()]
        [System.String[]]
        $Description,

        [Parameter()]
        [System.String[]]
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

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform SkypeForBusiness

    try
    {
        $policy = Get-CsTeamsMessagingPolicy -identity $Identity

        if ($null -eq $policy)
        {
            return @{
                Identity                = $Identity
                AllowGiphy              = $AllowGiphy
                AllowMemes              = $AllowMemes
                AllowOwnerDeleteMessage = $AllowOwnerDeleteMessage
                AllowStickers           = $AllowStickers
                AllowUrlPreviews        = $AllowUrlPreviews
                AllowUserChat           = $AllowUserChat
                AllowUserDeleteMessage  = $AllowUserDeleteMessage
                AllowUserTranslation    = $AllowUserTranslation
                GiphyRatingType         = $GiphyRatingType
                ReadReceiptsEnabledType = $ReadReceiptsEnabledType
                Description             = $Description
                Tenant                  = $Tenant
                Ensure                  = "Absent"
                GlobalAdminAccount      = $GlobalAdminAccount
            }
        }
        else
        {
            return @{
                Identity                = $policy.Identity
                AllowGiphy              = $policy.AllowGiphy
                AllowMemes              = $policy.AllowMemes
                AllowOwnerDeleteMessage = $policy.AllowOwnerDeleteMessage
                AllowStickers           = $policy.AllowStickers
                AllowUrlPreviews        = $policy.AllowUrlPreviews
                AllowUserChat           = $policy.AllowUserChat
                AllowUserDeleteMessage  = $policy.AllowUserDeleteMessage
                AllowUserTranslation    = $policy.AllowUserTranslation
                GiphyRatingType         = $policy.GiphyRatingType
                ReadReceiptsEnabledType = $policy.ReadReceiptsEnabledType
                Description             = $policy.Description
                Tenant                  = $policy.Tenant
                Ensure                           = "Absent"
                GlobalAdminAccount               = $GlobalAdminAccount
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
        [System.String]
        [ValidateSet('STRICT', 'MODERATE', 'NORESTRICTION')]
        $GiphyRatingType,

        [Parameter()]
        [System.String]
        [ValidateSet('UserPreference', 'Everyone', 'None')]
        $ReadReceiptsEnabledType,

        [Parameter()]
        [System.String[]]
        $Description,

        [Parameter()]
        [System.String[]]
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

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SkypeForBusiness

    $curPolicy = Get-TargetResource @PSBoundParameters

    $SetParams = $PSBoundParameters
    $SetParams.Remove("GlobalAdminAccount") | Out-Null

    if ($curPolicy.Ensure -eq "Absent" -and "Present" -eq $Ensure )
    {
        New-CsTeamsClientConfiguration @SetParams -force:$True
    }
    elseif (($curPolicy.Ensure -eq "Present" -and "Present" -eq $Ensure))
    {
        Set-CsTeamsClientConfiguration @SetParams -force:$True
    }
    elseif (($Ensure -eq "Absent"  -and $curPolicy.Ensure -eq "Present"))
    {
        Remove-CsTeamsClientConfiguration -identity $curPolicy.Identity -force:$True
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
        [System.String]
        [ValidateSet('STRICT', 'MODERATE', 'NORESTRICTION')]
        $GiphyRatingType,

        [Parameter()]
        [System.String]
        [ValidateSet('UserPreference', 'Everyone', 'None')]
        $ReadReceiptsEnabledType,

        [Parameter()]
        [System.String[]]
        $Description,

        [Parameter()]
        [System.String[]]
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

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck

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

    $params = @{
        Identity           = "Global"
        GlobalAdminAccount = $GlobalAdminAccount
    }
    $result = Get-TargetResource @params
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        TeamsMessagingPolicy " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
