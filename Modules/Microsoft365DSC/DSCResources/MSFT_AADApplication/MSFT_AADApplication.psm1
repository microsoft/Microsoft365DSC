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
        $GroupMembershipClaims,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String[]]
        $IdentifierUris,

        [Parameter()]
        [System.String]
        $LogoutURL,

        [Parameter()]
        [System.String[]]
        $KnownClientApplications,

        [Parameter()]
        [System.Boolean]
        $Oauth2RequirePostResponse,

        [Parameter()]
        [System.Boolean]
        $PublicClient = $false,

        [Parameter()]
        [System.String[]]
        $ReplyURLs,

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    Write-Verbose -Message "Getting configuration of Azure AD Application"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        try
        {
            if (-not [System.String]::IsNullOrEmpty($AppId))
            {
                $AADApp = Get-MgApplication -Filter "AppId eq '$AppId'"
            }
        }
        catch
        {
            Write-Verbose -Message "Could not retrieve AzureAD Application by Application ID {$AppId}"
        }

        if ($null -eq $AADApp)
        {
            Write-Verbose -Message "Attempting to retrieve Azure AD Application by DisplayName {$DisplayName}"
            $AADApp = Get-MgApplication -Filter "DisplayName eq '$($DisplayName)'"
        }
        if ($null -ne $AADApp -and $AADApp.Count -gt 1)
        {
            Throw "Multiple AAD Apps with the Displayname $($DisplayName) exist in the tenant. Aborting."
        }
        elseif ($null -eq $AADApp)
        {
            Write-Verbose -Message "Could not retrieve and instance of the Azure AD App in the Get-TargetResource function."
            return $nullReturn
        }
        else
        {
            Write-Verbose -Message "An instance of Azure AD App was retrieved."
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
            $result = @{
                DisplayName                = $AADApp.DisplayName
                AvailableToOtherTenants    = $AvailableToOtherTenantsValue
                GroupMembershipClaims      = $AADApp.GroupMembershipClaims
                Homepage                   = $AADApp.web.HomepageUrl
                IdentifierUris             = $AADApp.IdentifierUris
                KnownClientApplications    = $AADApp.Api.KnownClientApplications
                LogoutURL                  = $AADApp.web.LogoutURL
                Oauth2RequirePostResponse  = $AADApp.Oauth2RequirePostResponse
                PublicClient               = $isPublicClient
                ReplyURLs                  = $AADApp.web.RedirectUris
                ObjectId                   = $AADApp.Id
                AppId                      = $AADApp.AppId
                Permissions                = $permissionsObj
                Ensure                     = "Present"
                Credential                 = $Credential
                ApplicationId              = $ApplicationId
                TenantId                   = $TenantId
                ApplicationSecret          = $ApplicationSecret
                CertificateThumbprint      = $CertificateThumbprint
            }
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $nullReturn
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
        [System.String]
        $LogoutURL,

        [Parameter()]
        [System.Boolean]
        $Oauth2RequirePostResponse,

        [Parameter()]
        [System.Boolean]
        $PublicClient = $false,

        [Parameter()]
        [System.String[]]
        $ReplyURLs,

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration of Azure AD Application"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    # Ensure we throw an error if PublicClient is set to $true and we're trying to also configure either Permissions
    # or IdentifierUris
    if ($PublicClient -and ($Permissions.Length -gt 0 -or $IdentifierUris.Length -gt 0))
    {
        $ErrorMessage = "It is not possible set Permissions or IdentifierUris when the PublicClient property is " + `
            "set to `$true. Application will not be created. To fix this, modify the configuration to set the " + `
            "PublicClient property to `$false, or remove the Permissions and IdentifierUris properties from your configuration."
        Add-M365DSCEvent -Message $ErrorMessage -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        throw $ErrorMessage
    }

    $currentAADApp = Get-TargetResource @PSBoundParameters
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove("ApplicationId")  | Out-Null
    $currentParameters.Remove("TenantId")  | Out-Null
    $currentParameters.Remove("CertificateThumbprint")  | Out-Null
    $currentParameters.Remove("ApplicationSecret")  | Out-Null
    $currentParameters.Remove("Ensure")  | Out-Null
    $currentParameters.Remove("Credential")  | Out-Null

    if ($KnownClientApplications)
    {
        Write-Verbose -Message "Checking if the known client applications already exist."
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
        $currentParameters.Remove("KnownClientApplications") | Out-Null
        $currentParameters.Add("KnownClientApplications", $testedKnownClientApplications)
    }

    # App should exist but it doesn't
    $needToUpdatePermissions = $false
    $currentParameters.Remove("AppId") | Out-Null
    $currentParameters.Remove("Permissions") | Out-Null

    if ($currentParameters.AvailableToOtherTenants)
    {
        $currentParameters.Add("SignInAudience",'AzureADMultipleOrgs')
    }
    else
    {
        $currentParameters.Add("SignInAudience",'AzureADMyOrg')
    }
    $currentParameters.Remove("AvailableToOtherTenants") | Out-Null
    $currentParameters.Remove("PublicClient") | Out-Null

    if ($currentParameters.KnownClientApplications)
    {
        $apiValue = @{
            KnownClientApplications = $currentParameters.KnownClientApplications
        }
        $currentParameters.Add("Api", $apiValue)
        $currentParameters.Remove("KnownClientApplications") | Out-Null
    }
    else
    {
        $currentParameters.Remove("KnownClientApplications") | Out-Null
    }

    if ($ReplyUrls -or $LogoutURL -or $Homepage)
    {
        $webValue = @{}

        if ($ReplyUrls)
        {
            $webValue.Add("RedirectUris", $currentParameters.ReplyURLs)
        }
        if ($LogoutURL)
        {
            $webValue.Add("LogoutUrl", $currentParameters.LogoutURL)
        }
        if ($Homepage)
        {
            $webValue.Add("HomePageUrl", $currentParameters.Homepage)
        }

        $currentParameters.Add("web", $webValue)
        $currentParameters.Remove("ReplyURLs") | Out-Null
        $currentParameters.Remove("LogoutURL") | Out-Null
        $currentParameters.Remove("Homepage") | Out-Null
    }

    if ($Ensure -eq "Present" -and $currentAADApp.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Creating New AzureAD Application {$DisplayName} with values:`r`n$($currentParameters | Out-String)"
        $currentParameters.Remove("ObjectId") | Out-Null
        $currentAADApp = New-MgApplication @currentParameters
        Write-Verbose -Message "Azure AD Application {$DisplayName} was successfully created"
        $needToUpdatePermissions = $true

        $tries = 1
        $appEntity = $null
        do {
            Write-Verbose -Message "Waiting for 10 seconds"
            Start-Sleep -Seconds 10
            $appEntity = Get-MgApplication -ApplicationId $currentAADApp.AppId -ErrorAction SilentlyContinue
            $tries++
        } until ($null -eq $appEntity -or $tries -le 12)

    }
    # App should exist and will be configured to desired state
    if ($Ensure -eq 'Present' -and $currentAADApp.Ensure -eq 'Present')
    {
        $currentParameters.Remove("ObjectId") | Out-Null

        # Passing in the Oauth2RequirePostResponse parameter returns an error when calling update-mgapplication.
        # Removing it temporarly for the update scenario.
        $currentParameters.Remove("Oauth2RequirePostResponse") | Out-Null
        $currentParameters.Add("ApplicationId", $currentAADApp.ObjectId)
        Write-Verbose -Message "Updating existing AzureAD Application {$DisplayName} with values:`r`n$($currentParameters | Out-String)"
        Update-MgApplication @currentParameters
        $currentAADApp.Add("ID", $currentAADApp.ObjectId)
        $needToUpdatePermissions = $true
    }
    # App exists but should not
    elseif ($Ensure -eq 'Absent' -and $currentAADApp.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AzureAD Application {$DisplayName} by ObjectID {$($currentAADApp.ObjectID)}"
        Remove-MgApplication -ApplicationId $currentAADApp.ObjectID
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
                ResourceAppId        = $apiPrincipal.AppId
                ResourceAccess       = @()
            }
            foreach ($permission in $permissionsForcurrentAPI)
            {
                if ($permission.Type -eq 'Delegated')
                {
                    $scope = $apiPrincipal.Oauth2PermissionScopes | Where-Object -FilterScript { $_.Value -eq $permission.Name }
                    Write-Verbose -Message "Adding Delegated Permission {$($scope.Id)}"
                    $delPermission = @{
                        Id   = $scope.Id
                        Type = 'Scope'
                    }
                    $currentAPIAccess.ResourceAccess += $delPermission
                }
                elseif ($permission.Type -eq "AppOnly")
                {
                    $role = $apiPrincipal.AppRoles | Where-Object -FilterScript { $_.Value -eq $permission.Name }
                    $appPermission = @{
                        Id   = $role.Id
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
        [System.String]
        $LogoutURL,

        [Parameter()]
        [System.Boolean]
        $Oauth2RequirePostResponse,

        [Parameter()]
        [System.Boolean]
        $PublicClient = $false,

        [Parameter()]
        [System.String[]]
        $ReplyURLs,

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of AzureAD Application"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    if ($CurrentValues.Permissions.Length -gt 0 -and $null -ne $CurrentValues.Permissions.Name)
    {
        $permissionsDiff = Compare-Object -ReferenceObject ($CurrentValues.Permissions.Name) -DifferenceObject ($Permissions.Name)
        if ($null -ne $permissionsDiff)
        {
            Write-Verbose -Message "Permissions differ: $($permissionsDiff | Out-String)"
            Write-Verbose -Message "Test-TargetResource returned $false"
            $EventMessage = "Permissions for Azure AD Application {$DisplayName} were not in the desired state.`r`n" + `
                "The should contain {$($Permissions.Name)} but instead contained {$($CurrentValues.Permissions.Name)}"
            Add-M365DSCEvent -Message $EventMessage -EntryType 'Warning' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source)
            return $false
        }
        else
        {
            Write-Verbose -Message "Permissions for Azure AD Application are the same"
        }
    }
    else
    {
        if ($Permissions.Length -gt 0)
        {
            Write-Verbose -Message "No Permissions exist for the current Azure AD App, but permissions were specified for desired state"
            Write-Verbose -Message "Test-TargetResource returned $false"
            $EventMessage = "Permissions for Azure AD Application {$DisplayName} were not in the desired state.`r`n" + `
                "The should contain {$($Permissions.Name)} but instead contained {`$null}"
            Add-M365DSCEvent -Message $EventMessage -EntryType 'Warning' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source)
            return $false
        }
        else
        {
            Write-Verbose -Message "No Permissions exist for the current Azure AD App and no permissions were specified"
        }
    }
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove("ObjectId") | Out-Null
    $ValuesToCheck.Remove("AppId") | Out-Null
    $ValuesToCheck.Remove("Permissions") | Out-Null
    $ValuesToCheck.Remove("ApplicationId") | Out-Null
    $ValuesToCheck.Remove("Credential") | Out-Null
    $ValuesToCheck.Remove("TenantId") | Out-Null
    $ValuesToCheck.Remove("ApplicationSecret") | Out-Null
    $ValuesToCheck.Remove("CertificateThumbprint") | Out-Null

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    $dscContent = ''
    $i = 1
    Write-Host "`r`n" -NoNewline
    try
    {
        $AADApplications = Get-MgApplication -All -ErrorAction Stop
        foreach ($AADApp in $AADApplications)
        {
            Write-Host "    |---[$i/$($AADApplications.Count)] $($AADApp.DisplayName)" -NoNewline
            $Params = @{
                ApplicationId         = $ApplicationId
                AppId                 = $AADApp.AppId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ApplicationSecret     = $ApplicationSecret
                DisplayName           = $AADApp.DisplayName
                ObjectID              = $AADApp.Id
                Credential            = $Credential
            }
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
                        -ParameterName "Permissions"
                }

                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
                Write-Host $Global:M365DSCEmojiGreenCheckMark
                $i++
            }
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
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
        $SourceAPI = Get-MGServicePrincipal -Filter "AppId eq '$($requiredAccess.ResourceAppId)'"

        foreach ($resourceAccess in $requiredAccess.ResourceAccess)
        {
            $currentPermission = @{}
            $currentPermission.Add("SourceAPI", $SourceAPI.DisplayName)
            if ($resourceAccess.Type -eq 'Scope')
            {
                $scopeInfo = $SourceAPI.Oauth2PermissionScopes | Where-Object -FilterScript {$_.Id -eq $resourceAccess.Id}
                $currentPermission.Add("Type", "Delegated")
                $currentPermission.Add("Name", $scopeInfo.Value)
                $currentPermission.Add("AdminConsentGranted", $false)

                $appServicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$($app.AppId)'" -All:$true
                if ($null -ne $appServicePrincipal)
                {
                    $oAuth2grant = Get-MgOauth2PermissionGrant -Filter "ClientId eq '$($appServicePrincipal.Id)'"
                    if ($null -ne $oAuth2grant)
                    {
                        $scopes = $oAuth2grant.Scope.Split(' ')
                        if ($scopes.Contains($scopeInfo.Value))
                        {
                            $currentPermission.AdminConsentGranted = $true
                        }
                    }
                }
            }
            elseif ($resourceAccess.Type -eq 'Role')
            {
                $currentPermission.Add("Type", "AppOnly")
                $role = $SourceAPI.AppRoles | Where-Object -FilterScript {$_.Id -eq $resourceAccess.Id}
                $currentPermission.Add("Name", $role.Value)
                $currentPermission.Add("AdminConsentGranted", $false)

                $appServicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '$($app.AppId)'" -All:$true
                if ($null -ne $appServicePrincipal)
                {
                    $roleAssignments = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $appServicePrincipal.Id | Sort-Object ResourceDisplayName -Unique
                    foreach ($oAuth2Grant in $roleAssignments)
                    {
                        $foundPermission = $oAuth2Grant | Where-Object -FilterScript { $_.AppRoleId -eq '134fd756-38ce-4afd-ba33-e9623dbe66c2'}
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

    $StringContent = "@("
    foreach ($permission in $Permissions)
    {
        $StringContent += "MSFT_AADApplicationPermission { `r`n"
        $StringContent += "                Name                = '" + $permission.Name + "'`r`n"
        $StringContent += "                Type                = '" + $permission.Type + "'`r`n"
        $StringContent += "                SourceAPI           = '" + $permission.SourceAPI + "'`r`n"
        $StringContent += "                AdminConsentGranted = `$" + $permission.AdminConsentGranted + "`r`n"
        $StringContent += "            }`r`n"
    }
    $StringContent += "            )"
    return $StringContent
}

Export-ModuleMember -Function *-TargetResource
