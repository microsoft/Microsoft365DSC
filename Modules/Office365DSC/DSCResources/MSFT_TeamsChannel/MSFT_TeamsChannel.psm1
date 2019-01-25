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
        GroupID        = $GroupID
        DisplayName    = $null
        Description    = $null
        NewDisplayName = $null
        Ensure         = "Absent"
    }

    try {
        Write-Verbose -Message "Checking for existance of team channels "
        $channel = Get-TeamChannel -GroupId $GroupID | Where-Object {($_.DisplayName -eq $DisplayName)}
        if ($null -eq $channel) {
            Write-Verbose "Failed to get team channels with ID $GroupId and display name of $DisplayName"
            return $nullReturn
        }

        return @{
            DisplayName    = $channel.DisplayName
            GroupID        = $team.GroupID 
            Description    = $channel.Description
            NewDisplayName = $channel.DisplayName
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

    Write-Verbose  -Message "Entering Set-TargetResource"
    Write-Verbose  -Message "Retrieving information about team channel $($DisplayName) to see if it already exists"
    $channel = Get-TargetResource @PSBoundParameters

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("Ensure")


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
            if ($CurrentParameters.ContainsKey("NewDisplayName")) {
                $CurrentParameters.Remove("NewDisplayName")
            }
            Write-Verbose -Message "Creating team channel  $DislayName" 
            New-TeamChannel @CurrentParameters   
        }
    }
    else {
        if ($channel.DisplayName) {
            Write-Verbose -Message "Removing team channel $DislayName" 
            Remove-TeamChannel -GroupId $GroupID -DisplayName $DisplayName
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

    Write-Verbose -Message "Testing creation of new Team's channel"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Ensure", `
            "DisplayName", `
            "NewDisplayName", `
            "Description"
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
