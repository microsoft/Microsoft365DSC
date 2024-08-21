function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $AccountName,

        [Parameter()]
        [ValidateSet('userDefined', 'oneDay', 'threeDays', 'oneWeek', 'twoWeeks', 'oneMonth', 'unlimited')]
        [System.String]
        $DurationOfEmailToSync,

        [Parameter()]
        [ValidateSet('userPrincipalName', 'primarySmtpAddress')]
        [System.String]
        $EmailAddressSource,

        [Parameter()]
        [ValidateSet('userDefined', 'asMessagesArrive', 'manual', 'fifteenMinutes', 'thirtyMinutes', 'sixtyMinutes', 'basedOnMyUsage')]
        [System.String]
        $EmailSyncSchedule,

        [Parameter()]
        [System.String]
        $HostName,

        [Parameter()]
        [System.Boolean]
        $RequireSsl,

        [Parameter()]
        [System.Boolean]
        $SyncCalendar,

        [Parameter()]
        [System.Boolean]
        $SyncContacts,

        [Parameter()]
        [System.Boolean]
        $SyncTasks,

        [Parameter()]
        [System.String]
        $CustomDomainName,

        [Parameter()]
        [ValidateSet('fullDomainName', 'netBiosDomainName')]
        [System.String]
        $UserDomainNameSource,

        [Parameter()]
        [ValidateSet('userPrincipalName', 'primarySmtpAddress', 'samAccountName')]
        [System.String]
        $UsernameAADSource,

        [Parameter()]
        [ValidateSet('userPrincipalName', 'primarySmtpAddress')]
        [System.String]
        $UsernameSource,

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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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
        $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $Id -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Configuration Email Profile Policy for Windows10 with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
                    -Filter "DisplayName eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue | Where-Object `
                    -FilterScript { `
                        $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10EasEmailProfileConfiguration' `
                }

                if ($null -eq $getValue)
                {
                    Write-Verbose -Message "Could not find an Intune Device Configuration Email Profile Policy for Windows10 with DisplayName {$DisplayName}"
                    return $nullResult
                }
                if (([array]$getValue).count -gt 1)
                {
                    throw "A policy with a duplicated displayName {'$DisplayName'} was found - Ensure displayName is unique"
                }
            }
        }
        #endregion

        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Configuration Email Profile Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $enumDurationOfEmailToSync = $null
        if ($null -ne $getValue.AdditionalProperties.durationOfEmailToSync)
        {
            $enumDurationOfEmailToSync = $getValue.AdditionalProperties.durationOfEmailToSync.ToString()
        }

        $enumEmailAddressSource = $null
        if ($null -ne $getValue.AdditionalProperties.emailAddressSource)
        {
            $enumEmailAddressSource = $getValue.AdditionalProperties.emailAddressSource.ToString()
        }

        $enumEmailSyncSchedule = $null
        if ($null -ne $getValue.AdditionalProperties.emailSyncSchedule)
        {
            $enumEmailSyncSchedule = $getValue.AdditionalProperties.emailSyncSchedule.ToString()
        }

        $enumUserDomainNameSource = $null
        if ($null -ne $getValue.AdditionalProperties.userDomainNameSource)
        {
            $enumUserDomainNameSource = $getValue.AdditionalProperties.userDomainNameSource.ToString()
        }

        $enumUsernameAADSource = $null
        if ($null -ne $getValue.AdditionalProperties.usernameAADSource)
        {
            $enumUsernameAADSource = $getValue.AdditionalProperties.usernameAADSource.ToString()
        }

        $enumUsernameSource = $null
        if ($null -ne $getValue.AdditionalProperties.usernameSource)
        {
            $enumUsernameSource = $getValue.AdditionalProperties.usernameSource.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            AccountName           = $getValue.AdditionalProperties.accountName
            DurationOfEmailToSync = $enumDurationOfEmailToSync
            EmailAddressSource    = $enumEmailAddressSource
            EmailSyncSchedule     = $enumEmailSyncSchedule
            HostName              = $getValue.AdditionalProperties.hostName
            RequireSsl            = $getValue.AdditionalProperties.requireSsl
            SyncCalendar          = $getValue.AdditionalProperties.syncCalendar
            SyncContacts          = $getValue.AdditionalProperties.syncContacts
            SyncTasks             = $getValue.AdditionalProperties.syncTasks
            CustomDomainName      = $getValue.AdditionalProperties.customDomainName
            UserDomainNameSource  = $enumUserDomainNameSource
            UsernameAADSource     = $enumUsernameAADSource
            UsernameSource        = $enumUsernameSource
            Description           = $getValue.Description
            DisplayName           = $getValue.DisplayName
            Id                    = $getValue.Id
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            Managedidentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
            #endregion
        }

        $returnAssignments = @()
        $graphAssignments = Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $Id
        if ($graphAssignments.count -gt 0)
        {
            $returnAssignments += ConvertFrom-IntunePolicyAssignment `
                -IncludeDeviceFilter:$true `
                -Assignments ($graphAssignments)
        }
        $results.Add('Assignments', $returnAssignments)

        return [System.Collections.Hashtable] $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        $nullResult = Clear-M365DSCAuthenticationParameter -BoundParameters $nullResult
        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $AccountName,

        [Parameter()]
        [ValidateSet('userDefined', 'oneDay', 'threeDays', 'oneWeek', 'twoWeeks', 'oneMonth', 'unlimited')]
        [System.String]
        $DurationOfEmailToSync,

        [Parameter()]
        [ValidateSet('userPrincipalName', 'primarySmtpAddress')]
        [System.String]
        $EmailAddressSource,

        [Parameter()]
        [ValidateSet('userDefined', 'asMessagesArrive', 'manual', 'fifteenMinutes', 'thirtyMinutes', 'sixtyMinutes', 'basedOnMyUsage')]
        [System.String]
        $EmailSyncSchedule,

        [Parameter()]
        [System.String]
        $HostName,

        [Parameter()]
        [System.Boolean]
        $RequireSsl,

        [Parameter()]
        [System.Boolean]
        $SyncCalendar,

        [Parameter()]
        [System.Boolean]
        $SyncContacts,

        [Parameter()]
        [System.Boolean]
        $SyncTasks,

        [Parameter()]
        [System.String]
        $CustomDomainName,

        [Parameter()]
        [ValidateSet('fullDomainName', 'netBiosDomainName')]
        [System.String]
        $UserDomainNameSource,

        [Parameter()]
        [ValidateSet('userPrincipalName', 'primarySmtpAddress', 'samAccountName')]
        [System.String]
        $UsernameAADSource,

        [Parameter()]
        [ValidateSet('userPrincipalName', 'primarySmtpAddress')]
        [System.String]
        $UsernameSource,

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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion
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
        Write-Verbose -Message "Creating an Intune Device Configuration Email Profile Policy for Windows10 with DisplayName {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$BoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$CreateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $CreateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
            }
        }
        #region resource generator code
        $CreateParameters.Add('@odata.type', '#microsoft.graph.windows10EasEmailProfileConfiguration')
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
        Write-Verbose -Message "Updating the Intune Device Configuration Email Profile Policy for Windows10 with Id {$($currentInstance.Id)}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = ([Hashtable]$BoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$UpdateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
        }
        #region resource generator code
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.windows10EasEmailProfileConfiguration')
        Update-MgBetaDeviceManagementDeviceConfiguration  `
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
        Write-Verbose -Message "Removing the Intune Device Configuration Email Profile Policy for Windows10 with Id {$($currentInstance.Id)}"
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
        [System.String]
        $AccountName,

        [Parameter()]
        [ValidateSet('userDefined', 'oneDay', 'threeDays', 'oneWeek', 'twoWeeks', 'oneMonth', 'unlimited')]
        [System.String]
        $DurationOfEmailToSync,

        [Parameter()]
        [ValidateSet('userPrincipalName', 'primarySmtpAddress')]
        [System.String]
        $EmailAddressSource,

        [Parameter()]
        [ValidateSet('userDefined', 'asMessagesArrive', 'manual', 'fifteenMinutes', 'thirtyMinutes', 'sixtyMinutes', 'basedOnMyUsage')]
        [System.String]
        $EmailSyncSchedule,

        [Parameter()]
        [System.String]
        $HostName,

        [Parameter()]
        [System.Boolean]
        $RequireSsl,

        [Parameter()]
        [System.Boolean]
        $SyncCalendar,

        [Parameter()]
        [System.Boolean]
        $SyncContacts,

        [Parameter()]
        [System.Boolean]
        $SyncTasks,

        [Parameter()]
        [System.String]
        $CustomDomainName,

        [Parameter()]
        [ValidateSet('fullDomainName', 'netBiosDomainName')]
        [System.String]
        $UserDomainNameSource,

        [Parameter()]
        [ValidateSet('userPrincipalName', 'primarySmtpAddress', 'samAccountName')]
        [System.String]
        $UsernameAADSource,

        [Parameter()]
        [ValidateSet('userPrincipalName', 'primarySmtpAddress')]
        [System.String]
        $UsernameSource,

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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

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

    Write-Verbose -Message "Testing configuration of the Intune Device Configuration Email Profile Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    if (-not (Test-M365DSCAuthenticationParameter -BoundParameters $CurrentValues))
    {
        Write-Verbose "An error occured in Get-TargetResource, the policy {$displayName} will not be processed"
        throw "An error occured in Get-TargetResource, the policy {$displayName} will not be processed. Refer to the event viewer logs for more information."
    }
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -ne $Ensure)
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

    $ValuesToCheck.remove('Id') | Out-Null

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

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
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10EasEmailProfileConfiguration' `
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
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @params
            if (-not (Test-M365DSCAuthenticationParameter -BoundParameters $Results))
            {
                Write-Verbose "An error occured in Get-TargetResource, the policy {$($params.displayName)} will not be processed"
                throw "An error occured in Get-TargetResource, the policy {$($params.displayName)} will not be processed. Refer to the event viewer logs for more information."
            }
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
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
                $_.Exception -like '*Request not applicable to target tenant*')
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

Export-ModuleMember -Function *-TargetResource
