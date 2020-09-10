function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [ValidateSet('All', 'None')]
        [System.String]
        $AuditFlags,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting SPOSiteAuditSettings for {$Url}"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = @{
        Url                = $Url
        AuditFlags         = 'None'
        GlobalAdminAccount = $GlobalAdminAccount
    }

    try
    {
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
            -Platform PnP `
            -ConnectionUrl $Url -ErrorAction SilentlyContinue
        $auditSettings = Get-PnPAuditing -ErrorAction Stop
        $auditFlag = $auditSettings.AuditFlags
        if ($null -eq $auditFlag)
        {
            $auditFlag = 'None'
        }
        return @{
            Url                = $Url
            AuditFlags         = $auditFlag
            GlobalAdminAccount = $GlobalAdminAccount
        }
    }
    catch
    {
        if ($error[0].Exception.Message -like "No connection available")
        {
            Write-Verbose -Message "Make sure that you are connected to your PnPConnection"
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
        [ValidateSet('All', 'None')]
        [System.String]
        $AuditFlags,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Audit settings for {$Url}"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -ConnectionUrl $Url `
        -Platform PnP

    if ($AuditFlags -eq 'All')
    {
        Set-PnPAuditing -EnableAll
    }
    else
    {
        Set-PnPAuditing -DisableAll
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
        [ValidateSet('All', 'None')]
        [System.String]
        $AuditFlags,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing audit settings for {$Url}"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("AuditFlags")

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
    Test-MSCloudLogin -Platform PnP -CloudCredential $GlobalAdminAccount

    $sites = Get-PnPTenantSite

    $i = 1
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
    $content = ""
    foreach ($site in $sites)
    {
        try
        {
            Write-Information "    [$i/$($sites.Length)] Audit Settings for {$($site.Url)}"
            $params = @{
                Url                = $site.Url
                AuditFlags         = 'None'
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params

            if ([System.String]::IsNullOrEmpty($result.AuditFlags))
            {
                $result.AuditFlags = 'None'
            }
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        SPOSiteAuditSettings " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $partialContent = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            if ($partialContent.ToLower().Contains($principal.ToLower() + ".sharepoint.com"))
            {
                $partialContent = $partialContent -ireplace [regex]::Escape($principal + ".sharepoint.com"), "`$(`$OrganizationName.Split('.')[0]).sharepoint.com"
            }
            if ($partialContent.ToLower().Contains("@" + $organization.ToLower()))
            {
                $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$OrganizationName"
            }
            if ($partialContent.ToLower().Contains("@" + $principal.ToLower()))
            {
                $partialContent = $partialContent -ireplace [regex]::Escape("@" + $principal), "@`$OrganizationName.Split('.')[0])"
            }
            if ($partialContent.ToLower().Contains($principal.ToLower() + "-my.sharepoint.com"))
            {
                $partialContent = $partialContent -ireplace [regex]::Escape($principal + "-my.sharepoint.com"), "`$(`$OrganizationName.Split('.')[0])-my.sharepoint.com"
            }
            $content += $partialContent
            $content += "        }`r`n"
        }
        catch
        {
            Write-Verbose "There was an issue retrieving Audit Settings for $Url"
        }
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
