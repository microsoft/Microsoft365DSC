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
        [System.String[]]
        $Users,

        [Parameter()]
        [System.Boolean]
        $MigrateMeetingsToTeams,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Write-Verbose -Message "Checking the Teams Upgrade Policies"
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -Platform SkypeForBusiness

    $policy = Get-CsTeamsUpgradePolicy -Identity $Identity -ErrorAction SilentlyContinue
    [array]$users = Get-CSOnlineUser | Where-Object -Filter {$_.TeamsUpgradePolicy -eq $Identity}

    if ($null -eq $policy)
    {
        throw "No Teams Upgrade Policy with Identity {$Identity} was found"
    }

    [array]$usersList = @()
    foreach ($user in $users)
    {
        $usersList += $user.UserPrincipalName
    }
    Write-Verbose -Message "Found Teams Upgrade Policy with Identity {$Identity}"
    return @{
        Identity               = $Identity
        Users                  = $usersList
        MigrateMeetingsToTeams = $MigrateMeetingsToTeams
        GlobalAdminAccount     = $GlobalAdminAccount
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
        [System.String[]]
        $Users,

        [Parameter()]
        [System.Boolean]
        $MigrateMeetingsToTeams,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Write-Verbose -Message "Updating Teams Upgrade Policy {$Identity}"

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -Platform SkypeForBusiness

    foreach ($user in $Users)
    {
        Write-Verbose -Message "Granting TeamsUpgradePolicy {$Identity} to User {$user} with MigrateMeetingsToTeams=$MigrateMeetingsToTeams"
        Grant-CSTeamsUpgradePolicy -PolicyName $Identity -Identity $user -MigrateMeetingsToTeams:$MigrateMeetingsToTeams
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
        [System.String[]]
        $Users,

        [Parameter()]
        [System.Boolean]
        $MigrateMeetingsToTeams,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Team Upgrade Policy {$Identity}"

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
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $InformationPreference = 'Continue'
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -Platform SkypeForBusiness
    [array]$policies = Get-CsTeamsUpgradePolicy
    $i = 1
    $content = ''
    foreach ($policy in $policies)
    {
        Write-Information "    -[$i/$($policies.Count)] $($policy.Identity.Replace('Tag:', ''))"
        $params = @{
            Identity           = $policy.Identity.Replace("Tag:", "")
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        TeamsUpgradePolicy " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
