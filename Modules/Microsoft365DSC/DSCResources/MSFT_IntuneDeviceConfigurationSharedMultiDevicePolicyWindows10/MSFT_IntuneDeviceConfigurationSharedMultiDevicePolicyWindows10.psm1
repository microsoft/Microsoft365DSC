Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneDeviceConfigurationSharedMultiDevicePolicyWindows10'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AccountManagerPolicy,

        [Parameter()]
        [ValidateSet('notConfigured', 'guest', 'domain')]
        [System.String[]]
        $AllowedAccounts,

        [Parameter()]
        [System.Boolean]
        $AllowLocalStorage,

        [Parameter()]
        [System.Boolean]
        $DisableAccountManager,

        [Parameter()]
        [System.Boolean]
        $DisableEduPolicies,

        [Parameter()]
        [System.Boolean]
        $DisablePowerPolicies,

        [Parameter()]
        [System.Boolean]
        $DisableSignInOnResume,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $FastFirstSignIn,

        [Parameter()]
        [System.Int32]
        $IdleTimeBeforeSleepInSeconds,

        [Parameter()]
        [System.String]
        $KioskAppDisplayName,

        [Parameter()]
        [System.String]
        $KioskAppUserModelId,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $LocalStorage,

        [Parameter()]
        [System.TimeSpan]
        $MaintenanceStartTime,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $SetAccountManager,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $SetEduPolicies,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $SetPowerPolicies,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $SignInOnResume,

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

    Write-Verbose -Message "Getting configuration of the Intune Device Configuration Shared Multi Device Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

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
                Write-Verbose -Message "Could not find an Intune Device Configuration Shared Multi Device Policy for Windows10 with Id {$Id}"

                if (-not [string]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
                        -All `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")' and isof('microsoft.graph.sharedPCConfiguration')" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Device Configuration Shared Multi Device Policy for Windows10 with DisplayName {$DisplayName}"
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Configuration Shared Multi Device Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexAccountManagerPolicy = [ordered]@{}
        if ($null -ne $getValue.accountManagerPolicy.accountDeletionPolicy)
        {
            $complexAccountManagerPolicy.Add('AccountDeletionPolicy', $getValue.accountManagerPolicy.accountDeletionPolicy.ToString())
        }
        $complexAccountManagerPolicy.Add('CacheAccountsAboveDiskFreePercentage', $getValue.accountManagerPolicy.cacheAccountsAboveDiskFreePercentage)
        $complexAccountManagerPolicy.Add('InactiveThresholdDays', $getValue.accountManagerPolicy.inactiveThresholdDays)
        $complexAccountManagerPolicy.Add('RemoveAccountsBelowDiskFreePercentage', $getValue.accountManagerPolicy.removeAccountsBelowDiskFreePercentage)
        if ($complexAccountManagerPolicy.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexAccountManagerPolicy = $null
        }
        #endregion

        #region resource generator code
        $enumAllowedAccounts = @()
        if ($null -ne $getValue.allowedAccounts)
        {
            $allowedAccounts = $getValue.allowedAccounts.ToString().Split(',')
            foreach ($allowedAccount in $allowedAccounts)
            {
                $enumAllowedAccounts += $allowedAccount
            }
        }

        $enumFastFirstSignIn = $null
        if ($null -ne $getValue.fastFirstSignIn)
        {
            $enumFastFirstSignIn = $getValue.fastFirstSignIn.ToString()
        }

        $enumLocalStorage = $null
        if ($null -ne $getValue.localStorage)
        {
            $enumLocalStorage = $getValue.localStorage.ToString()
        }

        $enumSetAccountManager = $null
        if ($null -ne $getValue.setAccountManager)
        {
            $enumSetAccountManager = $getValue.setAccountManager.ToString()
        }

        $enumSetEduPolicies = $null
        if ($null -ne $getValue.setEduPolicies)
        {
            $enumSetEduPolicies = $getValue.setEduPolicies.ToString()
        }

        $enumSetPowerPolicies = $null
        if ($null -ne $getValue.setPowerPolicies)
        {
            $enumSetPowerPolicies = $getValue.setPowerPolicies.ToString()
        }

        $enumSignInOnResume = $null
        if ($null -ne $getValue.signInOnResume)
        {
            $enumSignInOnResume = $getValue.signInOnResume.ToString()
        }
        #endregion

        #region resource generator code
        $timeMaintenanceStartTime = $null
        if ($null -ne $getValue.maintenanceStartTime)
        {
            $timeMaintenanceStartTime = ([TimeSpan]$getValue.maintenanceStartTime).ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            AccountManagerPolicy         = $complexAccountManagerPolicy
            AllowedAccounts              = $enumAllowedAccounts
            AllowLocalStorage            = $getValue.allowLocalStorage
            DisableAccountManager        = $getValue.disableAccountManager
            DisableEduPolicies           = $getValue.disableEduPolicies
            DisablePowerPolicies         = $getValue.disablePowerPolicies
            DisableSignInOnResume        = $getValue.disableSignInOnResume
            Enabled                      = $getValue.enabled
            FastFirstSignIn              = $enumFastFirstSignIn
            IdleTimeBeforeSleepInSeconds = $getValue.idleTimeBeforeSleepInSeconds
            KioskAppDisplayName          = $getValue.kioskAppDisplayName
            KioskAppUserModelId          = $getValue.kioskAppUserModelId
            LocalStorage                 = $enumLocalStorage
            MaintenanceStartTime         = $timeMaintenanceStartTime
            SetAccountManager            = $enumSetAccountManager
            SetEduPolicies               = $enumSetEduPolicies
            SetPowerPolicies             = $enumSetPowerPolicies
            SignInOnResume               = $enumSignInOnResume
            Description                  = $getValue.Description
            DisplayName                  = $getValue.DisplayName
            Id                           = $getValue.Id
            RoleScopeTagIds              = $getValue.RoleScopeTagIds
            Ensure                       = 'Present'
            Credential                   = $Credential
            ApplicationId                = $ApplicationId
            TenantId                     = $TenantId
            ApplicationSecret            = $ApplicationSecret
            CertificateThumbprint        = $CertificateThumbprint
            CertificatePath              = $CertificatePath
            CertificatePassword          = $CertificatePassword
            ManagedIdentity              = $ManagedIdentity.IsPresent
            AccessTokens                 = $AccessTokens
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
        [Microsoft.Management.Infrastructure.CimInstance]
        $AccountManagerPolicy,

        [Parameter()]
        [ValidateSet('notConfigured', 'guest', 'domain')]
        [System.String[]]
        $AllowedAccounts,

        [Parameter()]
        [System.Boolean]
        $AllowLocalStorage,

        [Parameter()]
        [System.Boolean]
        $DisableAccountManager,

        [Parameter()]
        [System.Boolean]
        $DisableEduPolicies,

        [Parameter()]
        [System.Boolean]
        $DisablePowerPolicies,

        [Parameter()]
        [System.Boolean]
        $DisableSignInOnResume,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $FastFirstSignIn,

        [Parameter()]
        [System.Int32]
        $IdleTimeBeforeSleepInSeconds,

        [Parameter()]
        [System.String]
        $KioskAppDisplayName,

        [Parameter()]
        [System.String]
        $KioskAppUserModelId,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $LocalStorage,

        [Parameter()]
        [System.TimeSpan]
        $MaintenanceStartTime,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $SetAccountManager,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $SetEduPolicies,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $SetPowerPolicies,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $SignInOnResume,

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
        Write-Verbose -Message "Creating an Intune Device Configuration Shared Multi Device Policy for Windows10 with DisplayName {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$BoundParameters).Clone()
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('Id') | Out-Null

        if ($null -ne $AllowedAccounts)
        {
            $CreateParameters.AllowedAccounts = $AllowedAccounts -join ','
        }

        #region resource generator code
        $CreateParameters.Add('@odata.type', '#microsoft.graph.sharedPCConfiguration')
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
        Write-Verbose -Message "Updating the Intune Device Configuration Shared Multi Device Policy for Windows10 with Id {$($currentInstance.Id)}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $updateParameters = ([Hashtable]$boundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters
        $updateParameters.Remove('Id') | Out-Null

        if ($null -ne $AllowedAccounts)
        {
            $UpdateParameters.AllowedAccounts = $AllowedAccounts -join ','
        }
        #region resource generator code
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.sharedPCConfiguration')
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
        Write-Verbose -Message "Removing the Intune Device Configuration Shared Multi Device Policy for Windows10 with Id {$($currentInstance.Id)}"
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
        [Microsoft.Management.Infrastructure.CimInstance]
        $AccountManagerPolicy,

        [Parameter()]
        [ValidateSet('notConfigured', 'guest', 'domain')]
        [System.String[]]
        $AllowedAccounts,

        [Parameter()]
        [System.Boolean]
        $AllowLocalStorage,

        [Parameter()]
        [System.Boolean]
        $DisableAccountManager,

        [Parameter()]
        [System.Boolean]
        $DisableEduPolicies,

        [Parameter()]
        [System.Boolean]
        $DisablePowerPolicies,

        [Parameter()]
        [System.Boolean]
        $DisableSignInOnResume,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $FastFirstSignIn,

        [Parameter()]
        [System.Int32]
        $IdleTimeBeforeSleepInSeconds,

        [Parameter()]
        [System.String]
        $KioskAppDisplayName,

        [Parameter()]
        [System.String]
        $KioskAppUserModelId,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $LocalStorage,

        [Parameter()]
        [System.TimeSpan]
        $MaintenanceStartTime,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $SetAccountManager,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $SetEduPolicies,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $SetPowerPolicies,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $SignInOnResume,

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
        $baseFilter = "isof('microsoft.graph.sharedPCConfiguration')"
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
            if ($null -ne $Results.AccountManagerPolicy)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.AccountManagerPolicy `
                    -CIMInstanceName 'MicrosoftGraphsharedPCAccountManagerPolicy'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.AccountManagerPolicy = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AccountManagerPolicy') | Out-Null
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
                -NoEscape @('AccountManagerPolicy', 'Assignments')

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
