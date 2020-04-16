function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $OrgWideAccount,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Availability Config for $OrgWideAccount"

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $AvailabilityConfigs = Get-AvailabilityConfig

    $AvailabilityConfig = ($AvailabilityConfigs | Where-Object -FilterScript { $_.OrgWideAccount -IMatch $OrgWideAccount })

    if ($null -eq $AvailabilityConfig)
    {
        Write-Verbose -Message "Availability config for $($OrgWideAccount) does not exist."

        $nullReturn = @{
            OrgWideAccount     = $OrgWideAccount
            Ensure             = 'Absent'
            GlobalAdminAccount = $GlobalAdminAccount
        }

        return $nullReturn
    }
    else
    {
        $result = @{
            OrgWideAccount     = $AvailabilityConfig.OrgWideAccount
            Ensure             = 'Present'
            GlobalAdminAccount = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found Availability Config for $($OrgWideAccount)"
        return $result
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $OrgWideAccount,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Availability Config for account $OrgWideAccount"

    $currentAvailabilityConfig = Get-TargetResource @PSBoundParameters

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    # CASE: Availability Config doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentAvailabilityConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Availability Config '$($OrgWideAccount)' does not exist but it should. Create it."
        New-AvailabilityConfig -OrgWideAccount $OrgWideAccount
    }
    # CASE: Availability Config exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentAvailabilityConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Availability Config '$($OrgWideAccount)' exists but it shouldn't. Remove it."
        Remove-AvailabilityConfig -Confirm:$false
    }
    # CASE: Availability Config exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentAvailabilityConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Availability Config '$($OrgWideAccount)' already exists, but needs updating."
        Set-AvailabilityConfig -OrgWideAccount $OrgWideAccount -Confirm:$false
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
        $OrgWideAccount,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Availability Config for account $OrgWideAccount"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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
        -Platform ExchangeOnline

    $AvailabilityConfig = Get-AvailabilityConfig

    if ($null -eq $AvailabilityConfig)
    {
        return ""
    }

    $Params = @{
        OrgWideAccount     = $AvailabilityConfig.OrgWideAccount.ToString()
        GlobalAdminAccount = $GlobalAdminAccount
    }

    $result = Get-TargetResource @Params
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        EXOAvailabilityConfig " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource

