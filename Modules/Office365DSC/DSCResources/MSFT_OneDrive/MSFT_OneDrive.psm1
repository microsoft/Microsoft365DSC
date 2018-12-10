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
        [System.String]
        $DomainGuids,
        
        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $ExcludedFileExtensions,

        [Parameter()]
        [System.Boolean]
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
        Write-Verbose "OneDrive storage setting for tenant currently $($tenant.OneDriveStorageQuota)"


        Write-Verbose -Message "Getting tenant client sync setting"
        $tenantRestrictions = Get-SPOTenantSyncClientRestriction
        if (!$tenantRestrictions) {
            Write-Verbose "Failed to get Tenant client synce settings"
            return $nullReturn
        }
        Write-Verbose "Client sync settings for tenant $CentralAdminUrl"
        Write-Verbose "BlockMacSync $($tenantRestrictions.BlockMacSync)"
        Write-Verbose "Disable report problem dialog $($tenantRestrictions.DisableReportProblemDialog)"
        Write-Verbose "Allowed Domains $($tenantRestrictions.AllowedDomainList)"
        Write-Verbose "Tenant Restrictions enabled $($tenantRestrictions.TenantRestrictionEnabled)"
        Write-Verbose "Excluded file types $($tenantRestrictions.ExcludedFileExtensions)"
        Write-Verbose "Groove client blocked $($tenantRestrictions.OptOutOfGrooveBlock)"

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
        [System.String]
        $DomainGuids,
        
        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $ExcludedFileExtensions,

        [Parameter()]
        [System.Boolean]
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


    Write-Verbose "Current parameteres $CurrenParameters"
    $property = $null

    if ($CurrentParameters.ContainsKey("BlockMacSync")) {
        $property = "-BlockMacSync $BlockMacSync"
    }

    if ($CurrentParameters.ContainsKey("DisableReportProblemDialog")) {
        $property = "$property -DisableReportProblemDialog $DisableReportProblemDialog"
    }

    if ($CurrentParameters.ContainsKey("DomainGuids")) {
        $property = "$property -DomainGuids $DomainGuids"
    }

    if ($CurrentParameters.ContainsKey("Enabled")) {
        $property = "$property -Enabled $Enabled"
    }

    if ($CurrentParameters.ContainsKey("ExcludedFileExtensions")) {
        $property = "$property -ExcludedFileExtensions $ExcludedFileExtensions"
    }

    if ($CurrentParameters.ContainsKey("GrooveBlockOption")) {
        $property = "$property -GrooveBlockOption $GrooveBlockOption"
    }

    Write-Verbose "Properties $property"
    Set-SPOTenantSyncClientRestriction $property
    Write-Verbose -Message "Setting tenant client sync settings $property"

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
        [System.String]
        $DomainGuids,
        
        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $ExcludedFileExtensions,

        [Parameter()]
        [System.Boolean]
        $GrooveBlockOption,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing client tenant sync settings"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("BlockMacSync")
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
        [System.String]
        $DomainGuids,
        
        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $ExcludedFileExtensions,

        [Parameter()]
        [System.Boolean]
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
