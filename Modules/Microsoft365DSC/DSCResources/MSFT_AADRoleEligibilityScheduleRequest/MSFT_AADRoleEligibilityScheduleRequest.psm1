Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADRoleEligibilityScheduleRequest'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Principal,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RoleDefinition,

        [Parameter(Mandatory = $true)]
        [ValidateSet('User', 'Group', 'ServicePrincipal')]
        [System.String]
        $PrincipalType,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DirectoryScopeId,

        [Parameter()]
        [System.String]
        $AppScopeId,

        [Parameter()]
        [ValidateSet('adminAssign', 'adminUpdate', 'adminRemove', 'selfActivate', 'selfDeactivate', 'adminExtend', 'adminRenew', 'selfExtend', 'selfRenew', 'unknownFutureValue')]
        [System.String]
        $Action,

        [Parameter()]
        [System.String]
        $Justification,

        [Parameter()]
        [System.Boolean]
        $IsValidationOnly,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ScheduleInfo,

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

    Write-Verbose -Message "Getting configuration of the AAD Role Eligibility Schedule Request with Principal {$Principal}, RoleDefinition {$RoleDefinition}, PrincipalType {$PrincipalType} and DirectoryScopeId {$DirectoryScopeId}"

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

            if ($null -eq $Script:AllSchedules)
            {
                Write-Verbose -Message 'Retrieving all role eligibility schedules'
                $Script:AllSchedules = Get-MgBetaRoleManagementDirectoryRoleEligibilitySchedule -All `
                    -ErrorAction SilentlyContinue
            }
            if ($null -eq $Script:RoleDefinitions)
            {
                $Script:RoleDefinitions = [System.Collections.Generic.Dictionary[string, object]]::new()
                $allRoleDefinitions = Get-MgBetaRoleManagementDirectoryRoleDefinition -All -ErrorAction SilentlyContinue
                foreach ($singleRoleDefinition in $allRoleDefinitions)
                {
                    $Script:RoleDefinitions.Add($singleRoleDefinition.Id, $singleRoleDefinition)
                }
            }

            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                Write-Verbose -Message "Getting Role Eligibility by Id {$Id}"
                $schedule = Get-MgBetaRoleManagementDirectoryRoleEligibilitySchedule -UnifiedRoleEligibilityScheduleId $Id `
                    -ErrorAction SilentlyContinue
            }
        }
        else
        {
            $schedule = $Script:exportedInstance
            # To keep performance good, only assign the current instance
            $Script:AllSchedules = $Script:exportedInstance
        }

        Write-Verbose -Message 'Getting Role Eligibility by PrincipalId and RoleDefinitionId'
        $PrincipalValue = $null
        if ($PrincipalType -eq 'User')
        {
            Write-Verbose -Message "Retrieving Principal by UserPrincipalName {$Principal}"
            $PrincipalInstance = Get-MgUser -Filter "UserPrincipalName eq '$($Principal -replace "'", "''")'" -ErrorAction SilentlyContinue
            $PrincipalValue = $PrincipalInstance.UserPrincipalName
        }
        elseif ($PrincipalType -eq 'Group')
        {
            Write-Verbose -Message "Retrieving Principal by DisplayName {$Principal}"
            $PrincipalInstance = Get-MgGroup -Filter "DisplayName eq '$($Principal -replace "'", "''")'" -ErrorAction SilentlyContinue
            $PrincipalValue = $PrincipalInstance.DisplayName
        }
        else
        {
            Write-Verbose -Message "Retrieving Principal by DisplayName {$Principal}"
            $PrincipalInstance = Get-MgServicePrincipal -Filter "DisplayName eq '$($Principal -replace "'", "''")'" -ErrorAction SilentlyContinue
            $PrincipalValue = $PrincipalInstance.DisplayName
        }

        Write-Verbose -Message "Found Principal {$PrincipalValue}"
        $roleDefinitionId = $Script:RoleDefinitions.GetEnumerator() | Where-Object { $_.Value.DisplayName -eq $RoleDefinition } | Select-Object -ExpandProperty Key
        Write-Verbose -Message "Retrieved role definition {$RoleDefinition} with ID {$roleDefinitionId}"

        if ($null -eq $schedule)
        {
            Write-Verbose -Message "Retrieving the request by PrincipalId {$($PrincipalInstance.Id)}, RoleDefinitionId {$($roleDefinitionId)} and DirectoryScopeId {$($DirectoryScopeId)}"
            [array]$requests = $Script:AllSchedules | Where-Object -FilterScript {
                $_.PrincipalId -eq $PrincipalInstance.Id -and
                $_.RoleDefinitionId -eq $roleDefinitionId -and
                $_.DirectoryScopeId -eq $DirectoryScopeId
            }

            if ($requests.Count -eq 0)
            {
                # Lookup in Graph - can be the case if a role was created in this configuration run
                Write-Verbose -Message "No cached schedules found, fetching with principalId, roleDefinitionId and directoryScopeId"
                $requests = Get-MgBetaRoleManagementDirectoryRoleEligibilitySchedule -Filter "principalId eq '$($PrincipalInstance.Id)' and roleDefinitionId eq '$($roleDefinitionId)' and directoryScopeId eq '$($DirectoryScopeId)'" -ErrorAction SilentlyContinue
                if ($requests.Count -eq 0)
                {
                    # We need to make sure we're not ending up here because the role is a custom role (which has a different id).
                    Write-Verbose -Message "No schedules found, testing for custom role definitions"
                    $roleEntry = $Script:RoleDefinitions[$roleDefinitionId]
                    if ($null -eq $roleEntry)
                    {
                        $roleEntry = Get-MgBetaRoleManagementDirectoryRoleDefinition -UnifiedRoleDefinitionId $roleDefinitionId
                    }
                    if ($roleEntry.DisplayName -eq $RoleDefinition)
                    {
                        $roleDefinitionId = $roleEntry.Id
                        if (-not $Script:RoleDefinitions.ContainsKey($roleDefinitionId))
                        {
                            $Script:RoleDefinitions.Add($roleDefinitionId, $roleEntry)
                        }
                        # The TemplateId is the id of the custom role definition
                        Write-Verbose -Message "Fetching schedules for custom role definition with RoleDefinitionId {$roleDefinitionId}"
                        $requests = Get-MgBetaRoleManagementDirectoryRoleEligibilitySchedule -Filter "principalId eq '$($PrincipalInstance.Id)' and roleDefinition/TemplateId eq '$($roleDefinitionId)' and directoryScopeId eq '$($DirectoryScopeId)'" -ErrorAction SilentlyContinue
                        if ($requests.Count -eq 0)
                        {
                            Write-Verbose -Message "No schedules found for custom role definition"
                            return $nullResult
                        }
                    }
                }
                else
                {
                    Write-Verbose -Message "Adding schedule to cache"
                    $Script:AllSchedules += $requests[0]
                }
            }
            else
            {
                $schedule = $requests[0]
            }
        }

        $ScheduleInfoValue = @{}
        if ($null -ne $schedule.ScheduleInfo.Expiration)
        {
            $expirationValue = [ordered]@{
                duration = $schedule.ScheduleInfo.Expiration.Duration
                type     = $schedule.ScheduleInfo.Expiration.Type
            }
            if ($null -ne $schedule.ScheduleInfo.Expiration.EndDateTime)
            {
                $expirationValue.Add('endDateTime', $schedule.ScheduleInfo.Expiration.EndDateTime.ToString('yyyy-MM-ddTHH:mm:ssZ'))
            }
            $ScheduleInfoValue.Add('expiration', $expirationValue)
        }
        if ($null -ne $schedule.ScheduleInfo.Recurrence)
        {
            if (Test-M365DSCRecurrenceIsConfigured -RecurrenceSettings $schedule.ScheduleInfo.Recurrence)
            {
                $recurrenceValue = [ordered]@{
                    pattern = [ordered]@{
                        dayOfMonth     = $schedule.ScheduleInfo.Recurrence.Pattern.dayOfMonth
                        daysOfWeek     = $schedule.ScheduleInfo.Recurrence.Pattern.daysOfWeek
                        firstDayOfWeek = $schedule.ScheduleInfo.Recurrence.Pattern.firstDayOfWeek
                        index          = $schedule.ScheduleInfo.Recurrence.Pattern.index
                        interval       = $schedule.ScheduleInfo.Recurrence.Pattern.interval
                        month          = $schedule.ScheduleInfo.Recurrence.Pattern.month
                        type           = $schedule.ScheduleInfo.Recurrence.Pattern.type
                    }
                    range   = [ordered]@{
                        endDate             = $schedule.ScheduleInfo.Recurrence.Range.endDate
                        numberOfOccurrences = $schedule.ScheduleInfo.Recurrence.Range.numberOfOccurrences
                        recurrenceTimeZone  = $schedule.ScheduleInfo.Recurrence.Range.recurrenceTimeZone
                        startDate           = $schedule.ScheduleInfo.Recurrence.Range.startDate
                        type                = $schedule.ScheduleInfo.Recurrence.Range.type
                    }
                }
                $ScheduleInfoValue.Add('Recurrence', $recurrenceValue)
            }
        }
        if ($null -ne $schedule.ScheduleInfo.StartDateTime)
        {
            $ScheduleInfoValue.Add('StartDateTime', $schedule.ScheduleInfo.StartDateTime.ToString('yyyy-MM-ddThh:mm:ssZ'))
        }

        $results = @{
            Principal             = $PrincipalValue
            PrincipalType         = $PrincipalType
            RoleDefinition        = $RoleDefinition
            DirectoryScopeId      = $schedule.DirectoryScopeId
            AppScopeId            = $schedule.AppScopeId
            #Action                = $schedule.Action
            Id                    = $schedule.Id
            Justification         = "Assignment of role eligibility '$RoleDefinition' to principal '$PrincipalValue' of type '$PrincipalType'."
            #IsValidationOnly      = $schedule.IsValidationOnly
            ScheduleInfo          = $ScheduleInfoValue
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Principal,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RoleDefinition,

        [Parameter(Mandatory = $true)]
        [ValidateSet('User', 'Group', 'ServicePrincipal')]
        [System.String]
        $PrincipalType,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DirectoryScopeId,

        [Parameter()]
        [System.String]
        $AppScopeId,

        [Parameter()]
        [ValidateSet('adminAssign', 'adminUpdate', 'adminRemove', 'selfActivate', 'selfDeactivate', 'adminExtend', 'adminRenew', 'selfExtend', 'selfRenew', 'unknownFutureValue')]
        [System.String]
        $Action,

        [Parameter()]
        [System.String]
        $Justification,

        [Parameter()]
        [System.Boolean]
        $IsValidationOnly,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ScheduleInfo,

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

    # TODO: Remove during next breaking change
    if ($PSBoundParameters.ContainsKey('Action'))
    {
        Write-Warning -Message "The parameter 'Action' is deprecated. It will be removed in the next breaking change release."
    }

    if ($PSBoundParameters.ContainsKey('IsValidationOnly'))
    {
        Write-Warning -Message "The parameter 'IsValidationOnly' is deprecated. It will be removed in the next breaking change release."
    }

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

    Write-Verbose -Message "Retrieving Principal Id from Set-TargetResource"
    $PrincipalId = $null
    if ($PrincipalType -eq 'User')
    {
        Write-Verbose -Message "Retrieving Principal by UserPrincipalName {$Principal}"
        $PrincipalInstance = Get-MgUser -Filter "UserPrincipalName eq '$($Principal -replace "'", "''")'" -ErrorAction SilentlyContinue
        $PrincipalId = $PrincipalInstance.Id
    }
    elseif ($PrincipalType -eq 'Group')
    {
        Write-Verbose -Message "Retrieving Principal by DisplayName {$Principal}"
        $PrincipalInstance = Get-MgGroup -Filter "DisplayName eq '$($Principal -replace "'", "''")'" -ErrorAction SilentlyContinue
        $PrincipalId = $PrincipalInstance.Id
    }
    else
    {
        Write-Verbose -Message "Retrieving Principal by DisplayName {$Principal}"
        $PrincipalInstance = Get-MgServicePrincipal -Filter "DisplayName eq '$($Principal -replace "'", "''")'" -ErrorAction SilentlyContinue
        $PrincipalId = $PrincipalInstance.Id
    }

    Write-Verbose -Message "Retrieving RoleDefinitionId from Set-TargetResource"
    $roleDefinitionId = (Get-MgBetaRoleManagementDirectoryRoleDefinition -Filter "DisplayName eq '$($RoleDefinition -replace "'", "''")'").Id
    if ([System.String]::IsNullOrEmpty($roleDefinitionId))
    {
        throw "Couldn't find Role Definition {$RoleDefinition}"
    }

    $instanceParams = @{
        directoryScopeId = $DirectoryScopeId
        principalId      = $PrincipalId
        roleDefinitionId = $roleDefinitionId
        scheduleInfo     = @{
            expiration = @{
                type        = $ScheduleInfo.Expiration.Type
                duration    = $ScheduleInfo.Expiration.Duration
                endDateTime = $ScheduleInfo.Expiration.EndDateTime
            }
            startDateTime = $ScheduleInfo.StartDateTime
        }
    }

    if (-not [System.String]::IsNullOrEmpty($AppScopeId))
    {
        $instanceParams.Add('appScopeId', $AppScopeId)
    }

    if ($null -eq $instanceParams.ScheduleInfo.Expiration.Duration)
    {
        $instanceParams.ScheduleInfo.Expiration.Remove('duration') | Out-Null
    }

    $RecurrenceInfo = @{}
    $foundRecurrenceItem = $false
    if ($null -ne $ScheduleInfo.Recurrence.Pattern.Type)
    {
        $Pattern = @{
            dayOfMonth     = $ScheduleInfo.Recurrence.Pattern.DayOfMonth
            daysOfWeek     = $ScheduleInfo.Recurrence.Pattern.DaysOfWeek
            firstDayOfWeek = $ScheduleInfo.Recurrence.Pattern.FirstDayOfWeek
            index          = $ScheduleInfo.Recurrence.Pattern.Index
            month          = $ScheduleInfo.Recurrence.Pattern.Month
            type           = $ScheduleInfo.Recurrence.Pattern.Type
        }
        $RecurrenceInfo.Add('pattern', $Pattern)
        $foundRecurrenceItem = $true
    }
    if ($null -ne $ScheduleInfo.Recurrence.Range.Type)
    {
        $Range = @{
            endDate             = $ScheduleInfo.Recurrence.Range.EndDate
            numberOfOccurrences = $ScheduleInfo.Recurrence.Range.NumberOfOccurrences
            recurrenceTimeZone  = $ScheduleInfo.Recurrence.Range.RecurrenceTimeZone
            startDate           = $ScheduleInfo.Recurrence.Range.StartDate
            type                = $ScheduleInfo.Recurrence.Range.Type
        }
        $RecurrenceInfo.Add('range', $Range)
        $foundRecurrenceItem = $true
    }
    if ($foundRecurrenceItem)
    {
        $instanceParams.Add('recurrence', $RecurrenceInfo)
    }

    if ([System.String]::IsNullOrEmpty($instanceParams.scheduleInfo.expiration.endDateTime))
    {
        $instanceParams.scheduleInfo.expiration.Remove('endDateTime') | Out-Null
    }

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $instanceParams.Add('action', 'AdminAssign')
        $instanceParams.Add('justification', 'AdminAssign by Microsoft365DSC')
        Write-Verbose -Message "Creating new role eligibility Schedule with parameters:`r`n$(ConvertTo-Json $instanceParams -Depth 10)"
        New-MgBetaRoleManagementDirectoryRoleEligibilityScheduleRequest -BodyParameter $instanceParams
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        $instanceParams.Add('action', 'AdminUpdate')
        $instanceParams.Add('justification', 'AdminUpdate by Microsoft365DSC')
        Write-Verbose -Message "Updating role eligibility Schedule with parameters:`r`n$(ConvertTo-Json $instanceParams -Depth 10)"
        New-MgBetaRoleManagementDirectoryRoleEligibilityScheduleRequest -BodyParameter $instanceParams
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        $instanceParams.Add('action', 'AdminRemove')
        $instanceParams.Add('justification', 'AdminRemove by Microsoft365DSC')
        Write-Verbose -Message "Removing role eligibility Schedule with parameters:`r`n$(ConvertTo-Json $instanceParams -Depth 10)"
        New-MgBetaRoleManagementDirectoryRoleEligibilityScheduleRequest -BodyParameter $instanceParams
        if ($Script:AllSchedules.Count -gt 0)
        {
            # Remove the instance from the cached list to avoid re-processing
            $Script:AllSchedules = $Script:AllSchedules | Where-Object {
                $_.RoleDefinition -ne $RoleDefinition -and $_.Principal -ne $Principal -and $_.PrincipalType -ne $PrincipalType -and $_.DirectoryScopeId -ne $DirectoryScopeId
            }
        }
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
        $Principal,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RoleDefinition,

        [Parameter(Mandatory = $true)]
        [ValidateSet('User', 'Group', 'ServicePrincipal')]
        [System.String]
        $PrincipalType,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DirectoryScopeId,

        [Parameter()]
        [System.String]
        $AppScopeId,

        [Parameter()]
        [ValidateSet('adminAssign', 'adminUpdate', 'adminRemove', 'selfActivate', 'selfDeactivate', 'adminExtend', 'adminRenew', 'selfExtend', 'selfRenew', 'unknownFutureValue')]
        [System.String]
        $Action,

        [Parameter()]
        [System.String]
        $Justification,

        [Parameter()]
        [System.Boolean]
        $IsValidationOnly,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ScheduleInfo,

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

    # TODO: Remove during next breaking change
    if ($PSBoundParameters.ContainsKey('Action'))
    {
        Write-Warning -Message "The parameter 'Action' is deprecated. It will be removed in the next breaking change release."
    }

    if ($PSBoundParameters.ContainsKey('IsValidationOnly'))
    {
        Write-Warning -Message "The parameter 'IsValidationOnly' is deprecated. It will be removed in the next breaking change release."
    }

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
                                         -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
                                         @compareParameters
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
        [array] $exportedInstances = Get-MgBetaRoleManagementDirectoryRoleEligibilitySchedule -All -Filter $Filter -ErrorAction SilentlyContinue

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($exportedInstances.Count -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        if ($null -eq $Script:RoleDefinitions)
        {
            $Script:RoleDefinitions = [System.Collections.Generic.Dictionary[string, object]]::new()
            $roleDefinitions = Get-MgBetaRoleManagementDirectoryRoleDefinition -All -ErrorAction SilentlyContinue
            foreach ($roleDefinition in $roleDefinitions)
            {
                $Script:RoleDefinitions.Add($roleDefinition.Id, $roleDefinition)
            }
        }
        foreach ($config in $exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            Write-M365DSCHost -Message "    |---[$i/$($exportedInstances.Count)] $displayedKey" -DeferWrite
            # Find the Principal Type
            $principalType = 'User'
            $userInfo = Get-MgBetaDirectoryObjectById -Ids $config.PrincipalId -ErrorAction SilentlyContinue
            $principalType = $userInfo['@odata.type'].Split('.')[2]
            $PrincipalValue = if ($principalType -eq 'user' )
            {
                $userInfo['userPrincipalName']
            }
            else
            {
                $userInfo['displayName']
            }

            if ($null -ne $PrincipalValue)
            {
                $roleDefinition = $Script:RoleDefinitions[$config.RoleDefinitionId]
                if ($null -eq $roleDefinition)
                {
                    $roleDefinition = Get-MgBetaRoleManagementDirectoryRoleDefinition -UnifiedRoleDefinitionId $config.RoleDefinitionId `
                        -ErrorAction SilentlyContinue
                    $Script:RoleDefinitions.Add($config.RoleDefinitionId, $roleDefinition)
                }
                $params = @{
                    Id                    = $config.Id
                    Principal             = $PrincipalValue
                    PrincipalType         = $principalType
                    DirectoryScopeId      = $config.DirectoryScopeId
                    RoleDefinition        = $roleDefinition.DisplayName
                    Ensure                = 'Present'
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    ApplicationSecret     = $ApplicationSecret
                    CertificateThumbprint = $CertificateThumbprint
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    AccessTokens          = $AccessTokens
                }
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

            if ($Results.ScheduleInfo)
            {
                $complexMapping = @(
                    @{
                        Name            = 'expiration'
                        CimInstanceName = 'AADRoleEligibilityScheduleRequestScheduleExpiration'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'Recurrence'
                        CimInstanceName = 'AADRoleEligibilityScheduleRequestScheduleRecurrence'
                        IsRequired      = $False
                    }
                    @{
                        Name            = "range"
                        CimInstanceName = 'AADRoleEligibilityScheduleRequestScheduleRecurrenceRange'
                        IsRequired      = $False
                    }
                    @{
                        Name            = "pattern"
                        CimInstanceName = 'AADRoleEligibilityScheduleRequestScheduleRecurrencePattern'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.ScheduleInfo `
                        -CIMInstanceName 'AADRoleEligibilityScheduleRequestSchedule' `
                        -ComplexTypeMapping $complexMapping
                if ($complexTypeStringResult)
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
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Test-M365DSCRecurrenceIsConfigured
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $RecurrenceSettings
    )

    if ($null -eq $RecurrenceSettings.Pattern.DayOfMonth -and `
        $null -eq $RecurrenceSettings.Pattern.DayOfWeek -and `
        $null -eq $RecurrenceSettings.Pattern.FirstDayOfWeek -and `
        $null -eq $RecurrenceSettings.Pattern.Index -and `
        $null -eq $RecurrenceSettings.Pattern.Interval -and `
        $null -eq $RecurrenceSettings.Pattern.Month -and `
        $null -eq $RecurrenceSettings.Pattern.Type -and `
        $null -eq $RecurrenceSettings.Range.EndDate -and `
        $null -eq $RecurrenceSettings.Range.NumberOfOccurrences -and `
        $null -eq $RecurrenceSettings.Range.RecurrenceTimeZone -and `
        $null -eq $RecurrenceSettings.Range.StartDate -and `
        $null -eq $RecurrenceSettings.Range.Type)
    {
        return $false
    }

    return $true
}

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        ExcludedProperties = @('Action', 'IsValidationOnly', 'Justification')
        PostProcessing = {
            param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
            if (-not [System.String]::IsNullOrEmpty($DesiredValues.ScheduleInfo.StartDateTime))
            {
                $parsedDesiredDate = [System.DateTime]::MinValue
                $parseResultDesired = [System.DateTime]::TryParse($DesiredValues.ScheduleInfo.StartDateTime, [ref]$parsedDesiredDate)

                $parsedCurrentDate = [System.DateTime]::MinValue
                $parseResultCurrent = [System.DateTime]::TryParse($CurrentValues.ScheduleInfo.StartDateTime, [ref]$parsedCurrentDate)

                if ($parseResultDesired -and $parseResultCurrent)
                {
                    Write-Verbose -Message "Parsed Desired StartDateTime: $parsedDesiredDate, Parsed Current StartDateTime: $parsedCurrentDate"
                    if ($parsedDesiredDate -ne $parsedCurrentDate -and $parsedDesiredDate -lt [System.DateTime]::UtcNow)
                    {
                        Write-Verbose -Message "Ignoring StartDateTime in ScheduleInfo as it is in the past. StartDateTime cannot be set to a past date."
                        Write-Verbose -Message "Aligning the Desired and Current StartDateTime values for comparison."
                        $DesiredValues.ScheduleInfo.StartDateTime = $CurrentValues.ScheduleInfo.StartDateTime
                    }
                }
            }
            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
