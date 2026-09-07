Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADGSAPrivateAccessApplication'

$Script:PrivateAccessTemplateId = '8adf8e6e-67b2-4cf2-a259-e3dc5476c621'

function Invoke-AADGSAPrivateAccessApplicationGraphRequestWithRetry
{
    [CmdletBinding()]
    [OutputType([System.Object])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Method,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Uri,

        [Parameter()]
        [System.Collections.Hashtable]
        $Body,

        [Parameter()]
        [System.String]
        $PrimeGetUri,

        [Parameter()]
        [System.Int32]
        $MaxRetries = 5,

        [Parameter()]
        [System.Int32]
        $RetryDelaySeconds = 10
    )

    $retryCount = 0
    do
    {
        try
        {
            if (-not [string]::IsNullOrEmpty($PrimeGetUri))
            {
                # The application proxy backend needs the application to have been read at least once before it accepts writes to onPremisesPublishing, matching the GSA portal's own request pattern.
                $null = Invoke-MgGraphRequest -Method GET -Uri $PrimeGetUri -ErrorAction SilentlyContinue
            }
            $requestParams = @{
                Method      = $Method
                Uri         = $Uri
                ErrorAction = 'Stop'
            }
            if ($null -ne $Body)
            {
                $requestParams.Body = $Body
            }
            return Invoke-MgGraphRequest @requestParams
        }
        catch
        {
            $retryCount++
            if ($retryCount -ge $MaxRetries)
            {
                throw
            }
            # A newly instantiated application's onPremisesPublishing sub-resource is not immediately available and returns transient errors until provisioning completes.
            Write-Verbose -Message "Request to {$Uri} failed, retrying in $RetryDelaySeconds seconds ($retryCount/$MaxRetries)"
            Start-Sleep -Seconds $RetryDelaySeconds
        }
    } while ($true)
}

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateSet('nonwebapp', 'quickaccessapp')]
        [System.String]
        $ApplicationType,

        [Parameter()]
        [System.Boolean]
        $IsAccessibleViaZTNAClient,

        [Parameter()]
        [System.String]
        $ConnectorGroupName,

        [Parameter()]
        [System.Boolean]
        $IsDnsResolutionEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Segments,

        [Parameter()]
        [System.String]
        $ObjectId,

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

    Write-Verbose -Message "Getting configuration of AAD GSA Private Access Application {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.displayName -ne $DisplayName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

            $baseUrl = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl
            $getValue = $null

            if (-not [string]::IsNullOrEmpty($ObjectId))
            {
                try
                {
                    # onPremisesPublishing is not returned on a bare GET and must be explicitly selected.
                    $getValue = Invoke-MgGraphRequest -Method GET `
                        -Uri ($baseUrl + "beta/applications/${ObjectId}?`$select=id,appId,displayName,onPremisesPublishing") `
                        -ErrorAction Stop
                }
                catch
                {
                    # Invoke-MgGraphRequest throws a terminating error on 404 even with -ErrorAction SilentlyContinue, so fall back to the DisplayName lookup below.
                    $getValue = $null
                }
            }

            if ($null -eq $getValue)
            {
                $filter = "applicationTemplateId eq '$Script:PrivateAccessTemplateId' and displayName eq '$(($DisplayName -replace "'", "''"))'"
                try
                {
                    # onPremisesPublishing is not returned on a bare GET and must be explicitly selected.
                    $response = Invoke-MgGraphRequest -Method GET `
                        -Uri ($baseUrl + "beta/applications?`$filter=$filter&`$select=id,appId,displayName,onPremisesPublishing") `
                        -ErrorAction Stop
                    if ($null -ne $response -and $response.value.Count -gt 0)
                    {
                        $getValue = $response.value[0]
                    }
                }
                catch
                {
                    $getValue = $null
                }
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find AAD GSA Private Access Application {$DisplayName}"
            return $nullResult
        }

        $appId = $getValue.id
        $baseUrl = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl

        $onPremPub = $getValue.onPremisesPublishing

        $connectorGroupName = $null
        try
        {
            # An application with no connector group assigned returns a 404 here, which is expected.
            $connectorGroupResponse = Invoke-MgGraphRequest -Method GET `
                -Uri ($baseUrl + "beta/applications/$appId/connectorGroup") `
                -ErrorAction Stop
            if ($null -ne $connectorGroupResponse -and -not [string]::IsNullOrEmpty($connectorGroupResponse.name))
            {
                $connectorGroupName = $connectorGroupResponse.name
            }
        }
        catch
        {
            $connectorGroupName = $null
        }

        $complexSegments = @()
        try
        {
            $segmentsResponse = Invoke-MgGraphRequest -Method GET `
                -Uri ($baseUrl + "beta/applications/$appId/onPremisesPublishing/segmentsConfiguration/microsoft.graph.ipSegmentConfiguration/applicationSegments") `
                -ErrorAction Stop
        }
        catch
        {
            $segmentsResponse = $null
        }
        if ($null -ne $segmentsResponse -and $null -ne $segmentsResponse.value)
        {
            foreach ($seg in $segmentsResponse.value)
            {
                $complexSegments += @{
                    Id              = $seg.id
                    DestinationHost = $seg.destinationHost
                    DestinationType = ConvertFrom-AADGSADestinationTypeGraphValue -DestinationType $seg.destinationType
                    Ports           = [System.String[]]$seg.ports
                    Protocol        = $seg.protocol
                }
            }
        }

        $results = @{
            DisplayName              = $getValue.displayName
            ApplicationType          = $onPremPub.applicationType
            IsAccessibleViaZTNAClient = $onPremPub.isAccessibleViaZTNAClient
            ConnectorGroupName       = $connectorGroupName
            IsDnsResolutionEnabled   = $onPremPub.isDnsResolutionEnabled
            Segments                 = $complexSegments
            ObjectId                 = $appId
            Ensure                   = 'Present'
            Credential               = $Credential
            ApplicationId            = $ApplicationId
            TenantId                 = $TenantId
            ApplicationSecret        = $ApplicationSecret
            CertificateThumbprint    = $CertificateThumbprint
            CertificatePath          = $CertificatePath
            CertificatePassword      = $CertificatePassword
            ManagedIdentity          = $ManagedIdentity.IsPresent
            AccessTokens             = $AccessTokens
        }
        return $results
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
        $DisplayName,

        [Parameter()]
        [ValidateSet('nonwebapp', 'quickaccessapp')]
        [System.String]
        $ApplicationType,

        [Parameter()]
        [System.Boolean]
        $IsAccessibleViaZTNAClient,

        [Parameter()]
        [System.String]
        $ConnectorGroupName,

        [Parameter()]
        [System.Boolean]
        $IsDnsResolutionEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Segments,

        [Parameter()]
        [System.String]
        $ObjectId,

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

    Write-Verbose -Message "Setting configuration of AAD Private Access Application {$DisplayName}"

    $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

    $currentInstance = Get-TargetResource @PSBoundParameters
    $baseUrl = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating AAD Private Access Application {$DisplayName}"

        $instantiateBody = @{
            displayName = $DisplayName
        }
        $newApp = Invoke-MgGraphRequest -Method POST `
            -Uri ($baseUrl + "beta/applicationTemplates/$Script:PrivateAccessTemplateId/instantiate") `
            -Body $instantiateBody

        # The beta instantiate response exposes the application's id as 'objectId', not 'id' like v1.0 does.
        $appId = $newApp.application.objectId
        if ([string]::IsNullOrEmpty($appId))
        {
            $appId = $newApp.application.id
        }

        $onPremBody = @{
            applicationType           = $ApplicationType
            isAccessibleViaZTNAClient = $IsAccessibleViaZTNAClient
            trafficRoutingMethod      = 'none'
        }
        Invoke-AADGSAPrivateAccessApplicationGraphRequestWithRetry -Method PATCH `
            -Uri ($baseUrl + "beta/applications/$appId/onPremisesPublishing") `
            -Body $onPremBody `
            -PrimeGetUri ($baseUrl + "beta/applications/$appId") | Out-Null

        if (-not [string]::IsNullOrEmpty($ConnectorGroupName))
        {
            Set-AADGSAPrivateAccessApplicationConnectorGroup -AppId $appId -ConnectorGroupName $ConnectorGroupName -BaseUrl $baseUrl
        }

        if ($null -ne $Segments -and $Segments.Count -gt 0)
        {
            foreach ($segment in $Segments)
            {
                Add-AADGSAPrivateAccessApplicationSegment -AppId $appId -Segment $segment -BaseUrl $baseUrl
            }
        }

        if ($IsDnsResolutionEnabled)
        {
            $dnsBody = @{
                isDnsResolutionEnabled = $true
            }
            Invoke-AADGSAPrivateAccessApplicationGraphRequestWithRetry -Method PATCH `
                -Uri ($baseUrl + "beta/applications/$appId/onPremisesPublishing") `
                -Body $dnsBody | Out-Null
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        $appId = $currentInstance.ObjectId
        Write-Verbose -Message "Updating AAD GSA Private Access Application {$DisplayName} with Id {$appId}"

        $onPremBody = @{}
        $onPremUpdated = $false

        if ($PSBoundParameters.ContainsKey('ApplicationType') -and $ApplicationType -ne $currentInstance.ApplicationType)
        {
            $onPremBody.applicationType = $ApplicationType
            $onPremUpdated = $true
        }
        if ($PSBoundParameters.ContainsKey('IsAccessibleViaZTNAClient') -and $IsAccessibleViaZTNAClient -ne $currentInstance.IsAccessibleViaZTNAClient)
        {
            $onPremBody.isAccessibleViaZTNAClient = $IsAccessibleViaZTNAClient
            $onPremUpdated = $true
        }
        if ($PSBoundParameters.ContainsKey('IsDnsResolutionEnabled') -and $IsDnsResolutionEnabled -ne $currentInstance.IsDnsResolutionEnabled)
        {
            $onPremBody.isDnsResolutionEnabled = $IsDnsResolutionEnabled
            $onPremUpdated = $true
        }

        if ($onPremUpdated)
        {
            Invoke-AADGSAPrivateAccessApplicationGraphRequestWithRetry -Method PATCH `
                -Uri ($baseUrl + "beta/applications/$appId/onPremisesPublishing") `
                -Body $onPremBody | Out-Null
        }

        if ($PSBoundParameters.ContainsKey('ConnectorGroupName') -and $ConnectorGroupName -ne $currentInstance.ConnectorGroupName)
        {
            Set-AADGSAPrivateAccessApplicationConnectorGroup -AppId $appId -ConnectorGroupName $ConnectorGroupName -BaseUrl $baseUrl
        }

        if ($PSBoundParameters.ContainsKey('Segments'))
        {
            Sync-AADGSAPrivateAccessApplicationSegments `
                -AppId $appId `
                -DesiredSegments $Segments `
                -CurrentSegments $currentInstance.Segments `
                -BaseUrl $baseUrl
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        $appId = $currentInstance.ObjectId
        Write-Verbose -Message "Removing AAD Private Access Application {$DisplayName} with Id {$appId}"
        Invoke-MgGraphRequest -Method DELETE `
            -Uri ($baseUrl + "v1.0/applications/$appId") | Out-Null
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
        $DisplayName,

        [Parameter()]
        [ValidateSet('nonwebapp', 'quickaccessapp')]
        [System.String]
        $ApplicationType,

        [Parameter()]
        [System.Boolean]
        $IsAccessibleViaZTNAClient,

        [Parameter()]
        [System.String]
        $ConnectorGroupName,

        [Parameter()]
        [System.Boolean]
        $IsDnsResolutionEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Segments,

        [Parameter()]
        [System.String]
        $ObjectId,

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
        [System.String]
        $Filter,

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
        $baseUrl = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl
        $filterQuery = "applicationTemplateId eq '$Script:PrivateAccessTemplateId'"
        if (-not [string]::IsNullOrEmpty($Filter))
        {
            $filterQuery = "$filterQuery and $Filter"
        }
        # Graph rejects $select combined with $filter for onPremisesPublishing on this collection, so the per-item GET below (Get-TargetResource) must be used to retrieve it.
        $response = Invoke-MgGraphRequest -Method GET `
            -Uri ($baseUrl + "beta/applications?`$filter=$filterQuery") `
            -ErrorAction Stop
        [array]$exportedInstances = $response.value

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.displayName
            Write-M365DSCHost -Message "    |---[$i/$($exportedInstances.Count)] $displayedKey" -DeferWrite
            $params = @{
                DisplayName           = $config.displayName
                ObjectId              = $config.id
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            # $config from the list query lacks onPremisesPublishing (not selectable on this collection), so force Get-TargetResource to do its own fresh, correctly-selected GET.
            $Script:exportedInstance = $null
            $Results = Get-TargetResource @params

            if ($null -ne $Results.Segments -and $Results.Segments.Count -gt 0)
            {
                $complexMapping = @(
                    @{
                        Name            = 'Segments'
                        CimInstanceName = 'AADGSAPrivateAccessApplicationSegment'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Segments `
                    -CIMInstanceName 'AADGSAPrivateAccessApplicationSegment' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Segments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Segments') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Segments')

            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent.ToString()
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

function Set-AADGSAPrivateAccessApplicationConnectorGroup
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ConnectorGroupName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $BaseUrl
    )

    $groupResponse = Invoke-MgGraphRequest -Method GET `
        -Uri ($BaseUrl + "beta/onPremisesPublishingProfiles/applicationProxy/connectorGroups?`$filter=name eq '$(($ConnectorGroupName -replace "'", "''"))'") `
        -ErrorAction Stop

    if ($null -eq $groupResponse -or $groupResponse.value.Count -eq 0)
    {
        throw "Could not find connector group with name: $ConnectorGroupName"
    }

    $connectorGroupId = $groupResponse.value[0].id
    $refBody = @{
        '@odata.id' = $BaseUrl + "beta/onPremisesPublishingProfiles/applicationproxy/connectorGroups/$connectorGroupId"
    }
    Invoke-AADGSAPrivateAccessApplicationGraphRequestWithRetry -Method PUT `
        -Uri ($BaseUrl + "beta/applications/$AppId/connectorGroup/`$ref") `
        -Body $refBody | Out-Null
}

function ConvertTo-AADGSADestinationTypeGraphValue
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DestinationType
    )

    # The Global Secure Access API accepts 'ip' on the wire for the documented 'ipAddress' value.
    if ($DestinationType -eq 'ipAddress')
    {
        return 'ip'
    }
    return $DestinationType
}

function ConvertFrom-AADGSADestinationTypeGraphValue
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DestinationType
    )

    if ($DestinationType -eq 'ip')
    {
        return 'ipAddress'
    }
    return $DestinationType
}

function Add-AADGSAPrivateAccessApplicationSegment
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppId,

        [Parameter(Mandatory = $true)]
        [System.Object]
        $Segment,

        [Parameter(Mandatory = $true)]
        [System.String]
        $BaseUrl
    )

    $segmentBody = @{
        destinationHost = $Segment.DestinationHost
        destinationType = ConvertTo-AADGSADestinationTypeGraphValue -DestinationType $Segment.DestinationType
    }
    if ($null -ne $Segment.Ports -and $Segment.Ports.Count -gt 0)
    {
        $segmentBody.ports = [System.Collections.ArrayList]@($Segment.Ports)
    }
    if (-not [string]::IsNullOrEmpty($Segment.Protocol))
    {
        $segmentBody.protocol = $Segment.Protocol
    }

    Invoke-AADGSAPrivateAccessApplicationGraphRequestWithRetry -Method POST `
        -Uri ($BaseUrl + "beta/applications/$AppId/onPremisesPublishing/segmentsConfiguration/microsoft.graph.ipSegmentConfiguration/applicationSegments") `
        -Body $segmentBody | Out-Null
}

function Sync-AADGSAPrivateAccessApplicationSegments
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppId,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [System.Object[]]
        $DesiredSegments,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [System.Object[]]
        $CurrentSegments,

        [Parameter(Mandatory = $true)]
        [System.String]
        $BaseUrl
    )

    $matchedCurrentIds = @()

    foreach ($desired in $DesiredSegments)
    {
        $desiredHost = $desired.DestinationHost
        $desiredType = $desired.DestinationType
        $matchFound = $false

        foreach ($current in $CurrentSegments)
        {
            if ($current.Id -notin $matchedCurrentIds -and
                $current.DestinationHost -eq $desiredHost -and
                $current.DestinationType -eq $desiredType)
            {
                $matchedCurrentIds += $current.Id
                $matchFound = $true

                $updateBody = @{}
                if ($null -ne $desired.Ports -and $desired.Ports.Count -gt 0)
                {
                    $updateBody.ports = [System.Collections.ArrayList]@($desired.Ports)
                }
                if (-not [string]::IsNullOrEmpty($desired.Protocol))
                {
                    $updateBody.protocol = $desired.Protocol
                }
                if ($updateBody.Count -gt 0)
                {
                    Invoke-MgGraphRequest -Method PATCH `
                        -Uri ($BaseUrl + "beta/applications/$AppId/onPremisesPublishing/segmentsConfiguration/microsoft.graph.ipSegmentConfiguration/applicationSegments/$($current.Id)") `
                        -Body $updateBody | Out-Null
                }
                break
            }
        }

        if (-not $matchFound)
        {
            Add-AADGSAPrivateAccessApplicationSegment -AppId $AppId -Segment $desired -BaseUrl $BaseUrl
        }
    }

    foreach ($current in $CurrentSegments)
    {
        if ($current.Id -notin $matchedCurrentIds)
        {
            Invoke-MgGraphRequest -Method DELETE `
                -Uri ($BaseUrl + "beta/applications/$AppId/onPremisesPublishing/segmentsConfiguration/microsoft.graph.ipSegmentConfiguration/applicationSegments/$($current.Id)") | Out-Null
        }
    }
}

Export-ModuleMember -Function *-TargetResource
