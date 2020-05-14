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
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        [ValidatePattern("^(?:\+)?[0-9]*$")]
        $NotificationDialOutNumber,

        [Parameter()]
        [System.String]
        $NotificationGroup,

        [Parameter()]
        [System.String]
        [ValidateSet("NotificationOnly","ConferenceMuted","ConferenceUnMuted")]
        $NotificationMode,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting the Teams Emergency Calling Policy {$Identity}"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent  -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SkypeForBusiness

    $policy = Get-CsTeamsEmergencyCallingPolicy -Identity $Identity -ErrorAction 'SilentlyContinue'

    if ($null -eq $policy)
    {
        Write-Verbose -Message "Could not find Teams Emergency Calling Policy {$Identity}"
        return @{
            Identity           = $Identity
            Ensure             = 'Absent'
            GlobalAdminAccount = $GlobalAdminAccount
        }
    }
    Write-Verbose -Message "Found Teams Emergency Calling Policy {$Identity}"
    $result = @{
        Identity                  = $Identity
        Description               = $policy.Description
        NotificationDialOutNumber = $policy.NotificationDialOutNumber
        NotificationGroup         = $policy.NotificationGroup
        NotificationMode          = $policy.NotificationMode
        Ensure                    = "Present"
        GlobalAdminAccount        = $GlobalAdminAccount
    }

    if ([System.String]::IsNullOrEmpty($result.NotificationMode))
    {
        $result.Remove("NotificationMode") | Out-Null
    }

    return $result
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
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        [ValidatePattern("^(?:\+)?[0-9]*$")]
        $NotificationDialOutNumber,

        [Parameter()]
        [System.String]
        $NotificationGroup,

        [Parameter()]
        [System.String]
        [ValidateSet("NotificationOnly","ConferenceMuted","ConferenceUnMuted")]
        $NotificationMode,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Teams Emergency Calling Policy {$Identity}"

    # Check that at least one optional parameter is specified
    $inputValues = @()
    foreach ($item in $PSBoundParameters.Keys)
    {
        if (-not [System.String]::IsNullOrEmpty($PSBoundParameters.$item) -and $item -ne 'GlobalAdminAccount' `
            -and $item -ne 'Identity' -and $item -ne 'Ensure')
        {
            $inputValues += $item
        }
    }

    if ($inputValues.Count -eq 0)
    {
        throw "You need to specify at least one optional parameter for the Set-TargetResource function" + `
            " of the [TeamsEmergencyCallingPolicy] instance {$Identity}"
    }

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SkypeForBusiness

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $SetParameters = $PSBoundParameters
    $SetParameters.Remove("Ensure") | Out-Null
    $SetParameters.Remove("GlobalAdminAccount") | Out-Null

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a new Teams Emergency Calling Policy {$Identity}"
        New-CsTeamsEmergencyCallingPolicy @SetParameters
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        # If we get here, it's because the Test-TargetResource detected a drift, therefore we always call
        # into the Set-CsTeamsEmergencyCallingPolicy cmdlet.
        Write-Verbose -Message "Updating settings for Teams Emergency Calling Policy {$Identity}"
        Set-CsTeamsEmergencyCallingPolicy @SetParameters
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing existing Teams Emergency Calling Policy {$Identity}"
        Remove-CsTeamsEmergencyCallingPolicy -Identity $Identity -Confirm:$false
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
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        [ValidatePattern("^(?:\+)?[0-9]*$")]
        $NotificationDialOutNumber,

        [Parameter()]
        [System.String]
        $NotificationGroup,

        [Parameter()]
        [System.String]
        [ValidateSet("NotificationOnly","ConferenceMuted","ConferenceUnMuted")]
        $NotificationMode,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Team Emergency Calling Policy {$Identity}"

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
        -Platform SkypeForBusiness

    $organization = ""
    if ($GlobalAdminAccount.UserName.Contains("@"))
    {
        $organization = $GlobalAdminAccount.UserName.Split("@")[1]
    }

    $i = 1
    [array]$policies = Get-CsTeamsEmergencyCallingPolicy
    $content = ''
    foreach ($policy in $policies)
    {
        Write-Information "    [$i/$($policies.Count)] $($policy.Identity)"
        $params = @{
            Identity           = $policy.Identity
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        TeamsEmergencyCallingPolicy " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $partialContent = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        if ($partialContent.ToLower().IndexOf($organization.ToLower()) -gt 0)
        {
            $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$OrganizationName"
        }
        $content += $partialContent
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
