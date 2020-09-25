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
        $ConditionalCompany,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute10,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute11,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute12,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute13,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute14,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute15,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute4,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute5,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute6,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute7,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute8,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute9,

        [Parameter()]
        [System.String[]]
        $ConditionalDepartment,

        [Parameter()]
        [System.String[]]
        $ConditionalStateOrProvince,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateSet('AllRecipients', 'MailboxUsers', 'MailContacts', 'MailGroups', 'MailUsers', 'Resources')]
        [System.String[]]
        $IncludedRecipients,

        [Parameter()]
        [System.String]
        $RecipientFilter,

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

    Write-Verbose -Message "Getting configuration of AddressList for $Name"
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

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    try
    {
        if ($null -eq (Get-Command 'Get-AddressList' -ErrorAction SilentlyContinue))
        {
            return $nullReturn
        }
        $AddressLists = Get-AddressList -ErrorAction Stop
        $AddressList = $AddressLists | Where-Object -FilterScript { $_.Name -eq $Name }

        if ($null -eq $AddressList)
        {
            Write-Verbose -Message "Address List $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            if ($null -eq $AddressList.IncludedRecipients)
            {
                $IncludedRecipients = @()
            }
            else
            {
                $IncludedRecipients = $AddressList.IncludedRecipients
            }

            $result = @{
                Name                                 = $Name
                ConditionalCompany                   = $AddressList.ConditionalCompany
                ConditionalCustomAttribute1          = $AddressList.ConditionalCustomAttribute1
                ConditionalCustomAttribute10         = $AddressList.ConditionalCustomAttribute10
                ConditionalCustomAttribute11         = $AddressList.ConditionalCustomAttribute11
                ConditionalCustomAttribute12         = $AddressList.ConditionalCustomAttribute12
                ConditionalCustomAttribute13         = $AddressList.ConditionalCustomAttribute13
                ConditionalCustomAttribute14         = $AddressList.ConditionalCustomAttribute14
                ConditionalCustomAttribute15         = $AddressList.ConditionalCustomAttribute15
                ConditionalCustomAttribute2          = $AddressList.ConditionalCustomAttribute2
                ConditionalCustomAttribute3          = $AddressList.ConditionalCustomAttribute3
                ConditionalCustomAttribute4          = $AddressList.ConditionalCustomAttribute4
                ConditionalCustomAttribute5          = $AddressList.ConditionalCustomAttribute5
                ConditionalCustomAttribute6          = $AddressList.ConditionalCustomAttribute6
                ConditionalCustomAttribute7          = $AddressList.ConditionalCustomAttribute7
                ConditionalCustomAttribute8          = $AddressList.ConditionalCustomAttribute8
                ConditionalCustomAttribute9          = $AddressList.ConditionalCustomAttribute9
                ConditionalDepartment                = $AddressList.ConditionalDepartment
                ConditionalStateOrProvince           = $AddressList.ConditionalStateOrProvince
                DisplayName                          = $AddressList.DisplayName
                IncludedRecipients                   = $IncludedRecipients
                RecipientFilter                      = $AddressList.RecipientFilter
                Ensure                               = 'Present'
                GlobalAdminAccount                   = $GlobalAdminAccount
            }

            Write-Verbose -Message "Found AddressList $($Name)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
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
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $ConditionalCompany,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute10,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute11,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute12,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute13,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute14,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute15,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute4,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute5,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute6,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute7,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute8,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute9,

        [Parameter()]
        [System.String[]]
        $ConditionalDepartment,

        [Parameter()]
        [System.String[]]
        $ConditionalStateOrProvince,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateSet('AllRecipients', 'MailboxUsers', 'MailContacts', 'MailGroups', 'MailUsers', 'Resources')]
        [System.String[]]
        $IncludedRecipients,

        [Parameter()]
        [System.String]
        $RecipientFilter,

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

    Write-Verbose -Message "Setting Address List configuration for $Name"

    $currentAddressListConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

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

    if ($RecipientFilter)
    {
        $NewAddressListParams = @{
            Name            = $Name
            RecipientFilter = $RecipientFilter
            Confirm         = $false
        }
    }
    else
    {
        $NewAddressListParams = @{
            Name                         = $Name
            ConditionalCompany           = $ConditionalCompany
            ConditionalCustomAttribute1  = $ConditionalCustomAttribute1
            ConditionalCustomAttribute10 = $ConditionalCustomAttribute10
            ConditionalCustomAttribute11 = $ConditionalCustomAttribute11
            ConditionalCustomAttribute12 = $ConditionalCustomAttribute12
            ConditionalCustomAttribute13 = $ConditionalCustomAttribute13
            ConditionalCustomAttribute14 = $ConditionalCustomAttribute14
            ConditionalCustomAttribute15 = $ConditionalCustomAttribute15
            ConditionalCustomAttribute2  = $ConditionalCustomAttribute2
            ConditionalCustomAttribute3  = $ConditionalCustomAttribute3
            ConditionalCustomAttribute4  = $ConditionalCustomAttribute4
            ConditionalCustomAttribute5  = $ConditionalCustomAttribute5
            ConditionalCustomAttribute6  = $ConditionalCustomAttribute6
            ConditionalCustomAttribute7  = $ConditionalCustomAttribute7
            ConditionalCustomAttribute8  = $ConditionalCustomAttribute8
            ConditionalCustomAttribute9  = $ConditionalCustomAttribute9
            ConditionalDepartment        = $ConditionalDepartment
            ConditionalStateOrProvince   = $ConditionalStateOrProvince
            DisplayName                  = $DisplayName
            IncludedRecipients           = $IncludedRecipients
            Confirm                      = $false
        }
    }

    $SetAddressListParams = @{
        Identity                     = $Name
        Name                         = $Name
        ConditionalCompany           = $ConditionalCompany
        ConditionalCustomAttribute1  = $ConditionalCustomAttribute1
        ConditionalCustomAttribute10 = $ConditionalCustomAttribute10
        ConditionalCustomAttribute11 = $ConditionalCustomAttribute11
        ConditionalCustomAttribute12 = $ConditionalCustomAttribute12
        ConditionalCustomAttribute13 = $ConditionalCustomAttribute13
        ConditionalCustomAttribute14 = $ConditionalCustomAttribute14
        ConditionalCustomAttribute15 = $ConditionalCustomAttribute15
        ConditionalCustomAttribute2  = $ConditionalCustomAttribute2
        ConditionalCustomAttribute3  = $ConditionalCustomAttribute3
        ConditionalCustomAttribute4  = $ConditionalCustomAttribute4
        ConditionalCustomAttribute5  = $ConditionalCustomAttribute5
        ConditionalCustomAttribute6  = $ConditionalCustomAttribute6
        ConditionalCustomAttribute7  = $ConditionalCustomAttribute7
        ConditionalCustomAttribute8  = $ConditionalCustomAttribute8
        ConditionalCustomAttribute9  = $ConditionalCustomAttribute9
        ConditionalDepartment        = $ConditionalDepartment
        ConditionalStateOrProvince   = $ConditionalStateOrProvince
        DisplayName                  = $DisplayName
        IncludedRecipients           = $IncludedRecipients
        RecipientFilter              = $RecipientFilter
        Confirm                      = $false
    }

    #Address List doesn't exist but it should
    if ($Ensure -eq "Present" -and $currentAddressListConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "The Address List '$($Name)' does not exist but it should. Creating Address List."
        New-AddressList @NewAddressListParams
    }
    #Address List exists but shouldn't
    elseif ($Ensure -eq "Absent" -and $currentAddressListConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Address List '$($Name)' exists but shouldn't. Removing Address List."
        Remove-AddressList -Identity $Name -Confirm:$false
    }
    elseif ($Ensure -eq "Present" -and $currentAddressListConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Address List '$($Name)' already exists. Updating settings"
        Write-Verbose -Message "Setting Address List '$($Name)' with values: $(Convert-M365DscHashtableToString -Hashtable $SetAddressListParams)"
        Set-AddressList @SetAddressListParams
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
        $ConditionalCompany,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute10,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute11,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute12,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute13,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute14,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute15,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute4,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute5,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute6,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute7,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute8,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute9,

        [Parameter()]
        [System.String[]]
        $ConditionalDepartment,

        [Parameter()]
        [System.String[]]
        $ConditionalStateOrProvince,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateSet('AllRecipients', 'MailboxUsers', 'MailContacts', 'MailGroups', 'MailUsers', 'Resources')]
        [System.String[]]
        $IncludedRecipients,

        [Parameter()]
        [System.String]
        $RecipientFilter,

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

    Write-Verbose -Message "Testing Address List configuration for $Name"

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
    param (
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
    try
    {
        if ($null -eq (Get-Command 'Get-AddressList' -ErrorAction SilentlyContinue))
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered to allow for Address Lists"
            return ""
        }
        $dscContent = ""
        [array]$addressLists = Get-Addresslist -ErrorAction Stop
        if ($addressLists.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        $i = 1

        foreach ($addressList in $addressLists)
        {
            Write-Host "    |---[$i/$($addressLists.Count)] $($addressList.Name)" -NoNewLine
            $params = @{
                Name                  = $addressList.Name
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
            $i ++
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
