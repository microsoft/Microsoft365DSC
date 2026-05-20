Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADEntitlementManagementAccessPackage'

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
        $DisplayName,

        [Parameter()]
        [System.String]
        $CatalogId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsHidden,

        [Parameter()]
        [System.Boolean]
        $IsRoleScopesVisible,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AccessPackageResourceRoleScopes,

        [Parameter()]
        [System.String[]]
        $IncompatibleAccessPackages,

        [Parameter()]
        [System.String[]]
        $AccessPackagesIncompatibleWith,

        [Parameter()]
        [System.String[]]
        $IncompatibleGroups,
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

    Write-Verbose -Message "Getting configuration of AzureAD Entitlement Management Access Package for DisplayName {$DisplayName}"

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

            if (-not [System.String]::IsNullOrEmpty($id))
            {
                $getValue = Get-MgBetaEntitlementManagementAccessPackage -AccessPackageId $id `
                    -ExpandProperty "accessPackageResourceRoleScopes(`$expand=accessPackageResourceRole,accessPackageResourceScope)" `
                    -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                if (-not [System.String]::IsNullOrEmpty($id))
                {
                    Write-Verbose -Message "Could not find an Azure AD Entitlement Management Access Package with Id {$id}"
                }

                if (-not [string]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaEntitlementManagementAccessPackage `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" `
                        -ExpandProperty "accessPackageResourceRoleScopes(`$expand=accessPackageResourceRole,accessPackageResourceScope)" `
                        -ErrorAction SilentlyContinue
                }
            }
        }
        else
        {
            $getValue = Get-MgBetaEntitlementManagementAccessPackage -AccessPackageId $Id `
                -ExpandProperty "accessPackageResourceRoleScopes(`$expand=accessPackageResourceRole,accessPackageResourceScope)" `
                -ErrorAction SilentlyContinue
        }

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "No Azure AD Entitlement Management Access Package with DisplayName {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found access package with id {$($getValue.id)} and displayName {$($getValue.displayName)}"

        $getAccessPackageResourceRoleScopes = @()
        foreach ($accessPackageResourceRoleScope in $getValue.AccessPackageResourceRoleScopes)
        {
            $getAccessPackageResourceRoleScopes += @{
                Id                                   = $accessPackageResourceRoleScope.Id
                AccessPackageResourceOriginId        = $accessPackageResourceRoleScope.AccessPackageResourceScope.OriginId
                AccessPackageResourceRoleDisplayName = $accessPackageResourceRoleScope.AccessPackageResourceRole.DisplayName
            }
        }

        $catalog = Get-MgBetaEntitlementManagementAccessPackageCatalog -AccessPackageCatalog $getValue.CatalogId

        $getIncompatibleAccessPackages = @()
        [Array]$query = Get-MgBetaEntitlementManagementAccessPackageIncompatibleAccessPackage -AccessPackageId $getValue.id
        if ($query.Count -gt 0)
        {
            $getIncompatibleAccessPackages += $query.id
        }


        $getAccessPackagesIncompatibleWith = @()
        [Array]$query = Get-MgBetaEntitlementManagementAccessPackageIncompatibleWith -AccessPackageId $getValue.id
        if ($query.Count -gt 0)
        {
            $getAccessPackagesIncompatibleWith += $query.id
        }

        $getIncompatibleGroups = @()
        [Array]$query = Get-MgBetaEntitlementManagementAccessPackageIncompatibleGroup -AccessPackageId $getValue.id
        if ($query.Count -gt 0)
        {
            $getIncompatibleGroups += $query.id
        }

        $results = @{
            Id                              = $getValue.Id
            CatalogId                       = $catalog.DisplayName
            Description                     = $getValue.Description
            DisplayName                     = $getValue.DisplayName
            IsHidden                        = $getValue.IsHidden
            IsRoleScopesVisible             = $getValue.IsRoleScopesVisible
            AccessPackageResourceRoleScopes = $getAccessPackageResourceRoleScopes
            IncompatibleAccessPackages      = $getIncompatibleAccessPackages
            AccessPackagesIncompatibleWith  = $getAccessPackagesIncompatibleWith #read-only
            IncompatibleGroups              = $getIncompatibleGroups
            Ensure                          = 'Present'
            Credential                      = $Credential
            ApplicationId                   = $ApplicationId
            TenantId                        = $TenantId
            ApplicationSecret               = $ApplicationSecret
            CertificateThumbprint           = $CertificateThumbprint
            ManagedIdentity                 = $ManagedIdentity.IsPresent
            AccessTokens                    = $AccessTokens
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $CatalogId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsHidden,

        [Parameter()]
        [System.Boolean]
        $IsRoleScopesVisible,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AccessPackageResourceRoleScopes,

        [Parameter()]
        [System.String[]]
        $IncompatibleAccessPackages,

        [Parameter()]
        [System.String[]]
        $AccessPackagesIncompatibleWith,

        [Parameter()]
        [System.String[]]
        $IncompatibleGroups,
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

    Write-Verbose -Message "Setting configuration of AzureAD Entitlement Management Access Package for DisplayName {$DisplayName}"

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
        Write-Verbose -Message "Creating access package {$DisplayName}"

        #region basic information
        $CreateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

        if (-not [System.Guid]::TryParse($CreateParameters.CatalogId, [ref][System.Guid]::Empty))
        {
            $catalogInstance = Get-MgBetaEntitlementManagementAccessPackageCatalog -Filter "DisplayName eq '$($CreateParameters.CatalogId -replace "'", "''")'"
            if ($catalogInstance)
            {
                $CreateParameters.CatalogId = $catalogInstance.Id
            }
        }

        $CreateParameters.Remove('Id') | Out-Null
        $CreateParameters.Remove('AccessPackageResourceRoleScopes') | Out-Null
        $CreateParameters.Remove('IncompatibleAccessPackages') | Out-Null
        $CreateParameters.Remove('AccessPackagesIncompatibleWith') | Out-Null
        $CreateParameters.Remove('IncompatibleGroups') | Out-Null

        $accessPackage = New-MgBetaEntitlementManagementAccessPackage `
            -BodyParameter $CreateParameters

        #endregion

        #region IncompatibleAccessPackages
        foreach ($incompatibleAccessPackage in $IncompatibleAccessPackages)
        {
            $ref = @{
                '@odata.id' = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/identityGovernance/entitlementManagement/accessPackages/$incompatibleAccessPackage"
            }

            New-MgBetaEntitlementManagementAccessPackageIncompatibleAccessPackageByRef `
                -AccessPackageId $accessPackage.Id `
                -OdataId $ref.'@odata.id'
        }
        #endregion

        #region IncompatibleGroups
        foreach ($IncompatibleGroup in $IncompatibleGroups)
        {
            $ref = @{
                '@odata.id' = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/groups/$IncompatibleGroup"
            }

            New-MgBetaEntitlementManagementAccessPackageIncompatibleGroupByRef `
                -AccessPackageId $accessPackage.Id `
                -OdataId $ref.'@odata.id'
        }
        #endregion

        #region AccessPackageResourceRoleScopes
        foreach ($accessPackageResourceRoleScope in $AccessPackageResourceRoleScopes)
        {
            #Add scopeRole
            $originId = $accessPackageResourceRoleScope.AccessPackageResourceOriginId
            $roleName = $accessPackageResourceRoleScope.AccessPackageResourceRoleDisplayName

            Write-Verbose -Message "Adding roleScope {$originId`:$roleName} to access package with Id {$($accessPackage.Id)}"

            $resourceScope = Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResource `
                -AccessPackageCatalogId $CreateParameters.CatalogId `
                -Filter "originId eq '$originId'" `
                -ExpandProperty 'accessPackageResourceScopes'

            $resourceRole = Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResourceRole `
                -AccessPackageCatalogId $CatalogId `
                -Filter "(accessPackageResource/Id eq '$($resourceScope.id)' and DisplayName eq '$($roleName -replace "'", "''")' and originSystem eq '$($resourceScope.originSystem)')" `
                -ExpandProperty 'accessPackageResource'

            $isValidRoleScope = $true
            if ($null -eq $resourceScope)
            {
                Write-Verbose -Message "The AccessPackageResourceOriginId {$originId} could not be found in catalog with id {$CatalogId}"
                $isValidRoleScope = $false
            }

            if ($null -eq $resourceRole)
            {
                Write-Verbose -Message "The AccessPackageResourceRoleDisplayName {$roleName} could not be found for resource with originID {$originId}"
                $isValidRoleScope = $false
            }

            if ($isValidRoleScope)
            {
                $params = [ordered]@{
                    AccessPackageResourceRole  = @{
                        OriginId              = $resourceRole.OriginId
                        DisplayName           = $resourceRole.DisplayName
                        OriginSystem          = $resourceRole.OriginSystem
                        AccessPackageResource = @{
                            Id           = $resourceScope.Id
                            ResourceType = $resourceScope.ResourceType
                            OriginId     = $resourceScope.OriginId
                            OriginSystem = $resourceRole.OriginSystem
                        }
                    }
                    AccessPackageResourceScope = @{
                        OriginId     = $resourceScope.OriginId
                        OriginSystem = $resourceScope.OriginSystem
                        IsRootScope  = $resourceScope.AccessPackageResourceScopes[0].IsRootScope
                    }
                }

                Write-Verbose -Message ("package id {$($accessPackage.Id)}")
                Write-Verbose -Message ($params | ConvertTo-Json -Depth 20)
                New-MgBetaEntitlementManagementAccessPackageResourceRoleScope -AccessPackageId $accessPackage.Id -BodyParameter $params
            }
        }
        #endregion

    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating access package with id {$id} and displayName {$DisplayName}"

        #region basic information
        $UpdateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

        if (-not [System.Guid]::TryParse($CreateParameters.CatalogId, [ref][System.Guid]::Empty))
        {
            $catalogInstance = Get-MgBetaEntitlementManagementAccessPackageCatalog -Filter "DisplayName eq '$($UpdateParameters.CatalogId -replace "'", "''")'"
            if ($catalogInstance)
            {
                $UpdateParameters.CatalogId = $catalogInstance.Id
            }
        }

        $UpdateParameters.Remove('Id') | Out-Null
        $UpdateParameters.Remove('AccessPackageResourceRoleScopes') | Out-Null
        $UpdateParameters.Remove('IncompatibleAccessPackages') | Out-Null
        $UpdateParameters.Remove('AccessPackagesIncompatibleWith') | Out-Null
        $UpdateParameters.Remove('IncompatibleGroups') | Out-Null

        Update-MgBetaEntitlementManagementAccessPackage -BodyParameter $UpdateParameters `
            -AccessPackageId $currentInstance.Id
        #endregion

        #region IncompatibleAccessPackages
        [Array]$currentIncompatibleAccessPackages = $currentInstance.IncompatibleAccessPackages
        if ($null -eq $currentIncompatibleAccessPackages)
        {
            $currentIncompatibleAccessPackages = @()
        }
        if ($null -eq $IncompatibleAccessPackages)
        {
            $IncompatibleAccessPackages = @()
        }
        [Array]$compareResult = Compare-Object `
            -ReferenceObject $IncompatibleAccessPackages `
            -DifferenceObject $currentIncompatibleAccessPackages `

        [Array]$toBeAdded = $compareResult | Where-Object -FilterScript { $_.SideIndicator -eq '<=' }

        foreach ($incompatibleAccessPackage in $toBeAdded.InputObject)
        {
            $ref = @{
                '@odata.id' = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/identityGovernance/entitlementManagement/accessPackages/$incompatibleAccessPackage"
            }

            New-MgBetaEntitlementManagementAccessPackageIncompatibleAccessPackageByRef `
                -AccessPackageId $currentInstance.Id `
                -OdataId $ref.'@odata.id'
        }

        [Array]$toBeRemoved = $compareResult | Where-Object -FilterScript { $_.SideIndicator -eq '=>' }

        foreach ($incompatibleAccessPackage in $toBeRemoved.InputObject)
        {
            Remove-MgBetaEntitlementManagementAccessPackageIncompatibleAccessPackageByRef `
                -AccessPackageId $currentInstance.Id `
                -AccessPackageId1 $incompatibleAccessPackage
        }
        #endregion

        #region IncompatibleGroups
        [Array]$currentIncompatibleGroups = $currentInstance.IncompatibleGroups
        if ($null -eq $currentIncompatibleGroups)
        {
            $currentIncompatibleGroups = @()
        }
        if ($null -eq $IncompatibleGroups)
        {
            $IncompatibleGroups = @()
        }
        [Array]$compareResult = Compare-Object `
            -ReferenceObject $IncompatibleGroups `
            -DifferenceObject $currentIncompatibleGroups `

        [Array]$toBeAdded = $compareResult | Where-Object -FilterScript { $_.SideIndicator -eq '<=' }
        foreach ($incompatibleGroup in $tobeAdded.InputObject)
        {

            $ref = @{
                '@odata.id' = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/groups/$incompatibleGroup"
            }

            New-MgBetaEntitlementManagementAccessPackageIncompatibleGroupByRef `
                -AccessPackageId $currentInstance.Id `
                -OdataId $ref.'@odata.id'
        }

        [Array]$toBeRemoved = $compareResult | Where-Object -FilterScript { $_.SideIndicator -eq '=>' }

        foreach ($IncompatibleGroup in $toBeRemoved.InputObject)
        {
            Remove-MgBetaEntitlementManagementAccessPackageIncompatibleGroupByRef `
                -AccessPackageId $currentInstance.Id `
                -GroupId $incompatibleGroup
        }
        #endregion

        #region AccessPackageResourceRoleScopes
        $currentAccessPackageResourceOriginIds = $currentInstance.AccessPackageResourceRoleScopes.AccessPackageResourceOriginId
        foreach ($accessPackageResourceRoleScope in $AccessPackageResourceRoleScopes)
        {
            if ($accessPackageResourceRoleScope.AccessPackageResourceOriginId -notin ($currentAccessPackageResourceOriginIds))
            {
                #region new roleScope
                $originId = $accessPackageResourceRoleScope.AccessPackageResourceOriginId
                $roleName = $accessPackageResourceRoleScope.AccessPackageResourceRoleDisplayName

                Write-Verbose -Message "Adding roleScope {$originId`:$roleName} to access package with Id {$($currentInstance.Id)}"

                $resourceScope = Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResource `
                    -AccessPackageCatalogId $UpdateParameters.CatalogId `
                    -Filter "originId eq '$originId'" `
                    -ExpandProperty 'accessPackageResourceScopes'

                $resourceRole = Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResourceRole `
                    -AccessPackageCatalogId $CatalogId `
                    -Filter "(accessPackageResource/Id eq '$($resourceScope.id)' and DisplayName eq '$($roleName -replace "'", "''")' and originSystem eq '$($resourceScope.originSystem)')" `
                    -ExpandProperty 'accessPackageResource'

                $isValidRoleScope = $true
                if ($null -eq $resourceScope)
                {
                    Write-Verbose -Message "The AccessPackageResourceOriginId {$originId} could not be found in catalog with id {$CatalogId}"
                    $isValidRoleScope = $false
                }

                if ($null -eq $resourceRole)
                {
                    Write-Verbose -Message "The AccessPackageResourceRoleDisplayName {$roleName} could not be found for resource with originID {$originId}"
                    $isValidRoleScope = $false
                }

                if ($isValidRoleScope)
                {
                    $params = [ordered]@{
                        AccessPackageResourceRole  = @{
                            OriginId              = $resourceRole.OriginId
                            DisplayName           = $resourceRole.DisplayName
                            OriginSystem          = $resourceRole.OriginSystem
                            AccessPackageResource = @{
                                Id           = $resourceScope.Id
                                ResourceType = $resourceScope.ResourceType
                                OriginId     = $resourceScope.OriginId
                                OriginSystem = $resourceRole.OriginSystem
                            }
                        }
                        AccessPackageResourceScope = @{
                            OriginId     = $resourceScope.OriginId
                            OriginSystem = $resourceScope.OriginSystem
                            IsRootScope  = $resourceScope.AccessPackageResourceScopes[0].IsRootScope
                        }
                    }

                    New-MgBetaEntitlementManagementAccessPackageResourceRoleScope -AccessPackageId $currentInstance.Id -BodyParameter $params
                }
                #endregion
            }
            else
            {
                $currentRole = $currentInstance.AccessPackageResourceRoleScopes | Where-Object `
                    -FilterScript { $_.AccessPackageResourceOriginId -eq $accessPackageResourceRoleScope.AccessPackageResourceOriginId }
                if ($accessPackageResourceRoleScope.AccessPackageResourceRoleDisplayName -ne $currentRole.AccessPackageResourceRoleDisplayName )
                {
                    #region update role

                    $originId = $accessPackageResourceRoleScope.AccessPackageResourceOriginId
                    $roleName = $accessPackageResourceRoleScope.AccessPackageResourceRoleDisplayName

                    Write-Verbose -Message "Updating role {$roleName} from access package rolescope with Id {$($accessPackageResourceRoleScope.id)}"

                    $resourceScope = Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResource `
                        -AccessPackageCatalogId $UpdateParameters.CatalogId `
                        -Filter "originId eq '$originId'" `
                        -ExpandProperty 'accessPackageResourceScopes'

                    $resourceRole = Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResourceRole `
                        -AccessPackageCatalogId $CatalogId `
                        -Filter "(accessPackageResource/Id eq '$($resourceScope.id)' and DisplayName eq '$($roleName -replace "'", "''")' and originSystem eq '$($resourceScope.originSystem)')" `
                        -ExpandProperty 'accessPackageResource'

                    $isValidRoleScope = $true
                    if ($null -eq $resourceScope)
                    {
                        Write-Verbose -Message "The AccessPackageResourceOriginId {$originId} could not be found in catalog with id {$CatalogId}"
                        $isValidRoleScope = $false
                    }

                    if ($null -eq $resourceRole)
                    {
                        Write-Verbose -Message "The AccessPackageResourceRoleDisplayName {$roleName} could not be found for resource with originID {$originId}"
                        $isValidRoleScope = $false
                    }

                    if ($isValidRoleScope)
                    {
                        $params = [ordered]@{
                            AccessPackageResourceRole  = @{
                                OriginId              = $resourceRole.OriginId
                                DisplayName           = $resourceRole.DisplayName
                                OriginSystem          = $resourceRole.OriginSystem
                                AccessPackageResource = @{
                                    Id           = $resourceScope.Id
                                    ResourceType = $resourceScope.ResourceType
                                    OriginId     = $resourceScope.OriginId
                                    OriginSystem = $resourceRole.OriginSystem
                                }
                            }
                            AccessPackageResourceScope = @{
                                OriginId     = $resourceScope.OriginId
                                OriginSystem = $resourceScope.OriginSystem
                                IsRootScope  = $resourceScope.AccessPackageResourceScopes[0].IsRootScope
                            }
                        }

                        #write-verbose -message ($params|convertTo-json -depth 20)

                        Remove-MgBetaEntitlementManagementAccessPackageResourceRoleScope `
                            -AccessPackageId $currentInstance.Id `
                            -AccessPackageResourceRoleScopeId $currentRole.Id

                        New-MgBetaEntitlementManagementAccessPackageResourceRoleScope `
                            -AccessPackageId $currentInstance.Id `
                            -BodyParameter $params

                    }
                    #endregion
                }
            }
        }

        #region remove roleScope
        $currentAccessPackageResourceOriginIdsToRemove = $currentAccessPackageResourceOriginIds | Where-Object `
            -FilterScript { $_ -notin $AccessPackageResourceRoleScopes.AccessPackageResourceOriginId }
        foreach ($originId in $currentAccessPackageResourceOriginIdsToRemove)
        {

            $currentRoleScope = $currentInstance.AccessPackageResourceRoleScopes | Where-Object `
                -FilterScript { $_.AccessPackageResourceOriginId -eq $originId }

            Write-Verbose -Message "Removing RoleScope with originId {$originId} from access package {$($currentInstance.Id)}"

            Remove-MgBetaEntitlementManagementAccessPackageResourceRoleScope `
                -AccessPackageId $currentInstance.Id `
                -AccessPackageResourceRoleScopeId $currentRoleScope.Id
        }
        #endregion

    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing access package with id {$id} and displayName {$DisplayName}"

        #region resource generator code
        Remove-MgBetaEntitlementManagementAccessPackage -AccessPackageId $currentInstance.Id
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
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $CatalogId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsHidden,

        [Parameter()]
        [System.Boolean]
        $IsRoleScopesVisible,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AccessPackageResourceRoleScopes,

        [Parameter()]
        [System.String[]]
        $IncompatibleAccessPackages,

        [Parameter()]
        [System.String[]]
        $AccessPackagesIncompatibleWith,

        [Parameter()]
        [System.String[]]
        $IncompatibleGroups,
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
        [array]$getValue = Get-MgBetaEntitlementManagementAccessPackage `
            -All `
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

            $displayedKey = $config.id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.id
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
            if ($null -ne $Results.AccessPackageResourceRoleScopes)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ([Array]$Results.AccessPackageResourceRoleScopes) `
                    -CIMInstanceName AccessPackageResourceRoleScope

                $Results.AccessPackageResourceRoleScopes = $complexTypeStringResult

                if ([String]::IsNullOrEmpty($complexTypeStringResult))
                {
                    $Results.Remove('AccessPackageResourceRoleScopes') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('AccessPackageResourceRoleScopes')

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
            return ''
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
