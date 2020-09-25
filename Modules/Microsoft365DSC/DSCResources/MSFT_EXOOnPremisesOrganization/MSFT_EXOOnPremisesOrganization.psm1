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

    Write-Verbose -Message "Getting On-premises Organization configuration for $Identity"
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

    try
    {
        $AllOnPremisesOrganizations = Get-OnPremisesOrganization -ErrorAction Stop

        $OnPremisesOrganization = $AllOnPremisesOrganizations | Where-Object -FilterScript { $_.Identity -eq $Identity }

        if ($null -eq $OnPremisesOrganization)
        {
            Write-Verbose -Message "On-premises Organization $($Identity) does not exist."
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

    Write-Verbose -Message "Setting On-premises Organization configuration for $Identity"

    $currentOnPremisesOrganizationConfig = Get-TargetResource @PSBoundParameters

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

    Write-Verbose -Message "Testing On-premises Organization configuration for $Identity"

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
        [array]$AllOnPremisesOrganizations = Get-OnPremisesOrganization -ErrorAction Stop

        $dscContent = ""

        if ($AllOnPremisesOrganizations.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        $i = 1
        foreach ($OnPremisesOrganization in $AllOnPremisesOrganizations)
        {
            Write-Host "    |---[$i/$($AllOnPremisesOrganizations.Count)] $($OnPremisesOrganization.Identity)" -NoNewLine

            $Params = @{
                Identity              = $OnPremisesOrganization.Identity
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

