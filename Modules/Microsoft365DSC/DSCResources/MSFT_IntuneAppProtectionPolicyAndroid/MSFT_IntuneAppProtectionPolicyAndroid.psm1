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
        [System.String[]]
        $Apps,

        [Parameter()]
        [ValidateSet('allApps', 'allMicrosoftApps', 'allCoreMicrosoftApps', 'selectedPublicApps' )]
        [System.String]
        $AppGroupType,

        [Parameter()]
        [System.String[]]
        $Assignments,

        [Parameter()]
        [System.String[]]
        $ExcludedGroups,

        [Parameter()]
        [System.String]
        [ValidateSet('notConfigured', 'microsoftEdge')]
        $ManagedBrowser,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredOSVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredPatchVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningOSVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningPatchVersion,

        [Parameter()]
        [System.Boolean]
        $IsAssigned,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )
    Write-Verbose -Message "Checking for the Intune Android App Protection Policy {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' -ProfileName beta `
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
            throw 'Multiple Policies with same displayname identified - Module currently only functions with unique names'
        }

        Write-Verbose -Message "Found Android App Protection Policy {$DisplayName}"

        $appsArray = @()
        if ($null -ne $policyInfo.Apps)
        {
            foreach ($app in $policyInfo.Apps)
            {
                $appsArray += $app.MobileAppIdentifier.AdditionalProperties.packageId
            }
        }

        $assignmentsArray = @()
        $exclusionArray = @()
        if ($null -ne $policyInfo.Assignments)
        {
            foreach ($assignment in $policyInfo.Assignments)
            {
                switch ($assignment.Target.AdditionalProperties.'@odata.type')
                {
                    '#microsoft.graph.groupAssignmentTarget'
                    {
                        $assignmentsArray += $assignment.Target.AdditionalProperties.groupId
                    }

                    '#microsoft.graph.exclusionGroupAssignmentTarget'
                    {
                        $exclusionArray += $assignment.Target.AdditionalProperties.groupId
                    }
                }
            }
        }
        $Allparams = get-InputParameters
        $policy = @{}

        #loop regular parameters and add from $polycyinfo
        foreach ($param in ($Allparams.keys | Where-Object { $allparams.$_.Type -eq 'Parameter' }) )
        {
            # we need to process this because reverseDSC doesn't handle certain object types
            switch ($Allparams.$param.ExportFileType)
            {
                'String'
                {
                    $policy.add($param, $policyInfo.$param.tostring())
                }

                'Array'
                {
                    $tmparray = @()
                    $policyInfo.$param | ForEach-Object { $tmparray += $_.tostring() }
                    $policy.add($param, $tmparray)
                }

                DEFAULT
                { $policy.add($param, $policyInfo.$param) }
            }
        }
        # loop credential parameters and add them from input params
        foreach ($param in ($Allparams.keys | Where-Object { $allparams.$_.Type -eq 'Credential' }) )
        {
            $policy.add($param, (Get-Variable -Name $param).value)
        }
        # add complex parameters manually as they all have different requirements - potential to change in future
        $policy.add('Ensure', 'Present')
        $policy.add('Apps', $appsArray)
        $policy.add('Assignments', $assignmentsArray)
        $policy.add('ExcludedGroups', $exclusionArray)
        $policy.add('AppGroupType', $policyInfo.AppGroupType)
        # add Id for use in set function
        $policy.add('Id', $policyInfo.Id)


        return $policy
    }
    catch
    {
        Write-Verbose -Message "ERROR on get-targetresource for $displayName"
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
        [System.String[]]
        $Apps,

        [Parameter()]
        [ValidateSet('allApps', 'allMicrosoftApps', 'allCoreMicrosoftApps', 'selectedPublicApps' )]
        [System.String]
        $AppGroupType,

        [Parameter()]
        [System.String[]]
        $Assignments,

        [Parameter()]
        [System.String[]]
        $ExcludedGroups,

        [Parameter()]
        [System.String]
        [ValidateSet('notConfigured', 'microsoftEdge')]
        $ManagedBrowser,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredOSVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredPatchVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningOSVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningPatchVersion,

        [Parameter()]
        [System.Boolean]
        $IsAssigned,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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

    $currentPolicy = Get-TargetResource @PSBoundParameters

    if ($currentPolicy.Ensure -eq 'ERROR')
    {

        Throw 'Error when searching for current policy details - Please check verbose output for further detail'

    }
    if (($Ensure -eq 'Absent') -and ($currentPolicy.Ensure -eq 'Present'))
    {
        Write-Verbose -Message "Removing Android App Protection Policy {$DisplayName}"
        Remove-MgDeviceAppManagementAndroidManagedAppProtection -AndroidManagedAppProtectionId $currentPolicy.id
        # then exit
        return $true
    }

    $setParams = @{}
    $assignmentsArray = @()
    $appsarray = @()

    $configstring = "`r`nConfiguration To Be Applied:`r`n"

    $Allparams = get-InputParameters

    # loop through regular parameters
    foreach ($param in ($Allparams.keys | Where-Object { $allparams.$_.Type -eq 'Parameter' }) )
    {
        if ($PSBoundParameters.keys -contains $param )
        {
            switch ($Allparams.$param.ExportFileType)
            {
                'Duration'
                {
                    $setParams.add($param, (set-TimeSpan -duration $PSBoundParameters.$param))
                    $configstring += ($param + ':' + ($setParams.$param.tostring()) + "`r`n")
                }

                default
                {
                    $setParams.add($param, $psboundparameters.$param)
                    $configstring += ($param + ':' + $setParams.$param + "`r`n")
                }
            }
        }
        else
        {
            #write-host 'value' $param 'not specified'
        }
    }

    # handle complex parameters - manually for now
    if ($PSBoundParameters.keys -contains 'Assignments' )
    {
        $PSBoundParameters.Assignments | ForEach-Object {
            if ($_ -ne $null) { $assignmentsArray += set-JSONstring -id $_ -type 'Assignments' }
        }
        $configstring += ( 'Assignments' + ":`r`n" + ($PSBoundParameters.Assignments | Out-String) + "`r`n" )
    }
    if ($PSBoundParameters.keys -contains 'ExcludedGroups' )
    {
        $PSBoundParameters.ExcludedGroups | ForEach-Object {
            if ($_ -ne $null) { $assignmentsArray += set-JSONstring -id $_ -type 'ExcludedGroups' }
        }
        $configstring += ( 'ExcludedGroups' + ":`r`n" + ($PSBoundParameters.ExcludedGroups | Out-String) + "`r`n" )

    }
    # set the apps values
    $AppsHash = set-AppsHash -AppGroupType $AppGroupType -apps $apps
    $appshash.Apps | ForEach-Object {
        if ($_ -ne $null) { $appsarray += set-JSONstring -id $_ -type 'Apps' }
    }
    $configstring += ('AppGroupType:' + $appshash.AppGroupType + "`r`n")
    $configstring += ('Apps' + ":`r`n" + ($appshash.Apps | Out-String) + "`r`n" )





    Write-Verbose -Message $configstring

    if (($Ensure -eq 'Present') -and ($currentPolicy.Ensure -eq 'Absent'))
    {
        Write-Verbose -Message "Creating new Android App Protection Policy {$DisplayName}"
        $setParams.add('Assignments', $assignmentsArray)
        $newpolicy = New-MgDeviceAppMgtAndroidManagedAppProtection @setParams
        $setParams.add('AndroidManagedAppProtectionId', $newpolicy.Id)

    }
    elseif (($Ensure -eq 'Present') -and ($currentPolicy.Ensure -eq 'Present'))
    {
        Write-Verbose -Message "Updating existing Android App Protection Policy {$DisplayName}"
        $setParams.add('AndroidManagedAppProtectionId', $currentPolicy.id)
        Update-MgDeviceAppMgtAndroidManagedAppProtection @setParams

        Write-Verbose -Message 'Setting Group Assignments...'
        Set-MgDeviceAppMgtTargetedManagedAppConfiguration -TargetedManagedAppConfigurationId $setParams.AndroidManagedAppProtectionId -Assignments $assignmentsArray

    }
    # now we need to set up the apps
    Write-Verbose -Message ('Setting Application values of type: ' + $AppsHash.AppGroupType)
    Invoke-MgTargetDeviceAppMgtTargetedManagedAppConfigurationApp -TargetedManagedAppConfigurationId $setParams.AndroidManagedAppProtectionId -Apps $appsarray -AppGroupType $AppsHash.AppGroupType
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
        [System.String[]]
        $Apps,

        [Parameter()]
        [ValidateSet('allApps', 'allMicrosoftApps', 'allCoreMicrosoftApps', 'selectedPublicApps' )]
        [System.String]
        $AppGroupType,

        [Parameter()]
        [System.String[]]
        $Assignments,

        [Parameter()]
        [System.String[]]
        $ExcludedGroups,

        [Parameter()]
        [System.String]
        [ValidateSet('notConfigured', 'microsoftEdge')]
        $ManagedBrowser,

        [Parameter()]
        [System.String]
        $MinimumRequiredAppVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredOSVersion,

        [Parameter()]
        [System.String]
        $MinimumRequiredPatchVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningAppVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningOSVersion,

        [Parameter()]
        [System.String]
        $MinimumWarningPatchVersion,

        [Parameter()]
        [System.Boolean]
        $IsAssigned,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
    Write-Verbose -Message "Testing configuration of Android App Protection Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    if ($CurrentValues.Ensure -eq 'ERROR')
    {

        Throw 'Error when searching for current policy details - Please check verbose output for further detail'

    }

    if ($Ensure -eq 'Absent')
    {
        if ($currentvalues.Ensure -eq 'Present')
        {
            Write-Verbose -Message "Existing Policy {$DisplayName} will be removed"
            return $False
        }
        else
        {
            Write-Verbose -Message "Policy {$DisplayName} already removed"
            return $True
        }
    }

    $targetvalues = @{}

    $Allparams = get-InputParameters

    ($Allparams.keys | Where-Object { $allparams.$_.Type -eq 'Credential' }) | ForEach-Object {
        $CurrentValues.Remove($_) | Out-Null
    }

    # loop through regular parameters
    foreach ($param in ($Allparams.keys | Where-Object { $allparams.$_.Type -eq 'Parameter' }) )
    {
        if ($PSBoundParameters.keys -contains $param )
        {
            switch ($Allparams.$param.ExportFileType)
            {
                'Duration'
                {
                    $targetvalues.add($param, (set-TimeSpan -duration $PSBoundParameters.$param))
                }

                default
                {
                    $targetvalues.add($param, $psboundparameters.$param)
                }
            }
        }
        else
        {
            Write-Verbose -Message ('Unspecified Parameter in Config: ' + $param + '  Current Value Will be retained: ' + $CurrentValues.$param)
        }
    }

    # handle complex parameters - manually for now
    if ($PSBoundParameters.keys -contains 'Assignments' )
    {
        $targetvalues.add('Assignments', $psboundparameters.Assignments)
    }
    else
    {
        Write-Host 'Unspecified Parameter in Config: Assignments - Current Value is:' $CurrentValues.Assignments `
            "`r`nNOTE: Assignments interacts with other values - not specifying may lead to unexpected output"
    }

    if ($PSBoundParameters.keys -contains 'ExcludedGroups' )
    {
        $targetvalues.add('ExcludedGroups', $psboundparameters.ExcludedGroups)
    }
    else
    {
        Write-Host 'Unspecified Parameter in Config: ExcludedGroups - Current Value is:' $CurrentValues.ExcludedGroups `
            "`r`nNOTE: ExcludedGroups interacts with other values - not specifying may lead to unexpected output"
    }

    # set the apps values
    $AppsHash = set-AppsHash -AppGroupType $AppGroupType -apps $apps
    $targetvalues.add('Apps', $AppsHash.Apps)
    $targetvalues.add('AppGroupType', $AppsHash.AppGroupType)
    # wipe out the current apps value if AppGroupType is anything but selectedpublicapps to match the appshash values
    if ($CurrentValues.AppGroupType -ne 'selectedPublicApps') { $CurrentValues.Apps = @() }


    Write-Verbose -Message "Current Values: $((Convert-M365DscHashtableToString -Hashtable $CurrentValues) -replace ';', "`r`n")"
    Write-Verbose -Message "Target Values: $((Convert-M365DscHashtableToString -Hashtable $targetvalues) -replace ';', "`r`n")"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $targetvalues `
        -ValuesToCheck $targetvalues.Keys
    #-verbose

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
        [System.String]
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
        [array]$policies = Get-MgDeviceAppManagementAndroidManagedAppProtection -All:$true -Filter $Filter -ErrorAction Stop
        $i = 1
        $dscContent = ''
        if ($policies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.displayName)" -NoNewline
            $params = @{
                DisplayName           = $policy.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationID         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
            }
            $Results = Get-TargetResource @Params
            #remove the Id value
            $Results.remove('Id') | Out-Null
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
        return ''
    }
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
        throw 'Problem converting input to a timespan - If configuration document is using iso8601 string (e.g. PT15M) try using new-timespan (e.g. new-timespan -minutes 15)'
    }
    return $timespan
}
function set-AppsHash
{
    param (
        [string]$AppGroupType,
        [array]$Apps
    )

    if ($AppGroupType -eq '')
    {
        if ($apps.count -eq 0 ) { $AppGroupType = 'allApps' }
        else { $AppGroupType = 'selectedPublicApps' }
        Write-Verbose -Message "setting AppGroupType to $AppGroupType"
    }

    $appsarray = @()
    if ($AppGroupType -eq 'selectedPublicApps' )
    {
        $appsarray = $apps
    }

    $AppsHash = @{
        'AppGroupType' = $AppGroupType;
        'Apps'         = $appsarray
    }

    return $AppsHash
}

function get-InputParameters
{
    return @{
        AllowedDataStorageLocations             = @{Type = 'Parameter'        ; ExportFileType = 'Array'; };
        AllowedInboundDataTransferSources       = @{Type = 'Parameter'        ; ExportFileType = 'String'; };
        AllowedOutboundClipboardSharingLevel    = @{Type = 'Parameter'        ; ExportFileType = 'String'; };
        AllowedOutboundDataTransferDestinations = @{Type = 'Parameter'        ; ExportFileType = 'String'; };
        ApplicationId                           = @{Type = 'Credential'       ; ExportFileType = 'NA'; };
        ApplicationSecret                       = @{Type = 'Credential'       ; ExportFileType = 'NA'; };
        AppGroupType                            = @{Type = 'ComplexParameter' ; ExportFileType = 'NA'; };
        Apps                                    = @{Type = 'ComplexParameter' ; ExportFileType = 'NA'; };
        Assignments                             = @{Type = 'ComplexParameter' ; ExportFileType = 'NA'; };
        CertificateThumbprint                   = @{Type = 'Credential'       ; ExportFileType = 'NA'; };
        Managedidentity                         = @{Type = 'Credential'       ; ExportFileType = 'NA'; };
        ContactSyncBlocked                      = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        Credential                              = @{Type = 'Credential'       ; ExportFileType = 'NA'; };
        DataBackupBlocked                       = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        Description                             = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        DeviceComplianceRequired                = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        DisableAppPinIfDevicePinIsSet           = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        DisplayName                             = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        Ensure                                  = @{Type = 'ComplexParameter' ; ExportFileType = 'NA'; };
        ExcludedGroups                          = @{Type = 'ComplexParameter' ; ExportFileType = 'NA'; };
        FingerprintBlocked                      = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        IsAssigned                              = @{Type = 'ComplexParameter' ; ExportFileType = 'NA'; };
        ManagedBrowser                          = @{Type = 'Parameter'        ; ExportFileType = 'String'; };
        ManagedBrowserToOpenLinksRequired       = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        MaximumPinRetries                       = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        MinimumPinLength                        = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        MinimumRequiredAppVersion               = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        MinimumRequiredOSVersion                = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        MinimumRequiredPatchVersion             = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        MinimumWarningAppVersion                = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        MinimumWarningOSVersion                 = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        MinimumWarningPatchVersion              = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        OrganizationalCredentialsRequired       = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        PeriodBeforePinReset                    = @{Type = 'Parameter'        ; ExportFileType = 'Duration'; };
        PeriodOfflineBeforeAccessCheck          = @{Type = 'Parameter'        ; ExportFileType = 'Duration'; };
        PeriodOfflineBeforeWipeIsEnforced       = @{Type = 'Parameter'        ; ExportFileType = 'Duration'; };
        PeriodOnlineBeforeAccessCheck           = @{Type = 'Parameter'        ; ExportFileType = 'Duration'; };
        PinCharacterSet                         = @{Type = 'Parameter'        ; ExportFileType = 'String'; };
        PinRequired                             = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        PrintBlocked                            = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        SaveAsBlocked                           = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        ScreenCaptureBlocked                    = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        SimplePinBlocked                        = @{Type = 'Parameter'        ; ExportFileType = 'NA'; };
        TenantId                                = @{Type = 'Credential'       ; ExportFileType = 'NA'; }
    }
}

Export-ModuleMember -Function *-TargetResource
