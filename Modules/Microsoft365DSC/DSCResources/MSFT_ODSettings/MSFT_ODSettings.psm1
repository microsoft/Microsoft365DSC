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
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
        -InboundParameters $PSBoundParameters

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
        ApplicationId                             = $ApplicationId
        TenantId                                  = $TenantId
        CertificatePassword                       = $CertificatePassword
        CertificatePath                           = $CertificatePath
        CertificateThumbprint                     = $CertificateThumbprint
        GlobalAdminAccount                        = $GlobalAdminAccount
    }

    try
    {
        Write-Verbose -Message "Getting OneDrive quota size for tenant"
        $tenant = Get-PnPTenant

        if ($null -eq $tenant)
        {
            Write-Verbose -Message "Failed to get Tenant information"
            return $nullReturn
        }

        Write-Verbose -Message "Getting OneDrive quota size for tenant $($tenant.OneDriveStorageQuota)"
        Write-Verbose -Message "Getting tenant client sync setting"
        $tenantRestrictions = Get-PnPTenantSyncClientRestriction

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
        $Message = "Failed to get Tenant client sync settings"
        New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
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
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
        -InboundParameters $PSBoundParameters

    ## Configure OneDrive settings
    ## Parameters below are remove for the Set-SPOTenant cmdlet
    ## they are used in the Set-SPOTenantSyncClientRestriction cmdlet
    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount") | Out-Null

    if ($CurrentParameters.ContainsKey("Ensure"))
    {
        $CurrentParameters.Remove("Ensure") | Out-Null
    }

    if ($CurrentParameters.ContainsKey("BlockMacSync"))
    {
        $CurrentParameters.Remove("BlockMacSync") | Out-Null
    }
    if ($CurrentParameters.ContainsKey("DomainGuids"))
    {
        $CurrentParameters.Remove("DomainGuids")| Out-Null
    }
    if ($CurrentParameters.ContainsKey("DisableReportProblemDialog"))
    {
        $CurrentParameters.Remove("DisableReportProblemDialog") | Out-Null
    }
    if ($CurrentParameters.ContainsKey("ExcludedFileExtensions"))
    {
        $CurrentParameters.Remove("ExcludedFileExtensions") | Out-Null
    }
    if ($CurrentParameters.ContainsKey("GrooveBlockOption"))
    {
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
    Set-PnPTenant @CurrentParameters

    $clientSyncParameters = $PSBoundParameters

    ## Configure Sync Client restrictions
    ## Set-SPOTenantSyncClientRestriction has different parameter sets and they cannot be combined see article:
    ## https://docs.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenantsyncclientrestriction?view=sharepoint-ps

    if ($clientSyncParameters.ContainsKey("BlockMacSync") -and $clientSyncParameters.ContainsKey("DomainGuids"))
    {
        Set-PnPTenantSyncClientRestriction -BlockMacSync:$BlockMacSync -DomainGuids $DomainGuids -Enable
    }
    elseif ($clientSyncParameters.ContainsKey("DomainGuids") -and ($clientSyncParameters.ContainsKey("BlockMacSync") -eq $false))
    {
        Set-PnPTenantSyncClientRestriction -DomainGuids $DomainGuids -Enable
    }

    if ($clientSyncParameters.ContainsKey("ExcludedFileExtensions"))
    {
        $BlockedFileTypes = ""
        foreach ($fileTypes in $ExcludedFileExtensions)
        {
            $BlockedFileTypes += $fileTypes + ';'
        }

        Set-PnPTenantSyncClientRestriction -ExcludedFileExtensions $BlockedFileTypes
    }
    if ($clientSyncParameters.ContainsKey("DisableReportProblemDialog"))
    {
        Set-PnPTenantSyncClientRestriction -DisableReportProblemDialog $DisableReportProblemDialog
    }

    if ($clientSyncParameters.ContainsKey("GrooveBlockOption"))
    {
        Set-PnPTenantSyncClientRestriction -GrooveBlockOption $GrooveBlockOption
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

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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
    $InformationPReference = 'Continue'

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
        -InboundParameters $PSBoundParameters

    $params = @{
        IsSingleInstance      = 'Yes'
        ApplicationId         = $ApplicationId
        TenantId              = $TenantId
        CertificatePassword   = $CertificatePassword
        CertificatePath       = $CertificatePath
        CertificateThumbprint = $CertificateThumbprint
        GlobalAdminAccount    = $GlobalAdminAccount
    }

    $organization = Get-M365DSCOrganization -GlobalAdminAccount $GlobalAdminAccount -TenantId $Tenantid
    if ($organization.IndexOf(".") -gt 0)
    {
        $principal = $organization.Split(".")[0]
    }

    $result = Get-TargetResource @Params

    if ([System.String]::IsNullOrEmpty($result.GrooveBlockOption))
    {
        $result.Remove("GrooveBlockOption") | Out-Null
    }
    if ($ConnectionMode -eq 'Credential')
    {
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    }
    else
    {
        if ($null -ne $CertificatePassword)
        {
            $result.CertificatePassword = Resolve-Credentials -UserName "CertificatePassword"
        }
    }
    $result = Remove-NullEntriesFromHashTable -Hash $result

    $content = "        ODSettings " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    if ($ConnectionMode -eq 'Credential')
    {
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    }
    else
    {
        if ($null -ne $CertificatePassword)
        {
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "CertificatePassword"
        }
        else
        {
            $content += $currentDSCBlock
        }
        $content = Format-M365ServicePrincipalData -configContent $content -applicationid $ApplicationId `
            -principal $principal -CertificateThumbprint $CertificateThumbprint
    }
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
