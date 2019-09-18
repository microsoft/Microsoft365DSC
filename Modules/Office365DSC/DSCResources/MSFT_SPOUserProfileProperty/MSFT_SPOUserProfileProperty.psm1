function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Properties,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting SPO Profile Properties for user {$UserName}"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform PnP

    $nullReturn = @{
        UserName           = $UserName
        Properties         = $Properties
        GlobalAdminAccount = $GlobalAdminAccount
        Ensure             = 'Absent'
    }

    try
    {
        $currentProperties = Get-PnPUserProfileProperty -Account $UserName
        $currentProperties = $currentProperties.UserProfileProperties

        $propertiesValue = @()

        foreach ($key in $currentProperties.Keys)
        {
            $convertedProperty = Get-SPOUserProfilePropertyInstance -Key $key -Value $currentProperties[$key]
            $propertiesValue += $convertedProperty
        }
        $result =  @{
            UserName           = $UserName
            Properties         = $propertiesValue
            GlobalAdminAccount = $GlobalAdminAccount
            Ensure             = "Present"
        }

        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-O365DscHashtableToString -Hashtable $result)"
        return $result
    }
    catch
    {
        throw $_
        return $nullReturn
    }

}
function Set-TargetResource
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Properties,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for SPO Sharing settings"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SharePointOnline

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("Verbose")
    $CurrentParameters.Remove("IsSingleInstance")

    if ($null -eq $SignInAccelerationDomain)
    {
        $CurrentParameters.Remove("SignInAccelerationDomain")
        $CurrentParameters.Remove("EnableGuestSignInAcceleration")#removing EnableGuestSignInAcceleration since it can only be configured with a configured SignINAccerlation domain
    }
    if ($SharingCapability -ne "ExternalUserAndGuestSharing")
    {
        Write-Verbose -Message "The sharing capabilities for the tenant are not configured to be ExternalUserAndGuestSharing for that the RequireAnonymousLinksExpireInDays property cannot be configured"
        $CurrentParameters.Remove("RequireAnonymousLinksExpireInDays")
    }
    if ($RequireAcceptingAccountMatchInvitedAccount -eq $false)
    {
        Write-Verbose -Message "RequireAcceptingAccountMatchInvitedAccount is set to be false. For that SharingAllowedDomainList / SharingBlockedDomainList cannot be configured"
        $CurrentParameters.Remove("SharingAllowedDomainList")
        $CurrentParameters.Remove("SharingBlockedDomainList")
    }
    if ($SharingDomainRestrictionMode -eq "None")
    {
        Write-Verbose -Message "SharingDomainRestrictionMode is set to None. For that SharingAllowedDomainList / SharingBlockedDomainList cannot be configured"
        $CurrentParameters.Remove("SharingAllowedDomainList")
        $CurrentParameters.Remove("SharingBlockedDomainList")
    }
    elseif ($SharingDomainRestrictionMode -eq "AllowList")
    {
        Write-Verbose -Message "SharingDomainRestrictionMode is set to AllowList. For that SharingBlockedDomainList cannot be configured"
        $CurrentParameters.Remove("SharingBlockedDomainList")
    }
    elseif ($SharingDomainRestrictionMode -eq "BlockList")
    {
        Write-Verbose -Message "SharingDomainRestrictionMode is set to BlockList. For that SharingAllowedDomainList cannot be configured"
        $CurrentParameters.Remove("SharingAllowedDomainList")
    }
    foreach ($value in $CurrentParameters.GetEnumerator())
    {
        Write-verbose -Message "Configuring Tenant with: $value"
    }
    Set-SPOTenant @CurrentParameters | Out-Null
}
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Properties,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for SPO Sharing settings"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                                  -DesiredValues $PSBoundParameters `
                                                  -ValuesToCheck @("IsSingleInstance", `
                                                                   "SharingCapability", `
                                                                   "ShowEveryoneClaim", `
                                                                   "ShowAllUsersClaim", `
                                                                   "ShowEveryoneExceptExternalUsersClaim", `
                                                                   "ProvisionSharedWithEveryoneFolder", `
                                                                   "EnableGuestSignInAcceleration", `
                                                                   "BccExternalSharingInvitations", `
                                                                   "BccExternalSharingInvitationsList", `
                                                                   "RequireAnonymousLinksExpireInDays", `
                                                                   "SharingAllowedDomainList", `
                                                                   "SharingBlockedDomainList", `
                                                                   "SharingDomainRestrictionMode", `
                                                                   "DefaultSharingLinkType", `
                                                                   "PreventExternalUsersFromResharing", `
                                                                   "ShowPeoplePickerSuggestionsForGuestUsers", `
                                                                   "FileAnonymousLinkType", `
                                                                   "FolderAnonymousLinkType", `
                                                                   "NotifyOwnersWhenItemsReshared", `
                                                                   "RequireAcceptingAccountMatchInvitedAccount", `
                                                                   "DefaultLinkPermission")

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
    Test-MSCloudLogin -Platform MSOnline -O365Credential $GlobalAdminAccount

    $users = Get-MsolUser
    $content = ""

    $i = 1
    foreach ($user in $users)
    {
        Write-Information "    [$i/$($users.Count)] Scanning Profile Properties for user {$($user.UserPrincipalName)}"

        $params = @{
            UserName           = $user.UserPrincipalName
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "SPOUserProfileProperty " + (New-GUID).ToString() + "`r`n"
        $content += "{`r`n"
        $content += Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += "}`r`n"

        $i++
    }

    return $content
}

function Get-SPOUserProfilePropertyInstance
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory=$true)]
        [System.String]
        $Key,

        [Parameter()]
        [System.String]
        $Value
    )

    $result = [PSCustomObject]@{
        Key   = $Key
        Value = $Value
    }

    return $result
}

function ConvertTo-SPOUserProfilePropertyInstanceString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Properties
    )

    $content = ""
    foreach ($property in $properties)
    {
        content += "            MSFT_SPOUserProfilePropertyInstance`r`n            {`r`n"
        content += "                Key   = `"$(property.Key)`"`r`n"
        content += "                Value = `"$($property.Value)`"`r`n"
        content += "            }`r`n"
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
