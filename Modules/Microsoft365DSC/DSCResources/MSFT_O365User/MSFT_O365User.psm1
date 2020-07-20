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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )
    Write-Verbose -Message "Getting configuration of Office 365 User $UserPrincipalName"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' `
        -InboundParameters $PSBoundParameters

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
        $user = Get-AzureADUser -ObjectId $UserPrincipalName -ErrorAction SilentlyContinue
        if ($null -eq $user)
        {
            Write-Verbose -Message "The specified User doesn't already exist."
            return $nullReturn
        }

        Write-Verbose -Message "Found User $($UserPrincipalName)"
        $currentLicenseAssignment = @()
        $skus = Get-AzureADUserLicenseDetail -ObjectId $UserPrincipalName
        foreach ($sku in $skus)
        {
            $currentLicenseAssignment += $sku.SkuPartNumber
        }

        $userPasswordPolicyInfo = $user | Select-Object UserprincipalName,@{
                N="PasswordNeverExpires";E={$_.PasswordPolicies -contains "DisablePasswordExpiration"}
        }
        $passwordNeverExpires = $userPasswordPolicyInfo.PasswordNeverExpires

        $results = @{
            UserPrincipalName     = $UserPrincipalName
            DisplayName           = $user.DisplayName
            FirstName             = $user.GivenName
            LastName              = $user.Surname
            UsageLocation         = $user.UsageLocation
            LicenseAssignment     = $currentLicenseAssignment
            Password              = $Password
            City                  = $user.City
            Country               = $user.Country
            Department            = $user.Department
            Fax                   = $user.FacsimileTelephoneNumber
            MobilePhone           = $user.Mobile
            Office                = $user.PhysicalDeliveryOfficeName
            PasswordNeverExpires  = $passwordNeverExpires
            PhoneNumber           = $user.TelephoneNumber
            PostalCode            = $user.PostalCode
            PreferredLanguage     = $user.PreferredLanguage
            State                 = $user.State
            StreetAddress         = $user.StreetAddress
            Title                 = $user.JobTitle
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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    # PreferredDataLocation is no longer an accepted value;
    if (![System.String]::IsNullOrEmpty($PreferredDataLocation))
    {
        Write-Warning "[DEPRECATED] Property PreferredDataLocation is no longer supported by resource O365USer"
    }

    Write-Verbose -Message "Setting configuration of Office 365 User $UserPrincipalName"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' `
        -InboundParameters $PSBoundParameters

    $user = Get-TargetResource @PSBoundParameters
    $PasswordPolicies = $null
    if ($PasswordNeverExpires)
    {
        $PasswordPolicies = 'NONE'
    }
    $CreationParams = @{
        City = $City
        Country = $Country
        Department = $Department
        DisplayName = $DisplayName
        FacsimileTelephoneNumber = $Fax
        GivenName = $FirstName
        JobTitle = $Title
        Mobile = $MobilePhone
        PasswordPolicies = $PasswordPolicies
        PhysicalDeliveryOfficeName = $Office
        PostalCode = $PostalCode
        PreferredLanguage = $PreferredLanguage
        State = $State
        StreetAddress = $StreetAddress
        Surname = $LastName
        TelephoneNumber = $PhoneNumber
        UsageLocation = $UsageLocation
        UserPrincipalName = $UserPrincipalName
        UserType  = $UserType
    }
    $CreationParams = Remove-NullEntriesFromHashtable -Hash $CreationParams

    if ($null -ne $LicenseAssignment)
    {
        $licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses

        foreach ($licenseSkuPart in $LicenseAssignment)
        {
            Write-Verbose -Message "Adding License {$licenseSkuPart} to the Queue"
            $license = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
            $license.SkuId = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value $licenseSkuPart -EQ).SkuID

            # Set the Office license as the license we want to add in the $licenses object
            $licenses.AddLicenses = $license
        }
    }

    if ($user.UserPrincipalName)
    {
        Write-Verbose -Message "Updating License Assignment"
        try
        {
            Write-Verbose -Message "Assigning $($licenses.Count) licences to existing user"
            Set-AzureADUserLicense -ObjectId $UserPrincipalName `
                -AssignedLicenses $licenses `
                -ErrorAction SilentlyContinue
        }
        catch
        {
            $Message = "License {$($LicenseAssignment)} doesn't exist in tenant."
            Write-Verbose $Message
            New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
        }

        Write-Verbose -Message "Updating Office 365 User $UserPrincipalName Information"
        $CreationParams.Add("ObjectID", $UserPrincipalName)
        $user = Set-AzureADUser @CreationParams
    }
    else
    {
        Write-Verbose -Message "Creating Office 365 User $UserPrincipalName"
        $CreationParams.Add("AccountEnabled", $true)
        $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
        $PasswordProfile.Password ='TempP@ss'
        $CreationParams.Add("PasswordProfile", $PasswordProfile)
        $CreationParams.Add("MailNickName", $UserPrincipalName.Split('@')[0])
        $user = New-AzureADUser @CreationParams
        Set-AzureADUserPassword -ObjectId $UserPrincipalName -Password $Password.Password | Out-Null

        try
        {
            Write-Verbose -Message "Assigning $($licenses.Count) licences to new user"
            Set-AzureADUserLicense -ObjectId $UserPrincipalName `
                -AssignedLicenses $licenses `
                -ErrorAction SilentlyContinue
        }
        catch
        {
            $Message = "Could not assign license {$($newLicenseAssignment)} to user {$($UserPrincipalName)}"
            New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Testing configuration of Office 365 User $UserPrincipalName"

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' `
        -InboundParameters $PSBoundParameters

    $users = Get-AzureADUser -All $true
    $dscContent = ""
    $i = 1
    Write-Host "`r`n" -NoNewLine
    foreach ($user in $users)
    {
        Write-Host "    |---[$i/$($users.Length)] $($user.UserPrincipalName)" -NoNewLine
        $userUPN = $user.UserPrincipalName
        if (-not [System.String]::IsNullOrEmpty($userUPN))
        {
            $Params = @{
                UserPrincipalName     = $userUPN
                GlobalAdminAccount    = $GlobalAdminAccount
                Password              = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
            }

            $Results = Get-TargetResource @Params
            if ($null -ne $Results.UserPrincipalName)
            {
                $Results.Password = Resolve-Credentials -UserName "globaladmin"
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                        -Results $Results
                $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -GlobalAdminAccount $GlobalAdminAccount
                $dscContent = Convert-DSCStringParamToVariable -DSCBlock $dscContent -ParameterName "Password"
            }
        }
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        $i++
    }
    return $dscContent
}

Export-ModuleMember -Function *-TargetResource
