Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADServicePrincipal'
$Script:PropertiesToExport = "AppDisplayName", "AppId", "Id", "DisplayName", "CustomSecurityAttributes", "AlternativeNames", "AccountEnabled", "AppRoleAssignmentRequired", "ErrorUrl", "Homepage", "LogoutUrl", "Notes", "PreferredSingleSignOnMode", "PublisherName", "ReplyUrls", "SamlMetadataURL", "ServicePrincipalNames", "ServicePrincipalType", "Tags", "KeyCredentials", "PasswordCredentials"

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppRoleAssignedTo,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CustomSecurityAttributes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DelegatedPermissionClassifications,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String[]]
        $Owners,

        [Parameter()]
        [System.String]
        $PreferredSingleSignOnMode,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.String]
        $SamlMetadataURL,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $KeyCredentials,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PasswordCredentials,

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

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.AppId -ne $AppId)
        {
            Write-Verbose -Message 'Getting configuration of Azure AD ServicePrincipal'
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

            $nullReturn = $PSBoundParameters
            $nullReturn.Ensure = 'Absent'

            if (-not [System.String]::IsNullOrEmpty($ObjectID))
            {
                $AADServicePrincipal = Get-MgServicePrincipal -ServicePrincipalId $ObjectId `
                    -Property $Script:PropertiesToExport `
                    -ExpandProperty 'AppRoleAssignedTo' `
                    -ErrorAction SilentlyContinue
            }

            if ($null -eq $AADServicePrincipal)
            {
                $ObjectGuid = [System.Guid]::empty
                if (-not [System.Guid]::TryParse($AppId, [ref]$ObjectGuid))
                {
                    $AADServicePrincipal = [Array](Get-MgServicePrincipal -Filter "DisplayName eq '$($AppId -replace "'", "''")'" `
                            -Property $Script:PropertiesToExport `
                            -Expand 'AppRoleAssignedTo')
                    if ($null -ne $AADServicePrincipal -and $AADServicePrincipal.Count -gt 1)
                    {
                        Throw "Multiple Service Principal with the DisplayName $($AppId) exist in the tenant."
                    }
                }
                else
                {
                    $AADServicePrincipal = Get-MgServicePrincipal -Filter "AppID eq '$($AppId)'" `
                        -Property $Script:PropertiesToExport `
                        -Expand 'AppRoleAssignedTo'
                }
            }
            if ($null -eq $AADServicePrincipal)
            {
                Write-Verbose -Message "Service Principal with AppId '$AppId' not found."
                return $nullReturn
            }
        }
        else
        {
            $AADServicePrincipal = $Script:exportedInstance
        }

        $batchRequests = @(
            @{
                id = 'AppRoleAssignedTo'
                method = 'GET'
                url = "/servicePrincipals/$($AADServicePrincipal.Id)/appRoleAssignedTo"
            }
            @{
                id = 'Owners'
                method = 'GET'
                url = "/servicePrincipals/$($AADServicePrincipal.Id)/owners"
            }
            @{
                id = 'delegatedPermissionClassifications'
                method = 'GET'
                url = "/servicePrincipals/$($AADServicePrincipal.Id)/delegatedPermissionClassifications"
            }
        )
        $batchResponse = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests -ErrorAction SilentlyContinue

        $AppRoleAssignedToValues = @()
        $assignmentsValue = ($batchResponse | Where-Object -FilterScript { $_.id -eq 'AppRoleAssignedTo' }).body.value
        foreach ($principal in $assignmentsValue)
        {
            $currentAssignment = @{
                PrincipalType = $null
                Identity      = $null
            }
            if ($principal.PrincipalType -eq 'User')
            {
                $user = Get-MgUser -UserId $principal.PrincipalId
                $currentAssignment.PrincipalType = 'User'
                $currentAssignment.Identity = $user.UserPrincipalName
                $AppRoleAssignedToValues += $currentAssignment
            }
            elseif ($principal.PrincipalType -eq 'Group')
            {
                $group = Get-MgGroup -GroupId $principal.PrincipalId
                $currentAssignment.PrincipalType = 'Group'
                $currentAssignment.Identity = $group.DisplayName
                $AppRoleAssignedToValues += $currentAssignment
            }
        }

        $ownersValues = @()
        $ownersInfo = ($batchResponse | Where-Object -FilterScript { $_.id -eq 'Owners' }).body.value
        foreach ($ownerInfo in $ownersInfo)
        {
            $info = Get-MgUser -UserId $ownerInfo.Id -ErrorAction SilentlyContinue
            if ($null -ne $info)
            {
                $ownersValues += $info.UserPrincipalName
            }
        }

        #Managed Identities in AzureGov return exception when pulling delegatedPermissionClassifications
        [Array]$complexDelegatedPermissionClassifications = @()
        try
        {
            $permissionClassifications = ($batchResponse | Where-Object -FilterScript { $_.id -eq 'delegatedPermissionClassifications' }).body.value
        }
        catch
        {
            Write-Verbose -Message "Service Principal didn't return delegated permission classifications. Expected for Managed Identities."
        }

        foreach ($permissionClassification in $permissionClassifications.Value)
        {
            $hashtable = @{
                classification = $permissionClassification.Classification
                permissionName = $permissionClassification.permissionName
            }
            $complexDelegatedPermissionClassifications += $hashtable
        }

        $complexKeyCredentials = @()
        foreach ($currentkeyCredentials in $AADServicePrincipal.keyCredentials)
        {
            $mykeyCredentials = [ordered]@{}
            if ($null -ne $currentkeyCredentials.customKeyIdentifier)
            {
                $mykeyCredentials.Add('CustomKeyIdentifier', [convert]::ToBase64String($currentkeyCredentials.customKeyIdentifier))
            }
            $mykeyCredentials.Add('DisplayName', $currentkeyCredentials.displayName)
            if ($null -ne $currentkeyCredentials.endDateTime)
            {
                $mykeyCredentials.Add('EndDateTime', ([DateTimeOffset]$currentkeyCredentials.endDateTime).ToString('o'))
            }
            $mykeyCredentials.Add('KeyId', $currentkeyCredentials.keyId)


            if ($null -ne $currentkeyCredentials.Key)
            {
                $mykeyCredentials.Add('Key', [convert]::ToBase64String($currentkeyCredentials.key))
            }

            if ($null -ne $currentkeyCredentials.startDateTime)
            {
                $mykeyCredentials.Add('StartDateTime', ([DateTimeOffset]$currentkeyCredentials.startDateTime).ToString('o'))
            }
            $mykeyCredentials.Add('Type', $currentkeyCredentials.type)
            $mykeyCredentials.Add('Usage', $currentkeyCredentials.usage)
            if ($mykeyCredentials.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexKeyCredentials += $mykeyCredentials
            }
        }

        $complexPasswordCredentials = @()
        foreach ($currentpasswordCredentials in $AADServicePrincipal.passwordCredentials)
        {
            $mypasswordCredentials = [ordered]@{}
            $mypasswordCredentials.Add('DisplayName', $currentpasswordCredentials.displayName)
            if ($null -ne $currentpasswordCredentials.endDateTime)
            {
                $mypasswordCredentials.Add('EndDateTime', ([DateTimeOffset]$currentpasswordCredentials.endDateTime).ToString('o'))
            }
            $mypasswordCredentials.Add('Hint', $currentpasswordCredentials.hint)
            $mypasswordCredentials.Add('KeyId', $currentpasswordCredentials.keyId)
            if ($null -ne $currentpasswordCredentials.startDateTime)
            {
                $mypasswordCredentials.Add('StartDateTime', ([DateTimeOffset]$currentpasswordCredentials.startDateTime).ToString('o'))
            }
            if ($mypasswordCredentials.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexPasswordCredentials += $mypasswordCredentials
            }
        }

        $complexCustomSecurityAttributes = [Array](Get-CustomSecurityAttributes -ServicePrincipal $ServicePrincipal)
        if ($null -eq $complexCustomSecurityAttributes)
        {
            $complexCustomSecurityAttributes = @()
        }

        # If the App Id was passed in as a Guid, return it as a GUID. Otherwise return it as text.
        $ObjectGuid = [System.Guid]::empty
        if (-not [System.String]::IsNullOrEmpty($AppId) -and [System.Guid]::TryParse($AppId, [ref]$ObjectGuid))
        {
            Write-Verbose -Message "Returning AppId as GUID since the provided value was in GUID format."
            $appIdToExport = $AADServicePrincipal.AppId
        }
        else
        {
            Write-Verbose -Message "Returning AppId as Display Name since the provided value was NOT in GUID format."
            $appIdToExport = $AADServicePrincipal.DisplayName
        }

        $tagsValue = @()
        if ($null -ne $AADServicePrincipal.Tags)
        {
            $tagsValue = [Array]($AADServicePrincipal.Tags)
        }

        $alternativeNamesValue = @()
        if ($null -ne $AADServicePrincipal.AlternativeNames)
        {
            $alternativeNamesValue = [Array]($AADServicePrincipal.AlternativeNames)
        }

        $replyUrlsValue = @()
        if ($null -ne $AADServicePrincipal.ReplyURLs)
        {
            $replyUrlsValue = [Array]($AADServicePrincipal.ReplyURLs)
        }

        $servicePrincipalNamesValue = @()
        if ($null -ne $AADServicePrincipal.ServicePrincipalNames)
        {
            $servicePrincipalNamesValue = [Array]($AADServicePrincipal.ServicePrincipalNames)
        }

        $result = @{
            AppId                              = $appIdToExport
            AppRoleAssignedTo                  = $AppRoleAssignedToValues
            ObjectID                           = $AADServicePrincipal.Id
            DisplayName                        = $AADServicePrincipal.DisplayName
            AlternativeNames                   = $alternativeNamesValue
            AccountEnabled                     = [boolean]$AADServicePrincipal.AccountEnabled
            AppRoleAssignmentRequired          = $AADServicePrincipal.AppRoleAssignmentRequired
            CustomSecurityAttributes           = $complexCustomSecurityAttributes
            DelegatedPermissionClassifications = [Array]$complexDelegatedPermissionClassifications
            ErrorUrl                           = $AADServicePrincipal.ErrorUrl
            Homepage                           = $AADServicePrincipal.Homepage
            LogoutUrl                          = $AADServicePrincipal.LogoutUrl
            Notes                              = $AADServicePrincipal.Notes
            Owners                             = $ownersValues
            PreferredSingleSignOnMode          = $AADServicePrincipal.PreferredSingleSignOnMode
            PublisherName                      = $AADServicePrincipal.PublisherName
            ReplyURLs                          = $replyUrlsValue
            SamlMetadataURL                    = $AADServicePrincipal.SamlMetadataURL
            ServicePrincipalNames              = $servicePrincipalNamesValue
            ServicePrincipalType               = $AADServicePrincipal.ServicePrincipalType
            Tags                               = $tagsValue
            KeyCredentials                     = $complexKeyCredentials
            PasswordCredentials                = $complexPasswordCredentials
            Ensure                             = 'Present'
            Credential                         = $Credential
            ApplicationId                      = $ApplicationId
            ApplicationSecret                  = $ApplicationSecret
            TenantId                           = $TenantId
            CertificateThumbprint              = $CertificateThumbprint
            ManagedIdentity                    = $ManagedIdentity.IsPresent
            AccessTokens                       = $AccessTokens
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
        $AppId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppRoleAssignedTo,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CustomSecurityAttributes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DelegatedPermissionClassifications,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String[]]
        $Owners,

        [Parameter()]
        [System.String]
        $PreferredSingleSignOnMode,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.String]
        $SamlMetadataURL,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $KeyCredentials,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PasswordCredentials,

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

    Write-Verbose -Message 'Setting configuration of Azure AD ServicePrincipal'
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

    $currentAADServicePrincipal = Get-TargetResource @PSBoundParameters
    $currentParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $currentParameters.Remove('ObjectID') | Out-Null
    $currentParameters.Remove('Owners') | Out-Null

    # update the custom security attributes to be cmdlet comsumable
    if ($null -ne $currentParameters.CustomSecurityAttributes -and $currentParameters.CustomSecurityAttributes.Count -gt 0)
    {
        $currentParameters.CustomSecurityAttributes = Get-M365DSCAADServicePrincipalCustomSecurityAttributesAsCmdletHashtable -CustomSecurityAttributes $currentParameters.CustomSecurityAttributes
    }
    else
    {
        $currentParameters.Remove('CustomSecurityAttributes')
    }

    # If the AppId was passed as a display name (not in GUID format), translate it to an ID.
    $ObjectGuid = [System.Guid]::empty
    if (-not [System.Guid]::TryParse($AppId, [System.Management.Automation.PSReference]$ObjectGuid))
    {
        Write-Verbose -Message "AppId was provided as a DisplayName. Translating it to an a GUID."
        $appInstance = Get-MgApplication -Filter "DisplayName eq '$($AppId -replace "'", "''")'"
        $currentParameters.AppId = $appInstance.AppId
        Write-Verbose -Message "Translated to AppId {$($currentParameters.AppId)}"
    }

    $AppRoleAssignedToSpecified = $currentParameters.ContainsKey('AppRoleAssignedTo')
    # ServicePrincipal should exist but it doesn't
    if ($Ensure -eq 'Present' -and $currentAADServicePrincipal.Ensure -eq 'Absent')
    {
        # removing Delegated permission classifications from this new call, as adding below separately
        $currentParameters.Remove('DelegatedPermissionClassifications') | Out-Null
        $currentParameters.Remove('AppRoleAssignedTo') | Out-Null

        Write-Verbose -Message 'Creating new Service Principal'
        Write-Verbose -Message "With Values: $(Convert-M365DscHashtableToString -Hashtable $currentParameters)"
        $newSP = New-MgServicePrincipal @currentParameters

        # Assign Owners
        foreach ($owner in $Owners)
        {
            $userInfo = Get-MgUser -UserId $owner
            $body = @{
                '@odata.id' = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "v1.0/directoryObjects/$($userInfo.Id)"
            }
            Write-Verbose -Message "Adding new owner {$owner}"
            $newOwner = New-MgServicePrincipalOwnerByRef -ServicePrincipalId $newSP.Id -BodyParameter $body
        }

        # Adding delegated permissions classifications
        if ($null -ne $DelegatedPermissionClassifications)
        {
            foreach ($permissionClassification in $DelegatedPermissionClassifications)
            {
                $params = @{
                    classification = $permissionClassification.Classification
                    permissionName = $permissionClassification.permissionName
                }
                $Uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "v1.0/servicePrincipals(appId='$($currentParameters.AppId)')/delegatedPermissionClassifications"
                Invoke-MgGraphRequest -Uri $Uri -Method Post -Body $params
            }
        }

        # Update AppRoleAssignedTo
        if ($AppRoleAssignedToSpecified)
        {
            Write-Verbose -Message "Updating AppRoleAssignedTo value"
            foreach ($assignment in $AppRoleAssignedTo)
            {
                if ($assignment.PrincipalType -eq 'User')
                {
                    Write-Verbose -Message "Retrieving user {$($assignment.Identity)}"
                    $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($assignment.Identity)')"
                    $PrincipalIdValue = $user.Id
                }
                else
                {
                    Write-Verbose -Message "Retrieving group {$($assignment.Identity)}"
                    $group = Get-MgGroup -Filter "DisplayName eq '$($assignment.Identity -replace "'", "''")'"
                    $PrincipalIdValue = $group.Id
                }

                $bodyParam = @{
                    principalId = $PrincipalIdValue
                    resourceId  = $newSP.Id
                    appRoleId   = '00000000-0000-0000-0000-000000000000'
                }
                Write-Verbose -Message "Adding Service Principal AppRoleAssignedTo with values:`r`n$(ConvertTo-Json $bodyParam -Depth 3)"
                New-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $newSP.Id `
                    -BodyParameter $bodyParam | Out-Null
            }
        }
    }
    # ServicePrincipal should exist and will be configured to desired state
    elseif ($Ensure -eq 'Present' -and $currentAADServicePrincipal.Ensure -eq 'Present')
    {
        Write-Verbose -Message 'Updating existing Service Principal'
        Write-Verbose -Message "CurrentParameters: $($currentParameters | Out-String)"
        Write-Verbose -Message "ServicePrincipalID: $($currentAADServicePrincipal.ObjectID)"
        $AppRoleAssignedToSpecified = $currentParameters.ContainsKey('AppRoleAssignedTo')
        $currentParameters.Remove('AppRoleAssignedTo') | Out-Null
        $currentParameters.Remove('DelegatedPermissionClassifications') | Out-Null

        if ($PreferredSingleSignOnMode -eq 'saml')
        {
            $IdentifierUris = $ServicePrincipalNames | Where-Object { $_ -notmatch $AppId }
            $currentParameters.Remove('ServicePrincipalNames')
        }

        #removing the current custom security attributes
        if ($currentAADServicePrincipal.CustomSecurityAttributes.Count -gt 0)
        {
            $currentAADServicePrincipal.CustomSecurityAttributes = Get-M365DSCAADServicePrincipalCustomSecurityAttributesAsCmdletHashtable -CustomSecurityAttributes $currentAADServicePrincipal.CustomSecurityAttributes -GetForDelete $true
            $CSAParams = @{
                customSecurityAttributes = $currentAADServicePrincipal.CustomSecurityAttributes
            }
            Invoke-MgGraphRequest -Uri ((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/servicePrincipals(appId='$($currentParameters.AppId)')") -Method Patch -Body $CSAParams
        }

        Update-MgServicePrincipal -ServicePrincipalId $currentAADServicePrincipal.ObjectID @currentParameters

        if ($IdentifierUris)
        {
            Write-Verbose -Message 'Updating the Application ID Uri on the application instance.'
            $appInstance = Get-MgApplication -Filter "AppId eq '$AppId'"
            Update-MgApplication -ApplicationId $appInstance.Id -IdentifierUris $IdentifierUris
        }
        if ($AppRoleAssignedToSpecified)
        {
            Write-Verbose -Message "Need to update AppRoleAssignedTo value"
            [Array]$currentPrincipals = $currentAADServicePrincipal.AppRoleAssignedTo.Identity
            [Array]$desiredPrincipals = $AppRoleAssignedTo.Identity

            if ($null -eq $currentPrincipals)
            {
                $currentPrincipals = @()
            }
            if ($null -eq $desiredPrincipals)
            {
                $desiredPrincipals = @()
            }

            [Array]$differences = Compare-Object -ReferenceObject $currentPrincipals -DifferenceObject $desiredPrincipals
            [Array]$membersToAdd = $differences | Where-Object -FilterScript { $_.SideIndicator -eq '=>' }
            [Array]$membersToRemove = $differences | Where-Object -FilterScript { $_.SideIndicator -eq '<=' }

            if ($differences.Count -gt 0)
            {
                if ($membersToAdd.Count -gt 0)
                {
                    $AppRoleAssignedToValues = @()
                    foreach ($assignment in $AppRoleAssignedTo)
                    {
                        $AppRoleAssignedToValues += @{
                            PrincipalType = $assignment.PrincipalType
                            Identity      = $assignment.Identity
                        }
                    }
                    foreach ($member in $membersToAdd)
                    {
                        $assignment = $AppRoleAssignedToValues | Where-Object -FilterScript { $_.Identity -eq $member.InputObject }
                        if ($assignment.PrincipalType -eq 'User')
                        {
                            Write-Verbose -Message "Retrieving user {$($assignment.Identity)}"
                            $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($assignment.Identity)')"
                            $PrincipalIdValue = $user.Id
                        }
                        else
                        {
                            Write-Verbose -Message "Retrieving group {$($assignment.Identity)}"
                            $group = Get-MgGroup -Filter "DisplayName eq '$($assignment.Identity -replace "'", "''")'"
                            $PrincipalIdValue = $group.Id
                        }

                        $bodyParam = @{
                            principalId = $PrincipalIdValue
                            resourceId  = $currentAADServicePrincipal.ObjectID
                            appRoleId   = '00000000-0000-0000-0000-000000000000'
                        }
                        Write-Verbose -Message "Adding member {$($member.InputObject.ToString())}"
                        New-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $currentAADServicePrincipal.ObjectID `
                            -BodyParameter $bodyParam | Out-Null
                    }
                }

                if ($membersToRemove.Count -gt 0)
                {
                    $AppRoleAssignedToValues = @()
                    foreach ($assignment in $currentAADServicePrincipal.AppRoleAssignedTo)
                    {
                        $AppRoleAssignedToValues += @{
                            PrincipalType = $assignment.PrincipalType
                            Identity      = $assignment.Identity
                        }
                    }
                    foreach ($member in $membersToRemove)
                    {
                        $assignment = $AppRoleAssignedToValues | Where-Object -FilterScript { $_.Identity -eq $member.InputObject }
                        if ($assignment.PrincipalType -eq 'User')
                        {
                            Write-Verbose -Message "Retrieving user {$($assignment.Identity)}"
                            $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($assignment.Identity)')"
                            $PrincipalIdValue = $user.Id
                        }
                        else
                        {
                            Write-Verbose -Message "Retrieving group {$($assignment.Identity)}"
                            $group = Get-MgGroup -Filter "DisplayName eq '$($assignment.Identity -replace "'", "''")'"
                            $PrincipalIdValue = $group.Id
                        }
                        Write-Verbose -Message "PrincipalID Value = '$PrincipalIdValue'"
                        Write-Verbose -Message "ServicePrincipalId = '$($currentAADServicePrincipal.ObjectID)'"
                        $allAssignments = Get-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $currentAADServicePrincipal.ObjectID -All
                        $assignmentToRemove = $allAssignments | Where-Object -FilterScript { $_.PrincipalId -eq $PrincipalIdValue }
                        Write-Verbose -Message "Removing member {$($member.InputObject.ToString())}"
                        Remove-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $currentAADServicePrincipal.ObjectID `
                            -AppRoleAssignmentId $assignmentToRemove.Id | Out-Null
                    }
                }
            }
        }

        Write-Verbose -Message 'Checking if owners need to be updated...'

        if ($null -ne $Owners)
        {
            $diffOwners = Compare-Object -ReferenceObject $currentAADServicePrincipal.Owners -DifferenceObject $Owners
        }
        foreach ($diff in $diffOwners)
        {
            $userInfo = Get-MgUser -UserId $diff.InputObject
            if ($diff.SideIndicator -eq '=>')
            {
                $body = @{
                    '@odata.id' = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "v1.0/directoryObjects/$($userInfo.Id)"
                }
                Write-Verbose -Message "Adding owner {$($userInfo.Id)}"
                New-MgServicePrincipalOwnerByRef -ServicePrincipalId $currentAADServicePrincipal.ObjectId `
                    -BodyParameter $body | Out-Null
            }
            else
            {
                Write-Verbose -Message "Removing owner {$($userInfo.Id)}"
                Remove-MgServicePrincipalOwnerDirectoryObjectByRef -ServicePrincipalId $currentAADServicePrincipal.ObjectId `
                    -DirectoryObjectId $userInfo.Id | Out-Null
            }
        }

        Write-Verbose -Message 'Checking if DelegatedPermissionClassifications need to be updated...'

        if ($null -ne $DelegatedPermissionClassifications)
        {
            # removing old perm classifications
            $Uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "v1.0/servicePrincipals(appId='$($currentParameters.AppId)')/delegatedPermissionClassifications"
            $permissionClassificationList = Invoke-MgGraphRequest -Uri $Uri -Method Get
            foreach ($permissionClassification in $permissionClassificationList.Value)
            {
                Invoke-MgGraphRequest -Uri "$($Uri)/$($permissionClassification.Id)" -Method Delete
            }

            # adding new perm classifications
            foreach ($permissionClassification in $DelegatedPermissionClassifications)
            {
                $params = @{
                    classification = $permissionClassification.Classification
                    permissionName = $permissionClassification.permissionName
                }
                Invoke-MgGraphRequest -Uri $Uri -Method Post -Body $params
            }
        }
    }
    # ServicePrincipal exists but should not
    elseif ($Ensure -eq 'Absent' -and $currentAADServicePrincipal.Ensure -eq 'Present')
    {
        Write-Verbose -Message 'Removing Service Principal'
        Remove-MgServicePrincipal -ServicePrincipalId $currentAADServicePrincipal.ObjectID
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
        $AppId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppRoleAssignedTo,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CustomSecurityAttributes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DelegatedPermissionClassifications,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String[]]
        $Owners,

        [Parameter()]
        [System.String]
        $PreferredSingleSignOnMode,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.String]
        $SamlMetadataURL,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $KeyCredentials,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PasswordCredentials,

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

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
                                         -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
                                         -ExcludedProperties @('ObjectId')
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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $dscContent = [System.Text.StringBuilder]::new()
    try
    {
        $i = 1
        Write-M365DSCHost -Message "`r`n" -DeferWrite
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = Get-MgServicePrincipal -All:$true `
            -Filter $Filter `
            -Expand 'AppRoleAssignedTo' `
            -Property $Script:PropertiesToExport `
            -ErrorAction Stop
        foreach ($AADServicePrincipal in $Script:exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($Script:exportedInstances.Count)] $($AADServicePrincipal.DisplayName)" -DeferWrite
            $Params = @{
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                ApplicationSecret     = $ApplicationSecret
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AppID                 = $AADServicePrincipal.AppId
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $AADServicePrincipal
            $Results = Get-TargetResource @Params
            if ($Results.Ensure -eq 'Present')
            {
                if ($Results.AppRoleAssignedTo.Count -gt 0)
                {
                    $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $Results.AppRoleAssignedTo `
                        -CIMInstanceName 'AADServicePrincipalRoleAssignment'
                    if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                    {
                        $Results.AppRoleAssignedTo = $complexTypeStringResult
                    }
                    else
                    {
                        $Results.Remove('AppRoleAssignedTo') | Out-Null
                    }
                }
                if ($Results.DelegatedPermissionClassifications.Count -gt 0)
                {
                    $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $Results.DelegatedPermissionClassifications `
                        -CIMInstanceName 'AADServicePrincipalDelegatedPermissionClassification' -IsArray:$true
                    if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                    {
                        $Results.DelegatedPermissionClassifications = $complexTypeStringResult
                    }
                    else
                    {
                        $Results.Remove('DelegatedPermissionClassifications') | Out-Null
                    }
                }
                if ($null -ne $Results.KeyCredentials)
                {
                    $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $Results.KeyCredentials `
                        -CIMInstanceName 'MicrosoftGraphkeyCredential' -IsArray:$true
                    if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                    {
                        $Results.KeyCredentials = $complexTypeStringResult
                    }
                    else
                    {
                        $Results.Remove('KeyCredentials') | Out-Null
                    }
                }
                if ($null -ne $Results.PasswordCredentials)
                {
                    $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $Results.PasswordCredentials `
                        -CIMInstanceName 'MicrosoftGraphpasswordCredential' -IsArray:$true
                    if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                    {
                        $Results.PasswordCredentials = $complexTypeStringResult
                    }
                    else
                    {
                        $Results.Remove('PasswordCredentials') | Out-Null
                    }
                }
                if ($Results.CustomSecurityAttributes.Count -gt 0)
                {
                    $complexMapping = @(
                        @{
                            Name            = 'CustomSecurityAttributes'
                            CimInstanceName = 'AADServicePrincipalAttributeSet'
                            IsRequired      = $False
                        },
                        @{
                            Name            = 'AttributeValues'
                            CimInstanceName = 'AADServicePrincipalAttributeValue'
                            IsRequired      = $False
                        }
                    )
                    $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $Results.CustomSecurityAttributes `
                        -CIMInstanceName 'AADServicePrincipalAttributeSet' `
                        -ComplexTypeMapping $complexMapping `
                        -IsArray:$true
                    if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                    {
                        $Results.CustomSecurityAttributes = $complexTypeStringResult
                    }
                    else
                    {
                        $Results.Remove('CustomSecurityAttributes') | Out-Null
                    }
                }
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential `
                    -NoEscape @('AppRoleAssignedTo', 'DelegatedPermissionClassifications', 'KeyCredentials', 'PasswordCredentials', 'CustomSecurityAttributes')

                $dscContent.Append($currentDSCBlock) | Out-Null
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName

                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
                $i++
            }
        }
        return $dscContent.ToString()
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Get-M365DSCAADServicePrincipalCustomSecurityAttributesAsCmdletHashtable
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.ArrayList]
        $CustomSecurityAttributes,

        [Parameter()]
        [System.Boolean]
        $GetForDelete = $false
    )

    # logic to update the custom security attributes to be cmdlet comsumable
    $updatedCustomSecurityAttributes = @{}
    foreach ($attributeSet in $CustomSecurityAttributes)
    {
        $attributeSetKey = $attributeSet.AttributeSetName

        $valuesHashtable = @{}
        $valuesHashtable.Add('@odata.type', '#Microsoft.DirectoryServices.CustomSecurityAttributeValue')
        foreach ($attribute in $attributeSet.AttributeValues)
        {
            $attributeKey = $attribute.AttributeName
            # supply attributeName = $null in the body, if you want to delete this attribute
            if ($GetForDelete -eq $true)
            {
                $valuesHashtable.Add($attributeKey, $null)
                continue
            }

            $odataKey = $attributeKey + '@odata.type'

            if ($null -ne $attribute.StringArrayValue)
            {
                $valuesHashtable.Add($odataKey, '#Collection(String)')
                $attributeValue = $attribute.StringArrayValue
            }
            elseif ($null -ne $attribute.IntArrayValue)
            {
                $valuesHashtable.Add($odataKey, '#Collection(Int32)')
                $attributeValue = $attribute.IntArrayValue
            }
            elseif ($null -ne $attribute.StringValue)
            {
                $valuesHashtable.Add($odataKey, '#String')
                $attributeValue = $attribute.StringValue
            }
            elseif ($null -ne $attribute.IntValue)
            {
                $valuesHashtable.Add($odataKey, '#Int32')
                $attributeValue = $attribute.IntValue
            }
            elseif ($null -ne $attribute.BoolValue)
            {
                $attributeValue = $attribute.BoolValue
            }

            $valuesHashtable.Add($attributeKey, $attributeValue)
        }
        $updatedCustomSecurityAttributes.Add($attributeSetKey, $valuesHashtable)
    }
    return $updatedCustomSecurityAttributes
}

# Function to create MSFT_AttributeValue
function New-AttributeValue
{
    param
    (
        [string]$AttributeName,
        [object]$Value
    )

    $attributeValue = @{
        AttributeName    = $AttributeName
        StringArrayValue = $null
        IntArrayValue    = $null
        StringValue      = $null
        IntValue         = $null
        BoolValue        = $null
    }

    # Handle different types of values
    if ($Value -is [string])
    {
        $attributeValue.StringValue = $Value
    }
    elseif ($Value -is [System.Int32] -or $Value -is [System.Int64])
    {
        $attributeValue.IntValue = $Value
    }
    elseif ($Value -is [bool])
    {
        $attributeValue.BoolValue = $Value
    }
    elseif ($Value -is [array])
    {
        if ($Value[0] -is [string])
        {
            $attributeValue.StringArrayValue = $Value
        }
        elseif ($Value[0] -is [System.Int32] -or $Value[0] -is [System.Int64])
        {
            $attributeValue.IntArrayValue = $Value
        }
    }

    return $attributeValue
}


function Get-CustomSecurityAttributes
{
    [OutputType([System.Array])]
    param
    (
        $ServicePrincipal
    )

    $customSecurityAttributes = $ServicePrincipal.customSecurityAttributes
    $newCustomSecurityAttributes = @()

    foreach ($key in $customSecurityAttributes.Keys)
    {
        $attributeSet = @{
            AttributeSetName = $key
            AttributeValues  = @()
        }

        foreach ($attribute in $customSecurityAttributes[$key].Keys)
        {
            # Skip properties that end with '@odata.type'
            if ($attribute -like '*@odata.type')
            {
                continue
            }

            $value = $customSecurityAttributes[$key][$attribute]
            $attributeName = $attribute # Keep the attribute name as it is

            # Create the attribute value and add it to the set
            $attributeSet.AttributeValues += New-AttributeValue -AttributeName $attributeName -Value $value
        }

        #Add the attribute set to the final structure
        $newCustomSecurityAttributes += $attributeSet
    }

    # Display the new structure
    return [Array]$newCustomSecurityAttributes
}

Export-ModuleMember -Function *-TargetResource
