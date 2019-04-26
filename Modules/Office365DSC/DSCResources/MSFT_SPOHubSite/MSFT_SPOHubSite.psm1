function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $LogoUrl,

        [Parameter()]
        [System.Boolean]
        $RequiresJoinApproval,

        [Parameter()]
        [System.String[]]
        $AllowedToJoin,

        [Parameter()]
        [System.String]
        $SiteDesignId,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount

    $nullReturn = @{
        Url                  = $Url
        Title                = $null
        Description          = $null
        LogoUrl              = $null
        RequiresJoinApproval = $null
        AllowedToJoin        = $null
        SiteDesignId         = $null
        Ensure               = "Absent"
        CentralAdminUrl      = $CentralAdminUrl
        GlobalAdminAccount   = $GlobalAdminAccount
    }

    try
    {
        Write-Verbose -Message "Getting hub site collection $Url"
        $site = Get-SPOSite $Url
        if ($null -eq $site)
        {
            Write-Verbose "The specified Site Collection doesn't already exist."
            return $nullReturn
        }

        if ($site.IsHubSite -eq $false)
        {
            Write-Verbose "The specified Site Collection isn't a hub site."
            return $nullReturn
        }
        else
        {
            $hubSite = Get-SPOHubSite -Identity $site

            $principals = @()
            foreach ($permission in $hubSite.Permissions.PrincipalName)
            {
                $result = $permission.Split("|")
                if ($result[0].StartsWith("c") -eq $true)
                {
                    # Group permissions
                    $group = Get-MsolGroup -ObjectId $result[2]
                    $principals += $group.EmailAddress
                }
                else
                {
                    # User permissions
                    $principals += $result[2]
                }
            }

            if ($LogoUrl.StartsWith("http"))
            {
                $configuredLogo = $hubSite.LogoUrl
            }
            else
            {
                $configuredLogo = ([System.Uri]$hubSite.LogoUrl).AbsolutePath
            }

            $result = @{
                Url                  = $Url
                Title                = $hubSite.Title
                Description          = $hubSite.Description
                LogoUrl              = $configuredLogo
                RequiresJoinApproval = $hubSite.RequiresJoinApproval
                AllowedToJoin        = $principals
                SiteDesignId         = $hubSite.SiteDesignId
                Ensure               = "Present"
                CentralAdminUrl      = $CentralAdminUrl
                GlobalAdminAccount   = $GlobalAdminAccount
            }
            return $result
        }
    }
    catch
    {
        Write-Verbose "The specified Site Collection doesn't already exist."
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
        $Url,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $LogoUrl,

        [Parameter()]
        [System.Boolean]
        $RequiresJoinApproval,

        [Parameter()]
        [System.String[]]
        $AllowedToJoin,

        [Parameter()]
        [System.String]
        $SiteDesignId,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount

    try
    {
        Write-Verbose -Message "Setting hub site collection $Url"
        $site = Get-SPOSite $Url
    }
    catch
    {
        throw "The specified Site Collection doesn't already exist."
    }

    $currentValues = Get-TargetResource @PSBoundParameters

    if($Ensure -eq "Present" -and $currentValues.Ensure -eq "Absent")
    {
        Write-Verbose "Configuring site collection as Hub Site"
        Register-SPOHubSite -Site $site -Principals $AllowedToJoin | Out-Null
        $params = @{
            Identity = $site
        }

        if ($PSBoundParameters.ContainsKey("Title") -eq $true)
        {
            $params.Title = $Title
        }

        if ($PSBoundParameters.ContainsKey("Description") -eq $true)
        {
            $params.Description = $Description
        }

        if ($PSBoundParameters.ContainsKey("LogoUrl") -eq $true)
        {
            $params.LogoUrl = $LogoUrl
        }

        if ($PSBoundParameters.ContainsKey("RequiresJoinApproval") -eq $true)
        {
            $params.RequiresJoinApproval = $RequiresJoinApproval
        }

        if ($PSBoundParameters.ContainsKey("SiteDesignId") -eq $true)
        {
            $params.SiteDesignId = $SiteDesignId
        }

        if ($params.Count -ne 1)
        {
            Write-Verbose "Updating Hub Site properties"
            Set-SPOHubSite @params | Out-Null
        }
    }
    elseif ($Ensure -eq "Present" -and $currentValues.Ensure -eq "Present")
    {
        Write-Verbose "Updating Hub Site settings"
        $params = @{
            Identity = $site
        }

        if ($PSBoundParameters.ContainsKey("Title") -eq $true -and
            $currentValues.Title -ne $Title)
        {
            $params.Title = $Title
        }

        if ($PSBoundParameters.ContainsKey("Description") -eq $true -and
            $currentValues.Description -ne $Description)
        {
            $params.Description = $Description
        }

        if ($PSBoundParameters.ContainsKey("LogoUrl") -eq $true -and
            $currentValues.LogoUrl -ne $LogoUrl)
        {
            $params.LogoUrl = $LogoUrl
        }

        if ($PSBoundParameters.ContainsKey("RequiresJoinApproval") -eq $true -and
            $currentValues.RequiresJoinApproval -ne $RequiresJoinApproval)
        {
            $params.RequiresJoinApproval = $RequiresJoinApproval
        }

        if ($PSBoundParameters.ContainsKey("SiteDesignId") -eq $true -and
            $currentValues.SiteDesignId -ne $SiteDesignId)
        {
            $params.SiteDesignId = $SiteDesignId
        }

        if ($params.Count -ne 1)
        {
            Write-Verbose "Updating Hub Site properties"
            Set-SPOHubSite @params | Out-Null
        }

        $differences = Compare-Object -ReferenceObject $AllowedToJoin -DifferenceObject $currentValues.AllowedToJoin
        if ($null -ne $differences)
        {
            Write-Verbose "Updating Hub Site permissions"
            foreach ($item in $differences)
            {
                if ($item.SideIndicator -eq "<=")
                {
                    # Add item to principals
                    Grant-SPOHubSiteRights -Identity $site -Principals $item.InputObject -Rights Join | Out-Null
                }
                else
                {
                    # Remove item from principals
                    Revoke-SPOHubSiteRights -Identity $site -Principals $item.InputObject | Out-Null
                }
            }
        }
    }
    else
    {
        # Remove hub site
        Unregister-SPOHubSite -Identity $site -Force
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
        $Url,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $LogoUrl,

        [Parameter()]
        [System.Boolean]
        $RequiresJoinApproval,

        [Parameter()]
        [System.String[]]
        $AllowedToJoin,

        [Parameter()]
        [System.String]
        $SiteDesignId,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing hub site collection $Url"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    foreach ($value in $CurrentValues.GetEnumerator())
    {
        Write-Verbose "$($value.Key) = $($value.Value)"
    }
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                           -DesiredValues $PSBoundParameters `
                                           -ValuesToCheck @("Ensure", `
                                                            "Url", `
                                                            "Title", `
                                                            "Description", `
                                                            "LogoUrl", `
                                                            "RequiresJoinApproval", `
                                                            "AllowedToJoin", `
                                                            "SiteDesignId")
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result[1].GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        SPOHubSite " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result[1] -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
