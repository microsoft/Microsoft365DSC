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
        $Comment,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Device Conditional Access Policy for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    $PolicyObject = Get-DeviceConditionalAccessPolicy -Identity $Name -ErrorAction SilentlyContinue

    if ($null -eq $PolicyObject)
    {
        Write-Verbose -Message "Device Conditional Access Policy $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        Write-Verbose "Found existing Device Conditional Access Policy $($Name)"
        $result = @{
            Ensure                          = 'Present'
            Name                            = $PolicyObject.Name
            Comment                         = $PolicyObject.Comment
            ExchangeLocation                = $PolicyObject.ExchangeLocation.Name
            ExchangeSenderMemberOf          = $PolicyObject.ExchangeSenderMemberOf
            ExchangeSenderMemberOfException = $PolicyObject.ExchangeSenderMemberOfException
            Mode                            = $PolicyObject.Mode
            OneDriveLocation                = $PolicyObject.OneDriveLocation.Name
            OneDriveLocationException       = $PolicyObject.OneDriveLocationException
            Priority                        = $PolicyObject.Priority
            SharePointLocation              = $PolicyObject.SharePointLocation.Name
            SharePointLocationException     = $PolicyObject.SharePointLocationException
            TeamsLocation                   = $PolicyObject.TeamsLocation.Name
            TeamsLocationException          = $PolicyObject.TeamsLocationException
        }

        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-O365DscHashtableToString -Hashtable $result)"
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
        $Comment,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Device Conditional Access Policy for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    $CurrentPolicy = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentPolicy.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")
        New-DeviceConditionalAccessPolicy @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")
        $CreationParams.Remove("Name")
        $CreationParams.Add("Identity", $Name)

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
        if ($null -ne $CurrentPolicy.OneDriveLocation -or `
                $null -ne $OneDriveLocation)
        {
            $ToBeRemoved = $CurrentPolicy.OneDriveLocation | `
                Where-Object { $OneDriveLocation -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveOneDriveLocation", $ToBeRemoved)
            }

            $ToBeAdded = $OneDriveLocation | `
                Where-Object { $CurrentPolicy.OneDriveLocation -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddOneDriveLocation", $ToBeAdded)
            }
            $CreationParams.Remove("OneDriveLocation")
        }

        # OneDrive Location Exception is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.OneDriveLocationException -or `
                $null -ne $OneDriveLocationException)
        {
            $ToBeRemoved = $CurrentPolicy.OneDriveLocationException | `
                Where-Object { $OneDriveLocationException -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveOneDriveLocationException", $ToBeRemoved)
            }

            $ToBeAdded = $OneDriveLocationException | `
                Where-Object { $CurrentPolicy.OneDriveLocationException -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddOneDriveLocationException", $ToBeAdded)
            }
            $CreationParams.Remove("OneDriveLocationException")
        }

        # SharePoint Location Exception is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.SharePointLocationException -or `
                $null -ne $SharePointLocationException)
        {
            $ToBeRemoved = $CurrentPolicy.SharePointLocationException | `
                Where-Object { $SharePointLocationException -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveSharePointLocationException", $ToBeRemoved)
            }

            $ToBeAdded = $SharePointLocationException | `
                Where-Object { $CurrentPolicy.SharePointLocationException -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddSharePointLocationException", $ToBeAdded)
            }
            $CreationParams.Remove("SharePointLocationException")
        }

        # Teams Location is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.TeamsLocation -or `
                $null -ne $TeamsLocation)
        {
            $ToBeRemoved = $CurrentPolicy.TeamsLocation | `
                Where-Object { $TeamsLocation -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveTeamsLocation", $ToBeRemoved)
            }

            $ToBeAdded = $TeamsLocation | `
                Where-Object { $CurrentPolicy.TeamsLocation -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddTeamsLocation", $ToBeAdded)
            }
            $CreationParams.Remove("TeamsLocation")
        }

        # Teams Location Exception is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.TeamsLocationException -or `
                $null -ne $TeamsLocationException)
        {
            $ToBeRemoved = $CurrentPolicy.TeamsLocationException | `
                Where-Object { $TeamsLocationException -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveTeamsLocationException", $ToBeRemoved)
            }

            $ToBeAdded = $TeamsLocationException | `
                Where-Object { $CurrentPolicy.TeamsLocationException -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddTeamsLocationException", $ToBeAdded)
            }
            $CreationParams.Remove("TeamsLocationException")
        }
        Write-Verbose "Updating Policy with values: $(Convert-O365DscHashtableToString -Hashtable $CreationParams)"
        Set-DeviceConditionalAccessPolicy @CreationParams
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        # If the Policy exists and it shouldn't, simply remove it;
        Remove-DeviceConditionalAccessPolicy -Identity $Name
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
        $Comment,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Device Conditional Access Policy for $Name"

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

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter `
        -ErrorAction SilentlyContinue
    $policies = Get-DeviceConditionalAccessPolicy | Where-Object -FilterScript { $_.Mode -ne 'PendingDeletion' }

    $totalPolicies = $policies.Length
    if ($null -eq $totalPolicies)
    {
        $totalPolicies = 1
    }
    $i = 1
    $content = ''
    foreach ($policy in $policies)
    {
        Write-Information "    - [$i/$($totalPolicies)] $($policy.Name)"
        $params = @{
            GlobalAdminAccount = $GlobalAdminAccount
            Name               = $policy.Name
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        SCDeviceConditionalAccessPolicy " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
