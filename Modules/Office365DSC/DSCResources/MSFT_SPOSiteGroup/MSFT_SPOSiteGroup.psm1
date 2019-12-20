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
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting SPOSiteGroups for {$Url}"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = @{
        Url                = $Url
        Identity           = $null
        Owner              = $null
        PermissionLevels   = $null
        GlobalAdminAccount = $GlobalAdminAccount
        Ensure             = "Absent"
    }

    try
    {
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform SharePointOnline `
                          -ErrorAction SilentlyContinue
    }
    catch
    {
        if ($error[0].Exception.Message -like "No connection available")
        {
            $Message = "Make sure that you are connected to SharePoint Online"
            New-Office365DSCLogEntry -Error $_ -Message $Message
            throw $Message
            return $nullReturn
        }
        
    }
    #checking if the site actually exists
    try
    {
        $site = Get-SPOSite $Url
    }
    catch
    {
        if ($null -eq $site)
        {
            $Message = "The specified site collection doesn't exist."
            New-Office365DSCLogEntry -Error $_ -Message $Message
            throw $Message
            return $nullReturn
        }
    }
    try
    {
        $siteGroup = Get-SPOSiteGroup -Site $Url -Group $Identity
    }
    catch
    {
        if ($Error[0].Exception.Message -eq "Group cannot be found.")
        {
            write-verbose -Message "Site group $($Identity) could not be found on site $($Url)"
            
        }
    }
    if ($null -eq $siteGroup)
    {
        return $nullReturn
    }
    else
    {
        return @{
            Url                = $Url
            Identity           = $siteGroup.Title
            Owner              = $siteGroup.OwnerLoginName
            PermissionLevels   = $siteGroup.Roles
            GlobalAdminAccount = $GlobalAdminAccount
            Ensure             = "Present"
        }
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
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting SPOSiteGroups for {$Url}"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -Platform SharePointOnline `
                      -ErrorAction SilentlyContinue

    $currentValues = Get-TargetResource @PSBoundParameters
    if ($Ensure -eq "Present"-and $currentValues.Ensure -eq "Absent")
    {
        $SiteGroupSettings = @{
            Site = $Url
            Group = $Identity
            PermissionLevels = $PermissionLevels
        }
        Write-Verbose -Message "Site group $($Identity) does not exist, creating it."
        New-SPOSiteGroup @SiteGroupSettings
    }
    elseif ($Ensure -eq "Present" -and $currentValues.Ensure -eq "Present")
    {
        $RefferenceObjectRoles = $PermissionLevels
        $DifferenceObjectRoles = $currentValues.PermissionLevels
        $compareOutput = Compare-Object -ReferenceObject $RefferenceObjectRoles -DifferenceObject $DifferenceObjectRoles
        $PermissionLevelsToAdd = @()
        $PermissionLevelsToRemove = @()
        foreach ($entry in $compareOutput)
        {
            if ($entry.SideIndicator -eq "<=")
            {
                Write-Verbose -Message "Permissionlevels to add: $($entry.InputObject)"
                $PermissionLevelsToAdd +=$entry.InputObject
            }
            else
            {
                Write-Verbose -Message "Permissionlevels to remove: $($entry.InputObject)"
                $PermissionLevelsToRemove += $entry.InputObject
            }
        }
        if ($PermissionLevelsToAdd.Count -eq 0 -and $PermissionLevelsToRemove.Count -ne 0)
        {
            $SiteGroupSettings = @{
                Site                     = $Url
                Identity                 = $Identity
                Owner                    = $Owner
                PermissionLevelsToRemove = $PermissionLevelsToRemove
            }
            Set-SPOSiteGroup @SiteGroupSettings
        }
        elseif ($PermissionLevelsToRemove.Count -eq 0 -and $PermissionLevelsToAdd.Count -ne 0)
        {
            $SiteGroupSettings = @{
                Site                     = $Url
                Identity                 = $Identity
                Owner                    = $Owner
                PermissionLevelsToAdd    = $PermissionLevelsToAdd
            }
            Set-SPOSiteGroup @SiteGroupSettings
        }
        elseif ($PermissionLevelsToAdd.Count -eq 0 -and $PermissionLevelsToRemove.Count -eq 0)
        {
            if (($Identity -eq $currentValues.Identity)-and ($Owner -eq $currentlValues.Owner))
            {
                Write-Verbose -Message "All values are configured as desired"
            }
            else
            {
                $SiteGroupSettings = @{
                    Site                     = $Url
                    Identity                 = $Identity
                    Owner                    = $Owner
                }
                Set-SPOSiteGroup @SiteGroupSettings
            }
        }
        else
        {
            $SiteGroupSettings = @{
                Site                     = $Url
                Identity                 = $Identity
                Owner                    = $Owner
                PermissionLevelsToAdd    = $PermissionLevelsToAdd
                PermissionLevelsToRemove = $PermissionLevelsToRemove
            }
            Set-SPOSiteGroup @SiteGroupSettings
        }
        
    }
    elseif ($Ensure -eq "Absent" -and $currentValues.Ensure -eq "Present")
    {
        $SiteGroupSettings = @{
            Site     = $Url
            Identity = $Identity
        }
        Write-Verbose "Removing SPOSiteGroup $($Identity)"
        Remove-SPOSiteGroup @SiteGroupSettings
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
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing SPOSiteGroups for {$Url}"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
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
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    $InformationPreference = 'Continue'
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -Platform SharePointOnline `
                      -ErrorAction SilentlyContinue

    #Loop through all sites
    #for each site loop through all site groups and retrieve parameters
    $sites = Get-SPOSite -limit All

    $i = 1
    $content = ""
    foreach ($site in $sites)
    {
        Write-Information "    [$i/$($sites.Length)] SPOSite groups for {$($site.Url)}"
        try
        {
            $siteGroups = Get-SPOSiteGroup -Site $site.Url
        }
        catch
        {
            $message = $Error[0].Exception.Message   
            Write-Warning -Message $message 
        }
        foreach ($siteGroup in $siteGroups)
        {
            $params = @{
                Url                = $site.Url
                Identity           = $siteGroup.Title
                Owner              = $siteGroup.OwnerLoginName
                PermissionLevels   = $siteGroup.Roles
                GlobalAdminAccount = $GlobalAdminAccount
            }
        }
        try
        {
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        SPOSiteGroups " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"
        }
        catch
        {
            Write-Verbose "There was an issue retrieving the SiteGroups for $Url"
        }
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
