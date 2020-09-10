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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Teams Meeting"

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
        $config = Get-CsTeamsMeetingConfiguration

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
            GlobalAdminAccount          = $GlobalAdminAccount
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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Teams Meetings"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SkypeForBusiness

    $SetParams = $PSBoundParameters
    $SetParams.Remove("GlobalAdminAccount")

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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Teams Client"

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
    $content = "        TeamsMeetingConfiguration " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
