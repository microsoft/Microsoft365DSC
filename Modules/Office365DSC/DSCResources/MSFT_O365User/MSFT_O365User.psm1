function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserPrincipalName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

	    [Parameter(Mandatory = $true)]
        [System.String]
        $FirstName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $LastName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $UsageLocation,

        [Parameter(Mandatory = $true)]
        [System.String]
        $LicenseAssignment,

	    [Parameter()] 
        [System.Management.Automation.PSCredential] 
        $Password,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount
    
    $nullReturn = @{
	    UserPrincipalName = $null
        DisplayName = $null
        FirstName = $null
        LastName = $null
        UsageLocation = $null
        LicenseAssignment = $null
        Password = $null
    }

    try
    {        
        Write-Verbose -Message "Getting Office 365 User $UserPrincipalName"
        $user = Get-MSOLUser -UserPrincipalName $UserPrincipalName -ErrorAction SilentlyContinue
        if(!$user)
        {
            Write-Verbose "The specified User doesn't already exist."
            return $nullReturn
        }
        $accountName = $user.LicenseAssignmentDetails.AccountSku.AccountName
        $sku = $user.LicenseAssignmentDetails.AccountSku.SkuPartNumber
        return @{
            UserPrincipalName = $user.UserPrincipalName
            DisplayName = $user.DisplayName
            FirstName = $user.FirstName
            LastName = $user.LastName
            UsageLocation = $user.UsageLocation
            LicenseAssignment = $accountNAme + ":" + $sku
            Passsword = $Password
        }
    }
    catch
    {
        Write-Verbose "The specified User doesn't already exist."
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
        $UserPrincipalName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

	    [Parameter(Mandatory = $true)]
        [System.String]
        $FirstName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $LastName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $UsageLocation,

        [Parameter(Mandatory = $true)]
        [System.String]
        $LicenseAssignment,

	    [Parameter()] 
        [System.Management.Automation.PSCredential] 
        $Password,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount

    Write-Verbose -Message "Setting Office 365 User $UserPrincipalName"
    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount")

    $user = New-MsolUser @CurrentParameters
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserPrincipalName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

	    [Parameter(Mandatory = $true)]
        [System.String]
        $FirstName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $LastName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $UsageLocation,

        [Parameter(Mandatory = $true)]
        [System.String]
        $LicenseAssignment,

	    [Parameter()] 
        [System.Management.Automation.PSCredential] 
        $Password,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Office 365 User $UserPrincipalName"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                           -DesiredValues $PSBoundParameters `
                                           -ValuesToCheck @("UserPrincipalName", `
                                                            "LicenseAssignment", `
                                                            "UsageLocation",
                                                            "FirstName",
                                                            "LastName",
                                                            "DisplayName")
}

Export-ModuleMember -Function *-TargetResource
