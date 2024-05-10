function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
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

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
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

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        #region resource generator code
        try
        {
            $getValue = Get-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy -MdmWindowsInformationProtectionPolicyId $Id -ExpandProperty assignments -ErrorAction Stop
        }
        catch
        {
            $getValue = $null
        }

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Windows Information Protection Policy for Windows10 Mdm Enrolled with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy `
                    -Filter "DisplayName eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue
                if ($getValue.count -gt 1)
                {
                    throw ("Error: Ensure the displayName {$displayName} is unique.")
                }
                if (-not [String]::IsNullOrEmpty($getValue.Id))
                {
                    $getValue = Get-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy -MdmWindowsInformationProtectionPolicyId $getValue.id -ExpandProperty assignments
                }
            }
        }
        #endregion

        if ([String]::IsNullOrEmpty($getValue.Id))
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
            AccessTokens                           = $AccessTokens
            #endregion
        }
        if ($getValue.assignments.count -gt 0)
        {
            $results.Add('Assignments', (ConvertFrom-IntunePolicyAssignment -Assignments $getValue.assignments -IncludeDeviceFilter $false))
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
        [Parameter()]
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

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
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

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('Verbose') | Out-Null
    $PSBoundParameters.Remove('AccessTokens') | Out-Null

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Windows Information Protection Policy for Windows10 Mdm Enrolled with DisplayName {$DisplayName}"

        $PSBoundParameters.remove('Assignments') | Out-Null
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
        $policy = New-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy -BodyParameter $CreateParameters
        #endregion

        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }

        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceAppManagement/mdmWindowsInformationProtectionPolicies'
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Windows Information Protection Policy for Windows10 Mdm Enrolled with Id {$($currentInstance.Id)}"

        $PSBoundParameters.remove('Assignments') | Out-Null
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
        Update-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy `
            -MdmWindowsInformationProtectionPolicyId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        #endregion

        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository 'deviceAppManagement/mdmWindowsInformationProtectionPolicies'
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Windows Information Protection Policy for Windows10 Mdm Enrolled with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy -MdmWindowsInformationProtectionPolicyId $currentInstance.Id
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
        [Parameter()]
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

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
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

    Write-Verbose -Message "Testing configuration of the Intune Windows Information Protection Policy for Windows10 Mdm Enrolled with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -ne $Ensure)
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

            if ($key -eq 'Assignments')
            {
                $testResult = Compare-M365DSCIntunePolicyAssignment -Source $source -Target $target
            }

            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null

        }
    }
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
        #region resource generator code
        [array]$getValue = Get-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy -Filter $Filter -All -ErrorAction Stop
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
                AccessTokens          = $AccessTokens
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
            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Assignments -CIMInstanceName IntuneWindowsInformationProtectionPolicyWindows10MdmEnrolledPolicyAssignments
                if ($complexTypeStringResult)
                {
                    $Results.Assignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Assignments') | Out-Null
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
            if ($Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$true
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
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
        $_.Exception -like "*Request not applicable to target tenant*")
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

Export-ModuleMember -Function *-TargetResource
