Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADAccessReviewDefinition'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $DescriptionForAdmins,

        [Parameter()]
        [System.String]
        $DescriptionForReviewers,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdditionalNotificationRecipients,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $FallbackReviewers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InstanceEnumerationScope,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Reviewers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ScopeValue,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SettingsValue,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $StageSettings,

        [Parameter()]
        [System.String]
        $Id,

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

    Write-Verbose -Message "Getting configuration for Access Review Definition '$DisplayName'"

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
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaIdentityGovernanceAccessReviewDefinition -AccessReviewScheduleDefinitionId $Id `
                    -ErrorAction SilentlyContinue
            }
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Azure AD Access Review Definition with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaIdentityGovernanceAccessReviewDefinition `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Azure AD Access Review Definition with DisplayName {$DisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Azure AD Access Review Definition with Id {$Id} and DisplayName {$DisplayName} was found"

        #region resource generator code
        $complexScope = [ordered]@{}
        $complexScope.Add('Query', $getValue.Scope.query)
        $complexScope.Add('QueryRoot', $getValue.Scope.queryRoot)
        $complexScope.Add('QueryType', $getValue.Scope.queryType)

        if ($null -ne $getValue.Scope.'@odata.type')
        {
            $complexScope.Add('odataType', $getValue.Scope.'@odata.type'.ToString())
        }

        if ($complexScope.odataType -ne '#microsoft.graph.accessReviewQueryScope')
        {
            $complexPrincipalScopes = @()
            foreach ($currentPrincipalScopes in $getValue.Scope.principalScopes)
            {
                $myPrincipalScopes = [ordered]@{}
                $myPrincipalScopes.Add('Query', $currentPrincipalScopes.query)
                $myPrincipalScopes.Add('QueryRoot', $currentPrincipalScopes.queryRoot)
                $myPrincipalScopes.Add('QueryType', $currentPrincipalScopes.queryType)
                $myPrincipalScopes.Add('ScopeType', $currentPrincipalScopes.scopeType)
                if ($null -ne $currentPrincipalScopes.'@odata.type')
                {
                    $myPrincipalScopes.Add('odataType', $currentPrincipalScopes.'@odata.type'.ToString())
                }
                if ($myPrincipalScopes.values.Where({ $null -ne $_ }).Count -gt 0)
                {
                    $complexPrincipalScopes += $myPrincipalScopes
                }
            }
            $complexScope.Add('PrincipalScopes', $complexPrincipalScopes)
            $complexResourceScopes = @()
            foreach ($currentResourceScopes in $getValue.Scope.resourceScopes)
            {
                $myResourceScopes = [ordered]@{}
                $myResourceScopes.Add('Query', $currentResourceScopes.query)
                $myResourceScopes.Add('QueryRoot', $currentResourceScopes.queryRoot)
                $myResourceScopes.Add('QueryType', $currentResourceScopes.queryType)
                $myResourceScopes.Add('DisplayName', $currentResourceScopes.displayName)
                $myResourceScopes.Add('ResourceScopeId', $currentResourceScopes.resourceId)
                $myResourceScopes.Add('ScopeType', $currentResourceScopes.scopeType)
                if ($null -ne $currentResourceScopes.'@odata.type')
                {
                    $myResourceScopes.Add('odataType', $currentResourceScopes.'@odata.type'.ToString())
                }
                if ($myResourceScopes.values.Where({ $null -ne $_ }).Count -gt 0)
                {
                    $complexResourceScopes += $myResourceScopes
                }
            }
            $complexScope.Add('ResourceScopes', $complexResourceScopes)
        }

        if ($complexScope.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexScope = $null
        }

        $complexInstanceEnumerationScope = $null
        if ($null -ne $getValue.InstanceEnumerationScope)
        {
            $complexInstanceEnumerationScope = [ordered]@{}
            $complexInstanceEnumerationScope.Add('Query', (($getValue.InstanceEnumerationScope.query -replace '\/v1.0', '') -replace '&\$count=true', ''))
            $complexInstanceEnumerationScope.Add('QueryType', $getValue.InstanceEnumerationScope.queryType)
        }

        $complexSettings = [ordered]@{}
        $complexApplyActions = @()
        foreach ($currentApplyActions in $getValue.Settings.applyActions)
        {
            $myApplyActions = [ordered]@{}
            if ($null -ne $currentApplyActions.'@odata.type')
            {
                $myApplyActions.Add('odataType', $currentApplyActions.'@odata.type'.ToString())
            }
            if ($myApplyActions.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexApplyActions += $myApplyActions
            }
        }
        $complexSettings.Add('ApplyActions', $complexApplyActions)
        $complexSettings.Add('AutoApplyDecisionsEnabled', $getValue.Settings.autoApplyDecisionsEnabled)
        $complexSettings.Add('DecisionHistoriesForReviewersEnabled', $getValue.Settings.decisionHistoriesForReviewersEnabled)
        $complexSettings.Add('DefaultDecision', $getValue.Settings.defaultDecision)
        $complexSettings.Add('DefaultDecisionEnabled', $getValue.Settings.defaultDecisionEnabled)
        $complexSettings.Add('InstanceDurationInDays', $getValue.Settings.instanceDurationInDays)
        $complexSettings.Add('JustificationRequiredOnApproval', $getValue.Settings.justificationRequiredOnApproval)
        $complexSettings.Add('MailNotificationsEnabled', $getValue.Settings.mailNotificationsEnabled)
        $complexRecommendationInsightSettings = @()
        foreach ($currentRecommendationInsightSettings in $getValue.Settings.recommendationInsightSettings)
        {
            $myRecommendationInsightSettings = [ordered]@{}
            $myRecommendationInsightSettings.Add('RecommendationLookBackDuration', $currentRecommendationInsightSettings.recommendationLookBackDuration)
            if ($null -ne $currentRecommendationInsightSettings.signInScope)
            {
                $myRecommendationInsightSettings.Add('SignInScope', $currentRecommendationInsightSettings.signInScope.ToString())
            }
            if ($null -ne $currentRecommendationInsightSettings.'@odata.type')
            {
                $myRecommendationInsightSettings.Add('odataType', $currentRecommendationInsightSettings.'@odata.type'.ToString())
            }
            if ($myRecommendationInsightSettings.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexRecommendationInsightSettings += $myRecommendationInsightSettings
            }
        }
        $complexSettings.Add('RecommendationInsightSettings', $complexRecommendationInsightSettings)

        if ($null -ne $getValue.Settings.recommendationLookBackDuration)
        {
            $complexSettings.Add('RecommendationLookBackDuration', $getValue.Settings.recommendationLookBackDuration.ToString())
        }
        $complexSettings.Add('RecommendationsEnabled', $getValue.Settings.recommendationsEnabled)
        $complexRecurrence = [ordered]@{}
        $complexPattern = [ordered]@{}
        if ($getValue.settings.recurrence.pattern.type -in @('absoluteMonthly', 'absoluteYearly') -and $getValue.settings.recurrence.pattern.dayOfMonth -gt 0)
        {
            $complexPattern.Add('DayOfMonth', $getValue.settings.recurrence.pattern.dayOfMonth)
        }
        if ($null -ne $getValue.settings.recurrence.pattern.daysOfWeek -and $getValue.settings.recurrence.pattern.type -in @('weekly', 'relativeMonthly', 'relativeYearly'))
        {
            $complexPattern.Add('DaysOfWeek', $getValue.settings.recurrence.pattern.daysOfWeek)
        }
        if ($null -ne $getValue.settings.recurrence.pattern.firstDayOfWeek -and $getValue.settings.recurrence.pattern.type -eq 'weekly')
        {
            $complexFirstDaysOfWeek = [String]::Join(', ', $getValue.settings.recurrence.pattern.firstDayOfWeek)
            $complexPattern.Add('FirstDayOfWeek', $complexFirstDaysOfWeek)
        }
        if ($null -ne $getValue.settings.recurrence.pattern.index -and $getValue.settings.recurrence.pattern.type -in @('relativeMonthly', 'relativeYearly'))
        {
            $complexPattern.Add('Index', $getValue.settings.recurrence.pattern.index.ToString())
        }
        $complexPattern.Add('Interval', $getValue.settings.recurrence.pattern.interval)
        if ($getValue.settings.recurrence.pattern.month -gt 0)
        {
            $complexPattern.Add('Month', $getValue.settings.recurrence.pattern.month)
        }
        if ($null -ne $getValue.settings.recurrence.pattern.type)
        {
            $complexPattern.Add('Type', $getValue.settings.recurrence.pattern.type.ToString())
        }
        if ($complexPattern.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexPattern = $null
        }
        $complexRecurrence.Add('Pattern', $complexPattern)
        $complexRange = [ordered]@{}
        if ($null -ne $getValue.settings.recurrence.range.endDate -and $getValue.settings.recurrence.range.type -eq 'endDate')
        {
            $complexRange.Add('EndDate', ([DateTime]$getValue.settings.recurrence.range.endDate).ToString('o'))
        }
        $complexRange.Add('NumberOfOccurrences', $getValue.settings.recurrence.range.numberOfOccurrences)
        $complexRange.Add('RecurrenceTimeZone', $getValue.settings.recurrence.range.recurrenceTimeZone)
        if ($null -ne $getValue.settings.recurrence.range.startDate)
        {
            $complexRange.Add('StartDate', ([DateTime]$getValue.settings.recurrence.range.startDate).ToString('o') + 'Z')
        }
        if ($null -ne $getValue.settings.recurrence.range.type)
        {
            $complexRange.Add('Type', $getValue.settings.recurrence.range.type.ToString())
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
        $complexSettings.Add('Recurrence', $complexRecurrence)
        $complexSettings.Add('ReminderNotificationsEnabled', $getValue.Settings.reminderNotificationsEnabled)
        if ($complexSettings.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexSettings = $null
        }

        $complexStageSettings = @()
        foreach ($currentStageSettings in $getValue.stageSettings)
        {
            $myStageSettings = [ordered]@{}
            $myStageSettings.Add('DecisionsThatWillMoveToNextStage', $currentStageSettings.decisionsThatWillMoveToNextStage)
            $myStageSettings.Add('DependsOnValue', $currentStageSettings.dependsOn)
            $myStageSettings.Add('DurationInDays', $currentStageSettings.durationInDays)
            $complexRecommendationInsightSettings = @()
            foreach ($currentRecommendationInsightSettings in $currentStageSettings.recommendationInsightSettings)
            {
                $myRecommendationInsightSettings = [ordered]@{}

                if ($null -ne $currentRecommendationInsightSettings.recommendationLookBackDuration)
                {

                    $myRecommendationInsightSettings.Add('RecommendationLookBackDuration', $currentRecommendationInsightSettings.recommendationLookBackDuration.ToString())
                }
                if ($null -ne $currentRecommendationInsightSettings.signInScope)
                {
                    $myRecommendationInsightSettings.Add('SignInScope', $currentRecommendationInsightSettings.signInScope.ToString())
                }
                if ($null -ne $currentRecommendationInsightSettings.'@odata.type')
                {
                    $myRecommendationInsightSettings.Add('odataType', $currentRecommendationInsightSettings.'@odata.type'.ToString())
                }
                if ($myRecommendationInsightSettings.values.Where({ $null -ne $_ }).Count -gt 0)
                {
                    $complexRecommendationInsightSettings += $myRecommendationInsightSettings
                }
            }
            $myStageSettings.Add('RecommendationInsightSettings', $complexRecommendationInsightSettings)
            $myStageSettings.Add('RecommendationLookBackDuration', $currentStageSettings.recommendationLookBackDuration)
            $myStageSettings.Add('RecommendationsEnabled', $currentStageSettings.recommendationsEnabled)
            $myStageSettings.Add('StageId', $currentStageSettings.stageId)
            if ($myStageSettings.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexStageSettings += $myStageSettings
            }
        }

        $complexFallbackReviewers = @()
        if ($getValue.FallbackReviewers.Count -gt 0)
        {
            $allQueries = $getValue.FallbackReviewers.Query
            if ($allQueries.Count -gt 0)
            {
                $batchRequests = @()
                foreach ($query in $allQueries)
                {
                    $batchRequests += @{
                        id     = $query
                        method = 'GET'
                        url    = $query.Replace('/v1.0', '').Replace('transitiveMembers/microsoft.graph.user', '')
                    }
                }
                Write-Verbose -Message "Invoking BATCH request to resolve Fallback Reviewers from Get-TargetResource: $(ConvertTo-Json $batchRequests -Depth 10)"
                $batchResponses = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests
            }

            foreach ($currentFallbackReviewer in $getValue.FallbackReviewers)
            {
                $currentQuery = $batchResponses | Where-Object { $_.id -eq $currentFallbackReviewer.Query }
                switch ($currentFallbackReviewer.Query)
                {
                    { $_ -like '*users*' }
                    {
                        $reviewerType = 'User'
                    }
                    { $_ -like '*groups*' }
                    {
                        $reviewerType = 'Group'
                    }
                }
                $myFallbackReviewer = [ordered]@{}
                $myFallbackReviewer.Add('DisplayName', $currentQuery.body.displayName)
                $myFallbackReviewer.Add('ScopeType', $currentFallbackReviewer.scopeType)
                $myFallbackReviewer.Add('Type', $reviewerType)
                $complexFallbackReviewers += $myFallbackReviewer
            }
        }

        $complexAdditionalNotificationRecipients = @()
        if ($getValue.AdditionalNotificationRecipients.Count -gt 0)
        {
            $allQueries = $getValue.AdditionalNotificationRecipients.NotificationRecipientScope.Query
            if ($allQueries.Count -gt 0)
            {
                $batchRequests = @()
                foreach ($query in $allQueries)
                {
                    $batchRequests += @{
                        id     = $query
                        method = 'GET'
                        url    = $query.Replace('/v1.0', '').Replace('transitiveMembers/microsoft.graph.user', '')
                    }
                }
                Write-Verbose -Message "Invoking BATCH request to resolve Additional Notification Recipients from Get-TargetResource: $(ConvertTo-Json $batchRequests -Depth 10)"
                $batchResponses = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests
            }

            foreach ($currentAdditionalNotificationRecipient in $getValue.AdditionalNotificationRecipients)
            {
                $currentQuery = $batchResponses | Where-Object { $_.id -eq $currentAdditionalNotificationRecipient.NotificationRecipientScope.Query }
                switch ($currentAdditionalNotificationRecipient.NotificationRecipientScope.Query)
                {
                    { $_ -like '*users*' }
                    {
                        $reviewerType = 'User'
                    }
                    { $_ -like '*groups*' }
                    {
                        $reviewerType = 'Group'
                    }
                }
                $myAdditionalNotificationRecipient = [ordered]@{}
                $myAdditionalNotificationRecipient.Add('DisplayName', $currentQuery.body.displayName)
                $myAdditionalNotificationRecipient.Add('Type', $reviewerType)
                $complexAdditionalNotificationRecipients += $myAdditionalNotificationRecipient
            }
        }

        $complexReviewers = @()
        $allQueries = $getValue.Reviewers.Query
        $batchRequests = @()
        foreach ($query in $($allQueries | Where-Object { $_ -notlike "*manager*" -and -not [System.String]::IsNullOrEmpty($_) }))
        {
            if ($query -like '*manager*')
            {
                continue
            }
            $batchRequests += @{
                id     = $query
                method = 'GET'
                url    = $query.Replace('/v1.0', '').Replace('transitiveMembers/microsoft.graph.user', '').Replace('owners', '')
            }
        }
        if ($batchRequests.Count -gt 0)
        {
            Write-Verbose -Message "Invoking BATCH request to resolve Reviewers from Get-TargetResource: $(ConvertTo-Json $batchRequests -Depth 10)"
            $batchResponses = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests
        }

        foreach ($currentReviewer in $getValue.Reviewers)
        {
            $currentQuery = $batchResponses | Where-Object { $_.id -eq $currentReviewer.Query }
            switch ($currentReviewer.Query)
            {
                { $_ -like '*manager*' }
                {
                    $reviewerType = 'Manager'
                }
                { $_ -like '*users*' }
                {
                    $reviewerType = 'User'
                }
                { $_ -like '*groups*' }
                {
                    $reviewerType = 'Group'
                }
                { $_ -like '*/owners' }
                {
                    $reviewerType = 'Owner'
                }
            }
            $myReviewer = [ordered]@{}
            $myReviewer.Add('DisplayName', $currentQuery.body.displayName)
            $myReviewer.Add('ScopeType', $currentReviewer.scopeType)
            $myReviewer.Add('Type', $reviewerType)
            $complexReviewers += $myReviewer
        }
        #endregion

        $results = @{
            AdditionalNotificationRecipients = $complexAdditionalNotificationRecipients
            DescriptionForAdmins             = $getValue.DescriptionForAdmins
            DescriptionForReviewers          = $getValue.DescriptionForReviewers
            DisplayName                      = $getValue.DisplayName
            FallbackReviewers                = $complexFallbackReviewers
            InstanceEnumerationScope         = $complexInstanceEnumerationScope
            Reviewers                        = $complexReviewers
            ScopeValue                       = $complexScope
            SettingsValue                    = $complexSettings
            StageSettings                    = $complexStageSettings
            Id                               = $getValue.Id
            Ensure                           = 'Present'
            Credential                       = $Credential
            ApplicationId                    = $ApplicationId
            TenantId                         = $TenantId
            ApplicationSecret                = $ApplicationSecret
            CertificateThumbprint            = $CertificateThumbprint
            CertificatePath                  = $CertificatePath
            CertificatePassword              = $CertificatePassword
            ManagedIdentity                  = $ManagedIdentity.IsPresent
            AccessTokens                     = $AccessTokens
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
        [Parameter()]
        [System.String]
        $DescriptionForAdmins,

        [Parameter()]
        [System.String]
        $DescriptionForReviewers,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdditionalNotificationRecipients,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $FallbackReviewers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InstanceEnumerationScope,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Reviewers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ScopeValue,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SettingsValue,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $StageSettings,

        [Parameter()]
        [System.String]
        $Id,

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

    Write-Verbose -Message "Setting configuration for Access Review Definition '$DisplayName'"

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

    if ($BoundParameters.ContainsKey('AdditionalNotificationRecipients'))
    {
        $batchRequests = @()
        foreach ($currentRecipient in $AdditionalNotificationRecipients)
        {
            if ($currentRecipient.Type -eq 'User')
            {
                $reviewerType = 'users'
            }
            elseif ($currentRecipient.Type -eq 'Group')
            {
                $reviewerType = 'groups'
            }
            $filter = "displayName eq '$($currentRecipient.DisplayName -replace "'", "''")'"
            $batchRequests += @{
                id     = $currentRecipient.DisplayName
                method = 'GET'
                url    = "/$($reviewerType)?`$filter=$filter"
            }
        }
        if ($batchRequests.Count -gt 0)
        {
            Write-Verbose -Message "Invoking BATCH request to resolve AdditionalNotificationRecipients: $(ConvertTo-Json $batchRequests -Depth 10)"
            $batchResponses = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests
        }
        $newAdditionalNotificationRecipients = @()
        foreach ($currentRecipient in $AdditionalNotificationRecipients)
        {
            $currentQuery = $batchResponses | Where-Object { $_.id -eq $currentRecipient.DisplayName }
            if ($currentRecipient.Type -eq 'User')
            {
                $reviewerType = 'users'
            }
            elseif ($currentRecipient.Type -eq 'Group')
            {
                $reviewerType = 'groups'
            }
            if ($null -ne $currentQuery)
            {
                $append = $null
                if ($reviewerType -eq 'groups')
                {
                    $append = '/transitiveMembers'
                }
                $myAdditionalRecipient = @{
                    notificationRecipientScope = @{
                        '@odata.type' = '#microsoft.graph.accessReviewNotificationRecipientQueryScope'
                        query         = "/$reviewerType/$($currentQuery.body.value.id)$append"
                        queryType     = 'MicrosoftGraph'
                    }
                    notificationTemplateType = 'CompletedAdditionalRecipients'
                }
                $newAdditionalNotificationRecipients += $myAdditionalRecipient
            }
        }
        $BoundParameters.Remove('AdditionalNotificationRecipients') | Out-Null
        $BoundParameters.Add('additionalNotificationRecipients', $newAdditionalNotificationRecipients)
    }

    if ($BoundParameters.ContainsKey('FallbackReviewers'))
    {
        $batchRequests = @()
        foreach ($currentFallbackReviewer in $FallbackReviewers)
        {
            if ($currentFallbackReviewer.Type -eq 'User')
            {
                $reviewerType = 'users'
            }
            elseif ($currentFallbackReviewer.Type -eq 'Group')
            {
                $reviewerType = 'groups'
            }
            $filter = "displayName eq '$($currentFallbackReviewer.DisplayName -replace "'", "''")'"
            $batchRequests += @{
                id     = $currentFallbackReviewer.DisplayName
                method = 'GET'
                url    = "/$($reviewerType)?`$filter=$filter"
            }
        }
        if ($batchRequests.Count -gt 0)
        {
            Write-Verbose -Message "Invoking BATCH request to resolve FallbackReviewers: $(ConvertTo-Json $batchRequests -Depth 10)"
            $batchResponses = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests
        }
        $newFallbackReviewers = @()
        foreach ($currentFallbackReviewer in $FallbackReviewers)
        {
            $currentQuery = $batchResponses | Where-Object { $_.id -eq $currentFallbackReviewer.DisplayName }
            if ($currentFallbackReviewer.Type -eq 'User')
            {
                $reviewerType = 'users'
            }
            elseif ($currentFallbackReviewer.Type -eq 'Group')
            {
                $reviewerType = 'groups'
            }
            if ($null -ne $currentQuery)
            {
                $append = $null
                if ($reviewerType -eq 'groups')
                {
                    $append = '/transitiveMembers'
                }
                $myFallbackReviewer = @{
                    query     = "/$reviewerType/$($currentQuery.body.value.id)$append"
                    queryType = 'MicrosoftGraph'
                }
                $newFallbackReviewers += $myFallbackReviewer
            }
        }
        $BoundParameters.Remove('FallbackReviewers') | Out-Null
        $BoundParameters.Add('fallbackReviewers', $newFallbackReviewers)
    }

    if ($BoundParameters.ContainsKey('Reviewers'))
    {
        $batchRequests = @()
        foreach ($currentReviewer in $Reviewers)
        {
            if ($currentReviewer.Type -eq 'Manager' -or $currentReviewer.ScopeType -in @('Manager', 'ResourceOwner'))
            {
                continue
            }

            switch ($currentReviewer.Type)
            {
                'User'
                {
                    $reviewerType = 'users'
                }
                'Group'
                {
                    $reviewerType = 'groups'
                }
                'Owner'
                {
                    $reviewerType = 'groups'
                }
            }
            if (-not [System.String]::IsNullOrEmpty($currentReviewer.DisplayName))
            {
                $filter = "displayName eq '$($currentReviewer.DisplayName -replace "'", "''")'"
                $batchRequests += @{
                    id     = $currentReviewer.DisplayName
                    method = 'GET'
                    url    = "/$($reviewerType)?`$filter=$filter"
                }
            }
        }
        if ($batchRequests.Count -gt 0)
        {
            Write-Verbose -Message "Invoking BATCH request to resolve Reviewers: $(ConvertTo-Json $batchRequests -Depth 10)"
            $batchResponses = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests
        }
        $newReviewers = @()
        foreach ($currentReviewer in $Reviewers)
        {
            Write-Verbose "Checking reviewer $($currentReviewer.DisplayName) of type $($currentReviewer.Type) with scope type $($currentReviewer.ScopeType)"
            $currentQuery = $batchResponses | Where-Object { $_.id -eq $currentReviewer.DisplayName }
            switch ($currentReviewer.Type)
            {
                'User'
                {
                    $reviewerType = 'users'
                }
                'Group'
                {
                    $reviewerType = 'groups'
                }
                'Owner'
                {
                    $reviewerType = 'groups'
                }
            }
            if ($null -ne $currentQuery)
            {
                $append = $null
                if ($reviewerType -eq 'groups')
                {
                    $append = '/transitiveMembers/microsoft.graph.user'
                }
                elseif ($currentReviewer.Type -eq 'Owner')
                {
                    $append = '/owners'
                }
                $myReviewer = @{
                    query     = "/v1.0/$reviewerType/$($currentQuery.body.value.id)$append"
                    queryType = 'MicrosoftGraph'
                }
                $newReviewers += $myReviewer
            }
            else
            {
                if ($currentReviewer.Type -eq 'Manager')
                {
                    $myReviewer = @{
                        queryType = 'MicrosoftGraph'
                        query = './manager'
                        queryRoot = 'decisions'
                    }
                    $newReviewers += $myReviewer
                }
            }
        }
        $BoundParameters.Remove('Reviewers') | Out-Null
        $BoundParameters.Add('reviewers', $newReviewers)
    }

    if ($BoundParameters.ScopeValue.odataType -eq '#microsoft.graph.accessReviewQueryScope')
    {
        $BoundParameters.ScopeValue = @{
            '@odata.type' = '#microsoft.graph.accessReviewQueryScope'
            query     = $BoundParameters.ScopeValue.Query
            queryType = $BoundParameters.ScopeValue.QueryType
        }
    }

    $boundParameters = ([Hashtable]$BoundParameters.Clone())
    $boundParameters = Rename-M365DSCCimInstanceParameter -Properties $boundParameters
    $boundParameters.Remove('Id') | Out-Null

    foreach ($scope in $boundParameters.ScopeValue.ResourceScopes)
    {
        if ($scope.ContainsKey('ResourceScopeId'))
        {
            $scope.Add('resourceId', $scope.ResourceScopeId)
            $scope.Remove('ResourceScopeId') | Out-Null
        }
    }
    $boundParameters.Add('scope', $boundParameters.ScopeValue)
    $boundParameters.Remove('ScopeValue') | Out-Null

    $boundParameters.Add('settings', $boundParameters.SettingsValue)
    $boundParameters.Remove('SettingsValue') | Out-Null

    if ($null -ne $StageSettings)
    {
        Write-Verbose -Message 'StageSettings cannot be updated after creation of access review definition.'

        if ($currentInstance.Ensure -ne 'Absent')
        {
            Write-Verbose -Message "Removing the Azure AD Access Review Definition with Id {$($currentInstance.Id)}"
            Remove-MgBetaIdentityGovernanceAccessReviewDefinition -AccessReviewScheduleDefinitionId $currentInstance.Id
        }

        Write-Verbose -Message "Creating an Azure AD Access Review Definition with DisplayName {$DisplayName}"

        $createParameters = ([Hashtable]$BoundParameters).Clone()
        foreach ($hashtable in $createParameters.StageSettings)
        {
            $propertyToRemove = 'DependsOnValue'
            $newProperty = 'dependsOn'
            if ($hashtable.ContainsKey($propertyToRemove))
            {
                $value = $hashtable[$propertyToRemove]
                $hashtable[$newProperty] = $value
                $hashtable.Remove($propertyToRemove)
            }
        }

        foreach ($hashtable in $createParameters.StageSettings)
        {
            $keys = (([Hashtable]$hashtable).Clone()).Keys
            foreach ($key in $keys)
            {
                $value = $hashtable.$key
                $hashtable.Remove($key)
                $hashtable.Add($key.Substring(0, 1).ToLower() + $key.Substring(1), $value)
            }
        }

        #$createParameters.Add('@odata.type', '#microsoft.graph.AccessReviewScheduleDefinition')
        Write-Verbose -Message "Creating an Azure AD Access Review Definition with: $(ConvertTo-Json $createParameters -Depth 10)"
        $policy = New-MgBetaIdentityGovernanceAccessReviewDefinition -BodyParameter $createParameters
        return
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Azure AD Access Review Definition with DisplayName {$DisplayName}"

        $createParameters = ([Hashtable]$BoundParameters).Clone()
        foreach ($hashtable in $createParameters.StageSettings)
        {
            $propertyToRemove = 'DependsOnValue'
            $newProperty = 'dependsOn'
            if ($hashtable.ContainsKey($propertyToRemove))
            {
                $value = $hashtable[$propertyToRemove]
                $hashtable[$newProperty] = $value
                $hashtable.Remove($propertyToRemove)
            }
        }

        foreach ($hashtable in $createParameters.StageSettings)
        {
            $keys = (([Hashtable]$hashtable).Clone()).Keys
            foreach ($key in $keys)
            {
                $value = $hashtable.$key
                $hashtable.Remove($key)
                $hashtable.Add($key.Substring(0, 1).ToLower() + $key.Substring(1), $value)
            }
        }

        #region resource generator code
        #$createParameters.Add('@odata.type', '#microsoft.graph.AccessReviewScheduleDefinition')
        Write-Verbose -Message "Creating an Azure AD Access Review Definition with: $(ConvertTo-Json $createParameters -Depth 10)"
        $policy = New-MgBetaIdentityGovernanceAccessReviewDefinition -BodyParameter $createParameters
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Azure AD Access Review Definition with Id {$($currentInstance.Id)}"

        $updateParameters = ([Hashtable]$BoundParameters).Clone()

        #region resource generator code
        #$UpdateParameters.Add('@odata.type', '#microsoft.graph.AccessReviewScheduleDefinition')
        Write-Verbose -Message "Updating Azure AD Access Review Definition {$($currentInstance.Id)} with: $(ConvertTo-Json $UpdateParameters -Depth 10)"
        Set-MgBetaIdentityGovernanceAccessReviewDefinition `
            -AccessReviewScheduleDefinitionId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Azure AD Access Review Definition with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaIdentityGovernanceAccessReviewDefinition -AccessReviewScheduleDefinitionId $currentInstance.Id
        #endregion
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $DescriptionForAdmins,

        [Parameter()]
        [System.String]
        $DescriptionForReviewers,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdditionalNotificationRecipients,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $FallbackReviewers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InstanceEnumerationScope,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Reviewers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ScopeValue,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SettingsValue,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $StageSettings,

        [Parameter()]
        [System.String]
        $Id,

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
        #region resource generator code
        [array]$getValue = Get-MgBetaIdentityGovernanceAccessReviewDefinition `
            -Filter $Filter `
            -All `
            -ErrorAction Stop
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
            elseif (-not [string]::IsNullOrEmpty($config.name))
            {
                $displayedKey = $config.name
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
            if ($null -ne $Results.ScopeValue)
            {
                $complexMapping = @(
                    @{
                        Name            = 'ScopeValue'
                        CimInstanceName = 'MicrosoftGraphAccessReviewScope'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'PrincipalScopes'
                        CimInstanceName = 'MicrosoftGraphAccessReviewPrincipalScope'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'ResourceScopes'
                        CimInstanceName = 'MicrosoftGraphAccessReviewResourceScope'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ScopeValue `
                    -CIMInstanceName 'MicrosoftGraphaccessReviewScope' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ScopeValue = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ScopeValue') | Out-Null
                }
            }
            if ($null -ne $Results.InstanceEnumerationScope)
            {
                $complexMapping = @(
                    @{
                        Name            = 'InstanceEnumerationScope'
                        CimInstanceName = 'MicrosoftGraphAccessReviewScope'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.InstanceEnumerationScope `
                    -CIMInstanceName 'MicrosoftGraphAccessReviewScope2' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.InstanceEnumerationScope = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('InstanceEnumerationScope') | Out-Null
                }
            }
            if ($null -ne $Results.SettingsValue)
            {
                $complexMapping = @(
                    @{
                        Name            = 'SettingsValue'
                        CimInstanceName = 'MicrosoftGraphAccessReviewScheduleSettings'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'ApplyActions'
                        CimInstanceName = 'MicrosoftGraphAccessReviewApplyAction'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'RecommendationInsightSettings'
                        CimInstanceName = 'MicrosoftGraphAccessReviewRecommendationInsightSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'Recurrence'
                        CimInstanceName = 'MicrosoftGraphPatternedRecurrence'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'Pattern'
                        CimInstanceName = 'MicrosoftGraphRecurrencePattern'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'Range'
                        CimInstanceName = 'MicrosoftGraphRecurrenceRange'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.SettingsValue `
                    -CIMInstanceName 'MicrosoftGraphAccessReviewScheduleSettings' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.SettingsValue = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('SettingsValue') | Out-Null
                }
            }
            if ($null -ne $Results.StageSettings)
            {
                $complexMapping = @(
                    @{
                        Name            = 'StageSettings'
                        CimInstanceName = 'MicrosoftGraphAccessReviewStageSettings'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'PrincipalScopes'
                        CimInstanceName = 'MicrosoftGraphAccessReviewScope'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'ResourceScopes'
                        CimInstanceName = 'MicrosoftGraphAccessReviewScope'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'RecommendationInsightSettings'
                        CimInstanceName = 'MicrosoftGraphAccessReviewRecommendationInsightSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'PrincipalScopes'
                        CimInstanceName = 'MicrosoftGraphAccessReviewScope'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'ResourceScopes'
                        CimInstanceName = 'MicrosoftGraphAccessReviewScope'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.StageSettings `
                    -CIMInstanceName 'MicrosoftGraphaccessReviewStageSettings' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.StageSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('StageSettings') | Out-Null
                }
            }
            if ($null -ne $Results.AdditionalNotificationRecipients)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.AdditionalNotificationRecipients `
                    -CIMInstanceName 'AADAccessReviewDefinitionReviewer'

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.AdditionalNotificationRecipients = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AdditionalNotificationRecipients') | Out-Null
                }
            }
            if ($null -ne $Results.FallbackReviewers)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.FallbackReviewers `
                    -CIMInstanceName 'AADAccessReviewDefinitionReviewer'

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.FallbackReviewers = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('FallbackReviewers') | Out-Null
                }
            }
            if ($null -ne $Results.Reviewers)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Reviewers `
                    -CIMInstanceName 'AADAccessReviewDefinitionReviewer'

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Reviewers = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Reviewers') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('ScopeValue', 'InstanceEnumerationScope', 'SettingsValue', 'StageSettings', 'AdditionalNotificationRecipients', 'FallbackReviewers', 'Reviewers')

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

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        PostProcessing = {
            param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
            if (-not [System.String]::IsNullOrEmpty($DesiredValues.SettingsValue.Recurrence.Range.StartDate))
            {
                $parsedDesiredDate = [System.DateTime]::MinValue
                $parseResultDesired = [System.DateTime]::TryParse($DesiredValues.SettingsValue.Recurrence.Range.StartDate, [ref]$parsedDesiredDate)

                $parsedCurrentDate = [System.DateTime]::MinValue
                $parseResultCurrent = [System.DateTime]::TryParse($CurrentValues.SettingsValue.Recurrence.Range.StartDate, [ref]$parsedCurrentDate)

                if ($parseResultDesired -and $parseResultCurrent)
                {
                    Write-Verbose -Message "Parsed Desired StartDateTime: $parsedDesiredDate, Parsed Current StartDateTime: $parsedCurrentDate"
                    if ($parsedDesiredDate -ne $parsedCurrentDate -and $parsedDesiredDate -lt [System.DateTime]::UtcNow)
                    {
                        Write-Verbose -Message 'Ignoring StartDateTime in ScheduleInfo as it is in the past. StartDateTime cannot be set to a past date.'
                        Write-Verbose -Message 'Aligning the Desired and Current StartDateTime values for comparison.'
                        $DesiredValues.SettingsValue.Recurrence.Range.StartDate = $CurrentValues.SettingsValue.Recurrence.Range.StartDate
                    }
                }
            }
            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
