Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SCUnifiedAuditLogRetentionPolicy'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecordTypes,

        [Parameter()]
        [ValidateSet('SevenDays', 'OneMonth', 'ThreeMonths', 'SixMonths', 'NineMonths', 'TwelveMonths', 'ThreeYears', 'FiveYears', 'SevenYears', 'TenYears')]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [System.String[]]
        $UserIds,

        [Parameter()]
        [System.String[]]
        $Operations,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret
    )

    Write-Verbose -Message "Getting configuration of SC Unified Audit Log Retention Policy for $Name"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Name -ne $Name)
        {
            $null = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
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

            [array]$instances = @(Invoke-M365DSCCommand -ScriptBlock { Get-UnifiedAuditLogRetentionPolicy -ErrorAction Stop | Where-Object { $_.Mode -ne 'PendingDeletion' } } -SuppressNotFoundError)
            if ($null -eq $instances)
            {
                return $nullResult
            }

            $instance = $instances | Where-Object { $_.Name -eq $Name } | Select-Object -First 1
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        if ($null -eq $instance)
        {
            return $nullResult
        }

        Write-Verbose -Message "Found an SC Unified Audit Log Retention Policy with Name {$Name}"
        $results = @{
            Identity              = $instance.Identity
            Description           = $instance.Description
            Name                  = $instance.Name
            Operations            = $instance.Operations
            Priority              = $instance.Priority
            RecordTypes           = $instance.RecordTypes
            RetentionDuration     = $instance.RetentionDuration
            UserIds               = $instance.UserIds
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ApplicationSecret     = $ApplicationSecret
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
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $Operations,

        [Parameter(Mandatory = $true)]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecordTypes,

        [Parameter(Mandatory = $true)]
        [ValidateSet('SevenDays', 'OneMonth', 'ThreeMonths', 'SixMonths', 'NineMonths', 'TwelveMonths', 'ThreeYears', 'FiveYears', 'SevenYears', 'TenYears')]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [System.String[]]
        $UserIds,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret
    )

    Write-Verbose -Message "Setting configuration of SC Unified Audit Log Retention Policy for $Name"

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

    $GetParameters = ([Hashtable]$PSBoundParameters).Clone()
    $GetParameters.Remove('Description') | Out-Null
    $GetParameters.Remove('Operations') | Out-Null
    $GetParameters.Remove('RecordTypes') | Out-Null
    $GetParameters.Remove('UserIds') | Out-Null

    $currentInstance = Get-TargetResource @GetParameters
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $CreateParameters = ([Hashtable]$BoundParameters).Clone()
        Write-Verbose -Message "Creating a Unified Audit Log Retention Policy with Name {$Name}"
        New-UnifiedAuditLogRetentionPolicy @CreateParameters | Out-Null
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Unified Audit Log Retention Policy with Name {$Name}"

        $UpdateParameters = ([Hashtable]$BoundParameters).Clone()
        $UpdateParameters.Remove('Name') | Out-Null
        $UpdateParameters.Add('Identity', $currentInstance.Identity) | Out-Null
        Set-UnifiedAuditLogRetentionPolicy @UpdateParameters | Out-Null
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Unified Audit Log Retention Policy with Name {$Name}"
        Remove-UnifiedAuditLogRetentionPolicy -Identity $currentInstance.Identity
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $Operations,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecordTypes,

        [Parameter(Mandatory = $true)]
        [ValidateSet('SevenDays', 'OneMonth', 'ThreeMonths', 'SixMonths', 'NineMonths', 'TwelveMonths', 'ThreeYears', 'FiveYears', 'SevenYears', 'TenYears')]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [System.String[]]
        $UserIds,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        @compareParameters
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
        $ManagedIdentity
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
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
        [array]$getValue = @(Get-UnifiedAuditLogRetentionPolicy -ErrorAction Stop | Where-Object { $_.Mode -ne 'PendingDeletion' })

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Name
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Name                  = $config.Name
                Priority              = $config.Priority
                RetentionDuration     = $config.RetentionDuration
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ApplicationSecret     = $ApplicationSecret
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            $Results.Remove('Identity') | Out-Null

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

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        ExcludedProperties = @('Name')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
