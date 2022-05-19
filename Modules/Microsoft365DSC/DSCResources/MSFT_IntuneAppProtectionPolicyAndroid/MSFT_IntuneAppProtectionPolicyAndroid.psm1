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
        [System.String]
        $PeriodOfflineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $PeriodOnlineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $AllowedInboundDataTransferSources,

        [Parameter()]
        [System.String]
        $AllowedOutboundDataTransferDestinations,

        [Parameter()]
        [System.Boolean]
        $OrganizationalCredentialsRequired,

        [Parameter()]
        [System.String]
        $AllowedOutboundClipboardSharingLevel,

        [Parameter()]
        [System.Boolean]
        $DataBackupBlocked,

        [Parameter()]
        [System.Boolean]
        $DeviceComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $IsAssigned,

        [Parameter()]
        [System.String]
        $ManagedBrowser,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredOSVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningOSVersion,

        [Parameter()]
        [System.Boolean]
        $ManagedBrowserToOpenLinksRequired,

        [Parameter()]
        [System.Boolean]
        $SaveAsBlocked,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeWipeIsEnforced,

        [Parameter()]
        [System.Boolean]
        $PinRequired,

        [Parameter()]
        [System.Boolean]
        $DisableAppPinIfDevicePinIsSet,

        [Parameter()]
        [System.UInt32]
        $MaximumPinRetries,

        [Parameter()]
        [System.Boolean]
        $SimplePinBlocked,

        [Parameter()]
        [System.UInt32]
        $MinimumPinLength,

        [Parameter()]
        [System.String]
        $PinCharacterSet,

        [Parameter()]
        [System.String[]]
        $AllowedDataStorageLocations,

        [Parameter()]
        [System.Boolean]
        $ContactSyncBlocked,

        [Parameter()]
        [System.String]
        $PeriodBeforePinReset,

        [Parameter()]
        [System.Boolean]
        $PrintBlocked,

        [Parameter()]
        [System.Boolean]
        $FingerprintBlocked,

        [Parameter()]
        [ValidateSet('allApps', 'allMicrosoftApps', 'allCoreMicrosoftApps', 'selectedPublicApps' )]
        [System.String]
        $AppGroupType,

        [Parameter()]
        [System.String[]]
        $Apps,

        [Parameter()]
        [System.String[]]
        $Assignments,

        [Parameter()]
        [System.String[]]
        $ExcludedGroups,

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
    Write-Verbose -Message "Checking for the Intune Android App Protection Policy {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    write-host 'resourcename:' $ResourceName
    $CommandName  = $MyInvocation.MyCommand
    write-host 'commandname:' $commandname
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        $policyInfo = Get-MgDeviceAppManagementAndroidManagedAppProtection -Filter "displayName eq '$DisplayName'" -ExpandProperty Apps, assignments `
            -ErrorAction Stop

        if ($null -eq $policyInfo)
        {
            Write-Verbose -Message "No Android App Protection Policy {$DisplayName} was found"
            return $nullResult
        }

        # handle multiple results - throw error - may be able to remediate to specify ID in configuration at later date
        if ($policyInfo.gettype().isarray)
        {
            Write-Verbose -Message "Multiple Android Policies with name {$DisplayName} were found - Module will only function with unique names, please manually remediate"
            $nullResult.Ensure = 'ERROR'
            throw "Multiple Policies with same displayname identified - Module currently only functions with unique names"
        }

        # It may be possible to remove this once basic functionality is in place - output types differ to the graph module object though so implementing basic functionality first
        $policy = Get-M365DSCIntuneAppProtectionPolicyAndroid -PolicyId $policyInfo.Id
        Write-Verbose -Message "Found Android App Protection Policy {$DisplayName}"

        $appsArray = @()
        if ($null -ne $policy.Apps)
        {
            foreach ($app in $policy.Apps)
            {
                $appsArray += $app.mobileAppIdentifier.packageId
            }
        }

        $assignmentsArray = @()
        if ($null -ne $policy.Assignments)
        {
            $allAssignments = $policy.Assignments.target | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.groupAssignmentTarget' }

            foreach ($assignment in $allAssignments)
            {
                $assignmentsArray += $assignment.groupId
            }
        }

        $exclusionArray = @()
        if ($null -ne $policy.Assignments)
        {
            $allExclusions = $policy.Assignments.target | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.exclusionGroupAssignmentTarget' }

            foreach ($exclusion in $allExclusions)
            {
                $exclusionArray += $exclusion.groupId
            }
        }
        return @{
            DisplayName                             = $policyInfo.DisplayName
            Description                             = $policy.Description
            PeriodOfflineBeforeAccessCheck          = $policy.PeriodOfflineBeforeAccessCheck
            PeriodOnlineBeforeAccessCheck           = $policy.PeriodOnlineBeforeAccessCheck
            AllowedInboundDataTransferSources       = $policy.AllowedInboundDataTransferSources
            AllowedOutboundDataTransferDestinations = $policy.AllowedOutboundDataTransferDestinations
            OrganizationalCredentialsRequired       = $policy.OrganizationalCredentialsRequired
            AllowedOutboundClipboardSharingLevel    = $policy.AllowedOutboundClipboardSharingLevel
            DataBackupBlocked                       = $policy.DataBackupBlocked
            DeviceComplianceRequired                = $policy.DeviceComplianceRequired
            IsAssigned                              = $policy.IsAssigned
            ManagedBrowser                          = $policy.ManagedBrowser
            MinimumRequiredAppVersion               = $policy.MinimumRequiredAppVersion
            MinimumRequiredOSVersion                = $policy.MinimumRequiredOSVersion
            MinimumWarningAppVersion                = $policy.MinimumWarningAppVersion
            MinimumWarningOSVersion                 = $policy.MinimumWarningOSVersion
            ManagedBrowserToOpenLinksRequired       = $policy.ManagedBrowserToOpenLinksRequired
            SaveAsBlocked                           = $policy.SaveAsBlocked
            PeriodOfflineBeforeWipeIsEnforced       = $policy.PeriodOfflineBeforeWipeIsEnforced
            PinRequired                             = $policy.PinRequired
            DisableAppPinIfDevicePinIsSet           = $policy.disableAppPinIfDevicePinIsSet
            MaximumPinRetries                       = $policy.MaximumPinRetries
            SimplePinBlocked                        = $policy.SimplePinBlocked
            MinimumPinLength                        = $policy.MinimumPinLength
            PinCharacterSet                         = $policy.PinCharacterSet
            AllowedDataStorageLocations             = $policy.AllowedDataStorageLocations
            ContactSyncBlocked                      = $policy.ContactSyncBlocked
            PeriodBeforePinReset                    = $policy.PeriodBeforePinReset
            PrintBlocked                            = $policy.PrintBlocked
            FingerprintBlocked                      = $policy.FingerprintBlocked
            Assignments                             = $assignmentsArray
            ExcludedGroups                          = $exclusionArray
            Apps                                    = $appsArray
            Ensure                                  = "Present"
            Credential                              = $Credential
            ApplicationId                           = $ApplicationId
            ApplicationSecret                       = $ApplicationSecret
            TenantId                                = $TenantId
            CertificateThumbprint                   = $CertificateThumbprint
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = $Credential.UserName.Split('@')[1]
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
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $PeriodOnlineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $AllowedInboundDataTransferSources,

        [Parameter()]
        [System.String]
        $AllowedOutboundDataTransferDestinations,

        [Parameter()]
        [System.Boolean]
        $OrganizationalCredentialsRequired,

        [Parameter()]
        [System.String]
        $AllowedOutboundClipboardSharingLevel,

        [Parameter()]
        [System.Boolean]
        $DataBackupBlocked,

        [Parameter()]
        [System.Boolean]
        $DeviceComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $IsAssigned,

        [Parameter()]
        [System.String]
        $ManagedBrowser,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredOSVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningOSVersion,

        [Parameter()]
        [System.Boolean]
        $ManagedBrowserToOpenLinksRequired,

        [Parameter()]
        [System.Boolean]
        $SaveAsBlocked,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeWipeIsEnforced,

        [Parameter()]
        [System.Boolean]
        $PinRequired,

        [Parameter()]
        [System.Boolean]
        $DisableAppPinIfDevicePinIsSet,

        [Parameter()]
        [System.UInt32]
        $MaximumPinRetries,

        [Parameter()]
        [System.Boolean]
        $SimplePinBlocked,

        [Parameter()]
        [System.UInt32]
        $MinimumPinLength,

        [Parameter()]
        [System.String]
        $PinCharacterSet,

        [Parameter()]
        [System.String[]]
        $AllowedDataStorageLocations,

        [Parameter()]
        [System.Boolean]
        $ContactSyncBlocked,

        [Parameter()]
        [System.String]
        $PeriodBeforePinReset,

        [Parameter()]
        [System.Boolean]
        $PrintBlocked,

        [Parameter()]
        [System.Boolean]
        $FingerprintBlocked,

        [Parameter()]
        [ValidateSet('allApps', 'allMicrosoftApps', 'allCoreMicrosoftApps', 'selectedPublicApps' )]
        [System.String]
        $AppGroupType,

        [Parameter()]
        [System.Array[]]
        $Apps,

        [Parameter()]
        [System.Array[]]
        $Assignments,

        [Parameter()]
        [System.Array[]]
        $ExcludedGroups,

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
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

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

    $currentPolicy = Get-TargetResource @PSBoundParameters

    if ($currentPolicy.Ensure -eq "ERROR")
    {
        Throw 'Error when searching for current policy details - Please check verbose output for further detail'
    }

    $setParams = @{}
    $PSBoundParameters.Remove("Ensure") | Out-Null
    $PSBoundParameters.Remove("Credential") | Out-Null
    $PSBoundParameters.Remove("ApplicationID") | Out-Null
    $PSBoundParameters.Remove("ApplicationSecret") | Out-Null
    $PSBoundParameters.Remove("TenantID") | Out-Null
    $PSBoundParameters.Remove("CertificateThumbprint") | Out-Null

    #if $AppGroupType is blank set a value based on $apps value
    if ($AppGroupType -eq '')
    {
        if ($apps.count -eq 0 ) { $AppGroupType = 'allApps' }
        else { $AppGroupType = 'selectedPublicApps' }
        write-verbose -message "setting AppGroupType to $AppGroupType"
    }

    $assignmentsArray = @()
    $appsarray = @()
    $configstring = "`r`nConfiguration To Be Applied:`r`n"

    $ComplexParameters = @(
        'AppGroupType',
        'Apps',
        'Assignments',
        'ExcludedGroups'
    )

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        $graphparams = get-inputParamsList -commandName 'New-MgDeviceAppMgtAndroidManagedAppProtection'
        Write-Verbose -Message "Creating new Android App Protection Policy {$DisplayName}"
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Android App Protection Policy {$DisplayName}"
        $setParams.add('AndroidManagedAppProtectionId', (Get-MgDeviceAppManagementAndroidManagedAppProtection -Filter "displayName eq '$DisplayName'").id)
        $graphparams = get-inputParamsList -commandName 'Update-MgDeviceAppMgtAndroidManagedAppProtection'
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present'){}

    # construct command
    write-verbose -message "Preparing input parameters..."
    foreach ($param in $PSBoundParameters.keys)
    {
        if ( $graphparams.containskey($param) -and !($ComplexParameters -contains $param) )
        {
            switch ($graphparams.$param.ParameterType.name)
            {
                'TimeSpan'
                {
                    $setParams.add($param, (set-TimeSpan -duration $PSBoundParameters.$param))
                    $configstring += ($param + ':' + ($setParams.$param.tostring()) + "`r`n")
                }

                'string'
                {
                    $setParams.add($param, $PSBoundParameters.$param)
                    $configstring += ($param + ':' + $setParams.$param + "`r`n")
                }

                default
                {
                    $setParams.add($param, $PSBoundParameters.$param)
                    $configstring += ($param + ':' + $setParams.$param + "`r`n")
                }
            }
        }

        else
        {
            if($ComplexParameters -contains $param)
            {
                switch ($param)
                {

                    'AppGroupType'
                    {
                        $configstring += ('AppGroupType:' + $AppGroupType + "`r`n")
                    }

                    'Apps'
                    {
                        if ($AppGroupType -eq 'selectedPublicApps' )
                        {
                            $PSBoundParameters.$param | foreach {
                                $appsarray+= set-JSONstring -id $_ -type $param
                            }
                            $configstring += ($param + ":`r`n" +($PSBoundParameters.$param | out-string) + "`r`n" )
                        }
                    }

                    'Assignments'
                    {
                        $PSBoundParameters.$param | foreach {
                            $assignmentsArray+= set-JSONstring -id $_ -type $param
                        }
                        $configstring += ($param + ":`r`n" +($PSBoundParameters.$param | out-string) + "`r`n" )
                    }

                    'ExcludedGroups'
                    {
                        $PSBoundParameters.$param | foreach {
                            $assignmentsArray+= set-JSONstring -id $_ -type $param
                        }
                        $configstring += ($param + ":`r`n" +($PSBoundParameters.$param | out-string) + "`r`n" )
                    }
                }
            }
            else
            {
                write-verbose -message "Cannot specify this in graph cmdlet: $param"
            }
        }
    }

    write-verbose -message $configstring

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message 'Setting up policy via graph...'
        $setParams.add('Assignments', $assignmentsArray)
        $newpolicy = New-MgDeviceAppMgtAndroidManagedAppProtection @setParams
        $setParams.add('AndroidManagedAppProtectionId', $newpolicy.Id)

    }

    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message 'Amending policy via graph...'

        Update-MgDeviceAppMgtAndroidManagedAppProtection @setParams

        # Assignments need to be set using a different cmdlet - $assignmentsArray should exist at this point
        set-MgDeviceAppMgtTargetedManagedAppConfiguration -TargetedManagedAppConfigurationId $setParams.AndroidManagedAppProtectionId -Assignments $assignmentsArray

    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Android App Protection Policy {$DisplayName}"
        $policyInfo = Get-MgDeviceAppManagementAndroidManagedAppProtection -Filter "displayName eq '$DisplayName'" `
            -ErrorAction Stop
        Remove-MgDeviceAppManagementAndroidManagedAppProtection -AndroidManagedAppProtectionId $policyInfo.id
    }

    if ( ($AppGroupType -ne '') -and ($ensure -ne 'absent'))
    {
        write-verbose -message "Setting Application values of type: $AppGroupType"
        Invoke-MgTargetDeviceAppMgtTargetedManagedAppConfigurationApp -TargetedManagedAppConfigurationId $setParams.AndroidManagedAppProtectionId -Apps $appsarray -AppGroupType $AppGroupType
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $PeriodOnlineBeforeAccessCheck,

        [Parameter()]
        [System.String]
        $AllowedInboundDataTransferSources,

        [Parameter()]
        [System.String]
        $AllowedOutboundDataTransferDestinations,

        [Parameter()]
        [System.Boolean]
        $OrganizationalCredentialsRequired,

        [Parameter()]
        [System.String]
        $AllowedOutboundClipboardSharingLevel,

        [Parameter()]
        [System.Boolean]
        $DataBackupBlocked,

        [Parameter()]
        [System.Boolean]
        $DeviceComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $IsAssigned,

        [Parameter()]
        [System.String]
        $ManagedBrowser,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredOSVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningOSVersion,

        [Parameter()]
        [System.Boolean]
        $ManagedBrowserToOpenLinksRequired,

        [Parameter()]
        [System.Boolean]
        $SaveAsBlocked,

        [Parameter()]
        [System.String]
        $PeriodOfflineBeforeWipeIsEnforced,

        [Parameter()]
        [System.Boolean]
        $PinRequired,

        [Parameter()]
        [System.Boolean]
        $DisableAppPinIfDevicePinIsSet,

        [Parameter()]
        [System.UInt32]
        $MaximumPinRetries,

        [Parameter()]
        [System.Boolean]
        $SimplePinBlocked,

        [Parameter()]
        [System.UInt32]
        $MinimumPinLength,

        [Parameter()]
        [System.String]
        $PinCharacterSet,

        [Parameter()]
        [System.String[]]
        $AllowedDataStorageLocations,

        [Parameter()]
        [System.Boolean]
        $ContactSyncBlocked,

        [Parameter()]
        [System.String]
        $PeriodBeforePinReset,

        [Parameter()]
        [System.Boolean]
        $PrintBlocked,

        [Parameter()]
        [System.Boolean]
        $FingerprintBlocked,

        [Parameter()]
        [ValidateSet('allApps', 'allMicrosoftApps', 'allCoreMicrosoftApps', 'selectedPublicApps' )]
        [System.String]
        $AppGroupType,

        [Parameter()]
        [System.String[]]
        $Apps,

        [Parameter()]
        [System.String[]]
        $Assignments,

        [Parameter()]
        [System.String[]]
        $ExcludedGroups,

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
    Write-Verbose -Message "Testing configuration of Android App Protection Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    if ($CurrentValues.Ensure -eq "ERROR")
    {

        Throw 'Error when searching for current policy details - Please check verbose output for further detail'

    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

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
        [array]$policies = Get-MgDeviceAppManagementAndroidManagedAppProtection -ErrorAction Stop
        $i = 1
        $dscContent = ''
        if ($policies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.displayName)" -NoNewline
            $params = @{
                DisplayName           = $policy.displayName
                Ensure                = 'Present'
                Credential    = $Credential
                ApplicationID         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
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
        if ($_.Exception -like '*401*')
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX
        }
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = $Credential.UserName.Split('@')[1]

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

function Get-M365DSCIntuneAppProtectionPolicyAndroid
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $PolicyId
    )
    try
    {
        $Url = "https://graph.microsoft.com/beta/deviceAppManagement/AndroidManagedAppProtections('$PolicyId')/`?expand=apps,assignments"
        $response = Invoke-MgGraphRequest -Method Get `
            -Uri $Url
        return $response
    }
    catch
    {
        Write-Verbose -Message $_
        $tenantIdValue = $Credential.UserName.Split('@')[1]
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $tenantIdValue
    }
    return $null
}

function get-inputParamsList
{
        param(
            [string]$commandName
        )

    # it seems a daft function at the moment but I'm hoping wI can use it to set up dynamic parameters for the functions at some point and I'll probably need to work on it then
    $Graphparams = (get-command $commandName).Parameters

    return $Graphparams

}

function set-Timespan
{
    param(
        [string]$duration
    )
    try
    {
        if ($duration.startswith('P'))
        {
            $timespan = [System.Xml.XmlConvert]::ToTimeSpan($duration)
        }
        else
        {
            $timespan = [TimeSpan]$duration
        }
    }
    catch
    {
        throw "Problem converting input to a timespan - If configuration document is using iso8601 string (e.g. PT15M) try using new-timespan (e.g. new-timespan -minutes 15)"
    }
    return $timespan
}

function set-JSONstring
{
    param(
        [string]$id,
        [string]$type
    )

    $JsonContent = ''

    switch ($type)
    {

        'Apps'
        {
            $JsonContent = @"
                    {
                    "id":"$($id)",
                    "mobileAppIdentifier": {
                        "@odata.type": "#microsoft.graph.AndroidMobileAppIdentifier",
                        "packageId": "$id"
                    }
                }
"@

        }
        'Assignments'
        {
            $JsonContent = @"
            {
            "id":"$($id)_incl",
            "target": {
                        "@odata.type": "#microsoft.graph.groupAssignmentTarget",
                        "groupId": "$($id)"
                    }
            }
"@
        }
        'ExcludedGroups'
        {
            $JsonContent = @"
            {
            "id":"$($id)_excl",
            "target": {
                        "@odata.type": "#microsoft.graph.exclusionGroupAssignmentTarget",
                        "groupId": "$($id)"
                    }
            }
"@

        }
    }

    return $JsonContent

}


Export-ModuleMember -Function *-TargetResource
