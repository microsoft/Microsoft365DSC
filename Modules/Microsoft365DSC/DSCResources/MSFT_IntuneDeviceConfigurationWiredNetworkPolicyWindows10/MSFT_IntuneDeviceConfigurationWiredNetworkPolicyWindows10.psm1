Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneDeviceConfigurationWiredNetworkPolicyWindows10'

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
        [System.String[]]
        $RootCertificatesForServerValidationDisplayNames,

        [Parameter()]
        [System.String]
        $IdentityCertificateForClientAuthenticationId,

        [Parameter()]
        [System.String]
        $IdentityCertificateForClientAuthenticationDisplayName,

        [Parameter()]
        [System.String]
        $SecondaryIdentityCertificateForClientAuthenticationId,

        [Parameter()]
        [System.String]
        $SecondaryIdentityCertificateForClientAuthenticationDisplayName,

        [Parameter()]
        [System.String]
        $RootCertificateForClientValidationId,

        [Parameter()]
        [System.String]
        $RootCertificateForClientValidationDisplayName,

        [Parameter()]
        [System.String]
        $SecondaryRootCertificateForClientValidationId,

        [Parameter()]
        [System.String]
        $SecondaryRootCertificateForClientValidationDisplayName,

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
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

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

    Write-Verbose -Message "Getting configuration of the Intune Device Configuration Wired Network Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
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
            if (-not [string]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -All -Filter "Id eq '$Id'" -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Device Configuration Wired Network Policy for Windows10 with Id {$Id}"

                if (-not [string]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
                        -All `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" `
                        -ErrorAction SilentlyContinue | Where-Object `
                        -FilterScript {
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
        }
        else
        {
            $getValue = $Script:exportedInstance
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

        $rootCertificateForClientValidation = Get-DeviceConfigurationPolicyCertificate -DeviceConfigurationPolicyId $getValue.Id -CertificateName rootCertificateForClientValidation
        $rootCertificatesForServerValidation = Get-DeviceConfigurationPolicyCertificate -DeviceConfigurationPolicyId $getValue.Id -CertificateName rootCertificatesForServerValidation
        $identityCertificateForClientAuthentication = Get-DeviceConfigurationPolicyCertificate -DeviceConfigurationPolicyId $getValue.Id -CertificateName identityCertificateForClientAuthentication
        $secondaryIdentityCertificateForClientAuthentication = Get-DeviceConfigurationPolicyCertificate -DeviceConfigurationPolicyId $getValue.Id -CertificateName secondaryIdentityCertificateForClientAuthentication
        $secondaryRootCertificateForClientValidation = Get-DeviceConfigurationPolicyCertificate -DeviceConfigurationPolicyId $getValue.Id -CertificateName secondaryRootCertificateForClientValidation

        $results = @{
            #region resource generator code
            AuthenticationBlockPeriodInMinutes                             = $getValue.AdditionalProperties.authenticationBlockPeriodInMinutes
            AuthenticationMethod                                           = $enumAuthenticationMethod
            AuthenticationPeriodInSeconds                                  = $getValue.AdditionalProperties.authenticationPeriodInSeconds
            AuthenticationRetryDelayPeriodInSeconds                        = $getValue.AdditionalProperties.authenticationRetryDelayPeriodInSeconds
            AuthenticationType                                             = $enumAuthenticationType
            CacheCredentials                                               = $getValue.AdditionalProperties.cacheCredentials
            DisableUserPromptForServerValidation                           = $getValue.AdditionalProperties.disableUserPromptForServerValidation
            EapolStartPeriodInSeconds                                      = $getValue.AdditionalProperties.eapolStartPeriodInSeconds
            EapType                                                        = $enumEapType
            Enforce8021X                                                   = $getValue.AdditionalProperties.enforce8021X
            ForceFIPSCompliance                                            = $getValue.AdditionalProperties.forceFIPSCompliance
            InnerAuthenticationProtocolForEAPTTLS                          = $enumInnerAuthenticationProtocolForEAPTTLS
            MaximumAuthenticationFailures                                  = $getValue.AdditionalProperties.maximumAuthenticationFailures
            MaximumEAPOLStartMessages                                      = $getValue.AdditionalProperties.maximumEAPOLStartMessages
            OuterIdentityPrivacyTemporaryValue                             = $getValue.AdditionalProperties.outerIdentityPrivacyTemporaryValue
            PerformServerValidation                                        = $getValue.AdditionalProperties.performServerValidation
            RequireCryptographicBinding                                    = $getValue.AdditionalProperties.requireCryptographicBinding
            SecondaryAuthenticationMethod                                  = $enumSecondaryAuthenticationMethod
            TrustedServerCertificateNames                                  = $getValue.AdditionalProperties.trustedServerCertificateNames
            RootCertificatesForServerValidationIds                         = Get-M365DSCArrayFromProperty -PropertyValue $rootCertificatesForServerValidation.Id -ElementType ([System.String])
            RootCertificatesForServerValidationDisplayNames                = Get-M365DSCArrayFromProperty -PropertyValue $rootCertificatesForServerValidation.DisplayName -ElementType ([System.String])
            IdentityCertificateForClientAuthenticationId                   = $identityCertificateForClientAuthentication.Id
            IdentityCertificateForClientAuthenticationDisplayName          = $identityCertificateForClientAuthentication.DisplayName
            SecondaryIdentityCertificateForClientAuthenticationId          = $secondaryIdentityCertificateForClientAuthentication.Id
            SecondaryIdentityCertificateForClientAuthenticationDisplayName = $secondaryIdentityCertificateForClientAuthentication.DisplayName
            RootCertificateForClientValidationId                           = $rootCertificateForClientValidation.Id
            RootCertificateForClientValidationDisplayName                  = $rootCertificateForClientValidation.DisplayName
            SecondaryRootCertificateForClientValidationId                  = $secondaryRootCertificateForClientValidation.Id
            SecondaryRootCertificateForClientValidationDisplayName         = $secondaryRootCertificateForClientValidation.DisplayName
            Description                                                    = $getValue.Description
            DisplayName                                                    = $getValue.DisplayName
            Id                                                             = $getValue.Id
            RoleScopeTagIds                                                = $getValue.RoleScopeTagIds
            Ensure                                                         = 'Present'
            Credential                                                     = $Credential
            ApplicationId                                                  = $ApplicationId
            TenantId                                                       = $TenantId
            ApplicationSecret                                              = $ApplicationSecret
            CertificateThumbprint                                          = $CertificateThumbprint
            ManagedIdentity                                                = $ManagedIdentity.IsPresent
            AccessTokens                                                   = $AccessTokens
            #endregion
        }

        $assignmentsValues = Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment `
                -IncludeDeviceFilter:$true `
                -Assignments ($assignmentsValues)
        }
        $results.Add('Assignments', $assignmentResult)

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
        [System.String[]]
        $RootCertificatesForServerValidationDisplayNames,

        [Parameter()]
        [System.String]
        $IdentityCertificateForClientAuthenticationId,

        [Parameter()]
        [System.String]
        $IdentityCertificateForClientAuthenticationDisplayName,

        [Parameter()]
        [System.String]
        $SecondaryIdentityCertificateForClientAuthenticationId,

        [Parameter()]
        [System.String]
        $SecondaryIdentityCertificateForClientAuthenticationDisplayName,

        [Parameter()]
        [System.String]
        $RootCertificateForClientValidationId,

        [Parameter()]
        [System.String]
        $RootCertificateForClientValidationDisplayName,

        [Parameter()]
        [System.String]
        $SecondaryRootCertificateForClientValidationId,

        [Parameter()]
        [System.String]
        $SecondaryRootCertificateForClientValidationDisplayName,

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
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

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
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Configuration Wired Network Policy for Windows10 with DisplayName {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null
        $BoundParameters.Remove('RootCertificatesForServerValidationIds') | Out-Null
        $BoundParameters.Remove('RootCertificatesForServerValidationDisplayNames') | Out-Null
        $BoundParameters.Remove('IdentityCertificateForClientAuthenticationId') | Out-Null
        $BoundParameters.Remove('IdentityCertificateForClientAuthenticationDisplayName') | Out-Null
        $BoundParameters.Remove('SecondaryIdentityCertificateForClientAuthenticationId') | Out-Null
        $BoundParameters.Remove('SecondaryIdentityCertificateForClientAuthenticationDisplayName') | Out-Null
        $BoundParameters.Remove('RootCertificateForClientValidationId') | Out-Null
        $BoundParameters.Remove('RootCertificateForClientValidationDisplayName') | Out-Null
        $BoundParameters.Remove('SecondaryRootCertificateForClientValidationId') | Out-Null
        $BoundParameters.Remove('SecondaryRootCertificateForClientValidationDisplayName') | Out-Null

        $CreateParameters = ([Hashtable]$BoundParameters).Clone()
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('Id') | Out-Null

        #region resource generator code

        if ($null -ne $RootCertificatesForServerValidationIds -and $RootCertificatesForServerValidationIds.Count -gt 0 )
        {
            $rootCertificatesForServerValidation = @()
            for ($i = 0; $i -lt $RootCertificatesForServerValidationIds.Length; $i++)
            {
                $checkedCertId = Get-IntuneDeviceConfigurationCertificateId `
                    -CertificateId $RootCertificatesForServerValidationIds[$i] `
                    -CertificateDisplayName $RootCertificatesForServerValidationDisplayNames[$i] `
                    -OdataTypes @('#microsoft.graph.windows81TrustedRootCertificate')
                $rootCertificatesForServerValidation += "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceManagement/deviceConfigurations('$checkedCertId')"
            }
            $CreateParameters.Add('rootCertificatesForServerValidation@odata.bind', $rootCertificatesForServerValidation)
        }

        if (-not [String]::IsNullOrWhiteSpace($IdentityCertificateForClientAuthenticationId))
        {
            $checkedCertId = Get-IntuneDeviceConfigurationCertificateId `
                -CertificateId $IdentityCertificateForClientAuthenticationId `
                -CertificateDisplayName $IdentityCertificateForClientAuthenticationDisplayName `
                -OdataTypes @( `
                    '#microsoft.graph.windows81SCEPCertificateProfile', `
                    '#microsoft.graph.windows81TrustedRootCertificate', `
                    '#microsoft.graph.windows10PkcsCertificateProfile' `
            )
            $ref = "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceManagement/deviceConfigurations('$checkedCertId')"
            $CreateParameters.Add('identityCertificateForClientAuthentication@odata.bind', $ref)
        }

        if (-not [String]::IsNullOrWhiteSpace($SecondaryIdentityCertificateForClientAuthenticationId))
        {
            $checkedCertId = Get-IntuneDeviceConfigurationCertificateId `
                -CertificateId $SecondaryIdentityCertificateForClientAuthenticationId `
                -CertificateDisplayName $SecondaryIdentityCertificateForClientAuthenticationDisplayName `
                -OdataTypes @( `
                    '#microsoft.graph.windows81SCEPCertificateProfile', `
                    '#microsoft.graph.windows81TrustedRootCertificate', `
                    '#microsoft.graph.windows10PkcsCertificateProfile' `
            )
            $ref = "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceManagement/deviceConfigurations('$checkedCertId')"
            $CreateParameters.Add('secondaryIdentityCertificateForClientAuthentication@odata.bind', $ref)
        }

        if (-not [String]::IsNullOrWhiteSpace($RootCertificateForClientValidationId))
        {
            $checkedCertId = Get-IntuneDeviceConfigurationCertificateId `
                -CertificateId $RootCertificateForClientValidationId `
                -CertificateDisplayName $RootCertificateForClientValidationDisplayName `
                -OdataTypes @('#microsoft.graph.windows81TrustedRootCertificate')
            $ref = "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceManagement/deviceConfigurations('$checkedCertId')"
            $CreateParameters.Add('rootCertificateForClientValidation@odata.bind', $ref)
        }

        if (-not [String]::IsNullOrWhiteSpace($SecondaryRootCertificateForClientValidationId))
        {
            $checkedCertId = Get-IntuneDeviceConfigurationCertificateId `
                -CertificateId $SecondaryRootCertificateForClientValidationId `
                -CertificateDisplayName $SecondaryRootCertificateForClientValidationDisplayName `
                -OdataTypes @('#microsoft.graph.windows81TrustedRootCertificate')
            $ref = "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceManagement/deviceConfigurations('$checkedCertId')"
            $CreateParameters.Add('secondaryRootCertificateForClientValidation@odata.bind', $ref)
        }

        $CreateParameters.Add('@odata.type', '#microsoft.graph.windowsWiredNetworkConfiguration')
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments

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
        $BoundParameters.Remove('RootCertificatesForServerValidationDisplayNames') | Out-Null
        $BoundParameters.Remove('IdentityCertificateForClientAuthenticationId') | Out-Null
        $BoundParameters.Remove('IdentityCertificateForClientAuthenticationDisplayName') | Out-Null
        $BoundParameters.Remove('SecondaryIdentityCertificateForClientAuthenticationId') | Out-Null
        $BoundParameters.Remove('SecondaryIdentityCertificateForClientAuthenticationDisplayName') | Out-Null
        $BoundParameters.Remove('RootCertificateForClientValidationId') | Out-Null
        $BoundParameters.Remove('RootCertificateForClientValidationDisplayName') | Out-Null
        $BoundParameters.Remove('SecondaryRootCertificateForClientValidationId') | Out-Null
        $BoundParameters.Remove('SecondaryRootCertificateForClientValidationDisplayName') | Out-Null

        $updateParameters = ([Hashtable]$boundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters
        $updateParameters.Remove('Id') | Out-Null

        #region resource generator code
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.windowsWiredNetworkConfiguration')
        Update-MgBetaDeviceManagementDeviceConfiguration `
            -DeviceConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceConfigurations'
        #endregion

        if ($null -ne $RootCertificatesForServerValidationIds -and $RootCertificatesForServerValidationIds.Count -gt 0 )
        {
            [Array]$rootCertificatesForServerValidationChecked = @()
            for ($i = 0; $i -lt $RootCertificatesForServerValidationIds.Count; $i++)
            {
                $certId = $RootCertificatesForServerValidationIds[$i]
                $certName = $RootCertificatesForServerValidationDisplayNames[$i]
                $checkedCertId = Get-IntuneDeviceConfigurationCertificateId -CertificateId $certId -CertificateDisplayName $certName -OdataTypes @('#microsoft.graph.windows81TrustedRootCertificate')
                $rootCertificatesForServerValidationChecked += $checkedCertId
            }
            $RootCertificatesForServerValidationIds = $rootCertificatesForServerValidationChecked
            $compareResult = Compare-Object -ReferenceObject $currentInstance.RootCertificatesForServerValidationIds `
                -DifferenceObject $RootCertificatesForServerValidationIds

            [Array]$certsToAdd = ($compareResult | Where-Object { $_.SideIndicator -eq '=>' }).InputObject
            [Array]$certsToRemove = ($compareResult | Where-Object { $_.SideIndicator -eq '<=' }).InputObject

            if ($certsToAdd.Count -gt 0)
            {
                Update-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $currentInstance.Id `
                    -CertificateIds $certsToAdd `
                    -CertificateName rootCertificatesForServerValidation
            }

            if ($certsToRemove.Count -gt 0)
            {
                Remove-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $currentInstance.Id `
                    -CertificateIds $certsToRemove `
                    -CertificateName rootCertificatesForServerValidation
            }
        }

        if (-not [String]::IsNullOrWhiteSpace($IdentityCertificateForClientAuthenticationId))
        {
            if ($IdentityCertificateForClientAuthenticationId -ne $currentInstance.IdentityCertificateForClientAuthenticationId)
            {
                $IdentityCertificateForClientAuthenticationId = Get-IntuneDeviceConfigurationCertificateId `
                    -CertificateId $IdentityCertificateForClientAuthenticationId `
                    -CertificateDisplayName $IdentityCertificateForClientAuthenticationDisplayName `
                    -OdataTypes @( `
                        '#microsoft.graph.windows81SCEPCertificateProfile', `
                        '#microsoft.graph.windows81TrustedRootCertificate', `
                        '#microsoft.graph.windows10PkcsCertificateProfile' `
                )
                Update-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $currentInstance.Id `
                    -CertificateIds $IdentityCertificateForClientAuthenticationId `
                    -CertificateName identityCertificateForClientAuthentication
            }
        }

        if (-not [String]::IsNullOrWhiteSpace($SecondaryIdentityCertificateForClientAuthenticationId))
        {
            if ($SecondaryIdentityCertificateForClientAuthenticationId -ne $currentInstance.SecondaryIdentityCertificateForClientAuthenticationId)
            {
                $SecondaryIdentityCertificateForClientAuthenticationId = Get-IntuneDeviceConfigurationCertificateId `
                    -CertificateId $SecondaryIdentityCertificateForClientAuthenticationId `
                    -CertificateDisplayName $SecondaryIdentityCertificateForClientAuthenticationDisplayName `
                    -OdataTypes @( `
                        '#microsoft.graph.windows81SCEPCertificateProfile', `
                        '#microsoft.graph.windows81TrustedRootCertificate', `
                        '#microsoft.graph.windows10PkcsCertificateProfile' `
                )
                Update-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $currentInstance.Id `
                    -CertificateIds $SecondaryIdentityCertificateForClientAuthenticationId `
                    -CertificateName secondaryIdentityCertificateForClientAuthentication
            }
        }

        if (-not [String]::IsNullOrWhiteSpace($RootCertificateForClientValidationId))
        {
            if ($RootCertificateForClientValidationId -ne $currentInstance.RootCertificateForClientValidationId)
            {
                $RootCertificateForClientValidationId = Get-IntuneDeviceConfigurationCertificateId `
                    -CertificateId $RootCertificateForClientValidationId `
                    -CertificateDisplayName $RootCertificateForClientValidationDisplayName `
                    -OdataTypes @('#microsoft.graph.windows81TrustedRootCertificate')
                Update-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $currentInstance.Id `
                    -CertificateIds $RootCertificateForClientValidationId `
                    -CertificateName rootCertificateForClientValidation
            }
        }

        if (-not [String]::IsNullOrWhiteSpace($SecondaryRootCertificateForClientValidationId))
        {
            if ($SecondaryRootCertificateForClientValidationId -ne $currentInstance.SecondaryRootCertificateForClientValidationId)
            {
                $SecondaryRootCertificateForClientValidationId = Get-IntuneDeviceConfigurationCertificateId `
                    -CertificateId $SecondaryRootCertificateForClientValidationId `
                    -CertificateDisplayName $SecondaryRootCertificateForClientValidationDisplayName `
                    -OdataTypes @('#microsoft.graph.windows81TrustedRootCertificate')
                Update-DeviceConfigurationPolicyCertificateId -DeviceConfigurationPolicyId $currentInstance.Id `
                    -CertificateIds $SecondaryRootCertificateForClientValidationId `
                    -CertificateName secondaryRootCertificateForClientValidation
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
        [System.String[]]
        $RootCertificatesForServerValidationDisplayNames,

        [Parameter()]
        [System.String]
        $IdentityCertificateForClientAuthenticationId,

        [Parameter()]
        [System.String]
        $IdentityCertificateForClientAuthenticationDisplayName,

        [Parameter()]
        [System.String]
        $SecondaryIdentityCertificateForClientAuthenticationId,

        [Parameter()]
        [System.String]
        $SecondaryIdentityCertificateForClientAuthenticationDisplayName,

        [Parameter()]
        [System.String]
        $RootCertificateForClientValidationId,

        [Parameter()]
        [System.String]
        $RootCertificateForClientValidationDisplayName,

        [Parameter()]
        [System.String]
        $SecondaryRootCertificateForClientValidationId,

        [Parameter()]
        [System.String]
        $SecondaryRootCertificateForClientValidationDisplayName,

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
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

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

    $excludedProperties = @()
    if ($PSBoundParameters.ContainsKey('RootCertificatesForServerValidationDisplayNames'))
    {
        $excludedProperties += 'RootCertificatesForServerValidationIds'
    }
    if ($PSBoundParameters.ContainsKey('IdentityCertificateForClientAuthenticationDisplayName'))
    {
        $excludedProperties += 'IdentityCertificateForClientAuthenticationId'
    }
    if ($PSBoundParameters.ContainsKey('SecondaryIdentityCertificateForClientAuthenticationDisplayName'))
    {
        $excludedProperties += 'SecondaryIdentityCertificateForClientAuthenticationId'
    }
    if ($PSBoundParameters.ContainsKey('RootCertificateForClientValidationDisplayName'))
    {
        $excludedProperties += 'RootCertificateForClientValidationId'
    }
    if ($PSBoundParameters.ContainsKey('SecondaryRootCertificateForClientValidationDisplayName'))
    {
        $excludedProperties += 'SecondaryRootCertificateForClientValidationId'
    }

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        -ExcludedProperties $excludedProperties
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
        #region resource generator code
        [array]$getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter $Filter -All `
            -ErrorAction Stop | Where-Object `
            -FilterScript {
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windowsWiredNetworkConfiguration' `
        }
        #endregion

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

            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
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
                -Credential $Credential `
                -NoEscape @('Assignments')

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
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
                $_.Exception -like '*Message: Location header not present in redirection response.*' -or `
                $_.Exception -like '*Request not applicable to target tenant*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            throw
        }
    }
}

function Get-DeviceConfigurationPolicyCertificate
{
    [CmdletBinding()]
    [OutputType([System.String], [System.String[]])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter(Mandatory = 'true')]
        [ValidateSet('rootCertificatesForServerValidation', 'identityCertificateForClientAuthentication', 'secondaryIdentityCertificateForClientAuthentication', 'rootCertificateForClientValidation', 'secondaryRootCertificateForClientValidation')]
        [System.String]
        $CertificateName
    )
    $Uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceManagement/deviceConfigurations('$DeviceConfigurationPolicyId')/microsoft.graph.windowsWiredNetworkConfiguration/$CertificateName"
    try
    {
        $result = Invoke-MgGraphRequest -Method Get -Uri $Uri 4>$null

        return $(if ($result.value)
            {
                $result.value
            }
            else
            {
                $result
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
    param
    (
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
    $Uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceManagement/deviceConfigurations('$DeviceConfigurationPolicyId')/microsoft.graph.windowsWiredNetworkConfiguration/$CertificateName/`$ref"

    if ($CertificateName -eq 'rootCertificatesForServerValidation')
    {
        $method = 'POST'
    }
    else
    {
        $method = 'PUT'
    }

    foreach ($certificateId in $CertificateIds)
    {
        $ref = @{
            '@odata.id' = "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceManagement/deviceConfigurations('$certificateId')"
        }

        Invoke-MgGraphRequest -Method $method -Uri $Uri -Body ($ref | ConvertTo-Json) -ErrorAction Stop 4>$null
    }
}

function Remove-DeviceConfigurationPolicyCertificateId
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
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
        $Uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceManagement/deviceConfigurations('$DeviceConfigurationPolicyId')/microsoft.graph.windowsWiredNetworkConfiguration/$CertificateName/$certificateId/`$ref"
        Invoke-MgGraphRequest -Method DELETE -Uri $Uri -Body ($ref | ConvertTo-Json) -ErrorAction Stop 4>$null
    }
}

function Get-IntuneDeviceConfigurationCertificateId
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificateId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificateDisplayName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String[]]
        $OdataTypes
    )
    $Certificate = Get-MgBetaDeviceManagementDeviceConfiguration `
        -DeviceConfigurationId $CertificateId `
        -ErrorAction SilentlyContinue | `
            Where-Object -FilterScript {
            $_.AdditionalProperties.'@odata.type' -in $OdataTypes
        }

    if ($null -eq $Certificate)
    {
        Write-Verbose -Message "Could not find certificate with Id {$CertificateId}, searching by display name {$CertificateDisplayName}"

        $Certificate = Get-MgBetaDeviceManagementDeviceConfiguration `
            -Filter "DisplayName eq '$($CertificateDisplayName -replace "'", "''")'" `
            -ErrorAction SilentlyContinue | `
                Where-Object -FilterScript {
                $_.AdditionalProperties.'@odata.type' -in $OdataTypes
            }

        if ($null -eq $Certificate)
        {
            throw "Could not find certificate with Id {$CertificateId} or display name {$CertificateDisplayName}"
        }

        $CertificateId = $Certificate.Id
        Write-Verbose -Message "Found certificate with Id {$($CertificateId)} and DisplayName {$($Certificate.DisplayName)}"
    }
    else
    {
        Write-Verbose -Message "Found certificate with Id {$CertificateId}"
    }

    return $CertificateId
}

Export-ModuleMember -Function *-TargetResource
