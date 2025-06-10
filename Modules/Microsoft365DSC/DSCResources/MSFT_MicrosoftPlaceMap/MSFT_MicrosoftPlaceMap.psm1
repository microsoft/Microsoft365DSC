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
        $BuildingId,

        [Parameter()]
        [System.String]
        $Floor,

        [Parameter()]
        [System.String]
        $FloorLabel,

        [Parameter()]
        [System.String]
        $MapType,

        [Parameter()]
        [System.String]
        $MapImageUrl,

        [Parameter()]
        [System.String[]]
        $Tags,

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

    Write-Verbose -Message "Getting configuration of Microsoft Place Map for $Identity"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
        # Get map from Microsoft Places API
        $uri = "https://graph.microsoft.com/beta/places/$Identity"
        $map = Invoke-MgGraphRequest -Uri $uri -Method GET -ErrorAction SilentlyContinue

        if ($null -eq $map)
        {
            Write-Verbose -Message "Microsoft Place Map with Identity {$Identity} was not found"
            return $nullReturn
        }

        # Verify this is a map type place
        if ($map.'@odata.type' -ne '#microsoft.graph.room' -or 
            ($map.PlaceType -and $map.PlaceType -ne 'Map'))
        {
            Write-Verbose -Message "Place with Identity {$Identity} is not a map"
            return $nullReturn
        }

        Write-Verbose -Message "Found Microsoft Place Map with Identity {$Identity}"

        $result = @{
            Identity       = $map.id
            DisplayName    = $map.displayName
            BuildingId     = $map.building
            Floor          = $map.floor
            FloorLabel     = $map.floorLabel
            MapType        = $map.mapType
            MapImageUrl    = $map.mapImageUrl
            Tags           = $map.tags
            Ensure         = 'Present'
            Credential     = $Credential
            ApplicationId  = $ApplicationId
            TenantId       = $TenantId
            ApplicationSecret = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity = $ManagedIdentity.IsPresent
            AccessTokens   = $AccessTokens
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $BuildingId,

        [Parameter()]
        [System.String]
        $Floor,

        [Parameter()]
        [System.String]
        $FloorLabel,

        [Parameter()]
        [System.String]
        $MapType,

        [Parameter()]
        [System.String]
        $MapImageUrl,

        [Parameter()]
        [System.String[]]
        $Tags,

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

    Write-Verbose -Message "Setting configuration of Microsoft Place Map for $Identity"

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    $currentInstance = Get-TargetResource @PSBoundParameters

    # Prepare request body for map-specific properties
    $requestBody = @{}
    
    if (-not [String]::IsNullOrEmpty($DisplayName))
    {
        $requestBody.displayName = $DisplayName
    }

    if (-not [String]::IsNullOrEmpty($BuildingId))
    {
        $requestBody.building = $BuildingId
    }

    if (-not [String]::IsNullOrEmpty($Floor))
    {
        $requestBody.floor = $Floor
    }

    if (-not [String]::IsNullOrEmpty($FloorLabel))
    {
        $requestBody.floorLabel = $FloorLabel
    }

    if (-not [String]::IsNullOrEmpty($MapType))
    {
        $requestBody.mapType = $MapType
    }

    if (-not [String]::IsNullOrEmpty($MapImageUrl))
    {
        $requestBody.mapImageUrl = $MapImageUrl
    }

    if ($null -ne $Tags)
    {
        $requestBody.tags = $Tags
    }

    try
    {
        if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
        {
            Write-Verbose -Message "Creating Microsoft Place Map {$Identity}"
            $requestBody.'@odata.type' = '#microsoft.graph.room'
            $requestBody.placeType = 'Map'
            
            if ([String]::IsNullOrEmpty($DisplayName))
            {
                throw "DisplayName is required when creating a new Microsoft Place Map"
            }

            $uri = "https://graph.microsoft.com/beta/places"
            $createResponse = Invoke-MgGraphRequest -Uri $uri -Method POST -Body ($requestBody | ConvertTo-Json -Depth 10)
            Write-Verbose -Message "Successfully created Microsoft Place Map {$($createResponse.id)}"
        }
        elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
        {
            Write-Verbose -Message "Updating Microsoft Place Map {$Identity}"
            $uri = "https://graph.microsoft.com/beta/places/$Identity"
            Invoke-MgGraphRequest -Uri $uri -Method PATCH -Body ($requestBody | ConvertTo-Json -Depth 10)
            Write-Verbose -Message "Successfully updated Microsoft Place Map {$Identity}"
        }
        elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
        {
            Write-Verbose -Message "Removing Microsoft Place Map {$Identity}"
            $uri = "https://graph.microsoft.com/beta/places/$Identity"
            Invoke-MgGraphRequest -Uri $uri -Method DELETE
            Write-Verbose -Message "Successfully removed Microsoft Place Map {$Identity}"
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential
        throw $_
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $BuildingId,

        [Parameter()]
        [System.String]
        $Floor,

        [Parameter()]
        [System.String]
        $FloorLabel,

        [Parameter()]
        [System.String]
        $MapType,

        [Parameter()]
        [System.String]
        $MapImageUrl,

        [Parameter()]
        [System.String[]]
        $Tags,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Microsoft Place Map for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
    $ValuesToCheck.Remove('ManagedIdentity') | Out-Null
    $ValuesToCheck.Remove('AccessTokens') | Out-Null

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
        # Get all maps from Microsoft Places API
        $uri = "https://graph.microsoft.com/beta/places?\$filter=microsoft.graph.room/placeType eq 'Map'"
        $maps = Invoke-MgGraphRequest -Uri $uri -Method GET
        $dscContent = ''

        if ($maps.value.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }

        $i = 1
        foreach ($map in $maps.value)
        {
            Write-Host "    |---[$i/$($maps.value.Count)] $($map.displayName)" -NoNewline

            $params = @{
                Identity              = $map.id
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @params
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