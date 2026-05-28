Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneDeviceConfigurationPkcsCertificatePolicyWindows10'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [ValidateSet('user', 'machine')]
        [System.String]
        $CertificateStore,

        [Parameter()]
        [System.String]
        $CertificateTemplateName,

        [Parameter()]
        [System.String]
        $CertificationAuthority,

        [Parameter()]
        [System.String]
        $CertificationAuthorityName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CustomSubjectAlternativeNames,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExtendedKeyUsages,

        [Parameter()]
        [System.String]
        $SubjectAlternativeNameFormatString,

        [Parameter()]
        [System.String]
        $SubjectNameFormatString,

        [Parameter()]
        [ValidateSet('days', 'months', 'years')]
        [System.String]
        $CertificateValidityPeriodScale,

        [Parameter()]
        [System.Int32]
        $CertificateValidityPeriodValue,

        [Parameter()]
        [ValidateSet('useTpmKspOtherwiseUseSoftwareKsp', 'useTpmKspOtherwiseFail', 'usePassportForWorkKspOtherwiseFail', 'useSoftwareKsp')]
        [System.String]
        $KeyStorageProvider,

        [Parameter()]
        [System.Int32]
        $RenewalThresholdPercentage,

        [Parameter()]
        [ValidateSet('none', 'emailAddress', 'userPrincipalName', 'customAzureADAttribute', 'domainNameService', 'universalResourceIdentifier')]
        [System.String]
        $SubjectAlternativeNameType,

        [Parameter()]
        [ValidateSet('commonName', 'commonNameIncludingEmail', 'commonNameAsEmail', 'custom', 'commonNameAsIMEI', 'commonNameAsSerialNumber', 'commonNameAsAadDeviceId', 'commonNameAsIntuneDeviceId', 'commonNameAsDurableDeviceId')]
        [System.String]
        $SubjectNameFormat,

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

    Write-Verbose -Message "Getting configuration of the Intune Device Configuration Pkcs Certificate Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

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
                Write-Verbose -Message "Could not find an Intune Device Configuration Pkcs Certificate Policy for Windows10 with Id {$Id}"

                if (-not [string]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
                        -All `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")' and isof('microsoft.graph.windows10PkcsCertificateProfile')" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Device Configuration Pkcs Certificate Policy for Windows10 with DisplayName {$DisplayName}"
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Configuration Pkcs Certificate Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexCustomSubjectAlternativeNames = @()
        foreach ($currentcustomSubjectAlternativeNames in $getValue.customSubjectAlternativeNames)
        {
            $mycustomSubjectAlternativeNames = [ordered]@{}
            $mycustomSubjectAlternativeNames.Add('Name', $currentcustomSubjectAlternativeNames.name)
            if ($null -ne $currentcustomSubjectAlternativeNames.sanType)
            {
                $mycustomSubjectAlternativeNames.Add('SanType', $currentcustomSubjectAlternativeNames.sanType.ToString())
            }
            if ($mycustomSubjectAlternativeNames.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexCustomSubjectAlternativeNames += $mycustomSubjectAlternativeNames
            }
        }

        $complexExtendedKeyUsages = @()
        foreach ($currentextendedKeyUsages in $getValue.extendedKeyUsages)
        {
            $myextendedKeyUsages = [ordered]@{}
            $myextendedKeyUsages.Add('Name', $currentextendedKeyUsages.name)
            $myextendedKeyUsages.Add('ObjectIdentifier', $currentextendedKeyUsages.objectIdentifier)
            if ($myextendedKeyUsages.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexExtendedKeyUsages += $myextendedKeyUsages
            }
        }
        #endregion

        #region resource generator code
        $enumCertificateStore = $null
        if ($null -ne $getValue.certificateStore)
        {
            $enumCertificateStore = $getValue.certificateStore.ToString()
        }

        $enumCertificateValidityPeriodScale = $null
        if ($null -ne $getValue.certificateValidityPeriodScale)
        {
            $enumCertificateValidityPeriodScale = $getValue.certificateValidityPeriodScale.ToString()
        }

        $enumKeyStorageProvider = $null
        if ($null -ne $getValue.keyStorageProvider)
        {
            $enumKeyStorageProvider = $getValue.keyStorageProvider.ToString()
        }

        $enumSubjectAlternativeNameType = $null
        if ($null -ne $getValue.subjectAlternativeNameType)
        {
            $enumSubjectAlternativeNameType = $getValue.subjectAlternativeNameType.ToString()
        }

        $enumSubjectNameFormat = $null
        if ($null -ne $getValue.subjectNameFormat)
        {
            $enumSubjectNameFormat = $getValue.subjectNameFormat.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            CertificateStore                   = $enumCertificateStore
            CertificateTemplateName            = $getValue.certificateTemplateName
            CertificationAuthority             = $getValue.certificationAuthority
            CertificationAuthorityName         = $getValue.certificationAuthorityName
            CustomSubjectAlternativeNames      = $complexCustomSubjectAlternativeNames
            ExtendedKeyUsages                  = $complexExtendedKeyUsages
            SubjectAlternativeNameFormatString = $getValue.subjectAlternativeNameFormatString
            SubjectNameFormatString            = $getValue.subjectNameFormatString
            CertificateValidityPeriodScale     = $enumCertificateValidityPeriodScale
            CertificateValidityPeriodValue     = $getValue.certificateValidityPeriodValue
            KeyStorageProvider                 = $enumKeyStorageProvider
            RenewalThresholdPercentage         = $getValue.renewalThresholdPercentage
            SubjectAlternativeNameType         = $enumSubjectAlternativeNameType
            SubjectNameFormat                  = $enumSubjectNameFormat
            Description                        = $getValue.Description
            DisplayName                        = $getValue.DisplayName
            Id                                 = $getValue.Id
            RoleScopeTagIds                    = $getValue.RoleScopeTagIds
            Ensure                             = 'Present'
            Credential                         = $Credential
            ApplicationId                      = $ApplicationId
            TenantId                           = $TenantId
            ApplicationSecret                  = $ApplicationSecret
            CertificateThumbprint              = $CertificateThumbprint
            CertificatePath                    = $CertificatePath
            CertificatePassword                = $CertificatePassword
            ManagedIdentity                    = $ManagedIdentity.IsPresent
            AccessTokens                       = $AccessTokens
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
        [ValidateSet('user', 'machine')]
        [System.String]
        $CertificateStore,

        [Parameter()]
        [System.String]
        $CertificateTemplateName,

        [Parameter()]
        [System.String]
        $CertificationAuthority,

        [Parameter()]
        [System.String]
        $CertificationAuthorityName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CustomSubjectAlternativeNames,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExtendedKeyUsages,

        [Parameter()]
        [System.String]
        $SubjectAlternativeNameFormatString,

        [Parameter()]
        [System.String]
        $SubjectNameFormatString,

        [Parameter()]
        [ValidateSet('days', 'months', 'years')]
        [System.String]
        $CertificateValidityPeriodScale,

        [Parameter()]
        [System.Int32]
        $CertificateValidityPeriodValue,

        [Parameter()]
        [ValidateSet('useTpmKspOtherwiseUseSoftwareKsp', 'useTpmKspOtherwiseFail', 'usePassportForWorkKspOtherwiseFail', 'useSoftwareKsp')]
        [System.String]
        $KeyStorageProvider,

        [Parameter()]
        [System.Int32]
        $RenewalThresholdPercentage,

        [Parameter()]
        [ValidateSet('none', 'emailAddress', 'userPrincipalName', 'customAzureADAttribute', 'domainNameService', 'universalResourceIdentifier')]
        [System.String]
        $SubjectAlternativeNameType,

        [Parameter()]
        [ValidateSet('commonName', 'commonNameIncludingEmail', 'commonNameAsEmail', 'custom', 'commonNameAsIMEI', 'commonNameAsSerialNumber', 'commonNameAsAadDeviceId', 'commonNameAsIntuneDeviceId', 'commonNameAsDurableDeviceId')]
        [System.String]
        $SubjectNameFormat,

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
        Write-Verbose -Message "Creating an Intune Device Configuration Pkcs Certificate Policy for Windows10 with DisplayName {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$BoundParameters).Clone()
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('Id') | Out-Null

        #region resource generator code
        $CreateParameters.Add('@odata.type', '#microsoft.graph.windows10PkcsCertificateProfile')
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
        Write-Verbose -Message "Updating the Intune Device Configuration Pkcs Certificate Policy for Windows10 with Id {$($currentInstance.Id)}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $updateParameters = ([Hashtable]$boundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters
        $updateParameters.Remove('Id') | Out-Null

        #region resource generator code
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.windows10PkcsCertificateProfile')
        Update-MgBetaDeviceManagementDeviceConfiguration `
            -DeviceConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceConfigurations'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Device Configuration Pkcs Certificate Policy for Windows10 with Id {$($currentInstance.Id)}"
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
        [ValidateSet('user', 'machine')]
        [System.String]
        $CertificateStore,

        [Parameter()]
        [System.String]
        $CertificateTemplateName,

        [Parameter()]
        [System.String]
        $CertificationAuthority,

        [Parameter()]
        [System.String]
        $CertificationAuthorityName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CustomSubjectAlternativeNames,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExtendedKeyUsages,

        [Parameter()]
        [System.String]
        $SubjectAlternativeNameFormatString,

        [Parameter()]
        [System.String]
        $SubjectNameFormatString,

        [Parameter()]
        [ValidateSet('days', 'months', 'years')]
        [System.String]
        $CertificateValidityPeriodScale,

        [Parameter()]
        [System.Int32]
        $CertificateValidityPeriodValue,

        [Parameter()]
        [ValidateSet('useTpmKspOtherwiseUseSoftwareKsp', 'useTpmKspOtherwiseFail', 'usePassportForWorkKspOtherwiseFail', 'useSoftwareKsp')]
        [System.String]
        $KeyStorageProvider,

        [Parameter()]
        [System.Int32]
        $RenewalThresholdPercentage,

        [Parameter()]
        [ValidateSet('none', 'emailAddress', 'userPrincipalName', 'customAzureADAttribute', 'domainNameService', 'universalResourceIdentifier')]
        [System.String]
        $SubjectAlternativeNameType,

        [Parameter()]
        [ValidateSet('commonName', 'commonNameIncludingEmail', 'commonNameAsEmail', 'custom', 'commonNameAsIMEI', 'commonNameAsSerialNumber', 'commonNameAsAadDeviceId', 'commonNameAsIntuneDeviceId', 'commonNameAsDurableDeviceId')]
        [System.String]
        $SubjectNameFormat,

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
        $baseFilter = "isof('microsoft.graph.windows10PkcsCertificateProfile')"
        if (-not [string]::IsNullOrEmpty($Filter))
        {
            $Filter = "($baseFilter) and ($Filter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter $Filter -All -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
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
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            if ($null -ne $Results.CustomSubjectAlternativeNames)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.CustomSubjectAlternativeNames `
                    -CIMInstanceName 'MicrosoftGraphcustomSubjectAlternativeName'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.CustomSubjectAlternativeNames = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('CustomSubjectAlternativeNames') | Out-Null
                }
            }
            if ($null -ne $Results.ExtendedKeyUsages)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ExtendedKeyUsages `
                    -CIMInstanceName 'MicrosoftGraphextendedKeyUsage'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ExtendedKeyUsages = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ExtendedKeyUsages') | Out-Null
                }
            }
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
                -NoEscape @('CustomSubjectAlternativeNames', 'ExtendedKeyUsages', 'Assignments')
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent.ToString()
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
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

Export-ModuleMember -Function *-TargetResource
