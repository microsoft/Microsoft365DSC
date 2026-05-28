Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneRoleDefinition'

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
        [System.Boolean]
        $IsBuiltIn,

        [Parameter()]
        [System.String[]]
        $allowedResourceActions,

        [Parameter()]
        [System.String[]]
        $notAllowedResourceActions,

        [Parameter()]
        [System.String[]]
        $roleScopeTagIds,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Intune Role Definition {$DisplayName}"

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
            if ($Id -match '^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$')
            {
                $getValue = Get-MgBetaDeviceManagementRoleDefinition -RoleDefinitionId $Id -ErrorAction SilentlyContinue
                if ($null -ne $getValue)
                {
                    Write-Verbose -Message "Found an Intune Role Definition with Id {$Id}"
                }
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "No Intune Role Definition with Id {$Id} was found"
                $Filter = "DisplayName eq '$($DisplayName -replace "'", "''")'"
                $getValue = Get-MgBetaDeviceManagementRoleDefinition -All -Filter $Filter -ErrorAction SilentlyContinue
                if ($null -ne $getValue)
                {
                    Write-Verbose -Message "Found an Intune Role Definition with displayname {$DisplayName}"
                }
                else
                {
                    Write-Verbose -Message "No Intune Role Definition with displayname {$DisplayName} was found"
                    return $nullResult
                }
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }

        $results = @{
            Id                    = $getValue.Id
            Description           = $getValue.Description
            DisplayName           = $getValue.DisplayName
            IsBuiltIn             = $getValue.IsBuiltIn
            Ensure                = 'Present'
            RoleScopeTagIds       = $getValue.RoleScopeTagIds
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity
            AccessTokens          = $AccessTokens
        }
        if ($getValue.RolePermissions)
        {
            $results.Add('AllowedResourceActions', $getValue.RolePermissions.ResourceActions.AllowedResourceActions)
            $results.Add('NotAllowedResourceActions', $getValue.RolePermissions.ResourceActions.NotAllowedResourceActions)
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
        [System.Boolean]
        $IsBuiltIn,

        [Parameter()]
        [System.String[]]
        $allowedResourceActions,

        [Parameter()]
        [System.String[]]
        $notAllowedResourceActions,

        [Parameter()]
        [System.String[]]
        $roleScopeTagIds,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting the Intune Role Definition {$DisplayName}"

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

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating Role Definition {$DisplayName}"
        if ($null -ne $roleScopeTagIds)
        {
            $ScopeRoleTags = @()
            foreach ($roleScopeTagId in $roleScopeTagIds)
            {
                $Tag = Get-MgBetaDeviceManagementRoleScopeTag -RoleScopeTagId $roleScopeTagId -ErrorAction SilentlyContinue
                if ($null -ne $Tag)
                {
                    $ScopeRoleTags += $Tag.Id
                }
            }
        }
        $resourceActions = @{
            '@odata.type'             = 'microsoft.graph.resourceAction'
            notAllowedResourceActions = $notAllowedResourceActions
            allowedResourceActions    = $allowedResourceActions
        }
        $rolepermission = @{
            '@odata.type'   = 'microsoft.graph.rolePermission'
            resourceActions = @($resourceActions)
        }
        $ScopeTagIds = $ScopeRoleTags
        $CreateParameters = @{
            '@odata.type'   = '#microsoft.graph.roleDefinition'
            displayName     = $DisplayName
            description     = $Description
            rolePermissions = @($rolepermission)
            roleScopeTagIds = $ScopeTagIds
        }

        $policy = New-MgBetaDeviceManagementRoleDefinition -BodyParameter $CreateParameters

    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Role Definition {$DisplayName}"
        if ($null -ne $roleScopeTagIds)
        {
            $ScopeRoleTags = @()
            foreach ($roleScopeTagId in $roleScopeTagIds)
            {
                $Tag = Get-MgBetaDeviceManagementRoleScopeTag -RoleScopeTagId $roleScopeTagId -ErrorAction SilentlyContinue
                if ($null -ne $Tag)
                {
                    $ScopeRoleTags += $Tag.Id
                }
            }
        }
        $resourceActions = @{
            '@odata.type'             = 'microsoft.graph.resourceAction'
            notAllowedResourceActions = $notAllowedResourceActions
            allowedResourceActions    = $allowedResourceActions
        }
        $rolepermission = @{
            '@odata.type'   = 'microsoft.graph.rolePermission'
            resourceActions = @($resourceActions)
        }
        $ScopeTagIds = $ScopeRoleTags
        $UpdateParameters = @{
            '@odata.type'   = '#microsoft.graph.roleDefinition'
            displayName     = $DisplayName
            description     = $Description
            rolePermissions = @($rolepermission)
            roleScopeTagIds = $ScopeTagIds
        }

        Update-MgBetaDeviceManagementRoleDefinition -BodyParameter $UpdateParameters `
            -RoleDefinitionId $currentInstance.Id

    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Role Definition {$DisplayName}"
        Remove-MgBetaDeviceManagementRoleDefinition -RoleDefinitionId $currentInstance.Id
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
        [System.Boolean]
        $IsBuiltIn,

        [Parameter()]
        [System.String[]]
        $allowedResourceActions,

        [Parameter()]
        [System.String[]]
        $notAllowedResourceActions,

        [Parameter()]
        [System.String[]]
        $roleScopeTagIds,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        $baseFilter = "isof('microsoft.graph.deviceAndAppManagementRoleDefinition')"
        if (-not [string]::IsNullOrEmpty($Filter))
        {
            $Filter = "($baseFilter) and ($Filter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = Get-MgBetaDeviceManagementRoleDefinition -Filter $Filter -All -ErrorAction Stop

        if (-not $getValue)
        {
            [array]$getValue = Get-MgBetaDeviceManagementRoleDefinition -All -ErrorAction Stop
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
                ManagedIdentity       = $ManagedIdentity
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            [void]$dscContent.Append($currentDSCBlock)
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
