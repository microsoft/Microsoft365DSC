function Get-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupID,

        [Parameter(Mandatory = $true)]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        [ValidateSet("Member", "Owner")] 
        $Role,
              
        [Parameter()] 
        [ValidateSet("Present", "Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount | Out-Null 
    
    $nullReturn = @{
        User    = $null
        Role    = $null
        Ensure  = "Absent"
    }

    try {
        Write-Verbose -Message "Checking for existance of Team User"
        $users = Get-TeamUser -GroupId $GroupID  
        if (!$users) {
            Write-Verbose "Failed to get Team's users groupId $GroupID"
            return $nullReturn
        }

        foreach($user in $users){
            if ($user.User -eq $User){
                break 
            }
        }

        return @{
            User    = $user.User
            Role    = $user.role 
            Ensure  = "Present"
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
        $GroupID,

        [Parameter(Mandatory = $true)]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        [ValidateSet("Member", "Owner")] 
        $Role,
              
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

    if ($CurrentParameters.ContainsKey("Group") -and $CurrentParameters.Count -gt 1) {
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
        $GroupID,

        [Parameter(Mandatory = $true)]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        [ValidateSet("Member", "Owner")] 
        $Role,
              
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
        $GroupID,

        [Parameter(Mandatory = $true)]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        [ValidateSet("Member", "Owner")] 
        $Role,
              
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
    $content = "TeamsUser " + (New-GUID).ToString() + "`r`n"
    $content += "{`r`n"
    $content += Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += "}`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
