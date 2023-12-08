function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        [ValidateSet('disabled', 'enabled', 'enabledForReportingButNotEnforced')]
        $State,

        #ConditionalAccessApplicationCondition
        [Parameter()]
        [System.String[]]
        $IncludeApplications,

        [Parameter()]
        [System.String[]]
        $ExcludeApplications,

        [Parameter()]
        [System.String[]]
        $IncludeUserActions,

        #ConditionalAccessUserCondition
        [Parameter()]
        [System.String[]]
        $IncludeUsers,

        [Parameter()]
        [System.String[]]
        $ExcludeUsers,

        [Parameter()]
        [System.String[]]
        $IncludeGroups,

        [Parameter()]
        [System.String[]]
        $ExcludeGroups,

        [Parameter()]
        [System.String[]]
        $IncludeRoles,

        [Parameter()]
        [System.String[]]
        $ExcludeRoles,

        [Parameter()]
        [System.String[]]
        [validateSet('none', 'internalGuest', 'b2bCollaborationGuest', 'b2bCollaborationMember', 'b2bDirectConnectUser', 'otherExternalUser', 'serviceProvider', 'unknownFutureValue')]
        $IncludeGuestOrExternalUserTypes,

        [Parameter()]
        [System.String]
        [ValidateSet('', 'all', 'enumerated', 'unknownFutureValue')]
        $IncludeExternalTenantsMembershipKind,

        [Parameter()]
        [System.String[]]
        $IncludeExternalTenantsMembers,

        [Parameter()]
        [System.String[]]
        [validateSet('none', 'internalGuest', 'b2bCollaborationGuest', 'b2bCollaborationMember', 'b2bDirectConnectUser', 'otherExternalUser', 'serviceProvider', 'unknownFutureValue')]
        $ExcludeGuestOrExternalUserTypes,

        [Parameter()]
        [System.String]
        [ValidateSet('', 'all', 'enumerated', 'unknownFutureValue')]
        $ExcludeExternalTenantsMembershipKind,

        [Parameter()]
        [System.String[]]
        $ExcludeExternalTenantsMembers,

        #ConditionalAccessPlatformCondition
        [Parameter()]
        [System.String[]]
        $IncludePlatforms,

        [Parameter()]
        [System.String[]]
        $ExcludePlatforms,

        #ConditionalAccessLocationCondition
        [Parameter()]
        [System.String[]]
        $IncludeLocations,

        [Parameter()]
        [System.String[]]
        $ExcludeLocations,

        [Parameter()]
        [ValidateSet('include', 'exclude')]
        [System.String]
        $DeviceFilterMode,

        [Parameter()]
        [System.String]
        $DeviceFilterRule,

        #Further conditions
        [Parameter()]
        [System.String[]]
        $UserRiskLevels,

        [Parameter()]
        [System.String[]]
        $SignInRiskLevels,

        [Parameter()]
        [System.String[]]
        $ClientAppTypes,

        #ConditionalAccessGrantControls
        [Parameter()]
        [ValidateSet('AND', 'OR')]
        [System.String]
        $GrantControlOperator,

        [Parameter()]
        [System.String[]]
        $BuiltInControls,

        #ConditionalAccessSessionControls
        [Parameter()]
        [System.Boolean]
        $ApplicationEnforcedRestrictionsIsEnabled,

        [Parameter()]
        [System.Boolean]
        $CloudAppSecurityIsEnabled,

        [Parameter()]
        [System.String]
        $CloudAppSecurityType,

        [Parameter()]
        [System.Int32]
        $SignInFrequencyValue,

        [Parameter()]
        [ValidateSet('Days', 'Hours', '')]
        [System.String]
        $SignInFrequencyType,

        [Parameter()]
        [System.Boolean]
        $SignInFrequencyIsEnabled,

        [Parameter()]
        [ValidateSet('timeBased', 'everyTime', 'unknownFutureValue')]
        [System.String]
        $SignInFrequencyInterval,

        [Parameter()]
        [ValidateSet('Always', 'Never', '')]
        [System.String]
        $PersistentBrowserMode,

        [Parameter()]
        [System.Boolean]
        $PersistentBrowserIsEnabled,

        [Parameter()]
        [System.String]
        $TermsOfUse,

        [Parameter()]
        [System.String[]]
        $CustomAuthenticationFactors,

        [Parameter()]
        [System.String]
        $AuthenticationStrength,

        [Parameter()]
        [System.String[]]
        $AuthenticationContexts,

        #generic
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

    Write-Verbose 'Getting configuration of AzureAD Conditional Access Policy'
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

    if ($PSBoundParameters.ContainsKey('Id'))
    {
        Write-Verbose 'PolicyID was specified'
        try
        {
            $Policy = Get-MgBetaIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $Id -ErrorAction Stop
        }
        catch
        {
            Write-Verbose "Couldn't find existing policy by ID {$Id}"
            $Policy = Get-MgBetaIdentityConditionalAccessPolicy -Filter "DisplayName eq '$DisplayName'"
            if ($Policy.Length -gt 1)
            {
                throw "Duplicate CA Policies named $DisplayName exist in tenant"
            }
        }
    }
    else
    {
        Write-Verbose 'Id was NOT specified'
        ## Can retreive multiple CA Policies since displayname is not unique
        $Policy = Get-MgBetaIdentityConditionalAccessPolicy -Filter "DisplayName eq '$DisplayName'"
        if ($Policy.Length -gt 1)
        {
            throw "Duplicate CA Policies named $DisplayName exist in tenant"
        }
    }

    if ($null -eq $Policy)
    {
        Write-Verbose "No existing Policy with name {$DisplayName} were found"
        $currentValues = $PSBoundParameters
        $currentValues.Ensure = 'Absent'
        return $currentValues
    }
    else
    {
        Write-Verbose 'Get-TargetResource: Found existing Conditional Access policy'
        $PolicyDisplayName = $Policy.DisplayName

        Write-Verbose 'Get-TargetResource: Process IncludeUsers'
        #translate IncludeUser GUIDs to UPN, except id value is GuestsOrExternalUsers, None or All
        $IncludeUsers = @()
        if ($Policy.Conditions.Users.IncludeUsers)
        {
            foreach ($IncludeUserGUID in $Policy.Conditions.Users.IncludeUsers)
            {
                if ($IncludeUserGUID -notin 'GuestsOrExternalUsers', 'All', 'None')
                {
                    $IncludeUser = $null
                    try
                    {
                        $IncludeUser = (Get-MgUser -UserId $IncludeUserGUID -ErrorAction Stop).userprincipalname
                    }
                    catch
                    {
                        New-M365DSCLogEntry -Message 'Error retrieving data:' `
                            -Exception $_ `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $TenantId `
                            -Credential $Credential
                    }
                    if ($IncludeUser)
                    {
                        $IncludeUsers += $IncludeUser
                    }
                }
                else
                {
                    $IncludeUsers += $IncludeUserGUID
                }
            }
        }

        Write-Verbose 'Get-TargetResource: Process ExcludeUsers'
        #translate ExcludeUser GUIDs to UPN, except id value is GuestsOrExternalUsers, None or All
        $ExcludeUsers = @()
        if ($Policy.Conditions.Users.ExcludeUsers)
        {
            foreach ($ExcludeUserGUID in $Policy.Conditions.Users.ExcludeUsers)
            {
                if ($ExcludeUserGUID -notin 'GuestsOrExternalUsers', 'All', 'None')
                {
                    $ExcludeUser = $null
                    try
                    {
                        $ExcludeUser = (Get-MgUser -UserId $ExcludeUserGUID -ErrorAction Stop).userprincipalname
                    }
                    catch
                    {
                        $message = "Couldn't find user $ExcludeUserGUID , that is defined in policy $PolicyDisplayName"
                        New-M365DSCLogEntry -Message $message `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $TenantId `
                            -Credential $Credential
                    }
                    if ($ExcludeUser)
                    {
                        $ExcludeUsers += $ExcludeUser
                    }
                }
                else
                {
                    $ExcludeUsers += $ExcludeUserGUID
                }
            }
        }

        Write-Verbose 'Get-TargetResource: Process IncludeGroups'
        #translate IncludeGroup GUIDs to DisplayName
        $IncludeGroups = @()
        if ($Policy.Conditions.Users.IncludeGroups)
        {
            foreach ($IncludeGroupGUID in $Policy.Conditions.Users.IncludeGroups)
            {
                $IncludeGroup = $null
                try
                {
                    $IncludeGroup = (Get-MgGroup -GroupId $IncludeGroupGUID).displayname
                }
                catch
                {
                    $message = "Couldn't find Group $IncludeGroupGUID , that is defined in policy $PolicyDisplayName"
                    New-M365DSCLogEntry -Message $message `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                }
                if ($IncludeGroup)
                {
                    $IncludeGroups += $IncludeGroup
                }
            }
        }

        Write-Verbose 'Get-TargetResource: Process ExcludeGroups'
        #translate ExcludeGroup GUIDs to DisplayName
        $ExcludeGroups = @()
        if ($Policy.Conditions.Users.ExcludeGroups)
        {
            foreach ($ExcludeGroupGUID in $Policy.Conditions.Users.ExcludeGroups)
            {
                $ExcludeGroup = $null
                try
                {
                    $ExcludeGroup = (Get-MgGroup -GroupId $ExcludeGroupGUID).displayname
                }
                catch
                {
                    $message = "Couldn't find Group $ExcludeGroupGUID , that is defined in policy $PolicyDisplayName"
                    New-M365DSCLogEntry -Message $message `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                }
                if ($ExcludeGroup)
                {
                    $ExcludeGroups += $ExcludeGroup
                }
            }
        }


        $IncludeRoles = @()
        $ExcludeRoles = @()
        #translate role template guids to role name
        if ($Policy.Conditions.Users.IncludeRoles -or $Policy.Conditions.Users.ExcludeRoles)
        {
            Write-Verbose 'Get-TargetResource: Role condition defined, processing'
            #build role translation table
            $rolelookup = @{}
            foreach ($role in Get-MgBetaDirectoryRoleTemplate)
            {
                $rolelookup[$role.Id] = $role.DisplayName
            }

            Write-Verbose 'Get-TargetResource: Processing IncludeRoles'
            if ($Policy.Conditions.Users.IncludeRoles)
            {
                foreach ($IncludeRoleGUID in $Policy.Conditions.Users.IncludeRoles)
                {
                    if ($null -eq $rolelookup[$IncludeRoleGUID])
                    {
                        $message = "Couldn't find role $IncludeRoleGUID , couldn't add to policy $PolicyDisplayName"
                        New-M365DSCLogEntry -Message $message `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $TenantId `
                            -Credential $Credential
                    }
                    else
                    {
                        $IncludeRoles += $rolelookup[$IncludeRoleGUID]
                    }
                }
            }

            Write-Verbose 'Get-TargetResource: Processing ExcludeRoles'
            if ($Policy.Conditions.Users.ExcludeRoles)
            {
                foreach ($ExcludeRoleGUID in $Policy.Conditions.Users.ExcludeRoles)
                {
                    if ($null -eq $rolelookup[$ExcludeRoleGUID])
                    {
                        $message = "Couldn't find role $ExcludeRoleGUID , couldn't add to policy $PolicyDisplayName"
                        New-M365DSCLogEntry -Message $message `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $TenantId `
                            -Credential $Credential
                    }
                    else
                    {
                        $ExcludeRoles += $rolelookup[$ExcludeRoleGUID]
                    }
                }
            }

        }

        $IncludeLocations = @()
        $ExcludeLocations = @()
        #translate Location template guids to Location name
        if ($Policy.Conditions.Locations)
        {
            Write-Verbose 'Get-TargetResource: Location condition defined, processing'
            #build Location translation table
            $Locationlookup = @{}
            foreach ($Location in Get-MgBetaIdentityConditionalAccessNamedLocation)
            {
                $Locationlookup[$Location.Id] = $Location.DisplayName
            }

            Write-Verbose 'Get-TargetResource: Processing IncludeLocations'
            if ($Policy.Conditions.Locations.IncludeLocations)
            {
                foreach ($IncludeLocationGUID in $Policy.Conditions.Locations.IncludeLocations)
                {
                    if ($IncludeLocationGUID -in 'All', 'AllTrusted')
                    {
                        $IncludeLocations += $IncludeLocationGUID
                    }
                    elseif ($IncludeLocationGUID -eq '00000000-0000-0000-0000-000000000000')
                    {
                        $IncludeLocations += 'Multifactor authentication trusted IPs'
                    }
                    elseif ($null -eq $Locationlookup[$IncludeLocationGUID])
                    {
                        $message = "Couldn't find Location $IncludeLocationGUID , couldn't add to policy $PolicyDisplayName"
                        New-M365DSCLogEntry -Message $message `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $TenantId `
                            -Credential $Credential
                    }
                    else
                    {
                        $IncludeLocations += $Locationlookup[$IncludeLocationGUID]
                    }
                }
            }

            Write-Verbose 'Get-TargetResource: Processing ExcludeLocations'
            if ($Policy.Conditions.Locations.ExcludeLocations)
            {
                foreach ($ExcludeLocationGUID in $Policy.Conditions.Locations.ExcludeLocations)
                {
                    if ($ExcludeLocationGUID -in 'All', 'AllTrusted')
                    {
                        $ExcludeLocations += $ExcludeLocationGUID
                    }
                    elseif ($ExcludeLocationGUID -eq '00000000-0000-0000-0000-000000000000')
                    {
                        $ExcludeLocations += 'Multifactor authentication trusted IPs'
                    }
                    elseif ($null -eq $Locationlookup[$ExcludeLocationGUID])
                    {
                        $message = "Couldn't find Location $ExcludeLocationGUID , couldn't add to policy $PolicyDisplayName"
                        New-M365DSCLogEntry -Message $message `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $TenantId `
                            -Credential $Credential
                    }
                    else
                    {
                        $ExcludeLocations += $Locationlookup[$ExcludeLocationGUID]
                    }
                }
            }
        }

        # translate application displaynames to appplication ids
        Write-verbose "Get-TargetResource: process IncludeApplications"
        $IncludeApplications = @()
        if ($Policy.Conditions.Applications.IncludeApplications)
        {
            foreach ($appId in $Policy.Conditions.Applications.IncludeApplications)
            {
                if ($null -ne ($appId -as [guid])) # is this a GUID ?
                {
                    # if appId is a GUID then it MUST correspond to an existing AppId
                    $spn = Get-MgServicePrincipalByAppId -AppId $appId
                    Write-verbose "Get-TargetResource: IncludeApplications: AppId GUID $appid refers to SPN $($spn.DisplayName)"
                    # check if displayname is unique
                    $spnUnique = Get-MgServicePrincipal -Filter "DisplayName eq '$($spn.DisplayName)'"
                    if ($spnUnique.Count -gt 1)
                    {
                        Add-M365DSCEvent -Message "AADConditionalAccessPolicy $DisplayName, Get-TargetResource, IncludeApplications: SPN DisplayName $($spn.DisplayName) is not unique, target app by GUID" `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -EntryType Warning `
                            -EventID 2 `
                            -EventType Warning
                        $IncludeApplications += $appId
                    }
                    else
                    {
                        $IncludeApplications += $spn.DisplayName
                    }
                }
                else
                {
                    Write-verbose "Get-TargetResource: IncludeApplications: AppId $appid is a logical app name"
                    # if appId is *not* a GUID, add it untranslated (ie 'All', 'Office365', 'MicrosoftAdminPortals'), see https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-cloud-apps
                    $IncludeApplications += $appId
                }
            }
        }

        Write-verbose "Get-TargetResource: process ExcludeApplications"
        $ExcludeApplications = @()
        if ($Policy.Conditions.Applications.IncludeApplications)
        {
            foreach ($appId in $Policy.Conditions.Applications.ExcludeApplications)
            {
                if ($null -ne ($appId -as [guid])) # is this a GUID ?
                {
                    # if appId is a GUID then it MUST correspond to an existing AppId
                    $spn = Get-MgServicePrincipalByAppId -AppId $appId
                    Write-verbose "Get-TargetResource: ExcludeApplications: AppId GUID $appid refers to SPN $($spn.DisplayName)"
                    # check if displayname is unique
                    $spnUnique = Get-MgServicePrincipal -Filter "DisplayName eq '$($spn.DisplayName)'"
                    if ($spnUnique.Count -gt 1)
                    {
                        Add-M365DSCEvent -Message "AADConditionalAccessPolicy $DisplayName, Get-TargetResource, ExcludeApplications: SPN DisplayName $($spn.DisplayName) is not unique, target app by GUID" `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -EntryType Warning `
                            -EventID 2 `
                            -EventType Warning
                        $ExcludeApplications += $appId
                    }
                    else
                    {
                        $ExcludeApplications += $spn.DisplayName
                    }
                }
                else
                {
                    Write-verbose "Get-TargetResource: ExcludeApplications: AppId $appid is a logical app name"
                    # if appId is *not* a GUID, add it untranslated (ie 'All', 'Office365', 'MicrosoftAdminPortals'), see https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-cloud-apps
                    $ExcludeApplications += $appId
                }
            }
        }

        if ($Policy.SessionControls.CloudAppSecurity.IsEnabled)
        {
            $CloudAppSecurityType = [System.String]$Policy.SessionControls.CloudAppSecurity.CloudAppSecurityType
        }
        else
        {
            $CloudAppSecurityType = $null
        }
        if ($Policy.SessionControls.SignInFrequency.IsEnabled)
        {
            $SignInFrequencyType = [System.String]$Policy.SessionControls.SignInFrequency.Type
            $SignInFrequencyIntervalValue = [System.String]$Policy.SessionControls.SignInFrequency.FrequencyInterval
        }
        else
        {
            $SignInFrequencyType = $null
            $SignInFrequencyIntervalValue = $null
        }
        if ($Policy.SessionControls.PersistentBrowser.IsEnabled)
        {
            $PersistentBrowserMode = [System.String]$Policy.SessionControls.PersistentBrowser.Mode
        }
        else
        {
            $PersistentBrowserMode = $null
        }
        if ($Policy.Conditions.Users.IncludeGuestsOrExternalUsers.GuestOrExternalUserTypes)
        {
            [Array]$IncludeGuestOrExternalUserTypes = ($Policy.Conditions.Users.IncludeGuestsOrExternalUsers.GuestOrExternalUserTypes).Split(',')
        }
        if ($Policy.Conditions.Users.ExcludeGuestsOrExternalUsers.GuestOrExternalUserTypes)
        {
            [Array]$ExcludeGuestOrExternalUserTypes = ($Policy.Conditions.Users.ExcludeGuestsOrExternalUsers.GuestOrExternalUserTypes).Split(',')
        }

        $termsOfUseName = $null
        if ($Policy.GrantControls.TermsOfUse)
        {
            $termsOfUse = Get-MgBetaAgreement | Where-Object -FilterScript { $_.Id -eq $Policy.GrantControls.TermsOfUse }
            if ($termsOfUse)
            {
                $termsOfUseName = $termsOfUse.DisplayName
            }
        }

        $AuthenticationStrengthValue = $null
        if ($null -ne $Policy.GrantControls -and $null -ne $Policy.GrantControls.AuthenticationStrength -and `
            $null -ne $Policy.GrantControls.AuthenticationStrength.Id)
        {
            $strengthPolicy = Get-MgBetaPolicyAuthenticationStrengthPolicy -AuthenticationStrengthPolicyId $Policy.GrantControls.AuthenticationStrength.Id
            if ($null -ne $strengthPolicy)
            {
                $AuthenticationStrengthValue = $strengthPolicy.DisplayName
            }
        }

        $AuthenticationContextsValues = @()
        if ($null -ne $Policy.Conditions.Applications.IncludeAuthenticationContextClassReferences)
        {
            foreach ($class in $Policy.Conditions.Applications.IncludeAuthenticationContextClassReferences)
            {
                $classReference = Get-MgBetaIdentityConditionalAccessAuthenticationContextClassReference `
                                      -AuthenticationContextClassReferenceId $class `
                                      -ErrorAction SilentlyContinue
                if ($null -ne $classReference)
                {
                    $AuthenticationContextsValues += $classReference.DisplayName
                }
            }
        }

        $result = @{
            DisplayName                              = $Policy.DisplayName
            Id                                       = $Policy.Id
            State                                    = $Policy.State
            IncludeApplications                      = $IncludeApplications
            ExcludeApplications                      = $ExcludeApplications
            #no translation of GUIDs, return empty string array if undefined
            IncludeUserActions                       = [System.String[]](@() + $Policy.Conditions.Applications.IncludeUserActions)
            #no translation needed, return empty string array if undefined
            IncludeUsers                             = $IncludeUsers
            ExcludeUsers                             = $ExcludeUsers
            IncludeGroups                            = $IncludeGroups
            ExcludeGroups                            = $ExcludeGroups
            IncludeRoles                             = $IncludeRoles
            ExcludeRoles                             = $ExcludeRoles
            IncludeGuestOrExternalUserTypes          = [System.String[]]$IncludeGuestOrExternalUserTypes
            IncludeExternalTenantsMembershipKind     = [System.String]$Policy.Conditions.Users.IncludeGuestsOrExternalUsers.ExternalTenants.MembershipKind
            IncludeExternalTenantsMembers            = [System.String[]](@() + $Policy.Conditions.Users.IncludeGuestsOrExternalUsers.ExternalTenants.AdditionalProperties.members)

            ExcludeGuestOrExternalUserTypes          = [System.String[]]$ExcludeGuestOrExternalUserTypes
            ExcludeExternalTenantsMembershipKind     = [System.String]$Policy.Conditions.Users.ExcludeGuestsOrExternalUsers.ExternalTenants.MembershipKind
            ExcludeExternalTenantsMembers            = [System.String[]](@() + $Policy.Conditions.Users.ExcludeGuestsOrExternalUsers.ExternalTenants.AdditionalProperties.members)

            IncludePlatforms                         = [System.String[]](@() + $Policy.Conditions.Platforms.IncludePlatforms)
            #no translation needed, return empty string array if undefined
            ExcludePlatforms                         = [System.String[]](@() + $Policy.Conditions.Platforms.ExcludePlatforms)
            #no translation needed, return empty string array if undefined
            IncludeLocations                         = $IncludeLocations
            ExcludeLocations                         = $ExcludeLocations

            #no translation needed, return empty string array if undefined
            DeviceFilterMode                         = [System.String]$Policy.Conditions.Devices.DeviceFilter.Mode
            #no translation or conversion needed
            DeviceFilterRule                         = [System.String]$Policy.Conditions.Devices.DeviceFilter.Rule
            #no translation or conversion needed
            UserRiskLevels                           = [System.String[]](@() + $Policy.Conditions.UserRiskLevels)
            #no translation needed, return empty string array if undefined
            SignInRiskLevels                         = [System.String[]](@() + $Policy.Conditions.SignInRiskLevels)
            #no translation needed, return empty string array if undefined
            ClientAppTypes                           = [System.String[]](@() + $Policy.Conditions.ClientAppTypes)
            #no translation needed, return empty string array if undefined
            GrantControlOperator                     = $Policy.GrantControls.Operator
            #no translation or conversion needed
            BuiltInControls                          = [System.String[]](@() + $Policy.GrantControls.BuiltInControls)
            CustomAuthenticationFactors              = [System.String[]](@() + $Policy.GrantControls.CustomAuthenticationFactors)
            #no translation needed, return empty string array if undefined
            ApplicationEnforcedRestrictionsIsEnabled = $false -or $Policy.SessionControls.ApplicationEnforcedRestrictions.IsEnabled
            #make false if undefined, true if true
            CloudAppSecurityIsEnabled                = $false -or $Policy.SessionControls.CloudAppSecurity.IsEnabled
            #make false if undefined, true if true
            CloudAppSecurityType                     = [System.String]$Policy.SessionControls.CloudAppSecurity.CloudAppSecurityType
            #no translation needed, return empty string array if undefined
            SignInFrequencyIsEnabled                 = $false -or $Policy.SessionControls.SignInFrequency.IsEnabled
            #make false if undefined, true if true
            SignInFrequencyValue                     = $Policy.SessionControls.SignInFrequency.Value
            #no translation or conversion needed, $null returned if undefined
            SignInFrequencyType                      = [System.String]$Policy.SessionControls.SignInFrequency.Type
            SignInFrequencyInterval                  = $SignInFrequencyIntervalValue
            #no translation needed
            PersistentBrowserIsEnabled               = $false -or $Policy.SessionControls.PersistentBrowser.IsEnabled
            #make false if undefined, true if true
            PersistentBrowserMode                    = [System.String]$Policy.SessionControls.PersistentBrowser.Mode
            #no translation needed
            AuthenticationStrength                   = $AuthenticationStrengthValue
            AuthenticationContexts                   = $AuthenticationContextsValues
            #Standard part
            TermsOfUse                               = $termsOfUseName
            Ensure                                   = 'Present'
            Credential                               = $Credential
            ApplicationSecret                        = $ApplicationSecret
            ApplicationId                            = $ApplicationId
            TenantId                                 = $TenantId
            CertificateThumbprint                    = $CertificateThumbprint
            Managedidentity                          = $ManagedIdentity.IsPresent
        }
        Write-Verbose "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        [ValidateSet('disabled', 'enabled', 'enabledForReportingButNotEnforced')]
        $State,

        #ConditionalAccessApplicationCondition
        [Parameter()]
        [System.String[]]
        $IncludeApplications,

        [Parameter()]
        [System.String[]]
        $ExcludeApplications,

        [Parameter()]
        [System.String[]]
        $IncludeUserActions,

        #ConditionalAccessUserCondition
        [Parameter()]
        [System.String[]]
        $IncludeUsers,

        [Parameter()]
        [System.String[]]
        $ExcludeUsers,

        [Parameter()]
        [System.String[]]
        $IncludeGroups,

        [Parameter()]
        [System.String[]]
        $ExcludeGroups,

        [Parameter()]
        [System.String[]]
        $IncludeRoles,

        [Parameter()]
        [System.String[]]
        $ExcludeRoles,

        [Parameter()]
        [System.String[]]
        [validateSet('none', 'internalGuest', 'b2bCollaborationGuest', 'b2bCollaborationMember', 'b2bDirectConnectUser', 'otherExternalUser', 'serviceProvider', 'unknownFutureValue')]
        $IncludeGuestOrExternalUserTypes,

        [Parameter()]
        [System.String]
        [ValidateSet('', 'all', 'enumerated', 'unknownFutureValue')]
        $IncludeExternalTenantsMembershipKind,

        [Parameter()]
        [System.String[]]
        $IncludeExternalTenantsMembers,

        [Parameter()]
        [System.String[]]
        [validateSet('none', 'internalGuest', 'b2bCollaborationGuest', 'b2bCollaborationMember', 'b2bDirectConnectUser', 'otherExternalUser', 'serviceProvider', 'unknownFutureValue')]
        $ExcludeGuestOrExternalUserTypes,

        [Parameter()]
        [System.String]
        [ValidateSet('', 'all', 'enumerated', 'unknownFutureValue')]
        $ExcludeExternalTenantsMembershipKind,

        [Parameter()]
        [System.String[]]
        $ExcludeExternalTenantsMembers,

        #ConditionalAccessPlatformCondition
        [Parameter()]
        [System.String[]]
        $IncludePlatforms,

        [Parameter()]
        [System.String[]]
        $ExcludePlatforms,

        #ConditionalAccessLocationCondition
        [Parameter()]
        [System.String[]]
        $IncludeLocations,

        [Parameter()]
        [System.String[]]
        $ExcludeLocations,

        [Parameter()]
        [ValidateSet('include', 'exclude')]
        [System.String]
        $DeviceFilterMode,

        [Parameter()]
        [System.String]
        $DeviceFilterRule,

        #Further conditions
        [Parameter()]
        [System.String[]]
        $UserRiskLevels,

        [Parameter()]
        [System.String[]]
        $SignInRiskLevels,

        [Parameter()]
        [System.String[]]
        $ClientAppTypes,

        #ConditionalAccessGrantControls
        [Parameter()]
        [ValidateSet('AND', 'OR')]
        [System.String]
        $GrantControlOperator,

        [Parameter()]
        [System.String[]]
        $BuiltInControls,

        #ConditionalAccessSessionControls
        [Parameter()]
        [System.Boolean]
        $ApplicationEnforcedRestrictionsIsEnabled,

        [Parameter()]
        [System.Boolean]
        $CloudAppSecurityIsEnabled,

        [Parameter()]
        [System.String]
        $CloudAppSecurityType,

        [Parameter()]
        [System.Int32]
        $SignInFrequencyValue,

        [Parameter()]
        [ValidateSet('Days', 'Hours', '')]
        [System.String]
        $SignInFrequencyType,

        [Parameter()]
        [System.Boolean]
        $SignInFrequencyIsEnabled,

        [Parameter()]
        [ValidateSet('timeBased', 'everyTime', 'unknownFutureValue')]
        [System.String]
        $SignInFrequencyInterval,

        [Parameter()]
        [ValidateSet('Always', 'Never', '')]
        [System.String]
        $PersistentBrowserMode,

        [Parameter()]
        [System.Boolean]
        $PersistentBrowserIsEnabled,

        [Parameter()]
        [System.String]
        $TermsOfUse,

        [Parameter()]
        [System.String[]]
        $CustomAuthenticationFactors,

        [Parameter()]
        [System.String]
        $AuthenticationStrength,

        [Parameter()]
        [System.String[]]
        $AuthenticationContexts,

        #generic
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
    Write-Verbose 'Setting configuration of AzureAD Conditional Access Policy'

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

    Write-Verbose 'Set-Targetresource: Running Get-TargetResource'
    $currentPolicy = Get-TargetResource @PSBoundParameters
    Write-Verbose 'Set-Targetresource: Cleaning up parameters'
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove('ApplicationId') | Out-Null
    $currentParameters.Remove('TenantId') | Out-Null
    $currentParameters.Remove('CertificateThumbprint') | Out-Null
    $currentParameters.Remove('ApplicationSecret') | Out-Null
    $currentParameters.Remove('Ensure') | Out-Null
    $currentParameters.Remove('Credential') | Out-Null
    $currentParameters.Remove('ManagedIdentity') | Out-Null

    if ($Ensure -eq 'Present')#create policy attribute objects
    {
        Write-Verbose "Set-Targetresource: Policy $Displayname Ensure Present"
        $NewParameters = @{}
        $NewParameters.Add('DisplayName', $DisplayName)
        $NewParameters.Add('State', $State)
        #create Conditions object
        Write-Verbose 'Set-Targetresource: create Conditions object'
        $conditions = @{
            Applications = @{
            }
            Users        = @{
            }
        }
        #create and provision Application Condition object
        Write-Verbose 'Set-Targetresource: create Application Condition object'
        Write-Verbose 'Set-Targetresource: process IncludeApplications'
        if ($IncludeApplications)
        {
            $includeApps = @()
            foreach ($appName in $IncludeApplications)
            {
                if (Test-MSLogicalAppName -Name $appName) # appNames with special meaning are always added by name.
                {
                    Write-verbose "Set-Targetresource: IncludeApplications: Using Name '$appName' as-is"
                    $includeApps += $appName
                }
                else
                {
                    if ($null -ne ($appName -as [guid])) # is this a GUID ?
                    {
                        # no attempt to verify if SPN exists
                        Write-verbose "Set-Targetresource: IncludeApplications: Using AppId '$appName' as-is"
                        $includeApps += $appName
                    }
                    else
                    {
                        # try to translate app-name to app-id, see https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-cloud-apps
                        $spn = Get-MgServicePrincipal -Filter "DisplayName eq '$appName'" -ErrorAction SilentlyContinue
                        if ($null -ne $spn)
                        {
                            if ($spn.Count -gt 1)
                            {
                                $message = "AADConditionalAccessPolicy $DisplayName, Set-TargetResource, IncludeApplications: App name '$($spn.DisplayName)' is not unique, unable to target app"
                                Add-M365DSCEvent -Message $message `
                                    -Source $($MyInvocation.MyCommand.Source) `
                                    -EntryType Error `
                                    -EventID 3 `
                                    -EventType Error
                                throw $message
                            }
                            else
                            {
                                $includeApps += $spn.AppId
                            }
                        }
                        else
                        {
                            $message = "AADConditionalAccessPolicy $DisplayName, Set-Targetresource: IncludeApplications: Could NOT find App '$appName'"
                            Add-M365DSCEvent -Message $message `
                                -Source $($MyInvocation.MyCommand.Source) `
                                -EntryType Error `
                                -EventID 4 `
                                -EventType Error
                            throw $message
                        }
                    }
                }
            }
            $conditions.Applications.Add('IncludeApplications', $includeApps)
        }
        Write-Verbose 'Set-Targetresource: process ExcludeApplications'
        if ($ExcludeApplications)
        {
            $excludeApps = @()
            foreach ($appName in $ExcludeApplications)
            {
                if (Test-MSLogicalAppName -Name $appName) # appNames with special meaning are always added by name
                {
                    Write-verbose "Set-Targetresource: ExcludeApplications: Using Name '$appName' as-is"
                    $excludeApps += $appName
                }
                else
                {
                    if ($null -ne ($appName -as [guid]))
                    {
                        # no attempt to verify if SPN exists
                        Write-verbose "Set-Targetresource: ExcludeApplications: Using AppId '$appName' as-is"
                        $excludeApps += $appName
                    }
                    else
                    {
                        # try to translate app-name to app-id, see https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-cloud-apps
                        $spn = Get-MgServicePrincipal -Filter "DisplayName eq '$appName'" -ErrorAction SilentlyContinue
                        if ($null -ne $spn)
                        {
                            if ($spn.Count -gt 1)
                            {
                                $message = "AADConditionalAccessPolicy $DisplayName, Set-TargetResource, ExcludeApplications: SPN DisplayName $($spn.DisplayName) is not unique, unable to target app"
                                Add-M365DSCEvent -Message $message `
                                    -Source $($MyInvocation.MyCommand.Source) `
                                    -EntryType Error `
                                    -EventID 3 `
                                    -EventType Error
                                throw $message
                            }
                            else
                            {
                                Write-verbose "Set-Targetresource: ExcludeApplications: Using AppId $($spn.AppId) from SPN '$appName'"
                                $excludeApps += $spn.AppId
                            }
                        }
                        else
                        {
                            $message = "AADConditionalAccessPolicy $DisplayName, Set-Targetresource: ExcludeApplications: Could NOT find App '$appName'"
                            Add-M365DSCEvent -Message $message `
                                -Source $($MyInvocation.MyCommand.Source) `
                                -EntryType Error `
                                -EventID 4 `
                                -EventType Error
                            throw $message
                        }
                    }
                }
            }
            $conditions.Applications.Add('ExcludeApplications', $excludeApps)
        }
        if ($IncludeUserActions)
        {
            $conditions.Applications.Add('IncludeUserActions', $IncludeUserActions)
        }
        if ($AuthenticationContexts)
        {
            # Retrieve the class reference based on display name.
            $AuthenticationContextsValues = @()
            $classReferences = Get-MgBetaIdentityConditionalAccessAuthenticationContextClassReference -ErrorAction SilentlyContinue
            foreach ($authContext in $AuthenticationContexts)
            {
                $currentClassId = $classReferences | Where-Object -FilterScript {$_.DisplayName -eq $authContext}
                if ($null -ne $currentClassId)
                {
                    $AuthenticationContextsValues += $currentClassId.Id
                }
            }
            $conditions.Applications.Add('IncludeAuthenticationContextClassReferences', $AuthenticationContextsValues)
        }

        #create and provision User Condition object
        Write-Verbose 'Set-Targetresource: process includeusers'
        $conditions.Users.Add('IncludeUsers', @())
        foreach ($includeuser in $IncludeUsers)
        {
            #translate user UPNs to GUID, except id value is GuestsOrExternalUsers, None or All
            if ($includeuser)
            {
                if ($includeuser -notin 'GuestsOrExternalUsers', 'All', 'None')
                {
                    $userguid = $null
                    try
                    {
                        $userguid = (Get-MgUser -UserId $includeuser).Id
                    }
                    catch
                    {
                        New-M365DSCLogEntry -Message 'Error updating data:' `
                            -Exception $_ `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $TenantId `
                            -Credential $Credential
                    }
                    if ($null -eq $userguid)
                    {
                        $message = "Couldn't find user $includeuser , couldn't add to policy $DisplayName"
                        New-M365DSCLogEntry -Message $message `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $TenantId `
                            -Credential $Credential
                    }
                    else
                    {
                        $conditions.Users.IncludeUsers += $userguid
                    }
                }
                else
                {
                    $conditions.Users.IncludeUsers += $includeuser
                }
            }
        }
        Write-Verbose 'Set-Targetresource: process excludeusers'

        $conditions.Users.Add('ExcludeUsers', @())
        foreach ($excludeuser in $ExcludeUsers)
        {
            #translate user UPNs to GUID, except id value is GuestsOrExternalUsers, None or All
            if ($excludeuser)
            {
                if ($excludeuser -notin 'GuestsOrExternalUsers', 'All', 'None')
                {
                    $userguid = $null
                    try
                    {
                        $userguid = (Get-MgUser -UserId $excludeuser).Id
                    }
                    catch
                    {
                        New-M365DSCLogEntry -Message 'Error updating data:' `
                            -Exception $_ `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $TenantId `
                            -Credential $Credential
                    }
                    if ($null -eq $userguid)
                    {
                        $message = "Couldn't find user $excludeuser , couldn't add to policy $DisplayName"
                        New-M365DSCLogEntry -Message $message `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $TenantId `
                            -Credential $Credential
                    }
                    else
                    {
                        $conditions.Users.ExcludeUsers += $userguid
                    }
                }
                else
                {
                    $conditions.Users.ExcludeUsers += $excludeuser
                }
            }
        }
        Write-Verbose 'Set-Targetresource: process includegroups'
        $conditions.Users.Add('IncludeGroups', @())
        foreach ($includegroup in $IncludeGroups)
        {
            #translate user Group names to GUID
            if ($includegroup)
            {
                $GroupLookup = $null
                try
                {
                    $GroupLookup = Get-MgGroup -Filter "DisplayName eq '$includegroup'"
                }
                catch
                {
                    New-M365DSCLogEntry -Message 'Error updating data:' `
                        -Exception $_ `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                }
                if ($GroupLookup.Length -gt 1)
                {
                    $message = "Duplicate group found with displayname $includegroup , couldn't add to policy $DisplayName"
                    New-M365DSCLogEntry -Message $message `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                }
                elseif ($null -eq $GroupLookup)
                {
                    $message = "Couldn't find group $includegroup , couldn't add to policy $DisplayName"
                    New-M365DSCLogEntry -Message $message `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                }
                else
                {
                    Write-Verbose 'adding group to includegroups'
                    $conditions.Users.IncludeGroups += $GroupLookup.Id
                }
            }
        }

        $conditions.Users.Add('ExcludeGroups', @())
        Write-Verbose 'Set-Targetresource: process excludegroups'
        foreach ($ExcludeGroup in $ExcludeGroups)
        {
            #translate user Group names to GUID
            if ($ExcludeGroup)
            {
                $GroupLookup = $null
                try
                {
                    $GroupLookup = Get-MgGroup -Filter "DisplayName eq '$ExcludeGroup'"
                }
                catch
                {
                    New-M365DSCLogEntry -Message 'Error updating data:' `
                        -Exception $_ `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                }
                if ($GroupLookup.Length -gt 1)
                {
                    $message = "Duplicate group found with displayname $ExcludeGroup , couldn't add to policy $DisplayName"
                    New-M365DSCLogEntry -Message $message `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                }
                elseif ($null -eq $GroupLookup)
                {
                    $message = "Couldn't find group $ExcludeGroup , couldn't add to policy $DisplayName"
                    New-M365DSCLogEntry -Message $message `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                }
                else
                {
                    Write-Verbose 'adding group to ExcludeGroups'
                    $conditions.Users.ExcludeGroups += $GroupLookup.Id
                }
            }
        }
        Write-Verbose 'Set-Targetresource: process includeroles'
        $conditions.Users.Add('IncludeRoles', @())
        if ($IncludeRoles)
        {
            #translate role names to template guid if defined
            $rolelookup = @{}
            foreach ($role in Get-MgBetaDirectoryRoleTemplate)
            {
                $rolelookup[$role.DisplayName] = $role.Id
            }
            foreach ($IncludeRole in $IncludeRoles)
            {
                if ($IncludeRole)
                {
                    if ($null -eq $rolelookup[$IncludeRole])
                    {
                        $message = "Couldn't find role $IncludeRole , couldn't add to policy $DisplayName"
                        New-M365DSCLogEntry -Message $message `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $TenantId `
                            -Credential $Credential
                    }
                    else
                    {
                        $conditions.Users.IncludeRoles += $rolelookup[$IncludeRole]
                    }
                }
            }
        }
        Write-Verbose 'Set-Targetresource: process excluderoles'
        $conditions.Users.Add('ExcludeRoles', @())
        if ($ExcludeRoles)
        {
            #translate role names to template guid if defined
            $rolelookup = @{}
            foreach ($role in Get-MgBetaDirectoryRoleTemplate)
            {
                $rolelookup[$role.DisplayName] = $role.Id
            }
            foreach ($ExcludeRole in $ExcludeRoles)
            {
                if ($ExcludeRole)
                {
                    if ($null -eq $rolelookup[$ExcludeRole])
                    {
                        $message = "Couldn't find role $ExcludeRole , couldn't add to policy $DisplayName"
                        New-M365DSCLogEntry -Message $message `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $TenantId `
                            -Credential $Credential
                    }
                    else
                    {
                        $conditions.Users.ExcludeRoles += $rolelookup[$ExcludeRole]
                    }

                }
            }
        }
        Write-Verbose 'Set-Targetresource: process includeGuestsOrExternalUsers'
        if ($IncludeGuestOrExternalUserTypes.Count -ne 0)
        {
            $includeGuestsOrExternalUsers = @{}
            [string]$IncludeGuestOrExternalUserTypes = $IncludeGuestOrExternalUserTypes -join ','
            $includeGuestsOrExternalUsers.Add('guestOrExternalUserTypes', $IncludeGuestOrExternalUserTypes)
            $externalTenants = @{}
            if ($IncludeExternalTenantsMembershipKind -eq 'All')
            {
                $externalTenants.Add('@odata.type', '#microsoft.graph.conditionalAccessAllExternalTenants')
            }
            elseif ($IncludeExternalTenantsMembershipKind -eq 'enumerated')
            {
                $externalTenants.Add('@odata.type', '#microsoft.graph.conditionalAccessEnumeratedExternalTenants')
            }
            $externalTenants.Add('membershipKind', $IncludeExternalTenantsMembershipKind)
            if ($IncludeExternalTenantsMembers)
            {
                $externalTenants.Add('members', $IncludeExternalTenantsMembers)
            }
            $includeGuestsOrExternalUsers.Add('externalTenants', $externalTenants)
            $conditions.Users.Add('includeGuestsOrExternalUsers', $includeGuestsOrExternalUsers)
        }
        Write-Verbose 'Set-Targetresource: process excludeGuestsOrExternalUsers'
        if ($ExcludeGuestOrExternalUserTypes.Count -ne 0)
        {
            $excludeGuestsOrExternalUsers = @{}
            [string]$ExcludeGuestOrExternalUserTypes = $ExcludeGuestOrExternalUserTypes -join ','
            $excludeGuestsOrExternalUsers.Add('guestOrExternalUserTypes', $ExcludeGuestOrExternalUserTypes)
            $externalTenants = @{}
            if ($ExcludeExternalTenantsMembershipKind -eq 'All')
            {
                $externalTenants.Add('@odata.type', '#microsoft.graph.conditionalAccessAllExternalTenants')
            }
            elseif ($ExcludeExternalTenantsMembershipKind -eq 'enumerated')
            {
                $externalTenants.Add('@odata.type', '#microsoft.graph.conditionalAccessEnumeratedExternalTenants')
            }
            $externalTenants.Add('membershipKind', $ExcludeExternalTenantsMembershipKind)
            if ($ExcludeExternalTenantsMembers)
            {
                $externalTenants.Add('members', $ExcludeExternalTenantsMembers)
            }
            $excludeGuestsOrExternalUsers.Add('externalTenants', $externalTenants)
            $conditions.Users.Add('excludeGuestsOrExternalUsers', $excludeGuestsOrExternalUsers)
        }
        Write-Verbose 'Set-Targetresource: process platform condition'
        if ($IncludePlatforms -or $ExcludePlatforms)
        {
            #create and provision Platform condition object if used
            if (-not $conditions.Contains('Platforms'))
            {
                $conditions.Add('Platforms', @{
                        ExcludePlatforms = @()
                        IncludePlatforms = @()
                    })
            }
            else
            {
                $conditions.Platforms.Add('ExcludePlatforms', @())
                $conditions.Platforms.Add('IncludePlatforms', @())
            }
            Write-Verbose "Set-Targetresource: IncludePlatforms: $IncludePlatforms"
            if (([Array]$IncludePlatforms).Length -eq 0)
            {
                $conditions.Platforms.IncludePlatforms = @('all')
            }
            else
            {
                $conditions.Platforms.IncludePlatforms = @() + $IncludePlatforms
            }
            #no translation or conversion needed
            Write-Verbose "Set-Targetresource: ExcludePlatforms: $ExcludePlatforms"
            $conditions.Platforms.ExcludePlatforms = @() + $ExcludePlatforms
            #no translation or conversion needed
        }
        else
        {
            Write-Verbose 'Set-Targetresource: setting platform condition to null'
            $conditions.Platforms = $null
        }
        Write-Verbose 'Set-Targetresource: process include and exclude locations'
        if ($IncludeLocations -or $ExcludeLocations)
        {
            $conditions.Add('Locations', @{
                    ExcludeLocations = @()
                    IncludeLocations = @()
                })
            $conditions.Locations.IncludeLocations = @()
            $conditions.Locations.ExcludeLocations = @()
            Write-Verbose 'Set-Targetresource: locations specified'
            #create and provision Location condition object if used, translate Location names to guid
            $LocationLookup = @{}
            foreach ($Location in Get-MgBetaIdentityConditionalAccessNamedLocation)
            {
                $LocationLookup[$Location.DisplayName] = $Location.Id
            }
            foreach ($IncludeLocation in $IncludeLocations)
            {
                if ($IncludeLocation)
                {
                    if ($IncludeLocation -in 'All', 'AllTrusted')
                    {
                        $conditions.Locations.IncludeLocations += $IncludeLocation
                    }
                    elseif ($IncludeLocation -eq 'Multifactor authentication trusted IPs')
                    {
                        $conditions.Locations.IncludeLocations += '00000000-0000-0000-0000-000000000000'
                    }
                    elseif ($null -eq $LocationLookup[$IncludeLocation])
                    {
                        $message = "Couldn't find Location $IncludeLocation , couldn't add to policy $DisplayName"
                        New-M365DSCLogEntry -Message $message `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $TenantId `
                            -Credential $Credential
                    }
                    else
                    {
                        $conditions.Locations.IncludeLocations += $LocationLookup[$IncludeLocation]
                    }
                }
            }
            foreach ($ExcludeLocation in $ExcludeLocations)
            {
                if ($ExcludeLocation)
                {
                    if ($ExcludeLocation -eq 'All' -or $ExcludeLocation -eq 'AllTrusted')
                    {
                        $conditions.Locations.ExcludeLocations += $ExcludeLocation
                    }
                    elseif ($ExcludeLocation -eq 'Multifactor authentication trusted IPs')
                    {
                        $conditions.Locations.ExcludeLocations += '00000000-0000-0000-0000-000000000000'
                    }
                    elseif ($null -eq $LocationLookup[$ExcludeLocation])
                    {
                        $message = "Couldn't find Location $ExcludeLocation , couldn't add to policy $DisplayName"
                        New-M365DSCLogEntry -Message $message `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $TenantId `
                            -Credential $Credential
                    }
                    else
                    {
                        $conditions.Locations.ExcludeLocations += $LocationLookup[$ExcludeLocation]
                    }
                }
            }
        }

        Write-Verbose 'Set-Targetresource: process device filter'
        if ($DeviceFilterMode -and $DeviceFilterRule)
        {
            if (-not $conditions.Contains('Devices'))
            {
                $conditions.Add('Devices', @{})
                $conditions.Devices.Add('DeviceFilter', @{})
                $conditions.Devices.DeviceFilter.Add('Mode', $DeviceFilterMode)
                $conditions.Devices.DeviceFilter.Add('Rule', $DeviceFilterRule)
            }
            else
            {
                if (-not $conditions.Devices.Contains('DeviceFilter'))
                {
                    $conditions.Devices.Add('DeviceFilter', @{})
                    $conditions.Devices.DeviceFilter.Add('Mode', $DeviceFilterMode)
                    $conditions.Devices.DeviceFilter.Add('Rule', $DeviceFilterRule)
                }
                else
                {
                    if (-not $conditions.Devices.DeviceFilter.Contains('Mode'))
                    {
                        $conditions.Devices.DeviceFilter.Add('Mode', $DeviceFilterMode)
                    }
                    else
                    {
                        $conditions.Devices.DeviceFilter.Mode = $DeviceFilterMode
                    }
                    if (-not $conditions.Devices.DeviceFilter.Contains('Rule'))
                    {
                        $conditions.Devices.DeviceFilter.Add('Rule', $DeviceFilterRule)
                    }
                    else
                    {
                        $conditions.Devices.DeviceFilter.Rule = $DeviceFilterRule
                    }
                }
            }
        }

        Write-Verbose 'Set-Targetresource: process risk levels and app types'
        Write-Verbose "Set-Targetresource: UserRiskLevels: $UserRiskLevels"
        $Conditions.Add('UserRiskLevels', $UserRiskLevels)
        #no translation or conversion needed
        Write-Verbose "Set-Targetresource: SignInRiskLevels: $SignInRiskLevels"
        $Conditions.Add('SignInRiskLevels', $SignInRiskLevels)
        #no translation or conversion needed
        Write-Verbose "Set-Targetresource: ClientAppTypes: $ClientAppTypes"
        $Conditions.Add('ClientAppTypes', $ClientAppTypes)
        #no translation or conversion needed
        Write-Verbose 'Set-Targetresource: Adding processed conditions'
        #add all conditions to the parameter list
        $NewParameters.Add('Conditions', $Conditions)
        #create and provision Grant Control object
        Write-Verbose 'Set-Targetresource: create and provision Grant Control object'

        if ($GrantControlOperator -and ($BuiltInControls -or $TermsOfUse -or $CustomAuthenticationFactors -or $AuthenticationStrength))
        {
            $GrantControls = @{
                Operator = $GrantControlOperator
            }

            if ($BuiltInControls)
            {
                $GrantControls.Add('BuiltInControls', $BuiltInControls)
            }
            if ($customAuthenticationFactors)
            {
                $GrantControls.Add('customAuthenticationFactors', $CustomAuthenticationFactors)
            }
            if ($AuthenticationStrength)
            {
                $strengthPolicy = Get-MgBetaPolicyAuthenticationStrengthPolicy | Where-Object -FilterScript {$_.DisplayName -eq $AuthenticationStrength} -ErrorAction SilentlyContinue
                if ($null -ne $strengthPolicy)
                {
                    $authenticationStrengthInstance = @{
                        id            = $strengthPolicy.Id
                        "@odata.type" = "#microsoft.graph.authenticationStrengthPolicy"
                    }
                    $GrantControls.Add('authenticationStrength', $authenticationStrengthInstance)
                }
            }

            if ($TermsOfUse)
            {
                Write-Verbose "Gettign Terms of Use {$TermsOfUse}"
                $TermsOfUseObj = Get-MgBetaAgreement | Where-Object -FilterScript { $_.DisplayName -eq $TermsOfUse }
                $GrantControls.Add('TermsOfUse', $TermsOfUseObj.Id)
            }

            #no translation or conversion needed
            Write-Verbose 'Set-Targetresource: Adding processed grant controls'
            $NewParameters.Add('GrantControls', $GrantControls)
        }

        Write-Verbose 'Set-Targetresource: process session controls'

        $sessioncontrols = $null
        if ($ApplicationEnforcedRestrictionsIsEnabled -or $CloudAppSecurityIsEnabled -or $SignInFrequencyIsEnabled -or $PersistentBrowserIsEnabled)
        {
            Write-Verbose 'Set-Targetresource: create provision Session Control object'
            $sessioncontrols = @{
                ApplicationEnforcedRestrictions = @{
                    IsEnabled = $false
                }
            }

            if ($ApplicationEnforcedRestrictionsIsEnabled)
            {
                #create and provision ApplicationEnforcedRestrictions object if used
                $sessioncontrols.ApplicationEnforcedRestrictions.IsEnabled = $true
            }
            if ($CloudAppSecurityIsEnabled)
            {
                $CloudAppSecurityValue = @{
                    IsEnabled            = $false
                    CloudAppSecurityType = $null
                }

                $sessioncontrols.Add('CloudAppSecurity', $CloudAppSecurityValue)
                #create and provision CloudAppSecurity object if used
                $sessioncontrols.CloudAppSecurity.IsEnabled = $true
                $sessioncontrols.CloudAppSecurity.CloudAppSecurityType = $CloudAppSecurityType
            }
            if ($SignInFrequencyIsEnabled)
            {
                $SigninFrequencyProp = @{
                    isEnabled         = $true
                    type              = $null
                    value             = $null
                    frequencyInterval = $null
                }

                $sessioncontrols.Add('SignInFrequency', $SigninFrequencyProp)
                #create and provision SignInFrequency object if used
                $sessioncontrols.SignInFrequency.isEnabled = $true
                if ($SignInFrequencyType -ne '')
                {
                    $sessioncontrols.SignInFrequency.type = $SignInFrequencyType
                }
                else
                {
                    $sessioncontrols.SignInFrequency.Remove("type") | Out-Null
                }
                if ($SignInFrequencyValue -gt 0)
                {
                    $sessioncontrols.SignInFrequency.value = $SignInFrequencyValue
                }
                else
                {
                    $sessioncontrols.SignInFrequency.Remove("value") | Out-Null
                }
                $sessioncontrols.SignInFrequency.frequencyInterval = $SignInFrequencyInterval
            }
            if ($PersistentBrowserIsEnabled)
            {
                $PersistentBrowserValue = @{
                    IsEnabled = $false
                    Mode      = $false
                }
                $sessioncontrols.Add('PersistentBrowser', $PersistentBrowserValue)
                Write-Verbose "Set-Targetresource: Persistent Browser settings defined: PersistentBrowserIsEnabled:$PersistentBrowserIsEnabled, PersistentBrowserMode:$PersistentBrowserMode"
                #create and provision PersistentBrowser object if used
                $sessioncontrols.PersistentBrowser.IsEnabled = $true
                $sessioncontrols.PersistentBrowser.Mode = $PersistentBrowserMode
            }
        }
        $NewParameters.Add('SessionControls', $sessioncontrols)
        #add SessionControls to the parameter list
    }
    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose "Set-Targetresource: Change policy $DisplayName"
        $NewParameters.Add('ConditionalAccessPolicyId', $currentPolicy.Id)
        try
        {
            Write-Verbose "Updating existing policy with values: $(Convert-M365DscHashtableToString -Hashtable $NewParameters)"
            Update-MgBetaIdentityConditionalAccessPolicy @NewParameters
        }
        catch
        {
            New-M365DSCLogEntry -Message 'Error updating data:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            Write-Verbose "Set-Targetresource: Failed change policy $DisplayName"
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose "Set-Targetresource: create policy $DisplayName"
        Write-Verbose 'Create Parameters:'
        Write-Verbose (Convert-M365DscHashtableToString $NewParameters)
        try
        {
            New-MgBetaIdentityConditionalAccessPolicy @NewParameters
        }
        catch
        {
            New-M365DSCLogEntry -Message 'Error updating data:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            Write-Verbose 'Set-Targetresource: Failed creating policy'
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose "Set-Targetresource: delete policy $DisplayName"
        try
        {
            Remove-MgBetaIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $currentPolicy.ID
        }
        catch
        {
            New-M365DSCLogEntry -Message 'Error updating data:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            Write-Verbose "Set-Targetresource: Failed deleting policy $DisplayName"
        }
    }
    Write-Verbose "Set-Targetresource: finished processing Policy $Displayname"
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        [ValidateSet('disabled', 'enabled', 'enabledForReportingButNotEnforced')]
        $State,

        #ConditionalAccessApplicationCondition
        [Parameter()]
        [System.String[]]
        $IncludeApplications,

        [Parameter()]
        [System.String[]]
        $ExcludeApplications,

        [Parameter()]
        [System.String[]]
        $IncludeUserActions,

        #ConditionalAccessUserCondition
        [Parameter()]
        [System.String[]]
        $IncludeUsers,

        [Parameter()]
        [System.String[]]
        $ExcludeUsers,

        [Parameter()]
        [System.String[]]
        $IncludeGroups,

        [Parameter()]
        [System.String[]]
        $ExcludeGroups,

        [Parameter()]
        [System.String[]]
        $IncludeRoles,

        [Parameter()]
        [System.String[]]
        $ExcludeRoles,

        [Parameter()]
        [System.String[]]
        [validateSet('none', 'internalGuest', 'b2bCollaborationGuest', 'b2bCollaborationMember', 'b2bDirectConnectUser', 'otherExternalUser', 'serviceProvider', 'unknownFutureValue')]
        $IncludeGuestOrExternalUserTypes,

        [Parameter()]
        [System.String]
        [ValidateSet('', 'all', 'enumerated', 'unknownFutureValue')]
        $IncludeExternalTenantsMembershipKind,

        [Parameter()]
        [System.String[]]
        $IncludeExternalTenantsMembers,

        [Parameter()]
        [System.String[]]
        [validateSet('none', 'internalGuest', 'b2bCollaborationGuest', 'b2bCollaborationMember', 'b2bDirectConnectUser', 'otherExternalUser', 'serviceProvider', 'unknownFutureValue')]
        $ExcludeGuestOrExternalUserTypes,

        [Parameter()]
        [System.String]
        [ValidateSet('', 'all', 'enumerated', 'unknownFutureValue')]
        $ExcludeExternalTenantsMembershipKind,

        [Parameter()]
        [System.String[]]
        $ExcludeExternalTenantsMembers,

        #ConditionalAccessPlatformCondition
        [Parameter()]
        [System.String[]]
        $IncludePlatforms,

        [Parameter()]
        [System.String[]]
        $ExcludePlatforms,

        #ConditionalAccessLocationCondition
        [Parameter()]
        [System.String[]]
        $IncludeLocations,

        [Parameter()]
        [System.String[]]
        $ExcludeLocations,

        [Parameter()]
        [ValidateSet('include', 'exclude')]
        [System.String]
        $DeviceFilterMode,

        [Parameter()]
        [System.String]
        $DeviceFilterRule,

        #Further conditions
        [Parameter()]
        [System.String[]]
        $UserRiskLevels,

        [Parameter()]
        [System.String[]]
        $SignInRiskLevels,

        [Parameter()]
        [System.String[]]
        $ClientAppTypes,

        #ConditionalAccessGrantControls
        [Parameter()]
        [ValidateSet('AND', 'OR')]
        [System.String]
        $GrantControlOperator,

        [Parameter()]
        [System.String[]]
        $BuiltInControls,

        #ConditionalAccessSessionControls
        [Parameter()]
        [System.Boolean]
        $ApplicationEnforcedRestrictionsIsEnabled,

        [Parameter()]
        [System.Boolean]
        $CloudAppSecurityIsEnabled,

        [Parameter()]
        [System.String]
        $CloudAppSecurityType,

        [Parameter()]
        [System.Int32]
        $SignInFrequencyValue,

        [Parameter()]
        [ValidateSet('Days', 'Hours', '')]
        [System.String]
        $SignInFrequencyType,

        [Parameter()]
        [System.Boolean]
        $SignInFrequencyIsEnabled,

        [Parameter()]
        [ValidateSet('timeBased', 'everyTime', 'unknownFutureValue')]
        [System.String]
        $SignInFrequencyInterval,

        [Parameter()]
        [ValidateSet('Always', 'Never', '')]
        [System.String]
        $PersistentBrowserMode,

        [Parameter()]
        [System.Boolean]
        $PersistentBrowserIsEnabled,

        [Parameter()]
        [System.String]
        $TermsOfUse,

        [Parameter()]
        [System.String[]]
        $CustomAuthenticationFactors,

        [Parameter()]
        [System.String]
        $AuthenticationStrength,

        [Parameter()]
        [System.String[]]
        $AuthenticationContexts,

        #generic
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

    Write-Verbose 'Testing configuration of AzureAD CA Policies'

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $params = $PSBoundParameters # copy as we may need to update IncludeApplications/ExcludeApplications

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('ManagedIdentity') | Out-Null
    $ValuesToCheck.Remove('Id') | Out-Null

    Write-verbose "Test-TargetResource: process IncludeApplications"
    if ($IncludeApplications)
    {
        # to ensure backwards compatibility, convert app GUIDs to their DisplayName - if it's unique
        $formatApps = @()
        foreach ($app in $IncludeApplications)
        {
            if ($null -ne ($app -as [guid])) # is this a GUID ?
            {
                $spn = Get-MgServicePrincipalByAppId -AppId $app
                if ($spn) {
                    # check for duplicate names
                    $spnUnique = Get-MgServicePrincipal -Filter "DisplayName eq '$($spn.DisplayName)'"
                    if ($spnUnique.Count -gt 1)
                    {
                        write-verbose "Test-TargetResource: IncludeApplications AppId $app used as-is since the app name $($spn.DisplayName) is ambiguous"
                        $formatApps += $app
                    }
                    else
                    {
                        Write-verbose "Test-TargetResource: Translated IncludeApplications AppId $app to unique name $($spn.DisplayName)"
                        $formatApps += $spn.DisplayName
                    }
                }
                else
                {
                    Add-M365DSCEvent -Message "Couldn't find ServicePrincipal with AppId $app used in IncludeApplications for Conditional Access policy $DisplayName" `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -EntryType Warning `
                        -EventType Warning `
                        -EventID 3
                    $formatApps += $app
                }
            }
            else
            {
                if (Test-MSLogicalAppName -Name $app)
                {
                    Write-verbose "Test-TargetResource: IncludeApplications: Logical App Name $app used as-is"
                    $formatApps += $app
                }
                else
                {
                    $spnUnique = Get-MgServicePrincipal -Filter "DisplayName eq '$app'"
                    if ($spnUnique.Count -gt 1)
                    {
                        Add-M365DSCEvent -Message "Test-TargetResource: IncludeApplications App name '$app' used as-is BUT the name is ambiguous" `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -EntryType Warning `
                            -EventType Warning `
                            -EventID 2
                        $formatApps += $app
                    }
                    else
                    {
                        Write-verbose "Test-TargetResource: IncludeApplications App name $app is unique and used as-is"
                        $formatApps += $app
                    }
                }
            }
        }
        $IncludeApplications = $formatApps
        $params.IncludeApplications = $formatApps
    }

    Write-verbose "Test-TargetResource: process ExcludeApplications"
    if ($ExcludeApplications)
    {
        # to ensure backwards compatibility, convert app GUIDs to their DisplayName - if it's unique
        $formatApps = @()
        foreach ($app in $ExcludeApplications)
        {
            if ($null -ne ($app -as [guid])) # is this a GUID ?
            {
                $spn = Get-MgServicePrincipalByAppId -AppId $app
                if ($spn) {
                    # check for duplicate names
                    $spnUnique = Get-MgServicePrincipal -Filter "DisplayName eq '$($spn.DisplayName)'"
                    if ($spnUnique.Count -gt 1)
                    {
                        Write-verbose "Test-TargetResource: ExcludeApplications AppId $app used as-is since the app name ($($spn.DisplayName)) is ambiguous"
                        $formatApps += $app
                    }
                    else
                    {
                        Write-verbose "Test-TargetResource: Translated ExcludeApplications AppId $app to unique SPN $($spn.DisplayName)"
                        $formatApps += $spn.DisplayName
                    }
                }
                else
                {
                    Add-M365DSCEvent -Message "Couldn't find ServicePrincipal with AppId '$app' used in ExcludeApplications for Conditional Access policy $DisplayName" `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -EntryType Warning `
                        -EventType Warning `
                        -EventID 3
                    $formatApps += $app
                }
            }
            else
            {
                if (Test-MSLogicalAppName -Name $app)
                {
                    Write-verbose "Test-TargetResource: ExcludeApplications: Logical App name $app used as-is"
                    $formatApps += $app
                }
                else
                {
                    $spnUnique = Get-MgServicePrincipal -Filter "DisplayName eq '$app'"
                    if ($spnUnique.Count -gt 1)
                    {
                        Add-M365DSCEvent -Message "Test-TargetResource: ExcludeApplications App name '$app' used as-is BUT the name is ambiguous" `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -EntryType Warning `
                            -EventType Warning `
                            -EventID 2
                        $formatApps += $app
                    }
                    else
                    {
                        Write-verbose "Test-TargetResource: ExcludeApplications App name '$app' is unique and used as-is"
                        $formatApps += $app
                    }
                }
            }
        }
        $ExcludeApplications = $formatApps
        $params.ExcludeApplications = $formatApps
    }

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $params `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose "Test-TargetResource returned $TestResult"

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

    try
    {
        [array] $Policies = Get-MgBetaIdentityConditionalAccessPolicy -Filter $Filter -All:$true -ErrorAction Stop
        $i = 1
        $dscContent = ''

        if ($Policies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
            foreach ($Policy in $Policies)
            {
                Write-Host "    |---[$i/$($Policies.Count)] $($Policy.DisplayName)" -NoNewline
                $Params = @{
                    DisplayName           = $Policy.DisplayName
                    Id                    = $Policy.Id
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    ApplicationSecret     = $ApplicationSecret
                    CertificateThumbprint = $CertificateThumbprint
                    Credential            = $Credential
                    Managedidentity       = $ManagedIdentity.IsPresent
                }
                $Results = Get-TargetResource @Params

                if ([System.String]::IsNullOrEmpty($Results.DeviceFilterMode))
                {
                    $Results.Remove('DeviceFilterMode') | Out-Null
                }

                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential

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
        Write-Verbose $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

function Test-MSLogicalAppName
{
    param(
        [parameter(Mandatory)]
        [string]$Name
    )
    if ($Name -in @('All', 'Office365', 'MicrosoftAdminPortals'))
    {
        $true
    }
    else
    {
        $false
    }
}

Export-ModuleMember -Function *-TargetResource
