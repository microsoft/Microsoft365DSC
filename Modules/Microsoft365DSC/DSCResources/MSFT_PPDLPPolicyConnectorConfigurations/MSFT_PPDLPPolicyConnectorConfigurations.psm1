function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $PPTenantId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $PolicyName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ConnectorActionConfigurations,

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

    New-M365DSCConnection -Workload 'PowerPlatforms' `
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

        $policy = $null
        foreach ($policyInfo in $policies.value)
        {
            if ($policyInfo.properties.displayName -eq $PolicyName)
            {
                $policy = $policyInfo
            }
        }

        if ($null -eq $policy)
        {
            return $nullResult
        }

        $uri = "https://" + (Get-MSCloudLoginConnectionProfile -Workload 'PowerPlatformREST').BapEndpoint + `
               "/providers/PowerPlatform.Governance/v1/tenants/$($PPTenantId)/policies/$($policy.Name)/policyconnectorconfigurations"

        $ActionList = Invoke-M365DSCPowerPlatformRESTWebRequest -Uri $uri -Method 'GET'
        $ActionsValue = @()
        foreach ($action in $ActionList.connectorActionConfigurations)
        {
            $entry = @{
                connectorId                        = $action.connectorId
                defaultConnectorActionRuleBehavior = $action.defaultConnectorActionRuleBehavior
            }

            $actionRulesValues = @()
            foreach ($rule in $action.actionRules)
            {
                $actionRulesValues += @{
                    actionId = $rule.actionId
                    behavior = $rule.behavior
                }
            }
            $entry.Add('actionRules', $actionRulesValues)
            $ActionsValue += $entry
        }

        $results = @{
            PPTenantId                    = $PPTenantId
            PolicyName                    = $PolicyName
            ConnectorActionConfigurations = $ActionsValue
            Ensure                        = 'Present'
            Credential                    = $Credential
            ApplicationId                 = $ApplicationId
            TenantId                      = $TenantId
            CertificateThumbprint         = $CertificateThumbprint
            ManagedIdentity               = $ManagedIdentity.IsPresent
            AccessTokens                  = $AccessTokens
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
        $PPTenantId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $PolicyName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ConnectorActionConfigurations,

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

    $uri = "https://" + (Get-MSCloudLoginConnectionProfile -Workload 'PowerPlatformREST').BapEndpoint + `
        "/providers/Microsoft.BusinessAppPlatform/scopes/admin/apiPolicies?api-version=2016-11-01"

    $policies = Invoke-M365DSCPowerPlatformRESTWebRequest -Uri $uri -Method 'GET'

    $policy = $null
    foreach ($policyInfo in $policies.value)
    {
        if ($policyInfo.properties.displayName -eq $PolicyName)
        {
            $policy = $policyInfo
        }
    }
    # CREATE
    if ($Ensure -eq 'Present')
    {
        $body = @{
            connectorActionConfigurations = @()
        }

        foreach ($action in $connectorActionConfigurations)
        {
            $entry = @{
                connectorId                        = $action.connectorId
                defaultConnectorActionRuleBehavior = $action.defaultConnectorActionRuleBehavior
            }

            $ruleValues = @()
            foreach ($rule in $actionRules)
            {
                $ruleValues += @{
                    actionId = $rule.actionId
                    behavior = $rule.behavior
                }
            }
            $entry.Add('actionRules', $ruleValues)
            $body.connectorActionConfigurations += $entry
        }
        $payload = $(ConvertTo-Json $body -Depth 9 -Compress)
        Write-Verbose -Message "Setting Connector Configuration for Policy {$($PolicyNameValue)} with parameters:`r`n$payload"

        $uri = "https://" + (Get-MSCloudLoginConnectionProfile -Workload 'PowerPlatformREST').BapEndpoint + `
               "/providers/PowerPlatform.Governance/v1/tenants/$($PPTenantId)/policies/$($policy.Name)/policyconnectorconfigurations"

        Invoke-M365DSCPowerPlatformRESTWebRequest -Uri $uri -Method 'POST' -Body $body
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Removing Connector Configuration for Policy {$($PolicyNameValue)}"
        $uri = "https://" + (Get-MSCloudLoginConnectionProfile -Workload 'PowerPlatformREST').BapEndpoint + `
               "/providers/PowerPlatform.Governance/v1/tenants/$($PPTenantId)/policies/$($policy.Name)/policyconnectorconfigurations"

        Invoke-M365DSCPowerPlatformRESTWebRequest -Uri $uri -Method 'DELETE'
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
        $PPTenantId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $PolicyName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ConnectorActionConfigurations,

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

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($source.getType().Name -like '*CimInstance*')
        {
            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }
    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

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

        [array]$policies = Invoke-M365DSCPowerPlatformRESTWebRequest -Uri $uri -Method 'GET'
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters
        $tenantinfo = (Get-MgContext)

        $dscContent = ''
        if ($policies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($policy in $policies.value)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }
            Write-Host "    |---[$i/$($policies.value.Count)] $($policy.properties.DisplayName)" -NoNewline
            $params = @{
                PPTenantId            = $tenantInfo.TenantId
                PolicyName            = $policy.properties.displayName
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

            if ($null -ne $Results.ConnectorActionConfigurations)
            {
                $complexMapping = @(
                    @{
                        Name            = 'actionRules'
                        CimInstanceName = 'PPDLPPolicyConnectorConfigurationsActionRules'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ConnectorActionConfigurations `
                    -CIMInstanceName 'PPDLPPolicyConnectorConfigurationsAction' `
                    -ComplexTypeMapping $complexMapping
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ConnectorActionConfigurations = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ConnectorActionConfigurations') | Out-Null
                }
            }
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            if ($Results.ConnectorActionConfigurations)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'ConnectorActionConfigurations' -IsCIMArray:$true
            }
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $k++
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
