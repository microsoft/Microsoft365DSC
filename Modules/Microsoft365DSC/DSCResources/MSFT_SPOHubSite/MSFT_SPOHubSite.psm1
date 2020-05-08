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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration for hub site collection $Url"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform AzureAD

    $nullReturn = @{
        Url                  = $Url
        Title                = $null
        Description          = $null
        LogoUrl              = $null
        RequiresJoinApproval = $null
        AllowedToJoin        = $null
        SiteDesignId         = $null
        Ensure               = "Absent"
        GlobalAdminAccount   = $GlobalAdminAccount
    }

    try
    {
        Write-Verbose -Message "Getting hub site collection $Url"
        $site = Get-PnPTenantSite -Url $Url
        if ($null -eq $site)
        {
            Write-Verbose -Message "The specified Site Collection doesn't already exist."
            return $nullReturn
        }

        if ($site.IsHubSite -eq $false)
        {
            Write-Verbose -Message "The specified Site Collection isn't a hub site."
            return $nullReturn
        }
        else
        {
            $hubSite = Get-PnPHubSite -Identity $Url

            $principals = @()
            foreach ($permission in $hubSite.Permissions.PrincipalName)
            {
                $result = $permission.Split("|")
                if ($result[0].StartsWith("c") -eq $true)
                {
                    # Group permissions
                    $group = Get-AzureADGroup -ObjectId $result[2]

                    if ($null -eq $group.EmailAddress)
                    {
                        $principal = $group.DisplayName
                    }
                    else
                    {
                        $principal = $group.EmailAddress
                    }
                    $principals += $principal
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
                GlobalAdminAccount   = $GlobalAdminAccount
            }
            return $result
        }
    }
    catch
    {
        Write-Verbose -Message "The specified Site Collection doesn't already exist."
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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for hub site collection $Url"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform AzureAD

    try
    {
        Write-Verbose -Message "Setting hub site collection $Url"
        $site = Get-PnPTenantSite $Url
    }
    catch
    {
        $Message = "The specified Site Collection {$Url} for SPOHubSite doesn't already exist."
        New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
        throw $Message
    }

    $currentValues = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq "Present" -and $currentValues.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Configuring site collection as Hub Site"
        Register-PnPHubSite -Site $site.Url | Out-Null

        $params = @{
            Identity = $site.Url
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
            Write-Verbose -Message "Updating Hub Site properties"
            Set-PnPHubSite @params | Out-Null
        }

        if ($PSBoundParameters.ContainsKey("AllowedToJoin") -eq $true)
        {
            $groups = Get-AzureADGroup
            $regex = "^[a-zA-Z0-9.!£#$%&'^_`{}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$"

            Write-Verbose -Message "Validating AllowedToJoin principals"
            foreach ($principal in $AllowedToJoin)
            {
                Write-Verbose -Message "Processing $principal"
                if ($principal -notmatch $regex)
                {
                    $group = $groups | Where-Object -FilterScript {
                        $_.DisplayName -eq $principal
                    }

                    if ($group.Count -ne 1)
                    {
                        throw "Error for principal $principal. Number of occurences: $($group.Count)"
                    }
                }
            }
            Grant-PnPHubSiteRights -Identity $site.Url -Principals $AllowedToJoin -Rights Join | Out-Null
        }
    }
    elseif ($Ensure -eq "Present" -and $currentValues.Ensure -eq "Present")
    {
        Write-Verbose -Message "Updating Hub Site settings"
        $params = @{
            Identity = $site.Url
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
            Write-Verbose -Message "Updating Hub Site properties"
            Set-PnPHubSite @params | Out-Null
        }

        if ($PSBoundParameters.ContainsKey("AllowedToJoin") -eq $true)
        {
            if ($null -eq $currentValues.AllowedToJoin)
            {
                $differences = Compare-Object -ReferenceObject $AllowedToJoin -DifferenceObject @()
            }
            else
            {
                $differences = Compare-Object -ReferenceObject $AllowedToJoin -DifferenceObject $currentValues.AllowedToJoin
            }

            if ($null -ne $differences)
            {
                $groups = Get-AzureADGroup
                $regex = "^[a-zA-Z0-9.!£#$%&'^_`{}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$"

                Write-Verbose -Message "Updating Hub Site permissions"
                foreach ($item in $differences)
                {
                    if ($item.SideIndicator -eq "<=")
                    {
                        Write-Verbose -Message "Validating AllowedToJoin principals"
                        foreach ($principal in $AllowedToJoin)
                        {
                            Write-Verbose -Message "Processing $principal"
                            if ($principal -notmatch $regex)
                            {
                                $group = $groups | Where-Object -FilterScript {
                                    $_.DisplayName -eq $principal
                                }

                                if ($group.Count -ne 1)
                                {
                                    throw "Error for principal $principal. Number of occurences: $($group.Count)"
                                }
                            }
                        }
                        Grant-PnPHubSiteRights -Identity $site.Url -Principals $item.InputObject -Rights 'Join' | Out-Null
                    }
                    else
                    {
                        # Remove item from principals
                        Grant-PnPHubSiteRights -Identity $site.Url -Principals $item.InputObject -Rights 'None' | Out-Null
                    }
                }
            }
        }
    }
    else
    {
        # Remove hub site
        Unregister-PnPHubSite -Site $site.Url
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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for hub site collection $Url"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Ensure", `
            "Url", `
            "Title", `
            "Description", `
            "LogoUrl", `
            "RequiresJoinApproval", `
            "AllowedToJoin", `
            "SiteDesignId")

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

    $hubSites = Get-PnPHubSite

    $i = 1
    $content = ''
    $organization = ""
    $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
    if ($GlobalAdminAccount.UserName.Contains("@"))
    {
        $organization = $GlobalAdminAccount.UserName.Split("@")[1]

        if ($organization.IndexOf(".") -gt 0)
        {
            $principal = $organization.Split(".")[0]
        }
    }
    foreach ($hub in $hubSites)
    {
        Write-Information "    [$i/$($hubSites.Length)] $($hub.SiteUrl)"
        $params = @{
            GlobalAdminAccount = $GlobalAdminAccount
            Url                = $hub.SiteUrl
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = "`$Credsglobaladmin"

        $content += "        SPOHubSite " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $partialContent = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $partialContent = Convert-DSCStringParamToVariable -DSCBlock $partialContent -ParameterName "GlobalAdminAccount"
        if ($partialContent.ToLower().Contains($organization.ToLower()) -or `
            $partialContent.ToLower().Contains($principal.ToLower()))
        {
            $partialContent = $partialContent -ireplace [regex]::Escape('https://' + $principal + '.sharepoint.com/'), "https://`$(`$OrganizationName.Split('.')[0]).sharepoint.com/"
            $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$(`$OrganizationName)"
        }
        $content += $partialContent
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
