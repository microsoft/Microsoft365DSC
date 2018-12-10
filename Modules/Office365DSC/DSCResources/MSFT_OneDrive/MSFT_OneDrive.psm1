function Get-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $OneDriveStorageQuota,

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
        $GrooveBlockOption,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    
    $nullReturn = @{
        BlockMacSync               = $null
        DisableReportProblemDialog = $null
        DomainGuids                = $null
        Enabled                    = $null
        ExcludedFileExtensions     = $null
        GrooveBlockOption          = $null
        OneDriveStorageQuota       = $null
    }   

    try {

        Write-Verbose -Message "Getting OneDrive quoata size for tenant"
        $tenant = Get-SPOTenant

        if (!$tenant) {
            Write-Verbose "Failed to get Tenant information"
            return $nullReturn
        }
        Write-Verbose -Message "Getting tenant client sync setting"
        $tenantRestrictions = Get-SPOTenantSyncClientRestriction
        if (!$tenantRestrictions) {
            Write-Verbose "Failed to get Tenant client synce settings"
            return $nullReturn
        }

        return @{
            BlockMacSync               = $tenantRestrictions.BlockMacSync
            DisableReportProblemDialog = $tenantRestrictions.DisableReportProblemDialog
            DomainGuids                = $tenantRestrictions.AllowedDomainList
            Enabled                    = $tenantRestrictions.TenantRestrictionEnabled
            ExcludedFileExtensions     = $tenantRestrictions.ExcludedFileExtensions
            GrooveBlockOption          = $tenantRestrictions.OptOutOfGrooveBlock
            OneDriveStorageQuota       = $tenant.OneDriveStorageQuota
        }
    }
    catch {
        Write-Verbose "Failed to get Tenant client sync settings."
        return $nullReturn
    }
}

function Set-TargetResource {
    [CmdletBinding()]
    param
    (   
        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $OneDriveStorageQuota,

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
        $GrooveBlockOption,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("CentralAdminUrl")
    $CurrentParameters.Remove("GlobalAdminAccount")

    if ($CurrentParameters.ContainsKey("OneDriveStorageQuota")) {
        Set-SPOTenant -OneDriveStorageQuota $OneDriveStorageQuota
        Write-Verbose -Message "Setting OneDrive storage quoata to $OneDriveStorageQuota"
    }


    if ($CurrentParameters.ContainsKey("BlockMacSync") -and $CurrentParameters.ContainsKey("DomainGuids")) {
        $allowedDomains = ""
        foreach ($domain in $DomainGuids) {
            $allowedDomains += $domain + ";"
        }

        if ($CurrentParameters.ContainsKey("BlockMacSync") -eq $true) {
            Set-SPOTenantSyncClientRestriction -BlockMacSync:$true -DomainGuids $allowedDomains -Enable
        }
        elseif ($CurrentParameters.ContainsKey("BlockMacSync") -eq $false) {
            Set-SPOTenantSyncClientRestriction -BlockMacSync:$false -DomainGuids $allowedDomains -Enable   
        }
    }

    if ($CurrentParameters.ContainsKey("DomainGuids")) {
        $allowedDomains = ""
        foreach ($domain in $DomainGuids) {
            $allowedDomains += $domain + ";"
        }
        Set-SPOTenantSyncClientRestriction -DomainGuids $allowedDomains -Enable
    }

    if ($CurrentParameters.ContainsKey("ExcludedFileExtensions")) {
        $BlockedFileTypes = ""
        foreach ($fileTypes in $ExcludedFileExtensions) {
            $BlockedFileTypes += $fileTypes + ';'
        }

        Write-Verbose "Excluded file types $ExcludedFileExtensions"
        Set-SPOTenantSyncClientRestriction -ExcludedFileExtensions $BlockedFileTypes
    }
    if ($CurrentParameters.ContainsKey("DisableReportProblemDialog")) {
        Set-SPOTenantSyncClientRestriction -DisableReportProblemDialog $DisableReportProblemDialog
    }

    if ($CurrentParameters.ContainsKey("GrooveBlockOption")) {
        Set-SPOTenantSyncClientRestriction -GrooveBlockOption $GrooveBlockOption
    }
}

function Test-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $OneDriveStorageQuota,

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
        $GrooveBlockOption,

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
            "GrooveBlockOption", `
            "DisableReportProblemDialog", `
            "DomainGuids"
    )
}           

function Export-TargetResource {
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $OneDriveStorageQuota,

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
        $GrooveBlockOption,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    Test-SPOServiceConnection -GlobalAdminAccount $GlobalAdminAccount -SPOCentralAdminUrl $CentralAdminUrl
    $result = Get-TargetResource @PSBoundParameters
    $content = "Tenant client sync settings " + (New-GUID).ToString() + "`r`n"
    $content += "{`r`n"
    $content += Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += "}`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
