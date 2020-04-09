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
        [System.String[]]
        $AddressLists,

        [Parameter()]
        [System.String]
        $GlobalAddressList,

        [Parameter()]
        [System.String]
        $OfflineAddressBook,

        [Parameter()]
        [System.String]
        $RoomList,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting Address Book Policy configuration for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $AllAddressBookPolicies = Get-AddressBookPolicy

    $AddressBookPolicy = $AllAddressBookPolicies | Where-Object -FilterScript { $_.Name -eq $Name }

    if ($null -eq $AddressBookPolicy)
    {
        Write-Verbose -Message "Address Book Policy $($Name) does not exist."

        $nullReturn = @{
            Name               = $Name
            AddressLists       = $AddressLists
            GlobalAddressList  = $GlobalAddressList
            OfflineAddressBook = $OfflineAddressBook
            RoomList           = $RoomList
            Ensure             = 'Absent'
            GlobalAdminAccount = $GlobalAdminAccount
        }

        return $nullReturn
    }
    else
    {
        $result = @{
            Name               = $AddressBookPolicy.Name
            AddressLists       = $AddressBookPolicy.AddressLists
            GlobalAddressList  = $AddressBookPolicy.GlobalAddressList
            OfflineAddressBook = $AddressBookPolicy.OfflineAddressBook
            RoomList           = $AddressBookPolicy.RoomList
            Ensure             = 'Present'
            GlobalAdminAccount = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found Address Book Policy $($Name)"
        return $result
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
        [System.String[]]
        $AddressLists,

        [Parameter()]
        [System.String]
        $GlobalAddressList,

        [Parameter()]
        [System.String]
        $OfflineAddressBook,

        [Parameter()]
        [System.String]
        $RoomList,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Address Book Policy configuration for $Name"

    $currentAddressBookPolicyConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $NewAddressBookPolicyParams = @{
        Name               = $Name
        AddressLists       = $AddressLists
        GlobalAddressList  = $GlobalAddressList
        OfflineAddressBook = $OfflineAddressBook
        RoomList           = $RoomList
        Confirm            = $false
    }

    $SetAddressBookPolicyParams = @{
        Identity           = $Name
        AddressLists       = $AddressLists
        GlobalAddressList  = $GlobalAddressList
        OfflineAddressBook = $OfflineAddressBook
        RoomList           = $RoomList
        Confirm            = $false
    }

    # CASE: Address Book Policy doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentAddressBookPolicyConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Address Book Policy '$($Name)' does not exist but it should. Create and configure it."
        # Create Address Book Policy
        New-AddressBookPolicy @NewAddressBookPolicyParams

    }
    # CASE: Address Book Policy exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentAddressBookPolicyConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Address Book Policy '$($Name)' exists but it shouldn't. Remove it."
        Remove-AddressBookPolicy -Identity $Name -Confirm:$false
    }
    # CASE: Address Book Policy exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentAddressBookPolicyConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Address Book Policy '$($Name)' already exists, but needs updating."
        Write-Verbose -Message "Setting Address Book Policy $($Name) with values: $(Convert-M365DscHashtableToString -Hashtable $SetAddressBookPolicyParams)"
        Set-AddressBookPolicy @SetAddressBookPolicyParams
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
        [System.String[]]
        $AddressLists,

        [Parameter()]
        [System.String]
        $GlobalAddressList,

        [Parameter()]
        [System.String]
        $OfflineAddressBook,

        [Parameter()]
        [System.String]
        $RoomList,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Address Book Policy configuration for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    [array]$AllAddressBookPolicies = Get-AddressBookPolicy

    $dscContent = ""
    $i = 1
    foreach ($AddressBookPolicy in $AllAddressBookPolicies)
    {
        Write-Information "    [$i/$($AllAddressBookPolicies.Count)] $($AddressBookPolicy.Name)"

        $Params = @{
            Name               = $AddressBookPolicy.Name
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        EXOAddressBookPolicy " + (New-GUID).ToString() + "`r`n"
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

