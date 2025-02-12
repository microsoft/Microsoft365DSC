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
        [System.String]
        $PolicyName,

        [Parameter()]
        [System.String[]]
        $Environments,

        [Parameter()]
        [System.String]
        $FilterType,

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
    New-M365DSCConnection -Workload 'PowerPlatformREST' `
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
        $uri = "https://" + (Get-MSCloudLoginConnectionProfile -Workload 'PowerPlatformREST').BapEndpoint + `
               "/providers/Microsoft.BusinessAppPlatform/scopes/admin/apiPolicies?api-version=2016-11-01"

        $policies = Invoke-M365DSCPowerPlatformRESTWebRequest -Uri $uri -Method 'GET'

        $instance = $null
        foreach ($policyInfo in $policies.value)
        {
            if ($policyInfo.properties.displayName -eq $DisplayName)
            {
                $instance = $policyInfo
            }
        }
        if ($null -eq $instance)
        {
            return $nullResult
        }

        $results = @{
            DisplayName           = $instance.properties.displayName
            PolicyName            = $instance.PolicyName
            Environments          = [array]$instance.properties.definition.constraints.environmentFilter1.parameters.environments.name
            FilterType            = $instance.properties.definition.constraints.environmentFilter1.parameters.filterType
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $PolicyName,

        [Parameter()]
        [System.String[]]
        $Environments,

        [Parameter()]
        [System.String]
        $FilterType,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters
    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    $schema = "https://schema.management.azure.com/providers/Microsoft.BusinessAppPlatform/schemas/2016-10-01-preview/apiPolicyDefinition.json#"
    $constraints = @{}
    if ($null -ne $Environments -and $Environments.Length -gt 0)
    {
        $environmentInfo = @()
        foreach ($environment in $Environments)
        {
            $uri = "https://" + (Get-MSCloudLoginConnectionProfile -Workload 'PowerPlatformREST').BapEndpoint + `
                "/providers/Microsoft.BusinessAppPlatform/scopes/admin/environments/$($environment)?`$expand=permissions&api-version=2016-11-01"

            Write-Verbose -Message "Creating new policy with body:`r`n$(ConvertTo-Json $newPolicy -Depth 20)"
            $environmentInfo += Invoke-M365DSCPowerPlatformRESTWebRequest -Uri $uri -Method 'GET'
        }

        $constraints = @{
            environmentFilter1 = @{
                parameters = @{
                    environments = $environmentInfo
                    filterType = $FilterType
                }
                type = "environmentFilter"
            }
        }
    }
    $rules = @{
        dataFlowRule = @{
            actions = @{
                blockAction = @{
                    type = "Block"
                }
            }
            parameters = @{
                destinationApiGroup = "lbi"
                sourceApiGroup = "hbi"
            }
            type = "DataFlowRestriction"
        }
    }
    $CreatedTime = Get-Date -Format "o"
    $policyObject = @{
        id = ""
        name = ""
        type = $type
        tags = @{}
        properties = @{
            createdTime = $CreatedTime
            displayName = $DisplayName
            definition = @{
                "`$schema" = $schema
                defaultApiGroup = "lbi"
                constraints = $constraints
                apiGroups = @{
                    hbi = @{
                        apis = $hbiApis
                        description = "Business data only"
                    }
                    lbi = @{
                        apis =  @()
                        description = $lbiDescription
                    }
                }
                rules = $rules
            }
        }
    }

    # CREATE
    $needToUpdateNewInstance = $false
    $policyName = $currentInstance.PolicyName
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Data Policy {$DisplayName}"
        $uri = "https://" + (Get-MSCloudLoginConnectionProfile -Workload 'PowerPlatformREST').BapEndpoint + `
               "/providers/Microsoft.BusinessAppPlatform/scopes/admin/apiPolicies?api-version=2016-11-01"


        Write-Verbose -Message "Creating new policy with body:`r`n$(ConvertTo-Json $newPolicy -Depth 20)"
        $policy = Invoke-M365DSCPowerPlatformRESTWebRequest -Uri $uri -Method 'POST' -Body $policyObject
        $policyName = $policy.name
    }
    if ($setParameters.ContainsKey('PolicyName'))
    {
        $setParameters.PolicyName = $policyName
    }
    else
    {
        $setParameters.Add('PolicyName', $policyName)
    }

    # UPDATE
    if (($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present') -or $needToUpdateNewInstance)
    {
        Write-Verbose -Message "Updating Data Policy {$DisplayName}"
        $setParameters.Remove('DisplayName') | Out-Null

        if ($null -ne $setParameters.Environments -and $setParameters.Environments.Count -gt 0)
        {
            $setParameters.Environments = ($setParameters.Environments -join ',')
        }
        Write-Verbose -Message "Updating Data Policy {$DisplayName} with values:`r`n$(Convert-M365DscHashtableToString -Hashtable $setParameters)"
        $uri = "https://" + (Get-MSCloudLoginConnectionProfile -Workload 'PowerPlatformREST').BapEndpoint + `
               "/providers/Microsoft.BusinessAppPlatform/scopes/admin/apiPolicies/$($policyName)?api-version=2016-11-01"

        $policy = Invoke-M365DSCPowerPlatformRESTWebRequest -Uri $uri -Method 'PUT' -Body $policyObject
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Data Policy {$DisplayName}"
        $uri = "https://" + (Get-MSCloudLoginConnectionProfile -Workload 'PowerPlatformREST').BapEndpoint + `
               "/providers/Microsoft.BusinessAppPlatform/scopes/admin/apiPolicies/$($policyName)?api-version=2016-11-01"

        $policy = Invoke-M365DSCPowerPlatformRESTWebRequest -Uri $uri -Method 'DELETE'
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
        [System.String]
        $PolicyName,

        [Parameter()]
        [System.String[]]
        $Environments,

        [Parameter()]
        [System.String]
        $FilterType,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'PowerPlatformREST' `
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
        $uri = "https://" + (Get-MSCloudLoginConnectionProfile -Workload 'PowerPlatformREST').BapEndpoint + `
            "/providers/Microsoft.BusinessAppPlatform/scopes/admin/apiPolicies?api-version=2016-11-01"

        [array] $Script:exportedInstances = Invoke-M365DSCPowerPlatformRESTWebRequest -Uri $uri -Method 'GET'

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
        foreach ($config in $Script:exportedInstances.value)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.properties.displayName
            Write-Host "    |---[$i/$($Script:exportedInstances.value.Count)] $displayedKey" -NoNewline
            $params = @{
                DisplayName           = $config.properties.displayName
                PolicyName            = $config.name
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
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
