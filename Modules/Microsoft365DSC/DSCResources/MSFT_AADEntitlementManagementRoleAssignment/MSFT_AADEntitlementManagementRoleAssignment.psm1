Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADEntitlementManagementRoleAssignment'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Principal,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RoleDefinition,

        [Parameter()]
        [System.String]
        $AppScopeId,

        [Parameter()]
        [System.String]
        $DirectoryScopeId,
        #endregion

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

    Write-Verbose -Message "Getting configuration of AzureAD Entitlement Management Role Assignment for Principal {$Principal}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Id -ne $Id)
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
                $getValue = Get-MgBetaRoleManagementEntitlementManagementRoleAssignment -UnifiedRoleAssignmentId $Id `
                    -ExpandProperty 'Principal' `
                    -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                if ($null -eq $Script:AllRoleAssignments)
                {
                    $Script:AllRoleAssignments = Get-MgBetaRoleManagementEntitlementManagementRoleAssignment `
                        -ExpandProperty 'Principal' `
                        -All
                }
                if ($null -eq $Script:AllRoleDefinitions)
                {
                    [array]$Script:AllRoleDefinitions = Get-MgBetaRoleManagementEntitlementManagementRoleDefinition -All
                    $Script:AllRoleDefinitions += @{
                        Id          = 'e65cf63f-9cc2-4b48-8871-cb667e9d90fb'
                        DisplayName = 'Connected organization administrator'
                    }
                }

                Write-Verbose -Message "Getting role assignment for Principal {$Principal}"
                $getValue = $Script:AllRoleAssignments | Where-Object {
                    ($_.Principal.displayName -eq $Principal -or $_.Principal.userPrincipalName -eq $Principal -or $_.Principal.Id -eq $Principal) `
                        -and ($_.RoleDefinitionId -eq $($Script:AllRoleDefinitions | Where-Object { $_.DisplayName -eq $RoleDefinition }).Id)
                }
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }

        switch ($getValue.Principal)
        {
            '#microsoft.graph.user'
            {
                $principalName = $getValue.Principal.userPrincipalName
            }
            '#microsoft.graph.group'
            {
                $principalName = Get-MgGroup -GroupId $getValue.PrincipalId
            }
            '#microsoft.graph.servicePrincipal'
            {
                $principalName = $getValue.Principal.displayName
            }
        }

        if ($null -eq $getValue)
        {
            Write-Verbose -Message 'No existing assignments were found'
            return $nullResult
        }

        Write-Verbose -Message "Found existing role assignment with ID {$($getValue.id)}."

        $results = @{
            Id                    = $getValue.Id
            Principal             = $principalName
            RoleDefinition        = $RoleDefinition
            DisplayName           = $getValue.DisplayName
            AppScopeId            = $getValue.AppScopeId
            DirectoryScopeId      = $getValue.DirectoryScopeId
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
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
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Principal,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RoleDefinition,

        [Parameter()]
        [System.String]
        $AppScopeId,

        [Parameter()]
        [System.String]
        $DirectoryScopeId,
        #endregion

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

    Write-Verbose -Message "Setting configuration of AzureAD Entitlement Management Role Assignment for Principal {$Principal}"

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
    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    $batchRequests = @(
        @{
            id     = 'user'
            method = 'GET'
            url    = "/users/$($Principal)?`$select=id,userPrincipalName,displayName"
        }
        @{
            id     = 'group'
            method = 'GET'
            url    = "/groups?`$filter=displayName eq '$($Principal -replace "'", "''")'&`$select=id,displayName"
        }
        @{
            id     = 'servicePrincipal'
            method = 'GET'
            url    = "/servicePrincipals?`$filter=displayName eq '$($Principal -replace "'", "''")'&`$select=id,displayName"
        }
    )
    $batchResponses = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests

    $objectId = $batchResponses.body.value.id
    if ($null -eq $objectId)
    {
        throw "Principal '$Principal' not found. Ensure the Principal exists and is correctly specified."
    }
    if ($objectId -is [array] -and $objectId.Count -gt 1)
    {
        throw "Multiple objects found for Principal '$Principal'. Please specify a unique identifier."
    }

    $setParameters = Rename-M365DSCCimInstanceParameter -Properties $setParameters

    $roleInfo = Get-MgBetaRoleManagementEntitlementManagementRoleDefinition -Filter "DisplayName eq '$($RoleDefinition -replace "'", "''")'"
    $setParameters.Add('principalId', $objectId)
    $setParameters.Add('roleDefinitionId', $roleInfo.Id)
    $setParameters.Remove('Principal') | Out-Null
    $setParameters.Remove('RoleDefinition') | Out-Null

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $setParameters.Remove('Id') | Out-Null
        Write-Verbose -Message "Creating a new Entitlement Management Role Assignment for Principal {$Principal} with Role {$RoleDefinition}"
        New-MgBetaRoleManagementEntitlementManagementRoleAssignment -BodyParameter $setParameters
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message 'Entitlement Management Role Assignments cannot be updated.'
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Remove-MgBetaRoleManagementEntitlementManagementRoleAssignment -UnifiedRoleAssignmentId $currentInstance.Id
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Principal,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RoleDefinition,

        [Parameter()]
        [System.String]
        $AppScopeId,

        [Parameter()]
        [System.String]
        $DirectoryScopeId,
        #endregion

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
        #region resource generator code
        [array]$getValue = Get-MgBetaRoleManagementEntitlementManagementRoleAssignment `
            -All `
            -ExpandProperty 'Principal' `
            -Filter $Filter `
            -ErrorAction Stop

        #endregion
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

            if ($null -eq $Script:AllRoleDefinitions)
            {
                [array]$Script:AllRoleDefinitions = Get-MgBetaRoleManagementEntitlementManagementRoleDefinition -All
                $Script:AllRoleDefinitions += @{
                    Id          = 'e65cf63f-9cc2-4b48-8871-cb667e9d90fb'
                    DisplayName = 'Connected organization administrator'
                }
            }

            $displayedKey = $config.id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $roleInfo = $Script:AllRoleDefinitions | Where-Object { $_.Id -eq $config.RoleDefinitionId }
            switch ($config.Principal.'@odata.type')
            {
                '#microsoft.graph.user'
                {
                    $principalName = $config.Principal.userPrincipalName
                }
                $null
                {
                    $principalName = (Get-MgGroup -GroupId $config.PrincipalId).DisplayName
                }
                '#microsoft.graph.servicePrincipal'
                {
                    $principalName = $config.Principal.displayName
                }
            }
            $params = @{
                Id                    = $config.Id
                Principal             = $principalName
                RoleDefinition        = $roleInfo.DisplayName
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
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

            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName

            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
        }

        return $dscContent.ToString()
    }
    catch
    {
        if ($_.ErrorDetails.Message -like '*User is not authorized to perform the operation.*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) Tenant does not meet license requirement to extract this component or the user has not been granted the proper permissions."
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

Export-ModuleMember -Function *-TargetResource
