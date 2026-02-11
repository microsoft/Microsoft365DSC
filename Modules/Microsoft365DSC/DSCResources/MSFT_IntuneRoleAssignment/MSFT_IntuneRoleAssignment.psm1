Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneRoleAssignment'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $ResourceScopes,

        [Parameter()]
        [System.String[]]
        $ResourceScopesDisplayNames,

        [Parameter()]
        [System.String]
        $ScopeType,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $MembersDisplayNames,

        [Parameter()]
        [System.String]
        $RoleDefinition,

        [Parameter()]
        [System.String]
        $RoleDefinitionDisplayName,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Intune Role Assignment with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

            $getValue = $null
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceManagementRoleAssignment -DeviceAndAppManagementRoleAssignmentId $Id -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Role Assignment with Id {$Id}"

                $getValue = Get-MgBetaDeviceManagementRoleAssignment `
                    -All `
                    -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" `
                    -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Role Assignment with DisplayName {$DisplayName}"
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }

        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Role Assignment with Id {$Id} and DisplayName {$DisplayName} was found"

        # Get Roledefinition first, loop through all roledefinitions and find the assignment that matches the Id
        $tempRoleDefinitions = Get-MgDeviceManagementRoleDefinition
        foreach ($tempRoleDefinition in $tempRoleDefinitions)
        {
            $item = Get-MgDeviceManagementRoleDefinitionRoleAssignment -RoleDefinitionId $tempRoleDefinition.Id | Where-Object { $_.Id -eq $getValue.Id }
            if ($null -ne $item)
            {
                $RoleDefinition = $tempRoleDefinition.Id
                $RoleDefinitionDisplayName = $tempRoleDefinition.DisplayName
                break
            }
        }

        $resourceScopesDisplayNamesValue = @()
        foreach ($resourceScope in $getValue.ResourceScopes)
        {
            $group = Get-MgGroup -GroupId $resourceScope -ErrorAction SilentlyContinue
            if ($null -eq $group)
            {
                Write-Warning -Message "Could not find group with Id {$resourceScope} when retrieving resource scope display names"
                continue
            }
            $resourceScopesDisplayNamesValue += $group.DisplayName
        }

        $membersDisplayNamesValue = @()
        foreach ($tempMember in $getValue.Members)
        {
            $group = Get-MgGroup -GroupId $tempMember -ErrorAction SilentlyContinue
            if ($null -eq $group)
            {
                Write-Warning -Message "Could not find group with Id {$tempMember} when retrieving member display names"
                continue
            }
            $membersDisplayNamesValue += $group.DisplayName
        }

        $scopeTypeValue = $null
        if (-not ([System.String]::IsNullOrEmpty($getValue.ScopeType)))
        {
            $scopeTypeValue = $getValue.ScopeType.ToString()
        }
        $results = @{
            Id                         = $getValue.Id
            Description                = $getValue.Description
            DisplayName                = $getValue.DisplayName
            ResourceScopes             = $getValue.ResourceScopes
            ResourceScopesDisplayNames = $resourceScopesDisplayNamesValue
            ScopeType                  = $scopeTypeValue
            Members                    = $getValue.Members
            MembersDisplayNames        = $membersDisplayNamesValue
            RoleDefinition             = $RoleDefinition
            RoleDefinitionDisplayName  = $RoleDefinitionDisplayName
            Ensure                     = 'Present'
            Credential                 = $Credential
            ApplicationId              = $ApplicationId
            TenantId                   = $TenantId
            ApplicationSecret          = $ApplicationSecret
            CertificateThumbprint      = $CertificateThumbprint
            ManagedIdentity            = $ManagedIdentity.IsPresent
            AccessTokens               = $AccessTokens
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
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $ResourceScopes,

        [Parameter()]
        [System.String[]]
        $ResourceScopesDisplayNames,

        [Parameter()]
        [System.String]
        $ScopeType,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $MembersDisplayNames,

        [Parameter()]
        [System.String]
        $RoleDefinition,

        [Parameter()]
        [System.String]
        $RoleDefinitionDisplayName,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of the Intune Role Assignment with Id {$Id} and DisplayName {$DisplayName}"

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

    if ($RoleDefinition -notmatch '^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$' -or $RoleDefinition -eq '00000000-0000-0000-0000-000000000000')
    {
        $RoleDefinition = $null
        $filter = "DisplayName eq '$($RoleDefinitionDisplayName -replace "'", "''")'"
        $roleDefinitionId = Get-MgDeviceManagementRoleDefinition -All -Filter $filter -ErrorAction SilentlyContinue
        if ($null -ne $roleDefinitionId)
        {
            $RoleDefinition = $roleDefinitionId.Id
        }
        else
        {
            Write-Verbose -Message "No role definition with DisplayName {$RoleDefinitionDisplayName} was found"
        }
    }

    [array]$membersValue = @()
    if ($PSBoundParameters.ContainsKey('MembersDisplayNames'))
    {
        foreach ($membersDisplayName in $MembersDisplayNames)
        {
            $filter = "displayName eq '$($membersDisplayName -replace "'", "''")'"
            $memberId = Get-MgGroup -Filter $filter -ErrorAction SilentlyContinue
            if ($null -ne $memberId)
            {
                if ($membersValue -notcontains $memberId.Id)
                {
                    $membersValue += $memberId.Id
                }
            }
            else
            {
                Write-Verbose -Message "No member of type group with DisplayName {$membersDisplayName} was found"
            }
        }
    }
    else
    {
        $membersValue = $Members
    }

    [array]$resourceScopesValue = @()
    if ($PSBoundParameters.ContainsKey('ResourceScopesDisplayNames'))
    {
        foreach ($resourceScopesDisplayName in $ResourceScopesDisplayNames)
        {
            $filter = "DisplayName eq '$($resourceScopesDisplayName -replace "'", "''")'"
            $resourceScopeId = Get-MgGroup -Filter $filter -ErrorAction SilentlyContinue
            if ($null -ne $resourceScopeId)
            {
                if ($resourceScopesValue -notcontains $resourceScopeId.Id)
                {
                    $resourceScopesValue += $resourceScopeId.Id
                }
            }
            else
            {
                Write-Verbose -Message "No resource scope of type group with DisplayName {$resourceScopesDisplayName} was found"
            }
        }
    }
    else
    {
        $resourceScopesValue = $ResourceScopes
    }

    $scopeTypeValue = $ScopeType
    if ($ScopeType -match 'AllDevices|AllLicensedUsers|AllDevicesAndLicensedUsers')
    {
        $resourceScopesValue = $null
    }
    else
    {
        $scopeTypeValue = 'resourceScope'
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Role Assignment with DisplayName {$DisplayName}"

        $CreateParameters = @{
            description                 = $Description
            displayName                 = $DisplayName
            resourceScopes              = $resourceScopesValue
            scopeType                   = $scopeTypeValue
            members                     = $membersValue
            '@odata.type'               = '#microsoft.graph.deviceAndAppManagementRoleAssignment'
            'roleDefinition@odata.bind' = "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceManagement/roleDefinitions('$RoleDefinition')"
        }

        $null = New-MgBetaDeviceManagementRoleAssignment -BodyParameter $CreateParameters
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Role Assignment with Id {$($currentInstance.Id)} and DisplayName {$DisplayName}"

        $UpdateParameters = @{
            description                 = $Description
            displayName                 = $DisplayName
            resourceScopes              = $resourceScopesValue
            scopeType                   = $scopeTypeValue
            members                     = $membersValue
            '@odata.type'               = '#microsoft.graph.deviceAndAppManagementRoleAssignment'
            'roleDefinition@odata.bind' = "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceManagement/roleDefinitions('$RoleDefinition')"
        }

        $null = Update-MgBetaDeviceManagementRoleAssignment `
            -BodyParameter $UpdateParameters `
            -DeviceAndAppManagementRoleAssignmentId $currentInstance.Id
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Role Assignment with Id {$($currentInstance.Id)} and DisplayName {$DisplayName}"
        Remove-MgBetaDeviceManagementRoleAssignment -DeviceAndAppManagementRoleAssignmentId $currentInstance.Id
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $ResourceScopes,

        [Parameter()]
        [System.String[]]
        $ResourceScopesDisplayNames,

        [Parameter()]
        [System.String]
        $ScopeType,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $MembersDisplayNames,

        [Parameter()]
        [System.String]
        $RoleDefinition,

        [Parameter()]
        [System.String]
        $RoleDefinitionDisplayName,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
        [array]$getValue = Get-MgBetaDeviceManagementRoleAssignment -Filter $Filter -All `
            -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.deviceAndAppManagementRoleAssignment'  `
        }

        if (-not $getValue)
        {
            [array]$getValue = Get-MgBetaDeviceManagementRoleAssignment `
                -ErrorAction Stop
        }

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            $dscContent.Append($currentDSCBlock) | Out-Null
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent.ToString()
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
                $_.Exception -like '*Request not applicable to target tenant*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
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

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        PostProcessing = {
            param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
            if ($DesiredValues.ContainsKey('MembersDisplayNames'))
            {
                $ValuesToCheck.Remove('Members') | Out-Null
            }
            if ($DesiredValues.ContainsKey('ResourceScopesDisplayNames'))
            {
                $ValuesToCheck.Remove('ResourceScopes') | Out-Null
            }
            if ($DesiredValues.ContainsKey('RoleDefinitionDisplayName'))
            {
                $ValuesToCheck.Remove('RoleDefinition') | Out-Null
            }
            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
