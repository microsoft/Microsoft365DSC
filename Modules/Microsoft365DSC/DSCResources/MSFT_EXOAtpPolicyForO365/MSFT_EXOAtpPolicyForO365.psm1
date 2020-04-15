function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $Identity = 'Default',

        [Parameter()]
        [Boolean]
        $AllowClickThrough = $true,

        [Parameter()]
        [System.String[]]
        $BlockUrls = @(),

        [Parameter()]
        [Boolean]
        $EnableATPForSPOTeamsODB = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForClients = $false,

        [Parameter()]
        [Boolean]
        $TrackClicks = $true,

        [Parameter()]
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of AtpPolicyForO365 for $Identity"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    try
    {
        $nullReturn = $PSBoundParameters
        $nullReturn.Ensure = 'Absent'
        $AtpPolicies = Get-AtpPolicyForO365

        $AtpPolicyForO365 = $AtpPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
        if (-not $AtpPolicyForO365)
        {
            Write-Verbose -Message "AtpPolicyForO365 $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                IsSingleInstance          = "Yes"
                Identity                  = $AtpPolicyForO365.Identity
                AllowClickThrough         = $AtpPolicyForO365.AllowClickThrough
                BlockUrls                 = $AtpPolicyForO365.BlockUrls
                EnableATPForSPOTeamsODB   = $AtpPolicyForO365.EnableATPForSPOTeamsODB
                EnableSafeLinksForClients = $AtpPolicyForO365.EnableSafeLinksForClients
                TrackClicks               = $AtpPolicyForO365.TrackClicks
                Ensure                    = 'Present'
            }

            Write-Verbose -Message "Found AtpPolicyForO365 $($Identity)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        Write-Warning $_.Exception
        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $Identity = 'Default',

        [Parameter()]
        [Boolean]
        $AllowClickThrough = $true,

        [Parameter()]
        [System.String[]]
        $BlockUrls = @(),

        [Parameter()]
        [Boolean]
        $EnableATPForSPOTeamsODB = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForClients = $false,

        [Parameter()]
        [Boolean]
        $TrackClicks = $true,

        [Parameter()]
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of AtpPolicyForO365 for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    if ('Default' -ne $Identity)
    {
        throw "EXOAtpPolicyForO365 configurations MUST specify Identity value of 'Default'"
    }

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $AtpPolicyParams = $PSBoundParameters
    $AtpPolicyParams.Remove('Ensure') | Out-Null
    $AtpPolicyParams.Remove('GlobalAdminAccount') | Out-Null
    $AtpPolicyParams.Remove('IsSingleInstance') | Out-Null
    Write-Verbose -Message "Setting AtpPolicyForO365 $Identity with values: $(Convert-M365DscHashtableToString -Hashtable $AtpPolicyParams)"
    Set-AtpPolicyForO365 @AtpPolicyParams
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $Identity = 'Default',

        [Parameter()]
        [Boolean]
        $AllowClickThrough = $true,

        [Parameter()]
        [System.String[]]
        $BlockUrls = @(),

        [Parameter()]
        [Boolean]
        $EnableATPForSPOTeamsODB = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForClients = $false,

        [Parameter()]
        [Boolean]
        $TrackClicks = $true,

        [Parameter()]
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of AtpPolicyForO365 for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('IsSingleInstance') | Out-Null
    $ValuesToCheck.Remove('Verbose') | Out-Null

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
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $organization = ""
    $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
    if ($GlobalAdminAccount.UserName.Contains("@"))
    {
        $organization = $GlobalAdminAccount.UserName.Split("@")[1]

        if ($organization.IndexOf(".") -gt 0)
        {
            $principal = $organization.Split(".")[0]
        }
    }
    if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-AtpPolicyForO365)
    {
        $ATPPolicies = Get-AtpPolicyForO365
        $content = ""
        foreach ($atpPolicy in $ATPPolicies)
        {
            $params = @{
                IsSingleInstance   = 'Yes'
                Identity           = $atpPolicy.Identity
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            if ($result.Ensure -eq "Present")
            {
                $organization = $GlobalAdminAccount.UserName.Split("@")[1]
                $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
                $content += "        EXOAtpPolicyForO365 " + (New-GUID).ToString() + "`r`n"
                $content += "        {`r`n"
                $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GlobalAdminAccount'
                if ($currentDSCBlock.ToLower().IndexOf($organization.ToLower()) -gt 0)
                {
                    $currentDSCBlock = $currentDSCBlock -ireplace [regex]::Escape($organization), "`$OrganizationName"
                }
                $content += $currentDSCBlock
                $content += "        }`r`n"
            }
        }
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
