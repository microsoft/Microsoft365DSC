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
        [System.String[]]
        $HybridDomains,

        [Parameter()]
        [System.String]
        $InboundConnector,

        [Parameter()]
        [System.String]
        $OutboundConnector,

        [Parameter()]
        [System.String]
        $OrganizationName,

        [Parameter()]
        [System.String]
        $OrganizationGuid,

        [Parameter()]
        [System.String]
        $OrganizationRelationship,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting On-premises Organization configuration for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $AllOnPremisesOrganizations = Get-OnPremisesOrganization

    $OnPremisesOrganization = $AllOnPremisesOrganizations | Where-Object -FilterScript { $_.Identity -eq $Identity }

    if ($null -eq $OnPremisesOrganization)
    {
        Write-Verbose -Message "On-premises Organization $($Identity) does not exist."

        $nullReturn = @{
            Identity                 = $Identity
            Comment                  = $Comment
            HybridDomains            = $HybridDomains
            InboundConnector         = $InboundConnector
            OrganizationName         = $OrganizationName
            OrganizationGuid         = $OrganizationGuid
            OrganizationRelationship = $OrganizationRelationship
            OutboundConnector        = $OutboundConnector
            Ensure                   = 'Absent'
            GlobalAdminAccount       = $GlobalAdminAccount
        }

        return $nullReturn
    }
    else
    {
        $result = @{
            Identity                 = $OnPremisesOrganization.Identity
            Comment                  = $OnPremisesOrganization.Comment
            HybridDomains            = $OnPremisesOrganization.HybridDomains
            InboundConnector         = $OnPremisesOrganization.InboundConnector
            OrganizationName         = $OnPremisesOrganization.OrganizationName
            OrganizationGuid         = $OnPremisesOrganization.OrganizationGuid
            OrganizationRelationship = $OnPremisesOrganization.OrganizationRelationship
            OutboundConnector        = $OnPremisesOrganization.OutboundConnector
            Ensure                   = 'Present'
            GlobalAdminAccount       = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found On-premises Organization $($Identity)"
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
        [System.String[]]
        $HybridDomains,

        [Parameter()]
        [System.String]
        $InboundConnector,

        [Parameter()]
        [System.String]
        $OutboundConnector,

        [Parameter()]
        [System.String]
        $OrganizationName,

        [Parameter()]
        [System.String]
        $OrganizationGuid,

        [Parameter()]
        [System.String]
        $OrganizationRelationship,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting On-premises Organization configuration for $Identity"

    $currentOnPremisesOrganizationConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $NewOnPremisesOrganizationParams = @{
        Name                     = $Identity
        Comment                  = $Comment
        HybridDomains            = $HybridDomains
        InboundConnector         = $InboundConnector
        OrganizationName         = $OrganizationName
        OrganizationGuid         = $OrganizationGuid
        OrganizationRelationship = $OrganizationRelationship
        OutboundConnector        = $OutboundConnector
        Confirm                  = $false
    }

    $SetOnPremisesOrganizationParams = @{
        Identity                 = $Identity
        Comment                  = $Comment
        HybridDomains            = $HybridDomains
        InboundConnector         = $InboundConnector
        OrganizationName         = $OrganizationName
        OrganizationRelationship = $OrganizationRelationship
        OutboundConnector        = $OutboundConnector
        Confirm                  = $false
    }

    # CASE: On-premises Organization doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentOnPremisesOrganizationConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "On-premises Organization '$($Identity)' does not exist but it should. Create and configure it."
        # Create On-premises Organization
        New-OnPremisesOrganization @NewOnPremisesOrganizationParams

    }
    # CASE: On-premises Organization exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentOnPremisesOrganizationConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "On-premises Organization '$($Identity)' exists but it shouldn't. Remove it."
        Remove-OnPremisesOrganization -Identity $Identity -Confirm:$false
    }
    # CASE: On-premises Organization exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentOnPremisesOrganizationConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "On-premises Organization '$($Identity)' already exists, but needs updating."
        Write-Verbose -Message "Setting On-premises Organization $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $SetOnPremisesOrganizationParams)"
        Set-OnPremisesOrganization @SetOnPremisesOrganizationParams
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
        [System.String[]]
        $HybridDomains,

        [Parameter()]
        [System.String]
        $InboundConnector,

        [Parameter()]
        [System.String]
        $OutboundConnector,

        [Parameter()]
        [System.String]
        $OrganizationName,

        [Parameter()]
        [System.String]
        $OrganizationGuid,

        [Parameter()]
        [System.String]
        $OrganizationRelationship,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing On-premises Organization configuration for $Identity"

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

    [array]$AllOnPremisesOrganizations = Get-OnPremisesOrganization

    $dscContent = ""
    $i = 1
    foreach ($OnPremisesOrganization in $AllOnPremisesOrganizations)
    {
        Write-Information "    [$i/$($AllOnPremisesOrganizations.Count)] $($OnPremisesOrganization.Identity)"

        $Params = @{
            Identity           = $OnPremisesOrganization.Identity
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        EXOOnPremisesOrganization " + (New-GUID).ToString() + "`r`n"
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

