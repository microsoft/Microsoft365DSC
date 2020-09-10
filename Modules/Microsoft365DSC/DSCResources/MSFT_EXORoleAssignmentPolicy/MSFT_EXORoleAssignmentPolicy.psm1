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
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.String[]]
        $Roles,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting Role Assignment Policy configuration for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $AllRoleAssignmentPolicies = Get-RoleAssignmentPolicy

    $RoleAssignmentPolicy = $AllRoleAssignmentPolicies | Where-Object -FilterScript { $_.Name -eq $Name }

    if ($null -eq $RoleAssignmentPolicy)
    {
        Write-Verbose -Message "Role Assignment Policy $($Name) does not exist."

        $nullReturn = @{
            Name               = $Name
            Description        = $Description
            IsDefault          = $IsDefault
            Roles              = $Roles
            Ensure             = 'Absent'
            GlobalAdminAccount = $GlobalAdminAccount
        }

        return $nullReturn
    }
    else
    {
        $result = @{
            Name               = $RoleAssignmentPolicy.Name
            Description        = $RoleAssignmentPolicy.Description
            IsDefault          = $RoleAssignmentPolicy.IsDefault
            Roles              = $RoleAssignmentPolicy.AssignedRoles
            Ensure             = 'Present'
            GlobalAdminAccount = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found Role Assignment Policy $($Name)"
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
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.String[]]
        $Roles,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Role Assignment Policy configuration for $Name"

    $currentRoleAssignmentPolicyConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $NewRoleAssignmentPolicyParams = @{
        Name        = $Name
        Description = $Description
        IsDefault   = $IsDefault
        Roles       = $Roles
        Confirm     = $false
    }

    $SetRoleAssignmentPolicyParams = @{
        Identity    = $Name
        Name        = $Name
        Description = $Description
        IsDefault   = $IsDefault
        Roles       = $Roles
        Confirm     = $false
    }

    # CASE: Role Assignment Policy doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentRoleAssignmentPolicyConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Role Assignment Policy '$($Name)' does not exist but it should. Create and configure it."
        # Create Role Assignment Policy
        New-RoleAssignmentPolicy @NewRoleAssignmentPolicyParams
    }
    # CASE: Role Assignment Policy exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentRoleAssignmentPolicyConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Role Assignment Policy '$($Name)' exists but it shouldn't. Remove it."
        Remove-RoleAssignmentPolicy -Identity $Name -Confirm:$false
    }
    # CASE: Role Assignment Policy exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentRoleAssignmentPolicyConfig.Ensure -eq "Present" -and $null -eq (Compare-Object -ReferenceObject $($currentRoleAssignmentPolicyConfig.Roles) -DifferenceObject $Roles))
    {
        Write-Verbose -Message "Role Assignment Policy '$($Name)' already exists, but needs updating."
        Write-Verbose -Message "Setting Role Assignment Policy $($Name) with values: $(Convert-M365DscHashtableToString -Hashtable $SetRoleAssignmentPolicyParams)"
        Set-RoleAssignmentPolicy @SetRoleAssignmentPolicyParams
    }
    # CASE: Role Assignment Policy exists and it should, but Roles attribute has different values than the desired ones
    # Set-RoleAssignmentPolicy cannot change Roles attribute. Therefore we have to remove and recreate the policy if Roles attribute should be changed.
    elseif ($Ensure -eq "Present" -and $currentRoleAssignmentPolicyConfig.Ensure -eq "Present" -and $null -ne (Compare-Object -ReferenceObject $($currentRoleAssignmentPolicyConfig.Roles) -DifferenceObject $Roles))
    {
        Write-Verbose -Message "Role Assignment Policy '$($Name)' already exists, but roles attribute needs updating."
        Write-Verbose -Message "Remove Role AssignmentPolicy before recreating because Roles attribute cannot be change with Set cmdlet"
        Remove-RoleAssignmentPolicy -Identity $Name -Confirm:$false
        New-RoleAssignmentPolicy @NewRoleAssignmentPolicyParams
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
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.String[]]
        $Roles,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Role Assignment Policy configuration for $Name"

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

    [array]$AllRoleAssignmentPolicies = Get-RoleAssignmentPolicy

    $dscContent = ""
    $i = 1
    foreach ($RoleAssignmentPolicy in $AllRoleAssignmentPolicies)
    {
        Write-Information "    [$i/$($AllRoleAssignmentPolicies.Count)] $($RoleAssignmentPolicy.Name)"

        $Params = @{
            Name               = $RoleAssignmentPolicy.Name
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        EXORoleAssignmentPolicy " + (New-GUID).ToString() + "`r`n"
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

