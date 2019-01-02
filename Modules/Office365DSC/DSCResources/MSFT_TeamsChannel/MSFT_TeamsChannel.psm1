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
        $CurrentDisplayName,

        [Parameter()]
        [System.String]
        $NewDisplayName,

        [Parameter()]
        [System.String]
        $Description,
        
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
        GroupID            = $null
        CurrentDisplayName = $null
        NewDisplayName     = $null
        Description        = $null
        Ensure             = "Absent"
    }

    try {
        Write-Verbose -Message "Checking for existance of Team"
        $channel = Get-TeamChannel -GroupId $GroupID | Where-Object {($_.DisplayName -eq $CurrentDisplayName)}
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
        $CurrentDisplayName,

        [Parameter()]
        [System.String]
        $NewDisplayName,

        [Parameter()]
        [System.String]
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

    Write-Verbose -Message "Setting team channel to $NewDisplayName" 
    Set-TeamChannel @CurrentParameters
   
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
        $CurrentDisplayName,

        [Parameter()]
        [System.String]
        $NewDisplayName,

        [Parameter()]
        [System.String]
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
            "CurrentDisplayName"
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
        $CurrentDisplayName,

        [Parameter()]
        [System.String]
        $NewDisplayName,

        [Parameter()]
        [System.String]
        $Description,

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
    $content = "TeamsChannel " + (New-GUID).ToString() + "`r`n"
    $content += "{`r`n"
    $content += Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += "}`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
