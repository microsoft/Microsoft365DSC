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
        $AllowSdnProviderForBroadcastMeeting,

        [Parameter()]
        [System.String]
        $SupportURL,

        [Parameter()]
        [System.String]
        $SdnName,

        [Parameter()]
        [System.String]
        $SdnLicenseId,

        [Parameter()]
        [System.String]
        $SdnApiTemplateUrl,

        [Parameter()]
        [System.String]
        $SdnApiToken,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Teams Meeting Broadcast"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform SkypeForBusiness

    try
    {
        $config = Get-CsTeamsMeetingBroadcastConfiguration -ExposeSDNConfigurationJsonBlob

        return @{
            Identity                            = $config.Identity
            AllowSdnProviderForBroadcastMeeting = $config.AllowSdnProviderForBroadcastMeeting
            SdnName                             = $config.SdnName
            SdnLicenseId                        = $config.SdnLicenseId
            SdnApiTemplateUrl                   = $config.SdnApiTemplateUrl
            SdnApiToken                         = $config.SdnApiToken
            GlobalAdminAccount                  = $GlobalAdminAccount
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
        $AllowSdnProviderForBroadcastMeeting,

        [Parameter()]
        [System.String]
        $SupportURL,

        [Parameter()]
        [System.String]
        $SdnName,

        [Parameter()]
        [System.String]
        $SdnLicenseId,

        [Parameter()]
        [System.String]
        $SdnApiTemplateUrl,

        [Parameter()]
        [System.String]
        $SdnApiToken,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Teams Meeting Broadcast"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SkypeForBusiness

    $SetParams = $PSBoundParameters
    $SetParams.Remove("GlobalAdminAccount")

    Set-CsTeamsMeetingBroadcastConfiguration @SetParams
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
        $AllowSdnProviderForBroadcastMeeting,

        [Parameter()]
        [System.String]
        $SupportURL,

        [Parameter()]
        [System.String]
        $SdnName,

        [Parameter()]
        [System.String]
        $SdnLicenseId,

        [Parameter()]
        [System.String]
        $SdnApiTemplateUrl,

        [Parameter()]
        [System.String]
        $SdnApiToken,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Teams Client"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
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
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    $params = @{
        Identity           = "Global"
        GlobalAdminAccount = $GlobalAdminAccount
    }
    $result = Get-TargetResource @params
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        TeamsMeetingBroadcastConfiguration " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
