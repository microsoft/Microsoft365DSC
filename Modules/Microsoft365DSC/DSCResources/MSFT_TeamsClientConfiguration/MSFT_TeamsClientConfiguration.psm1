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
        $AllowBox,

        [Parameter()]
        [System.Boolean]
        $AllowDropBox,

        [Parameter()]
        [System.Boolean]
        $AllowEmailIntoChannel,

        [Parameter()]
        [System.Boolean]
        $AllowGoogleDrive,

        [Parameter()]
        [System.Boolean]
        $AllowGuestUser,

        [Parameter()]
        [System.Boolean]
        $AllowOrganizationTab,

        [Parameter()]
        [System.Boolean]
        $AllowResourceAccountSendMessage,

        [Parameter()]
        [System.Boolean]
        $AllowScopedPeopleSearchandAccess,

        [Parameter()]
        [System.Boolean]
        $AllowShareFile,

        [Parameter()]
        [System.Boolean]
        $AllowSkypeBusinessInterop,

        [Parameter()]
        [System.String]
        [ValidateSet('NotRequired', 'RequiredOutsideScheduleMeeting', 'AlwaysRequired')]
        $ContentPin = 'RequiredOutsideScheduledMeeting',

        [Parameter()]
        [System.String]
        [ValidateSet('NoAccess', 'PartialAccess', 'FullAccess')]
        $ResourceAccountContentAccess,

        [Parameter()]
        [System.String[]]
        $RestrictedSenderList = $null,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Teams Client"

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
        $config = Get-CsTeamsClientConfiguration

        $result = @{
            Identity                         = $config.Identity
            AllowBox                         = $config.AllowBox
            AllowDropBox                     = $config.AllowDropBox
            AllowEmailIntoChannel            = $config.AllowEmailIntoChannel
            AllowGoogleDrive                 = $config.AllowGoogleDrive
            AllowGuestUser                   = $config.AllowGuestUser
            AllowOrganizationTab             = $config.AllowOrganizationTab
            AllowResourceAccountSendMessage  = $config.AllowResourceAccountSendMessage
            AllowScopedPeopleSearchandAccess = $config.AllowScopedPeopleSearchandAccess
            AllowShareFile                   = $config.AllowShareFile
            AllowSkypeBusinessInterop        = $config.AllowSkypeBusinessInterop
            ContentPin                       = $config.ContentPin
            ResourceAccountContentAccess     = $config.ResourceAccountContentAccess
            RestrictedSenderList             = $config.RestrictedSenderList
            GlobalAdminAccount               = $GlobalAdminAccount
        }
        if ([System.String]::IsNullOrEmpty($RestrictedSenderList))
        {
            $result.Remove("RestrictedSenderList") | Out-Null
        }
        return $result
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
        $AllowBox,

        [Parameter()]
        [System.Boolean]
        $AllowDropBox,

        [Parameter()]
        [System.Boolean]
        $AllowEmailIntoChannel,

        [Parameter()]
        [System.Boolean]
        $AllowGoogleDrive,

        [Parameter()]
        [System.Boolean]
        $AllowGuestUser,

        [Parameter()]
        [System.Boolean]
        $AllowOrganizationTab,

        [Parameter()]
        [System.Boolean]
        $AllowResourceAccountSendMessage,

        [Parameter()]
        [System.Boolean]
        $AllowScopedPeopleSearchandAccess,

        [Parameter()]
        [System.Boolean]
        $AllowShareFile,

        [Parameter()]
        [System.Boolean]
        $AllowSkypeBusinessInterop,

        [Parameter()]
        [System.String]
        [ValidateSet('NotRequired', 'RequiredOutsideScheduleMeeting', 'AlwaysRequired')]
        $ContentPin = 'RequiredOutsideScheduledMeeting',

        [Parameter()]
        [System.String]
        [ValidateSet('NoAccess', 'PartialAccess', 'FullAccess')]
        $ResourceAccountContentAccess,

        [Parameter()]
        [System.String[]]
        $RestrictedSenderList = $null,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Teams Client"

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

    if ([System.String]::IsNullOrEmpty($RestrictedSenderList))
    {
        $SetParams.Remove("RestrictedSenderList") | Out-Null
    }
    Set-CsTeamsClientConfiguration @SetParams
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
        $AllowBox,

        [Parameter()]
        [System.Boolean]
        $AllowDropBox,

        [Parameter()]
        [System.Boolean]
        $AllowEmailIntoChannel,

        [Parameter()]
        [System.Boolean]
        $AllowGoogleDrive,

        [Parameter()]
        [System.Boolean]
        $AllowGuestUser,

        [Parameter()]
        [System.Boolean]
        $AllowOrganizationTab,

        [Parameter()]
        [System.Boolean]
        $AllowResourceAccountSendMessage,

        [Parameter()]
        [System.Boolean]
        $AllowScopedPeopleSearchandAccess,

        [Parameter()]
        [System.Boolean]
        $AllowShareFile,

        [Parameter()]
        [System.Boolean]
        $AllowSkypeBusinessInterop,

        [Parameter()]
        [System.String]
        [ValidateSet('NotRequired', 'RequiredOutsideScheduleMeeting', 'AlwaysRequired')]
        $ContentPin = 'RequiredOutsideScheduledMeeting',

        [Parameter()]
        [System.String]
        [ValidateSet('NoAccess', 'PartialAccess', 'FullAccess')]
        $ResourceAccountContentAccess,

        [Parameter()]
        [System.String[]]
        $RestrictedSenderList = $null,

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

    if ([System.String]::IsNullOrEmpty($RestrictedSenderList))
    {
        $ValuesToCheck.Remove("RestrictedSenderList") | Out-Null
    }
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
    $content = "        TeamsClientConfiguration " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
