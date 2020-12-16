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
        $IncludeDeviceStates,

        [Parameter()]
        [System.String[]]
        $ExcludeDeviceStates,

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

        #generic
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

    Write-Verbose -Message "Getting configuration of AzureAD Conditional Access Policy"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' -InboundParameters $PSBoundParameters

    if ($PSBoundParameters.ContainsKey("Id"))
    {
        Write-Verbose -Message "PolicyID was specified"
        try
        {
            $Policy = Get-AzureADMSConditionalAccessPolicy -PolicyId $Id
        }
        catch
        {
            $Policy = Get-AzureADMSConditionalAccessPolicy | Where-Object { $_.DisplayName -eq $DisplayName }
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
        $Policy = Get-AzureADMSConditionalAccessPolicy | Where-Object { $_.DisplayName -eq $DisplayName }
        if ($Policy.Length -gt 1)
        {
            throw "Duplicate CA Policies named $DisplayName exist in tenant"
        }
    }

    if ($null -eq $Policy)
    {
        $currentValues = $PSBoundParameters
        $currentValues.Ensure = "Absent"
        return $currentValues
    }
    else
    {
        Write-Verbose -Message "Get-TargetResource: Found existing Conditional Access policy"
        $PolicyDisplayName = $Policy.DisplayName

        Write-Verbose -Message "Get-TargetResource: Process IncludeUsers"
        #translate IncludeUser GUIDs to UPN, except id value is GuestsOrExternalUsers or All
        $IncludeUsers = $null
        if ($Policy.Conditions.Users.IncludeUsers)
        {
            $IncludeUsers = @()
            foreach ($IncludeUserGUID in $Policy.Conditions.Users.IncludeUsers)
            {
                if ($IncludeUserGUID -notin "GuestsOrExternalUsers", "All")
                {
                    $IncludeUser = $null
                    try
                    {
                        $IncludeUser = (Get-AzureADUser -ObjectId $IncludeUserGUID).userprincipalname
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
        #translate ExcludeUser GUIDs to UPN, except id value is GuestsOrExternalUsers or All
        $ExcludeUsers = $null
        if ($Policy.Conditions.Users.ExcludeUsers)
        {
            $ExcludeUsers = @()
            foreach ($ExcludeUserGUID in $Policy.Conditions.Users.ExcludeUsers)
            {
                if ($ExcludeUserGUID -notin "GuestsOrExternalUsers", "All")
                {
                    $ExcludeUser = $null
                    try
                    {
                        $ExcludeUser = (Get-AzureADUser -ObjectId $ExcludeUserGUID).userprincipalname
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
                            elseif ($null -ne $GlobalAdminAccount)
                            {
                                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
        $IncludeGroups = $null
        if ($Policy.Conditions.Users.IncludeGroups)
        {
            $IncludeGroups = @()
            foreach ($IncludeGroupGUID in $Policy.Conditions.Users.IncludeGroups)
            {
                $IncludeGroup = $null
                try
                {
                    $IncludeGroup = (Get-AzureADGroup -ObjectId $IncludeGroupGUID).displayname
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
                        elseif ($null -ne $GlobalAdminAccount)
                        {
                            $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
        $ExcludeGroups = $null
        if ($Policy.Conditions.Users.ExcludeGroups)
        {
            $ExcludeGroups = @()
            foreach ($ExcludeGroupGUID in $Policy.Conditions.Users.ExcludeGroups)
            {
                $ExcludeGroup = $null
                try
                {
                    $ExcludeGroup = (Get-AzureADGroup -ObjectId $ExcludeGroupGUID).displayname
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
                        elseif ($null -ne $GlobalAdminAccount)
                        {
                            $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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


        $IncludeRoles = $null
        $ExcludeRoles = $null
        #translate role template guids to role name
        if ($Policy.Conditions.Users.IncludeRoles -or $Policy.Conditions.Users.ExcludeRoles)
        {
            Write-Verbose -Message "Get-TargetResource: Role condition defined, processing"
            #build role translation table
            $rolelookup = @{}
            foreach ($role in Get-AzureADDirectoryRoleTemplate)
            {
                $rolelookup[$role.ObjectId] = $role.DisplayName
            }

            Write-Verbose -Message "Get-TargetResource: Processing IncludeRoles"
            if ($Policy.Conditions.Users.IncludeRoles)
            {
                $IncludeRoles = @()
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
                            elseif ($null -ne $GlobalAdminAccount)
                            {
                                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
                $ExcludeRoles = @()
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
                            elseif ($null -ne $GlobalAdminAccount)
                            {
                                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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

        $IncludeLocations = $null
        $ExcludeLocations = $null
        #translate Location template guids to Location name
        if ($Policy.Conditions.Locations.IncludeLocations -or $Policy.Conditions.Locations.ExcludeLocations)
        {
            Write-Verbose -Message "Get-TargetResource: Location condition defined, processing"
            #build Location translation table
            $Locationlookup = @{}
            foreach ($Location in Get-AzureADMSNamedLocationPolicy)
            {
                $Locationlookup[$Location.Id] = $Location.DisplayName
            }

            Write-Verbose -Message "Get-TargetResource: Processing IncludeLocations"
            if ($Policy.Conditions.Locations.IncludeLocations)
            {
                $IncludeLocations = @()
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
                            elseif ($null -ne $GlobalAdminAccount)
                            {
                                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
                $ExcludeLocations = @()
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
                            elseif ($null -ne $GlobalAdminAccount)
                            {
                                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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

        $result = @{
            DisplayName                              = $Policy.DisplayName
            Id                                       = $Policy.Id
            State                                    = $Policy.State
            IncludeApplications                      = [System.String[]]$Policy.Conditions.Applications.IncludeApplications
            #no translation of Application GUIDs
            ExcludeApplications                      = [System.String[]]$Policy.Conditions.Applications.ExcludeApplications
            #no translation of GUIDs
            IncludeUserActions                       = [System.String[]]$Policy.Conditions.Applications.IncludeUserActions
            #no translation needed
            IncludeUsers                             = $IncludeUsers
            ExcludeUsers                             = $ExcludeUsers
            IncludeGroups                            = $IncludeGroups
            ExcludeGroups                            = $ExcludeGroups
            IncludeRoles                             = $IncludeRoles
            ExcludeRoles                             = $ExcludeRoles

            IncludePlatforms                         = [System.String[]]$Policy.Conditions.Platforms.IncludePlatforms
            #no translation needed
            ExcludePlatforms                         = [System.String[]]$Policy.Conditions.Platforms.ExcludePlatforms
            #no translation needed
            IncludeLocations                         = $IncludeLocations
            ExcludeLocations                         = $ExcludeLocations
            IncludeDeviceStates                      = [System.String[]]$Policy.Conditions.Devices.IncludeDeviceStates
            #no translation needed
            ExcludeDeviceStates                      = [System.String[]]$Policy.Conditions.Devices.ExcludeDeviceStates
            #no translation needed
            UserRiskLevels                           = [System.String[]]$Policy.Conditions.UserRiskLevels
            #no translation needed
            SignInRiskLevels                         = [System.String[]]$Policy.Conditions.SignInRiskLevels
            #no translation needed
            ClientAppTypes                           = [System.String[]]$Policy.Conditions.ClientAppTypes
            #no translation needed
            GrantControlOperator                     = $Policy.GrantControls._Operator
            #no translation or conversion needed
            BuiltInControls                          = [System.String[]]$Policy.GrantControls.BuiltInControls
            #no translation needed
            ApplicationEnforcedRestrictionsIsEnabled = $Policy.SessionControls.ApplicationEnforcedRestrictions.IsEnabled
            #no translation or conversion needed
            CloudAppSecurityIsEnabled                = $Policy.SessionControls.CloudAppSecurity.IsEnabled
            #no translation or conversion needed
            CloudAppSecurityType                     = [System.String]$Policy.SessionControls.CloudAppSecurity.CloudAppSecurityType
            #no translation needed
            SignInFrequencyValue                     = $Policy.SessionControls.SignInFrequency.Value
            #no translation or conversion needed
            SignInFrequencyType                      = [System.String]$Policy.SessionControls.SignInFrequency.Type
            #no translation needed
            SignInFrequencyIsEnabled                 = $Policy.SessionControls.SignInFrequency.IsEnabled
            #no translation or conversion needed
            PersistentBrowserMode                    = [System.String]$Policy.SessionControls.PersistentBrowser.Mode
            #no translation needed
            PersistentBrowserIsEnabled               = $Policy.SessionControls.PersistentBrowser.IsEnabled
            #no translation or conversion needed
            #Standard part
            Ensure                                   = "Present"
            GlobalAdminAccount                       = $GlobalAdminAccount
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
        $IncludeDeviceStates,

        [Parameter()]
        [System.String[]]
        $ExcludeDeviceStates,

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

        #generic
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

    Write-Verbose -Message "Set-Targetresource: Start processing"
    Write-Verbose -Message "Set-Targetresource: Starting telemetry"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Write-Verbose -Message "Set-Targetresource: Finished telemetry"
    Write-Verbose -Message "Set-Targetresource: Running Get-TargetResource"
    $currentPolicy = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Set-Targetresource: Cleaning up parameters"
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove("ApplicationId") | Out-Null
    $currentParameters.Remove("TenantId") | Out-Null
    $currentParameters.Remove("CertificateThumbprint") | Out-Null
    $currentParameters.Remove("GlobalAdminAccount") | Out-Null
    $currentParameters.Remove("Ensure") | Out-Null

    if ($Ensure -eq 'Present')#create policy attribute objects
    {
        Write-Verbose -Message "Set-Targetresource: Policy $Displayname Ensure Present"
        $NewParameters = @{}
        $NewParameters.Add("DisplayName", $DisplayName)
        $NewParameters.Add("State", $State)
        #create Conditions object
        Write-Verbose -Message "Set-Targetresource: create Conditions object"
        $conditions = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessConditionSet
        #create and provision Application Condition object
        Write-Verbose -Message "Set-Targetresource: create Application Condition object"
        $conditions.Applications = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessApplicationCondition
        $conditions.Applications.IncludeApplications = $IncludeApplications
        $conditions.Applications.ExcludeApplications = $ExcludeApplications
        $conditions.Applications.IncludeUserActions = $IncludeUserActions
        #create and provision User Condition object
        Write-Verbose -Message "Set-Targetresource: create and provision User Condition object"
        $conditions.Users = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessUserCondition
        Write-Verbose -Message "Set-Targetresource: process includeusers"
        foreach ($includeuser in $IncludeUsers)
        {
            #translate user UPNs to GUID, except id value is GuestsOrExternalUsers or All
            if ($includeuser)
            {
                if ($includeuser -notin "GuestsOrExternalUsers", "All")
                {
                    $userguid = $null
                    try
                    { $userguid = (Get-AzureADUser -ObjectId $includeuser).ObjectId
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
                            elseif ($null -ne $GlobalAdminAccount)
                            {
                                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
                            elseif ($null -ne $GlobalAdminAccount)
                            {
                                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
        foreach ($excludeuser in $ExcludeUsers)
        {
            #translate user UPNs to GUID, except id value is GuestsOrExternalUsers or All
            if ($excludeuser)
            {
                if ($excludeuser -notin "GuestsOrExternalUsers", "All")
                {
                    $userguid = $null
                    try
                    { $userguid = (Get-AzureADUser -ObjectId $excludeuser).ObjectId
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
                            elseif ($null -ne $GlobalAdminAccount)
                            {
                                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
                            elseif ($null -ne $GlobalAdminAccount)
                            {
                                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
        foreach ($includegroup in $IncludeGroups)
        {
            #translate user Group names to GUID
            if ($includegroup)
            {
                $GroupLookup = $null
                try
                { $GroupLookup = Get-AzureADGroup -Filter "DisplayName eq '$includegroup'"
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
                        elseif ($null -ne $GlobalAdminAccount)
                        {
                            $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
                        elseif ($null -ne $GlobalAdminAccount)
                        {
                            $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
                        elseif ($null -ne $GlobalAdminAccount)
                        {
                            $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
                    $conditions.Users.IncludeGroups += $GroupLookup.ObjectId
                }
            }
        }
        Write-Verbose -Message "Set-Targetresource: process excludegroups"
        foreach ($ExcludeGroup in $ExcludeGroups)
        {
            #translate user Group names to GUID
            if ($ExcludeGroup)
            {
                $GroupLookup = $null
                try
                { $GroupLookup = Get-AzureADGroup -Filter "DisplayName eq '$ExcludeGroup'"
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
                        elseif ($null -ne $GlobalAdminAccount)
                        {
                            $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
                        elseif ($null -ne $GlobalAdminAccount)
                        {
                            $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
                        elseif ($null -ne $GlobalAdminAccount)
                        {
                            $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
                    $conditions.Users.ExcludeGroups += $GroupLookup.ObjectId
                }
            }
        }
        Write-Verbose -Message "Set-Targetresource: process includeroles"
        if ($IncludeRoles)
        {
            #translate role names to template guid if defined
            $rolelookup = @{}
            foreach ($role in Get-AzureADDirectoryRoleTemplate)
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
                            elseif ($null -ne $GlobalAdminAccount)
                            {
                                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
        if ($ExcludeRoles)
        {
            #translate role names to template guid if defined
            $rolelookup = @{}
            foreach ($role in Get-AzureADDirectoryRoleTemplate)
            { $rolelookup[$role.DisplayName] = $role.ObjectId
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
                            elseif ($null -ne $GlobalAdminAccount)
                            {
                                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
        Write-Verbose -Message "Set-Targetresource: process includeplatforms"
        if ($IncludePlatforms -or $ExcludePlatforms)
        {
            #create and provision Platform condition object if used
            $conditions.Platforms = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessPlatformCondition
            $conditions.Platforms.IncludePlatforms = $IncludePlatforms
            #no translation or conversion needed
            $conditions.Platforms.ExcludePlatforms = $ExcludePlatforms
            #no translation or conversion needed
        }
        Write-Verbose -Message "Set-Targetresource: process include and exclude locations"
        if ($IncludeLocations -or $ExcludeLocations)
        {
            Write-Verbose -Message "Set-Targetresource: locations specified"
            #create and provision Location condition object if used, translate Location names to guid
            $conditions.Locations = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessLocationCondition
            $LocationLookup = @{}
            foreach ($Location in Get-AzureADMSNamedLocationPolicy)
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
                            elseif ($null -ne $GlobalAdminAccount)
                            {
                                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
                            elseif ($null -ne $GlobalAdminAccount)
                            {
                                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
        if ($IncludeDeviceStates -or $ExcludeDeviceStates)
        {
            #create and provision Device condition object if used
            $conditions.Devices = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessDevicesCondition
            $conditions.Devices.IncludeDeviceStates = $IncludeDeviceStates
            #no translation or conversion needed
            $conditions.Devices.ExcludeDeviceStates = $ExcludeDeviceStates
            #no translation or conversion needed
        }
        Write-Verbose -Message "Set-Targetresource: process risk levels and app types"
        $Conditions.UserRiskLevels = $UserRiskLevels
        #no translation or conversion needed
        $Conditions.SignInRiskLevels = $SignInRiskLevels
        #no translation or conversion needed
        $Conditions.ClientAppTypes = $ClientAppTypes
        #no translation or conversion needed
        Write-Verbose -Message "Set-Targetresource: Adding processed conditions"
        #add all conditions to the parameter list
        $NewParameters.Add("Conditions", $Conditions)
        #create and provision Grant Control object
        Write-Verbose -Message "Set-Targetresource: create and provision Grant Control object"
        $GrantControls = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessGrantControls
        $GrantControls._Operator = $GrantControlOperator
        $GrantControls.BuiltInControls = $BuiltInControls
        #no translation or conversion needed
        Write-Verbose -Message "Set-Targetresource: Adding processed grant controls"
        $NewParameters.Add("GrantControls", $GrantControls)
        #add GrantControls to the parameter list
        Write-Verbose -Message "Set-Targetresource: process session controls"
        if ($ApplicationEnforcedRestrictionsIsEnabled -or $CloudAppSecurityIsEnabled -or $SignInFrequencyIsEnabled -or $PersistentBrowserIsEnabled)
        {
            #create and provision Session Control object if used
            Write-Verbose -Message "Set-Targetresource: Create and provision Session Control object"
            $sessioncontrols = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessSessionControls
            if ($ApplicationEnforcedRestrictionsIsEnabled)
            {
                #create and provision ApplicationEnforcedRestrictions object if used
                $sessioncontrols.ApplicationEnforcedRestrictions = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessApplicationEnforcedRestrictions
                $sessioncontrols.ApplicationEnforcedRestrictions.IsEnabled = $true
            }
            if ($CloudAppSecurityIsEnabled)
            {
                #create and provision CloudAppSecurity object if used
                $sessioncontrols.CloudAppSecurity = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessCloudAppSecurity
                $sessioncontrols.CloudAppSecurity.IsEnabled = $true
                $sessioncontrols.CloudAppSecurity.CloudAppSecurityType = $CloudAppSecurityType
            }
            if ($SignInFrequencyIsEnabled)
            {
                #create and provision SignInFrequency object if used
                $sessioncontrols.SignInFrequency = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessSignInFrequency
                $sessioncontrols.SignInFrequency.IsEnabled = $true
                $sessioncontrols.SignInFrequency.Type = $SignInFrequencyType
                $sessioncontrols.SignInFrequency.Value = $SignInFrequencyValue
            }
            if ($PersistentBrowserIsEnabled)
            {
                #create and provision PersistentBrowser object if used
                $sessioncontrols.PersistentBrowser = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessPersistentBrowser
                $sessioncontrols.PersistentBrowser.IsEnabled = $true
                $sessioncontrols.PersistentBrowser.Mode = $PersistentBrowserMode
            }
            $NewParameters.Add("SessionControls", $sessioncontrols)
            #add SessionControls to the parameter list
        }

    }
    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Set-Targetresource: Change policy $DisplayName"
        $NewParameters.Add("PolicyId", $currentPolicy.Id)
        try
        {
            Set-AzureADMSConditionalAccessPolicy @NewParameters
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
                elseif ($null -ne $GlobalAdminAccount)
                {
                    $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
        try
        {
            New-AzureADMSConditionalAccessPolicy @NewParameters
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
                elseif ($null -ne $GlobalAdminAccount)
                {
                    $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
            Remove-AzureADMSConditionalAccessPolicy -PolicyId $currentPolicy.ID
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
                elseif ($null -ne $GlobalAdminAccount)
                {
                    $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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
        $IncludeDeviceStates,

        [Parameter()]
        [System.String[]]
        $ExcludeDeviceStates,

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

        #generic
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

    Write-Verbose -Message "Testing configuration of AzureAD CA Policies"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
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

    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' -InboundParameters $PSBoundParameters
    try
    {
        [array] $Policies = Get-AzureADMSConditionalAccessPolicy
        $i = 1
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($Policy in $Policies)
        {
            Write-Host "    |---[$i/$($Policies.Count)] $($Policy.DisplayName)" -NoNewline
            $Params = @{
                GlobalAdminAccount    = $GlobalAdminAccount
                DisplayName           = $Policy.DisplayName
                Id                    = $Policy.Id
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
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

Export-ModuleMember -Function *-TargetResource
