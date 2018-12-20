function Get-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupID,

        [Parameter()]
        [System.String]
        $AllowGiphy,

        [Parameter()]
        [ValidateSet("Strict", "Moderate")] 
        [System.String]
        $GiphyContentRating,

        [Parameter()]
        [System.String]
        $AllowStickersAndMemes,

        [Parameter()]
        [System.String]
        $AllowCustomMemes,

        [Parameter()] 
        [ValidateSet("Present", "Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount
    
    $nullReturn = @{
        GroupID               = $null
        AllowGiphy            = $null
        GiphyContentRating    = "Strict"
        AllowStickersAndMemes = $null
        AllowCustomMemes      = $null
        Ensure                = "Absent"
    }

    try {
        Write-Verbose -Message "Getting Team fun settings for $GroupID"
        $team = Get-TeamFunSettings -GroupId $GroupID
        if (!$team) {
            Write-Verbose "The specified Team doesn't exist."
            return $nullReturn
        }
        Write-Verbose "Team fun settings for AllowGiphy = $($team.AllowGiphy)"
        Write-Verbose "Team fun settings for GiphyContentRating = $($team.GiphyContentRating)"
        Write-Verbose "Team fun settings for AllowStickersAndMemes = $($team.AllowStickersAndMemes)"
        Write-Verbose "Team fun settings for AllowCustomMemes = $($team.AllowCustomMemes)"

        return @{
            GroupID               = $team.GroupID
            AllowGiphy            = $team.AllowGiphy
            GiphyContentRating    = $team.GiphyContentRating
            AllowStickersAndMemes = $team.AllowStickersAndMemes
            AllowCustomMemes      = $team.AllowCustomMemes
            Ensure                = "Present"
        }
    }
    catch {
        Write-Verbose "The specified Team doesn't exist."
        return $nullReturn
    }
}

function Set-TargetResource {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupID,

        [Parameter()]
        [System.String]
        $AllowGiphy,

        [Parameter()]
        [ValidateSet("Strict", "Moderate")] 
        [System.String]
        $GiphyContentRating,

        [Parameter()]
        [System.String]
        $AllowStickersAndMemes,

        [Parameter()]
        [System.String]
        $AllowCustomMemes,

        [Parameter()] 
        [ValidateSet("Present", "Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount")

    if ($Ensure -eq "Present") {
        
        if ($CurrentParameters.ContainsKey("AllowGiphy")) {
            Set-TeamFunSettings -GroupId $GroupID -AllowGiphy $AllowGiphy
            Write-Verbose -Message "Setting Team AllowGiphy to  $AllowGiphy"
        }

        if ($CurrentParameters.ContainsKey("GiphyContentRating")) {
            Set-TeamFunSettings -GroupId $GroupID -GiphyContentRating $GiphyContentRating
            Write-Verbose -Message "Setting Team GiphyContentRating to  $GiphyContentRating"
        }

        if ($CurrentParameters.ContainsKey("AllowStickersAndMemes")) {
            Set-TeamFunSettings -GroupId $GroupID -AllowStickersAndMemes $AllowStickersAndMemes
            Write-Verbose -Message "Setting Team AllowStickersAndMemes to  $AllowStickersAndMemes"
        }

        if ($CurrentParameters.ContainsKey("AllowCustomMemes")) {
            Set-TeamFunSettings -GroupId $GroupID -AllowCustomMemes $AllowCustomMemes
            Write-Verbose -Message "Setting Team AllowCustomMemes to  $AllowCustomMemes"
        }
        
    }
}

function Test-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupID,

        [Parameter()]
        [System.String]
        $AllowGiphy,

        [Parameter()]
        [ValidateSet("Strict", "Moderate")] 
        [System.String]
        $GiphyContentRating,

        [Parameter()]
        [System.String]
        $AllowStickersAndMemes,

        [Parameter()]
        [System.String]
        $AllowCustomMemes,

        [Parameter()] 
        [ValidateSet("Present", "Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Team fun settings for  $GroupID"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Ensure", `
            "AllowGiphy", `
            "GiphyContentRating", `
            "AllowStickersAndMemes", `
            "AllowCustomMemes"
    )
}

function Export-TargetResource {
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupID,

        [Parameter()]
        [System.String]
        $AllowGiphy,

        [Parameter()]
        [ValidateSet("Strict", "Moderate")] 
        [System.String]
        $GiphyContentRating,

        [Parameter()]
        [System.String]
        $AllowStickersAndMemes,

        [Parameter()]
        [System.String]
        $AllowCustomMemes,

        [Parameter()] 
        [ValidateSet("Present", "Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount  
    $result = Get-TargetResource @PSBoundParameters
    $content = "TeamFunSettings " + (New-GUID).ToString() + "`r`n"
    $content += "{`r`n"
    $content += Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += "}`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
