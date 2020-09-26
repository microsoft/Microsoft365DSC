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
        [System.String]
        $Priority,

        [Parameter()]
        [System.String[]]
        $EnabledEmailAddressTemplates,

        [Parameter()]
        [System.String[]]
        $EnabledPrimarySMTPAddressTemplate,

        [Parameter()]
        [System.String]
        $ManagedByFilter,

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

    Write-Verbose -Message "Getting Email Address Policy configuration for $Name"
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

    $nullReturn = @{
        Name                              = $Name
        Priority                          = $Priority
        EnabledEmailAddressTemplates      = $EnabledEmailAddressTemplates
        EnabledPrimarySMTPAddressTemplate = $EnabledPrimarySMTPAddressTemplate
        ManagedByFilter                   = $ManagedByFilter
        Ensure                            = 'Absent'
        GlobalAdminAccount                = $GlobalAdminAccount
    }

    try
    {
        $AllEmailAddressPolicies = Get-EmailAddressPolicy -ErrorAction Stop

        $EmailAddressPolicy = $AllEmailAddressPolicies | Where-Object -FilterScript { $_.Name -eq $Name }

        if ($null -eq $EmailAddressPolicy)
        {
            Write-Verbose -Message "Email Address Policy $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Name                              = $EmailAddressPolicy.Name
                Priority                          = $EmailAddressPolicy.Priority
                EnabledEmailAddressTemplates      = $EmailAddressPolicy.EnabledEmailAddressTemplates
                EnabledPrimarySMTPAddressTemplate = $EmailAddressPolicy.EnabledPrimarySMTPAddressTemplate
                ManagedByFilter                   = $EmailAddressPolicy.ManagedByFilter
                Ensure                            = 'Present'
                GlobalAdminAccount                = $GlobalAdminAccount
            }

            Write-Verbose -Message "Found Email Address Policy $($Name)"
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
        [System.String]
        $Priority,

        [Parameter()]
        [System.String[]]
        $EnabledEmailAddressTemplates,

        [Parameter()]
        [System.String[]]
        $EnabledPrimarySMTPAddressTemplate,

        [Parameter()]
        [System.String]
        $ManagedByFilter,

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

    Write-Verbose -Message "Setting Email Address Policy configuration for $Name"

    $currentEmailAddressPolicyConfig = Get-TargetResource @PSBoundParameters

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

    $NewEmailAddressPolicyParams = @{
        Name                              = $Name
        Priority                          = $Priority
        EnabledEmailAddressTemplates      = $EnabledEmailAddressTemplates
        EnabledPrimarySMTPAddressTemplate = $EnabledPrimarySMTPAddressTemplate
        ManagedByFilter                   = $ManagedByFilter
        IncludeUnifiedGroupRecipients     = $true
        Confirm                           = $false
    }

    $SetEmailAddressPolicyParams = @{
        Identity                          = $Name
        Priority                          = $Priority
        EnabledEmailAddressTemplates      = $EnabledEmailAddressTemplates
        EnabledPrimarySMTPAddressTemplate = $EnabledPrimarySMTPAddressTemplate
        Confirm                           = $false
    }

    # EnabledEmailAddressTemplates and EnabledPrimarySMTPAddressTemplate cannot used at the same time.
    # If both parameters are specified, EnabledPrimarySMTPAddressTemplate will be removed and only
    # EnabledEmailAddressTemplates will be used.
    if ($null -ne $EnabledEmailAddressTemplates)
    {
        $NewEmailAddressPolicyParams.Remove("EnabledPrimarySMTPAddressTemplate")
        $SetEmailAddressPolicyParams.Remove("EnabledPrimarySMTPAddressTemplate")
    }

    # CASE: Email Address Policy doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentEmailAddressPolicyConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Email Address Policy '$($Name)' does not exist but it should. Create and configure it."
        # Create Email Address Policy
        New-EmailAddressPolicy @NewEmailAddressPolicyParams

    }
    # CASE: Email Address Policy exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentEmailAddressPolicyConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Email Address Policy '$($Name)' exists but it shouldn't. Remove it."
        Remove-EmailAddressPolicy -Identity $Name -Confirm:$false
    }
    # CASE: Email Address Policy exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentEmailAddressPolicyConfig.Ensure -eq "Present")
    {
        if ($Identity -ne 'Default Policy')
        {
            Write-Verbose -Message "Email Address Policy '$($Name)' already exists, but needs updating."
            Write-Verbose -Message "Setting Email Address Policy $($Name) with values: $(Convert-M365DscHashtableToString -Hashtable $SetEmailAddressPolicyParams)"
            Set-EmailAddressPolicy @SetEmailAddressPolicyParams
        }
        else
        {
            Write-Verbose -Message "Cannot update the Default Email Address Policy."
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
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Priority,

        [Parameter()]
        [System.String[]]
        $EnabledEmailAddressTemplates,

        [Parameter()]
        [System.String[]]
        $EnabledPrimarySMTPAddressTemplate,

        [Parameter()]
        [System.String]
        $ManagedByFilter,

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

    Write-Verbose -Message "Testing Email Address Policy configuration for $Name"

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
    if ($null -eq (Get-Command Get-EmailAddressPolicy -ErrorAction SilentlyContinue))
    {
        Write-Host "`r`n    $($Global:M365DSCEmojiRedX) The specified account doesn't have permissions to access Email Address Policy"
        return ""
    }

    try
    {
        [array]$AllEmailAddressPolicies = Get-EmailAddressPolicy -ErrorAction Stop

        $dscContent = ""
        if ($AllEmailAddressPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        $i = 1
        foreach ($EmailAddressPolicy in $AllEmailAddressPolicies)
        {
            Write-Host "    |---[$i/$($AllEmailAddressPolicies.Count)] $($EmailAddressPolicy.Name)" -NoNewLine

            $Params = @{
                Name                  = $EmailAddressPolicy.Name
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

