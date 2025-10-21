Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADFederationConfiguration'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $IssuerUri,

        [Parameter()]
        [System.String]
        $MetadataExchangeUri,

        [Parameter()]
        [System.String]
        $SigningCertificate,

        [Parameter()]
        [System.String]
        $PassiveSignInUri,

        [Parameter()]
        [System.String]
        $PreferredAuthenticationProtocol,

        [Parameter()]
        [System.String[]]
        $Domains,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Id -ne $Id)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $uri = '/beta/directory/federationConfigurations/microsoft.graph.samlOrWsFedExternalDomainFederation'
            $instances = Invoke-MgGraphRequest $uri -Method Get
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $instance = $instances.value | Where-Object -FilterScript { $_.id -eq $Id }
            }
            if ($null -eq $instance)
            {
                $instance = $instances.value | Where-Object -FilterScript { $_.displayName -eq $DisplayName }
            }
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        if ($null -eq $instance)
        {
            return $nullResult
        }

        $results = @{
            Id                              = $instance.id
            DisplayName                     = $instance.displayName
            IssuerUri                       = $instance.issuerUri
            MetadataExchangeUri             = $instance.metadataExchangeUri
            PassiveSignInUri                = $instance.passiveSignInUri
            PreferredAuthenticationProtocol = $instance.preferredAuthenticationProtocol
            Domains                         = $instance.domains.id
            SigningCertificate              = $instance.signingCertificate
            Ensure                          = 'Present'
            Credential                      = $Credential
            ApplicationId                   = $ApplicationId
            TenantId                        = $TenantId
            ApplicationSecret               = $ApplicationSecret
            CertificateThumbprint           = $CertificateThumbprint
            ManagedIdentity                 = $ManagedIdentity.IsPresent
            AccessTokens                    = $AccessTokens
        }

        return $results
    }
    catch
    {
        Write-Verbose -Message $_
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $IssuerUri,

        [Parameter()]
        [System.String]
        $MetadataExchangeUri,

        [Parameter()]
        [System.String]
        $SigningCertificate,

        [Parameter()]
        [System.String]
        $PassiveSignInUri,

        [Parameter()]
        [System.String]
        $PreferredAuthenticationProtocol,

        [Parameter()]
        [System.String[]]
        $Domains,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    $instanceParams = @{
        '@odata.type'                   = 'microsoft.graph.samlOrWsFedExternalDomainFederation'
        displayName                     = $DisplayName
        metadataExchangeUri             = $MetadataExchangeUri
        issuerUri                       = $IssuerUri
        preferredAuthenticationProtocol = $PreferredAuthenticationProtocol
        passiveSignInUri                = $PassiveSignInUri
        signingCertificate              = $SigningCertificate
        domains                         = @()
    }
    foreach ($domain in $domains)
    {
        $instanceParams.domains += @{
            '@odata.type' = 'microsoft.graph.externalDomainName'
            id            = $domain
        }
    }

    if ([System.String]::IsNullOrEmpty($MetadataExchangeUri))
    {
        $instanceParams.Remove('metadataExchangeUri') | Out-Null
    }

    if ([System.String]::IsNullOrEmpty($SigningCertificate))
    {
        $instanceParams.Remove('signingCertificate') | Out-Null
    }

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $uri = "/beta/directory/federationConfigurations/microsoft.graph.samlOrWsFedExternalDomainFederation"
        $body = ConvertTo-Json $instanceParams -Depth 10 -Compress
        Write-Verbose -Message "Creating federation configuration {$DisplayName} with:`r`n$body"
        Invoke-MgGraphRequest -Uri $uri -Method POST -Body $body
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        $uri = "/beta/directory/federationConfigurations/microsoft.graph.samlOrWsFedExternalDomainFederation/$($currentInstance.Id)"
        $body = ConvertTo-Json $instanceParams -Depth 10 -Compress
        Write-Verbose -Message "Updating federation configuration {$DisplayName} with:`r`n$body"
        Invoke-MgGraphRequest -Uri $uri -Method PATCH -Body $body
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        $uri = "/beta/directory/federationConfigurations/microsoft.graph.samlOrWsFedExternalDomainFederation/$($currentInstance.Id)"
        Write-Verbose -Message "Removing federation configuration {$DisplayName}"
        Invoke-MgGraphRequest -Uri $uri -Method DELETE
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $IssuerUri,

        [Parameter()]
        [System.String]
        $MetadataExchangeUri,

        [Parameter()]
        [System.String]
        $SigningCertificate,

        [Parameter()]
        [System.String]
        $PassiveSignInUri,

        [Parameter()]
        [System.String]
        $PreferredAuthenticationProtocol,

        [Parameter()]
        [System.String[]]
        $Domains,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + 'beta/directory/federationConfigurations/microsoft.graph.samlOrWsFedExternalDomainFederation'
        [array] $Script:exportedInstances = Invoke-MgGraphRequest $uri -Method Get

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $Script:exportedInstances.value)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.displayName
            Write-M365DSCHost -Message "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -DeferWrite
            $params = @{
                DisplayName           = $config.displayName
                Id                    = $config.Id
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
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
