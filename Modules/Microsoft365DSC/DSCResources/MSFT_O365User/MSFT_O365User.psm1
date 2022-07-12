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
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Write-Verbose -Message "Getting configuration of Office 365 User $UserPrincipalName"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = @{
        UserPrincipalName     = $null
        DisplayName           = $null
        FirstName             = $null
        LastName              = $null
        UsageLocation         = $null
        LicenseAssignment     = $null
        Password              = $null
        Credential            = $Credential
        ApplicationId         = $ApplicationId
        TenantId              = $TenantId
        CertificateThumbprint = $CertificateThumbprint
        ApplicationSecret     = $ApplicationSecret
        Ensure                = "Absent"
    }

    try
    {
        Write-Verbose -Message "Getting Office 365 User $UserPrincipalName"
        $user = Get-MgUser -UserId $UserPrincipalName -ErrorAction SilentlyContinue
        if ($null -eq $user)
        {
            Write-Verbose -Message "The specified User doesn't already exist."
            return $nullReturn
        }

        Write-Verbose -Message "Found User $($UserPrincipalName)"
        $currentLicenseAssignment = @()
        $skus = Get-MgUserLicenseDetail -UserId $UserPrincipalName -ErrorAction Stop
        foreach ($sku in $skus)
        {
            $currentLicenseAssignment += $sku.SkuPartNumber
        }

        $userPasswordPolicyInfo = $user | Select-Object UserprincipalName, @{
            N = "PasswordNeverExpires"; E = { $_.PasswordPolicies -contains "DisablePasswordExpiration" }
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
            Office                = $user.OfficeLocation
            PasswordNeverExpires  = $passwordNeverExpires
            PhoneNumber           = $user.TelephoneNumber
            PostalCode            = $user.PostalCode
            PreferredLanguage     = $user.PreferredLanguage
            State                 = $user.State
            StreetAddress         = $user.StreetAddress
            Title                 = $user.JobTitle
            UserType              = $user.UserType
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            Ensure                = "Present"
        }
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $nullReturn
    }
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
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    # PreferredDataLocation is no longer an accepted value;
    if (![System.String]::IsNullOrEmpty($PreferredDataLocation))
    {
        Write-Warning "[DEPRECATED] Property PreferredDataLocation is no longer supported by resource O365USer"
    }

    Write-Verbose -Message "Setting configuration of Office 365 User $UserPrincipalName"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    $user = Get-TargetResource @PSBoundParameters
    if ($user.Ensure -eq 'Present' -and $Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Removing User {$UserPrincipalName}"
        Remove-MgUser -UserId $UserPrincipalName
    }
    else
    {
        $PasswordPolicies = $null
        if ($PasswordNeverExpires)
        {
            $PasswordPolicies = 'DisablePasswordExpiration'
        }
        else
        {
            $PasswordPolicies = "None"
        }
        $CreationParams = @{
            City                       = $City
            Country                    = $Country
            Department                 = $Department
            DisplayName                = $DisplayName
            FacsimileTelephoneNumber   = $Fax
            GivenName                  = $FirstName
            JobTitle                   = $Title
            Mobile                     = $MobilePhone
            PasswordPolicies           = $PasswordPolicies
            OfficeLocation             = $Office
            PostalCode                 = $PostalCode
            PreferredLanguage          = $PreferredLanguage
            State                      = $State
            StreetAddress              = $StreetAddress
            Surname                    = $LastName
            TelephoneNumber            = $PhoneNumber
            UsageLocation              = $UsageLocation
            UserPrincipalName          = $UserPrincipalName
            UserType                   = $UserType
        }
        $CreationParams = Remove-NullEntriesFromHashtable -Hash $CreationParams

        $licenses = @{}

        foreach ($licenseSkuPart in $LicenseAssignment)
        {
            Write-Verbose -Message "Adding License {$licenseSkuPart} to the Queue"
            $license = @{
                SkuId = (Get-MgSubscribedSku | Where-Object -Property SkuPartNumber -Value $licenseSkuPart -EQ).SkuID
            }

            # Set the Office license as the license we want to add in the $licenses object
            if ($licenses.Keys -NotContains "AddLicenses")
            {
                $licenses.Add("AddLicenses", @($license))
            }
            else
            {
                $licenses.AddLicenses += $license
            }
        }

        foreach ($currentLicense in $user.LicenseAssignment)
        {
            if ($LicenseAssignment -and -not $LicenseAssignment.Contains($currentLicense))
            {
                Write-Verbose -Message "Removing {$currentLicense} from user {$UserPrincipalName}"
                $license = @{
                    SkuId = (Get-MgSubscribedSku | Where-Object -Property SkuPartNumber -Value $currentLicense -EQ).SkuID
                }
                if ( $licenses.Keys -NotContains "AddLicenses")
                {
                    $licenses.Add("RemoveLicenses", @($license))
                }
                else
                {
                    $licenses.RemoveLicenses += $license
                }
            }
        }

        if ($user.UserPrincipalName)
        {

            if ($null -ne $licenses -and `
                ($licenses.AddLicenses.Length -gt 0 -or $licenses.RemoveLicenses.Length -gt 0))
            {
                Write-Verbose -Message "Updating License Assignment {$($licenses[0] | Out-String)}"
                try
                {
                    Write-Verbose -Message "Assigning $($licenses.Count) licences to existing user"
                    Update-MgUser -UserId $UserPrincipalName `
                        -AssignedLicenses $licenses `
                        -ErrorAction SilentlyContinue
                }
                catch
                {
                    $Message = "License {$($LicenseAssignment)} doesn't exist in tenant."
                    Write-Verbose $Message
                    New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
                }
            }

            Write-Verbose -Message "Updating Office 365 User $UserPrincipalName Information"
            $CreationParams.Add("UserId", $UserPrincipalName)
            $user = Update-MgUser @CreationParams
        }
        else
        {
            Write-Verbose -Message "Creating Office 365 User $UserPrincipalName"
            $CreationParams.Add("AccountEnabled", $true)
            $PasswordProfile = @{
                Password = 'TempP@ss'
            }
            $CreationParams.Add("AssignedLicenses", $licenses)
            $CreationParams.Add("PasswordProfile", $PasswordProfile)
            $CreationParams.Add("MailNickName", $UserPrincipalName.Split('@')[0])
            $user = New-MgUser @CreationParams
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
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Office 365 User $UserPrincipalName"

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
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
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $users = Get-MgUser -All -ErrorAction Stop
        $dscContent = ""
        $i = 1
        Write-Host "`r`n" -NoNewline
        foreach ($user in $users)
        {
            Write-Host "    |---[$i/$($users.Length)] $($user.UserPrincipalName)" -NoNewline
            $userUPN = $user.UserPrincipalName
            if (-not [System.String]::IsNullOrEmpty($userUPN))
            {
                $Params = @{
                    UserPrincipalName     = $userUPN
                    Credential            = $Credential
                    Password              = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    ApplicationSecret     = $ApplicationSecret
                }

                $Results = Get-TargetResource @Params
                $Results.Password = "New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));"
                if ($null -ne $Results.UserPrincipalName)
                {
                    $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                        -Results $Results
                    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                        -ConnectionMode $ConnectionMode `
                        -ModulePath $PSScriptRoot `
                        -Results $Results `
                        -Credential $Credential
                    $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Password"
                    $dscContent += $currentDSCBlock

                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                        -FileName $Global:PartialExportFileName
                }
            }
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
