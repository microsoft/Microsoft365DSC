function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $IsPerDeviceAcceptanceRequired,

        [Parameter()]
        [System.Boolean]
        $IsViewingBeforeAcceptanceRequired,

        [Parameter()]
        [System.String]
        $TermsOfUseUrl,

        [Parameter()]
        [System.String]
        $UserReacceptRequiredFrequency,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    try
    {
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

        $instance = $null
        if (-not [System.String]::IsNullOrEmpty($Id))
        {
            $instance = Get-MgAgreement -AgreementId $Id -ErrorAction SilentlyContinue
        }
        elseif (-not [System.String]::IsNullOrEmpty($DisplayName))
        {
            $instance = Get-MgAgreement -Filter "DisplayName eq '$DisplayName'" -ErrorAction SilentlyContinue
        }

        if ($null -eq $instance)
        {
            return $nullResult
        }

        # Convert TimeSpan back to ISO 8601 duration format for UserReacceptRequiredFrequency
        $userReacceptFrequency = $instance.UserReacceptRequiredFrequency
        if ($null -ne $userReacceptFrequency -and $userReacceptFrequency -is [TimeSpan])
        {
            $userReacceptFrequency = "P$($userReacceptFrequency.Days)D"
        }

        $results = @{
            Id                               = $instance.Id
            DisplayName                      = $instance.DisplayName
            IsPerDeviceAcceptanceRequired    = $instance.IsPerDeviceAcceptanceRequired
            IsViewingBeforeAcceptanceRequired = $instance.IsViewingBeforeAcceptanceRequired
            TermsOfUseUrl                    = $instance.TermsOfUseUrl
            UserReacceptRequiredFrequency    = $userReacceptFrequency
            Ensure                           = 'Present'
            Credential                       = $Credential
            ApplicationId                    = $ApplicationId
            TenantId                         = $TenantId
            ApplicationSecret                = $ApplicationSecret
            CertificateThumbprint            = $CertificateThumbprint
            ManagedIdentity                  = $ManagedIdentity.IsPresent
            AccessTokens                     = $AccessTokens
        }

        return [System.Collections.Hashtable] $results
    }
    catch
    {
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $IsPerDeviceAcceptanceRequired,

        [Parameter()]
        [System.Boolean]
        $IsViewingBeforeAcceptanceRequired,

        [Parameter()]
        [System.String]
        $TermsOfUseUrl,

        [Parameter()]
        [System.String]
        $UserReacceptRequiredFrequency,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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

    $currentInstance = Get-TargetResource @PSBoundParameters

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating Terms of Use Agreement {$DisplayName}"
        
        $createParameters = @{
            DisplayName                      = $DisplayName
            IsPerDeviceAcceptanceRequired    = $IsPerDeviceAcceptanceRequired
            IsViewingBeforeAcceptanceRequired = $IsViewingBeforeAcceptanceRequired
        }

        if (-not [System.String]::IsNullOrEmpty($UserReacceptRequiredFrequency))
        {
            # Convert ISO 8601 duration to TimeSpan if needed
            if ($UserReacceptRequiredFrequency -match '^P(\d+)D$')
            {
                $days = [int]$Matches[1]
                $timeSpan = [TimeSpan]::FromDays($days)
                $createParameters.Add('UserReacceptRequiredFrequency', $timeSpan)
            }
            else
            {
                $createParameters.Add('UserReacceptRequiredFrequency', $UserReacceptRequiredFrequency)
            }
        }

        $newInstance = New-MgAgreement @createParameters
        Write-Verbose -Message "Created Terms of Use Agreement {$DisplayName} with Id {$($newInstance.Id)}"
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Terms of Use Agreement {$DisplayName}"
        
        $updateParameters = @{
            AgreementId                      = $Id
            DisplayName                      = $DisplayName
            IsPerDeviceAcceptanceRequired    = $IsPerDeviceAcceptanceRequired
            IsViewingBeforeAcceptanceRequired = $IsViewingBeforeAcceptanceRequired
        }

        if (-not [System.String]::IsNullOrEmpty($UserReacceptRequiredFrequency))
        {
            # Convert ISO 8601 duration to TimeSpan if needed
            if ($UserReacceptRequiredFrequency -match '^P(\d+)D$')
            {
                $days = [int]$Matches[1]
                $timeSpan = [TimeSpan]::FromDays($days)
                $updateParameters.Add('UserReacceptRequiredFrequency', $timeSpan)
            }
            else
            {
                $updateParameters.Add('UserReacceptRequiredFrequency', $UserReacceptRequiredFrequency)
            }
        }

        Update-MgAgreement @updateParameters
        Write-Verbose -Message "Updated Terms of Use Agreement {$DisplayName}"
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Terms of Use Agreement {$DisplayName}"
        Remove-MgAgreement -AgreementId $Id
        Write-Verbose -Message "Removed Terms of Use Agreement {$DisplayName}"
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
        $Id,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $IsPerDeviceAcceptanceRequired,

        [Parameter()]
        [System.Boolean]
        $IsViewingBeforeAcceptanceRequired,

        [Parameter()]
        [System.String]
        $TermsOfUseUrl,

        [Parameter()]
        [System.String]
        $UserReacceptRequiredFrequency,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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

    Write-Verbose -Message 'Testing configuration of Terms of Use Agreement'

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
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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
        [array] $Script:exportedInstances = Get-MgAgreement -ErrorAction Stop

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
        foreach ($instance in $Script:exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $($instance.DisplayName)" -NoNewline

            $params = @{
                Id                    = $instance.Id
                DisplayName           = $instance.DisplayName
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
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