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
        [ValidateSet('disabled', 'enabled','enabledForReportingButNotEnforced')]
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

        #[Parameter()]
        #[System.String[]]
        #$IncludeProtectionLevels,
        #not exposed yet

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
        $GrantControl_Operator,

        [Parameter()]
        [System.String[]]
        $BuiltInControls,

        #[Parameter()]
        #[System.String[]]
        #$CustomAuthenticationFactors,
        #not exposed yet

        #[Parameter()]
        #[System.String[]]
        #$TermsOfUse,
        #not exposed yet

        #ConditionalAccessSessionControls
        [Parameter()]
        [System.Boolean]
        $ApplicationEnforcedRestrictions_IsEnabled,

        [Parameter()]
        [System.Boolean]
        $CloudAppSecurity_IsEnabled,

        [Parameter()]
        [System.String]
        $CloudAppSecurity_Type,

        [Parameter()]
        [System.Int32]
        $SignInFrequency_Value,

        [Parameter()]
        [ValidateSet('Days', 'Hours')]
        [System.String]
        $SignInFrequency_Type,

        [Parameter()]
        [System.Boolean]
        $SignInFrequency_IsEnabled,

        [Parameter()]
        [ValidateSet('Always', 'Never')]
        [System.String]
        $PersistentBrowser_Mode,

        [Parameter()]
        [System.Boolean]
        $PersistentBrowser_IsEnabled,

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
            $Policy = Get-AzureADMSConditionalAccessPolicy | Where-Object { $_.DisplayName -eq $DisplayName}
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
        $Policy = Get-AzureADMSConditionalAccessPolicy | Where-Object { $_.DisplayName -eq $DisplayName}
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
        Write-Verbose -Message "Found existing Conditional Access policy"

        $result = @{
            DisplayName                   = $Policy.DisplayName
            Id                            = $Policy.Id
            State                         = $Policy.State
            IncludeApplications           = [System.String[]]$Policy.Conditions.Applications.IncludeApplications#no translation of GUIDs
            ExcludeApplications           = [System.String[]]$Policy.Conditions.Applications.ExcludeApplications#no translation of GUIDs
            IncludeUserActions            = [System.String[]]$Policy.Conditions.Applications.IncludeUserActions#no translation needed
            #IncludeProtectionLevels      = [System.String[]]$Policy.Conditions.Applications.IncludeProtectionLevels
            IncludeUsers                  = $Policy.Conditions.Users.IncludeUsers | ForEach-Object { if($_ -notmatch 'GuestsOrExternalUsers|All' -and $_){ (Get-AzureADUser -ObjectId $_).userprincipalname} else {$_}}#translate user GUIDs to UPN, except id value is GuestsOrExternalUsers or All
            ExcludeUsers                  = $Policy.Conditions.Users.ExcludeUsers | ForEach-Object { if($_ -notmatch 'GuestsOrExternalUsers|All' -and $_){ (Get-AzureADUser -ObjectId $_).userprincipalname} else {$_}}#translate user GUIDs to UPN, except id value is GuestsOrExternalUsers or All
            IncludeGroups                 = $policy.Conditions.Users.IncludeGroups | ForEach-Object { if($_){(Get-AzureADGroup -ObjectId $_).displayname}}#convert Group GUIDs to displayname
            ExcludeGroups                 = $Policy.Conditions.Users.ExcludeGroups | ForEach-Object { if($_){(Get-AzureADGroup -ObjectId $_).displayname}}#convert Group GUIDs to displayname
            IncludeRoles                  = if($Policy.Conditions.Users.IncludeRoles)#translate role template guids to role name
            {
            $rolelookup=@{}
            Get-AzureADDirectoryRoleTemplate | ForEach-Object {$rolelookup[$_.ObjectId]=$_.DisplayName}
            $Policy.Conditions.Users.IncludeRoles | ForEach-Object {$rolelookup[$_]}
            }
            else {$null}

            ExcludeRoles                  = if($Policy.Conditions.Users.ExcludeRoles)#translate role template guids to role name
            {
            $rolelookup=@{}
            Get-AzureADDirectoryRoleTemplate | ForEach-Object {$rolelookup[$_.ObjectId]=$_.DisplayName}
            $Policy.Conditions.Users.ExcludeRoles | ForEach-Object {$rolelookup[$_]}
            }
            else {$null}

            IncludePlatforms              = [System.String[]]$Policy.Conditions.Platforms.IncludePlatforms#no translation needed
            ExcludePlatforms              = [System.String[]]$Policy.Conditions.Platforms.ExcludePlatforms#no translation needed
            IncludeLocations              = $Policy.Conditions.Locations.IncludeLocations | ForEach-Object { if($_ -notmatch 'All' -and $_){ (Get-AzureADMSNamedLocationPolicy -PolicyId $_).DisplayName} else {$_}}#translate location GUIDs to Displayname, except if value is All or AllTrusted
            ExcludeLocations              = $Policy.Conditions.Locations.ExcludeLocations | ForEach-Object { if($_ -notmatch 'All' -and $_){ (Get-AzureADMSNamedLocationPolicy -PolicyId $_).DisplayName} else {$_}}#translate location GUIDs to Displayname, except if value is All or AllTrusted
            IncludeDeviceStates           = [System.String[]]$Policy.Conditions.Devices.IncludeDeviceStates#no translation needed
            ExcludeDeviceStates           = [System.String[]]$Policy.Conditions.Devices.ExcludeDeviceStates#no translation needed
            UserRiskLevels                = [System.String[]]$Policy.Conditions.UserRiskLevels#no translation needed
            SignInRiskLevels              = [System.String[]]$Policy.Conditions.SignInRiskLevels#no translation needed
            ClientAppTypes                = [System.String[]]$Policy.Conditions.ClientAppTypes#no translation needed
            GrantControl_Operator         = $Policy.GrantControls._Operator#no translation or conversion needed
            BuiltInControls               = [System.String[]]$Policy.GrantControls.BuiltInControls#no translation needed
            ApplicationEnforcedRestrictions_IsEnabled = $Policy.SessionControls.ApplicationEnforcedRestrictions.IsEnabled#no translation or conversion needed
            CloudAppSecurity_IsEnabled    = $Policy.SessionControls.CloudAppSecurity.IsEnabled#no translation or conversion needed
            CloudAppSecurity_Type         = [System.String]$Policy.SessionControls.CloudAppSecurity.CloudAppSecurityType#no translation needed
            SignInFrequency_Value         = $Policy.SessionControls.SignInFrequency.Value#no translation or conversion needed
            SignInFrequency_Type          = [System.String]$Policy.SessionControls.SignInFrequency.Type#no translation needed
            SignInFrequency_IsEnabled     = $Policy.SessionControls.SignInFrequency.IsEnabled#no translation or conversion needed
            PersistentBrowser_Mode        = [System.String]$Policy.SessionControls.PersistentBrowser.Mode#no translation needed
            PersistentBrowser_IsEnabled   = $Policy.SessionControls.PersistentBrowser.IsEnabled#no translation or conversion needed
#Standard part
            Ensure                        = "Present"
            GlobalAdminAccount            = $GlobalAdminAccount
            ApplicationId                 = $ApplicationId
            TenantId                      = $TenantId
            CertificateThumbprint         = $CertificateThumbprint
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
        [ValidateSet('disabled', 'enabled','enabledForReportingButNotEnforced')]
        [System.String]
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

        #[Parameter()]
        #[System.String[]]
        #$IncludeProtectionLevels,
        #not exposed yet

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
        $GrantControl_Operator,

        [Parameter()]
        [System.String[]]
        $BuiltInControls,

        #[Parameter()]
        #[System.String[]]
        #$CustomAuthenticationFactors,
        #not exposed yet

        #[Parameter()]
        #[System.String[]]
        #$TermsOfUse,
        #not exposed yet

        #ConditionalAccessSessionControls
        [Parameter()]
        [System.Boolean]
        $ApplicationEnforcedRestrictions_IsEnabled,

        [Parameter()]
        [System.Boolean]
        $CloudAppSecurity_IsEnabled,

        [Parameter()]
        [System.String]
        $CloudAppSecurity_Type,

        [Parameter()]
        [System.Int32]
        $SignInFrequency_Value,

        [Parameter()]
        [ValidateSet('Days', 'Hours')]
        [System.String]
        $SignInFrequency_Type,

        [Parameter()]
        [System.Boolean]
        $SignInFrequency_IsEnabled,

        [Parameter()]
        [ValidateSet('Always', 'Never')]
        [System.String]
        $PersistentBrowser_Mode,

        [Parameter()]
        [System.Boolean]
        $PersistentBrowser_IsEnabled,

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

    Write-Verbose -Message "Setting configuration of Conditional Access Policies"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove("ApplicationId")
    $currentParameters.Remove("TenantId")
    $currentParameters.Remove("CertificateThumbprint")
    $currentParameters.Remove("GlobalAdminAccount")
    $currentParameters.Remove("Ensure")

    if ($Ensure -eq 'Present')#create policy attribute objects
    {
        $NewParameters=@{}
        $NewParameters.Add("DisplayName",$DisplayName)
        $NewParameters.Add("State",$State)
        #create Conditions object
        $conditions = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessConditionSet
        #create and provision Application Condition object
        $conditions.Applications = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessApplicationCondition
        $conditions.Applications.IncludeApplications = $IncludeApplications
        $conditions.Applications.ExcludeApplications = $ExcludeApplications
        $conditions.Applications.IncludeUserActions = $IncludeUserActions
        #create and provision User Condition object
        $conditions.Users = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessUserCondition
        $IncludeUsers | foreach-object#translate user UPNs to GUID, except id value is GuestsOrExternalUsers or All
        {
            if($_)
            {
                if($_ -notmatch 'GuestsOrExternalUsers|All')
                {
                    $user=$null
                    $user=(Get-AzureADUser -ObjectId $_).ObjectId
                    if($null -eq $user)
                    {
                        New-M365DSCLogEntry -Error $_ -Message "Couldn't find user $_ , couldn't add to policy $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
                    }
                    elseif (condition)
                    {
                        $conditions.Users.IncludeUsers += $user
                    }
                }
                else
                {
                    $conditions.Users.IncludeUsers += $_
                }
            }
        }
        $ExcludeUsers | foreach-object#translate user UPNs to GUID, except id value is GuestsOrExternalUsers or All
        {
            if($_)
            {
                if($_ -notmatch 'GuestsOrExternalUsers|All')
                {
                    $user=$null
                    $user=(Get-AzureADUser -ObjectId $_).ObjectId
                    if($null -eq $user)
                    {
                        New-M365DSCLogEntry -Error $_ -Message "Couldn't find user $_ , couldn't add to policy $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
                    }
                    elseif (condition)
                    {
                        $conditions.Users.ExcludeUsers += $user
                    }
                }
                else
                {
                    $conditions.Users.ExcludeUsers += $_
                }
            }
        }
        $IncludeGroups | foreach-object#translate user Group names to GUID
        {
            if($_)
            {
                $Group=$null
                $Group = Get-AzureADGroup -Filter "DisplayName eq '$_'"
                if ($Group.Length -gt 1)
                {
                    New-M365DSCLogEntry -Error $_ -Message "Duplicate group found with displayname $_ , couldn't add to policy $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
                }
                elseif($null -eq $Group)
                {
                    New-M365DSCLogEntry -Error $_ -Message "Couldn't find group $_ , couldn't add to policy $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
                }
                else
                {
                    $conditions.Users.IncludeGroups += $Group
                }

            }
        }
        $ExcludeGroups | foreach-object#translate user Group names to GUID
        {
            if($_)
            {
                $Group=$null
                $Group = Get-AzureADGroup -Filter "DisplayName eq '$_'"
                if ($Group.Length -gt 1)
                {
                    New-M365DSCLogEntry -Error $_ -Message "Duplicate group found with displayname $_ , couldn't add to policy $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
                }
                elseif($null -eq $Group)
                {
                    New-M365DSCLogEntry -Error $_ -Message "Couldn't find group $_ , couldn't add to policy $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
                }
                else
                {
                    $conditions.Users.ExcludeGroups += $Group
                }

            }
        }
        if ($IncludeRoles)#translate role names to template guid if defined
        {
            $rolelookup=@{}
            Get-AzureADDirectoryRoleTemplate | ForEach-Object {$rolelookup[$_.DisplayName]=$_.ObjectId}
            $IncludeRoles | foreach-object
            {
                if($_)
                {
                    if($null -eq $rolelookup[$_])
                    {
                        New-M365DSCLogEntry -Error $_ -Message "Couldn't find role $_ , couldn't add to policy $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
                    }
                    else {
                        {
                            $conditions.Users.IncludeRoles += $rolelookup[$_]
                        }
                    }

                }
            }
        }
        if ($ExcludeRoles)#translate role names to template guid if defined
        {
            $rolelookup=@{}
            Get-AzureADDirectoryRoleTemplate | ForEach-Object {$rolelookup[$_.DisplayName]=$_.ObjectId}
            $ExcludeRoles | foreach-object
            {
                if($_)
                {
                    if($null -eq $rolelookup[$_])
                    {
                        New-M365DSCLogEntry -Error $_ -Message "Couldn't find role $_ , couldn't add to policy $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
                    }
                    else {
                        {
                            $conditions.Users.ExcludeRoles += $rolelookup[$_]
                        }
                    }

                }
            }
        }
        if ($IncludePlatforms -or $ExcludePlatforms)#create and provision Platform condition object if used
        {
            $conditions.Platforms = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessPlatformCondition
            $conditions.Platforms.IncludePlatforms=$IncludePlatforms #no translation or conversion needed
            $conditions.Platforms.ExcludePlatforms=$ExcludePlatforms#no translation or conversion needed
        }

        if ($IncludeLocations -or $ExcludeLocations)#create and provision Location condition object if used, translate Location names to guid
        {
            $conditions.Locations = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessLocationCondition
            $LocationLookup=@{}
            Get-AzureADMSNamedLocationPolicy | ForEach-Object {$LocationLookup[$_.DisplayName]=$_.Id}
            $IncludeLocations| foreach-object
            {
                if($_)
                {
                    if($null -eq $LocationLookup[$_])
                    {
                        New-M365DSCLogEntry -Error $_ -Message "Couldn't find Location $_ , couldn't add to policy $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
                    }
                    elseif ($_ -eq "All" -or $_ -eq "AllTrusted") {
                        $conditions.Locations.IncludeLocations += $_
                    }
                    else {
                        {
                            $conditions.Locations.IncludeLocations += $LocationLookup[$_]
                        }
                    }
                }
            $ExcludeLocations| foreach-object
            {
                if($_)
                {
                    if($null -eq $LocationLookup[$_])
                    {
                        New-M365DSCLogEntry -Error $_ -Message "Couldn't find Location $_ , couldn't add to policy $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
                    }
                    elseif ($_ -eq "All" -or $_ -eq "AllTrusted") {
                        $conditions.Locations.ExcludeLocations += $_
                    }
                    else {
                        {
                            $conditions.Locations.ExcludeLocations += $LocationLookup[$_]
                        }
                    }
                }
            }
        }


        if ($IncludeDeviceStates -or $ExcludeDeviceStates)#create and provision Device condition object if used
        {
            $conditions.Devices = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessDevicesCondition
            $conditions.Devices.IncludeDeviceStates=$IncludeDeviceStates#no translation or conversion needed
            $conditions.Devices.ExcludeDeviceStates=$ExcludeDeviceStates#no translation or conversion needed
        }
        $Conditions.UserRiskLevels = $UserRiskLevels#no translation or conversion needed
        $Conditions.SignInRiskLevels = $SignInRiskLevels #no translation or conversion needed
        $Conditions.ClientAppTypes = $ClientAppTypes#no translation or conversion needed

        $NewParameters.Add("Conditions",$Conditions)#add all conditions to the parameter list
        #create and provision Grant Control object
        $GrantControls = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessGrantControls
        $GrantControls._Operator = $GrantControl_Operator
        $GrantControls.BuiltInControls = $BuiltInControls #no translation or conversion needed
        $NewParameters.Add("GrantControls",$GrantControls)#add GrantControls to the parameter list

        if ($ApplicationEnforcedRestrictions_IsEnabled -or $CloudAppSecurity_IsEnabled -or $SignInFrequency_IsEnabled -or $PersistentBrowser_IsEnabled)
        {
            #create and provision Session Control object if used
            $sessioncontrols = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessSessionControls
            if ($ApplicationEnforcedRestrictions_IsEnabled)#create and provision ApplicationEnforcedRestrictions object if used
            {
                $sessioncontrols.ApplicationEnforcedRestrictions = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessApplicationEnforcedRestrictions
                $sessioncontrols.ApplicationEnforcedRestrictions.IsEnabled = $true
            }
            if ($CloudAppSecurity_IsEnabled)#create and provision CloudAppSecurity object if used
            {
                $sessioncontrols.CloudAppSecurity = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessCloudAppSecurity
                $sessioncontrols.CloudAppSecurity.IsEnabled=$true
                $sessioncontrols.CloudAppSecurity.CloudAppSecurityType=$CloudAppSecurity_Type
            }
            if ($SignInFrequency_IsEnabled)#create and provision SignInFrequency object if used
            {
                $sessioncontrols.SignInFrequency = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessSignInFrequency
                $sessioncontrols.SignInFrequency.IsEnabled =$true
                $sessioncontrols.SignInFrequency.Type = $SignInFrequency_Type
                $sessioncontrols.SignInFrequency.Value = $SignInFrequency_Value
            }
            if ($PersistentBrowser_IsEnabled)#create and provision PersistentBrowser object if used
            {
                $sessioncontrols.PersistentBrowser = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessPersistentBrowser
                $sessioncontrols.PersistentBrowser.IsEnabled =$true
                $sessioncontrols.PersistentBrowser.Mode=$PersistentBrowser_Mode
            }
            $NewParameters.Add("SessionControls",$sessioncontrols)#add SessionControls to the parameter list
        }



    }
    }
    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        $NewParameters.Add("PolicyId",$Id)
        try
        {
            Set-AzureADMSConditionalAccessPolicy @NewParameters
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't set policy $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        try
        {
            New-AzureADMSConditionalAccessPolicy @NewParameters
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't create Policy $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        try
        {
            Remove-AzureADMSConditionalAccessPolicy -PolicyId $currentPolicy.ID
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't delete Policy $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
        }
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
        $Id,

        [Parameter()]
        [ValidateSet('disabled', 'enabled','enabledForReportingButNotEnforced')]
        [System.String]
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

        #[Parameter()]
        #[System.String[]]
        #$IncludeProtectionLevels,
        #not exposed yet

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
        $GrantControl_Operator,

        [Parameter()]
        [System.String[]]
        $BuiltInControls,

        #[Parameter()]
        #[System.String[]]
        #$CustomAuthenticationFactors,
        #not exposed yet

        #[Parameter()]
        #[System.String[]]
        #$TermsOfUse,
        #not exposed yet

        #ConditionalAccessSessionControls
        [Parameter()]
        [System.Boolean]
        $ApplicationEnforcedRestrictions_IsEnabled,

        [Parameter()]
        [System.Boolean]
        $CloudAppSecurity_IsEnabled,

        [Parameter()]
        [System.String]
        $CloudAppSecurity_Type,

        [Parameter()]
        [System.Int32]
        $SignInFrequency_Value,

        [Parameter()]
        [ValidateSet('Days', 'Hours')]
        [System.String]
        $SignInFrequency_Type,

        [Parameter()]
        [System.Boolean]
        $SignInFrequency_IsEnabled,

        [Parameter()]
        [ValidateSet('Always', 'Never')]
        [System.String]
        $PersistentBrowser_Mode,

        [Parameter()]
        [System.Boolean]
        $PersistentBrowser_IsEnabled,

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

    Write-Verbose -Message "Testing configuration of AzureAD Groups"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('Id') | Out-Null

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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

    [array] $Policies = Get-AzureADMSConditionalAccessPolicy
    $i = 1
    $dscContent = ''
    Write-Host "`r`n" -NoNewLine
    foreach ($Policy in $Policies)
    {
        Write-Host "    |---[$i/$($Policies.Count)] $($Policy.DisplayName)" -NoNewLine
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

Export-ModuleMember -Function *-TargetResource
