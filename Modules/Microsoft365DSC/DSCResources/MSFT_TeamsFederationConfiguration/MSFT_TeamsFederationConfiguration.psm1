Confirm-M365DSCModuleDependency -ModuleName 'MSFT_TeamsFederationConfiguration'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Global')]
        $Identity,

        [Parameter()]
        [System.String[]]
        $AllowedDomains,

        [Parameter()]
        [System.String[]]
        $BlockedDomains,

        [Parameter()]
        [System.Boolean]
        $AllowFederatedUsers,

        [Parameter()]
        [System.Boolean]
        $AllowTeamsConsumer,

        [Parameter()]
        [System.Boolean]
        $AllowTeamsConsumerInbound,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $DomainBlockingForMDOAdminsInTeams,

        [Parameter()]
        [System.String]
        [ValidateSet('Allowed', 'Blocked')]
        $ExternalAccessWithTrialTenants,

        [Parameter()]
        [System.Boolean]
        $TreatDiscoveredPartnersAsUnverified,

        [Parameter()]
        [System.Boolean]
        $SharedSipAddressSpace,

        [Parameter()]
        [System.Boolean]
        $RestrictTeamsConsumerToExternalUserProfiles,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message 'Getting configuration of Teams Federation'

    try
    {
        if (-not $Script:exportMode)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftTeams' `
                -InboundParameters $PSBoundParameters

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

            $nullReturn = @{
                Identity = 'Global'
            }
        }

        $config = Get-CsTenantFederationConfiguration -ErrorAction Stop

        $AllowedDomainsArray = $config.AllowedDomains.AllowedDomain.Domain
        $AllowedDomainsValues = @()

        if ($AllowedDomainsArray.Length -gt 0)
        {
            foreach ($domain in $AllowedDomainsArray)
            {
                $AllowedDomainsValues += $domain
            }
        }

        $BlockedDomainsArray = $config.BlockedDomains.Domain
        $BlockedDomainsValues = @()

        if ($BlockedDomainsArray.Length -gt 0)
        {
            foreach ($domain in $BlockedDomainsArray)
            {
                $BlockedDomainsValues += $domain
            }
        }

        return @{
            Identity                                    = $Identity
            AllowedDomains                              = $AllowedDomainsValues
            BlockedDomains                              = $BlockedDomainsValues
            AllowFederatedUsers                         = $config.AllowFederatedUsers
            AllowTeamsConsumer                          = $config.AllowTeamsConsumer
            AllowTeamsConsumerInbound                   = $config.AllowTeamsConsumerInbound
            DomainBlockingForMDOAdminsInTeams           = $config.DomainBlockingForMDOAdminsInTeams
            ExternalAccessWithTrialTenants              = $config.ExternalAccessWithTrialTenants
            TreatDiscoveredPartnersAsUnverified         = $config.TreatDiscoveredPartnersAsUnverified
            SharedSipAddressSpace                       = $config.SharedSipAddressSpace
            RestrictTeamsConsumerToExternalUserProfiles = $config.RestrictTeamsConsumerToExternalUserProfiles
            Credential                                  = $Credential
            ApplicationId                               = $ApplicationId
            TenantId                                    = $TenantId
            CertificateThumbprint                       = $CertificateThumbprint
            ManagedIdentity                             = $ManagedIdentity.IsPresent
            AccessTokens                                = $AccessTokens
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
        [ValidateSet('Global')]
        $Identity,

        [Parameter()]
        [System.String[]]
        $AllowedDomains,

        [Parameter()]
        [System.String[]]
        $BlockedDomains,

        [Parameter()]
        [System.Boolean]
        $AllowFederatedUsers,

        [Parameter()]
        [System.Boolean]
        $AllowTeamsConsumer,

        [Parameter()]
        [System.Boolean]
        $AllowTeamsConsumerInbound,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $DomainBlockingForMDOAdminsInTeams,

        [Parameter()]
        [System.String]
        [ValidateSet('Allowed', 'Blocked')]
        $ExternalAccessWithTrialTenants,

        [Parameter()]
        [System.Boolean]
        $TreatDiscoveredPartnersAsUnverified,

        [Parameter()]
        [System.Boolean]
        $SharedSipAddressSpace,

        [Parameter()]
        [System.Boolean]
        $RestrictTeamsConsumerToExternalUserProfiles,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message 'Setting configuration of Teams Federation'

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

    $null = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    $SetParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    if ($allowedDomains.Length -gt 0)
    {
        $SetParams.Add('AllowedDomainsAsAList', $AllowedDomains)
    }
    else
    {
        $AllowAllKnownDomains = New-CsEdgeAllowAllKnownDomains
        $SetParams.Add('AllowedDomains', $AllowAllKnownDomains)
    }

    Write-Verbose -Message "SetParams: $(Convert-M365DscHashtableToString -Hashtable $SetParams)"
    Set-CsTenantFederationConfiguration @SetParams
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Global')]
        $Identity,

        [Parameter()]
        [System.String[]]
        $AllowedDomains,

        [Parameter()]
        [System.String[]]
        $BlockedDomains,

        [Parameter()]
        [System.Boolean]
        $AllowFederatedUsers,

        [Parameter()]
        [System.Boolean]
        $AllowTeamsConsumer,

        [Parameter()]
        [System.Boolean]
        $AllowTeamsConsumerInbound,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $DomainBlockingForMDOAdminsInTeams,

        [Parameter()]
        [System.String]
        [ValidateSet('Allowed', 'Blocked')]
        $ExternalAccessWithTrialTenants,

        [Parameter()]
        [System.Boolean]
        $TreatDiscoveredPartnersAsUnverified,

        [Parameter()]
        [System.Boolean]
        $SharedSipAddressSpace,

        [Parameter()]
        [System.Boolean]
        $RestrictTeamsConsumerToExternalUserProfiles,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
                                         -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

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
        $dscContent = ''
        $params = @{
            Identity              = 'Global'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
        $Script:exportMode = $true
        $Results = Get-TargetResource @Params
        if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName

            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite
        }

        return $dscContent
    }
    catch
    {
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
