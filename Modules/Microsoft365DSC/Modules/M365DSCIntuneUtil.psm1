function ConvertFrom-IntunePolicyAssignment
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable[]])]
    param (
        [Parameter(Mandatory = $true)]
        [Array]
        $Assignments,

        [Parameter()]
        [System.Boolean]
        $IncludeDeviceFilter = $true
    )

    if ($null -eq $Script:IntuneAssignmentFilters)
    {
        $Script:IntuneAssignmentFilters = Get-MgBetaDeviceManagementAssignmentFilter -All -ErrorAction SilentlyContinue | ForEach-Object {
            @{
                FilterId    = $_.Id
                DisplayName = $_.DisplayName
            }
        }
    }

    $assignmentResult = @()
    foreach ($assignment in $Assignments)
    {
        $hashAssignment = [ordered]@{}
        if ($null -ne $assignment.Target.'@odata.type')
        {
            $dataType = $assignment.Target.'@odata.type'
        }
        else
        {
            $dataType = $assignment.Target.AdditionalProperties.'@odata.type'
        }

        if ($null -ne $assignment.Target.groupId)
        {
            $groupId = $assignment.Target.groupId
        }
        else
        {
            $groupId = $assignment.Target.AdditionalProperties.groupId
        }

        if ($null -ne $assignment.Target.collectionId)
        {
            $collectionId = $assignment.Target.collectionId
        }
        else
        {
            $collectionId = $assignment.Target.AdditionalProperties.collectionId
        }

        $hashAssignment.Add('dataType', $dataType)
        if (-not [string]::IsNullOrEmpty($groupId))
        {
            $hashAssignment.Add('groupId', $groupId)

            $group = Get-MgGroup -GroupId ($groupId) -ErrorAction SilentlyContinue
            if ($null -ne $group)
            {
                $groupDisplayName = $group.DisplayName
            }
        }
        if ($dataType -eq '#microsoft.graph.allLicensedUsersAssignmentTarget')
        {
            $groupDisplayName = 'All users'
        }
        if ($dataType -eq '#microsoft.graph.allDevicesAssignmentTarget')
        {
            $groupDisplayName = 'All devices'
        }
        if ($null -ne $groupDisplayName)
        {
            $hashAssignment.Add('groupDisplayName', $groupDisplayName)
        }
        if (-not [string]::IsNullOrEmpty($collectionId))
        {
            $hashAssignment.Add('collectionId', $collectionId)
        }
        if ($IncludeDeviceFilter)
        {
            if ($null -ne $assignment.Target.DeviceAndAppManagementAssignmentFilterType)
            {
                $hashAssignment.Add('deviceAndAppManagementAssignmentFilterType', $assignment.Target.DeviceAndAppManagementAssignmentFilterType.ToString())
            }
            if ($null -ne $assignment.Target.DeviceAndAppManagementAssignmentFilterId)
            {
                $filterId = $assignment.Target.DeviceAndAppManagementAssignmentFilterId
                $hashAssignment.Add('deviceAndAppManagementAssignmentFilterId', $filterId)
                $hashAssignment.Add('deviceAndAppManagementAssignmentFilterDisplayName', (($Script:IntuneAssignmentFilters | Where-Object -FilterScript { $_.FilterId -eq $filterId }).DisplayName))
            }
        }

        $assignmentResult += $hashAssignment
    }

    return ,$assignmentResult
}

function ConvertTo-IntunePolicyAssignment
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param (
        [Parameter(Mandatory = $true)]
        [AllowNull()]
        $Assignments,

        [Parameter()]
        [System.Boolean]
        $IncludeDeviceFilter = $true
    )

    if ($null -eq $Script:IntuneAssignmentFilters)
    {
        $Script:IntuneAssignmentFilters = Get-MgBetaDeviceManagementAssignmentFilter -All -ErrorAction SilentlyContinue | ForEach-Object {
            @{
                FilterId    = $_.Id
                DisplayName = $_.DisplayName
            }
        }
    }

    if ($null -eq $Assignments)
    {
        return ,@()
    }

    $assignmentResult = @()
    foreach ($assignment in $Assignments)
    {
        $target = @{
            '@odata.type' = $assignment.dataType
        }
        if ($IncludeDeviceFilter)
        {
            if ($null -ne $assignment.DeviceAndAppManagementAssignmentFilterType -and $assignment.DeviceAndAppManagementAssignmentFilterType -ne 'none')
            {
                $filter = $Script:IntuneAssignmentFilters | Where-Object -FilterScript { $_.FilterId -eq $assignment.DeviceAndAppManagementAssignmentFilterId }
                if ($null -eq $filter)
                {
                    $filter = $Script:IntuneAssignmentFilters | Where-Object -FilterScript { $_.DisplayName -eq $assignment.DeviceAndAppManagementAssignmentFilterDisplayName }
                    if ($null -eq $filter)
                    {
                        Write-Warning -Message "Assignment filter with DisplayName {$($assignment.DeviceAndAppManagementAssignmentFilterDisplayName)} not found in the directory. Please update your DSC resource extract with the correct filterId or filterDisplayName."
                    }
                }

                if ($null -ne $filter)
                {
                    $target.Add('deviceAndAppManagementAssignmentFilterType', $assignment.DeviceAndAppManagementAssignmentFilterType)
                    $target.Add('deviceAndAppManagementAssignmentFilterId', $filter.FilterId)
                }
            }
        }
        if ($assignment.dataType -like '*CollectionAssignmentTarget')
        {
            $target.Add('collectionId', $assignment.collectionId)
        }
        elseif ($assignment.dataType -like '*GroupAssignmentTarget')
        {
            $group = $null
            if (-not [System.String]::IsNullOrEmpty($assignment.groupId))
            {
                $group = Get-MgGroup -GroupId ($assignment.groupId) -ErrorAction SilentlyContinue
            }
            if ($null -eq $group -and -not [System.String]::IsNullOrEmpty($assignment.groupDisplayName))
            {
                $escapedName = $assignment.groupDisplayName -replace "'", "''"
                $group = Get-MgGroup -Filter "DisplayName eq '$escapedName'" -All -ErrorAction SilentlyContinue
                if ($null -eq $group)
                {
                    Write-Warning "Skipping assignment: groupDisplayName '{$($assignment.groupDisplayName)}' not found."
                    $target = $null
                }
                elseif ($group.Count -gt 1)
                {
                    Write-Warning "Skipping assignment: groupDisplayName '{$($assignment.groupDisplayName)}' is not unique."
                    $target = $null
                }
            }
            # If group found, add its ID
            if ($null -ne $group)
            {
                $target.Add('groupId', $group.Id)
            }
            elseif ($null -eq $group -and [System.String]::IsNullOrEmpty($assignment.groupDisplayName))
            {
                Write-Warning 'Skipping assignment: missing both groupId and groupDisplayName.'
                $target = $null
            }
        }

        if ($target)
        {
            $assignmentResult += @{ target = $target }
        }
    }

    return ,$assignmentResult
}

function ConvertFrom-IntuneMobileAppAssignment
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable[]])]
    param (
        [Parameter(Mandatory = $true)]
        [Array]
        $Assignments,

        [Parameter()]
        [System.Boolean]
        $IncludeDeviceFilter = $true
    )

    if ($null -eq $Script:IntuneAssignmentFilters)
    {
        $Script:IntuneAssignmentFilters = Get-MgBetaDeviceManagementAssignmentFilter -All -ErrorAction SilentlyContinue | ForEach-Object {
            @{
                FilterId    = $_.Id
                DisplayName = $_.DisplayName
            }
        }
    }

    $assignmentResult = @()
    foreach ($assignment in $Assignments)
    {
        $hashAssignment = @{}
        if ($null -ne $assignment.Target.'@odata.type')
        {
            $dataType = $assignment.Target.'@odata.type'
        }
        else
        {
            $dataType = $assignment.Target.AdditionalProperties.'@odata.type'
        }

        if ($null -ne $assignment.Target.groupId)
        {
            $groupId = $assignment.Target.groupId
        }
        else
        {
            $groupId = $assignment.Target.AdditionalProperties.groupId
        }

        $hashAssignment.Add('dataType', $dataType)
        if (-not [string]::IsNullOrEmpty($groupId))
        {
            $hashAssignment.Add('groupId', $groupId)

            $group = Get-MgGroup -GroupId ($groupId) -ErrorAction SilentlyContinue
            if ($null -ne $group)
            {
                $groupDisplayName = $group.DisplayName
            }
        }

        if ($dataType -eq '#microsoft.graph.allLicensedUsersAssignmentTarget')
        {
            $groupDisplayName = 'All users'
        }
        if ($dataType -eq '#microsoft.graph.allDevicesAssignmentTarget')
        {
            $groupDisplayName = 'All devices'
        }
        if ($null -ne $groupDisplayName)
        {
            $hashAssignment.Add('groupDisplayName', $groupDisplayName)
        }

        $hashAssignment.Add('intent', $assignment.intent.ToString())

        if ($IncludeDeviceFilter)
        {
            if ($null -ne $assignment.Target.DeviceAndAppManagementAssignmentFilterType)
            {
                $hashAssignment.Add('deviceAndAppManagementAssignmentFilterType', $assignment.Target.DeviceAndAppManagementAssignmentFilterType.ToString())
            }
            if ($null -ne $assignment.Target.DeviceAndAppManagementAssignmentFilterId)
            {
                $filterId = $assignment.Target.DeviceAndAppManagementAssignmentFilterId
                $hashAssignment.Add('deviceAndAppManagementAssignmentFilterId', $filterId)
                $hashAssignment.Add('deviceAndAppManagementAssignmentFilterDisplayName', (($Script:IntuneAssignmentFilters | Where-Object -FilterScript { $_.FilterId -eq $filterId }).DisplayName))
            }
        }

        if ($null -ne $assignment.settings -and $assignment.settings.AdditionalProperties.Count -gt 0)
        {
            $settings = (Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $assignment.settings.AdditionalProperties)
            $hashAssignment.Add('assignmentSettings', $settings)
        }

        $assignmentResult += $hashAssignment
    }

    return ,$assignmentResult
}

function ConvertTo-IntuneMobileAppAssignment
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param (
        [Parameter(Mandatory = $true)]
        [AllowNull()]
        $Assignments,

        [Parameter()]
        [System.Boolean]
        $IncludeDeviceFilter = $true
    )

    if ($null -eq $Script:IntuneAssignmentFilters)
    {
        $Script:IntuneAssignmentFilters = Get-MgBetaDeviceManagementAssignmentFilter -All -ErrorAction SilentlyContinue | ForEach-Object {
            @{
                FilterId    = $_.Id
                DisplayName = $_.DisplayName
            }
        }
    }

    if ($null -eq $Assignments)
    {
        return ,@()
    }

    $assignmentResult = @()
    foreach ($assignment in $Assignments)
    {
        $formattedAssignment = @{}
        $target = @{
            '@odata.type' = $assignment.dataType
        }

        # Handle Device Filters
        if ($IncludeDeviceFilter)
        {
            if ($null -ne $assignment.DeviceAndAppManagementAssignmentFilterType -and
                $assignment.DeviceAndAppManagementAssignmentFilterType -ne 'none')
            {
                $filter = $Script:IntuneAssignmentFilters | Where-Object {
                    $_.FilterId -eq $assignment.DeviceAndAppManagementAssignmentFilterId
                }

                if ($null -eq $filter)
                {
                    $filter = $Script:IntuneAssignmentFilters | Where-Object {
                        $_.DisplayName -eq $assignment.DeviceAndAppManagementAssignmentFilterDisplayName
                    }
                }

                if ($null -ne $filter)
                {
                    $target.Add('deviceAndAppManagementAssignmentFilterType', $assignment.DeviceAndAppManagementAssignmentFilterType)
                    $target.Add('deviceAndAppManagementAssignmentFilterId', $filter.FilterId)
                }
                else
                {
                    Write-Warning "Assignment filter with DisplayName {$($assignment.DeviceAndAppManagementAssignmentFilterDisplayName)} not found."
                }
            }
        }

        # Add intent (required for app assignments)
        $formattedAssignment.Add('intent', $assignment.intent)

        if ($assignment.dataType -like '*groupAssignmentTarget')
        {
            $group = $null
            if (-not [System.String]::IsNullOrEmpty($assignment.groupId))
            {
                $group = Get-MgGroup -GroupId $assignment.groupId -ErrorAction SilentlyContinue
            }
            # If groupId lookup failed, try by display name
            if ($null -eq $group -and -not [System.String]::IsNullOrEmpty($assignment.groupDisplayName))
            {
                $escapedName = $assignment.groupDisplayName -replace "'", "''"
                $group = Get-MgGroup -Filter "DisplayName eq '$escapedName'" -All -ErrorAction SilentlyContinue
                if ($null -eq $group)
                {
                    Write-Warning "Skipping assignment: groupDisplayName '{$($assignment.groupDisplayName)}' not found."
                    $target = $null
                }
                elseif ($group.Count -gt 1)
                {
                    Write-Warning "Skipping assignment: groupDisplayName '{$($assignment.groupDisplayName)}' is not unique."
                    $target = $null
                }
            }
            # If group found, add its ID
            if ($null -ne $group)
            {
                $target.Add('groupId', $group.Id)
            }
            elseif ($null -eq $group -and [System.String]::IsNullOrEmpty($assignment.groupDisplayName))
            {
                Write-Warning 'Skipping assignment: missing both groupId and groupDisplayName.'
                $target = $null
            }
        }
        # Add target if valid
        if ($target)
        {
            $formattedAssignment.Add('target', $target)
        }
        # Add assignment settings if present
        if ($null -ne $assignment.assignmentSettings)
        {
            $settings = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $assignment.assignmentSettings
            $formattedAssignment.Add('settings', $settings)
            $formattedAssignment.settings.Add('@odata.type', $formattedAssignment.settings.odataType)
            $formattedAssignment.settings.Remove('odataType') | Out-Null
        }
        $assignmentResult += $formattedAssignment
    }
    return ,$assignmentResult
}

function Update-DeviceConfigurationPolicyAssignment
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter()]
        [Array]
        $Targets,

        [Parameter()]
        [System.String]
        $Repository = 'deviceManagement/configurationPolicies',

        [Parameter()]
        [ValidateSet('v1.0', 'beta')]
        [System.String]
        $APIVersion = 'beta',

        [Parameter()]
        [System.String]
        $RootIdentifier = 'assignments'
    )

    try
    {
        $deviceManagementPolicyAssignments = @()
        $Uri = "/$APIVersion/$Repository/$DeviceConfigurationPolicyId/assign"

        foreach ($target in $targets)
        {
            $targetAssignment = @{}
            $formattedTarget = @{'@odata.type' = $target.dataType }
            if ($null -ne $target.runRemediationScript)
            {
                $targetAssignment.Add('runRemediationScript', $target.runRemediationScript)
            }
            if ($null -ne $target.runSchedule)
            {
                $targetAssignment.Add('runSchedule', $target.runSchedule)
            }
            if ($target.target -is [hashtable])
            {
                $target = $target.target
            }
            if (-not $formattedTarget.'@odata.type' -and $target.'@odata.type')
            {
                $formattedTarget.'@odata.type' = $target.'@odata.type'
            }
            if ($target.groupId)
            {
                $group = Get-MgGroup -GroupId ($target.groupId) -ErrorAction SilentlyContinue
                if ($null -eq $group)
                {
                    if ($target.groupDisplayName)
                    {
                        $group = Get-MgGroup -Filter "DisplayName eq '$($target.groupDisplayName -replace "'", "''")'" -All -ErrorAction SilentlyContinue
                        if ($null -eq $group)
                        {
                            $message = "Skipping assignment for the group with DisplayName {$($target.groupDisplayName)} as it could not be found in the directory.`r`n"
                            $message += 'Please update your DSC resource extract with the correct groupId or groupDisplayName.'
                            Write-Warning -Message $message
                            $target = $null
                        }
                        if ($group -and $group.Count -gt 1)
                        {
                            $message = "Skipping assignment for the group with DisplayName {$($target.groupDisplayName)} as it is not unique in the directory.`r`n"
                            $message += 'Please update your DSC resource extract with the correct groupId or a unique group DisplayName.'
                            Write-Warning -Message $message
                            $group = $null
                            $target = $null
                        }
                    }
                    else
                    {
                        $message = "Skipping assignment for the group with Id {$($target.groupId)} as it could not be found in the directory.`r`n"
                        $message += 'Please update your DSC resource extract with the correct groupId or a unique group DisplayName.'
                        Write-Warning -Message $message
                        $target = $null
                    }
                }
                #Skipping assignment if group not found from either groupId or groupDisplayName
                if ($null -ne $group)
                {
                    $formattedTarget.Add('groupId', $group.Id)
                }
            }
            if ($target.collectionId)
            {
                $formattedTarget.Add('collectionId', $target.collectionId)
            }
            if ($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType', $target.deviceAndAppManagementAssignmentFilterType)
            }
            if ($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId', $target.deviceAndAppManagementAssignmentFilterId)
            }
            $targetAssignment.Add('target', $formattedTarget)
            $deviceManagementPolicyAssignments += $targetAssignment
        }

        $body = @{$RootIdentifier = $deviceManagementPolicyAssignments } | ConvertTo-Json -Depth 20
        Write-Verbose -Message $body

        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $null
    }
}

function Update-DeviceAppManagementPolicyAssignment
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppManagementPolicyId,

        [Parameter()]
        [Array]
        $Assignments,

        [Parameter()]
        [System.String]
        $Repository = 'deviceAppManagement/mobileApps',

        [Parameter()]
        [ValidateSet('v1.0', 'beta')]
        [System.String]
        $APIVersion = 'beta',

        [Parameter()]
        [System.String]
        $RootIdentifier = 'mobileAppAssignments'
    )

    try
    {
        $appManagementPolicyAssignments = @()
        $Uri = "/$APIVersion/$Repository/$AppManagementPolicyId/assign"

        foreach ($assignment in $Assignments)
        {
            $formattedAssignment = @{
                '@odata.type' = '#microsoft.graph.mobileAppAssignment'
                intent        = $assignment.intent
            }
            if ($assignment.settings)
            {
                $formattedAssignment.Add('settings', $assignment.settings)
            }

            if ($assignment.target -is [hashtable])
            {
                $target = $assignment.target
            }

            $formattedTarget = @{'@odata.type' = $target.dataType }
            if (-not $formattedTarget.'@odata.type' -and $target.'@odata.type')
            {
                $formattedTarget.'@odata.type' = $target.'@odata.type'
            }
            if ($target.groupId)
            {
                $group = Get-MgGroup -GroupId ($target.groupId) -ErrorAction SilentlyContinue
                if ($null -eq $group)
                {
                    if ($target.groupDisplayName)
                    {
                        $group = Get-MgGroup -Filter "DisplayName eq '$($target.groupDisplayName -replace "'", "''")'" -All -ErrorAction SilentlyContinue
                        if ($null -eq $group)
                        {
                            $message = "Skipping assignment for the group with DisplayName {$($target.groupDisplayName)} as it could not be found in the directory.`r`n"
                            $message += 'Please update your DSC resource extract with the correct groupId or groupDisplayName.'
                            Write-Warning -Message $message
                            $target = $null
                        }
                        if ($group -and $group.Count -gt 1)
                        {
                            $message = "Skipping assignment for the group with DisplayName {$($target.groupDisplayName)} as it is not unique in the directory.`r`n"
                            $message += 'Please update your DSC resource extract with the correct groupId or a unique group DisplayName.'
                            Write-Warning -Message $message
                            $group = $null
                            $target = $null
                        }
                    }
                    else
                    {
                        $message = "Skipping assignment for the group with Id {$($target.groupId)} as it could not be found in the directory.`r`n"
                        $message += 'Please update your DSC resource extract with the correct groupId or a unique group DisplayName.'
                        Write-Warning -Message $message
                        $target = $null
                    }
                }
                #Skipping assignment if group not found from either groupId or groupDisplayName
                if ($null -ne $group)
                {
                    $formattedTarget.Add('groupId', $group.Id)
                }
            }
            if ($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType', $target.deviceAndAppManagementAssignmentFilterType)
            }
            if ($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId', $target.deviceAndAppManagementAssignmentFilterId)
            }
            $formattedAssignment.Add('target', $formattedTarget)
            $appManagementPolicyAssignments += $formattedAssignment
        }

        $body = @{$RootIdentifier = $appManagementPolicyAssignments } | ConvertTo-Json -Depth 20
        Write-Verbose -Message $body

        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $null
    }
}

function Update-DeviceAppManagementAppCategory
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $App,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [Array]
        $Categories,

        [Parameter()]
        [switch]
        $Compare
    )

    if ($Compare)
    {
        [array]$referenceObject = if ($null -ne $App.Categories.DisplayName)
        {
            $App.Categories.DisplayName
        }
        else
        {
            , @()
        }
        [array]$differenceObject = if ($null -ne $Categories.DisplayName)
        {
            $Categories.DisplayName
        }
        else
        {
            , @()
        }
        $delta = Compare-Object -ReferenceObject $referenceObject -DifferenceObject $differenceObject -PassThru
        foreach ($diff in $delta)
        {
            if ($diff.SideIndicator -eq '=>')
            {
                $category = $Categories | Where-Object { $_.DisplayName -eq $diff }
                if ($category.Id)
                {
                    $currentCategory = Get-MgBetaDeviceAppManagementMobileAppCategory -MobileAppCategoryId $category.Id
                }
                else
                {
                    $currentCategory = Get-MgBetaDeviceAppManagementMobileAppCategory -Filter "DisplayName eq '$($category.DisplayName -replace "'", "''")'"
                }

                if ($null -eq $currentCategory)
                {
                    throw "Mobile App Category with DisplayName $($category.DisplayName) not found."
                }

                Invoke-MgGraphRequest -Uri "/beta/deviceAppManagement/mobileApps/$($App.Id)/categories/`$ref" -Method 'POST' -Body @{
                    '@odata.id' = "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceAppManagement/mobileAppCategories/$($currentCategory.Id)"
                }
            }
            else
            {
                $category = $App.Categories | Where-Object { $_.DisplayName -eq $diff }
                Invoke-MgGraphRequest -Uri "/beta/deviceAppManagement/mobileApps/$($App.Id)/categories/$($category.Id)/`$ref" -Method 'DELETE'
            }
        }
    }
    else
    {
        foreach ($category in $Categories)
        {
            if ($category.Id)
            {
                $currentCategory = Get-MgBetaDeviceAppManagementMobileAppCategory -MobileAppCategoryId $category.Id
            }
            else
            {
                $currentCategory = Get-MgBetaDeviceAppManagementMobileAppCategory -Filter "DisplayName eq '$($category.DisplayName -replace "'", "''")'"
            }

            if ($null -eq $currentCategory)
            {
                throw "Mobile App Category with DisplayName $($category.DisplayName) not found."
            }

            Invoke-MgGraphRequest -Uri "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceAppManagement/mobileApps/$($App.Id)/categories/`$ref" -Method 'POST' -Body @{
                '@odata.id' = "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceAppManagement/mobileAppCategories/$($currentCategory.Id)"
            }
        }
    }
}

function Get-M365DSCIntuneDeviceConfigurationSettings
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties,

        [Parameter()]
        [System.String]
        $TemplateId
    )

    $templateCategoryId = (Get-MgBetaDeviceManagementTemplateCategory -DeviceManagementTemplateId $TemplateId).Id
    $templateSettings = Get-MgBetaDeviceManagementTemplateCategoryRecommendedSetting `
        -DeviceManagementTemplateId $TemplateId `
        -DeviceManagementTemplateSettingCategoryId $templateCategoryId

    $results = @()
    foreach ($setting in $templateSettings)
    {
        $result = @{}
        $settingType = $setting.AdditionalProperties.'@odata.type'
        $settingValue = $null
        $currentValueKey = $Properties.keys | Where-Object -FilterScript { $setting.DefinitionId -like "*$_" }
        if ($null -ne $currentValueKey)
        {
            $settingValue = $Properties.$currentValueKey
        }

        $requiresValueJson = $false
        switch ($settingType)
        {
            {
                ( $_ -eq '#microsoft.graph.deviceManagementStringSettingInstance' ) -or
                ( $_ -eq '#microsoft.graph.deviceManagementBooleanSettingInstance' )
            }
            {
                if ([String]::IsNullOrEmpty($settingValue))
                {
                    $settingValue = $setting.ValueJson | ConvertFrom-Json
                }
            }
            '#microsoft.graph.deviceManagementCollectionSettingInstance'
            {
                $requiresValueJson = $true
                if ($null -eq $settingValue)
                {
                    $settingValue = ConvertTo-Json -InputObject @()
                }
                else
                {
                    $settingValue = ConvertTo-Json -InputObject ([Array]$settingValue)
                }
            }
            default
            {
                if ($null -eq $settingValue)
                {
                    $settingValue = $setting.ValueJson | ConvertFrom-Json
                }
            }
        }

        $result.Add('@odata.type', $settingType)
        $result.Add('Id', $setting.Id)
        $result.Add('definitionId', $setting.DefinitionId)

        if ($requiresValueJson)
        {
            $result.Add('valueJson', $settingValue)
        }
        else
        {
            $result.Add('value', $settingValue)
        }

        $results += $result
    }

    return $results
}

function Get-OmaSettingPlainTextValue
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $SecretReferenceValueId,

        [Parameter()]
        [ValidateSet('v1.0', 'beta')]
        [System.String]
        $APIVersion = 'beta'
    )

    try
    {
        <#
            e.g. PolicyId for SecretReferenceValueId '35ea58ec-2a79-471d-8eea-7e28e6cd2722_bdf6c690-05fb-4d02-835d-5a7406c35d58_abe32712-2255-445f-a35e-0c6f143d82ca'
            is 'bdf6c690-05fb-4d02-835d-5a7406c35d58'
        #>
        $SplitSecretReferenceValueId = $SecretReferenceValueId.Split('_')
        if ($SplitSecretReferenceValueId.Count -eq 3)
        {
            $PolicyId = $SplitSecretReferenceValueId[1]
        }
        else
        {
            return $null
        }
    }
    catch
    {
        return $null
    }

    $Repository = 'deviceManagement/deviceConfigurations'
    $Uri = "/{0}/{1}/{2}/getOmaSettingPlainTextValue(secretReferenceValueId='{3}')" -f $APIVersion, $Repository, $PolicyId, $SecretReferenceValueId

    try
    {
        $Result = Invoke-MgGraphRequest -Method GET -Uri $Uri -ErrorAction Stop
    }
    catch
    {
        $Message = 'Error decrypting OmaSetting with SecretReferenceValueId {0}:' -f $SecretReferenceValueId
        New-M365DSCLogEntry -Message $Message `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $null
    }

    if (![String]::IsNullOrEmpty($Result.Value))
    {
        return $Result.Value
    }
    else
    {
        return $null
    }
}

function Get-IntuneSettingCatalogPolicySetting
{
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $DSCParams,

        [Parameter(
            Mandatory = 'true',
            ParameterSetName = 'Start'
        )]
        [System.String]
        $TemplateId,

        [Parameter(
            Mandatory = 'true',
            ParameterSetName = 'DeviceAndUserSettings'
        )]
        [System.Array]
        $SettingTemplates,

        [Parameter(ParameterSetName = 'Start')]
        [switch]
        $ContainsDeviceAndUserSettings
    )

    if ($null -eq (Get-Command Get-SettingsCatalogSettingName -ErrorAction SilentlyContinue))
    {
        Import-Module -Name (Join-Path $PSScriptRoot M365DSCIntuneSettingsCatalogUtil.psm1) -Force
    }

    $DSCParams.Remove('Identity') | Out-Null
    $DSCParams.Remove('DisplayName') | Out-Null
    $DSCParams.Remove('Description') | Out-Null

    if ($PSCmdlet.ParameterSetName -eq 'Start')
    {
        # Prepare setting definitions mapping
        $SettingTemplates = Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate `
            -DeviceManagementConfigurationPolicyTemplateId $TemplateId `
            -ExpandProperty 'SettingDefinitions' `
            -All
    }

    return ,[Microsoft365DSC.Intune.SettingCatalogPolicySettingBuilder]::Build(
        [System.Collections.Generic.List[object]]@($SettingTemplates),
        $DSCParams,
        $ContainsDeviceAndUserSettings.IsPresent)
}

function Export-IntuneSettingCatalogPolicySettings
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Start'
        )]
        $Settings,

        [Parameter(
            Mandatory = $true
        )]
        [System.Collections.Hashtable]$ReturnHashtable,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Setting'
        )]
        $SettingInstance,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Setting'
        )]
        $SettingDefinitions,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Setting'
        )]
        [Parameter(
            ParameterSetName = 'Start'
        )]
        [System.Array]
        $AllSettingDefinitions,

        [Parameter(
            ParameterSetName = 'Setting'
        )]
        [switch]$IsRoot,

        [Parameter(
            ParameterSetName = 'Start'
        )]
        [switch]$ContainsDeviceAndUserSettings
    )

    return [Microsoft365DSC.Intune.SettingCatalogPolicyExporter]::Export($Settings, $ReturnHashtable, $AllSettingDefinitions, $ContainsDeviceAndUserSettings)
}

function Update-IntuneDeviceConfigurationPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Platforms,

        [Parameter()]
        [System.String]
        $Technologies,

        [Parameter()]
        [System.String]
        $TemplateReferenceId,

        [Parameter()]
        [AllowNull()]
        [System.String]
        $CreationSource,

        [Parameter()]
        [Array]
        $Settings,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds
    )

    try
    {
        $Uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceManagement/configurationPolicies/$DeviceConfigurationPolicyId"

        $policy = @{
            'name'            = $Name
            'description'     = $Description
            'platforms'       = $Platforms
            'technologies'    = $Technologies
            'settings'        = $Settings
            'roleScopeTagIds' = $RoleScopeTagIds
        }

        if ($PSBoundParameters.ContainsKey('TemplateReferenceId'))
        {
            $policy.Add('templateReference', @{ 'templateId' = $TemplateReferenceId })
        }

        if ($PSBoundParameters.ContainsKey('CreationSource') -and -not [System.String]::IsNullOrEmpty($CreationSource))
        {
            $policy.Add('creationSource', $CreationSource)
        }

        $body = $policy | ConvertTo-Json -Depth 20
        Write-Verbose -Message "Updating policy with:`r`n$body"
        Invoke-MgGraphRequest -Method PUT -Uri $Uri -Body $body -ErrorAction Stop
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Get-ComplexFunctionsFromFilterQuery
{
    [CmdletBinding()]
    [OutputType([System.Array])]
    param (
        [string]$FilterQuery
    )

    $complexFunctionsRegex = "startswith\((.*?),\s*'(.*?)'\)|endswith\((.*?),\s*'(.*?)'\)|contains\((.*?),\s*'(.*?)'\)"
    [array]$complexFunctions = [regex]::Matches($FilterQuery, $complexFunctionsRegex) | ForEach-Object {
        $_.Value
    }

    return $complexFunctions
}

function Remove-ComplexFunctionsFromFilterQuery
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [string]$FilterQuery
    )

    $complexFunctionsRegex = "startswith\((.*?),\s*'(.*?)'\)|endswith\((.*?),\s*'(.*?)'\)|contains\((.*?),\s*'(.*?)'\)"
    $basicFilterQuery = [regex]::Replace($FilterQuery, $complexFunctionsRegex, '').Trim()
    $basicFilterQuery = $basicFilterQuery -replace '^and\s', '' -replace '\sand$', '' -replace '\sand\s+', ' and ' -replace '\sor\s+', ' or '

    return $basicFilterQuery
}

function Find-GraphDataUsingComplexFunctions
{
    [CmdletBinding()]
    [OutputType([System.Array])]
    param (
        [array]$Policies,
        [array]$ComplexFunctions
    )

    foreach ($function in $ComplexFunctions)
    {
        if ($function -match "startswith\((.*?),\s*'(.*?)'")
        {
            $property = $matches[1]
            $value = $matches[2]
            $Policies = $Policies | Where-Object { $_.$property -like "$value*" }
        }
        elseif ($function -match "endswith\((.*?),\s*'(.*?)'")
        {
            $property = $matches[1]
            $value = $matches[2]
            $Policies = $Policies | Where-Object { $_.$property -like "*$value" }
        }
        elseif ($function -match "contains\((.*?),\s*'(.*?)'")
        {
            $property = $matches[1]
            $value = $matches[2]
            $Policies = $Policies | Where-Object { $_.$property -like "*$value*" }
        }
    }

    return $Policies
}

function Invoke-M365DSCIntuneMobileAppInitialUpload
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OdataType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $FileExtension
    )

    $OdataType = $OdataType.Replace('#', '')
    $contentVersionsUri = "beta/deviceAppManagement/mobileApps/$($AppId)/$OdataType/contentVersions"
    $contentVersion = Invoke-MgGraphRequest -Method POST -Uri $contentVersionsUri -Body @{}

    $manifest = $null
    $size = 1
    $sizeEncrypted = 64
    $base64File = '+drh1SKfuLjdp37gfv8EuWqOTt06m0TirqJJ0xQvrd5sm6NkiYBY8vBkFM+9ZwHRskO83NEfsLPtTzLB9FFsKA=='
    $fileDigest = 'ypeBEsobvcr6wjGzmiPcTaeG7/gUfE5yuYB3ha/uSLs='
    $mac = '+drh1SKfuLjdp37gfv8EuWqOTt06m0TirqJJ0xQvrd4='
    switch ($OdataType)
    {
        'microsoft.graph.androidLobApp'
        {
            $size = 3425
            $sizeEncrypted = 3488
            $manifest = $([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('<?xml version="1.0" encoding="utf-8"?><AndroidManifestProperties xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><Package>b.a</Package><PackageVersionCode>1</PackageVersionCode><PackageVersionName></PackageVersionName><ApplicationName>Sample.apk</ApplicationName><MinSdkVersion>3</MinSdkVersion><AWTVersion></AWTVersion></AndroidManifestProperties>')))
            $base64File = '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'
            $fileDigest = 'rCQEPUja3DkId6YVFRVWWx/cHasCjuLZXYC9gAhdk3Y='
            $mac = 'OXtq10WM7mpJAnbN2AU/cqvKGYeKfTfJirK3weR6Y08='
        }
        'microsoft.graph.windowsMobileMSI'
        {
            $manifest = $([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('<MobileMsiData MsiExecutionContext="User" MsiRequiresReboot="false" MsiUpgradeCode="{00000000-0000-0000-0000-000000000000}" MsiIsMachineInstall="false" MsiIsUserInstall="true" MsiRequiresLogon="true" MsiIncludesServices="false" MsiContainsSystemRegistryKeys="false" MsiContainsSystemFolders="false"></MobileMsiData>')))
        }
        'microsoft.graph.windowsUniversalAppx'
        {
            $manifest = $([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("Sample.$($FileExtension)".ToUpper())))
        }
    }

    $fileUri = "beta/deviceAppManagement/mobileApps/$($AppId)/$OdataType/contentVersions/$($contentVersion.id)/files"
    $manifest = $null
    if ($OdataType -eq 'microsoft.graph.windowsUniversalAppx')
    {
        # Manifest is required for Windows Universal Appx
        $manifest = $([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("Sample.$($FileExtension)".ToUpper())))
    }
    elseif ($OdataType -eq 'microsoft.graph.windowsMobileMSI')
    {
        # Manifest is required for Windows Mobile MSI
        $manifest = $([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('<MobileMsiData MsiExecutionContext="User" MsiRequiresReboot="false" MsiUpgradeCode="{00000000-0000-0000-0000-000000000000}" MsiIsMachineInstall="false" MsiIsUserInstall="true" MsiRequiresLogon="true" MsiIncludesServices="false" MsiContainsSystemRegistryKeys="false" MsiContainsSystemFolders="false"></MobileMsiData>')))
    }
    $file = Invoke-MgGraphRequest -Method POST `
        -Uri $fileUri `
        -Body @{
        '@odata.type' = '#microsoft.graph.mobileAppContentFile'
        name          = "Sample.$($FileExtension)"
        size          = $size
        sizeEncrypted = $sizeEncrypted
        isDependency  = $false
        manifest      = $manifest
    }

    $file = Wait-ForFileProcessing -AppId $AppId -OdataType $OdataType -FileId $file.id -ContentVersionId $contentVersion.id -UploadStatePrefix 'AzureStorageUriRequest'

    # Upload the encrypted Sample file to Azure Storage
    $success = $false
    $breakCounter = 0
    do
    {
        try
        {
            Write-Verbose "Uploading file to Azure Storage: $($file.azureStorageUri)"
            $base64File = '+drh1SKfuLjdp37gfv8EuWqOTt06m0TirqJJ0xQvrd5sm6NkiYBY8vBkFM+9ZwHRskO83NEfsLPtTzLB9FFsKA=='
            $sasUri = $file.azureStorageUri
            $uri = "$($sasUri)&comp=block&blockid=0001"
            $iso = [System.Text.Encoding]::GetEncoding('iso-8859-1')
            $body = [System.Convert]::FromBase64String($base64File)
            $encodedBody = $iso.GetString($body)
            Invoke-WebRequest -Uri $uri -Method PUT -Body $encodedBody -Headers @{
                'x-ms-blob-type' = 'BlockBlob'
            } -ErrorAction Stop -UseBasicParsing | Out-Null
            Write-Verbose 'File uploaded successfully to Azure Storage.' -Verbose
            $success = $true
        }
        catch
        {
            Write-Warning -Message "Failed to upload file to Azure Storage: $($_.Exception.Message)" -Verbose
            Start-Sleep -Seconds 2
        }
    } while ($success -eq $false -and $breakCounter -lt 5)

    # Finalize the upload to Azure Storage
    $uri = "$($sasUri)&comp=blocklist"
    $xml = '<?xml version="1.0" encoding="utf-8"?><BlockList><Latest>0001</Latest></BlockList>'
    Invoke-RestMethod -Uri $uri -Method PUT -Body $xml

    # Commit the file and update the app
    $jsonCommit = @{
        fileEncryptionInfo = @{
            fileDigestAlgorithm  = 'SHA256'
            encryptionKey        = 'yqjlzT5KYpwU0wkr5eJGGukMB0Ar8iGqYX3B0lJJnKk='
            initializationVector = 'bJujZImAWPLwZBTPvWcB0Q=='
            fileDigest           = $fileDigest
            mac                  = $mac
            profileIdentifier    = 'ProfileVersion1'
            macKey               = 'mGfhTn/0AB3fftWzENQcoU34xghAfvVq23PoiBD81tM='
        }
    }
    $commitUri = "beta/deviceAppManagement/mobileApps/$AppId/$OdataType/contentVersions/$($contentVersion.id)/files/$($file.id)/commit"
    Invoke-MgGraphRequest -Method POST -Uri $commitUri -Body $($jsonCommit | ConvertTo-Json -Depth 10)

    Wait-ForFileProcessing -AppId $AppId -OdataType $OdataType -FileId $file.id -ContentVersionId $contentVersion.id -UploadStatePrefix 'CommitFile'

    # Update the app with the committed content version
    Invoke-MgGraphRequest -Method PATCH -Uri "beta/deviceAppManagement/mobileApps/$AppId" -Body @{
        '@odata.type'           = "#$OdataType"
        committedContentVersion = '1'
    }
}

function Wait-ForFileProcessing
{
    [CmdletBinding()]
    [OutputType([System.Object])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OdataType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $FileId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ContentVersionId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $UploadStatePrefix
    )

    $fileUri = "beta/deviceAppManagement/mobileApps/$($AppId)/$OdataType/contentVersions/$ContentVersionId/files/$($FileId)"

    Write-Verbose "Waiting for file processing to complete for AppId: $AppId, OdataType: $OdataType, FileId: $FileId, ContentVersionId: $ContentVersionId"
    $file = Invoke-MgGraphRequest -Method GET -Uri $fileUri

    while ($file.uploadState -ne "$($UploadStatePrefix)Success")
    {
        if ($file.uploadState -like '*Failed')
        {
            throw "File upload failed with state: $($file.uploadState). Please check the file and try again."
        }

        Start-Sleep -Seconds 1
        Write-Verbose "Current upload state: $($file.uploadState). Waiting for processing to complete..."
        $file = Invoke-MgGraphRequest -Method GET -Uri $fileUri
    }

    $file
}

Export-ModuleMember -Function @(
    'Compare-M365DSCIntunePolicyAssignment',
    'ConvertFrom-IntuneMobileAppAssignment',
    'ConvertFrom-IntunePolicyAssignment',
    'ConvertTo-IntuneMobileAppAssignment',
    'ConvertTo-IntunePolicyAssignment',
    'Export-IntuneSettingCatalogPolicySettings',
    'Find-GraphDataUsingComplexFunctions',
    'Get-ComplexFunctionsFromFilterQuery',
    'Get-IntuneSettingCatalogPolicySetting',
    'Get-M365DSCIntuneDeviceConfigurationSettings',
    'Get-OmaSettingPlainTextValue',
    'Invoke-M365DSCIntuneMobileAppInitialUpload',
    'Remove-ComplexFunctionsFromFilterQuery',
    'Update-DeviceAppManagementAppCategory',
    'Update-DeviceAppManagementPolicyAssignment',
    'Update-DeviceConfigurationPolicyAssignment',
    'Update-IntuneDeviceConfigurationPolicy',
    'Wait-ForFileProcessing'
)
