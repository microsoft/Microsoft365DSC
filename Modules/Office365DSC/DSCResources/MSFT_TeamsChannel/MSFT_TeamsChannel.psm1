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
        [ValidateLength(1, 50)]
        $DisplayName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 50)]
        $NewDisplayName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,
        
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
        GroupID        = $null
        DisplayName    = $null
        NewDisplayName = $null
        Description    = $null
        Ensure         = "Absent"
    }

    try {
        Write-Verbose -Message "Checking for existance of Team"
        $channel = Get-TeamChannel -GroupId $GroupID | Where-Object {($_.DisplayName -eq $DisplayName)}
        if (!$channel) {
            Write-Verbose "Failed to get Team with ID $GroupId"
            return $nullReturn
        }

        return @{
            DisplayName    = $channel.DisplayName
            GroupID        = $team.GroupID 
            Description    = $channel.Description
            NewDisplayName = $null 
            Ensure         = "Present"
        }
    }
    catch {
        Write-Verbose -Message "Failed to get Teams from the tenant."
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
        [ValidateLength(1, 50)]
        $DisplayName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 50)]
        $NewDisplayName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,
       
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
    $CurrentParameters.Remove("Ensure")

    $channel = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Channel: $channel"

    if ($Ensure -eq "Present") {
        # Remap attribute from DisplayName to current display name for Set-TeamChannel cmdlet
        if ($channel.DisplayName) {
            if ($CurrentParameters.ContainsKey("NewDisplayName")) {
                $CurrentParameters.Add("CurrentDisplayName", $DisplayName)
                $CurrentParameters.Remove("DisplayName")    
                Set-TeamChannel @CurrentParameters
            }
        }   
        else {
            Write-Verbose -Message "Creating team channel  $DislayName" 
            New-TeamChannel @CurrentParameters   
        }
    }
    else {
        if ($CurrentParameters.ContainsKey("Description")) {
            $CurrentParameters.Remove("Description")
        }
        Write-Verbose -Message "Removing team channel $DislayName" 
        Remove-TeamChannel @CurrentParameters
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
        [ValidateLength(1, 50)]
        $DisplayName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 50)]
        $NewDisplayName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,
       
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

        [Parameter()]
        [System.String]
        [ValidateLength(1, 50)]
        $DisplayName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 50)]
        $NewDisplayName,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

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
    $content = "TeamsChannel " + (New-GUID).ToString() + "`r`n"
    $content += "{`r`n"
    $content += Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += "}`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
