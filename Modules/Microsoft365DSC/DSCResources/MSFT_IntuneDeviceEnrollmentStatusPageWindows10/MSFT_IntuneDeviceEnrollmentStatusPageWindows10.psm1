function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AllowDeviceResetOnInstallFailure,

        [Parameter()]
        [System.Boolean]
        $AllowDeviceUseOnInstallFailure,

        [Parameter()]
        [System.Boolean]
        $AllowLogCollectionOnInstallFailure,

        [Parameter()]
        [System.Boolean]
        $AllowNonBlockingAppInstallation,

        [Parameter()]
        [System.Boolean]
        $BlockDeviceSetupRetryByUser,

        [Parameter()]
        [System.String]
        $CustomErrorMessage,

        [Parameter()]
        [System.Boolean]
        $DisableUserStatusTrackingAfterFirstUser,

        [Parameter()]
        [System.Int32]
        $InstallProgressTimeoutInMinutes,

        [Parameter()]
        [System.Boolean]
        $InstallQualityUpdates,

        [Parameter()]
        [System.String[]]
        $SelectedMobileAppIds,

        [Parameter()]
        [System.Boolean]
        $ShowInstallationProgress,

        [Parameter()]
        [System.Boolean]
        $TrackInstallProgressForAutopilotOnly,
        #endregion

        [Parameter()]
        [System.Uint32]
        $Priority,

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
        $getValue = Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration -DeviceEnrollmentConfigurationId $Id -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Enrollment Configuration for Windows10 with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration `
                    -Filter "DisplayName eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue | Where-Object `
                    -FilterScript { `
                        $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10EnrollmentCompletionPageConfiguration' `
                }
            }
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Enrollment Configuration for Windows10 with DisplayName {$DisplayName}"
            return $nullResult
        }

        if($getValue -is [Array])
        {
            Throw "The DisplayName {$DisplayName} returned multiple policies, make sure DisplayName is unique."
        }

        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Enrollment Configuration for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        $results = @{
            #region resource generator code
            AllowDeviceResetOnInstallFailure        = $getValue.AdditionalProperties.allowDeviceResetOnInstallFailure
            AllowDeviceUseOnInstallFailure          = $getValue.AdditionalProperties.allowDeviceUseOnInstallFailure
            AllowLogCollectionOnInstallFailure      = $getValue.AdditionalProperties.allowLogCollectionOnInstallFailure
            AllowNonBlockingAppInstallation         = $getValue.AdditionalProperties.allowNonBlockingAppInstallation
            BlockDeviceSetupRetryByUser             = $getValue.AdditionalProperties.blockDeviceSetupRetryByUser
            CustomErrorMessage                      = $getValue.AdditionalProperties.customErrorMessage
            DisableUserStatusTrackingAfterFirstUser = $getValue.AdditionalProperties.disableUserStatusTrackingAfterFirstUser
            InstallProgressTimeoutInMinutes         = $getValue.AdditionalProperties.installProgressTimeoutInMinutes
            InstallQualityUpdates                   = $getValue.AdditionalProperties.installQualityUpdates
            SelectedMobileAppIds                    = $getValue.AdditionalProperties.selectedMobileAppIds
            ShowInstallationProgress                = $getValue.AdditionalProperties.showInstallationProgress
            TrackInstallProgressForAutopilotOnly    = $getValue.AdditionalProperties.trackInstallProgressForAutopilotOnly
            Priority                                = $getValue.Priority
            Description                             = $getValue.Description
            DisplayName                             = $getValue.DisplayName
            Id                                      = $getValue.Id
            Ensure                                  = 'Present'
            Credential                              = $Credential
            ApplicationId                           = $ApplicationId
            TenantId                                = $TenantId
            ApplicationSecret                       = $ApplicationSecret
            CertificateThumbprint                   = $CertificateThumbprint
            Managedidentity                         = $ManagedIdentity.IsPresent
            #endregion
        }
        $assignmentsValues = Get-MgBetaDeviceManagementDeviceEnrollmentConfigurationAssignment -DeviceEnrollmentConfigurationId $Id
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AllowDeviceResetOnInstallFailure,

        [Parameter()]
        [System.Boolean]
        $AllowDeviceUseOnInstallFailure,

        [Parameter()]
        [System.Boolean]
        $AllowLogCollectionOnInstallFailure,

        [Parameter()]
        [System.Boolean]
        $AllowNonBlockingAppInstallation,

        [Parameter()]
        [System.Boolean]
        $BlockDeviceSetupRetryByUser,

        [Parameter()]
        [System.String]
        $CustomErrorMessage,

        [Parameter()]
        [System.Boolean]
        $DisableUserStatusTrackingAfterFirstUser,

        [Parameter()]
        [System.Int32]
        $InstallProgressTimeoutInMinutes,

        [Parameter()]
        [System.Boolean]
        $InstallQualityUpdates,

        [Parameter()]
        [System.String[]]
        $SelectedMobileAppIds,

        [Parameter()]
        [System.Boolean]
        $ShowInstallationProgress,

        [Parameter()]
        [System.Boolean]
        $TrackInstallProgressForAutopilotOnly,
        #endregion

        [Parameter()]
        [System.Uint32]
        $Priority,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters
    $PSBoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Enrollment Configuration for Windows10 with DisplayName {$DisplayName}"

        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null
        $CreateParameters.Remove('Assignments') | Out-Null
        $CreateParameters.Remove('Priority') | Out-Null

        #region resource generator code
        if ($CreateParameters.showInstallationProgress -eq $false)
        {
            $CreateParameters.blockDeviceSetupRetryByUser = $true
            $CreateParameters.Remove('allowLogCollectionOnInstallFailure') | Out-Null
            $CreateParameters.Remove('allowNonBlockingAppInstallation') | Out-Null
            $CreateParameters.Remove('customErrorMessage') | Out-Null
            $CreateParameters.Remove('disableUserStatusTrackingAfterFirstUser') | Out-Null
            $CreateParameters.Remove('installProgressTimeoutInMinutes') | Out-Null
            $CreateParameters.Remove('installQualityUpdates') | Out-Null
            $CreateParameters.Remove('trackInstallProgressForAutopilotOnly') | Out-Null
        }

        if ($CreateParameters.blockDeviceSetupRetryByUser -eq $true)
        {
            $CreateParameters.Remove('allowDeviceUseOnInstallFailure') | Out-Null
            $CreateParameters.Remove('allowDeviceResetOnInstallFailure') | Out-Null
            $CreateParameters.Remove('selectedMobileAppIds') | Out-Null
        }

        $CreateParameters.Add('@odata.type', '#microsoft.graph.windows10EnrollmentCompletionPageConfiguration')
        $policy = New-MgBetaDeviceManagementDeviceEnrollmentConfiguration -BodyParameter $CreateParameters

        $intuneAssignments = @()
        if($null -ne $Assignments -and $Assignments.count -gt 0)
        {
            $intuneAssignments += ConvertTo-IntunePolicyAssignment -Assignments $Assignments
        }
        $body = @{'enrollmentConfigurationAssignments' = $intuneAssignments} | ConvertTo-Json -Depth 100
        $Uri = "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations/$($policy.Id)/assign"
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop

        Update-DeviceEnrollmentConfigurationPriority `
            -DeviceEnrollmentConfigurationId $policy.id `
            -Priority $Priority
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Device Enrollment Configuration for Windows10 with Id {$($currentInstance.Id)}"

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters
        $UpdateParameters.Remove('Assignments') | Out-Null
        $UpdateParameters.Remove('Priority') | Out-Null

        #region resource generator code
        if ($UpdateParameters.blockDeviceSetupRetryByUser -eq $true)
        {
            $UpdateParameters.Remove('allowDeviceUseOnInstallFailure') | Out-Null
            $UpdateParameters.Remove('allowDeviceResetOnInstallFailure') | Out-Null
            $UpdateParameters.Remove('selectedMobileAppIds') | Out-Null
        }

        $UpdateParameters.Add('@odata.type', '#microsoft.graph.windows10EnrollmentCompletionPageConfiguration')
        Update-MgBetaDeviceManagementDeviceEnrollmentConfiguration `
            -DeviceEnrollmentConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters

        if ($currentInstance.Id -notlike '*_DefaultWindows10EnrollmentCompletionPageConfiguration')
        {
            $intuneAssignments = @()
            if($null -ne $Assignments -and $Assignments.count -gt 0)
            {
                $intuneAssignments += ConvertTo-IntunePolicyAssignment -Assignments $Assignments
            }
            $body = @{'enrollmentConfigurationAssignments' = $intuneAssignments} | ConvertTo-Json -Depth 100
            $Uri = "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations/$($currentInstance.Id)/assign"
            Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop

            Update-DeviceEnrollmentConfigurationPriority `
                -DeviceEnrollmentConfigurationId $currentInstance.id `
                -Priority $Priority
        }
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Device Enrollment Configuration for Windows10 with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceManagementDeviceEnrollmentConfiguration -DeviceEnrollmentConfigurationId $currentInstance.Id
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AllowDeviceResetOnInstallFailure,

        [Parameter()]
        [System.Boolean]
        $AllowDeviceUseOnInstallFailure,

        [Parameter()]
        [System.Boolean]
        $AllowLogCollectionOnInstallFailure,

        [Parameter()]
        [System.Boolean]
        $AllowNonBlockingAppInstallation,

        [Parameter()]
        [System.Boolean]
        $BlockDeviceSetupRetryByUser,

        [Parameter()]
        [System.String]
        $CustomErrorMessage,

        [Parameter()]
        [System.Boolean]
        $DisableUserStatusTrackingAfterFirstUser,

        [Parameter()]
        [System.Int32]
        $InstallProgressTimeoutInMinutes,

        [Parameter()]
        [System.Boolean]
        $InstallQualityUpdates,

        [Parameter()]
        [System.String[]]
        $SelectedMobileAppIds,

        [Parameter()]
        [System.Boolean]
        $ShowInstallationProgress,

        [Parameter()]
        [System.Boolean]
        $TrackInstallProgressForAutopilotOnly,
        #endregion

        [Parameter()]
        [System.Uint32]
        $Priority,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of the Intune Device Enrollment Configuration for Windows10 with Id {$Id} and DisplayName {$DisplayName}"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck
    $ValuesToCheck.Remove('Id') | Out-Null

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

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $ValuesToCheck.Remove('Id') | Out-Null

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
        [array]$getValue = Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration `
            -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10EnrollmentCompletionPageConfiguration' `
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
                DisplayName           = $config.displayName
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

            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
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

function Update-DeviceEnrollmentConfigurationPriority
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceEnrollmentConfigurationId,

        [Parameter(Mandatory = 'true')]
        [System.UInt32]
        $Priority
    )
    try
    {
        $Uri = "https://graph.microsoft.com/beta/deviceManagement/deviceEnrollmentConfigurations/$DeviceEnrollmentConfigurationId/setpriority"
        $body = @{'priority' = $Priority } | ConvertTo-Json -Depth 100
        #write-verbose -Message $body
        Invoke-MgGraphRequest `
            -Method POST `
            -Body $body `
            -Uri $Uri  `
            -ErrorAction Stop 4> Out-Null
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $null
    }
}

Export-ModuleMember -Function *-TargetResource
