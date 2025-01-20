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
        if (-not $Script:exportedInstance)
        {
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
                    -Filter "displayName eq '$DisplayName'" `
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

        #Get Roledefinition first, loop through all roledefinitions and find the assignment that matches the Id
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

        $ResourceScopesDisplayNames = @()
        foreach ($ResourceScope in $getValue.ResourceScopes)
        {
            $ResourceScopesDisplayNames += (Get-MgGroup -GroupId $ResourceScope).DisplayName
        }

        $MembersDisplayNames = @()
        foreach ($tempMember in $getValue.Members)
        {
            $MembersDisplayNames += (Get-MgGroup -GroupId $tempMember).DisplayName
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
            ResourceScopesDisplayNames = $ResourceScopesDisplayNames
            ScopeType                  = $scopeTypeValue
            Members                    = $getValue.Members
            MembersDisplayNames        = $MembersDisplayNames
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

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters
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
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if (!($RoleDefinition -match '^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$'))
    {
        [string]$roleDefinition = $null
        $Filter = "displayName eq '$RoleDefinitionDisplayName'"
        $RoleDefinitionId = Get-MgDeviceManagementRoleDefinition -All -Filter $Filter -ErrorAction SilentlyContinue
        if ($null -ne $RoleDefinitionId)
        {
            $roleDefinition = $RoleDefinitionId.Id
        }
        else
        {
            Write-Verbose -Message "No role definition with DisplayName {$RoleDefinitionDisplayName} was found"
        }
    }

    [array]$members = @()
    foreach ($MembersDisplayName in $membersDisplayNames)
    {
        $Filter = "displayName eq '$MembersDisplayName'"
        $MemberId = Get-MgGroup -Filter $Filter -ErrorAction SilentlyContinue
        if ($null -ne $MemberId)
        {
            if ($Members -notcontains $MemberId.Id)
            {
                $Members += $MemberId.Id
            }
        }
        else
        {
            Write-Verbose -Message "No member of type group with DisplayName {$MembersDisplayName} was found"
        }
    }

    [array]$resourceScopes = @()
    foreach ($ResourceScopesDisplayName in $ResourceScopesDisplayNames)
    {
        $Filter = "displayName eq '$ResourceScopesDisplayName'"
        $ResourceScopeId = Get-MgGroup -Filter $Filter -ErrorAction SilentlyContinue
        if ($null -ne $ResourceScopeId)
        {
            if ($ResourceScopes -notcontains $ResourceScopeId.Id)
            {
                $ResourceScopes += $ResourceScopeId.Id
            }
        }
        else
        {
            Write-Verbose -Message "No resource scope of type group with DisplayName {$ResourceScopesDisplayName} was found"
        }
    }
    if ($ScopeType -match 'AllDevices|AllLicensedUsers|AllDevicesAndLicensedUsers')
    {
        $ResourceScopes = $null
    }
    else
    {
        $ScopeType = 'resourceScope'
        $ResourceScopes = $ResourceScopes
    }
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Role Assignment with DisplayName {$DisplayName}"

        $CreateParameters = @{
            description                 = $Description
            displayName                 = $DisplayName
            resourceScopes              = $ResourceScopes
            scopeType                   = $ScopeType
            members                     = $Members
            '@odata.type'               = '#microsoft.graph.deviceAndAppManagementRoleAssignment'
            'roleDefinition@odata.bind' = "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceManagement/roleDefinitions('$roleDefinition')"
        }
        $null = New-MgBetaDeviceManagementRoleAssignment -BodyParameter $CreateParameters
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Role Assignment with Id {$($currentInstance.Id)} and DisplayName {$DisplayName}"

        $UpdateParameters = @{
            description                 = $Description
            displayName                 = $DisplayName
            resourceScopes              = $ResourceScopes
            scopeType                   = $ScopeType
            members                     = $Members
            '@odata.type'               = '#microsoft.graph.deviceAndAppManagementRoleAssignment'
            'roleDefinition@odata.bind' = "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceManagement/roleDefinitions('$roleDefinition')"
        }

        Update-MgBetaDeviceManagementRoleAssignment -BodyParameter $UpdateParameters `
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

    Write-Verbose -Message "Testing configuration of {$Id - $displayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

    if (-not ($RoleDefinition -match '^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$'))
    {
        [string]$roleDefinition = $null
        $Filter = "displayName eq '$RoleDefinitionDisplayName'"
        $RoleDefinitionId = Get-MgDeviceManagementRoleDefinition -All -Filter $Filter -ErrorAction SilentlyContinue
        if ($null -ne $RoleDefinitionId)
        {
            $roleDefinition = $RoleDefinitionId.Id
            $PSBoundParameters.Set_Item('RoleDefinition', $roleDefinition)
        }
        else
        {
            Write-Verbose -Message "No role definition with DisplayName {$RoleDefinitionDisplayName} was found"
        }
    }

    foreach ($MembersDisplayName in $membersDisplayNames)
    {
        $Filter = "displayName eq '$MembersDisplayName'"
        $newMemeber = Get-MgGroup -Filter $Filter -ErrorAction SilentlyContinue
        if ($null -ne $newMemeber)
        {
            if ($Members -notcontains $newMemeber.Id)
            {
                $Members += $newMemeber.Id
            }
        }
        else
        {
            Write-Verbose -Message "No member of type group with DisplayName {$MembersDisplayName} was found"
        }
    }
    $PSBoundParameters.Set_Item('Members', $Members)

    foreach ($ResourceScopesDisplayName in $resourceScopesDisplayNames)
    {
        $Filter = "displayName eq '$ResourceScopesDisplayName'"
        $newResourceScope = Get-MgGroup -Filter $Filter -ErrorAction SilentlyContinue
        if ($null -ne $newResourceScope)
        {
            if ($ResourceScopes -notcontains $newResourceScope.Id)
            {
                $ResourceScopes += $newResourceScope.Id
            }
        }
        else
        {
            Write-Verbose -Message "No resource scope of type group with DisplayName {$ResourceScopesDisplayName} was found"
        }
    }
    $PSBoundParameters.Set_Item('ResourceScopes', $ResourceScopes)

    if ($CurrentValues.Ensure -ne $Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult = $true

    $ValuesToCheck.Remove('Id') | Out-Null
    $ValuesToCheck.Remove('ResourceScopesDisplayNames') | Out-Null
    $ValuesToCheck.Remove('membersDisplayNames') | Out-Null

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
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
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
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

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
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
                $_.Exception -like '*Request not applicable to target tenant*')
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX

            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
