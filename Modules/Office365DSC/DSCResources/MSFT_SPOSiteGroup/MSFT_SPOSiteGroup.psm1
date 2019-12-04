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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Owner,

        [Parameter(Mandatory = $true)]
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

    $nullReturn = @{
        Url                = $Url
        Identity           = $null
        Owner              = $null
        PermissionLevels    = $null
        GlobalAdminAccount = $GlobalAdminAccount
        Ensure             = "Absent"
    }

    try
    {
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform SharePointOnline `
                          -ErrorAction SilentlyContinue
        
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
            if($Error[0].Exception.Message -eq "Group cannot be found.")
            {
                write-verbose -Message "Site group $($Identity) could not be found on site $($Url)"
                #New-Office365DSCLogEntry -Error $_ -Message $Message
                
            }
            return $nullReturn
        }
        
        return @{
            Url                = $Url
            Identity           = $siteGroup.Title
            Owner              = $siteGroup.OwnerLoginName
            PermissionLevels   = $siteGroup.Roles
            GlobalAdminAccount = $GlobalAdminAccount
            Ensure             = "Present"
        }
    }
    catch
    {
        if ($error[0].Exception.Message -like "No connection available")
        {
            $Message = "Make sure that you are connected to SharePoint Online"
            New-Office365DSCLogEntry -Error $_ -Message $Message
            throw $Message
            
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Owner,

        [Parameter(Mandatory = $true)]
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


    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -Platform SharePointOnline `
                      -ErrorAction SilentlyContinue
    
                      
    try
    {
        $siteGroup = Get-SPOSiteGroup -Group $Identity -Site $Url
    }
    catch
    {
        if($Error[0].Exception.Message -eq "Group cannot be found.")
        {
            write-verbose -Message "Group $($Identity) does not exist on site $($url)... creating it"
            
            #New-Office365DSCLogEntry -Error $_ -Message $Message
        }
        $createGroup = $true
    }
    $currentValues = Get-TargetResource @PSBoundParameters

    if($Ensure -eq "Present" -and $currentValues.Ensure -eq "Absent")
    {
        if($createGroup -eq $true)
        {
            $SiteGroupSettings = @{
                Site = $Url
                Group = $Identity
                PermissionLevels = $PermissionLevels
            }
            New-SPOSiteGroup @SiteGroupSettings
        }
        else
        {
            $RefferenceObjectRoles = $PermissionLevels
            $DifferenceObjectRoles = $siteGroup.Roles
            $compareOutput = Compare-Object -ReferenceObject $RefferenceObjectRoles -DifferenceObject $DifferenceObjectRoles
            $PermissionLevelsToAdd = @()
            $PermissionLevelsToRemove = @()
            foreach($entry in $compareOutput)
            {
                if($entry.SideIndicator -eq "<=")
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
            $SiteGroupSettings = @{
                Site = $Url
                Identity = $Identity
                Owner = $Owner
                PermissionLevelsToAdd = $PermissionLevelsToAdd
                PermissionLevelsToRemove = $PermissionLevelsToRemove
            }
            Set-SPOSiteGroup @SiteGroupSettings
        }
    }
    else
    {
        $SiteGroupSettings = @{
            Site     = $Url
            Identity = $Identity
        }
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Owner,

        [Parameter(Mandatory = $true)]
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

    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                                  -DesiredValues $PSBoundParameters `
                                                  -ValuesToCheck @("Ensure", `
                                                                   "Url", `
                                                                   "Identity", `
                                                                   "Owner", `
                                                                   "PermissionLevels"
                                                )

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

    $InformationPreference = 'Continue'
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -Platform SharePointOnline `
                      -ErrorAction SilentlyContinue

    #Loop through all sites
    #for each site loop through all site groups and retrieve parameters
    $sites = Get-SPOSites -limit All

    $i = 1
    $content = ""
    foreach ($site in $sites)
    {
        Write-Information "    [$i/$($sites.Length)] SPOSite groups for {$($site.Url)}"
        $siteGroups = Get-SPOSiteGroup -Site $site.Url
        foreach($siteGroup in $siteGroups)
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
