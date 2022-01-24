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
        $Id,

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

        #ConditionalAccessDevicesCondition
        [Parameter()]
        [System.String[]]
        $IncludeDevices,

        [Parameter()]
        [System.String[]]
        $ExcludeDevices,

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
        [ValidateSet('Always', 'Never', '')]
        [System.String]
        $PersistentBrowserMode,

        [Parameter()]
        [System.Boolean]
        $PersistentBrowserIsEnabled,

        [Parameter()]
        [System.String]
        $TermsOfUse,

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration of AzureAD Conditional Access Policy"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

    Select-MgProfile -Name 'beta'

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    if ($PSBoundParameters.ContainsKey("Id"))
    {
        Write-Verbose -Message "PolicyID was specified"
        try
        {
            $Policy = Get-MgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $Id -ErrorAction Stop
        }
        catch
        {
            Write-Verbose -Message "Couldn't find existing policy by ID {$Id}"
            $Policy = Get-MgIdentityConditionalAccessPolicy -Filter "DisplayName eq '$DisplayName'"
            if ($Policy.Length -gt 1)
            {
                throw "Duplicate CA Policies named $DisplayName exist in tenant"
            }
        }
    }
    else
    {
        Write-Verbose -Message "Id was NOT specified"
        ## Can retreive multiple CA Policies since displayname is not unique
        $Policy = Get-MgIdentityConditionalAccessPolicy -Filter "DisplayName eq '$DisplayName'"
        if ($Policy.Length -gt 1)
        {
            throw "Duplicate CA Policies named $DisplayName exist in tenant"
        }
    }

    if ($null -eq $Policy)
    {
        Write-Verbose -Message "No existing Policy with name {$DisplayName} were found"
        $currentValues = $PSBoundParameters
        $currentValues.Ensure = "Absent"
        return $currentValues
    }
    else
    {
        Write-Verbose -Message "Get-TargetResource: Found existing Conditional Access policy"
        $PolicyDisplayName = $Policy.DisplayName

        Write-Verbose -Message "Get-TargetResource: Process IncludeUsers"
        #translate IncludeUser GUIDs to UPN, except id value is GuestsOrExternalUsers, None or All
        $IncludeUsers = @()
        if ($Policy.Conditions.Users.IncludeUsers)
        {
            foreach ($IncludeUserGUID in $Policy.Conditions.Users.IncludeUsers)
            {
                if ($IncludeUserGUID -notin "GuestsOrExternalUsers", "All", "None")
                {
                    $IncludeUser = $null
                    try
                    {
                        $IncludeUser = (Get-MgUser -UserId $IncludeUserGUID).userprincipalname
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
                            elseif ($null -ne $Credential)
                            {
                                $tenantIdValue = $Credential.UserName.Split('@')[1]
                            }
                            Add-M365DSCEvent -Message "Couldn't find user $IncludeUserGUID , that is defined in policy $PolicyDisplayName" -EntryType 'Error' `
                                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                                -TenantId $tenantIdValue
                        }
                        catch
                        {
                            Write-Verbose -Message $_
                        }
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

        Write-Verbose -Message "Get-TargetResource: Process ExcludeUsers"
        #translate ExcludeUser GUIDs to UPN, except id value is GuestsOrExternalUsers, None or All
        $ExcludeUsers = @()
        if ($Policy.Conditions.Users.ExcludeUsers)
        {
            foreach ($ExcludeUserGUID in $Policy.Conditions.Users.ExcludeUsers)
            {
                if ($ExcludeUserGUID -notin "GuestsOrExternalUsers", "All", "None")
                {
                    $ExcludeUser = $null
                    try
                    {
                        $ExcludeUser = (Get-MgUser -UserId $ExcludeUserGUID).userprincipalname
                    }
                    catch
                    {
                        $Message = "Couldn't find user $ExcludeUserGUID , that is defined in policy $PolicyDisplayName"
                        try
                        {
                            Write-Verbose -Message $Message
                            $tenantIdValue = ""
                            if (-not [System.String]::IsNullOrEmpty($TenantId))
                            {
                                $tenantIdValue = $TenantId
                            }
                            elseif ($null -ne $Credential)
                            {
                                $tenantIdValue = $Credential.UserName.Split('@')[1]
                            }
                            Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                                -TenantId $tenantIdValue
                        }
                        catch
                        {
                            Write-Verbose -Message $_
                        }
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

        Write-Verbose -Message "Get-TargetResource: Process IncludeGroups"
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
                    $Message = "Couldn't find Group $IncludeGroupGUID , that is defined in policy $PolicyDisplayName"
                    try
                    {
                        Write-Verbose -Message $Message
                        $tenantIdValue = ""
                        if (-not [System.String]::IsNullOrEmpty($TenantId))
                        {
                            $tenantIdValue = $TenantId
                        }
                        elseif ($null -ne $Credential)
                        {
                            $tenantIdValue = $Credential.UserName.Split('@')[1]
                        }
                        Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $tenantIdValue
                    }
                    catch
                    {
                        Write-Verbose -Message $_
                    }
                }
                if ($IncludeGroup)
                {
                    $IncludeGroups += $IncludeGroup
                }
            }
        }

        Write-Verbose -Message "Get-TargetResource: Process ExcludeGroups"
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
                    $Message = "Couldn't find Group $ExcludeGroupGUID , that is defined in policy $PolicyDisplayName"
                    try
                    {
                        Write-Verbose -Message $Message
                        $tenantIdValue = ""
                        if (-not [System.String]::IsNullOrEmpty($TenantId))
                        {
                            $tenantIdValue = $TenantId
                        }
                        elseif ($null -ne $Credential)
                        {
                            $tenantIdValue = $Credential.UserName.Split('@')[1]
                        }
                        Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $tenantIdValue
                    }
                    catch
                    {
                        Write-Verbose -Message $_
                    }
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
            Write-Verbose -Message "Get-TargetResource: Role condition defined, processing"
            #build role translation table
            $rolelookup = @{}
            foreach ($role in Get-MgDirectoryRoleTemplate)
            {
                $rolelookup[$role.Id] = $role.DisplayName
            }

            Write-Verbose -Message "Get-TargetResource: Processing IncludeRoles"
            if ($Policy.Conditions.Users.IncludeRoles)
            {
                foreach ($IncludeRoleGUID in $Policy.Conditions.Users.IncludeRoles)
                {
                    if ($null -eq $rolelookup[$IncludeRoleGUID])
                    {
                        $Message = "Couldn't find role $IncludeRoleGUID , couldn't add to policy $PolicyDisplayName"
                        try
                        {
                            Write-Verbose -Message $Message
                            $tenantIdValue = ""
                            if (-not [System.String]::IsNullOrEmpty($TenantId))
                            {
                                $tenantIdValue = $TenantId
                            }
                            elseif ($null -ne $Credential)
                            {
                                $tenantIdValue = $Credential.UserName.Split('@')[1]
                            }
                            Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                                -TenantId $tenantIdValue
                        }
                        catch
                        {
                            Write-Verbose -Message $_
                        }
                    }
                    else
                    {
                        $IncludeRoles += $rolelookup[$IncludeRoleGUID]
                    }
                }
            }

            Write-Verbose -Message "Get-TargetResource: Processing ExcludeRoles"
            if ($Policy.Conditions.Users.ExcludeRoles)
            {
                foreach ($ExcludeRoleGUID in $Policy.Conditions.Users.ExcludeRoles)
                {
                    if ($null -eq $rolelookup[$ExcludeRoleGUID])
                    {
                        $Message = "Couldn't find role $ExcludeRoleGUID , couldn't add to policy $PolicyDisplayName"
                        try
                        {
                            Write-Verbose -Message $Message
                            $tenantIdValue = ""
                            if (-not [System.String]::IsNullOrEmpty($TenantId))
                            {
                                $tenantIdValue = $TenantId
                            }
                            elseif ($null -ne $Credential)
                            {
                                $tenantIdValue = $Credential.UserName.Split('@')[1]
                            }
                            Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                                -TenantId $tenantIdValue
                        }
                        catch
                        {
                            Write-Verbose -Message $_
                        }
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
            Write-Verbose -Message "Get-TargetResource: Location condition defined, processing"
            #build Location translation table
            $Locationlookup = @{}
            foreach ($Location in Get-MgIdentityConditionalAccessNamedLocation)
            {
                $Locationlookup[$Location.Id] = $Location.DisplayName
            }

            Write-Verbose -Message "Get-TargetResource: Processing IncludeLocations"
            if ($Policy.Conditions.Locations.IncludeLocations)
            {
                foreach ($IncludeLocationGUID in $Policy.Conditions.Locations.IncludeLocations)
                {
                    if ($IncludeLocationGUID -in "All", "AllTrusted")
                    {
                        $IncludeLocations += $IncludeLocationGUID
                    }
                    elseif ($null -eq $Locationlookup[$IncludeLocationGUID])
                    {
                        $Message = "Couldn't find Location $IncludeLocationGUID , couldn't add to policy $PolicyDisplayName"
                        try
                        {
                            Write-Verbose -Message $Message
                            $tenantIdValue = ""
                            if (-not [System.String]::IsNullOrEmpty($TenantId))
                            {
                                $tenantIdValue = $TenantId
                            }
                            elseif ($null -ne $Credential)
                            {
                                $tenantIdValue = $Credential.UserName.Split('@')[1]
                            }
                            Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                                -TenantId $tenantIdValue
                        }
                        catch
                        {
                            Write-Verbose -Message $_
                        }
                    }
                    else
                    {
                        $IncludeLocations += $Locationlookup[$IncludeLocationGUID]
                    }
                }
            }

            Write-Verbose -Message "Get-TargetResource: Processing ExcludeLocations"
            if ($Policy.Conditions.Locations.ExcludeLocations)
            {
                foreach ($ExcludeLocationGUID in $Policy.Conditions.Locations.ExcludeLocations)
                {
                    if ($ExcludeLocationGUID -in "All", "AllTrusted")
                    {
                        $ExcludeLocations += $ExcludeLocationGUID
                    }
                    elseif ($null -eq $Locationlookup[$ExcludeLocationGUID])
                    {
                        $Message = "Couldn't find Location $ExcludeLocationGUID , couldn't add to policy $PolicyDisplayName"
                        try
                        {
                            Write-Verbose -Message $Message
                            $tenantIdValue = ""
                            if (-not [System.String]::IsNullOrEmpty($TenantId))
                            {
                                $tenantIdValue = $TenantId
                            }
                            elseif ($null -ne $Credential)
                            {
                                $tenantIdValue = $Credential.UserName.Split('@')[1]
                            }
                            Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                                -TenantId $tenantIdValue
                        }
                        catch
                        {
                            Write-Verbose -Message $_
                        }
                    }
                    else
                    {
                        $ExcludeLocations += $Locationlookup[$ExcludeLocationGUID]
                    }
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
        }
        else
        {
            $SignInFrequencyType = $null
        }
        if ($Policy.SessionControls.PersistentBrowser.IsEnabled)
        {
            $PersistentBrowserMode = [System.String]$Policy.SessionControls.PersistentBrowser.Mode
        }
        else
        {
            $PersistentBrowserMode = $null
        }

        $termsOfUseName = $null
        if ($Policy.GrantControls.TermsOfUse)
        {
            $termofUse = Get-MgAgreement | Where-Object -FilterScript {$_.Id -eq $Policy.GrantControls.TermsOfUse}
            if ($termOfUse)
            {
                $termOfUseName = $termOfUse.DisplayName
            }
        }

        $result = @{
            DisplayName                              = $Policy.DisplayName
            Id                                       = $Policy.Id
            State                                    = $Policy.State
            IncludeApplications                      = [System.String[]](@() + $Policy.Conditions.Applications.IncludeApplications)
            #no translation of Application GUIDs, return empty string array if undefined
            ExcludeApplications                      = [System.String[]](@() + $Policy.Conditions.Applications.ExcludeApplications)
            #no translation of GUIDs, return empty string array if undefined
            IncludeUserActions                       = [System.String[]](@() + $Policy.Conditions.Applications.IncludeUserActions)
            #no translation needed, return empty string array if undefined
            IncludeUsers                             = $IncludeUsers
            ExcludeUsers                             = $ExcludeUsers
            IncludeGroups                            = $IncludeGroups
            ExcludeGroups                            = $ExcludeGroups
            IncludeRoles                             = $IncludeRoles
            ExcludeRoles                             = $ExcludeRoles

            IncludePlatforms                         = [System.String[]](@() + $Policy.Conditions.Platforms.IncludePlatforms)
            #no translation needed, return empty string array if undefined
            ExcludePlatforms                         = [System.String[]](@() + $Policy.Conditions.Platforms.ExcludePlatforms)
            #no translation needed, return empty string array if undefined
            IncludeLocations                         = $IncludeLocations
            ExcludeLocations                         = $ExcludeLocations
            IncludeDevices                           = [System.String[]](@() + $Policy.Conditions.Devices.IncludeDevices)
            #no translation needed, return empty string array if undefined
            ExcludeDevices                           = [System.String[]](@() + $Policy.Conditions.Devices.ExcludeDevices)
            #no translation needed, return empty string array if undefined
            UserRiskLevels                           = [System.String[]](@() + $Policy.Conditions.UserRiskLevels)
            #no translation needed, return empty string array if undefined
            SignInRiskLevels                         = [System.String[]](@() + $Policy.Conditions.SignInRiskLevels)
            #no translation needed, return empty string array if undefined
            ClientAppTypes                           = [System.String[]](@() + $Policy.Conditions.ClientAppTypes)
            #no translation needed, return empty string array if undefined
            GrantControlOperator                     = $Policy.GrantControls.Operator
            #no translation or conversion needed
            BuiltInControls                          = [System.String[]](@() + $Policy.GrantControls.BuiltInControls)
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
            #no translation needed
            PersistentBrowserIsEnabled               = $false -or $Policy.SessionControls.PersistentBrowser.IsEnabled
            #make false if undefined, true if true
            PersistentBrowserMode                    = [System.String]$Policy.SessionControls.PersistentBrowser.Mode
            #no translation needed
            #Standard part
            TermsOfUse                                = $termOfUseName
            Ensure                                   = "Present"
            Credential                               = $Credential
            ApplicationSecret                        = $ApplicationSecret
            ApplicationId                            = $ApplicationId
            TenantId                                 = $TenantId
            CertificateThumbprint                    = $CertificateThumbprint
        }
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
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
        $Id,

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

        #ConditionalAccessDevicesCondition
        [Parameter()]
        [System.String[]]
        $IncludeDevices,

        [Parameter()]
        [System.String[]]
        $ExcludeDevices,

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
        [ValidateSet('Always', 'Never', '')]
        [System.String]
        $PersistentBrowserMode,

        [Parameter()]
        [System.Boolean]
        $PersistentBrowserIsEnabled,

        [Parameter()]
        [System.String]
        $TermsOfUse,

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Write-Verbose -Message "Setting configuration of AzureAD Conditional Access Policy"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Set-Targetresource: Running Get-TargetResource"
    $currentPolicy = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Set-Targetresource: Cleaning up parameters"
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove("ApplicationId") | Out-Null
    $currentParameters.Remove("TenantId") | Out-Null
    $currentParameters.Remove("CertificateThumbprint") | Out-Null
    $currentParameters.Remove("ApplicationSecret") | Out-Null
    $currentParameters.Remove("Ensure") | Out-Null
    $currentParameters.Remove("Credential") | Out-Null

    if ($Ensure -eq 'Present')#create policy attribute objects
    {
        Write-Verbose -Message "Set-Targetresource: Policy $Displayname Ensure Present"
        $NewParameters = @{}
        $NewParameters.Add("DisplayName", $DisplayName)
        $NewParameters.Add("State", $State)
        #create Conditions object
        Write-Verbose -Message "Set-Targetresource: create Conditions object"
        $conditions = @{
            Applications = @{
            }
            Users        = @{
            }
        }
        #create and provision Application Condition object
        Write-Verbose -Message "Set-Targetresource: create Application Condition object"
        if ($IncludeApplications)
        {
            $conditions.Applications.Add("IncludeApplications", $IncludeApplications)
        }
        if ($ExcludeApplications)
        {
            $conditions.Applications.Add("ExcludeApplications", $ExcludeApplications)
        }
        if ($IncludeUserActions)
        {
            $conditions.Applications.Add("IncludeUserActions", $IncludeUserActions)
        }

        #create and provision User Condition object
        Write-Verbose -Message "Set-Targetresource: process includeusers"
        if ($IncludeUsers)
        {
            $conditions.Users.Add("IncludeUsers", @())
        }
        foreach ($includeuser in $IncludeUsers)
        {
            #translate user UPNs to GUID, except id value is GuestsOrExternalUsers, None or All
            if ($includeuser)
            {
                if ($includeuser -notin "GuestsOrExternalUsers", "All", "None")
                {
                    $userguid = $null
                    try
                    {
                        $userguid = (Get-MgUser -UserId $includeuser).Id
                    }
                    catch
                    {
                        $Message = $_
                        try
                        {
                            Write-Verbose -Message $Message
                            $tenantIdValue = ""
                            if (-not [System.String]::IsNullOrEmpty($TenantId))
                            {
                                $tenantIdValue = $TenantId
                            }
                            elseif ($null -ne $Credential)
                            {
                                $tenantIdValue = $Credential.UserName.Split('@')[1]
                            }
                            Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                                -TenantId $tenantIdValue
                        }
                        catch
                        {
                            Write-Verbose -Message $_
                        }
                    }
                    if ($null -eq $userguid)
                    {
                        $Message = "Couldn't find user $includeuser , couldn't add to policy $DisplayName"
                        try
                        {
                            Write-Verbose -Message $Message
                            $tenantIdValue = ""
                            if (-not [System.String]::IsNullOrEmpty($TenantId))
                            {
                                $tenantIdValue = $TenantId
                            }
                            elseif ($null -ne $Credential)
                            {
                                $tenantIdValue = $Credential.UserName.Split('@')[1]
                            }
                            Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                                -TenantId $tenantIdValue
                        }
                        catch
                        {
                            Write-Verbose -Message $_
                        }
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
        Write-Verbose -Message "Set-Targetresource: process excludeusers"

        if ($ExcludeUsers.Length -gt 0 -and -not ($ExcludeUsers.Length -eq 1 -and [System.String]::IsNullOrEmpty($ExcludeUsers[0])))
        {
            $conditions.Users.Add("ExcludeUsers", @())
        }
        foreach ($excludeuser in $ExcludeUsers)
        {
            #translate user UPNs to GUID, except id value is GuestsOrExternalUsers, None or All
            if ($excludeuser)
            {
                if ($excludeuser -notin "GuestsOrExternalUsers", "All", "None")
                {
                    $userguid = $null
                    try
                    {
                        $userguid = (Get-MgUser -UserId $excludeuser).Id
                    }
                    catch
                    {
                        $Message = $_
                        try
                        {
                            Write-Verbose -Message $Message
                            $tenantIdValue = ""
                            if (-not [System.String]::IsNullOrEmpty($TenantId))
                            {
                                $tenantIdValue = $TenantId
                            }
                            elseif ($null -ne $Credential)
                            {
                                $tenantIdValue = $Credential.UserName.Split('@')[1]
                            }
                            Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                                -TenantId $tenantIdValue
                        }
                        catch
                        {
                            Write-Verbose -Message $_
                        }
                    }
                    if ($null -eq $userguid)
                    {
                        $Message = "Couldn't find user $excludeuser , couldn't add to policy $DisplayName"
                        try
                        {
                            Write-Verbose -Message $Message
                            $tenantIdValue = ""
                            if (-not [System.String]::IsNullOrEmpty($TenantId))
                            {
                                $tenantIdValue = $TenantId
                            }
                            elseif ($null -ne $Credential)
                            {
                                $tenantIdValue = $Credential.UserName.Split('@')[1]
                            }
                            Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                                -TenantId $tenantIdValue
                        }
                        catch
                        {
                            Write-Verbose -Message $_
                        }
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
        Write-Verbose -Message "Set-Targetresource: process includegroups"
        if ($IncludeGroups.Length -gt 0 -and -not ($IncludeGroups.Length -eq 1 -and [System.String]::IsNullOrEmpty($IncludeGroups[0])))
        {
            $conditions.Users.Add("IncludeGroups", @())
        }
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
                    $Message = $_
                    try
                    {
                        Write-Verbose -Message $Message
                        $tenantIdValue = ""
                        if (-not [System.String]::IsNullOrEmpty($TenantId))
                        {
                            $tenantIdValue = $TenantId
                        }
                        elseif ($null -ne $Credential)
                        {
                            $tenantIdValue = $Credential.UserName.Split('@')[1]
                        }
                        Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $tenantIdValue
                    }
                    catch
                    {
                        Write-Verbose -Message $_
                    }

                    Write-Verbose -Message $_
                }
                if ($GroupLookup.Length -gt 1)
                {
                    $Message = "Duplicate group found with displayname $includegroup , couldn't add to policy $DisplayName"
                    try
                    {
                        Write-Verbose -Message $Message
                        $tenantIdValue = ""
                        if (-not [System.String]::IsNullOrEmpty($TenantId))
                        {
                            $tenantIdValue = $TenantId
                        }
                        elseif ($null -ne $Credential)
                        {
                            $tenantIdValue = $Credential.UserName.Split('@')[1]
                        }
                        Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $tenantIdValue
                    }
                    catch
                    {
                        Write-Verbose -Message $_
                    }
                }
                elseif ($null -eq $GroupLookup)
                {
                    $Message = "Couldn't find group $includegroup , couldn't add to policy $DisplayName"
                    try
                    {
                        Write-Verbose -Message $Message
                        $tenantIdValue = ""
                        if (-not [System.String]::IsNullOrEmpty($TenantId))
                        {
                            $tenantIdValue = $TenantId
                        }
                        elseif ($null -ne $Credential)
                        {
                            $tenantIdValue = $Credential.UserName.Split('@')[1]
                        }
                        Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $tenantIdValue
                    }
                    catch
                    {
                        Write-Verbose -Message $_
                    }

                }
                else
                {
                    Write-Verbose -Message "adding group to includegroups"
                    $conditions.Users.IncludeGroups += $GroupLookup.Id
                }
            }
        }
        if ($ExcludeGroups.Length -gt 0 -and -not ($ExcludeGroups.Length -eq 1 -and [System.String]::IsNullOrEmpty($ExcludeGroups[0])))
        {
            $conditions.Users.Add("ExcludeGroups", @())
        }
        Write-Verbose -Message "Set-Targetresource: process excludegroups"
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
                    $Message = $_
                    try
                    {
                        Write-Verbose -Message $Message
                        $tenantIdValue = ""
                        if (-not [System.String]::IsNullOrEmpty($TenantId))
                        {
                            $tenantIdValue = $TenantId
                        }
                        elseif ($null -ne $Credential)
                        {
                            $tenantIdValue = $Credential.UserName.Split('@')[1]
                        }
                        Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $tenantIdValue
                    }
                    catch
                    {
                        Write-Verbose -Message $_
                    }
                    Write-Verbose -Message $_
                }
                if ($GroupLookup.Length -gt 1)
                {
                    $Message = "Duplicate group found with displayname $ExcludeGroup , couldn't add to policy $DisplayName"
                    try
                    {
                        Write-Verbose -Message $Message
                        $tenantIdValue = ""
                        if (-not [System.String]::IsNullOrEmpty($TenantId))
                        {
                            $tenantIdValue = $TenantId
                        }
                        elseif ($null -ne $Credential)
                        {
                            $tenantIdValue = $Credential.UserName.Split('@')[1]
                        }
                        Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $tenantIdValue
                    }
                    catch
                    {
                        Write-Verbose -Message $_
                    }

                }
                elseif ($null -eq $GroupLookup)
                {
                    $Message = "Couldn't find group $ExcludeGroup , couldn't add to policy $DisplayName"
                    try
                    {
                        Write-Verbose -Message $Message
                        $tenantIdValue = ""
                        if (-not [System.String]::IsNullOrEmpty($TenantId))
                        {
                            $tenantIdValue = $TenantId
                        }
                        elseif ($null -ne $Credential)
                        {
                            $tenantIdValue = $Credential.UserName.Split('@')[1]
                        }
                        Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $tenantIdValue
                    }
                    catch
                    {
                        Write-Verbose -Message $_
                    }

                }
                else
                {
                    Write-Verbose -Message "adding group to ExcludeGroups"
                    $conditions.Users.ExcludeGroups += $GroupLookup.Id
                }
            }
        }
        Write-Verbose -Message "Set-Targetresource: process includeroles"
        if ($IncludeRoles.Length -gt 0 -and -not ($IncludeRoles.Length -eq 1 -and [System.String]::IsNullOrEmpty($IncludeRoles[0])))
        {
            $conditions.Users.Add("IncludeRoles", @())
        }
        if ($IncludeRoles)
        {
            #translate role names to template guid if defined
            $rolelookup = @{}
            foreach ($role in Get-MgDirectoryRoleTemplate)
            { $rolelookup[$role.DisplayName] = $role.ObjectId
            }
            foreach ($IncludeRole in $IncludeRoles)
            {
                if ($IncludeRole)
                {
                    if ($null -eq $rolelookup[$IncludeRole])
                    {
                        $Message = "Couldn't find role $IncludeRole , couldn't add to policy $DisplayName"
                        try
                        {
                            Write-Verbose -Message $Message
                            $tenantIdValue = ""
                            if (-not [System.String]::IsNullOrEmpty($TenantId))
                            {
                                $tenantIdValue = $TenantId
                            }
                            elseif ($null -ne $Credential)
                            {
                                $tenantIdValue = $Credential.UserName.Split('@')[1]
                            }
                            Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                                -TenantId $tenantIdValue
                        }
                        catch
                        {
                            Write-Verbose -Message $_
                        }
                    }
                    else
                    {
                        $conditions.Users.IncludeRoles += $rolelookup[$IncludeRole]
                    }
                }
            }
        }
        Write-Verbose -Message "Set-Targetresource: process excluderoles"
        if ($ExcludeRoles.Length -gt 0 -and -not ($ExcludeRoles.Length -eq 1 -and [System.String]::IsNullOrEmpty($ExcludeRoles[0])))
        {
            $conditions.Users.Add("ExcludeRoles", @())
        }
        if ($ExcludeRoles)
        {
            #translate role names to template guid if defined
            $rolelookup = @{}
            foreach ($role in Get-MgDirectoryRoleTemplate)
            {
                $rolelookup[$role.DisplayName] = $role.Id
            }
            foreach ($ExcludeRole in $ExcludeRoles)
            {
                if ($ExcludeRole)
                {
                    if ($null -eq $rolelookup[$ExcludeRole])
                    {
                        $Message = "Couldn't find role $ExcludeRole , couldn't add to policy $DisplayName"
                        try
                        {
                            Write-Verbose -Message $Message
                            $tenantIdValue = ""
                            if (-not [System.String]::IsNullOrEmpty($TenantId))
                            {
                                $tenantIdValue = $TenantId
                            }
                            elseif ($null -ne $Credential)
                            {
                                $tenantIdValue = $Credential.UserName.Split('@')[1]
                            }
                            Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                                -TenantId $tenantIdValue
                        }
                        catch
                        {
                            Write-Verbose -Message $_
                        }
                    }
                    else
                    {
                        $conditions.Users.ExcludeRoles += $rolelookup[$ExcludeRole]
                    }

                }
            }
        }
        Write-Verbose -Message "Set-Targetresource: process platform condition"
        if ($IncludePlatforms -or $ExcludePlatforms)
        {
            #create and provision Platform condition object if used
            if (-not $conditions.Contains("Platforms"))
            {
                $conditions.Add("Platforms", @{
                        ExcludePlatforms = @()
                        IncludePlatforms = @()
                    })
            }
            else
            {
                $conditions.Platforms.Add("ExcludePlatforms", @())
                $conditions.Platforms.Add("IncludePlatform", @())
            }
            Write-Verbose -Message "Set-Targetresource: IncludePlatforms: $IncludePlatforms"
            $conditions.Platforms.IncludePlatforms = @() + $IncludePlatforms
            #no translation or conversion needed
            Write-Verbose -Message "Set-Targetresource: ExcludePlatforms: $ExcludePlatforms"
            $conditions.Platforms.ExcludePlatforms = @() + $ExcludePlatforms
            #no translation or conversion needed
        }
        else
        {
            Write-Verbose -Message "Set-Targetresource: setting platform condition to null"
            $conditions.Platforms = $null
        }
        Write-Verbose -Message "Set-Targetresource: process include and exclude locations"
        if ($IncludeLocations -or $ExcludeLocations)
        {
            $conditions.Add("Locations", @{
                    ExcludeLocations = @()
                    IncludeLocations = @()
                })
            $conditions.Locations.IncludeLocations = @()
            $conditions.Locations.ExcludeLocations = @()
            Write-Verbose -Message "Set-Targetresource: locations specified"
            #create and provision Location condition object if used, translate Location names to guid
            $LocationLookup = @{}
            foreach ($Location in Get-MgIdentityConditionalAccessNamedLocation)
            {
                $LocationLookup[$Location.DisplayName] = $Location.Id
            }
            foreach ($IncludeLocation in $IncludeLocations)
            {
                if ($IncludeLocation)
                {
                    if ($IncludeLocation -in "All", "AllTrusted")
                    {
                        $conditions.Locations.IncludeLocations += $IncludeLocation
                    }
                    elseif ($null -eq $LocationLookup[$IncludeLocation])
                    {
                        $Message = "Couldn't find Location $IncludeLocation , couldn't add to policy $DisplayName"
                        try
                        {
                            Write-Verbose -Message $Message
                            $tenantIdValue = ""
                            if (-not [System.String]::IsNullOrEmpty($TenantId))
                            {
                                $tenantIdValue = $TenantId
                            }
                            elseif ($null -ne $Credential)
                            {
                                $tenantIdValue = $Credential.UserName.Split('@')[1]
                            }
                            Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                                -TenantId $tenantIdValue
                        }
                        catch
                        {
                            Write-Verbose -Message $_
                        }
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
                    if ($ExcludeLocation -eq "All" -or $ExcludeLocation -eq "AllTrusted")
                    {
                        $conditions.Locations.ExcludeLocations += $ExcludeLocation
                    }
                    elseif ($null -eq $LocationLookup[$ExcludeLocation])
                    {
                        $Message = "Couldn't find Location $ExcludeLocation , couldn't add to policy $DisplayName"
                        try
                        {
                            Write-Verbose -Message $Message
                            $tenantIdValue = ""
                            if (-not [System.String]::IsNullOrEmpty($TenantId))
                            {
                                $tenantIdValue = $TenantId
                            }
                            elseif ($null -ne $Credential)
                            {
                                $tenantIdValue = $Credential.UserName.Split('@')[1]
                            }
                            Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                                -TenantId $tenantIdValue
                        }
                        catch
                        {
                            Write-Verbose -Message $_
                        }
                    }
                    else
                    {
                        $conditions.Locations.ExcludeLocations += $LocationLookup[$ExcludeLocation]
                    }
                }
            }
        }

        Write-Verbose -Message "Set-Targetresource: process device states"
        if ($IncludeDevices -or $ExcludeDevices)
        {
            #create and provision Device condition object if used
            if (-not $conditions.Contains("Devices"))
            {
                $conditions.Add("Devices", @{
                        ExcludeDevices = @()
                        IncludeDevices = @()
                    })
            }
            else
            {
                $conditions.Devices.Add("ExcludeDevices", @())
                $conditions.Devices.Add("IndludeDevices", @())
            }
            $conditions.Devices.IncludeDevices = $IncludeDevices
            #no translation or conversion needed
            $conditions.Devices.ExcludeDevices = $ExcludeDevices
            #no translation or conversion needed
        }
        Write-Verbose -Message "Set-Targetresource: process risk levels and app types"
        Write-Verbose -Message "Set-Targetresource: UserRiskLevels: $UserRiskLevels"
        $Conditions.Add("UserRiskLevels", $UserRiskLevels)
        #no translation or conversion needed
        Write-Verbose -Message "Set-Targetresource: SignInRiskLevels: $SignInRiskLevels"
        $Conditions.Add("SignInRiskLevels", $SignInRiskLevels)
        #no translation or conversion needed
        Write-Verbose -Message "Set-Targetresource: ClientAppTypes: $ClientAppTypes"
        $Conditions.Add("ClientAppTypes", $ClientAppTypes)
        #no translation or conversion needed
        Write-Verbose -Message "Set-Targetresource: Adding processed conditions"
        #add all conditions to the parameter list
        $NewParameters.Add("Conditions", $Conditions)
        #create and provision Grant Control object
        Write-Verbose -Message "Set-Targetresource: create and provision Grant Control object"

        if ($GrantControlOperator -and ($BuiltInControls -or $TermsOfUse))
        {
            $GrantControls = @{
                Operator        = $GrantControlOperator
            }

            if ($BuiltInControls)
            {
                $GrantControls.Add("BuiltInControls", $BuiltInControls)
            }

            if ($TermsOfUse)
            {
                Write-Verbose -Message "Gettign Terms of Use {$TermsOfUse}"
                $TermsOfUseObj = Get-MgAgreement | Where-Object -FilterScript {$_.DisplayName -eq $TermsOfUse}
                $GrantControls.Add('TermsOfUse', $TermsOfUseObj.Id)
            }

            #no translation or conversion needed
            Write-Verbose -Message "Set-Targetresource: Adding processed grant controls"
            $NewParameters.Add("GrantControls", $GrantControls)
        }

        Write-Verbose -Message "Set-Targetresource: process session controls"

        $sessioncontrols = $null
        if ($ApplicationEnforcedRestrictionsIsEnabled -or $CloudAppSecurityIsEnabled -or $SignInFrequencyIsEnabled -or $PersistentBrowserIsEnabled)
        {
            Write-Verbose -Message "Set-Targetresource: create provision Session Control object"
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

                $sessioncontrols.Add("CloudAppSecurity", $CloudAppSecurityValue)
                #create and provision CloudAppSecurity object if used
                $sessioncontrols.CloudAppSecurity.IsEnabled = $true
                $sessioncontrols.CloudAppSecurity.CloudAppSecurityType = $CloudAppSecurityType
            }
            if ($SignInFrequencyIsEnabled)
            {
                $SigninFrequencyProp = @{
                    IsEnabled = $true
                    Type      = $null
                    Value     = $null
                }

                $sessioncontrols.Add("SignInFrequency", $SigninFrequencyProp)
                #create and provision SignInFrequency object if used
                $sessioncontrols.SignInFrequency.IsEnabled = $true
                $sessioncontrols.SignInFrequency.Type = $SignInFrequencyType
                $sessioncontrols.SignInFrequency.Value = $SignInFrequencyValue
            }
            if ($PersistentBrowserIsEnabled)
            {
                $PersistentBrowserValue = @{
                    IsEnabled = $false
                    Mode      = $false
                }
                $sessioncontrols.Add("PersistentBrowser", $PersistentBrowserValue)
                Write-Verbose -Message "Set-Targetresource: Persistent Browser settings defined: PersistentBrowserIsEnabled:$PersistentBrowserIsEnabled, PersistentBrowserMode:$PersistentBrowserMode"
                #create and provision PersistentBrowser object if used
                $sessioncontrols.PersistentBrowser.IsEnabled = $true
                $sessioncontrols.PersistentBrowser.Mode = $PersistentBrowserMode
            }
        }
        $NewParameters.Add("SessionControls", $sessioncontrols)
        #add SessionControls to the parameter list
    }
    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Set-Targetresource: Change policy $DisplayName"
        $NewParameters.Add("ConditionalAccessPolicyId", $currentPolicy.Id)
        try
        {
            Write-Verbose -Message "Updating existing policy with values: $(Convert-M365DscHashtableToString -Hashtable $NewParameters)"
            Update-MgIdentityConditionalAccessPolicy @NewParameters
        }
        catch
        {
            $Message = $_
            try
            {
                Write-Verbose -Message $Message
                $tenantIdValue = ""
                if (-not [System.String]::IsNullOrEmpty($TenantId))
                {
                    $tenantIdValue = $TenantId
                }
                elseif ($null -ne $Credential)
                {
                    $tenantIdValue = $Credential.UserName.Split('@')[1]
                }
                Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                    -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                    -TenantId $tenantIdValue
            }
            catch
            {
                Write-Verbose -Message $_
            }

            Write-Verbose -Message "Set-Targetresource: Failed change policy $DisplayName"
            Write-Verbose -Message $_
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Set-Targetresource: create policy $DisplayName"
        Write-Verbose -Message "Create Parameters:"
        Write-Verbose -Message (Convert-M365DscHashtableToString $NewParameters)
        try
        {
            New-MgIdentityConditionalAccessPolicy @NewParameters
        }
        catch
        {
            $Message = $_
            try
            {
                Write-Verbose -Message $Message
                $tenantIdValue = ""
                if (-not [System.String]::IsNullOrEmpty($TenantId))
                {
                    $tenantIdValue = $TenantId
                }
                elseif ($null -ne $Credential)
                {
                    $tenantIdValue = $Credential.UserName.Split('@')[1]
                }
                Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                    -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                    -TenantId $tenantIdValue
            }
            catch
            {
                Write-Verbose -Message $_
            }

            Write-Verbose -Message "Set-Targetresource: Failed creating policy"
            Write-Verbose -Message $_
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Set-Targetresource: delete policy $DisplayName"
        try
        {
            Remove-MgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $currentPolicy.ID
        }
        catch
        {
            $Message = $_
            try
            {
                Write-Verbose -Message $Message
                $tenantIdValue = ""
                if (-not [System.String]::IsNullOrEmpty($TenantId))
                {
                    $tenantIdValue = $TenantId
                }
                elseif ($null -ne $Credential)
                {
                    $tenantIdValue = $Credential.UserName.Split('@')[1]
                }
                Add-M365DSCEvent -Message $Message -EntryType 'Error' `
                    -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                    -TenantId $tenantIdValue
            }
            catch
            {
                Write-Verbose -Message $_
            }

            Write-Verbose -Message "Set-Targetresource: Failed deleting policy $DisplayName"
            Write-Verbose -Message $_
        }
    }
    Write-Verbose -Message "Set-Targetresource: finished processing Policy $Displayname"
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
        $Id,

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

        #ConditionalAccessDevicesCondition
        [Parameter()]
        [System.String[]]
        $IncludeDevices,

        [Parameter()]
        [System.String[]]
        $ExcludeDevices,

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
        [ValidateSet('Always', 'Never', '')]
        [System.String]
        $PersistentBrowserMode,

        [Parameter()]
        [System.Boolean]
        $PersistentBrowserIsEnabled,

        [Parameter()]
        [System.String]
        $TermsOfUse,

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Testing configuration of AzureAD CA Policies"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('Id') | Out-Null

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
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

    Select-MgProfile -Name 'beta'

    try
    {
        [array] $Policies = Get-MgIdentityConditionalAccessPolicy
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
                }
                $Results = Get-TargetResource @Params

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
        Write-Host $Global:M365DSCEmojiRedX
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
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
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
