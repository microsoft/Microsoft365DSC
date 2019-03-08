function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [ValidateSet('Authoritative')]
        [System.String]
        $DomainType = 'Authoritative',

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter(Mandatory = $true)]
        [ValidatePattern( '(?=^.{1,254}$)(^(?:(?!\d+\.|-)[a-zA-Z0-9_\-]{1,63}(?<!-)\.?)+(?:[a-zA-Z]{2,})$)' )]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateScript( {$false -eq $_})]
        [System.Boolean]
        $MatchSubDomains = $false,

        [Parameter()]
        [ValidateScript( {$false -eq $_})]
        [System.Boolean]
        $OutboundOnly = $false
    )
    Write-Verbose "Get-TargetResource will attempt to retrieve Accepted Domain configuration for $($Identity)"
    Write-Verbose "Calling Connect-ExchangeOnline function:"
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    Write-Verbose "Global ExchangeOnlineSession status:"
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    try
    {
        $AllAcceptedDomains = Get-AcceptedDomain
    }
    catch
    {
        $ExceptionMessage = $_.Exception
        Write-Verbose "Closing Remote PowerShell Sessions"
        $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
        Write-Error $ExceptionMessage
    }

    $AcceptedDomain = ($AllAcceptedDomains | Where-Object Identity -IMatch $Identity)

    if (!$AcceptedDomain)
    {
        Write-Verbose "AcceptedDomain configuration for $($Identity) does not exist."

        # Check to see if $Identity matches a verified domain in the O365 Tenant
        try
        {
            Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount
            $VerifiedDomains = (Get-AzureADDomain | Where-Object IsVerified)
            $MatchingVerifiedDomain = $VerifiedDomains | Where-Object Name -eq $Identity
        }
        catch
        {
            $ExceptionMessage = $_.Exception
            Write-Verbose "Closing Remote PowerShell Sessions"
            $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
            Write-Error $ExceptionMessage
        }

        if (-NOT $MatchingVerifiedDomain)
        {
            Write-Verbose "A verified domain matching $($Identity) does not exist in this O365 Tenant."
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

        Write-Verbose "Found AcceptedDomain configuration for $($Identity)"
        return $result
    }

}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [ValidateSet('Authoritative')]
        [System.String]
        $DomainType = 'Authoritative',

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter(Mandatory = $true)]
        [ValidatePattern( '(?=^.{1,254}$)(^(?:(?!\d+\.|-)[a-zA-Z0-9_\-]{1,63}(?<!-)\.?)+(?:[a-zA-Z]{2,})$)' )]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateScript( {$false -eq $_})]
        [System.Boolean]
        $MatchSubDomains = $false,

        [Parameter()]
        [ValidateScript( {$false -eq $_})]
        [System.Boolean]
        $OutboundOnly = $false
    )
    Write-Verbose 'Entering Set-TargetResource'
    Write-Verbose 'Retrieving information about AcceptedDomain configuration'
    Write-Verbose "Calling Connect-ExchangeOnline function:"
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    Write-Verbose "Global ExchangeOnlineSession status:"
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    $AcceptedDomainParams = @{
        DomainType      = $DomainType
        Identity        = $Identity
        MatchSubDomains = $MatchSubDomains
        OutboundOnly    = $OutboundOnly
    }
    try
    {
        Write-Verbose "Setting AcceptedDomain for $($Identity) with values: $($AcceptedDomainParams | Out-String)"
        Set-AcceptedDomain @AcceptedDomainParams
    }
    catch
    {
        $ExceptionMessage = $_.Exception
        Write-Verbose "Closing Remote PowerShell Sessions"
        $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
        Write-Error $ExceptionMessage
    }

}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [ValidateSet('Authoritative')]
        [System.String]
        $DomainType = 'Authoritative',

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter(Mandatory = $true)]
        [ValidatePattern( '(?=^.{1,254}$)(^(?:(?!\d+\.|-)[a-zA-Z0-9_\-]{1,63}(?<!-)\.?)+(?:[a-zA-Z]{2,})$)' )]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateScript( {$false -eq $_})]
        [System.Boolean]
        $MatchSubDomains = $false,

        [Parameter()]
        [ValidateScript( {$false -eq $_})]
        [System.Boolean]
        $OutboundOnly = $false
    )

    Write-Verbose -Message "Testing AcceptedDomain for $($Identity)"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose "Closing Remote PowerShell Sessions"
    $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck = $ValuesToCheck.Remove('GlobalAdminAccount') | out-null
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @ValuesToCheck
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [ValidateSet('Authoritative')]
        [System.String]
        $DomainType = 'Authoritative',

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter(Mandatory = $true)]
        [ValidatePattern( '(?=^.{1,254}$)(^(?:(?!\d+\.|-)[a-zA-Z0-9_\-]{1,63}(?<!-)\.?)+(?:[a-zA-Z]{2,})$)' )]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateScript( {$false -eq $_})]
        [System.Boolean]
        $MatchSubDomains = $false,

        [Parameter()]
        [ValidateScript( {$false -eq $_})]
        [System.Boolean]
        $OutboundOnly = $false
    )
    $result = Get-TargetResource @PSBoundParameters
    $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        EXOAcceptedDomain " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
