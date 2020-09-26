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
        $ApplicationIdentifier,

        [Parameter()]
        [System.Boolean]
        $AcceptSecurityIdentifierInformation,

        [Parameter()]
        [ValidateSet('OrganizationalAccount', 'ConsumerAccount')]
        [System.String]
        $AccountType,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $LinkedAccount,

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

    Write-Verbose -Message "Getting Partner Application configuration for $Name"
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
    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    try
    {
        $AllPartnerApplications = Get-PartnerApplication -ErrorAction Stop

        $PartnerApplication = $AllPartnerApplications | Where-Object -FilterScript { $_.Name -eq $Name }

        if ($null -eq $PartnerApplication)
        {
            Write-Verbose -Message "Partner Application $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Name                                = $PartnerApplication.Name
                ApplicationIdentifier               = $PartnerApplication.ApplicationIdentifier
                AcceptSecurityIdentifierInformation = $PartnerApplication.AcceptSecurityIdentifierInformation
                AccountType                         = $PartnerApplication.AccountType
                Enabled                             = $PartnerApplication.Enabled
                LinkedAccount                       = $PartnerApplication.LinkedAccount
                Ensure                              = 'Present'
                GlobalAdminAccount                  = $GlobalAdminAccount
            }

            Write-Verbose -Message "Found Partner Application $($Name)"
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
        [System.String]
        $ApplicationIdentifier,

        [Parameter()]
        [System.Boolean]
        $AcceptSecurityIdentifierInformation,

        [Parameter()]
        [ValidateSet('OrganizationalAccount', 'ConsumerAccount')]
        [System.String]
        $AccountType,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $LinkedAccount,

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

    Write-Verbose -Message "Setting Partner Application configuration for $Name"

    $currentPartnerApplicationConfig = Get-TargetResource @PSBoundParameters

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

    $NewPartnerApplicationParams = @{
        Name                                = $Name
        ApplicationIdentifier               = $ApplicationIdentifier
        AcceptSecurityIdentifierInformation = $AcceptSecurityIdentifierInformation
        AccountType                         = $AccountType
        Enabled                             = $Enabled
        LinkedAccount                       = $LinkedAccount
        Confirm                             = $false
    }

    $SetPartnerApplicationParams = @{
        Identity                            = $Name
        Name                                = $Name
        ApplicationIdentifier               = $ApplicationIdentifier
        AcceptSecurityIdentifierInformation = $AcceptSecurityIdentifierInformation
        AccountType                         = $AccountType
        Enabled                             = $Enabled
        LinkedAccount                       = $LinkedAccount
        Confirm                             = $false
    }

    # CASE: Partner Application doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentPartnerApplicationConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Partner Application '$($Name)' does not exist but it should. Create and configure it."
        # Create Partner Application
        New-PartnerApplication @NewPartnerApplicationParams

    }
    # CASE: Partner Application exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentPartnerApplicationConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Partner Application '$($Name)' exists but it shouldn't. Remove it."
        Remove-PartnerApplication -Identity $Name -Confirm:$false
    }
    # CASE: Partner Application exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentPartnerApplicationConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Partner Application '$($Name)' already exists, but needs updating."
        Write-Verbose -Message "Setting Partner Application $($Name) with values: $(Convert-M365DscHashtableToString -Hashtable $SetPartnerApplicationParams)"
        Set-PartnerApplication @SetPartnerApplicationParams
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
        $ApplicationIdentifier,

        [Parameter()]
        [System.Boolean]
        $AcceptSecurityIdentifierInformation,

        [Parameter()]
        [ValidateSet('OrganizationalAccount', 'ConsumerAccount')]
        [System.String]
        $AccountType,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $LinkedAccount,

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

    Write-Verbose -Message "Testing Partner Application configuration for $Name"

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

    try
    {
        [array]$AllPartnerApplications = Get-PartnerApplication -ErrorAction Stop

        $dscContent = ""
        if ($AllPartnerApplications.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        $i = 1
        foreach ($PartnerApplication in $AllPartnerApplications)
        {
            Write-Host "    |---[$i/$($AllPartnerApplications.Length)] $($PartnerApplication.Name)" -NoNewLine

            $Params = @{
                Name                  = $PartnerApplication.Name
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

