function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('singlePlatformRestriction', 'platformRestrictions')]
        [System.String]
        $DeviceEnrollmentConfigurationType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $IosRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsHomeSkuRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsMobileRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AndroidRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AndroidForWorkRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MacRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MacOSRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
    Write-Verbose -Message "Checking for the Intune Device Enrollment Restriction {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        $config = Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration -DeviceEnrollmentConfigurationId $Identity -ErrorAction silentlyContinue

        if ($null -eq $config)
        {
            Write-Verbose -Message "No Device Enrollment Platform Restriction {$Identity} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found Device Enrollment Platform Restriction with Name {$($config.DisplayName)}"
        $results = @{
            Identity                          = $config.Id
            DisplayName                       = $config.DisplayName
            Description                       = $config.Description
            DeviceEnrollmentConfigurationType = $config.DeviceEnrollmentConfigurationType.toString()
            Ensure                            = 'Present'
            Credential                        = $Credential
            ApplicationId                     = $ApplicationId
            TenantId                          = $TenantId
            ApplicationSecret                 = $ApplicationSecret
            CertificateThumbprint             = $CertificateThumbprint
            Managedidentity                   = $ManagedIdentity.IsPresent
        }

        $results += Get-DevicePlatformRestrictionSetting -Properties $config.AdditionalProperties

        if ($null -ne $results.WindowsMobileRestriction)
        {
            $results.Remove('WindowsMobileRestriction') | Out-Null
        }

        $AssignmentsValues = Get-MgBetaDeviceManagementDeviceEnrollmentConfigurationAssignment -DeviceEnrollmentConfigurationId $config.Id
        $assignmentResult = @()
        foreach ($assignmentEntry in $AssignmentsValues)
        {
            $assignmentValue = @{
                dataType                                   = $assignmentEntry.Target.AdditionalProperties.'@odata.type'
                deviceAndAppManagementAssignmentFilterType = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType.ToString()
                deviceAndAppManagementAssignmentFilterId   = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterId
                groupId                                    = $assignmentEntry.Target.AdditionalProperties.groupId
            }
            $assignmentResult += $assignmentValue
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
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('singlePlatformRestriction', 'platformRestrictions')]
        [System.String]
        $DeviceEnrollmentConfigurationType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $IosRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsHomeSkuRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsMobileRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AndroidRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AndroidForWorkRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MacRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MacOSRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

    $currentCategory = Get-TargetResource @PSBoundParameters
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('Verbose') | Out-Null
    $PSBoundParameters.Remove('Identity') | Out-Null

    if ($Ensure -eq 'Present' -and $currentCategory.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Device Enrollment Platform Restriction {$DisplayName}"

        $PSBoundParameters.Remove('Assignments') | Out-Null

        if ($PSBoundParameters.Keys.Contains('WindowsMobileRestriction'))
        {
            if ($WindowsMobileRestriction.platformBlocked -eq $false)
            {
                Write-Verbose -Message 'Windows Mobile platform is deprecated and cannot be unblocked, reverting back to blocked'

                $WindowsMobileRestriction.platformBlocked = $true
            }
        }

        $keys = (([Hashtable]$PSBoundParameters).clone()).Keys
        foreach ($key in $keys)
        {
            $keyName = $key.substring(0, 1).toLower() + $key.substring(1, $key.length - 1)
            $keyValue = $PSBoundParameters.$key
            if ($null -ne $PSBoundParameters.$key -and $PSBoundParameters.$key.getType().Name -like '*cimInstance*')
            {
                $keyValue = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $PSBoundParameters.$key
                if ($DeviceEnrollmentConfigurationType -eq 'singlePlatformRestriction' )
                {
                    $keyName = 'platformRestriction'
                    $PSBoundParameters.add('platformType', ($key.replace('Restriction', '')))
                }
            }
            $PSBoundParameters.remove($key)
            $PSBoundParameters.add($keyName, $keyValue)
        }

        $policyType = '#microsoft.graph.deviceEnrollmentPlatformRestrictionConfiguration'
        if ($DeviceEnrollmentConfigurationType -eq 'platformRestrictions' )
        {
            $policyType = '#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration'
            $PSBoundParameters.add('deviceEnrollmentConfigurationType ', 'limit')
        }
        $PSBoundParameters.add('@odata.type', $policyType)

        Write-Verbose ($PSBoundParameters | ConvertTo-Json -Depth 20)

        $policy = New-MgBetaDeviceManagementDeviceEnrollmentConfiguration `
            -BodyParameter $PSBoundParameters

        #Assignments from DefaultPolicy are not editable and will raise an alert
        if ($policy.Id -notlike '*_DefaultPlatformRestrictions')
        {
            if ($null -ne $Assignments -and $Assignments -ne @())
            {
                $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments

                Update-DeviceConfigurationPolicyAssignments `
                    -DeviceConfigurationPolicyId $policy.Id `
                    -Targets $assignmentsHash
            }
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentCategory.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Device Enrollment Platform Restriction {$DisplayName}"

        $PSBoundParameters.Remove('Assignments') | Out-Null

        if ($PSBoundParameters.Keys.Contains('WindowsMobileRestriction'))
        {
            if ($WindowsMobileRestriction.platformBlocked -eq $false)
            {
                Write-Verbose -Message 'Windows Mobile platform is deprecated and cannot be unblocked, reverting back to blocked'

                $WindowsMobileRestriction.platformBlocked = $true
            }
        }

        $keys = (([Hashtable]$PSBoundParameters).clone()).Keys
        foreach ($key in $keys)
        {
            $keyName = $key.substring(0, 1).toLower() + $key.substring(1, $key.length - 1)
            $keyValue = $PSBoundParameters.$key
            if ($null -ne $PSBoundParameters.$key -and $PSBoundParameters.$key.getType().Name -like '*cimInstance*')
            {
                $keyValue = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $PSBoundParameters.$key
                if ($DeviceEnrollmentConfigurationType -eq 'singlePlatformRestriction' )
                {
                    $keyName = 'platformRestriction'
                }
            }
            $PSBoundParameters.remove($key)
            $PSBoundParameters.add($keyName, $keyValue)
        }

        $policyType = '#microsoft.graph.deviceEnrollmentPlatformRestrictionConfiguration'
        if ($DeviceEnrollmentConfigurationType -eq 'platformRestrictions' )
        {
            $policyType = '#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration'
        }
        $PSBoundParameters.add('@odata.type', $policyType)
        Write-Verbose ($PSBoundParameters | ConvertTo-Json -Depth 20)
        Update-MgBetaDeviceManagementDeviceEnrollmentConfiguration `
            -BodyParameter $PSBoundParameters `
            -DeviceEnrollmentConfigurationId $Identity

        #Assignments from DefaultPolicy are not editable and will raise an alert
        if ($Identity -notlike '*_DefaultPlatformRestrictions')
        {
            if ($null -ne $Assignments -and $Assignments -ne @())
            {
                $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments

                Update-DeviceConfigurationPolicyAssignments `
                    -DeviceConfigurationPolicyId $Identity `
                    -Targets $assignmentsHash
            }
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentCategory.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Device Enrollment Platform Restriction {$DisplayName}"
        $config = Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration -Filter "displayName eq '$DisplayName'" `
        | Where-Object -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration' }

        Remove-MgBetaDeviceManagementDeviceEnrollmentConfiguration -DeviceEnrollmentConfigurationId $config.id
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('singlePlatformRestriction', 'platformRestrictions')]
        [System.String]
        $DeviceEnrollmentConfigurationType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $IosRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsHomeSkuRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WindowsMobileRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AndroidRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AndroidForWorkRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MacRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MacOSRestriction,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Write-Verbose -Message "Testing configuration of Device Enrollment Platform Restriction {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -eq 'Absent')
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
        if ($source.getType().Name -like '*CimInstance*' -and $key -ne 'WindowsMobileRestriction')
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
    $ValuesToCheck.Remove('WindowsMobileRestriction') | Out-Null

    #Convert any DateTime to String
    foreach ($key in $ValuesToCheck.Keys)
    {
        if (($null -ne $CurrentValues[$key]) `
                -and ($CurrentValues[$key].getType().Name -eq 'DateTime'))
        {
            $CurrentValues[$key] = $CurrentValues[$key].toString()
        }
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"
    #Compare basic parameters
    if ($testResult)
    {
        Write-Verbose -Message "Comparing the current values with the desired ones"
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

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
        $ManagedIdentity
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
        [array]$configs = Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration -All:$true -Filter $Filter -ErrorAction Stop `
        | Where-Object -FilterScript { $_.AdditionalProperties.'@odata.type' -like '#microsoft.graph.deviceEnrollmentPlatform*Configuration' }

        $i = 1
        $dscContent = ''
        if ($configs.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $configs)
        {
            Write-Host "    |---[$i/$($configs.Count)] $($config.displayName)" -NoNewline
            $params = @{
                Identity              = $config.id
                DisplayName           = $config.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
            }
            $Results = Get-TargetResource @Params

            if ($null -ne $Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ([Array]$Results.Assignments) -CIMInstanceName DeviceManagementConfigurationPolicyAssignments
                if ($complexTypeStringResult)
                {
                    $Results.Assignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Assignments') | Out-Null
                }
            }

            if ($null -ne $Results.IosRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.IosRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.IosRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('IosRestriction') | Out-Null
                }
            }

            if ($null -ne $Results.WindowsRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.WindowsRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.WindowsRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('WindowsRestriction') | Out-Null
                }
            }

            if ($null -ne $Results.WindowsHomeSkuRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.WindowsHomeSkuRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.WindowsHomeSkuRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('WindowsHomeSkuRestriction') | Out-Null
                }
            }
            if ($null -ne $Results.WindowsMobileRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.WindowsMobileRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.WindowsMobileRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('WindowsMobileRestriction') | Out-Null
                }
            }

            if ($null -ne $Results.AndroidRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.AndroidRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.AndroidRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AndroidRestriction') | Out-Null
                }
            }

            if ($null -ne $Results.AndroidForWorkRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.AndroidForWorkRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.AndroidForWorkRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AndroidForWorkRestriction') | Out-Null
                }
            }

            if ($null -ne $Results.MacRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.MacRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.MacRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MacRestriction') | Out-Null
                }
            }

            if ($null -ne $Results.MacOSRestriction)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ($Results.MacOSRestriction) -CIMInstanceName DeviceEnrollmentPlatformRestriction
                if ($complexTypeStringResult)
                {
                    $Results.MacOSRestriction = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MacOSRestriction') | Out-Null
                }
            }


            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential


            if ($null -ne $Results.Assignments)
            {
                $isCIMArray = $false
                if ($Results.Assignments.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$isCIMArray
            }

            if ($null -ne $Results.IosRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'IosRestriction'
            }

            if ($null -ne $Results.WindowsRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'WindowsRestriction'
            }

            if ($null -ne $Results.WindowsHomeSkuRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'WindowsHomeSkuRestriction'
            }
            if ($null -ne $Results.WindowsMobileRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'WindowsMobileRestriction'
            }

            if ($null -ne $Results.AndroidRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'AndroidRestriction'
            }

            if ($null -ne $Results.AndroidForWorkRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'AndroidForWorkRestriction'
            }

            if ($null -ne $Results.MacRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'MacRestriction'
            }

            if ($null -ne $Results.MacOSRestriction)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'MacOSRestriction'
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

function Get-DevicePlatformRestrictionSetting
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{}

    if ($null -ne $Properties.platformType)
    {
        $keyName = ($Properties.platformType).Substring(0, 1).toUpper() + ($Properties.platformType).substring(1, $Properties.platformType.length - 1) + 'Restriction'
        $keyValue = [Hashtable]::new($Properties.platformRestriction)
        $hash = @{}
        foreach ($key in $keyValue.Keys)
        {
            if ($null -ne $keyValue.$key)
            {
                switch -Wildcard ($keyValue.$key.getType().name)
                {
                    '*[[\]]'
                    {
                        if ($keyValue.$key.count -gt 0)
                        {
                            $hash.add($key, $keyValue.$key)
                        }
                    }
                    'String'
                    {
                        if (-Not [String]::IsNullOrEmpty($keyValue.$key))
                        {
                            $hash.add($key, $keyValue.$key)
                        }
                    }
                    Default
                    {
                        $hash.add($key, $keyValue.$key)
                    }
                }
            }
        }
        $results.add($keyName, $hash)
    }
    else
    {
        $platformRestrictions = [Hashtable]::new($Properties)
        $platformRestrictions.remove('@odata.type')
        $platformRestrictions.remove('@odata.context')
        foreach ($key in $platformRestrictions.Keys)
        {
            $keyName = $key.Substring(0, 1).toUpper() + $key.substring(1, $key.length - 1)
            $keyValue = [Hashtable]::new($platformRestrictions.$key)
            $hash = @{}
            foreach ($key in $keyValue.Keys)
            {
                if ($null -ne $keyValue.$key)
                {
                    switch -Wildcard ($keyValue.$key.getType().name)
                    {
                        '*[[\]]'
                        {
                            if ($keyValue.$key.count -gt 0)
                            {
                                $hash.add($key, $keyValue.$key)
                            }
                        }
                        'String'
                        {
                            if (-Not [String]::IsNullOrEmpty($keyValue.$key))
                            {
                                $hash.add($key, $keyValue.$key)
                            }
                        }
                        Default
                        {
                            $hash.add($key, $keyValue.$key)
                        }
                    }

                }
            }
            $results.add($keyName, $hash)
        }
    }

    return $results
}

function Update-DeviceConfigurationPolicyAssignments
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter()]
        [Array]
        $Targets
    )
    try
    {
        $configurationPolicyAssignments = @()

        $Uri = "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations/$DeviceConfigurationPolicyId/assign"

        foreach ($target in $targets)
        {
            $formattedTarget = @{'@odata.type' = $target.dataType }
            if ($target.groupId)
            {
                $formattedTarget.Add('groupId', $target.groupId)
            }
            if ($target.collectionId)
            {
                $formattedTarget.Add('collectionId', $target.collectionId)
            }
            if ($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType', $target.deviceAndAppManagementAssignmentFilterType)
            }
            if ($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId', $target.deviceAndAppManagementAssignmentFilterId)
            }
            $configurationPolicyAssignments += @{'target' = $formattedTarget }
        }
        $body = @{'enrollmentConfigurationAssignments' = $configurationPolicyAssignments } | ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
            $tenantIdValue = $Credential.UserName.Split('@')[1]
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $null
    }


}

function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable], [hashtable[]])]
    param(
        [Parameter()]
        $ComplexObject
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }


    if ($ComplexObject.getType().Fullname -like '*hashtable')
    {
        return $ComplexObject
    }
    if ($ComplexObject.getType().Fullname -like '*hashtable[[\]]')
    {
        return , [hashtable[]]$ComplexObject
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

    $results = @{}
    $keys = $ComplexObject | Get-Member | Where-Object -FilterScript { $_.MemberType -eq 'Property' -and $_.Name -ne 'AdditionalProperties' }

    foreach ($key in $keys)
    {

        if ($null -ne $ComplexObject.$($key.Name))
        {
            $keyName = $key.Name[0].ToString().ToLower() + $key.Name.Substring(1, $key.Name.Length - 1)

            if ($ComplexObject.$($key.Name).gettype().fullname -like '*CimInstance*')
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$($key.Name)

                $results.Add($keyName, $hash)
            }
            else
            {
                $results.Add($keyName, $ComplexObject.$($key.Name))
            }
        }
    }

    return [hashtable]$results
}

function Get-M365DSCDRGComplexTypeToString
{
    [CmdletBinding()]
    #[OutputType([System.String])]
    param(
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
        [switch]
        $isArray = $false
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    #If ComplexObject  is an Array
    if ($ComplexObject.GetType().FullName -like '*[[\]]')
    {
        $currentProperty = @()
        foreach ($item in $ComplexObject)
        {
            $split = @{
                'ComplexObject'   = $item
                'CIMInstanceName' = $CIMInstanceName
                'Whitespace'      = "                $whitespace"
            }
            if ($ComplexTypeMapping)
            {
                $split.add('ComplexTypeMapping', $ComplexTypeMapping)
            }

            $currentProperty += Get-M365DSCDRGComplexTypeToString -isArray:$true @split

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
    }
    $currentProperty += "$whitespace`MSFT_$CIMInstanceName{`r`n"
    $keyNotNull = 0
    foreach ($key in $ComplexObject.Keys)
    {
        if ($null -ne $ComplexObject.$key)
        {
            $keyNotNull++
            if ($ComplexObject.$key.GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*' -or $key -in $ComplexTypeMapping.Name)
            {
                $hashPropertyType = $ComplexObject[$key].GetType().Name.tolower()

                #overwrite type if object defined in mapping complextypemapping
                if ($key -in $ComplexTypeMapping.Name)
                {
                    $hashPropertyType = ($ComplexTypeMapping | Where-Object -FilterScript { $_.Name -eq $key }).CimInstanceName
                    $hashProperty = $ComplexObject[$key]
                }
                else
                {
                    $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                }

                if ($key -notin $ComplexTypeMapping.Name)
                {
                    $Whitespace += '            '
                }

                if (-not $isArray -or ($isArray -and $key -in $ComplexTypeMapping.Name ))
                {
                    $currentProperty += $whitespace + $key + ' = '
                    if ($ComplexObject[$key].GetType().FullName -like '*[[\]]')
                    {
                        $currentProperty += '@('
                    }
                }

                if ($key -in $ComplexTypeMapping.Name)
                {
                    $Whitespace = ''

                }
                $currentProperty += Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $hashProperty `
                    -CIMInstanceName $hashPropertyType `
                    -Whitespace $Whitespace `
                    -ComplexTypeMapping $ComplexTypeMapping

                if ($ComplexObject.$key.GetType().FullName -like '*[[\]]')
                {
                    $currentProperty += ')'
                }
            }
            else
            {
                if (-not $isArray)
                {
                    $Whitespace = '            '
                }
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key] -Space ($Whitespace + '    ')
            }
        }
        else
        {
            $mappedKey = $ComplexTypeMapping | Where-Object -FilterScript { $_.name -eq $key }

            if ($mappedKey -and $mappedKey.isRequired)
            {
                if ($mappedKey.isArray)
                {
                    $currentProperty += "$Whitespace    $key = @()`r`n"
                }
                else
                {
                    $currentProperty += "$Whitespace    $key = `$null`r`n"
                }
            }
        }
    }
    $currentProperty += "$Whitespace}"

    return $currentProperty
}

Function Get-M365DSCDRGSimpleObjectTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
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
            foreach ($item in $Value)
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
    param(
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

        $i = 0
        foreach ($item in $Source)
        {

            $compareResult = Compare-M365DSCComplexObject `
                -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source[$i]) `
                -Target $Target[$i]

            if (-not $compareResult)
            {
                Write-Verbose -Message 'Configuration drift - The complex array items are not identical'
                return $false
            }
            $i++
        }
        return $true
    }

    $keys = $Source.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    foreach ($key in $keys)
    {
        #write-verbose -message "Comparing key: {$key}"
        #Matching possible key names between Source and Target
        $skey = $key
        $tkey = $key
        if ($key -eq 'odataType')
        {
            $skey = '@odata.type'
        }
        else
        {
            $tmpkey = $Target.keys | Where-Object -FilterScript { $_ -eq "$key" }
            if ($tkey)
            {
                $tkey = $tmpkey | Select-Object -First 1
            }
        }

        $sourceValue = $Source.$key
        $targetValue = $Target.$tkey
        #One of the item is null and not the other
        if (($null -eq $Source.$skey) -xor ($null -eq $Target.$tkey))
        {

            if ($null -eq $Source.$skey)
            {
                $sourceValue = 'null'
            }

            if ($null -eq $Target.$tkey)
            {
                $targetValue = 'null'
            }

            Write-Verbose -Message "Configuration drift - key: $key Source {$sourceValue} Target {$targetValue}"
            return $false
        }

        #Both keys aren't null or empty
        if (($null -ne $Source.$skey) -and ($null -ne $Target.$tkey))
        {
            if ($Source.$skey.getType().FullName -like '*CimInstance*' -or $Source.$skey.getType().FullName -like '*hashtable*'  )
            {
                #Recursive call for complex object
                $compareResult = Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source.$skey) `
                    -Target $Target.$tkey

                if (-not $compareResult)
                {

                    Write-Verbose -Message "Configuration drift - complex object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject = $Target.$tkey
                $differenceObject = $Source.$skey

                $compareResult = Compare-Object `
                    -ReferenceObject ($referenceObject) `
                    -DifferenceObject ($differenceObject)

                if ($null -ne $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - simple object key: $key Source {$sourceValue} Target {$targetValue}"
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
    param(
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
