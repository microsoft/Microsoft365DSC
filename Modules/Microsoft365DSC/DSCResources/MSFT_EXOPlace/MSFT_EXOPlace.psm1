Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOPlace'

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
        $DisplayName,

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
        [ValidateSet('Floor', 'Section', 'None')]
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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration for Place for $($Identity)"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
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

            $place = Get-Place -Identity $Identity -ErrorAction SilentlyContinue
            if ($null -eq $place)
            {
                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    Write-Verbose -Message "Couldn't retrieve place by Id {$($Identity)}. Trying by DisplayName"
                    $place = Get-Place -ResultSize 'Unlimited' | Where-Object -FilterScript { $_.DisplayName -eq $DisplayName }
                }

                if ($null -eq $place)
                {
                    return $nullReturn
                }
            }
        }
        else
        {
            $place = $Script:exportedInstance
        }

        Write-Verbose -Message "Found Place with Identity {$Identity}"

        $TagsValue = [Array] $place.Tags
        if ($null -eq $place.Tags)
        {
            $TagsValue = @()
        }

        $result = @{
            Identity               = $place.Identity
            AudioDeviceName        = $place.AudioDeviceName
            Building               = $place.Building
            Capacity               = $place.Capacity
            City                   = $place.City
            CountryOrRegion        = $place.CountryOrRegion
            Desks                  = [Array] $place.Desks
            DisplayDeviceName      = $place.DisplayDeviceName
            DisplayName            = $place.DisplayName
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
            Tags                   = $TagsValue
            VideoDeviceName        = $place.VideoDeviceName
            Credential             = $Credential
            Ensure                 = 'Present'
            ApplicationId          = $ApplicationId
            CertificateThumbprint  = $CertificateThumbprint
            CertificatePath        = $CertificatePath
            CertificatePassword    = $CertificatePassword
            ManagedIdentity        = $ManagedIdentity.IsPresent
            TenantId               = $TenantId
            AccessTokens           = $AccessTokens
        }

        return $result
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
        $DisplayName,

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
        [ValidateSet('Floor', 'Section', 'None')]
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

    Write-Verbose -Message "Setting configuration of Place for $($Identity)"

    $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $updateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ([System.String]::IsNullOrEmpty($ParentId) -and $null -ne $ParentType)
    {
        Write-Verbose -Message 'ParentId is $null, removing ParentType.'
        $updateParameters.Remove('ParentType') | Out-Null
    }
    Set-Place @updateParameters
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
        $DisplayName,

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
        [ValidateSet('Floor', 'Section', 'None')]
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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
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
        [array]$places = Get-Place -ResultSize 'Unlimited' -ErrorAction Stop | `
            Where-Object -FilterScript { $_.PlaceType -ne 'RoomList'}
        $dscContent = ''

        if ($places.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $i = 1
        foreach ($place in $places)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($places.Length)] $($place.Identity)" -DeferWrite

            $Params = @{
                Identity              = $place.Identity
                DisplayName           = $place.DisplayName
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $place
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
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
