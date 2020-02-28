function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserPrincipalName,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $FirstName,

        [Parameter()]
        [System.String]
        $LastName,

        [Parameter()]
        [System.String]
        $UsageLocation,

        [Parameter()]
        [System.String[]]
        $LicenseAssignment,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Password,

        [Parameter()]
        [System.String]
        $City,

        [Parameter()]
        [System.String]
        $Country,

        [Parameter()]
        [System.String]
        $Department,

        [Parameter()]
        [System.String]
        $Fax,

        [Parameter()]
        [System.String]
        $MobilePhone,

        [Parameter()]
        [System.String]
        $Office,

        [Parameter()]
        [System.Boolean]
        $PasswordNeverExpires = $false,

        [Parameter()]
        [System.String]
        $PhoneNumber,

        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [System.String]
        $PreferredDataLocation,

        [Parameter()]
        [System.String]
        $PreferredLanguage,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $StreetAddress,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [ValidateSet("Guest", "Member", "Other", "Viral")]
        [System.String]
        $UserType,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion
    Test-MSCloudLogin -Platform MSOnline -O365Credential $GlobalAdminAccount
    Write-Verbose -Message "Getting configuration of Office 365 User $UserPrincipalName"

    $nullReturn = @{
        UserPrincipalName  = $null
        DisplayName        = $null
        FirstName          = $null
        LastName           = $null
        UsageLocation      = $null
        LicenseAssignment  = $null
        Password           = $null
        GlobalAdminAccount = $GlobalAdminAccount
        Ensure             = "Absent"
    }

    try
    {
        Write-Verbose -Message "Getting Office 365 User $UserPrincipalName"
        $user = Get-MSOLUser -UserPrincipalName $UserPrincipalName -ErrorAction SilentlyContinue
        if ($null -eq $user)
        {
            Write-Verbose -Message "The specified User doesn't already exist."
            return $nullReturn
        }

        Write-Verbose -Message "Found User $($UserPrincipalName)"
        $currentLicenseAssignment = @()
        foreach ($license in $user.Licenses)
        {
            $currentLicenseAssignment += $license.AccountSkuID.ToString()
        }

        $passwordNeverExpires = $user.PasswordNeverExpires
        if ($null -eq $passwordNeverExpires)
        {
            $passwordNeverExpires = $true
        }

        $results = @{
            UserPrincipalName     = $user.UserPrincipalName
            DisplayName           = $user.DisplayName
            FirstName             = $user.FirstName
            LastName              = $user.LastName
            UsageLocation         = $user.UsageLocation
            LicenseAssignment     = $currentLicenseAssignment
            Password              = $Password
            City                  = $user.City
            Country               = $user.Country
            Department            = $user.Department
            Fax                   = $user.Fax
            MobilePhone           = $user.MobilePhone
            Office                = $user.Office
            PasswordNeverExpires  = $passwordNeverExpires
            PhoneNumber           = $user.PhoneNumber
            PostalCode            = $user.PostalCode
            PreferredDataLocation = $user.PreferredDataLocation
            PreferredLanguage     = $user.PreferredLanguage
            State                 = $user.State
            StreetAddress         = $user.StreetAddress
            Title                 = $user.Title
            UserType              = $user.UserType
            GlobalAdminAccount    = $GlobalAdminAccount
            Ensure                = "Present"
        }
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        $Message = "The specified User {$UserPrincipalName} doesn't already exist."
        Write-Verbose $Message
        return $nullReturn
    }
    return $nullReturn
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserPrincipalName,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $FirstName,

        [Parameter()]
        [System.String]
        $LastName,

        [Parameter()]
        [System.String]
        $UsageLocation,

        [Parameter()]
        [System.String[]]
        $LicenseAssignment,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Password,

        [Parameter()]
        [System.String]
        $City,

        [Parameter()]
        [System.String]
        $Country,

        [Parameter()]
        [System.String]
        $Department,

        [Parameter()]
        [System.String]
        $Fax,

        [Parameter()]
        [System.String]
        $MobilePhone,

        [Parameter()]
        [System.String]
        $Office,

        [Parameter()]
        [System.Boolean]
        $PasswordNeverExpires = $false,

        [Parameter()]
        [System.String]
        $PhoneNumber,

        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [System.String]
        $PreferredDataLocation,

        [Parameter()]
        [System.String]
        $PreferredLanguage,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $StreetAddress,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [ValidateSet("Guest", "Member", "Other", "Viral")]
        [System.String]
        $UserType,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Office 365 User $UserPrincipalName"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform MSOnline

    $user = Get-TargetResource @PSBoundParameters
    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("Ensure")
    $CurrentParameters.Remove("GlobalAdminAccount")
    $newLicenseAssignment = $LicenseAssignment

    if ($user.UserPrincipalName)
    {
        if ($LicenseAssignment.Length -gt 0)
        {
            Write-Verbose -Message "Comparing License Assignment for user $UserPrincipalName"
            $diff = Compare-Object -ReferenceObject $user.LicenseAssignment -DifferenceObject $newLicenseAssignment
        }

        $CurrentParameters.Remove("LicenseAssignment")
        if ($Password)
        {
            $CurrentParameters.Remove("Password")
        }

        if ($null -ne $diff)
        {
            Write-Verbose -Message "Detected a change in license assignment for user $UserPrincipalName"
            Write-Verbose -Message "Current License Assignment is $($user.LicenseAssignment)"
            Write-Verbose -Message "New License Assignment is $($newLicenseAssignment)"
            $licensesToRemove = @()
            $licensesToAdd = @()
            foreach ($difference in $diff)
            {
                if ($difference.SideIndicator -eq "<=")
                {
                    $licensesToRemove += $difference.InputObject
                }
                elseif ($difference.SideIndicator -eq "=>")
                {
                    $licensesToAdd += $difference.InputObject
                }
            }
            Write-Verbose -Message "Updating License Assignment"
            try
            {
                Set-MsolUserLicense -UserPrincipalName $UserPrincipalName `
                    -AddLicenses $LicenseAssignment `
                    -ErrorAction SilentlyContinue
            }
            catch
            {
                $Message = "License {$($LicenseAssignment)} doesn't exist in tenant."
                Write-Verbose $Message
                New-Office365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
            }
        }
        Write-Verbose -Message "Updating Office 365 User $UserPrincipalName Information"
        $user = Set-MsolUser @CurrentParameters
    }
    else
    {
        Write-Verbose -Message "Creating Office 365 User $UserPrincipalName"
        $CurrentParameters.Remove("LicenseAssignment")
        $user = New-MsolUser @CurrentParameters

        try
        {
            Set-MsolUserLicense -UserPrincipalName $UserPrincipalName `
                -AddLicenses $licensesToAdd `
                -RemoveLicenses $licensesToRemove `
                -ErrorAction SilentlyContinue
        }
        catch
        {
            $Message = "Could not assign license {$($newLicenseAssignment)} to user {$($UserPrincipalName)}"
            New-Office365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
            throw $Message
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
        $UserPrincipalName,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $FirstName,

        [Parameter()]
        [System.String]
        $LastName,

        [Parameter()]
        [System.String]
        $UsageLocation,

        [Parameter()]
        [System.String[]]
        $LicenseAssignment,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Password,

        [Parameter()]
        [System.String]
        $City,

        [Parameter()]
        [System.String]
        $Country,

        [Parameter()]
        [System.String]
        $Department,

        [Parameter()]
        [System.String]
        $Fax,

        [Parameter()]
        [System.String]
        $MobilePhone,

        [Parameter()]
        [System.String]
        $Office,

        [Parameter()]
        [System.Boolean]
        $PasswordNeverExpires = $false,

        [Parameter()]
        [System.String]
        $PhoneNumber,

        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [System.String]
        $PreferredDataLocation,

        [Parameter()]
        [System.String]
        $PreferredLanguage,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $StreetAddress,

        [Parameter()]
        [System.String]
        $Title,

        [Parameter()]
        [ValidateSet("Guest", "Member", "Other", "Viral")]
        [System.String]
        $UserType,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Office 365 User $UserPrincipalName"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Ensure", `
            "UserPrincipalName", `
            "LicenseAssignment", `
            "UsageLocation", `
            "FirstName", `
            "LastName", `
            "DisplayName", `
            "City", `
            "Country", `
            "Department", `
            "Fax", `
            "MobilePhone", `
            "Office", `
            "PasswordNeverExpires", `
            "PhoneNumber", `
            "PostalCode", `
            "PreferredDataLocation", `
            "PreferredLanguage", `
            "State", `
            "StreetAddress", `
            "Title", `
            "UserType")

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-O365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -Platform MSOnline -CloudCredential $GlobalAdminAccount
    $organization = ""
    $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the O365DSC part of O365DSC.onmicrosoft.com)
    if ($GlobalAdminAccount.UserName.Contains("@"))
    {
        $organization = $GlobalAdminAccount.UserName.Split("@")[1]

        if ($organization.IndexOf(".") -gt 0)
        {
            $principal = $organization.Split(".")[0]
        }
    }
    $users = Get-MsolUser
    $content = ''
    $partialContent = ""
    $i = 1
    foreach ($user in $users)
    {
        Write-Information "    - [$i/$($users.Length)] $($user.UserPrincipalName)"
        $userUPN = $user.UserPrincipalName
        if (-not [System.String]::IsNullOrEmpty($userUPN))
        {
            $params = @{
                UserPrincipalName   = $userUPN
                GlobalAdminAccount  = $GlobalAdminAccount
                Password            = $GlobalAdminAccount
            }

            $result = Get-TargetResource @params
            if ($null -ne $result.UserPrincipalName)
            {
                $result.Password = Resolve-Credentials -UserName "globaladmin"
                $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
                $content += "        O365User " + (New-GUID).ToString() + "`r`n"
                $content += "        {`r`n"
                $partialContent = Get-DSCBlock -Params $result -ModulePath  $PSScriptRoot
                $partialContent = Convert-DSCStringParamToVariable -DSCBlock $partialContent -ParameterName "Password"
                $partialContent = Convert-DSCStringParamToVariable -DSCBlock $partialContent -ParameterName "GlobalAdminAccount"
                if ($partialContent.ToLower().IndexOf($organization.ToLower()) -gt 0)
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape($organization), "`$OrganizationName"
                    $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$OrganizationName"
                }

                if ($partialContent.ToLower().IndexOf($principal.ToLower()) -gt 0)
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape($principal.ToLower()), "`$(`$OrganizationName.Split('.')[0])"
                }
                $content += $partialContent
                $content += "        }`r`n"
            }
        }
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
