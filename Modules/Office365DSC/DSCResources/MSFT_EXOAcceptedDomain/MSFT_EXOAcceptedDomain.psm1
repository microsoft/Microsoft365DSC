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
        [ValidateSet('Authoritative')]
        [System.String]
        $DomainType = 'Authoritative',

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateScript( {$false -eq $_})]
        [System.Boolean]
        $MatchSubDomains = $false,

        [Parameter()]
        [ValidateScript( {$false -eq $_})]
        [System.Boolean]
        $OutboundOnly = $false,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Accepted Domain for $Identity"

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    $AllAcceptedDomains = Get-AcceptedDomain

    $AcceptedDomain = ($AllAcceptedDomains | Where-Object -FilterScript { $_.Identity -IMatch $Identity })

    if ($null -eq $AcceptedDomain)
    {
        Write-Verbose -Message "AcceptedDomain configuration for $($Identity) does not exist."

        # Check to see if $Identity matches a verified domain in the O365 Tenant
        Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount
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
        [ValidateSet('Authoritative')]
        [System.String]
        $DomainType = 'Authoritative',

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateScript( {$false -eq $_})]
        [System.Boolean]
        $MatchSubDomains = $false,

        [Parameter()]
        [ValidateScript( {$false -eq $_})]
        [System.Boolean]
        $OutboundOnly = $false,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Accepted Domain for $Identity"

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    $AcceptedDomainParams = @{
        DomainType      = $DomainType
        Identity        = $Identity
        MatchSubDomains = $MatchSubDomains
        OutboundOnly    = $OutboundOnly
    }

    Write-Verbose -Message "Setting AcceptedDomain for $($Identity) with values: $(Convert-O365DscHashtableToString -Hashtable $AcceptedDomainParams)"
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
        [ValidateSet('Authoritative')]
        [System.String]
        $DomainType = 'Authoritative',

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateScript( {$false -eq $_})]
        [System.Boolean]
        $MatchSubDomains = $false,

        [Parameter()]
        [ValidateScript( {$false -eq $_})]
        [System.Boolean]
        $OutboundOnly = $false,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Accepted Domain for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
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
        [ValidatePattern('(?=^.{1,254}$)(^(?:(?!\d+\.|-)[a-zA-Z0-9_\-]{1,63}(?<!-)\.?)+(?:[a-zA-Z]{2,})$)' )]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        EXOAcceptedDomain " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
