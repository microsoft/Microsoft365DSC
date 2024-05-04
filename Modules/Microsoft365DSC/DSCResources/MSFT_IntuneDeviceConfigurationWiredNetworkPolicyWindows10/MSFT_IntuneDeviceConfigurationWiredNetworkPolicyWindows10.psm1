function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Int32]
        $AuthenticationBlockPeriodInMinutes,

        [Parameter()]
        [ValidateSet('certificate', 'usernameAndPassword', 'derivedCredential', 'unknownFutureValue')]
        [System.String]
        $AuthenticationMethod,

        [Parameter()]
        [System.Int32]
        $AuthenticationPeriodInSeconds,

        [Parameter()]
        [System.Int32]
        $AuthenticationRetryDelayPeriodInSeconds,

        [Parameter()]
        [ValidateSet('none', 'user', 'machine', 'machineOrUser', 'guest', 'unknownFutureValue')]
        [System.String]
        $AuthenticationType,

        [Parameter()]
        [System.Boolean]
        $CacheCredentials,

        [Parameter()]
        [System.Boolean]
        $DisableUserPromptForServerValidation,

        [Parameter()]
        [System.Int32]
        $EapolStartPeriodInSeconds,

        [Parameter()]
        [ValidateSet('eapTls', 'leap', 'eapSim', 'eapTtls', 'peap', 'eapFast', 'teap')]
        [System.String]
        $EapType,

        [Parameter()]
        [System.Boolean]
        $Enforce8021X,

        [Parameter()]
        [System.Boolean]
        $ForceFIPSCompliance,

        [Parameter()]
        [ValidateSet('unencryptedPassword', 'challengeHandshakeAuthenticationProtocol', 'microsoftChap', 'microsoftChapVersionTwo')]
        [System.String]
        $InnerAuthenticationProtocolForEAPTTLS,

        [Parameter()]
        [System.Int32]
        $MaximumAuthenticationFailures,

        [Parameter()]
        [System.Int32]
        $MaximumEAPOLStartMessages,

        [Parameter()]
        [System.String]
        $OuterIdentityPrivacyTemporaryValue,

        [Parameter()]
        [System.Boolean]
        $PerformServerValidation,

        [Parameter()]
        [System.Boolean]
        $RequireCryptographicBinding,

        [Parameter()]
        [ValidateSet('certificate', 'usernameAndPassword', 'derivedCredential', 'unknownFutureValue')]
        [System.String]
        $SecondaryAuthenticationMethod,

        [Parameter()]
        [System.String[]]
        $TrustedServerCertificateNames,

        [Parameter()]
        [System.String[]]
        $RootCertificatesForServerValidationIds,

        [Parameter()]
        [System.String]
        $IdentityCertificateForClientAuthenticationId,

        [Parameter()]
        [System.String]
        $SecondaryIdentityCertificateForClientAuthenticationId,

        [Parameter()]
        [System.String]
        $RootCertificateForClientValidationId,

        [Parameter()]
        [System.String]
        $SecondaryRootCertificateForClientValidationId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

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

        $getValue = $null
        #region resource generator code
        $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $Id -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Configuration Wired Network Policy for Windows10 with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
                    -Filter "DisplayName eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue | Where-Object `
                    -FilterScript { `
                        $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windowsWiredNetworkConfiguration' `
                }
            }
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Configuration Wired Network Policy for Windows10 with DisplayName {$DisplayName}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Configuration Wired Network Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $enumAuthenticationMethod = $null
        if ($null -ne $getValue.AdditionalProperties.authenticationMethod)
        {
            $enumAuthenticationMethod = $getValue.AdditionalProperties.authenticationMethod.ToString()
        }

        $enumAuthenticationType = $null
        if ($null -ne $getValue.AdditionalProperties.authenticationType)
        {
            $enumAuthenticationType = $getValue.AdditionalProperties.authenticationType.ToString()
        }

        $enumEapType = $null
        if ($null -ne $getValue.AdditionalProperties.eapType)
        {
            $enumEapType = $getValue.AdditionalProperties.eapType.ToString()
        }

        $enumInnerAuthenticationProtocolForEAPTTLS = $null
        if ($null -ne $getValue.AdditionalProperties.innerAuthenticationProtocolForEAPTTLS)
        {
            $enumInnerAuthenticationProtocolForEAPTTLS = $getValue.AdditionalProperties.innerAuthenticationProtocolForEAPTTLS.ToString()
        }

        $enumSecondaryAuthenticationMethod = $null
        if ($null -ne $getValue.AdditionalProperties.secondaryAuthenticationMethod)
        {
            $enumSecondaryAuthenticationMethod = $getValue.AdditionalProperties.secondaryAuthenticationMethod.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            AuthenticationBlockPeriodInMinutes                    = $getValue.AdditionalProperties.authenticationBlockPeriodInMinutes
            AuthenticationMethod                                  = $enumAuthenticationMethod
            AuthenticationPeriodInSeconds                         = $getValue.AdditionalProperties.authenticationPeriodInSeconds
            AuthenticationRetryDelayPeriodInSeconds               = $getValue.AdditionalProperties.authenticationRetryDelayPeriodInSeconds
            AuthenticationType                                    = $enumAuthenticationType
            CacheCredentials                                      = $getValue.AdditionalProperties.cacheCredentials
            DisableUserPromptForServerValidation                  = $getValue.AdditionalProperties.disableUserPromptForServerValidation
            EapolStartPeriodInSeconds                             = $getValue.AdditionalProperties.eapolStartPeriodInSeconds
            EapType                                               = $enumEapType
            Enforce8021X                                          = $getValue.AdditionalProperties.enforce8021X
            ForceFIPSCompliance                                   = $getValue.AdditionalProperties.forceFIPSCompliance
            InnerAuthenticationProtocolForEAPTTLS                 = $enumInnerAuthenticationProtocolForEAPTTLS
            MaximumAuthenticationFailures                         = $getValue.AdditionalProperties.maximumAuthenticationFailures
            MaximumEAPOLStartMessages                             = $getValue.AdditionalProperties.maximumEAPOLStartMessages
            OuterIdentityPrivacyTemporaryValue                    = $getValue.AdditionalProperties.outerIdentityPrivacyTemporaryValue
            PerformServerValidation                               = $getValue.AdditionalProperties.performServerValidation
            RequireCryptographicBinding                           = $getValue.AdditionalProperties.requireCryptographicBinding
            SecondaryAuthenticationMethod                         = $enumSecondaryAuthenticationMethod
            TrustedServerCertificateNames                         = $getValue.AdditionalProperties.trustedServerCertificateNames
            RootCertificatesForServerValidationIds                = Get-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $getValue.Id -CertificateName rootCertificatesForServerValidation
            IdentityCertificateForClientAuthenticationId          = Get-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $getValue.Id -CertificateName identityCertificateForClientAuthentication
            SecondaryIdentityCertificateForClientAuthenticationId = Get-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $getValue.Id -CertificateName secondaryIdentityCertificateForClientAuthentication
            RootCertificateForClientValidationId                  = Get-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $getValue.Id -CertificateName rootCertificateForClientValidation
            SecondaryRootCertificateForClientValidationId         = Get-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $getValue.Id -CertificateName secondaryRootCertificateForClientValidation
            Description                                           = $getValue.Description
            DisplayName                                           = $getValue.DisplayName
            Id                                                    = $getValue.Id
            Ensure                                                = 'Present'
            Credential                                            = $Credential
            ApplicationId                                         = $ApplicationId
            TenantId                                              = $TenantId
            ApplicationSecret                                     = $ApplicationSecret
            CertificateThumbprint                                 = $CertificateThumbprint
            Managedidentity                                       = $ManagedIdentity.IsPresent
            AccessTokens                                          = $AccessTokens
            #endregion
        }
        $assignmentsValues = Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $Id
        $assignmentResult = @()
        foreach ($assignmentEntry in $AssignmentsValues)
        {
            $assignmentValue = @{
                dataType                                   = $assignmentEntry.Target.AdditionalProperties.'@odata.type'
                deviceAndAppManagementAssignmentFilterType = $(if ($null -ne $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType)
                    {
                        $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType.ToString()
                    })
                deviceAndAppManagementAssignmentFilterId   = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterId
                groupId                                    = $assignmentEntry.Target.AdditionalProperties.groupId
            }
            $assignmentResult += $assignmentValue
        }
        $results.Add('Assignments', $assignmentResult)

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
        [System.Int32]
        $AuthenticationBlockPeriodInMinutes,

        [Parameter()]
        [ValidateSet('certificate', 'usernameAndPassword', 'derivedCredential', 'unknownFutureValue')]
        [System.String]
        $AuthenticationMethod,

        [Parameter()]
        [System.Int32]
        $AuthenticationPeriodInSeconds,

        [Parameter()]
        [System.Int32]
        $AuthenticationRetryDelayPeriodInSeconds,

        [Parameter()]
        [ValidateSet('none', 'user', 'machine', 'machineOrUser', 'guest', 'unknownFutureValue')]
        [System.String]
        $AuthenticationType,

        [Parameter()]
        [System.Boolean]
        $CacheCredentials,

        [Parameter()]
        [System.Boolean]
        $DisableUserPromptForServerValidation,

        [Parameter()]
        [System.Int32]
        $EapolStartPeriodInSeconds,

        [Parameter()]
        [ValidateSet('eapTls', 'leap', 'eapSim', 'eapTtls', 'peap', 'eapFast', 'teap')]
        [System.String]
        $EapType,

        [Parameter()]
        [System.Boolean]
        $Enforce8021X,

        [Parameter()]
        [System.Boolean]
        $ForceFIPSCompliance,

        [Parameter()]
        [ValidateSet('unencryptedPassword', 'challengeHandshakeAuthenticationProtocol', 'microsoftChap', 'microsoftChapVersionTwo')]
        [System.String]
        $InnerAuthenticationProtocolForEAPTTLS,

        [Parameter()]
        [System.Int32]
        $MaximumAuthenticationFailures,

        [Parameter()]
        [System.Int32]
        $MaximumEAPOLStartMessages,

        [Parameter()]
        [System.String]
        $OuterIdentityPrivacyTemporaryValue,

        [Parameter()]
        [System.Boolean]
        $PerformServerValidation,

        [Parameter()]
        [System.Boolean]
        $RequireCryptographicBinding,

        [Parameter()]
        [ValidateSet('certificate', 'usernameAndPassword', 'derivedCredential', 'unknownFutureValue')]
        [System.String]
        $SecondaryAuthenticationMethod,

        [Parameter()]
        [System.String[]]
        $TrustedServerCertificateNames,

        [Parameter()]
        [System.String[]]
        $RootCertificatesForServerValidationIds,

        [Parameter()]
        [System.String]
        $IdentityCertificateForClientAuthenticationId,

        [Parameter()]
        [System.String]
        $SecondaryIdentityCertificateForClientAuthenticationId,

        [Parameter()]
        [System.String]
        $RootCertificateForClientValidationId,

        [Parameter()]
        [System.String]
        $SecondaryRootCertificateForClientValidationId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

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

    $currentInstance = Get-TargetResource @PSBoundParameters

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Configuration Wired Network Policy for Windows10 with DisplayName {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null
        $BoundParameters.Remove('RootCertificatesForServerValidationIds') | Out-Null
        $BoundParameters.Remove('IdentityCertificateForClientAuthenticationId') | Out-Null
        $BoundParameters.Remove('SecondaryIdentityCertificateForClientAuthenticationId') | Out-Null
        $BoundParameters.Remove('RootCertificateForClientValidationId') | Out-Null
        $BoundParameters.Remove('SecondaryRootCertificateForClientValidationId') | Out-Null

        $CreateParameters = ([Hashtable]$BoundParameters).clone()
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

        if ($null -ne $RootCertificatesForServerValidationIds -and $RootCertificatesForServerValidationIds.count -gt 0 )
        {
            $rootCertificatesForServerValidation = @()
            foreach ($certId in $RootCertificatesForServerValidationIds)
            {
                $rootCertificatesForServerValidation += "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations('$certId')"
            }
            $CreateParameters.Add('rootCertificatesForServerValidation@odata.bind', $rootCertificatesForServerValidation)
        }

        if (-not [String]::IsNullOrWhiteSpace($IdentityCertificateForClientAuthenticationId))
        {
            $ref = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations('$IdentityCertificateForClientAuthenticationId')"
            $CreateParameters.Add('identityCertificateForClientAuthentication@odata.bind', $ref)
        }

        if (-not [String]::IsNullOrWhiteSpace($SecondaryIdentityCertificateForClientAuthenticationId))
        {
            $ref = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations('$SecondaryIdentityCertificateForClientAuthenticationId')"
            $CreateParameters.Add('secondaryIdentityCertificateForClientAuthentication@odata.bind', $ref)
        }

        if (-not [String]::IsNullOrWhiteSpace($RootCertificateForClientValidationId))
        {
            $ref = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations('$RootCertificateForClientValidationId')"
            $CreateParameters.Add('rootCertificateForClientValidation@odata.bind', $ref)
        }

        if (-not [String]::IsNullOrWhiteSpace($SecondaryRootCertificateForClientValidationId))
        {
            $ref = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations('$SecondaryRootCertificateForClientValidationId')"
            $CreateParameters.Add('secondaryRootCertificateForClientValidation@odata.bind', $ref)
        }

        $CreateParameters.Add('@odata.type', '#microsoft.graph.windowsWiredNetworkConfiguration')
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }

        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceConfigurations'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Device Configuration Wired Network Policy for Windows10 with Id {$($currentInstance.Id)}"
        $BoundParameters.Remove('Assignments') | Out-Null
        $BoundParameters.Remove('RootCertificatesForServerValidationIds') | Out-Null
        $BoundParameters.Remove('IdentityCertificateForClientAuthenticationId') | Out-Null
        $BoundParameters.Remove('SecondaryIdentityCertificateForClientAuthenticationId') | Out-Null
        $BoundParameters.Remove('RootCertificateForClientValidationId') | Out-Null
        $BoundParameters.Remove('SecondaryRootCertificateForClientValidationId') | Out-Null

        $UpdateParameters = ([Hashtable]$BoundParameters).clone()
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
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.windowsWiredNetworkConfiguration')
        Update-MgBetaDeviceManagementDeviceConfiguration  `
            -DeviceConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceConfigurations'
        #endregion

        if ($null -ne $RootCertificatesForServerValidationIds -and $RootCertificatesForServerValidationIds.count -gt 0 )
        {
            $compareResult = Compare-Object -ReferenceObject $currentInstance.RootCertificatesForServerValidationIds `
                -DifferenceObject $RootCertificatesForServerValidationIds

            [Array]$certsToAdd = ($compareResult | Where-Object { $_.SideIndicator -eq '=>' }).InputObject
            [Array]$certsToRemove = ($compareResult | Where-Object { $_.SideIndicator -eq '<=' }).InputObject

            if ($certsToAdd.count -gt 0)
            {
                Update-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $Id `
                    -CertificateIds $certsToAdd `
                    -CertificateName rootCertificatesForServerValidation
            }

            if ($certsToRemove.count -gt 0)
            {
                Remove-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $Id `
                    -CertificateIds $certsToRemove `
                    -CertificateName rootCertificatesForServerValidation
            }
        }

        if (-not [String]::IsNullOrWhiteSpace($IdentityCertificateForClientAuthenticationId))
        {
            if ($IdentityCertificateForClientAuthenticationId -ne $currentInstance.IdentityCertificateForClientAuthenticationId)
            {
                Update-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $Id `
                    -CertificateIds $IdentityCertificateForClientAuthenticationId `
                    -CertificateName identityCertificateForClientAuthenticationId
            }
        }

        if (-not [String]::IsNullOrWhiteSpace($SecondaryIdentityCertificateForClientAuthenticationId))
        {
            if ($SecondaryIdentityCertificateForClientAuthenticationId -ne $currentInstance.SecondaryIdentityCertificateForClientAuthenticationId)
            {
                Update-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $Id `
                    -CertificateIds $SecondaryIdentityCertificateForClientAuthenticationId `
                    -CertificateName secondaryIdentityCertificateForClientAuthenticationId
            }
        }

        if (-not [String]::IsNullOrWhiteSpace($RootCertificateForClientValidationId))
        {
            if ($RootCertificateForClientValidationId -ne $currentInstance.RootCertificateForClientValidationId)
            {
                Update-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $Id `
                    -CertificateIds $RootCertificateForClientValidationId `
                    -CertificateName rootCertificateForClientValidationId
            }
        }

        if (-not [String]::IsNullOrWhiteSpace($SecondaryRootCertificateForClientValidationId))
        {
            if ($SecondaryRootCertificateForClientValidationId -ne $currentInstance.SecondaryRootCertificateForClientValidationId)
            {
                Update-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $Id `
                    -CertificateIds $SecondaryRootCertificateForClientValidationId `
                    -CertificateName secondaryRootCertificateForClientValidationId
            }
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Device Configuration Wired Network Policy for Windows10 with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $currentInstance.Id
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
        [System.Int32]
        $AuthenticationBlockPeriodInMinutes,

        [Parameter()]
        [ValidateSet('certificate', 'usernameAndPassword', 'derivedCredential', 'unknownFutureValue')]
        [System.String]
        $AuthenticationMethod,

        [Parameter()]
        [System.Int32]
        $AuthenticationPeriodInSeconds,

        [Parameter()]
        [System.Int32]
        $AuthenticationRetryDelayPeriodInSeconds,

        [Parameter()]
        [ValidateSet('none', 'user', 'machine', 'machineOrUser', 'guest', 'unknownFutureValue')]
        [System.String]
        $AuthenticationType,

        [Parameter()]
        [System.Boolean]
        $CacheCredentials,

        [Parameter()]
        [System.Boolean]
        $DisableUserPromptForServerValidation,

        [Parameter()]
        [System.Int32]
        $EapolStartPeriodInSeconds,

        [Parameter()]
        [ValidateSet('eapTls', 'leap', 'eapSim', 'eapTtls', 'peap', 'eapFast', 'teap')]
        [System.String]
        $EapType,

        [Parameter()]
        [System.Boolean]
        $Enforce8021X,

        [Parameter()]
        [System.Boolean]
        $ForceFIPSCompliance,

        [Parameter()]
        [ValidateSet('unencryptedPassword', 'challengeHandshakeAuthenticationProtocol', 'microsoftChap', 'microsoftChapVersionTwo')]
        [System.String]
        $InnerAuthenticationProtocolForEAPTTLS,

        [Parameter()]
        [System.Int32]
        $MaximumAuthenticationFailures,

        [Parameter()]
        [System.Int32]
        $MaximumEAPOLStartMessages,

        [Parameter()]
        [System.String]
        $OuterIdentityPrivacyTemporaryValue,

        [Parameter()]
        [System.Boolean]
        $PerformServerValidation,

        [Parameter()]
        [System.Boolean]
        $RequireCryptographicBinding,

        [Parameter()]
        [ValidateSet('certificate', 'usernameAndPassword', 'derivedCredential', 'unknownFutureValue')]
        [System.String]
        $SecondaryAuthenticationMethod,

        [Parameter()]
        [System.String[]]
        $TrustedServerCertificateNames,

        [Parameter()]
        [System.String[]]
        $RootCertificatesForServerValidationIds,

        [Parameter()]
        [System.String]
        $IdentityCertificateForClientAuthenticationId,

        [Parameter()]
        [System.String]
        $SecondaryIdentityCertificateForClientAuthenticationId,

        [Parameter()]
        [System.String]
        $RootCertificateForClientValidationId,

        [Parameter()]
        [System.String]
        $SecondaryRootCertificateForClientValidationId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

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

    Write-Verbose -Message "Testing configuration of the Intune Device Configuration Wired Network Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

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

            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.remove('Id') | Out-Null

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
        [array]$getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter $Filter -All `
            -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windowsWiredNetworkConfiguration' `
        }
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
            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Assignments -CIMInstanceName DeviceManagementConfigurationPolicyAssignments
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
            if ($Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$true
            }

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
            $_.Exception -like "*Message: Location header not present in redirection response.*" -or `
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

function Get-DeviceConfigurationPolicyCertificateId
{
    [CmdletBinding()]
    [OutputType([System.String], [System.String[]])]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter(Mandatory = 'true')]
        [ValidateSet('rootCertificatesForServerValidation', 'identityCertificateForClientAuthentication', 'secondaryIdentityCertificateForClientAuthentication', 'rootCertificateForClientValidation', 'secondaryRootCertificateForClientValidation')]
        [System.String]
        $CertificateName
    )

    $Uri = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations('$DeviceConfigurationPolicyId')/microsoft.graph.windowsWiredNetworkConfiguration/$CertificateName"
    try
    {
        $result = Invoke-MgGraphRequest -Method Get -Uri $Uri 4>$null
        return $(if ($result.id)
            {
                $result.id
            }
            else
            {
                $result.value.id
            })
    }
    catch
    {
        return $null
    }

}

function Update-DeviceConfigurationPolicyCertificateId
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter(Mandatory = 'true')]
        [System.String[]]
        $CertificateIds,

        [Parameter(Mandatory = 'true')]
        [ValidateSet('rootCertificatesForServerValidation', 'identityCertificateForClientAuthentication', 'secondaryIdentityCertificateForClientAuthentication', 'rootCertificateForClientValidation', 'secondaryRootCertificateForClientValidation')]
        [System.String]
        $CertificateName
    )

    $Uri = " https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations('$DeviceConfigurationPolicyId')/microsoft.graph.windowsWiredNetworkConfiguration/$CertificateName/`$ref"

    foreach ($certificateId in $CertificateIds)
    {
        $ref = @{
            '@odata.id' = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations('$certificateId')"
        }

        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body ($ref | ConvertTo-Json) -ErrorAction Stop 4>$null
    }
}

function Remove-DeviceConfigurationPolicyCertificateId
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter(Mandatory = 'true')]
        [System.String[]]
        $CertificateIds,

        [Parameter(Mandatory = 'true')]
        [ValidateSet('rootCertificatesForServerValidation', 'identityCertificateForClientAuthentication', 'secondaryIdentityCertificateForClientAuthentication', 'rootCertificateForClientValidation', 'secondaryRootCertificateForClientValidation')]
        [System.String]
        $CertificateName
    )

    foreach ($certificateId in $CertificateIds)
    {
        $Uri = " https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations('$DeviceConfigurationPolicyId')/microsoft.graph.windowsWiredNetworkConfiguration/$CertificateName/$certificateId/`$ref"
        Invoke-MgGraphRequest -Method DELETE -Uri $Uri -Body ($ref | ConvertTo-Json) -ErrorAction Stop 4>$null
    }
}

Export-ModuleMember -Function *-TargetResource
