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
        [ValidateSet("Pink", "Red", "Yellow", "Green", "Blue", "Purple")]
        [System.String[]]
        $Categories,

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
        [ValidateSet("Present", "Absent")]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId
    )
    Write-Verbose -Message "Getting configuration of Planner Task {$Title}"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = @{
        PlanId                = $PlanId
        Title                 = $Title
        Ensure                = "Absent"
        ApplicationId         = $ApplicationId
        GlobalAdminAccount    = $GlobalAdminAccount
    }

    # If no TaskId were passed, automatically assume that this is a new task;
    if ([System.String]::IsNullOrEmpty($TaskId))
    {
        return $nullReturn
    }

    $PlannerModulePath = Join-Path -Path $PSScriptRoot `
        -ChildPath "../../Modules/GraphHelpers/Planner.psm1"
    $usingScriptBody = "using module $PlannerModulePath"
    $usingScript = [ScriptBlock]::Create($usingScriptBody)
    . $usingScript
    $task = [PlannerTaskObject]::new()
    Write-Verbose -Message "Populating task {$taskId} from the Get method"
    $task.PopulateById($GlobalAdminAccount, $TaskId)

    if ($null -eq $task)
    {
        return $nullReturn
    }
    else
    {
        $BucketValue = $null
        if ($null -ne $task.BucketId)
        {
            # If the current task has a bucket id but the bucket property was not passed,
            # Simply return the Id of the bucket associated with the Task.
            $associatedBucket = Get-MGPlannerPlanBucket -PlannerPlanId $PlanId `
                    -ErrorAction 'SilentlyContinue' | Where-Object -FilterScript {$_.Id -eq $Bucket -or $_.Name -eq $Bucket}
            if ([System.String]::IsNullOrEmpty($Bucket) -or $null -eq $associatedBucket)
            {
                $BucketValue = $task.BucketId
            }
            else
            {
                $BucketValue = $Bucket
            }
        }

        $NotesValue = $task.Notes

        #region Task Assignment
        Test-MSCloudLogin -Platform AzureAD -CloudCredential $GlobalAdminAccount
        $assignedValues = @()
        foreach ($assignee in $task.Assignments)
        {
            $user = Get-AzureADUser -ObjectId $assignee
            $assignedValues += $user.UserPrincipalName
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
            TaskId                = $task.Id
            Bucket                = $BucketValue
            Priority              = $task.Priority
            PercentComplete       = $task.PercentComplete
            StartDateTime         = $StartDateTimeValue
            DueDateTime           = $DueDateTimeValue
            Notes                 = $NotesValue
            Ensure                = "Present"
            ApplicationId         = $ApplicationId
            GlobalAdminAccount    = $GlobalAdminAccount
        }
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $results)"
        return $results
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
        [ValidateSet("Pink", "Red", "Yellow", "Green", "Blue", "Purple")]
        [System.String[]]
        $Categories,

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
        [ValidateSet("Present", "Absent")]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId
    )
    Write-Verbose -Message "Setting configuration of Planner Task {$Title}"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Connect-Graph -Scopes "Group.ReadWrite.All" | Out-Null

    $currentValues = Get-TargetResource @PSBoundParameters

    $PlannerModulePath = Join-Path -Path $PSScriptRoot `
        -ChildPath "../../Modules/GraphHelpers/Planner.psm1"
    $usingScriptBody = "using module $PlannerModulePath"
    $usingScript = [ScriptBlock]::Create($usingScriptBody)
    . $usingScript
    $task = [PlannerTaskObject]::new()

    if (-not [System.String]::IsNullOrEmpty($TaskId))
    {
        Write-Verbose -Message "Populating Task {$TaskId} from the Set method"
        $task.PopulateById($GlobalAdminAccount, $TaskId)
    }

    #region BucketId
    if (-not [System.String]::IsNullOrEmpty($Bucket))
    {
        $associatedBucket = Get-MGPlannerPlanBucket -PlannerPlanId $PlanId `
                    -ErrorAction 'SilentlyContinue' | Where-Object -FilterScript {$_.Id -eq $Bucket -or $_.Name -eq $Bucket}
        $task.BucketId = $associatedBucket.Id
    }
    #endregion

    $task.Title         = $Title
    $task.PlanId        = $PlanId
    $task.StartDateTime = $StartDateTime
    $task.DueDateTime   = $DueDateTime
    $task.Priority      = $Priority
    $task.Notes         = $Notes

    #region Assignments
    if ($AssignedUsers.Length -gt 0)
    {
        Test-MSCloudLogin -Platform AzureAD -CloudCredential $GlobalAdminAccount
        $AssignmentsValue = @()
        foreach ($userName in $AssignedUsers)
        {
            $user = Get-AzureADUser -SearchString $userName
            if ($null -ne $user)
            {
                $AssignmentsValue += $user.ObjectId
            }
        }
        $task.Assignments = $AssignmentsValue
    }
    #endregion

    #region Categories
    if ($Categories.Length -gt 0)
    {
        $CategoriesValue = @()
        foreach ($category in $Categories)
        {
            $CategoriesValue += $task.GetTaskCategoryNameByColor($category)
        }
        $task.Categories = $CategoriesValue
    }
    #endregion
    if ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Planner Task {$Title} doesn't already exist. Creating it."
        $task.Create($GlobalAdminAccount)
    }
    elseif ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Planner Task {$Title} already exists, but is not in the `
            Desired State. Updating it."
        $task.Update($GlobalAdminAccount)
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Planner Task {$Title} exists, but is should not. `
            Removing it."
        $task.Delete($GlobalAdminAccount, $TaskId)
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
        [ValidateSet("Pink", "Red", "Yellow", "Green", "Blue", "Purple")]
        [System.String[]]
        $Categories,

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
        [ValidateSet("Present", "Absent")]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Testing configuration of Planner Task {$Title}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null

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
        $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId
    )
    $InformationPreference = 'Continue'

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' `
        -InboundParameters $PSBoundParameters

    [array]$groups = Get-AzureADGroup -All:$true

    $ConnectionMode = Connect-Graph -Scopes "Group.ReadWrite.All"
    $i = 1
    $content = ''
    foreach ($group in $groups)
    {
        Write-Information "    [$i/$($groups.Length)] $($group.DisplayName) - {$($group.ObjectID)}"
        try
        {
            [Array]$plans = Get-MgGroupPlannerPlan -GroupId $group.ObjectId -ErrorAction 'SilentlyContinue'

            $j = 1
            foreach ($plan in $plans)
            {
                Write-Information "        [$j/$($plans.Length)] $($plan.Title)"

                $filterClause = "planId eq '$($plan.Id)'"
                [Array]$tasks = Get-MGPlannerTask -Filter $filterClause
                $k = 1
                foreach ($task in $tasks)
                {
                    Write-Information "            [$k/$($tasks.Length)] $($task.Title)"
                    $params = @{
                        TaskId                = $task.Id
                        PlanId                = $plan.Id
                        Title                 = $task.Title
                        ApplicationId         = $ApplicationId
                        GlobalAdminAccount    = $GlobalAdminAccount
                    }

                    $result = Get-TargetResource @params

                    if ([System.String]::IsNullOrEmpty($result.ApplicationId))
                    {
                        $result.Remove("ApplicationId") | Out-Null
                    }
                    if ($result.AssignedUsers.Count -eq 0)
                    {
                        $result.Remove("AssignedUsers") | Out-Null
                    }
                    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
                    $content += "        PlannerTask " + (New-GUID).ToString() + "`r`n"
                    $content += "        {`r`n"
                    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
                    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
                    $content += "        }`r`n"
                    $k++
                }
                $j++
            }
            $i++
        }
        catch
        {
            $VerbosePreference = 'Continue'
            Write-Verbose -Message $_
        }
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
