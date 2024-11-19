function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $BillingAccount,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnterpriseAgreementPolicies,

        [Parameter()]
        [System.String]
        $MarketplacePurchases,

        [Parameter()]
        [System.String]
        $ReservationPurchases,

        [Parameter()]
        [System.String]
        $SavingsPlanPurchases,

        [Parameter()]
        [System.String]
        $Name,

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

    New-M365DSCConnection -Workload 'Azure' `
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
        $uri = "https://management.azure.com/providers/Microsoft.Billing/billingAccounts/$($BillingAccount)/policies/default?api-version=2024-04-01"
        $response = Invoke-AzRest -Uri $uri -Method GET
        $instance = (ConvertFrom-Json ($response.Content)).value

        if ($null -eq $instance)
        {
            return $nullResult
        }

        $EnterpriseAgreementPoliciesValue = $null
        if ($null -ne $EnterpriseAgreementPolicies)
        {
            $EnterpriseAgreementPoliciesValue = @{
                accountOwnerViewCharges    = $instance.properties.enterpriseAgreementPolicies.accountOwnerViewCharges
                authenticationType         = $instance.properties.enterpriseAgreementPolicies.authenticationType
                departmentAdminViewCharges = $instance.properties.enterpriseAgreementPolicies.departmentAdminViewCharges
            }
        }

        $results = @{
            BillingAccount              = $BillingAccount
            Name                        = $instance.name
            EnterpriseAgreementPolicies = $EnterpriseAgreementPoliciesValue
            MarketplacePurchases        = $instance.properties.marketplacePurchases
            ReservationPurchases        = $instance.properties.reservationPurchases
            SavingsPlanPurchases        = $instance.properties.savingsPlanPurchases
            Ensure                      = 'Present'
            Credential                  = $Credential
            ApplicationId               = $ApplicationId
            TenantId                    = $TenantId
            CertificateThumbprint       = $CertificateThumbprint
            ManagedIdentity             = $ManagedIdentity.IsPresent
            AccessTokens                = $AccessTokens
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
        $BillingAccount,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnterpriseAgreementPolicies,

        [Parameter()]
        [System.String]
        $MarketplacePurchases,

        [Parameter()]
        [System.String]
        $ReservationPurchases,

        [Parameter()]
        [System.String]
        $SavingsPlanPurchases,

        [Parameter()]
        [System.String]
        $Name,

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

    New-M365DSCConnection -Workload 'Azure' `
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

    $instanceParams = @{
        properties = @{
            enterpriseAgreementPolicies = @{
                accountOwnerViewCharges    = $EnterpriseAgreementPolicies.accountOwnerViewCharges
                authenticationType         = $EnterpriseAgreementPolicies.authenticationType
                departmentAdminViewCharges = $EnterpriseAgreementPolicies.departmentAdminViewCharges
            }
            marketplacePurchases = $MarketplacePurchases
            reservationPurchases = $ReservationPurchases
            savingsPlanPurchases = $SavingsPlanPurchases
        }
    }
    $payload = ConvertTo-Json $instanceParams -Depth 5 -Compress
    Write-Verbose -Message "Updating billing account policy for {$BillingAccount} with payload:`r`n$($payload)"
    $uri = "https://management.azure.com/providers/Microsoft.Billing/billingAccounts/$($BillingAccount)/policies/default?api-version=2024-04-01"
    $response = Invoke-AzRest -Uri $uri -Method "PUT" -Payload $payload
    if (-not [System.String]::IsNullOrEmpty($response.Error))
    {
        throw "Error: $($response.Error)"
    }
    Write-Verbose -Message "Response:`r`n$($response.Content)"
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $BillingAccount,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnterpriseAgreementPolicies,

        [Parameter()]
        [System.String]
        $MarketplacePurchases,

        [Parameter()]
        [System.String]
        $ReservationPurchases,

        [Parameter()]
        [System.String]
        $SavingsPlanPurchases,

        [Parameter()]
        [System.String]
        $Name,

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
    $testResult = $true

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

    $ConnectionMode = New-M365DSCConnection -Workload 'Azure' `
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

        #Get all billing account
        $accounts = Get-M365DSCAzureBillingAccount

        $i = 1
        $dscContent = ''
        if ($accounts.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($account in $accounts.value)
        {
            $displayedKey = $account.properties.displayName
            Write-Host "    |---[$i/$($accounts.value.Length)] $displayedKey" -NoNewline

            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }
            $params = @{
                BillingAccount        = $account.name
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

            if ($Results.EnterpriseAgreementPolicies)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.EnterpriseAgreementPolicies -CIMInstanceName AzureBillingAccountPolicyEnterpriseAgreementPolicy
                if ($complexTypeStringResult)
                {
                    $Results.EnterpriseAgreementPolicies = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('EnterpriseAgreementPolicies') | Out-Null
                }
            }
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            if ($Results.EnterpriseAgreementPolicies)
            {
                $isCIMArray = $false
                if ($Results.EnterpriseAgreementPolicies.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'EnterpriseAgreementPolicies' -IsCIMArray:$isCIMArray
            }
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
