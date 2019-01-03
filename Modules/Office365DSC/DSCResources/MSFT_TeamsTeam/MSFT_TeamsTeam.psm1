function Get-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1,256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Group,

        [Parameter()]
        [System.String]
        [ValidateLength(1,1024)]
        $Description,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.String]
        [ValidateSet("Public", "Private")] 
        $AccessType,
        
        [Parameter()] 
        [ValidateSet("Present", "Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    $CurrentParameters = $PSBoundParameters
    if ($CurrentParameters.ContainsKey("Group") -and $CurrentParameters.Count -gt 1)
    {
        throw "If Group ID is set no other parameters can be passed"
    }

    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount | Out-Null 
    
    $nullReturn = @{
        DisplayName        = $null
        Group              = $null
        Description        = $null
        Owner              = $null
        Classification     = $null
        AccessType         = "Private"
        Ensure             = "Absent"
    }

    try {
        Write-Verbose -Message "Checking for existance of Team"
        $team = Get-Team |  Where-Object {($_.DisplayName -eq $DisplayName)}
        if (!$team) {
            Write-Verbose "Failed to get Teams with displayname $DisplayName"
            return $nullReturn
        }

        return @{
            DisplayName        = $team.DisplayName
            Group              = $team.GroupID 
            Description        = $team.Description
            Owner              = $null
            Classification     = $null
            AccessType         = "Private"
            Ensure             = "Present"
        }
    }
    catch {
        Write-Verbose "Failed to get Teams from the tenant."
        return $nullReturn
    }
}

function Set-TargetResource {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1,256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Group,

        [Parameter()]
        [System.String]
        [ValidateLength(1,1024)]
        $Description,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.String]
        [ValidateSet("Public", "Private")] 
        $AccessType,
       
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

    if ($CurrentParameters.ContainsKey("Group") -and $CurrentParameters.Count -gt 1)
    {
        throw "If group is set no other parameters can be passed"
        
    }
  
    New-Team @CurrentParameters
  
}

function Test-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1,256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Group,

        [Parameter()]
        [System.String]
        [ValidateLength(1,1024)]
        $Description,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.String]
        [ValidateSet("Public", "Private")] 
        $AccessType,
       
        [Parameter()] 
        [ValidateSet("Present", "Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing creation of new Team"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Ensure", `
            "DisplayName"
            )
}           

function Export-TargetResource {
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1,256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Group,

        [Parameter()]
        [System.String]
        [ValidateLength(1,1024)]
        $Description,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.String]
        [ValidateSet("Public", "Private")] 
        $AccessType,


        [Parameter()] 
        [ValidateSet("Present", "Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    Test-SPOServiceConnection -GlobalAdminAccount $GlobalAdminAccount -SPOCentralAdminUrl $CentralAdminUrl
    $result = Get-TargetResource @PSBoundParameters
    $content = "TeamsTeam " + (New-GUID).ToString() + "`r`n"
    $content += "{`r`n"
    $content += Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += "}`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
