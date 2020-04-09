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
        [ValidateSet('RestrictAccess', 'DenyAccess')]
        [System.String]
        $AccessRight,

        [Parameter()]
        [System.String[]]
        $AppID,

        [Parameter()]
        [System.String]
        $PolicyScopeGroupId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting Application Access Policy configuration for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $nullReturn = @{
        Identity           = $Identity
        AccessRight        = $AccessRight
        AppID              = $AppID
        PolicyScopeGroupId = $PolicyScopeGroupId
        Description        = $Description
        Ensure             = 'Absent'
        GlobalAdminAccount = $GlobalAdminAccount
    }

    try
    {
        $AllApplicationAccessPolicies = Get-ApplicationAccessPolicy -ErrorAction Stop
    }
    catch
    {
        if ($_.Exception -like "The operation couldn't be performed because object*")
        {
            Write-Verbose "Could not obtain Application Access Policies for Tenant"
            return $nullReturn
        }
    }


    $ApplicationAccessPolicy = $AllApplicationAccessPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }

    if ($null -eq $ApplicationAccessPolicy)
    {
        Write-Verbose -Message "Application Access Policy $($Identity) does not exist."
        return $nullReturn
    }
    else
    {
        $result = @{
            Identity           = $ApplicationAccessPolicy.Identity
            AccessRight        = $ApplicationAccessPolicy.AccessRight
            AppID              = $ApplicationAccessPolicy.AppID
            PolicyScopeGroupId = $ApplicationAccessPolicy.ScopeIdentity
            Description        = $ApplicationAccessPolicy.Description
            Ensure             = 'Present'
            GlobalAdminAccount = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found Application Access Policy $($Identity)"
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
        [ValidateSet('RestrictAccess', 'DenyAccess')]
        [System.String]
        $AccessRight,

        [Parameter()]
        [System.String[]]
        $AppID,

        [Parameter()]
        [System.String]
        $PolicyScopeGroupId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Application Access Policy configuration for $Identity"

    $currentApplicationAccessPolicyConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $NewApplicationAccessPolicyParams = @{
        AccessRight        = $AccessRight
        AppID              = $AppID
        PolicyScopeGroupId = $PolicyScopeGroupId
        Description        = $Description
        Confirm            = $false
    }

    $SetApplicationAccessPolicyParams = @{
        Identity    = $Identity
        Description = $Description
        Confirm     = $false
    }

    # CASE: Application Access Policy doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentApplicationAccessPolicyConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Application Access Policy '$($Identity)' does not exist but it should. Create and configure it."
        # Create Application Access Policy
        New-ApplicationAccessPolicy @NewApplicationAccessPolicyParams

    }
    # CASE: Application Access Policy exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentApplicationAccessPolicyConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Application Access Policy '$($Identity)' exists but it shouldn't. Remove it."
        Remove-ApplicationAccessPolicy -Identity $Identity -Confirm:$false
    }
    # CASE: Application Access Policy exists and it should, but Description attribute has different values than desired (Set-ApplicationAccessPolicy is only able to change description attribute)
    elseif ($Ensure -eq "Present" -and $currentApplicationAccessPolicyConfig.Ensure -eq "Present" -and $currentApplicationAccessPolicyConfig.Description -ne $Description)
    {
        Write-Verbose -Message "Application Access Policy '$($Identity)' already exists, but needs updating."
        Write-Verbose -Message "Setting Application Access Policy $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $SetApplicationAccessPolicyParams)"
        Set-ApplicationAccessPolicy @SetApplicationAccessPolicyParams
    }
    # CASE: Application Access Policy exists and it should, but has different values than the desired one
    # Set-ApplicationAccessPolicy is only able to change description attribute, therefore re-create policy
    elseif ($Ensure -eq "Present" -and $currentApplicationAccessPolicyConfig.Ensure -eq "Present" -and $currentApplicationAccessPolicyConfig.Description -eq $Description)
    {
        Write-Verbose -Message "Re-create Application Access Policy '$($Identity)'"
        Remove-ApplicationAccessPolicy -Identity $Identity -Confirm:$false
        New-ApplicationAccessPolicy @NewApplicationAccessPolicyParams
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
        [ValidateSet('RestrictAccess', 'DenyAccess')]
        [System.String]
        $AccessRight,

        [Parameter()]
        [System.String[]]
        $AppID,

        [Parameter()]
        [System.String]
        $PolicyScopeGroupId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Application Access Policy configuration for $Identity"

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

    try
    {
        [array]$AllApplicationAccessPolicies = Get-ApplicationAccessPolicy -ErrorAction Stop
    }
    catch
    {
        if ($_.Exception -like "*The operation couldn't be performed because object*")
        {
            Write-Verbose "Could not obtain Application Access Policies for Tenant"
            return ""
        }
        throw $_
    }

    $dscContent = ""
    $i = 1
    foreach ($ApplicationAccessPolicy in $AllApplicationAccessPolicies)
    {
        Write-Information "    [$i/$($AllApplicationAccessPolicies.Count)] $($ApplicationAccessPolicy.Identity)"

        $Params = @{
            Identity           = $ApplicationAccessPolicy.Identity
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        EXOApplicationAccessPolicy " + (New-GUID).ToString() + "`r`n"
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

