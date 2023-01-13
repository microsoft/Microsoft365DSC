function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [validateset('Public', 'HiddenMembership')]
        [System.String]
        $Visibility,

        [Parameter()]
        [validateset('Assigned', 'Dynamic')]
        [System.String]$MembershipType,

        [Parameter()]
        [System.String]$MembershipRule,

        [Parameter()]
        [validateset('Paused', 'On')]
        [System.String]$MembershipRuleProcessingState,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Members,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ScopedRoleMembers,

        <#
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Extensions,
        #>


        #endregion

        [Parameter(Mandatory = $true)]
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
        $ManagedIdentity
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters `
            -ProfileName 'v1.0'
    }
    catch
    {
        Write-Verbose -Message ($_)
    }

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
        $getValue = $null

        #region resource generator code
        if (-Not [string]::IsNullOrEmpty($Id))
        {
            $getValue = Get-MgDirectoryAdministrativeUnit -AdministrativeUnitId $Id -ErrorAction Stop
        }

        if (-not $getValue -and -Not [string]::IsNullOrEmpty($DisplayName))
        {
            $getValue = Get-MgDirectoryAdministrativeUnit -Filter "DisplayName eq '$DisplayName'" -ErrorAction Stop
        }
        #endregion


        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Nothing with id {$id} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found AU with id {$($getValue.id)}, DisplayName {$($getValue.DisplayName)}"

        $results = @{

            #region resource generator code
            Id                    = $getValue.Id
            Description           = $getValue.Description
            DisplayName           = $getValue.DisplayName
            Visibility            = $getValue.Visibility
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
        }
        if (-not [string]::IsNullOrEmpty($getValue.AdditionalProperties.membershipType))
        {
            # only include details about membership if values are present
            $results.Add('MembershipType', $getValue.AdditionalProperties.membershipType)
            $results.Add('MembershipRule', $getValue.AdditionalProperties.membershipRule)
            $results.Add('MembershipRuleProcessingState', $getValue.AdditionalProperties.membershipRuleProcessingState)
        }

        $memberSpec = $null
        if ($getValue.AdditionalProperties.MembershipType -ne 'Dynamic')
        {
            $auMembers = Get-MgDirectoryAdministrativeUnitMember -AdministrativeUnitId $getValue.Id -All
            if ($auMembers)
            {
                $memberSpec = @()
            }
            foreach ($getMember in $auMembers)
            {
                # get object regardless of type
                $memberObject = Invoke-MgGraphRequest -Method Get -Uri "https://graph.microsoft.com/v1.0/directoryObjects/$($getMember.Id)"
                switch -regex ([regex]::Escape($memberObject.'@odata.type'))
                {
                    'group'
                    {
                        $memberSpec += @{
                            Identity = $memberObject.DisplayName
                            Type     = 'Group'
                        }
                    }
                    'user'
                    {
                        $memberSpec += @{
                            Identity = $memberObject.UserPrincipalName
                            Type     = 'User'
                        }
                    }
                    'device'
                    {
                        $memberSpec += @{
                            Identity = $memberObject.DisplayName
                            Type     = 'Device'
                        }
                    }
                }
            }
            $results.Add('Members', $memberSpec)
        }

        $scopedRoleMemberSpec = $null
        $auScopedRoleMembers = Get-MgDirectoryAdministrativeUnitScopedRoleMember -AdministrativeUnitId $getValue.Id -All
        if ($auScopedRoleMembers)
        {
            $scopedRoleMemberSpec = @()
            foreach ($getMember in $auScopedRoleMembers)
            {
                $roleObject = Get-MgDirectoryRole -DirectoryRoleId $getMember.RoleId
                # get object regardless of type
                $roleMemberObject = Invoke-MgGraphRequest -Method Get -Uri "https://graph.microsoft.com/v1.0/directoryObjects/$($getMember.RoleMemberInfo.Id)"
                if ([regex]::Escape($roleMemberObject.'@odata.type') -match 'user')
                {
                    $memberType = 'User'
                    $memberIdentity = $roleMemberObject.UserPrincipalName
                }
                else
                {
                    if ([regex]::Escape($roleMemberObject.'@odata.type') -match 'group')
                    {
                        $memberType = 'Group'
                    }
                    else
                    {
                        $memberType = 'ServicePrincipal'
                    }
                    $memberIdentity = $roleMemberObject.DisplayName
                }
                $scopedRoleMemberInfo = @{
                    RoleName       = $roleObject.DisplayName
                    RoleMemberInfo = @{
                        Identity = $memberIdentity
                        Type     = $memberType
                    }
                }
                $scopedRoleMemberSpec += $scopedRoleMemberInfo
            }
        }
        $results.Add('ScopedRoleMembers', $scopedRoleMemberSpec)

        <#
        # Extensions are still too unwieldy
        $auExtensions = Get-MgDirectoryAdministrativeUnitExtension -AdministrativeUnitId $getValue.Id -All
        $extensionsSpec = $null
        if ($auExtensions)
        {
            $extensionsSpec = @()
            $extensionDef = @{Id = $auExtensions.Id}
            foreach ($auExtension in $auExtensions)
            {
                if ($auExtension.Properties -and $auExtension.Properties.Count % 2 -ne 0)
                {
                    throw "AU {$($getValue.DisplayName)] has extension {$($auExtension.Id)} with properties without values"
                }
                # address MSFT_KeyValuePair as an array containing key1,value1,key2,value2 etc
                # see https://forums.powershell.org/t/hashtable-as-resource-parameter/2962/3
                # and https://learn.microsoft.com/en-us/answers/questions/440415/passing-a-key-value-pair-list-to-a-powershell-scri.html
                for ($p = 0; $p -lt $auExtension.Properties.Count; $p = $p + 2)
                {
                    $extensionDef.Add($auExtension.Properties[$p], $auExtension.Properties[$p+1])
                }
            }
            $extensionsSpec += $extensionDef
        }
        $results.Add("Extensions", $extensionsSpec)
        #>
        return [System.Collections.Hashtable]$results
    }
    catch
    {
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [validateset('Public', 'HiddenMembership')]
        [System.String]
        $Visibility,

        [Parameter()]
        [validateset('Assigned', 'Dynamic')]
        [System.String]$MembershipType,

        [Parameter()]
        [System.String]$MembershipRule,

        [Parameter()]
        [validateset('Paused', 'On')]
        [System.String]$MembershipRuleProcessingState,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Members,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ScopedRoleMembers,

        <#
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Extensions,
        #>


        #endregion

        [Parameter(Mandatory = $true)]
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
        $ManagedIdentity
    )

    # Note: Graph names basic cmdlets xxx-MgDirectoryAdministrativeUnit(xxx)
    # but the beta profile names latest cmdlets xxx-MgDirectoryAdministrativeUnit(xxx)
    # ONLY the beta cmdlets support the preview enabling MembershipType and MembershipRuleProcessingState
    # NB: Usage of these params require that the corresponding AAD preview feature is enabled

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters `
            -ProfileName 'v1.0'
    }
    catch
    {
        Write-Verbose -Message $_
    }

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

    $currentParameters = ([hashtable]$PSBoundParameters).Clone()
    $currentParameters.Remove('Ensure') | Out-Null
    $currentParameters.Remove('Credential') | Out-Null
    $currentParameters.Remove('ApplicationId') | Out-Null
    $currentParameters.Remove('ApplicationSecret') | Out-Null
    $currentParameters.Remove('TenantId') | Out-Null
    $currentParameters.Remove('CertificateThumbprint') | Out-Null
    $currentParameters.Remove('ManagedIdentity') | Out-Null

    $backCurrentMembers = $currentInstance.Members
    $backCurrentScopedRoleMembers = $currentInstance.ScopedRoleMembers
    #$backCurrentExtensions        = $currentInstance.Extensions
    $currentInstance.Remove('Members') | Out-Null
    $currentInstance.Remove('ScopedRoleMembers') | Out-Null

    if ($MembershipType -eq 'Dynamic' -and $Members)
    {
        throw "AU {$($DisplayName)}: Members is not allowed when MembershipType is Dynamic"
    }

    if ($Ensure -eq 'Present')
    {
        $CreateParameters = $currentParameters.Clone()

        <# When using -BodyParameter it is not necessary to use AdditionalProperties for Dynamic AU params
        if ($CreateParameters.Containskey('MembershipType') -or $CreateParameters.Containskey('MembershipRule') -or $CreateParameters.Containskey('MembershipRuleProcessingState'))
        {
            $CreateParameters.Remove('MembershipType') | Out-Null
            $CreateParameters.Remove('MembershipRule') | Out-Null
            $CreateParameters.Remove('MembershipRuleProcessingState') | Out-Null
            $CreateParameters.Add('AdditionalProperties', @{})
            if (-not [System.String]::IsNullOrEmpty($MembershipType))
            {
                $CreateParameters.AdditionalProperties.Add('MembershipType', $MembershipType)
            }
            if (-not [System.String]::IsNullOrEmpty($MembershipType))
            {
                $CreateParameters.AdditionalProperties.Add('MembershipRule', $MembershipRule)
            }
            if (-not [System.String]::IsNullOrEmpty($MembershipRuleProcessingState))
            {
                $CreateParameters.AdditionalProperties.Add('MembershipRuleProcessingState', $MembershipRuleProcessingState)
            }
        }
        #>

        foreach ($key in ($CreateParameters.clone()).Keys)
        {
            if ($CreateParameters[$key].getType().Fullname -like '*CimInstance*')
            {
                $CreateParameters[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters[$key]
            }
        }

        # Resolve Members Type/Identity to user or group id
        if ($currentParameters.Members)
        {
            $memberSpecification = @()
            foreach ($Member in $Members)
            {
                if ($Member.Type -eq 'User')
                {
                    $memberIdentity = Get-MgUser -Filter "UserPrincipalName eq '$($Member.Identity)'" -ErrorAction Stop
                    if ($memberIdentity)
                    {
                        $memberSpecification += @{Type="$($Member.Type)s";Id = $memberIdentity.Id }
                    }
                    else
                    {
                        throw "AU {$($DisplayName)}: User {$($Member.Identity)} does not exist"
                    }
                }
                elseif ($Member.Type -eq 'Group')
                {
                    $memberIdentity = Get-MgGroup -Filter "DisplayName eq '$($Member.Identity)'" -ErrorAction Stop
                    if ($memberIdentity)
                    {
                        $memberSpecification += @{Type="$($Member.Type)s";Id = $memberIdentity.Id }
                    }
                    else
                    {
                        throw "AU {$($DisplayName)}: Group {$($Member.Identity)} does not exist"
                    }
                }
                elseif ($Member.Type -eq 'Device')
                {
                    $memberIdentity = Get-MgDevice -Filter "DisplayName eq '$($Member.Identity)'" -ErrorAction Stop
                    if ($memberIdentity)
                    {
                        $memberSpecification += @{Type="$($Member.Type)s";Id = $memberIdentity.Id }
                    }
                    else
                    {
                        throw "AU {$($DisplayName)}: Device {$($Member.Identity)} does not exist"
                    }
                }
                else
                {
                    throw "AU {$($DisplayName)}: Member {$($Member.Identity)} has invalid type {$($Member.Type)}"
                }
            }
            # Members are added to the AU *after* it has been created
            $CreateParameters.Remove('Members') | Out-Null
        }
        else
        {
            $CreateParameters.Remove('Members') | Out-Null
        }

        # Resolve ScopedRoleMembers Type/Identity to user, group or service principal
        if ($currentParameters.ScopedRoleMembers)
        {
            $scopedRoleMemberSpecification = @()
            foreach ($roleMember in $ScopedRoleMembers)
            {
                $roleObject = Get-MgDirectoryRole -Filter "DisplayName eq '$($roleMember.RoleName)'" -ErrorAction stop
                if ($null -eq $roleObject)
                {
                    throw "AU {$($DisplayName)}: RoleName {$($roleMember.RoleName)} does not exist or is not enabled"
                }
                if ($roleMember.RoleMemberInfo.Type -eq 'User')
                {
                    $roleMemberIdentity = Get-MgUser -Filter "UserPrincipalName eq '$($roleMember.RoleMemberInfo.Identity)'" -ErrorAction Stop
                    if ($null -eq $roleMemberIdentity)
                    {
                        throw "AU {$($DisplayName)}:  Scoped Role User {$($roleMember.RoleMemberInfo.Identity)} does not exist"
                    }
                }
                elseif ($roleMember.RoleMemberInfo.Type -eq 'Group')
                {
                    $roleMemberIdentity = Get-MgGroup -Filter "displayName eq '$($roleMember.RoleMemberInfo.Identity)'" -ErrorAction Stop
                    if ($null -eq $roleMemberIdentity)
                    {
                        throw "AU {$($DisplayName)}: Scoped Role Group {$($roleMember.RoleMemberInfo.Identity)} does not exist"
                    }
                }
                elseif ($roleMember.RoleMemberInfo.Type -eq 'ServicePrincipal')
                {
                    $roleMemberIdentity = Get-MgServicePrincipal -Filter "displayName eq '$($roleMember.RoleMemberInfo.Identity)'" -ErrorAction Stop
                    if ($null -eq $roleMemberIdentity)
                    {
                        throw "AU {$($DisplayName)}: Scoped Role ServicePrincipal {$($roleMember.RoleMemberInfo.Identity)} does not exist"
                    }
                }
                else
                {
                    throw "AU {$($DisplayName)}: Invalid ScopedRoleMember.RoleMemberInfo.Type {$($roleMember.RolememberInfo.Type)}"
                }
                $scopedRoleMemberSpecification += @{
                    RoleId         = $roleObject.Id
                    RoleMemberInfo = @{
                        Id = $roleMemberIdentity.Id
                    }
                }
            }
            #$CreateParameters.ScopedRoleMembers = $scopedRoleMemberSpecification
            # ScopedRoleMember-info is added after the AU is created
        }
        else
        {
            $CreateParameters.Remove('ScopedRoleMembers') | Out-Null
        }
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating AU {$DisplayName}"

        $CreateParameters = Rename-M365DSCCimInstanceODataParameter -Properties $CreateParameters

        $CreateParameters.Remove('Id') | Out-Null
        $CreateParameters.Remove('Verbose') | Out-Null

        foreach ($key in ($CreateParameters.clone()).Keys)
        {
            if ($CreateParameters[$key].getType().Fullname -like '*CimInstance*')
            {
                $CreateParameters[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters[$key]
            }
        }

        #region resource generator code
        $policy = New-MgDirectoryAdministrativeUnit -BodyParameter $CreateParameters

        #endregion
        foreach ($member in $memberSpecificationpecification)
        {
            $memberBodyParam = @{
                '@odata.id' = "https://graph.microsoft.com/v1.0/$($member.Type)/{$($member.Id)}"
            }

            New-MgDirectoryAdministrativeUnitMemberByRef -AdministrativeUnitId $policy.Id -BodyParameter $memberBodyParam
        }

        foreach ($scopedRoleMember in $scopedRoleMemberSpecification)
        {
            New-MgDirectoryAdministrativeUnitScopedRoleMember -AdministrativeUnitId $policy.Id -BodyParameter $scopedRoleMember
        }

    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating AU {$DisplayName}"

        $UpdateParameters = $currentParameters.Clone()
        $UpdateParameters = Rename-M365DSCCimInstanceODataParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null
        $UpdateParameters.Remove('Verbose') | Out-Null

        foreach ($key in ($UpdateParameters.clone()).Keys)
        {
            if ($UpdateParameters[$key].getType().Fullname -like '*CimInstance*')
            {
                $UpdateParameters[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters[$key]
            }
        }

        #$UpdateParameters.Remove('Extensions') | Out-Null
        $UpdateParameters.Remove('Members') | Out-Null
        $UpdateParameters.Remove('ScopedRoleMembers') | Out-Null
        #$UpdateParameters.Remove('Visibility') | Out-Null

        <# When using -BodyParameter it is not necessary to use AdditionalProperties for Dynamic AU params
        if ($UpdateParameters.Containskey('MembershipType') -or $UpdateParameters.Containskey('MembershipRule') -or $UpdateParameters.Containskey('MembershipRuleProcessingState'))
        {
            $UpdateParameters.Remove('MembershipType') | Out-Null
            $UpdateParameters.Remove('MembershipRule') | Out-Null
            $UpdateParameters.Remove('MembershipRuleProcessingState') | Out-Null
            $UpdateParameters.Add('AdditionalProperties', @{})
            if (-not [System.String]::IsNullOrEmpty($MembershipType))
            {
                $UpdateParameters.AdditionalProperties.Add('MembershipType', $MembershipType)
            }
            if (-not [System.String]::IsNullOrEmpty($MembershipType))
            {
                $UpdateParameters.AdditionalProperties.Add('MembershipRule', $MembershipRule)
            }
            if (-not [System.String]::IsNullOrEmpty($MembershipRuleProcessingState))
            {
                $UpdateParameters.AdditionalProperties.Add('MembershipRuleProcessingState', $MembershipRuleProcessingState)
            }
        }
        #>

        # when updating the resource, update the AU first and its members (if any) afterwards.
        # The AU MembershipType may have changed from Dynamic to Static and that change has to be implemented before explicitly adding members

        #region resource generator code
        Update-MgDirectoryAdministrativeUnit -BodyParameter $UpdateParameters `
            -AdministrativeUnitId $currentInstance.Id

        #endregion

        if ($MembershipType -ne 'Dynamic' -and ($Members -or $backCurrentMembers))
        {
            $currentMembersValue = @()
            if ($currentInstance.Members.Length -ne 0)
            {
                $currentMembersValue = $backCurrentMembers
            }
            if ($null -eq $currentMembersValue)
            {
                $currentMembersValue = @()
            }
            $desiredMembersValue = $Members
            if ($null -eq $desiredMembersValue)
            {
                $desiredMembersValue = @()
            }
            $membersDiff = Compare-Object -ReferenceObject $currentMembersValue -DifferenceObject $desiredMembersValue -Property Identity, Type
            foreach ($diff in $membersDiff)
            {
                if ($diff.Type -eq 'User')
                {
                    $memberObject = Get-MgUser -Filter "UserPrincipalName eq '$($diff.Identity)'"
                    $memberType = 'users'
                }
                elseif ($diff.Type -eq 'Group')
                {
                    $memberObject = Get-MgGroup -Filter "DisplayName eq '$($diff.Identity)'"
                    $membertype = 'groups'
                }
                elseif ($diff.Type -eq 'Device')
                {
                    $memberObject = Get-MgDevice -Filter "DisplayName eq '$($diff.Identity)'"
                    $membertype = 'devices'
                } else {
                    # throw if a *new* member has been specified with invalid type
                    throw "AU {$($DisplayName)}: Member {$($diff.Identity)} has invalid type {$($diff.Type)}"
                }
                if ($null -eq $memberObject)
                {
                    throw "AU member {$($diff.Identity)} does not exist as a $($diff.Type)"
                }
                if ($memberObject.Count -gt 1)
                {
                    throw "AU member {$($diff.Identity)} is not a unique $($diff.Type.ToLower()) (Count=$($memberObject.Count))"
                }
                if ($diff.SideIndicator -eq '=>')
                {
                    Write-Verbose -Message "Adding new member {$($diff.Identity)}, type {$($diff.Type)} to Administrative Unit {$($currentInstance.DisplayName)}"

                    $memberBodyParam = @{
                        '@odata.id' = "https://graph.microsoft.com/v1.0/$memberType/{$($memberObject.Id)}"
                    }
                    New-MgDirectoryAdministrativeUnitMemberByRef -AdministrativeUnitId ($currentInstance.Id) -BodyParameter $memberBodyParam | Out-Null
                }
                elseif ($diff.SideIndicator -eq '<=')
                {
                    Write-Verbose -Message "Removing member {$($diff.Identity)}, type {$($diff.Type)} from Administrative UNit {$($currentInstance.DisplayName)}"
                    Remove-MgDirectoryAdministrativeUnitMemberByRef -AdministrativeUnitId ($currentInstance.Id) -DirectoryObjectId ($memberObject.Id) | Out-Null
                }
            }
        }

        <#
        if ($Extensions -or $backCurrentExtensions)
        {
            $currentExtensionsValue = @()
            if ($currentInstance.Extensions.Length -ne 0)
            {
                $currentExtensionsValue = $backCurrentExtensions
            }
            if ($null -eq $currentExtensionsValue)
            {
                $currentExtensionsValue = @()
            }
            $desiredExtensionsValue = $Extensions
            if ($null -eq $desiredExtensionsValue)
            {
                $desiredExtensionsValue = @()
            }
            $membersDiff = Compare-Object -ReferenceObject $currentExtensionsValue -DifferenceObject $desiredExtensionsValue -Property Id
            foreach ($diff in $membersDiff)
            {
                if ($diff.SideIndicator -eq '=>')
                {
                    Write-Verbose -Message "Adding new extension {$($diff.InputObject.Id)} to Administrative Unit {$($currentInstance.DisplayName)}"
                    $additionalPropertiesArg = @{}
                    if ($diff.InputObject.Properties.Count -gt 0)
                    {
                        $additionalPropertiesArg.AdditionalProperties = @{}
                        for ($p = 0; $p -lt $diff.InputObject.Properties.Count; $p = $p + 1)
                        {
                            $additionalPropertiesArg.AdditionalProperties.Add($diff.InputObject.Properties[$p], $diff.InputObject.Properties[$p+1])
                        }
                    }
                    New-MgDirectoryAdministrativeUnitExtension -AdministrativeUnitId ($currentInstance.Id) @additionalPropertiesArg -BodyParameter @{ExtensionId = $diff.InputObject.Id} | Out-Null
                }
                elseif ($diff.SideIndicator -eq '<=')
                {
                    Write-Verbose -Message "Removing extension {$($diff.InputObject.Id)} from Administrative Unit {$($currentInstance.DisplayName)}"
                    Remove-MgDirectoryAdministrativeUnitExtension -AdministrativeUnitId ($currentInstance.Id) -ExtensionId ($diff.InputObject.Id) | Out-Null
                }
                else
                {
                    #update AU Extension to use specified Properties only
                    $additionalPropertiesArg = @{}
                    if ($diff.InputObject.Properties.Count -gt 0)
                    {
                        $additionalPropertiesArg.AdditionalProperties = @{}
                        for ($p = 0; $p -lt $diff.InputObject.Properties.Count; $p = $p + 1)
                        {
                            $additionalPropertiesArg.AdditionalProperties.Add($diff.InputObject.Properties[$p], $diff.InputObject.Properties[$p+1])
                        }
                    }
                    Update-MgDirectoryAdministrativeUnitExtension -AdministrativeUnitId ($currentInstance.Id) -ExtensionId $diff.InputObject.Id @additionalPropertiesArg
                }
            }
        }
        #>

        if ($ScopedRoleMembers -or $backCurrentScopedRoleMembers)
        {
            $currentScopedRoleMembersValue = @()
            if ($currentInstance.ScopedRoleMembers.Length -ne 0)
            {
                $currentScopedRoleMembersValue = $backCurrentScopedRoleMembers
            }
            if ($null -eq $currentScopedRoleMembersValue)
            {
                $currentScopedRoleMembersValue = @()
            }
            $desiredScopedRoleMembersValue = $ScopedRoleMembers
            if ($null -eq $desiredScopedRoleMembersValue)
            {
                $desiredScopedRoleMembersValue = @()
            }
            # flatten objects to compare:
            $compareCurrentScopedRoleMembersValue = @()
            foreach ($roleMember in $currentScopedRoleMembersValue)
            {
                $compareCurrentScopedRoleMembersValue += [pscustomobject]@{
                    RoleName = $roleMember.RoleName
                    Identity = $roleMember.RoleMemberInfo.Identity
                    Type     = $roleMember.RoleMemberInfo.Type
                }
            }
            $compareDesiredScopedRoleMembersValue = @()
            foreach ($roleMember in $desiredScopedRoleMembersValue)
            {
                $compareDesiredScopedRoleMembersValue += [pscustomobject]@{
                    RoleName = $roleMember.RoleName
                    Identity = $roleMember.RoleMemberInfo.Identity
                    Type     = $roleMember.RoleMemberInfo.Type
                }
            }
            $scopedRoleMembersDiff = Compare-Object -ReferenceObject $compareCurrentScopedRoleMembersValue -DifferenceObject $compareDesiredScopedRoleMembersValue -Property RoleName, Identity, Type
            foreach ($diff in $scopedRoleMembersDiff)
            {
                if ($diff.Type -eq 'User')
                {
                    $memberObject = Get-MgUser -Filter "UserPrincipalName eq '$($diff.Identity)'"
                    $memberType = 'users'
                }
                else
                {
                    $memberObject = Get-MgGroup -Filter "DisplayName eq '$($diff.Identity)'"
                    $membertype = 'groups'
                }
                if ($null -eq $memberobject)
                {
                    throw "AU scoped role member {$($diff.Identity)} does not exist as a $(diff.Type)"
                }
                if ($memberobject.Count -gt 1)
                {
                    throw "AU scoped role member {$($diff.Identity)} is not a unique $($diff.Type)"
                }
                if ($diff.SideIndicator -ne '==')
                {
                    $roleObject = Get-MgDirectoryRole -Filter "DisplayName -eq '$($diff.RoleName)"
                    if ($null -eq $roleObject)
                    {
                        throw "AU Scoped Role {$($diff.RoleName)} does not exist as an Azure AD role"
                    }
                }
                if ($diff.SideIndicator -eq '=>')
                {
                    Write-Verbose -Message "Adding new scoped role {$($diff.RoleName)} member {$($diff.Identity)}, type {$($diff.Type)} to Administrative Unit {$($currentInstance.DisplayName)}"

                    $scopedRoleMemberParam = @{
                        RoleId         = $roleObject.Id
                        RoleMemberInfo = @{
                            Id = $memberObject.Id
                        }
                    }
                    # addition of scoped rolemember may throw if role is not supported as a scoped role
                    New-MgDirectoryAdministrativeUnitScopedRoleMember -AdministrativeUnitId ($currentInstance.Id) -BodyParameter $scopedRoleMemberParam -ErrorAction Stop | Out-Null
                }
                elseif ($diff.SideIndicator -eq '<=')
                {
                    Write-Verbose -Message "Removing scoped role {$($diff.RoleName)} member {$($diff.Identity)}, type {$($diff.Type)} from Administrative Unit {$($currentInstance.DisplayName)}"
                    $scopedRoleMemberObject = Get-MgDirectoryAdministrativeUnitScopedRoleMember -AdministrativeUnitId ($currentInstance.Id) -All | Where-Object -FilterScript { $_.RoleId -eq $roleObject.Id -and $_.RoleMemberInfo.Id -eq $memberObject.Id }
                    Remove-MgDirectoryAdministrativeUnitScopedRoleMember -AdministrativeUnitId ($currentInstance.Id) -ScopedRoleMembershipId $scopedRoleMemberObject.Id | Out-Null
                }
            }
        }

    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AU {$DisplayName}"


        #region resource generator code
        #endregion



        #region resource generator code
        Remove-MgDirectoryAdministrativeUnit -AdministrativeUnitId $currentInstance.Id
        #endregion

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

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [validateset('Public', 'HiddenMembership')]
        [System.String]
        $Visibility,

        [Parameter()]
        [validateset('Assigned', 'Dynamic')]
        [System.String]$MembershipType,

        [Parameter()]
        [System.String]$MembershipRule,

        [Parameter()]
        [validateset('Paused', 'On')]
        [System.String]$MembershipRuleProcessingState,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Members,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ScopedRoleMembers,

        <#
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Extensions,
        #>

        [Parameter(Mandatory = $true)]
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
        $ManagedIdentity
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

    Write-Verbose -Message "Testing configuration of {$id}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }

    $testResult = $true

    foreach ($key in $PSBoundParameters.Keys)
    {
        if ($PSBoundParameters[$key].getType().Name -like '*CimInstance*')
        {
            $CIMArraySource = @()
            $CIMArrayTarget = @()
            $CIMArraySource += $PSBoundParameters[$key]
            if ($CurrentValues.$key)
            {
                $CIMArrayTarget += $CurrentValues.$key
            }
            if ($CIMArraySource.count -ne $CIMArrayTarget.count)
            {
                Write-Verbose -Message "Configuration drift:Number of items does not match: Source=$($CIMArraySource.count) Target=$($CIMArrayTarget.count)"
                $testResult = $false
                break
            }
            $i = 0
            foreach ($item in $CIMArraySource )
            {
                $testResult = Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $CIMArraySource[$i]) `
                    -Target ($CIMArrayTarget[$i])

                $i++
                if (-Not $testResult)
                {
                    $testResult = $false
                    break
                }
            }
            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
    $ValuesToCheck.Remove('ManagedIdentity') | Out-Null

    # Removing the visibility parameter from the check since this is always being returned as null currently by the Microsoft Graph.
    $ValuesToCheck.Remove('Visibility') | Out-Null

    if ($MembershipType -ne 'Dynamic' -and $CurrentValues.MembershipType -ne 'Dynamic')
    {
        # Removing the MembershipType parameter from the check if it isn't Dynamic. If so, it can be aither Assigned or null
        $ValuesToCheck.Remove('MembershipType') | Out-Null
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    #Convert any DateTime to String
    foreach ($key in $ValuesToCheck.Keys)
    {
        if (($null -ne $CurrentValues[$key]) `
                -and ($CurrentValues[$key].getType().Name -eq 'DateTime'))
        {
            $CurrentValues[$key] = $CurrentValues[$key].toString()
        }
    }

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

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
        $ManagedIdentity
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'
    $context = Get-MgContext
    if ($null -eq $context)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters -ProfileName 'beta'
    }

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
        [array]$getValue = Get-MgAdministrativeUnit -All `
            -ErrorAction Stop

        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $getValue)
        {
            Write-Host "    |---[$i/$($getValue.Count)] $($config.DisplayName)" -NoNewline
            $params = @{
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            if ($Results.Members)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Members -CIMInstanceName MicrosoftGraphIdentity
                if ($complexTypeStringResult)
                {
                    $Results.Members = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Members') | Out-Null
                }
            }
            if ($Results.ScopedRoleMembers)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.ScopedRoleMembers -CIMInstanceName MicrosoftGraphscopedrolemembership
                if ($complexTypeStringResult)
                {
                    $Results.ScopedRoleMembers = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ScopedRoleMembers') | Out-Null
                }
            }
            <#
            if ($Results.Extensions)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Extensions -CIMInstanceName    MicrosoftGraphextension
                if ($complexTypeStringResult)
                {
                    $Results.Extensions = $complexTypeStringResult            }
                else
                {
                    $Results.Remove('Extensions') | Out-Null
                }
            }
            #>
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            if ($Results.Members)
            {
                $isCIMArray = $false
                if ($Results.Members.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Members' -IsCIMArray:$isCIMArray
                $currentDSCBlock = $currentDSCBlock.Replace('}");', '});')
            }
            if ($Results.ScopedRoleMembers)
            {
                $isCIMArray = $false
                if ($Results.ScopedRoleMembers.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'ScopedRoleMembers'   -IsCIMArray:$isCIMArray
            }
            if ($Results.Extensions)
            {
                $isCIMArray = $false
                if ($Results.Extensions.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Extensions' -IsCIMArray:$isCIMArray
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


function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter()]
        $ComplexObject
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    if ($ComplexObject.GetType().FullName -like '*[[\]]')
    {
        $results = @()

        foreach ($item in $ComplexObject)
        {
            if ($item)
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                $results += $hash
            }
        }
        if ($results.Count -eq 0)
        {
            return $null
        }
        return $results
    }

    $results = @{}
    $keys = $ComplexObject | Get-Member | Where-Object -FilterScript { $_.MemberType -eq 'Property' -and $_.Name -ne 'AdditionalProperties' }

    foreach ($key in $keys)
    {
        if ($ComplexObject.$($key.Name))
        {
            $results.Add($key.Name, $ComplexObject.$($key.Name))
        }
    }
    if ($results.count -eq 0)
    {
        return $null
    }
    return $results
}

function Get-M365DSCDRGComplexTypeToString
{
    [CmdletBinding()]
    #[OutputType([System.String])]
    param(
        [Parameter()]
        $ComplexObject,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CIMInstanceName,

        [Parameter()]
        [System.String]
        $Whitespace = '',

        [Parameter()]
        [switch]
        $isArray = $false
    )
    if ($null -eq $ComplexObject)
    {
        return $null
    }

    #If ComplexObject  is an Array
    if ($ComplexObject.GetType().FullName -like '*[[\]]')
    {
        $currentProperty = @()
        foreach ($item in $ComplexObject)
        {
            $currentProperty += Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $item `
                -isArray:$true `
                -CIMInstanceName $CIMInstanceName `
                -Whitespace '                '

        }
        if ([string]::IsNullOrEmpty($currentProperty))
        {
            return $null
        }
        return $currentProperty

    }

    #If ComplexObject is a single CIM Instance
    if (-Not (Test-M365DSCComplexObjectHasValues -ComplexObject $ComplexObject))
    {
        return $null
    }
    $currentProperty = ''
    if ($isArray)
    {
        $currentProperty += "`r`n"
    }
    $currentProperty += "$whitespace`MSFT_$CIMInstanceName{`r`n"
    $keyNotNull = 0
    foreach ($key in $ComplexObject.Keys)
    {
        if ($ComplexObject[$key])
        {
            $keyNotNull++

            if ($ComplexObject[$key].GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*')
            {
                $hashPropertyType = $ComplexObject[$key].GetType().Name.tolower()
                $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]

                if (Test-M365DSCComplexObjectHasValues -ComplexObject $hashProperty)
                {
                    $Whitespace += '            '
                    if (-not $isArray)
                    {
                        $currentProperty += '                ' + $key + ' = '
                    }
                    $currentProperty += Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $hashProperty `
                        -CIMInstanceName $hashPropertyType `
                        -Whitespace $Whitespace
                }
            }
            else
            {
                if (-not $isArray)
                {
                    $Whitespace = '            '
                }
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key] -Space ($Whitespace + '    ')
            }
        }
    }
    $currentProperty += '            }'

    if ($keyNotNull -eq 0)
    {
        $currentProperty = $null
    }

    return $currentProperty
}
function Test-M365DSCComplexObjectHasValues
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $ComplexObject
    )
    $keys = $ComplexObject.keys
    $hasValue = $false
    foreach ($key in $keys)
    {
        if ($ComplexObject[$key])
        {
            if ($ComplexObject[$key].GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*')
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                if (-Not $hash)
                {
                    return $false
                }
                $hasValue = Test-M365DSCComplexObjectHasValues -ComplexObject ($hash)
            }
            else
            {
                $hasValue = $true
                return $hasValue
            }
        }
    }
    return $hasValue
}
Function Get-M365DSCDRGSimpleObjectTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.String]
        $Key,

        [Parameter(Mandatory = 'true')]
        $Value,

        [Parameter()]
        [System.String]
        $Space = '                '

    )

    $returnValue = ''
    switch -Wildcard ($Value.GetType().Fullname )
    {
        '*.Boolean'
        {
            $returnValue = $Space + $Key + " = `$" + $Value.ToString() + "`r`n"
        }
        '*.String'
        {
            if ($key -eq '@odata.type')
            {
                $key = 'odataType'
            }
            $returnValue = $Space + $Key + " = '" + $Value + "'`r`n"
        }
        '*.DateTime'
        {
            $returnValue = $Space + $Key + " = '" + $Value + "'`r`n"
        }
        '*[[\]]'
        {
            $returnValue = $Space + $key + ' = @('
            $whitespace = ''
            $newline = ''
            if ($Value.Count -gt 1)
            {
                $returnValue += "`r`n"
                $whitespace = $Space + '    '
                $newline = "`r`n"
            }
            foreach ($item in $Value)
            {
                switch -Wildcard ($item.GetType().Fullname )
                {
                    '*.String'
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    '*.DateTime'
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    Default
                    {
                        $returnValue += "$whitespace$item$newline"
                    }
                }
            }
            if ($Value.Count -gt 1)
            {
                $returnValue += "$Space)`r`n"
            }
            else
            {
                $returnValue += ")`r`n"

            }
        }
        Default
        {
            $returnValue = $Space + $Key + ' = ' + $Value + "`r`n"
        }
    }
    return $returnValue
}

function Rename-M365DSCCimInstanceODataParameter
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )
    $CIMparameters = $Properties.GetEnumerator() | Where-Object -FilterScript { $_.Value.GetType().Fullname -like '*CimInstance*' }
    foreach ($CIMParam in $CIMparameters)
    {
        if ($CIMParam.Value.GetType().Fullname -like '*[[\]]')
        {
            $CIMvalues = @()
            foreach ($item in $CIMParam.Value)
            {
                $CIMHash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                $keys = ($CIMHash.Clone()).Keys
                if ($keys -contains 'odataType')
                {
                    $CIMHash.Add('@odata.type', $CIMHash.odataType)
                    $CIMHash.Remove('odataType')
                }
                $CIMvalues += $CIMHash
            }
            $Properties.($CIMParam.Key) = $CIMvalues
        }
        else
        {
            $CIMHash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $CIMParam.value
            $keys = ($CIMHash.Clone()).Keys
            if ($keys -contains 'odataType')
            {
                $CIMHash.Add('@odata.type', $CIMHash.odataType)
                $CIMHash.Remove('odataType')
                $Properties.($CIMParam.Key) = $CIMHash
            }
        }
    }
    return $Properties
}
function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter()]
        [System.Collections.Hashtable]
        $Source,
        [Parameter()]
        [System.Collections.Hashtable]
        $Target
    )

    $keys = $Source.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    foreach ($key in $keys)
    {
        Write-Verbose -Message "Comparing Source-key: {$key}"
        $skey = $key
        if ($key -eq 'odataType')
        {
            $skey = '@odata.type'
        }

        #Marking Target[key] to null if empty complex object or array
        if ($null -ne $Target[$key])
        {
            switch -Wildcard ($Target[$key].getType().Fullname )
            {
                'Microsoft.Graph.PowerShell.Models.*'
                {
                    $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Target[$key]
                    if (-not (Test-M365DSCComplexObjectHasValues -ComplexObject $hashProperty))
                    {
                        $Target[$key] = $null
                    }
                }
                '*[[\]]'
                {
                    if ($Target[$key].count -eq 0)
                    {
                        $Target[$key] = $null
                    }
                }
            }
        }
        $sourceValue = $Source[$key]
        $targetValue = $Target[$key]
        #One of the item is null
        if (($null -eq $Source[$skey]) -xor ($null -eq $Target[$key]))
        {
            if ($null -eq $Source[$skey])
            {
                $sourceValue = 'null'
            }

            if ($null -eq $Target[$key])
            {
                $targetValue = 'null'
            }
            Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
            return $false
        }
        #Both source and target aren't null or empty
        if (($null -ne $Source[$skey]) -and ($null -ne $Target[$key]))
        {
            if ($Source[$skey].getType().FullName -like '*CimInstance*' -or $Target[$skey].getType().FullName -like '*CimInstance*')
            {
                #Recursive call for complex object
                if ($Source[$skey].getType().FullName -like '*CimInstance*')
                {
                    $complexSourceValue = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source[$skey]
                }
                else
                {
                    $complexSourceValue = $Source[$key]
                }
                if ($Target[$skey].getType().FullName -like '*CimInstance*')
                {
                    $complexTargetValue = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Target[$key]
                }
                else
                {
                    $complexTargetValue = $Target[$key]
                }
                $compareResult = Compare-M365DSCComplexObject `
                    -Source $complexSourceValue `
                    -Target $complexTargetValue

                if (-not $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject = $Target[$key]
                $differenceObject = $Source[$skey]

                $compareResult = Compare-Object `
                    -ReferenceObject ($referenceObject) `
                    -DifferenceObject ($differenceObject)

                if ($null -ne $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
                    return $false
                }

            }
        }
    }

    return $true
}

function Convert-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = 'true')]
        $ComplexObject
    )

    if ($ComplexObject.getType().Fullname -like '*[[\]]')
    {
        $results = @()
        foreach ($item in $ComplexObject)
        {
            $hash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            if (Test-M365DSCComplexObjectHasValues -ComplexObject $hash)
            {
                $results += $hash
            }
        }
        if ($results.count -eq 0)
        {
            return $null
        }
        return $Results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject
    if ($hashComplexObject)
    {
        $results = $hashComplexObject.clone()
        $keys = $hashComplexObject.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
        foreach ($key in $keys)
        {
            if (($null -ne $hashComplexObject[$key]) -and ($hashComplexObject[$key].getType().Fullname -like '*CimInstance*'))
            {
                $results[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            if ($null -eq $results[$key])
            {
                $results.remove($key) | Out-Null
            }

        }
    }
    return $results
}

Export-ModuleMember -Function *-TargetResource
