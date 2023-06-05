function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [validateset('Public', 'HiddenMembership')]
        [System.String]
        $Visibility,

        [Parameter()]
        [validateset('Assigned', 'Dynamic')]
        [System.String]
        $MembershipType,

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [validateset('Paused', 'On')]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Members,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ScopedRoleMembers,
        #endregion

        [Parameter()]
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
        if (-not [string]::IsNullOrEmpty($Id))
        {
            $getValue = Get-MgDirectoryAdministrativeUnit -AdministrativeUnitId $Id -ErrorAction SilentlyContinue
        }

        if ($null -eq $getValue -and -not [string]::IsNullOrEmpty($DisplayName))
        {
            Write-Verbose -Message "Could not find an Azure AD Administrative Unit with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgDirectoryAdministrativeUnit -Filter "DisplayName eq '$DisplayName'" -ErrorAction Stop
            }
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Azure AD Administrative Unit with DisplayName {$DisplayName}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Azure AD Administrative Unit with Id {$Id} and DisplayName {$DisplayName} was found."
        $results = @{
            #region resource generator code
            Description           = $getValue.Description
            DisplayName           = $getValue.DisplayName
            Visibility            = $getValue.Visibility
            Id                    = $getValue.Id
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            Managedidentity       = $ManagedIdentity.IsPresent
            #endregion
        }

        if (-not [string]::IsNullOrEmpty($getValue.AdditionalProperties.MembershipType))
        {
            $results.Add('MembershipType', $getValue.AdditionalProperties.MembershipType)
        }
        if (-not [string]::IsNullOrEmpty($getValue.AdditionalProperties.MembershipRule))
        {
            $results.Add('MembershipRule', $getValue.AdditionalProperties.MembershipRule)
        }
        if (-not [string]::IsNullOrEmpty($getValue.AdditionalProperties.MembershipRuleProcessingState))
        {
            $results.Add('MembershipRuleProcessingState', $getValue.AdditionalProperties.MembershipRuleProcessingState)
        }

        Write-Verbose -Message "AU {$DisplayName} MembershipType {$($results.MembershipType)}"
        if ($results.MembershipType -ne 'Dynamic')
        {
            Write-Verbose -Message "AU {$DisplayName} get Members"
            [array]$auMembers = Get-MgDirectoryAdministrativeUnitMember -AdministrativeUnitId $getValue.Id -All
            if ($auMembers.Count -gt 0)
            {
                Write-Verbose -Message "AU {$DisplayName} process $($auMembers.Count) members"
                $memberSpec = @()
                foreach ($auMember in $auMembers)
                {
                    $member = @{}
                    $memberObject = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/directoryobjects/$($auMember.Id)"
                    if ($memberObject.'@odata.type' -match 'user')
                    {
                        $member.Add('Identity', $memberObject.UserPrincipalName)
                        $member.Add('Type', 'User')
                    }
                    elseif ($memberObject.'@odata.type' -match 'group')
                    {
                        $member.Add('Identity', $memberObject.DisplayName)
                        $member.Add('Type', 'Group')
                    }
                    else
                    {
                        $member.Add('Identity', $memberObject.DisplayName)
                        $member.Add('Type', 'Device')
                    }
                    Write-Verbose -Message "AU {$DisplayName} member found: Type '$($member.Type)' identity '$($member.Identity)'"
                    $memberSpec += $member
                }
                Write-Verbose -Message "AU {$DisplayName} add Members to results"
                $results.Add('Members', $memberSpec)
            }
        }

        Write-Verbose -Message "AU {$DisplayName} get Scoped Role Members"
        $ErrorActionPreference = 'Stop'
        [array]$auScopedRoleMembers = Get-MgDirectoryAdministrativeUnitScopedRoleMember -AdministrativeUnitId $getValue.Id -All
        if ($auScopedRoleMembers.Count -gt 0)
        {
            Write-Verbose -Message "AU {$DisplayName} process $($auScopedRoleMembers.Count) scoped role members"
            $scopedRoleMemberSpec = @()
            foreach ($auScopedRoleMember in $auScopedRoleMembers)
            {
                Write-Verbose -Message "AU {$DisplayName} verify RoleId {$($auScopedRoleMember.RoleId)}"
                $roleObject = Get-MgDirectoryRole -DirectoryRoleId $auScopedRoleMember.RoleId -ErrorAction Stop
                Write-Verbose -Message "Found DirectoryRole '$($roleObject.DisplayName)' with id $($roleObject.Id)"
                $scopedRoleMember = [ordered]@{
                    RoleName       = $roleObject.DisplayName
                    RoleMemberInfo = @{
                        Type     = $null
                        Identity = $null
                    }
                }
                Write-Verbose -Message "AU {$DisplayName} verify RoleMemberInfo.Id {$($auScopedRoleMember.RoleMemberInfo.Id)}"
                $memberObject = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/directoryobjects/$($auScopedRoleMember.RoleMemberInfo.Id)"
                Write-Verbose -Message "AU {$DisplayName} @odata.Type={$($memberObject.'@odata.type')}"
                if (($memberObject.'@odata.type') -match 'user')
                {
                    Write-Verbose -Message "AU {$DisplayName} UPN = {$($memberObject.UserPrincipalName)}"
                    $scopedRoleMember.RoleMemberInfo.Identity = $memberObject.UserPrincipalName
                    $scopedRoleMember.RoleMemberInfo.Type = 'User'
                }
                elseif (($memberObject.'@odata.type') -match 'group')
                {
                    Write-Verbose -Message "AU {$DisplayName} Group = {$($memberObject.DisplayName)}"
                    $scopedRoleMember.RoleMemberInfo.Identity = $memberObject.DisplayName
                    $scopedRoleMember.RoleMemberInfo.Type = 'Group'
                }
                else
                {
                    Write-Verbose -Message "AU {$DisplayName} SPN = {$($memberObject.DisplayName)}"
                    $scopedRoleMember.RoleMemberInfo.Identity = $memberObject.DisplayName
                    $scopedRoleMember.RoleMemberInfo.Type = 'ServicePrincipal'
                }
                Write-Verbose -Message "AU {$DisplayName} scoped role member: RoleName '$($scopedRoleMember.RoleName)' Type '$($scopedRoleMember.RoleMemberInfo.Type)' Identity '$($scopedRoleMember.RoleMemberInfo.Identity)'"
                $scopedRoleMemberSpec += $scopedRoleMember
            }
            Write-Verbose -Message "AU {$DisplayName} add $($scopedRoleMemberSpec.Count) ScopedRoleMembers to results"
            $results.Add('ScopedRoleMembers', $scopedRoleMemberSpec)
        }
        Write-Verbose -Message "AU {$DisplayName} return results"
        return [System.Collections.Hashtable] $results
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
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [validateset('Public', 'HiddenMembership')]
        [System.String]
        $Visibility,

        [Parameter()]
        [validateset('Assigned', 'Dynamic')]
        [System.String]
        $MembershipType,

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [validateset('Paused', 'On')]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Members,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ScopedRoleMembers,
        #endregion

        [Parameter()]
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

    $currentInstance = Get-TargetResource @PSBoundParameters

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('Verbose') | Out-Null

    $backCurrentMembers = $currentInstance.Members
    $backCurrentScopedRoleMembers = $currentInstance.ScopedRoleMembers

    if ($Ensure -eq 'Present')
    {
        if ($MembershipType -eq 'Dynamic' -and $Members.Count -gt 0)
        {
            throw "AU {$($DisplayName)}: Members is not allowed when MembershipType is Dynamic"
        }
        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$CreateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $CreateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
            }
        }
        $memberSpecification = $null
        if ($CreateParameters.MembershipType -ne 'Dynamic' -and $CreateParameters.Members.Count -gt 0)
        {
            $memberSpecification = @()
            Write-Verbose -Message "AU {$DisplayName} process $($CreateParameters.Members.Count) Members"
            foreach ($member in $CreateParameters.Members)
            {
                Write-Verbose -Message "AU {$DisplayName} member Type '$($member.Type)' Identity '$($member.Identity)'"
                if ($member.Type -eq 'User')
                {
                    $memberIdentity = Get-MgUser -Filter "UserPrincipalName eq '$($member.Identity)'" -ErrorAction Stop
                    if ($memberIdentity)
                    {
                        $memberSpecification += [pscustomobject]@{Type = "$($member.Type)s"; Id = $memberIdentity.Id }
                    }
                    else
                    {
                        throw "AU {$($DisplayName)}: User {$($member.Identity)} does not exist"
                    }
                }
                elseif ($member.Type -eq 'Group')
                {
                    $memberIdentity = Get-MgGroup -Filter "DisplayName eq '$($member.Identity)'" -ErrorAction Stop
                    if ($memberIdentity)
                    {
                        if ($memberIdentity.Count -gt 1)
                        {
                            throw "AU {$($DisplayName)}: Group displayname {$($member.Identity)} is not unique"
                        }
                        $memberSpecification += [pscustomobject]@{Type = "$($member.Type)s"; Id = $memberIdentity.Id }
                    }
                    else
                    {
                        throw "AU {$($DisplayName)}: Group {$($member.Identity)} does not exist"
                    }
                }
                elseif ($member.Type -eq 'Device')
                {
                    $memberIdentity = Get-MgDevice -Filter "DisplayName eq '$($member.Identity)'" -ErrorAction Stop
                    if ($memberIdentity)
                    {
                        if ($memberIdentity.Count -gt 1)
                        {
                            throw "AU {$($DisplayName)}: Device displayname {$($member.Identity)} is not unique"
                        }
                        $memberSpecification += [pscustomobject]@{Type = "$($member.Type)s"; Id = $memberIdentity.Id }
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
        }
        $CreateParameters.Remove('Members') | Out-Null

        # Resolve ScopedRoleMembers Type/Identity to user, group or service principal
        if ($CreateParameters.ScopedRoleMembers)
        {
            Write-Verbose -Message "AU {$DisplayName} process $($CreateParameters.ScopedRoleMembers.Count) ScopedRoleMembers"
            $scopedRoleMemberSpecification = @()
            foreach ($roleMember in $CreateParameters.ScopedRoleMembers)
            {
                Write-Verbose -Message "AU {$DisplayName} member: role '$($roleMember.RoleName)' type '$($roleMember.RoleMemberInfo.Type)' identity $($roleMember.RoleMemberInfo.Identity)"
                try
                {
                    $roleObject = Get-MgDirectoryRole -Filter "DisplayName eq '$($roleMember.RoleName)'" -ErrorAction stop
                    Write-Verbose -Message "AU {$DisplayName} role is enabled"
                }
                catch
                {
                    Write-Verbose -Message "Azure AD role {$($rolemember.RoleName)} is not enabled"
                    $roleTemplate = Get-MgDirectoryRoleTemplate -Filter "DisplayName eq '$($roleMember.RoleName)'" -ErrorAction Stop
                    if ($null -ne $roleTemplate)
                    {
                        Write-Verbose -Message "Enable Azure AD role {$($rolemember.RoleName)} with id {$($roleTemplate.Id)}"
                        $roleObject = New-MgDirectoryRole -RoleTemplateId $roleTemplate.Id -ErrorAction Stop
                    }
                }
                if ($null -eq $roleObject)
                {
                    throw "AU {$($DisplayName)}: RoleName {$($roleMember.RoleName)} does not exist"
                }
                if ($roleMember.RoleMemberInfo.Type -eq 'User')
                {
                    $roleMemberIdentity = Get-MgUser -Filter "UserPrincipalName eq '$($roleMember.RoleMemberInfo.Identity)'" -ErrorAction Stop
                    if ($null -eq $roleMemberIdentity)
                    {
                        throw "AU {$($DisplayName)}:  Scoped Role User {$($roleMember.RoleMemberInfo.Identity)} for role {$($roleMember.RoleName)} does not exist"
                    }
                }
                elseif ($roleMember.RoleMemberInfo.Type -eq 'Group')
                {
                    $roleMemberIdentity = Get-MgGroup -Filter "displayName eq '$($roleMember.RoleMemberInfo.Identity)'" -ErrorAction Stop
                    if ($null -eq $roleMemberIdentity)
                    {
                        throw "AU {$($DisplayName)}: Scoped Role Group {$($roleMember.RoleMemberInfo.Identity)} for role {$($roleMember.RoleName)} does not exist"
                    }
                    elseif ($roleMemberIdentity.IsAssignableToRole -eq $false)
                    {
                        throw "AU {$($DisplayName)}: Scoped Role Group {$($roleMember.RoleMemberInfo.Identity)} for role {$($roleMember.RoleName)} is not role-enabled"
                    }
                }
                elseif ($roleMember.RoleMemberInfo.Type -eq 'ServicePrincipal')
                {
                    $roleMemberIdentity = Get-MgServicePrincipal -Filter "displayName eq '$($roleMember.RoleMemberInfo.Identity)'" -ErrorAction Stop
                    if ($null -eq $roleMemberIdentity)
                    {
                        throw "AU {$($DisplayName)}: Scoped Role ServicePrincipal {$($roleMember.RoleMemberInfo.Identity)} for role {$($roleMember.RoleName)} does not exist"
                    }
                }
                else
                {
                    throw "AU {$($DisplayName)}: Invalid ScopedRoleMember.RoleMemberInfo.Type {$($roleMember.RoleMemberInfo.Type)}"
                }
                if ($roleMemberIdentity.Count -gt 1)
                {
                    throw "AU {$($DisplayName)}: ScopedRoleMember for role {$($roleMember.RoleName)}: $($roleMember.RoleMemberInfo.Type) {$($roleMember.RoleMemberInfo.Identity)} is not unique"
                }
                $scopedRoleMemberSpecification += @{
                    RoleId         = $roleObject.Id
                    RoleMemberInfo = @{
                        Id = $roleMemberIdentity.Id
                    }
                }
            }
            # ScopedRoleMember-info is added after the AU is created
        }
        $CreateParameters.Remove('ScopedRoleMembers') | Out-Null

    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Azure AD Administrative Unit with DisplayName {$DisplayName}"

        #region resource generator code
        $policy = New-MgDirectoryAdministrativeUnit -BodyParameter $CreateParameters

        if ($MembershipType -ne 'Dynamic')
        {
            foreach ($member in $memberSpecification)
            {
                $memberBodyParam = @{
                    '@odata.id' = "https://graph.microsoft.com/v1.0/$($member.Type)/$($member.Id)"
                }

                New-MgDirectoryAdministrativeUnitMemberByRef -AdministrativeUnitId $policy.Id -BodyParameter $memberBodyParam
            }
        }

        foreach ($scopedRoleMember in $scopedRoleMemberSpecification)
        {
            New-MgDirectoryAdministrativeUnitScopedRoleMember -AdministrativeUnitId $policy.Id -BodyParameter $scopedRoleMember
        }


        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Azure AD Administrative Unit with Id {$($currentInstance.Id)}"

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$UpdateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
        }

        $requestedMembers = $UpdateParameters.Members
        $UpdateParameters.Remove('Members') | Out-Null
        $requestedScopedRoleMembers = $UpdateParameters.ScopedRoleMembers
        $UpdateParameters.Remove('ScopedRoleMembers') | Out-Null

        #region resource generator code
        Update-MgDirectoryAdministrativeUnit -AdministrativeUnitId $currentInstance.Id -BodyParameter $UpdateParameters
        #endregion

        if ($MembershipType -ne 'Dynamic')
        {
            if ($PSBoundParameters.ContainsKey('Members') -and ($backCurrentMembers.Count -gt 0 -or $requestedMembers.Count -gt 0))
            {
                $currentMembers = @()
                foreach ($member in $backCurrentMembers)
                {
                    $currentMembers += [pscustomobject]@{Type = $member.Type; Identity = $member.Identity }
                }
                $desiredMembers = @()
                foreach ($member in $requestedMembers)
                {
                    $desiredMembers += [pscustomobject]@{Type = $member.Type; Identity = $member.Identity }
                }
                $membersDiff = Compare-Object -ReferenceObject $currentMembers -DifferenceObject $desiredMembers -Property Identity, Type
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
                    }
                    else
                    {
                        # a *new* member has been specified with invalid type
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
                        Write-Verbose -Message "AdministrativeUnit {$DisplayName} Adding member {$($diff.Identity)}, type {$($diff.Type)}"

                        $memberBodyParam = @{
                            '@odata.id' = "https://graph.microsoft.com/v1.0/$memberType/$($memberObject.Id)"
                        }
                        New-MgDirectoryAdministrativeUnitMemberByRef -AdministrativeUnitId ($currentInstance.Id) -BodyParameter $memberBodyParam | Out-Null
                    }
                    else
                    {
                        Write-Verbose -Message "Administrative Unit {$DisplayName} Removing member {$($diff.Identity)}, type {$($diff.Type)}"
                        Remove-MgDirectoryAdministrativeUnitMemberByRef -AdministrativeUnitId ($currentInstance.Id) -DirectoryObjectId ($memberObject.Id) | Out-Null
                    }
                }
            }
        }

        if ($PSBoundParameters.ContainsKey('ScopedRoleMembers') -and ($backCurrentScopedRoleMembers.Count -gt 0 -or $requestedScopedRoleMembers.Count -gt 0))
        {
            if ($backCurrentScopedRoleMembers.Length -ne 0)
            {
                $currentScopedRoleMembersValue = $backCurrentScopedRoleMembers
            }
            if ($null -eq $currentScopedRoleMembersValue)
            {
                $currentScopedRoleMembersValue = @()
            }
            $desiredScopedRoleMembersValue = $requestedScopedRoleMembers
            if ($null -eq $desiredScopedRoleMembersValue)
            {
                $desiredScopedRoleMembersValue = @()
            }

            # flatten hashtabls for compare
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
            Write-Verbose -Message "AU {$DisplayName} Update ScopedRoleMembers: Current members: $($compareCurrentScopedRoleMembersValue.Identity -join ', ')"
            Write-Verbose -Message "                                            Desired members: $($compareDesiredScopedRoleMembersValue.Identity -join ', ')"
            $scopedRoleMembersDiff = Compare-Object -ReferenceObject $compareCurrentScopedRoleMembersValue -DifferenceObject $compareDesiredScopedRoleMembersValue -Property RoleName, Identity, Type
            # $scopedRoleMembersDiff = Compare-Object -ReferenceObject $CurrentScopedRoleMembersValue -DifferenceObject $DesiredScopedRoleMembersValue -Property RoleName, Identity, Type
            Write-Verbose -Message "                                            # compare results : $($scopedRoleMembersDiff.Count -gt 0)"

            foreach ($diff in $scopedRoleMembersDiff)
            {
                if ($diff.Type -eq 'User')
                {
                    $memberObject = Get-MgUser -Filter "UserPrincipalName eq '$($diff.Identity)'"
                    #$memberType = 'users'
                }
                elseif ($diff.Type -eq 'Group')
                {
                    $memberObject = Get-MgGroup -Filter "DisplayName eq '$($diff.Identity)'"
                    #$membertype = 'groups'
                }
                elseif ($diff.Type -eq 'ServicePrincipal')
                {
                    $memberObject = Get-MgServicePrincipal -Filter "DisplayName eq '$($diff.Identity)'"
                    #$memberType = "servicePrincipals"
                }
                else
                {
                    if ($diff.RoleName)
                    {
                        throw "AU {$DisplayName} scoped role {$($diff.RoleName)} member {$($diff.Identity)} has invalid type $($diff.Type)"
                    }
                    else
                    {
                        Write-Verbose -Message 'Compare ScopedRoleMembers - skip processing blank RoleName'
                        continue   # don't process,
                    }
                }
                if ($null -eq $memberObject)
                {
                    throw "AU scoped role member {$($diff.Identity)} does not exist as a $($diff.Type)"
                }
                if ($memberObject.Count -gt 1)
                {
                    throw "AU scoped role member {$($diff.Identity)} is not a unique $($diff.Type) (Count=$($memberObject.Count))"
                }
                if ($diff.SideIndicator -ne '==')
                {
                    $roleObject = Get-MgDirectoryRole -Filter "DisplayName eq '$($diff.RoleName)'"
                    if ($null -eq $roleObject)
                    {
                        throw "AU {$DisplayName} Scoped Role {$($diff.RoleName)} does not exist as an Azure AD role"
                    }
                }
                if ($diff.SideIndicator -eq '=>')
                {
                    Write-Verbose -Message "Adding new scoped role {$($diff.RoleName)} member {$($diff.Identity)}, type {$($diff.Type)} to Administrative Unit {$DisplayName}"

                    $scopedRoleMemberParam = @{
                        RoleId         = $roleObject.Id
                        RoleMemberInfo = @{
                            Id = $memberObject.Id
                        }
                    }
                    # addition of scoped rolemember may throw if role is not supported as a scoped role
                    New-MgDirectoryAdministrativeUnitScopedRoleMember -AdministrativeUnitId ($currentInstance.Id) -BodyParameter $scopedRoleMemberParam -ErrorAction Stop | Out-Null
                }
                else
                {
                    if (-not [string]::IsNullOrEmpty($diff.Rolename))
                    {
                        Write-Verbose -Message "Removing scoped role {$($diff.RoleName)} member {$($diff.Identity)}, type {$($diff.Type)} from Administrative Unit {$DisplayName}"
                        $scopedRoleMemberObject = Get-MgDirectoryAdministrativeUnitScopedRoleMember -AdministrativeUnitId ($currentInstance.Id) -All | Where-Object -FilterScript { $_.RoleId -eq $roleObject.Id -and $_.RoleMemberInfo.Id -eq $memberObject.Id }
                        Remove-MgDirectoryAdministrativeUnitScopedRoleMember -AdministrativeUnitId ($currentInstance.Id) -ScopedRoleMembershipId $scopedRoleMemberObject.Id -ErrorAction Stop | Out-Null
                    }
                }
            }
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Azure AD Administrative Unit with Id {$($currentInstance.Id)}"
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
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [validateset('Public', 'HiddenMembership')]
        [System.String]
        $Visibility,

        [Parameter()]
        [validateset('Assigned', 'Dynamic')]
        [System.String]
        $MembershipType,

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [validateset('Paused', 'On')]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Members,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ScopedRoleMembers,
        #endregion

        [Parameter()]
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

    Write-Verbose -Message "Testing configuration of the Azure AD Administrative Unit with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false - Ensure not the same"
        return $false
    }
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($source.getType().Name -like '*CimInstance*')
        {
            $source = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $source

            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-Not $testResult)
            {
                Write-Verbose -Message "Difference found for $key"
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
    $ValuesToCheck.Remove('Id') | Out-Null

    # Visibility is currently not returned by Get-TargetResource
    $ValuesToCheck.Remove('Visibility') | Out-Null

    if ($ValuesToCheck.ContainsKey('MembershipType') -and $MembershipType -ne 'Dynamic' -and $CurrentValues.MembershipType -ne 'Dynamic')
    {
        # MembershipType may be returned as null or Assigned with same effect. Only compare if Dynamic is specified or returned
        $ValuesToCheck.Remove('MembershipType') | Out-Null
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

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
        -ProfileName 'v1.0'

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
        [array]$getValue = Get-MgDirectoryAdministrativeUnit -All `
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
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                DisplayName           = $config.DisplayName
                Id                    = $config.Id
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
            }

            $Results = Get-TargetResource @Params

            if ($null -ne $Results.ScopedRoleMembers)
            {
                $complexMapping = @(
                    @{
                        Name            = 'RoleMemberInfo'
                        CimInstanceName = 'MicrosoftGraphMember'
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ([Array]$Results.ScopedRoleMembers) `
                    -CIMInstanceName MicrosoftGraphScopedRoleMembership -ComplexTypeMapping $complexMapping

                $Results.ScopedRoleMembers = $complexTypeStringResult

                if ([String]::IsNullOrEmpty($complexTypeStringResult))
                {
                    $Results.Remove('ScopedRoleMembers') | Out-Null
                }
            }
            if ($null -ne $Results.Members)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ([Array]$Results.Members) `
                    -CIMInstanceName MicrosoftGraphMember
                $Results.Members = $complexTypeStringResult

                if ([String]::IsNullOrEmpty($complexTypeStringResult))
                {
                    $Results.Remove('Members') | Out-Null
                }
            }

            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            if ($null -ne $Results.ScopedRoleMembers)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'ScopedRoleMembers' -IsCIMArray $true
            }
            if ($null -ne $Results.Members)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Members' -IsCIMArray $true
                $currentDSCBlock = $currentDSCBlock.Replace(",`r`n", '').Replace("`");`r`n", ");`r`n")
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
        Write-Verbose -Message "Exception: $($_.Exception.Message)"

        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}
function Rename-M365DSCCimInstanceParameter
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable], [System.Collections.Hashtable[]])]
    param(
        [Parameter(Mandatory = 'true')]
        $Properties
    )

    $keyToRename = @{
        'odataType' = '@odata.type'
    }

    $result = $Properties

    $type = $Properties.getType().FullName

    #region Array
    if ($type -like '*[[\]]')
    {
        $values = @()
        foreach ($item in $Properties)
        {
            $values += Rename-M365DSCCimInstanceParameter $item
        }
        $result = $values

        return , $result
    }
    #endregion

    #region Single
    if ($type -like '*Hashtable')
    {
        $result = ([Hashtable]$Properties).clone()
    }
    if ($type -like '*CimInstance*' -or $type -like '*Hashtable*' -or $type -like '*Object*')
    {
        $hashProperties = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $result
        $keys = ($hashProperties.clone()).keys
        foreach ($key in $keys)
        {
            $keyName = $key.substring(0, 1).tolower() + $key.substring(1, $key.length - 1)
            if ($key -in $keyToRename.Keys)
            {
                $keyName = $keyToRename.$key
            }

            $property = $hashProperties.$key
            if ($null -ne $property)
            {
                $hashProperties.Remove($key)
                $hashProperties.add($keyName, (Rename-M365DSCCimInstanceParameter $property))
            }
        }
        $result = $hashProperties
    }

    return $result
    #endregion
}
function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable], [hashtable[]])]
    param(
        [Parameter()]
        $ComplexObject
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    if ($ComplexObject.gettype().fullname -like '*[[\]]')
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

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , [hashtable[]]$results
    }

    if ($ComplexObject.getType().fullname -like '*Dictionary*')
    {
        $results = @{}

        $ComplexObject = [hashtable]::new($ComplexObject)
        $keys = $ComplexObject.Keys
        foreach ($key in $keys)
        {
            if ($null -ne $ComplexObject.$key)
            {
                $keyName = $key

                $keyType = $ComplexObject.$key.gettype().fullname

                if ($keyType -like '*CimInstance*' -or $keyType -like '*Dictionary*' -or $keyType -like 'Microsoft.Graph.PowerShell.Models.*' -or $keyType -like '*[[\]]')
                {
                    $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$key

                    $results.Add($keyName, $hash)
                }
                else
                {
                    $results.Add($keyName, $ComplexObject.$key)
                }
            }
        }
        return [hashtable]$results
    }

    $results = @{}

    if ($ComplexObject.getType().Fullname -like '*hashtable')
    {
        $keys = $ComplexObject.keys
    }
    else
    {
        $keys = $ComplexObject | Get-Member | Where-Object -FilterScript { $_.MemberType -eq 'Property' }
    }

    foreach ($key in $keys)
    {
        $keyName = $key
        if ($ComplexObject.getType().Fullname -notlike '*hashtable')
        {
            $keyName = $key.Name
        }

        if ($null -ne $ComplexObject.$keyName)
        {
            $keyType = $ComplexObject.$keyName.gettype().fullname
            if ($keyType -like '*CimInstance*' -or $keyType -like '*Dictionary*' -or $keyType -like 'Microsoft.Graph.PowerShell.Models.*' )
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$keyName

                $results.Add($keyName, $hash)
            }
            else
            {
                $results.Add($keyName, $ComplexObject.$keyName)
            }
        }
    }

    return [hashtable]$results
}

<#
    Use ComplexTypeMapping to overwrite the type of nested CIM
    Example
    $complexMapping=@(
                    @{
                        Name="ApprovalStages"
                        CimInstanceName="MSFT_MicrosoftGraphapprovalstage1"
                        IsRequired=$false
                    }
                    @{
                        Name="PrimaryApprovers"
                        CimInstanceName="MicrosoftGraphuserset"
                        IsRequired=$false
                    }
                    @{
                        Name="EscalationApprovers"
                        CimInstanceName="MicrosoftGraphuserset"
                        IsRequired=$false
                    }
                )
    With
    Name: the name of the parameter to be overwritten
    CimInstanceName: The type of the CIM instance (can include or not the prefix MSFT_)
    IsRequired: If isRequired equals true, an empty hashtable or array will be returned. Some of the Graph parameters are required even though they are empty
#>
function Get-M365DSCDRGComplexTypeToString
{
    [CmdletBinding()]
    param(
        [Parameter()]
        $ComplexObject,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CIMInstanceName,

        [Parameter()]
        [Array]
        $ComplexTypeMapping,

        [Parameter()]
        [System.String]
        $Whitespace = '',

        [Parameter()]
        [System.uint32]
        $IndentLevel = 3,

        [Parameter()]
        [switch]
        $isArray = $false
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    Write-Verbose -Message "Get-M365DSCDRGComplexTypeToString $CIMInstanceName isArray=$isArray"

    $indent = ''
    for ($i = 0; $i -lt $IndentLevel ; $i++)
    {
        $indent += '    '
    }
    #If ComplexObject  is an Array
    if ($ComplexObject.GetType().FullName -like '*[[\]]')
    {
        $currentProperty = @()
        $IndentLevel++
        foreach ($item in $ComplexObject)
        {
            $splat = @{
                'ComplexObject'   = $item
                'CIMInstanceName' = $CIMInstanceName
                'IndentLevel'     = $IndentLevel
            }
            if ($ComplexTypeMapping)
            {
                $splat.add('ComplexTypeMapping', $ComplexTypeMapping)
            }

            $currentProperty += Get-M365DSCDRGComplexTypeToString -isArray:$true @splat
        }

        Write-Verbose -Message "return array currentProperty on next line:`r`n $($currentProperty -join "`r`n")"

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , $currentProperty
    }

    $currentProperty = ''
    if ($isArray)
    {
        $currentProperty += "`r`n"
        $currentProperty += $indent
    }

    $CIMInstanceName = $CIMInstanceName.replace('MSFT_', '')
    $currentProperty += "MSFT_$CIMInstanceName { `r`n"
    $IndentLevel++
    $indent = ''
    for ($i = 0; $i -lt $IndentLevel ; $i++)
    {
        $indent += '    '
    }
    $keyNotNull = 0

    if ($ComplexObject.Keys.count -eq 0)
    {
        return $null
    }

    foreach ($key in $ComplexObject.Keys)
    {
        Write-Verbose -Message "ComplexObject key=$key"
        if ($null -ne $ComplexObject.$key)
        {
            Write-Verbose -Message "`tnot null"
            $keyNotNull++
            if ($ComplexObject.$key.GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*' -or $key -in $ComplexTypeMapping.Name)
            {
                $hashPropertyType = $ComplexObject[$key].GetType().Name.tolower()

                $isArray = $false
                if ($ComplexObject[$key].GetType().FullName -like '*[[\]]')
                {
                    $isArray = $true
                }
                #overwrite type if object defined in mapping complextypemapping
                if ($key -in $ComplexTypeMapping.Name)
                {
                    $hashPropertyType = ($ComplexTypeMapping | Where-Object -FilterScript { $_.Name -eq $key }).CimInstanceName
                    $hashProperty = $ComplexObject[$key]
                }
                else
                {
                    $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                }

                if (-not $isArray)
                {
                    $currentProperty += $indent + $key + ' = '
                }

                if ($isArray -and $key -in $ComplexTypeMapping.Name )
                {
                    if ($ComplexObject.$key.count -gt 0)
                    {
                        $currentProperty += $indent + $key + ' = '
                        $currentProperty += '@('
                    }
                }

                if ($isArray)
                {
                    $IndentLevel++
                    foreach ($item in $ComplexObject[$key])
                    {
                        if ($ComplexObject.$key.GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*')
                        {
                            $item = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                        }
                        $currentProperty += Get-M365DSCDRGComplexTypeToString `
                            -ComplexObject $item `
                            -CIMInstanceName $hashPropertyType `
                            -IndentLevel $IndentLevel `
                            -ComplexTypeMapping $ComplexTypeMapping `
                            -IsArray:$true
                    }
                    $IndentLevel--
                }
                else
                {
                    $currentProperty += Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $hashProperty `
                        -CIMInstanceName $hashPropertyType `
                        -IndentLevel $IndentLevel `
                        -ComplexTypeMapping $ComplexTypeMapping
                }
                if ($isArray)
                {
                    if ($ComplexObject.$key.count -gt 0)
                    {
                        $currentProperty += $indent
                        $currentProperty += ')'
                        $currentProperty += "`r`n"
                    }
                }
                $isArray = $PSBoundParameters.IsArray
            }
            else
            {
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key] -Space ($indent)
            }
        }
        else
        {
            $mappedKey = $ComplexTypeMapping | Where-Object -FilterScript { $_.name -eq $key }

            if ($mappedKey -and $mappedKey.isRequired)
            {
                if ($mappedKey.isArray)
                {
                    $currentProperty += "$indent$key = @()`r`n"
                }
                else
                {
                    $currentProperty += "$indent$key = `$null`r`n"
                }
            }
        }
    }
    $indent = ''
    for ($i = 0; $i -lt $IndentLevel - 1 ; $i++)
    {
        $indent += '    '
    }
    $currentProperty += "$indent}"
    if ($isArray -or $IndentLevel -gt 4)
    {
        $currentProperty += "`r`n"
    }

    #Indenting last parenthese when the cim instance is an array
    if ($IndentLevel -eq 5)
    {
        $indent = ''
        for ($i = 0; $i -lt $IndentLevel - 2 ; $i++)
        {
            $indent += '    '
        }
        $currentProperty += $indent
    }
    Write-Verbose -Message "return item currentProperty on next line:`r`n$currentProperty"
    return $currentProperty
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

    Write-Verbose -Message "Get-M365DSCDRGSimpleObjectTypeToString key='$Key', value='$Value'. Type=$($value.gettype().fullname)"
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
            if ($Value.count -gt 1)
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
            if ($Value.count -gt 1)
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
    Write-Verbose -Message "return '$returnValue'"
    return $returnValue
}

function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter()]
        $Source,
        [Parameter()]
        $Target
    )

    #Comparing full objects
    if ($null -eq $Source -and $null -eq $Target)
    {
        return $true
    }

    $sourceValue = ''
    $targetValue = ''
    if (($null -eq $Source) -xor ($null -eq $Target))
    {
        if ($null -eq $Source)
        {
            $sourceValue = 'Source is null'
        }

        if ($null -eq $Target)
        {
            $targetValue = 'Target is null'
        }
        Write-Verbose -Message "Configuration drift - Complex object: {$sourceValue$targetValue}"
        return $false
    }

    if ($Source.getType().FullName -like '*CimInstance[[\]]' -or $Source.getType().FullName -like '*Hashtable[[\]]')
    {
        if ($source.count -ne $target.count)
        {
            Write-Verbose -Message "Configuration drift - The complex array have different number of items: Source {$($source.count)} Target {$($target.count)}"
            return $false
        }
        if ($source.count -eq 0)
        {
            return $true
        }

        foreach ($item in $Source)
        {

            $hashSource = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            foreach ($targetItem in $Target)
            {
                $compareResult = Compare-M365DSCComplexObject `
                    -Source $hashSource `
                    -Target $targetItem

                if ($compareResult)
                {
                    Write-Verbose -Message 'Compare-M365DSCComplexObject: Diff found'
                    break
                }
            }

            if (-not $compareResult)
            {
                Write-Verbose -Message 'Configuration drift - The complex array items are not identical'
                return $false
            }
        }
        return $true
    }

    $keys = $Source.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    foreach ($key in $keys)
    {
        #Matching possible key names between Source and Target
        $skey = $key
        $tkey = $key

        $sourceValue = $Source.$key
        $targetValue = $Target.$tkey
        #One of the item is null and not the other
        if (($null -eq $Source.$key) -xor ($null -eq $Target.$tkey))
        {

            if ($null -eq $Source.$key)
            {
                $sourceValue = 'null'
            }

            if ($null -eq $Target.$tkey)
            {
                $targetValue = 'null'
            }

            #Write-Verbose -Message "Configuration drift - key: $key Source {$sourceValue} Target {$targetValue}"
            return $false
        }

        #Both keys aren't null or empty
        if (($null -ne $Source.$key) -and ($null -ne $Target.$tkey))
        {
            if ($Source.$key.getType().FullName -like '*CimInstance*' -or $Source.$key.getType().FullName -like '*hashtable*'  )
            {
                #Recursive call for complex object
                $compareResult = Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source.$key) `
                    -Target $Target.$tkey

                if (-not $compareResult)
                {

                    #Write-Verbose -Message "Configuration drift - complex object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject = $Target.$tkey
                $differenceObject = $Source.$key

                #Identifying date from the current values
                $targetType = ($Target.$tkey.getType()).Name
                if ($targetType -like '*Date*')
                {
                    $compareResult = $true
                    $sourceDate = [DateTime]$Source.$key
                    if ($sourceDate -ne $targetType)
                    {
                        $compareResult = $null
                    }
                }
                else
                {
                    $compareResult = Compare-Object `
                        -ReferenceObject ($referenceObject) `
                        -DifferenceObject ($differenceObject)
                }

                if ($null -ne $compareResult)
                {
                    #Write-Verbose -Message "Configuration drift - simple object key: $key Source {$sourceValue} Target {$targetValue}"
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
    [OutputType([hashtable], [hashtable[]])]
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
            $results += $hash
        }

        #Write-Verbose -Message ("Convert-M365DSCDRGComplexTypeToHashtable >>> results: "+(convertTo-JSON $results -Depth 20))
        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , [hashtable[]]$results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject

    if ($null -ne $hashComplexObject)
    {

        $results = $hashComplexObject.clone()
        $keys = $hashComplexObject.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
        foreach ($key in $keys)
        {
            if ($hashComplexObject[$key] -and $hashComplexObject[$key].getType().Fullname -like '*CimInstance*')
            {
                $results[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            else
            {
                $propertyName = $key[0].ToString().ToLower() + $key.Substring(1, $key.Length - 1)
                $propertyValue = $results[$key]
                $results.remove($key) | Out-Null
                $results.add($propertyName, $propertyValue)
            }
        }
    }
    return [hashtable]$results
}

Export-ModuleMember -Function *-TargetResource
