Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOMigration'

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
        [System.String[]]
        $NotificationEmails,

        [Parameter()]
        [System.String]
        $CompleteAfter,

        [Parameter()]
        [System.Boolean]
        $AddUsers,

        [Parameter()]
        [System.String]
        $BadItemLimit,

        [Parameter()]
        [System.String]
        $LargeItemLimit,

        [Parameter()]
        [System.String[]]
        $MoveOptions,

        [Parameter()]
        [System.String[]]
        $SkipMerging,

        [Parameter()]
        [System.String]
        $StartAfter,

        [Parameter()]
        [System.Boolean]
        $Update,

        [Parameter()]
        [System.String]
        $Status,

        [Parameter()]
        [System.String]
        $TargetDeliveryDomain,

        [Parameter()]
        [System.String]
        $SourceEndpoint,

        [Parameter()]
        [System.String[]]
        $MigrationUsers,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure,

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

    Write-Verbose -Message "Getting configuration for Migration Batch with Identity {$Identity}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
                -InboundParameters $PSBoundParameters

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $instance = Get-MigrationBatch -Identity $Identity -ErrorAction SilentlyContinue
            if ($null -eq $instance)
            {
                Write-Verbose -Message "Migration Batch with Identity $Identity not found"
                return $nullResult
            }
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        Write-Verbose -Message "Migration Batch with Identity $Identity found"

        $Users = Get-MigrationUser -BatchId $Identity
        $UserEmails = @()
        foreach ($user in $Users)
        {
            $UserEmails += $user.Identity
        }

        $results = @{
            Identity              = $Identity
            NotificationEmails    = [System.String[]]$instance.NotificationEmails
            AddUsers              = [System.Boolean]$instance.AddUsers
            BadItemLimit          = [System.String]$instance.BadItemLimit
            LargeItemLimit        = [System.String]$instance.LargeItemLimit
            MoveOptions           = [System.String[]]$instance.MoveOptions
            SkipMerging           = [System.String[]]$instance.SkipMerging
            Update                = [System.Boolean]$instance.Update
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
            Status                = $instance.Status.Value
            MigrationUsers        = $UserEmails
            SourceEndpoint        = $instance.SourceEndpoint.Identity.Id
            TargetDeliveryDomain  = $instance.TargetDeliveryDomain
        }

        if ($null -ne $instance.CompleteAfter)
        {
            $results.Add('CompleteAfter', $instance.CompleteAfter.ToString('MM/dd/yyyy hh:mm tt'))
        }

        if ($null -ne $instance.StartAfter)
        {
            $results.Add('StartAfter', $instance.CompleteAfter.ToString('MM/dd/yyyy hh:mm tt'))
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
        $Identity,

        [Parameter()]
        [System.String[]]
        $NotificationEmails,

        [Parameter()]
        [System.String]
        $CompleteAfter,

        [Parameter()]
        [System.Boolean]
        $AddUsers,

        [Parameter()]
        [System.String]
        $BadItemLimit,

        [Parameter()]
        [System.String]
        $LargeItemLimit,

        [Parameter()]
        [System.String[]]
        $MoveOptions,

        [Parameter()]
        [System.String[]]
        $SkipMerging,

        [Parameter()]
        [System.String]
        $StartAfter,

        [Parameter()]
        [System.Boolean]
        $Update,

        [Parameter()]
        [System.String]
        $Status,

        [Parameter()]
        [System.String]
        $TargetDeliveryDomain,

        [Parameter()]
        [System.String]
        $SourceEndpoint,

        [Parameter()]
        [System.String[]]
        $MigrationUsers,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure,

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

    Write-Verbose -Message "Setting configuration for Migration Batch with Identity {$Identity}"

    Confirm-M365DSCDependencies

    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data

    $currentInstance = Get-TargetResource @PSBoundParameters

    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        # Convert the list of users to CSV format
        $csvContent = @('"EmailAddress"') + ($MigrationUsers | ForEach-Object { "`"$_`"" })

        # Join the results into a single string with new lines
        $csvContent = $csvContent -join "`r`n"

        # Convert the CSV content to bytes directly without saving to a file
        $csvBytes = [System.Text.Encoding]::UTF8.GetBytes($csvContent -join "`r`n")

        $BatchParams = @{
            Name                 = $Identity  # Use the existing Identity as the new batch name
            CSVData              = $csvBytes  # Directly use the byte array
            NotificationEmails   = $NotificationEmails  # Use the same notification emails if provided
            CompleteAfter        = $CompleteAfter
            StartAfter           = $StartAfter
            BadItemLimit         = [System.String]$BadItemLimit
            LargeItemLimit       = $LargeItemLimit
            SkipMerging          = $SkipMerging
            SourceEndpoint       = $SourceEndpoint
            TargetDeliveryDomain = $TargetDeliveryDomain
        }

        # Create a new migration batch with the specified parameters
        New-MigrationBatch @BatchParams
        Write-M365DSCHost -Message "A new migration batch named '$($currentInstance.Identity)' has been created with the specified parameters."
    }

    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        # Retrieve the migration batch
        $migrationBatch = Get-MigrationBatch -Identity $currentInstance.Identity -ErrorAction Stop

        if ($migrationBatch.Status.Value -in @('Completed', 'CompletedWithErrors', 'Stopped', 'Failed', 'SyncedWithErrors'))
        {
            # If the migration batch is in a final state, remove it directly
            Remove-MigrationBatch -Identity $currentInstance.Identity -Confirm:$false
            Write-M365DSCHost -Message "Migration batch '$($currentInstance.Identity)' has been removed as it was in a completed or stopped state."
        }
        elseif ($migrationBatch.Status.Value -in @('InProgress', 'Syncing', 'Queued', 'Completing'))
        {
            # If the migration batch is in progress, stop it first
            Stop-MigrationBatch -Identity $currentInstance.Identity -Confirm:$false
            Write-M365DSCHost -Message "Migration batch '$($currentInstance.Identity)' was in progress and has been stopped."

            # Now remove the migration batch
            Remove-MigrationBatch -Identity $currentInstance.Identity -Confirm:$false
            Write-M365DSCHost -Message "Migration batch '$($currentInstance.Identity)' has been removed after stopping."
        }
        else
        {
            Write-M365DSCHost -Message "Migration batch '$($currentInstance.Identity)' is in an unexpected status: $($migrationBatch.Status.Value). Manual intervention may be required."
        }
    }

    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        # Define the path for the CSV file to store the migration users
        $csvFilePath = "$env:TEMP\MigrationUsers.csv"

        # Convert each item in the array to a custom object with an EmailAddress property
        $csvContent = $MigrationUsers | ForEach-Object { @{EmailAddress = $_ } }

        # Export to CSV with the header "EmailAddress"
        $csvContent | Export-Csv -Path $csvFilePath -NoTypeInformation -Force

        $BatchParams = @{
            Identity           = $Identity  # Use the existing Identity as the new batch name
            CSVData            = [System.IO.File]::ReadAllBytes($csvFilePath)  # Load the CSV as byte array
            NotificationEmails = $NotificationEmails  # Use the same notification emails if provided
            CompleteAfter      = $CompleteAfter
            StartAfter         = $StartAfter
            BadItemLimit       = [System.String]$BadItemLimit
            LargeItemLimit     = $LargeItemLimit
            SkipMerging        = $SkipMerging
            Update             = $Update
            AddUsers           = $AddUsers
        }

        Set-MigrationBatch @BatchParams

        $migrationBatch = Get-MigrationBatch -Identity $currentInstance.Identity -ErrorAction Stop

        if ($currentInstance.Status -eq 'Stopped' -and $migrationBatch.Status -eq 'Started')
        {
            # If currentInstance is stopped but migrationBatch is started, stop the migration batch
            Stop-MigrationBatch -Identity $currentInstance.Identity -Confirm:$false
            Write-M365DSCHost -Message "Migration batch '$($currentInstance.Identity)' was running and has been stopped to match the current instance status."
        }
        elseif ($currentInstance.Status -eq 'Started' -and $migrationBatch.Status -eq 'Stopped')
        {
            # If currentInstance is started but migrationBatch is stopped, start the migration batch
            Start-MigrationBatch -Identity $currentInstance.Identity -Confirm:$false
            Write-M365DSCHost -Message "Migration batch '$($currentInstance.Identity)' was stopped and has been started to match the current instance status."
        }
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
        [System.String[]]
        $NotificationEmails,

        [Parameter()]
        [System.String]
        $CompleteAfter,

        [Parameter()]
        [System.Boolean]
        $AddUsers,

        [Parameter()]
        [System.String]
        $BadItemLimit,

        [Parameter()]
        [System.String]
        $LargeItemLimit,

        [Parameter()]
        [System.String[]]
        $MoveOptions,

        [Parameter()]
        [System.String[]]
        $SkipMerging,

        [Parameter()]
        [System.String]
        $StartAfter,

        [Parameter()]
        [System.Boolean]
        $Update,

        [Parameter()]
        [System.String]
        $TargetDeliveryDomain,

        [Parameter()]
        [System.String]
        $Status,

        [Parameter()]
        [System.String]
        $SourceEndpoint,

        [Parameter()]
        [System.String[]]
        $MigrationUsers,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

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
        [array]$migrationBatches = Get-MigrationBatch -ErrorAction Stop

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($migrationBatches.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $migrationBatches)
        {
            $displayedKey = $config.Identity
            Write-M365DSCHost -Message "    |---[$i/$($migrationBatches.Count)] $displayedKey" -DeferWrite
            $params = @{
                Identity              = $config.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
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

Export-ModuleMember -Function *-TargetResource
