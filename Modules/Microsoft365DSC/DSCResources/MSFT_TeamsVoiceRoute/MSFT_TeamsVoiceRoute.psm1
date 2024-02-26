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
        $NumberPattern,

        [Parameter()]
        [System.String[]]
        $OnlinePstnGatewayList,

        [Parameter()]
        [System.String[]]
        $OnlinePstnUsages,

        [Parameter()]
        [System.UInt32]
        $Priority,

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
        [Switch]
        $ManagedIdentity
    )

    Write-Verbose -Message "Getting the Voice Route {$Identity}"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
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

    $nullReturn = @{
        Identity              = $Identity
        Ensure                = 'Absent'
        Credential            = $Credential
        ApplicationId         = $ApplicationId
        TenantId              = $TenantId
        CertificateThumbprint = $CertificateThumbprint
        ManagedIdentity       = $ManagedIdentity.IsPresent
    }
    try
    {
        $route = Get-CsOnlineVoiceRoute -Identity $Identity -ErrorAction 'SilentlyContinue'

        if ($null -eq $route)
        {
            Write-Verbose -Message "Could not find Voice Route {$Identity}"
            return $nullReturn
        }
        Write-Verbose -Message "Found Voice Route {$Identity}"
        return @{
            Identity              = $Identity
            Description           = $route.Description
            NumberPattern         = $route.NumberPattern
            OnlinePstnGatewayList = $route.OnlinePstnGatewayList
            OnlinePstnUsages      = $route.OnlinePstnUsages
            Priority              = $route.Priority
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
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
        $NumberPattern,

        [Parameter()]
        [System.String[]]
        $OnlinePstnGatewayList,

        [Parameter()]
        [System.String[]]
        $OnlinePstnUsages,

        [Parameter()]
        [System.UInt32]
        $Priority,

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
        [Switch]
        $ManagedIdentity
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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    # Validate that the selected PSTN usages exist in the environment
    $existingUsages = Get-CsOnlinePstnUsage | Select-Object -ExpandProperty Usage
    $notFoundUsageList = @()
    foreach ($usage in $OnlinePstnUsages)
    {
        if ( -not ($existingUsages -match $usage))
        {
            $notFoundUsageList += $usage
        }
    }

    if ($notFoundUsageList)
    {
        $notFoundUsages = $notFoundUsageList -join ','
        throw "Please create the PSTN Usage(s) ($notFoundUsages) using `"TeamsPstnUsage`""
    }

    # Validate that the selected PSTN gateway exists in the environment
    $existingGateways = Get-CsOnlinePSTNGateway | Select-Object -ExpandProperty Identity
    $notFoundGatewayList = @()
    foreach ($gateway in $OnlinePstnGatewayList)
    {
        if ( -not ($existingGateways -match $gateway))
        {
            $notFoundGatewayList += $gateway
        }
    }

    if ($notFoundUsageList)
    {
        $notFoundGateways = $notFoundGatewayList -join ','
        throw "Please create the Voice Gateway object(s) ($notFoundGateways) using `"TeamsVoiceRoute`""
    }

    Write-Verbose -Message "Setting Voice Route {$Identity}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $SetParameters = $PSBoundParameters
    $SetParameters.Remove('Ensure') | Out-Null
    $SetParameters.Remove('Credential') | Out-Null
    $SetParameters.Remove('ApplicationId') | Out-Null
    $SetParameters.Remove('TenantId') | Out-Null
    $SetParameters.Remove('CertificateThumbprint') | Out-Null
    $SetParameters.Remove('ManagedIdentity') | Out-Null

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a new Voice Route {$Identity}"
        New-CsOnlineVoiceRoute @SetParameters
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        <#
            If we get here, it's because the Test-TargetResource detected a drift, therefore we always call
            into the Set-CsOnlineVoiceRoute cmdlet.
        #>
        Write-Verbose -Message "Updating settings for Voice Route {$Identity}"
        Set-CsOnlineVoiceRoute @SetParameters
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing existing Voice Route {$Identity}"
        Remove-CsOnlineVoiceRoute -Identity $Identity -Confirm:$false
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
        $NumberPattern,

        [Parameter()]
        [System.String[]]
        $OnlinePstnGatewayList,

        [Parameter()]
        [System.String[]]
        $OnlinePstnUsages,

        [Parameter()]
        [System.UInt32]
        $Priority,

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
        [Switch]
        $ManagedIdentity
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

    Write-Verbose -Message "Testing configuration of Voice Route {$Identity}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

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
        [Switch]
        $ManagedIdentity
    )
    $InformationPreference = 'Continue'

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
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
        $i = 1
        [array]$routes = Get-CsOnlineVoiceRoute -ErrorAction Stop
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($route in $routes)
        {
            Write-Host "    |---[$i/$($routes.Count)] $($route.Identity)" -NoNewline
            $params = @{
                Identity              = $route.Identity
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
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
