function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Case,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $PublicFolderLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocation,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of SCCaseHoldPolicy for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    $PolicyObject = Get-CaseHoldPolicy -Case $Case -Identity $Name -ErrorAction SilentlyContinue

    if ($null -eq $PolicyObject)
    {
        Write-Verbose -Message "SCCaseHoldPolicy $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        Write-Verbose "Found existing SCCaseHoldPolicy $($Name)"
        $result = @{
            Ensure               = 'Present'
            Name                 = $PolicyObject.Name
            Case                 = $Case
            Enabled              = $PolicyObject.Enabled
            Comment              = $PolicyObject.Comment
            ExchangeLocation     = $PolicyObject.ExchangeLocation.Name
            PublicFolderLocation = $PolicyObject.PublicFolderLocation.Name
            SharePointLocation   = $PolicyObject.SharePointLocation.Name
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Case,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $PublicFolderLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocation,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of SCCaseHoldPolicy for $Name"
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
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")
        New-CaseHoldPolicy @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")
        $CreationParams.Remove("Name")
        $CreationParams.Remove("Case")

        $policy = Get-CaseHoldPolicy -Identity $Name -Case $Case
        $CreationParams.Add("Identity", $policy.Name)

        # SharePoint Location is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.SharePointLocation -or `
                $null -ne $SharePointLocation)
        {
            $ToBeRemoved = $CurrentPolicy.SharePointLocation | `
                Where-Object { $SharePointLocation -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveSharePointLocation", $ToBeRemoved)
            }

            $ToBeAdded = $SharePointLocation | `
                Where-Object { $CurrentPolicy.SharePointLocation -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddSharePointLocation", $ToBeAdded)
            }

            $CreationParams.Remove("SharePointLocation")
        }

        # Exchange Location is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.ExchangeLocation -or `
                $null -ne $ExchangeLocation)
        {
            $ToBeRemoved = $CurrentPolicy.ExchangeLocation | `
                Where-Object { $ExchangeLocation -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveExchangeLocation", $ToBeRemoved)
            }

            $ToBeAdded = $ExchangeLocation | `
                Where-Object { $CurrentPolicy.ExchangeLocation -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddExchangeLocation", $ToBeAdded)
            }

            $CreationParams.Remove("ExchangeLocation")
        }

        # OneDrive Location is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.PublicFolderLocation -or `
                $null -ne $PublicFolderLocation)
        {
            $ToBeRemoved = $CurrentPolicy.PublicFolderLocation | `
                Where-Object { $PublicFolderLocation -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemovePublicFolderLocation", $ToBeRemoved)
            }

            $ToBeAdded = $PublicFolderLocation | `
                Where-Object { $CurrentPolicy.PublicFolderLocation -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddPublicFolderLocation", $ToBeAdded)
            }
            $CreationParams.Remove("PublicFolderLocation")
        }

        Write-Verbose "Updating Policy with values: $(Convert-M365DscHashtableToString -Hashtable $CreationParams)"
        Set-CaseHoldPolicy @CreationParams
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        # If the Policy exists and it shouldn't, simply remove it;
        $policy = Get-CaseHoldPolicy -Identity $Name -Case $Case
        Remove-CaseHoldPolicy -Identity $policy.Name
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Case,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $PublicFolderLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocation,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of SCCaseHoldPolicy for $Name"

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
    $organization = ""
    if ($GlobalAdminAccount.UserName.Contains("@"))
    {
        $organization = $GlobalAdminAccount.UserName.Split("@")[1]
    }
    [array]$cases = Get-ComplianceCase

    $dscContent = ""
    $i = 1
    foreach ($case in $cases)
    {
        Write-Information "    [$i/$($Cases.Count)] Scanning Policies in Case {$($case.Name)}"
        [array]$policies = Get-CaseHoldPolicy -Case $case.Name

        $j = 1
        foreach ($policy in $policies)
        {
            Write-Information "        [$j/$($policies.Count)] $($policy.Name)"
            $params = @{
                Name               = $policy.Name
                Case               = $case.Name
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $dscContent += "        SCCaseHoldPolicy " + (New-GUID).ToString() + "`r`n"
            $dscContent += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $partialContent = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            if ($partialContent.ToLower().IndexOf($organization.ToLower()) -gt 0)
            {
                $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$OrganizationName"
            }
            $partialContent += "        }`r`n"
            $dscContent += $partialContent
            $j++
        }
        $i++
    }

    return $dscContent
}

Export-ModuleMember -Function *-TargetResource
