Confirm-M365DSCModuleDependency -ModuleName 'MSFT_TeamsVoiceRoute'

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
        $BridgeSourcePhoneNumber,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting the Voice Route {$Identity}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftTeams' `
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
                AccessTokens          = $AccessTokens
            }

            $route = Get-CsOnlineVoiceRoute -Identity $Identity -ErrorAction 'SilentlyContinue'
        }
        else
        {
            $route = $Script:exportedInstance
        }

        if ($null -eq $route)
        {
            Write-Verbose -Message "Could not find Voice Route {$Identity}"
            return $nullReturn
        }

        Write-Verbose -Message "Found Voice Route {$Identity}"
        return @{
            Identity                = $Identity
            BridgeSourcePhoneNumber = $route.BridgeSourcePhoneNumber
            Description             = $route.Description
            NumberPattern           = $route.NumberPattern
            OnlinePstnGatewayList   = $route.OnlinePstnGatewayList
            OnlinePstnUsages        = $route.OnlinePstnUsages
            Priority                = $route.Priority
            Ensure                  = 'Present'
            Credential              = $Credential
            ApplicationId           = $ApplicationId
            TenantId                = $TenantId
            CertificateThumbprint   = $CertificateThumbprint
            ManagedIdentity         = $ManagedIdentity.IsPresent
            AccessTokens            = $AccessTokens
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
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
        $BridgeSourcePhoneNumber,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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

    $null = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    # Validate that the selected PSTN usages exist in the environment
    $existingUsages = Get-CsOnlinePstnUsage | Select-Object -ExpandProperty Usage
    $notFoundUsageList = @()
    foreach ($usage in $OnlinePstnUsages)
    {
        if (-not ($existingUsages -match $usage))
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
        if (-not ($existingGateways -match $gateway))
        {
            $notFoundGatewayList += $gateway
        }
    }

    if ($notFoundGatewayList)
    {
        $notFoundGateways = $notFoundGatewayList -join ','
        throw "Please create the Voice Gateway object(s) ($notFoundGateways) using cmdlet `"New-CsOnlinePSTNGateway`""
    }

    Write-Verbose -Message "Setting Voice Route {$Identity}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a new Voice Route {$Identity}"
        New-CsOnlineVoiceRoute @boundParameters
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating settings for Voice Route {$Identity}"
        Set-CsOnlineVoiceRoute @boundParameters
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing existing Voice Route {$Identity}"
        Remove-CsOnlineVoiceRoute -Identity $Identity
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
        $BridgeSourcePhoneNumber,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $Filter = "*",

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

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
        [array]$routes = Get-CsOnlineVoiceRoute -Filter $Filter -ErrorAction Stop
        $dscContent = ''
        Write-M365DSCHost -Message "`r`n" -DeferWrite
        foreach ($route in $routes)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($routes.Count)] $($route.Identity)" -DeferWrite
            $params = @{
                Identity              = $route.Identity
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $route
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
