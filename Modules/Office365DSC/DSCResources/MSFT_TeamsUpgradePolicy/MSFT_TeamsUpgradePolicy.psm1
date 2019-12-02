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
        [System.Boolean]
        $NotifySfBUsers,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Checking the Teams Upgrade Policies"
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -Platform SkypeForBusiness

    $policy = Get-CsTeamsUpgradePolicy -Identity $Identity -ErrorAction SilentlyContinue

    if ($null -eq $policy)
    {
        Write-Verbose -Message "No Teams Upgrade Policy with Identity {$Identity} was found"
        return @{
            Identity           = $Identity
            Ensure             = 'Absent'
            GlobalAdminAccount = $GlobalAdminAccount
        }
    }
    Write-Verbose -Message "Found Teams Upgrade Policy with Identity {$Identity}"
    return @{
        Identity           = $Identity
        Description        = $policy.Description
        NotifySfBUsers     = $policy.NotifySfBUsers
        Ensure             = 'Present'
        GlobalAdminAccount = $GlobalAdminAccount
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
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $NotifySfBUsers,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Teams Upgrade Policy {$Identity}"

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -Platform SkypeForBusiness

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $SetParameters = $PSBoundParameters
    $SetParameters.Remove("Ensure") | Out-Null
    $SetParameters.Remove("GlobalAdminAccount") | Out-Null
    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Teams Upgrade Policy {$Identity} doesn't already exist. Creating it from the Set function."
        try
        {
            New-CsTeamsUpgradePolicy @SetParameters
        }
        catch
        {
            Write-Verbose -Message "An error occured trying to create a new Teams Upgrade Policy with Identity {$Identity}"
            throw $_
        }
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        # Call the Set-CsTeamsUpgradePolicy all the time because if we got here, the Test-TargetResource returned $false,
        # meaning that a property was different.
        Write-Verbose "Updating existing instance of Teams Upgrade Policy {$Identity}"
        try
        {
            Set-CsTeamsUpgradePolicy @SetParameters
        }
        catch
        {
            Write-Verbose -Message "An error occured trying to update the existing Teams Upgrade Policy instance {$Identity}"
            throw $_
        }
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "An existing instance of Teams Upgrade Policy {$Identity} was found. Deleting it from the Set method."
        try
        {
            Remove-CsTeamsUpgradePolicy -Identity $Identity
        }
        catch
        {
            Write-Verbose -Message "An error occured trying to delete Teams Upgrade Policy {$Identity}"
            throw $_
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
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $NotifySfBUsers,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Team Upgrade Policy {$Identity}"

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
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -Platform SkypeForBusiness
    $policies = Get-CsTeamsUpgradePolicy
    $i = 1
    $content = ''
    foreach ($policy in $policies)
    {
        Write-Information "    -[$i/$($policy.Count)] $Identity"
        $params = @{
            Identity           = $policy.Identity
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        TeamsUpgradePolicy " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
