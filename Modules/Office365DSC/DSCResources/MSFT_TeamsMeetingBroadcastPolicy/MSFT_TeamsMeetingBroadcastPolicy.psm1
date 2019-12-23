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
        $AllowBroadcastScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowBroadcastTranscription,

        [Parameter()]
        [System.String]
        [ValidateSet("Everyone","EveryoneInCompany","InvitedUsersInCompany","EveryoneInCompanyAndExternal","InvitedUsersInCompanyAndExternal")]
        $BroadcastAttendeeVisibilityMode,

        [Parameter()]
        [System.String]
        [ValidateSet("AlwaysEnabled","AlwaysDisabled","UserOverride")]
        $BroadcastRecordingMode,

        [Parameter()]
        [System.String]
        [ValidateSet("Present", "Absent")]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Teams Meeting Broadcast Policies"

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
        $config = Get-CsTeamsMeetingBroadcastPolicy -Identity $Identity -ErrorAction SilentlyContinue
        if ($null -ne $config)
        {
            return @{
                Identity                        = $config.Identity
                AllowBroadcastScheduling        = $config.AllowBroadcastScheduling
                AllowBroadcastTranscription     = $config.AllowBroadcastTranscription
                BroadcastAttendeeVisibilityMode = $config.BroadcastAttendeeVisibilityMode
                BroadcastRecordingMode          = $config.BroadcastRecordingMode
                Ensure                          = 'Present'
                GlobalAdminAccount              = $GlobalAdminAccount
            }
        }
        return @{
            Identity           = $Identity
            Ensure             = 'Absent'
            GlobalAdminAccount = $GlobalAdminAccount
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
        $AllowBroadcastScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowBroadcastTranscription,

        [Parameter()]
        [System.String]
        [ValidateSet("Everyone","EveryoneInCompany","InvitedUsersInCompany","EveryoneInCompanyAndExternal","InvitedUsersInCompanyAndExternal")]
        $BroadcastAttendeeVisibilityMode,

        [Parameter()]
        [System.String]
        [ValidateSet("AlwaysEnabled","AlwaysDisabled","UserOverride")]
        $BroadcastRecordingMode,

        [Parameter()]
        [System.String]
        [ValidateSet("Present", "Absent")]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Teams Meeting Broadcast Policies"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SkypeForBusiness

    $currentValues = Get-TargetResource @PSBoundParameters
    $IsInDesiredState = Test-TargetResource @PSBoundParameters
    $SetParams = $PSBoundParameters
    $SetParams.Remove("GlobalAdminAccount") | Out-Null
    $SetParams.Remove("Ensure") | Out-Null

    if ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Absent')
    {
        New-CSTeamsMeetingBroadcastPolicy @SetParams
    }
    elseif ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Present')
    {
        if ($IsInDesiredState -eq $false)
        {
            Set-CSTeamsMeetingBroadcastPolicy @SetParams
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentValues.Ensure -eq 'Present')
    {
        Remove-CSTeamsMeetingBroadcastPolicy -Identity $Identity -Confirm:$false
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
        $AllowBroadcastScheduling,

        [Parameter()]
        [System.Boolean]
        $AllowBroadcastTranscription,

        [Parameter()]
        [System.String]
        [ValidateSet("Everyone","EveryoneInCompany","InvitedUsersInCompany","EveryoneInCompanyAndExternal","InvitedUsersInCompanyAndExternal")]
        $BroadcastAttendeeVisibilityMode,

        [Parameter()]
        [System.String]
        [ValidateSet("AlwaysEnabled","AlwaysDisabled","UserOverride")]
        $BroadcastRecordingMode,

        [Parameter()]
        [System.String]
        [ValidateSet("Present", "Absent")]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Teams Meeting Broadcast policies"

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
    $InformationPreference = 'Continue'

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SkypeForBusiness

    [array]$policies = Get-CsTeamsMeetingBroadcastPolicy

    $i = 1
    $content = ''
    foreach ($policy in $policies)
    {
        $params = @{
            Identity           = $policy.Identity
            GlobalAdminAccount = $GlobalAdminAccount
        }
        Write-Information "    [$i/$($policies.Length)] $($policy.Identity)"
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        TeamsMeetingBroadcastPolicy " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $partial = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += $partial
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
