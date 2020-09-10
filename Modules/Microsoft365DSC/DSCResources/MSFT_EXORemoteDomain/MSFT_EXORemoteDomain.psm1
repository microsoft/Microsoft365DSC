function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateLength(0, 256)]
        [System.String]
        $DomainName,

        [Parameter()]
        [ValidateSet('External', 'ExternalLegacy', 'InternalLegacy', 'None')]
        [System.String]
        $AllowedOOFType,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Boolean]
        $AutoForwardEnabled,

        [Parameter()]
        [System.Boolean]
        $AutoReplyEnabled,

        [Parameter()]
        [ValidateSet('Use7Bit', 'UseQP', 'UseBase64', 'UseQPHtmlDetectTextPlain', 'UseBase64HtmlDetectTextPlain', 'UseQPHtml7BitTextPlain', 'UseBase64Html7BitTextPlain', 'Undefined')]
        [System.String]
        $ByteEncoderTypeFor7BitCharsets,

        [Parameter()]
        [System.String]
        $CharacterSet,

        [Parameter()]
        [ValidateSet('MimeHtmlText', 'MimeText', 'MimeHtml')]
        [System.String]
        $ContentType,

        [Parameter()]
        [System.Boolean]
        $DeliveryReportEnabled,

        [Parameter()]
        [System.Boolean]
        $DisplaySenderName,

        [Parameter()]
        [System.Boolean]
        $IsInternal,

        [Parameter()]
        [System.String]
        $LineWrapSize,

        [Parameter()]
        [System.Boolean]
        $MeetingForwardNotificationEnabled,

        [Parameter()]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $NonMimeCharacterSet,

        [Parameter()]
        [ValidateSet('50220', '50221', '50222', 'Undefined')]
        [System.String]
        $PreferredInternetCodePageForShiftJis,

        [Parameter()]
        [System.Int32]
        $RequiredCharsetCoverage,

        [Parameter()]
        [System.String]
        $TargetDeliveryDomain,

        [Parameter()]
        [System.Boolean]
        $TNEFEnabled,

        [Parameter()]
        [System.Boolean]
        $TrustedMailInboundEnabled,

        [Parameter()]
        [System.Boolean]
        $TrustedMailOutboundEnabled,

        [Parameter()]
        [System.Boolean]
        $UseSimpleDisplayName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )


    Write-Verbose -Message "Getting configuration of Remote Domain for $Identity"

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $RemoteDomain = Get-RemoteDomain -Identity $Identity -ErrorAction SilentlyContinue

    if ($null -eq $RemoteDomain)
    {
        Write-Verbose -Message "RemoteDomain configuration for $($Identity) does not exist."

        $nullReturn = @{
            Identity                             = $Identity
            DomainName                           = $DomainName
            AllowedOOFType                       = $AllowedOOFType
            Ensure                               = $Ensure
            AutoForwardEnabled                   = $AutoForwardEnabled
            AutoReplyEnabled                     = $AutoReplyEnabled
            ByteEncoderTypeFor7BitCharsets       = $ByteEncoderTypeFor7BitCharsets
            CharacterSet                         = $CharacterSet
            ContentType                          = $ContentType
            DeliveryReportEnabled                = $DeliveryReportEnabled
            DisplaySenderName                    = $DisplaySenderName
            IsInternal                           = $IsInternal
            LineWrapSize                         = $LineWrapSize
            MeetingForwardNotificationEnabled    = $MeetingForwardNotificationEnabled
            Name                                 = $Name
            NonMimeCharacterSet                  = $NonMimeCharacterSet
            PreferredInternetCodePageForShiftJis = $PreferredInternetCodePageForShiftJis
            RequiredCharsetCoverage              = $RequiredCharsetCoverage
            TargetDeliveryDomain                 = $TargetDeliveryDomain
            TNEFEnabled                          = $TNEFEnabled
            TrustedMailInboundEnabled            = $TrustedMailInboundEnabled
            TrustedMailOutboundEnabled           = $TrustedMailOutboundEnabled
            UseSimpleDisplayName                 = $UseSimpleDisplayName
            GlobalAdminAccount                   = $GlobalAdminAccount
        }

        return $nullReturn

    }
    else
    {
        $result = @{
            Identity                             = $RemoteDomain.Identity
            DomainName                           = $RemoteDomain.DomainName
            AllowedOOFType                       = $RemoteDomain.AllowedOOFType
            Ensure                               = 'Present'
            AutoForwardEnabled                   = $RemoteDomain.AutoForwardEnabled
            AutoReplyEnabled                     = $RemoteDomain.AutoReplyEnabled
            ByteEncoderTypeFor7BitCharsets       = $RemoteDomain.ByteEncoderTypeFor7BitCharsets
            CharacterSet                         = $RemoteDomain.CharacterSet
            ContentType                          = $RemoteDomain.ContentType
            DeliveryReportEnabled                = $RemoteDomain.DeliveryReportEnabled
            DisplaySenderName                    = $RemoteDomain.DisplaySenderName
            IsInternal                           = $RemoteDomain.IsInternal
            LineWrapSize                         = $RemoteDomain.LineWrapSize
            MeetingForwardNotificationEnabled    = $RemoteDomain.MeetingForwardNotificationEnabled
            Name                                 = $RemoteDomain.Name
            NonMimeCharacterSet                  = $RemoteDomain.NonMimeCharacterSet
            PreferredInternetCodePageForShiftJis = $RemoteDomain.PreferredInternetCodePageForShiftJis
            RequiredCharsetCoverage              = $RemoteDomain.RequiredCharsetCoverage
            TargetDeliveryDomain                 = $RemoteDomain.TargetDeliveryDomain
            TNEFEnabled                          = $RemoteDomain.TNEFEnabled
            TrustedMailInboundEnabled            = $RemoteDomain.TrustedMailInboundEnabled
            TrustedMailOutboundEnabled           = $RemoteDomain.TrustedMailOutboundEnabled
            UseSimpleDisplayName                 = $RemoteDomain.UseSimpleDisplayName
            GlobalAdminAccount                   = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found RemoteDomain configuration for $($Identity)"
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
        $Identity,

        [Parameter()]
        [ValidateLength(0, 256)]
        [System.String]
        $DomainName,

        [Parameter()]
        [ValidateSet('External', 'ExternalLegacy', 'InternalLegacy', 'None')]
        [System.String]
        $AllowedOOFType,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Boolean]
        $AutoForwardEnabled,

        [Parameter()]
        [System.Boolean]
        $AutoReplyEnabled,

        [Parameter()]
        [ValidateSet('Use7Bit', 'UseQP', 'UseBase64', 'UseQPHtmlDetectTextPlain', 'UseBase64HtmlDetectTextPlain', 'UseQPHtml7BitTextPlain', 'UseBase64Html7BitTextPlain', 'Undefined')]
        [System.String]
        $ByteEncoderTypeFor7BitCharsets,

        [Parameter()]
        [System.String]
        $CharacterSet,

        [Parameter()]
        [ValidateSet('MimeHtmlText', 'MimeText', 'MimeHtml')]
        [System.String]
        $ContentType,

        [Parameter()]
        [System.Boolean]
        $DeliveryReportEnabled,

        [Parameter()]
        [System.Boolean]
        $DisplaySenderName,

        [Parameter()]
        [System.Boolean]
        $IsInternal,

        [Parameter()]
        [System.String]
        $LineWrapSize,

        [Parameter()]
        [System.Boolean]
        $MeetingForwardNotificationEnabled,

        [Parameter()]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $NonMimeCharacterSet,

        [Parameter()]
        [ValidateSet('50220', '50221', '50222', 'Undefined')]
        [System.String]
        $PreferredInternetCodePageForShiftJis,

        [Parameter()]
        [System.Int32]
        $RequiredCharsetCoverage,

        [Parameter()]
        [System.String]
        $TargetDeliveryDomain,

        [Parameter()]
        [System.Boolean]
        $TNEFEnabled,

        [Parameter()]
        [System.Boolean]
        $TrustedMailInboundEnabled,

        [Parameter()]
        [System.Boolean]
        $TrustedMailOutboundEnabled,

        [Parameter()]
        [System.Boolean]
        $UseSimpleDisplayName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Remote Domain for $Identity"

    $currentRemoteDomainConfig = Get-TargetResource @PSBoundParameters

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $RemoteDomainParams = @{
        Identity                             = $Identity
        AllowedOOFType                       = $AllowedOOFType
        AutoForwardEnabled                   = $AutoForwardEnabled
        AutoReplyEnabled                     = $AutoReplyEnabled
        ByteEncoderTypeFor7BitCharsets       = $ByteEncoderTypeFor7BitCharsets
        CharacterSet                         = $CharacterSet
        ContentType                          = $ContentType
        DeliveryReportEnabled                = $DeliveryReportEnabled
        DisplaySenderName                    = $DisplaySenderName
        IsInternal                           = $IsInternal
        LineWrapSize                         = $LineWrapSize
        MeetingForwardNotificationEnabled    = $MeetingForwardNotificationEnabled
        Name                                 = $Name
        NonMimeCharacterSet                  = $NonMimeCharacterSet
        PreferredInternetCodePageForShiftJis = $PreferredInternetCodePageForShiftJis
        RequiredCharsetCoverage              = $RequiredCharsetCoverage
        TargetDeliveryDomain                 = $TargetDeliveryDomain
        TNEFEnabled                          = $TNEFEnabled
        TrustedMailInboundEnabled            = $TrustedMailInboundEnabled
        TrustedMailOutboundEnabled           = $TrustedMailOutboundEnabled
        UseSimpleDisplayName                 = $UseSimpleDisplayName
    }

    # CASE: Remote Domain doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentRemoteDomainConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Remote Domain '$($Name)' does not exist but it should. Create and configure it."
        # Create remote domain
        New-RemoteDomain -Name $Name -DomainName $DomainName
        # Configure new remote domain
        Set-RemoteDomain @RemoteDomainParams
    }
    # CASE: Remote Domain exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentRemoteDomainConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Remote Domain '$($Name)' exists but it shouldn't. Remove it."
        Remove-RemoteDomain -Identity $Name -Confirm:$false
    }
    # CASE: Remote Domain exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentRemoteDomainConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Remote Domain '$($Name)' already exists, but needs updating."
        Write-Verbose -Message "Setting RemoteDomain for $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $RemoteDomainParams)"
        Set-RemoteDomain @RemoteDomainParams
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
        $Identity,

        [Parameter()]
        [ValidateLength(0, 256)]
        [System.String]
        $DomainName,

        [Parameter()]
        [ValidateSet('External', 'ExternalLegacy', 'InternalLegacy', 'None')]
        [System.String]
        $AllowedOOFType,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Boolean]
        $AutoForwardEnabled,

        [Parameter()]
        [System.Boolean]
        $AutoReplyEnabled,

        [Parameter()]
        [ValidateSet('Use7Bit', 'UseQP', 'UseBase64', 'UseQPHtmlDetectTextPlain', 'UseBase64HtmlDetectTextPlain', 'UseQPHtml7BitTextPlain', 'UseBase64Html7BitTextPlain', 'Undefined')]
        [System.String]
        $ByteEncoderTypeFor7BitCharsets,

        [Parameter()]
        [System.String]
        $CharacterSet,

        [Parameter()]
        [ValidateSet('MimeHtmlText', 'MimeText', 'MimeHtml')]
        [System.String]
        $ContentType,

        [Parameter()]
        [System.Boolean]
        $DeliveryReportEnabled,

        [Parameter()]
        [System.Boolean]
        $DisplaySenderName,

        [Parameter()]
        [System.Boolean]
        $IsInternal,

        [Parameter()]
        [System.String]
        $LineWrapSize,

        [Parameter()]
        [System.Boolean]
        $MeetingForwardNotificationEnabled,

        [Parameter()]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $NonMimeCharacterSet,

        [Parameter()]
        [ValidateSet('50220', '50221', '50222', 'Undefined')]
        [System.String]
        $PreferredInternetCodePageForShiftJis,

        [Parameter()]
        [System.Int32]
        $RequiredCharsetCoverage,

        [Parameter()]
        [System.String]
        $TargetDeliveryDomain,

        [Parameter()]
        [System.Boolean]
        $TNEFEnabled,

        [Parameter()]
        [System.Boolean]
        $TrustedMailInboundEnabled,

        [Parameter()]
        [System.Boolean]
        $TrustedMailOutboundEnabled,

        [Parameter()]
        [System.Boolean]
        $UseSimpleDisplayName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Remote Domain for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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

    [array]$AllRemoteDomains = Get-RemoteDomain

    $dscContent = ""
    $i = 1
    foreach ($domain in $AllRemoteDomains)
    {
        Write-Information "    [$i/$($AllRemoteDomains.Count)] $($domain.Identity)"

        $Params = @{
            Identity           = $domain.Identity
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        EXORemoteDomain " + (New-GUID).ToString() + "`r`n"
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

