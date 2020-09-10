function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteDesignTitle,

        [Parameter()]
        [System.String[]]
        $UserPrincipals,

        [Parameter(Mandatory = $true)]
        [ValidateSet("View", "None")]
        [System.String]
        $Rights,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration for SPO SiteDesignRights for $SiteDesignTitle"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $nullReturn = @{
        SiteDesignTitle    = $SiteDesignTitle
        UserPrincipals     = $UserPrincipals
        Rights             = $Rights
        Ensure             = "Absent"
        GlobalAdminAccount = $GlobalAdminAccount
    }

    Write-Verbose -Message "Getting Site Design Rights for $SiteDesignTitle"

    $siteDesign = Get-PnPSiteDesign -Identity $SiteDesignTitle
    if ($null -eq $siteDesign)
    {
        throw "Site Design with title $SiteDesignTitle doesn't exist in tenant"
    }

    Write-Verbose -Message "Site Design ID is $($siteDesign.Id)"

    $siteDesignRights = Get-PnPSiteDesignRights -Identity $siteDesign.Id -ErrorAction SilentlyContinue | `
        Where-Object -FilterScript { $_.Rights -eq $Rights }

    if ($null -eq $siteDesignRights)
    {
        Write-Verbose -Message "No Site Design Rights exist for site design $SiteDesignTitle."
        return $nullReturn
    }

    $curUserPrincipals = @()

    foreach ($siteDesignRight in $siteDesignRights)
    {
        $curUserPrincipals += $siteDesignRight.PrincipalName.split("|")[2]
    }

    Write-Verbose -Message "Site Design Rights User Principals = $($curUserPrincipals)"
    return @{
        SiteDesignTitle    = $SiteDesignTitle
        UserPrincipals     = $curUserPrincipals
        Rights             = $Rights
        Ensure             = "Present"
        GlobalAdminAccount = $GlobalAdminAccount
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteDesignTitle,

        [Parameter()]
        [System.String[]]
        $UserPrincipals,

        [Parameter(Mandatory = $true)]
        [ValidateSet("View", "None")]
        [System.String]
        $Rights,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for SPO SiteDesignRights for $SiteDesignTitle"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $cursiteDesign = Get-PnPSiteDesign -Identity $SiteDesignTitle
    if ($null -eq $cursiteDesign)
    {
        throw "Site Design with title $SiteDesignTitle doesn't exist in tenant"
    }

    $currentSiteDesignRights = Get-TargetResource @PSBoundParameters
    $CurrentParameters = $PSBoundParameters

    if ($currentSiteDesignRights.Ensure -eq "Present")
    {
        $difference = Compare-Object -ReferenceObject $currentSiteDesignRights.UserPrincipals -DifferenceObject $CurrentParameters.UserPrincipals

        if ($difference.InputObject)
        {
            Write-Verbose -Message "Detected a difference in the current design rights of user principals and the desired one"
            $principalsToRemove = @()
            $principalsToAdd = @()
            foreach ($diff in $difference)
            {
                if ($diff.SideIndicator -eq "<=")
                {
                    $principalsToRemove += $diff.InputObject
                }
                elseif ($diff.SideIndicator -eq "=>")
                {
                    $principalsToAdd += $diff.InputObject
                }
            }

            if ($principalsToAdd.Count -gt 0 -and $Ensure -eq "Present")
            {
                Write-Verbose -Message "Granting SiteDesign rights on site design $SiteDesignTitle"
                Grant-PnPSiteDesignRights -Identity $cursiteDesign.Id -Principals $principalsToAdd -Rights $Rights
            }

            if ($principalsToRemove.Count -gt 0)
            {
                Write-Verbose -Message "Revoking SiteDesign rights on $principalsToRemove for site design $SiteDesignTitle with Id $($cursiteDesign.Id)"
                Revoke-PnPSiteDesignRights -Identity $cursiteDesign.Id -Principals $principalsToRemove
            }
        }
    }
    if ($Ensure -eq "Absent")
    {
        Write-Verbose -Message "Revoking SiteDesign rights on  $UserPrincipals for site design $SiteDesignTitle"
        Revoke-PnPSiteDesignRights -Identity $cursiteDesign.Id -Principals $UserPrincipals
    }

    #No site design rights currently exist so add them
    If ($currentSiteDesignRights.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Granting SiteDesign rights on site design $SiteDesignTitle"
        Grant-PnPSiteDesignRights -Identity $cursiteDesign.Id -Principals $UserPrincipals -Rights $Rights
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
        $SiteDesignTitle,

        [Parameter()]
        [System.String[]]
        $UserPrincipals,

        [Parameter(Mandatory = $true)]
        [ValidateSet("View", "None")]
        [System.String]
        $Rights,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for SPO SiteDesignRights for $SiteDesignTitle"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("UserPrincipals", `
            "Rights", `
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
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $siteDesigns = Get-PnPSiteDesign

    $content = ""
    $i = 1
    foreach ($siteDesign in $siteDesigns)
    {
        Write-Information "    - [$i/$($siteDesigns.Length)] $($siteDesign.Title)"
        $params = @{
            SiteDesignTitle    = $siteDesign.Title
            Rights             = "View"
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $content = ""
        if ($result.Ensure -eq "Present")
        {
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        SPOSiteDesignRights " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"
        }

        $params = @{
            SiteDesignTitle    = $siteDesign.Title
            Rights             = "None"
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        if ($result.Ensure -eq "Present")
        {
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        SPOSiteDesignRights " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"
        }
        $i++
    }

    return $content
}

Export-ModuleMember -Function *-TargetResource
