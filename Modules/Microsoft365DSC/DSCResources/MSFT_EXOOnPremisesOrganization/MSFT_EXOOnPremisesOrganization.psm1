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
        $Credential,

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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting On-premises Organization configuration for $Identity"
    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

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
                Credential               = $Credential
                ApplicationId            = $ApplicationId
                CertificateThumbprint    = $CertificateThumbprint
                CertificatePath          = $CertificatePath
                CertificatePassword      = $CertificatePassword
                Managedidentity          = $ManagedIdentity.IsPresent
                TenantId                 = $TenantId
                AccessTokens             = $AccessTokens
            }

            Write-Verbose -Message "Found On-premises Organization $($Identity)"
            return $result
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

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
        $Credential,

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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting On-premises Organization configuration for $Identity"

    $currentOnPremisesOrganizationConfig = Get-TargetResource @PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $NewOnPremisesOrganizationParams = @{
        Name                     = $Identity
        Comment                  = $Comment
        HybridDomains            = $HybridDomains
        InboundConnector         = $InboundConnector
        OrganizationName         = $OrganizationName
        OrganizationGuid         = $OrganizationGuid
        OutboundConnector        = $OutboundConnector
        Confirm                  = $false
    }

    $SetOnPremisesOrganizationParams = @{
        Identity                 = $Identity
        Comment                  = $Comment
        HybridDomains            = $HybridDomains
        InboundConnector         = $InboundConnector
        OrganizationName         = $OrganizationName
        OutboundConnector        = $OutboundConnector
        Confirm                  = $false
    }

    if (-not [System.String]::IsNullOrEmpty($OrganizationRelationship))
    {
        $NewOnPremisesOrganizationParams.Add('OrganizationRelationship', $OrganizationRelationship)
        $SetOnPremisesOrganizationParams.Add('OrganizationRelationship', $OrganizationRelationship)
    }

    # CASE: On-premises Organization doesn't exist but should;
    if ($Ensure -eq 'Present' -and $currentOnPremisesOrganizationConfig.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "On-premises Organization '$($Identity)' does not exist but it should. Create and configure it."
        # Create On-premises Organization
        New-OnPremisesOrganization @NewOnPremisesOrganizationParams

    }
    # CASE: On-premises Organization exists but it shouldn't;
    elseif ($Ensure -eq 'Absent' -and $currentOnPremisesOrganizationConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "On-premises Organization '$($Identity)' exists but it shouldn't. Remove it."
        Remove-OnPremisesOrganization -Identity $Identity -Confirm:$false
    }
    # CASE: On-premises Organization exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq 'Present' -and $currentOnPremisesOrganizationConfig.Ensure -eq 'Present')
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
        $Credential,

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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing On-premises Organization configuration for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

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
        $Credential,

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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$AllOnPremisesOrganizations = Get-OnPremisesOrganization -ErrorAction Stop

        $dscContent = ''

        if ($AllOnPremisesOrganizations.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($OnPremisesOrganization in $AllOnPremisesOrganizations)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($AllOnPremisesOrganizations.Count)] $($OnPremisesOrganization.Identity)" -NoNewline

            $Params = @{
                Identity              = $OnPremisesOrganization.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource

