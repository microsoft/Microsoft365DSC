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
        $AllowGiphy,

        [Parameter()]
        [System.String]
        [ValidateSet("Moderate", "Strict", "NoRestriction")]
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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Teams Guest Messaging settings"

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
        $config = Get-CsTeamsGuestMessagingConfiguration

        return @{
            Identity               = $Identity
            AllowUserEditMessage   = $config.AllowUserEditMessage
            AllowUserDeleteMessage = $config.AllowUserDeleteMessage
            AllowUserChat          = $config.AllowUserChat
            AllowGiphy             = $config.AllowGiphy
            GiphyRatingType        = $config.GiphyRatingType
            AllowMemes             = $config.AllowMemes
            AllowStickers          = $config.AllowStickers
            AllowImmersiveReader   = $config.AllowImmersiveReader
            GlobalAdminAccount     = $GlobalAdminAccount
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
        $AllowGiphy,

        [Parameter()]
        [System.String]
        [ValidateSet("Moderate", "Strict", "NoRestriction")]
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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Teams Guest Messaging settings"

    # Check that at least one optional parameter is specified
    $inputValues = $PSBoundParameters
    $inputValues.Remove("GlobalAdminAccount") | Out-Null
    $inputValues.Remove("Identity") | Out-Null
    foreach ($item in $inputValues)
    {
        if ([System.String]::IsNullOrEmpty($item.Value))
        {
            $inputValues.Remove($item.key) | Out-Null
        }
    }

    if ($inputValues.Count -eq 0)
    {
        throw "You need to specify at least one optional parameter for the Set-TargetResource function `
            of the [TeamsGuestMessagingConfiguration] instance {$Identity}"
    }

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SkypeForBusiness

    $SetParams = $PSBoundParameters
    $SetParams.Remove("GlobalAdminAccount") | Out-Null

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
        $AllowGiphy,

        [Parameter()]
        [System.String]
        [ValidateSet("Moderate", "Strict", "NoRestriction")]
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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Teams Guest Messaging settings"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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
    $InformationPreference ='Continue'

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion


    $params = @{
        Identity           = "Global"
        GlobalAdminAccount = $GlobalAdminAccount
    }
    $result = Get-TargetResource @params
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        TeamsGuestMessagingConfiguration " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
