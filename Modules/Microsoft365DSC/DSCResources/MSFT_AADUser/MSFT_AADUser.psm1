Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADUser'

$Script:propertiesToRetrieve = @('Id', 'AccountEnabled', 'UserPrincipalName', 'DisplayName', 'GivenName', 'Surname', 'UsageLocation', 'City', 'Country', 'Department', 'FaxNumber', 'MobilePhone', 'OfficeLocation', 'Mail', 'OtherMails', 'BusinessPhones', 'PostalCode', 'PreferredLanguage', 'State', 'StreetAddress', 'JobTitle', 'UserType', 'PasswordPolicies')
$Script:creationParamsMap = @{AccountEnabled = 'AccountEnabled'; City = 'City'; Country = 'Country'; Department = 'Department'; DisplayName = 'DisplayName'; FaxNumber = 'Fax'; GivenName = 'FirstName'; JobTitle = 'Title'; MobilePhone = 'MobilePhone'; OfficeLocation = 'Office'; Mail = 'Mail'; OtherMails = 'OtherMails'; PostalCode = 'PostalCode'; PreferredLanguage = 'PreferredLanguage'; State = 'State'; StreetAddress = 'StreetAddress'; Surname = 'LastName'; BusinessPhones = 'PhoneNumber'; UsageLocation = 'UsageLocation'; UserPrincipalName = 'UserPrincipalName'; UserType = 'UserType'; PasswordPolicies = 'PasswordPolicies'}

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
        [System.Boolean]
        $AccountEnabled,

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
        [System.String[]]
        $MemberOf,

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
        [System.String]
        $Mail,

        [Parameter()]
        [System.String[]]
        $OtherMails,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of Office 365 User $UserPrincipalName"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.UserPrincipalName -ne $UserPrincipalName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
                AccountEnabled        = $null
                DisplayName           = $null
                FirstName             = $null
                LastName              = $null
                UsageLocation         = $null
                LicenseAssignment     = $null
                MemberOf              = $null
                Mail                  = $null
                OtherMails            = $null
                Password              = $null
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                ApplicationSecret     = $ApplicationSecret
                Ensure                = 'Absent'
                AccessTokens          = $AccessTokens
            }

            Write-Verbose -Message "Getting Office 365 User $UserPrincipalName"
            $user = Get-MgUser -UserId $UserPrincipalName -Property $Script:propertiesToRetrieve -ErrorAction SilentlyContinue
            if ($null -eq $user)
            {
                Write-Verbose -Message "The specified User doesn't already exist."
                return $nullReturn
            }
        }
        else
        {
            Write-Verbose -Message 'Retrieving user from the exported instances'
            $user = $Script:exportedInstance
        }

        $batchRequests = @(
            @{
                id     = 'License'
                method = 'GET'
                url    = "/users/$($UserPrincipalName)/licenseDetails"
            }
            @{
                id      = 'MemberOf'
                method  = 'GET'
                url     = "/users/$($UserPrincipalName)/memberOf?`$select=displayName&`$filter=not(groupTypes/any(c:c eq 'DynamicMembership'))"
                headers = @{
                    'ConsistencyLevel' = 'eventual'
                }
            }
        )
        $batchResponse = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests

        # If the user was deleted in the meantime, then return an empty hashtable
        # This only happens during Export because we cache the user objects
        # During normal Get or Test, we would have already returned $nullReturn above
        if ($null -ne $Script:exportedInstance -and $batchResponse.status -contains '404')
        {
            Write-Verbose -Message 'The specified user was deleted in the meantime.'
            return @{}
        }

        Write-Verbose -Message "Found User $($UserPrincipalName)"
        $currentLicenseAssignment = @()
        $skus = ($batchResponse | Where-Object -FilterScript { $_.id -eq 'License' }).body.value
        foreach ($sku in $skus)
        {
            $currentLicenseAssignment += $sku.SkuPartNumber
        }

        # return membership of static groups only
        [array]$currentMemberOf = ($batchResponse | Where-Object -FilterScript { $_.id -eq 'MemberOf' }).body.value.DisplayName

        $userPasswordPolicyInfo = $user | Select-Object UserprincipalName, @{
            N = 'PasswordNeverExpires'; E = { $_.PasswordPolicies -contains 'DisablePasswordExpiration' }
        }
        $passwordNeverExpires = $userPasswordPolicyInfo.PasswordNeverExpires

        if ($null -eq $Script:allDirectoryRoleAssignment)
        {
            $Script:allDirectoryRoleAssignment = Get-MgBetaRoleManagementDirectoryRoleAssignment -All
        }
        $assignedRoles = $Script:allDirectoryRoleAssignment | Where-Object -FilterScript { $_.PrincipalId -eq $user.Id }

        $rolesValue = @()
        if ($null -eq $Script:allAssignedRoles -and $assignedRoles.Length -gt 0)
        {
            $Script:allAssignedRoles = Get-MgBetaRoleManagementDirectoryRoleDefinition -All
        }
        foreach ($assignedRole in $assignedRoles)
        {
            $currentRoleInfo = $Script:allAssignedRoles | Where-Object -FilterScript { $_.Id -eq $assignedRole.RoleDefinitionId }
            $rolesValue += $currentRoleInfo.DisplayName
        }

        $results = @{
            UserPrincipalName     = $UserPrincipalName
            AccountEnabled        = $user.AccountEnabled
            DisplayName           = $user.DisplayName
            FirstName             = $user.GivenName
            LastName              = $user.Surname
            UsageLocation         = $user.UsageLocation
            LicenseAssignment     = $currentLicenseAssignment
            MemberOf              = $currentMemberOf
            Password              = $Password
            City                  = $user.City
            Country               = $user.Country
            Department            = $user.Department
            Fax                   = $user.FaxNumber
            MobilePhone           = $user.MobilePhone
            Office                = $user.OfficeLocation
            Mail                  = $user.Mail
            OtherMails            = $user.OtherMails
            PasswordNeverExpires  = $passwordNeverExpires
            PasswordPolicies      = $user.PasswordPolicies
            PhoneNumber           = $user.BusinessPhones | Select-Object -First 1
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
            AccessTokens          = $AccessTokens
        }
        return $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
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
        [System.Boolean]
        $AccountEnabled,

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
        [System.String[]]
        $MemberOf,

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
        [System.String]
        $Mail,

        [Parameter()]
        [System.String[]]
        $OtherMails,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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

    $user = Get-TargetResource @PSBoundParameters
    if ($user.Ensure -eq 'Present' -and $Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Removing User {$UserPrincipalName}"
        Remove-MgUser -UserId $UserPrincipalName
    }
    elseif ($Ensure -eq 'Present')
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

        $creationParams = @{}
        foreach ($kvp in $Script:creationParamsMap.GetEnumerator())
        {
            if ($PSBoundParameters.ContainsKey($($kvp.Value)))
            {
                $creationParams.Add($kvp.Key, $PSBoundParameters.$($kvp.Value))
            }
        }
        $creationParams = Remove-NullEntriesFromHashtable -Hash $CreationParams
        $creationParams = Rename-M365DSCCimInstanceParameter -Properties $creationParams

        #region Licenses
        if ($null -ne $LicenseAssignment)
        {
            [Array] $currentLicenses = $user.LicenseAssignment
            if ($null -eq $currentLicenses)
            {
                $currentLicenses = @()
            }
            [Array]$licenseDifferences = Compare-Object -ReferenceObject $LicenseAssignment -DifferenceObject $currentLicenses
            if ($licenseDifferences.Length -gt 0)
            {
                $licenses = @{addLicenses = @(); removeLicenses = @(); }

                $SubscribedSku = Get-MgBetaSubscribedSku
                foreach ($licenseSkuPart in $LicenseAssignment)
                {
                    Write-Verbose -Message "Adding License {$licenseSkuPart} to the Queue"
                    $license = @{
                        skuId = ($SubscribedSku | Where-Object -Property SkuPartNumber -Value $licenseSkuPart -EQ).SkuID
                    }

                    # Set the Office license as the license we want to add in the $licenses object
                    $licenses.addLicenses += $license
                }

                foreach ($currentLicense in $user.LicenseAssignment)
                {
                    if ($LicenseAssignment -and -not $LicenseAssignment.Contains($currentLicense))
                    {
                        Write-Verbose -Message "Removing {$currentLicense} from user {$UserPrincipalName}"
                        $license = @{
                            skuId = ($SubscribedSku | Where-Object -Property SkuPartNumber -Value $currentLicense -EQ).SkuID
                        }
                        $licenses.removeLicenses += $license
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
                Write-Verbose -Message 'PasswordProfile property will not be updated'
            }

            Update-MgUser -UserId $UserPrincipalName -BodyParameter $creationParams
            $userId = (Get-MgUser -UserId $UserPrincipalName).Id
        }
        else
        {

            if ($null -ne $Password)
            {
                $passwordValue = $Password.GetNetworkCredential().Password
            }
            else
            {
                if ($PSVersionTable.PSVersion.Major -eq 5)
                {
                    Add-Type -AssemblyName System.Web
                    $passwordValue = [System.Web.Security.Membership]::GeneratePassword(30, 2)
                }
                else
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
                password = $passwordValue
            }
            $creationParams.Add('passwordProfile', $PasswordProfile)

            Write-Verbose -Message "Creating Office 365 User $UserPrincipalName"
            if (-not $creationParams.ContainsKey('accountEnabled') -or $null -eq $creationParams.accountEnabled)
            {
                $creationParams.accountEnabled = $true
            }
            $creationParams.Add('mailNickName', $UserPrincipalName.Split('@')[0])
            Write-Verbose -Message "Creating new user with values: $(Convert-M365DscHashtableToString -Hashtable $creationParams)"
            $user = New-MgUser -BodyParameter $creationParams
            $userId = $user.Id
        }

        #region Assign Licenses
        try
        {
            if ($licenseDifferences.Length -gt 0)
            {
                Write-Verbose -Message "Updating License assignments with values: $(Convert-M365DscHashtableToString -Hashtable $licenses)"
                Invoke-M365DSCCommand -ScriptBlock {
                    Set-MgUserLicense -UserId $user.UserPrincipalName -AddLicenses $licenses.addLicenses -RemoveLicenses $licenses.removeLicenses
                } -RetryOnNotFoundError
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

        #region Update MemberOf groups - if specified
        if ($null -ne $MemberOf)
        {
            if ($null -eq $user.MemberOf)
            {
                # user is not currently a member of any groups, add user to groups listed in MemberOf
                foreach ($memberOfGroup in $MemberOf)
                {
                    $group = Get-MgGroup -Filter "DisplayName eq '$($memberOfGroup -replace "'", "''")'" -Property Id, GroupTypes
                    if ($null -eq $group)
                    {
                        New-M365DSCLogEntry -Message 'Error updating data:' `
                            -Exception "Attempting to add a user to a group that doesn't exist" `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $TenantId `
                            -Credential $Credential

                        throw "Group '$memberOfGroup' does not exist in tenant"
                    }
                    if ($group.GroupTypes -contains 'DynamicMembership')
                    {
                        New-M365DSCLogEntry -Message 'Error updating data:' `
                            -Exception 'Attempting to add a user to a dynamic group' `
                            -Source $($MyInvocation.MyCommand.Source) `
                            -TenantId $TenantId `
                            -Credential $Credential

                        throw "Cannot add user $UserPrincipalName to group '$memberOfGroup' because it is a dynamic group"
                    }
                    Invoke-M365DSCCommand -ScriptBlock {
                        New-MgGroupMemberByRef -GroupId $group.Id -BodyParameter @{
                            '@odata.id' = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "v1.0/directoryObjects/$userId"
                        }
                    } -RetryOnNotFoundError
                }
            }
            else
            {
                # user is a member of some groups, ensure that user is only a member of groups listed in MemberOf
                Compare-Object -ReferenceObject $MemberOf -DifferenceObject $user.MemberOf | ForEach-Object {
                    $group = Get-MgGroup -Filter "DisplayName eq '$($_.InputObject -replace "'", "''")'" -Property Id, GroupTypes
                    if ($_.SideIndicator -eq '<=')
                    {
                        # Group in MemberOf not present in groups that user is a member of, add user to group
                        if ($null -eq $group)
                        {
                            New-M365DSCLogEntry -Message 'Error updating data:' `
                                -Exception "Attempting to add a user to a group that doesn't exist" `
                                -Source $($MyInvocation.MyCommand.Source) `
                                -TenantId $TenantId `
                                -Credential $Credential

                            throw "Group '$($_.InputObject)' does not exist in tenant"
                        }
                        if ($group.GroupTypes -contains 'DynamicMembership')
                        {
                            New-M365DSCLogEntry -Message 'Error updating data:' `
                                -Exception 'Attempting to add a user to a dynamic group' `
                                -Source $($MyInvocation.MyCommand.Source) `
                                -TenantId $TenantId `
                                -Credential $Credential

                            throw "Cannot add user $UserPrincipalName to group '$($_.InputObject)' because it is a dynamic group"
                        }
                        New-MgGroupMemberByRef -GroupId $group.Id -BodyParameter @{
                            '@odata.id' = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "v1.0/directoryObjects/$userId"
                        } | Out-Null
                    }
                    else
                    {

                        # Group that user is a member of is not present in MemberOf, remove user from group
                        # (no need to test for dynamic groups as they are ignored in Get-TargetResource)
                        Remove-MgGroupMemberDirectoryObjectByRef -GroupId $group.Id -DirectoryObjectId $userId
                    }
                }
            }
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
                $roleDefinitionId = (Get-MgBetaRoleManagementDirectoryRoleDefinition -Filter "DisplayName eq '$($roleDifference.InputObject -replace "'", "''")'").Id

                # Roles to remove
                if ($roleDifference.SideIndicator -eq '=>')
                {
                    $currentAssignment = Get-MgBetaRoleManagementDirectoryRoleAssignment -Filter "PrincipalId eq '$userId' and RoleDefinitionId eq '$roleDefinitionId'"

                    Write-Verbose -Message "Removing role assignment for user {$($user.UserPrincipalName)} for role {$($roleDifference.InputObject)}"
                    Remove-MgBetaRoleManagementDirectoryRoleAssignment -UnifiedRoleAssignmentId $currentAssignment.Id | Out-Null
                }
                # Roles to add
                elseif ($roleDifference.SideIndicator -eq '<=')
                {
                    Write-Verbose -Message "Creating role assignment for user {$($user.UserPrincipalName) for role {$($roleDifference.InputObject)}"
                    Invoke-M365DSCCommand -ScriptBlock {
                        New-MgBetaRoleManagementDirectoryRoleAssignment -PrincipalId $userId `
                            -RoleDefinitionId $roleDefinitionId `
                            -DirectoryScopeId '/' | Out-Null
                    } -RetryOnNotFoundError
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
        [System.Boolean]
        $AccountEnabled,

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
        [System.String[]]
        $MemberOf,

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
        [System.String]
        $Mail,

        [Parameter()]
        [System.String[]]
        $OtherMails,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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
        $ExportParameters = @{
            Filter      = $Filter
            All         = [switch]$true
            Property    = $Script:propertiesToRetrieve
            ErrorAction = 'Stop'
            Sort        = 'UserPrincipalName'
        }
        $queryTypes = @{
            'eq'         = @('assignedPlans/any(a:a/capabilityStatus)',
                'assignedPlans/any(a:a/service)',
                'assignedPlans/any(a:a/servicePlanId)',
                'authorizationInfo/certificateUserIds/any(p:p)',
                'businessPhones/any(p:p)',
                'companyName',
                'createdObjects/any(c:c/id)',
                'employeeHireDate',
                'employeeOrgData/costCenter',
                'employeeOrgData/division',
                'employeeType',
                'faxNumber',
                'mobilePhone',
                'officeLocation',
                'onPremisesExtensionAttributes/extensionAttribute1',
                'onPremisesExtensionAttributes/extensionAttribute10',
                'onPremisesExtensionAttributes/extensionAttribute11',
                'onPremisesExtensionAttributes/extensionAttribute12',
                'onPremisesExtensionAttributes/extensionAttribute13',
                'onPremisesExtensionAttributes/extensionAttribute14',
                'onPremisesExtensionAttributes/extensionAttribute15',
                'onPremisesExtensionAttributes/extensionAttribute2',
                'onPremisesExtensionAttributes/extensionAttribute3',
                'onPremisesExtensionAttributes/extensionAttribute4',
                'onPremisesExtensionAttributes/extensionAttribute5',
                'onPremisesExtensionAttributes/extensionAttribute6',
                'onPremisesExtensionAttributes/extensionAttribute7',
                'onPremisesExtensionAttributes/extensionAttribute8',
                'onPremisesExtensionAttributes/extensionAttribute9',
                'onPremisesSamAccountName',
                'passwordProfile/forceChangePasswordNextSignIn',
                'passwordProfile/forceChangePasswordNextSignInWithMfa',
                'postalCode',
                'preferredLanguage',
                'provisionedPlans/any(p:p/provisioningStatus)',
                'provisionedPlans/any(p:p/service)',
                'showInAddressList',
                'streetAddress')

            'startsWith' = @(
                'assignedPlans/any(a:a/service)',
                'businessPhones/any(p:p)',
                'companyName',
                'faxNumber',
                'mobilePhone',
                'officeLocation',
                'onPremisesSamAccountName',
                'postalCode',
                'preferredLanguage',
                'provisionedPlans/any(p:p/service)',
                'streetAddress'
            )
            'ge'         = @('employeeHireDate')
            'le'         = @('employeeHireDate')
            'eq Null'    = @(
                'city',
                'companyName',
                'country',
                'createdDateTime',
                'department',
                'displayName',
                'employeeId',
                'faxNumber',
                'givenName',
                'jobTitle',
                'mail',
                'mailNickname',
                'mobilePhone',
                'officeLocation',
                'onPremisesExtensionAttributes/extensionAttribute1',
                'onPremisesExtensionAttributes/extensionAttribute10',
                'onPremisesExtensionAttributes/extensionAttribute11',
                'onPremisesExtensionAttributes/extensionAttribute12',
                'onPremisesExtensionAttributes/extensionAttribute13',
                'onPremisesExtensionAttributes/extensionAttribute14',
                'onPremisesExtensionAttributes/extensionAttribute15',
                'onPremisesExtensionAttributes/extensionAttribute2',
                'onPremisesExtensionAttributes/extensionAttribute3',
                'onPremisesExtensionAttributes/extensionAttribute4',
                'onPremisesExtensionAttributes/extensionAttribute5',
                'onPremisesExtensionAttributes/extensionAttribute6',
                'onPremisesExtensionAttributes/extensionAttribute7',
                'onPremisesExtensionAttributes/extensionAttribute8',
                'onPremisesExtensionAttributes/extensionAttribute9',
                'onPremisesSecurityIdentifier',
                'onPremisesSyncEnabled',
                'passwordPolicies',
                'passwordProfile/forceChangePasswordNextSignIn',
                'passwordProfile/forceChangePasswordNextSignInWithMfa',
                'postalCode',
                'preferredLanguage',
                'state',
                'streetAddress',
                'surname',
                'usageLocation',
                'userType'
            )
        }

        # Initialize a flag to indicate whether the filter conditions match the attribute support
        $allConditionsMatched = $true

        # Check each condition in the filter against the support list
        # Assuming the provided PowerShell script is part of a larger context and the variable $Filter is defined elsewhere

        # Check if $Filter is not null
        if ($Filter)
        {
            # Check each condition in the filter against the support list
            foreach ($condition in $Filter.Split(' '))
            {
                if ($condition -match '(\w+)/(\w+):(\w+)')
                {
                    $attribute, $operation, $value = $matches[1], $matches[2], $matches[3]
                    if (-not $queryTypes.ContainsKey($operation) -or -not $queryTypes[$operation].Contains($attribute))
                    {
                        $allConditionsMatched = $false
                        break
                    }
                }
            }
        }

        # If all conditions match the support, add parameters to $ExportParameters
        if ($allConditionsMatched -or ($Filter -like '*endsWith*') -or ($Filter -like '*not*'))
        {
            $ExportParameters.Add('CountVariable', 'count')
            $ExportParameters.Add('ConsistencyLevel', 'eventual')
        }
        $Script:M365DSCExportInstances = Get-MgUser @ExportParameters

        $dscContent = [System.Text.StringBuilder]::new()
        $i = 1
        Write-M365DSCHost -Message "`r`n" -DeferWrite
        foreach ($user in $Script:M365DSCExportInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($Script:M365DSCExportInstances.Length)] $($user.UserPrincipalName)" -DeferWrite
            $userUPN = $user.UserPrincipalName
            if (-not [System.String]::IsNullOrEmpty($userUPN))
            {
                $Params = @{
                    UserPrincipalName     = $userUPN
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    ApplicationSecret     = $ApplicationSecret
                    AccessTokens          = $AccessTokens
                }

                $Script:exportedInstance = $user
                $Results = Get-TargetResource @Params
                $Results.Password = "New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString ((New-Guid).ToString()) -AsPlainText -Force))"
                if ($null -ne $Results.UserPrincipalName)
                {
                    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                        -ConnectionMode $ConnectionMode `
                        -ModulePath $PSScriptRoot `
                        -Results $Results `
                        -Credential $Credential `
                        -NoEscape @('Password')

                    [void]$dscContent.Append($currentDSCBlock)
                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                        -FileName $Global:PartialExportFileName
                }
            }
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
        }
        return $dscContent.ToString()
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
