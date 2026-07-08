Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOOfflineAddressBook'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $AddressLists = @(),

        [Parameter()]
        [System.String[]]
        $ConfiguredAttributes = @(),

        [Parameter()]
        [System.String]
        $DiffRetentionPeriod,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

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

    Write-Verbose -Message "Getting Offline Address Book configuration for $Name"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Name -ne $Name)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
                -InboundParameters $PSBoundParameters

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullReturn = $PSBoundParameters
            $nullReturn.Ensure = 'Absent'

            $OfflineAddressBook = Get-OfflineAddressBook -Identity $Name -ErrorAction SilentlyContinue
            if ($null -eq $OfflineAddressBook)
            {
                Write-Verbose -Message "Offline Address Book $($Name) does not exist."
                return $nullReturn
            }
        }
        else
        {
            $OfflineAddressBook = $Script:exportedInstance
        }

        Write-Verbose -Message "Offline Address Book with Name $($OfflineAddressBook.Name) found"

        $result = @{
            Name                  = $OfflineAddressBook.Name
            AddressLists          = $OfflineAddressBook.AddressLists
            ConfiguredAttributes  = $OfflineAddressBook.ConfiguredAttributes
            DiffRetentionPeriod   = $OfflineAddressBook.DiffRetentionPeriod
            IsDefault             = $OfflineAddressBook.IsDefault
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            ManagedIdentity       = $ManagedIdentity.IsPresent
            TenantId              = $TenantId
            AccessTokens          = $AccessTokens
        }

        return $result
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
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $AddressLists = @(),

        [Parameter()]
        [System.String[]]
        $ConfiguredAttributes = @(),

        [Parameter()]
        [System.String]
        $DiffRetentionPeriod,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

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

    Write-Verbose -Message "Setting Offline Address Book configuration for $Name"

    $currentOfflineAddressBookConfig = Get-TargetResource @PSBoundParameters
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $NewOfflineAddressBookParams = @{
        Name                = $Name
        AddressLists        = $AddressLists
        DiffRetentionPeriod = $DiffRetentionPeriod
        IsDefault           = $IsDefault
        Confirm             = $false
    }

    $SetOfflineAddressBookParams = @{
        Identity             = $Name
        Name                 = $Name
        AddressLists         = $AddressLists
        ConfiguredAttributes = $ConfiguredAttributes
        DiffRetentionPeriod  = $DiffRetentionPeriod
        IsDefault            = $IsDefault
        Confirm              = $false
    }

    # CASE: Offline Address Book doesn't exist but should;
    if ($Ensure -eq 'Present' -and $currentOfflineAddressBookConfig.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Offline Address Book '$($Name)' does not exist but it should. Create and configure it."
        # Create Offline Address Book
        New-OfflineAddressBook @NewOfflineAddressBookParams

    }
    # CASE: Offline Address Book exists but it shouldn't;
    elseif ($Ensure -eq 'Absent' -and $currentOfflineAddressBookConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Offline Address Book '$($Name)' exists but it shouldn't. Remove it."
        Remove-OfflineAddressBook -Identity $Name -Confirm:$false -Force
    }
    # CASE: Offline Address Book exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq 'Present' -and $currentOfflineAddressBookConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Offline Address Book '$($Name)' already exists, but needs updating."
        Write-Verbose -Message "Setting Offline Address Book $($Name) with values: $(Convert-M365DscHashtableToString -Hashtable $SetOfflineAddressBookParams)"
        Set-OfflineAddressBook @SetOfflineAddressBookParams
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $AddressLists = @(),

        [Parameter()]
        [System.String[]]
        $ConfiguredAttributes = @(),

        [Parameter()]
        [System.String]
        $DiffRetentionPeriod,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$AllOfflineAddressBooks = Get-OfflineAddressBook -ErrorAction Stop
        $dscContent = [System.Text.StringBuilder]::new()

        if ($AllOfflineAddressBooks.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $i = 1
        foreach ($OfflineAddressBook in $AllOfflineAddressBooks)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($AllOfflineAddressBooks.Count)] $($OfflineAddressBook.Name)" -DeferWrite

            $Params = @{
                Name                  = $OfflineAddressBook.Name
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $OfflineAddressBook
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
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
