Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADOrganizationCertificateBasedAuthConfiguration'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CertificateAuthorities,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OrganizationId,
        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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

        $getValue = $null
        #region resource generator code

        # This GUID is ALWAYS fixed as per the documentation.
        $CertificateBasedAuthConfigurationId = '29728ade-6ae4-4ee9-9103-412912537da5'
        $getValue = Get-MgBetaOrganizationCertificateBasedAuthConfiguration `
            -CertificateBasedAuthConfigurationId $CertificateBasedAuthConfigurationId `
            -OrganizationId $OrganizationId -ErrorAction SilentlyContinue

        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Azure AD Organization Certificate Based Auth Configuration with Id {$Id}."
            return $nullResult
        }

        $Id = $getValue.Id
        Write-Verbose -Message "An Azure AD Organization Certificate Based Auth Configuration with Id {$Id} was found"

        #region resource generator code
        $complexCertificateAuthorities = @()
        foreach ($currentCertificateAuthorities in $getValue.certificateAuthorities)
        {
            $myCertificateAuthorities = [ordered]@{}
            $myCertificateAuthorities.Add('Certificate', [System.Convert]::ToBase64String($currentCertificateAuthorities.certificate))
            $myCertificateAuthorities.Add('CertificateRevocationListUrl', $currentCertificateAuthorities.certificateRevocationListUrl)
            $myCertificateAuthorities.Add('DeltaCertificateRevocationListUrl', $currentCertificateAuthorities.deltaCertificateRevocationListUrl)
            $myCertificateAuthorities.Add('IsRootAuthority', $currentCertificateAuthorities.isRootAuthority)
            if ($myCertificateAuthorities.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexCertificateAuthorities += $myCertificateAuthorities
            }
        }
        #endregion

        $results = @{
            #region resource generator code
            CertificateAuthorities = $complexCertificateAuthorities
            OrganizationId         = $OrganizationId
            Ensure                 = 'Present'
            Credential             = $Credential
            ApplicationId          = $ApplicationId
            TenantId               = $TenantId
            ApplicationSecret      = $ApplicationSecret
            CertificateThumbprint  = $CertificateThumbprint
            ManagedIdentity        = $ManagedIdentity.IsPresent
            #endregion
        }

        return $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CertificateAuthorities,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OrganizationId,
        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    # This GUID is ALWAYS fixed as per the documentation.
    $CertificateBasedAuthConfigurationId = '29728ade-6ae4-4ee9-9103-412912537da5'

    # Delete the old configuration
    Write-Verbose -Message 'Removing the current Azure AD Organization Certificate Based Auth Configuration.'
    Invoke-MgGraphRequest -Uri "/beta/organization/$OrganizationId/certificateBasedAuthConfiguration/$CertificateBasedAuthConfigurationId" -Method DELETE

    if ($Ensure -eq 'Present')
    {
        Write-Verbose -Message "Creating an Azure AD Organization Certificate Based Auth Configuration with Id {$CertificateBasedAuthConfigurationId}"

        $createParameters = ([Hashtable]$BoundParameters).Clone()
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('OrganizationId') | Out-Null

        $createCertAuthorities = @()
        foreach ($CertificateAuthority in $CertificateAuthorities)
        {
            $createCertAuthorities += @{
                certificate                       = $CertificateAuthority.Certificate
                certificateRevocationListUrl      = $CertificateAuthority.CertificateRevocationListUrl
                deltaCertificateRevocationListUrl = $CertificateAuthority.DeltaCertificateRevocationListUrl
                isRootAuthority                   = $CertificateAuthority.IsRootAuthority
            }
        }
        $params = @{
            certificateAuthorities = $createCertAuthorities
        }

        $uri = "/beta/organization/$OrganizationId/certificateBasedAuthConfiguration/"

        Write-Verbose -Message "Creating with Parameters:`r`n$(ConvertTo-Json $params -Depth 10)"
        Invoke-MgGraphRequest -Uri $uri `
                              -Method 'POST' `
                              -Body $params
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CertificateAuthorities,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OrganizationId,
        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        [System.String]
        $Filter,

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
        # This GUID is ALWAYS fixed as per the documentation.
        $CertificateBasedAuthConfigurationId = '29728ade-6ae4-4ee9-9103-412912537da5'
        $getValue = Get-MgBetaOrganization

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }
            $displayedKey = "CertificateBasedAuthConfigurations for $($getValue.DisplayName)"
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Ensure                = 'Present'
                OrganizationId        = $getValue.Id
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params
            if ($null -ne $Results.CertificateAuthorities)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.CertificateAuthorities `
                    -CIMInstanceName 'MicrosoftGraphcertificateAuthority'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.CertificateAuthorities = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('CertificateAuthorities') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('CertificateAuthorities')

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
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
