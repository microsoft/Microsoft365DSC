function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String[]]
        $PermissionLevels,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        [System.String]
        $ApplicationSecret,

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

    Write-Verbose -Message "Getting SPOSiteGroups for {$Url}"
    $ConnectionMode = New-M365DSCConnection -Workload 'PNP' `
        -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    try
    {
        #checking if the site actually exists
        try
        {
            $site = Get-PnPTenantSite $Url
        }
        catch
        {
            $Message = "The specified site collection doesn't exist."
            New-M365DSCLogEntry -Error $_ -Message $Message
            throw $Message
            return $nullReturn
        }
        try
        {
            $ConnectionMode = New-M365DSCConnection -Workload 'PNP' `
                -InboundParameters $PSBoundParameters `
                -Url $Url
            $siteGroup = Get-PnPGroup -Identity $Identity `
                -ErrorAction Stop
        }
        catch
        {
            if ($Error[0].Exception.Message -eq "Group cannot be found.")
            {
                Write-Verbose -Message "Site group $($Identity) could not be found on site $($Url)"

            }
        }
        if ($null -eq $siteGroup)
        {
            return $nullReturn
        }

        try
        {
            $sitePermissions = Get-PnPGroupPermissions -Identity $Identity `
                -ErrorAction Stop
        }
        catch
        {
            if ($_.Exception -like '*Access denied*')
            {
                Write-Warning -Message "The specified account does not have access to the permissions list"
                return $nullReturn
            }
        }
        $permissions = @()
        foreach ($entry in $sitePermissions.Name)
        {
            $permissions += $entry.ToString()
        }
        return @{
            Url                   = $Url
            Identity              = $siteGroup.Title
            Owner                 = $siteGroup.Owner.LoginName
            PermissionLevels      = [array]$permissions
            Credential    = $Credential
            Ensure                = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String[]]
        $PermissionLevels,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        [System.String]
        $ApplicationSecret,

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

    Write-Verbose -Message "Setting SPOSiteGroups for {$Url}"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $ConnectionMode = New-M365DSCConnection -Workload 'PNP' -InboundParameters $PSBoundParameters `
        -ErrorAction SilentlyContinue

    $currentValues = Get-TargetResource @PSBoundParameters
    $IsNew = $false
    if ($Ensure -eq "Present" -and $currentValues.Ensure -eq "Absent")
    {
        $SiteGroupSettings = @{
            Title = $Identity
            Owner = $Owner
        }
        Write-Verbose -Message "Site group $Identity does not exist, creating it."
        New-PnPGroup @SiteGroupSettings
        $IsNew = $true
    }
    if (($Ensure -eq "Present" -and $currentValues.Ensure -eq "Present") -or $IsNew)
    {
        $RefferenceObjectRoles = $PermissionLevels
        $DifferenceObjectRoles = $currentValues.PermissionLevels
        $compareOutput = $null
        if ($null -ne $DifferenceObjectRoles)
        {
            $compareOutput = Compare-Object -ReferenceObject $RefferenceObjectRoles -DifferenceObject $DifferenceObjectRoles
        }

        $PermissionLevelsToAdd = @()
        $PermissionLevelsToRemove = @()
        foreach ($entry in $compareOutput)
        {
            if ($entry.SideIndicator -eq "<=")
            {
                Write-Verbose -Message "Permissionlevels to add: $($entry.InputObject)"
                $PermissionLevelsToAdd += $entry.InputObject
            }
            else
            {
                Write-Verbose -Message "Permissionlevels to remove: $($entry.InputObject)"
                $PermissionLevelsToRemove += $entry.InputObject
            }
        }
        if ($PermissionLevelsToAdd.Count -eq 0 -and $PermissionLevelsToRemove.Count -ne 0)
        {
            Write-Verbose -Message "Need to remove Permissions $PermissionLevelsToRemove"
            $SiteGroupSettings = @{
                Identity = $Identity
                Owner    = $Owner
            }
            Set-PnPGroup @SiteGroupSettings

            Set-PnPGroupPermissions -Identity $Identity -RemoveRole $PermissionLevelsToRemove
        }
        elseif ($PermissionLevelsToRemove.Count -eq 0 -and $PermissionLevelsToAdd.Count -ne 0)
        {
            Write-Verbose -Message "Need to add Permissions $PermissionLevelsToAdd"
            $SiteGroupSettings = @{
                Identity = $Identity
                Owner    = $Owner
            }
            Write-Verbose -Message "Setting PnP Group with Identity {$Identity} and Owner {$Owner}"
            Set-PnPGroup @SiteGroupSettings

            Write-Verbose -Message "Setting PnP Group Permissions Identity {$Identity} AddRole {$PermissionLevelsToAdd}"
            Set-PnPGroupPermissions -Identity $Identity -AddRole $PermissionLevelsToAdd
        }
        elseif ($PermissionLevelsToAdd.Count -eq 0 -and $PermissionLevelsToRemove.Count -eq 0)
        {
            if (($Identity -eq $currentValues.Identity) -and ($Owner -eq $currentlValues.Owner))
            {
                Write-Verbose -Message "All values are configured as desired"
            }
            else
            {
                Write-Verbose -Message "Updating Group"
                $SiteGroupSettings = @{
                    Identity = $Identity
                    Owner    = $Owner
                }
                Set-PnPGroup @SiteGroupSettings
            }
        }
        else
        {
            Write-Verbose -Message "Updating Group Permissions Add {$PermissionLevelsToAdd} Remove {$PermissionLevelsToRemove}"
            $SiteGroupSettings = @{
                Identity = $Identity
                Owner    = $Owner
            }
            Set-PnPGroup @SiteGroupSettings

            Set-PnPGroupPermissions -Identity $Identity -AddRole $PermissionLevelsToAdd -RemoveRole $PermissionLevelsToRemove
        }

    }
    elseif ($Ensure -eq "Absent" -and $currentValues.Ensure -eq "Present")
    {
        Write-Verbose -Message "Removing Group $Identity"
        $SiteGroupSettings = @{
            Identity = $Identity
        }
        Write-Verbose "Removing SPOSiteGroup $Identity"
        Remove-PnPGroup @SiteGroupSettings
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String[]]
        $PermissionLevels,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        [System.String]
        $ApplicationSecret,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing SPOSiteGroups for {$Url}"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove("ApplicationId") | Out-Null
    $ValuesToCheck.Remove("TenantId") | Out-Null
    $ValuesToCheck.Remove("CertificatePath") | Out-Null
    $ValuesToCheck.Remove("CertificatePassword") | Out-Null
    $ValuesToCheck.Remove("CertificateThumbprint") | Out-Null
    $ValuesToCheck.Remove("ApplicationSecret") | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

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
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

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

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'PNP' -InboundParameters $PSBoundParameters `
            -ErrorAction SilentlyContinue

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

        #Loop through all sites
        #for each site loop through all site groups and retrieve parameters
        $sites = Get-PnPTenantSite -ErrorAction Stop

        $i = 1

        $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
        if ($null -ne $Credential -and $Credential.UserName.Contains("@"))
        {
            $organization = $Credential.UserName.Split("@")[1]

            if ($organization.IndexOf(".") -gt 0)
            {
                $principal = $organization.Split(".")[0]
            }
        }
        else
        {
            $organization = $TenantId
            $principal = $organization.Split(".")[0]
        }

        $dscContent = ""
        Write-Host "`r`n" -NoNewline
        foreach ($site in $sites)
        {
            Write-Host "    |---[$i/$($sites.Length)] SPOSite groups for {$($site.Url)}"
            $siteGroups = $null
            try
            {

                $ConnectionMode = New-M365DSCConnection -Workload 'PNP' `
                    -InboundParameters $PSBoundParameters `
                    -Url $site.Url
                $siteGroups = Get-PnPGroup -ErrorAction Stop
            }
            catch
            {
                Write-Warning -Message "Could not retrieve sitegroups for site $($site.Url): $($_.Exception.Message)"
            }

            $j = 1
            foreach ($siteGroup in $siteGroups)
            {
                Write-Host "        |---[$j/$($siteGroups.Length)] $($siteGroup.Title)" -NoNewline
                try
                {
                    [array]$sitePerm = Get-PnPGroupPermissions -Identity $siteGroup.Title -ErrorAction Stop
                }
                catch
                {
                    Write-Warning -Message "The specified account does not have access to the permissions list for {$($siteGroup.Title)}"
                    break
                }
                $Params = @{
                    Url                   = $site.Url
                    Identity              = $siteGroup.Title
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    ApplicationSecret     = $ApplicationSecret
                    CertificatePassword   = $CertificatePassword
                    CertificatePath       = $CertificatePath
                    CertificateThumbprint = $CertificateThumbprint
                    Credential    = $Credential
                }
                try
                {
                    $Results = Get-TargetResource @Params
                    if ($Results.Ensure -eq 'Present')
                    {
                        $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                            -Results $Results
                        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                            -ConnectionMode $ConnectionMode `
                            -ModulePath $PSScriptRoot `
                            -Results $Results `
                            -Credential $Credential

                        # Make the Url parameterized
                        if ($currentDSCBlock.ToLower().Contains($organization.ToLower()) -or `
                                $currentDSCBlock.ToLower().Contains($principal.ToLower()))
                        {
                            $currentDSCBlock = $currentDSCBlock -ireplace [regex]::Escape('https://' + $principal + '.sharepoint.com/'), "https://`$(`$OrganizationName.Split('.')[0]).sharepoint.com/"
                            $currentDSCBlock = $currentDSCBlock -ireplace [regex]::Escape('https://' + $principal + '-my.sharepoint.com/'), "https://`$(`$OrganizationName.Split('.')[0])-my.sharepoint.com/"
                            $currentDSCBlock = $currentDSCBlock -ireplace [regex]::Escape("@" + $organization), "@`$(`$OrganizationName)"
                        }
                        $dscContent += $currentDSCBlock

                        Save-M365DSCPartialExport -Content $currentDSCBlock `
                            -FileName $Global:PartialExportFileName
                    }
                }
                catch
                {
                    Write-Verbose -Message "There was an issue retrieving the SiteGroups for $($Url)"
                }
                $j++
                Write-Host $Global:M365DSCEmojiGreenCheckmark
            }

            $i++
        }

        if ($i -eq 1)
        {
            Write-Host ""
        }

        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX
        try
        {
            Write-Warning -Message "Cannot access {$($siteGroup.Title)}"

            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
