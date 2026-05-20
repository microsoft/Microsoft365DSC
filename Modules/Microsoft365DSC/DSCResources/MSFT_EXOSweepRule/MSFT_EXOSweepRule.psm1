Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOSweepRule'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Provider,

        [Parameter()]
        [System.String]
        $DestinationFolder,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Int32]
        $KeepForDays,

        [Parameter()]
        [System.Int32]
        $KeepLatest,

        [Parameter()]
        [System.String]
        $Mailbox,

        [Parameter()]
        [System.String]
        $SenderName,

        [Parameter()]
        [System.String]
        $SourceFolder,

        [Parameter()]
        [System.String]
        $SystemCategory,

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

    Write-Verbose -Message "Getting configuration for Sweep Rule with Name {$Name}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Name -ne $Name)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
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

            $instance = Get-SweepRule -Mailbox $Mailbox -ErrorAction SilentlyContinue
            if ($null -eq $instance)
            {
                Write-Verbose -Message "No Sweep Rule found with Name {$Name}"
                return $nullResult
            }
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        Write-Verbose -Message "An EXO Sweep Rule with Name {$($instance.Name)} was found."

        $userInfo = Get-User -Identity $instance.MailboxOwnerId

        $results = @{
            Name                  = $instance.Name
            Provider              = $instance.Provider
            DestinationFolder     = $userInfo.UserPrincipalName + ':\' + $instance.DestinationFolder
            Enabled               = [Boolean]$instance.Enabled
            KeepForDays           = $instance.KeepForDays
            KeepLatest            = $instance.KeepLatest
            Mailbox               = $userInfo.UserPrincipalName
            SenderName            = $instance.Sender.Split('"')[1]
            SourceFolder          = $userInfo.UserPrincipalName + ':\' + $instance.SourceFolder
            SystemCategory        = $instance.SystemCategory
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
        $Name,

        [Parameter()]
        [System.String]
        $Provider,

        [Parameter()]
        [System.String]
        $DestinationFolder,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Int32]
        $KeepForDays,

        [Parameter()]
        [System.Int32]
        $KeepLatest,

        [Parameter()]
        [System.String]
        $Mailbox,

        [Parameter()]
        [System.String]
        $SenderName,

        [Parameter()]
        [System.String]
        $SourceFolder,

        [Parameter()]
        [System.String]
        $SystemCategory,

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

    Write-Verbose -Message "Setting configuration for Sweep Rule with Name {$Name}"

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
    $setParameters.Add('Sender', $setParameters.SenderName)
    $setParameters.Remove('SenderName') | Out-Null
    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message 'Creating new Sweep Rule.'
        New-SweepRule @SetParameters
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message 'Updating existing Sweep Rule.'
        $instance = Get-SweepRule -Mailbox $Mailbox | Where-Object -FilterScript { $_.Name -eq $Name }
        $SetParameters.Add('Identity', $instance.RuleId)
        Write-Verbose -Message "Parameters:`r`n$(ConvertTo-Json $SetParameters -Depth 10)"
        Set-SweepRule @SetParameters
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message 'Removing existing Sweep Rule.'
        $instance = Get-SweepRule -Mailbox $Mailbox | Where-Object -FilterScript { $_.Name -eq $Name }
        Remove-SweepRule -Identity $instance.RuleId -Mailbox $Mailbox
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
        $Name,

        [Parameter()]
        [System.String]
        $Provider,

        [Parameter()]
        [System.String]
        $DestinationFolder,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Int32]
        $KeepForDays,

        [Parameter()]
        [System.Int32]
        $KeepLatest,

        [Parameter()]
        [System.String]
        $Mailbox,

        [Parameter()]
        [System.String]
        $SenderName,

        [Parameter()]
        [System.String]
        $SourceFolder,

        [Parameter()]
        [System.String]
        $SystemCategory,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
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
        $mailboxes = Get-Mailbox
        $j = 1
        if ($Script:mailboxes.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $dscContent = [System.Text.StringBuilder]::new()
        foreach ($mailbox in $mailboxes)
        {
            Write-M365DSCHost -Message "    |---[$j/$($mailboxes.Count)] $($mailbox.Name)" -DeferWrite
            [Array] $currentInstances = Get-SweepRule -Mailbox $mailbox.Name -ErrorAction Stop

            $i = 1
            if ($currentInstances.Length -eq 0)
            {
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }
            else
            {
                Write-M365DSCHost -Message "`r`n" -DeferWrite
            }
            foreach ($config in $currentInstances)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }
                $displayedKey = $config.Name
                Write-M365DSCHost -Message "        |---[$i/$($currentInstances.Count)] $displayedKey" -DeferWrite
                $params = @{
                    Name                  = $config.Name
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    AccessTokens          = $AccessTokens
                }
                $Script:exportedInstance = $config
                $Results = Get-TargetResource @params
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
            $j++
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
