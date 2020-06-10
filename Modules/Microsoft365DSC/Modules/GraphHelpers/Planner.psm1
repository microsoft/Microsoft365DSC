class PlannerTaskObject
{
    [string]$PlanId
    [string]$TaskId
    [string]$Title
    [string]$Notes
    [string]$BucketId
    [string]$ETag
    [string[]]$Assignments
    [string]$StartDateTime
    [string]$DueDateTime
    [string]$CompletedDateTime
    [int]$PercentComplete
    [int]$Priority
    [string]$OrderHint

    [void]PopulateById([System.Management.Automation.PSCredential]$GlobalAdminAccount, [string]$TaskId)
    {
        $uri = "https://graph.microsoft.com/beta/planner/tasks/$TaskId"
        $taskResponse = Invoke-MSCloudLoginMicrosoftGraphAPI -CloudCredential $GlobalAdminAccount `
            -Uri $uri `
            -Method Get
        $taskDetailsResponse = Invoke-MSCloudLoginMicrosoftGraphAPI -CloudCredential $GlobalAdminAccount `
            -Uri ($uri + "/details") `
            -Method Get

        #region Assignments
        $allAssignments = $taskResponse.assignments | gm | Where-Object -FilterScript{$_.MemberType -eq 'NoteProperty'}
        $assignmentsValue = @()
        foreach ($assignment in $allAssignments)
        {
            $assignmentsValue += $assignment.Name
        }
        #endregion
        $this.Etag              = $taskResponse.'@odata.etag'
        $this.Title             = $taskResponse.Title
        $this.StartDateTime     = $taskResponse.startDateTime
        $this.DueDateTime       = $taskResponse.dueDateTime
        $this.CompletedDateTime = $taskResponse.completedDateTime
        $this.PlanId            = $taskResponse.planId
        $this.TaskId            = $taskResponse.id
        $this.BucketId          = $taskResponse.bucketId
        $this.Priority          = $taskResponse.priority
        $this.Notes             = $taskDetailsResponse.description
        $this.Assignments       = $assignmentsValue
    }
    [string]ConvertToJSONTask()
    {
        $sb = [System.Text.StringBuilder]::New()
        $sb.Append("{") | Out-Null
        $sb.Append("`"planId`":`"$($this.PlanId)`"") | Out-Null
        $sb.Append(",`"title`":`"$($this.Title)`"") | Out-Null
        if (-not [System.String]::IsNullOrEmpty($this.BucketId))
        {
            $sb.Append(",`"bucketId`":`"$($this.BucketId)`"") | Out-Null
        }
        if (-not [System.String]::IsNullOrEmpty($this.Priority))
        {
            $sb.Append(",`"priority`":`"$($this.Priority)`"") | Out-Null
        }
        if (-not [System.String]::IsNullOrEmpty($this.StartDateTime))
        {
            $sb.Append(",`"startDateTime`":`"$($this.StartDateTime)`"") | Out-Null
        }
        if (-not [System.String]::IsNullOrEmpty($this.DueDateTime))
        {
            $sb.Append(",`"dueDateTime`":`"$($this.DueDateTime)`"") | Out-Null
        }
        if ($this.Assignments.Length -gt 0)
        {
            $sb.Append(",`"assignments`": {") | Out-Null
            $id = 1
            foreach ($assignment in $this.Assignments)
            {
                if ($id -gt 1)
                {
                    $sb.Append(",") | Out-Null
                }
                $sb.Append("`"$assignment`":{") | Out-Null
                $sb.Append("`"@odata.type`":`"#microsoft.graph.plannerAssignment`"") | Out-Null

                if ([System.String]::IsNullOrEmpty($this.OrderHint))
                {
                    $sb.Append(",`"orderHint`": `" !`"")
                }
                $sb.Append("}") | Out-Null
                $id++
            }
            $sb.Append("}") | Out-Null
        }
        $sb.Append("}") | Out-Null
        return $sb.ToString()
    }

    [string]ConvertToJSONTaskDetails()
    {
        $sb = [System.Text.StringBuilder]::New()
        $sb.Append("{") | Out-Null
        $sb.Append("`"description`":`"$($this.Notes)`"") | Out-Null
        $sb.Append("}") | Out-Null
        return $sb.ToString()
    }

    [void]Create([System.Management.Automation.PSCredential]$GlobalAdminAccount)
    {
        $uri = "https://graph.microsoft.com/v1.0/planner/tasks"
        $body = $this.ConvertToJSONTask()
        $taskResponse = Invoke-MSCloudLoginMicrosoftGraphAPI -CloudCredential $GlobalAdminAccount `
            -Uri $uri `
            -Method "POST" `
            -Body $body
        $this.TaskId = $taskResponse.id
        Write-Verbose -Message "New Planner Task created with Id {$($taskResponse.id)}"
        $this.UpdateDetails($GlobalAdminAccount)
    }

    [void]Update([System.Management.Automation.PSCredential]$GlobalAdminAccount)
    {
        $uri = "https://graph.microsoft.com/v1.0/planner/tasks/$($this.TaskId)"
        $body = $this.ConvertToJSONTask()
        $Headers = @{}
        $Headers.Add("If-Match", $this.ETag)
        $taskResponse = Invoke-MSCloudLoginMicrosoftGraphAPI -CloudCredential $GlobalAdminAccount `
            -Uri $uri `
            -Method "PATCH" `
            -Body $body `
            -Headers $Headers
    }

    [void]UpdateDetails([System.Management.Automation.PSCredential]$GlobalAdminAccount)
    {
        $uri = "https://graph.microsoft.com/v1.0/planner/tasks/$($this.TaskId)/details"
        $body = $this.ConvertToJSONTaskDetails()

        # Get ETag for the details
        $currentTaskDetails = Invoke-MSCloudLoginMicrosoftGraphAPI -CloudCredential $GlobalAdminAccount `
            -Uri $uri `
            -Method "GET"
        $Headers = @{}
        $Headers.Add("If-Match", $currentTaskDetails.'@odata.etag')
        $taskResponse = Invoke-MSCloudLoginMicrosoftGraphAPI -CloudCredential $GlobalAdminAccount `
            -Uri $uri `
            -Method "PATCH" `
            -Body $body `
            -Headers $Headers
    }

    [void]Delete([System.Management.Automation.PSCredential]$GlobalAdminAccount, [string]$TaskId)
    {
        $VerbosePreference = 'Continue'
        Write-Verbose -Message "Initiating the Deletion of Task {$TaskId}"
        $uri = "https://graph.microsoft.com/v1.0/planner/tasks/$TaskId"

        # Get ETag for the details
        $currentTaskDetails = Invoke-MSCloudLoginMicrosoftGraphAPI -CloudCredential $GlobalAdminAccount `
            -Uri $uri `
            -Method "GET"
        $Headers = @{}
        $Headers.Add("If-Match", $currentTaskDetails.'@odata.etag')
        Write-Verbose -Message "Retrieved Task's ETag {$($currentTaskDetails.'@odata.etag')}"
        $taskResponse = Invoke-MSCloudLoginMicrosoftGraphAPI -CloudCredential $GlobalAdminAccount `
            -Uri $uri `
            -Method "DELETE" `
            -Headers $Headers
    }
}
