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
        $Address,

        [Parameter()]
        [System.String]
        $City,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $CountryOrRegion,

        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [System.String]
        $Phone,

        [Parameter()]
        [System.String]
        $GeoCoordinates,

        [Parameter()]
        [System.UInt32]
        $Capacity,

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
        $Label,

        [Parameter()]
        [System.Boolean]
        $IsWheelChairAccessible,

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

    Write-Verbose -Message "Getting configuration of Microsoft Place Workspace for $Identity"

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
        # Get workspace from Microsoft Places API
        $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/places/$Identity"
        $workspace = Invoke-MgGraphRequest -Uri $uri -Method GET -ErrorAction SilentlyContinue

        if ($null -eq $workspace)
        {
            Write-Verbose -Message "Microsoft Place Workspace with Identity {$Identity} was not found"
            return $nullReturn
        }

        # Verify this is a workspace type place
        if ($workspace.'@odata.type' -ne '#microsoft.graph.room' -or 
            ($workspace.PlaceType -and $workspace.PlaceType -ne 'Workspace'))
        {
            Write-Verbose -Message "Place with Identity {$Identity} is not a workspace"
            return $nullReturn
        }

        Write-Verbose -Message "Found Microsoft Place Workspace with Identity {$Identity}"

        $result = @{
            Identity              = $workspace.id
            DisplayName           = $workspace.displayName
            Address               = $workspace.address.street
            City                  = $workspace.address.city
            State                 = $workspace.address.state
            CountryOrRegion       = $workspace.address.countryOrRegion
            PostalCode            = $workspace.address.postalCode
            Phone                 = $workspace.phone
            GeoCoordinates        = if ($workspace.geoCoordinates) { "$($workspace.geoCoordinates.latitude),$($workspace.geoCoordinates.longitude)" } else { $null }
            Capacity              = $workspace.capacity
            BuildingId            = $workspace.building
            Floor                 = $workspace.floor
            FloorLabel            = $workspace.floorLabel
            Label                 = $workspace.label
            IsWheelChairAccessible = [Boolean]$workspace.isWheelChairAccessible
            Tags                  = $workspace.tags
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
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
        $Address,

        [Parameter()]
        [System.String]
        $City,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $CountryOrRegion,

        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [System.String]
        $Phone,

        [Parameter()]
        [System.String]
        $GeoCoordinates,

        [Parameter()]
        [System.UInt32]
        $Capacity,

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
        $Label,

        [Parameter()]
        [System.Boolean]
        $IsWheelChairAccessible,

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

    Write-Verbose -Message "Setting configuration of Microsoft Place Workspace for $Identity"

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

    # Prepare request body
    $requestBody = @{}
    
    if (-not [String]::IsNullOrEmpty($DisplayName))
    {
        $requestBody.displayName = $DisplayName
    }

    if (-not [String]::IsNullOrEmpty($Phone))
    {
        $requestBody.phone = $Phone
    }

    if ($PSBoundParameters.ContainsKey('Capacity'))
    {
        $requestBody.capacity = $Capacity
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

    if (-not [String]::IsNullOrEmpty($Label))
    {
        $requestBody.label = $Label
    }

    if ($PSBoundParameters.ContainsKey('IsWheelChairAccessible'))
    {
        $requestBody.isWheelChairAccessible = $IsWheelChairAccessible
    }

    if ($null -ne $Tags)
    {
        $requestBody.tags = $Tags
    }

    # Handle address
    if (-not [String]::IsNullOrEmpty($Address) -or -not [String]::IsNullOrEmpty($City) -or 
        -not [String]::IsNullOrEmpty($State) -or -not [String]::IsNullOrEmpty($CountryOrRegion) -or 
        -not [String]::IsNullOrEmpty($PostalCode))
    {
        $requestBody.address = @{}
        if (-not [String]::IsNullOrEmpty($Address)) { $requestBody.address.street = $Address }
        if (-not [String]::IsNullOrEmpty($City)) { $requestBody.address.city = $City }
        if (-not [String]::IsNullOrEmpty($State)) { $requestBody.address.state = $State }
        if (-not [String]::IsNullOrEmpty($CountryOrRegion)) { $requestBody.address.countryOrRegion = $CountryOrRegion }
        if (-not [String]::IsNullOrEmpty($PostalCode)) { $requestBody.address.postalCode = $PostalCode }
    }

    # Handle geo coordinates
    if (-not [String]::IsNullOrEmpty($GeoCoordinates))
    {
        $coords = $GeoCoordinates.Split(',')
        if ($coords.Length -eq 2)
        {
            $requestBody.geoCoordinates = @{
                latitude = [double]$coords[0].Trim()
                longitude = [double]$coords[1].Trim()
            }
        }
    }

    try
    {
        if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
        {
            Write-Verbose -Message "Creating Microsoft Place Workspace {$Identity}"
            $requestBody.'@odata.type' = '#microsoft.graph.room'
            $requestBody.placeType = 'Workspace'
            
            if ([String]::IsNullOrEmpty($DisplayName))
            {
                throw "DisplayName is required when creating a new Microsoft Place Workspace"
            }

            $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/places"
            $createResponse = Invoke-MgGraphRequest -Uri $uri -Method POST -Body ($requestBody | ConvertTo-Json -Depth 10)
            Write-Verbose -Message "Successfully created Microsoft Place Workspace {$($createResponse.id)}"
        }
        elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
        {
            Write-Verbose -Message "Updating Microsoft Place Workspace {$Identity}"
            $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/places/$Identity"
            Invoke-MgGraphRequest -Uri $uri -Method PATCH -Body ($requestBody | ConvertTo-Json -Depth 10)
            Write-Verbose -Message "Successfully updated Microsoft Place Workspace {$Identity}"
        }
        elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
        {
            Write-Verbose -Message "Removing Microsoft Place Workspace {$Identity}"
            $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/places/$Identity"
            Invoke-MgGraphRequest -Uri $uri -Method DELETE
            Write-Verbose -Message "Successfully removed Microsoft Place Workspace {$Identity}"
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
        $Address,

        [Parameter()]
        [System.String]
        $City,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $CountryOrRegion,

        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [System.String]
        $Phone,

        [Parameter()]
        [System.String]
        $GeoCoordinates,

        [Parameter()]
        [System.UInt32]
        $Capacity,

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
        $Label,

        [Parameter()]
        [System.Boolean]
        $IsWheelChairAccessible,

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

    Write-Verbose -Message "Testing configuration of Microsoft Place Workspace for $Identity"

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
        # Get all workspaces from Microsoft Places API
        $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/places?\$filter=microsoft.graph.room/placeType eq 'Workspace'"
        $workspaces = Invoke-MgGraphRequest -Uri $uri -Method GET
        $dscContent = ''

        if ($workspaces.value.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }

        $i = 1
        foreach ($workspace in $workspaces.value)
        {
            Write-Host "    |---[$i/$($workspaces.value.Count)] $($workspace.displayName)" -NoNewline

            $params = @{
                Identity              = $workspace.id
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @params
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