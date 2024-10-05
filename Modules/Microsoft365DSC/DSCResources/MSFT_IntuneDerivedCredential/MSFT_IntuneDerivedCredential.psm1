function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $HelpUrl,

        [Parameter(Mandatory=$true)]
        [ValidateSet('intercede', 'entrust', 'disa purebred')]
        [System.String]
        $Issuer,

        [Parameter(Mandatory=$true)]
        [ValidateSet('email', 'Company Portal (iOS) Microsoft Intune (Android) app')]
        [System.String]
        $NotificationType,

        [Parameter()]
        [System.Int32]
        $ThresholdPercentage,

        [Parameter()]
        [System.String]
        $Header
    )

    New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters | Out-Null

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'
    try
    {
        $instance = $null
        if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
        {
            $instance = $Script:exportedInstances | Where-Object -FilterScript {$_.Id -eq $Id}
        }
        if ($null -eq $instance)
        {
          $instance = Get-MgBetaDeviceManagementDerivedCredential DerivedCredentialId $Id -ErrorAction Stop

          if ($null -eq $instance)
          {
              Write-Verbose -Message "Could not find DerivedCredential by Id {$Id}."

              if (-Not [string]::IsNullOrEmpty($DisplayName))
              {
                  $instance = Get-MgBetaDeviceManagementDerivedCredential `
                      -Filter "DisplayName eq '$DisplayName'" `
                      -ErrorAction SilentlyContinue
              }
          }
        }
        if ($null -eq $instance)
        {
            Write-Verbose -Message "Could not find DerivedCredential by DisplayName {$DisplayName}."
            return $nullResult
        }

        $results = @{
            Ensure                = 'Present'
            Id                    = $instance.Id
            DisplayName           = $instance.DisplayName
            HelpUrl               = $HelpUrl
            Issuer                = $Issuer
            NotificationType      = $NotificationType
            ThresholdPercentage   = $ThresholdPercentage
            Header                = $Header

        }
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        Write-Verbose -Message $_
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $HelpUrl,

        [Parameter(Mandatory=$true)]
        [ValidateSet('intercede', 'entrust', 'disa purebred')]
        [System.String]
        $Issuer,

        [Parameter(Mandatory=$true)]
        [ValidateSet('email', 'Company Portal (iOS) Microsoft Intune (Android) app')]
        [System.String]
        $NotificationType,

        [Parameter()]
        [System.Int32]
        $ThresholdPercentage,

        [Parameter()]
        [System.String]
        $Header
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        New-MgBetaDeviceManagementDerivedCredential @SetParameters
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Update-MgBetaDeviceManagementDerivedCredential @SetParameters
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Remove-MgBetaDeviceManagementDerivedCredential @SetParameters
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $HelpUrl,

        [Parameter(Mandatory=$true)]
        [ValidateSet('intercede', 'entrust', 'disa purebred')]
        [System.String]
        $Issuer,

        [Parameter(Mandatory=$true)]
        [ValidateSet('email', 'Company Portal (iOS) Microsoft Intune (Android) app')]
        [System.String]
        $NotificationType,

        [Parameter()]
        [System.Int32]
        $ThresholdPercentage,

        [Parameter()]
        [System.String]
        $Header
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $HelpUrl,

        [Parameter(Mandatory=$true)]
        [ValidateSet('Intercede', 'Entrust', 'DISA Purebred')]
        [System.String]
        $Issuer,

        [Parameter(Mandatory=$true)]
        [ValidateSet('Email', 'Company Portal (iOS) Microsoft Intune (Android) app')]
        [System.String]
        $NotificationType,

        [Parameter()]
        [System.Int32]
        $ThresholdPercentage,

        [Parameter()]
        [System.Collections.IDictionary]
        $Header

    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = Get-MgBetaDeviceManagementDerivedCredential -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $Script:exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline
            $results = @{
            Ensure                = 'Present'
            Id                    = $instance.Id
            DisplayName           = $instance.DisplayName
            HelpUrl               = $HelpUrl
            Issuer                = $Issuer
            NotificationType      = $NotificationType
            ThresholdPercentage   = $ThresholdPercentage
            Header                = $Header

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
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
