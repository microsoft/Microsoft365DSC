function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ManagedBy,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount
    
    $nullReturn = @{
        DisplayName = $null
        Description = $null
        ManagedBy = $null
        TenantId = $null
	GlobalAdminAccount = $null
    }

    try
    {        
        Write-Verbose -Message "Getting Office 365 Group $DisplayName"
        $group = Get-MSOLGroup | Where-Object {$_.DisplayName -eq $DisplayName}

        if(!$group)
        {
            Write-Verbose "The specified Group doesn't already exist."
            return $nullReturn
        }

	$groupMembers = Get-MsolGroupMember -GroupObjectId $group.ObjectId
        return @{
            DisplayName = $group.DisplayName
            Description = $group.Description
            ManagedBy = $groupMembers[0].ObjectId
            GlobalAdminAccount = $GlobalAdminAccount
        }
    }
    catch
    {
        Write-Verbose "The specified Group doesn't already exist."
        return $nullReturn        
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ManagedBy,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount

    Write-Verbose -Message "Setting Office 365 Group $DisplayName"
    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount")
    $owner = Get-MsolUser -ObjectId $ManagedBy -ErrorAction SilentlyContinue
    if(!$owner)
    {
	$owner = Get-MsolUser -UserPrincipalName $ManagedBy
	$currentParameters("ManagedBy") = $owner.ObjectId
    }
    $group = New-MsolGroup @CurrentParameters
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ManagedBy,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Office 365 Group $DisplayName"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                           -DesiredValues $PSBoundParameters `
                                           -ValuesToCheck @("DisplayName", `
                                                            "Description", `
                                                            "ManagedBy")
}

Export-ModuleMember -Function *-TargetResource
