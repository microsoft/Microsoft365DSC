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
        [ValidateSet('', 'AllRecipients', 'MailboxUsers', 'MailContacts', 'MailGroups', 'MailUsers', 'Resources')]
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

    Write-Verbose -Message "Getting Global Address List configuration for $Name"
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

    $nullReturn = @{
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
        IncludedRecipients           = $IncludedRecipients
        RecipientFilter              = $RecipientFilter
        Ensure                       = 'Absent'
        GlobalAdminAccount           = $GlobalAdminAccount
    }
    if ($null -eq (Get-Command 'Get-GlobalAddressList' -ErrorAction SilentlyContinue))
    {
        return $nullReturn
    }

    try
    {
        $AllGlobalAddressLists = Get-GlobalAddressList -ErrorAction Stop

        $GlobalAddressList = $AllGlobalAddressLists | Where-Object -FilterScript { $_.Name -eq $Name }

        if ($null -eq $GlobalAddressList)
        {
            Write-Verbose -Message "Global Address List $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            if ($null -eq $GlobalAddressList.IncludedRecipients)
            {
                $IncludedRecipients = "".ToString()
            }
            else
            {
                $IncludedRecipients = $GlobalAddressList.IncludedRecipients
            }

            $result = @{
                Name                         = $GlobalAddressList.Name
                ConditionalCompany           = $GlobalAddressList.ConditionalCompany
                ConditionalCustomAttribute1  = $GlobalAddressList.ConditionalCustomAttribute1
                ConditionalCustomAttribute10 = $GlobalAddressList.ConditionalCustomAttribute10
                ConditionalCustomAttribute11 = $GlobalAddressList.ConditionalCustomAttribute11
                ConditionalCustomAttribute12 = $GlobalAddressList.ConditionalCustomAttribute12
                ConditionalCustomAttribute13 = $GlobalAddressList.ConditionalCustomAttribute13
                ConditionalCustomAttribute14 = $GlobalAddressList.ConditionalCustomAttribute14
                ConditionalCustomAttribute15 = $GlobalAddressList.ConditionalCustomAttribute15
                ConditionalCustomAttribute2  = $GlobalAddressList.ConditionalCustomAttribute2
                ConditionalCustomAttribute3  = $GlobalAddressList.ConditionalCustomAttribute3
                ConditionalCustomAttribute4  = $GlobalAddressList.ConditionalCustomAttribute4
                ConditionalCustomAttribute5  = $GlobalAddressList.ConditionalCustomAttribute5
                ConditionalCustomAttribute6  = $GlobalAddressList.ConditionalCustomAttribute6
                ConditionalCustomAttribute7  = $GlobalAddressList.ConditionalCustomAttribute7
                ConditionalCustomAttribute8  = $GlobalAddressList.ConditionalCustomAttribute8
                ConditionalCustomAttribute9  = $GlobalAddressList.ConditionalCustomAttribute9
                ConditionalDepartment        = $GlobalAddressList.ConditionalDepartment
                ConditionalStateOrProvince   = $GlobalAddressList.ConditionalStateOrProvince
                IncludedRecipients           = $IncludedRecipients
                RecipientFilter              = $GlobalAddressList.RecipientFilter
                Ensure                       = 'Present'
                GlobalAdminAccount           = $GlobalAdminAccount
            }

            Write-Verbose -Message "Found Global Address List $($Name)"
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
        [ValidateSet('', 'AllRecipients', 'MailboxUsers', 'MailContacts', 'MailGroups', 'MailUsers', 'Resources')]
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

    Write-Verbose -Message "Setting Global Address List configuration for $Name"

    $currentGlobalAddressListConfig = Get-TargetResource @PSBoundParameters

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

    # RecipientFilter parameter cannot be used in combination with the IncludedRecipients parameter or any Conditional parameters (which are used to create precanned filters).
    if ($RecipientFilter)
    {
        $NewGlobalAddressListParams = @{
            Name            = $Name
            RecipientFilter = $RecipientFilter
            Confirm         = $false
        }
    }
    else
    {
        $NewGlobalAddressListParams = @{
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
            IncludedRecipients           = $IncludedRecipients
            Confirm                      = $false
        }
    }

    $SetGlobalAddressListParams = @{
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
        IncludedRecipients           = $IncludedRecipients
        RecipientFilter              = $RecipientFilter
        Confirm                      = $false
    }

    # CASE: Global Address List doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentGlobalAddressListConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Global Address List '$($Name)' does not exist but it should. Create and configure it."
        # Create Global Address List
        New-GlobalAddressList @NewGlobalAddressListParams

    }
    # CASE: Global Address List exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentGlobalAddressListConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Global Address List '$($Name)' exists but it shouldn't. Remove it."
        Remove-GlobalAddressList -Identity $Name -Confirm:$false
    }
    # CASE: Global Address List exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentGlobalAddressListConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Global Address List '$($Name)' already exists, but needs updating."
        Write-Verbose -Message "Setting Global Address List $($Name) with values: $(Convert-M365DscHashtableToString -Hashtable $SetGlobalAddressListParams)"
        Set-GlobalAddressList @SetGlobalAddressListParams
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
        [ValidateSet('', 'AllRecipients', 'MailboxUsers', 'MailContacts', 'MailGroups', 'MailUsers', 'Resources')]
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

    Write-Verbose -Message "Testing Global Address List configuration for $Name"

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

    if ($null -eq (Get-Command 'Get-GlobalAddressList' -ErrorAction SilentlyContinue))
    {
        Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered to allow for Global Address List"
        return ""
    }

    try
    {
        [array]$AllGlobalAddressLists = Get-GlobalAddressList -ErrorAction Stop

        $dscContent = ""
        if ($AllGlobalAddressLists.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        $i = 1
        foreach ($GlobalAddressList in $AllGlobalAddressLists)
        {
            Write-Host "    |---[$i/$($AllGlobalAddressLists.Count)] $($GlobalAddressList.Name)" -NoNewLine

            $Params = @{
                Name                  = $GlobalAddressList.Name
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

