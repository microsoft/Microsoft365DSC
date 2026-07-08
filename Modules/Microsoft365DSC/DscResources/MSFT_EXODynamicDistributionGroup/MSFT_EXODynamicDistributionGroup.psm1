function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateLength(1,64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFrom,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFromDLMembers,

        [Parameter()]
        [ValidateLength(1,64)]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String[]]
        $BypassModerationFromSendersOrMembers,

        [Parameter()]
        [System.String[]]
        $ConditionalCompany,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute10,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute11,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute12,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute13,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute14,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute15,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute4,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute5,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute6,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute7,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute8,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute9,

        [Parameter()]
        [System.String[]]
        $ConditionalDepartment,

        [Parameter()]
        [System.String[]]
        $ConditionalStateOrProvince,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [ValidateLength(0, 256)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $EmailAddresses,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute5,

        [Parameter()]
        [System.String[]]
        $GrantSendOnBehalfTo,

        [Parameter()]
        [System.Boolean]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [ValidateSet('AllRecipients','MailboxUsers','MailboxContacts','MailGroups','MailUsers','Resources')]
        [System.String[]]
        $IncludedRecipients,

        [Parameter()]
        [System.String]
        $MailTip,

        [Parameter()]
        [System.String[]]
        $MailTipTranslations,

        [Parameter()]
        [System.String]
        $ManagedBy,

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
        [ValidateLength(0,256)]
        [System.String]
        $PhoneticDisplayName,

        [Parameter()]
        [System.String]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.String]
        $RecipientContainer,

        [Parameter()]
        [System.String]
        $RecipientFilter,

        [Parameter()]
        [System.String[]]
        $RejectMessagesFrom,

        [Parameter()]
        [System.String[]]
        $RejectMessagesFromDLMembers,

        [Parameter()]
        [System.String[]]
        $RejectMessagesFromSendersOrMembers,

        [Parameter()]
        [System.Boolean]
        $ReportToManagerEnabled,

        [Parameter()]
        [System.Boolean]
        $ReportToOriginatorEnabled,

        [Parameter()]
        [System.Boolean]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [ValidateSet('Always','Internal','Never')]
        [System.String]
        $SendModerationNotifications,

        [Parameter()]
        [System.Boolean]
        $SendOofMessageToOriginatorEnabled,

        [Parameter()]
        [System.String]
        $SimpleDisplayName,

        [Parameter()]
        [System.String]
        $WindowsEmailAddress,

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

    Write-Verbose -Message "Getting configuration of the EXO Dynamic Distribution Group with Identity {$Identity}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Name -ne $Name)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
                -InboundParameters $PSBoundParameters

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            if (-not [System.String]::IsNullOrEmpty($PrimarySmtpAddress))
            {
                $instance = Get-DynamicDistributionGroup -Identity $PrimarySmtpAddress -ErrorAction SilentlyContinue
            }
            else
            {
                $instance = Get-DynamicDistributionGroup -Identity $Identity -ErrorAction SilentlyContinue
            }

            if ($null -eq $instance)
            {
                Write-Verbose -Message "Could not find an EXO Dynamic Distribution Group with Identity $($Identity)."
                return $nullResult
            }
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        Write-Verbose -Message "An EXO Dynamic Distribution Group with Identity {$Identity} was found"

        $acceptMessagesOnlyFromValue = @()
        if ($null -ne $instance.AcceptMessagesOnlyFrom)
        {
            Write-Verbose -Message "Getting Dynamic Distribution Group AcceptMessagesOnlyFrom for $Identity"
            $acceptMessagesOnlyFromValue += Get-ElementFromRecipientsCacheAsPrimarySmtpAddress -RecipientName $instance.AcceptMessagesOnlyFrom
        }

        $acceptMessagesOnlyFromDLMembersValue = @()
        if ($null -ne $instance.AcceptMessagesOnlyFromDLMembers)
        {
            Write-Verbose -Message "Getting Dynamic Distribution Group AcceptMessagesOnlyFromDLMembers for $Identity"
            $acceptMessagesOnlyFromDLMembersValue += Get-ElementFromRecipientsCacheAsPrimarySmtpAddress -RecipientName $instance.AcceptMessagesOnlyFromDLMembers
        }

        $bypassModerationFromSendersOrMembersValue = @()
        if ($null -ne $instance.BypassModerationFromSendersOrMembers)
        {
            Write-Verbose -Message "Getting Dynamic Distribution Group BypassModerationFromSendersOrMembers for $Identity"
            $bypassModerationFromSendersOrMembersValue += Get-ElementFromRecipientsCacheAsPrimarySmtpAddress -RecipientName $instance.BypassModerationFromSendersOrMembers
        }

        $grantSendOnBehalfToValue = @()
        if ($null -ne $instance.GrantSendOnBehalfTo)
        {
            Write-Verbose -Message "Getting Dynamic Distribution Group GrantSendOnBehalfTo for $Identity"
            $grantSendOnBehalfToValue += Get-ElementFromRecipientsCacheAsPrimarySmtpAddress -RecipientName $instance.GrantSendOnBehalfTo
        }

        $managedByValue = $null
        if ($null -ne $instance.ManagedBy)
        {
            Write-Verbose -Message "Getting Dynamic Distribution Group manager for $Identity"
            $managedByValue = Get-ElementFromRecipientsCacheAsPrimarySmtpAddress -RecipientName $instance.ManagedBy
        }

        $moderatedByValue = @()
        if ($null -ne $instance.ModeratedBy)
        {
            Write-Verbose -Message "Getting Dynamic Distribution Group moderators for $Identity"
            $moderatedByValue += Get-ElementFromRecipientsCacheAsPrimarySmtpAddress -RecipientName $instance.ModeratedBy
        }

        $rejectMessagesFromValue = @()
        if ($null -ne $instance.RejectMessagesFrom)
        {
            Write-Verbose -Message "Getting Dynamic Distribution Group RejectMessagesFrom for $Identity"
            $rejectMessagesFromValue += Get-ElementFromRecipientsCacheAsPrimarySmtpAddress -RecipientName $instance.RejectMessagesFrom
        }

        $rejectMessagesFromDLMembersValue = @()
        if ($null -ne $instance.RejectMessagesFromDLMembers)
        {
            Write-Verbose -Message "Getting Dynamic Distribution Group RejectMessagesFromDLMembers for $Identity"
            $rejectMessagesFromDLMembersValue += Get-ElementFromRecipientsCacheAsPrimarySmtpAddress -RecipientName $instance.RejectMessagesFromDLMembers
        }

        $results = @{
            AcceptMessagesOnlyFrom                 = $acceptMessagesOnlyFromValue
            AcceptMessagesOnlyFromDLMembers        = $acceptMessagesOnlyFromDLMembersValue
            Alias                                  = $instance.Alias
            BypassModerationFromSendersOrMembers   = $bypassModerationFromSendersOrMembersValue
            ConditionalCompany                     = $instance.ConditionalCompany
            ConditionalCustomAttribute1            = $instance.ConditionalCustomAttribute1
            ConditionalCustomAttribute10           = $instance.ConditionalCustomAttribute10
            ConditionalCustomAttribute11           = $instance.ConditionalCustomAttribute11
            ConditionalCustomAttribute12           = $instance.ConditionalCustomAttribute12
            ConditionalCustomAttribute13           = $instance.ConditionalCustomAttribute13
            ConditionalCustomAttribute14           = $instance.ConditionalCustomAttribute14
            ConditionalCustomAttribute15           = $instance.ConditionalCustomAttribute15
            ConditionalCustomAttribute2            = $instance.ConditionalCustomAttribute2
            ConditionalCustomAttribute3            = $instance.ConditionalCustomAttribute3
            ConditionalCustomAttribute4            = $instance.ConditionalCustomAttribute4
            ConditionalCustomAttribute5            = $instance.ConditionalCustomAttribute5
            ConditionalCustomAttribute6            = $instance.ConditionalCustomAttribute6
            ConditionalCustomAttribute7            = $instance.ConditionalCustomAttribute7
            ConditionalCustomAttribute8            = $instance.ConditionalCustomAttribute8
            ConditionalCustomAttribute9            = $instance.ConditionalCustomAttribute9
            ConditionalDepartment                  = $instance.ConditionalDepartment
            ConditionalStateOrProvince             = $instance.ConditionalStateOrProvince
            CustomAttribute1                       = $instance.CustomAttribute1
            CustomAttribute10                      = $instance.CustomAttribute10
            CustomAttribute11                      = $instance.CustomAttribute11
            CustomAttribute12                      = $instance.CustomAttribute12
            CustomAttribute13                      = $instance.CustomAttribute13
            CustomAttribute14                      = $instance.CustomAttribute14
            CustomAttribute15                      = $instance.CustomAttribute15
            CustomAttribute2                       = $instance.CustomAttribute2
            CustomAttribute3                       = $instance.CustomAttribute3
            CustomAttribute4                       = $instance.CustomAttribute4
            CustomAttribute5                       = $instance.CustomAttribute5
            CustomAttribute6                       = $instance.CustomAttribute6
            CustomAttribute7                       = $instance.CustomAttribute7
            CustomAttribute8                       = $instance.CustomAttribute8
            CustomAttribute9                       = $instance.CustomAttribute9
            DisplayName                            = $instance.DisplayName
            EmailAddresses                         = $instance.EmailAddresses
            ExtensionCustomAttribute1              = $instance.ExtensionCustomAttribute1
            ExtensionCustomAttribute2              = $instance.ExtensionCustomAttribute2
            ExtensionCustomAttribute3              = $instance.ExtensionCustomAttribute3
            ExtensionCustomAttribute4              = $instance.ExtensionCustomAttribute4
            ExtensionCustomAttribute5              = $instance.ExtensionCustomAttribute5
            ForceMembershipRefresh                 = $instance.ForceMembershipRefresh
            GrantSendOnBehalfTo                    = $grantSendOnBehalfToValue
            HiddenFromAddressListsEnabled          = $instance.HiddenFromAddressListsEnabled
            Identity                               = $instance.Identity
            IncludedRecipients                     = $instance.IncludedRecipients
            MailTip                                = $instance.MailTip
            MailTipTranslations                    = $instance.MailTipTranslations
            ManagedBy                              = $managedByValue
            ModeratedBy                            = $moderatedByValue
            ModerationEnabled                      = $instance.ModerationEnabled
            Name                                   = $instance.Name
            Notes                                  = $instance.Notes
            PhoneticDisplayName                    = $instance.PhoneticDisplayName
            PrimarySmtpAddress                     = $instance.PrimarySmtpAddress
            RecipientContainer                     = $instance.RecipientContainer
            RecipientFilter                        = Restore-OriginalRecipientFilter -ExpandedFilter $instance.RecipientFilter
            RejectMessagesFrom                     = $rejectMessagesFromValue
            RejectMessagesFromDLMembers            = $rejectMessagesFromDLMembersValue
            ReportToManagerEnabled                 = $instance.ReportToManagerEnabled
            ReportToOriginatorEnabled              = $instance.ReportToOriginatorEnabled
            RequireSenderAuthenticationEnabled     = $instance.RequireSenderAuthenticationEnabled
            SendModerationNotifications            = $instance.SendModerationNotifications
            SendOofMessageToOriginatorEnabled      = $instance.SendOofMessageToOriginatorEnabled
            SimpleDisplayName                      = $instance.SimpleDisplayName
            UpdateMemberCount                      = $instance.UpdateMemberCount
            WindowsEmailAddress                    = $instance.WindowsEmailAddress
            Ensure                                 = 'Present'
            Credential                             = $Credential
            ApplicationId                          = $ApplicationId
            TenantId                               = $TenantId
            CertificateThumbprint                  = $CertificateThumbprint
            ApplicationSecret                      = $ApplicationSecret
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

        return $nullResult
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

        [Parameter()]
        [ValidateLength(1,64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFrom,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFromDLMembers,

        [Parameter()]
        [ValidateLength(1,64)]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String[]]
        $BypassModerationFromSendersOrMembers,

        [Parameter()]
        [System.String[]]
        $ConditionalCompany,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute10,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute11,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute12,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute13,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute14,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute15,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute4,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute5,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute6,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute7,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute8,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute9,

        [Parameter()]
        [System.String[]]
        $ConditionalDepartment,

        [Parameter()]
        [System.String[]]
        $ConditionalStateOrProvince,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [ValidateLength(0, 256)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $EmailAddresses,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute5,

        [Parameter()]
        [System.String[]]
        $GrantSendOnBehalfTo,

        [Parameter()]
        [System.Boolean]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [ValidateSet('AllRecipients','MailboxUsers','MailboxContacts','MailGroups','MailUsers','Resources')]
        [System.String[]]
        $IncludedRecipients,

        [Parameter()]
        [System.String]
        $MailTip,

        [Parameter()]
        [System.String[]]
        $MailTipTranslations,

        [Parameter()]
        [System.String]
        $ManagedBy,

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
        [ValidateLength(0,256)]
        [System.String]
        $PhoneticDisplayName,

        [Parameter()]
        [System.String]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.String]
        $RecipientContainer,

        [Parameter()]
        [System.String]
        $RecipientFilter,

        [Parameter()]
        [System.String[]]
        $RejectMessagesFrom,

        [Parameter()]
        [System.String[]]
        $RejectMessagesFromDLMembers,

        [Parameter()]
        [System.String[]]
        $RejectMessagesFromSendersOrMembers,

        [Parameter()]
        [System.Boolean]
        $ReportToManagerEnabled,

        [Parameter()]
        [System.Boolean]
        $ReportToOriginatorEnabled,

        [Parameter()]
        [System.Boolean]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [ValidateSet('Always','Internal','Never')]
        [System.String]
        $SendModerationNotifications,

        [Parameter()]
        [System.Boolean]
        $SendOofMessageToOriginatorEnabled,

        [Parameter()]
        [System.String]
        $SimpleDisplayName,

        [Parameter()]
        [System.String]
        $WindowsEmailAddress,

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

    $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    if ($boundParameters.ContainsKey('RecipientFilter') -and -not [System.String]::IsNullOrEmpty($boundParameters['RecipientFilter']))
    {
        Write-Verbose -Message 'Removing Conditional* parameters because RecipientFilter is set'
        $boundParameters.Keys.Clone() | ForEach-Object {
            if ($_ -like 'Conditional*')
            {
                $boundParameters.Remove($_) | Out-Null
            }
        }
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $createParameters = ([Hashtable]$boundParameters).Clone()
        $onlyUpateParameters = @(
            'Identity',
            'AcceptMessagesOnlyFrom',
            'AcceptMessagesOnlyFromDLMembers',
            'BypassModerationFromSendersOrMembers',
            'CustomAttribute1',
            'CustomAttribute10',
            'CustomAttribute11',
            'CustomAttribute12',
            'CustomAttribute13',
            'CustomAttribute14',
            'CustomAttribute15',
            'CustomAttribute2',
            'CustomAttribute3',
            'CustomAttribute4',
            'CustomAttribute5',
            'CustomAttribute6',
            'CustomAttribute7',
            'CustomAttribute8',
            'CustomAttribute9',
            'EmailAddresses',
            'ExtensionCustomAttribute1',
            'ExtensionCustomAttribute2',
            'ExtensionCustomAttribute3',
            'ExtensionCustomAttribute4',
            'ExtensionCustomAttribute5',
            'GrantSendOnBehalfTo',
            'HiddenFromAddressListsEnabled',
            'MailTip',
            'MailTipTranslations',
            'ManagedBy',
            'Notes',
            'PhoneticDisplayName',
            'RejectMessagesFrom',
            'RejectMessagesFromDLMembers',
            'ReportToManagerEnabled',
            'ReportToOriginatorEnabled',
            'RequireSenderAuthenticationEnabled',
            'SendOofMessageToOriginatorEnabled',
            'SimpleDisplayName',
            'WindowsEmailAddress'
        )

        $updateParameters = @{}
        foreach ($param in $onlyUpateParameters)
        {
            if ($createParameters.ContainsKey($param) -and $param -ne 'Identity')
            {
                $updateParameters[$param] = $createParameters[$param]
            }
            $createParameters.Remove($param) | Out-Null
        }

        Write-Verbose -Message "Creating an EXO Dynamic Distribution Group with Identity {$Identity}"
        $group = New-DynamicDistributionGroup @createParameters

        if ($updateParameters.Count -gt 1)
        {
            Write-Verbose -Message "Updating the EXO Dynamic Distribution Group with Identity {$Identity} after creation"
            Set-DynamicDistributionGroup -Identity $group.Identity @updateParameters | Out-Null
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the EXO Dynamic Distribution Group with Identity {$Identity}"

        $updateParameters = ([Hashtable]$boundParameters).Clone()
        if ($EmailAddresses.Length -gt 0)
        {
            $updateParameters.Remove('PrimarySmtpAddress') | Out-Null
        }

        if ($AcceptMessagesOnlyFrom.Length -gt 0)
        {
            $updateParameters.Remove('AcceptMessagesOnlyFromDLMembers') | Out-Null
            $updateParameters.Remove('AcceptMessagesOnlyFromSendersOrMembers') | Out-Null
        }

        Set-DynamicDistributionGroup @updateParameters | Out-Null
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the EXO Dynamic Distribution Group with Identity {$Identity}"
        Remove-DynamicDistributionGroup -Identity $currentInstance.Identity
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

        [Parameter()]
        [ValidateLength(1,64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFrom,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFromDLMembers,

        [Parameter()]
        [ValidateLength(1,64)]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String[]]
        $BypassModerationFromSendersOrMembers,

        [Parameter()]
        [System.String[]]
        $ConditionalCompany,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute10,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute11,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute12,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute13,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute14,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute15,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute4,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute5,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute6,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute7,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute8,

        [Parameter()]
        [System.String[]]
        $ConditionalCustomAttribute9,

        [Parameter()]
        [System.String[]]
        $ConditionalDepartment,

        [Parameter()]
        [System.String[]]
        $ConditionalStateOrProvince,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [ValidateLength(0, 256)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $EmailAddresses,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute5,

        [Parameter()]
        [System.String[]]
        $GrantSendOnBehalfTo,

        [Parameter()]
        [System.Boolean]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [ValidateSet('AllRecipients','MailboxUsers','MailboxContacts','MailGroups','MailUsers','Resources')]
        [System.String[]]
        $IncludedRecipients,

        [Parameter()]
        [System.String]
        $MailTip,

        [Parameter()]
        [System.String[]]
        $MailTipTranslations,

        [Parameter()]
        [System.String]
        $ManagedBy,

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
        [ValidateLength(0,256)]
        [System.String]
        $PhoneticDisplayName,

        [Parameter()]
        [System.String]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.String]
        $RecipientContainer,

        [Parameter()]
        [System.String]
        $RecipientFilter,

        [Parameter()]
        [System.String[]]
        $RejectMessagesFrom,

        [Parameter()]
        [System.String[]]
        $RejectMessagesFromDLMembers,

        [Parameter()]
        [System.String[]]
        $RejectMessagesFromSendersOrMembers,

        [Parameter()]
        [System.Boolean]
        $ReportToManagerEnabled,

        [Parameter()]
        [System.Boolean]
        $ReportToOriginatorEnabled,

        [Parameter()]
        [System.Boolean]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [ValidateSet('Always','Internal','Never')]
        [System.String]
        $SendModerationNotifications,

        [Parameter()]
        [System.Boolean]
        $SendOofMessageToOriginatorEnabled,

        [Parameter()]
        [System.String]
        $SimpleDisplayName,

        [Parameter()]
        [System.String]
        $WindowsEmailAddress,

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
        [System.String]
        $Filter = "*",

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$getValue = Get-DynamicDistributionGroup -Filter $Filter -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Identity
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Identity              = $config.Identity
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
    }
    catch
    {
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

function Get-ElementFromRecipientsCacheAsPrimarySmtpAddress
{
    param
    (
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [System.String[]]
        $RecipientName
    )

    if ($null -eq $Script:RecipientsCache)
    {
        if ($null -eq $Script:RecipientsCache)
        {
            $Script:RecipientsCache = [System.Collections.Generic.Dictionary[System.String, System.Object]]::new()

        }
    }

    foreach ($name in $RecipientName)
    {
        if (-not $Script:RecipientsCache.ContainsKey($name))
        {
            Get-Recipient -Identity $name -ErrorAction SilentlyContinue | ForEach-Object {
                $Script:RecipientsCache[$_.Name] = @{
                    PrimarySmtpAddress = $_.PrimarySmtpAddress
                    WindowsLiveID      = $_.WindowsLiveID
                }
            }
        }
        $Script:RecipientsCache[$name].PrimarySmtpAddress
    }
}

<#
.SYNOPSIS
    Normalize RecipientFilter like Exchange Online's wrapping behavior.

.DESCRIPTION
    - Expects atomic conditions to be parenthesized, e.g. "(Company -eq 'Contoso')".
    - Respects operator precedence: -and higher than -or.
    - Wraps -and nodes with two extra parentheses (so the -and group becomes triple-wrapped).
    - Adds one additional outer parentheses per operator in the whole expression (to mimic Exchange).
#>
function Convert-ToExchangeFilterSyntax
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Expression
    )

    function ConvertFrom-ExchangeExpression {
        param ([System.String] $expr)

        # Trim outer spaces and redundant parentheses
        $expr = $expr.Trim()
        while ($expr.StartsWith('(') -and $expr.EndsWith(')'))
        {
            $inner = $expr.Substring(1, $expr.Length - 2).Trim()
            $balance = 0
            $valid = $true
            foreach ($ch in $inner.ToCharArray())
            {
                if ($ch -eq '(')
                {
                    $balance++
                }
                elseif ($ch -eq ')')
                {
                    $balance--
                }

                if ($balance -lt 0)
                {
                    $valid = $false
                    break
                }
            }

            if (-not $valid -or $balance -ne 0)
            {
                break
            }
            $expr = $inner
        }

        # Parse into tokens considering nested parentheses
        $tokens = [System.Collections.Generic.List[string]]::new()
        $current = ''
        $depth = 0
        for ($i = 0; $i -lt $expr.Length; $i++)
        {
            $ch = $expr[$i]
            if ($ch -eq '(')
            {
                $depth++
                $current += $ch
            }
            elseif ($ch -eq ')')
            {
                $depth--
                $current += $ch
            }
            elseif ($depth -eq 0 -and $expr.Substring($i) -match '^-or\s|^-and\s')
            {
                # Split at top-level logical operator
                $match = $matches[0].Trim()
                $tokens.Add(($current.Trim()))
                $tokens.Add($match)
                $current = ''
                $i += $match.Length - 1
            }
            else
            {
                $current += $ch
            }
        }
        if ($current.Trim())
        {
            $tokens.Add(($current.Trim()))
        }

        # Base condition — no logical operators
        if ($tokens.Count -eq 1)
        {
            return $tokens[0]
        }

        # Handle operator precedence: -and before -or
        # First handle all -and operations
        for ($i = 0; $i -lt $tokens.Count; $i++)
        {
            if ($tokens[$i] -eq '-and')
            {
                $left = ConvertFrom-ExchangeExpression $tokens[$i - 1]
                $right = ConvertFrom-ExchangeExpression $tokens[$i + 1]
                $combined = "(($left) -and ($right))"
                $tokens[$i - 1] = $combined
                $tokens.RemoveAt($i)    # remove operator
                $tokens.RemoveAt($i)    # remove right operand
                $i--
            }
        }

        # Then handle -or operations
        for ($i = 0; $i -lt $tokens.Count; $i++)
        {
            if ($tokens[$i] -eq '-or')
            {
                $left = ConvertFrom-ExchangeExpression $tokens[$i - 1]
                $right = ConvertFrom-ExchangeExpression $tokens[$i + 1]
                $combined = "(($left) -or ($right))"
                $tokens[$i - 1] = $combined
                $tokens.RemoveAt($i)
                $tokens.RemoveAt($i)
                $i--
            }
        }

        return $tokens[0]
    }

    $normalized = ConvertFrom-ExchangeExpression $Expression
    return "($normalized)"  # Always add one final outer wrapper
}


<#
.SYNOPSIS
    Restores the original RecipientFilter text as it was before Exchange Online expanded it.

.DESCRIPTION
    Exchange Online automatically expands RecipientFilters with extra clauses for system mailboxes,
    arbitration mailboxes, etc. This function removes those known injected query patterns and
    returns the user-defined part of the filter.

.PARAMETER ExpandedFilter
    The RecipientFilter string as returned by Get-DynamicDistributionGroup.

.EXAMPLE
    $group = Get-DynamicDistributionGroup -Identity "Test"
    Restore-OriginalRecipientFilter -ExpandedFilter $group.RecipientFilter
#>
function Restore-OriginalRecipientFilter
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ExpandedFilter
    )

    # region --- define the two known Exchange Online auto-append patterns ---
    $patterns = @()

    # 1. System/Arbitration mailbox exclusion block
    $patterns += [regex]::Escape("-and (-not(Name -like 'SystemMailbox{*')) -and (-not(Name -like 'CAS_{*')) -and (-not(RecipientTypeDetailsValue -eq 'MailboxPlan')) -and (-not(RecipientTypeDetailsValue -eq 'DiscoveryMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'PublicFolderMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'ArbitrationMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'AuditLogMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'AuxAuditLogMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'SupervisoryReviewPolicyMailbox'))")

    # 2. Extended RecipientType filtering block
    $patterns += [regex]::Escape("-and (((RecipientType -eq 'UserMailbox') -or (RecipientType -eq 'MailContact') -or (RecipientType -eq 'MailUser') -or (((RecipientType -eq 'MailUniversalDistributionGroup') -or (RecipientType -eq 'MailUniversalSecurityGroup') -or (RecipientType -eq 'MailNonUniversalGroup') -or (RecipientType -eq 'DynamicDistributionGroup'))) -or (((RecipientType -eq 'UserMailbox') -and (ResourceMetaData -like 'ResourceType:*') -and (ResourceSearchProperties -ne )))))))  -and (-not(RecipientTypeDetailsValue -eq 'GuestMailUser')))")

    # endregion

    $cleaned = $ExpandedFilter

    foreach ($pattern in $patterns)
    {
        $cleaned = [regex]::Replace($cleaned, $pattern, '', 'IgnoreCase')
    }

    # Normalize whitespace
    $cleaned = $cleaned -replace '\s{2,}', ' '

    # Trim outer parentheses if they wrap the whole expression
    $trimmed = $cleaned.Trim()
    if ($trimmed.StartsWith('(') -and $trimmed.EndsWith(')'))
    {
        # Check parentheses balance before trimming
        $open = 0
        $balanced = $true
        for ($i = 0; $i -lt $trimmed.Length; $i++)
        {
            switch ($trimmed[$i])
            {
                '(' { $open++ }
                ')' { $open-- }
            }

            if ($open -lt 0)
            {
                $balanced = $false
                break
            }
        }
        if ($balanced -and $open -eq 0)
        {
            # Remove only one outer layer of parentheses
            $trimmed = $trimmed.Substring(1, $trimmed.Length - 2).Trim()
        }
    }

    return $trimmed
}

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        PostProcessing = {
            param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
            if ($DesiredValues.ContainsKey('RecipientFilter') -and -not [System.String]::IsNullOrEmpty($DesiredValues.RecipientFilter))
            {
                $DesiredValues.RecipientFilter = Convert-ToExchangeFilterSyntax -Expression $DesiredValues.RecipientFilter

                # If RecipientFilter is specified, ignore the conditional properties
                $ValuesToCheck.Keys.Clone() | Where-Object { $_ -like "Conditional*" } | Foreach-Object {
                    $ValuesToCheck.Remove($_) | Out-Null
                }
            }
            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
