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
        $Description,

        [Parameter()]
        [ValidateSet("Active", "Closed")]
        [System.String]
        $Status = "Active",

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of SCComplianceCase for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    $Case = Get-ComplianceCase -Identity $Name -ErrorAction SilentlyContinue

    if ($null -eq $Case)
    {
        Write-Verbose -Message "SCComplianceCase $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        Write-Verbose "Found existing SCComplianceCase $($Name)"
        $Status = $Case.Status
        if ('Closing' -eq $Status)
        {
            $Status = "Closed"
        }
        $result = @{
            Name               = $Case.Name
            Description        = $Case.Description
            Status             = $Status
            GlobalAdminAccount = $GlobalAdminAccount
            Ensure             = 'Present'
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
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet("Active", "Closed")]
        [System.String]
        $Status = "Active",

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of SCComplianceCase for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    $CurrentCase = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentCase.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Status")
        $CreationParams.Remove("Ensure")

        Write-Verbose "Creating new Compliance Case $Name calling the New-ComplianceCase cmdlet."
        New-ComplianceCase @CreationParams

        # There is a possibility that the new case has to be closed to begin with (could be for future re-open);
        if ('Closed' -eq $Status)
        {
            Set-ComplianceCase -Identity $Name -Close
        }
    }
    # Compliance Case exists and it should. Update it.
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentTag.Ensure))
    {
        # The only real value we can update is the description;
        if ($CurrentCase.Description -ne $Description)
        {
            Set-ComplianceCase -Identity $Name -Description $Description
        }

        # Compliance case is currently Active, but should be Closed; Close it.
        if ('Active' -eq $CurrentCase.Status -and 'Closed' -eq $Status)
        {
            Set-ComplianceCase -Identity $Name -Close
        }

        # Compliance Case is currently Closed, but should be active. Re-open it.
        if ('Closed' -eq $CurrentCase.Status -and 'Active' -eq $Status)
        {
            Set-ComplianceCase -Identity $Name -Reopen
        }
    }
    # Compliance Case exists but it shouldn't. Remove it.
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentTag.Ensure))
    {
        Remove-ComplianceCase -Identity $Name -Confirm:$false
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
        $Description,

        [Parameter()]
        [ValidateSet("Active", "Closed")]
        [System.String]
        $Status = "Active",

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of SCComplianceCase for $Name"

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
    [array]$Cases = Get-ComplianceCase

    $dscContent = ""
    $i = 1
    foreach ($Case in $Cases)
    {
        Write-Information "    eDiscovery: [$i/$($Cases.Count)] $($Case.Name)"
        $params = @{
            Name               = $Case.Name
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $dscContent += "        SCComplianceCase " + (New-GUID).ToString() + "`r`n"
        $dscContent += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $partialContent = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $partialContent += "        }`r`n"
        $dscContent += $partialContent
        $i++
    }

    [array]$Cases = Get-ComplianceCase -CaseType "DSR"

    $i = 1
    foreach ($Case in $Cases)
    {
        Write-Information "    GDPR: [$i/$($Cases.Count)] $($Case.Name)"
        $params = @{
            Name               = $Case.Name
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $dscContent += "        SCComplianceCase " + (New-GUID).ToString() + "`r`n"
        $dscContent += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $partialContent = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $partialContent += "        }`r`n"
        $dscContent += $partialContent
        $i++
    }
    return $dscContent
}

Export-ModuleMember -Function *-TargetResource
