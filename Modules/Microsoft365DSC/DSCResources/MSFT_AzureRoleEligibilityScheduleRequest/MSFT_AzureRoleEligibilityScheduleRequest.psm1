Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AzureRoleEligibilityScheduleRequest'

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
        [System.String]
        $Justification,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of Azure Role Eligibility Schedule Request"

    try
    {
        if (-not $Script:exportedInstance)
        {
            $null = New-M365DSCConnection -Workload 'Azure' `
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
                Write-Verbose -Message "Retrieving all role eligibility schedules in scope {$DirectoryScopeId}"
                $Script:AllSchedules = Get-AzRoleEligibilitySchedule -Scope $DirectoryScopeId `
                    -ErrorAction SilentlyContinue
            }
            if ($null -eq $Script:RoleDefinitions)
            {
                $Script:RoleDefinitions = [System.Collections.Generic.Dictionary[System.String, System.Object]]::new()
                $allRoleDefinitions = Get-AzRoleDefinition -ErrorAction SilentlyContinue
                foreach ($singleRoleDefinition in $allRoleDefinitions)
                {
                    $Script:RoleDefinitions.Add($singleRoleDefinition.Id, $singleRoleDefinition)
                }
            }

            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                Write-Verbose -Message "Getting Role Eligibility with scope {$DirectoryScopeId} and by Id {$Id}"
                $schedule = $Script:AllSchedules | Where-Object -FilterScript {
                    $_.id -eq $Id -and $_.Scope -eq $DirectoryScopeId
                }
            }
        }
        else
        {
            $schedule = $Script:exportedInstance
            # To keep performance good, only assign the current instance
            $Script:AllSchedules = $Script:exportedInstance
        }

        Write-Verbose -Message "Getting Role Eligibility by PrincipalId and RoleDefinitionId for Principal {$Principal}"
        if ($null -eq $Script:PrincipalByNameCache)
        {
            $Script:PrincipalByNameCache = [System.Collections.Generic.Dictionary[System.String, System.Object]]::new()
        }
        $cacheKey = "$PrincipalType|$Principal"
        $PrincipalValue = $null
        if ($Script:PrincipalByNameCache.ContainsKey($cacheKey))
        {
            Write-Verbose -Message "Using cached principal for {$Principal}"
            $PrincipalInstance = $Script:PrincipalByNameCache[$cacheKey]
        }
        else
        {
            if ($PrincipalType -eq 'User')
            {
                Write-Verbose -Message "Retrieving Principal by UserPrincipalName {$Principal}"
                $PrincipalInstance = Get-AzADUser -UserPrincipalName ($Principal -replace "'", "''") -ErrorAction SilentlyContinue
            }
            elseif ($PrincipalType -eq 'Group')
            {
                Write-Verbose -Message "Retrieving Principal by DisplayName {$Principal}"
                $PrincipalInstance = Get-AzADGroup -DisplayName ($Principal -replace "'", "''") -ErrorAction SilentlyContinue
            }
            else
            {
                Write-Verbose -Message "Retrieving Principal by DisplayName {$Principal}"
                $PrincipalInstance = Get-AzADServicePrincipal -DisplayName ($Principal -replace "'", "''") -ErrorAction SilentlyContinue
            }
            if ($null -ne $PrincipalInstance)
            {
                $Script:PrincipalByNameCache[$cacheKey] = $PrincipalInstance
            }
        }
        if ($PrincipalType -eq 'User')
        {
            $PrincipalValue = $PrincipalInstance.UserPrincipalName
        }
        elseif ($null -ne $PrincipalInstance)
        {
            $PrincipalValue = $PrincipalInstance.DisplayName
        }

        if ([System.String]::IsNullOrEmpty($PrincipalValue)) {
            return $nullResult
        }

        Write-Verbose -Message "Found Principal {$PrincipalValue}"
        $roleDefinitionId = $Script:RoleDefinitions.GetEnumerator() | Where-Object { $_.Value.Name -eq $RoleDefinition } | Select-Object -ExpandProperty Key
        Write-Verbose -Message "Retrieved role definition {$RoleDefinition} with ID {$roleDefinitionId}"

        if ($null -eq $schedule)
        {
            Write-Verbose -Message "Retrieving the request by PrincipalId {$($PrincipalInstance.Id)}, RoleDefinitionId {$($roleDefinitionId)} and DirectoryScopeId {$($DirectoryScopeId)}"
            [array]$requests = $Script:AllSchedules | Where-Object -FilterScript {
                $_.PrincipalId -eq $PrincipalInstance.Id -and
                $null -ne $_.RoleDefinitionId -and
                $_.RoleDefinitionId.Split('/')[-1] -eq $roleDefinitionId -and
                $_.Scope -eq $DirectoryScopeId
            }

            if ($requests.Count -eq 0)
            {
                # Lookup in Azure - can be the case if a role was created in this configuration run
                Write-Verbose -Message "No cached schedules found, fetching with principalId, roleDefinitionId and directoryScopeId"
                $requests = Get-AzRoleEligibilitySchedule -Scope $DirectoryScopeId -Filter "principalId eq '$($PrincipalInstance.Id)'" -ErrorAction SilentlyContinue
                $requests = $requests | Where-Object -FilterScript {
                    $null -ne $_.RoleDefinitionId -and
                    $_.RoleDefinitionId.Split('/')[-1] -eq $roleDefinitionId -and
                    $_.Scope -eq $DirectoryScopeId
                }
                if ($requests.Count -eq 0)
                {
                    # We need to make sure we're not ending up here because the role is a custom role (which has a different id).
                    Write-Verbose -Message "No schedules found, testing for custom role definitions"
                    if ($null -eq $roleDefinitionId)
                    {
                        Write-Verbose -Message "Role definition Id is null, returning null result"
                        return $nullResult
                    }
                    $roleEntry = $Script:RoleDefinitions[$roleDefinitionId]
                    if ($null -eq $roleEntry)
                    {
                        $roleEntry = Get-AzRoleDefinition -Id $roleDefinitionId -ErrorAction SilentlyContinue
                    }
                    if ($roleEntry.Name -eq $RoleDefinition)
                    {
                        $roleDefinitionId = $roleEntry.Id
                        if (-not $Script:RoleDefinitions.ContainsKey($roleDefinitionId))
                        {
                            $Script:RoleDefinitions.Add($roleDefinitionId, $roleEntry)
                        }
                        # The TemplateId is the id of the custom role definition
                        Write-Verbose -Message "Fetching schedules for custom role definition with RoleDefinitionId {$roleDefinitionId}"
                        $requests = Get-AzRoleEligibilitySchedule -Scope $DirectoryScopeId -Filter "principalId eq '$($PrincipalInstance.Id)'" -ErrorAction SilentlyContinue
                        $requests = $requests | Where-Object -FilterScript {
                            $null -ne $_.RoleDefinitionId -and
                            $_.RoleDefinitionId.Split('/')[-1] -eq $roleDefinitionId -and
                            $_.Scope -eq $DirectoryScopeId
                        }
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

        if ($null -eq $schedule -and $null -ne $requests -and $requests.Count -gt 0)
        {
            $schedule = $requests[0]
        }

        if ($null -eq $schedule)
        {
            return $nullResult
        }

        $ScheduleInfoValue = @{}

        $expirationValue = [ordered]@{}
        if ($null -ne $schedule.EndDateTime)
        {
            $expirationValue.Add('endDateTime', $schedule.EndDateTime.ToString('yyyy-MM-ddTHH:mm:ssZ'))
            $expirationValue.Add('type', 'afterDateTime')
        }
        else
        {
            $expirationValue.Add('type', 'noExpiration')
        }
        $ScheduleInfoValue.Add('expiration', $expirationValue)

        if ($null -ne $schedule.StartDateTime)
        {
            $ScheduleInfoValue.Add('StartDateTime', $schedule.StartDateTime.ToString('yyyy-MM-ddTHH:mm:ssZ'))
        }

        $results = @{
            Principal             = $PrincipalValue
            PrincipalType         = $PrincipalType
            RoleDefinition        = $RoleDefinition
            DirectoryScopeId      = $schedule.Scope
            Id                    = $schedule.Name
            Justification         = "Eligibility of Azure role '$RoleDefinition' to principal '$PrincipalValue' of type '$PrincipalType'."
            ScheduleInfo          = $ScheduleInfoValue
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
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
        [System.String]
        $Justification,

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

    # Reset caches to ensure fresh data
    $Script:AllSchedules = $null
    $Script:RoleDefinitions = $null
    $Script:PrincipalByNameCache = $null
    $Script:PrincipalByIdCache = $null

    $currentInstance = Get-TargetResource @PSBoundParameters

    if ($PrincipalType -eq 'User')
    {
        Write-Verbose -Message "Retrieving Principal by UserPrincipalName {$Principal}"
        [Array]$PrincipalIdValue = (Get-AzADUser -UserPrincipalName ($Principal -replace "'", "''") -ErrorAction SilentlyContinue).Id
    }
    elseif ($PrincipalType -eq 'Group')
    {
        Write-Verbose -Message "Retrieving Principal by DisplayName {$Principal}"
        [Array]$PrincipalIdValue = (Get-AzADGroup -DisplayName ($Principal -replace "'", "''") -ErrorAction SilentlyContinue).Id
    }
    elseif ($PrincipalType -eq 'ServicePrincipal')
    {
        Write-Verbose -Message "Retrieving Principal by DisplayName {$Principal}"
        [Array]$PrincipalIdValue = (Get-AzADServicePrincipal -DisplayName ($Principal -replace "'", "''") -ErrorAction SilentlyContinue).Id
    }

    if ($null -eq $PrincipalIdValue)
    {
        throw "Couldn't find Principal {$Principal} of type {$PrincipalType}"
    }
    elseif ($PrincipalIdValue.Length -gt 1)
    {
        throw "Multiple Principal with ID {$Principal} of type {$PrincipalType} were found. Cannot create schedule."
    }

    $RoleDefinitionIdValue = (Get-AzRoleDefinition -Name ($RoleDefinition -replace "'", "''") -ErrorAction SilentlyContinue).Id
    if ($null -eq $RoleDefinitionIdValue)
    {
        throw "Couldn't find Role Definition {$RoleDefinition}"
    }

    $instanceParams = @{
        Name             = [guid]::NewGuid().ToString()
        Scope            = $DirectoryScopeId
        PrincipalId      = $PrincipalIdValue[0]
        RoleDefinitionId = "$DirectoryScopeId/providers/Microsoft.Authorization/roleDefinitions/$RoleDefinitionIdValue"
    }

    if ($null -ne $ScheduleInfo)
    {
        if (-not [System.String]::IsNullOrEmpty($ScheduleInfo.StartDateTime))
        {
            $instanceParams.Add('ScheduleInfoStartDateTime', $ScheduleInfo.StartDateTime)
        }
        if (-not [System.String]::IsNullOrEmpty($ScheduleInfo.Expiration.Type))
        {
            $instanceParams.Add('ExpirationType', $ScheduleInfo.Expiration.Type)
        }
        if (-not [System.String]::IsNullOrEmpty($ScheduleInfo.Expiration.Duration))
        {
            $instanceParams.Add('ExpirationDuration', $ScheduleInfo.Expiration.Duration)
        }
        if (-not [System.String]::IsNullOrEmpty($ScheduleInfo.Expiration.EndDateTime))
        {
            $instanceParams.Add('ExpirationEndDateTime', $ScheduleInfo.Expiration.EndDateTime)
        }
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $instanceParams.Add('RequestType', 'AdminAssign')
        $instanceParams.Add('Justification', 'AdminAssign by Microsoft365DSC')
        Write-Verbose -Message "Creating a Role Eligibility Schedule Request for principal {$Principal} and role {$RoleDefinition}"
        New-AzRoleEligibilityScheduleRequest @instanceParams
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        $instanceParams.Add('RequestType', 'AdminUpdate')
        $instanceParams.Add('Justification', 'AdminUpdate by Microsoft365DSC')
        Write-Verbose -Message "Updating the Role Eligibility Schedule Request for principal {$Principal} and role {$RoleDefinition}"
        New-AzRoleEligibilityScheduleRequest @instanceParams
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        $instanceParams.Add('RequestType', 'AdminRemove')
        $instanceParams.Add('Justification', 'AdminRemove by Microsoft365DSC')
        Write-Verbose -Message "Removing the Role Eligibility Schedule Request for principal {$Principal} and role {$RoleDefinition}"
        New-AzRoleEligibilityScheduleRequest @instanceParams
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
        [System.String]
        $Justification,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'Azure' `
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
        #region resource generator code
        $AllSchedules = [System.Collections.Generic.List[System.Object]]::new()
        $SeenScheduleNames = [System.Collections.Generic.HashSet[System.String]]::new()

        # Helper scriptblock to call Get-AzRoleEligibilitySchedule with optional Filter
        $GetSchedules = {
            param([System.String]$Scope)
            if ([System.String]::IsNullOrWhiteSpace($Filter))
            {
                Get-AzRoleEligibilitySchedule -Scope $Scope -ErrorAction SilentlyContinue
            }
            else
            {
                Get-AzRoleEligibilitySchedule -Scope $Scope -Filter $Filter -ErrorAction SilentlyContinue
            }
        }

        # Helper function to collect schedules for a given scope and add new ones to the list
        $CollectSchedules = {
            param([System.String]$Scope)
            Write-Verbose -Message "Enumerating role eligibility schedules for scope: $Scope"
            $ScopeSchedules = & $GetSchedules -Scope $Scope
            foreach ($Schedule in $ScopeSchedules)
            {
                if ($SeenScheduleNames.Add($Schedule.Name))
                {
                    $AllSchedules.Add($Schedule)
                }
            }
        }

        # Determine tenant root management group ID
        $TenantRootGroupId = $null
        $TenantInfo = Get-AzTenant -ErrorAction SilentlyContinue
        if ($null -ne $TenantInfo -and $null -ne $TenantInfo.TenantRootGroupId)
        {
            $TenantRootGroupId = $TenantInfo.TenantRootGroupId
            Write-Verbose -Message "Discovered tenant root management group ID: $TenantRootGroupId"
        }

        # Enumerate management groups recursively from tenant root
        $ManagementGroupIds = [System.Collections.Generic.List[System.String]]::new()
        if (-not [System.String]::IsNullOrWhiteSpace($TenantRootGroupId))
        {
            Write-Verbose -Message "Enumerating management groups recursively from root: $TenantRootGroupId"
            $RootMg = Get-AzManagementGroup -GroupName $TenantRootGroupId -Expand -Recurse -ErrorAction SilentlyContinue
            if ($null -ne $RootMg)
            {
                # Flatten management group tree recursively
                $FlattenMg = {
                    param($MgNode)
                    $ManagementGroupIds.Add($MgNode.Name)
                    foreach ($Child in $MgNode.Children)
                    {
                        if ($Child.Type -eq '/providers/Microsoft.Management/managementGroups')
                        {
                            & $FlattenMg $Child
                        }
                    }
                }
                & $FlattenMg $RootMg
            }
        }
        else
        {
            # Fallback: enumerate all management groups without recursive expansion
            Write-Verbose -Message 'Tenant root management group ID not available; falling back to flat management group enumeration.'
            $ManagementGroups = Get-AzManagementGroup -ErrorAction SilentlyContinue
            foreach ($ManagementGroup in $ManagementGroups)
            {
                $ManagementGroupIds.Add($ManagementGroup.Name)
            }
        }

        # Query schedules for each management group scope
        foreach ($MgId in $ManagementGroupIds)
        {
            $MgScope = "/providers/Microsoft.Management/managementGroups/$MgId"
            & $CollectSchedules -Scope $MgScope
        }

        # Subscriptions and their Resource Groups
        $Subscriptions = Get-AzSubscription -ErrorAction SilentlyContinue
        foreach ($Subscription in $Subscriptions)
        {
            $SubScope = "/subscriptions/$($Subscription.Id)"
            & $CollectSchedules -Scope $SubScope

            $null = Set-AzContext -Subscription $Subscription.Id -ErrorAction SilentlyContinue
            $ResourceGroups = Get-AzResourceGroup -ErrorAction SilentlyContinue
            foreach ($ResourceGroup in $ResourceGroups)
            {
                $RgScope = "$SubScope/resourceGroups/$($ResourceGroup.ResourceGroupName)"
                & $CollectSchedules -Scope $RgScope
            }
        }

        [array] $Script:exportedInstances = $AllSchedules

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Count -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        if ($null -eq $Script:RoleDefinitions)
        {
            $Script:RoleDefinitions = [System.Collections.Generic.Dictionary[System.String, System.Object]]::new()
            $roleDefinitions = Get-AzRoleDefinition -ErrorAction SilentlyContinue
            foreach ($roleDefinition in $roleDefinitions)
            {
                $Script:RoleDefinitions.Add($roleDefinition.Id, $roleDefinition)
            }
        }
        $Script:PrincipalByIdCache = [System.Collections.Generic.Dictionary[System.String, System.Object]]::new()
        foreach ($request in $Script:exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $request.Name
            Write-M365DSCHost -Message "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -DeferWrite

            # Find the Principal Type
            $principalType = $request.PrincipalType
            $principalInfo = $null
            $PrincipalValue = $null
            if ($Script:PrincipalByIdCache.ContainsKey($request.PrincipalId))
            {
                $principalInfo = $Script:PrincipalByIdCache[$request.PrincipalId]
            }
            else
            {
                if ($principalType -eq 'User')
                {
                    $principalInfo = Get-AzADUser -ObjectId $request.PrincipalId -ErrorAction SilentlyContinue
                }
                elseif ($principalType -eq 'Group')
                {
                    $principalInfo = Get-AzADGroup -ObjectId $request.PrincipalId -ErrorAction SilentlyContinue
                }
                else
                {
                    $principalInfo = Get-AzADServicePrincipal -ObjectId $request.PrincipalId -ErrorAction SilentlyContinue
                }
                if ($null -ne $principalInfo)
                {
                    $Script:PrincipalByIdCache[$request.PrincipalId] = $principalInfo
                }
            }
            if ($principalType -eq 'User')
            {
                $PrincipalValue = $principalInfo.UserPrincipalName
            }
            elseif ($null -ne $principalInfo)
            {
                $PrincipalValue = $principalInfo.DisplayName
            }

            if ($null -ne $PrincipalValue)
            {
                $roleDefinitionGuid = $request.RoleDefinitionId.Split('/')[-1]
                $roleDefinition = $Script:RoleDefinitions[$roleDefinitionGuid]
                if ($null -eq $roleDefinition)
                {
                    $roleDefinition = Get-AzRoleDefinition -Id $roleDefinitionGuid `
                        -ErrorAction SilentlyContinue
                    $Script:RoleDefinitions.Add($roleDefinitionGuid, $roleDefinition)
                }
                $params = @{
                    Id                    = $request.Name
                    Principal             = $PrincipalValue
                    PrincipalType         = $principalType
                    DirectoryScopeId      = $request.Scope
                    RoleDefinition        = $roleDefinition.Name
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

            $Script:exportedInstance = $request
            $Results = Get-TargetResource @Params

            if ($null -ne $Results.ScheduleInfo)
            {
                $complexMapping = @(
                    @{
                        Name            = 'ScheduleInfo'
                        CimInstanceName = 'MSFT_AzureRoleEligibilityScheduleRequestSchedule'
                        IsRequired      = $False
                    },
                    @{
                        Name            = 'expiration'
                        CimInstanceName = 'MSFT_AzureRoleEligibilityScheduleRequestScheduleExpiration'
                        IsRequired      = $False
                    },
                    @{
                        Name            = 'recurrence'
                        CimInstanceName = 'MSFT_AzureRoleEligibilityScheduleRequestScheduleRecurrence'
                        IsRequired      = $False
                    },
                    @{
                        Name            = 'pattern'
                        CimInstanceName = 'MSFT_AzureRoleEligibilityScheduleRequestScheduleRecurrencePattern'
                        IsRequired      = $False
                    },
                    @{
                        Name            = 'range'
                        CimInstanceName = 'MSFT_AzureRoleEligibilityScheduleRequestScheduleRecurrenceRange'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ScheduleInfo `
                    -CIMInstanceName 'MSFT_AzureRoleEligibilityScheduleRequestSchedule' `
                    -ComplexTypeMapping $complexMapping

                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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

            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
    }
    catch
    {
        if ($_.ErrorDetails.Message -like '*The tenant needs an AAD Premium*' -or `
                $_.ErrorDetails.Message -like '*[AadPremiumLicenseRequired]*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) Tenant does not meet license requirement to extract this component."
            return ''
        }
        else
        {
            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            throw
        }
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
        ExcludedProperties = @('Justification')
        PostProcessing = {
            param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
            if ($null -ne $DesiredValues.ScheduleInfo -and
                -not [System.String]::IsNullOrEmpty($DesiredValues.ScheduleInfo.StartDateTime))
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
