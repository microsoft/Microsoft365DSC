function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AllowedToSignUpEmailBasedSubscriptions,

        [Parameter()]
        [System.Boolean]
        $AllowedToUseSSPR,

        [Parameter()]
        [System.Boolean]
        $AllowEmailVerifiedUsersToJoinOrganization,

        [Parameter()]
        [System.String]
        [validateset('None', 'AdminsAndGuestInviters', 'AdminsGuestInvitersAndAllMembers', 'Everyone')]
        $AllowInvitesFrom,

        [Parameter()]
        [System.Boolean]
        $BlockMsolPowerShell,

        [Parameter()]
        [System.Boolean]
        $DefaultUserRoleAllowedToCreateApps,

        [Parameter()]
        [System.Boolean]
        $DefaultUserRoleAllowedToCreateSecurityGroups,

        [Parameter()]
        [System.Boolean]
        $DefaultUserRoleAllowedToReadOtherUsers,

        [Parameter()]
        [System.String[]]
        $PermissionGrantPolicyIdsAssignedToDefaultUserRole,

        [Parameter()]
        [validateset('User', 'Guest', 'RestrictedGuest')]
        [System.String]
        $GuestUserRole,

        #generic
        [Parameter()]
        [ValidateSet('Present')]
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
        $ManagedIdentity
    )

    Write-Verbose -Message 'Getting configuration of AzureAD Authorization Policy'
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

    $nullReturn = @{
        IsSingleInstance = 'Yes'
    }

    try
    {
        $Policy = Get-MgPolicyAuthorizationPolicy -ErrorAction Stop
    }
    catch
    {
        $message = 'Could not find existing authorization policy'

        New-M365DSCLogEntry -Message $message `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullReturn
    }

    if ($null -eq $Policy)
    {
        $message = 'Existing Authorization Policy was not found'

        New-M365DSCLogEntry -Message $message `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullReturn
    }
    else
    {
        Write-Verbose -Message 'Get-TargetResource: Found existing authorization policy'

        $result = @{
            IsSingleInstance                                  = 'Yes'
            DisplayName                                       = $Policy.DisplayName
            Description                                       = $Policy.Description
            AllowedToSignUpEmailBasedSubscriptions            = $Policy.AllowedToSignUpEmailBasedSubscriptions
            AllowedToUseSSPR                                  = $Policy.AllowedToUseSSPR
            AllowEmailVerifiedUsersToJoinOrganization         = $Policy.AllowEmailVerifiedUsersToJoinOrganization
            AllowInvitesFrom                                  = $Policy.AllowInvitesFrom
            BlockMsolPowerShell                               = $Policy.BlockMsolPowerShell
            DefaultUserRoleAllowedToCreateApps                = $Policy.DefaultUserRolePermissions.AllowedToCreateApps
            DefaultUserRoleAllowedToCreateSecurityGroups      = $Policy.DefaultUserRolePermissions.AllowedToCreateSecurityGroups
            DefaultUserRoleAllowedToReadOtherUsers            = $Policy.DefaultUserRolePermissions.AllowedToReadOtherUsers
            PermissionGrantPolicyIdsAssignedToDefaultUserRole = $Policy.DefaultUserRolePermissions.PermissionGrantPoliciesAssigned
            GuestUserRole                                     = Get-GuestUserRoleNameFromId -GuestUserRoleId $Policy.GuestUserRoleId
            Ensure                                            = 'Present'
            Credential                                        = $Credential
            ApplicationSecret                                 = $ApplicationSecret
            ApplicationId                                     = $ApplicationId
            TenantId                                          = $TenantId
            CertificateThumbprint                             = $CertificateThumbprint
            Managedidentity                                   = $ManagedIdentity.IsPresent
        }

        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AllowedToSignUpEmailBasedSubscriptions,

        [Parameter()]
        [System.Boolean]
        $AllowedToUseSSPR,

        [Parameter()]
        [System.Boolean]
        $AllowEmailVerifiedUsersToJoinOrganization,

        [Parameter()]
        [System.String]
        [validateset('None', 'AdminsAndGuestInviters', 'AdminsGuestInvitersAndAllMembers', 'Everyone')]
        $AllowInvitesFrom,

        [Parameter()]
        [System.Boolean]
        $BlockMsolPowerShell,

        [Parameter()]
        [System.Boolean]
        $DefaultUserRoleAllowedToCreateApps,

        [Parameter()]
        [System.Boolean]
        $DefaultUserRoleAllowedToCreateSecurityGroups,

        [Parameter()]
        [System.Boolean]
        $DefaultUserRoleAllowedToReadOtherUsers,

        [Parameter()]
        [System.String[]]
        $PermissionGrantPolicyIdsAssignedToDefaultUserRole,

        [Parameter()]
        [validateset('User', 'Guest', 'RestrictedGuest')]
        [System.String]
        $GuestUserRole,

        #generic
        [Parameter()]
        [ValidateSet('Present')]
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
        $ManagedIdentity
    )
    Write-Verbose -Message 'Setting configuration of AzureAD Authorization Policy'

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

    Write-Verbose -Message 'Set-Targetresource: Running Get-TargetResource'
    $currentPolicy = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message 'Set-Targetresource: Cleaning up parameters'
    $currentParameters = ([hashtable]$PSBoundParameters).Clone()
    $currentParameters.Remove('IsSingleInstance') | Out-Null
    $currentParameters.Remove('ApplicationId') | Out-Null
    $currentParameters.Remove('TenantId') | Out-Null
    $currentParameters.Remove('CertificateThumbprint') | Out-Null
    $currentParameters.Remove('ApplicationSecret') | Out-Null
    $currentParameters.Remove('Ensure') | Out-Null
    $currentParameters.Remove('Credential') | Out-Null
    $currentParameters.Remove('ManagedIdentity') | Out-Null

    Write-Verbose -Message 'Set-Targetresource: Authorization Policy Ensure Present'
    $UpdateParameters = @{}
    # update policy with supplied parameters that are different from existing policy

    # prepare object for default user role permissions
    $defaultUserRolePermissions = @{}

    foreach ($param in $currentParameters.Keys)
    {
        if ($currentParameters.$param -ne $currentPolicy.$param -or
            ($null -eq $currentParementers.$param -and $null -ne $currentPolicy.$param) -or
            ($null -ne $currentParementers.$param -and $null -eq $currentPolicy.$param))
        {
            if ($param.ToLower() -match 'defaultuserrole')
            {
                if ($param -like 'Permission*')
                {
                    #beta profile
                    #$UpdateParameters.Add($param, $currentParameters.$param)
                    #Write-Verbose -Message "Added '$param' to UpdateParameters"
                    #v1.0 profile
                    $defaultUserRolePermissions.Add('PermissionGrantPoliciesAssigned', $currentParameters.$param)
                    Write-Verbose -Message "Added 'PermissionGrantPoliciesAssigned' ($param) to defaultUserRolePermissions"
                }
                else
                {
                    $defaultUserRolePermissions.Add(($param -replace '^DefaultUserRole'), $currentParameters.$param)
                    Write-Verbose -Message "Added '$($param -replace '^DefaultUserRole')' ($param) to defaultUserRolePermissions"
                }
            }
            else
            {
                if ($param -eq 'GuestUserRole')
                {
                    # translate displayvalue to corresponding GUID
                    $guestUserRoleId = Get-GuestUserRoleIdFromName -GuestUserRole $currentParameters.$param
                    Write-Verbose -Message "Translated GuestUserRole '$param' to '$guestUserRoleId'"
                    $UpdateParameters.Add($param, $guestUserRoleId)
                    Write-Verbose -Message "Added '$param' to UpdateParameters"
                }
                else
                {
                    $UpdateParameters.Add($param, $currentParameters.$param)
                    Write-Verbose -Message "added '$param' to UpdateParameters"
                }
            }
        }
        else
        {
            Write-Verbose -Message "'$param' is unchanged"
        }
    }

    if ($defaultUserRolePermissions.Keys.Count -gt 0)
    {
        Write-Verbose -Message "Add 'DefaultUserRolePermissions' to UpdateParameters"
        $UpdateParameters.Add('DefaultUserRolePermissions', $defaultUserRolePermissions.Clone())
    }

    try
    {
        Write-Verbose -Message "Updating existing authorization policy with values: $(Convert-M365DscHashtableToString -Hashtable $UpdateParameters)"
        $response = Update-MgPolicyAuthorizationPolicy @updateParameters -ErrorAction Stop
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        Write-Verbose -Message "Set-Targetresource: Failed change policy $DisplayName"
    }
    Write-Verbose -Message "Set-Targetresource: finished processing Policy $Displayname"
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AllowedToSignUpEmailBasedSubscriptions,

        [Parameter()]
        [System.Boolean]
        $AllowedToUseSSPR,

        [Parameter()]
        [System.Boolean]
        $AllowEmailVerifiedUsersToJoinOrganization,

        [Parameter()]
        [System.String]
        [validateset('None', 'AdminsAndGuestInviters', 'AdminsGuestInvitersAndAllMembers', 'Everyone')]
        $AllowInvitesFrom,

        [Parameter()]
        [System.Boolean]
        $BlockMsolPowerShell,

        [Parameter()]
        [System.Boolean]
        $DefaultUserRoleAllowedToCreateApps,

        [Parameter()]
        [System.Boolean]
        $DefaultUserRoleAllowedToCreateSecurityGroups,

        [Parameter()]
        [System.Boolean]
        $DefaultUserRoleAllowedToReadOtherUsers,

        [Parameter()]
        [System.String[]]
        $PermissionGrantPolicyIdsAssignedToDefaultUserRole,

        [Parameter()]
        [validateset('User', 'Guest', 'RestrictedGuest')]
        [System.String]$GuestUserRole,

        #generic
        [Parameter()]
        [ValidateSet('Present')]
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
        $ManagedIdentity
    )

    Write-Verbose -Message 'Testing configuration of AzureAD Authorization Policy'

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('IsSingleInstance') | Out-Null
    $ValuesToCheck.Remove('ManagedIdentity') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    try
    {
        $dscContent = ''

        $params = @{
            IsSingleInstance      = 'Yes'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity
        }
        $Results = Get-TargetResource @Params

        if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
        {
            Write-Host "`r`n" -NoNewline
            Write-Host "    |---[1/1] $($results.DisplayName)" -NoNewline
            $results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $results `
                -Credential $Credential
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName

            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX
        }

        return $currentDSCBlock
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
<#
.Description
This function returns a hashtable correlating GUIDs and GuestUserRole names

.Link
https://docs.microsoft.com/en-us/graph/api/resources/authorizationpolicy?view=graph-rest-beta#properties

.Functionality
Internal, Hidden

#>
function Get-GuestUserRoleIdTable
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    @{
        'User'            = 'a0b1b346-4d3e-4e8b-98f8-753987be4970'
        'Guest'           = '10dae51f-b6af-4016-8d66-8c2a99b929b3'
        'RestrictedGuest' = '2af84b1e-32c8-42b7-82bc-daa82404023b'
    }
}
<#
.Description
This function returns the Guid defining the GuestUserRoleId

.Parameter GuestUserRole
DisplayName of role.

.Example
Get-GuestUserRoleIdFromName -GuestUserRole Guest
10dae51f-b6af-4016-8d66-8c2a99b929b3

.Example
Get-GuestUserRoleIdFromName -GuestUserRole RestrictedGuest
2af84b1e-32c8-42b7-82bc-daa82404023b

.Link
https://docs.microsoft.com/en-us/graph/api/authorizationpolicy-update?view=graph-rest-1.0&tabs=http#request-body

.Functionality
Internal, Hidden

#>
function Get-GuestUserRoleIdFromName
{
    [CmdletBinding()]
    [OutputType([System.string])]
    param(
        [parameter()]
        [validateset('User', 'Guest', 'RestrictedGuest')]
        [String]
        $GuestUserRole
    )

    $guestUserRoleIdTable = Get-GuestUserRoleIdTable
    return $guestUserRoleIdTable.$GuestUserRole
}
<#
.Description
This function returns the RoleName defined by the GuestUserRoleId

.Parameter GuestUserRoleId
Id of role.

.Example
Get-GuestUserRoleNameFromId -GuestUserRoleId '10dae51f-b6af-4016-8d66-8c2a99b929b3'
Guest

.Example
Get-GuestUserRoleIdFromName -GuestUserRoleId '2af84b1e-32c8-42b7-82bc-daa82404023b'
RestrictedGuest

.Link
https://docs.microsoft.com/en-us/graph/api/authorizationpolicy-update?view=graph-rest-1.0&tabs=http#request-body

.Functionality
Internal, Hidden

#>
function Get-GuestUserRoleNameFromId
{
    [CmdletBinding()]
    [OutputType([System.string])]
    param(
        [parameter()]
        [String]
        $GuestUserRoleId
    )

    $guestUserRoleIdTable = Get-GuestUserRoleIdTable
    if (-not $guestUserRoleIdTable.ContainsValue($GuestUserRoleId))
    {
        throw "Unexpected value of GuestuserRoleId '$GuestUserRoleId', should be one of $($guestUserRoleIdTable.Values -join ',')"
    }
    foreach ($roleName in $guestUserRoleIdTable.Keys)
    {
        if ($guestUserRoleIdTable.$roleName -eq $GuestUserRoleId)
        {
            Write-Verbose "`tRoleName matching GuestUserRoleId is $roleName"
            break
        }
    }
    Write-Verbose "return $rolename"
    return $roleName
}

Export-ModuleMember -Function *-TargetResource
