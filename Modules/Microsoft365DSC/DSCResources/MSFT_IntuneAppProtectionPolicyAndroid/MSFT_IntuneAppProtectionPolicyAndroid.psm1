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
    # could we do this better?  I'm sure we could
    $PSBoundParameters.Remove("ApplicationID") | Out-Null
    $PSBoundParameters.Remove("ApplicationSecret") | Out-Null
    $PSBoundParameters.Remove("TenantID") | Out-Null
    $PSBoundParameters.Remove("CertificateThumbprint") | Out-Null

    $assignmentsArray = @()

    # removing known problematic values until i can fix them...
    #$PSBoundParameters.Remove("PeriodOfflineBeforeAccessCheck") | out-null
    #$PSBoundParameters.Remove("PeriodOnlineBeforeAccessCheck") | out-null
    #$PSBoundParameters.Remove("PeriodOfflineBeforeWipeIsEnforced") | out-null
    #$PSBoundParameters.Remove("PeriodBeforePinReset") | out-null
    #$PSBoundParameters.Remove("Apps") | out-null
    #$PSBoundParameters.Remove("Assignments") | out-null


    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Android App Protection Policy {$DisplayName}"

        # construct command
        $graphparams = get-inputParamsList
        foreach ($param in $PSBoundParameters.keys)
        {
            write-verbose "########################### $param ########################"
            if ( $graphparams.containskey($param) )
            {

                write-host 'we have a match with:' $param 'Type is:' $graphparams.$param.ParameterType.name
                # we need to see if our input is valid (timespan is particulalry important as the direct graph values seem to be different)
                switch ($graphparams.$param.ParameterType.name)
                {
                    'TimeSpan'
                    {
                        write-verbose 'we need to see if this can be interpreted as a timespan'
                        $setParams.add($param, (set-TimeSpan -duration $PSBoundParameters.$param))
                        #[TimeSpan]$PSBoundParameters.$param
                    }

                    'string'
                    {
                        write-verbose 'Adding value as entered...'
                        $setParams.add($param, $PSBoundParameters.$param)
                    }

                    'IMicrosoftGraphManagedMobileApp[]'
                    {
                            # This parameter accepts an array of json snippets
                            write-verbose -message "Constructing Apps Object for $param..."
                            write-verbose -message ($PSBoundParameters.$param.gettype())
                            write-verbose -message (' count: ' + $PSBoundParameters.$param.count)
                            $apparray = @()

                            $PSBoundParameters.$param | foreach {

                                write-verbose -message ('value: ' + $_)

                                $appsValue = @"
                                        {
                                        "id":"$($_)",
                                        "mobileAppIdentifier": {
                                            "@odata.type": "#microsoft.graph.AndroidMobileAppIdentifier",
                                            "packageId": "$_"
                                        }
                                    }
"@
                                $apparray+= $appsValue
                            }
                            $setParams.add($param, $apparray)
                    }

                    'IMicrosoftGraphTargetedManagedAppPolicyAssignment1[]'
                    {
                        # could be either assignments or excludedgroups but we only get here with assignments (at the moment)
                        # because we may need to complete it twice we don't add this to the params list until the end
                        write-verbose -message "Collecting Role Assignments Data for $param..."
                        write-verbose -message ($PSBoundParameters.$param.gettype())
                        write-verbose -message (' count: ' + $PSBoundParameters.$param.count)

                        $PSBoundParameters.$param | foreach {
                            $assignmentsArray += @{
                                                    'ID' = $_;
                                                    'Type' = 'incl';
                                                    'ODataType' = 'GroupAssignmentTarget'
                                                }
                            }
                    }

                    default
                    {

                        if ($graphparams.$param.ParameterType.name.endswith('[]'))
                        {
                            write-verbose -message 'Array required...'
                            write-host $PSBoundParameters.$param.gettype() 'count:' $PSBoundParameters.$param.count
                            write-host $PSBoundParameters.$param
                            $setParams.add($param, $PSBoundParameters.$param)
                        }
                        else
                        {
                            write-verbose 'Adding value as entered...'
                            $setParams.add($param, $PSBoundParameters.$param)
                        }
                    }


                }


            }
            else
            {
                if ($param -eq 'excludedgroups')
                {
                    write-verbose -message "Collecting Role Assignments Data for $param..."
                    write-verbose -message ($PSBoundParameters.$param.gettype())
                    write-verbose -message (' count: ' + $PSBoundParameters.$param.count)
                    $PSBoundParameters.$param | foreach {
                        $assignmentsArray += @{
                                                'ID' = $_;
                                                'Type' = 'excl';
                                                'ODataType' = 'exclusionGroupAssignmentTarget'
                                            }
                        }

                }
                else
                {
                    write-verbose -message "Cannot specify this in graph cmdlet: $param"
                }
            }
        }

        # check if included or excluded groups gathered and assign
        if ($assignmentsArray.count -gt 0)
        {
            write-verbose -message "Setting group assignments..."
            $AssignmentsCombined= @()

            $assignmentsArray | foreach {

                $JsonContent = @"
                                {
                                "id":"$($_.id)_$($_.Type))",
                                "target": {
                                            "@odata.type": "#microsoft.graph.$($_.ODataType)",
                                            "groupId": "$($_.id)"
                                        }
                                }
"@
                $AssignmentsCombined+= $JsonContent

                write-verbose $JsonContent
            }



            $setParams.add('Assignments', $AssignmentsCombined)


        }

        write-verbose $setParams.PeriodBeforePinReset
        #let's try to splat it.. if I can rememeber how to splat
        Write-Verbose -Message 'Setting up policy via graph...'
        New-MgDeviceAppMgtAndroidManagedAppProtection @setParams


        #$JsonContent = Get-M365DSCIntuneAppProtectionPolicyAndroidJSON -Parameters $PSBoundParameters
        $JsonContent = Get-M365DSCIntuneAppProtectionPolicyAndroidJSON -Parameters $setParams
        Write-Verbose -Message "JSON: $JsonContent"
        <#
        New-M365DSCIntuneAppProtectionPolicyAndroid -JSONContent $JsonContent

        $policyInfo = Get-MgDeviceAppManagementAndroidManagedAppProtection -Filter "displayName eq '$DisplayName'" `
            -ErrorAction Stop
        $assignmentJSON = Get-M365DSCIntuneAppProtectionPolicyAndroidAssignmentJson -Assignments $Assignments `
            -Exclusions $ExcludedGroups

        Set-M365DSCIntuneAppProtectionPolicyAndroidAssignment -JsonContent $assignmentJSON `
            -PolicyId $policyInfo.Id
        #>
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Android App Protection Policy {$DisplayName}"
        $policyInfo = Get-MgDeviceAppManagementAndroidManagedAppProtection -Filter "displayName eq '$DisplayName'" `
            -ErrorAction Stop

        $JsonContent = Get-M365DSCIntuneAppProtectionPolicyAndroidJSON -Parameters $PSBoundParameters `
            -IncludeApps $false
        Set-M365DSCIntuneAppProtectionPolicyAndroid -JSONContent $JsonContent `
            -PolicyId ($policyInfo.id)

        $appJSON = Get-M365DSCIntuneAppProtectionPolicyAndroidAppsJSON -Parameters $PSBoundParameters
        Set-M365DSCIntuneAppProtectionPolicyAndroidApps -JSONContent $appJSON `
            -PolicyId $policyInfo.Id

    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Android App Protection Policy {$DisplayName}"
        $policyInfo = Get-MgDeviceAppManagementAndroidManagedAppProtection -Filter "displayName eq '$DisplayName'" `
            -ErrorAction Stop
        Remove-MgDeviceAppManagementAndroidManagedAppProtection -AndroidManagedAppProtectionId $policyInfo.id
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

function Get-M365DSCIntuneAppProtectionPolicyAndroidJSON
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Parameters,

        [Parameter()]
        [System.Boolean]
        $IncludeApps = $true
    )

    #region AllowedDataStorageLocations
    $allowedDataStorageLocations = "["
    $foundOne = $false
    foreach ($allowedLocation in $Parameters.AllowedDataStorageLocations)
    {
        $foundOne = $true
        $allowedDataStorageLocations += "`r`n`"$allowedLocation`","
    }
    if ($foundOne)
    {
        $allowedDataStorageLocations = $allowedDataStorageLocations.TrimEnd(',') + " `r`n"
    }
    $allowedDataStorageLocations += "],"
    #endregion

    #region Apps
    $appsValue = "["
    $foundOne = $false
    foreach ($app in $Parameters.Apps)
    {
        $foundOne = $true

        $appsValue += @"
            `r`n{
                "id":"$($app)",
                "mobileAppIdentifier": {
                    "@odata.type": "#microsoft.graph.androidMobileAppIdentifier",
                    "packageId": "$app"
                }
            },
"@
    }
    if ($foundOne)
    {
        $appsValue = $appsValue.TrimEnd(',') + " `r`n"
    }
    $appsValue += "]"
    #endregion
    $JsonContent = @"
    {
        "@odata.type": "#microsoft.graph.androidManagedAppProtection",
        "displayName": "$($Parameters.DisplayName)",
        "description": "$($Parameters.Description)",
        "periodOfflineBeforeAccessCheck": "$($Parameters.PeriodOfflineBeforeAccessCheck)",
        "periodOnlineBeforeAccessCheck": "$($Parameters.PeriodOnlineBeforeAccessCheck)",
        "allowedInboundDataTransferSources": "$($Parameters.AllowedInboundDataTransferSources)",
        "allowedOutboundDataTransferDestinations": "$($Parameters.AllowedOutboundDataTransferDestinations)",
        "organizationalCredentialsRequired": $($Parameters.OrganizationalCredentialsRequired.ToString().ToLower()),
        "allowedOutboundClipboardSharingLevel": "$($Parameters.AllowedOutboundClipboardSharingLevel)",
        "dataBackupBlocked": $($Parameters.DataBackupBlocked.ToString().ToLower()),
        "deviceComplianceRequired": $($Parameters.DeviceComplianceRequired.ToString().ToLower()),
        "managedBrowserToOpenLinksRequired": $($Parameters.ManagedBrowserToOpenLinksRequired.ToString().ToLower()),
        "saveAsBlocked": $($Parameters.SaveAsBlocked.ToString().ToLower()),
        "periodOfflineBeforeWipeIsEnforced": "$($Parameters.PeriodOfflineBeforeWipeIsEnforced)",
        "pinRequired": $($Parameters.PinRequired.ToString().ToLower()),
        "disableAppPinIfDevicePinIsSet": $($Parameters.DisableAppPinIfDevicePinIsSet.ToString().ToLower()),
        "maximumPinRetries": $($Parameters.MaximumPinRetries),
        "simplePinBlocked": $($Parameters.SimplePinBlocked.ToString().ToLower()),
        "minimumPinLength": $($Parameters.MinimumPinLength),
        "pinCharacterSet": "$($Parameters.PinCharacterSet)",
        "contactSyncBlocked": $($Parameters.ContactSyncBlocked.ToString().ToLower()),
        "periodBeforePinReset": "$($Parameters.PeriodBeforePinReset)",
        "printBlocked": $($Parameters.PrintBlocked.ToString().ToLower()),
        "fingerprintBlocked": $($Parameters.FingerprintBlocked.ToString().ToLower()),
        "allowedDataStorageLocations": $allowedDataStorageLocations
"@

    if ($IncludeApps)
    {
        $JSOnContent += "`"apps`":$appsValue`r`n"
    }
    $JsonContent += "}"
    return $JsonContent
}

function Get-M365DSCIntuneAppProtectionPolicyAndroidAppsJSON
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Parameters
    )

    #region Apps
    $appsValue = "["
    $foundOne = $false
    foreach ($app in $Parameters.Apps)
    {
        $foundOne = $true

        $appsValue += @"
            `r`n{
                "id":"$($app)",
                "mobileAppIdentifier": {
                    "@odata.type": "#microsoft.graph.AndroidMobileAppIdentifier",
                    "packageId": "$app"
                }
            },
"@
    }
    if ($foundOne)
    {
        $appsValue = $appsValue.TrimEnd(',') + " `r`n"
    }
    $appsValue += "]"
    #endregion

    $JsonContent = @"
    {
        "apps": $appsValue
    }
"@
    return $JsonContent
}

function Get-M365DSCIntuneAppProtectionPolicyAndroidAssignmentJSON
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String[]]
        $Assignments,

        [Parameter(Mandatory = $false)]
        [System.String[]]
        $Exclusions
    )

    $JsonContent = "{`r`n"
    $JsonContent += "`"assignments`":[`r`n"
    foreach ($assignment in $Assignments)
    {
        $JsonContent += "    {`"target`":{`r`n"
        $JsonContent += "        `"groupId`":`"$assignment`",`r`n"
        $JsonContent += "        `"@odata.type`":`"#microsoft.graph.groupAssignmentTarget`"`r`n"
        $JsonContent += "    }},"
    }
    foreach ($exclusion in $Exclusions)
    {
        $JsonContent += "    {`"target`":{`r`n"
        $JsonContent += "        `"groupId`":`"$exclusion`",`r`n"
        $JsonContent += "        `"@odata.type`":`"#microsoft.graph.exclusionGroupAssignmentTarget`"`r`n"
        $JsonContent += "    }},"
    }
    $JsonContent = $JsonContent.TrimEnd(',')
    $JsonContent += "]`r`n"
    $JsonContent += "`r`n}"

    return $JsonContent
}

function New-M365DSCIntuneAppProtectionPolicyAndroid
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $JSONContent
    )
    try
    {
        $Url = 'https://graph.microsoft.com/beta/deviceAppManagement/managedAppPolicies'
        Write-Verbose -Message "Creating new Android App Protection policy with JSON payload: `r`n$JSONContent"
        Invoke-MgGraphRequest -Method POST `
            -Uri $Url `
            -Body $JSONContent `
            -Headers @{"Content-Type" = "application/json" } | Out-Null
    }
    catch
    {
        Write-Verbose -Message $_
        $tenantIdValue = $Credential.UserName.Split('@')[1]
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $tenantIdValue
    }
}

function Set-M365DSCIntuneAppProtectionPolicyAndroid
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $JSONContent,

        [Parameter(Mandatory = $true)]
        [System.String]
        $PolicyId
    )
    try
    {
        $Url = "https://graph.microsoft.com/beta/deviceAppManagement/androidManagedAppProtections('$PolicyId')/"
        Write-Verbose -Message "Updating Android App Protection policy with JSON payload: `r`n$JSONContent"
        Invoke-MgGraphRequest -Method PATCH `
            -Uri $Url `
            -Body $JSONContent `
            -Headers @{"Content-Type" = "application/json" } | Out-Null
    }
    catch
    {
        Write-Verbose -Message $_
        $tenantIdValue = $Credential.UserName.Split('@')[1]
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $tenantIdValue
    }
}

function Set-M365DSCIntuneAppProtectionPolicyAndroidApps
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $JSONContent,

        [Parameter(Mandatory = $true)]
        [System.String]
        $PolicyId
    )
    try
    {
        $Url = "https://graph.microsoft.com/beta/deviceAppManagement/managedAppPolicies/$PolicyId/targetApps"
        Write-Verbose -Message "Updating Apps for Android App Protection policy with JSON payload: `r`n$JSONContent"
        Invoke-MgGraphRequest -Method POST `
            -Uri $Url `
            -Body $JSONContent `
            -Headers @{"Content-Type" = "application/json" } | Out-Null
    }
    catch
    {
        Write-Verbose -Message $_
        $tenantIdValue = $Credential.UserName.Split('@')[1]
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $tenantIdValue
    }
}

function Set-M365DSCIntuneAppProtectionPolicyAndroidAssignment
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $JSONContent,

        [Parameter(Mandatory = $true)]
        [System.String]
        $PolicyId
    )
    try
    {
        $Url = "https://graph.microsoft.com/beta/deviceAppManagement/androidManagedAppProtections('$PolicyId')/assign"
        Write-Verbose -Message "Group Assignment for Android App Protection policy with JSON payload: `r`n$JSONContent"
        Invoke-MgGraphRequest -Method POST `
            -Uri $Url `
            -Body $JSONContent `
            -Headers @{"Content-Type" = "application/json" } | Out-Null
    }
    catch
    {
        Write-Verbose -Message $_
        $tenantIdValue = $Credential.UserName.Split('@')[1]
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $tenantIdValue
    }
}


function get-inputParamsList
{

    # it seems a daft function at the moment but I'm hoping wI can use it to set up dynamic parameters for the functions at some point and I'll probably need to work on it then
    $Graphparams = (get-command New-MgDeviceAppMgtAndroidManagedAppProtection).Parameters

    return $Graphparams

}

function set-Timespan
{
    param(
        [string]$duration
    )

    write-verbose -message "converting to timespan - I hope: $duration"

    try
    {
        if ($duration.startswith('P'))
        {
            write-verbose -message 'looks like a iso8601 string'
            $timespan = [System.Xml.XmlConvert]::ToTimeSpan($duration)
        }
        else
        {
            write-verbose -message 'assuming it can be converted straight to a timespan'
            $timespan = [TimeSpan]$duration
        }
    }
    catch
    {
        throw "Problem converting input to a timespan - If configuration document is using iso8601 string (e.g. PT15M) try using new-timespan (e.g. new-timespan -minutes 15)"
    }

    return $timespan

}


Export-ModuleMember -Function *-TargetResource
