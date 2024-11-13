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

        [Parameter()]
        [System.String]
        $Status,

        [Parameter()]
        [System.String]
        $View,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Notification,

        [Parameter()]
        [System.String]
        $NotificationEmail,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Schedule,

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
        $uri = "https://management.azure.com/providers/Microsoft.Billing/billingAccounts/$($account.name)/providers/Microsoft.CostManagement/scheduledActions?api-version=2023-11-01"
        $response = Invoke-AzRest -Uri $uri -Method GET
        $actions = (ConvertFrom-Json ($response.Content)).value

        $instance = $actions | Where-Object -FilterScript {$_.properties.displayName -eq $DisplayName}

        if ($null -eq $instance)
        {
            return $nullResult
        }

        $NotificationValue = $null
        if ($null -ne $instance.properties.notification)
        {
            $NotificationValue = @{
                subject = $instance.properties.notification.subject
                message = $instance.properties.notification.message
                to      = $instance.properties.notification.to
            }
        }

        $ScheduleValue = $null
        if ($null -ne $instance.properties.schedule)
        {
            $ScheduleValue = @{
                frequency    = $instance.properties.schedule.frequency
                hourOfDay    = $instance.properties.schedule.hourOfDay
                daysOfWeek   = [Array]($instance.properties.schedule.daysOfWeek)
                weeksofMonth = [Array]($instance.properties.schedule.weeksofMonth)
                dayOfMonth   = $instance.properties.schedule.dayOfMonth
                startDate    = $instance.properties.schedule.startDate
                endDate      = $instance.properties.schedule.endDate
            }
        }

        $results = @{
            DisplayName           = $DisplayName
            BillingAccount        = $BillingAccount
            Status                = $instance.properties.Status
            View                  = $instance.properties.viewId
            Notification          = $NotificationValue
            NotificationEmail     = $instance.properties.notificationEmail
            Schedule              = $ScheduleValue
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $BillingAccount,

        [Parameter()]
        [System.String]
        $Status,

        [Parameter()]
        [System.String]
        $View,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Notification,

        [Parameter()]
        [System.String]
        $NotificationEmail,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Schedule,

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

    $instanceParams = @{
        kind              = "Email"
        properties        = @{
            displayName       = $DisplayName
            notificationEmail = $NotificationEmail
            notification      = @{
                to      = $Notification.to
                subject = $Notification.subject
                message = $Notification.message
            }
            schedule = @{
                frequency    = $Schedule.frequency
                weeksOfMonth = $Schedule.weeksOfMonth
                daysOfWeek   = $Schedule.daysOfWeek
                startDate    = $Schedule.startDate
                endDate      = $Schedule.endDate
                dayOfMonth   = $Schedule.dayOfMonth
            }
            viewId = $View
            status = $Status
        }
    }
    $payload = ConvertTo-Json $instanceParams -Depth 10 -Compress

    # CREATE
    if ($Ensure -eq 'Present')
    {
        $uri = "https://management.azure.com/providers/Microsoft.Billing/billingAccounts/$($BillingAccount)/providers/Microsoft.CostManagement/scheduledActions/$($DisplayName)?api-version=2023-11-01"
        Write-Verbose -Message "Making PUT call to {$uri}"

        if ($currentInstance.Ensure -eq 'Absent')
        {
            Write-Verbose -Message "Creating new scheduled action {$DisplayName} with payload:`r`n$($payload)"
        }
        else
        {
            Write-Verbose -Message "Updating scheduled action {$DisplayName} with payload:`r`n$($payload)"
        }

        $response = Invoke-AzRest -Uri $uri -Method PUT -Payload $payload
        Write-Verbose -Message "Response:`r`n$($response.Content)"
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing scheduled action {$DisplayName} with payload:`r`n$($payload)"
        $uri = "https://management.azure.com/providers/Microsoft.Billing/billingAccounts/$($BillingAccount)/providers/Microsoft.CostManagement/scheduledActions/$($DisplayName)?api-version=2023-11-01"
        $response = Invoke-AzRest -Uri $uri -Method DELETE
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

        [Parameter()]
        [System.String]
        $Status,

        [Parameter()]
        [System.String]
        $View,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Notification,

        [Parameter()]
        [System.String]
        $NotificationEmail,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Schedule,

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

            $uri = "https://management.azure.com/providers/Microsoft.Billing/billingAccounts/$($account.name)/providers/Microsoft.CostManagement/scheduledActions?api-version=2023-11-01"
            $response = Invoke-AzRest -Uri $uri -Method GET
            $actions = (ConvertFrom-Json ($response.Content)).value
            $j = 1
            if ($actions.Length -eq 0)
            {
                Write-Host $Global:M365DSCEmojiGreenCheckMark
            }
            else
            {
                Write-Host "`r`n" -NoNewline
            }
            foreach ($config in $actions)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                $displayedKey = $config.properties.displayName
                Write-Host "        |---[$j/$($actions.Count)] $displayedKey" -NoNewline
                $params = @{
                    DisplayName           = $config.properties.displayName
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

                if ($Results.Notification)
                {
                    $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Notification -CIMInstanceName AzureBillingAccountScheduledActionNotification
                    if ($complexTypeStringResult)
                    {
                        $Results.Notification = $complexTypeStringResult
                    }
                    else
                    {
                        $Results.Remove('Notification') | Out-Null
                    }
                }
                if ($Results.Schedule)
                {
                    $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Schedule -CIMInstanceName AzureBillingAccountScheduledActionSchedule
                    if ($complexTypeStringResult)
                    {
                        $Results.Schedule = $complexTypeStringResult
                    }
                    else
                    {
                        $Results.Remove('Schedule') | Out-Null
                    }
                }
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential

                if ($Results.Notification)
                {
                    $isCIMArray = $false
                    if ($Results.Notification.getType().Fullname -like '*[[\]]')
                    {
                        $isCIMArray = $true
                    }
                    $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Notification' -IsCIMArray:$isCIMArray
                }
                if ($Results.Schedule)
                {
                    $isCIMArray = $false
                    if ($Results.Schedule.getType().Fullname -like '*[[\]]')
                    {
                        $isCIMArray = $true
                    }
                    $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Schedule' -IsCIMArray:$isCIMArray
                }
                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
                $i++
                Write-Host $Global:M365DSCEmojiGreenCheckMark
            }
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
