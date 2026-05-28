Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AzureBillingAccountsAssociatedTenant'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $BillingAccount,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AssociatedTenantId,

        [Parameter()]
        [System.String]
        $BillingManagementState,

        [Parameter()]
        [System.String]
        $ProvisioningManagementState,

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

    Write-Verbose -Message "Getting configuration for Azure Billing Accounts Associated Tenant for Billing Account {$BillingAccount} and Display Name {$DisplayName}"

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

        $accounts = Get-M365DSCAzureBillingAccount
        $currentAccount = $accounts.value | Where-Object -FilterScript { $_.properties.displayName -eq $BillingAccount }

        if ($null -ne $currentAccount)
        {
            $instances = Get-M365DSCAzureBillingAccountsAssociatedTenant -BillingAccountId $currentAccount.Name -ErrorAction Stop
            $instance = $instances.value | Where-Object -FilterScript { $_.properties.displayName -eq $DisplayName }
        }
        if ($null -eq $instance)
        {
            return $nullResult
        }

        $results = @{
            BillingAccount              = $BillingAccount
            DisplayName                 = $DisplayName
            AssociatedTenantId          = $instance.properties.tenantId
            BillingManagementState      = $instance.properties.billingManagementState
            ProvisioningManagementState = $instance.properties.provisioningManagementState
            Ensure                      = 'Present'
            Credential                  = $Credential
            ApplicationId               = $ApplicationId
            TenantId                    = $TenantId
            CertificateThumbprint       = $CertificateThumbprint
            CertificatePath             = $CertificatePath
            CertificatePassword         = $CertificatePassword
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
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $BillingAccount,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AssociatedTenantId,

        [Parameter()]
        [System.String]
        $BillingManagementState,

        [Parameter()]
        [System.String]
        $ProvisioningManagementState,

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

    Write-Verbose -Message "Setting configuration for Azure Billing Accounts Associated Tenant for Billing Account {$BillingAccount} and Display Name {$DisplayName}"

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
    $billingAccounts = Get-M365DSCAzureBillingAccount
    $account = $billingAccounts.value | Where-Object -FilterScript { $_.properties.displayName -eq $BillingAccount }

    $instanceParams = @{
        properties = @{
            displayName                 = $DisplayName
            tenantId                    = $AssociatedTenantId
            billingManagementState      = $BillingManagementState
            provisioningManagementState = $ProvisioningManagementState
        }
    }
    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Adding associated tenant {$AssociatedTenantId}"
        New-M365DSCAzureBillingAccountsAssociatedTenant -BillingAccountId $account.Name `
            -AssociatedTenantId $AssociatedTenantId `
            -Body $instanceParams
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating associated tenant {$AssociatedTenantId}"
        New-M365DSCAzureBillingAccountsAssociatedTenant -BillingAccountId $account.Name `
            -AssociatedTenantId $AssociatedTenantId `
            -Body $instanceParams
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing associated tenant {$AssociatedTenantId}"
        Remove-M365DSCAzureBillingAccountsAssociatedTenant -BillingAccountId $account.Name `
            -AssociatedTenantId $AssociatedTenantId
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $BillingAccount,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AssociatedTenantId,

        [Parameter()]
        [System.String]
        $BillingManagementState,

        [Parameter()]
        [System.String]
        $ProvisioningManagementState,

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
        #Get all billing account
        $accounts = Get-M365DSCAzureBillingAccount

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        [array] $Script:exportedInstances = @()
        foreach ($config in $accounts.value)
        {
            $displayedKey = $config.properties.displayName
            Write-M365DSCHost -Message "    |---[$i/$($accounts.Count)] $displayedKey"

            $associatedTenants += Get-M365DSCAzureBillingAccountsAssociatedTenant -BillingAccountId $config.name

            $j = 1
            foreach ($associatedTenant in $associatedTenants.value)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }
                Write-M365DSCHost -Message "        |---[$j/$($associatedTenants.value.Length)] $($associatedTenant.properties.DisplayName)" -DeferWrite
                $params = @{
                    BillingAccount        = $config.properties.displayName
                    DisplayName           = $associatedTenant.properties.displayName
                    AssociatedTenantId    = $associatedTenant.properties.tenantId
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    AccessTokens          = $AccessTokens
                }

                $Results = Get-TargetResource @Params

                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                [void]$dscContent.Append($currentDSCBlock)
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
                $j++
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }
            $i++
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

Export-ModuleMember -Function *-TargetResource
