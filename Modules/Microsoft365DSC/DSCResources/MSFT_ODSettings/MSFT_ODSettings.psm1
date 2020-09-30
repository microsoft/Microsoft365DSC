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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration of OneDrive Settings"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
        -InboundParameters $PSBoundParameters

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    try
    {
        Write-Verbose -Message "Getting OneDrive quota size for tenant"
        $tenant = Get-PnPTenant -ErrorAction Stop

        if ($null -eq $tenant)
        {
            Write-Verbose -Message "Failed to get Tenant information"
            return $nullReturn
        }

        Write-Verbose -Message "Getting OneDrive quota size for tenant $($tenant.OneDriveStorageQuota)"
        Write-Verbose -Message "Getting tenant client sync setting"
        $tenantRestrictions = Get-PnPTenantSyncClientRestriction -ErrorAction Stop

        if ($null -eq $tenantRestrictions)
        {
            Write-Verbose -Message "Failed to get Tenant client synce settings!"
            return $nullReturn
        }

        $GrooveOption = $null

        if (($tenantRestrictions.OptOutOfGrooveBlock -eq $true) -and ($tenantRestrictions.OptOutOfGrooveSoftBlock -eq $false))
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

        $FixedExcludedFileExtensions = $tenantRestrictions.ExcludedFileExtensions
        if ($FixedExcludedFileExtensions.Count -eq 0 -or
            ($FixedExcludedFileExtensions.Count -eq 1 -and $FixedExcludedFileExtensions[0] -eq ""))
        {
            $FixedExcludedFileExtensions = @()
        }

        $FixedAllowedDomainList = $tenantRestrictions.AllowedDomainList
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
            BlockMacSync                              = $tenantRestrictions.BlockMacSync
            DisableReportProblemDialog                = $tenantRestrictions.DisableReportProblemDialog
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
            ApplicationId                             = $ApplicationId
            TenantId                                  = $TenantId
            CertificatePassword                       = $CertificatePassword
            CertificatePath                           = $CertificatePath
            CertificateThumbprint                     = $CertificateThumbprint
            GlobalAdminAccount                        = $GlobalAdminAccount
        }
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration of OneDrive Settings"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
        -InboundParameters $PSBoundParameters

    ## Configure OneDrive settings
    ## Parameters below are remove for the Set-SPOTenant cmdlet
    ## they are used in the Set-SPOTenantSyncClientRestriction cmdlet
    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount") | Out-Null
    $Options = @{}

    if ($CurrentParameters.ContainsKey("Ensure"))
    {
        $CurrentParameters.Remove("Ensure") | Out-Null
    }
    if ($CurrentParameters.ContainsKey("BlockMacSync"))
    {
        $Options.Add("BlockMacSync", $CurrentParameters.BlockMacSync)
        $CurrentParameters.Remove("BlockMacSync") | Out-Null
    }
    if ($CurrentParameters.ContainsKey("DomainGuids"))
    {
        $Options.Add("DomainGuids", [System.Guid[]]$CurrentParameters.DomainGuids)
        $CurrentParameters.Remove("DomainGuids")| Out-Null
    }
    if ($CurrentParameters.ContainsKey("DisableReportProblemDialog"))
    {
        $Options.Add("DisableReportProblemDialog", $CurrentParameters.DisableReportProblemDialog)
        $CurrentParameters.Remove("DisableReportProblemDialog") | Out-Null
    }
    if ($CurrentParameters.ContainsKey("ExcludedFileExtensions"))
    {
        $Options.Add("ExcludedFileExtensions", $CurrentParameters.ExcludedFileExtensions)
        $CurrentParameters.Remove("ExcludedFileExtensions") | Out-Null
    }
    if ($CurrentParameters.ContainsKey("GrooveBlockOption"))
    {
        $Options.Add("GrooveBlockOption", $CurrentParameters.GrooveBlockOption)
        $CurrentParameters.Remove("GrooveBlockOption") | Out-Null
    }
    if ($CurrentParameters.ContainsKey("IsSingleInstance"))
    {
        $CurrentParameters.Remove("IsSingleInstance") | Out-Null
    }

    $CurrentParameters.Remove("ApplicationId") | Out-Null
    $CurrentParameters.Remove("TenantId") | Out-Null
    $CurrentParameters.Remove("CertificatePath") | Out-Null
    $CurrentParameters.Remove("CertificatePassword") | Out-Null
    $CurrentParameters.Remove("CertificateThumbprint") | Out-Null

    Write-Verbose -Message "Configuring OneDrive settings."
    Set-PnPTenant @CurrentParameters | Out-Null

    ## Configure Sync Client restrictions
    ## Set-SPOTenantSyncClientRestriction has different parameter sets and they cannot be combined see article:
    ## https://docs.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenantsyncclientrestriction?view=sharepoint-ps
    Write-Verbose -Message "Setting other configuration parameters"
    Write-Verbose -Message ($Options | Out-String)
    if ($Options.ContainsKey("BlockMacSync") -and $Options.ContainsKey("DomainGuids"))
    {
        Write-Verbose -Message "Updating BlockMacSync {$($Options.BlockMacSync)}"
        Set-PnPTenantSyncClientRestriction -BlockMacSync:$Options.BlockMacSync -DomainGuids $Options.DomainGuids -Enable:$true | Out-Null
    }
    elseif ($Options.ContainsKey("DomainGuids") -and ($Options.ContainsKey("BlockMacSync") -eq $false))
    {
        Write-Verbose -Message "Updating DomainGuids"
        Set-PnPTenantSyncClientRestriction -DomainGuids $Options.DomainGuids -Enable:$true| Out-Null
    }

    if ($Options.ContainsKey("ExcludedFileExtensions"))
    {
        Write-Verbose -Message "Updating ExcludedFileExtensions"
        $BlockedFileTypes = ""
        foreach ($fileTypes in $Options.ExcludedFileExtensions)
        {
            $BlockedFileTypes += $fileTypes + ';'
        }

        Set-PnPTenantSyncClientRestriction -ExcludedFileExtensions $BlockedFileTypes | Out-Null
    }
    if ($Options.ContainsKey("DisableReportProblemDialog"))
    {
        Write-Verbose -Message "Updating DisableReportProblemDialog"
        Set-PnPTenantSyncClientRestriction -DisableReportProblemDialog:$Options.DisableReportProblemDialog | Out-Null
    }

    if ($Options.ContainsKey("GrooveBlockOption"))
    {
        Write-Verbose -Message "Updating GrooveBlockOption"
        Set-PnPTenantSyncClientRestriction -GrooveBlockOption $Options.GrooveBlockOption | Out-Null
    }
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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Testing configuration of OneDrive Settings"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
        -InboundParameters $PSBoundParameters

    try
    {
        $Params = @{
            IsSingleInstance      = 'Yes'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
            GlobalAdminAccount    = $GlobalAdminAccount
        }

        $Results = Get-TargetResource @Params

        if ([System.String]::IsNullOrEmpty($Results.GrooveBlockOption))
        {
            $Results.Remove("GrooveBlockOption") | Out-Null
        }

        $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
            -Results $Results
        $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $Results `
            -GlobalAdminAccount $GlobalAdminAccount
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        return $dscContent
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
