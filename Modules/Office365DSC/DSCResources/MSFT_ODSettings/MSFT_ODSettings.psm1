function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter()]
        [System.UInt32]
        $OneDriveStorageQuota,

        [Parameter()]
        [System.UInt32]
        $OrphanedPersonalSitesRetentionPeriod,

        [Parameter()]
        [System.Boolean]
        $OneDriveForGuestsEnabled,

        [Parameter()]
        [System.Boolean]
        $NotifyOwnersWhenInvitationsAccepted,

        [Parameter()]
        [System.Boolean]
        $NotificationsInOneDriveForBusinessEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet("On","Off","Unspecified")] 
        $ODBMembersCanShare,

        [Parameter()]
        [System.String]
        [ValidateSet("On","Off","Unspecified")] 
        $ODBAccessRequests,

        [Parameter()]
        [System.Boolean]
        $BlockMacSync,

        [Parameter()]
        [System.Boolean]
        $DisableReportProblemDialog,

        [Parameter()]
        [System.String]
        $DomainGuids,
        
        [Parameter()]
        [System.String[]]
        $ExcludedFileExtensions,

        [Parameter()]
        [System.String]
        [ValidateSet("OptOut","HardOptIn","SoftOptIn")] 
        $GrooveBlockOption,

        [Parameter()] 
        [ValidateSet("Present","Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    
    $nullReturn = @{
        BlockMacSync                              = $null
        DisableReportProblemDialog                = $null
        DomainGuids                               = $null
        Enabled                                   = $null
        ExcludedFileExtensions                    = $null
        GrooveBlockOption                         = $null
        OneDriveStorageQuota                      = $null
        OrphanedPersonalSitesRetentionPeriod      = $null
        OneDriveForGuestsEnabled                  = $null 
        ODBAccessRequests                         = $null
        ODBMembersCanShare                        = $null
        NotifyOwnersWhenInvitationsAccepted       = $null
        NotificationsInOneDriveForBusinessEnabled = $null
        Ensure                                    = "Absent"
    }

    try
    {
        Write-Verbose -Message "Getting OneDrive quoata size for tenant"
        $tenant = Get-SPOTenant

        if (!$tenant)
        {
            Write-Verbose "Failed to get Tenant information"
            return $nullReturn
        }

        Write-Verbose -Message "Getting OneDrive quoata size for tenant $($tenant.OneDriveStorageQuota)"
        Write-Verbose -Message "Getting tenant client sync setting"
        $tenantRestrictions = Get-SPOTenantSyncClientRestriction
         
        if (!$tenantRestrictions)
        {
            Write-Verbose "Failed to get Tenant client synce settings!"
            return $nullReturn
        }

        $GrooveOption = $null 

        if (($tenantRestrictions.OptOutOfGrooveBlock -eq $false) -and ($tenantRestrictions.OptOutOfGrooveSoftBlock -eq $false))
        {
            $GrooveOption = "SoftOptIn"
        }

        if (($tenantRestrictions.OptOutOfGrooveBlock -eq $false) -and ($tenantRestrictions.OptOutOfGrooveSoftBlock -eq $true))
        {
            $GrooveOption = "HardOptIn"
        }

        if (($tenantRestrictions.OptOutOfGrooveBlock -eq $true) -and ($tenantRestrictions.OptOutOfGrooveSoftBlock -eq $true))
        {
            $GrooveOption = "OptOut"
        }
        
        Write-Verbose "Groove block values $($GrooveOption)"
        return @{
            BlockMacSync                              = $tenantRestrictions.BlockMacSync
            DisableReportProblemDialog                = $tenantRestrictions.DisableReportProblemDialog
            DomainGuids                               = $tenantRestrictions.AllowedDomainList
            Enabled                                   = $tenantRestrictions.TenantRestrictionEnabled
            ExcludedFileExtensions                    = $tenantRestrictions.ExcludedFileExtensions
            GrooveBlockOption                         = $GrooveOption
            OneDriveStorageQuota                      = $tenant.OneDriveStorageQuota
            OrphanedPersonalSitesRetentionPeriod      = $tenant.OrphanedPersonalSitesRetentionPeriod 
            OneDriveForGuestsEnabled                  = $tenant.OneDriveForGuestsEnabled
            ODBAccessRequests                         = $tenant.ODBAccessRequests
            ODBMembersCanShare                        = $tenant.ODBMembersCanShare
            NotifyOwnersWhenInvitationsAccepted       = $tenant.NotifyOwnersWhenInvitationsAccepted
            NotificationsInOneDriveForBusinessEnabled = $tenant.NotificationsInOneDriveForBusinessEnabled
            Ensure                                    = "Present"
        }
    }
    catch
    {
        Write-Verbose "Failed to get Tenant client sync settings !"
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
        $CentralAdminUrl,

        [Parameter()]
        [System.UInt32]
        $OneDriveStorageQuota,

        [Parameter()]
        [System.UInt32]
        $OrphanedPersonalSitesRetentionPeriod,

        [Parameter()]
        [System.Boolean]
        $OneDriveForGuestsEnabled,

        [Parameter()]
        [System.Boolean]
        $NotifyOwnersWhenInvitationsAccepted,

        [Parameter()]
        [System.Boolean]
        $NotificationsInOneDriveForBusinessEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet("On","Off","Unspecified")] 
        $ODBMembersCanShare,

        [Parameter()]
        [System.String]
        [ValidateSet("On","Off","Unspecified")] 
        $ODBAccessRequests,

        [Parameter()]
        [System.Boolean]
        $BlockMacSync,

        [Parameter()]
        [System.Boolean]
        $DisableReportProblemDialog,

        [Parameter()]
        [System.String]
        $DomainGuids,
        
        [Parameter()]
        [System.String[]]
        $ExcludedFileExtensions,

        [Parameter()]
        [System.String]
        [ValidateSet("OptOut","HardOptIn","SoftOptIn")] 
        $GrooveBlockOption,

        [Parameter()] 
        [ValidateSet("Present","Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("CentralAdminUrl")
    $CurrentParameters.Remove("GlobalAdminAccount")
    ## Tenant settings updated ###

    if ($CurrentParameters.ContainsKey("OneDriveStorageQuota"))
    {
        Set-SPOTenant -OneDriveStorageQuota $OneDriveStorageQuota
        Write-Verbose -Message "Setting OneDrive storage quoata to $OneDriveStorageQuota"
    }

    if ($CurrentParameters.ContainsKey("OrphanedPersonalSitesRetentionPeriod"))
    {
        Set-SPOTenant -OrphanedPersonalSitesRetentionPeriod $OrphanedPersonalSitesRetentionPeriod
        Write-Verbose -Message "Setting OneDrive retention period $OrphanedPersonalSitesRetentionPeriod"
    }

    if ($CurrentParameters.ContainsKey("OneDriveForGuestsEnabled"))
    {
        Set-SPOTenant -OneDriveForGuestsEnabled $OneDriveForGuestsEnabled
        Write-Verbose -Message "Setting OneDrive for guest access $OneDriveForGuestsEnabled"
    }

    if ($CurrentParameters.ContainsKey("NotifyOwnersWhenInvitationsAccepted"))
    {
        Set-SPOTenant -NotifyOwnersWhenInvitationsAccepted $NotifyOwnersWhenInvitationsAccepted
        Write-Verbose -Message "Setting OneDrive notify owner when guest access accepted $NotifyOwnersWhenInvitationsAccepted"
    }
    
    if ($CurrentParameters.ContainsKey("NotificationsInOneDriveForBusinessEnabled"))
    {
        Set-SPOTenant -NotificationsInOneDriveForBusinessEnabled $NotificationsInOneDriveForBusinessEnabled
        Write-Verbose -Message "Setting OneDrive notify enabled to  $NotificationsInOneDriveForBusinessEnabled"
    }

    if ($CurrentParameters.ContainsKey("ODBAccessRequests"))
    {
        Set-SPOTenant -ODBAccessRequests $ODBAccessRequests
        Write-Verbose -Message "Setting OneDrive access requests $ODBAccessRequests"
    }
   
    if ($CurrentParameters.ContainsKey("ODBMembersCanShare"))
    {
        Set-SPOTenant -ODBMembersCanShare $ODBMembersCanShare
        Write-Verbose -Message "Setting OneDrive member share requets $ODBMembersCanShare"
    }
    ## Sync client settings 
    
    if ($CurrentParameters.ContainsKey("BlockMacSync") -and $CurrentParameters.ContainsKey("DomainGuids"))
    {
        if ($BlockMacSync -eq $true)
        {
            Set-SPOTenantSyncClientRestriction -BlockMacSync:$BlockMacSync -DomainGuids $DomainGuids -Enable
        }
        elseif ($BlockMacSync -eq $false)
        {
            Set-SPOTenantSyncClientRestriction -BlockMacSync:$BlockMacSync -DomainGuids $DomainGuids -Enable   
        }
    }

    if ($CurrentParameters.ContainsKey("DomainGuids") -and ($BlockMacSync -eq $null))
    {
        Set-SPOTenantSyncClientRestriction -DomainGuids $DomainGuids -Enable
    }

    if (!$CurrentParameters.ContainsKey("DomainGuids") -and ($BlockMacSync -ne $null))
    {
        Write-Verbose "Cannot block Mac Clients without specifiing an allowed domain !"
    }

    if ($CurrentParameters.ContainsKey("ExcludedFileExtensions"))
    {
        $BlockedFileTypes = ""
        foreach ($fileTypes in $ExcludedFileExtensions)
        {
            $BlockedFileTypes += $fileTypes + ';'
        }

        Set-SPOTenantSyncClientRestriction -ExcludedFileExtensions $BlockedFileTypes
    }
    if ($CurrentParameters.ContainsKey("DisableReportProblemDialog"))
    {
        Set-SPOTenantSyncClientRestriction -DisableReportProblemDialog $DisableReportProblemDialog
    }

    if ($CurrentParameters.ContainsKey("GrooveBlockOption"))
    {
        Set-SPOTenantSyncClientRestriction -GrooveBlockOption $GrooveBlockOption
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
        $CentralAdminUrl,

        [Parameter()]
        [System.UInt32]
        $OneDriveStorageQuota,

        [Parameter()]
        [System.UInt32]
        $OrphanedPersonalSitesRetentionPeriod,

        [Parameter()]
        [System.Boolean]
        $OneDriveForGuestsEnabled,

        [Parameter()]
        [System.Boolean]
        $NotifyOwnersWhenInvitationsAccepted,

        [Parameter()]
        [System.Boolean]
        $NotificationsInOneDriveForBusinessEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet("On","Off","Unspecified")] 
        $ODBMembersCanShare,

        [Parameter()]
        [System.String]
        [ValidateSet("On","Off","Unspecified")] 
        $ODBAccessRequests,

        [Parameter()]
        [System.Boolean]
        $BlockMacSync,

        [Parameter()]
        [System.Boolean]
        $DisableReportProblemDialog,

        [Parameter()]
        [System.String]
        $DomainGuids,
        
        [Parameter()]
        [System.String[]]
        $ExcludedFileExtensions,

        [Parameter()]
        [System.String]
        [ValidateSet("OptOut","HardOptIn","SoftOptIn")] 
        $GrooveBlockOption,

        [Parameter()] 
        [ValidateSet("Present","Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing client tenant sync settings"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("BlockMacSync", `
            "ExcludedFileExtensions", `
            "DisableReportProblemDialog", `
            "GrooveBlockOption", `
            "DomainGuids", `
            "OneDriveStorageQuota", `
            "OrphanedPersonalSitesRetentionPeriod", `
            "OneDriveForGuestsEnabled", `
            "ODBAccessRequests", `
            "ODBMembersCanShare", `
            "NotifyOwnersWhenInvitationsAccepted", `
            "NotificationsInOneDriveForBusinessEnabled",
            "Ensure"
    )
}           

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter()]
        [System.UInt32]
        $OneDriveStorageQuota,

        [Parameter()]
        [System.UInt32]
        $OrphanedPersonalSitesRetentionPeriod,

        [Parameter()]
        [System.Boolean]
        $OneDriveForGuestsEnabled,

        [Parameter()]
        [System.Boolean]
        $NotifyOwnersWhenInvitationsAccepted,

        [Parameter()]
        [System.Boolean]
        $NotificationsInOneDriveForBusinessEnabled,

        [Parameter()]
        [System.String]
        $ODBMembersCanShare,

        [Parameter()]
        [System.String]
        $ODBAccessRequests,

        [Parameter()]
        [System.Boolean]
        $BlockMacSync,

        [Parameter()]
        [System.Boolean]
        $DisableReportProblemDialog,

        [Parameter()]
        [System.String]
        $DomainGuids,

        [Parameter()]
        [System.String[]]
        $ExcludedFileExtensions,

        [Parameter()]
        [System.String]
        $GrooveBlockOption,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    Test-SPOServiceConnection -GlobalAdminAccount $GlobalAdminAccount -SPOCentralAdminUrl $CentralAdminUrl
    $result = Get-TargetResource @PSBoundParameters
    $content = "ODSettings " + (New-GUID).ToString() + "`r`n"
    $content += "{`r`n"
    $content += Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += "}`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
