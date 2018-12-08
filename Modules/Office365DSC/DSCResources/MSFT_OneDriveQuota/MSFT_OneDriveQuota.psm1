function Get-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $OneDriveStorageQuota,
      
        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    
    $nullReturn = @{
        OneDriveStorageQuota = $null
    }

    try {
        Write-Verbose -Message "Getting OneDrive quoata size for tenant"
        $tenant = Get-SPOTenant
        if (!$tenant) {
            Write-Verbose "Failed to get Tenant information"
            return $nullReturn
        }
        Write-Verbose "Storage setting for tenant currently $($tenant.OneDriveStorageQuota)"
        return @{
            OneDriveStorageQuota = $tenant.OneDriveStorageQuota
        }
    }
    catch {
        Write-Verbose "Failed to get Tenant information."
        return $nullReturn
    }
}

function Set-TargetResource {
    [CmdletBinding()]
    param
    (   
        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $OneDriveStorageQuota,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("CentralAdminUrl")
    $CurrentParameters.Remove("GlobalAdminAccount")

    Set-SPOTenant -OneDriveStorageQuota $OneDriveStorageQuota
    Write-Verbose -Message "Setting OneDrive storage quoata to $OneDriveStorageQuota"
     

}

function Test-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $OneDriveStorageQuota,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing OneDrive quota $OneDriveStorageQuota"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("OneDriveStorageQuota")
}

function Export-TargetResource {
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $OneDriveStorageQuota,
 
        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    Test-SPOServiceConnection -GlobalAdminAccount $GlobalAdminAccount -SPOCentralAdminUrl $CentralAdminUrl
    $result = Get-TargetResource @PSBoundParameters
    $content = "OneDriveQuota " + (New-GUID).ToString() + "`r`n"
    $content += "{`r`n"
    $content += Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += "}`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
