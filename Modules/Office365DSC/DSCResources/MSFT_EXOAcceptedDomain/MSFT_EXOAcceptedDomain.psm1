function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [ValidateSet('Authoritative', 'ExternalRelay', 'InternalRelay')]
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
        [ValidatePattern( '(?=^.{1,254}$)(^(?:(?!\d+\.|-)[a-zA-Z0-9_\-]{1,63}(?<!-)\.?)+(?:[a-zA-Z]{2,})$)|(\{|\()?[A-Za-z0-9]{4}([A-Za-z0-9]{4}\-?){4}[A-Za-z0-9]{12}(\}|\()?' )]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $MatchSubDomains = $false,

        [Parameter()]
        [System.Boolean]
        $OutboundOnly = $false
    )
    Write-Verbose "Get-TargetResource will attempt to retrieve Accepted Domain configuration for $($Identity)"
    $nullReturn = @{
        DomainType         = $null
        Ensure             = 'Absent'
        GlobalAdminAccount = $null
        Identity           = $Identity
        MatchSubDomains    = $null
        OutboundOnly       = $null
    }

    $AcceptedDomain = Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
        -ScriptBlock {
        Get-AcceptedDomain -Identity $Identity
    }

    if (!$AcceptedDomain)
    {
        Write-Verbose "AcceptedDomain configuration for $($Identity) does not exist."
        return $nullReturn
    }

    $result = @{
        DomainType         = $AcceptedDomain.DomainType
        Ensure             = $Ensure
        GlobalAdminAccount = $GlobalAdminAccount
        Identity           = $Identity
        MatchSubDomains    = $AcceptedDomain.MatchSubDomains
        OutboundOnly       = $AcceptedDomain.OutboundOnly
    }

    Write-Verbose "Found AcceptedDomain configuration for $($Identity)"
    return $result
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [ValidateSet('Authoritative', 'ExternalRelay', 'InternalRelay')]
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
        [ValidatePattern( '(?=^.{1,254}$)(^(?:(?!\d+\.|-)[a-zA-Z0-9_\-]{1,63}(?<!-)\.?)+(?:[a-zA-Z]{2,})$)|(\{|\()?[A-Za-z0-9]{4}([A-Za-z0-9]{4}\-?){4}[A-Za-z0-9]{12}(\}|\()?' )]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $MatchSubDomains = $false,

        [Parameter()]
        [System.Boolean]
        $OutboundOnly = $false
    )
    Write-Verbose 'Entering Set-TargetResource'
    Write-Verbose 'Retrieving information about AcceptedDomain configuration'
    $AcceptedDomain = Get-TargetResource @PSBoundParameters
    Write-Verbose "Setting AcceptedDomain for $($Identity) with values: $($PSBoundParameters)"
    $AcceptedDomainParams = @{
        DomainType      = $DomainType
        Identity        = $Identity
        MatchSubDomains = $MatchSubDomains
        OutboundOnly    = $OutboundOnly
    }

    Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
        -Arguments $PSBoundParameters `
        -ScriptBlock { Set-AcceptedDomain @AcceptedDomainParams }
}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [ValidateSet('Authoritative', 'ExternalRelay', 'InternalRelay')]
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
        [ValidatePattern( '(?=^.{1,254}$)(^(?:(?!\d+\.|-)[a-zA-Z0-9_\-]{1,63}(?<!-)\.?)+(?:[a-zA-Z]{2,})$)|(\{|\()?[A-Za-z0-9]{4}([A-Za-z0-9]{4}\-?){4}[A-Za-z0-9]{12}(\}|\()?' )]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $MatchSubDomains = $false,

        [Parameter()]
        [System.Boolean]
        $OutboundOnly = $false
    )

    Write-Verbose -Message "Testing AcceptedDomain for $($Identity)"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @('DomainType',
        'Ensure',
        'Identity',
        'MatchSubDomains',
        'OutboundOnly'
    )
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [ValidateSet('Authoritative', 'ExternalRelay', 'InternalRelay')]
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
        [ValidatePattern( '(?=^.{1,254}$)(^(?:(?!\d+\.|-)[a-zA-Z0-9_\-]{1,63}(?<!-)\.?)+(?:[a-zA-Z]{2,})$)|(\{|\()?[A-Za-z0-9]{4}([A-Za-z0-9]{4}\-?){4}[A-Za-z0-9]{12}(\}|\()?' )]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $MatchSubDomains = $false,

        [Parameter()]
        [System.Boolean]
        $OutboundOnly = $false
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        EXOAcceptedDomain " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
