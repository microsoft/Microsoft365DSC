function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String[]]
        $Domains,

        [Parameter()]
        [System.Boolean]
        $Default,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting Sharing Policy configuration for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $AllSharingPolicies = Get-SharingPolicy

    $SharingPolicy = $AllSharingPolicies | Where-Object -FilterScript { $_.Name -eq $Name }

    if ($null -eq $SharingPolicy)
    {
        Write-Verbose -Message "Sharing Policy $($Name) does not exist."

        $nullReturn = @{
            Name               = $Name
            Default            = $Default
            Domains            = $Domains
            Enabled            = $Enabled
            Ensure             = 'Absent'
            GlobalAdminAccount = $GlobalAdminAccount
        }

        return $nullReturn
    }
    else
    {
        $result = @{
            Name               = $SharingPolicy.Name
            Default            = $SharingPolicy.Default
            Domains            = $SharingPolicy.Domains
            Enabled            = $SharingPolicy.Enabled
            Ensure             = 'Present'
            GlobalAdminAccount = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found Sharing Policy $($Name)"
        return $result
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String[]]
        $Domains,

        [Parameter()]
        [System.Boolean]
        $Default,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Sharing Policy configuration for $Name"

    $currentSharingPolicyConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $NewSharingPolicyParams = @{
        Name    = $Name
        Domains = $Domains
        Enabled = $Enabled
        Default = $Default
        Confirm = $false
    }

    $SetSharingPolicyParams = @{
        Identity = $Name
        Name     = $Name
        Domains  = $Domains
        Enabled  = $Enabled
        Default  = $Default
        Confirm  = $false
    }

    # CASE: Sharing Policy doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentSharingPolicyConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Sharing Policy '$($Name)' does not exist but it should. Create and configure it."
        # Create Sharing Policy
        New-SharingPolicy @NewSharingPolicyParams

    }
    # CASE: Sharing Policy exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentSharingPolicyConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Sharing Policy '$($Name)' exists but it shouldn't. Remove it."
        Remove-SharingPolicy -Identity $Name -Confirm:$false
    }
    # CASE: Sharing Policy exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentSharingPolicyConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Sharing Policy '$($Name)' already exists, but needs updating."
        Write-Verbose -Message "Setting Sharing Policy $($Name) with values: $(Convert-M365DscHashtableToString -Hashtable $SetSharingPolicyParams)"
        Set-SharingPolicy @SetSharingPolicyParams
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String[]]
        $Domains,

        [Parameter()]
        [System.Boolean]
        $Default,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Sharing Policy configuration for $Name"

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

    [array]$AllSharingPolicies = Get-SharingPolicy

    $dscContent = ""
    $i = 1
    foreach ($SharingPolicy in $AllSharingPolicies)
    {
        Write-Information "    [$i/$($AllSharingPolicies.Count)] $($SharingPolicy.Name)"

        $Params = @{
            Name               = $SharingPolicy.Name
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        EXOSharingPolicy " + (New-GUID).ToString() + "`r`n"
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

