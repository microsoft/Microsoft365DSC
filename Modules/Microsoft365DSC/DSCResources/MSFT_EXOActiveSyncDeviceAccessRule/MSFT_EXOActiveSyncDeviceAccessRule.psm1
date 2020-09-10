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
        [ValidateSet('Allow', 'Block', 'Quarantine')]
        [System.String]
        $AccessLevel,

        [Parameter()]
        [ValidateSet('DeviceModel', 'DeviceType', 'DeviceOS', 'UserAgent', 'XMSWLHeader')]
        [System.String]
        $Characteristic,

        [Parameter()]
        [System.String]
        $QueryString,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting Active Sync Device Access Rule configuration for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $AllActiveSyncDeviceAccessRules = Get-ActiveSyncDeviceAccessRule

    $ActiveSyncDeviceAccessRule = $AllActiveSyncDeviceAccessRules | Where-Object -FilterScript { $_.Identity -eq $Identity }

    if ($null -eq $ActiveSyncDeviceAccessRule)
    {
        Write-Verbose -Message "Active Sync Device Access Rule $($Identity) does not exist."

        $nullReturn = @{
            Identity           = $Identity
            AccessLevel        = $AccessLevel
            Characteristic     = $Characteristic
            QueryString        = $QueryString
            Ensure             = 'Absent'
            GlobalAdminAccount = $GlobalAdminAccount
        }

        return $nullReturn
    }
    else
    {
        $result = @{
            Identity           = $ActiveSyncDeviceAccessRule.Identity
            AccessLevel        = $ActiveSyncDeviceAccessRule.AccessLevel
            Characteristic     = $ActiveSyncDeviceAccessRule.Characteristic
            QueryString        = $ActiveSyncDeviceAccessRule.QueryString
            Ensure             = 'Present'
            GlobalAdminAccount = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found Active Sync Device Access Rule $($Identity)"
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
        $Identity,

        [Parameter()]
        [ValidateSet('Allow', 'Block', 'Quarantine')]
        [System.String]
        $AccessLevel,

        [Parameter()]
        [ValidateSet('DeviceModel', 'DeviceType', 'DeviceOS', 'UserAgent', 'XMSWLHeader')]
        [System.String]
        $Characteristic,

        [Parameter()]
        [System.String]
        $QueryString,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Active Sync Device Access Rule configuration for $Identity"

    $currentActiveSyncDeviceAccessRuleConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $NewActiveSyncDeviceAccessRuleParams = @{
        AccessLevel    = $AccessLevel
        Characteristic = $Characteristic
        QueryString    = $QueryString
        Confirm        = $false
    }

    $SetActiveSyncDeviceAccessRuleParams = @{
        Identity       = $Identity
        AccessLevel    = $AccessLevel
        Characteristic = $Characteristic
        QueryString    = $QueryString
        Confirm        = $false
    }

    # CASE: Active Sync Device Access Rule doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentActiveSyncDeviceAccessRuleConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Active Sync Device Access Rule '$($Identity)' does not exist but it should. Create and configure it."
        # Create Active Sync Device Access Rule
        New-ActiveSyncDeviceAccessRule @NewActiveSyncDeviceAccessRuleParams

    }
    # CASE: Active Sync Device Access Rule exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentActiveSyncDeviceAccessRuleConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Active Sync Device Access Rule '$($Identity)' exists but it shouldn't. Remove it."
        Remove-ActiveSyncDeviceAccessRule -Identity $Identity -Confirm:$false
    }
    # CASE: Active Sync Device Access Rule exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentActiveSyncDeviceAccessRuleConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Active Sync Device Access Rule '$($Identity)' already exists, but needs updating."
        Write-Verbose -Message "Setting Active Sync Device Access Rule $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $SetActiveSyncDeviceAccessRuleParams)"
        Set-ActiveSyncDeviceAccessRule @SetActiveSyncDeviceAccessRuleParams
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
        [ValidateSet('Allow', 'Block', 'Quarantine')]
        [System.String]
        $AccessLevel,

        [Parameter()]
        [ValidateSet('DeviceModel', 'DeviceType', 'DeviceOS', 'UserAgent', 'XMSWLHeader')]
        [System.String]
        $Characteristic,

        [Parameter()]
        [System.String]
        $QueryString,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Active Sync Device Access Rule configuration for $Identity"

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
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    [array]$AllActiveSyncDeviceAccessRules = Get-ActiveSyncDeviceAccessRule

    $dscContent = ""
    $i = 1
    foreach ($ActiveSyncDeviceAccessRule in $AllActiveSyncDeviceAccessRules)
    {
        Write-Information "    [$i/$($AllActiveSyncDeviceAccessRules.Count)] $($ActiveSyncDeviceAccessRule.Identity)"

        $Params = @{
            Identity           = $ActiveSyncDeviceAccessRule.Identity
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        EXOActiveSyncDeviceAccessRule " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $dscContent += $content
        $i++
    }
    return $dscContent
}

Export-ModuleMember -Function *-TargetResource

