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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Getting configuration for hub site collection $Url"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
                -InboundParameters $PSBoundParameters

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

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
            $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' `
                        -InboundParameters $PSBoundParameters
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
                Url                   = $Url
                Title                 = $hubSite.Title
                Description           = $hubSite.Description
                LogoUrl               = $configuredLogo
                RequiresJoinApproval  = $hubSite.RequiresJoinApproval
                AllowedToJoin         = $principals
                SiteDesignId          = $hubSite.SiteDesignId
                Ensure                = "Present"
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
            }
            return $result
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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Setting configuration for hub site collection $Url"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
                -InboundParameters $PSBoundParameters

    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' `
                -InboundParameters $PSBoundParameters

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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Testing configuration for hub site collection $Url"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
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

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
                -InboundParameters $PSBoundParameters

    try
    {
        [array]$hubSites = Get-PnPHubSite -ErrorAction Stop

        $i = 1
        Write-Host "`r`n" -NoNewLine

        $dscContent = ''
        foreach ($hub in $hubSites)
        {
            Write-Host "    [$i/$($hubSites.Length)] $($hub.SiteUrl)" -NoNewLine

            $Params = @{
                Url                   = $hub.SiteUrl
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                GlobalAdminAccount    = $GlobalAdminAccount
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
            $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -GlobalAdminAccount $GlobalAdminAccount
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
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
