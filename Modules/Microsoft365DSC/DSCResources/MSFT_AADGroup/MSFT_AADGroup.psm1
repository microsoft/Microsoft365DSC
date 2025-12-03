Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADGroup'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $MailNickname,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $Owners,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $GroupAsMembers,

        [Parameter()]
        [System.String[]]
        $MemberOf,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $GroupLifecyclePolicySelectedEnabled,

        [Parameter()]
        [System.String[]]
        $GroupTypes,

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [ValidateSet('On', 'Paused')]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $SecurityEnabled,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $MailEnabled,

        [Parameter()]
        [System.Boolean]
        $IsAssignableToRole,

        [Parameter()]
        [System.String[]]
        $AssignedToRole,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'HiddenMembership')]
        [System.String]
        $Visibility,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AssignedLicenses,

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

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            Write-Verbose -Message 'Getting configuration of AzureAD Group'
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters

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
            $nullReturn.Owners = @()
            $nullReturn.Members = @()
            $nullReturn.GroupAsMembers = @()
            $nullReturn.MemberOf = @()
            $nullReturn.AssignedToRole = @()
            $nullReturn.AssignedLicenses = @()

            if ($PSBoundParameters.ContainsKey('Id'))
            {
                Write-Verbose -Message 'GroupID was specified'
                try
                {
                    $Group = Get-MgBetaGroup -GroupId $Id -ExpandProperty "members" -ErrorAction Stop
                }
                catch
                {
                    Write-Verbose -Message "Couldn't get group by ID, trying by name"
                    $Group = Get-MgBetaGroup -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" -ExpandProperty "members" -ErrorAction Stop
                    if ($Group.Length -gt 1)
                    {
                        throw "Duplicate AzureAD Groups named $DisplayName exist in tenant"
                    }
                }
            }
            else
            {
                Write-Verbose -Message 'Id was NOT specified'
                ## Can retreive multiple AAD Groups since displayname is not unique
                $Group = Get-MgBetaGroup -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" -ExpandProperty "members" -ErrorAction Stop
                if ($Group.Length -gt 1)
                {
                    throw "Duplicate AzureAD Groups named $DisplayName exist in tenant"
                }
            }

            if ($null -eq $Group)
            {
                Write-Verbose -Message 'Group was null, returning null'
                return $nullReturn
            }
        }
        else
        {
            $Group = $Script:exportedInstance
        }

        Write-Verbose -Message 'Found existing AzureAD Group'
        $batchRequests = @(
            @{
                id     = 'Owners'
                method = 'GET'
                url    = "/groups/$($Group.Id)/owners"
            }
            @{
                id     = 'MemberOf'
                method = 'GET'
                url    = "/groups/$($Group.Id)/memberOf"
            }
            @{
                id     = 'Licenses'
                method = 'GET'
                url    = "/groups/$($Group.Id)/assignedLicenses"
            }
            @{
                id     = 'GroupLifecyclePolicies'
                method = 'GET'
                url    = "/groups/$($Group.Id)/groupLifecyclePolicies"
            }
        )
        $batchResponse = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests

        # Owners
        [Array]$owners = ($batchResponse | Where-Object -FilterScript { $_.id -eq 'Owners' }).body.value
        $OwnersValues = @()
        foreach ($owner in $owners)
        {
            if ($null -ne $owner.userPrincipalName)
            {
                $OwnersValues += $owner.userPrincipalName
            }
            elseif ($owner.'@odata.type' -eq '#microsoft.graph.servicePrincipal')
            {
                $OwnersValues += $owner.displayName
            }
        }

        $MembersValues = $null
        $result = @{}
        if ($Group.MembershipRuleProcessingState -ne 'On')
        {
            # Members
            $MembersValues = [System.Collections.Generic.List[System.String]]::new()
            $GroupAsMembersValues = [System.Collections.Generic.List[System.String]]::new()
            $groupMembers = $Group.Members
            if ($Group.Members.Count -eq 20 -or $Script:requireGroupMemberFetching -eq $true)
            {
                # Fetch all group members
                $uri = "/beta/groups/$($Group.Id)/members?`$top=999"
                $groupMembers = [System.Collections.Generic.List[System.Object]]::new()
                $graphRequest = Invoke-MgGraphRequest -Uri $uri -Method GET
                $groupMembers.AddRange($graphRequest.value)
                while (-not [System.String]::IsNullOrEmpty($graphRequest.'@odata.nextLink'))
                {
                    $graphRequest = Invoke-MgGraphRequest -Uri $graphRequest.'@odata.nextLink' -Method GET
                    $groupMembers.AddRange($graphRequest.value)
                }
            }
            foreach ($member in $groupMembers)
            {
                if ($null -ne $member.AdditionalProperties)
                {
                    switch ($member.AdditionalProperties.'@odata.type')
                    {
                        '#microsoft.graph.user' {
                            $MembersValues.Add($member.AdditionalProperties.userPrincipalName)
                        }
                        '#microsoft.graph.servicePrincipal' {
                            $MembersValues.Add($member.AdditionalProperties.displayName)
                        }
                        '#microsoft.graph.device' {
                            $MembersValues.Add($member.AdditionalProperties.displayName)
                        }
                        '#microsoft.graph.group' {
                            $GroupAsMembersValues.Add($member.AdditionalProperties.displayName)
                        }
                    }
                }
                else
                {
                    switch ($member.'@odata.type')
                    {
                        '#microsoft.graph.user' {
                            $MembersValues.Add($member.userPrincipalName)
                        }
                        '#microsoft.graph.servicePrincipal' {
                            $MembersValues.Add($member.displayName)
                        }
                        '#microsoft.graph.device' {
                            $MembersValues.Add($member.displayName)
                        }
                        '#microsoft.graph.group' {
                            $GroupAsMembersValues.Add($member.displayName)
                        }
                    }
                }
            }
            $result.Add('Members', $MembersValues)
            $result.Add('GroupAsMembers', $GroupAsMembersValues)
        }

        # MemberOf
        [Array]$memberOf = ($batchResponse | Where-Object -FilterScript { $_.id -eq 'MemberOf' }).body.value
        $MemberOfValues = @()
        # Note: only process security-groups that this group is a member of and not directory roles (if any)
        foreach ($member in ($memberOf | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.group' }))
        {
            if ($null -ne $member.displayName)
            {
                $MemberOfValues += $member.displayName
            }
        }

        if ($null -eq $Script:DirectoryRoleDefinitions)
        {
            $Script:DirectoryRoleDefinitions = [System.Collections.Generic.Dictionary[string, string]]::new()
            $allRoleDefinitions = Get-MgBetaRoleManagementDirectoryRoleDefinition -All
            foreach ($roleDefinition in $allRoleDefinitions)
            {
                $Script:DirectoryRoleDefinitions.Add($roleDefinition.Id, $roleDefinition.DisplayName)
            }
        }

        if ($null -eq $Script:DirectoryRoleAssignments)
        {
            $Script:DirectoryRoleAssignments = [System.Collections.Generic.Dictionary[string, string[]]]::new()
            $allRoleAssignments = Get-MgBetaRoleManagementDirectoryRoleAssignment -All
            foreach ($roleAssignment in $allRoleAssignments)
            {
                if (-not $Script:DirectoryRoleAssignments.ContainsKey($roleAssignment.PrincipalId))
                {
                    $Script:DirectoryRoleAssignments[$roleAssignment.PrincipalId] = @()
                }
                $Script:DirectoryRoleAssignments[$roleAssignment.PrincipalId] += $roleAssignment.RoleDefinitionId
            }
        }

        # AssignedToRole
        $AssignedToRoleValues = @()
        if ($Group.IsAssignableToRole -eq $true)
        {
            $AssignedToRoleValues = @()
            $roleDefinitionIds = $Script:DirectoryRoleAssignments[$Group.Id]
            foreach ($roleDefinitionId in $roleDefinitionIds)
            {
                $roleDefinitionName = $Script:DirectoryRoleDefinitions[$roleDefinitionId]
                $AssignedToRoleValues += $roleDefinitionName
            }
        }

        # Licenses
        $assignedLicensesValues = @()
        $assignedLicensesRequest = ($batchResponse | Where-Object -FilterScript { $_.id -eq 'Licenses' }).body
        if ($assignedLicensesRequest.value.Length -gt 0)
        {
            [Array]$assignedLicensesValues = Get-M365DSCAzureADGroupLicenses -AssignedLicenses $assignedLicensesRequest.value
        }

        # GroupLifecyclePolicies
        $groupLifecyclePoliciesRequest = ($batchResponse | Where-Object -FilterScript { $_.id -eq 'GroupLifecyclePolicies' }).body.value
        $isGroupLifecyclePoliciesEnabled = $null -ne $groupLifecyclePoliciesRequest -and `
                                               $groupLifecyclePoliciesRequest.managedGroupTypes -eq 'selected'

        $policySettings = @{
            DisplayName                         = $Group.DisplayName
            Id                                  = $Group.Id
            Owners                              = $OwnersValues
            MemberOf                            = $MemberOfValues
            Description                         = $Group.Description
            GroupTypes                          = [System.String[]]$Group.GroupTypes
            MembershipRule                      = $Group.MembershipRule
            MembershipRuleProcessingState       = $Group.MembershipRuleProcessingState
            SecurityEnabled                     = $Group.SecurityEnabled
            MailEnabled                         = $Group.MailEnabled
            IsAssignableToRole                  = $false -or $Group.IsAssignableToRole
            AssignedToRole                      = $AssignedToRoleValues
            MailNickname                        = $Group.MailNickname
            Visibility                          = $Group.Visibility
            AssignedLicenses                    = $assignedLicensesValues
            Ensure                              = 'Present'
            ApplicationId                       = $ApplicationId
            TenantId                            = $TenantId
            CertificateThumbprint               = $CertificateThumbprint
            ApplicationSecret                   = $ApplicationSecret
            Credential                          = $Credential
            ManagedIdentity                     = $ManagedIdentity.IsPresent
            AccessTokens                        = $AccessTokens
        }

        $result += $policySettings
        if ($result.MailEnabled)
        {
            $result.Add("GroupLifecyclePolicySelectedEnabled", $isGroupLifecyclePoliciesEnabled)
        }

        return $result
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw $_
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $MailNickname,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $Owners,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $GroupAsMembers,

        [Parameter()]
        [System.String[]]
        $MemberOf,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $GroupLifecyclePolicySelectedEnabled,

        [Parameter()]
        [System.String[]]
        $GroupTypes,

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [ValidateSet('On', 'Paused')]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $SecurityEnabled,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $MailEnabled,

        [Parameter()]
        [System.Boolean]
        $IsAssignableToRole,

        [Parameter()]
        [System.string[]]
        $AssignedToRole,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'HiddenMembership')]
        [System.String]
        $Visibility,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AssignedLicenses,

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

    Write-Verbose -Message 'Setting configuration of Azure AD Groups'

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

    $currentParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $currentGroup = Get-TargetResource @PSBoundParameters
    $backCurrentOwners = $currentGroup.Owners
    $backCurrentMembers = $currentGroup.Members
    $backCurrentGroupAsMembers = $currentGroup.GroupAsMembers
    $backCurrentMemberOf = $currentGroup.MemberOf
    $backCurrentAssignedToRole = $currentGroup.AssignedToRole
    $currentParameters.Remove('Owners') | Out-Null
    $currentParameters.Remove('Members') | Out-Null
    $currentParameters.Remove('GroupAsMembers') | Out-Null
    $currentParameters.Remove('MemberOf') | Out-Null
    $currentParameters.Remove('AssignedToRole') | Out-Null

    if ($Ensure -eq 'Present' -and `
        ($null -ne $GroupTypes -and $GroupTypes.Contains('Unified')) -and `
        ($null -ne $MailEnabled -and $MailEnabled -eq $false))
    {
        Write-Verbose -Message 'Cannot set mailenabled to false if GroupTypes is set to Unified when creating group.'
        throw 'Cannot set mailenabled to false if GroupTypes is set to Unified when creating a group.'
    }

    $currentValuesToCheck = @()
    if ($currentGroup.AssignedLicenses.Length -gt 0)
    {
        $currentValuesToCheck = $currentGroup.AssignedLicenses.SkuId
    }
    $desiredValuesToCheck = @()
    if ($AssignedLicenses.Length -gt 0)
    {
        $desiredValuesToCheck = $AssignedLicenses.SkuId
    }

    [Array]$licensesDiff = Compare-Object -ReferenceObject $currentValuesToCheck -DifferenceObject $desiredValuesToCheck -IncludeEqual
    $toAdd = @()
    $toRemove = @()
    foreach ($diff in $licensesDiff)
    {
        if ($diff.SideIndicator -eq '=>')
        {
            $toAdd += $diff.InputObject
        }
        elseif ($diff.SideIndicator -eq '<=')
        {
            $toRemove += $diff.InputObject
        }
        elseif ($diff.SideIndicator -eq '==')
        {
            # This will take care of the scenario where the license is already assigned but has different disabled plans
            $toAdd += $diff.InputObject
        }
    }

    # Convert AssignedLicenses from SkuPartNumber back to GUID
    $licensesToAdd = @()
    $licensesToRemove = @()
    [Array]$AllLicenses = Get-M365DSCCombinedLicenses -DesiredLicenses $AssignedLicenses -CurrentLicenses $currentGroup.AssignedLicenses

    $allSkus = Get-MgBetaSubscribedSku
    # Create complete list of all Service Plans
    $allServicePlans = @()
    Write-Verbose -Message 'Getting all Service Plans'
    foreach ($sku in $allSkus)
    {
        foreach ($serviceplan in $sku.ServicePlans)
        {
            if ($allServicePlans.Length -eq 0 -or -not $allServicePlans.ServicePlanName.Contains($servicePlan.ServicePlanName))
            {
                $allServicePlans += @{
                    ServicePlanId   = $serviceplan.ServicePlanId
                    ServicePlanName = $serviceplan.ServicePlanName
                }
            }
        }
    }

    foreach ($assignedLicense in $AllLicenses)
    {
        $skuInfo = $allSkus | Where-Object -FilterScript { ($_.SkuPartNumber -replace [char]0xFEFF, '') -eq $assignedLicense.SkuId }
        if ($skuInfo)
        {
            if ($toAdd.Contains($assignedLicense.SkuId))
            {
                $disabledPlansValues = @()
                foreach ($plan in $assignedLicense.DisabledPlans)
                {
                    $foundItem = $allServicePlans | Where-Object -FilterScript { $_.ServicePlanName -eq $plan }
                    $disabledPlansValues += $foundItem.ServicePlanId
                }

                $skuInfo = $allSkus | Where-Object -FilterScript { ($_.SkuPartNumber -replace [char]0xFEFF, '') -eq $assignedLicense.SkuId }
                $licensesToAdd += @{
                    DisabledPlans = $disabledPlansValues
                    SkuId         = $skuInfo.SkuId
                }
            }
            elseif ($toRemove.Contains($assignedLicense.SkuId))
            {
                $licensesToRemove += $skuInfo.SkuId
            }
        }
        else
        {
            Write-Warning -Message "Specified Sku {$($assignedLicense.SkuId)} could not be found on the tenant."
        }
    }

    $currentParameters.Remove('AssignedLicenses') | Out-Null

    if ($Ensure -eq 'Present' -and $currentGroup.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Checking to see if an existing deleted group exists with DisplayName {$DisplayName}"
        $restoringExisting = $false
        [Array]$groups = Get-MgBetaDirectoryDeletedItemAsGroup -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'"
        if ($groups.Length -gt 1)
        {
            throw "Multiple deleted groups with the name {$DisplayName} were found. Cannot restore the existing group. Please ensure that you either have no instance of the group in the deleted list or that you have a single one."
        }

        if ($groups.Length -eq 1)
        {
            Write-Verbose -Message "Found an instance of a deleted group {$DisplayName}. Restoring it."
            Restore-MgBetaDirectoryDeletedItem -DirectoryObjectId $groups[0].Id
            $restoringExisting = $true
            $currentGroup = Get-MgBetaGroup -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" -ErrorAction Stop
        }

        if (-not $restoringExisting)
        {
            Write-Verbose -Message "Creating new group {$DisplayName}"
            $currentParameters.Remove('Id') | Out-Null

            try
            {
                Write-Verbose -Message "Creating Group with Values: $(Convert-M365DscHashtableToString -Hashtable $currentParameters)"
                $currentGroup = New-MgGroup @currentParameters
                Write-Verbose -Message "Created Group $($currentGroup.id)"
            }
            catch
            {
                Write-Verbose -Message $_
                New-M365DSCLogEntry -Message "Couldn't create group $DisplayName" `
                    -Exception $_ `
                    -Source $MyInvocation.MyCommand.ModuleName
            }
        }
    }
    if ($Ensure -eq 'Present')
    {
        Write-Verbose -Message "Group {$DisplayName} exists and it should."
        try
        {
            Write-Verbose -Message "Updating settings by ID for group {$DisplayName}"
            if ($true -eq $currentParameters.ContainsKey('IsAssignableToRole'))
            {
                Write-Verbose -Message 'Cannot set IsAssignableToRole once group is created.'
                $currentParameters.Remove('IsAssignableToRole') | Out-Null
            }

            if ($false -eq $currentParameters.ContainsKey('Id'))
            {
                Update-MgGroup @currentParameters -GroupId $currentGroup.Id | Out-Null
            }
            else
            {
                $currentParameters.Remove('Id') | Out-Null
                $currentParameters.Add('GroupId', $currentGroup.Id)
                Write-Verbose -Message "Updating Group with Values: $(Convert-M365DscHashtableToString -Hashtable $currentParameters)"
                Update-MgGroup @currentParameters | Out-Null
            }

            if (($licensesToAdd.Length -gt 0 -or $licensesToRemove.Length -gt 0) -and $PSBoundParameters.ContainsKey('AssignedLicenses'))
            {
                try
                {
                    Write-Verbose -Message "Setting Group Licenses with:`r`nLicensesToAdd: $(ConvertTo-Json $licensesToAdd)`r`nLicensesToRemove: $(ConvertTo-Json $licensesToRemove)"
                    Set-MgGroupLicense -GroupId $currentGroup.Id `
                        -AddLicenses $licensesToAdd `
                        -RemoveLicenses $licensesToRemove `
                        -ErrorAction Stop | Out-Null
                }
                catch
                {
                    Write-Verbose -Message $_
                }
            }
        }
        catch
        {
            New-M365DSCLogEntry -Message "Couldn't set group $DisplayName" `
                -Exception $_ `
                -Source $MyInvocation.MyCommand.ModuleName
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentGroup.Ensure -eq 'Present')
    {
        try
        {
            Remove-MgGroup -GroupId $currentGroup.Id | Out-Null
        }
        catch
        {
            New-M365DSCLogEntry -Message "Couldn't delete group $DisplayName" `
                -Exception $_ `
                -Source $MyInvocation.MyCommand.ModuleName
        }
    }

    if ($Ensure -ne 'Absent')
    {
        #Owners
        Write-Verbose -Message 'Updating Owners'
        if ($PSBoundParameters.ContainsKey('Owners'))
        {
            $desiredOwnersValue = @()
            if ($Owners.Length -gt 0)
            {
                $desiredOwnersValue = $Owners
            }
            if ($null -eq $backCurrentOwners)
            {
                $backCurrentOwners = @()
            }
            $ownersDiff = Compare-Object -ReferenceObject $backCurrentOwners -DifferenceObject $desiredOwnersValue
            foreach ($diff in $ownersDiff)
            {
                $directoryObject = Get-MgUser -UserId $diff.InputObject -ErrorAction SilentlyContinue
                if ($null -eq $directoryObject)
                {
                    Write-Verbose -Message "Trying to retrieve Service Principal {$($diff.InputObject)}"
                    $app = Get-MgApplication -Filter "DisplayName eq '$($diff.InputObject -replace "'", "''")'"
                    if ($null -ne $app)
                    {
                        $directoryObject = Get-MgServicePrincipal -Filter "AppId eq '$($app.AppId)'"
                    }
                    else
                    {
                        $spInstances = Get-MgServicePrincipal -Filter "DisplayName eq '$($diff.InputObject -replace "'", "''")'"
                        if ($null -ne $spInstances -and $spInstances.Count -gt 1)
                        {
                            Throw "Duplicate Service Principals named '$($diff.InputObject)' exist in tenant"
                        }
                        elseif ($null -ne $spInstances -and $spInstances.Count -eq 1)
                        {
                            $directoryObject = $spInstances
                        }
                    }
                }
                if ($diff.SideIndicator -eq '=>')
                {
                    Write-Verbose -Message "Adding new owner {$($diff.InputObject)} to AAD Group {$($currentGroup.DisplayName)}"
                    $ownerObject = @{
                        '@odata.id' = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "v1.0/directoryObjects/{$($directoryObject.Id)}"
                    }
                    try
                    {
                        New-MgGroupOwnerByRef -GroupId ($currentGroup.Id) -BodyParameter $ownerObject -ErrorAction Stop | Out-Null
                    }
                    catch
                    {
                        if ($_.Exception.Message -notlike '*One or more added object references already exist for the following modified properties*')
                        {
                            throw $_
                        }
                    }
                }
                elseif ($diff.SideIndicator -eq '<=')
                {
                    Write-Verbose -Message "Removing new owner {$($diff.InputObject)} to AAD Group {$($currentGroup.DisplayName)}"
                    Remove-MgGroupOwnerDirectoryObjectByRef -GroupId ($currentGroup.Id) -DirectoryObjectId ($directoryObject.Id) | Out-Null
                }
            }

        }

        #Members
        Write-Verbose -Message 'Updating Members'
        if ($MembershipRuleProcessingState -ne 'On' -and $PSBoundParameters.ContainsKey('Members'))
        {
            $desiredMembersValue = @()
            if ($Members.Length -ne 0)
            {
                $desiredMembersValue = $Members
            }
            if ($null -eq $backCurrentMembers)
            {
                $backCurrentMembers = @()
            }
            Write-Verbose -Message 'Comparing current members and desired list'
            $membersDiff = Compare-Object -ReferenceObject $backCurrentMembers -DifferenceObject $desiredMembersValue
            foreach ($diff in $membersDiff)
            {
                Write-Verbose -Message "Found difference for member {$($diff.InputObject)}"
                $directoryObject = Get-MgUser -UserId $diff.InputObject -ErrorAction SilentlyContinue

                if ($null -eq $directoryObject)
                {
                    Write-Verbose -Message "Trying to retrieve Service Principal {$($diff.InputObject)}"
                    $app = Get-MgApplication -Filter "DisplayName eq '$($diff.InputObject -replace "'", "''")'"
                    if ($null -ne $app)
                    {
                        $directoryObject = Get-MgServicePrincipal -Filter "AppId eq '$($app.AppId)'"
                    }
                    else
                    {
                        $spInstances = Get-MgServicePrincipal -Filter "DisplayName eq '$($diff.InputObject -replace "'", "''")'"
                        if ($null -ne $spInstances -and $spInstances.Count -gt 1)
                        {
                            Throw "Duplicate Service Principals named '$($diff.InputObject)' exist in tenant"
                        }
                        elseif ($null -ne $spInstances -and $spInstances.Count -eq 1)
                        {
                            $directoryObject = $spInstances
                        }
                    }
                }

                if ($null -eq $directoryObject)
                {
                    Write-Verbose -Message "Trying to retrieve Device {$($diff.InputObject)}"
                    $directoryObject = Get-MgDevice -Filter "DisplayName eq '$($diff.InputObject -replace "'", "''")'"
                }

                if ($diff.SideIndicator -eq '=>')
                {
                    Write-Verbose -Message "Adding new member {$($diff.InputObject)} to AAD Group {$($currentGroup.DisplayName)}"
                    $memberObject = @{
                        '@odata.id' = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "v1.0/directoryObjects/{$($directoryObject.Id)}"
                    }
                    New-MgGroupMemberByRef -GroupId ($currentGroup.Id) -BodyParameter $memberObject | Out-Null
                }
                elseif ($diff.SideIndicator -eq '<=')
                {
                    Write-Verbose -Message "Removing new member {$($diff.InputObject)} to AAD Group {$($currentGroup.DisplayName)}"
                    $memberObject = @{
                        '@odata.id' = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "v1.0/directoryObjects/{$($directoryObject.Id)}"
                    }
                    Remove-MgGroupMemberDirectoryObjectByRef -GroupId ($currentGroup.Id) -DirectoryObjectId ($directoryObject.Id) | Out-Null
                }
            }
        }
        elseif ($MembershipRuleProcessingState -eq 'On')
        {
            Write-Verbose -Message 'Ignoring membership since this is a dynamic group.'
        }

        #GroupAsMembers
        Write-Verbose -Message 'Updating GroupAsMembers'
        if ($MembershipRuleProcessingState -ne 'On' -and $PSBoundParameters.ContainsKey('GroupAsMembers'))
        {
            $desiredGroupAsMembersValue = @()
            if ($GroupAsMembers.Length -ne 0)
            {
                $desiredGroupAsMembersValue = $GroupAsMembers
            }
            if ($null -eq $backCurrentGroupAsMembers)
            {
                $backCurrentGroupAsMembers = @()
            }
            $groupAsMembersDiff = Compare-Object -ReferenceObject $backCurrentGroupAsMembers -DifferenceObject $desiredGroupAsMembersValue
            foreach ($diff in $groupAsMembersDiff)
            {
                try
                {
                    $groupAsMember = Get-MgBetaGroup -Filter "DisplayName eq '$($diff.InputObject -replace "'", "''")'" -ErrorAction SilentlyContinue
                }
                catch
                {
                    $groupAsMember = $null
                }
                if ($null -eq $groupAsMember)
                {
                    throw "Group '$($diff.InputObject)' does not exist"
                }
                else
                {
                    if ($diff.SideIndicator -eq '=>')
                    {
                        Write-Verbose -Message "Adding AAD group {$($groupAsMember.DisplayName)} as member of AAD group {$($currentGroup.DisplayName)}"
                        $groupAsMemberObject = @{
                            '@odata.id' = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "v1.0/directoryObjects/$($groupAsMember.Id)"
                        }
                        New-MgBetaGroupMemberByRef -GroupId ($currentGroup.Id) -Body $groupAsMemberObject | Out-Null
                    }
                    if ($diff.SideIndicator -eq '<=')
                    {
                        Write-Verbose -Message "Removing AAD Group {$($groupAsMember.DisplayName)} from AAD group {$($currentGroup.DisplayName)}"
                        Remove-MgBetaGroupMemberDirectoryObjectByRef -GroupId ($currentGroup.Id) -DirectoryObjectId ($groupAsMember.Id) | Out-Null
                    }
                }
            }
        }

        #MemberOf
        Write-Verbose -Message 'Updating MemberOf'
        if ($PSBoundParameters.ContainsKey('MemberOf'))
        {
            $desiredMemberOfValue = @()
            if ($MemberOf.Length -ne 0)
            {
                $desiredMemberOfValue = $MemberOf
            }
            if ($null -eq $backCurrentMemberOf)
            {
                $backCurrentMemberOf = @()
            }
            $memberOfDiff = Compare-Object -ReferenceObject $backCurrentMemberOf -DifferenceObject $desiredMemberOfValue
            foreach ($diff in $memberOfDiff)
            {
                try
                {
                    $memberOfGroup = Get-MgBetaGroup -Filter "DisplayName eq '$($diff.InputObject -replace "'", "''")'" -ErrorAction Stop
                }
                catch
                {
                    $memberOfGroup = $null
                }
                if ($null -eq $memberOfGroup)
                {
                    throw "Security-group or directory role '$($diff.InputObject)' does not exist"
                }
                else
                {
                    if ($diff.SideIndicator -eq '=>')
                    {
                        # see if memberOfGroup contains property SecurityEnabled (it can be true or false)
                        if ($memberOfGroup.psobject.Typenames -match 'Group')
                        {
                            Write-Verbose -Message "Adding AAD group {$($currentGroup.DisplayName)} as member of AAD group {$($memberOfGroup.DisplayName)}"
                            New-MgGroupMember -GroupId ($memberOfGroup.Id) -DirectoryObject ($currentGroup.Id) | Out-Null
                        }
                        else
                        {
                            Throw "Cannot add AAD group {$($currentGroup.DisplayName)} to {$($memberOfGroup.DisplayName)} as it is not a security-group"
                        }
                    }
                    elseif ($diff.SideIndicator -eq '<=')
                    {
                        if ($memberOfGroup.psobject.Typenames -match 'Group')
                        {
                            Write-Verbose -Message "Removing AAD Group {$($currentGroup.DisplayName)} from AAD group {$($memberOfGroup.DisplayName)}"
                            Remove-MgGroupMemberDirectoryObjectByRef -GroupId ($memberOfGroup.Id) -DirectoryObjectId ($currentGroup.Id) | Out-Null
                        }
                        else
                        {
                            Throw "Cannot remove AAD group {$($currentGroup.DisplayName)} from {$($memberOfGroup.DisplayName)} as it is not a security-group"
                        }
                    }
                }
            }
        }

        if ($currentGroup.IsAssignableToRole -eq $true -and $PSBoundParameters.ContainsKey('AssignedToRole'))
        {
            $desiredAssignedToRoleValue = @()
            if ($AssignedToRole.Length -ne 0)
            {
                $desiredAssignedToRoleValue = $AssignedToRole
            }
            if ($null -eq $backCurrentAssignedToRole)
            {
                $backCurrentAssignedToRole = @()
            }
            $assignedToRoleDiff = Compare-Object -ReferenceObject $backCurrentAssignedToRole -DifferenceObject $desiredAssignedToRoleValue
            foreach ($diff in $assignedToRoleDiff)
            {
                try
                {
                    $role = Get-MgBetaRoleManagementDirectoryRoleDefinition -Filter "DisplayName eq '$($diff.InputObject -replace "'", "''")'"
                }
                catch
                {
                    $role = $null
                }
                if ($null -eq $role)
                {
                    throw "Directory Role '$($diff.InputObject)' does not exist"
                }
                else
                {
                    if ($diff.SideIndicator -eq '=>')
                    {
                        Write-Verbose -Message "Assigning AAD group {$($currentGroup.DisplayName)} to Directory Role {$($diff.InputObject)}"
                        New-MgBetaRoleManagementDirectoryRoleAssignment -RoleDefinitionId $role.Id -PrincipalId $currentGroup.Id -DirectoryScopeId '/'
                    }
                    elseif ($diff.SideIndicator -eq '<=')
                    {
                        Write-Verbose -Message "Removing AAD group {$($currentGroup.DisplayName)} from Directory Role {$($role.DisplayName)}"
                        Write-Verbose "GroupId = $($currentGroup.Id)"
                        Write-Verbose "RoleDefinitionId = $($role.Id)"
                        $roleAssignment = Get-MgBetaRoleManagementDirectoryRoleAssignment -Filter "PrincipalId eq '$($currentGroup.Id)' and RoleDefinitionId eq '$($role.Id)'"
                        Remove-MgBetaRoleManagementDirectoryRoleAssignment -UnifiedRoleAssignmentId $roleAssignment.Id
                    }
                }
            }
        }

        # GroupLifecyclePolicies
        if ($PSBoundParameters.ContainsKey('GroupLifecyclePolicySelectedEnabled'))
        {
            if ($null -eq $Script:GroupLifecyclePolicy)
            {
                $Script:GroupLifecyclePolicy = Get-MgBetaGroupLifecyclePolicy
            }

            if ($Script:GroupLifecyclePolicy.ManagedGroupTypes -ne 'selected')
            {
                Write-Warning -Message "Cannot assign or remove group from lifecycle policy because the current mode is not 'Selected'."
                return
            }

            if (-not $currentGroup.MailEnabled)
            {
                Write-Warning -Message "Cannot assign or remove group from lifecycle policy because it is not a Microsoft 365 Group."
                return
            }

            if ($GroupLifecyclePolicySelectedEnabled -and -not $currentGroup.GroupLifecyclePolicySelectedEnabled)
            {
                Write-Verbose -Message "Enabling Group Lifecycle Policy for AAD group {$($currentGroup.DisplayName)}"
                Add-MgBetaGroupToLifecyclePolicy -GroupLifecyclePolicyId $Script:GroupLifecyclePolicy.Id -GroupId $currentGroup.Id
            }
            elseif (-not $GroupLifecyclePolicySelectedEnabled -and $currentGroup.GroupLifecyclePolicySelectedEnabled)
            {
                Write-Verbose -Message "Removing AAD group {$($currentGroup.DisplayName)} from Group Lifecycle Policy"
                Remove-MgBetaGroupFromLifecyclePolicy -GroupLifecyclePolicyId $Script:GroupLifecyclePolicy.Id -GroupId $currentGroup.Id
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
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $MailNickname,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $Owners,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $GroupAsMembers,

        [Parameter()]
        [System.String[]]
        $MemberOf,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $GroupLifecyclePolicySelectedEnabled,

        [Parameter()]
        [System.String[]]
        $GroupTypes,

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [ValidateSet('On', 'Paused')]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $SecurityEnabled,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $MailEnabled,

        [Parameter()]
        [System.Boolean]
        $IsAssignableToRole,

        [Parameter()]
        [System.String[]]
        $AssignedToRole,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'HiddenMembership')]
        [System.String]
        $Visibility,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AssignedLicenses,

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

    $postProcessingScript = {
        param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
        if ($DesiredValues.ContainsKey('GroupLifecyclePolicySelectedEnabled') -and -not $CurrentValues.MailEnabled)
        {
            Write-Verbose -Message "Removing 'GroupLifecyclePolicySelectedEnabled' from comparison because group is not a Microsoft 365 Group."
            $ValuesToCheck.Remove('GroupLifecyclePolicySelectedEnabled') | Out-Null
        }
        return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
    }

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
                                         -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
                                         -PostProcessing $postProcessingScript
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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

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
        $Script:ExportMode = $true
        $ExportParameters = @{
            Filter      = $Filter
            All         = [switch]$true
            ExpandProperty = 'members'
            ErrorAction = 'Stop'
        }

        # Define the list of attributes
        $attributesToCheck = @(
            'description',
            'displayName',
            'hasMembersWithLicenseErrors',
            'mail',
            'mailNickname',
            'onPremisesSecurityIdentifier',
            'onPremisesSyncEnabled',
            'preferredLanguage'
        )

        # Initialize a flag to indicate whether any attribute matches the condition
        $matchConditionFound = $false

        # Check each attribute in the list
        foreach ($attribute in $attributesToCheck)
        {
            if ($Filter -like "*$attribute eq null*")
            {
                $matchConditionFound = $true
                break
            }
        }

        # If any attribute matches, add parameters to $ExportParameters
        if ($matchConditionFound -or ($Filter -like '*endsWith*') -or ($Filter -like '*not*'))
        {
            $ExportParameters.Add('CountVariable', 'count')
            $ExportParameters.Add('ConsistencyLevel', 'eventual')
            $ExportParameters.Remove('ExpandProperty') | Out-Null
            $Script:requireGroupMemberFetching = $true
        }

        # Exclude Distribution Groups and mail enabled security groups from Exchange
        [array] $Script:exportedGroups = Get-MgBetaGroup @ExportParameters
        $Script:exportedGroups = $Script:exportedGroups | Where-Object -FilterScript {
            -not ($_.MailEnabled -and ($null -eq $_.GroupTypes -or $_.GroupTypes.Count -eq 0)) -and `
                -not ($_.MailEnabled -and $_.SecurityEnabled -and ($null -eq $_.GroupTypes -or $_.GroupTypes.Count -eq 0))
        } | Sort-Object -Property DisplayName

        $i = 1
        $dscContent = ''
        Write-M365DSCHost -Message "`r`n" -DeferWrite
        foreach ($group in $Script:exportedGroups)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($Script:exportedGroups.Count)] $($group.DisplayName)" -DeferWrite
            $Params = @{
                ApplicationSecret     = $ApplicationSecret
                DisplayName           = $group.DisplayName
                MailNickName          = $group.MailNickName
                SecurityEnabled       = $true
                MailEnabled           = $true
                Id                    = $group.Id
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                Credential            = $Credential
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $group
            $Results = Get-TargetResource @Params

            if ($null -ne $Results.AssignedLicenses)
            {
                $complexMapping = @(
                    @{
                        Name            = 'AssignedLicenses'
                        CimInstanceName = 'AADGroupLicense'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.AssignedLicenses `
                    -CIMInstanceName 'AADGroupLicense' `
                    -ComplexTypeMapping $complexMapping

                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.AssignedLicenses = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AssignedLicenses') | Out-Null
                }
            }
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('AssignedLicenses')
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName

            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

function Get-M365DSCAzureADGroupLicenses
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory = $true)]
        $AssignedLicenses
    )

    $returnValue = @()
    if ($null -eq $Script:SubscribedSkus)
    {
        $Script:SubscribedSkus = Get-MgBetaSubscribedSku
    }

    # Create complete list of all Service Plans
    $allServicePlans = @()
    Write-Verbose -Message 'Getting all Service Plans'
    foreach ($sku in $Script:SubscribedSkus)
    {
        foreach ($serviceplan in $sku.ServicePlans)
        {
            if ($allServicePlans.Length -eq 0 -or -not $allServicePlans.ServicePlanName.Contains($servicePlan.ServicePlanName))
            {
                $allServicePlans += @{
                    ServicePlanId   = $serviceplan.ServicePlanId
                    ServicePlanName = $serviceplan.ServicePlanName
                }
            }
        }
    }

    foreach ($assignedLicense in $AssignedLicenses)
    {
        $skuPartNumber = $Script:SubscribedSkus.Where({ $_.SkuId -eq $assignedLicense.SkuId })
        $disabledPlansValues = @()
        foreach ($plan in $assignedLicense.DisabledPlans)
        {
            $foundItem = $allServicePlans | Where-Object -FilterScript { $_.ServicePlanId -eq $plan }
            $disabledPlansValues += $foundItem.ServicePlanName
        }
        $currentLicense = @{
            DisabledPlans = $disabledPlansValues
            SkuId         = $skuPartNumber.SkuPartNumber -replace [char]0xFEFF
        }
        $returnValue += $currentLicense
    }

    return $returnValue
}

function Get-M365DSCCombinedLicenses
{
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter()]
        [System.Object[]]
        $CurrentLicenses,

        [Parameter()]
        [System.Object[]]
        $DesiredLicenses
    )

    $result = @()
    if ($currentLicenses.Length -gt 0)
    {
        foreach ($license in $CurrentLicenses)
        {
            Write-Verbose -Message "Including Current $license"
            $result += @{
                SkuId         = $license.SkuId
                DisabledPlans = $license.DisabledPlans
            }
        }
    }

    if ($DesiredLicenses.Length -gt 0)
    {
        foreach ($license in $DesiredLicenses)
        {
            $licenseSkuId = $license.SkuId
            if ($result.Length -eq 0)
            {
                $result += @{
                    SkuId         = $licenseSkuId
                    DisabledPlans = $license.DisabledPlans
                }
            }
            else
            {
                if (-not $result.SkuId.Contains($licenseSkuId))
                {
                    $result += @{
                        SkuId         = $licenseSkuId
                        DisabledPlans = $license.DisabledPlans
                    }
                }
                else
                {
                    # Set the Desired Disabled Plans if the sku is already added to the list
                    foreach ($item in $result)
                    {
                        if ($item.SkuId -eq $licenseSkuId)
                        {
                            $item.DisabledPlans = $license.DisabledPlans
                        }
                    }
                }
            }
        }
    }

    return $result
}

Export-ModuleMember -Function *-TargetResource
