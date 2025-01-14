function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [ValidateSet('owner','member','unknownFutureValue')]
        [System.String]
        $AccessId,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupDisplayName,

        [Parameter()]
        [ValidateSet('direct','group','unknownFutureValue')]
        [System.String]
        $MemberType,

        [Parameter()]
        [System.String]
        $PrincipalId,

        [Parameter()]
        [System.String]
        $PrincipalType,

        [Parameter()]
        [System.String]
        $PrincipalDisplayName,

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

    Write-Verbose -Message "Getting configuration of the Azure AD Group {$GroupDisplayName}Eligibility Schedule"

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
        if($GroupId.Length -eq 0){
            $Filter = "DisplayName eq '" + $GroupDisplayName + "'"
            $GroupId = (Get-MgGroup -Filter $Filter).Id
        }
        if ($Id -notmatch '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}_member_[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$') {
            $getId = Get-MgIdentityGovernancePrivilegedAccessGroupEligibilitySchedule `
                -Filter "Groupid eq '$GroupId'" `
                -ErrorAction SilentlyContinue
                $Id = $getId.Id
        }

        $uri = 'https://graph.microsoft.com/v1.0/identityGovernance/privilegedAccess/group/eligibilitySchedules/' + $Id
        $getvalue = Invoke-GraphRequest -Uri $uri -Method Get -ErrorAction SilentlyContinue

        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Azure AD Group Eligibility Schedule with {$GroupDisplayName}."
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Azure AD Group Eligibility Schedule with Id {$Id} and DisplayName {$GroupDisplayName} was found"

        #region resource generator code
        $complexScheduleInfo = @{}
        $complexExpiration = @{}
        $complexExpiration.Add('Duration', $getValue.scheduleInfo.expiration.duration)
        if ($null -ne $getValue.scheduleInfo.expiration.endDateTime)
        {
            $complexExpiration.Add('EndDateTime', ([DateTimeOffset]$getValue.scheduleInfo.expiration.endDateTime).ToString(''))
        }
        if ($null -ne $getValue.scheduleInfo.expiration.type)
        {
            $complexExpiration.Add('Type', $getValue.scheduleInfo.expiration.type.ToString())
        }
        if ($complexExpiration.values.Where({$null -ne $_}).Count -eq 0)
        {
            $complexExpiration = $null
        }
        $complexScheduleInfo.Add('Expiration',$complexExpiration)
        $complexRecurrence = @{}
        $complexPattern = @{}
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
        if ($complexPattern.values.Where({$null -ne $_}).Count -eq 0)
        {
            $complexPattern = $null
        }
        $complexRecurrence.Add('Pattern',$complexPattern)
        $complexRange = @{}
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
        if ($complexRange.values.Where({$null -ne $_}).Count -eq 0)
        {
            $complexRange = $null
        }
        $complexRecurrence.Add('Range',$complexRange)
        if ($complexRecurrence.values.Where({$null -ne $_}).Count -eq 0)
        {
            $complexRecurrence = $null
        }
        $complexScheduleInfo.Add('Recurrence',$complexRecurrence)
        if ($null -ne $getValue.ScheduleInfo.startDateTime)
        {
            $complexScheduleInfo.Add('StartDateTime', ([DateTimeOffset]$getValue.ScheduleInfo.startDateTime).ToString('o'))
        }
        if ($complexScheduleInfo.values.Where({$null -ne $_}).Count -eq 0)
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

        switch ($getValue.PrincipalType)
        {
            'group' {
                $PrincipalDisplayName = (Get-MgGroup -GroupId $getvalue.PrincipalId).DisplayName
            }
            'user' {
                $PrincipalDisplayName = (Get-MgUser -UserId $getvalue.PrincipalId).DisplayName
            }
        }

        $GroupDisplayName = (Get-MgGroup -GroupId $getvalue.GroupId).DisplayName

        $results = @{
            #region resource generator code
            AccessId              = $enumAccessId
            GroupId               = $getValue.groupId
            GroupDisplayName      = $GroupDisplayName
            MemberType            = $enumMemberType
            PrincipalType         = $PrincipalType
            PrincipalDisplayname  = $PrincipalDisplayName
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
        [Parameter()]
        [ValidateSet('owner','member','unknownFutureValue')]
        [System.String]
        $AccessId,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupDisplayName,

        [Parameter()]
        [ValidateSet('direct','group','unknownFutureValue')]
        [System.String]
        $MemberType,

        [Parameter()]
        [System.String]
        $PrincipalId,

        [Parameter()]
        [System.String]
        $PrincipalType,

        [Parameter()]
        [System.String]
        $PrincipalDisplayName,

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
        $createParameters.Remove('PrincipalDisplayName') | Out-Null
        $createParameters.Remove('GroupDisplayName') | Out-Null
        $createParameters.Add('Action', 'adminAssign')

        $GroupFilter = "DisplayName eq '" + $GroupDisplayName + "'"
        $GroupId = (Get-MgGroup -Filter $GroupFilter).Id

        if($ScheduleInfo.Expiration.Type -eq 'noExpiration'){
            $p = Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter $("scopeId eq '{0}' and scopeType eq 'Group' and RoleDefinitionId eq 'member'" -f $GroupId)
            $unifiedRoleManagementPolicyId = $p.PolicyId
            $unifiedRoleManagementPolicyRuleId = "Expiration_Admin_Eligibility"
            $isExpirationRequired = (Get-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $unifiedRoleManagementPolicyId -UnifiedRoleManagementPolicyRuleId $unifiedRoleManagementPolicyRuleId).AdditionalProperties.isExpirationRequired
            if($isExpirationRequired){
                $params = @{
                    "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule"
                    id = "Expiration_Admin_Eligibility"
                    isExpirationRequired = $false
                    target = @{
                        caller = "Admin"
                        operations = @(
                            "All"
                        )
                        level = "Eligibility"
                        inheritableSettings = @(
                        )
                        enforcedSettings = @(
                        )
                    }
                }
                Update-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $unifiedRoleManagementPolicyId -UnifiedRoleManagementPolicyRuleId $unifiedRoleManagementPolicyRuleId -BodyParameter $params
            }
        }
        elseif($ScheduleInfo.Expiration.Type -match "^after"){
            $p = Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter $("scopeId eq '{0}' and scopeType eq 'Group' and RoleDefinitionId eq 'member'" -f $GroupId)
            $unifiedRoleManagementPolicyId = $p.PolicyId
            $unifiedRoleManagementPolicyRuleId = "Expiration_Admin_Eligibility"
            $isExpirationRequired = (Get-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $unifiedRoleManagementPolicyId -UnifiedRoleManagementPolicyRuleId $unifiedRoleManagementPolicyRuleId).AdditionalProperties.isExpirationRequired
            if(-not $isExpirationRequired){
                $params = @{
                    "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule"
                    id = "Expiration_Admin_Eligibility"
                    isExpirationRequired = $true
                    maximumDuration = 'P365D'
                    target = @{
                        caller = "Admin"
                        operations = @(
                            "All"
                        )
                        level = "Eligibility"
                        inheritableSettings = @(
                        )
                        enforcedSettings = @(
                        )
                    }
                }
                Update-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $unifiedRoleManagementPolicyId -UnifiedRoleManagementPolicyRuleId $unifiedRoleManagementPolicyRuleId -BodyParameter $params
            }
        }

        $createParameters.Add('GroupId', $GroupId)
        $Filter = "DisplayName eq '" + $PrincipalDisplayname + "'"
        if($PrincipalType -eq 'group'){
            $PrincipalId = (Get-MgGroup -Filter $Filter).Id
        }
        else{
            $PrincipalId = (Get-MgUser -Filter $Filter).Id
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
        New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -BodyParameter $createParameters
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Azure AD Group Eligibility Schedule with Id {$($currentInstance.Id)}"

        $scheduledStart = $currentInstance.ScheduleInfo.StartDateTime
        $scheduledEnd = $currentInstance.ScheduleInfo.Expiration.EndDateTime
        if($scheduledStart -ne $ScheduleInfo.StartDateTime -or $scheduledEnd -ne $ScheduleInfo.Expiration.EndDateTime){
            $Action = 'adminExtend'
        }
        else{
            $Action = 'adminUpdate'
        }
        $updateParameters = ([Hashtable]$BoundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters

        $updateParameters.Remove('Id') | Out-Null
        $updateParameters.Remove('PrincipalType') | Out-Null
        $updateParameters.Remove('PrincipalDisplayName') | Out-Null
        $updateParameters.Remove('GroupDisplayName') | Out-Null
        $updateParameters.Add('Action', $Action)

        $GroupFilter = "DisplayName eq '" + $GroupDisplayName + "'"
        $GroupId = (Get-MgGroup -Filter $GroupFilter).Id
        if($ScheduleInfo.Expiration.Type -eq 'noExpiration'){
            $p = Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter $("scopeId eq '{0}' and scopeType eq 'Group' and RoleDefinitionId eq 'member'" -f $GroupId)
            $unifiedRoleManagementPolicyId = $p.PolicyId
            $unifiedRoleManagementPolicyRuleId = "Expiration_Admin_Eligibility"
            $isExpirationRequired = (Get-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $unifiedRoleManagementPolicyId -UnifiedRoleManagementPolicyRuleId $unifiedRoleManagementPolicyRuleId).AdditionalProperties.isExpirationRequired
            if($isExpirationRequired){
                $params = @{
                    "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule"
                    id = "Expiration_Admin_Eligibility"
                    isExpirationRequired = $false
                    target = @{
                        caller = "Admin"
                        operations = @(
                            "All"
                        )
                        level = "Eligibility"
                        inheritableSettings = @(
                        )
                        enforcedSettings = @(
                        )
                    }
                }
                Write-Verbose -Message "Updating the expiration policy for the group {$GroupDisplayName}"
                Update-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $unifiedRoleManagementPolicyId -UnifiedRoleManagementPolicyRuleId $unifiedRoleManagementPolicyRuleId -BodyParameter $params
            }
        }
        elseif($ScheduleInfo.Expiration.Type -match "^after"){
            $p = Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter $("scopeId eq '{0}' and scopeType eq 'Group' and RoleDefinitionId eq 'member'" -f $GroupId)
            $unifiedRoleManagementPolicyId = $p.PolicyId
            $unifiedRoleManagementPolicyRuleId = "Expiration_Admin_Eligibility"
            $isExpirationRequired = (Get-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $unifiedRoleManagementPolicyId -UnifiedRoleManagementPolicyRuleId $unifiedRoleManagementPolicyRuleId).AdditionalProperties.isExpirationRequired
            if(-not $isExpirationRequired){
                $params = @{
                    "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule"
                    id = "Expiration_Admin_Eligibility"
                    isExpirationRequired = $true
                    maximumDuration = 'P365D'
                    target = @{
                        caller = "Admin"
                        operations = @(
                            "All"
                        )
                        level = "Eligibility"
                        inheritableSettings = @(
                        )
                        enforcedSettings = @(
                        )
                    }
                }
                Write-Verbose -Message "Updating the expiration policy for the group {$GroupDisplayName}"
                Update-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $unifiedRoleManagementPolicyId -UnifiedRoleManagementPolicyRuleId $unifiedRoleManagementPolicyRuleId -BodyParameter $params
            }
        }
        $updateParameters.Add('GroupId', $GroupId)
        $Filter = "DisplayName eq '" + $PrincipalDisplayname + "'"
        if($PrincipalType -eq 'group'){
            $PrincipalId = (Get-MgGroup -Filter $Filter).Id
        }
        else{
            $PrincipalId = (Get-MgUser -Filter $Filter).Id
        }
        $updateParameters.Add('PrincipalId', $PrincipalId)

        $keys = (([Hashtable]$updateParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $pdateParameters.$key -and $updateParameters.$key.GetType().Name -like '*CimInstance*')
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
        $updateParameters.Remove('PrincipalDisplayName') | Out-Null
        $updateParameters.Remove('GroupDisplayName') | Out-Null
        $updateParameters.Add('Action', 'adminRemove')

        $GroupFilter = "DisplayName eq '" + $GroupDisplayName + "'"
        $GroupId = (Get-MgGroup -Filter $GroupFilter).Id
        $updateParameters.Add('GroupId', $GroupId)
        $Filter = "DisplayName eq '" + $PrincipalDisplayname + "'"
        if($PrincipalType -eq 'group'){
            $PrincipalId = (Get-MgGroup -Filter $Filter).Id
        }
        else{
            $PrincipalId = (Get-MgUser -Filter $Filter).Id
        }
        $updateParameters.Add('PrincipalId', $PrincipalId)

        $keys = (([Hashtable]$updateParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $pdateParameters.$key -and $updateParameters.$key.GetType().Name -like '*CimInstance*')
            {
                $updateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $updateParameters.PrivilegedAccessGroupEligibilityScheduleId
            }
        }

        #region resource generator code
        New-MgBetaIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest -BodyParameter $UpdateParameters
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
        [ValidateSet('owner','member','unknownFutureValue')]
        [System.String]
        $AccessId,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupDisplayName,

        [Parameter()]
        [ValidateSet('direct','group','unknownFutureValue')]
        [System.String]
        $MemberType,

        [Parameter()]
        [System.String]
        $PrincipalId,

        [Parameter()]
        [System.String]
        $PrincipalType,

        [Parameter()]
        [System.String]
        $PrincipalDisplayName,

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

    Write-Verbose -Message "Testing configuration of the Azure AD Group Eligibility Schedule for Group {$GroupId} and DisplayName {$GroupDisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
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
        if ($null -ne $source -and $source.GetType().Name -like '*CimInstance*')
        {
            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-not $testResult)
            {
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.Remove('Id') | Out-Null
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck

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

        $groups = Get-MgGroup -Filter "MailEnabled eq false and NOT(groupTypes/any(x:x eq 'DynamicMembership'))" -Property "displayname,Id" -CountVariable CountVar  -ConsistencyLevel eventual -ErrorAction Stop
        foreach ($group in $groups)
        {
            Write-Host "get group $($group.DisplayName)"
            #region resource generator code
            $getValue = Get-MgIdentityGovernancePrivilegedAccessGroupEligibilitySchedule `
                -Filter "groupId eq '$($group.Id)'" `
                -All `
                -ErrorAction Stop
            if($null -eq $getValue)
            {
                continue
            }

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
                Write-Host "    |---[$i/$($getValue.Count)] $($group.DisplayName)" -NoNewline
                $params = @{
                    Id                    = $config.Id
                    GroupDisplayName      = $group.DisplayName
                    Ensure                = 'Present'
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    ApplicationSecret     = $ApplicationSecret
                    CertificateThumbprint = $CertificateThumbprint
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    AccessTokens          = $AccessTokens
                }

                $Results = Get-TargetResource @Params
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
                if ($null -ne $Results.ScheduleInfo)
                {
                    $complexMapping = @(
                        @{
                            Name = 'ScheduleInfo'
                            CimInstanceName = 'MicrosoftGraphRequestSchedule'
                            IsRequired = $True
                        }
                        @{
                            Name = 'Expiration'
                            CimInstanceName = 'MicrosoftGraphExpirationPattern'
                            IsRequired = $False
                        }
                        @{
                            Name = 'Recurrence'
                            CimInstanceName = 'MicrosoftGraphPatternedRecurrence1'
                            IsRequired = $False
                        }
                        @{
                            Name = 'Pattern'
                            CimInstanceName = 'MicrosoftGraphRecurrencePattern1'
                            IsRequired = $False
                        }
                        @{
                            Name = 'Range'
                            CimInstanceName = 'MicrosoftGraphRecurrenceRange1'
                            IsRequired = $False
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
                    -Credential $Credential
                if ($Results.ScheduleInfo)
                {
                    $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "ScheduleInfo" -IsCIMArray:$False
                }

                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
                $i++
                Write-Host $Global:M365DSCEmojiGreenCheckMark
            }
            return $dscContent
        }
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
