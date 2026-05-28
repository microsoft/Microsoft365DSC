Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SPOStorageEntity'

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
        [ValidateSet('Tenant', 'Site')]
        [System.String]
        $EntityScope = 'Tenant',

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteUrl,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration for SPO Storage Entity for $Key"

    try
    {
        if ($null -eq $Script:exportedInstance)
        {
            $ConnectionMode = New-M365DSCConnection -Workload 'PNP' `
                -InboundParameters $PSBoundParameters `
                -Url $SiteUrl

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullReturn = $PSBoundParameters
            $nullReturn.Ensure = 'Absent'

            Write-Verbose -Message "Getting storage entity $Key"
            $entityStorageParms = @{ }
            $entityStorageParms.Add('Key', $Key)

            if ($null -ne $EntityScope -and '' -ne $EntityScope)
            {
                $entityStorageParms.Add('Scope', $EntityScope)
            }

            $Entity = Get-PnPStorageEntity @entityStorageParms -ErrorAction SilentlyContinue
            ## Get-PnPStorageEntity seems to not return $null when not found
            ## so checking key
            if ($null -eq $Entity.Key)
            {
                Write-Verbose -Message "No storage entity found for $Key"
                return $nullReturn
            }
        }
        else
        {
            $Entity = $Script:exportedInstance
        }

        Write-Verbose -Message "Found storage entity $($Entity.Key)"

        return @{
            Key                   = $Entity.Key
            Value                 = $Entity.Value
            EntityScope           = $EntityScope
            Description           = $Entity.Description
            Comment               = $Entity.Comment
            Ensure                = 'Present'
            SiteUrl               = $SiteUrl
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
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
        [ValidateSet('Tenant', 'Site')]
        [System.String]
        $EntityScope = 'Tenant',

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteUrl,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration for SPO Storage Entity for $Key"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $curStorageEntry = Get-TargetResource @PSBoundParameters

    $CurrentParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $CurrentParameters.Remove('SiteUrl') | Out-Null
    $CurrentParameters.Remove('EntityScope') | Out-Null
    $CurrentParameters.Add('Scope', $EntityScope)

    if (($Ensure -eq 'Absent' -and $curStorageEntry.Ensure -eq 'Present'))
    {
        Write-Verbose -Message "Removing storage entity $Key"
        Remove-PnPStorageEntity -Key $Key
    }
    elseif ($Ensure -eq 'Present')
    {
        try
        {
            Write-Verbose -Message "Adding new storage entity $Key"
            Set-PnPStorageEntity @CurrentParameters
        }
        catch
        {
            if ($_.Exception -like '*Access denied*')
            {
                throw "It appears that the account doesn't have access to create an SPO Storage " + `
                    'Entity or that an App Catalog was not created for the specified location'
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
        [ValidateSet('Tenant', 'Site')]
        [System.String]
        $EntityScope = 'Tenant',

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteUrl,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        @compareParameters
    return $result
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'PNP' `
            -InboundParameters $PSBoundParameters

        #Ensure the proper dependencies are installed in the current environment.
        Confirm-M365DSCDependencies

        #region Telemetry
        $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
        $CommandName = $MyInvocation.MyCommand
        $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
            -CommandName $CommandName `
            -Parameters $PSBoundParameters
        Add-M365DSCTelemetryEvent -Data $data
        #endregion

        $storageEntities = Get-PnPStorageEntity -ErrorAction SilentlyContinue

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        $organization = ''
        $principal = '' # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
        $organization = Get-M365DSCOrganization -Credential $Credential -TenantId $Tenantid
        if ($organization.IndexOf('.') -gt 0)
        {
            $principal = $organization.Split('.')[0]
        }

        # Obtain central administration url from a User Principal Name
        if ($ConnectionMode -eq 'Credential')
        {
            $centralAdminUrl = Get-SPOAdministrationUrl -Credential $Credential
        }
        else
        {
            $centralAdminUrl = "https://$principal-admin.sharepoint.com"
        }

        if ($storageEntities.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }

        foreach ($storageEntity in $storageEntities)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $Params = @{
                Credential            = $Credential
                Key                   = $storageEntity.Key
                SiteUrl               = $centralAdminUrl
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }
            Write-M365DSCHost -Message "    |---[$i/$($storageEntities.Length)] $($storageEntity.Key)" -DeferWrite

            $Script:exportedInstance = $storageEntity
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            # Make the Url parameterized
            if ($currentDSCBlock.ToLower().Contains($organization.ToLower()) -or `
                    $currentDSCBlock.ToLower().Contains($principal.ToLower()))
            {
                $currentDSCBlock = $currentDSCBlock -ireplace [regex]::Escape('https://' + $principal + '.sharepoint.com'), "https://`$(`$OrganizationName.Split('.')[0]).sharepoint.com"
                $currentDSCBlock = $currentDSCBlock -ireplace [regex]::Escape('https://' + $principal + '-admin.sharepoint.com'), "https://`$(`$OrganizationName.Split('.')[0])-admin.sharepoint.com"
            }
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName

            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }

        return $dscContent.ToString()
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        ExcludedProperties = @('SiteUrl')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
