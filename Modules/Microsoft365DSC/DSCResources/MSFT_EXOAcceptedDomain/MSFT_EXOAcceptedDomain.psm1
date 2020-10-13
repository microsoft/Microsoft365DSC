function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidatePattern( '(?=^.{1,254}$)(^(?:(?!\d+\.|-)[a-zA-Z0-9_\-]{1,63}(?<!-)\.?)+(?:[a-zA-Z]{2,})$)' )]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateSet('Authoritative','InternalRelay')]
        [System.String]
        $DomainType = 'Authoritative',

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateScript( { $false -eq $_ })]
        [System.Boolean]
        $MatchSubDomains = $false,

        [Parameter()]
        [ValidateScript( { $false -eq $_ })]
        [System.Boolean]
        $OutboundOnly = $false,

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
    Write-Verbose -Message "Getting configuration of Accepted Domain for $Identity"
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
        Write-Verbose -Message 'Getting all Accepted Domain'
        $AllAcceptedDomains = Get-AcceptedDomain -ErrorAction Stop

        Write-Verbose -Message 'Filtering Accepted Domain list by Identity'
        $AcceptedDomain = $AllAcceptedDomains | Where-Object -FilterScript { $_.Identity -eq $Identity }

        if ($null -eq $AcceptedDomain)
        {
            Write-Verbose -Message "AcceptedDomain configuration for $($Identity) does not exist."

            # Check to see if $Identity matches a verified domain in the O365 Tenant
            $ConnectionMode = New-M365DSCConnection -Platform 'AzureAd' `
            -InboundParameters $PSBoundParameters

            $VerifiedDomains = Get-AzureADDomain | Where-Object -FilterScript { $_.IsVerified }
            $MatchingVerifiedDomain = $VerifiedDomains | Where-Object -FilterScript { $_.Name -eq $Identity }

            if ($null -ne $MatchingVerifiedDomain)
            {
                Write-Verbose -Message "A verified domain matching $($Identity) does not exist in this O365 Tenant."
                $nullReturn = @{
                    DomainType         = $DomainType
                    Ensure             = $Ensure
                    GlobalAdminAccount = $GlobalAdminAccount
                    Identity           = $Identity
                    MatchSubDomains    = $MatchSubDomains
                    OutboundOnly       = $OutboundOnly
                }
                <#
                if AcceptedDomain does not exist and does not match a verified domain, return submitted parameters for ReverseDSC.
                This also prevents Set-TargetResource from running when current state could not be determined
                #>
                return $nullReturn
            }
            else
            {
                # if AcceptedDomain does not exist for a verfied domain, return 'Absent' with submitted parameters to Test-TargetResource.
                return $nullReturn
            }
        }
        else
        {
            $result = @{
                DomainType            = $AcceptedDomain.DomainType
                Ensure                = 'Present'
                Identity              = $AcceptedDomain.Identity
                MatchSubDomains       = $AcceptedDomain.MatchSubDomains
                OutboundOnly          = $AcceptedDomain.OutboundOnly
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
            }

            Write-Verbose -Message "Found AcceptedDomain configuration for $($Identity)"
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
        [ValidatePattern( '(?=^.{1,254}$)(^(?:(?!\d+\.|-)[a-zA-Z0-9_\-]{1,63}(?<!-)\.?)+(?:[a-zA-Z]{2,})$)' )]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateSet('Authoritative','InternalRelay')]
        [System.String]
        $DomainType = 'Authoritative',

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateScript( { $false -eq $_ })]
        [System.Boolean]
        $MatchSubDomains = $false,

        [Parameter()]
        [ValidateScript( { $false -eq $_ })]
        [System.Boolean]
        $OutboundOnly = $false,

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

    Write-Verbose -Message "Setting configuration of Accepted Domain for $Identity"

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

    $AcceptedDomainParams = @{
        DomainType      = $DomainType
        Identity        = $Identity
        MatchSubDomains = $MatchSubDomains
        OutboundOnly    = $OutboundOnly
    }

    Write-Verbose -Message "Setting AcceptedDomain for $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $AcceptedDomainParams)"
    Set-AcceptedDomain @AcceptedDomainParams
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidatePattern( '(?=^.{1,254}$)(^(?:(?!\d+\.|-)[a-zA-Z0-9_\-]{1,63}(?<!-)\.?)+(?:[a-zA-Z]{2,})$)' )]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateSet('Authoritative','InternalRelay')]
        [System.String]
        $DomainType = 'Authoritative',

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateScript( { $false -eq $_ })]
        [System.Boolean]
        $MatchSubDomains = $false,

        [Parameter()]
        [ValidateScript( { $false -eq $_ })]
        [System.Boolean]
        $OutboundOnly = $false,

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

    Write-Verbose -Message "Testing configuration of Accepted Domain for $Identity"

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
        [array]$AllAcceptedDomains = Get-AcceptedDomain -ErrorAction Stop

        $dscContent = ""
        $i = 1
        if ($AllAcceptedDomains.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        foreach ($domain in $AllAcceptedDomains)
        {
            Write-Host "    |---[$i/$($AllAcceptedDomains.Count)] $($domain.Identity)" -NoNewLine

            $Params = @{
                Identity              = $domain.Identity
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
                GlobalAdminAccount    = $GlobalAdminAccount
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
