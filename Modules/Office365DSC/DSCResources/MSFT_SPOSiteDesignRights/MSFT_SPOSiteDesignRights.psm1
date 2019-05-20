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

        [Parameter()]
        [ValidateSet("View", "None")]
        [System.String]
        $Rights,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration for SPO SiteDesignRights for $SiteDesignTitle"

    Test-PnPOnlineConnection -SiteUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $nullReturn = @{
        SiteDesignTitle    = $SiteDesignTitle
        UserPrincipals     = $UserPrincipals
        Rights             = $Rights
        Ensure             = "Absent"
        CentralAdminUrl    = $CentralAdminUrl
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
        CentralAdminUrl    = $CentralAdminUrl
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

        [Parameter()]
        [ValidateSet("View", "None")]
        [System.String]
        $Rights,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for SPO SiteDesignRights for $SiteDesignTitle"

    Test-PnPOnlineConnection -SiteUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

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

        [Parameter()]
        [ValidateSet("View", "None")]
        [System.String]
        $Rights,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for SPO SiteDesignRights for $SiteDesignTitle"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
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
        [System.String]
        $SiteDesignTitle,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Test-PnPOnlineConnection -SiteUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    $result = Get-TargetResource @PSBoundParameters

    $content = ""
    if ($result.Ensure -eq "Present")
    {
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        SPOSiteDesignRights " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
