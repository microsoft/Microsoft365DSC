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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting Offline Address Book configuration for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $AllOfflineAddressBooks = Get-OfflineAddressBook

    $OfflineAddressBook = $AllOfflineAddressBooks | Where-Object -FilterScript { $_.Name -eq $Name }

    if ($null -eq $OfflineAddressBook)
    {
        Write-Verbose -Message "Offline Address Book $($Name) does not exist."

        $nullReturn = @{
            Name                 = $Name
            AddressLists         = $AddressLists
            ConfiguredAttributes = $ConfiguredAttributes
            DiffRetentionPeriod  = $DiffRetentionPeriod
            IsDefault            = $IsDefault
            Ensure               = 'Absent'
            GlobalAdminAccount   = $GlobalAdminAccount
        }

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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Offline Address Book configuration for $Name"

    $currentOfflineAddressBookConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform ExchangeOnline

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
        Write-Verbose -Message "Setting Offline Address Book $($Name) with values: $(Convert-O365DscHashtableToString -Hashtable $SetOfflineAddressBookParams)"
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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Offline Address Book configuration for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
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
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion
    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform ExchangeOnline

    [array]$AllOfflineAddressBooks = Get-OfflineAddressBook

    $dscContent = ""
    $i = 1
    foreach ($OfflineAddressBook in $AllOfflineAddressBooks)
    {
        Write-Information "    [$i/$($AllOfflineAddressBooks.Count)] $($OfflineAddressBook.Name)"

        $Params = @{
            Name               = $OfflineAddressBook.Name
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        EXOOfflineAddressBook " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $dscContent += $content
        $i++
    }
    return $dscContent
}

Export-ModuleMember -Function *-TargetResource

