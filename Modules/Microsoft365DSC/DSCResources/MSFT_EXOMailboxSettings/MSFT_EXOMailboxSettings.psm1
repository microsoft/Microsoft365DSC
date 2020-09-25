function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $TimeZone,

        [Parameter()]
        [System.String]
        $Locale,

        [Parameter()]
        [ValidateSet("Present")]
        [System.String]
        $Ensure = "Present",

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

    Write-Verbose -Message "Getting configuration of Office 365 Mailbox Settings for $DisplayName"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = @{
        DisplayName = $DisplayName
        TimeZone    = $null
        Locale      = $null
        Ensure      = "Absent"
    }

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
        $mailboxSettings = Get-MailboxRegionalConfiguration -Identity $DisplayName -ErrorAction Stop
    }
    catch
    {
        return $nullReturn
    }

    if ($null -eq $mailboxSettings)
    {
        Write-Verbose -Message "The specified Mailbox doesn't already exist."
        return $nullReturn
    }

    $result = @{
        DisplayName        = $DisplayName
        TimeZone           = $mailboxSettings.TimeZone
        Locale             = $mailboxSettings.Language.Name
        Ensure             = "Present"
        GlobalAdminAccount = $GlobalAdminAccount
    }
    Write-Verbose -Message "Found an existing instance of Mailbox '$($DisplayName)'"
    return $result
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $TimeZone,

        [Parameter()]
        [System.String]
        $Locale,

        [Parameter()]
        [ValidateSet("Present")]
        [System.String]
        $Ensure = "Present",

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

    Write-Verbose -Message "Setting configuration of Office 365 Mailbox Settings for $DisplayName"
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

    $currentMailbox = Get-TargetResource @PSBoundParameters

    # CASE: Mailbox doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentMailbox.Ensure -eq "Absent")
    {
        throw "The specified mailbox {$($DisplayName)} does not exist."
    }

    $AllowedTimeZones = (Get-ChildItem "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Time zones" | `
            ForEach-Object { Get-ItemProperty $_.PSPath }).PSChildName

    if ($AllowedTimeZones.Contains($TimeZone) -eq $false)
    {
        throw "The specified Time Zone {$($TimeZone)} is not valid."
    }


    Set-MailboxRegionalConfiguration -Identity $DisplayName `
        -Language $Locale `
        -TimeZone $TimeZone
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $TimeZone,

        [Parameter()]
        [System.String]
        $Locale,

        [Parameter()]
        [ValidateSet("Present")]
        [System.String]
        $Ensure = "Present",

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

    Write-Verbose -Message "Testing configuration of Office 365 Mailbox Settings for $DisplayName"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Ensure", `
            "DisplayName", `
            "TimeZone", `
            "Locale")

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

    [array]$mailboxes = Get-Mailbox -ResultSize 'Unlimited'

    $i = 1
    if ($mailboxes.Length -eq 0)
    {
        Write-Host $Global:M365DSCEmojiGreenCheckMark
    }
    else
    {
        Write-Host "`r`n"-NoNewLine
    }
    $dscContent = ''
    foreach ($mailbox in $mailboxes)
    {
        Write-Host "    |---[$i/$($mailboxes.Length)] $($mailbox.Name)" -NoNewLine
        $mailboxName = $mailbox.Name
        if (![System.String]::IsNullOrEmpty($mailboxName))
        {
            $Params = @{
                GlobalAdminAccount    = $GlobalAdminAccount
                DisplayName           = $mailbox.Name
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
            }
            $Results = Get-TargetResource @Params

            if ($Results.Ensure -eq 'Present')
            {
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
                $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -GlobalAdminAccount $GlobalAdminAccount
            }
        }
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        $i++
    }
    return $dscContent
}

Export-ModuleMember -Function *-TargetResource
