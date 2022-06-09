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
    # beta profile as previous graph call used beta and it returns more data
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' -ProfileName beta `
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
                #write-host '#######'  $assignment.Target.AdditionalProperties.'@odata.type'
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

        $ComplexParameters = @{
            'Apps' = $appsArray;
            'Assignments' = $assignmentsArray;
            'ExcludedGroups' = $exclusionArray
        }

        $AllParams = (get-command Get-TargetResource).Parameters
        ($AllParams.keys | Where-Object { $AllParams.$_.Aliases.count -ne 0 } ) | foreach {$allparams.remove($_) | out-null}
        $AllParams.add('id', 'Placeholder')

        $policy = @{}
        foreach ($property in ($policyInfo | get-member -MemberType properties))
        {
            if (!($ComplexParameters.keys -contains $property.name) -and ($AllParams.keys -contains $property.name))
            {
                $policy.add($property.name, $policyInfo.($property.name) )
            }
        }

        $ComplexParameters.keys | foreach { $policy.add($_, $ComplexParameters.$_ ) }
        $policy.add('Ensure', 'Present' )

        return $policy
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

    $AppsHash = set-AppsHash -AppGroupType $AppGroupType -apps $apps

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
            #write-verbose -message "Cannot specify this in graph cmdlet: $param"
        }
    }

    foreach ($param in $ComplexParameters)
    {
        switch ($param)
        {
            'AppGroupType'
            {
                $configstring += ('AppGroupType:' + $appshash.AppGroupType + "`r`n")
            }

            'Apps'
            {
                if ($appshash.AppGroupType -eq 'selectedPublicApps' )
                {
                    $appshash.Apps | foreach {
                        if ($_ -ne $null) {$appsarray+= set-JSONstring -id $_ -type $param}
                    }
                    $configstring += ($param + ":`r`n" +($appshash.Apps | out-string) + "`r`n" )
                }
            }

            'Assignments'
            {
                $PSBoundParameters.$param | foreach {
                    if ($_ -ne $null) {$assignmentsArray+= set-JSONstring -id $_ -type $param}
                }
                $configstring += ( $param + ":`r`n" +($PSBoundParameters.$param | out-string) + "`r`n" )
            }

            'ExcludedGroups'
            {
                $PSBoundParameters.$param | foreach {
                    if ($_ -ne $null) {$assignmentsArray+= set-JSONstring -id $_ -type $param}
                }
                $configstring += ($param + ":`r`n" +($PSBoundParameters.$param | out-string) + "`r`n" )
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

        Write-Verbose -Message 'Setting Group Assignments...'
        set-MgDeviceAppMgtTargetedManagedAppConfiguration -TargetedManagedAppConfigurationId $setParams.AndroidManagedAppProtectionId -Assignments $assignmentsArray

    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Android App Protection Policy {$DisplayName}"
        $policyInfo = Get-MgDeviceAppManagementAndroidManagedAppProtection -Filter "displayName eq '$DisplayName'" `
            -ErrorAction Stop
        Remove-MgDeviceAppManagementAndroidManagedAppProtection -AndroidManagedAppProtectionId $policyInfo.id
    }

    if ( $ensure -ne 'Absent')
    {
        write-verbose -message ("Setting Application values of type: " + $AppsHash.AppGroupType)
        Invoke-MgTargetDeviceAppMgtTargetedManagedAppConfigurationApp -TargetedManagedAppConfigurationId $setParams.AndroidManagedAppProtectionId -Apps $appsarray -AppGroupType $AppsHash.AppGroupType
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

    if ($CurrentValues.AppGroupType -ne 'SelectedPublicApps') { $CurrentValues.Apps = @() }

    if ($CurrentValues.Ensure -eq "ERROR")
    {

        Throw 'Error when searching for current policy details - Please check verbose output for further detail'

    }

    $ValuesToCheck = @{}

    $ComplexParameters = @(
        'AppGroupType',
        'Apps',
        'Assignments',
        'ExcludedGroups'
    )

    $credentialParams = @(
        'Credential',
        'ApplicationId',
        'TenantId',
        'ApplicationSecret',
        'CertificateThumbprint'
    )

    ($allparams = (get-command Test-TargetResource).Parameters).keys | foreach {

        if(!($PSBoundParameters.keys -contains $allparams.$_.name) -and ($allparams.$_.Aliases.count -eq 0) -and !($credentialParams -contains $_) )
        {
            if ($ComplexParameters -contains $allparams.$_.name)
            {
                write-host 'Unspecified Parameter in Config:' $allparams.$_.name  "- Current Value is:" $CurrentValues.$_ `
                "`r`nNOTE:" $allparams.$_.name "interacts with other values - not specifying may lead to unexpected output"
                # set to '' at this stage - the apps values are configured below
                $ValuesToCheck.add( ($allparams.$_.name) , '')
            }
            else
            {
                write-host 'Unspecified Parameter in Config:' $allparams.$_.name  "Current Value Will be retained:" $CurrentValues.$_
                #$ValuesToCheck.add( ($allparams.$_.name) , '')
            }
        }
    }

    $AppsHash = set-AppsHash -AppGroupType $AppGroupType -apps $apps
    $PSBoundParameters.AppGroupType = $AppsHash.AppGroupType
    $PSBoundParameters.Apps = $AppsHash.Apps

    #$ValuesToCheck = $PSBoundParameters
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove("CertificateThumbprint") | Out-Null

    $PSBoundParameters.keys | foreach {
        if ($currentvalues.$_ -ne $null)
        {
            if ($currentvalues.$_.gettype().name -eq 'TimeSpan') { $ValuesToCheck.$_ = set-timespan -duration $PSBoundParameters.$_ }
            else{ $ValuesToCheck.$_ = $PSBoundParameters.$_ }
        }
        else{ $ValuesToCheck.$_ = $PSBoundParameters.$_ }
    }


    Write-Verbose -Message "Current Values: $((Convert-M365DscHashtableToString -Hashtable $CurrentValues) -replace ';', "`r`n")"
    Write-Verbose -Message "Target Values: $((Convert-M365DscHashtableToString -Hashtable $ValuesToCheck) -replace ';', "`r`n")"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $ValuesToCheck `
        -ValuesToCheck $ValuesToCheck.Keys `
        -verbose

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
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' -ProfileName v1.0 `
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
            write-host ($Results | out-string)
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

function get-inputParamsList
{
    param(
        [string]$commandName
    )

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
        write-verbose -message "setting AppGroupType to $AppGroupType"
    }

    $appsarray = @()
    if ($AppGroupType -eq 'selectedPublicApps' )
    {
        $appsarray = $apps
    }

    $AppsHash = @{
        'AppGroupType' = $AppGroupType;
        'Apps' = $appsarray
    }

    return $AppsHash
}


Export-ModuleMember -Function *-TargetResource
