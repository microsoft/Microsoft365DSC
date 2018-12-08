function Get-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
      
        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

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
    }   

    try {
        Write-Verbose -Message "Getting tenant client sync setting"
        $tenantRestrictions = Get-SPOTenantSyncClientRestriction
        if (!$tenantRestrictions) {
            Write-Verbose "Failed to get Tenant client synce settings"
            return $nullReturn
        }
        Write-Verbose "Client sync settings for tenant"
        return @{
            BlockMacSync               = $tenantRestrictions.BlockMacSync
            DisableReportProblemDialog = $tenantRestrictions.DisableReportProblemDialog
            DomainGuids                = $tenantRestrictions.DomainGuids
            Enabled                    = $tenantRestrictions.Enabled
            ExcludedFileExtensions     = $tenantRestrictions.ExcludedFileExtensions
            GrooveBlockOption          = $tenantRestrictions.GrooveBlockOption
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
        -ValuesToCheck @("BlockMacSync". `
            "DisableReportProblemDialog", `
            "DomainGuids", `
            "Enabled", `
            "ExcludedFileExtensions", `
            "GrooveBlockOption")
}           

function Export-TargetResource {
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

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
