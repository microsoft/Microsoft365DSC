function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Exchange', 'SharePoint', 'OneDriveForBusiness')]
        [System.String]
        $Workload,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of SCAuditConfigurationPolicy for Workload {$Workload}"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    $PolicyObject = $null
    $WorkloadValue = $Workload
    if ($Workload -eq 'OneDriveForBusiness')
    {
        $PolicyObject = Get-AuditConfigurationPolicy | Where-Object -FilterScript { $_.Name -eq 'a415dcce-19a0-4153-b137-eb6fd67995b5' }
        $WorkloadValue = 'OneDriveForBusiness'
    }
    else
    {
        $PolicyObject = Get-AuditConfigurationPolicy | Where-Object -FilterScript { $_.Workload -eq $Workload }
    }


    if ($null -eq $PolicyObject)
    {
        Write-Verbose -Message "SCAuditConfigurationPolicy $Workload does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        Write-Verbose "Found existing SCAuditConfigurationPolicy $Workload"
        $result = @{
            Ensure             = 'Present'
            Workload           = $WorkloadValue
            GlobalAdminAccount = $GlobalAdminAccount
        }

        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
    }
}

function Set-TargetResource
{

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Exchange', 'SharePoint', 'OneDriveForBusiness')]
        [System.String]
        $Workload,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of SCAuditConfigurationPolicy for $Workload"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    $CurrentPolicy = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentPolicy.Ensure))
    {
        $CreationParams = @{Workload = $Workload }
        New-AuditConfigurationPolicy @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        Write-Verbose "SCAuditConfigurationPolicy already exists for Workload {$Workload}"
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        # If the Policy exists and it shouldn't, simply remove it;
        Write-Verbose "Removing SCAuditConfigurationPolicy for Workload {$Workload}"
        if ($Workload -eq 'OneDriveForBusiness')
        {
            $policy = Get-AuditConfigurationPolicy | Where-Object -FilterScript { $_.Name -eq 'a415dcce-19a0-4153-b137-eb6fd67995b5' }
        }
        else
        {
            $policy = Get-AuditConfigurationPolicy | Where-Object -FilterScript { $_.Workload -eq $CurrentPolicy.Workload }
        }

        try
        {
            Remove-AuditConfigurationPolicy -Identity $policy.Identity -ErrorAction Stop
        }
        catch
        {
            Write-Verbose -Message "Policy for $Workload is already in the process of being deleted."
            New-M365DSCLogEntry  -Error $_ -Message $_ -Source $MyInvocation.MyCommand.ModuleName
        }
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Exchange', 'SharePoint', 'OneDriveForBusiness')]
        [System.String]
        $Workload,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of SCAuditConfigurationPolicy for $Workload"

    $CurrentValues = Get-TargetResource @PSBoundParameters
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
    $InformationPreference = "Continue"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    $policies = Get-AuditConfigurationPolicy
    $content = ""
    $i = 1
    foreach ($policy in $policies)
    {
        Write-Information "    [$i/$($policies.Count)] {$($policy.Workload)}"

        $params = @{
            Workload           = $policy.Workload
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        SCAuditConfigurationPolicy " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"

        $i++
    }

    return $content
}

Export-ModuleMember -Function *-TargetResource
