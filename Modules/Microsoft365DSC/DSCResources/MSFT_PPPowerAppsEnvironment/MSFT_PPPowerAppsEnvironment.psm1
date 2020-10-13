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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration for PowerApps Environment {$DisplayName}"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PowerPlatforms' `
        -InboundParameters $PSBoundParameters

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    try
    {
        $environment = Get-AdminPowerAppEnvironment -ErrorAction Stop | Where-Object -FilterScript { $_.DisplayName -eq $DisplayName }

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
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration for PowerApps Environment {$DisplayName}"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PowerPlatforms' `
        -InboundParameters $PSBoundParameters

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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Testing configuration for PowerApps Environment {$DisplayName}"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove("GlobalAdminAccount") | Out-Null
    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
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
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PowerPlatforms' `
        -InboundParameters $PSBoundParameters
    try
    {
        [array]$environments = Get-AdminPowerAppEnvironment -ErrorAction Stop
        $dscContent = ''
        $i = 1
        Write-Host "`r`n" -NoNewLine
        foreach ($environment in $environments)
        {
            Write-Host "    |---[$i/$($environments.Count)] $($environment.DisplayName)" -NoNewLine
            if ($environment.EnvironmentType -ne 'Default')
            {
                $Params = @{
                    DisplayName           = $environment.DisplayName
                    Location              = $environment.Location
                    EnvironmentSku        = $environment.EnvironmentType
                    GlobalAdminAccount    = $GlobalAdminAccount
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                }
                $Results = Get-TargetResource @Params
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
                $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -GlobalAdminAccount $GlobalAdminAccount
            }
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
