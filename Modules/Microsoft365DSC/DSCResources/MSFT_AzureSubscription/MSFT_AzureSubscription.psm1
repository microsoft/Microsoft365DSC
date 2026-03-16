Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AzureSubscription'

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
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $InvoiceSectionId,

        [Parameter()]
        [System.String]
        $Status,

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

    Write-Verbose -Message "Getting configuration for Azure Subscription with Name $Name"

    try
    {
        if ($null -eq $Script:exportedInstances -or -not $Script:ExportMode)
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

            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)$($InvoiceSectionId.Trim('/'))/billingSubscriptions/$($Id)?api-version=2024-04-01"
                $response = Invoke-AzRest -Uri $uri -Method Get
                $instance = (ConvertFrom-Json $response.Content).value
            }
            elseif ($null -eq $instance -and -not [System.String]::IsNullOrEmpty($DisplayName))
            {
                $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)$($InvoiceSectionId.Trim('/'))/billingSubscriptions?api-version=2024-04-01"
                $response = Invoke-AzRest -Uri $uri -Method Get
                $instances = (ConvertFrom-Json $response.Content).value
                $instance = $instances | Where-Object -FilterScript { $_.properties.displayName -eq $DisplayName }
            }

            if ($null -eq $instance)
            {
                return $nullResult
            }
        }
        else
        {
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $instance = $Script:exportedInstances | Where-Object -FilterScript { $_.Name -eq $Id }
            }
            elseif ($null -eq $instance -and -not [System.String]::IsNullOrEmpty($Name))
            {
                $instance = $Script:exportedInstances | Where-Object -FilterScript { $_.properties.displayName -eq $DisplayName -and `
                        $_.properties.invoiceSectionId -eq $InvoiceSectionId }
            }
        }

        $results = @{
            DisplayName           = $instance.properties.displayName
            Id                    = $instance.name
            InvoiceSectionId      = $instance.properties.invoiceSectionId
            Status                = $instance.properties.status
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
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
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $InvoiceSectionId,

        [Parameter()]
        [System.String]
        $Status,

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

    Write-Verbose -Message "Setting configuration for Azure Subscription with Name $DisplayName"

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

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)providers/Microsoft.Subscription/aliases/$((New-Guid).ToString())?api-version=2021-10-01"
        $params = @{
            properties = @{
                billingScope = $InvoiceSectionId
                DisplayName  = $DisplayName
                Workload     = 'Production'
            }
        }
        $payload = ConvertTo-Json $params -Depth 10 -Compress
        Write-Verbose -Message "Creating new subscription {$DisplayName} with payload:`r`n$payload"
        $response = Invoke-AzRest -Uri $uri -Method PUT -Payload $payload
        Write-Verbose -Message "Result: $($response.Content)"
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        if ($Status -eq 'Active')
        {
            Write-Verbose -Message "Enabling subscription {$Name}"
            Enable-AzSubscription -Id $currentInstance.Id | Out-Null
        }
        elseif (-not $Enabled)
        {
            Write-Verbose -Message "Disabling subscription {$Name}"
            Disable-AzSubscription -Id $currentInstance.Id | Out-Null
        }
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Deleting subscription {$Name}"
        $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)subscriptions/$($currentInstance.Id)/providers/Microsoft.Subscription/cancel?api-version=2019-03-01-preview&ImmediateDelete=true"
        $response = Invoke-AzRest -Uri $uri -Method POST
        Write-Verbose -Message "Response:`r`n$($response.Content)"
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
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $InvoiceSectionId,

        [Parameter()]
        [System.String]
        $Status,

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
        $Script:ExportMode = $true

        $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)providers/Microsoft.Billing/billingaccounts/?api-version=2020-05-01"
        $response = Invoke-AzRest -Uri $uri -Method Get
        $billingAccounts = (ConvertFrom-Json $response.Content).value

        if ($billingAccounts.Count -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            return ''
        }

        foreach ($billingAccount in $billingAccounts)
        {
            $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)providers/Microsoft.Billing/billingaccounts/$($billingAccount.Name)/billingprofiles/?api-version=2020-05-01"
            $response = Invoke-AzRest -Uri $uri -Method Get
            $billingProfiles = (ConvertFrom-Json $response.Content).value

            foreach ($billingProfile in $billingProfiles)
            {
                $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)providers/Microsoft.Billing/billingAccounts/$($billingAccount.name)/billingProfiles/$($billingProfile.name)/billingSubscriptions?api-version=2024-04-01"
                $response = Invoke-AzRest -Uri $uri -Method Get
                $subscriptions = (ConvertFrom-Json $response.Content).value
                [array] $Script:exportedInstances += $subscriptions

                $i = 1
                $dscContent = ''
                if ($Script:exportedInstances.Length -eq 0)
                {
                    Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
                }
                else
                {
                    Write-M365DSCHost -Message "`r`n" -DeferWrite
                }
                foreach ($config in $subscriptions)
                {
                    if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                    {
                        $Global:M365DSCExportResourceInstancesCount++
                    }
                    $displayedKey = $config.properties.displayName
                    Write-M365DSCHost -Message "    |---[$i/$($subscriptions.Count)] $displayedKey" -DeferWrite
                    $params = @{
                        DisplayName           = $config.properties.displayName
                        Id                    = $config.Name
                        InvoiceSectionId      = $config.properties.invoiceSectionId
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
                    $dscContent += $currentDSCBlock
                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                        -FileName $Global:PartialExportFileName
                    $i++
                    Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
                }
            }
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
