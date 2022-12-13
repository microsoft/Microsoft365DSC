class PlannerTaskObject
{
    [string]$PlanId
    [string]$TaskId
    [string]$Title
    [string]$Notes
    [string]$BucketId
    [string]$ETag
    [string[]]$Assignments
    [System.Collections.Hashtable[]]$Attachments
    [System.Collections.Hashtable[]]$Checklist
    [string]$StartDateTime
    [string]$DueDateTime
    [string[]]$Categories
    [string]$CompletedDateTime
    [int]$PercentComplete
    [int]$Priority
    [string]$ConversationThreadId
    [string]$OrderHint

    [string]GetTaskCategoryNameByColor([string]$ColorName)
    {
        switch ($ColorName)
        {
            'Pink'
            { return 'category1'
            }
            'Red'
            { return 'category2'
            }
            'Yellow'
            { return 'category3'
            }
            'Green'
            { return 'category4'
            }
            'Blue'
            { return 'category5'
            }
            'Purple'
            { return 'category6'
            }
        }
        return $null
    }

    [string]GetTaskColorNameByCategory([string]$CategoryName)
    {
        switch ($CategoryName)
        {
            'category1'
            { return 'Pink'
            }
            'category2'
            { return 'Red'
            }
            'category3'
            { return 'Yellow'
            }
            'category4'
            { return 'Green'
            }
            'category5'
            { return 'Blue'
            }
            'category6'
            { return 'Purple'
            }
        }
        return $null
    }

    [void]PopulateById([System.Management.Automation.PSCredential]$Credential, [string]$TaskId)
    {
        $uri = "https://graph.microsoft.com/beta/planner/tasks/$TaskId"
        $taskResponse = Invoke-MSCloudLoginMicrosoftGraphAPI -Credential $Credential `
            -Uri $uri `
            -Method Get
        $taskDetailsResponse = Invoke-MSCloudLoginMicrosoftGraphAPI -Credential $Credential `
            -Uri ($uri + '/details') `
            -Method Get

        #region Assignments
        $assignmentsValue = @()
        if ($null -ne $taskResponse.assignments)
        {
            $allAssignments = $taskResponse.assignments | Get-Member | Where-Object -FilterScript {
                $_.MemberType -eq 'NoteProperty'
            }
            foreach ($assignment in $allAssignments)
            {
                $assignmentsValue += $assignment.Name
            }
        }
        #endregion

        #region Attachments
        $attachmentsValue = @()
        if ($null -ne $taskDetailsResponse.references)
        {
            $allAttachments = $taskDetailsResponse.references | Get-Member | Where-Object -FilterScript {
                $_.MemberType -eq 'NoteProperty'
            }
            foreach ($attachment in $allAttachments)
            {
                $hashEntry = @{
                    Uri   = $attachment.Name
                    Alias = $taskDetailsResponse.references.($attachment.Name).alias
                    Type  = $taskDetailsResponse.references.($attachment.Name).type
                }
                $attachmentsValue += $hashEntry
            }
        }
        #endregion

        #region Categories
        $categoriesValue = @()
        if ($null -ne $taskResponse.appliedCategories)
        {
            $allCategories = $taskResponse.appliedCategories | Get-Member | Where-Object -FilterScript {
                $_.MemberType -eq 'NoteProperty'
            }
            foreach ($category in $allCategories)
            {
                $categoriesValue += $this.GetTaskColorNameByCategory($category.Name)
            }
        }
        #endregion

        #region Checklist
        $checklistValue = @()
        if ($null -ne $taskDetailsResponse.checklist)
        {
            $allCheckListItems = $taskDetailsResponse.checklist | Get-Member | Where-Object -FilterScript {
                $_.MemberType -eq 'NoteProperty'
            }
            foreach ($checkListItem in $allCheckListItems)
            {
                $hashEntry = @{
                    Title     = $taskDetailsResponse.checklist.($checkListItem.Name).title
                    Completed = [bool]$taskDetailsResponse.checklist.($checkListItem.Name).isChecked
                }
                $checklistValue += $hashEntry
            }
        }
        #endregion
        $this.Etag = $taskResponse.'@odata.etag'
        $this.Title = $taskResponse.title
        $this.StartDateTime = $taskResponse.startDateTime
        $this.ConversationThreadId = $taskResponse.conversationThreadId
        $this.DueDateTime = $taskResponse.dueDateTime
        $this.CompletedDateTime = $taskResponse.completedDateTime
        $this.PlanId = $taskResponse.planId
        $this.TaskId = $taskResponse.id
        $this.BucketId = $taskResponse.bucketId
        $this.Priority = $taskResponse.priority
        $this.Notes = $taskDetailsResponse.description
        $this.Assignments = $assignmentsValue
        $this.Attachments = $attachmentsValue
        $this.Categories = $categoriesValue
        $this.Checklist = $checklistValue
    }

    [string]ConvertToJSONTask()
    {
        $sb = [System.Text.StringBuilder]::New()
        $sb.Append('{') | Out-Null
        $sb.Append("`"planId`":`"$($this.PlanId)`"") | Out-Null
        $sb.Append(",`"title`":`"$($this.Title)`"") | Out-Null
        if (-not [System.String]::IsNullOrEmpty($this.BucketId))
        {
            $sb.Append(",`"bucketId`":`"$($this.BucketId)`"") | Out-Null
        }
        if (-not [System.String]::IsNullOrEmpty($this.Priority))
        {
            $sb.Append(",`"priority`": $($this.Priority.ToString())") | Out-Null
        }
        if (-not [System.String]::IsNullOrEmpty($this.StartDateTime))
        {
            $sb.Append(",`"startDateTime`":`"$($this.StartDateTime)`"") | Out-Null
        }
        if (-not [System.String]::IsNullOrEmpty($this.DueDateTime))
        {
            $sb.Append(",`"dueDateTime`":`"$($this.DueDateTime)`"") | Out-Null
        }
        if (-not [System.String]::IsNullOrEmpty($this.ConversationThreadId))
        {
            $sb.Append(",`"conversationThreadId`":`"$($this.ConversationThreadId)`"") | Out-Null
        }
        if ($this.Assignments.Length -gt 0)
        {
            $sb.Append(",`"assignments`": {") | Out-Null
            $id = 1
            foreach ($assignment in $this.Assignments)
            {
                if ($id -gt 1)
                {
                    $sb.Append(',') | Out-Null
                }
                $sb.Append("`"$assignment`":{") | Out-Null
                $sb.Append("`"@odata.type`":`"#microsoft.graph.plannerAssignment`"") | Out-Null

                if ([System.String]::IsNullOrEmpty($this.OrderHint))
                {
                    $sb.Append(",`"orderHint`": `" !`"")
                }
                $sb.Append('}') | Out-Null
                $id++
            }
            $sb.Append('}') | Out-Null
        }
        if ($this.Categories.Length -gt 0)
        {
            $sb.Append(",`"appliedCategories`": {") | Out-Null
            $id = 1
            foreach ($category in $this.Categories)
            {
                if ($id -gt 1)
                {
                    $sb.Append(',') | Out-Null
                }
                $categoryName = $this.GetTaskCategoryNameByColor($category)
                $sb.Append("`"$categoryName`":true") | Out-Null
                $id++
            }
            $sb.Append('}') | Out-Null
        }
        $sb.Append('}') | Out-Null
        return $sb.ToString()
    }

    [string]ConvertToJSONTaskDetails()
    {
        $sb = [System.Text.StringBuilder]::New()
        $sb.Append('{') | Out-Null
        $sb.Append("`"description`":`"$($this.Notes)`"") | Out-Null

        if ($this.Attachments.Length -gt 0)
        {
            $sb.Append(",`"references`": {") | Out-Null
            $i = 1
            foreach ($attachment in $this.Attachments)
            {
                if ($i -gt 1)
                {
                    $sb.Append(',') | Out-Null
                }
                $sb.Append("`"$($attachment.Uri)`": {") | Out-Null
                $sb.Append("`"@odata.type`": `"#microsoft.graph.plannerExternalReference`",") | Out-Null
                $sb.Append("`"alias`":`"$($attachment.Alias)`",") | Out-Null
                $sb.Append("`"type`":`"$($attachment.Type)`"") | Out-Null
                $sb.Append('}') | Out-Null
                $i++
            }
            $sb.Append('}') | Out-Null
        }

        if ($this.Checklist.Length -gt 0)
        {
            $sb.Append(",`"checklist`": {") | Out-Null
            $i = 1
            foreach ($checkListItem in $this.Checklist)
            {
                if ($i -gt 1)
                {
                    $sb.Append(',') | Out-Null
                }
                $sb.Append("`"$((New-Guid).ToString())`": {") | Out-Null
                $sb.Append("`"@odata.type`": `"#microsoft.graph.plannerChecklistItem`",") | Out-Null
                $sb.Append("`"title`":`"$($checkListItem.Title)`",") | Out-Null
                $sb.Append("`"isChecked`": $($checkListItem.Completed.ToString().Replace('`$', '').ToLower())") | Out-Null
                $sb.Append('}') | Out-Null
                $i++
            }
            $sb.Append('}') | Out-Null
        }
        $sb.Append('}') | Out-Null
        return $sb.ToString()
    }

    [void]Create([System.Management.Automation.PSCredential]$Credential)
    {
        $uri = 'https://graph.microsoft.com/v1.0/planner/tasks'
        $body = $this.ConvertToJSONTask()
        $taskResponse = Invoke-MSCloudLoginMicrosoftGraphAPI -Credential $Credential `
            -Uri $uri `
            -Method 'POST' `
            -Body $body
        $this.TaskId = $taskResponse.id
        Write-Verbose -Message "New Planner Task created with Id {$($taskResponse.id)}"
        $this.UpdateDetails($Credential)
    }

    [void]Update([System.Management.Automation.PSCredential]$Credential)
    {
        $uri = "https://graph.microsoft.com/v1.0/planner/tasks/$($this.TaskId)"
        $body = $this.ConvertToJSONTask()
        $Headers = @{}
        $Headers.Add('If-Match', $this.ETag)
        $taskResponse = Invoke-MSCloudLoginMicrosoftGraphAPI -Credential $Credential `
            -Uri $uri `
            -Method 'PATCH' `
            -Body $body `
            -Headers $Headers
    }

    [void]UpdateDetails([System.Management.Automation.PSCredential]$Credential)
    {
        $uri = "https://graph.microsoft.com/v1.0/planner/tasks/$($this.TaskId)/details"
        $body = $this.ConvertToJSONTaskDetails()

        # Get ETag for the details
        $currentTaskDetails = Invoke-MSCloudLoginMicrosoftGraphAPI -Credential $Credential `
            -Uri $uri `
            -Method 'GET'
        $Headers = @{}
        $Headers.Add('If-Match', $currentTaskDetails.'@odata.etag')
        $taskResponse = Invoke-MSCloudLoginMicrosoftGraphAPI -Credential $Credential `
            -Uri $uri `
            -Method 'PATCH' `
            -Body $body `
            -Headers $Headers
    }

    [void]Delete([System.Management.Automation.PSCredential]$Credential, [string]$TaskId)
    {
        $VerbosePreference = 'Continue'
        Write-Verbose -Message "Initiating the Deletion of Task {$TaskId}"
        $uri = "https://graph.microsoft.com/v1.0/planner/tasks/$TaskId"

        # Get ETag for the details
        $currentTaskDetails = Invoke-MSCloudLoginMicrosoftGraphAPI -Credential $Credential `
            -Uri $uri `
            -Method 'GET'
        $Headers = @{}
        $Headers.Add('If-Match', $currentTaskDetails.'@odata.etag')
        Write-Verbose -Message "Retrieved Task's ETag {$($currentTaskDetails.'@odata.etag')}"
        $taskResponse = Invoke-MSCloudLoginMicrosoftGraphAPI -Credential $Credential `
            -Uri $uri `
            -Method 'DELETE' `
            -Headers $Headers
    }
}
