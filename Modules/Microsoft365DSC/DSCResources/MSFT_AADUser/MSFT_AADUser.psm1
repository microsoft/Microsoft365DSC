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
        $PasswordPolicies,

        [Parameter()]
        [System.String]
        $PhoneNumber,

        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [System.String]
        $PreferredLanguage,

        [Parameter()]
        [System.String[]]
        $Roles,

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
        [ValidateSet('Guest', 'Member', 'Other', 'Viral')]
        [System.String]
        $UserType,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )
    Write-Verbose -Message "Getting configuration of Office 365 User $UserPrincipalName"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
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
        Managedidentity       = $ManagedIdentity.IsPresent
        ApplicationSecret     = $ApplicationSecret
        Ensure                = 'Absent'
    }

    try
    {
        Write-Verbose -Message "Getting Office 365 User $UserPrincipalName"
        $propertiesToRetrieve = @('Id', 'UserPrincipalName', 'DisplayName', 'GivenName', 'Surname', 'UsageLocation', 'City', 'Country', 'Department', 'FacsimileTelephoneNumber', 'Mobile', 'OfficeLocation', 'TelephoneNumber', 'PostalCode', 'PreferredLanguage', 'State', 'StreetAddress', 'JobTitle', 'UserType', 'PasswordPolicies')
        $user = Get-MgUser -UserId $UserPrincipalName -Property $propertiesToRetrieve -ErrorAction SilentlyContinue
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
            N = 'PasswordNeverExpires'; E = { $_.PasswordPolicies -contains 'DisablePasswordExpiration' }
        }
        $passwordNeverExpires = $userPasswordPolicyInfo.PasswordNeverExpires

        $assignedRoles = Get-MgRoleManagementDirectoryRoleAssignment -Filter "PrincipalId eq '$($user.Id)'"
        $rolesValue = @()
        foreach ($assignedRole in $assignedRoles)
        {
            $currentRoleInfo = Get-MgRoleManagementDirectoryRoleDefinition -UnifiedRoleDefinitionId $assignedRole.RoleDefinitionId
            $rolesValue += $currentRoleInfo.DisplayName
        }

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
            PasswordPolicies      = $user.PasswordPolicies
            PhoneNumber           = $user.TelephoneNumber
            PostalCode            = $user.PostalCode
            PreferredLanguage     = $user.PreferredLanguage
            State                 = $user.State
            StreetAddress         = $user.StreetAddress
            Title                 = $user.JobTitle
            UserType              = $user.UserType
            Roles                 = $rolesValue
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            Ensure                = 'Present'
        }
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

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
        $PasswordPolicies,

        [Parameter()]
        [System.String]
        $PhoneNumber,

        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [System.String]
        $PreferredLanguage,

        [Parameter()]
        [System.String[]]
        $Roles,

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
        [ValidateSet('Guest', 'Member', 'Other', 'Viral')]
        [System.String]
        $UserType,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    Write-Verbose -Message "Setting configuration of Office 365 User $UserPrincipalName"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
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
            $PasswordPolicies = 'None'
        }
        $CreationParams = @{
            City                     = $City
            Country                  = $Country
            Department               = $Department
            DisplayName              = $DisplayName
            FacsimileTelephoneNumber = $Fax
            GivenName                = $FirstName
            JobTitle                 = $Title
            Mobile                   = $MobilePhone
            PasswordPolicies         = $PasswordPolicies
            OfficeLocation           = $Office
            PostalCode               = $PostalCode
            PreferredLanguage        = $PreferredLanguage
            State                    = $State
            StreetAddress            = $StreetAddress
            Surname                  = $LastName
            TelephoneNumber          = $PhoneNumber
            UsageLocation            = $UsageLocation
            UserPrincipalName        = $UserPrincipalName
            UserType                 = $UserType
        }
        $CreationParams = Remove-NullEntriesFromHashtable -Hash $CreationParams

        #region Licenses
        if ($LicenseAssignment -ne $null)
        {
            [Array] $currentLicenses = $user.LicenseAssignment
            if ($null -eq $currentLicenses)
            {
                $currentLicenses = @()
            }
            [Array]$licenseDifferences = Compare-Object -ReferenceObject $LicenseAssignment -DifferenceObject $currentLicenses
            if ($licenseDifferences.Length -gt 0)
            {
                $licenses = @{AddLicenses = @(); RemoveLicenses = @(); }

                $SubscribedSku = Get-MgSubscribedSku
                foreach ($licenseSkuPart in $LicenseAssignment)
                {
                    Write-Verbose -Message "Adding License {$licenseSkuPart} to the Queue"
                    $license = @{
                        SkuId = ($SubscribedSku | Where-Object -Property SkuPartNumber -Value $licenseSkuPart -EQ).SkuID
                    }

                    # Set the Office license as the license we want to add in the $licenses object
                    $licenses.AddLicenses += $license
                }

                foreach ($currentLicense in $user.LicenseAssignment)
                {
                    if ($LicenseAssignment -and -not $LicenseAssignment.Contains($currentLicense))
                    {
                        Write-Verbose -Message "Removing {$currentLicense} from user {$UserPrincipalName}"
                        $license = @{
                            SkuId = ($SubscribedSku | Where-Object -Property SkuPartNumber -Value $currentLicense -EQ).SkuID
                        }
                        $licenses.RemoveLicenses += $license
                    }
                }
            }
        }
        #endregion

        if ($null -ne $user.UserPrincipalName)
        {
            Write-Verbose -Message "Updating Office 365 User $UserPrincipalName Information"

            if ($null -ne $Password)
            {
                Write-Verbose -Message "PasswordProfile property will not be updated"
            }

            $CreationParams.Add('UserId', $UserPrincipalName)
            Update-MgUser @CreationParams
        }
        else
        {

            if ($null -ne $Password)
            {
                $passwordValue = $Password.GetNetworkCredential().Password
            }
            else
            {
                try
                {
                    # This only works in PowerShell 5.
                    Add-Type -AssemblyName System.Web
                    $passwordValue = [System.Web.Security.Membership]::GeneratePassword(30, 2)
                }
                catch
                {
                    $TokenSet = @{
                        U = [Char[]]'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                        L = [Char[]]'abcdefghijklmnopqrstuvwxyz'
                        N = [Char[]]'0123456789'
                        S = [Char[]]'!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~'
                    }

                    $Upper = Get-Random -Count 8 -InputObject $TokenSet.U
                    $Lower = Get-Random -Count 8 -InputObject $TokenSet.L
                    $Number = Get-Random -Count 8 -InputObject $TokenSet.N
                    $Special = Get-Random -Count 8 -InputObject $TokenSet.S

                    $StringSet = $Upper + $Lower + $Number + $Special

                    $stringPassword = (Get-Random -Count 30 -InputObject $StringSet) -join ''
                    $passwordValue = ConvertTo-SecureString $stringPassword -AsPlainText -Force
                }
            }

            $PasswordProfile = @{
                Password = $passwordValue
            }
            $CreationParams.Add('PasswordProfile', $PasswordProfile)

            Write-Verbose -Message "Creating Office 365 User $UserPrincipalName"
            $CreationParams.Add('AccountEnabled', $true)
            $CreationParams.Add('MailNickName', $UserPrincipalName.Split('@')[0])
            Write-Verbose -Message "Creating new user with values: $(Convert-M365DscHashtableToString -Hashtable $CreationParams)"
            $user = New-MgUser @CreationParams
        }

        #region Assign Licenses
        try
        {
            if ($licenseDifferences.Length -gt 0)
            {
                Write-Verbose -Message "Updating License assignments with values: $(Convert-M365DscHashtableToString -Hashtable $licenses)"
                Set-MgUserLicense -UserId $user.UserPrincipalName -AddLicenses $licenses.AddLicenses -RemoveLicenses $licenses.RemoveLicenses
            }
        }
        catch
        {
            New-M365DSCLogEntry -Message 'Error updating data:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            return $nullReturn
        }
        #endregion

        #region Roles
        if ($null -ne $Roles)
        {
            [Array] $currentRoles = $user.Roles
            if ($null -eq $currentRoles -or $currentRoles.Length -eq 0)
            {
                $currentRoles = @()
            }

            [Array]$diffRoles = Compare-Object -ReferenceObject $Roles -DifferenceObject $currentRoles

            if ($diffRoles.Length -gt 0)
            {
                Write-Verbose -Message "Current Roles: $($currentRoles -join ',')"
                Write-Verbose -Message "Desired Roles: $($Roles -join ',')"
            }

            foreach ($roleDifference in $diffRoles)
            {
                $roleDefinitionId = (Get-MgRoleManagementDirectoryRoleDefinition -Filter "DisplayName eq '$($roleDifference.InputObject)'").Id
                $userId = (Get-MgUser -UserId $UserPrincipalName).Id

                # Roles to remove
                if ($roleDifference.SideIndicator -eq '=>')
                {
                    $currentAssignment = Get-MgRoleManagementDirectoryRoleAssignment -Filter "PrincipalId eq '$userId' and RoleDefinitionId eq '$roleDefinitionId'"

                    Write-Verbose -Message "Removing role assignment for user {$($user.UserPrincipalName)} for role {$($roleDifference.InputObject)}"
                    Remove-MgRoleManagementDirectoryRoleAssignment -UnifiedRoleAssignmentId $currentAssignment.Id | Out-Null
                }
                # Roles to add
                elseif ($roleDifference.SideIndicator -eq '<=')
                {
                    Write-Verbose -Message "Creating role assignment for user {$($user.UserPrincipalName) for role {$($roleDifference.InputObject)}"
                    New-MgRoleManagementDirectoryRoleAssignment -PrincipalId $userId `
                        -RoleDefinitionId $roleDefinitionId `
                        -DirectoryScopeId '/' | Out-Null
                }
            }
        }
        #endregion
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
        $PasswordPolicies,

        [Parameter()]
        [System.String]
        $PhoneNumber,

        [Parameter()]
        [System.String]
        $PostalCode,

        [Parameter()]
        [System.String]
        $PreferredLanguage,

        [Parameter()]
        [System.String[]]
        $Roles,

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
        [ValidateSet('Guest', 'Member', 'Other', 'Viral')]
        [System.String]
        $UserType,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
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
        -ValuesToCheck @('Ensure', `
            'UserPrincipalName', `
            'LicenseAssignment', `
            'UsageLocation', `
            'FirstName', `
            'LastName', `
            'DisplayName', `
            'City', `
            'Country', `
            'Department', `
            'Fax', `
            'MobilePhone', `
            'Office', `
            'PasswordNeverExpires', `
            'PhoneNumber', `
            'PostalCode', `
            'PreferredLanguage', `
            'State', `
            'StreetAddress', `
            'Title', `
            'UserType',
        'Roles')

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
        [System.String]
        $Filter,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $users = Get-MgUser -Filter $Filter -All:$true -ErrorAction Stop

        $dscContent = [System.Text.StringBuilder]::new()
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
                    Managedidentity       = $ManagedIdentity.IsPresent
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

                    $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Password'
                    $dscContent.Append($currentDSCBlock) | Out-Null

                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                        -FileName $Global:PartialExportFileName
                }
            }
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent.ToString()
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
