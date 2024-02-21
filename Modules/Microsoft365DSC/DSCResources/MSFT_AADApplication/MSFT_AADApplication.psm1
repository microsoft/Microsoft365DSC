function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $AppId,

        [Parameter()]
        [System.Boolean]
        $AvailableToOtherTenants,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $GroupMembershipClaims,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String[]]
        $IdentifierUris,

        [Parameter()]
        [System.Boolean]
        $IsFallbackPublicClient,

        [Parameter()]
        [System.String]
        $LogoutURL,

        [Parameter()]
        [System.String[]]
        $KnownClientApplications,

        [Parameter()]
        [System.Boolean]
        $PublicClient = $false,

        [Parameter()]
        [System.String[]]
        $ReplyURLs,

        [Parameter()]
        [System.String[]]
        $Owners,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Permissions,

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
        $ManagedIdentity
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    Write-Verbose -Message 'Getting configuration of Azure AD Application'

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

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        try
        {
            if (-not [System.String]::IsNullOrEmpty($AppId))
            {
                if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
                {
                    $AADApp = $Script:exportedInstances | Where-Object -FilterScript {$_.Id -eq $AppId}
                }
                else
                {
                    $AADApp = Get-MgApplication -Filter "AppId eq '$AppId'"
                }
            }
        }
        catch
        {
            Write-Verbose -Message "Could not retrieve AzureAD Application by Application ID {$AppId}"
        }

        if ($null -eq $AADApp)
        {
            Write-Verbose -Message "Attempting to retrieve Azure AD Application by DisplayName {$DisplayName}"

            if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
            {
                $AADApp = $Script:exportedInstances | Where-Object -FilterScript {$_.DisplayName -eq $DisplayName}
            }
            else
            {
                $AADApp = Get-MgApplication -Filter "DisplayName eq '$($DisplayName)'"
            }
        }
        if ($null -ne $AADApp -and $AADApp.Count -gt 1)
        {
            Throw "Multiple AAD Apps with the Displayname $($DisplayName) exist in the tenant. These apps will not be exported."
        }
        elseif ($null -eq $AADApp)
        {
            Write-Verbose -Message 'Could not retrieve and instance of the Azure AD App in the Get-TargetResource function.'
            return $nullReturn
        }
        else
        {
            Write-Verbose -Message 'An instance of Azure AD App was retrieved.'
            $permissionsObj = Get-M365DSCAzureADAppPermissions -App $AADApp
            $isPublicClient = $false
            if (-not [System.String]::IsNullOrEmpty($AADApp.PublicClient) -and $AADApp.PublicClient -eq $true)
            {
                $isPublicClient = $true
            }
            $AvailableToOtherTenantsValue = $false
            if ($AADApp.SignInAudience -ne 'AzureADMyOrg')
            {
                $AvailableToOtherTenantsValue = $true
            }

            [Array]$Owners = Get-MgApplicationOwner -ApplicationId $AADApp.Id -All:$true | `
                    Where-Object { !$_.DeletedDateTime }
            $OwnersValues = @()
            foreach ($Owner in $Owners)
            {
                if ($Owner.AdditionalProperties.userPrincipalName)
                {
                    $OwnersValues += $Owner.AdditionalProperties.userPrincipalName
                }
                else
                {
                    $OwnersValues += $Owner.Id
                }
            }

            $IsFallbackPublicClientValue = $false
            if ($AADApp.IsFallbackPublicClient)
            {
                $IsFallbackPublicClientValue = $AADApp.IsFallbackPublicClient
            }
            $result = @{
                DisplayName             = $AADApp.DisplayName
                AvailableToOtherTenants = $AvailableToOtherTenantsValue
                Description             = $AADApp.Description
                GroupMembershipClaims   = $AADApp.GroupMembershipClaims
                Homepage                = $AADApp.web.HomepageUrl
                IdentifierUris          = $AADApp.IdentifierUris
                IsFallbackPublicClient  = $IsFallbackPublicClientValue
                KnownClientApplications = $AADApp.Api.KnownClientApplications
                LogoutURL               = $AADApp.web.LogoutURL
                PublicClient            = $isPublicClient
                ReplyURLs               = $AADApp.web.RedirectUris
                Owners                  = $OwnersValues
                ObjectId                = $AADApp.Id
                AppId                   = $AADApp.AppId
                Permissions             = $permissionsObj
                Ensure                  = 'Present'
                Credential              = $Credential
                ApplicationId           = $ApplicationId
                TenantId                = $TenantId
                ApplicationSecret       = $ApplicationSecret
                CertificateThumbprint   = $CertificateThumbprint
                Managedidentity         = $ManagedIdentity.IsPresent
            }
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        if ($Script:ExportMode)
        {
            throw $_
        }
        else
        {
            New-M365DSCLogEntry -Message 'Error retrieving data:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            return $nullReturn
        }
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $AppId,

        [Parameter()]
        [System.Boolean]
        $AvailableToOtherTenants,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $GroupMembershipClaims,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String[]]
        $IdentifierUris,

        [Parameter()]
        [System.String[]]
        $KnownClientApplications,

        [Parameter()]
        [System.Boolean]
        $IsFallbackPublicClient,

        [Parameter()]
        [System.String]
        $LogoutURL,

        [Parameter()]
        [System.Boolean]
        $PublicClient = $false,

        [Parameter()]
        [System.String[]]
        $ReplyURLs,

        [Parameter()]
        [System.String[]]
        $Owners,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Permissions,

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
        $ManagedIdentity
    )

    Write-Verbose -Message 'Setting configuration of Azure AD Application'

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

    # Ensure we throw an error if PublicClient is set to $true and we're trying to also configure either Permissions
    # or IdentifierUris
    if ($PublicClient -and ($Permissions.Length -gt 0 -or $IdentifierUris.Length -gt 0))
    {
        $ErrorMessage = 'It is not possible set Permissions or IdentifierUris when the PublicClient property is ' + `
            "set to `$true. Application will not be created. To fix this, modify the configuration to set the " + `
            "PublicClient property to `$false, or remove the Permissions and IdentifierUris properties from your configuration."
        Add-M365DSCEvent -Message $ErrorMessage -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        throw $ErrorMessage
    }

    $currentAADApp = Get-TargetResource @PSBoundParameters
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove('ApplicationId') | Out-Null
    $tenantIdValue = $TenantId
    $currentParameters.Remove('TenantId') | Out-Null
    $currentParameters.Remove('CertificateThumbprint') | Out-Null
    $currentParameters.Remove('ApplicationSecret') | Out-Null
    $currentParameters.Remove('Ensure') | Out-Null
    $currentParameters.Remove('Credential') | Out-Null
    $currentParameters.Remove('ManagedIdentity') | Out-Null
    $backCurrentOwners = $currentAADApp.Owners
    $currentParameters.Remove('Owners') | Out-Null

    if ($KnownClientApplications)
    {
        Write-Verbose -Message 'Checking if the known client applications already exist.'
        $testedKnownClientApplications = New-Object System.Collections.Generic.List[string]
        foreach ($KnownClientApplication in $KnownClientApplications)
        {
            $knownAADApp = $null
            $knownAADApp = Get-MgApplication -Filter "AppID eq '$($KnownClientApplication)'"
            if ($null -ne $knownAADApp)
            {
                $testedKnownClientApplications.Add($knownAADApp.AppId)
            }
            else
            {
                Write-Verbose -Message "Could not find an existing app with the app ID $($KnownClientApplication)"
            }
        }
        $currentParameters.Remove('KnownClientApplications') | Out-Null
        $currentParameters.Add('KnownClientApplications', $testedKnownClientApplications)
    }

    # App should exist but it doesn't
    $needToUpdatePermissions = $false
    $currentParameters.Remove('AppId') | Out-Null
    $currentParameters.Remove('Permissions') | Out-Null

    if ($currentParameters.AvailableToOtherTenants)
    {
        $currentParameters.Add('SignInAudience', 'AzureADMultipleOrgs')
    }
    else
    {
        $currentParameters.Add('SignInAudience', 'AzureADMyOrg')
    }
    $currentParameters.Remove('AvailableToOtherTenants') | Out-Null
    $currentParameters.Remove('PublicClient') | Out-Null

    if ($currentParameters.KnownClientApplications)
    {
        $apiValue = @{
            KnownClientApplications = $currentParameters.KnownClientApplications
        }
        $currentParameters.Add('Api', $apiValue)
        $currentParameters.Remove('KnownClientApplications') | Out-Null
    }
    else
    {
        $currentParameters.Remove('KnownClientApplications') | Out-Null
    }

    if ($ReplyUrls -or $LogoutURL -or $Homepage)
    {
        $webValue = @{}

        if ($ReplyUrls)
        {
            $webValue.Add('RedirectUris', $currentParameters.ReplyURLs)
        }
        if ($LogoutURL)
        {
            $webValue.Add('LogoutUrl', $currentParameters.LogoutURL)
        }
        if ($Homepage)
        {
            $webValue.Add('HomePageUrl', $currentParameters.Homepage)
        }

        $currentParameters.Add('web', $webValue)
    }
    $currentParameters.Remove('ReplyURLs') | Out-Null
    $currentParameters.Remove('LogoutURL') | Out-Null
    $currentParameters.Remove('Homepage') | Out-Null

    $skipToUpdate = $false
    $AppIdValue = $null
    if ($Ensure -eq 'Present' -and $currentAADApp.Ensure -eq 'Absent')
    {
        # Before attempting to create a new instance, let's first check to see if there is already an existing instance that is soft deleted
        if (-not [System.String]::IsNullOrEmpty($AppId))
        {
            Write-Verbose "Trying to retrieve existing deleted Applications from soft delete by Id {$AppId}."
            [Array]$deletedApp = Get-MgBetaDirectoryDeletedItemAsApplication -DirectoryObjectId $AppId -ErrorAction SilentlyContinue
        }

        if ($null -eq $deletedApp)
        {
            Write-Verbose "Trying to retrieve existing deleted Applications from soft delete by DisplayName {$DisplayName}."
            [Array]$deletedApp = Get-MgBetaDirectoryDeletedItemAsApplication -Filter "DisplayName eq '$DisplayName'" -ErrorAction SilentlyContinue
        }

        if ($null -ne $deletedApp -and $deletedApp.Length -eq 1)
        {
            $deletedSinceInDays = [System.DateTime]::Now.Subtract($deletedApp[0].DeletedDateTime).Days
            if ($deletedSinceInDays -le 30)
            {
                Write-Verbose -Message "Found existing deleted instance of {$DisplayName}. Restoring it instead of creating a new one. This could take a few minutes to complete."
                Restore-MgBetaDirectoryDeletedItem -DirectoryObjectId $deletedApp.Id
                $skipToUpdate = $true
                $AppIdValue = $deletedApp.Id
            }
            else
            {
                Write-Verbose -Message "Found existing deleted instance of {$DisplayName}. However, the deleted date was over days ago and it cannot be restored. Will recreate a new instance instead."
            }
        }
        elseif ($deletedApp.Length -gt 1)
        {
            Write-Verbose -Message "Multiple instances of a deleted application with name {$DisplayName} wehre found. Creating a new instance since we can't determine what instance to restore."
        }
    }
    if ($Ensure -eq 'Present' -and $currentAADApp.Ensure -eq 'Absent' -and -not $skipToUpdate)
    {
        Write-Verbose -Message "Creating New AzureAD Application {$DisplayName} with values:`r`n$($currentParameters | Out-String)"
        $currentParameters.Remove('ObjectId') | Out-Null
        $currentAADApp = New-MgApplication @currentParameters
        Write-Verbose -Message "Azure AD Application {$DisplayName} was successfully created"
        $needToUpdatePermissions = $true

        $tries = 1
        $appEntity = $null
        do
        {
            Write-Verbose -Message 'Waiting for 10 seconds'
            Start-Sleep -Seconds 10
            $appEntity = Get-MgApplication -ApplicationId $currentAADApp.AppId -ErrorAction SilentlyContinue
            $tries++
        } until ($null -eq $appEntity -or $tries -le 12)

    }
    # App should exist and will be configured to desired state
    elseif (($Ensure -eq 'Present' -and $currentAADApp.Ensure -eq 'Present') -or $skipToUpdate)
    {
        $currentParameters.Remove('ObjectId') | Out-Null

        if (-not $skipToUpdate)
        {
            $AppIdValue = $currentAADApp.ObjectId
        }
        $currentParameters.Add('ApplicationId', $AppIdValue)
        Write-Verbose -Message "Updating existing AzureAD Application {$DisplayName} with values:`r`n$($currentParameters | Out-String)"
        Update-MgApplication @currentParameters
        $currentAADApp.Add('ID', $AppIdValue)
        $needToUpdatePermissions = $true
    }
    # App exists but should not
    elseif ($Ensure -eq 'Absent' -and $currentAADApp.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AzureAD Application {$DisplayName} by ObjectID {$($currentAADApp.ObjectID)}"
        Remove-MgApplication -ApplicationId $currentAADApp.ObjectID
    }

    if ($Ensure -ne 'Absent')
    {
        $desiredOwnersValue = @()
        if ($Owners.Length -gt 0)
        {
            $desiredOwnersValue = $Owners
        }
        if (!$backCurrentOwners)
        {
            $backCurrentOwners = @()
        }
        $ownersDiff = Compare-Object -ReferenceObject $backCurrentOwners -DifferenceObject $desiredOwnersValue
        foreach ($diff in $ownersDiff)
        {
            if ($diff.SideIndicator -eq '=>')
            {
                Write-Verbose -Message "Adding new owner {$($diff.InputObject)} to AAD Application {$DisplayName}"
                if ($diff.InputObject.Contains('@'))
                {
                    $Type = 'users'
                }
                else
                {
                    $Type = 'directoryObjects'
                }
                $ObjectUri = 'https://graph.microsoft.com/v1.0/{0}/{1}' -f $Type, $diff.InputObject
                $ownerObject = @{
                    '@odata.id' = $ObjectUri
                }
                try
                {
                    New-MgApplicationOwnerByRef -ApplicationId $currentAADApp.ObjectId -BodyParameter $ownerObject | Out-Null
                }
                catch
                {
                    New-M365DSCLogEntry -Message 'Error updating data:' `
                        -Exception $_ `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                }
            }
            elseif ($diff.SideIndicator -eq '<=')
            {
                Write-Verbose -Message "Removing new owner {$($diff.InputObject)} from AAD Application {$DisplayName}"
                try
                {
                    if ($diff.InputObject.Contains('@'))
                    {
                        $ObjectId = $(Get-MgUser -UserId $diff.InputObject -ErrorAction Stop).Id
                    }
                    else
                    {
                        $ObjectId = $diff.InputObject
                    }
                    Remove-MgApplicationOwnerByRef -ApplicationId $currentAADApp.ObjectId -DirectoryObjectId $ObjectId -ErrorAction Stop
                }
                catch
                {
                    New-M365DSCLogEntry -Message 'Error updating data:' `
                        -Exception $_ `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                }
            }
        }
    }

    if ($needToUpdatePermissions -and -not [System.String]::IsNullOrEmpty($Permissions) -and $Permissions.Length -gt 0)
    {
        Write-Verbose -Message "Will update permissions for Azure AD Application {$($currentAADApp.DisplayName)}"
        $allSourceAPIs = $Permissions.SourceAPI | Get-Unique
        $allRequiredAccess = @()

        foreach ($sourceAPI in $allSourceAPIs)
        {
            Write-Verbose -Message "Adding permissions for API {$($sourceAPI)}"
            $permissionsForcurrentAPI = $Permissions | Where-Object -FilterScript { $_.SourceAPI -eq $sourceAPI }
            $apiPrincipal = Get-MgServicePrincipal -Filter "DisplayName eq '$($sourceAPI)'"
            $currentAPIAccess = @{
                ResourceAppId  = $apiPrincipal.AppId
                ResourceAccess = @()
            }
            foreach ($permission in $permissionsForcurrentAPI)
            {
                if ($permission.Type -eq 'Delegated')
                {
                    $scope = $apiPrincipal.Oauth2PermissionScopes | Where-Object -FilterScript { $_.Value -eq $permission.Name }
                    $scopeId = $null
                    if ($null -eq $scope)
                    {
                        $ObjectGuid = [System.Guid]::empty
                        if ([System.Guid]::TryParse($permission.Name,[System.Management.Automation.PSReference]$ObjectGuid))
                        {
                            $scopeId = $permission.Name
                        }
                    }
                    else
                    {
                        $scopeId = $scope.Id
                    }
                    Write-Verbose -Message "Adding Delegated Permission {$($scopeId)}"
                    $delPermission = @{
                        Id   = $scopeId
                        Type = 'Scope'
                    }
                    $currentAPIAccess.ResourceAccess += $delPermission
                }
                elseif ($permission.Type -eq 'AppOnly')
                {
                    $role = $apiPrincipal.AppRoles | Where-Object -FilterScript { $_.Value -eq $permission.Name }
                    $roleId = $null
                    if ($null -eq $role)
                    {
                        $ObjectGuid = [System.Guid]::empty
                        if ([System.Guid]::TryParse($permission.Name,[System.Management.Automation.PSReference]$ObjectGuid))
                        {
                            $roleId = $permission.Name
                        }
                    }
                    else
                    {
                        $roleId = $role.Id
                    }
                    $appPermission = @{
                        Id   = $roleId
                        Type = 'Role'
                    }
                    $currentAPIAccess.ResourceAccess += $appPermission
                }
            }
            if ($null -ne $currentAPIAccess)
            {
                $allRequiredAccess += $currentAPIAccess
            }
        }

        Write-Verbose -Message "Updating permissions for Azure AD Application {$($currentAADApp.DisplayName)} with RequiredResourceAccess:`r`n$($allRequiredAccess | Out-String)"
        Write-Verbose -Message "Current App Id: $($currentAADApp.AppId)"

        # Even if the property is named ApplicationId, we need to pass in the ObjectId
        Update-MgApplication -ApplicationId ($currentAADApp.Id) `
            -RequiredResourceAccess $allRequiredAccess | Out-Null
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $AppId,

        [Parameter()]
        [System.Boolean]
        $AvailableToOtherTenants,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $GroupMembershipClaims,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String[]]
        $IdentifierUris,

        [Parameter()]
        [System.Boolean]
        $IsFallbackPublicClient,

        [Parameter()]
        [System.String[]]
        $KnownClientApplications,

        [Parameter()]
        [System.String]
        $LogoutURL,

        [Parameter()]
        [System.Boolean]
        $PublicClient = $false,

        [Parameter()]
        [System.String[]]
        $ReplyURLs,

        [Parameter()]
        [System.String[]]
        $Owners,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Permissions,

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

    Write-Verbose -Message 'Testing configuration of AzureAD Application'

    $CurrentValues = Get-TargetResource @PSBoundParameters

    if ($CurrentValues.Permissions.Length -gt 0 -and $null -ne $CurrentValues.Permissions.Name -and $Permissions.Name.Length -gt 0)
    {
        $permissionsDiff = Compare-Object -ReferenceObject ($CurrentValues.Permissions.Name) -DifferenceObject ($Permissions.Name)
        $driftedParams = @{}
        if ($null -ne $permissionsDiff)
        {
            Write-Verbose -Message "Permissions differ: $($permissionsDiff | Out-String)"
            Write-Verbose -Message "Test-TargetResource returned $false"
            $EventValue = "<CurrentValue>$($CurrentValues.Permissions.Name)</CurrentValue>"
            $EventValue += "<DesiredValue>$($Permissions.Name)</DesiredValue>"
            $driftedParams.Add('Permissions', $EventValue)
        }
        else
        {
            Write-Verbose -Message 'Permissions for Azure AD Application are the same'
        }
    }
    else
    {
        if ($Permissions.Length -gt 0)
        {
            Write-Verbose -Message 'No Permissions exist for the current Azure AD App, but permissions were specified for desired state'
            Write-Verbose -Message "Test-TargetResource returned $false"

            $EventValue = "<CurrentValue>`$null</CurrentValue>"
            $EventValue += "<DesiredValue>$($Permissions.Name)</DesiredValue>"
            $driftedParams.Add('Permissions', $EventValue)
        }
        else
        {
            Write-Verbose -Message 'No Permissions exist for the current Azure AD App and no permissions were specified'
        }
    }
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('ObjectId') | Out-Null
    $ValuesToCheck.Remove('AppId') | Out-Null
    $ValuesToCheck.Remove('Permissions') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys `
        -IncludedDrifts $driftedParams

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

    $dscContent = [System.Text.StringBuilder]::new()
    $i = 1
    Write-Host "`r`n" -NoNewline
    try
    {
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = Get-MgApplication -Filter $Filter -All -ErrorAction Stop
        foreach ($AADApp in $Script:exportedInstances)
        {
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $($AADApp.DisplayName)" -NoNewline
            $Params = @{
                ApplicationId         = $ApplicationId
                AppId                 = $AADApp.AppId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ApplicationSecret     = $ApplicationSecret
                Description           = $AADApp.Description
                DisplayName           = $AADApp.DisplayName
                ObjectID              = $AADApp.Id
                Credential            = $Credential
                Managedidentity       = $ManagedIdentity.IsPresent
            }
            try
            {
                $Results = Get-TargetResource @Params
                if ($Results.Ensure -eq 'Present')
                {
                    $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                        -Results $Results
                    if ($Results.Permissions.Count -gt 0)
                    {
                        $Results.Permissions = Get-M365DSCAzureADAppPermissionsAsString $Results.Permissions
                    }
                    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                        -ConnectionMode $ConnectionMode `
                        -ModulePath $PSScriptRoot `
                        -Results $Results `
                        -Credential $Credential

                    if ($null -ne $Results.Permissions)
                    {
                        $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock `
                            -ParameterName 'Permissions'
                    }

                    $dscContent.Append($currentDSCBlock) | Out-Null
                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                        -FileName $Global:PartialExportFileName
                    Write-Host $Global:M365DSCEmojiGreenCheckMark
                    $i++
                }
            }
            catch
            {
                if ($_.Exception.Message -like "*Multiple AAD Apps with the Displayname*")
                {
                    Write-Host "`r`n        $($Global:M365DSCEmojiYellowCircle)" -NoNewline
                    Write-Host " Multiple app instances wth name {$($AADApp.DisplayName)} were found. We will skip exporting these instances."
                }
            }
        }
        return $dscContent.ToString()
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

function Get-M365DSCAzureADAppPermissions
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory = $true)]
        $App
    )
    Write-Verbose -Message "Retrieving permissions for Azure AD Application {$($App.DisplayName)}"
    [array]$requiredAccesses = $App.RequiredResourceAccess

    $permissions = @()
    $i = 1
    foreach ($requiredAccess in $requiredAccesses)
    {
        Write-Verbose -Message "[$i/$($requiredAccesses.Length)]Obtaining information for App's Permission for {$($requiredAccess.ResourceAppId)}"
        $SourceAPI = Get-MgServicePrincipal -Filter "AppId eq '$($requiredAccess.ResourceAppId)'"

        foreach ($resourceAccess in $requiredAccess.ResourceAccess)
        {
            $currentPermission = @{}
            $currentPermission.Add('SourceAPI', $SourceAPI.DisplayName)
            if ($resourceAccess.Type -eq 'Scope')
            {
                $scopeInfo = $SourceAPI.Oauth2PermissionScopes | Where-Object -FilterScript { $_.Id -eq $resourceAccess.Id }
                $scopeInfoValue = $null
                if ($null -eq $scopeInfo)
                {
                    $ObjectGuid = [System.Guid]::empty
                    if ([System.Guid]::TryParse($resourceAccess.Id,[System.Management.Automation.PSReference]$ObjectGuid))
                    {
                        $scopeInfoValue = $resourceAccess.Id
                    }
                }
                else
                {
                    $scopeInfoValue = $scopeInfo.Value
                }
                $currentPermission.Add('Type', 'Delegated')
                $currentPermission.Add('Name', $scopeInfoValue)
                $currentPermission.Add('AdminConsentGranted', $false)

                $appServicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$($app.AppId)'" -All:$true
                if ($null -ne $appServicePrincipal)
                {
                    $oAuth2grant = Get-MgBetaOauth2PermissionGrant -Filter "ClientId eq '$($appServicePrincipal.Id)'"
                    if ($null -ne $oAuth2grant)
                    {
                        $scopes = $oAuth2grant.Scope.Split(' ')
                        if ($scopes.Contains($scopeInfoValue.Value))
                        {
                            $currentPermission.AdminConsentGranted = $true
                        }
                    }
                }
            }
            elseif ($resourceAccess.Type -eq 'Role' -or $resourceAccess.Type -eq 'Role,Scope')
            {
                $currentPermission.Add('Type', 'AppOnly')
                $role = $SourceAPI.AppRoles | Where-Object -FilterScript { $_.Id -eq $resourceAccess.Id }
                $roleValue = $null
                if ($null -eq $role)
                {
                    $ObjectGuid = [System.Guid]::empty
                    if ([System.Guid]::TryParse($resourceAccess.Id,[System.Management.Automation.PSReference]$ObjectGuid))
                    {
                        $roleValue = $resourceAccess.Id
                    }
                }
                else
                {
                    $roleValue = $role.Value
                }
                $currentPermission.Add('Name', $roleValue)
                $currentPermission.Add('AdminConsentGranted', $false)

                $appServicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$($app.AppId)'" -All:$true
                if ($null -ne $appServicePrincipal)
                {
                    $roleAssignments = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $appServicePrincipal.Id | Sort-Object ResourceDisplayName -Unique
                    foreach ($oAuth2Grant in $roleAssignments)
                    {
                        $foundPermission = $oAuth2Grant | Where-Object -FilterScript { $_.AppRoleId -eq '134fd756-38ce-4afd-ba33-e9623dbe66c2' }
                        break
                    }

                    if ($foundPermission)
                    {
                        $currentPermission.AdminConsentGranted = $true
                    }
                }
            }
            $permissions += $currentPermission
        }
        $i++
    }

    return $permissions
}

function Get-M365DSCAzureADAppPermissionsAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.ArrayList]
        $Permissions
    )

    $StringContent = '@('
    foreach ($permission in $Permissions)
    {
        $StringContent += "MSFT_AADApplicationPermission {`r`n"
        $StringContent += "                Name                = '" + $permission.Name + "'`r`n"
        $StringContent += "                Type                = '" + $permission.Type + "'`r`n"
        $StringContent += "                SourceAPI           = '" + $permission.SourceAPI + "'`r`n"
        $StringContent += "                AdminConsentGranted = `$" + $permission.AdminConsentGranted + "`r`n"
        $StringContent += "            }`r`n"
    }
    $StringContent += '            )'
    return $StringContent
}

Export-ModuleMember -Function *-TargetResource
