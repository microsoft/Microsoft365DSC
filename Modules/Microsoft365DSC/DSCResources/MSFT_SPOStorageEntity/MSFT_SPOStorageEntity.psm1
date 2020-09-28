function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet("Tenant", "Site")]
        [System.String]
        $EntityScope = "Tenant",

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteUrl,

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

    Write-Verbose -Message "Getting configuration for SPO Storage Entity for $Key"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters `
        -Url $SiteUrl

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        Write-Verbose -Message "Getting storage entity $Key"

        $entityStorageParms = @{ }
        $entityStorageParms.Add("Key", $Key)

        if ($null -ne $EntityScope -and "" -ne $EntityScope)
        {
            $entityStorageParms.Add("Scope", $EntityScope)
        }

        $Entity = Get-PnPStorageEntity @entityStorageParms -ErrorAction SilentlyContinue
        ## Get-PnPStorageEntity seems to not return $null when not found
        ## so checking key
        if ($null -eq $Entity.Key)
        {
            Write-Verbose -Message "No storage entity found for $Key"
            return $nullReturn
        }

        Write-Verbose -Message "Found storage entity $($Entity.Key)"

        return @{
            Key                   = $Entity.Key
            Value                 = $Entity.Value
            EntityScope           = $EntityScope
            Description           = $Entity.Description
            Comment               = $Entity.Comment
            Ensure                = "Present"
            SiteUrl               = $SiteUrl
            GlobalAdminAccount    = $GlobalAdminAccount
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
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
        [System.String]
        $Key,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet("Tenant", "Site")]
        [System.String]
        $EntityScope = "Tenant",

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteUrl,

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

    Write-Verbose -Message "Setting configuration for SPO Storage Entity for $Key"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters `
        -Url $SiteUrl

    $curStorageEntry = Get-TargetResource @PSBoundParameters

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("SiteUrl") | Out-Null
    $CurrentParameters.Remove("GlobalAdminAccount") | Out-Null
    $CurrentParameters.Remove("Ensure") | Out-Null
    $CurrentParameters.Remove("EntityScope") | Out-Null
    $CurrentParameters.Remove("ApplicationId") | Out-Null
    $CurrentParameters.Remove("TenantId") | Out-Null
    $CurrentParameters.Remove("CertificatePath") | Out-Null
    $CurrentParameters.Remove("CertificatePassword") | Out-Null
    $CurrentParameters.Remove("CertificateThumbprint") | Out-Null
    $CurrentParameters.Add("Scope", $EntityScope)

    if (($Ensure -eq "Absent" -and $curStorageEntry.Ensure -eq "Present"))
    {
        Write-Verbose -Message "Removing storage entity $Key"
        Remove-PnPStorageEntity -Key $Key
    }
    elseif ($Ensure -eq "Present")
    {
        try
        {
            Write-Verbose -Message "Adding new storage entity $Key"
            Set-PnPStorageEntity @CurrentParameters
        }
        catch
        {
            if ($_.Exception -like "*Access denied*")
            {
                throw "It appears that the account doesn't have access to create an SPO Storage " + `
                    "Entity or that an App Catalog was not created for the specified location"
            }
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
        $Key,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet("Tenant", "Site")]
        [System.String]
        $EntityScope = "Tenant",

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteUrl,

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

    Write-Verbose -Message "Testing configuration for SPO Storage Entity for $Key"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Key", `
            "Value", `
            "Key", `
            "Comment", `
            "Description", `
            "EntityScope", `
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

    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' `
        -InboundParameters $PSBoundParameters

    try
    {
        $storageEntities = Get-PnPStorageEntity -ErrorAction SilentlyContinue

        $i = 1
        $dscContent = ''
        $organization = ""
        $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
        $organization = Get-M365DSCOrganization -GlobalAdminAccount $GlobalAdminAccount -TenantId $Tenantid
        if ($organization.IndexOf(".") -gt 0)
        {
            $principal = $organization.Split(".")[0]
        }

        # Obtain central administration url from a User Principal Name
        if ($ConnectionMode -eq 'Credential')
        {
            $centralAdminUrl = Get-SPOAdministrationUrl -GlobalAdminAccount $GlobalAdminAccount
        }
        else
        {
            $centralAdminUrl = "https://$principal-admin.sharepoint.com"
        }
        Write-Host "`r`n" -NoNewline
        foreach ($storageEntity in $storageEntities)
        {
            $Params = @{
                GlobalAdminAccount    = $GlobalAdminAccount
                Key                   = $storageEntity.Key
                SiteUrl               = $centralAdminUrl
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
                CertificateThumbprint = $CertificateThumbprint
            }
            Write-Host "    |---[$i/$($storageEntities.Length)] $($storageEntity.Key)" -NoNewline
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
            $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckmark
        }
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
