function Get-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Group,

        [Parameter()]
        [System.String]
        $GroupId,
        
        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
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
    if ($CurrentParameters.ContainsKey("Group") -and $CurrentParameters.Count -gt 1) {
        throw "If connected O365Group is passed no other parameters can be passed into New-Team cmdlet"
    }

    Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount  
    
    $nullReturn = @{
        DisplayName    = $null
        Group          = $null
        GroupId        = $null
        Description    = $null
        Owner          = $null
        Classification = $null
        Alias          = $null   
        AccessType     = "Private"
        Ensure         = "Absent"
    }

    # try 
    # {
    Write-Verbose -Message "Checking for existance of Team"
    $allGroups = Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
        -ScriptBlock {
        Get-UnifiedGroup 
    }
             
    if ($CurrentParameters.ContainsKey("GroupId")) {
        $teamGroup = $allGroups | Where-Object {$_.Name.split("_")[0] -eq $GroupId}
        $team = Get-Team |  Where-Object {($_.GroupId -eq $GroupId)}
        if (!$team) {
            Write-Verbose "Failed to get Teams with GroupId $($GroupId)"
            return $nullReturn
        }
    }
    else {
        $team = Get-Team |  Where-Object {($_.DisplayName -eq $DisplayName)}
        if (!$team) {
            Write-Verbose "Failed to get Teams with displayname $DisplayName"
            return $nullReturn
        }
        if ($team.Count -gt 1) {
            throw "Duplicate Teams name $DisplayName exist in tenant"
        }
    }

    Write-Verbose -Message "Found Team $($team.DisplayName) and groupid of $($team.GroupId)"

    return @{
        DisplayName    = $team.DisplayName
        Group          = $null
        GroupId        = $team.GroupId
        Description    = $team.Description
        Owner          = $null
        Classification = $null
        Alias          = $teamGroup.Alias
        AccessType     = $teamGroup.AccessType
        Ensure         = "Present"
    }
}
#    catch {
#        Write-Verbose "Failed to get Teams from the tenant."
#        return $nullReturn
#    }
#}

function Set-TargetResource {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Group,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
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
   
    $team = Get-TargetResource @PSBoundParameters
    
    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount")

    if ($CurrentParameters.ContainsKey("Group") -and $CurrentParameters.Count -gt 1) {
        throw "If group is set no other parameters can be passed"    
    }

    Write-Verbose -Message "Team group id $($team.GroupId)"
    
    if ($Ensure -eq "Present") {
        if ($CurrentParameters.ContainsKey("Ensure")) {
            $CurrentParameters.Remove("Ensure")
        }
        if ($team.DisplayName) {
            if ($CurrentParameters.ContainsKey("Owner")) {
                $CurrentParameters.Remove("Owner")
            }
            if ($CurrentParameters.ContainsKey("AccessType")) {
                $CurrentParameters.Remove("AccessType")
                $CurrentParameters.Add("Visibility", $AccessType)
            }
            # GroupId not passed into parameters but found a group with same display name
            if (!$CurrentParameters.ContainsKey("GroupId")) {
                $CurrentParameters.Add("GroupId", $team.GroupId)
            }
            Set-Team @CurrentParameters 
            Write-Verbose -Message "Updating team group id $($GroupId)"
        }
        else {
            if ($CurrentParameters.ContainsKey("GroupId")) {
                $CurrentParameters.Remove("GroupId")
            }
            Write-Verbose -Message "Creating team $DisplayName"
            New-Team @CurrentParameters
        }
    }
    if (($Ensure -eq "Absent") -and ($team.GroupId)) {
        Write-Verbose -Message "Removing team $DisplayName"   
    }   Remove-team -GroupId $team.GroupId
}

function Test-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Group,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
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
        -ValuesToCheck @("DisplayName", `
            "Description", `
            "Alias", `
            "AccessType", `
            "Ensure"
    )
}           

function Export-TargetResource {
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Group,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
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
