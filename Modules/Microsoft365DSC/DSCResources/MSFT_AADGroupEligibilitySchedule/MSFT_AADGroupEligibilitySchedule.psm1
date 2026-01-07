Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADGroupEligibilitySchedule'

function Get-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [ValidateSet('owner', 'member', 'unknownFutureValue')]
        [System.String]
        $AccessId,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupDisplayName,

        [Parameter()]
        [ValidateSet('direct', 'group', 'unknownFutureValue')]
        [System.String]
        $MemberType,

        [Parameter()]
        [System.String]
        $PrincipalType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Principal,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ScheduleInfo,

        [Parameter()]
        [System.String]
        $Id,
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

    Write-Verbose -Message "Getting configuration of the Azure AD Group {$GroupDisplayName} Eligibility Schedule"

    try
    {
        if (-not $Script:exportedInstance)
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
            if ([System.String]::IsNullOrEmpty($GroupId))
            {
                $Filter = "DisplayName eq '" + $GroupDisplayName + "'"
                $Script:CurrentGroup = Get-MgGroup -Filter $Filter

                if ([string]::IsNullOrEmpty($Script:CurrentGroup))
                {
                    Write-Verbose -Message "Could not find an valid Azure AD Group with name $GroupDisplayName "
                    return $nullResult
                }

                $GroupId = $Script:CurrentGroup.Id
            }
            if ($Id -notmatch '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}_(member|owner)_[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$') {
                Write-Verbose "ID didn't match GUID_accessID_GUID doing lookup by GroupID : $GroupId"
                $schedules = Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule `
                    -All `
                    -Filter "Groupid eq '$GroupId'" `
                    -ErrorAction SilentlyContinue

                switch ($PrincipalType)
                {
                    'user' {
                        Write-Verbose -Message "Performing Get-MgUser on UserPrincipalName eq $Principal"
                        $PrincipalInstance = Get-MgUser -Filter "UserPrincipalName eq '$Principal'" -ErrorAction SilentlyContinue
                    }
                    default {
                        Write-Verbose -Message "Performing Get-MgGroup on DisplayName eq $Principal"
                        $PrincipalInstance = Get-MgGroup -Filter "DisplayName eq '$Principal'" -ErrorAction SilentlyContinue
                    }
                }
                $getValue = $($schedules | Where-Object {$_.accessid -eq $AccessId -and $_.principalId -eq $PrincipalInstance.id})
                $id = $getValue.id
                Write-Verbose "Setting Id for schedule to $Id"
            }
            else
            {
                $getValue = Get-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilitySchedule `
                    -PrivilegedAccessGroupEligibilityScheduleId $Id `
                    -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Azure AD Group Eligibility Schedule with {$GroupDisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id

        if ($getValue.GetType().Name -eq 'MicrosoftGraphPrivilegedAccessGroupEligibilitySchedule')
        {
            $newGetValue = @{}
            $getValue | Get-Member -MemberType Property | ForEach-Object {
                $newGetValue[$_.Name] = $getValue.$($_.Name)
            }
            $getValue = $newGetValue
        }

        Write-Verbose -Message "An Azure AD Group Eligibility Schedule with Id {$Id} and DisplayName {$GroupDisplayName} was found"

        #region resource generator code
        $complexScheduleInfo = [ordered]@{}
        $complexExpiration = [ordered]@{}
        $complexExpiration.Add('Duration', $getValue.scheduleInfo.expiration.duration)
        if ($null -ne $getValue.scheduleInfo.expiration.endDateTime)
        {
            $complexExpiration.Add('EndDateTime', ([DateTimeOffset]$getValue.scheduleInfo.expiration.endDateTime).ToString('o'))
        }
        if ($null -ne $getValue.scheduleInfo.expiration.type)
        {
            $complexExpiration.Add('Type', $getValue.scheduleInfo.expiration.type.ToString())
        }
        if ($complexExpiration.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexExpiration = $null
        }
        $complexScheduleInfo.Add('Expiration', $complexExpiration)
        $complexRecurrence = [ordered]@{}
        $complexPattern = [ordered]@{}
        $complexPattern.Add('DayOfMonth', $getValue.scheduleInfo.recurrence.pattern.dayOfMonth)
        if ($null -ne $getValue.scheduleInfo.recurrence.pattern.daysOfWeek)
        {
            $complexPattern.Add('DaysOfWeek', $getValue.scheduleInfo.recurrence.pattern.daysOfWeek.ToString())
        }
        if ($null -ne $getValue.scheduleInfo.recurrence.pattern.firstDayOfWeek)
        {
            $complexPattern.Add('FirstDayOfWeek', $getValue.scheduleInfo.recurrence.pattern.firstDayOfWeek.ToString())
        }
        if ($null -ne $getValue.scheduleInfo.recurrence.pattern.index)
        {
            $complexPattern.Add('Index', $getValue.scheduleInfo.recurrence.pattern.index.ToString())
        }
        $complexPattern.Add('Interval', $getValue.scheduleInfo.recurrence.pattern.interval)
        $complexPattern.Add('Month', $getValue.scheduleInfo.recurrence.pattern.month)
        if ($null -ne $getValue.scheduleInfo.recurrence.pattern.type)
        {
            $complexPattern.Add('Type', $getValue.scheduleInfo.recurrence.pattern.type.ToString())
        }
        if ($complexPattern.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexPattern = $null
        }
        $complexRecurrence.Add('Pattern', $complexPattern)
        $complexRange = [ordered]@{}
        if ($null -ne $getValue.scheduleInfo.recurrence.range.endDate)
        {
            $complexRange.Add('EndDate', ([DateTime]$getValue.scheduleInfo.recurrence.range.endDate).ToString(''))
        }
        $complexRange.Add('NumberOfOccurrences', $getValue.scheduleInfo.recurrence.range.numberOfOccurrences)
        $complexRange.Add('RecurrenceTimeZone', $getValue.scheduleInfo.recurrence.range.recurrenceTimeZone)
        if ($null -ne $getValue.scheduleInfo.recurrence.range.startDate)
        {
            $complexRange.Add('StartDate', ([DateTime]$getValue.scheduleInfo.recurrence.range.startDate).ToString(''))
        }
        if ($null -ne $getValue.scheduleInfo.recurrence.range.type)
        {
            $complexRange.Add('Type', $getValue.scheduleInfo.recurrence.range.type.ToString())
        }
        if ($complexRange.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexRange = $null
        }
        $complexRecurrence.Add('Range', $complexRange)
        if ($complexRecurrence.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexRecurrence = $null
        }
        $complexScheduleInfo.Add('Recurrence', $complexRecurrence)
        if ($null -ne $getValue.ScheduleInfo.startDateTime)
        {
            $complexScheduleInfo.Add('StartDateTime', ([DateTimeOffset]$getValue.ScheduleInfo.startDateTime).ToString('o'))
        }
        if ($complexScheduleInfo.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexScheduleInfo = $null
        }
        #endregion

        #region resource generator code
        $enumAccessId = $null
        if ($null -ne $getValue.accessId)
        {
            $enumAccessId = $getValue.accessId.ToString()
        }

        $enumMemberType = $null
        if ($null -ne $getValue.memberType)
        {
            $enumMemberType = $getValue.memberType.ToString()
        }
        #endregion

        $PrincipalValue = $null
        $objectInfo = Get-MgBetaDirectoryObjectById -Ids $getvalue.PrincipalId -ErrorAction SilentlyContinue

        if (-not $getValue.ContainsKey('PrincipalType'))
        {
            $getValue.Add('PrincipalType', $objectInfo.AdditionalProperties['@odata.type'].Split('.')[2])
        }
        else
        {
            $getValue.PrincipalType = $objectInfo.AdditionalProperties['@odata.type'].Split('.')[2]
        }

       	switch ($getValue.PrincipalType)
        {
       	    'user' {
                $PrincipalValue = $objectInfo.AdditionalProperties['userPrincipalName']
            }
       	    default {
                $PrincipalValue = $objectInfo.AdditionalProperties['displayName']
            }
       	}

        Write-Verbose "PrincipalValue = $PrincipalValue"
        $results = @{
            #region resource generator code
            AccessId              = $enumAccessId
            GroupDisplayName      = $Script:CurrentGroup.DisplayName
            MemberType            = $enumMemberType
            PrincipalType         = $getValue.PrincipalType
            Principal             = $PrincipalValue
            ScheduleInfo          = $complexScheduleInfo
            Id                    = $getValue.Id
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            #endregion
        }

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

function Set-TargetResource {
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [ValidateSet('owner', 'member', 'unknownFutureValue')]
        [System.String]
        $AccessId,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupDisplayName,

        [Parameter()]
        [ValidateSet('direct', 'group', 'unknownFutureValue')]
        [System.String]
        $MemberType,

        [Parameter()]
        [System.String]
        $PrincipalType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Principal,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ScheduleInfo,

        [Parameter()]
        [System.String]
        $Id,

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

    Write-Verbose -Message "Setting configuration of the Azure AD Group Eligibility Schedule for group {$GroupId} and DisplayName {$GroupDisplayName}"

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
        Write-Verbose -Message "Creating an Azure AD Group Eligibility Schedule for Group {$GroupDisplayName}"

        $createParameters = ([Hashtable]$BoundParameters).Clone()
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('Id') | Out-Null
        $createParameters.Remove('PrincipalType') | Out-Null
        $createParameters.Remove('Principal') | Out-Null
        $createParameters.Remove('GroupDisplayName') | Out-Null
        $createParameters.Add('Action', 'adminAssign')

        $GroupFilter = "DisplayName eq '" + $GroupDisplayName + "'"
        $GroupId = (Get-MgGroup -Filter $GroupFilter).Id
        if ([string]::IsNullOrEmpty($GroupId))
        {
            throw "Failed to lookup group $GroupDisplayName"
        }
        if ($ScheduleInfo.Expiration.Type -eq 'noExpiration')
        {
            $p = Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter $("scopeId eq '{0}' and scopeType eq 'Group' and RoleDefinitionId eq '{1}'" -f $GroupId, $accessid)
            $unifiedRoleManagementPolicyId = $p.PolicyId
            $unifiedRoleManagementPolicyRuleId = "Expiration_Admin_Eligibility"
            $isExpirationRequired = (Get-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $unifiedRoleManagementPolicyId -UnifiedRoleManagementPolicyRuleId $unifiedRoleManagementPolicyRuleId).AdditionalProperties.isExpirationRequired
            if ($isExpirationRequired)
            {
                $params = @{
                    "@odata.type"        = "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule"
                    id                   = "Expiration_Admin_Eligibility"
                    isExpirationRequired = $false
                    target               = @{
                        caller              = "Admin"
                        operations          = @(
                            "All"
                        )
                        level               = "Eligibility"
                        inheritableSettings = @(
                        )
                        enforcedSettings    = @(
                        )
                    }
                }
                Update-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $unifiedRoleManagementPolicyId -UnifiedRoleManagementPolicyRuleId $unifiedRoleManagementPolicyRuleId -BodyParameter $params
            }
        }
        elseif ($ScheduleInfo.Expiration.Type -match "^after")
        {
            $p = Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter $("scopeId eq '{0}' and scopeType eq 'Group' and RoleDefinitionId eq '{1}'" -f $GroupId, $accessid)
            $unifiedRoleManagementPolicyId = $p.PolicyId
            $unifiedRoleManagementPolicyRuleId = "Expiration_Admin_Eligibility"
            $isExpirationRequired = (Get-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $unifiedRoleManagementPolicyId -UnifiedRoleManagementPolicyRuleId $unifiedRoleManagementPolicyRuleId).AdditionalProperties.isExpirationRequired
            if (-not $isExpirationRequired)
            {
                $params = @{
                    "@odata.type"        = "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule"
                    id                   = "Expiration_Admin_Eligibility"
                    isExpirationRequired = $true
                    maximumDuration      = 'P365D'
                    target               = @{
                        caller              = "Admin"
                        operations          = @(
                            "All"
                        )
                        level               = "Eligibility"
                        inheritableSettings = @(
                        )
                        enforcedSettings    = @(
                        )
                    }
                }
                Update-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $unifiedRoleManagementPolicyId -UnifiedRoleManagementPolicyRuleId $unifiedRoleManagementPolicyRuleId -BodyParameter $params
            }
        }

        $createParameters.Add('GroupId', $GroupId)

        switch ($PrincipalType)
        {
            'user' {
                $PrincipalId = (Get-MgUser -Filter "UserPrincipalName eq '$Principal'" -ErrorAction SilentlyContinue).id
            }
            default {
                $PrincipalId = (Get-MgGroup -Filter "DisplayName eq '$Principal'" -ErrorAction SilentlyContinue).id
            }
        }
        $createParameters.Add('PrincipalId', $PrincipalId)

        $keys = (([Hashtable]$createParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $createParameters.$key -and $createParameters.$key.GetType().Name -like '*CimInstance*')
            {
                $createParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $createParameters.$key
            }
        }
        #region resource generator code
        Write-Verbose -Message "Creating the Azure AD Group Eligibility Schedule with parameters:`r`n$(ConvertTo-Json $createParameters -Depth 10)"
        New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -BodyParameter $createParameters
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Azure AD Group Eligibility Schedule with Id {$($currentInstance.Id)}"

        $scheduledStart = $currentInstance.ScheduleInfo.StartDateTime
        $scheduledEnd = $currentInstance.ScheduleInfo.Expiration.EndDateTime
        if ($scheduledStart -ne $ScheduleInfo.StartDateTime -or $scheduledEnd -ne $ScheduleInfo.Expiration.EndDateTime)
        {
            $Action = 'adminExtend'
        }
        else
        {
            $Action = 'adminUpdate'
        }
        $updateParameters = ([Hashtable]$BoundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters

        $updateParameters.Remove('Id') | Out-Null
        $updateParameters.Remove('PrincipalType') | Out-Null
        $updateParameters.Remove('Principal') | Out-Null
        $updateParameters.Remove('GroupDisplayName') | Out-Null
        $updateParameters.Add('Action', $Action)

        $GroupFilter = "DisplayName eq '" + $GroupDisplayName + "'"
        $GroupId = (Get-MgGroup -Filter $GroupFilter).Id
        if ($ScheduleInfo.Expiration.Type -eq 'noExpiration')
        {
            $p = Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter $("scopeId eq '{0}' and scopeType eq 'Group' and RoleDefinitionId eq '{1}'" -f $GroupId, $accessid)
            $unifiedRoleManagementPolicyId = $p.PolicyId
            $unifiedRoleManagementPolicyRuleId = "Expiration_Admin_Eligibility"
            $isExpirationRequired = (Get-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $unifiedRoleManagementPolicyId -UnifiedRoleManagementPolicyRuleId $unifiedRoleManagementPolicyRuleId).AdditionalProperties.isExpirationRequired
            if ($isExpirationRequired)
            {
                $params = @{
                    "@odata.type"        = "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule"
                    id                   = "Expiration_Admin_Eligibility"
                    isExpirationRequired = $false
                    target               = @{
                        caller              = "Admin"
                        operations          = @(
                            "All"
                        )
                        level               = "Eligibility"
                        inheritableSettings = @(
                        )
                        enforcedSettings    = @(
                        )
                    }
                }
                Write-Verbose -Message "Updating the expiration policy for the group {$GroupDisplayName} with:`r`n$(ConvertTo-Json $params -Depth 10)"
                Update-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $unifiedRoleManagementPolicyId -UnifiedRoleManagementPolicyRuleId $unifiedRoleManagementPolicyRuleId -BodyParameter $params
            }
        }
        elseif ($ScheduleInfo.Expiration.Type -match "^after")
        {
            $p = Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter $("scopeId eq '{0}' and scopeType eq 'Group' and RoleDefinitionId eq '{1}'" -f $GroupId, $accessid)
            $unifiedRoleManagementPolicyId = $p.PolicyId
            $unifiedRoleManagementPolicyRuleId = "Expiration_Admin_Eligibility"
            $isExpirationRequired = (Get-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $unifiedRoleManagementPolicyId -UnifiedRoleManagementPolicyRuleId $unifiedRoleManagementPolicyRuleId).AdditionalProperties.isExpirationRequired
            if (-not $isExpirationRequired)
            {
                $params = @{
                    "@odata.type"        = "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule"
                    id                   = "Expiration_Admin_Eligibility"
                    isExpirationRequired = $true
                    maximumDuration      = 'P365D'
                    target               = @{
                        caller              = "Admin"
                        operations          = @(
                            "All"
                        )
                        level               = "Eligibility"
                        inheritableSettings = @(
                        )
                        enforcedSettings    = @(
                        )
                    }
                }
                Write-Verbose -Message "Updating the expiration policy for the group {$GroupDisplayName}"
                Update-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $unifiedRoleManagementPolicyId -UnifiedRoleManagementPolicyRuleId $unifiedRoleManagementPolicyRuleId -BodyParameter $params
            }
        }
        $updateParameters.Add('GroupId', $GroupId)
        switch ($PrincipalType)
        {
            'user' {
                $PrincipalId = (Get-MgUser -Filter "UserPrincipalName eq '$Principal'" -ErrorAction SilentlyContinue).id
            }
            default {
                $PrincipalId = (Get-MgGroup -Filter "DisplayName eq '$Principal'" -ErrorAction SilentlyContinue).id
            }
        }

        $updateParameters.Add('PrincipalId', $PrincipalId)

        $keys = (([Hashtable]$updateParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $updateParameters.$key -and $updateParameters.$key.GetType().Name -like '*CimInstance*')
            {
                $updateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $updateParameters.PrivilegedAccessGroupEligibilityScheduleId
            }
        }

        #region resource generator code
        New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -BodyParameter $UpdateParameters
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removiong the Azure AD Group Eligibility Schedule with Id {$($currentInstance.Id)}"

        $updateParameters = ([Hashtable]$BoundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters

        $updateParameters.Remove('Id') | Out-Null
        $updateParameters.Remove('PrincipalType') | Out-Null
        $updateParameters.Remove('Principal') | Out-Null
        $updateParameters.Remove('GroupDisplayName') | Out-Null
        $updateParameters.Add('Action', 'adminRemove')

        $GroupFilter = "DisplayName eq '" + $GroupDisplayName + "'"
        $GroupId = (Get-MgGroup -Filter $GroupFilter).Id
        $updateParameters.Add('GroupId', $GroupId)
        switch ($PrincipalType)
        {
            'user' {
                $PrincipalId = (Get-MgUser -Filter "UserPrincipalName eq '$Principal'" -ErrorAction SilentlyContinue).id
            }
            default {
                $PrincipalId = (Get-MgGroup -Filter "DisplayName eq '$Principal'" -ErrorAction SilentlyContinue).id
            }
        }
        $updateParameters.Add('PrincipalId', $PrincipalId)

        $keys = (([Hashtable]$updateParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $updateParameters.$key -and $updateParameters.$key.GetType().Name -like '*CimInstance*')
            {
                $updateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $updateParameters.PrivilegedAccessGroupEligibilityScheduleId
            }
        }

        #region resource generator code
        New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -BodyParameter $UpdateParameters
        #endregion
    }
}

function Test-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [ValidateSet('owner', 'member', 'unknownFutureValue')]
        [System.String]
        $AccessId,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupDisplayName,

        [Parameter()]
        [ValidateSet('direct', 'group', 'unknownFutureValue')]
        [System.String]
        $MemberType,

        [Parameter()]
        [System.String]
        $PrincipalType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Principal,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ScheduleInfo,

        [Parameter()]
        [System.String]
        $Id,
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

function Export-TargetResource {
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

    $Script:ExportMode = $true
    # Filter out dynamic groups
    if ($filter -notlike "*DynamicMembership*")
    {
        if (-not [string]::IsNullOrEmpty($filter))
        {
            $Filter = "$Filter and"
        }
        $Filter = "$Filter NOT(groupTypes/any(x:x eq 'DynamicMembership'))"
        Write-Verbose "Setting Export fitler to $Filter"
    }

    $ExportParameters = @{
        Filter      = $Filter
        All         = [switch]$true
        Property    = "displayname,Id"
        CountVariable = "CountVar"
        ConsistencyLevel = "eventual"
        ErrorAction = 'Stop'
    }

    try
    {
        Write-Verbose "Calling Get-MgGroup with Export Parameters"
        [array] $Script:exportedGroups = Get-MgGroup @ExportParameters
        Write-Verbose "Got $($Script:exportedGroups.Length) total unfiltered groups"
        Write-Verbose "Filtering all groups to PIM compatible"
        $Script:exportedGroups = $Script:exportedGroups | Where-Object -FilterScript {
            -not ($_.MailEnabled -and ($null -eq $_.GroupTypes -or $_.GroupTypes.Length -eq 0)) -and `
                -not ($_.MailEnabled -and $_.SecurityEnabled)
        }
        Write-Verbose "Got $($Script:exportedGroups.Length) PIM compatible groups"

        $j = 1
        if ($Script:exportedGroups.Length -eq 0)
        {
             if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }
            Write-M365DSCHost -Message  "    |---[$j/$($Script:exportedGroups.Count)] $($group.DisplayName)" -DeferWrite
        }
        else {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }

        $dscContent = ''
        $batchRequests = @()

        Write-M365DSCHost -Message "`r`n" -DeferWrite
        foreach ($group in $Script:exportedGroups)
        {
            $batchRequests += @{
                id     = $group.Id
                method = 'GET'
                url    = "/identityGovernance/privilegedAccess/group/eligibilitySchedules?`$filter=groupId eq '$($group.Id)'"
            }
        }

        Write-Verbose "Invoking Batch request"
        $batchResponses = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests
        $batchResponses | % {Write-Verbose "Batch ID: $($_.id)"}

        foreach ($group in $Script:exportedGroups)
        {
            Write-Verbose "Processing Group $($group.DisplayName), Id $($group.id)"
            Write-M365DSCHost -Message "    |---[$j/$($Script:exportedGroups.Length)] $($group.DisplayName)" -DeferWrite
            #region resource generator code
            $getValue = ($batchResponses | Where-Object { $_.id -eq $group.Id }).body.value
            Write-Verbose "GetValue set for schedule Id $($getValue.Id)"

            $Script:CurrentGroup = $group

            $i = 1

            if ($getValue.Length -eq 0)
            {
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }
            else {
                Write-M365DSCHost -Message "`r`n" -DeferWrite
            }
            Write-Verbose "Got $($getValue.count) schedules on group $($group.DisplayName)"
            foreach ($config in $getValue)
            {
                Write-Verbose "AccessId = $($config.accessId)"
                Write-Verbose "Id = $($config.Id)"
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }
                Write-M365DSCHost -Message "        |---[$i/$($getValue.Count)] $($config.Id)" -DeferWrite

                # Find the Principal Type
                Write-Verbose "Looking up ObjectId $($config.PrincipalId)"
                $PrincipalInfo = Get-MgBetaDirectoryObjectById -Ids $config.PrincipalId -ErrorAction SilentlyContinue
                $principalType = $PrincipalInfo.AdditionalProperties['@odata.type'].Split('.')[2]

                Write-Verbose "Got PrincipalType $PrincipalType back for ObjectID"
                $PrincipalValue = if ($principalType -eq 'user' )
                {
                    $PrincipalInfo.AdditionalProperties['userPrincipalName']
                }
                else
                {
                    $PrincipalInfo.AdditionalProperties['displayName']
                }
                Write-Verbose "PrincipalValue for object is $PrincipalValue"

                $params = @{
                    Id                    = $config.Id
                    GroupId               = $group.Id
                    GroupDisplayName      = $group.DisplayName
                    AccessId              = $config.accessId
                    Principal             = $PrincipalValue
                    Ensure                = 'Present'
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    ApplicationSecret     = $ApplicationSecret
                    CertificateThumbprint = $CertificateThumbprint
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    AccessTokens          = $AccessTokens
                }

                $Script:exportedInstance = $config
                $Results = Get-TargetResource @Params

                if ($null -ne $Results.ScheduleInfo)
                {
                    $complexMapping = @(
                        @{
                            Name            = 'ScheduleInfo'
                            CimInstanceName = 'MicrosoftGraphRequestSchedule'
                            IsRequired      = $True
                        }
                        @{
                            Name            = 'Expiration'
                            CimInstanceName = 'MicrosoftGraphExpirationPattern'
                            IsRequired      = $False
                        }
                        @{
                            Name            = 'Recurrence'
                            CimInstanceName = 'MicrosoftGraphPatternedRecurrence1'
                            IsRequired      = $False
                        }
                        @{
                            Name            = 'Pattern'
                            CimInstanceName = 'MicrosoftGraphRecurrencePattern1'
                            IsRequired      = $False
                        }
                        @{
                            Name            = 'Range'
                            CimInstanceName = 'MicrosoftGraphRecurrenceRange1'
                            IsRequired      = $False
                        }
                    )
                    $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $Results.ScheduleInfo `
                        -CIMInstanceName 'MicrosoftGraphrequestSchedule' `
                        -ComplexTypeMapping $complexMapping

                    if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                    {
                        $Results.ScheduleInfo = $complexTypeStringResult
                    }
                    else
                    {
                        $Results.Remove('ScheduleInfo') | Out-Null
                    }
                }

                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential `
                    -NoEscape @('ScheduleInfo')

                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
                $i++
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }
            $j++
        }
        return $dscContent
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
