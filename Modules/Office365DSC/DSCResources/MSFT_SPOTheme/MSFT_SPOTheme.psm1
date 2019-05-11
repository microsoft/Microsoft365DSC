function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $false)]
        [System.Boolean]
        $IsInverted,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Palette,

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

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $nullReturn = @{
        Name                = $Name
        IsInverted          = $null
        Palette             = $null
        Ensure              = "Absent"
        CentralAdminUrl     = $CentralAdminUrl
    }

    try
    {
        Write-Verbose -Message "Getting theme $Name"
        $theme = Get-SPOTheme -Name $Name
        if ($null -eq $theme)
        {
            Write-Verbose "The specified theme doesn't exist."
            return $nullReturn
        }
        return @{
            Name                = $theme.Name
            IsInverted          = $theme.IsInverted
            Palette             = $theme.Palette
            CentralAdminUrl     = $CentralAdminUrl
            Ensure              = "Present"
        }
    }
    catch
    {
        Write-Verbose "The specified theme doesn't exist."
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

        [Parameter(Mandatory = $false)]
        [System.Boolean]
        $IsInverted,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Palette,

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

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    if($Ensure -eq "Present")
    {
        Write-Verbose -Message "Starting Theme creation"
        $PaletteHash = @{ }
        $PaletteObj = $Palette | ConvertFrom-Json
        foreach($entry in $PaletteObj.Psobject.Properties)
        {
            $PaletteHash[$Entry.Name] = $entry.Value
        }
        $CurrentParameters = $PSBoundParameters
        $CurrentParameters.Remove("Palette")
        $CurrentParameters.Remove("Ensure")
        $CurrentParameters.Remove("CentralAdminURL")
        $CurrentParameters.Remove("GlobalAdminAccount")
        $CurrentParameters.Add("Palette",$PaletteHash)

        try 
        {
            
            $existingTheme = Get-SPOTheme -Name $Name
            Write-Verbose -Message " theme exists $existingTheme"
        }
        catch
        {
            Write-verbose -Message "Theme $($Name) does not yet exist."
        }

        if($null -eq $existingTheme)
        {
            Add-SPOTheme @CurrentParameters
        }
        else
        {
            $ThemeHashTable = Convert-ExistingThemePaletteToHashTable -existingTheme $existingTheme
            $compareOutput = Compare-SPOTheme -existingThemePalette $ThemeHashTable -configThemePalette $currentParameters.Palette
            if(($compareOutput -eq "Themes are identical") -and ($existingTheme.IsInverted -eq $CurrentParameters.isInverted))
            {
                Write-verbose -Message "Theme $($Name) already exists and is configured as specified."
            }
            else
            {
                Write-Verbose -Message "Theme $($Name) already exists but is not configured as specified. Overwriting it."
                Add-SPOTheme @CurrentParameters -Overwrite
            }
        }
    }
    elseif($Ensure -eq "Absent")
    {
        Write-Verbose -Message "Removing theme $($Name)"
        try
        {
            Remove-SPOTheme -Identity $Name -Confirm:$false
        }
        catch
        {
            Write-Error -Message "The theme $($theme) does not exist and for that cannot be removed."
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

        [Parameter(Mandatory = $false)]
        [System.Boolean]
        $IsInverted,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Palette,

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

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    Write-Verbose -Message "Testing theme $Name"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Ensure", `
            "Name", `
            "IsInverted", `
            "Palette"
    )
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        SPOTheme " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
