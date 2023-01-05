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

        [Parameter()]
        [System.String]
        $CatalogId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

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

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
            -ProfileName 'beta'
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
        $getValue = Get-MgEntitlementManagementAccessPackage -AccessPackageId $id `
            -ExpandProperty "accessPackageResourceRoleScopes(`$expand=accessPackageResourceRole,accessPackageResourceScope)" `
            -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Nothing with id {$id} was found"

            if(-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgEntitlementManagementAccessPackage `
                    -Filter "displayName eq '$DisplayName'" `
                    -ExpandProperty "accessPackageResourceRoleScopes(`$expand=accessPackageResourceRole,accessPackageResourceScope)" `
                    -ErrorAction SilentlyContinue
            }
        }
        #endregion

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Nothing with DisplayName {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found access package with id {$($getValue.id)} and displayName {$($getValue.displayName)}"

        $getAccessPackageResourceRoleScopes=@()
        foreach ($accessPackageResourceRoleScope in $getValue.AccessPackageResourceRoleScopes)
        {
            $getAccessPackageResourceRoleScopes += @{
                Id = $accessPackageResourceRoleScope.Id
                AccessPackageResourceOriginId = $accessPackageResourceRoleScope.AccessPackageResourceScope.OriginId
                AccessPackageResourceRoleDisplayName = $accessPackageResourceRoleScope.AccessPackageResourceRole.DisplayName
            }
        }

        $getIncompatibleAccessPackages=@()
        [Array]$query=Get-MgEntitlementManagementAccessPackageIncompatibleAccessPackage -AccessPackageId $getValue.id
        if($query.count -gt 0)
        {
            $getIncompatibleAccessPackages += $query.id
        }


        $getAccessPackagesIncompatibleWith=@()
        [Array]$query = Get-MgEntitlementManagementAccessPackageIncompatibleWith -AccessPackageId $getValue.id
        if($query.count -gt 0)
        {
            $getIncompatibleAccessPackages += $query.id
        }

        $getIncompatibleGroups=@()
        [Array]$query = Get-MgEntitlementManagementAccessPackageIncompatibleGroup -AccessPackageId $getValue.id
        if($query.count -gt 0)
        {
            $getIncompatibleGroups += $query.id
        }

        $results = @{

            #region resource generator code
            Id                              = $getValue.Id
            CatalogId                       = $getValue.CatalogId
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
            Managedidentity                 = $ManagedIdentity.IsPresent
        }


        return [System.Collections.Hashtable] $results
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
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
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $CatalogId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

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

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
            -ProfileName 'beta'
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

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating access package {$DisplayName}"

        #region basic information
        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()

        $CreateParameters.Remove('Id') | Out-Null
        $CreateParameters.Remove('Verbose') | Out-Null
        $CreateParameters.Remove('AccessPackageResourceRoleScopes') | Out-Null
        $CreateParameters.Remove('IncompatibleAccessPackages') | Out-Null
        $CreateParameters.Remove('AccessPackagesIncompatibleWith') | Out-Null
        $CreateParameters.Remove('IncompatibleGroups') | Out-Null

        $accessPackage = New-MgEntitlementManagementAccessPackage `
            -BodyParameter $CreateParameters

        #endregion

        #region IncompatibleAccessPackages
        foreach ($incompatibleAccessPackage in $IncompatibleAccessPackages)
        {
            $ref = @{
                '@odata.id' = "https://graph.microsoft.com/beta/identityGovernance/entitlementManagement/accessPackages/$incompatibleAccessPackage"
            }

            New-MgEntitlementManagementAccessPackageIncompatibleAccessPackageByRef `
                -AccessPackageId $accessPackage.Id `
                -OdataId $ref.'@odata.id'
        }
        #endregion

        #region IncompatibleGroups
        foreach ($IncompatibleGroup in $IncompatibleGroups)
        {
            $ref = @{
                '@odata.id' = "https://graph.microsoft.com/beta/groups/$IncompatibleGroup"
            }

            New-MgEntitlementManagementAccessPackageIncompatibleGroupByRef `
                -AccessPackageId $accessPackage.Id `
                -OdataId $ref.'@odata.id'
        }
        #endregion

        #region AccessPackageResourceRoleScopes
        foreach($accessPackageResourceRoleScope in $AccessPackageResourceRoleScopes)
        {
            #Add scopeRole
            $originId=$accessPackageResourceRoleScope.AccessPackageResourceOriginId
            $roleName=$accessPackageResourceRoleScope.AccessPackageResourceRoleDisplayName

            write-verbose -message "Adding roleScope {$originId`:$roleName} to access package with Id {$($accessPackage.Id)}"

            $resourceScope = Get-MgEntitlementManagementAccessPackageCatalogAccessPackageResource `
                -AccessPackageCatalogId $CatalogId `
                -Filter "originId eq '$originId'" `
                -ExpandProperty "accessPackageResourceScopes"

            $resourceRole = Get-MgEntitlementManagementAccessPackageCatalogAccessPackageResourceRole `
                -AccessPackageCatalogId $CatalogId `
                -Filter "(accessPackageResource/Id eq '$($resourceScope.id)' and displayname eq '$roleName' and originSystem eq '$($resourceScope.originSystem)')" `
                -ExpandProperty "accessPackageResource"

            $isValidRoleScope=$true
            if($null -eq $resourceScope)
            {
                write-verbose -message "The AccessPackageResourceOriginId {$originId} could not be found in catalog with id {$CatalogId}"
                $isValidRoleScope=$false
            }

            if($null -eq $resourceRole)
            {
                write-verbose -message "The AccessPackageResourceRoleDisplayName {$roleName} could not be found for resource with originID {$originId}"
                $isValidRoleScope=$false
            }

            if($isValidRoleScope)
            {
                $params = [ordered]@{
                    AccessPackageResourceRole = @{
                        OriginId = $resourceRole.OriginId
                        DisplayName = $resourceRole.DisplayName
                        OriginSystem = $resourceRole.OriginSystem
                        AccessPackageResource = @{
                            Id = $resourceScope.Id
                            ResourceType = $resourceScope.ResourceType
                            OriginId = $resourceScope.OriginId
                            OriginSystem = $resourceRole.OriginSystem
                        }
                    }
                    AccessPackageResourceScope = @{
                        OriginId = $resourceScope.OriginId
                        OriginSystem = $resourceScope.OriginSystem
                        IsRootScope = $resourceScope.AccessPackageResourceScopes[0].IsRootScope
                    }
                }

                write-verbose -message ("package id {$($accessPackage.Id)}")
                write-verbose -message ($params|convertTo-json -depth 20)
                New-MgEntitlementManagementAccessPackageResourceRoleScope -AccessPackageId $accessPackage.Id -BodyParameter $params
            }
        }
        #endregion

    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating access package with id {$id} and displayName {$DisplayName}"

        #region basic information
        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()

        $UpdateParameters.Remove('Id') | Out-Null
        $UpdateParameters.Remove('Verbose') | Out-Null
        $UpdateParameters.Remove('AccessPackageResourceRoleScopes') | Out-Null
        $UpdateParameters.Remove('IncompatibleAccessPackages') | Out-Null
        $UpdateParameters.Remove('AccessPackagesIncompatibleWith') | Out-Null
        $UpdateParameters.Remove('IncompatibleGroups') | Out-Null

        Update-MgEntitlementManagementAccessPackage -BodyParameter $UpdateParameters `
            -AccessPackageId $currentInstance.Id
        #endregion

        #region IncompatibleAccessPackages
        [Array]$currentIncompatibleAccessPackages=$currentInstance.IncompatibleAccessPackages
        if($null -eq $currentIncompatibleAccessPackages)
        {
            $currentIncompatibleAccessPackages=@()
        }
        if($null -eq $IncompatibleAccessPackages)
        {
            $IncompatibleAccessPackages=@()
        }
        [Array]$compareResult=Compare-Object `
            -ReferenceObject $IncompatibleAccessPackages `
            -DifferenceObject $currentIncompatibleAccessPackages `

        [Array]$toBeAdded= $compareResult| Where-Object -FilterScript {$_.SideIndicator -eq '<='}

        foreach ($incompatibleAccessPackage in $toBeAdded.InputObject)
        {
            $ref = @{
                '@odata.id' = "https://graph.microsoft.com/beta/identityGovernance/entitlementManagement/accessPackages/$incompatibleAccessPackage"
            }

            New-MgEntitlementManagementAccessPackageIncompatibleAccessPackageByRef `
                -AccessPackageId $currentInstance.Id `
                -OdataId $ref.'@odata.id'
        }

        [Array]$toBeRemoved= $compareResult| Where-Object -FilterScript {$_.SideIndicator -eq '=>'}

        foreach ($incompatibleAccessPackage in $toBeRemoved.InputObject)
        {
            Remove-MgEntitlementManagementAccessPackageIncompatibleAccessPackageByRef `
                -AccessPackageId $currentInstance.Id `
                -AccessPackageId1  $incompatibleAccessPackage
        }
        #endregion

        #region IncompatibleGroups
        [Array]$currentIncompatibleGroups=$currentInstance.IncompatibleGroups
        if($null -eq $currentIncompatibleGroups)
        {
            $currentIncompatibleGroups=@()
        }
        if($null -eq $IncompatibleGroups)
        {
            $IncompatibleGroups=@()
        }
        [Array]$compareResult=Compare-Object `
            -ReferenceObject $IncompatibleGroups `
            -DifferenceObject $currentIncompatibleGroups `

        [Array]$toBeAdded= $compareResult| Where-Object -FilterScript {$_.SideIndicator -eq '<='}
        foreach ($incompatibleGroup in $tobeAdded.InputObject)
        {

            $ref = @{
                '@odata.id' = "https://graph.microsoft.com/beta/groups/$incompatibleGroup"
            }

            New-MgEntitlementManagementAccessPackageIncompatibleGroupByRef `
                -AccessPackageId $currentInstance.Id `
                -OdataId $ref.'@odata.id'
        }

        [Array]$toBeRemoved= $compareResult| Where-Object -FilterScript {$_.SideIndicator -eq '=>'}

        foreach ($IncompatibleGroup in $toBeRemoved.InputObject)
        {
            Remove-MgEntitlementManagementAccessPackageIncompatibleGroupByRef `
                -AccessPackageId $currentInstance.Id `
                -GroupId  $incompatibleGroup
        }
        #endregion

        #region AccessPackageResourceRoleScopes
        $currentAccessPackageResourceOriginIds=$currentInstance.AccessPackageResourceRoleScopes.AccessPackageResourceOriginId
        foreach($accessPackageResourceRoleScope in $AccessPackageResourceRoleScopes)
        {
            if($accessPackageResourceRoleScope.AccessPackageResourceOriginId -notin ($currentAccessPackageResourceOriginIds))
            {
                #region new roleScope
                $originId=$accessPackageResourceRoleScope.AccessPackageResourceOriginId
                $roleName=$accessPackageResourceRoleScope.AccessPackageResourceRoleDisplayName

                write-verbose -message "Adding roleScope {$originId`:$roleName} to access package with Id {$($currentInstance.Id)}"

                $resourceScope = Get-MgEntitlementManagementAccessPackageCatalogAccessPackageResource `
                    -AccessPackageCatalogId $CatalogId `
                    -Filter "originId eq '$originId'" `
                    -ExpandProperty "accessPackageResourceScopes"

                $resourceRole = Get-MgEntitlementManagementAccessPackageCatalogAccessPackageResourceRole `
                    -AccessPackageCatalogId $CatalogId `
                    -Filter "(accessPackageResource/Id eq '$($resourceScope.id)' and displayname eq '$roleName' and originSystem eq '$($resourceScope.originSystem)')" `
                    -ExpandProperty "accessPackageResource"

                $isValidRoleScope=$true
                if($null -eq $resourceScope)
                {
                    write-verbose -message "The AccessPackageResourceOriginId {$originId} could not be found in catalog with id {$CatalogId}"
                    $isValidRoleScope=$false
                }

                if($null -eq $resourceRole)
                {
                    write-verbose -message "The AccessPackageResourceRoleDisplayName {$roleName} could not be found for resource with originID {$originId}"
                    $isValidRoleScope=$false
                }

                if($isValidRoleScope)
                {
                    $params = [ordered]@{
                        AccessPackageResourceRole = @{
                            OriginId = $resourceRole.OriginId
                            DisplayName = $resourceRole.DisplayName
                            OriginSystem = $resourceRole.OriginSystem
                            AccessPackageResource = @{
                                Id = $resourceScope.Id
                                ResourceType = $resourceScope.ResourceType
                                OriginId = $resourceScope.OriginId
                                OriginSystem = $resourceRole.OriginSystem
                            }
                        }
                        AccessPackageResourceScope = @{
                            OriginId = $resourceScope.OriginId
                            OriginSystem = $resourceScope.OriginSystem
                            IsRootScope = $resourceScope.AccessPackageResourceScopes[0].IsRootScope
                        }
                    }

                    New-MgEntitlementManagementAccessPackageResourceRoleScope -AccessPackageId $currentInstance.Id -BodyParameter $params
                }
                #endregion
            }
            else
            {
                $currentRole=$currentInstance.AccessPackageResourceRoleScopes|where-object `
                        -FilterScript {$_.AccessPackageResourceOriginId -eq $accessPackageResourceRoleScope.AccessPackageResourceOriginId }
                if($accessPackageResourceRoleScope.AccessPackageResourceRoleDisplayName -ne $currentRole.AccessPackageResourceRoleDisplayName )
                {
                    #region update role

                    $originId=$accessPackageResourceRoleScope.AccessPackageResourceOriginId
                    $roleName=$accessPackageResourceRoleScope.AccessPackageResourceRoleDisplayName

                    write-verbose -message "Updating role {$roleName} from access package rolescope with Id {$($accessPackageResourceRoleScope.id)}"

                    $resourceScope = Get-MgEntitlementManagementAccessPackageCatalogAccessPackageResource `
                        -AccessPackageCatalogId $CatalogId `
                        -Filter "originId eq '$originId'" `
                        -ExpandProperty "accessPackageResourceScopes"

                    $resourceRole = Get-MgEntitlementManagementAccessPackageCatalogAccessPackageResourceRole `
                        -AccessPackageCatalogId $CatalogId `
                        -Filter "(accessPackageResource/Id eq '$($resourceScope.id)' and displayname eq '$roleName' and originSystem eq '$($resourceScope.originSystem)')" `
                        -ExpandProperty "accessPackageResource"

                    $isValidRoleScope=$true
                    if($null -eq $resourceScope)
                    {
                        write-verbose -message "The AccessPackageResourceOriginId {$originId} could not be found in catalog with id {$CatalogId}"
                        $isValidRoleScope=$false
                    }

                    if($null -eq $resourceRole)
                    {
                        write-verbose -message "The AccessPackageResourceRoleDisplayName {$roleName} could not be found for resource with originID {$originId}"
                        $isValidRoleScope=$false
                    }

                    if($isValidRoleScope)
                    {
                        $params = [ordered]@{
                            AccessPackageResourceRole = @{
                                OriginId = $resourceRole.OriginId
                                DisplayName = $resourceRole.DisplayName
                                OriginSystem = $resourceRole.OriginSystem
                                AccessPackageResource = @{
                                    Id = $resourceScope.Id
                                    ResourceType = $resourceScope.ResourceType
                                    OriginId = $resourceScope.OriginId
                                    OriginSystem = $resourceRole.OriginSystem
                                }
                            }
                            AccessPackageResourceScope = @{
                                OriginId = $resourceScope.OriginId
                                OriginSystem = $resourceScope.OriginSystem
                                IsRootScope = $resourceScope.AccessPackageResourceScopes[0].IsRootScope
                            }
                        }

                        #write-verbose -message ($params|convertTo-json -depth 20)

                        Remove-MgEntitlementManagementAccessPackageResourceRoleScope `
                            -AccessPackageId $currentInstance.Id  `
                            -AccessPackageResourceRoleScopeId $currentRole.Id

                        New-MgEntitlementManagementAccessPackageResourceRoleScope `
                            -AccessPackageId $currentInstance.Id `
                            -BodyParameter $params

                    }
                    #endregion
                }
            }
        }

        #region remove roleScope
        $currentAccessPackageResourceOriginIdsToRemove = $currentAccessPackageResourceOriginIds | where-object `
                -FilterScript {$_ -notin $AccessPackageResourceRoleScopes.AccessPackageResourceOriginId}
        foreach ($originId in $currentAccessPackageResourceOriginIdsToRemove)
        {

            $currentRoleScope=$currentInstance.AccessPackageResourceRoleScopes | Where-Object `
                    -FilterScript {$_.AccessPackageResourceOriginId -eq $originId}

            write-verbose -message "Removing RoleScope with originId {$originId} from access package {$($currentInstance.Id)}"

            Remove-MgEntitlementManagementAccessPackageResourceRoleScope `
                -AccessPackageId $currentInstance.Id  `
                -AccessPackageResourceRoleScopeId $currentRoleScope.Id
        }

        #endregion
        #endregion

    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing access package with id {$id} and displayName {$DisplayName}"

        #region resource generator code
        Remove-MgEntitlementManagementAccessPackage -AccessPackageId $currentInstance.Id
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

        [Parameter()]
        [System.String]
        $CatalogId,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

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

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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

    Write-Verbose -Message "Testing configuration of {$Id}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if($CurrentValues.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult=$true

    #Compare Cim instances
    foreach($key in $PSBoundParameters.Keys)
    {
        $source=$PSBoundParameters.$key
        $target=$CurrentValues.$key
        if($source.getType().Name -like "*CimInstance*")
        {
            $source=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $source
            foreach($s in [Array]$source)
            {
                $s.remove("Id")
            }
            foreach($t in [Array]$target)
            {
                $t.remove("Id")
            }

            $testResult=Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if(-Not $testResult)
            {
                $testResult=$false
                break;
            }

            $ValuesToCheck.Remove($key)|Out-Null

        }
    }

    $ValuesToCheck.Remove('Id') | Out-Null
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('AccessPackagesIncompatibleWith') | Out-Null #read-only

    #Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    #Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

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
        [array]$getValue = Get-MgEntitlementManagementAccessPackage `
                    -All `
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
            $displayedKey=$config.id
            if(-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey=$config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                id                    = $config.id
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
            }

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

            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential


            if ($null -ne $Results.AccessPackageResourceRoleScopes)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "AccessPackageResourceRoleScopes" -isCIMArray:$true
            }

            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }

        #Removing extra coma between items in cim instance array created by Convert-DSCStringParamToVariable
        $dscContent=$dscContent.replace("            ,`r`n","")
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ''
    }
}
function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable],[hashtable[]])]
    param(
        [Parameter()]
        $ComplexObject
    )

    if($null -eq $ComplexObject)
    {
        return $null
    }


    if($ComplexObject.getType().Fullname -like "*hashtable")
    {
        return $ComplexObject
    }
    if($ComplexObject.getType().Fullname -like "*hashtable[[\]]")
    {
        return ,[hashtable[]]$ComplexObject
    }


    if($ComplexObject.gettype().fullname -like "*[[\]]")
    {
        $results=@()

        foreach($item in $ComplexObject)
        {
            if($item)
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                $results+=$hash
            }
        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return ,[hashtable[]]$results
    }

    $results = @{}

    if($ComplexObject.getType().Name -like 'Dictionary*')
    {
        $ComplexObject=[hashtable]::new($ComplexObject)
        $keys=$ComplexObject.Keys
        foreach ($key in $keys)
        {

            if($null -ne $ComplexObject.$key)
            {
                $keyName = $key#.Name[0].ToString().ToLower() + $key.Name.Substring(1, $key.Name.Length - 1)

                $keyType=$ComplexObject.$key.gettype().fullname
                if($keyType -like "*CimInstance*" -or $keyType -like "Microsoft.Graph.PowerShell.Models.*" )
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

    $keys = $ComplexObject | Get-Member | Where-Object -FilterScript {$_.MemberType -eq 'Property' -and $_.Name -ne 'AdditionalProperties'}

    foreach ($key in $keys)
    {

        if($null -ne $ComplexObject.$($key.Name))
        {
            $keyName = $key.Name[0].ToString().ToLower() + $key.Name.Substring(1, $key.Name.Length - 1)

            if($ComplexObject.$($key.Name).gettype().fullname -like "*CimInstance*")
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$($key.Name)

                $results.Add($keyName, $hash)
            }
            else
            {
                $results.Add($keyName, $ComplexObject.$($key.Name))
            }
        }
    }

    return [hashtable]$results
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
        [Array]
        $ComplexTypeMapping,

        [Parameter()]
        [System.String]
        $Whitespace='',

        [Parameter()]
        [System.uint32]
        $IndentLevel=3,

        [Parameter()]
        [switch]
        $isArray=$false
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    $indent=''
    for ($i = 0; $i -lt $IndentLevel ; $i++)
    {
        $indent+='    '
    }
    #If ComplexObject  is an Array
    if ($ComplexObject.GetType().FullName -like "*[[\]]")
    {
        $currentProperty=@()
        $IndentLevel++
        foreach ($item in $ComplexObject)
        {
            $splat=@{
                'ComplexObject'=$item
                'CIMInstanceName'=$CIMInstanceName
                'IndentLevel'=$IndentLevel
            }
            if ($ComplexTypeMapping)
            {
                $splat.add('ComplexTypeMapping',$ComplexTypeMapping)
            }

            $currentProperty += Get-M365DSCDRGComplexTypeToString -isArray:$true @splat

        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return ,$currentProperty
    }

    $currentProperty=''
    if($isArray)
    {
        $currentProperty += "`r`n"
        $currentProperty += $indent
    }

    $currentProperty += "MSFT_$CIMInstanceName{`r`n"
    $IndentLevel++
    $indent=''
    for ($i = 0; $i -lt $IndentLevel ; $i++)
    {
        $indent+='    '
    }
    $keyNotNull = 0
    foreach ($key in $ComplexObject.Keys)
    {
        if ($null -ne $ComplexObject.$key)
        {
            $keyNotNull++
            if ($ComplexObject.$key.GetType().FullName -like "Microsoft.Graph.PowerShell.Models.*" -or $key -in $ComplexTypeMapping.Name)
            {
                $hashPropertyType=$ComplexObject[$key].GetType().Name.tolower()

                #overwrite type if object defined in mapping complextypemapping
                if($key -in $ComplexTypeMapping.Name)
                {
                    $hashPropertyType=($ComplexTypeMapping|Where-Object -FilterScript {$_.Name -eq $key}).CimInstanceName
                    $hashProperty=$ComplexObject[$key]
                }
                else
                {
                    $hashProperty=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                }

                if(-not $isArray -or ($isArray -and $key -in $ComplexTypeMapping.Name ))
                {
                    $currentProperty += $indent + $key + ' = '
                    if($ComplexObject[$key].GetType().FullName -like "*[[\]]")
                    {
                        $currentProperty += "@("
                    }
                }

                $currentProperty += Get-M365DSCDRGComplexTypeToString `
                                -ComplexObject $hashProperty `
                                -CIMInstanceName $hashPropertyType `
                                -IndentLevel $IndentLevel `
                                -ComplexTypeMapping $ComplexTypeMapping
                if($ComplexObject.$key.GetType().FullName -like "*[[\]]")
                {
                    $currentProperty += $indent
                    $currentProperty += ')'
                    $currentProperty += "`r`n"

                }
            }
            else
            {
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key] -Space ($indent)
            }
        }
        else
        {
            $mappedKey=$ComplexTypeMapping|where-object -filterscript {$_.name -eq $key}

            if($mappedKey -and $mappedKey.isRequired)
            {
                if($mappedKey.isArray)
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
    $indent=''
    for ($i = 0; $i -lt $IndentLevel-1 ; $i++)
    {
        $indent+='    '
    }
    $currentProperty += "$indent}`r`n"

    #Indenting last parenthese when the cim instance is an array
    if($IndentLevel -eq 5)
    {
        $indent=''
        for ($i = 0; $i -lt $IndentLevel-2 ; $i++)
        {
            $indent+='    '
        }
        $currentProperty += $indent

    }
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
        $Space="                "

    )

    $returnValue=""
    switch -Wildcard ($Value.GetType().Fullname )
    {
        "*.Boolean"
        {
            $returnValue= $Space + $Key + " = `$" + $Value.ToString() + "`r`n"
        }
        "*.String"
        {
            if($key -eq '@odata.type')
            {
                $key='odataType'
            }
            $returnValue= $Space + $Key + " = '" + $Value + "'`r`n"
        }
        "*.DateTime"
        {
            $returnValue= $Space + $Key + " = '" + $Value + "'`r`n"
        }
        "*[[\]]"
        {
            $returnValue= $Space + $key + " = @("
            $whitespace=""
            $newline=""
            if($Value.count -gt 1)
            {
                $returnValue += "`r`n"
                $whitespace=$Space+"    "
                $newline="`r`n"
            }
            foreach ($item in $Value)
            {
                switch -Wildcard ($item.GetType().Fullname )
                {
                    "*.String"
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    "*.DateTime"
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    Default
                    {
                        $returnValue += "$whitespace$item$newline"
                    }
                }
            }
            if($Value.count -gt 1)
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
            $returnValue= $Space + $Key + " = " + $Value + "`r`n"
        }
    }
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
    if($null -eq  $Source  -and $null -eq $Target)
    {
        return $true
    }

    $sourceValue=""
    $targetValue=""
    if (($null -eq $Source) -xor ($null -eq $Target))
    {
        if($null -eq $Source)
        {
            $sourceValue="Source is null"
        }

        if($null -eq $Target)
        {
            $targetValue="Target is null"
        }
        Write-Verbose -Message "Configuration drift - Complex object: {$sourceValue$targetValue}"
        return $false
    }

    if($Source.getType().FullName -like "*CimInstance[[\]]" -or $Source.getType().FullName -like "*Hashtable[[\]]")
    {
        if($source.count -ne $target.count)
        {
            Write-Verbose -Message "Configuration drift - The complex array have different number of items: Source {$($source.count)} Target {$($target.count)}"
            return $false
        }
        if($source.count -eq 0)
        {
            return $true
        }

        #$i=0
        foreach($item in $Source)
        {

            $hashSource=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            foreach($targetItem in $Target)
            {
                $compareResult= Compare-M365DSCComplexObject `
                    -Source $hashSource `
                    -Target $targetItem

                if ($compareResult)
                {
                    break
                }
            }

            <#$compareResult= Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source[$i]) `
                    -Target $Target[$i]#>

            if(-not $compareResult)
            {
                Write-Verbose -Message "Configuration drift - The complex array items are not identical"
                return $false
            }
            #$i++
        }
        return $true
    }

    $keys= $Source.Keys|Where-Object -FilterScript {$_ -ne "PSComputerName"}
    foreach ($key in $keys)
    {
        #write-verbose -message "Comparing key: {$key}"
        #Matching possible key names between Source and Target
        $skey=$key
        $tkey=$key
        if($key -eq 'odataType')
        {
            #$skey='@odata.type'
        }
        else
        {
            $tmpkey=$Target.keys|Where-Object -FilterScript {$_ -eq "$key"}
            if($tkey)
            {
                $tkey=$tmpkey|Select-Object -First 1
            }
        }

        $sourceValue=$Source.$key
        $targetValue=$Target.$tkey
        #One of the item is null and not the other
        if (($null -eq $Source.$skey) -xor ($null -eq $Target.$tkey))
        {

            if($null -eq $Source.$skey)
            {
                $sourceValue="null"
            }

            if($null -eq $Target.$tkey)
            {
                $targetValue="null"
            }

            Write-Verbose -Message "Configuration drift - key: $key Source {$sourceValue} Target {$targetValue}"
            return $false
        }

        #Both keys aren't null or empty
        if(($null -ne $Source.$skey) -and ($null -ne $Target.$tkey))
        {
            if($Source.$skey.getType().FullName -like "*CimInstance*" -or $Source.$skey.getType().FullName -like "*hashtable*"  )
            {
                #Recursive call for complex object
                $compareResult= Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source.$skey) `
                    -Target $Target.$tkey

                if(-not $compareResult)
                {

                    Write-Verbose -Message "Configuration drift - complex object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject=$Target.$tkey
                $differenceObject=$Source.$skey

                $compareResult = Compare-Object `
                    -ReferenceObject ($referenceObject) `
                    -DifferenceObject ($differenceObject)

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
    [OutputType([hashtable],[hashtable[]])]
    param(
        [Parameter(Mandatory = 'true')]
        $ComplexObject
    )


    if($ComplexObject.getType().Fullname -like "*[[\]]")
    {
        $results=@()
        foreach($item in $ComplexObject)
        {
            $hash=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            $results+=$hash
        }

        #Write-Verbose -Message ("Convert-M365DSCDRGComplexTypeToHashtable >>> results: "+(convertTo-JSON $results -Depth 20))
        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return ,[hashtable[]]$results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject

    if($null -ne $hashComplexObject)
    {

        $results=$hashComplexObject.clone()
        $keys=$hashComplexObject.Keys|Where-Object -FilterScript {$_ -ne 'PSComputerName'}
        foreach ($key in $keys)
        {
            if($hashComplexObject[$key] -and $hashComplexObject[$key].getType().Fullname -like "*CimInstance*")
            {
                $results[$key]=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            else
            {
                $propertyName = $key[0].ToString().ToLower() + $key.Substring(1, $key.Length - 1)
                $propertyValue=$results[$key]
                $results.remove($key)|out-null
                $results.add($propertyName,$propertyValue)
            }
        }
    }
    return [hashtable]$results
}

Export-ModuleMember -Function *-TargetResource
