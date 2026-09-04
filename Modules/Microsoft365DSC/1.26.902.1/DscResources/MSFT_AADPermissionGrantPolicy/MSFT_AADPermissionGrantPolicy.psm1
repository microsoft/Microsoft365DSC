Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADPermissionGrantPolicy'

# Cache for service principal lookups to avoid redundant Graph API calls
$Script:ServicePrincipalCache = [System.Collections.Generic.Dictionary[System.String, System.Object]]::new()

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Includes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Excludes,

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

    Write-Verbose -Message "Getting configuration of Entra Permission Grant Policy {$Id}"

    try
    {
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

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        if (-not $Script:exportedInstance -or $Script:exportedInstance.Id -ne $Id)
        {

            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaPolicyPermissionGrantPolicy -PermissionGrantPolicyId $Id `
                    -ErrorAction SilentlyContinue
            }
            else
            {
                $getValue = Get-MgBetaPolicyPermissionGrantPolicy -PermissionGrantPolicyId $Id `
                    -ErrorAction SilentlyContinue
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "No Entra Permission Grant Policy with Id {$Id} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found Entra Permission Grant Policy with Id {$Id}"

        # Convert Includes collection to hashtable array
        $includesArray = @()
        if ($null -ne $getValue.Includes)
        {
            foreach ($include in $getValue.Includes)
            {
                $includesArray += Get-PermissionGrantConditionSetAsHashtable -ConditionSet $include
            }
        }

        # Convert Excludes collection to hashtable array
        $excludesArray = @()
        if ($null -ne $getValue.Excludes)
        {
            foreach ($exclude in $getValue.Excludes)
            {
                $excludesArray += Get-PermissionGrantConditionSetAsHashtable -ConditionSet $exclude
            }
        }

        $result = @{
            Id                    = $getValue.Id
            DisplayName           = $getValue.DisplayName
            Description           = $getValue.Description
            Includes              = [Array]$includesArray
            Excludes              = [Array]$excludesArray
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

        return $result
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
        $Id,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Includes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Excludes,

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

    Write-Verbose -Message "Setting configuration of Entra Permission Grant Policy {$Id}"

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
        # Clear the service principal cache for fresh lookups
        $Script:ServicePrincipalCache = [System.Collections.Generic.Dictionary[System.String, System.Object]]::new()

        $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters

        $currentPolicy = Get-TargetResource @PSBoundParameters

        # CREATE
        if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
        {
            Write-Verbose -Message "Creating new Entra Permission Grant Policy with Id {$Id} and DisplayName {$DisplayName}"

            $createParameters = @{
                Id          = $Id
                DisplayName = $DisplayName
                Description = $Description
            }

            New-MgBetaPolicyPermissionGrantPolicy -BodyParameter $createParameters | Out-Null

            # Add Includes
            if ($null -ne $Includes -and $Includes.Count -gt 0)
            {
                foreach ($include in $Includes)
                {
                    Write-Verbose -Message "Adding include condition set {$($include.Id)}"
                    $includeParams = Get-PermissionGrantConditionSetAsParameters -ConditionSet $include
                    New-MgBetaPolicyPermissionGrantPolicyInclude -PermissionGrantPolicyId $Id -BodyParameter $includeParams | Out-Null
                }
            }

            # Add Excludes
            if ($null -ne $Excludes -and $Excludes.Count -gt 0)
            {
                foreach ($exclude in $Excludes)
                {
                    Write-Verbose -Message "Adding exclude condition set {$($exclude.Id)}"
                    $excludeParams = Get-PermissionGrantConditionSetAsParameters -ConditionSet $exclude
                    New-MgBetaPolicyPermissionGrantPolicyExclude -PermissionGrantPolicyId $Id -BodyParameter $excludeParams | Out-Null
                }
            }
        }
        # UPDATE
        elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
        {
            Write-Verbose -Message "Updating Entra Permission Grant Policy with Id {$Id} and DisplayName {$DisplayName}"

            $updateParameters = @{}
            if ($PSBoundParameters.ContainsKey('DisplayName') -and $DisplayName -ne $currentPolicy.DisplayName)
            {
                $updateParameters.Add('DisplayName', $DisplayName)
            }

            if ($PSBoundParameters.ContainsKey('Description') -and $Description -ne $currentPolicy.Description)
            {
                $updateParameters.Add('Description', $Description)
            }

            if ($updateParameters.Count -gt 1)
            {
                Update-MgBetaPolicyPermissionGrantPolicy -PermissionGrantPolicyId $Id -BodyParameter $updateParameters | Out-Null
            }

            # Sync Includes - use content-based matching since desired state
            # condition sets may not have Id (auto-generated by Graph API)
            Write-Verbose -Message "Syncing Includes"
            if ($null -ne $Includes)
            {
                $matchedCurrentIncludeIds = @()

                # Find matches for each desired include by content
                foreach ($desiredInclude in $Includes)
                {
                    $matchFound = $false
                    foreach ($currentInclude in $currentPolicy.Includes)
                    {
                        if ($currentInclude.Id -notin $matchedCurrentIncludeIds -and
                            (Test-ConditionSetsEqual -ConditionSet1 $desiredInclude -ConditionSet2 $currentInclude))
                        {
                            $matchedCurrentIncludeIds += $currentInclude.Id
                            $matchFound = $true
                            break
                        }
                    }

                    if (-not $matchFound)
                    {
                        Write-Verbose -Message "Adding include condition set"
                        $includeParams = Get-PermissionGrantConditionSetAsParameters -ConditionSet $desiredInclude
                        New-MgBetaPolicyPermissionGrantPolicyInclude -PermissionGrantPolicyId $Id -BodyParameter $includeParams | Out-Null
                    }
                }

                # Remove current includes that were not matched to any desired include
                foreach ($currentInclude in $currentPolicy.Includes)
                {
                    if ($currentInclude.Id -notin $matchedCurrentIncludeIds)
                    {
                        Write-Verbose -Message "Removing include condition set {$($currentInclude.Id)}"
                        Remove-MgBetaPolicyPermissionGrantPolicyInclude `
                            -PermissionGrantPolicyId $Id `
                            -PermissionGrantConditionSetId $currentInclude.Id | Out-Null
                    }
                }
            }

            # Sync Excludes - use content-based matching since desired state
            # condition sets may not have Id (auto-generated by Graph API)
            Write-Verbose -Message "Syncing Excludes"
            if ($null -ne $Excludes)
            {
                $matchedCurrentExcludeIds = @()

                # Find matches for each desired exclude by content
                foreach ($desiredExclude in $Excludes)
                {
                    $matchFound = $false
                    foreach ($currentExclude in $currentPolicy.Excludes)
                    {
                        if ($currentExclude.Id -notin $matchedCurrentExcludeIds -and
                            (Test-ConditionSetsEqual -ConditionSet1 $desiredExclude -ConditionSet2 $currentExclude))
                        {
                            $matchedCurrentExcludeIds += $currentExclude.Id
                            $matchFound = $true
                            break
                        }
                    }

                    if (-not $matchFound)
                    {
                        Write-Verbose -Message "Adding exclude condition set"
                        $excludeParams = Get-PermissionGrantConditionSetAsParameters -ConditionSet $desiredExclude
                        New-MgBetaPolicyPermissionGrantPolicyExclude -PermissionGrantPolicyId $Id -BodyParameter $excludeParams | Out-Null
                    }
                }

                # Remove current excludes that were not matched to any desired exclude
                foreach ($currentExclude in $currentPolicy.Excludes)
                {
                    if ($currentExclude.Id -notin $matchedCurrentExcludeIds)
                    {
                        Write-Verbose -Message "Removing exclude condition set {$($currentExclude.Id)}"
                        Remove-MgBetaPolicyPermissionGrantPolicyExclude `
                            -PermissionGrantPolicyId $Id `
                            -PermissionGrantConditionSetId $currentExclude.Id | Out-Null
                    }
                }
            }
        }
        # REMOVE
        elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
        {
            Write-Verbose -Message "Removing Entra Permission Grant Policy {$Id}"
            Remove-MgBetaPolicyPermissionGrantPolicy -PermissionGrantPolicyId $Id | Out-Null
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
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
        $Id,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Includes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Excludes,

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

    Write-Verbose -Message "Testing configuration of Entra Permission Grant Policy {$Id}"

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        @compareParameters

    Write-Verbose -Message "Test-TargetResource returned $result"

    return $result
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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array] $exportedInstances = Get-MgBetaPolicyPermissionGrantPolicy -All `
            -ErrorAction Stop

        $dscContent = [System.Text.StringBuilder]::new()
        $i = 1

        if ($exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }

        foreach ($policy in $exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($exportedInstances.Count)] $($policy.Id)" -DeferWrite

            $Params = @{
                Id                    = $policy.Id
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

            $Script:exportedInstance = $policy
            $Results = Get-TargetResource @Params

            if ($null -ne $Results.Includes)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Includes `
                    -CIMInstanceName 'MSFT_AADPermissionGrantConditionSet'
                if (-not [System.String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Includes = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Includes') | Out-Null
                }
            }

            if ($null -ne $Results.Excludes)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Excludes `
                    -CIMInstanceName 'MSFT_AADPermissionGrantConditionSet'
                if (-not [System.String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Excludes = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Excludes') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Includes', 'Excludes')
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
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

#region Helper Functions
function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    # Normalize condition sets in desired values so that permission names
    # compare correctly against the current values.
    return @{
        PostProcessing = {
            param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)

            foreach ($propertyName in @('Includes', 'Excludes'))
            {
                if ($null -ne $ValuesToCheck[$propertyName])
                {
                    $normalizedSets = @()
                    foreach ($conditionSet in $ValuesToCheck[$propertyName])
                    {
                        $normalizedSets += Get-PermissionGrantConditionSetAsHashtable -ConditionSet $conditionSet
                    }
                    $ValuesToCheck[$propertyName] = [Array]$normalizedSets
                    $DesiredValues[$propertyName] = [Array]$normalizedSets
                }
            }

            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
    }
}

<#
.SYNOPSIS
Resolves a ResourceApplication AppId GUID to the service principal display name.

.DESCRIPTION
This helper function takes a ResourceApplication value (typically an AppId GUID returned by the
Microsoft Graph API) and resolves it to the service principal's display name. The wildcard value
'any' and values that are already names (not GUIDs) are returned unchanged.
Uses the module-scoped ServicePrincipalCache for performance.

.PARAMETER ResourceApplication
The ResourceApplication value to resolve. Can be an AppId GUID, a display name, or a wildcard.

.OUTPUTS
System.String
Returns the service principal display name, or the original value if it cannot be resolved.

.EXAMPLE
$name = Resolve-ResourceApplicationName -ResourceApplication '00000003-0000-0000-c000-000000000000'
# Returns 'Microsoft Graph'
#>
function Resolve-ResourceApplicationName
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceApplication
    )

    # Pass through wildcard
    if ($ResourceApplication -eq 'any')
    {
        return $ResourceApplication
    }

    # If not a GUID, assume it is already a display name
    $guidResult = [System.Guid]::Empty
    if (-not [System.Guid]::TryParse($ResourceApplication, [ref]$guidResult))
    {
        return $ResourceApplication
    }

    try
    {
        $cacheKey = $guidResult.ToString()
        if ($Script:ServicePrincipalCache.ContainsKey($cacheKey))
        {
            $servicePrincipal = $Script:ServicePrincipalCache[$cacheKey]
        }
        else
        {
            $servicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$cacheKey'" -ErrorAction SilentlyContinue
            $Script:ServicePrincipalCache[$cacheKey] = $servicePrincipal
            if ($null -ne $servicePrincipal -and -not [System.String]::IsNullOrEmpty($servicePrincipal.DisplayName))
            {
                $Script:ServicePrincipalCache[$servicePrincipal.DisplayName] = $servicePrincipal
            }
        }

        if ($null -ne $servicePrincipal)
        {
            Write-Verbose -Message "Resolved ResourceApplication '$ResourceApplication' to name '$($servicePrincipal.DisplayName)'."
            return $servicePrincipal.DisplayName
        }
    }
    catch
    {
        Write-Verbose -Message "Error resolving ResourceApplication '$ResourceApplication': $_"
    }

    return $ResourceApplication
}

<#
.SYNOPSIS
Resolves a ResourceApplication display name to the service principal AppId GUID.

.DESCRIPTION
This helper function takes a ResourceApplication value (a service principal display name or AppId GUID)
and resolves it to the AppId GUID. Values that are already GUIDs and the wildcard value 'any'
are returned unchanged. The resolved service principal is added to the module-scoped
ServicePrincipalCache for subsequent lookups.

.PARAMETER ResourceApplication
The ResourceApplication value to resolve. Can be a display name, an AppId GUID, or a wildcard.

.OUTPUTS
System.String
Returns the AppId GUID, or the original value if it cannot be resolved.

.EXAMPLE
$appId = Resolve-ResourceApplicationId -ResourceApplication 'Microsoft Graph'
# Returns '00000003-0000-0000-c000-000000000000'
#>
function Resolve-ResourceApplicationId
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceApplication
    )

    # Pass through wildcard
    if ($ResourceApplication -eq 'any')
    {
        return $ResourceApplication
    }

    # If already a GUID, return as-is
    $guidResult = [System.Guid]::Empty
    if ([System.Guid]::TryParse($ResourceApplication, [ref]$guidResult))
    {
        return $ResourceApplication
    }

    try
    {
        # Check if the display name is already in the cache
        if ($Script:ServicePrincipalCache.ContainsKey($ResourceApplication))
        {
            $servicePrincipal = $Script:ServicePrincipalCache[$ResourceApplication]
        }
        else
        {
            # Look up the service principal by display name
            $escapedName = $ResourceApplication -replace "'", "''"
            $servicePrincipal = Get-MgServicePrincipal -Filter "DisplayName eq '$escapedName'" -ErrorAction SilentlyContinue
        }

        if ($null -ne $servicePrincipal)
        {
            # Handle array result (multiple SPs with same name)
            if ($servicePrincipal -is [Array])
            {
                Write-Verbose -Message "Multiple service principals found for DisplayName '$ResourceApplication'. Using the first match."
                $servicePrincipal = $servicePrincipal[0]
            }

            $Script:ServicePrincipalCache[$servicePrincipal.AppId] = $servicePrincipal
            if (-not [System.String]::IsNullOrEmpty($servicePrincipal.DisplayName))
            {
                $Script:ServicePrincipalCache[$servicePrincipal.DisplayName] = $servicePrincipal
            }
            Write-Verbose -Message "Resolved ResourceApplication name '$ResourceApplication' to AppId '$($servicePrincipal.AppId)'."
            return $servicePrincipal.AppId
        }
    }
    catch
    {
        Write-Verbose -Message "Error resolving ResourceApplication name '$ResourceApplication': $_"
    }

    Write-Verbose -Message "Could not resolve ResourceApplication name '$ResourceApplication' to an AppId."
    return $ResourceApplication
}

<#
.SYNOPSIS
Converts a permission display name to its GUID using the resource application's service principal.

.DESCRIPTION
This helper function resolves permission names (e.g., 'User.Read') to their corresponding
GUIDs by looking up the resource application's service principal and checking both
Oauth2PermissionScopes (delegated) and AppRoles (application) collections.
Wildcard values ('all', 'any') and existing GUIDs are passed through unchanged.

.PARAMETER PermissionName
The permission name or GUID to resolve.

.PARAMETER ResourceApplicationId
The appId of the resource application whose service principal contains the permission definitions.

.PARAMETER PermissionType
The type of permission: 'delegated' or 'application'. Used to determine whether to search
Oauth2PermissionScopes or AppRoles.

.OUTPUTS
System.String
Returns the permission GUID, or the original value if it is already a GUID or a wildcard.

.EXAMPLE
$guid = ConvertTo-PermissionGuid -PermissionName 'User.Read' -ResourceApplicationId '00000003-0000-0000-c000-000000000000' -PermissionType 'delegated'
#>
function ConvertTo-PermissionGuid
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $PermissionName,

        [Parameter()]
        [System.String]
        $ResourceApplicationId,

        [Parameter()]
        [System.String]
        $PermissionType
    )

    # Pass through wildcard values
    if ($PermissionName -eq 'all' -or $PermissionName -eq 'any')
    {
        return 'all'
    }

    # Check if already a GUID
    if ([System.Guid]::TryParse($PermissionName, [ref][System.Guid]::Empty))
    {
        return $PermissionName
    }

    # Cannot resolve without a specific resource application
    if ([System.String]::IsNullOrEmpty($ResourceApplicationId) -or
        $ResourceApplicationId -eq 'any')
    {
        Write-Verbose -Message "Cannot resolve permission name '$PermissionName' without a specific ResourceApplication."
        return $PermissionName
    }

    # If ResourceApplicationId is not a GUID, try to resolve it as a service principal name
    $appIdGuid = [System.Guid]::Empty
    if (-not [System.Guid]::TryParse($ResourceApplicationId, [ref]$appIdGuid))
    {
        $resolvedId = Resolve-ResourceApplicationId -ResourceApplication $ResourceApplicationId
        if (-not [System.Guid]::TryParse($resolvedId, [ref]$appIdGuid))
        {
            Write-Verbose -Message "ResourceApplication '$ResourceApplicationId' could not be resolved to a valid GUID."
            return $PermissionName
        }
        $ResourceApplicationId = $resolvedId
    }

    try
    {
        $cacheKey = $appIdGuid.ToString()
        if ($Script:ServicePrincipalCache.ContainsKey($cacheKey))
        {
            Write-Verbose -Message "Using cached service principal for ResourceApplication '$ResourceApplicationId'."
            $servicePrincipal = $Script:ServicePrincipalCache[$cacheKey]
        }
        else
        {
            $servicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$cacheKey'" -ErrorAction SilentlyContinue
            $Script:ServicePrincipalCache[$cacheKey] = $servicePrincipal
            if ($null -ne $servicePrincipal -and -not [System.String]::IsNullOrEmpty($servicePrincipal.DisplayName))
            {
                $Script:ServicePrincipalCache[$servicePrincipal.DisplayName] = $servicePrincipal
            }
        }

        if ($null -eq $servicePrincipal)
        {
            Write-Verbose -Message "Service principal for ResourceApplication '$ResourceApplicationId' not found."
            return $PermissionName
        }

        if ($PermissionType -eq 'delegated')
        {
            $scope = $servicePrincipal.Oauth2PermissionScopes | Where-Object { $_.Value -eq $PermissionName }
            if ($null -ne $scope)
            {
                Write-Verbose -Message "Resolved delegated permission '$PermissionName' to GUID '$($scope.Id)'."
                return $scope.Id.ToString()
            }
        }
        elseif ($PermissionType -eq 'application')
        {
            $role = $servicePrincipal.AppRoles | Where-Object { $_.Value -eq $PermissionName }
            if ($null -ne $role)
            {
                Write-Verbose -Message "Resolved application permission '$PermissionName' to GUID '$($role.Id)'."
                return $role.Id.ToString()
            }
        }

        # Try both collections if PermissionType is not specified or not found
        $scope = $servicePrincipal.Oauth2PermissionScopes | Where-Object { $_.Value -eq $PermissionName }
        if ($null -ne $scope)
        {
            Write-Verbose -Message "Resolved permission '$PermissionName' to GUID '$($scope.Id)' from Oauth2PermissionScopes."
            return $scope.Id.ToString()
        }

        $role = $servicePrincipal.AppRoles | Where-Object { $_.Value -eq $PermissionName }
        if ($null -ne $role)
        {
            Write-Verbose -Message "Resolved permission '$PermissionName' to GUID '$($role.Id)' from AppRoles."
            return $role.Id.ToString()
        }

        Write-Verbose -Message "Permission '$PermissionName' not found in service principal for '$ResourceApplicationId'."
    }
    catch
    {
        Write-Verbose -Message "Error resolving permission '$PermissionName': $_"
    }

    return $PermissionName
}

<#
.SYNOPSIS
Converts a permission GUID to its display name.

.DESCRIPTION
This helper function takes a permission GUID and resolves it to its display name
by looking up the service principal's Oauth2PermissionScopes (delegated) and AppRoles (application).
Values that are already display names (non-GUID strings) and wildcard values ('all', 'any')
are returned unchanged.

.PARAMETER PermissionId
The permission GUID to resolve.

.PARAMETER ResourceApplicationId
The AppId GUID of the resource application (service principal) that defines the permission.
Required for resolution. If not provided or set to a wildcard, the original value is returned.

.PARAMETER PermissionType
The type of permission: 'delegated' or 'application'. Used to search the correct collection first.

.OUTPUTS
System.String
Returns the permission display name, or the original value if it cannot be resolved.

.EXAMPLE
$name = ConvertTo-PermissionName -PermissionId 'e1fe6dd8-ba31-4d61-89e7-88639da4683d' -ResourceApplicationId '00000003-0000-0000-c000-000000000000' -PermissionType 'delegated'
# Returns 'User.Read'
#>
function ConvertTo-PermissionName
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $PermissionId,

        [Parameter()]
        [System.String]
        $ResourceApplicationId,

        [Parameter()]
        [System.String]
        $PermissionType
    )

    # Pass through wildcard values
    if ($PermissionId -eq 'all' -or $PermissionId -eq 'any')
    {
        return $PermissionId
    }

    # If not a GUID, assume it is already a display name
    $guidResult = [System.Guid]::Empty
    if (-not [System.Guid]::TryParse($PermissionId, [ref]$guidResult))
    {
        return $PermissionId
    }

    # Cannot resolve without a specific resource application
    if ([System.String]::IsNullOrEmpty($ResourceApplicationId) -or
        $ResourceApplicationId -eq 'any')
    {
        Write-Verbose -Message "Cannot resolve permission GUID '$PermissionId' without a specific ResourceApplication."
        return $PermissionId
    }

    # If ResourceApplicationId is not a GUID, try to resolve it as a service principal name
    $appIdGuid = [System.Guid]::Empty
    if (-not [System.Guid]::TryParse($ResourceApplicationId, [ref]$appIdGuid))
    {
        $resolvedId = Resolve-ResourceApplicationId -ResourceApplication $ResourceApplicationId
        if (-not [System.Guid]::TryParse($resolvedId, [ref]$appIdGuid))
        {
            Write-Verbose -Message "ResourceApplication '$ResourceApplicationId' could not be resolved to a valid GUID."
            return $PermissionId
        }
        $ResourceApplicationId = $resolvedId
    }

    try
    {
        $cacheKey = $appIdGuid.ToString()
        if ($Script:ServicePrincipalCache.ContainsKey($cacheKey))
        {
            Write-Verbose -Message "Using cached service principal for ResourceApplication '$ResourceApplicationId'."
            $servicePrincipal = $Script:ServicePrincipalCache[$cacheKey]
        }
        else
        {
            $servicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$cacheKey'" -ErrorAction SilentlyContinue
            $Script:ServicePrincipalCache[$cacheKey] = $servicePrincipal
        }

        if ($null -eq $servicePrincipal)
        {
            Write-Verbose -Message "Service principal for ResourceApplication '$ResourceApplicationId' not found."
            return $PermissionId
        }

        if ($PermissionType -eq 'delegated')
        {
            $scope = $servicePrincipal.Oauth2PermissionScopes | Where-Object { $_.Id -eq $guidResult }
            if ($null -ne $scope)
            {
                Write-Verbose -Message "Resolved delegated permission GUID '$PermissionId' to name '$($scope.Value)'."
                return $scope.Value
            }
        }
        elseif ($PermissionType -eq 'application')
        {
            $role = $servicePrincipal.AppRoles | Where-Object { $_.Id -eq $guidResult }
            if ($null -ne $role)
            {
                Write-Verbose -Message "Resolved application permission GUID '$PermissionId' to name '$($role.Value)'."
                return $role.Value
            }
        }

        # Try both collections if PermissionType is not specified or not found
        $scope = $servicePrincipal.Oauth2PermissionScopes | Where-Object { $_.Id -eq $guidResult }
        if ($null -ne $scope)
        {
            Write-Verbose -Message "Resolved permission GUID '$PermissionId' to name '$($scope.Value)' from Oauth2PermissionScopes."
            return $scope.Value
        }

        $role = $servicePrincipal.AppRoles | Where-Object { $_.Id -eq $guidResult }
        if ($null -ne $role)
        {
            Write-Verbose -Message "Resolved permission GUID '$PermissionId' to name '$($role.Value)' from AppRoles."
            return $role.Value
        }

        Write-Verbose -Message "Permission GUID '$PermissionId' not found in service principal for '$ResourceApplicationId'."
    }
    catch
    {
        Write-Verbose -Message "Error resolving permission GUID '$PermissionId': $_"
    }

    return $PermissionId
}

<#
.SYNOPSIS
Converts a permission grant condition set object to a hashtable representation.

.DESCRIPTION
This helper function takes a condition set object (from the Microsoft Graph API)
and converts it to a hashtable format suitable for DSC configuration comparison.
Only non-null properties are included in the result.

.PARAMETER ConditionSet
The condition set object to convert. This can be a PSCustomObject from the Graph API
or a hashtable/CIM instance from DSC configuration.

.OUTPUTS
System.Collections.Hashtable

.EXAMPLE
$hashtable = Get-PermissionGrantConditionSetAsHashtable -ConditionSet $graphObject
#>
function Get-PermissionGrantConditionSetAsHashtable
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $ConditionSet
    )

    $result = @{
        Id = $ConditionSet.Id
    }

    if ($null -ne $ConditionSet.CertifiedClientApplicationsOnly)
    {
        $result.Add('CertifiedClientApplicationsOnly', $ConditionSet.CertifiedClientApplicationsOnly)
    }

    if ($null -ne $ConditionSet.ClientApplicationIds)
    {
        $result.Add('ClientApplicationIds', [string[]]$ConditionSet.ClientApplicationIds)
    }

    if ($null -ne $ConditionSet.ClientApplicationPublisherIds)
    {
        $result.Add('ClientApplicationPublisherIds', [string[]]$ConditionSet.ClientApplicationPublisherIds)
    }

    if ($null -ne $ConditionSet.ClientApplicationTenantIds)
    {
        $result.Add('ClientApplicationTenantIds', [string[]]$ConditionSet.ClientApplicationTenantIds)
    }

    if ($null -ne $ConditionSet.ClientApplicationsFromVerifiedPublisherOnly)
    {
        $result.Add('ClientApplicationsFromVerifiedPublisherOnly', $ConditionSet.ClientApplicationsFromVerifiedPublisherOnly)
    }

    if ($null -ne $ConditionSet.PermissionClassification)
    {
        $result.Add('PermissionClassification', $ConditionSet.PermissionClassification)
    }

    if ($null -ne $ConditionSet.PermissionType)
    {
        $result.Add('PermissionType', $ConditionSet.PermissionType)
    }

    if ($null -ne $ConditionSet.ResourceApplication)
    {
        $result.Add('ResourceApplication', $ConditionSet.ResourceApplication)
    }

    if ($null -ne $ConditionSet.Permissions)
    {
        $resolvedPermissions = @()
        foreach ($permission in $ConditionSet.Permissions)
        {
            $resolvedPermissions += ConvertTo-PermissionName `
                -PermissionId $permission `
                -ResourceApplicationId $ConditionSet.ResourceApplication `
                -PermissionType $ConditionSet.PermissionType
        }
        $result.Add('Permissions', [string[]]$resolvedPermissions)
    }

    return $result
}

<#
.SYNOPSIS
Converts a condition set to Microsoft Graph API parameters.

.DESCRIPTION
This helper function takes a condition set (from DSC configuration) and converts it
to a hashtable of parameters suitable for passing to Microsoft Graph API cmdlets
(New-MgBetaPolicyPermissionGrantPolicyInclude/Exclude).

.PARAMETER ConditionSet
The condition set to convert. This can be a CIM instance or hashtable.

.OUTPUTS
System.Collections.Hashtable

.EXAMPLE
$params = Get-PermissionGrantConditionSetAsParameters -ConditionSet $cimInstance
New-MgBetaPolicyPermissionGrantPolicyInclude -BodyParameter $params
#>
function Get-PermissionGrantConditionSetAsParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $ConditionSet
    )

    $params = @{}

    if ($null -ne $ConditionSet.CertifiedClientApplicationsOnly)
    {
        $params.Add('CertifiedClientApplicationsOnly', [bool]$ConditionSet.CertifiedClientApplicationsOnly)
    }

    if ($null -ne $ConditionSet.ClientApplicationIds -and $ConditionSet.ClientApplicationIds.Count -gt 0)
    {
        $params.Add('ClientApplicationIds', [string[]]$ConditionSet.ClientApplicationIds)
    }

    if ($null -ne $ConditionSet.ClientApplicationPublisherIds -and $ConditionSet.ClientApplicationPublisherIds.Count -gt 0)
    {
        $params.Add('ClientApplicationPublisherIds', [string[]]$ConditionSet.ClientApplicationPublisherIds)
    }

    if ($null -ne $ConditionSet.ClientApplicationTenantIds -and $ConditionSet.ClientApplicationTenantIds.Count -gt 0)
    {
        $params.Add('ClientApplicationTenantIds', [string[]]$ConditionSet.ClientApplicationTenantIds)
    }

    if ($null -ne $ConditionSet.ClientApplicationsFromVerifiedPublisherOnly)
    {
        $params.Add('ClientApplicationsFromVerifiedPublisherOnly', [bool]$ConditionSet.ClientApplicationsFromVerifiedPublisherOnly)
    }

    if (-not [string]::IsNullOrEmpty($ConditionSet.PermissionClassification))
    {
        $params.Add('PermissionClassification', $ConditionSet.PermissionClassification)
    }

    # Pass through ResourceApplication as-is (expects GUID or 'any')
    if (-not [string]::IsNullOrEmpty($ConditionSet.ResourceApplication))
    {
        $params.Add('ResourceApplication', $ConditionSet.ResourceApplication)
    }

    if (-not [string]::IsNullOrEmpty($ConditionSet.PermissionType))
    {
        $params.Add('PermissionType', $ConditionSet.PermissionType)
    }

    # Convert permission names to GUIDs
    if ($null -ne $ConditionSet.Permissions -and $ConditionSet.Permissions.Count -gt 0)
    {
        $resourceAppValue = $ConditionSet.ResourceApplication

        $resolvedPermissions = @()
        foreach ($permission in $ConditionSet.Permissions)
        {
            $resolvedPermissions += ConvertTo-PermissionGuid `
                -PermissionName $permission `
                -ResourceApplicationId $resourceAppValue `
                -PermissionType $ConditionSet.PermissionType
        }
        $params.Add('Permissions', [string[]]$resolvedPermissions)
    }

    return $params
}

<#
.SYNOPSIS
Compares two permission grant condition sets for equality.

.DESCRIPTION
This helper function performs a deep comparison of two condition sets to determine
if they are logically equivalent. Array properties are compared after sorting to
ensure order-independent comparison.

.PARAMETER ConditionSet1
The first condition set to compare.

.PARAMETER ConditionSet2
The second condition set to compare.

.OUTPUTS
System.Boolean
Returns $true if the condition sets are equivalent, $false otherwise.

.EXAMPLE
$areEqual = Test-ConditionSetsEqual -ConditionSet1 $desired -ConditionSet2 $current
#>
function Test-ConditionSetsEqual
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $ConditionSet1,

        [Parameter(Mandatory = $true)]
        [System.Object]
        $ConditionSet2
    )

    # Convert both to hashtables for comparison
    $hash1 = Get-PermissionGrantConditionSetAsHashtable -ConditionSet $ConditionSet1
    $hash2 = Get-PermissionGrantConditionSetAsHashtable -ConditionSet $ConditionSet2

    # Compare each property, skipping Id (auto-generated by Graph API)
    foreach ($key in $hash1.Keys)
    {
        if ($key -eq 'Id')
        {
            continue
        }

        if (-not $hash2.ContainsKey($key))
        {
            return $false
        }

        $value1 = $hash1[$key]
        $value2 = $hash2[$key]

        # Handle array comparison
        if ($value1 -is [Array] -and $value2 -is [Array])
        {
            if ($value1.Count -ne $value2.Count)
            {
                return $false
            }

            $sorted1 = $value1 | Sort-Object
            $sorted2 = $value2 | Sort-Object

            for ($i = 0; $i -lt $sorted1.Count; $i++)
            {
                if ($sorted1[$i] -ne $sorted2[$i])
                {
                    return $false
                }
            }
        }
        else
        {
            if ($value1 -ne $value2)
            {
                return $false
            }
        }
    }

    # Check for keys in hash2 that are not in hash1 (excluding Id)
    foreach ($key in $hash2.Keys)
    {
        if ($key -eq 'Id')
        {
            continue
        }

        if (-not $hash1.ContainsKey($key))
        {
            return $false
        }
    }

    return $true
}

#endregion

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
