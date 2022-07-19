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
        $Description,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Boolean]
        $PasswordRequiredToUnlockFromIdle,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault', 'Alphanumeric', 'Numeric')]
        $PasswordRequiredType,

        [Parameter()]
        [System.Boolean]
        $RequireHealthyDeviceReport,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMinimumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $EarlyLaunchAntiMalwareDriverEnabled,

        [Parameter()]
        [System.Boolean]
        $BitLockerEnabled,

        [Parameter()]
        [System.Boolean]
        $SecureBootEnabled,

        [Parameter()]
        [System.Boolean]
        $CodeIntegrityEnabled,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $ActiveFirewallRequired,

        [Parameter()]
        [System.Boolean]
        $DefenderEnabled,

        [Parameter()]
        [System.String]
        $DefenderVersion,

        [Parameter()]
        [System.Boolean]
        $SignatureOutOfDate,

        [Parameter()]
        [System.Boolean]
        $RtpEnabled,

        [Parameter()]
        [System.Boolean]
        $AntivirusRequired,

        [Parameter()]
        [System.Boolean]
        $AntiSpywareRequired,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ConfigurationManagerComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $TPMRequired,

        [Parameter()]
        [System.String]
        $DeviceCompliancePolicyScript,

        [Parameter()]
        [System.Array]
        $ValidOperatingSystemBuildRanges,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Checking for the Intune Device Compliance Windows 10 Policy {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters
    Select-MgProfile -Name beta

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'
    try
    {
        $devicePolicy = Get-MGDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10CompliancePolicy' -and `
            $_.displayName -eq $($DisplayName) }

        if ($null -eq $devicePolicy)
        {
            Write-Verbose -Message "No Windows 10 Device Compliance Policy with displayName {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found Windows 10 Device Compliance Policy with displayName {$DisplayName}"
        $results = @{
            DisplayName                                 = $devicePolicy.DisplayName
            Description                                 = $devicePolicy.Description
            PasswordRequired                            = $devicePolicy.AdditionalProperties.passwordRequired
            PasswordBlockSimple                         = $devicePolicy.AdditionalProperties.passwordBlockSimple
            PasswordRequiredToUnlockFromIdle            = $devicePolicy.AdditionalProperties.passwordRequiredToUnlockFromIdle
            PasswordMinutesOfInactivityBeforeLock       = $devicePolicy.AdditionalProperties.passwordMinutesOfInactivityBeforeLock
            PasswordExpirationDays                      = $devicePolicy.AdditionalProperties.passwordExpirationDays
            PasswordMinimumLength                       = $devicePolicy.AdditionalProperties.passwordMinimumLength
            PasswordMinimumCharacterSetCount            = $devicePolicy.AdditionalProperties.passwordMinimumCharacterSetCount
            PasswordRequiredType                        = $devicePolicy.AdditionalProperties.passwordRequiredType
            PasswordPreviousPasswordBlockCount          = $devicePolicy.AdditionalProperties.passwordPreviousPasswordBlockCount
            RequireHealthyDeviceReport                  = $devicePolicy.AdditionalProperties.requireHealthyDeviceReport
            OsMinimumVersion                            = $devicePolicy.AdditionalProperties.osMinimumVersion
            OsMaximumVersion                            = $devicePolicy.AdditionalProperties.osMaximumVersion
            MobileOsMinimumVersion                      = $devicePolicy.AdditionalProperties.mobileOsMinimumVersion
            MobileOsMaximumVersion                      = $devicePolicy.AdditionalProperties.mobileOsMaximumVersion
            EarlyLaunchAntiMalwareDriverEnabled         = $devicePolicy.AdditionalProperties.earlyLaunchAntiMalwareDriverEnabled
            BitLockerEnabled                            = $devicePolicy.AdditionalProperties.bitLockerEnabled
            SecureBootEnabled                           = $devicePolicy.AdditionalProperties.secureBootEnabled
            CodeIntegrityEnabled                        = $devicePolicy.AdditionalProperties.codeIntegrityEnabled
            StorageRequireEncryption                    = $devicePolicy.AdditionalProperties.storageRequireEncryption
            ActiveFirewallRequired                      = $devicePolicy.AdditionalProperties.activeFirewallRequired
            DefenderEnabled                             = $devicePolicy.AdditionalProperties.defenderEnabled
            DefenderVersion                             = $devicePolicy.AdditionalProperties.defenderVersion
            SignatureOutOfDate                          = $devicePolicy.AdditionalProperties.signatureOutOfDate
            RTPEnabled                                  = $devicePolicy.AdditionalProperties.rtpEnabled
            AntivirusRequired                           = $devicePolicy.AdditionalProperties.antivirusRequired
            AntiSpywareRequired                         = $devicePolicy.AdditionalProperties.antiSpywareRequired
            DeviceThreatProtectionEnabled               = $devicePolicy.AdditionalProperties.deviceThreatProtectionEnabled
            DeviceThreatProtectionRequiredSecurityLevel = $devicePolicy.AdditionalProperties.deviceThreatProtectionRequiredSecurityLevel
            ConfigurationManagerComplianceRequired      = $devicePolicy.AdditionalProperties.configurationManagerComplianceRequired
            TPMRequired                                 = $devicePolicy.AdditionalProperties.tPMRequired
            DeviceCompliancePolicyScript                = $devicePolicy.AdditionalProperties.deviceCompliancePolicyScript
            ValidOperatingSystemBuildRanges             = $devicePolicy.AdditionalProperties.validOperatingSystemBuildRanges
            Ensure                                      = 'Present'
            Credential                                  = $Credential
            ApplicationId                               = $ApplicationId
            TenantId                                    = $TenantId
            ApplicationSecret                           = $ApplicationSecret
            CertificateThumbprint                       = $CertificateThumbprint
        }

        $myAssignments=@()
        $myAssignments+=Get-MgDeviceManagementPolicyAssignments -DeviceManagementPolicyId $devicePolicy.id -repository 'deviceCompliancePolicies'
        $results.Add('Assignments',$myAssignments)
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $nullResult
    }
}

function Set-TargetResource
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
        $Description,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Boolean]
        $PasswordRequiredToUnlockFromIdle,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault', 'Alphanumeric', 'Numeric')]
        $PasswordRequiredType,

        [Parameter()]
        [System.Boolean]
        $RequireHealthyDeviceReport,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMinimumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $EarlyLaunchAntiMalwareDriverEnabled,

        [Parameter()]
        [System.Boolean]
        $BitLockerEnabled,

        [Parameter()]
        [System.Boolean]
        $SecureBootEnabled,

        [Parameter()]
        [System.Boolean]
        $CodeIntegrityEnabled,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $ActiveFirewallRequired,

        [Parameter()]
        [System.Boolean]
        $DefenderEnabled,

        [Parameter()]
        [System.String]
        $DefenderVersion,

        [Parameter()]
        [System.Boolean]
        $SignatureOutOfDate,

        [Parameter()]
        [System.Boolean]
        $RtpEnabled,

        [Parameter()]
        [System.Boolean]
        $AntivirusRequired,

        [Parameter()]
        [System.Boolean]
        $AntiSpywareRequired,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ConfigurationManagerComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $TPMRequired,

        [Parameter()]
        [System.String]
        $DeviceCompliancePolicyScript,

        [Parameter()]
        [System.Array]
        $ValidOperatingSystemBuildRanges,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Intune Device Compliance Windows 10 Policy {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    Select-MgProfile -Name beta

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentDeviceWindows10Policy = Get-TargetResource @PSBoundParameters

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null

    $scheduledActionsForRule = @{
        '@odata.type'                 = "#microsoft.graph.deviceComplianceScheduledActionForRule"
        ruleName                      = "PasswordRequired"
        scheduledActionConfigurations = @(
            @{
                "@odata.type"= "#microsoft.graph.deviceComplianceActionItem"
                actionType   =  "block"
            }
        )
    }

    if ($Ensure -eq 'Present' -and $currentDeviceWindows10Policy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Intune Device Compliance Windows 10 Policy {$DisplayName}"
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $AdditionalProperties = Get-M365DSCIntuneDeviceCompliancePolicyWindows10AdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        $policy=New-MGDeviceManagementDeviceCompliancePolicy -DisplayName $DisplayName `
            -Description $Description `
            -additionalProperties $AdditionalProperties `
            -scheduledActionsForRule $scheduledActionsForRule

        $assignmentsHash=@()
        foreach($assignment in $Assignments)
        {
            $assignmentsHash+=Get-M365DSCAssignmentsAsHashtable -CIMAssignment $Assignment

        }
        Update-MgDeviceManagementPolicyAssignments -DeviceManagementPolicyId $policy.id `
            -Targets $assignmentsHash `
            -Repository deviceCompliancePolicies

    }
    elseif ($Ensure -eq 'Present' -and $currentDeviceWindows10Policy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Intune Device Compliance Windows 10 Policy {$DisplayName}"
        $configDevicePolicy = Get-MGDeviceManagementDeviceCompliancePolicy `
        -ErrorAction Stop | Where-Object `
        -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10CompliancePolicy' -and `
            $_.displayName -eq $($DisplayName) }

        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $AdditionalProperties = Get-M365DSCIntuneDeviceCompliancePolicyWindows10AdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        Update-MGDeviceManagementDeviceCompliancePolicy -AdditionalProperties $AdditionalProperties `
            -Description $Description `
            -DeviceCompliancePolicyId $configDevicePolicy.Id

        $assignmentsHash=@()
        foreach($assignment in $Assignments)
        {
            $assignmentsHash+=Get-M365DSCAssignmentsAsHashtable -CIMAssignment $Assignment

        }
        Update-MgDeviceManagementPolicyAssignments -DeviceManagementPolicyId $configDevicePolicy.id `
            -Targets $assignmentsHash `
            -Repository deviceCompliancePolicies
    }
    elseif ($Ensure -eq 'Absent' -and $currentDeviceWindows10Policy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Intune Device Compliance Windows 10 Policy {$DisplayName}"
        $configDevicePolicy = Get-MGDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10CompliancePolicy' -and `
                $_.displayName -eq $($DisplayName) }

        Remove-MGDeviceManagementDeviceCompliancePolicy -DeviceCompliancePolicyId $configDevicePolicy.Id
    }
}

function Test-TargetResource
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
        $Description,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Boolean]
        $PasswordRequiredToUnlockFromIdle,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault', 'Alphanumeric', 'Numeric')]
        $PasswordRequiredType,

        [Parameter()]
        [System.Boolean]
        $RequireHealthyDeviceReport,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMinimumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $EarlyLaunchAntiMalwareDriverEnabled,

        [Parameter()]
        [System.Boolean]
        $BitLockerEnabled,

        [Parameter()]
        [System.Boolean]
        $SecureBootEnabled,

        [Parameter()]
        [System.Boolean]
        $CodeIntegrityEnabled,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $ActiveFirewallRequired,

        [Parameter()]
        [System.Boolean]
        $DefenderEnabled,

        [Parameter()]
        [System.String]
        $DefenderVersion,

        [Parameter()]
        [System.Boolean]
        $SignatureOutOfDate,

        [Parameter()]
        [System.Boolean]
        $RtpEnabled,

        [Parameter()]
        [System.Boolean]
        $AntivirusRequired,

        [Parameter()]
        [System.Boolean]
        $AntiSpywareRequired,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ConfigurationManagerComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $TPMRequired,

        [Parameter()]
        [System.String]
        $DeviceCompliancePolicyScript,

        [Parameter()]
        [System.Array]
        $ValidOperatingSystemBuildRanges,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Intune Device Compliance Windows 10 Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    #Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    #Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

    $testResult=$true
    if(([Array]$Assignments).count -ne $CurrentValues.Assignments.count)
    {
        Write-Verbose -Message "Configuration drift:Number of assignments does not match: Source=$([Array]$Assignments.count) Target=$($CurrentValues.Assignments.count)"
        $testResult=$false
    }
    if($testResult)
    {
        foreach($assignment in $CurrentValues.Assignments)
        {
            #GroupId Assignment
            if(-not [String]::IsNullOrEmpty($assignment.groupId))
            {
                $source=[Array]$ValuesToCheck.Assignments|Where-Object -FilterScript {$_.groupId -eq $assignment.groupId}
                if(-not $source)
                {
                    Write-Verbose -Message "Configuration drift: groupId {$($assignment.groupId)} not found"
                    $testResult=$false
                    break;
                }

                $CIMAssignmentAsHash=Get-M365DSCAssignmentsAsHashtable -CIMAssignment $source
            }
            #collectionId Assignment
            elseif(-not [String]::IsNullOrEmpty($assignment.collectionId))
            {
                $source=[Array]$ValuesToCheck.Assignments|Where-Object -FilterScript {$_.groupId -eq $assignment.collectionId}
                if(-not $source)
                {
                    Write-Verbose -Message "Configuration drift: collectionId {$($assignment.collectionId)} not found"
                    $testResult=$false
                    break;
                }

                $CIMAssignmentAsHash=Get-M365DSCAssignmentsAsHashtable -CIMAssignment $source
            }
            #AllDevices/AllUsers assignment
            else
            {
                $source=[Array]$ValuesToCheck.Assignments|Where-Object -FilterScript {$_.dataType -eq $assignment.dataType}
                if(-not $source)
                {
                    Write-Verbose -Message "Configuration drift: {$($assignment.dataType)} not found"
                    $testResult=$false
                    break;
                }
                $CIMAssignmentAsHash=Get-M365DSCAssignmentsAsHashtable -CIMAssignment $source
            }

            foreach($key in $assignment.keys)
            {
                $compareResult = Compare-Object `
                    -ReferenceObject @($assignment[$key]|Select-Object) `
                    -DifferenceObject @($CIMAssignmentAsHash[$key]|Select-Object)

                if ($null -ne $compareResult)
                {
                    Write-Verbose -Message "Configuration drift in assignment key: $key - CurrentValue $($assignment[$key]|out-string)"
                    Write-Verbose -Message "Configuration drift in assignment key: $key - TargetValue $($CIMAssignmentAsHash[$key]|out-string)"
                    return $false
                }
            }

            if(-not $testResult)
            {
                $testResult=$false
                break;
            }

        }

    }

    $ValuesToCheck.Remove('Assignments') | Out-Null

    if($testResult)
    {
        $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys `
            -Verbose

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    Select-MgProfile -Name beta

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$configDeviceWindowsPolicies = Get-MGDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10CompliancePolicy' }
        $i = 1
        $dscContent = ''
        if ($configDeviceWindowsPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }


        foreach ($configDeviceWindowsPolicy in $configDeviceWindowsPolicies)
        {
            Write-Host "    |---[$i/$($configDeviceWindowsPolicies.Count)] $($configDeviceWindowsPolicy.displayName)" -NoNewline
            $params = @{
                DisplayName           = $configDeviceWindowsPolicy.displayName
                Ensure                = 'Present'
                Credential    = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
            }
            $Results = Get-TargetResource @Params

            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            if($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCAssignmentsAsString -Params $Results.Assignments
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
                $isCIMArray=$false
                if($Results.Assignments.getType().Fullname -like "*[[\]]")
                {
                    $isCIMArray=$true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Assignments" -isCIMArray:$isCIMArray
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
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}


function Get-M365DSCIntuneDeviceCompliancePolicyWindows10AdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{"@odata.type" = "#microsoft.graph.windows10CompliancePolicy"}
    foreach ($property in $properties.Keys)
    {
        if ($property -ne 'Verbose')
        {
            $propertyName = $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            $propertyValue = $properties.$property
            $results.Add($propertyName, $propertyValue)
        }
    }
    Write-Verbose -Message ($results | Out-String)
    return $results
}

function Get-M365DSCAssignmentsAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter()]
        [System.Object[]]
        $Params
    )

    if ($null -eq $params)
    {
        return $null
    }
    $currentProperty = "@(`r`n"
    $space="                "
    $nbParam=0
    $hasValue=$false
    foreach ($rule in $params)
    {

        $currentProperty += "$($space)MSFT_DeviceManagementConfigurationPolicyAssignments{`r`n"
        foreach ($key in $rule.Keys)
        {
            $value = $rule[$key]
            if (-not [System.String]::IsNullOrEmpty($value))
            {
                $currentProperty += "                    " + $key + " = '" + $value + "'`r`n"
                $hasValue=$true
            }

        }
        $currentProperty += "                }"
        if($nbParam -lt ($params.Count -1) )
        {
            $nbParam++
            $currentProperty +="`r`n"
        }

    }
    $currentProperty += ")"
    if (-not $hasValue)
    {
        return '@()'
    }
    return $currentProperty
}

function Get-M365DSCAssignmentsAsHashtable
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CIMAssignment
    )

    if ($null -eq $CIMAssignment)
    {
        return $null
    }
    $CIMAssignmentAsHash=@{}
    $keys = $CIMAssignment | Get-Member -MemberType Properties

    foreach ($key in $keys)
    {
        if($CIMAssignment.$($key.Name))
        {
            $CIMAssignmentAsHash.Add($key.Name, $CIMAssignment.$($key.Name))
        }
    }
    if ($CIMAssignmentAsHash.Count -eq 0)
    {
        return $null
    }
    return $CIMAssignmentAsHash
}
function Get-MgDeviceManagementPolicyAssignments
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceManagementPolicyId,

        [Parameter()]
        [ValidateSet('deviceCompliancePolicies','intents','configurationPolicies')]
        [System.String]
        $Repository='configurationPolicies'
    )
    try
    {
        $deviceManagementPolicyAssignments=@()

        $Uri="https://graph.microsoft.com/beta/deviceManagement/$Repository/$DeviceManagementPolicyId/assignments"
        $results=Invoke-MgGraphRequest -Method GET  -Uri $Uri -ErrorAction Stop
        foreach($result in $results.value.target)
        {
            $deviceManagementPolicyAssignments+=@{
                dataType=$result."@odata.type"
                groupId=$result.groupId
                collectionId=$result.collectionId
                deviceAndAppManagementAssignmentFilterType=$result.deviceAndAppManagementAssignmentFilterType
                deviceAndAppManagementAssignmentFilterId=$result.deviceAndAppManagementAssignmentFilterId
            }
        }

        while($results."@odata.nextLink")
        {
            $Uri=$results."@odata.nextLink"
            $results=Invoke-MgGraphRequest -Method GET -Uri $Uri -ErrorAction Stop
            foreach($result in $results.value.target)
            {
                $deviceManagementPolicyAssignments+=@{
                    dataType=$result."@odata.type"
                    groupId=$result.groupId
                    collectionId=$result.collectionId
                    deviceAndAppManagementAssignmentFilterType=$result.deviceAndAppManagementAssignmentFilterType
                    deviceAndAppManagementAssignmentFilterId=$result.deviceAndAppManagementAssignmentFilterId
                }
            }
        }
        return $deviceManagementPolicyAssignments
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
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
function Update-MgDeviceManagementPolicyAssignments
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceManagementPolicyId,

        [Parameter()]
        [Array]
        $Targets,

        [Parameter()]
        [ValidateSet('deviceCompliancePolicies','intents','configurationPolicies')]
        [System.String]
        $Repository='configurationPolicies'
    )
    try
    {
        $deviceManagementPolicyAssignments=@()

        $Uri="https://graph.microsoft.com/beta/deviceManagement/$Repository/$DeviceManagementPolicyId/assign"

        foreach($target in $targets)
        {
            $formattedTarget=@{"@odata.type"=$target.dataType}
            if($target.groupId)
            {
                $formattedTarget.Add('groupId',$target.groupId)
            }
            if($target.collectionId)
            {
                $formattedTarget.Add('collectionId',$target.collectionId)
            }
            if($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType',$target.deviceAndAppManagementAssignmentFilterType)
            }
            if($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId',$target.deviceAndAppManagementAssignmentFilterId)
            }
            $deviceManagementPolicyAssignments+=@{'target'= $formattedTarget}
        }
        $body=@{'assignments'=$deviceManagementPolicyAssignments}|ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop

    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
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

Export-ModuleMember -Function *-TargetResource,*
