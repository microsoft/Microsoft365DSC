Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXODistributionGroup'

$Script:displayNameProperties = @{
    IncludeAcceptMessagesOnlyFromDLMembersWithDisplayNames        = $true
    IncludeAcceptMessagesOnlyFromSendersOrMembersWithDisplayNames = $true
    IncludeAcceptMessagesOnlyFromWithDisplayNames                 = $true
    IncludeBypassModerationFromSendersOrMembersWithDisplayNames   = $true
    IncludeGrantSendOnBehalfToWithDisplayNames                    = $true
    IncludeManagedByWithDisplayNames                              = $true
    IncludeModeratedByWithDisplayNames                            = $true
}

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFrom,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFromDLMembers,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.Boolean]
        $BccBlocked,

        [Parameter()]
        [System.String[]]
        $BypassModerationFromSendersOrMembers,

        [Parameter()]
        [System.Boolean]
        $BypassNestedModerationEnabled,

        [Parameter()]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $EmailAddresses,

        [Parameter()]
        [System.String[]]
        $GrantSendOnBehalfTo,

        [Parameter()]
        [System.Boolean]
        $HiddenGroupMembershipEnabled,

        [Parameter()]
        [System.String[]]
        $ManagedBy,

        [Parameter()]
        [System.String]
        [ValidateSet('Open', 'Closed')]
        $MemberDepartRestriction,

        [Parameter()]
        [System.String]
        [ValidateSet('Open', 'Closed', 'ApprovalRequired')]
        $MemberJoinRestriction,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $ModeratedBy,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $OrganizationalUnit,

        [Parameter()]
        [System.String]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.Boolean]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.Boolean]
        $RoomList,

        [Parameter()]
        [System.Boolean]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [ValidateSet('Always', 'Internal', 'Never')]
        [System.String]
        $SendModerationNotifications,

        [Parameter()]
        [System.Boolean]
        $SendOofMessageToOriginatorEnabled,

        [Parameter()]
        [ValidateSet('Distribution', 'Security')]
        [System.String]
        $Type,

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

    Write-Verbose -Message "Getting configuration of Distribution Group for $Identity"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Name -ne $Name)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
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

            $nullReturn = $PSBoundParameters
            $nullReturn.Ensure = 'Absent'

            if (-not [System.String]::IsNullOrEmpty($PrimarySmtpAddress))
            {
                $distributionGroup = Get-DistributionGroup -Identity $PrimarySmtpAddress @Script:displayNameProperties -ErrorAction SilentlyContinue
            }
            else
            {
                $distributionGroup = Get-DistributionGroup -Identity $Identity @Script:displayNameProperties -ErrorAction SilentlyContinue
            }

            if ($null -eq $distributionGroup)
            {
                Write-Verbose -Message "Distribution Group $($Identity) does not exist."
                return $nullReturn
            }
        }
        else
        {
            $distributionGroup = $Script:exportedInstance
        }

        Write-Verbose -Message "Getting Distribution Group members for $Identity"
        if (-not [System.String]::IsNullOrEmpty($PrimarySmtpAddress))
        {
            $distributionGroupMembers = Get-DistributionGroupMember -Identity $PrimarySmtpAddress `
                -ErrorAction 'Stop' `
                -ResultSize 'Unlimited'
        }
        else
        {
            $distributionGroupMembers = Get-DistributionGroupMember -Identity $Identity `
                -ErrorAction 'Stop' `
                -ResultSize 'Unlimited'
        }

        $distributionMembersValue = @()
        foreach ($member in $distributionGroupMembers)
        {
            if (-not [System.String]::IsNullOrEmpty($member.PrimarySmtpAddress))
            {
                $distributionMembersValue += $member.PrimarySmtpAddress
            }
            else
            {
                # For RecipientType 'User', PrimarySmtpAddress is unavailable, but WindowsLiveID is, and works with Add-DistributionGroupMember
                $distributionMembersValue += $member.WindowsLiveID
            }
        }

        Write-Verbose -Message "Found existing Distribution Group {$Identity}."
        $descriptionValue = $null
        if ($distributionGroup.Description.Length -gt 0)
        {
            $descriptionValue = $distributionGroup.Description[0].Replace("`r", '').Replace("`n", '')
        }

        $groupTypeValue = 'Distribution'
        if (([System.String[]]$distributionGroup.GroupType.Replace(' ', '').Split(',')).Contains('SecurityEnabled'))
        {
            $groupTypeValue = 'Security'
        }

        $acceptMessagesOnlyFromValue = Get-DisplayNameSimplified -DisplayName $distributionGroup.AcceptMessagesOnlyFromWithDisplayNames
        $acceptMessagesOnlyFromDlMembersValue = Get-DisplayNameSimplified -DisplayName $distributionGroup.AcceptMessagesOnlyFromDLMembersWithDisplayNames
        $acceptMessagesOnlyFromSendersOrMembersValue = Get-DisplayNameSimplified -DisplayName $distributionGroup.AcceptMessagesOnlyFromWithDisplayNames
        $bypassModerationFromSendersOrMembersValue = Get-DisplayNameSimplified -DisplayName $distributionGroup.BypassModerationFromSendersOrMembersWithDisplayNames
        $grantSendOnBehalfToValue = Get-DisplayNameSimplified -DisplayName $distributionGroup.GrantSendOnBehalfToWithDisplayNames
        $managedByValue = Get-DisplayNameSimplified -DisplayName $distributionGroup.ManagedByWithDisplayName
        $moderatedByValue = Get-DisplayNameSimplified -DisplayName $distributionGroup.ModeratedByWithDisplayNames

        $result = @{
            Identity                               = $distributionGroup.Identity
            Alias                                  = $distributionGroup.Alias
            BccBlocked                             = $distributionGroup.BccBlocked
            BypassModerationFromSendersOrMembers   = $bypassModerationFromSendersOrMembersValue
            BypassNestedModerationEnabled          = $distributionGroup.BypassNestedModerationEnabled
            Description                            = $descriptionValue
            DisplayName                            = $distributionGroup.DisplayName
            HiddenGroupMembershipEnabled           = $distributionGroup.HiddenGroupMembershipEnabled
            ManagedBy                              = $managedByValue
            MemberDepartRestriction                = $distributionGroup.MemberDepartRestriction
            MemberJoinRestriction                  = $distributionGroup.MemberJoinRestriction
            Members                                = $distributionMembersValue
            ModeratedBy                            = $moderatedByValue
            ModerationEnabled                      = $distributionGroup.ModerationEnabled
            Name                                   = $distributionGroup.Name
            Notes                                  = $distributionGroup.Notes
            OrganizationalUnit                     = $distributionGroup.OrganizationalUnit
            PrimarySmtpAddress                     = $distributionGroup.PrimarySmtpAddress
            RequireSenderAuthenticationEnabled     = $distributionGroup.RequireSenderAuthenticationEnabled
            RoomList                               = $distributionGroup.RoomList
            SendModerationNotifications            = $distributionGroup.SendModerationNotifications
            AcceptMessagesOnlyFrom                 = $acceptMessagesOnlyFromValue
            AcceptMessagesOnlyFromDLMembers        = $acceptMessagesOnlyFromDlMembersValue
            AcceptMessagesOnlyFromSendersOrMembers = $acceptMessagesOnlyFromSendersOrMembersValue
            CustomAttribute1                       = $distributionGroup.CustomAttribute1
            CustomAttribute2                       = $distributionGroup.CustomAttribute2
            CustomAttribute3                       = $distributionGroup.CustomAttribute3
            CustomAttribute4                       = $distributionGroup.CustomAttribute4
            CustomAttribute5                       = $distributionGroup.CustomAttribute5
            CustomAttribute6                       = $distributionGroup.CustomAttribute6
            CustomAttribute7                       = $distributionGroup.CustomAttribute7
            CustomAttribute8                       = $distributionGroup.CustomAttribute8
            CustomAttribute9                       = $distributionGroup.CustomAttribute9
            CustomAttribute10                      = $distributionGroup.CustomAttribute10
            CustomAttribute11                      = $distributionGroup.CustomAttribute11
            CustomAttribute12                      = $distributionGroup.CustomAttribute12
            CustomAttribute13                      = $distributionGroup.CustomAttribute13
            CustomAttribute14                      = $distributionGroup.CustomAttribute14
            CustomAttribute15                      = $distributionGroup.CustomAttribute15
            EmailAddresses                         = [System.String[]]$distributionGroup.EmailAddresses
            GrantSendOnBehalfTo                    = $grantSendOnBehalfToValue
            HiddenFromAddressListsEnabled          = [Boolean]$distributionGroup.HiddenFromAddressListsEnabled
            SendOofMessageToOriginatorEnabled      = [Boolean]$distributionGroup.SendOofMessageToOriginatorEnabled
            Type                                   = $groupTypeValue
            Ensure                                 = 'Present'
            Credential                             = $Credential
            ApplicationId                          = $ApplicationId
            CertificateThumbprint                  = $CertificateThumbprint
            CertificatePath                        = $CertificatePath
            CertificatePassword                    = $CertificatePassword
            ManagedIdentity                        = $ManagedIdentity.IsPresent
            TenantId                               = $TenantId
            AccessTokens                           = $AccessTokens
        }

        return $result
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
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFrom,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFromDLMembers,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.Boolean]
        $BccBlocked,

        [Parameter()]
        [System.String[]]
        $BypassModerationFromSendersOrMembers,

        [Parameter()]
        [System.Boolean]
        $BypassNestedModerationEnabled,

        [Parameter()]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $EmailAddresses,

        [Parameter()]
        [System.String[]]
        $GrantSendOnBehalfTo,

        [Parameter()]
        [System.Boolean]
        $HiddenGroupMembershipEnabled,

        [Parameter()]
        [System.String[]]
        $ManagedBy,

        [Parameter()]
        [System.String]
        [ValidateSet('Open', 'Closed')]
        $MemberDepartRestriction,

        [Parameter()]
        [System.String]
        [ValidateSet('Open', 'Closed', 'ApprovalRequired')]
        $MemberJoinRestriction,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $ModeratedBy,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $OrganizationalUnit,

        [Parameter()]
        [System.String]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.Boolean]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.Boolean]
        $RoomList,

        [Parameter()]
        [System.Boolean]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [ValidateSet('Always', 'Internal', 'Never')]
        [System.String]
        $SendModerationNotifications,

        [Parameter()]
        [System.Boolean]
        $SendOofMessageToOriginatorEnabled,

        [Parameter()]
        [ValidateSet('Distribution', 'Security')]
        [System.String]
        $Type,

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

    Write-Verbose -Message "Setting configuration of Distribution Group for $Identity"

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

    $currentDistributionGroup = Get-TargetResource @PSBoundParameters

    $currentParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    # Distribution group doesn't exist but it should
    $newGroup = $null
    if ($Ensure -eq 'Present' -and $currentDistributionGroup.Ensure -eq 'Absent')
    {
        $CreateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
        Write-Verbose -Message "The Distribution Group {$Identity} does not exist but it should. Creating it."
        $CreateParameters.Remove('Identity') | Out-Null
        $CreateParameters.Remove('AcceptMessagesOnlyFrom') | Out-Null
        $CreateParameters.Remove('AcceptMessagesOnlyFromSendersOrMembers') | Out-Null
        $CreateParameters.Remove('CustomAttribute1') | Out-Null
        $CreateParameters.Remove('CustomAttribute2') | Out-Null
        $CreateParameters.Remove('CustomAttribute3') | Out-Null
        $CreateParameters.Remove('CustomAttribute4') | Out-Null
        $CreateParameters.Remove('CustomAttribute5') | Out-Null
        $CreateParameters.Remove('CustomAttribute6') | Out-Null
        $CreateParameters.Remove('CustomAttribute7') | Out-Null
        $CreateParameters.Remove('CustomAttribute8') | Out-Null
        $CreateParameters.Remove('CustomAttribute9') | Out-Null
        $CreateParameters.Remove('CustomAttribute10') | Out-Null
        $CreateParameters.Remove('CustomAttribute11') | Out-Null
        $CreateParameters.Remove('CustomAttribute12') | Out-Null
        $CreateParameters.Remove('CustomAttribute13') | Out-Null
        $CreateParameters.Remove('CustomAttribute14') | Out-Null
        $CreateParameters.Remove('CustomAttribute15') | Out-Null
        $CreateParameters.Remove('EmailAddresses') | Out-Null
        $CreateParameters.Remove('GrantSendOnBehalfTo') | Out-Null
        $CreateParameters.Remove('HiddenFromAddressListsEnabled') | Out-Null
        $CreateParameters.Remove('SendOofMessageToOriginatorEnabled') | Out-Null
        $CreateParameters.Remove('BypassModerationFromSendersOrMembers') | Out-Null
        $newGroup = New-DistributionGroup @CreateParameters
        Start-Sleep -Seconds 5
        Write-Verbose -Message "New Distribution Group with Identity {$($newGroup.Identity)} was successfully created"
    }
    # Distribution group exists but shouldn't
    elseif ($Ensure -eq 'Absent' -and $currentDistributionGroup.Ensure -eq 'Present')
    {
        Write-Verbose -Message "The Distribution Group {$Identity} exists but shouldn't. Removing it."
        # Use the group identity value retrieved from Get-TargetResource, in case we got the group using PrimarySmtpAddress
        Remove-DistributionGroup -Identity $currentDistributionGroup.Identity `
            -BypassSecurityGroupManagerCheck `
            -Confirm:$false
    }
    # Update even if we just created the group. There are properties that can only be set with the set- cmdlet.
    if ($Ensure -eq 'Present')
    {
        # If this is a newly created group, use the new group identity
        if ($null -ne $newGroup)
        {
            $currentParameters.Identity = $newGroup.Identity
        }
        # Otherwise, use the existing group identity (using the value retrieved from Get-TargetResource, in the event that we got the group using PrimarySmtpAddress)
        else
        {
            $currentParameters.Identity = $currentDistributionGroup.Identity
        }

        $currentParameters.Remove('Type') | Out-Null
        Write-Verbose -Message "Updating Distribution Group {$Identity} with values: $(Convert-M365DscHashtableToString -Hashtable $currentParameters)"

        if ($null -ne $OrganizationalUnit -and $currentDistributionGroup.OrganizationalUnit -ne $OrganizationalUnit)
        {
            Write-Warning -Message 'Desired and current OrganizationalUnit values differ. This property cannot be updated once the distribution group has been created. Delete and recreate the distribution group to update the value.'
        }
        $currentParameters.Remove('OrganizationalUnit') | Out-Null
        $currentParameters.Remove('Type') | Out-Null

        # Members
        if ($null -ne $Members)
        {
            $membersDiff = Compare-Object -ReferenceObject $currentDistributionGroup.Members -DifferenceObject $Members
            $membersToAdd = @()
            $membersToRemove = @()
            foreach ($difference in $membersDiff)
            {
                if ($difference.SideIndicator -eq '=>')
                {
                    $membersToAdd += $difference.InputObject
                }
                elseif ($difference.SideIndicator -eq '<=')
                {
                    $membersToRemove += $difference.InputObject
                }
            }

            foreach ($member in $membersToAdd)
            {
                Write-Verbose -Message "Adding member {$member}"
                # Use the group identity value retrieved from Get-TargetResource, in case we got the group using PrimarySmtpAddress
                Add-DistributionGroupMember -Identity $currentParameters.Identity -Member $member -BypassSecurityGroupManagerCheck
            }
            foreach ($member in $membersToRemove)
            {
                Write-Verbose -Message "Removing member {$member}"
                # Use the group identity value retrieved from Get-TargetResource, in case we got the group using PrimarySmtpAddress
                Remove-DistributionGroupMember -Identity $currentParameters.Identity `
                    -Member $member `
                    -BypassSecurityGroupManagerCheck `
                    -Confirm:$false
            }
            $currentParameters.Remove('Members') | Out-Null
        }

        if ($EmailAddresses.Length -gt 0)
        {
            $currentParameters.Remove('PrimarySmtpAddress') | Out-Null
        }

        if ($AcceptMessagesOnlyFrom.Length -gt 0)
        {
            $currentParameters.Remove('AcceptMessagesOnlyFromDLMembers') | Out-Null
            $currentParameters.Remove('AcceptMessagesOnlyFromSendersOrMembers') | Out-Null
        }
        Set-DistributionGroup @currentParameters -BypassSecurityGroupManagerCheck
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
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFrom,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFromDLMembers,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.Boolean]
        $BccBlocked,

        [Parameter()]
        [System.String[]]
        $BypassModerationFromSendersOrMembers,

        [Parameter()]
        [System.Boolean]
        $BypassNestedModerationEnabled,

        [Parameter()]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $EmailAddresses,

        [Parameter()]
        [System.String[]]
        $GrantSendOnBehalfTo,

        [Parameter()]
        [System.Boolean]
        $HiddenGroupMembershipEnabled,

        [Parameter()]
        [System.String[]]
        $ManagedBy,

        [Parameter()]
        [System.String]
        [ValidateSet('Open', 'Closed')]
        $MemberDepartRestriction,

        [Parameter()]
        [System.String]
        [ValidateSet('Open', 'Closed', 'ApprovalRequired')]
        $MemberJoinRestriction,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $ModeratedBy,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $OrganizationalUnit,

        [Parameter()]
        [System.String]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.Boolean]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.Boolean]
        $RoomList,

        [Parameter()]
        [System.Boolean]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [ValidateSet('Always', 'Internal', 'Never')]
        [System.String]
        $SendModerationNotifications,

        [Parameter()]
        [System.Boolean]
        $SendOofMessageToOriginatorEnabled,

        [Parameter()]
        [ValidateSet('Distribution', 'Security')]
        [System.String]
        $Type,

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

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        @compareParameters
    return $result
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

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
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
        [array] $exportedInstances = Get-DistributionGroup @Script:displayNameProperties -ResultSize 'Unlimited' -ErrorAction Stop

        $i = 1
        if ($exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }

        $dscContent = [System.Text.StringBuilder]::new()
        foreach ($distributionGroup in $exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($exportedInstances.Count)] $($distributionGroup.Identity)" -DeferWrite
            $params = @{
                Identity              = $distributionGroup.Identity
                PrimarySmtpAddress    = $distributionGroup.PrimarySmtpAddress
                Name                  = $distributionGroup.Name
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $distributionGroup
            $Results = Get-TargetResource @Params
            if ($Results.AcceptMessagesOnlyFromSendersOrMembers.Length -eq 0)
            {
                $Results.Remove('AcceptMessagesOnlyFromSendersOrMembers') | Out-Null
            }

            if ($Results.AcceptMessagesOnlyFrom.Length -eq 0)
            {
                $Results.Remove('AcceptMessagesOnlyFrom') | Out-Null
            }

            if ($Results.AcceptMessagesOnlyFromDLMembers.Length -eq 0)
            {
                $Results.Remove('AcceptMessagesOnlyFromDLMembers') | Out-Null
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            [void]$dscContent.Append($currentDSCBlock)

            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i ++
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

function Get-DisplayNameSimplified
{
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [AllowNull()]
        [System.String[]]
        $DisplayName
    )

    $simplifiedNames = @()
    foreach ($name in $DisplayName)
    {
        if ([System.String]::IsNullOrEmpty($name))
        {
            continue
        }
        $simplifiedNames += $name.Split(',')[0].Replace('(','')
    }
    return ,@($simplifiedNames | Sort-Object)
}

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        PostProcessing = {
            param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
            if (-not $ValuesToCheck.OrganizationalUnit)
            {
                $ValuesToCheck.Remove('OrganizationalUnit') | Out-Null
            }
            foreach ($key in $Script:displayNameProperties.Keys)
            {
                $key = $key.Replace("Include", "").Replace("WithDisplayNames", "").Replace("WithDisplayName", "")
                if ($DesiredValues.ContainsKey($key))
                {
                    $convertedValues = @()
                    foreach ($member in $DesiredValues.$key)
                    {
                        if ([System.Guid]::TryParse($member, [ref][System.Guid]::Empty))
                        {
                            $entry = Get-Recipient -Identity $member
                            $convertedValues += $entry.PrimarySmtpAddress
                        }
                        else
                        {
                            $convertedValues += $member
                        }
                    }
                    $DesiredValues.$key = $convertedValues
                }
            }
            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
