function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Yes")]
        [System.String]
        $IsSingleInstance,

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
        [ValidateSet("On", "Off", "Unspecified")]
        $ODBMembersCanShare,

        [Parameter()]
        [System.String]
        [ValidateSet("On", "Off", "Unspecified")]
        $ODBAccessRequests,

        [Parameter()]
        [System.Boolean]
        $BlockMacSync,

        [Parameter()]
        [System.Boolean]
        $DisableReportProblemDialog,

        [Parameter()]
        [System.String[]]
        $DomainGuids,

        [Parameter()]
        [System.String[]]
        $ExcludedFileExtensions,

        [Parameter()]
        [System.String]
        [ValidateSet("OptOut", "HardOptIn", "SoftOptIn")]
        $GrooveBlockOption,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of OneDrive Settings"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform PnP

    $nullReturn = @{
        IsSingleInstance                          = "Yes"
        BlockMacSync                              = $null
        DisableReportProblemDialog                = $null
        DomainGuids                               = $null
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
        Write-Verbose -Message "Getting Tenant information"
        $ctx = (Get-PnPConnection).Context
        $tenant = [Microsoft.Online.SharePoint.TenantAdministration.Tenant]::new($ctx)



        $ctx.Load($tenant)

        # taken from the cmdlet for clientsyncsettings
        # but it seems that it's loaded by default
        # $propertiesToLoad = @("IsUnmanagedSyncClientForTenantRestricted"
        # ,"AllowedDomainListForSyncClient"
        # ,"BlockMacSync"
        # ,"ExcludedFileExtensionsForSyncClient"
        # ,"OptOutOfGrooveBlock"
        # ,"OptOutOfGrooveSoftBlock"
        # ,"DisableReportProblemDialog")
        # Load-CSOMProperties -Object  $tenant -PropertyNames $propertiesToLoad
        $ctx.ExecuteQuery();

        if ($null -eq $tenant)
        {
            Write-Verbose -Message "Failed to get Tenant information"
            return $nullReturn
        }

        $GrooveOption = $null

        if (($tenant.OptOutOfGrooveBlock -eq $false) -and ($tenant.OptOutOfGrooveSoftBlock -eq $false))
        {
            $GrooveOption = "SoftOptIn"
        }

        if (($tenant.OptOutOfGrooveBlock -eq $false) -and ($tenant.OptOutOfGrooveSoftBlock -eq $true))
        {
            $GrooveOption = "HardOptIn"
        }

        if (($tenant.OptOutOfGrooveBlock -eq $true) -and ($tenant.OptOutOfGrooveSoftBlock -eq $true))
        {
            $GrooveOption = "OptOut"
        }

        $FixedExcludedFileExtensions = $tenant.ExcludedFileExtensionsForSyncClient
        if ($FixedExcludedFileExtensions.Count -eq 0 -or
            ($FixedExcludedFileExtensions.Count -eq 1 -and $FixedExcludedFileExtensions[0] -eq ""))
        {
            $FixedExcludedFileExtensions = @()
        }

        $FixedAllowedDomainList = $tenant.AllowedDomainListForSyncClient
        if ($FixedAllowedDomainList.Count -eq 0 -or
            ($FixedAllowedDomainList.Count -eq 1 -and $FixedAllowedDomainList[0] -eq ""))
        {
            $FixedAllowedDomainList = @()
        }

        $ODBMembersCanShareValue = $tenant.ODBMembersCanShare
        if ([System.String]::IsNullOrEmpty($ODBMembersCanShareValue))
        {
            $ODBMembersCanShareValue = 'Unspecified'
        }
        return @{
            IsSingleInstance                          = "Yes"
            BlockMacSync                              = $tenant.BlockMacSync
            DisableReportProblemDialog                = $tenant.DisableReportProblemDialog
            DomainGuids                               = $FixedAllowedDomainList
            ExcludedFileExtensions                    = $FixedExcludedFileExtensions
            GrooveBlockOption                         = $GrooveOption
            OneDriveStorageQuota                      = $tenant.OneDriveStorageQuota
            OrphanedPersonalSitesRetentionPeriod      = $tenant.OrphanedPersonalSitesRetentionPeriod
            OneDriveForGuestsEnabled                  = $tenant.OneDriveForGuestsEnabled
            ODBAccessRequests                         = $tenant.ODBAccessRequests
            ODBMembersCanShare                        = $ODBMembersCanShareValue
            NotifyOwnersWhenInvitationsAccepted       = $tenant.NotifyOwnersWhenInvitationsAccepted
            NotificationsInOneDriveForBusinessEnabled = $tenant.NotificationsInOneDriveForBusinessEnabled
            Ensure                                    = "Present"
        }
    }
    catch
    {
        $Message = "Failed to get Tenant client sync settings"
        New-Office365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Yes")]
        [System.String]
        $IsSingleInstance,

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
        [ValidateSet("On", "Off", "Unspecified")]
        $ODBMembersCanShare,

        [Parameter()]
        [System.String]
        [ValidateSet("On", "Off", "Unspecified")]
        $ODBAccessRequests,

        [Parameter()]
        [System.Boolean]
        $BlockMacSync,

        [Parameter()]
        [System.Boolean]
        $DisableReportProblemDialog,

        [Parameter()]
        [System.String[]]
        $DomainGuids,

        [Parameter()]
        [System.String[]]
        $ExcludedFileExtensions,

        [Parameter()]
        [System.String]
        [ValidateSet("OptOut", "HardOptIn", "SoftOptIn")]
        $GrooveBlockOption,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    throw "Not implemented"
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Yes")]
        [System.String]
        $IsSingleInstance,

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
        [ValidateSet("On", "Off", "Unspecified")]
        $ODBMembersCanShare,

        [Parameter()]
        [System.String]
        [ValidateSet("On", "Off", "Unspecified")]
        $ODBAccessRequests,

        [Parameter()]
        [System.Boolean]
        $BlockMacSync,

        [Parameter()]
        [System.Boolean]
        $DisableReportProblemDialog,

        [Parameter()]
        [System.String[]]
        $DomainGuids,

        [Parameter()]
        [System.String[]]
        $ExcludedFileExtensions,

        [Parameter()]
        [System.String]
        [ValidateSet("OptOut", "HardOptIn", "SoftOptIn")]
        $GrooveBlockOption,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    throw "Not implemented"
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $InformationPReference = 'Continue'

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion
    $Params = @{
        IsSingleInstance   = 'Yes'
        GlobalAdminAccount = $GlobalAdminAccount
    }
    $result = Get-TargetResource @Params
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        ODSettings " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
