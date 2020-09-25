function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $IsInverted,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Palette,

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

    Write-Verbose -Message "Getting configuration for SPO Theme $Name"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    try
    {
        Write-Verbose -Message "Getting theme $Name"
        $theme = Get-PnPTenantTheme -ErrorAction Stop | Where-Object -FilterScript { $_.Name -eq $Name }
        if ($null -eq $theme)
        {
            Write-Verbose -Message "The specified theme doesn't exist."
            return $nullReturn
        }
        $convertedPalette = Convert-ExistingThemePaletteToHashTable -Palette ([System.Collections.Hashtable]$theme.Palette)

        return @{
            Name                  = $theme.Name
            IsInverted            = $theme.IsInverted
            Palette               = $convertedPalette
            GlobalAdminAccount    = $GlobalAdminAccount
            Ensure                = "Present"
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
        $Name,

        [Parameter()]
        [System.Boolean]
        $IsInverted,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Palette,

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

    Write-Verbose -Message "Setting configuration for SPO Theme $Name"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters

    $CurrentPalette = Get-TargetResource @PSBoundParameters
    if ($Ensure -eq "Present")
    {
        Write-Verbose "Converting Received Palette Values into Hashtable"
        $HashPalette = Convert-NewThemePaletteToHashTable -Palette $Palette
        $AddParameters = @{
            Identity   = $Name
            IsInverted = $IsInverted
            Palette    = $HashPalette
        }

        try
        {
            $existingTheme = Get-PnPTenantTheme -Name $Name -ErrorAction SilentlyContinue
        }
        catch
        {
            Write-Verbose -Message "Theme $($Name) does not yet exist."
        }

        if ($null -eq $existingTheme)
        {
            Write-Verbose -Message "Theme {$Name} doesn't already exist. Creating it."
            Add-PnPTenantTheme @AddParameters
        }
        else
        {
            Write-Verbose -Message "Theme {$Name} already exists. Updating it"
            Add-PnPTenantTheme @AddParameters -Overwrite
        }
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentPalette.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing theme $($Name)"
        try
        {
            Remove-PnPTenantTheme -Identity $Name -Confirm:$false
        }
        catch
        {
            $Message = "The SPOTheme $($theme) does not exist and for that cannot be removed."
            New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
            Write-Error $Message
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
        $Name,

        [Parameter()]
        [System.Boolean]
        $IsInverted,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Palette,

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

    Write-Verbose -Message "Testing configuration for SPO Theme $Name"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove("GlobalAdminAccount") | Out-Null
    $ValuesToCheck.Remove("Palette") | Out-Null
    $ValuesToCheck.Remove("ApplicationId") | Out-Null
    $ValuesToCheck.Remove("TenantId") | Out-Null
    $ValuesToCheck.Remove("CertificatePath") | Out-Null
    $ValuesToCheck.Remove("CertificatePassword") | Out-Null
    $ValuesToCheck.Remove("CertificateThumbprint") | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    if ($TestResult)
    {
        $TestResult = Compare-SPOTheme -existingThemePalette $currentValues.Palette -configThemePalette $Palette
    }

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

    try
    {
        [array]$themes = Get-PnPTenantTheme -ErrorAction Stop
        $dscContent = ""
        $i = 1
        Write-Host "`r`n" -NoNewLine
        foreach ($theme in $themes)
        {
            Write-Host "    |---[$i/$($themes.Length)] $($theme.Name)" -NoNewLine
            $Params = @{
                Name                  = $theme.Name
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

function Convert-ExistingThemePaletteToHashTable
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Palette
    )
    $themeHash = @{ }
    foreach ($entry in $Palette.GetEnumerator())
    {
        $themeHash[$entry.Key] = $entry.Value
    }
    return $themeHash
}

function Convert-NewThemePaletteToHashTable
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Palette
    )

    $results = @{ }
    foreach ($entry in $Palette)
    {
        $results.Add($entry.Property, $entry.Value)
    }
    return $results
}

function ConvertTo-SPOThemePalettePropertyString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Palette
    )

    $StringContent = "@("
    foreach ($property in $Palette.Keys)
    {
        $StringContent += "            MSFT_SPOThemePaletteProperty`r`n            {`r`n"
        $StringContent += "                Property = '$($property)'`r`n"
        $StringContent += "                Value    = '$($Palette[$property])'`r`n"
        $StringContent += "            }`r`n"
    }
    $StringCOntent += "            )`r`n"
    return $StringContent
}


function Compare-SPOTheme
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object]
        $existingThemePalette,
        [Parameter(Mandatory = $true)]
        [System.Object]
        $configThemePalette
    )

    $existingThemePalette = $existingThemePalette.GetEnumerator() | Sort-Object -Property Name
    $configThemePalette = $configThemePalette.GetEnumerator() | Sort-Object -Property Name

    $existingThemePaletteCount = 0
    $configThemePaletteCount = 0

    foreach ($val in $existingThemePalette.Value)
    {
        if ($configThemePalette.Value.Contains($val))
        {
            $configThemePaletteCount++
        }
    }

    foreach ($val in $configThemePalette.Value)
    {
        if ($existingThemePalette.value.Contains($val))
        {
            $existingThemePaletteCount++
        }
    }

    if (($existingThemePalette.Count -eq $configThemePaletteCount) -and ($configThemePalette.Count -eq $existingThemePaletteCount))
    {
        return "Themes are identical"
    }
    else
    {
        return "Themes are not identical"
    }
}

Export-ModuleMember -Function *-TargetResource
