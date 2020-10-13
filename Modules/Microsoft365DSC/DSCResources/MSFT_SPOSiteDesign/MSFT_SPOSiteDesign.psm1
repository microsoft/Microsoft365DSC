function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Title,

        [Parameter()]
        [System.String[]]
        $SiteScriptNames,

        [Parameter()]
        [ValidateSet("CommunicationSite", "TeamSite")]
        [System.String]
        $WebTemplate,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.String]
        $PreviewImageAltText,

        [Parameter()]
        [System.String]
        $PreviewImageUrl,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.UInt32]
        $Version,

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration for SPO SiteDesign for $Title"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' `
        -InboundParameters $PSBoundParameters

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        Write-Verbose -Message "Getting Site Design for $Title"

        $siteDesign = Get-PnPSiteDesign -Identity $Title -ErrorAction SilentlyContinue
        if ($null -eq $siteDesign)
        {
            Write-Verbose -Message "No Site Design found for $Title"
            return $nullReturn
        }

        $scriptTitles = @()
        foreach ($scriptId in $siteDesign.SiteScriptIds)
        {
            $siteScript = Get-PnPSiteScript -Identity $scriptId -ErrorAction SilentlyContinue

            if ($null -ne $siteScript)
            {
                $scriptTitles += $siteScript.Title
            }
        }
        ## Todo need to see if we can get this somehow from PNP module instead of hard coded in script
        ## https://github.com/SharePoint/PnP-PowerShell/blob/master/Commands/Enums/SiteWebTemplate.cs
        $webtemp = $null
        if ($siteDesign.WebTemplate -eq "64")
        {
            $webtemp = "TeamSite"
        }
        else
        {
            $webtemp = "CommunicationSite"
        }

        return @{
            Title                 = $siteDesign.Title
            SiteScriptNames       = $scriptTitles
            WebTemplate           = $webtemp
            IsDefault             = $siteDesign.IsDefault
            Description           = $siteDesign.Description
            PreviewImageAltText   = $siteDesign.PreviewImageAltText
            PreviewImageUrl       = $siteDesign.PreviewImageUrl
            Version               = $siteDesign.Version
            Ensure                = "Present"
            GlobalAdminAccount    = $GlobalAdminAccount
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
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
        $Title,

        [Parameter()]
        [ValidateSet("CommunicationSite", "TeamSite")]
        [System.String]
        $WebTemplate,

        [Parameter()]
        [System.String[]]
        $SiteScriptNames,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.String]
        $PreviewImageAltText,

        [Parameter()]
        [System.String]
        $PreviewImageUrl,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.UInt32]
        $Version,

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration for SPO SiteDesign for $Title"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' `
        -InboundParameters $PSBoundParameters

    $curSiteDesign = Get-TargetResource @PSBoundParameters

    # Get list of site script names
    $scriptIds = @()
    foreach ($siteScriptName in $SiteScriptNames)
    {
        $siteScript = Get-PnPSiteScript | Where-Object -FilterScript { $_.Title -eq $siteScriptName }
        $scriptIds += $siteScript.Id
    }

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount") | Out-Null
    $CurrentParameters.Remove("SiteScriptNames") | Out-Null
    $CurrentParameters.Remove("Ensure") | Out-Null
    $CurrentParameters.Remove("ApplicationId") | Out-Null
    $CurrentParameters.Remove("TenantId") | Out-Null
    $CurrentParameters.Remove("CertificatePath") | Out-Null
    $CurrentParameters.Remove("CertificatePassword") | Out-Null
    $CurrentParameters.Remove("CertificateThumbprint") | Out-Null
    $CurrentParameters.Add("SiteScriptIds", $scriptIds)

    if ($curSiteDesign.Ensure -eq "Absent" -and "Present" -eq $Ensure )
    {
        $CurrentParameters.Remove("Version")
        Write-Verbose -Message "Adding new site design $Title"
        Add-PnPSiteDesign @CurrentParameters
    }
    elseif (($curSiteDesign.Ensure -eq "Present" -and "Present" -eq $Ensure))
    {
        $siteDesign = Get-PnPSiteDesign -Identity $Title -ErrorAction SilentlyContinue
        if ($null -ne $siteDesign)
        {
            Write-Verbose -Message "Updating current site design $Title"
            Set-PnPSiteDesign -Identity $siteDesign.Id  @CurrentParameters
        }
    }
    elseif (($Ensure -eq "Absent" -and $curSiteDesign.Ensure -eq "Present"))
    {
        $siteDesign = Get-PnPSiteDesign -Identity $Title -ErrorAction SilentlyContinue
        if ($null -ne $siteDesign)
        {
            Write-Verbose -Message "Removing site design $Title"
            Remove-PnPSiteDesign -Identity $siteDesign.Id -Force
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
        $Title,

        [Parameter()]
        [ValidateSet("CommunicationSite", "TeamSite")]
        [System.String]
        $WebTemplate,

        [Parameter()]
        [System.String[]]
        $SiteScriptNames,

        [Parameter()]
        [System.Boolean]
        $isDefault,

        [Parameter()]
        [System.String]
        $PreviewImageAltText,

        [Parameter()]
        [System.String]
        $PreviewImageUrl,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.UInt32]
        $Version,

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Write-Verbose -Message "Testing configuration for SPO SiteDesign for $Title"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove("ApplicationId") | Out-Null
    $ValuesToCheck.Remove("TenantId") | Out-Null
    $ValuesToCheck.Remove("CertificatePath") | Out-Null
    $ValuesToCheck.Remove("CertificatePassword") | Out-Null
    $ValuesToCheck.Remove("CertificateThumbprint") | Out-Null

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
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' `
        -InboundParameters $PSBoundParameters

    $dscContent = ''
    $i = 1

    try
    {
        [array]$designs = Get-PnPSiteDesign -ErrrAction Stop
        Write-Host "`r`n" -NoNewline
        foreach ($design in $designs)
        {

            Write-Host "    |---[$i/$($designs.Length)] $($design.Title)" -NoNewline
            $Params = @{
                Title                 = $design.Title
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
                CertificateThumbprint = $CertificateThumbprint
                GlobalAdminAccount    = $GlobalAdminAccount
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -GlobalAdminAccount $GlobalAdminAccount
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckmark
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
