Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOTenantAllowBlockListItems'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Allow', 'Block')]
        [System.String]
        $Action,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Value,

        [Parameter()]
        [System.DateTime]
        $ExpirationDate,

        [Parameter()]
        [ValidateSet('AdvancedDelivery', 'Submission', 'Tenant')]
        [System.String]
        $ListSubType,

        [Parameter(Mandatory = $true)]
        [ValidateSet('FileHash', 'Sender', 'Url')]
        [System.String]
        $ListType,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.UInt32]
        $RemoveAfter,

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
        $ApplicationSecret,

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

    Write-Verbose -Message "Getting configuration for Tenant Allow/Block List Items with Action {$Action} and Value {$Value}"

    try
    {
        if (-not $Script:exportedInstance -or ($Script:exportedInstance.Value -ne $Value -or $Script:exportedInstance.ListType -ne $ListType))
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
            $nullResult.ListType = $ListType

            $getParams = @{
                ListType = $ListType
                Entry = $Value
            }
            $instance = Get-TenantAllowBlockListItems @getParams -ErrorAction SilentlyContinue
            if ($null -eq $instance)
            {
                Write-Verbose -Message "No EXO Tenant Allow/Block List Item found for Action {$Action} and Value {$Value}"
                return $nullResult
            }
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        Write-Verbose -Message "Found an EXO Tenant Allow/Block List Item with Action {$Action}, Value {$Value}, and ListType {$ListType}"

        $results = @{
            Action                = $instance.Action
            Value                 = $instance.Value
            ExpirationDate        = $instance.ExpirationDate
            ListSubType           = $instance.ListSubType
            ListType              = $ListType
            Notes                 = $instance.Notes
            RemoveAfter           = $instance.RemoveAfter
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ApplicationSecret     = $ApplicationSecret
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
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
        [ValidateSet('Allow', 'Block')]
        [System.String]
        $Action,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Value,

        [Parameter()]
        [System.DateTime]
        $ExpirationDate,

        [Parameter()]
        [ValidateSet('AdvancedDelivery', 'Submission', 'Tenant')]
        [System.String]
        $ListSubType,

        [Parameter(Mandatory = $true)]
        [ValidateSet('FileHash', 'Sender', 'Url')]
        [System.String]
        $ListType,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.UInt32]
        $RemoveAfter,

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
        $ApplicationSecret,

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

    Write-Verbose -Message "Setting configuration for Tenant Allow/Block List Items with Action {$Action} and Value {$Value}"

    if ($PSBoundParameters.ContainsKey('ApplicationSecret'))
    {
        Write-Warning -Message "The 'ApplicationSecret' parameter is deprecated and will be removed in future versions."
    }

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
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $CreateParameters = ([Hashtable]$BoundParameters).Clone()

        $CreateParameters.Remove('Value') | Out-Null
        $CreateParameters.Add('Entries', @($Value)) | Out-Null
        if ($Action -eq 'Allow')
        {
            $CreateParameters.Add('Allow', $true) | Out-Null
        }
        elseif ($Action -eq 'Block')
        {
            $CreateParameters.Add('Block', $true) | Out-Null
        }
        $CreateParameters.Remove('Action') | Out-Null

        Write-Verbose -Message "Creating {$Value} with Parameters:`r`n$(Convert-M365DscHashtableToString -Hashtable $CreateParameters)"
        New-TenantAllowBlockListItems @CreateParameters | Out-Null
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating {$Value}"

        $UpdateParameters = ([Hashtable]$BoundParameters).Clone()
        $UpdateParameters.Remove('Value') | Out-Null
        $UpdateParameters.Add('Entries', @($Value)) | Out-Null
        $UpdateParameters.Remove('Action') | Out-Null

        Set-TenantAllowBlockListItems @UpdateParameters | Out-Null
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing {$Value}"
        Remove-TenantAllowBlockListItems -Entries $currentInstance.Value -ListType $currentInstance.ListType
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Allow', 'Block')]
        [System.String]
        $Action,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Value,

        [Parameter(Mandatory = $true)]
        [ValidateSet('FileHash', 'Sender', 'Url')]
        [System.String]
        $ListType,

        [Parameter()]
        [System.DateTime]
        $ExpirationDate,

        [Parameter()]
        [ValidateSet('AdvancedDelivery', 'Submission', 'Tenant')]
        [System.String]
        $ListSubType,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.Int32]
        $RemoveAfter,

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
        $ApplicationSecret,

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

    if ($PSBoundParameters.ContainsKey('ApplicationSecret'))
    {
        Write-Warning -Message "The 'ApplicationSecret' parameter is deprecated and will be removed in future versions."
    }

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
        $ListTypes = ('FileHash', 'Sender', 'Url')

        foreach ($ListType in $ListTypes)
        {
            [array]$listValues = Get-TenantAllowBlockListItems -ListType $ListType -ErrorAction Stop
            foreach ($value in $listValues)
            {
                $value | Add-Member -MemberType NoteProperty -Name ListType -Value $ListType
            }
        }

        $i = 1
        $dscContent = ''
        if ($listValues.Count -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $listValues)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = "[$($config.Action)] [$($config.ListType)] $($config.Value)"
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($listValues.Count)] $displayedKey" -DeferWrite
            $params = @{
                Action                = $config.Action
                ListType              = $config.ListType
                Value                 = $config.Value
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ApplicationSecret     = $ApplicationSecret
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
        IncludedProperties = @('Action', 'ListType', 'Value')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
