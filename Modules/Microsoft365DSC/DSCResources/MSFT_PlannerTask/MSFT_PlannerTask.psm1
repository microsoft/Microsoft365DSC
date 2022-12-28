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
        [ValidateSet('Pink', 'Red', 'Yellow', 'Green', 'Blue', 'Purple')]
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
        [System.String]
        [ValidateSet('Present', 'Absent')]
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

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters

        # If no TaskId were passed, automatically assume that this is a new task;
        if ([System.String]::IsNullOrEmpty($TaskId))
        {
            return $nullReturn
        }

        try
        {
            [PlannerTaskObject].GetType() | Out-Null
        }
        catch
        {
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath '../../Modules/GraphHelpers/PlannerTaskObject.psm1'
            $usingScriptBody = "using module '$ModulePath'"
            $usingScript = [ScriptBlock]::Create($usingScriptBody)
            . $usingScript
        }
        $task = [PlannerTaskObject]::new()
        Write-Verbose -Message "Populating task {$taskId} from the Get method"
        $task.PopulateById($Credential, $TaskId)

        if ($null -eq $task)
        {
            return $nullReturn
        }
        else
        {
            $NotesValue = $task.Notes

            #region Task Assignment
            if ($task.Assignments.Length -gt 0)
            {
                $assignedValues = @()
                foreach ($assignee in $task.Assignments)
                {
                    $user = Get-MgUser -UserId $assignee
                    $assignedValues += $user.UserPrincipalName
                }
            }
            #endregion

            #region Task Categories
            $categoryValues = @()
            foreach ($category in $task.Categories)
            {
                $categoryValues += $category
            }
            #endregion

            $StartDateTimeValue = $null
            if ($null -ne $task.StartDateTime)
            {
                $StartDateTimeValue = $task.StartDateTime
            }
            $DueDateTimeValue = $null
            if ($null -ne $task.DueDateTime)
            {
                $DueDateTimeValue = $task.DueDateTime
            }
            $results = @{
                PlanId                = $PlanId
                Title                 = $Title
                AssignedUsers         = $assignedValues
                TaskId                = $task.TaskId
                Categories            = $categoryValues
                Attachments           = $task.Attachments
                Checklist             = $task.Checklist
                Bucket                = $task.BucketId
                Priority              = $task.Priority
                ConversationThreadId  = $task.ConversationThreadId
                PercentComplete       = $task.PercentComplete
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
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $results)"
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

        return $nullReturn
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
        [ValidateSet('Pink', 'Red', 'Yellow', 'Green', 'Blue', 'Purple')]
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
        [System.String]
        [ValidateSet('Present', 'Absent')]
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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    $currentValues = Get-TargetResource @PSBoundParameters

    try
    {
        [PlannerTaskObject].GetType() | Out-Null
    }
    catch
    {
        $ModulePath = Join-Path -Path $PSScriptRoot `
            -ChildPath '../../Modules/GraphHelpers/PlannerTaskObject.psm1'
        $usingScriptBody = "using module '$ModulePath'"
        $usingScript = [ScriptBlock]::Create($usingScriptBody)
        . $usingScript
    }
    $task = [PlannerTaskObject]::new()

    if (-not [System.String]::IsNullOrEmpty($TaskId))
    {
        Write-Verbose -Message "Populating Task {$TaskId} from the Set method"
        $task.PopulateById($Credential, $TaskId)
    }

    $task.BucketId = $Bucket
    $task.Title = $Title
    $task.PlanId = $PlanId
    $task.StartDateTime = $StartDateTime
    $task.DueDateTime = $DueDateTime
    $task.Priority = $Priority
    $task.Notes = $Notes
    $task.ConversationThreadId = $ConversationThreadId

    #region Assignments
    if ($AssignedUsers.Length -gt 0)
    {
        $AssignmentsValue = @()
        foreach ($userName in $AssignedUsers)
        {
            $user = Get-MgUser -UserId $userName
            if ($null -ne $user)
            {
                $AssignmentsValue += $user.Id
            }
        }
        $task.Assignments = $AssignmentsValue
    }
    #endregion

    #region Attachments
    if ($Attachments.Length -gt 0)
    {
        $attachmentsArray = @()
        foreach ($attachment in $Attachments)
        {
            $attachmentsValue = @{
                Uri   = $attachment.Uri
                Alias = $attachment.Alias
                Type  = $attachment.Type
            }
            $attachmentsArray += $AttachmentsValue
        }
        $task.Attachments = $attachmentsArray
    }
    #endregion

    #region Categories
    if ($Categories.Length -gt 0)
    {
        $CategoriesValue = @()
        foreach ($category in $Categories)
        {
            $CategoriesValue += $category
        }
        $task.Categories = $CategoriesValue
    }
    #endregion

    #region Checklist
    if ($Checklist.Length -gt 0)
    {
        $checklistArray = @()
        foreach ($checkListItem in $Checklist)
        {
            $checklistItemValue = @{
                Title     = $checkListItem.Title
                Completed = $checkListItem.Completed
            }
            $checklistArray += $checklistItemValue
        }
        $task.Checklist = $checklistArray
    }
    #endregion

    if ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Planner Task {$Title} doesn't already exist. Creating it."
        $task.Create($Credential)
    }
    elseif ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Planner Task {$Title} already exists, but is not in the `
            Desired State. Updating it."
        $task.Update($Credential)
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Planner Task {$Title} exists, but is should not. `
            Removing it."
        $task.Delete($Credential, $TaskId)
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
        [ValidateSet('Pink', 'Red', 'Yellow', 'Green', 'Blue', 'Purple')]
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
        [System.String]
        [ValidateSet('Present', 'Absent')]
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

    Write-Verbose -Message "Testing configuration of Planner Task {$Title}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

    # If the Task is currently assigned to a bucket and the Bucket property is null,
    # assume that we are trying to remove the given task from the bucket and therefore
    # treat this as a drift.
    if ([System.String]::IsNullOrEmpty($Bucket) -and `
            -not [System.String]::IsNullOrEmpty($CurrentValues.Bucket))
    {
        $TestResult = $false
    }
    else
    {
        $ValuesToCheck.Remove('Checklist') | Out-Null
        if (-not (Test-M365DSCPlannerTaskCheckListValues -CurrentValues $CurrentValues `
                    -DesiredValues $ValuesToCheck))
        {
            return $false
        }
        $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

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

        [array]$groups = Get-MgGroup -All:$true

        $i = 1
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($group in $groups)
        {
            Write-Host "    |---[$i/$($groups.Length)] $($group.DisplayName) - {$($group.Id)}"
            try
            {
                [Array]$plans = Get-MgGroupPlannerPlan -GroupId $group.Id -ErrorAction 'SilentlyContinue'

                $j = 1
                foreach ($plan in $plans)
                {
                    Write-Host "        |---[$j/$($plans.Length)] $($plan.Title)"

                    [Array]$tasks = Get-MgGroupPlannerPlanTask -GroupId $group.Id -PlannerPlanId $plan.Id -ErrorAction 'SilentlyContinue'

                    $k = 1
                    foreach ($task in $tasks)
                    {
                        Write-Host "            |---[$k/$($tasks.Length)] $($task.Title)" -NoNewline
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
                        $result = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                            -Results $Result
                        if ($result.Attachments.Length -gt 0)
                        {
                            $result.Attachments = [Array](Convert-M365DSCPlannerTaskAssignmentToCIMArray `
                                    -Attachments $result.Attachments)
                        }
                        else
                        {
                            $result.Remove('Attachments') | Out-Null
                        }

                        if ($result.Checklist.Length -gt 0)
                        {
                            $result.Checklist = [Array](Convert-M365DSCPlannerTaskChecklistToCIMArray `
                                    -Checklist $result.Checklist)
                        }
                        else
                        {
                            $result.Remove('Checklist') | Out-Null
                        }

                        # Fix Notes which can have multiple lines
                        $result.Notes = $result.Notes.Replace('"', '``"')
                        $result.Notes = $result.Notes.Replace('&', "``&")

                        $currentDSCBlock += '        PlannerTask ' + (New-Guid).ToString() + "`r`n"
                        $currentDSCBlock += "        {`r`n"
                        $content = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
                        $content = Convert-DSCStringParamToVariable -DSCBlock $content `
                            -ParameterName 'Credential'
                        if ($result.Attachments.Length -gt 0)
                        {
                            $content = Convert-DSCStringParamToVariable -DSCBlock $content `
                                -ParameterName 'Attachments' `
                                -IsCIMArray $true
                        }
                        if ($result.Checklist.Length -gt 0)
                        {
                            $content = Convert-DSCStringParamToVariable -DSCBlock $content `
                                -ParameterName 'Checklist' `
                                -IsCIMArray $true
                        }
                        $currentDSCBlock += $content
                        $currentDSCBlock += "        }`r`n"
                        $dscContent += $currentDSCBlock

                        Save-M365DSCPartialExport -Content $currentDSCBlock `
                            -FileName $Global:PartialExportFileName
                        $k++
                        Write-Host $Global:M365DSCEmojiGreenCheckmark
                    }
                    $j++
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
            }
            $i++
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

function Test-M365DSCPlannerTaskCheckListValues
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param(
        [Parameter(Mandatory = $true)]
        [System.Collections.HashTable[]]
        $CurrentValues,

        [Parameter(Mandatory = $true)]
        [System.Collections.HashTable[]]
        $DesiredValues
    )

    # Check in CurrentValues for item that don't exist or are different in
    # the DesiredValues;
    foreach ($checklistItem in $CurrentValues)
    {
        $equivalentItemInDesired = $DesiredValues | Where-Object -FilterScript { $_.Title -eq $checklistItem.Title }
        if ($null -eq $equivalentItemInDesired -or `
                $checklistItem.Completed -ne $equivalentItemInDesired.Completed)
        {
            return $false
        }
    }

    # Do the opposite, check in DesiredValue for item that don't exist or are different in
    # the CurrentValues;
    foreach ($checklistItem in $DesiredValues)
    {
        $equivalentItemInCurrent = $CurrentValues | Where-Object -FilterScript { $_.Title -eq $checklistItem.Title }
        if ($null -eq $equivalentItemInCurrent -or `
                $checklistItem.Completed -ne $equivalentItemInCurrent.Completed)
        {
            return $false
        }
    }
    return $true
}

function Convert-M365DSCPlannerTaskAssignmentToCIMArray
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    Param(
        [Parameter(Mandatory = $true)]
        [System.Collections.HashTable[]]
        $Attachments
    )

    $result = @()
    foreach ($attachment in $Attachments)
    {
        $stringContent = "MSFT_PlannerTaskAttachment`r`n            {`r`n"
        $stringContent += "                Uri = '$($attachment.Uri)'`r`n"
        $stringContent += "                Alias = '$($attachment.Alias.Replace("'", "''"))'`r`n"
        $stringContent += "                Type = '$($attachment.Type)'`r`n"
        $StringContent += "            }`r`n"
        $result += $stringContent
    }
    return $result
}

function Convert-M365DSCPlannerTaskChecklistToCIMArray
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    Param(
        [Parameter(Mandatory = $true)]
        [System.Collections.HashTable[]]
        $Checklist
    )

    $result = @()
    foreach ($checklistItem in $Checklist)
    {
        $stringContent = "MSFT_PlannerTaskChecklistItem`r`n            {`r`n"
        $stringContent += "                Title = '$($checklistItem.Title.Replace("'", "''"))'`r`n"
        $stringContent += "                Completed = `$$($checklistItem.Completed.ToString())`r`n"
        $StringContent += "            }`r`n"
        $result += $stringContent
    }
    return $result
}

function Get-M365DSCPlannerPlansFromGroup
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable[]])]
    Param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupId,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    $results = @()
    $uri = "https://graph.microsoft.com/v1.0/groups/$GroupId/planner/plans"
    $taskResponse = Invoke-MSCloudLoginMicrosoftGraphAPI -CloudCredential $Credential `
        -Uri $uri `
        -Method Get
    foreach ($plan in $taskResponse.value)
    {
        $results += @{
            Id    = $plan.id
            Title = $plan.title
        }
    }
    return $results
}

function Get-M365DSCPlannerTasksFromPlan
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable[]])]
    Param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $PlanId,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    $results = @()
    $uri = "https://graph.microsoft.com/v1.0/planner/plans/$PlanId/tasks"
    $taskResponse = Invoke-MSCloudLoginMicrosoftGraphAPI -Credential $Credential `
        -Uri $uri `
        -Method Get
    foreach ($task in $taskResponse.value)
    {
        $results += @{
            Title = $task.title
            Id    = $task.id
        }
    }
    return $results
}

Export-ModuleMember -Function *-TargetResource
