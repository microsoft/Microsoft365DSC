Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AzureBillingAccountPolicy'

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

    Write-Verbose -Message "Getting configuration of Azure Billing Account Policy for Billing Account $BillingAccount"

    try
    {
        $null = New-M365DSCConnection -Workload 'Azure' `
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

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)providers/Microsoft.Billing/billingAccounts/$($BillingAccount)/policies/default?api-version=2024-04-01"
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

    Write-Verbose -Message "Setting configuration of Azure Billing Account Policy for Billing Account $BillingAccount"

    $null = New-M365DSCConnection -Workload 'Azure' `
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

    $instanceParams = @{
        properties = @{
            enterpriseAgreementPolicies = @{
                accountOwnerViewCharges    = $EnterpriseAgreementPolicies.accountOwnerViewCharges
                authenticationType         = $EnterpriseAgreementPolicies.authenticationType
                departmentAdminViewCharges = $EnterpriseAgreementPolicies.departmentAdminViewCharges
            }
            marketplacePurchases        = $MarketplacePurchases
            reservationPurchases        = $ReservationPurchases
            savingsPlanPurchases        = $SavingsPlanPurchases
        }
    }
    $payload = ConvertTo-Json $instanceParams -Depth 5 -Compress
    Write-Verbose -Message "Updating billing account policy for {$BillingAccount} with payload:`r`n$($payload)"
    $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)providers/Microsoft.Billing/billingAccounts/$($BillingAccount)/policies/default?api-version=2024-04-01"
    $response = Invoke-AzRest -Uri $uri -Method 'PUT' -Payload $payload
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
        # Get all billing account
        $accounts = Get-M365DSCAzureBillingAccount

        $i = 1
        $dscContent = ''
        if ($accounts.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($account in $accounts.value)
        {
            $displayedKey = $account.properties.displayName
            Write-M365DSCHost -Message "    |---[$i/$($accounts.value.Length)] $displayedKey" -DeferWrite

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
                -Credential $Credential `
                -NoEscape @('EnterpriseAgreementPolicies')

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
