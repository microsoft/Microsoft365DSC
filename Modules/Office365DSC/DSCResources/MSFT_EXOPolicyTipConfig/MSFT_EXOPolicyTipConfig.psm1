function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting Policy Tip configuration for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $AllPolicyTips = Get-PolicyTipConfig

    $PolicyTipConfig = $AllPolicyTips | Where-Object -FilterScript { $_.Name -eq $Name }

    if ($null -eq $PolicyTipConfig)
    {
        Write-Verbose -Message "Policy Tip Config $($Name) does not exist."

        $nullReturn = @{
            Name               = $Name
            Value              = $Value
            Ensure             = 'Absent'
            GlobalAdminAccount = $GlobalAdminAccount
        }

        return $nullReturn
    }
    else
    {
        $result = @{
            Name               = $PolicyTipConfig.Name
            Value              = $PolicyTipConfig.Value
            Ensure             = 'Present'
            GlobalAdminAccount = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found Policy Tip Config $($Name)"
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
        $Name,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Policy Tip config for $Name"

    $currentPolicyTipConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $NewPolicyTipConfigParams = @{
        Name    = $Name
        Value   = $Value
        Confirm = $false
    }

    $SetPolicyTipConfigParams = @{
        Identity = $Name
        Value    = $Value
        Confirm  = $false
    }

    # CASE: Policy Tip Config doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentPolicyTipConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Policy Tip Config '$($Name)' does not exist but it should. Create and configure it."
        # Create Policy Tip Config
        New-PolicyTipConfig @NewPolicyTipConfigParams

    }
    # CASE: Policy Tip Config exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentPolicyTipConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Policy Tip Config '$($Name)' exists but it shouldn't. Remove it."
        Remove-PolicyTipConfig -Identity $Name -Confirm:$false
    }
    # CASE: Policy Tip Config exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentPolicyTipConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Policy Tip Config '$($Name)' already exists, but needs updating."
        Write-Verbose -Message "Setting Policy Tip Config $($Name) with values: $(Convert-O365DscHashtableToString -Hashtable $SetPolicyTipConfigParams)"
        Set-PolicyTipConfig @SetPolicyTipConfigParams
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
        $Name,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Policy Tip Config for $Name"

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
    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform ExchangeOnline

    [array]$AllPolicyTips = Get-PolicyTipConfig

    $dscContent = ""
    $i = 1
    foreach ($PolicyTipConfig in $AllPolicyTips)
    {
        Write-Information "    [$i/$($AllPolicyTips.Count)] $($PolicyTipConfig.Name)"

        $Params = @{
            Name               = $PolicyTipConfig.Name
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        EXOPolicyTipConfig " + (New-GUID).ToString() + "`r`n"
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

