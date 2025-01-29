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

    New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters | Out-Null

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
    try
    {
        if (-not [System.String]::IsNullOrEmpty($Id))
        {
            if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
            {
                $schedule = $Script:exportedInstances | Where-Object -FilterScript { $_.Id -eq $Id }
            }
            else
            {
                Write-Verbose -Message "Getting Role Eligibility by Id {$Id}"
                $schedule = Get-MgBetaRoleManagementDirectoryRoleEligibilitySchedule -UnifiedRoleEligibilityScheduleId $Id `
                    -ErrorAction SilentlyContinue
            }
        }

        Write-Verbose -Message 'Getting Role Eligibility by PrincipalId and RoleDefinitionId'
        $PrincipalValue = $null
        if ($PrincipalType -eq 'User')
        {
            Write-Verbose -Message "Retrieving Principal by UserPrincipalName {$Principal}"
            $PrincipalInstance = Get-MgUser -Filter "UserPrincipalName eq '$Principal'" -ErrorAction SilentlyContinue
            $PrincipalValue = $PrincipalInstance.UserPrincipalName
        }
        elseif ($null -eq $PrincipalIdValue -and $PrincipalType -eq 'Group')
        {
            Write-Verbose -Message "Retrieving Principal by DisplayName {$Principal}"
            $PrincipalInstance = Get-MgGroup -Filter "DisplayName eq '$Principal'" -ErrorAction SilentlyContinue
            $PrincipalValue = $PrincipalInstance.DisplayName
        }
        else
        {
            Write-Verbose -Message "Retrieving Principal by DisplayName {$Principal}"
            $PrincipalInstance = Get-MgServicePrincipal -Filter "DisplayName eq '$Principal'" -ErrorAction SilentlyContinue
            $PrincipalValue = $PrincipalInstance.DisplayName
        }

        Write-Verbose -Message "Found Principal {$PrincipalValue}"
        $RoleDefinitionId = (Get-MgBetaRoleManagementDirectoryRoleDefinition -Filter "DisplayName eq '$RoleDefinition'").Id
        Write-Verbose -Message "Retrieved role definition {$RoleDefinition} with ID {$RoleDefinitionId}"

        if ($null -eq $schedule)
        {
            Write-Verbose -Message "Retrieving the request by PrincipalId {$($PrincipalInstance.Id)}, RoleDefinitionId {$($RoleDefinitionId)} and DirectoryScopeId {$($DirectoryScopeId)}"
            [Array] $requests = Get-MgBetaRoleManagementDirectoryRoleEligibilitySchedule -Filter "PrincipalId eq '$($PrincipalInstance.Id)' and RoleDefinitionId eq '$($RoleDefinitionId)' and DirectoryScopeId eq '$($DirectoryScopeId)'"
            if ($requests.Length -eq 0)
            {
                # We need to make sure we're not ending up here because the role is a custom role (which has a different id).
                # We start by retrieving all schedules for the given principal.
                [Array] $schedulesForPrincipal = Get-MgBetaRoleManagementDirectoryRoleEligibilitySchedule -Filter "PrincipalId eq '$($PrincipalInstance.Id)' and DirectoryScopeId eq '$($DirectoryScopeId)'"
                
                # Loop through the role associated with each schedule to check and see if we have a match on the name.
                $schedule = $null
                foreach ($foundSchedule in $schedulesForPrincipal)
                {
                    $scheduleRoleId = $foundSchedule.RoleDefinitionId
                    $roleEntry = Get-MgBetaRoleManagementDirectoryRoleDefinition -UnifiedRoleDefinitionId $scheduleRoleId
                    if ($roleEntry.DisplayName -eq $RoleDefinition)
                    {
                        $RoleDefinitionId = $roleEntry.Id
                        $schedule = $foundSchedule
                        break
                    }
                }

                if ($null -eq $schedule)
                {
                    return $nullResult
                }
            }
            else
            {
                $schedule = $requests[0]
            }
        }

        if ($null -eq $schedule)
        {
            $schedules = Get-MgBetaRoleManagementDirectoryRoleEligibilitySchedule -Filter "PrincipalId eq '$($request.PrincipalId)'"
            $schedule = $schedules | Where-Object -FilterScript { $_.RoleDefinitionId -eq $RoleDefinitionId }
        }
        if ($null -eq $schedule)
        {
            foreach ($instance in $schedules)
            {
                $roleDefinitionInfo = Get-MgBetaRoleManagementDirectoryRoleDefinition -UnifiedRoleDefinitionId $instance.RoleDefinitionId
                if ($null -ne $roleDefinitionInfo -and $RoleDefinitionInfo.DisplayName -eq $RoleDefinition)
                {
                    $schedule = $instance
                    break
                }
            }
        }

        if ($null -eq $schedule)
        {
            if ($null -eq $schedule)
            {
                Write-Verbose -Message "Could not retrieve the schedule for {$($request.PrincipalId)} & RoleDefinitionId {$RoleDefinitionId}"
            }
            return $nullResult
        }

        $ScheduleInfoValue = @{}

        if ($null -ne $schedule.ScheduleInfo.Expiration)
        {
            $expirationValue = @{
                duration = $schedule.ScheduleInfo.Expiration.Duration
                type     = $schedule.ScheduleInfo.Expiration.Type
            }
            if ($null -ne $schedule.ScheduleInfo.Expiration.EndDateTime)
            {
                $expirationValue.Add('endDateTime', $schedule.ScheduleInfo.Expiration.EndDateTime.ToString('yyyy-MM-ddThh:mm:ssZ'))
            }
            $ScheduleInfoValue.Add('expiration', $expirationValue)
        }
        if ($null -ne $schedule.ScheduleInfo.Recurrence)
        {
            $recurrenceValue = @{
                pattern = @{
                    dayOfMonth     = $schedule.ScheduleInfo.Recurrence.Pattern.dayOfMonth
                    daysOfWeek     = $schedule.ScheduleInfo.Recurrence.Pattern.daysOfWeek
                    firstDayOfWeek = $schedule.ScheduleInfo.Recurrence.Pattern.firstDayOfWeek
                    index          = $schedule.ScheduleInfo.Recurrence.Pattern.index
                    interval       = $schedule.ScheduleInfo.Recurrence.Pattern.interval
                    month          = $schedule.ScheduleInfo.Recurrence.Pattern.month
                    type           = $schedule.ScheduleInfo.Recurrence.Pattern.type
                }
                range   = @{
                    endDate             = $schedule.ScheduleInfo.Recurrence.Range.endDate
                    numberOfOccurrences = $schedule.ScheduleInfo.Recurrence.Range.numberOfOccurrences
                    recurrenceTimeZone  = $schedule.ScheduleInfo.Recurrence.Range.recurrenceTimeZone
                    startDate           = $schedule.ScheduleInfo.Recurrence.Range.startDate
                    type                = $schedule.ScheduleInfo.Recurrence.Range.type
                }
            }
            $ScheduleInfoValue.Add('Recurrence', $recurrenceValue)
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
            Action                = $schedule.Action
            Id                    = $schedule.Id
            Justification         = $schedule.Justification
            IsValidationOnly      = $schedule.IsValidationOnly
            ScheduleInfo          = $ScheduleInfoValue
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            Managedidentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
        return $results
    }
    catch
    {
        Write-Verbose "Error: $_"
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

    Write-Verbose -Message "Retrieving Principal Id from Set-TargetResource"
    $PrincipalId = $null
    if ($PrincipalType -eq 'User')
    {
        Write-Verbose -Message "Retrieving Principal by UserPrincipalName {$Principal}"
        $PrincipalInstance = Get-MgUser -Filter "UserPrincipalName eq '$Principal'" -ErrorAction SilentlyContinue
        $PrincipalId = $PrincipalInstance.Id
    }
    elseif ($null -eq $PrincipalIdValue -and $PrincipalType -eq 'Group')
    {
        Write-Verbose -Message "Retrieving Principal by DisplayName {$Principal}"
        $PrincipalInstance = Get-MgGroup -Filter "DisplayName eq '$Principal'" -ErrorAction SilentlyContinue
        $PrincipalId = $PrincipalInstance.Id
    }
    else
    {
        Write-Verbose -Message "Retrieving Principal by DisplayName {$Principal}"
        $PrincipalInstance = Get-MgServicePrincipal -Filter "DisplayName eq '$Principal'" -ErrorAction SilentlyContinue
        $PrincipalId = $PrincipalInstance.Id
    }

    Write-Verbose -Message "Retrieving ROleDefinitionId from Set-TargetResource"
    $RoleDefinitionId = (Get-MgBetaRoleManagementDirectoryRoleDefinition -Filter "DisplayName eq '$RoleDefinition'").Id

    $instanceParams = @{
        directoryScopeId = $DirectoryScopeId
        principalId      = $PrincipalId
        roleDefinitionId = $RoleDefinitionId
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
        New-MgBetaRoleManagementDirectoryRoleEligibilityScheduleRequest @instanceParams -Verbose
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        $instanceParams.Add('action', 'AdminUpdate')
        $instanceParams.Add('justification', 'AdminUpdate by Microsoft365DSC')
        Write-Verbose -Message "Updating role eligibility Schedule with parameters:`r`n$(ConvertTo-Json $instanceParams -Depth 10)"
        New-MgBetaRoleManagementDirectoryRoleEligibilityScheduleRequest @instanceParams
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        $instanceParams.Add('action', 'AdminRemove')
        $instanceParams.Add('justification', 'AdminRemove by Microsoft365DSC')
        Write-Verbose -Message "Removing role eligibility Schedule with parameters:`r`n$(ConvertTo-Json $instanceParams -Depth 10)"
        New-MgBetaRoleManagementDirectoryRoleEligibilityScheduleRequest @instanceParams
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

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

    if ($null -ne $CurrentValues.ScheduleInfo -and $null -ne $ValuesToCheck.ScheduleInfo)
    {
        # Compare ScheduleInfo.Expiration
        if ($CurrentValues.ScheduleInfo.Expiration.duration -ne $ValuesToCheck.ScheduleInfo.Expiration.duration -or `
                $CurrentValues.ScheduleInfo.Expiration.endDateTime -ne $ValuesToCheck.ScheduleInfo.Expiration.endDateTime -or `
                $CurrentValues.ScheduleInfo.Expiration.type -ne $ValuesToCheck.ScheduleInfo.Expiration.type)
        {
            Write-Verbose -Message 'Discrepancy found in ScheduleInfo.Expiration'
            Write-Verbose -Message "Current: $($CurrentValues.ScheduleInfo.Expiration | Out-String)"
            Write-Verbose -Message "Desired: $($ValuesToCheck.ScheduleInfo.Expiration | Out-String)"
            return $false
        }

        # Compare ScheduleInfo.Recurrence.Pattern
        if ($CurrentValues.ScheduleInfo.Recurrence.Pattern.dayOfMonth -ne $ValuesToCheck.ScheduleInfo.Recurrence.Pattern.dayOfMonth -or `
                $CurrentValues.ScheduleInfo.Recurrence.Pattern.daysOfWeek -ne $ValuesToCheck.ScheduleInfo.Recurrence.Pattern.daysOfWeek -or `
                $CurrentValues.ScheduleInfo.Recurrence.Pattern.firstDayOfWeek -ne $ValuesToCheck.ScheduleInfo.Recurrence.Pattern.firstDayOfWeek -or `
                $CurrentValues.ScheduleInfo.Recurrence.Pattern.index -ne $ValuesToCheck.ScheduleInfo.Recurrence.Pattern.index -or `
                $CurrentValues.ScheduleInfo.Recurrence.Pattern.interval -ne $ValuesToCheck.ScheduleInfo.Recurrence.Pattern.interval -or `
                $CurrentValues.ScheduleInfo.Recurrence.Pattern.month -ne $ValuesToCheck.ScheduleInfo.Recurrence.Pattern.month -or `
                $CurrentValues.ScheduleInfo.Recurrence.Pattern.type -ne $ValuesToCheck.ScheduleInfo.Recurrence.Pattern.type)
        {
            Write-Verbose -Message 'Discrepancy found in ScheduleInfo.Recurrence.Pattern'
            Write-Verbose -Message "Current: $($CurrentValues.ScheduleInfo.Recurrence.Pattern | Out-String)"
            Write-Verbose -Message "Desired: $($ValuesToCheck.ScheduleInfo.Recurrence.Pattern | Out-String)"
            return $false
        }

        # Compare ScheduleInfo.Recurrence.Range
        if ($CurrentValues.ScheduleInfo.Recurrence.Range.endDate -ne $ValuesToCheck.ScheduleInfo.Recurrence.Range.endDate -or `
                $CurrentValues.ScheduleInfo.Recurrence.Range.numberOfOccurrences -ne $ValuesToCheck.ScheduleInfo.Recurrence.Range.numberOfOccurrences -or `
                $CurrentValues.ScheduleInfo.Recurrence.Range.recurrenceTimeZone -ne $ValuesToCheck.ScheduleInfo.Recurrence.Range.recurrenceTimeZone -or `
                $CurrentValues.ScheduleInfo.Recurrence.Range.startDate -ne $ValuesToCheck.ScheduleInfo.Recurrence.Range.startDate -or `
                $CurrentValues.ScheduleInfo.Recurrence.Range.type -ne $ValuesToCheck.ScheduleInfo.Recurrence.Range.type)
        {
            Write-Verbose -Message 'Discrepancy found in ScheduleInfo.Recurrence.Range'
            Write-Verbose -Message "Current: $($CurrentValues.ScheduleInfo.Recurrence.Range | Out-String)"
            Write-Verbose -Message "Desired: $($ValuesToCheck.ScheduleInfo.Recurrence.Range | Out-String)"
            return $false
        }
    }
    $ValuesToCheck.Remove('ScheduleInfo') | Out-Null    
    $ValuesToCheck.Remove('Action') | Out-Null
    $ValuesToCheck.Remove('IsValidationOnly') | Out-Null
    $ValuesToCheck.Remove('Justification') | Out-Null

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

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
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = Get-MgBetaRoleManagementDirectoryRoleEligibilitySchedule -All `
                                                -ErrorAction SilentlyContinue

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $Script:exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline
            # Find the Principal Type
            $principalType = 'User'
            $userInfo = Get-MgUser -UserId $config.PrincipalId -ErrorAction SilentlyContinue

            if ($null -eq $userInfo)
            {
                $principalType = 'Group'
                $groupInfo = Get-MgGroup -GroupId $config.PrincipalId -ErrorAction SilentlyContinue
                if ($null -eq $groupInfo)
                {
                    $principalType = 'ServicePrincipal'
                    $spnInfo = Get-MgServicePrincipal -ServicePrincipalId $config.PrincipalId -ErrorAction SilentlyContinue
                    if ($null -ne $spnInfo)
                    {
                        $PrincipalValue = $spnInfo.DisplayName
                    }
                    else
                    {
                        $PrincipalValue = $null
                    }
                }
                else
                {
                    $PrincipalValue = $groupInfo.DisplayName
                }
            }
            else
            {
                $PrincipalValue = $userInfo.UserPrincipalName
            }

            if ($null -ne $PrincipalValue)
            {
                $RoleDefinitionId = Get-MgBetaRoleManagementDirectoryRoleDefinition -UnifiedRoleDefinitionId $config.RoleDefinitionId
                $params = @{
                    Id                    = $config.Id
                    Principal             = $PrincipalValue
                    PrincipalType         = $principalType
                    DirectoryScopeId      = $config.DirectoryScopeId
                    RoleDefinition        = $RoleDefinitionId.DisplayName
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

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

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
                -Credential $Credential
            if ($Results.ScheduleInfo)
            {
                $isCIMArray = $false
                if ($Results.ScheduleInfo.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock `
                        -ParameterName 'ScheduleInfo' -IsCIMArray:$isCIMArray
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
