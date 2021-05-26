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
        $Oauth2AllowImplicitFlow,

        [Parameter()]
        [System.Boolean]
        $Oauth2AllowUrlPathMatching,

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
        [System.String]
        $SamlMetadataUrl,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Permissions,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' `
        -InboundParameters $PSBoundParameters

    Write-Verbose -Message "Getting configuration of Azure AD Application"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("COnnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        try
        {
            if ($null -ne $ObjectID)
            {
                $AADApp = Get-AzureADApplication -ObjectId $ObjectId
            }
        }
        catch
        {
            Write-Verbose -Message "Could not retrieve AzureAD Application by Object ID {$ObjectID}"
        }

        if ($null -eq $AADApp)
        {
            Write-Verbose -Message "Attempting to retrieve Azure AD Application by DisplayName {$DisplayName}"
            $AADApp = Get-AzureADApplication -Filter "DisplayName eq '$($DisplayName)'"
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
            $result = @{
                DisplayName                = $AADApp.DisplayName
                AvailableToOtherTenants    = $AADApp.AvailableToOtherTenants
                GroupMembershipClaims      = $AADApp.GroupMembershipClaims
                Homepage                   = $AADApp.Homepage
                IdentifierUris             = $AADApp.IdentifierUris
                KnownClientApplications    = $AADApp.KnownClientApplications
                LogoutURL                  = $AADApp.LogoutURL
                Oauth2AllowImplicitFlow    = $AADApp.Oauth2AllowImplicitFlow
                Oauth2AllowUrlPathMatching = $AADApp.Oauth2AllowUrlPathMatching
                Oauth2RequirePostResponse  = $AADApp.Oauth2RequirePostResponse
                PublicClient               = $isPublicClient
                ReplyURLs                  = $AADApp.ReplyURLs
                SamlMetadataUrl            = $AADApp.SamlMetadataUrl
                ObjectId                   = $AADApp.ObjectID
                AppId                      = $AADApp.AppId
                Permissions                = $permissionsObj
                Ensure                     = "Present"
                GlobalAdminAccount         = $GlobalAdminAccount
                ApplicationId              = $ApplicationId
                TenantId                   = $TenantId
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
            elseif ($null -ne $GlobalAdminAccount)
            {
                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
        $Oauth2AllowImplicitFlow,

        [Parameter()]
        [System.Boolean]
        $Oauth2AllowUrlPathMatching,

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
        [System.String]
        $SamlMetadataUrl,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Permissions,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration of Azure AD Application"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
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
    $currentParameters.Remove("GlobalAdminAccount")  | Out-Null
    $currentParameters.Remove("Ensure")  | Out-Null

    if ($null -ne $KnownClientApplications)
    {
        Write-Verbose -Message "Checking if the known client applications already exist."
        $testedKnownClientApplications = New-Object System.Collections.Generic.List[string]
        foreach ($KnownClientApplication in $KnownClientApplications)
        {
            $knownAADApp = $null
            $knownAADApp = Get-AzureADApplication -Filter "AppID eq '$($KnownClientApplication)'"
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

    if ($Ensure -eq "Present" -and $currentAADApp.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Creating New AzureAD Application {$DisplayName} with values:`r`n$($currentParameters | Out-String)"
        $currentParameters.Remove("ObjectId") | Out-Null
        $currentAADApp = New-AzureADApplication @currentParameters
        Write-Verbose -Message "Azure AD Application {$DisplayName} was successfully created"
        $needToUpdatePermissions = $true
        Start-Sleep 5
    }
    # App should exist and will be configured to desired state
    if ($Ensure -eq 'Present' -and $currentAADApp.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing AzureAD Application {$DisplayName} with values:`r`n$($currentParameters | Out-String)"
        $currentParameters.ObjectId = $currentAADApp.ObjectId
        Set-AzureADApplication @currentParameters
        $needToUpdatePermissions = $true
    }
    # App exists but should not
    elseif ($Ensure -eq 'Absent' -and $currentAADApp.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AzureAD Application {$DisplayName} by ObjectID {$($currentAADApp.ObjectID)}"
        Remove-AzureADApplication -ObjectId $currentAADApp.ObjectID
    }

    if ($needToUpdatePermissions -and -not [System.String]::IsNullOrEmpty($Permissions) -and $Permissions.Length -gt 0)
    {
        Write-Verbose -Message "Will update permissions for Azure AD Application {$($currentAADApp.DisplayName)}"
        $allSourceAPIs = $Permissions.SourceAPI | Get-Unique
        $allRequiredAccess = New-Object System.Collections.Generic.List[Microsoft.Open.AzureAD.Model.RequiredResourceAccess]

        foreach ($sourceAPI in $allSourceAPIs)
        {
            Write-Verbose -Message "Adding permissions for API {$($sourceAPI)}"
            $permissionsForcurrentAPI = $Permissions | Where-Object -FilterScript { $_.SourceAPI -eq $sourceAPI }
            $apiPrincipal = Get-AzureADServicePrincipal -Filter "DisplayName eq '$($sourceAPI)'"
            $currentAPIAccess = New-Object -TypeName "Microsoft.Open.AzureAD.Model.RequiredResourceAccess"
            $currentAPIAccess.ResourceAppId = $apiPrincipal.AppId
            foreach ($permission in $permissionsForcurrentAPI)
            {
                if ($permission.Type -eq 'Delegated')
                {
                    $scope = $apiPrincipal.Oauth2Permissions | Where-Object -FilterScript { $_.Value -eq $permission.Name }
                    $delPermission = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" `
                        -ArgumentList $scope.Id, "Scope"

                    Write-Verbose -Message "Adding Permission:`r`n$($delPermission | Format-List *)"
                    $currentAPIAccess.ResourceAccess += $delPermission
                }
                elseif ($permission.Type -eq "AppOnly")
                {
                    $role = $apiPrincipal.AppRoles | Where-Object -FilterScript { $_.Value -eq $permission.Name }
                    $appPermission = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess"
                    $appPermission.Id = $role.Id
                    $appPermission.Type = "Role"
                    $currentAPIAccess.ResourceAccess += $appPermission
                }
            }
            if ($null -ne $currentAPIAccess.ResourceAccess)
            {
                $allRequiredAccess.Add($currentAPIAccess)
            }
        }

        Write-Verbose -Message "Updating permissions for Azure AD Application {$($currentAADApp.DisplayName)} with RequiredResourceAccess:`r`n$($allRequiredAccess.ResourceAccess | Out-String)"
        Set-AzureADApplication -ObjectId ($currentAADApp.ObjectId) `
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
        $Oauth2AllowImplicitFlow,

        [Parameter()]
        [System.Boolean]
        $Oauth2AllowUrlPathMatching,

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
        [System.String]
        $SamlMetadataUrl,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Permissions,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
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
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove("ObjectId") | Out-Null
    $ValuesToCheck.Remove("AppId") | Out-Null
    $ValuesToCheck.Remove("Permissions") | Out-Null

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
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    #region Telemetry
    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' -InboundParameters $PSBoundParameters

    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $dscContent = ''
    $i = 1
    Write-Host "`r`n" -NoNewline
    try
    {
        $AADApplications = Get-AzureADApplication -ErrorAction Stop
        foreach ($AADApp in $AADApplications)
        {
            Write-Host "    |---[$i/$($AADApplications.Count)] $($AADApp.DisplayName)" -NoNewline
            $Params = @{
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                DisplayName           = $AADApp.DisplayName
                ObjectID              = $AADApp.ObjectID
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
                    -GlobalAdminAccount $GlobalAdminAccount

                if ($null -ne $Results.Permissions)
                {
                    $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Permissions"
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
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $GlobalAdminAccount)
            {
                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
    [array]$requiredAccess = $App.RequiredResourceAccess.ResourceAccess
    $servicePrincipal = Get-AzureADServicePrincipal -Filter "AppId eq '$($App.AppId)'" -All:$true

    $permissions = @()
    $i = 1
    foreach ($apiPermission in $requiredAccess)
    {
        Write-Verbose -Message "[$i/$($requiredAccess.Length)]Obtaining information for App's Permission for {$($apiPermission.Id)}"
        if ($apiPermission.Type -eq 'Role')
        {
            Write-Verbose -Message "    App's permission is {AppOnly}"
            $currentPermission = @{}
            $currentPermission.Add("Type", "AppOnly")
            $foundPermission = $null
            $AppRoleAssignments = Get-AzureADServiceAppRoleAssignedTo -ObjectId $ServicePrincipal.ObjectId | Sort-Object ResourceDisplayName -Unique
            foreach ($oAuth2Grant in $AppRoleAssignments)
            {
                $apiPrincipal = Get-AzureADServicePrincipal -ObjectId $oAuth2Grant.ResourceId
                Write-Verbose -Message "    Obtained service principal for {$($apiPrincipal.DisplayName)}"
                $foundPermission = $oAuth2Grant | Where-Object -FilterScript { $_.Id -eq $apiPermission.Id }

                $role = $apiPrincipal.AppRoles | Where-Object { $_.Id -eq $apiPermission.Id }

                if ($null -ne $role)
                {
                    Write-Verbose -Message "    Found permission in {$($apiPrincipal.DisplayName)} and the name is {$($role.Value)}"
                    $currentPermission.Add("Name", $role.Value)
                    $currentPermission.Add("SourceAPI", $apiPrincipal.DisplayName)
                    Write-Verbose -Message "    Found permission {$($role.Value)}"
                    break
                }
            }
            if ($null -ne $foundPermission)
            {
                $currentPermission.Add("AdminConsentGranted", $true)
            }
            else
            {
                $currentPermission.Add("AdminConsentGranted", $false)
            }
        }
        elseif ($apiPermission.Type -eq 'Scope')
        {
            $oAuth2Grants = Get-AzureADServicePrincipalOAuth2PermissionGrant -ObjectId $servicePrincipal.ObjectId -All $true
            Write-Verbose -Message "    App's permission is {Delegated}"
            $currentPermission = @{}
            $currentPermission.Add("Type", "Delegated")
            $foundPermission = $false

            foreach ($oAuth2Grant in $oAuth2Grants)
            {
                $apiPrincipal = Get-AzureADServicePrincipal -ObjectId $oAuth2Grant.ResourceId
                $scope = $apiPrincipal.Oauth2Permissions | Where-Object { $_.Id -eq $apiPermission.Id }
                $foundPermission = $oAuth2Grant.Scope.Split(" ") -contains $scope.Value

                if ($scope)
                {
                    $currentPermission.Add("SourceAPI", $apiPrincipal.DisplayName)
                    $currentPermission.Add("Name", $scope.Value)
                    Write-Verbose -Message "    Found permission {$($scope.Value)}"
                    break
                }
            }
            $currentPermission.Add("AdminConsentGranted", $foundPermission)
        }
        $permissions += $currentPermission
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
