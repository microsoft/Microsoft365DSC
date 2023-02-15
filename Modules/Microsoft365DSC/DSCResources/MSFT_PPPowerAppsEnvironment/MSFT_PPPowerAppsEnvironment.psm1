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
        [ValidateSet('canada', 'unitedstates', 'europe', 'asia', 'australia', 'india', 'japan', 'unitedkingdom', 'unitedstatesfirstrelease', 'southamerica', 'france', 'usgov', 'germany')]
        $Location,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Production', 'Trial', 'Sandbox', 'SubscriptionBasedTrial', 'Teams', 'Developer')]
        $EnvironmentSKU,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret
    )

    Write-Verbose -Message "Getting configuration for PowerApps Environment {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'PowerPlatforms' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

    try
    {
        $environment = Get-AdminPowerAppEnvironment -ErrorAction Stop | Where-Object -FilterScript { $_.DisplayName -eq $DisplayName }

        if ($null -eq $environment)
        {
            Write-Verbose -Message "Could not find PowerApps Environment {$DisplayName}"
            return $nullReturn
        }

        Write-Verbose -Message "Found PowerApps Environment {$DisplayName}"
        $environmentType = $environment.EnvironmentType
        if ($environmentType -eq 'Notspecified')
        {
            $environmentType = 'Teams'
        }
        return @{
            DisplayName           = $DisplayName
            Location              = $environment.Location
            EnvironmentSKU        = $environmentType
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ApplicationSecret     = $ApplicationSecret
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

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
        [ValidateSet('canada', 'unitedstates', 'europe', 'asia', 'australia', 'india', 'japan', 'unitedkingdom', 'unitedstatesfirstrelease', 'southamerica', 'france', 'usgov', 'germany')]
        $Location,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Production', 'Trial', 'Sandbox', 'SubscriptionBasedTrial', 'Teams', 'Developer')]
        $EnvironmentSKU,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret
    )

    Write-Verbose -Message "Setting configuration for PowerApps Environment {$DisplayName}"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'PowerPlatforms' `
        -InboundParameters $PSBoundParameters

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove('Credential') | Out-Null
    $CurrentParameters.Remove('ApplicationId') | Out-Null
    $CurrentParameters.Remove('TenantId') | Out-Null
    $CurrentParameters.Remove('ApplicationSecret') | Out-Null
    $CurrentParameters.Remove('CertificateThumbprint') | Out-Null
    $CurrentParameters.Remove('Ensure') | Out-Null

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
        [ValidateSet('canada', 'unitedstates', 'europe', 'asia', 'australia', 'india', 'japan', 'unitedkingdom', 'unitedstatesfirstrelease', 'southamerica', 'france', 'usgov', 'germany')]
        $Location,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Production', 'Trial', 'Sandbox', 'SubscriptionBasedTrial', 'Teams', 'Developer')]
        $EnvironmentSKU,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration for PowerApps Environment {$DisplayName}"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
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
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'PowerPlatforms' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$environments = Get-AdminPowerAppEnvironment -ErrorAction Stop
        $dscContent = ''
        $i = 1

        if ($environments.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($environment in $environments)
        {
            if ($environment.EnvironmentType -ne 'Default')
            {
                Write-Host "    |---[$i/$($environments.Count)] $($environment.DisplayName)" -NoNewline
                $environmentType = $environment.EnvironmentType
                if ($environmentType -eq 'Notspecified')
                {
                    $environmentType = 'Teams'
                }
                $Params = @{
                    DisplayName           = $environment.DisplayName
                    Location              = $environment.Location
                    EnvironmentSku        = $environmentType
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    ApplicationSecret     = $ApplicationSecret
                }
                $Results = Get-TargetResource @Params
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                $dscContent += $currentDSCBlock

                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
                Write-Host $Global:M365DSCEmojiGreenCheckMark
            }
            else
            {
                Write-Host "    |---[$i/$($environments.Count)] Skipping Default Environment $($environment.DisplayName)" -NoNewline
                Write-Host $Global:M365DSCEmojiInformation
            }
            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message "Error during Export:" `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
