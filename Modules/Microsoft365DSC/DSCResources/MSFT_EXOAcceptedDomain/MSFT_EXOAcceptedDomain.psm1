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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Accepted Domain for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    Write-Verbose -Message 'Getting all Accepted Domain'
    $AllAcceptedDomains = Get-AcceptedDomain

    Write-Verbose -Message 'Filtering Accepted Domain list by Identity'
    $AcceptedDomain = $AllAcceptedDomains | Where-Object -FilterScript { $_.Identity -eq $Identity }

    if ($null -eq $AcceptedDomain)
    {
        Write-Verbose -Message "AcceptedDomain configuration for $($Identity) does not exist."

        # Check to see if $Identity matches a verified domain in the O365 Tenant
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
            -Platform AzureAD

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
            $result = @{
                DomainType         = $DomainType
                Ensure             = 'Absent'
                GlobalAdminAccount = $GlobalAdminAccount
                Identity           = $Identity
                MatchSubDomains    = $MatchSubDomains
                OutboundOnly       = $OutboundOnly
            }
            # if AcceptedDomain does not exist for a verfied domain, return 'Absent' with submitted parameters to Test-TargetResource.
            return $result
        }
    }
    else
    {
        $result = @{
            DomainType         = $AcceptedDomain.DomainType
            Ensure             = 'Present'
            GlobalAdminAccount = $GlobalAdminAccount
            Identity           = $AcceptedDomain.Identity
            MatchSubDomains    = $AcceptedDomain.MatchSubDomains
            OutboundOnly       = $AcceptedDomain.OutboundOnly
        }

        Write-Verbose -Message "Found AcceptedDomain configuration for $($Identity)"
        return $result
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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Accepted Domain for $Identity"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Accepted Domain for $Identity"

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

    [array]$AllAcceptedDomains = Get-AcceptedDomain

    $dscContent = ""
    $i = 1
    foreach ($domain in $AllAcceptedDomains)
    {
        Write-Information "    [$i/$($AllAcceptedDomains.Count)] $($domain.Identity)"

        $Params = @{
            Identity           = $domain.Identity
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        EXOAcceptedDomain " + (New-GUID).ToString() + "`r`n"
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
