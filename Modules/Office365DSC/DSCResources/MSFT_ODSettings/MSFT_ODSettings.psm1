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
        Execute-CSOMQueryRetry -Context $ctx

        if ($null -eq $tenant)
        {
            Write-Verbose -Message "Failed to get Tenant information"
            return $nullReturn
        }

        Write-Verbose -Message "Getting OneDrive quota size for tenant $($tenant.OneDriveStorageQuota)"

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

        $FixedAllowedDomainList = $tenant.AllowedDomainListForSyncClient | ForEach-Object { $_.ToString()}
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

    Write-Verbose -Message "Setting configuration of OneDrive Settings"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform PnP

    $ctx = (Get-PnPConnection).Context
    $tenant = [Microsoft.Online.SharePoint.TenantAdministration.Tenant]::new($ctx)
    $ctx.Load($tenant)
    Execute-CSOMQueryRetry -Context $ctx

     ## Configure OneDrive settings
    ## Parameters below are removed because they are not directly mapped to the CSOM Tenant object
    $CurrentParameters =  @{} + $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount")

    if ($CurrentParameters.ContainsKey("DomainGuids"))
    {
        $CurrentParameters.Remove("DomainGuids")
    }
    if ($CurrentParameters.ContainsKey("ExcludedFileExtensions"))
    {
        $CurrentParameters.Remove("ExcludedFileExtensions")
    }
    if ($CurrentParameters.ContainsKey("GrooveBlockOption"))
    {
        $CurrentParameters.Remove("GrooveBlockOption")
    }
    if ($CurrentParameters.ContainsKey("IsSingleInstance"))
    {
        $CurrentParameters.Remove("IsSingleInstance")
    }

    Write-Verbose -Message "Configuring OneDrive settings."

    foreach($param in $CurrentParameters.GetEnumerator())
    {
        $propName = $param.Key
        $tenant.$propName = $param.Value
    }

    if ($PSBoundParameters.ContainsKey("DomainGuids"))
    {
        $actualDomainGuids = New-Object System.Collections.Generic.List[Guid]
        foreach($domainGuid in $DomainGuids)
        {
            [guid]$parsedGuid = [Guid]::Empty
            if(![Guid]::TryParse($domainGuid, [ref] $parsedGuid))
            {
                continue
            }
            $actualDomainGuids.Add($parsedGuid)
        }
        $tenant.AllowedDomainListForSyncClient = $actualDomainGuids
    }
    if ($PSBoundParameters.ContainsKey("ExcludedFileExtensions"))
    {
        $tenant.ExcludedFileExtensionsForSyncClient = $ExcludedFileExtensions
    }

    if ($PSBoundParameters.ContainsKey("GrooveBlockOption"))
    {
        if ($GrooveBlockOption -eq "OptOut")
        {
            $tenant.OptOutOfGrooveBlock = $true;
            $tenant.OptOutOfGrooveSoftBlock = $true;
        }
        elseif ($GrooveBlockOption -eq "HardOptIn")
        {
            $tenant.OptOutOfGrooveBlock = $false;
        }
        elseif ($GrooveBlockOption -eq "SoftOptIn")
        {
            $tenant.OptOutOfGrooveSoftBlock = $false;
        }
    }

    $ctx.ExecuteQuery()
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

    Write-Verbose -Message "Testing configuration of OneDrive Settings"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
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
        "Ensure")

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
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
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP `
        -ErrorAction SilentlyContinue
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
