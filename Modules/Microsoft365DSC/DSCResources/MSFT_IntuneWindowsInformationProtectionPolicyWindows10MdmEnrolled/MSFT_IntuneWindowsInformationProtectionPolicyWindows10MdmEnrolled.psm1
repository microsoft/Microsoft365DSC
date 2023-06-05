function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $AzureRightsManagementServicesAllowed,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DataRecoveryCertificate,

        [Parameter()]
        [ValidateSet('noProtection', 'encryptAndAuditOnly', 'encryptAuditAndPrompt', 'encryptAuditAndBlock')]
        [System.String]
        $EnforcementLevel,

        [Parameter()]
        [System.String]
        $EnterpriseDomain,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseInternalProxyServers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseIPRanges,

        [Parameter()]
        [System.Boolean]
        $EnterpriseIPRangesAreAuthoritative,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseNetworkDomainNames,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseProtectedDomainNames,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseProxiedDomains,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseProxyServers,

        [Parameter()]
        [System.Boolean]
        $EnterpriseProxyServersAreAuthoritative,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExemptApps,

        [Parameter()]
        [System.Boolean]
        $IconsVisible,

        [Parameter()]
        [System.Boolean]
        $IndexingEncryptedStoresOrItemsBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NeutralDomainResources,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ProtectedApps,

        [Parameter()]
        [System.Boolean]
        $ProtectionUnderLockConfigRequired,

        [Parameter()]
        [System.Boolean]
        $RevokeOnUnenrollDisabled,

        [Parameter()]
        [System.Guid]
        $RightsManagementServicesTemplateId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $SmbAutoEncryptedFileExtensions,

        [Parameter()]
        [System.String]
        $Description,
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
        $ManagedIdentity
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters `
            -ProfileName 'beta'

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
        $getValue = Get-MgDeviceAppMgtMdmWindowInformationProtectionPolicy -MdmWindowsInformationProtectionPolicyId $Id -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Windows Information Protection Policy for Windows10 Mdm Enrolled with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgDeviceAppMgtMdmWindowInformationProtectionPolicy `
                    -Filter "DisplayName eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue
            }
        }
        #endregion

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Windows Information Protection Policy for Windows10 Mdm Enrolled with DisplayName {$DisplayName}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Windows Information Protection Policy for Windows10 Mdm Enrolled with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexDataRecoveryCertificate = @{}
        $complexDataRecoveryCertificate.Add('Certificate', $getValue.DataRecoveryCertificate.certificate)
        $complexDataRecoveryCertificate.Add('Description', $getValue.DataRecoveryCertificate.description)
        if ($null -ne $getValue.DataRecoveryCertificate.expirationDateTime)
        {
            $complexDataRecoveryCertificate.Add('ExpirationDateTime', ([DateTimeOffset]$getValue.DataRecoveryCertificate.expirationDateTime).ToString('o'))
        }
        $complexDataRecoveryCertificate.Add('SubjectName', $getValue.DataRecoveryCertificate.subjectName)
        if ($complexDataRecoveryCertificate.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexDataRecoveryCertificate = $null
        }

        $complexEnterpriseInternalProxyServers = @()
        foreach ($currentEnterpriseInternalProxyServers in $getValue.enterpriseInternalProxyServers)
        {
            $myEnterpriseInternalProxyServers = @{}
            $myEnterpriseInternalProxyServers.Add('DisplayName', $currentEnterpriseInternalProxyServers.displayName)
            $myEnterpriseInternalProxyServers.Add('Resources', $currentEnterpriseInternalProxyServers.resources)
            if ($myEnterpriseInternalProxyServers.values.Where({ $null -ne $_ }).count -gt 0)
            {
                $complexEnterpriseInternalProxyServers += $myEnterpriseInternalProxyServers
            }
        }

        $complexEnterpriseIPRanges = @()
        foreach ($currentEnterpriseIPRanges in $getValue.enterpriseIPRanges)
        {
            $myEnterpriseIPRanges = @{}
            $myEnterpriseIPRanges.Add('DisplayName', $currentEnterpriseIPRanges.displayName)
            $complexRanges = @()
            foreach ($currentRanges in $currentEnterpriseIPRanges.ranges)
            {
                $myRanges = @{}
                $myRanges.Add('CidrAddress', $currentRanges.AdditionalProperties.cidrAddress)
                $myRanges.Add('LowerAddress', $currentRanges.AdditionalProperties.lowerAddress)
                $myRanges.Add('UpperAddress', $currentRanges.AdditionalProperties.upperAddress)
                if ($null -ne $currentRanges.AdditionalProperties.'@odata.type')
                {
                    $myRanges.Add('odataType', $currentRanges.AdditionalProperties.'@odata.type'.toString())
                }
                if ($myRanges.values.Where({ $null -ne $_ }).count -gt 0)
                {
                    $complexRanges += $myRanges
                }
            }
            $myEnterpriseIPRanges.Add('Ranges', $complexRanges)
            if ($myEnterpriseIPRanges.values.Where({ $null -ne $_ }).count -gt 0)
            {
                $complexEnterpriseIPRanges += $myEnterpriseIPRanges
            }
        }

        $complexEnterpriseNetworkDomainNames = @()
        foreach ($currentEnterpriseNetworkDomainNames in $getValue.enterpriseNetworkDomainNames)
        {
            $myEnterpriseNetworkDomainNames = @{}
            $myEnterpriseNetworkDomainNames.Add('DisplayName', $currentEnterpriseNetworkDomainNames.displayName)
            $myEnterpriseNetworkDomainNames.Add('Resources', $currentEnterpriseNetworkDomainNames.resources)
            if ($myEnterpriseNetworkDomainNames.values.Where({ $null -ne $_ }).count -gt 0)
            {
                $complexEnterpriseNetworkDomainNames += $myEnterpriseNetworkDomainNames
            }
        }

        $complexEnterpriseProtectedDomainNames = @()
        foreach ($currentEnterpriseProtectedDomainNames in $getValue.enterpriseProtectedDomainNames)
        {
            $myEnterpriseProtectedDomainNames = @{}
            $myEnterpriseProtectedDomainNames.Add('DisplayName', $currentEnterpriseProtectedDomainNames.displayName)
            $myEnterpriseProtectedDomainNames.Add('Resources', $currentEnterpriseProtectedDomainNames.resources)
            if ($myEnterpriseProtectedDomainNames.values.Where({ $null -ne $_ }).count -gt 0)
            {
                $complexEnterpriseProtectedDomainNames += $myEnterpriseProtectedDomainNames
            }
        }

        $complexEnterpriseProxiedDomains = @()
        foreach ($currentEnterpriseProxiedDomains in $getValue.enterpriseProxiedDomains)
        {
            $myEnterpriseProxiedDomains = @{}
            $myEnterpriseProxiedDomains.Add('DisplayName', $currentEnterpriseProxiedDomains.displayName)
            $complexProxiedDomains = @()
            foreach ($currentProxiedDomains in $currentEnterpriseProxiedDomains.proxiedDomains)
            {
                $myProxiedDomains = @{}
                $myProxiedDomains.Add('IpAddressOrFQDN', $currentProxiedDomains.ipAddressOrFQDN)
                $myProxiedDomains.Add('Proxy', $currentProxiedDomains.proxy)
                if ($myProxiedDomains.values.Where({ $null -ne $_ }).count -gt 0)
                {
                    $complexProxiedDomains += $myProxiedDomains
                }
            }
            $myEnterpriseProxiedDomains.Add('ProxiedDomains', $complexProxiedDomains)
            if ($myEnterpriseProxiedDomains.values.Where({ $null -ne $_ }).count -gt 0)
            {
                $complexEnterpriseProxiedDomains += $myEnterpriseProxiedDomains
            }
        }

        $complexEnterpriseProxyServers = @()
        foreach ($currentEnterpriseProxyServers in $getValue.enterpriseProxyServers)
        {
            $myEnterpriseProxyServers = @{}
            $myEnterpriseProxyServers.Add('DisplayName', $currentEnterpriseProxyServers.displayName)
            $myEnterpriseProxyServers.Add('Resources', $currentEnterpriseProxyServers.resources)
            if ($myEnterpriseProxyServers.values.Where({ $null -ne $_ }).count -gt 0)
            {
                $complexEnterpriseProxyServers += $myEnterpriseProxyServers
            }
        }

        $complexExemptApps = @()
        foreach ($currentExemptApps in $getValue.exemptApps)
        {
            $myExemptApps = @{}
            $myExemptApps.Add('Denied', $currentExemptApps.denied)
            $myExemptApps.Add('Description', $currentExemptApps.description)
            $myExemptApps.Add('DisplayName', $currentExemptApps.displayName)
            $myExemptApps.Add('ProductName', $currentExemptApps.productName)
            $myExemptApps.Add('PublisherName', $currentExemptApps.publisherName)
            $myExemptApps.Add('BinaryName', $currentExemptApps.AdditionalProperties.binaryName)
            $myExemptApps.Add('BinaryVersionHigh', $currentExemptApps.AdditionalProperties.binaryVersionHigh)
            $myExemptApps.Add('BinaryVersionLow', $currentExemptApps.AdditionalProperties.binaryVersionLow)
            if ($null -ne $currentExemptApps.AdditionalProperties.'@odata.type')
            {
                $myExemptApps.Add('odataType', $currentExemptApps.AdditionalProperties.'@odata.type'.toString())
            }
            if ($myExemptApps.values.Where({ $null -ne $_ }).count -gt 0)
            {
                $complexExemptApps += $myExemptApps
            }
        }

        $complexNeutralDomainResources = @()
        foreach ($currentNeutralDomainResources in $getValue.neutralDomainResources)
        {
            $myNeutralDomainResources = @{}
            $myNeutralDomainResources.Add('DisplayName', $currentNeutralDomainResources.displayName)
            $myNeutralDomainResources.Add('Resources', $currentNeutralDomainResources.resources)
            if ($myNeutralDomainResources.values.Where({ $null -ne $_ }).count -gt 0)
            {
                $complexNeutralDomainResources += $myNeutralDomainResources
            }
        }

        $complexProtectedApps = @()
        foreach ($currentProtectedApps in $getValue.protectedApps)
        {
            $myProtectedApps = @{}
            $myProtectedApps.Add('Denied', $currentProtectedApps.denied)
            $myProtectedApps.Add('Description', $currentProtectedApps.description)
            $myProtectedApps.Add('DisplayName', $currentProtectedApps.displayName)
            $myProtectedApps.Add('ProductName', $currentProtectedApps.productName)
            $myProtectedApps.Add('PublisherName', $currentProtectedApps.publisherName)
            $myProtectedApps.Add('BinaryName', $currentProtectedApps.AdditionalProperties.binaryName)
            $myProtectedApps.Add('BinaryVersionHigh', $currentProtectedApps.AdditionalProperties.binaryVersionHigh)
            $myProtectedApps.Add('BinaryVersionLow', $currentProtectedApps.AdditionalProperties.binaryVersionLow)
            if ($null -ne $currentProtectedApps.AdditionalProperties.'@odata.type')
            {
                $myProtectedApps.Add('odataType', $currentProtectedApps.AdditionalProperties.'@odata.type'.toString())
            }
            if ($myProtectedApps.values.Where({ $null -ne $_ }).count -gt 0)
            {
                $complexProtectedApps += $myProtectedApps
            }
        }

        $complexSmbAutoEncryptedFileExtensions = @()
        foreach ($currentSmbAutoEncryptedFileExtensions in $getValue.smbAutoEncryptedFileExtensions)
        {
            $mySmbAutoEncryptedFileExtensions = @{}
            $mySmbAutoEncryptedFileExtensions.Add('DisplayName', $currentSmbAutoEncryptedFileExtensions.displayName)
            $mySmbAutoEncryptedFileExtensions.Add('Resources', $currentSmbAutoEncryptedFileExtensions.resources)
            if ($mySmbAutoEncryptedFileExtensions.values.Where({ $null -ne $_ }).count -gt 0)
            {
                $complexSmbAutoEncryptedFileExtensions += $mySmbAutoEncryptedFileExtensions
            }
        }
        #endregion

        #region resource generator code
        $enumEnforcementLevel = $null
        if ($null -ne $getValue.EnforcementLevel)
        {
            $enumEnforcementLevel = $getValue.EnforcementLevel.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            AzureRightsManagementServicesAllowed   = $getValue.AzureRightsManagementServicesAllowed
            DataRecoveryCertificate                = $complexDataRecoveryCertificate
            EnforcementLevel                       = $enumEnforcementLevel
            EnterpriseDomain                       = $getValue.EnterpriseDomain
            EnterpriseInternalProxyServers         = $complexEnterpriseInternalProxyServers
            EnterpriseIPRanges                     = $complexEnterpriseIPRanges
            EnterpriseIPRangesAreAuthoritative     = $getValue.EnterpriseIPRangesAreAuthoritative
            EnterpriseNetworkDomainNames           = $complexEnterpriseNetworkDomainNames
            EnterpriseProtectedDomainNames         = $complexEnterpriseProtectedDomainNames
            EnterpriseProxiedDomains               = $complexEnterpriseProxiedDomains
            EnterpriseProxyServers                 = $complexEnterpriseProxyServers
            EnterpriseProxyServersAreAuthoritative = $getValue.EnterpriseProxyServersAreAuthoritative
            ExemptApps                             = $complexExemptApps
            IconsVisible                           = $getValue.IconsVisible
            IndexingEncryptedStoresOrItemsBlocked  = $getValue.IndexingEncryptedStoresOrItemsBlocked
            NeutralDomainResources                 = $complexNeutralDomainResources
            ProtectedApps                          = $complexProtectedApps
            ProtectionUnderLockConfigRequired      = $getValue.ProtectionUnderLockConfigRequired
            RevokeOnUnenrollDisabled               = $getValue.RevokeOnUnenrollDisabled
            RightsManagementServicesTemplateId     = $getValue.RightsManagementServicesTemplateId
            SmbAutoEncryptedFileExtensions         = $complexSmbAutoEncryptedFileExtensions
            Description                            = $getValue.Description
            DisplayName                            = $getValue.DisplayName
            Id                                     = $getValue.Id
            Ensure                                 = 'Present'
            Credential                             = $Credential
            ApplicationId                          = $ApplicationId
            TenantId                               = $TenantId
            ApplicationSecret                      = $ApplicationSecret
            CertificateThumbprint                  = $CertificateThumbprint
            Managedidentity                        = $ManagedIdentity.IsPresent
            #endregion
        }

        return [System.Collections.Hashtable] $results
    }
    catch
    {
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
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $AzureRightsManagementServicesAllowed,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DataRecoveryCertificate,

        [Parameter()]
        [ValidateSet('noProtection', 'encryptAndAuditOnly', 'encryptAuditAndPrompt', 'encryptAuditAndBlock')]
        [System.String]
        $EnforcementLevel,

        [Parameter()]
        [System.String]
        $EnterpriseDomain,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseInternalProxyServers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseIPRanges,

        [Parameter()]
        [System.Boolean]
        $EnterpriseIPRangesAreAuthoritative,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseNetworkDomainNames,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseProtectedDomainNames,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseProxiedDomains,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseProxyServers,

        [Parameter()]
        [System.Boolean]
        $EnterpriseProxyServersAreAuthoritative,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExemptApps,

        [Parameter()]
        [System.Boolean]
        $IconsVisible,

        [Parameter()]
        [System.Boolean]
        $IndexingEncryptedStoresOrItemsBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NeutralDomainResources,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ProtectedApps,

        [Parameter()]
        [System.Boolean]
        $ProtectionUnderLockConfigRequired,

        [Parameter()]
        [System.Boolean]
        $RevokeOnUnenrollDisabled,

        [Parameter()]
        [System.Guid]
        $RightsManagementServicesTemplateId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $SmbAutoEncryptedFileExtensions,

        [Parameter()]
        [System.String]
        $Description,
        #endregion

        [Parameter(Mandatory)]
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
        $ManagedIdentity
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

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('Verbose') | Out-Null

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Windows Information Protection Policy for Windows10 Mdm Enrolled with DisplayName {$DisplayName}"

        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$CreateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $CreateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
            }
        }

        #region resource generator code
        $policy = New-MgDeviceAppMgtMdmWindowInformationProtectionPolicy -BodyParameter $CreateParameters
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Windows Information Protection Policy for Windows10 Mdm Enrolled with Id {$($currentInstance.Id)}"

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$UpdateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
        }

        #region resource generator code
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.MdmWindowsInformationProtectionPolicy')
        Update-MgDeviceAppMgtMdmWindowInformationProtectionPolicy  `
            -MdmWindowsInformationProtectionPolicyId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Windows Information Protection Policy for Windows10 Mdm Enrolled with Id {$($currentInstance.Id)}"

        #region resource generator code
        Remove-MgDeviceAppMgtMdmWindowInformationProtectionPolicy -MdmWindowsInformationProtectionPolicyId $currentInstance.Id
        #endregion
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $AzureRightsManagementServicesAllowed,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DataRecoveryCertificate,

        [Parameter()]
        [ValidateSet('noProtection', 'encryptAndAuditOnly', 'encryptAuditAndPrompt', 'encryptAuditAndBlock')]
        [System.String]
        $EnforcementLevel,

        [Parameter()]
        [System.String]
        $EnterpriseDomain,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseInternalProxyServers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseIPRanges,

        [Parameter()]
        [System.Boolean]
        $EnterpriseIPRangesAreAuthoritative,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseNetworkDomainNames,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseProtectedDomainNames,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseProxiedDomains,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EnterpriseProxyServers,

        [Parameter()]
        [System.Boolean]
        $EnterpriseProxyServersAreAuthoritative,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExemptApps,

        [Parameter()]
        [System.Boolean]
        $IconsVisible,

        [Parameter()]
        [System.Boolean]
        $IndexingEncryptedStoresOrItemsBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NeutralDomainResources,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ProtectedApps,

        [Parameter()]
        [System.Boolean]
        $ProtectionUnderLockConfigRequired,

        [Parameter()]
        [System.Boolean]
        $RevokeOnUnenrollDisabled,

        [Parameter()]
        [System.Guid]
        $RightsManagementServicesTemplateId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $SmbAutoEncryptedFileExtensions,

        [Parameter()]
        [System.String]
        $Description,
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
        $ManagedIdentity
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

    Write-Verbose -Message "Testing configuration of the Intune Windows Information Protection Policy for Windows10 Mdm Enrolled with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($source.getType().Name -like '*CimInstance*')
        {
            $source = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $source

            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null

        }
    }

    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('Id') | Out-Null

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
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
        $ManagedIdentity
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

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
        #region resource generator code
        [array]$getValue = Get-MgDeviceAppMgtMdmWindowInformationProtectionPolicy `
            -All `
            -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $getValue)
        {
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            if ( $null -ne $Results.DataRecoveryCertificate)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.DataRecoveryCertificate `
                    -CIMInstanceName 'MicrosoftGraphwindowsInformationProtectionDataRecoveryCertificate'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.DataRecoveryCertificate = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('DataRecoveryCertificate') | Out-Null
                }
            }
            if ( $null -ne $Results.EnterpriseInternalProxyServers)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.EnterpriseInternalProxyServers `
                    -CIMInstanceName 'MicrosoftGraphwindowsInformationProtectionResourceCollection'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.EnterpriseInternalProxyServers = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('EnterpriseInternalProxyServers') | Out-Null
                }
            }
            if ( $null -ne $Results.EnterpriseIPRanges)
            {
                $complexMapping = @(
                    @{
                        Name            = 'EnterpriseIPRanges'
                        CimInstanceName = 'MicrosoftGraphWindowsInformationProtectionIPRangeCollection'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'Ranges'
                        CimInstanceName = 'MicrosoftGraphIpRange'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.EnterpriseIPRanges `
                    -CIMInstanceName 'MicrosoftGraphwindowsInformationProtectionIPRangeCollection' `
                    -ComplexTypeMapping $complexMapping

                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.EnterpriseIPRanges = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('EnterpriseIPRanges') | Out-Null
                }
            }
            if ( $null -ne $Results.EnterpriseNetworkDomainNames)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.EnterpriseNetworkDomainNames `
                    -CIMInstanceName 'MicrosoftGraphwindowsInformationProtectionResourceCollection'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.EnterpriseNetworkDomainNames = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('EnterpriseNetworkDomainNames') | Out-Null
                }
            }
            if ( $null -ne $Results.EnterpriseProtectedDomainNames)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.EnterpriseProtectedDomainNames `
                    -CIMInstanceName 'MicrosoftGraphwindowsInformationProtectionResourceCollection'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.EnterpriseProtectedDomainNames = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('EnterpriseProtectedDomainNames') | Out-Null
                }
            }
            if ( $null -ne $Results.EnterpriseProxiedDomains)
            {
                $complexMapping = @(
                    @{
                        Name            = 'EnterpriseProxiedDomains'
                        CimInstanceName = 'MicrosoftGraphWindowsInformationProtectionProxiedDomainCollection'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'ProxiedDomains'
                        CimInstanceName = 'MicrosoftGraphProxiedDomain'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.EnterpriseProxiedDomains `
                    -CIMInstanceName 'MicrosoftGraphwindowsInformationProtectionProxiedDomainCollection' `
                    -ComplexTypeMapping $complexMapping

                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.EnterpriseProxiedDomains = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('EnterpriseProxiedDomains') | Out-Null
                }
            }
            if ( $null -ne $Results.EnterpriseProxyServers)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.EnterpriseProxyServers `
                    -CIMInstanceName 'MicrosoftGraphwindowsInformationProtectionResourceCollection'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.EnterpriseProxyServers = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('EnterpriseProxyServers') | Out-Null
                }
            }
            if ( $null -ne $Results.ExemptApps)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ExemptApps `
                    -CIMInstanceName 'MicrosoftGraphwindowsInformationProtectionApp'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ExemptApps = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ExemptApps') | Out-Null
                }
            }
            if ( $null -ne $Results.NeutralDomainResources)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.NeutralDomainResources `
                    -CIMInstanceName 'MicrosoftGraphwindowsInformationProtectionResourceCollection'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.NeutralDomainResources = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('NeutralDomainResources') | Out-Null
                }
            }
            if ( $null -ne $Results.ProtectedApps)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ProtectedApps `
                    -CIMInstanceName 'MicrosoftGraphwindowsInformationProtectionApp'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ProtectedApps = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ProtectedApps') | Out-Null
                }
            }
            if ( $null -ne $Results.SmbAutoEncryptedFileExtensions)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.SmbAutoEncryptedFileExtensions `
                    -CIMInstanceName 'MicrosoftGraphwindowsInformationProtectionResourceCollection'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.SmbAutoEncryptedFileExtensions = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('SmbAutoEncryptedFileExtensions') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            if ($Results.DataRecoveryCertificate)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'DataRecoveryCertificate' -IsCIMArray:$False
            }
            if ($Results.EnterpriseInternalProxyServers)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'EnterpriseInternalProxyServers' -IsCIMArray:$True
            }
            if ($Results.EnterpriseIPRanges)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'EnterpriseIPRanges' -IsCIMArray:$True
            }
            if ($Results.EnterpriseNetworkDomainNames)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'EnterpriseNetworkDomainNames' -IsCIMArray:$True
            }
            if ($Results.EnterpriseProtectedDomainNames)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'EnterpriseProtectedDomainNames' -IsCIMArray:$True
            }
            if ($Results.EnterpriseProxiedDomains)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'EnterpriseProxiedDomains' -IsCIMArray:$True
            }
            if ($Results.EnterpriseProxyServers)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'EnterpriseProxyServers' -IsCIMArray:$True
            }
            if ($Results.ExemptApps)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'ExemptApps' -IsCIMArray:$True
            }
            if ($Results.NeutralDomainResources)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'NeutralDomainResources' -IsCIMArray:$True
            }
            if ($Results.ProtectedApps)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'ProtectedApps' -IsCIMArray:$True
            }
            if ($Results.SmbAutoEncryptedFileExtensions)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'SmbAutoEncryptedFileExtensions' -IsCIMArray:$True
            }
            #removing trailing commas and semi colons between items of an array of cim instances added by Convert-DSCStringParamToVariable
            $currentDSCBlock = $currentDSCBlock.replace( "    ,`r`n" , "    `r`n" )
            $currentDSCBlock = $currentDSCBlock.replace( "`r`n;`r`n" , "`r`n" )
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*")
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX

            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }

        return ''
    }
}

function Rename-M365DSCCimInstanceParameter
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable], [System.Collections.Hashtable[]])]
    param
    (
        [Parameter(Mandatory = 'true')]
        $Properties
    )

    $keyToRename = @{
        'odataType' = '@odata.type'
    }

    $result = $Properties

    $type = $Properties.getType().FullName

    #region Array
    if ($type -like '*[[\]]')
    {
        $values = @()
        foreach ($item in $Properties)
        {
            $values += Rename-M365DSCCimInstanceParameter $item
        }
        $result = $values

        return , $result
    }
    #endregion

    #region Single
    if ($type -like '*Hashtable')
    {
        $result = ([Hashtable]$Properties).clone()
    }
    if ($type -like '*CimInstance*' -or $type -like '*Hashtable*' -or $type -like '*Object*')
    {
        $hashProperties = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $result
        $keys = ($hashProperties.clone()).keys
        foreach ($key in $keys)
        {
            $keyName = $key.substring(0, 1).tolower() + $key.substring(1, $key.length - 1)
            if ($key -in $keyToRename.Keys)
            {
                $keyName = $keyToRename.$key
            }

            $property = $hashProperties.$key
            if ($null -ne $property)
            {
                $hashProperties.Remove($key)
                $hashProperties.add($keyName, (Rename-M365DSCCimInstanceParameter $property))
            }
        }
        $result = $hashProperties
    }

    return $result
    #endregion
}

function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable], [hashtable[]])]
    param
    (
        [Parameter()]
        $ComplexObject
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    if ($ComplexObject.gettype().fullname -like '*[[\]]')
    {
        $results = @()

        foreach ($item in $ComplexObject)
        {
            if ($item)
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                $results += $hash
            }
        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , [hashtable[]]$results
    }

    if ($ComplexObject.getType().fullname -like '*Dictionary*')
    {
        $results = @{}

        $ComplexObject = [hashtable]::new($ComplexObject)
        $keys = $ComplexObject.Keys
        foreach ($key in $keys)
        {
            if ($null -ne $ComplexObject.$key)
            {
                $keyName = $key

                $keyType = $ComplexObject.$key.gettype().fullname

                if ($keyType -like '*CimInstance*' -or $keyType -like '*Dictionary*' -or $keyType -like 'Microsoft.Graph.PowerShell.Models.*' -or $keyType -like '*[[\]]')
                {
                    $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$key

                    $results.Add($keyName, $hash)
                }
                else
                {
                    $results.Add($keyName, $ComplexObject.$key)
                }
            }
        }
        return [hashtable]$results
    }

    $results = @{}

    if ($ComplexObject.getType().Fullname -like '*hashtable')
    {
        $keys = $ComplexObject.keys
    }
    else
    {
        $keys = $ComplexObject | Get-Member | Where-Object -FilterScript { $_.MemberType -eq 'Property' }
    }

    foreach ($key in $keys)
    {
        $keyName = $key
        if ($ComplexObject.getType().Fullname -notlike '*hashtable')
        {
            $keyName = $key.Name
        }

        if ($null -ne $ComplexObject.$keyName)
        {
            $keyType = $ComplexObject.$keyName.gettype().fullname
            if ($keyType -like '*CimInstance*' -or $keyType -like '*Dictionary*' -or $keyType -like 'Microsoft.Graph.PowerShell.Models.*' )
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$keyName

                $results.Add($keyName, $hash)
            }
            else
            {
                $results.Add($keyName, $ComplexObject.$keyName)
            }
        }
    }

    return [hashtable]$results
}

<#
    Use ComplexTypeMapping to overwrite the type of nested CIM
    Example
    $complexMapping=@(
                    @{
                        Name="ApprovalStages"
                        CimInstanceName="MSFT_MicrosoftGraphapprovalstage1"
                        IsRequired=$false
                    }
                    @{
                        Name="PrimaryApprovers"
                        CimInstanceName="MicrosoftGraphuserset"
                        IsRequired=$false
                    }
                    @{
                        Name="EscalationApprovers"
                        CimInstanceName="MicrosoftGraphuserset"
                        IsRequired=$false
                    }
                )
    With
    Name: the name of the parameter to be overwritten
    CimInstanceName: The type of the CIM instance (can include or not the prefix MSFT_)
    IsRequired: If isRequired equals true, an empty hashtable or array will be returned. Some of the Graph parameters are required even though they are empty
#>
function Get-M365DSCDRGComplexTypeToString
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        $ComplexObject,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CIMInstanceName,

        [Parameter()]
        [Array]
        $ComplexTypeMapping,

        [Parameter()]
        [System.String]
        $Whitespace = '',

        [Parameter()]
        [System.uint32]
        $IndentLevel = 3,

        [Parameter()]
        [switch]
        $isArray = $false
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    $indent = ''
    for ($i = 0; $i -lt $IndentLevel ; $i++)
    {
        $indent += '    '
    }
    #If ComplexObject  is an Array
    if ($ComplexObject.GetType().FullName -like '*[[\]]')
    {
        $currentProperty = @()
        $IndentLevel++
        foreach ($item in $ComplexObject)
        {
            $splat = @{
                'ComplexObject'   = $item
                'CIMInstanceName' = $CIMInstanceName
                'IndentLevel'     = $IndentLevel
            }
            if ($ComplexTypeMapping)
            {
                $splat.add('ComplexTypeMapping', $ComplexTypeMapping)
            }

            $currentProperty += Get-M365DSCDRGComplexTypeToString -isArray:$true @splat
        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , $currentProperty
    }

    $currentProperty = ''
    if ($isArray)
    {
        $currentProperty += "`r`n"
        $currentProperty += $indent
    }

    $CIMInstanceName = $CIMInstanceName.replace('MSFT_', '')
    $currentProperty += "MSFT_$CIMInstanceName{`r`n"
    $IndentLevel++
    $indent = ''
    for ($i = 0; $i -lt $IndentLevel ; $i++)
    {
        $indent += '    '
    }
    $keyNotNull = 0

    if ($ComplexObject.Keys.count -eq 0)
    {
        return $null
    }

    foreach ($key in $ComplexObject.Keys)
    {
        if ($null -ne $ComplexObject.$key)
        {
            $keyNotNull++
            if ($ComplexObject.$key.GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*' -or $key -in $ComplexTypeMapping.Name)
            {
                $hashPropertyType = $ComplexObject[$key].GetType().Name.tolower()

                $isArray = $false
                if ($ComplexObject[$key].GetType().FullName -like '*[[\]]')
                {
                    $isArray = $true
                }
                #overwrite type if object defined in mapping complextypemapping
                if ($key -in $ComplexTypeMapping.Name)
                {
                    $hashPropertyType = ([Array]($ComplexTypeMapping | Where-Object -FilterScript { $_.Name -eq $key }).CimInstanceName)[0]
                    $hashProperty = $ComplexObject[$key]
                }
                else
                {
                    $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                }

                if (-not $isArray)
                {
                    $currentProperty += $indent + $key + ' = '
                }

                if ($isArray -and $key -in $ComplexTypeMapping.Name )
                {
                    if ($ComplexObject.$key.count -gt 0)
                    {
                        $currentProperty += $indent + $key + ' = '
                        $currentProperty += '@('
                    }
                }

                if ($isArray)
                {
                    $IndentLevel++
                    foreach ($item in $ComplexObject[$key])
                    {
                        if ($ComplexObject.$key.GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*')
                        {
                            $item = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                        }
                        $nestedPropertyString = Get-M365DSCDRGComplexTypeToString `
                            -ComplexObject $item `
                            -CIMInstanceName $hashPropertyType `
                            -IndentLevel $IndentLevel `
                            -ComplexTypeMapping $ComplexTypeMapping `
                            -IsArray:$true
                        if ([string]::IsNullOrWhiteSpace($nestedPropertyString))
                        {
                            $nestedPropertyString = "@()`r`n"
                        }
                        $currentProperty += $nestedPropertyString
                    }
                    $IndentLevel--
                }
                else
                {
                    $nestedPropertyString = Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $hashProperty `
                        -CIMInstanceName $hashPropertyType `
                        -IndentLevel $IndentLevel `
                        -ComplexTypeMapping $ComplexTypeMapping
                    if ([string]::IsNullOrWhiteSpace($nestedPropertyString))
                    {
                        $nestedPropertyString = "`$null`r`n"
                    }
                    $currentProperty += $nestedPropertyString
                }
                if ($isArray)
                {
                    if ($ComplexObject.$key.count -gt 0)
                    {
                        $currentProperty += $indent
                        $currentProperty += ')'
                        $currentProperty += "`r`n"
                    }
                }
                $isArray = $PSBoundParameters.IsArray
            }
            else
            {
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key] -Space ($indent)
            }
        }
        else
        {
            $mappedKey = $ComplexTypeMapping | Where-Object -FilterScript { $_.name -eq $key }

            if ($mappedKey -and $mappedKey.isRequired)
            {
                if ($mappedKey.isArray)
                {
                    $currentProperty += "$indent$key = @()`r`n"
                }
                else
                {
                    $currentProperty += "$indent$key = `$null`r`n"
                }
            }
        }
    }
    $indent = ''
    for ($i = 0; $i -lt $IndentLevel - 1 ; $i++)
    {
        $indent += '    '
    }
    $currentProperty += "$indent}"
    if ($isArray -or $IndentLevel -gt 4)
    {
        $currentProperty += "`r`n"
    }

    #Indenting last parenthese when the cim instance is an array
    if ($IndentLevel -eq 5)
    {
        $indent = ''
        for ($i = 0; $i -lt $IndentLevel - 2 ; $i++)
        {
            $indent += '    '
        }
        $currentProperty += $indent
    }

    $emptyCIM = $currentProperty.replace(' ', '').replace("`r`n", '')
    if ($emptyCIM -eq "MSFT_$CIMInstanceName{}")
    {
        $currentProperty = $null
    }

    return $currentProperty
}

function Get-M365DSCDRGSimpleObjectTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $Key,

        [Parameter(Mandatory = 'true')]
        $Value,

        [Parameter()]
        [System.String]
        $Space = '                '

    )

    $returnValue = ''
    switch -Wildcard ($Value.GetType().Fullname )
    {
        '*.Boolean'
        {
            $returnValue = $Space + $Key + " = `$" + $Value.ToString() + "`r`n"
        }
        '*.String'
        {
            if ($key -eq '@odata.type')
            {
                $key = 'odataType'
            }
            $returnValue = $Space + $Key + " = '" + $Value + "'`r`n"
        }
        '*.DateTime'
        {
            $returnValue = $Space + $Key + " = '" + $Value + "'`r`n"
        }
        '*[[\]]'
        {
            $returnValue = $Space + $key + ' = @('
            $whitespace = ''
            $newline = ''
            if ($Value.count -gt 1)
            {
                $returnValue += "`r`n"
                $whitespace = $Space + '    '
                $newline = "`r`n"
            }
            foreach ($item in ($Value | Where-Object -FilterScript { $null -ne $_ }))
            {
                switch -Wildcard ($item.GetType().Fullname )
                {
                    '*.String'
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    '*.DateTime'
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    Default
                    {
                        $returnValue += "$whitespace$item$newline"
                    }
                }
            }
            if ($Value.count -gt 1)
            {
                $returnValue += "$Space)`r`n"
            }
            else
            {
                $returnValue += ")`r`n"

            }
        }
        Default
        {
            $returnValue = $Space + $Key + ' = ' + $Value + "`r`n"
        }
    }
    return $returnValue
}

function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        $Source,
        [Parameter()]
        $Target
    )

    #Comparing full objects
    if ($null -eq $Source -and $null -eq $Target)
    {
        return $true
    }

    $sourceValue = ''
    $targetValue = ''
    if (($null -eq $Source) -xor ($null -eq $Target))
    {
        if ($null -eq $Source)
        {
            $sourceValue = 'Source is null'
        }

        if ($null -eq $Target)
        {
            $targetValue = 'Target is null'
        }
        Write-Verbose -Message "Configuration drift - Complex object: {$sourceValue$targetValue}"
        return $false
    }

    if ($Source.getType().FullName -like '*CimInstance[[\]]' -or $Source.getType().FullName -like '*Hashtable[[\]]')
    {
        if ($source.count -ne $target.count)
        {
            Write-Verbose -Message "Configuration drift - The complex array have different number of items: Source {$($source.count)} Target {$($target.count)}"
            return $false
        }
        if ($source.count -eq 0)
        {
            return $true
        }

        foreach ($item in $Source)
        {

            $hashSource = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            foreach ($targetItem in $Target)
            {
                $compareResult = Compare-M365DSCComplexObject `
                    -Source $hashSource `
                    -Target $targetItem

                if ($compareResult)
                {
                    break
                }
            }

            if (-not $compareResult)
            {
                Write-Verbose -Message 'Configuration drift - The complex array items are not identical'
                return $false
            }
        }
        return $true
    }

    $keys = $Source.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    foreach ($key in $keys)
    {
        #Matching possible key names between Source and Target
        $skey = $key
        $tkey = $key

        $sourceValue = $Source.$key
        $targetValue = $Target.$tkey
        #One of the item is null and not the other
        if (($null -eq $Source.$key) -xor ($null -eq $Target.$tkey))
        {

            if ($null -eq $Source.$key)
            {
                $sourceValue = 'null'
            }

            if ($null -eq $Target.$tkey)
            {
                $targetValue = 'null'
            }

            #Write-Verbose -Message "Configuration drift - key: $key Source {$sourceValue} Target {$targetValue}"
            return $false
        }

        #Both keys aren't null or empty
        if (($null -ne $Source.$key) -and ($null -ne $Target.$tkey))
        {
            if ($Source.$key.getType().FullName -like '*CimInstance*' -or $Source.$key.getType().FullName -like '*hashtable*'  )
            {
                #Recursive call for complex object
                $compareResult = Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source.$key) `
                    -Target $Target.$tkey

                if (-not $compareResult)
                {

                    #Write-Verbose -Message "Configuration drift - complex object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject = $Target.$tkey
                $differenceObject = $Source.$key

                #Identifying date from the current values
                $targetType = ($Target.$tkey.getType()).Name
                if ($targetType -like '*Date*')
                {
                    $compareResult = $true
                    $sourceDate = [DateTime]$Source.$key
                    if ($sourceDate -ne $targetType)
                    {
                        $compareResult = $null
                    }
                }
                else
                {
                    $compareResult = Compare-Object `
                        -ReferenceObject ($referenceObject) `
                        -DifferenceObject ($differenceObject)
                }

                if ($null -ne $compareResult)
                {
                    #Write-Verbose -Message "Configuration drift - simple object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
        }
    }

    return $true
}

function Convert-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable], [hashtable[]])]
    param
    (
        [Parameter(Mandatory = 'true')]
        $ComplexObject
    )

    if ($ComplexObject.getType().Fullname -like '*[[\]]')
    {
        $results = @()
        foreach ($item in $ComplexObject)
        {
            $hash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            $results += $hash
        }

        #Write-Verbose -Message ("Convert-M365DSCDRGComplexTypeToHashtable >>> results: "+(convertTo-JSON $results -Depth 20))
        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , [hashtable[]]$results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject

    if ($null -ne $hashComplexObject)
    {

        $results = $hashComplexObject.clone()
        $keys = $hashComplexObject.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
        foreach ($key in $keys)
        {
            if ($hashComplexObject[$key] -and $hashComplexObject[$key].getType().Fullname -like '*CimInstance*')
            {
                $results[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            else
            {
                $propertyName = $key[0].ToString().ToLower() + $key.Substring(1, $key.Length - 1)
                $propertyValue = $results[$key]
                $results.remove($key) | Out-Null
                $results.add($propertyName, $propertyValue)
            }
        }
    }
    return [hashtable]$results
}

Export-ModuleMember -Function *-TargetResource
