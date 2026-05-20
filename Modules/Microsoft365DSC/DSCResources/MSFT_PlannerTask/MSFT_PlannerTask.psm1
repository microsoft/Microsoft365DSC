Confirm-M365DSCModuleDependency -ModuleName 'MSFT_PlannerTask'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $PlanId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Title,

        [Parameter()]
        [System.String[]]
        $AssignedUsers,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $Bucket,

        [Parameter()]
        [System.String]
        $TaskId,

        [Parameter()]
        [System.String]
        $StartDateTime,

        [Parameter()]
        [System.String]
        $DueDateTime,

        [Parameter()]
        [System.String[]]
        $Categories,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Attachments,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Checklist,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Uint32]
        $PercentComplete,

        [Parameter()]
        [ValidateRange(0, 10)]
        [System.UInt32]
        $Priority,

        [Parameter()]
        [System.String]
        $ConversationThreadId,

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    Write-Verbose -Message "Getting configuration of Planner Task {$Title}"

    try
    {
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

        $nullReturn = $PSBoundParameters
        $nullReturn.Ensure = 'Absent'

        $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters

        # If no TaskId were passed, automatically assume that this is a new task;
        if ([System.String]::IsNullOrEmpty($TaskId))
        {
            return $nullReturn
        }

        $taskResponse = Get-MgPlannerTask -PlannerTaskId $TaskId
        $taskDetailsResponse = Get-MgPlannerTaskDetail -PlannerTaskId $taskResponse.Id

        #region Assignments
        $assignmentsValue = @()
        if ($null -ne $taskResponse.Assignments)
        {
            foreach ($assignmentKey in $taskResponse.Assignments.AdditionalProperties.Keys)
            {
                $assignedUser = Get-MgUser -UserId $assignmentKey -ErrorAction SilentlyContinue
                if ($null -eq $assignedUser)
                {
                    Write-Warning -Message "Skipping user with Id [$assignmentKey] because it could not be found."
                    continue
                }
                $assignmentsValue += $assignedUser.UserPrincipalName
            }
        }
        #endregion

        #region Attachments
        $attachmentsValue = @()
        if ($null -ne $taskDetailsResponse.References)
        {
            foreach ($attachment in $taskDetailsResponse.References.AdditionalProperties.Keys)
            {
                $entry = $taskDetailsResponse.References.AdditionalProperties."$attachment"
                $hashEntry = @{
                    Uri   = $attachment
                    Alias = $entry.alias
                    Type  = $entry.type
                }
                $attachmentsValue += $hashEntry
            }
        }
        #endregion

        #region Categories
        $categoriesValue = @()
        if ($null -ne $taskResponse.appliedCategories)
        {
            foreach ($category in $taskResponse.appliedCategories.AdditionalProperties.Keys)
            {
                $categoryValue = $Script:AppliedCategories.$category
                if ([String]::IsNullOrEmpty($categoryValue))
                {
                    $categoryValue = Get-TaskColorNameByCategory -CategoryName $category
                }
                $categoriesValue += $categoryValue
            }
        }
        #endregion

        #region Checklist
        $checklistValue = @()
        if ($null -ne $taskDetailsResponse.CheckList)
        {
            foreach ($checkListItem in $taskDetailsResponse.CheckList.AdditionalProperties.Keys)
            {
                $hashEntry = @{
                    Title     = $taskDetailsResponse.CheckList.AdditionalProperties."$checkListItem".title
                    Completed = [bool]$taskDetailsResponse.CheckList.AdditionalProperties."$checkListItem".isChecked
                }
                $checklistValue += $hashEntry
            }
        }
        #endregion

        if ($null -eq $taskResponse)
        {
            return $nullReturn
        }
        else
        {
            $NotesValue = ''
            if (-not [System.String]::IsNullOrEmpty($taskResponse))
            {
                $NotesValue = $taskDetailsResponse.Description
            }

            $StartDateTimeValue = $null
            if ($null -ne $taskResponse.StartDateTime)
            {
                $StartDateTimeValue = $taskResponse.StartDateTime
            }
            $DueDateTimeValue = $null
            if ($null -ne $taskResponse.DueDateTime)
            {
                $DueDateTimeValue = $taskResponse.DueDateTime
            }
            $results = @{
                PlanId                = $PlanId
                Title                 = $Title
                AssignedUsers         = $assignmentsValue
                TaskId                = $taskResponse.Id
                Categories            = $categoriesValue
                Attachments           = $attachmentsValue
                Checklist             = $checklistValue
                Bucket                = $taskResponse.BucketId
                Priority              = $taskResponse.Priority
                ConversationThreadId  = $taskResponse.ConversationThreadId
                PercentComplete       = $taskResponse.PercentComplete
                StartDateTime         = $StartDateTimeValue
                DueDateTime           = $DueDateTimeValue
                Notes                 = $NotesValue
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ApplicationSecret     = $ApplicationSecret
                ManagedIdentity       = $ManagedIdentity.IsPresent
            }
            return $results
        }
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
        $PlanId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Title,

        [Parameter()]
        [System.String[]]
        $AssignedUsers,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $Bucket,

        [Parameter()]
        [System.String]
        $TaskId,

        [Parameter()]
        [System.String]
        $StartDateTime,

        [Parameter()]
        [System.String]
        $DueDateTime,

        [Parameter()]
        [System.String[]]
        $Categories,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Attachments,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Checklist,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Uint32]
        $PercentComplete,

        [Parameter()]
        [ValidateRange(0, 10)]
        [System.UInt32]
        $Priority,

        [Parameter()]
        [System.String]
        $ConversationThreadId,

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    Write-Verbose -Message "Setting configuration of Planner Task {$Title}"

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

    $currentValues = Get-TargetResource @PSBoundParameters

    $setParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    #region Assignments
    Write-Verbose -Message 'Converting Assignments into the proper format'
    $assignmentsValue = @{}
    foreach ($assignment in $setParams.AssignedUsers)
    {
        $user = Get-MgUser -UserId $assignment -ErrorAction SilentlyContinue

        if ($null -ne $user)
        {
            $currentValue += @{
                '@odata.type' = '#microsoft.graph.plannerAssignment'
                orderHint     = ' !'
            }
            $assignmentsValue.Add($user.Id, $currentValue)
        }
    }
    $setParams.Assignments = $assignmentsValue
    $setParams.Remove('AssignedUsers') | Out-Null
    #endregion

    $DetailsValue = @{
        id          = (New-Guid).ToString()
        checklist   = @()
        description = $Notes
        references  = @()
    }

    #region CheckList
    $checklistValues = @{}
    foreach ($checkListItem in $setParams.Checklist)
    {
        $currentValue = @{
            '@odata.type' = '#microsoft.graph.plannerChecklistItem'
            isChecked     = $checkListItem.Completed
            title         = $checkListItem.Title
        }
        $checkListValues.Add((New-Guid).ToString(), $currentValue)
    }
    $DetailsValue.checklist = $checkListValues
    $setParams.Remove('Checklist') | Out-Null
    #endregion

    #region Attachments
    $attachmentsValues = @{}
    foreach ($attachment in $setParams.Attachments)
    {
        $currentValue = @{
            '@odata.type' = '#microsoft.graph.plannerExternalReference'
            alias         = $attachment.Alias
            type          = $attachment.Type
        }
        $attachmentsValues.Add($attachment.Uri, $currentValue)
    }
    $DetailsValue.references = $attachmentsValues
    $setParams.Remove('Attachments') | Out-Null
    #endregion

    $setParams.Remove('Description') | Out-Null
    $setParams.Add('Details', $DetailsValue)
    $setParams.Remove('Notes') | Out-Null

    #region Categories
    $categoriesValue = @{
        category1  = $false
        category2  = $false
        category3  = $false
        category4  = $false
        category5  = $false
        category6  = $false
        category7  = $false
        category8  = $false
        category9  = $false
        category10 = $false
        category11 = $false
        category12 = $false
        category13 = $false
        category14 = $false
        category15 = $false
        category16 = $false
        category17 = $false
        category18 = $false
        category19 = $false
        category20 = $false
        category21 = $false
        category22 = $false
        category23 = $false
        category24 = $false
        category25 = $false
    }

    $planDetails = (Get-MgPlannerPlanDetail -PlannerPlanId $PlanId).CategoryDescriptions
    $appliedCategoriesInverse = $planDetails | ConvertTo-Json | ConvertFrom-Json # Convert to PSObject instead of Graph type
    foreach ($category in $setParams.Categories)
    {
        $categoryName = $appliedCategoriesInverse.PSObject.Properties | Where-Object { $_.Value -eq $category } | Select-Object -ExpandProperty Name
        if ([String]::IsNullOrEmpty($categoryName))
        {
            $categoryName = Get-TaskCategoryNameByColor -ColorName $category
        }
        $categoriesValue.$categoryName = $true
    }
    $setParams.Add('AppliedCategories', $categoriesValue)
    $setParams.Remove('Categories') | Out-Null
    #endregion

    $setParams.Add('BucketId', $setParams.Bucket)
    $setParams.Remove('Bucket') | Out-Null

    if ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Absent')
    {
        $setParams.Remove('TaskId') | Out-Null
        Write-Verbose -Message "Planner Task {$Title} doesn't already exist. Creating it with`r`n:$(Convert-M365DscHashtableToString -Hashtable $setParams)"
        $newTask = New-MgPlannerTask @setParams
    }
    elseif ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Present')
    {
        $taskId = $setParams.TaskId
        $setParams.Remove('TaskId') | Out-Null
        $details = $setParams.Details
        $setParams.Remove('Details') | Out-Null
        $setParams.Remove('Verbose') | Out-Null

        # Fix Casing
        $setParams.Add('assignments', $setParams.Assignments)
        $setParams.Remove('Assignments') | Out-Null

        $setParams.Add('appliedCategories', $setParams.AppliedCategories)
        $setParams.Remove('AppliedCategories') | Out-Null

        $setParams.Add('title', $setParams.Title)
        $setParams.Remove('Title') | Out-Null

        $setParams.Add('bucketId', $setParams.BucketId)
        $setParams.Remove('BucketId') | Out-Null

        $setParams.Add('dueDateTime', [DateTime]::Parse($setParams.DueDateTime).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffK'))
        $setParams.Remove('DueDateTime') | Out-Null

        $setParams.Add('percentComplete', $setParams.PercentComplete)
        $setParams.Remove('PercentComplete') | Out-Null

        $setParams.Remove('PlanId') | Out-Null

        $setParams.Add('priority', $setParams.Priority)
        $setParams.Remove('Priority') | Out-Null

        if ($null -ne $setParams.StartDateTime)
        {
            $setParams.Add('startDateTime', [DateTime]::Parse($setParams.StartDateTime).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffK'))
        }
        $setParams.Remove('StartDateTime') | Out-Null

        Write-Verbose -Message "Planner Task {$Title} already exists, but is not in the `
            Desired State. Updating it."
        $currentTask = Get-MgPlannerTask -PlannerTaskId $taskId
        $Headers = @{}
        $etag = $currentTask.AdditionalProperties.'@odata.etag'

        $Headers.Add('If-Match', $etag)
        $JSONDetails = (ConvertTo-Json $setParams)
        Write-Verbose -Message "Updating Task with:`r`n$JSONDetails"
        # Need to continue to rely on Invoke-MgGraphRequest
        Invoke-MgGraphRequest -Method PATCH `
            -Uri "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)v1.0/planner/tasks/$taskId" `
            -Headers $Headers `
            -Body $JSONDetails

        # Update Details
        $Headers = @{}
        $currentTaskDetails = Get-MgPlannerTaskDetail -PlannerTaskId $taskId
        $Headers.Add('If-Match', $currentTaskDetails.AdditionalProperties.'@odata.etag')
        $details.Remove('id') | Out-Null
        $JSONDetails = (ConvertTo-Json $details)
        Write-Verbose -Message "Updating Task's details with:`r`n$JSONDetails"
        Invoke-MgGraphRequest -Method PATCH `
            -Uri "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)v1.0/planner/tasks/$taskId/details" `
            -Headers $Headers `
            -Body $JSONDetails

        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Planner Task {$Title} exists, but is should not. `
            Removing it."
        Remove-MgPlannerTask -PlannerTaskId $setParams.TaskId
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
        $PlanId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Title,

        [Parameter()]
        [System.String[]]
        $AssignedUsers,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $Bucket,

        [Parameter()]
        [System.String]
        $TaskId,

        [Parameter()]
        [System.String]
        $StartDateTime,

        [Parameter()]
        [System.String]
        $DueDateTime,

        [Parameter()]
        [System.String[]]
        $Categories,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Attachments,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Checklist,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Uint32]
        $PercentComplete,

        [Parameter()]
        [ValidateRange(0, 10)]
        [System.UInt32]
        $Priority,

        [Parameter()]
        [System.String]
        $ConversationThreadId,

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $TenantId,

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

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters

        [array]$groups = Get-MgGroup -All -ErrorAction Stop -Filter $filter

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        Write-M365DSCHost -Message "`r`n" -DeferWrite
        foreach ($group in $groups)
        {
            Write-M365DSCHost -Message "    |---[$i/$($groups.Length)] $($group.DisplayName) - {$($group.Id)}"
            try
            {
                [Array]$plans = Get-MgGroupPlannerPlan -GroupId $group.Id -ErrorAction 'SilentlyContinue'

                $j = 1
                foreach ($plan in $plans)
                {
                    Write-M365DSCHost -Message "        |---[$j/$($plans.Length)] $($plan.Title)"

                    [Array]$tasks = Get-MgGroupPlannerPlanTask -GroupId $group.Id -PlannerPlanId $plan.Id -ErrorAction 'SilentlyContinue'
                    $Script:AppliedCategories = (Get-MgPlannerPlanDetail -PlannerPlanId $plan.Id).CategoryDescriptions

                    $k = 1
                    foreach ($task in $tasks)
                    {
                        if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                        {
                            $Global:M365DSCExportResourceInstancesCount++
                        }

                        Write-M365DSCHost -Message "            |---[$k/$($tasks.Length)] $($task.Title)" -DeferWrite
                        $currentDSCBlock = ''

                        $params = @{
                            TaskId                = $task.Id
                            PlanId                = $plan.Id
                            Title                 = $task.Title
                            Credential            = $Credential
                            ApplicationId         = $ApplicationId
                            TenantId              = $TenantId
                            CertificateThumbprint = $CertificateThumbprint
                            ApplicationSecret     = $ApplicationSecret
                            ManagedIdentity       = $ManagedIdentity.IsPresent
                        }

                        $result = Get-TargetResource @params

                        if ($result.AssignedUsers.Count -eq 0)
                        {
                            $result.Remove('AssignedUsers') | Out-Null
                        }

                        if ($result.Attachments)
                        {
                            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                                -ComplexObject $result.Attachments `
                                -CIMInstanceName 'PlannerTaskAttachment'
                            if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                            {
                                $result.Attachments = $complexTypeStringResult
                            }
                            else
                            {
                                $result.Remove('Attachments') | Out-Null
                            }
                        }

                        if ($result.Checklist)
                        {
                            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                                -ComplexObject $result.Checklist `
                                -CIMInstanceName 'PlannerTaskChecklistItem'
                            if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                            {
                                $result.Checklist = $complexTypeStringResult
                            }
                            else
                            {
                                $result.Remove('Checklist') | Out-Null
                            }
                        }

                        # Fix Notes which can have multiple lines
                        if (-not [System.String]::IsNullOrEmpty($result.Notes))
                        {
                            $result.Notes = $result.Notes.Replace('"', '``"')
                            $result.Notes = $result.Notes.Replace('&', "``&")
                        }

                        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                            -ConnectionMode $ConnectionMode `
                            -ModulePath $PSScriptRoot `
                            -Results $result `
                            -Credential $Credential `
                            -NoEscape @('Attachments', 'Checklist')

                        [void]$dscContent.Append($currentDSCBlock)
                        Save-M365DSCPartialExport -Content $currentDSCBlock `
                            -FileName $Global:PartialExportFileName
                        $k++
                        Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
                    }
                    $j++
                }
            }
            catch
            {
                Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

                New-M365DSCLogEntry -Message 'Error during Export:' `
                    -Exception $_ `
                    -Source $($MyInvocation.MyCommand.Source) `
                    -TenantId $TenantId `
                    -Credential $Credential
            }
            $i++
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

function Get-TaskCategoryNameByColor
{
    [CmdletBinding()]
    [OutputType([System.string])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $ColorName
    )
    switch ($ColorName)
    {
        'Pink'
        {
            return 'category1'
        }
        'Red'
        {
            return 'category2'
        }
        'Yellow'
        {
            return 'category3'
        }
        'Green'
        {
            return 'category4'
        }
        'Blue'
        {
            return 'category5'
        }
        'Purple'
        {
            return 'category6'
        }
        'Bronze'
        {
            return 'category7'
        }
        'Lime'
        {
            return 'category8'
        }
        'Aqua'
        {
            return 'category9'
        }
        'Gray'
        {
            return 'category10'
        }
        'Silver'
        {
            return 'category11'
        }
        'Brown'
        {
            return 'category12'
        }
        'Cranberry'
        {
            return 'category13'
        }
        'Orange'
        {
            return 'category14'
        }
        'Peach'
        {
            return 'category15'
        }
        'Marigold'
        {
            return 'category16'
        }
        'Light green'
        {
            return 'category17'
        }
        'Dark green'
        {
            return 'category18'
        }
        'Teal'
        {
            return 'category19'
        }
        'Light blue'
        {
            return 'category20'
        }
        'Dark blue'
        {
            return 'category21'
        }
        'Lavender'
        {
            return 'category22'
        }
        'Plum'
        {
            return 'category23'
        }
        'Light gray'
        {
            return 'category24'
        }
        'Dark gray'
        {
            return 'category25'
        }
    }
    return $null
}

function Get-TaskColorNameByCategory
{
    [CmdletBinding()]
    [OutputType([System.string])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $CategoryName
    )
    switch ($CategoryName)
    {
        'category1'
        {
            return 'Pink'
        }
        'category2'
        {
            return 'Red'
        }
        'category3'
        {
            return 'Yellow'
        }
        'category4'
        {
            return 'Green'
        }
        'category5'
        {
            return 'Blue'
        }
        'category6'
        {
            return 'Purple'
        }
        'category7'
        {
            return 'Bronze'
        }
        'category8'
        {
            return 'Lime'
        }
        'category9'
        {
            return 'Aqua'
        }
        'category10'
        {
            return 'Gray'
        }
        'category11'
        {
            return 'Silver'
        }
        'category12'
        {
            return 'Brown'
        }
        'category13'
        {
            return 'Cranberry'
        }
        'category14'
        {
            return 'Orange'
        }
        'category15'
        {
            return 'Peach'
        }
        'category16'
        {
            return 'Marigold'
        }
        'category17'
        {
            return 'Light green'
        }
        'category18'
        {
            return 'Dark green'
        }
        'category19'
        {
            return 'Teal'
        }
        'category20'
        {
            return 'Light blue'
        }
        'category21'
        {
            return 'Dark blue'
        }
        'category22'
        {
            return 'Lavender'
        }
        'category23'
        {
            return 'Plum'
        }
        'category24'
        {
            return 'Light gray'
        }
        'category25'
        {
            return 'Dark gray'
        }
    }
    return $null
}

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        PostProcessing = {
            param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
            if ([System.String]::IsNullOrEmpty($DesiredValues.Bucket) -and
                -not [System.String]::IsNullOrEmpty($CurrentValues.Bucket))
            {
                if (-not $ValuesToCheck.ContainsKey('Bucket'))
                {
                    $DesiredValues.Bucket = $null
                    $ValuesToCheck.Add('Bucket', $null)
                }
            }
            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
