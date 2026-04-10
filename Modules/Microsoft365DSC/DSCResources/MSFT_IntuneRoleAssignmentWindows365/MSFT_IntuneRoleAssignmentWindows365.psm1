function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String[]]
        $AppScopeIds,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $DirectoryScopes,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $Principals,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RoleDefinition,

        [Parameter()]
        [System.String]
        $Id,
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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration for the Intune Role Assignment Windows365 with Id {$Id} and DisplayName {$DisplayName}"

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

            #region resource generator code
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaRoleManagementCloudPcRoleAssignment -UnifiedRoleAssignmentMultipleId $Id  -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Role Assignment Windows365 with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaRoleManagementCloudPcRoleAssignment `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Role Assignment Windows365 with DisplayName {$DisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Role Assignment Windows365 with Id {$Id} and DisplayName {$DisplayName} was found"

        if ($getValue.DirectoryScopeIds -notcontains "0")
        {
            $batchRequests = @()
            foreach ($directoryScopeId in $getValue.DirectoryScopeIds)
            {
                $batchRequests += @{
                    id      = $directoryScopeId
                    method = 'GET'
                    url    = "/groups/$($directoryScopeId)?`$select=id,displayName"
                }
            }
            $batchResponses = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests
            foreach ($response in $batchResponses)
            {
                if ($response.status -ne 200)
                {
                    Write-Warning -Message "The Directory Scope group with Id '$($response.id)' was not found for {$DisplayName}. It will be skipped for the current configuration."
                }
            }
            $groupDisplayNames = @($batchResponses.body.displayName | Sort-Object)
        }
        else
        {
            $groupDisplayNames = @("All Users")
        }

        $batchRequests = @()
        foreach ($principalId in $getValue.PrincipalIds)
        {
            $batchRequests += @{
                id      = $principalId
                method = 'GET'
                url    = "/groups/$($principalId)?`$select=id,displayName"
            }
        }
        $batchResponses = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests
        foreach ($response in $batchResponses)
        {
            if ($response.status -ne 200)
            {
                Write-Warning -Message "The Principal group with Id '$($response.id)' was not found for {$DisplayName}. It will be skipped for the current configuration."
            }
        }
        $principalDisplayNames = @($batchResponses.body.displayName | Sort-Object)

        if ($null -eq $Script:RoleDefinitionsCache)
        {
            $Script:RoleDefinitionsCache = @{}
        }

        if (-not $Script:RoleDefinitionsCache.ContainsKey($getValue.RoleDefinitionId))
        {
            $roleDef = Get-MgBetaRoleManagementCloudPcRoleDefinition -UnifiedRoleDefinitionId $getValue.RoleDefinitionId
            $Script:RoleDefinitionsCache.Add($getValue.RoleDefinitionId, $roleDef.DisplayName)
        }
        $roleDefinitionName = $Script:RoleDefinitionsCache[$getValue.RoleDefinitionId]

        $results = @{
            #region resource generator code
            AppScopeIds           = $getValue.AppScopeIds # RoleScopeTagIds
            Description           = $getValue.Description
            DirectoryScopes       = $groupDisplayNames
            DisplayName           = $getValue.DisplayName
            Principals            = $principalDisplayNames
            RoleDefinition        = $roleDefinitionName
            Id                    = $getValue.Id
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            #endregion
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

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String[]]
        $AppScopeIds,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $DirectoryScopes,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $Principals,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RoleDefinition,

        [Parameter()]
        [System.String]
        $Id,
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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of the Intune Role Assignment Windows365 with Id {$Id} and DisplayName {$DisplayName}"

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
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($boundParameters.ContainsKey('RoleDefinition'))
    {
        $roleDef = Get-MgBetaRoleManagementCloudPcRoleDefinition -Filter "DisplayName eq '$($RoleDefinition -replace "'", "''")'" -ErrorAction Stop
        if ($null -eq $roleDef)
        {
            throw "The IntuneRoleDefinitionWindows365 with name '$RoleDefinition' was not found for {$DisplayName}."
        }
        $boundParameters.RoleDefinitionId = $roleDef.Id
        $boundParameters.Remove('RoleDefinition') | Out-Null
    }

    if ($boundParameters.ContainsKey('DirectoryScopes'))
    {
        $directoryScopeIds = @()
        if ($DirectoryScopes -contains "All Users")
        {
            $directoryScopeIds += "0"
        }
        if ($DirectoryScopes.Count -gt 0 -and $DirectoryScopes -notcontains "All Users")
        {
            $batchRequests = @()
            foreach ($name in $DirectoryScopes)
            {
                $batchRequests += @{
                    id     = $name
                    method = 'GET'
                    url    = "/groups?`$filter=displayName eq '$($name -replace "'", "''")'&`$select=id,displayName"
                }
            }
            $batchResponses = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests

            foreach ($resp in $batchResponses)
            {
                if ($resp.status -ne 200 -or $null -eq $resp.body.value -or $resp.body.value.Count -eq 0)
                {
                    throw "The Directory Scope group with name '$($resp.id)' was not found for {$DisplayName}."
                }
                $directoryScopeIds += $resp.body.value[0].id
            }
        }

        $boundParameters.DirectoryScopeIds = $directoryScopeIds
        $boundParameters.Remove('DirectoryScopes') | Out-Null
    }

    if ($boundParameters.ContainsKey('Principals'))
    {
        $principalIds = @()
        if ($Principals.Count -gt 0)
        {
            $batchRequests = @()
            foreach ($name in $Principals)
            {
                $batchRequests += @{
                    id     = $name
                    method = 'GET'
                    url    = "/groups?`$filter=displayName eq '$($name -replace "'", "''")'&`$select=id,displayName"
                }
            }
            $batchResponses = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests

            foreach ($resp in $batchResponses)
            {
                if ($resp.status -ne 200 -or $null -eq $resp.body.value -or $resp.body.value.Count -eq 0)
                {
                    throw "The Principal group with name '$($resp.id)' was not found for {$DisplayName}."
                }
                $principalIds += $resp.body.value[0].id
            }
        }

        $boundParameters.PrincipalIds = $principalIds
        $boundParameters.Remove('Principals') | Out-Null
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Role Assignment Windows365 with DisplayName {$DisplayName}"

        $createParameters = ([Hashtable]$boundParameters).Clone()
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('Id') | Out-Null

        #region resource generator code
        $policy = New-MgBetaRoleManagementCloudPcRoleAssignment -BodyParameter $createParameters
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Role Assignment Windows365 with Id {$($currentInstance.Id)}"

        $updateParameters = ([Hashtable]$boundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters
        $updateParameters.Remove('Id') | Out-Null
        $updateParameters.Remove('RoleDefinitionId') | Out-Null

        #region resource generator code
        Update-MgBetaRoleManagementCloudPcRoleAssignment `
            -UnifiedRoleAssignmentMultipleId $currentInstance.Id `
            -BodyParameter $updateParameters
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Role Assignment Windows365 with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaRoleManagementCloudPcRoleAssignment -UnifiedRoleAssignmentMultipleId $currentInstance.Id
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
        [Parameter()]
        [System.String[]]
        $AppScopeIds,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $DirectoryScopes,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $Principals,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RoleDefinition,

        [Parameter()]
        [System.String]
        $Id,
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
        [array]$getValue = Get-MgBetaRoleManagementCloudPcRoleAssignment `
            -Filter $Filter `
            -All `
            -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Count -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            $displayedKey = $config.Id
            if (-not [System.String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            elseif (-not [System.String]::IsNullOrEmpty($config.name))
            {
                $displayedKey = $config.name
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                RoleDefinition        = $config.RoleDefinitionId
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
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
