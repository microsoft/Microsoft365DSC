function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('canada', 'unitedstates', 'europe', 'asia', 'australia', 'india', 'japan', 'unitedkingdom', 'unitedstatesfirstrelease', 'southamerica', 'france', 'usgov')]
        $Location,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Production','Standard', 'Trial', 'Sandbox')]
        $EnvironmentSKU,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration for PowerApps Environment {$DisplayName}"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -Cloud $GlobalAdminAccount `
        -Platform PowerPlatforms

    $nullReturn = @{
        DisplayName        = $DisplayName
        Location           = $Location
        EnvironmentSKU     = $EnvironmentSKU
        Ensure             = 'Absent'
        GlobalAdminAccount = $null
    }

    try
    {
        $environment = Get-AdminPowerAppEnvironment | Where-Object -FilterScript { $_.DisplayName -eq $DisplayName }

        if ($null -eq $environment)
        {
            Write-Verbose -Message "Could not find PowerApps Environment {$DisplayName}"
            return $nullReturn
        }

        Write-Verbose -Message "Found PowerApps Environment {$DisplayName}"
        return @{
            DisplayName        = $DisplayName
            Location           = $environment.Location
            EnvironmentSKU     = $environment.EnvironmentType
            Ensure             = 'Present'
            GlobalAdminAccount = $GlobalAdminAccount
        }
    }
    catch
    {
        Write-Verbose $_
        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('canada', 'unitedstates', 'europe', 'asia', 'australia', 'india', 'japan', 'unitedkingdom', 'unitedstatesfirstrelease', 'southamerica', 'france', 'usgov')]
        $Location,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Production','Standard', 'Trial', 'Sandbox')]
        $EnvironmentSKU,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for PowerApps Environment {$DisplayName}"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PowerPlatforms

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("Ensure")

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new PowerApps environment {$DisplayName}"
        try
        {
            New-AdminPowerAppEnvironment @CurrentParameters
        }
        catch
        {
            Write-Verbose -Message "An error occured trying to create new PowerApps Environment {$DisplayName}"
            throw $_
        }
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Warning -Message "Resource doesn't support updating existing environments. Please delete and recreate {$DisplayName}"
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing existing instance of PowerApps environment {$DisplayName}"
        Remove-AdminPowerAppEnvironment -EnvironmentName -$DisplayName | Out-Null
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('canada', 'unitedstates', 'europe', 'asia', 'australia', 'india', 'japan', 'unitedkingdom', 'unitedstatesfirstrelease', 'southamerica', 'france', 'usgov')]
        $Location,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Production','Standard', 'Trial', 'Sandbox')]
        $EnvironmentSKU,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for PowerApps Environment {$DisplayName}"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove("GlobalAdminAccount") | Out-Null
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
        -Platform PowerPlatforms

    [array]$environments = Get-AdminPowerAppEnvironment
    $content = ''
    $i = 1

    foreach ($environment in $environments)
    {
        Write-Information "    -[$i/$($environments.Count)] $($environment.DisplayName)"
        if ($environment.EnvironmentType -ne 'Default')
        {
            $params = @{
                DisplayName        = $environment.DisplayName
                Location           = $environment.Location
                EnvironmentSku     = $environment.EnvironmentType
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        PPPowerAppsEnvironment " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"
        }
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
