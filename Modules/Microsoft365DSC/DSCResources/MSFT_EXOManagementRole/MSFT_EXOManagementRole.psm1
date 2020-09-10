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
        $Parent,

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

    Write-Verbose -Message "Getting Management Role configuration for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $AllManagementRoles = Get-ManagementRole

    $ManagementRole = $AllManagementRoles | Where-Object -FilterScript { $_.Name -eq $Name }

    if ($null -eq $ManagementRole)
    {
        Write-Verbose -Message "Management Role $($Name) does not exist."

        $nullReturn = @{
            Name               = $Name
            Parent             = $Parent
            Description        = $Description
            Ensure             = 'Absent'
            GlobalAdminAccount = $GlobalAdminAccount
        }

        return $nullReturn
    }
    else
    {
        $result = @{
            Name               = $ManagementRole.Name
            Parent             = $ManagementRole.Parent
            Description        = $ManagementRole.Description
            Ensure             = 'Present'
            GlobalAdminAccount = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found Management Role $($Name)"
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
        $Parent,

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

    Write-Verbose -Message "Setting Management Role configuration for $Name"

    $currentManagementRoleConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $NewManagementRoleParams = @{
        Name        = $Name
        Parent      = $Parent
        Description = $Description
        Confirm     = $false
    }

    # CASE: Management Role doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentManagementRoleConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Management Role '$($Name)' does not exist but it should. Create and configure it."
        # Create Management Role
        New-ManagementRole @NewManagementRoleParams

    }
    # CASE: Management Role exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentManagementRoleConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Management Role '$($Name)' exists but it shouldn't. Remove it."
        Remove-ManagementRole -Identity $Name -Confirm:$false -Force
    }
    # CASE: Management Role exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentManagementRoleConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Management Role '$($Name)' already exists, but needs updating. Re-create management role."
        Write-Verbose -Message "Setting Management Role $($Name) with values: $(Convert-M365DscHashtableToString -Hashtable $NewManagementRoleParams)"
        # Since there is no Set-ManagementRole cmdlet available, remove management role and re-create it
        Remove-ManagementRole -Identity $Name -Confirm:$false -Force
        New-ManagementRole @NewManagementRoleParams
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
        $Parent,

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

    Write-Verbose -Message "Testing Management Role configuration for $Name"

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

    [array]$AllManagementRoles = Get-ManagementRole

    $dscContent = ""
    $i = 1
    foreach ($ManagementRole in $AllManagementRoles)
    {
        Write-Information "    [$i/$($AllManagementRoles.Count)] $($ManagementRole.Name)"

        $Params = @{
            Name               = $ManagementRole.Name
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        EXOManagementRole " + (New-GUID).ToString() + "`r`n"
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

