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
        $GlobalAdminAccount,

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
        $CertificatePassword
    )

    Write-Verbose -Message "Getting Offline Address Book configuration for $Name"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }
    try
    {
        if ($null -eq (Get-Command 'Get-OfflineAddressBook' -ErrorAction SilentlyContinue))
        {
            return $nullReturn
        }

        $AllOfflineAddressBooks = Get-OfflineAddressBook

        $OfflineAddressBook = $AllOfflineAddressBooks | Where-Object -FilterScript { $_.Name -eq $Name }

        if ($null -eq $OfflineAddressBook)
        {
            Write-Verbose -Message "Offline Address Book $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Name                 = $OfflineAddressBook.Name
                AddressLists         = $OfflineAddressBook.AddressLists
                ConfiguredAttributes = $OfflineAddressBook.ConfiguredAttributes
                DiffRetentionPeriod  = $OfflineAddressBook.DiffRetentionPeriod
                IsDefault            = $OfflineAddressBook.IsDefault
                Ensure               = 'Present'
                GlobalAdminAccount   = $GlobalAdminAccount
            }

            Write-Verbose -Message "Found Offline Address Book $($Name)"
            return $result
        }
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return $nullReturn
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
        $GlobalAdminAccount,

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
        $CertificatePassword
    )

    Write-Verbose -Message "Setting Offline Address Book configuration for $Name"

    $currentOfflineAddressBookConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $NewOfflineAddressBookParams = @{
        Name                 = $Name
        AddressLists         = $AddressLists
        ConfiguredAttributes = $ConfiguredAttributes
        DiffRetentionPeriod  = $DiffRetentionPeriod
        IsDefault            = $IsDefault
        Confirm              = $false
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
    if ($Ensure -eq "Present" -and $currentOfflineAddressBookConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Offline Address Book '$($Name)' does not exist but it should. Create and configure it."
        # Create Offline Address Book
        New-OfflineAddressBook @NewOfflineAddressBookParams

    }
    # CASE: Offline Address Book exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentOfflineAddressBookConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Offline Address Book '$($Name)' exists but it shouldn't. Remove it."
        Remove-OfflineAddressBook -Identity $Name -Confirm:$false -Force
    }
    # CASE: Offline Address Book exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentOfflineAddressBookConfig.Ensure -eq "Present")
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
        $GlobalAdminAccount,

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
        $CertificatePassword
    )

    Write-Verbose -Message "Testing Offline Address Book configuration for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

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
        $CertificatePassword
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    if ($null -eq (Get-Command 'Get-OfflineAddressBook' -ErrorAction SilentlyContinue))
    {
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        return $nullReturn
    }

    try
    {
        [array]$AllOfflineAddressBooks = Get-OfflineAddressBook -ErrorAction Stop

        $dscContent = ""

        if ($AllOfflineAddressBooks.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        $i = 1
        foreach ($OfflineAddressBook in $AllOfflineAddressBooks)
        {
            Write-Host "    |---[$i/$($AllOfflineAddressBooks.Count)] $($OfflineAddressBook.Name)" -NoNewLine

            $Params = @{
                Name                  = $OfflineAddressBook.Name
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource

