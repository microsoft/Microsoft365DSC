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
        $AudioDeviceName,

        [Parameter()]
        [System.String]
        $Building,

        [Parameter()]
        [System.UInt32]
        $Capacity,

        [Parameter()]
        [System.String]
        $City,

        [Parameter()]
        [System.String]
        $CountryOrRegion,

        [Parameter()]
        [System.String[]]
        $Desks = @(),

        [Parameter()]
        [System.String]
        $DisplayDeviceName,

        [Parameter()]
        [System.UInt32]
        $Floor,

        [Parameter()]
        [System.String]
        $FloorLabel,

        [Parameter()]
        [System.String]
        $GeoCoordinates,

        [Parameter()]
        [System.Boolean]
        $IsWheelChairAccessible,

        [Parameter()]
        [System.String]
        $Label,

        [Parameter()]
        [System.Boolean]
        $MTREnabled,

        [Parameter()]
        [System.String]
        $ParentId,

        [Parameter()]
        [ValidateSet("Floor", "Section")]
        [System.String]
        $ParentType,

        [Parameter()]
        [System.String]
        $Phone,

        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $Street,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [System.String]
        $VideoDeviceName,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )
    Write-Verbose -Message "Getting configuration for Place for $($Identity)"

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }

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
        $place = Get-Place -Identity $Identity -ErrorAction Stop

        if ($null -eq $place)
        {
            Write-Verbose -Message "Place $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Identity               = $place.Identity
                AudioDeviceName        = $place.AudioDeviceName
                Building               = $place.Building
                Capacity               = $place.Capacity
                City                   = $place.City
                CountryOrRegion        = $place.CountryOrRegion
                Desks                  = [Array] $place.Desks
                DisplayDeviceName      = $place.DisplayDeviceName
                Floor                  = $place.Floor
                FloorLabel             = $place.FloorLabel
                GeoCoordinates         = $place.GeoCoordinates
                IsWheelChairAccessible = [Boolean] $place.IsWheelChairAccessible
                Label                  = $place.Label
                MTREnabled             = [Boolean] $place.MTREnabled
                ParentId               = $place.ParentId
                ParentType             = $place.ParentType
                Phone                  = $place.Phone
                PostalCode             = $place.PostalCode
                State                  = $place.State
                Street                 = $place.Street
                Tags                   = [Array] $place.Tags
                VideoDeviceName        = $place.VideoDeviceName
                Credential             = $Credential
                Ensure                 = 'Present'
                ApplicationId          = $ApplicationId
                CertificateThumbprint  = $CertificateThumbprint
                CertificatePath        = $CertificatePath
                CertificatePassword    = $CertificatePassword
                Managedidentity        = $ManagedIdentity.IsPresent
                TenantId               = $TenantId
            }

            Write-Verbose -Message "Found Place $($Identity)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
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
        [System.String[]]
        $AssociatedAcceptedDomains = @(),

        [Parameter()]
        [System.Boolean]
        $CloudServicesMailEnabled,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [ValidateSet('Default', 'Migrated', 'HybridWizard')]
        [System.String]
        $ConnectorSource,

        [Parameter()]
        [ValidateSet('OnPremises', 'Partner')]
        [System.String]
        $ConnectorType,

        [Parameter()]
        [System.String[]]
        $EFSkipIPs = @(),

        [Parameter()]
        [System.Boolean]
        $EFSkipLastIP,

        [Parameter()]
        [System.String[]]
        $EFUsers = @(),

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Boolean]
        $RequireTls,

        [Parameter()]
        [System.Boolean]
        $RestrictDomainsToCertificate,

        [Parameter()]
        [System.Boolean]
        $RestrictDomainsToIPAddresses,

        [Parameter()]
        [System.String[]]
        $SenderDomains = @(),

        [Parameter()]
        [System.String[]]
        $SenderIPAddresses = @(),

        [Parameter()]
        [System.String]
        $TlsSenderCertificateName,

        [Parameter()]
        [System.Boolean]
        $TreatMessagesAsInternal,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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

    Write-Verbose -Message "Setting configuration of InboundConnector for $($Identity)"

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $InboundConnectors = Get-InboundConnector
    $InboundConnector = $InboundConnectors | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $InboundConnectorParams = [System.Collections.Hashtable]($PSBoundParameters)
    $InboundConnectorParams.Remove('Ensure') | Out-Null
    $InboundConnectorParams.Remove('Credential') | Out-Null
    $InboundConnectorParams.Remove('ApplicationId') | Out-Null
    $InboundConnectorParams.Remove('TenantId') | Out-Null
    $InboundConnectorParams.Remove('CertificateThumbprint') | Out-Null
    $InboundConnectorParams.Remove('CertificatePath') | Out-Null
    $InboundConnectorParams.Remove('CertificatePassword') | Out-Null
    $InboundConnectorParams.Remove('ManagedIdentity') | Out-Null

    if (('Present' -eq $Ensure ) -and ($null -eq $InboundConnector))
    {
        Write-Verbose -Message "Creating InboundConnector $($Identity)."
        $InboundConnectorParams.Add('Name', $Identity)
        $InboundConnectorParams.Remove('Identity') | Out-Null
        New-InboundConnector @InboundConnectorParams
    }
    elseif (('Present' -eq $Ensure ) -and ($Null -ne $InboundConnector))
    {
        Write-Verbose -Message "Setting InboundConnector $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $InboundConnectorParams)"
        Set-InboundConnector @InboundConnectorParams -Confirm:$false
    }
    elseif (('Absent' -eq $Ensure ) -and ($null -ne $InboundConnector))
    {
        Write-Verbose -Message "Removing InboundConnector $($Identity)"
        Remove-InboundConnector -Identity $Identity -Confirm:$false
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
        [System.String[]]
        $AssociatedAcceptedDomains = @(),

        [Parameter()]
        [System.Boolean]
        $CloudServicesMailEnabled,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [ValidateSet('Default', 'Migrated', 'HybridWizard')]
        [System.String]
        $ConnectorSource,

        [Parameter()]
        [ValidateSet('OnPremises', 'Partner')]
        [System.String]
        $ConnectorType,

        [Parameter()]
        [System.String[]]
        $EFSkipIPs = @(),

        [Parameter()]
        [System.Boolean]
        $EFSkipLastIP,

        [Parameter()]
        [System.String[]]
        $EFUsers = @(),

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Boolean]
        $RequireTls,

        [Parameter()]
        [System.Boolean]
        $RestrictDomainsToCertificate,

        [Parameter()]
        [System.Boolean]
        $RestrictDomainsToIPAddresses,

        [Parameter()]
        [System.String[]]
        $SenderDomains = @(),

        [Parameter()]
        [System.String[]]
        $SenderIPAddresses = @(),

        [Parameter()]
        [System.String]
        $TlsSenderCertificateName,

        [Parameter()]
        [System.Boolean]
        $TreatMessagesAsInternal,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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

    Write-Verbose -Message "Testing configuration of Place for $($Identity)"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $($TestResult)"

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

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
        [array]$places = Get-Place -ErrorAction Stop
        $dscContent = ''

        if ($places.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($place in $places)
        {
            Write-Host "    |---[$i/$($places.Length)] $($place.Identity)" -NoNewline

            $Params = @{
                Identity              = $place.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
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
            $i++
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
