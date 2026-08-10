Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADGSAPrivateAccessApplication'

$Script:PrivateAccessTemplateId = '8adf8e6e-67b2-4cf2-a259-e3dc5476c621'

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
                $getValue = Invoke-MgGraphRequest -Method GET `
                    -Uri ($baseUrl + "beta/applications/$ObjectId") `
                    -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                $filter = "applicationTemplateId eq '$Script:PrivateAccessTemplateId' and displayName eq '$(($DisplayName -replace "'", "''"))'"
                $response = Invoke-MgGraphRequest -Method GET `
                    -Uri ($baseUrl + "beta/applications?`$filter=$filter") `
                    -ErrorAction SilentlyContinue
                if ($null -ne $response -and $response.value.Count -gt 0)
                {
                    $getValue = $response.value[0]
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
        $connectorGroupResponse = Invoke-MgGraphRequest -Method GET `
            -Uri ($baseUrl + "beta/applications/$appId/connectorGroup") `
            -ErrorAction SilentlyContinue
        if ($null -ne $connectorGroupResponse -and -not [string]::IsNullOrEmpty($connectorGroupResponse.name))
        {
            $connectorGroupName = $connectorGroupResponse.name
        }

        $complexSegments = @()
        $segmentsResponse = Invoke-MgGraphRequest -Method GET `
            -Uri ($baseUrl + "beta/applications/$appId/onPremisesPublishing/segmentsConfiguration/microsoft.graph.ipSegmentConfiguration/applicationSegments") `
            -ErrorAction SilentlyContinue
        if ($null -ne $segmentsResponse -and $null -ne $segmentsResponse.value)
        {
            foreach ($seg in $segmentsResponse.value)
            {
                $complexSegments += @{
                    Id              = $seg.id
                    DestinationHost = $seg.destinationHost
                    DestinationType = $seg.destinationType
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
            -Uri ($baseUrl + "v1.0/applicationTemplates/$Script:PrivateAccessTemplateId/instantiate") `
            -Body $instantiateBody

        $appId = $newApp.application.id

        $onPremBody = @{
            onPremisesPublishing = @{
                applicationType           = $ApplicationType
                isAccessibleViaZTNAClient = $IsAccessibleViaZTNAClient
            }
        }
        Invoke-MgGraphRequest -Method PATCH `
            -Uri ($baseUrl + "beta/applications/$appId") `
            -Body $onPremBody | Out-Null

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
            Invoke-MgGraphRequest -Method PATCH `
                -Uri ($baseUrl + "beta/applications/$appId/onPremisesPublishing") `
                -Body $dnsBody | Out-Null
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        $appId = $currentInstance.ObjectId
        Write-Verbose -Message "Updating AAD GSA Private Access Application {$DisplayName} with Id {$appId}"

        $onPremBody = @{
            onPremisesPublishing = @{}
        }
        $onPremUpdated = $false

        if ($PSBoundParameters.ContainsKey('ApplicationType') -and $ApplicationType -ne $currentInstance.ApplicationType)
        {
            $onPremBody.onPremisesPublishing.applicationType = $ApplicationType
            $onPremUpdated = $true
        }
        if ($PSBoundParameters.ContainsKey('IsAccessibleViaZTNAClient') -and $IsAccessibleViaZTNAClient -ne $currentInstance.IsAccessibleViaZTNAClient)
        {
            $onPremBody.onPremisesPublishing.isAccessibleViaZTNAClient = $IsAccessibleViaZTNAClient
            $onPremUpdated = $true
        }
        if ($PSBoundParameters.ContainsKey('IsDnsResolutionEnabled') -and $IsDnsResolutionEnabled -ne $currentInstance.IsDnsResolutionEnabled)
        {
            $onPremBody.onPremisesPublishing.isDnsResolutionEnabled = $IsDnsResolutionEnabled
            $onPremUpdated = $true
        }

        if ($onPremUpdated)
        {
            Invoke-MgGraphRequest -Method PATCH `
                -Uri ($baseUrl + "beta/applications/$appId") `
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

            $Script:exportedInstance = $config
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
    Invoke-MgGraphRequest -Method PUT `
        -Uri ($BaseUrl + "beta/applications/$AppId/connectorGroup/`$ref") `
        -Body $refBody | Out-Null
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
        destinationType = $Segment.DestinationType
    }
    if ($null -ne $Segment.Ports -and $Segment.Ports.Count -gt 0)
    {
        $segmentBody.ports = [System.Collections.ArrayList]@($Segment.Ports)
    }
    if (-not [string]::IsNullOrEmpty($Segment.Protocol))
    {
        $segmentBody.protocol = $Segment.Protocol
    }

    Invoke-MgGraphRequest -Method POST `
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
