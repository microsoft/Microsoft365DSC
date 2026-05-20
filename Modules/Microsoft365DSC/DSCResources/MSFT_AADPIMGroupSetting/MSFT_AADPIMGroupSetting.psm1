Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADPIMGroupSetting'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $ActivationMaxDuration,

        [Parameter()]
        [System.Boolean]
        $ActivationReqJustification,

        [Parameter(Mandatory = $true)]
        [ValidateSet('owner', 'member')]
        [System.String]
        $RoleDefinitionId,

        [Parameter()]
        [System.Boolean]
        $ActivationReqTicket,

        [Parameter()]
        [System.Boolean]
        $ActivationReqMFA,

        [Parameter()]
        [System.Boolean]
        $ApprovaltoActivate,

        [Parameter()]
        [System.String[]]
        $ActivateApprover,

        [Parameter()]
        [System.Boolean]
        $PermanentEligibleAssignmentisExpirationRequired,

        [Parameter()]
        [System.String]
        $ExpireEligibleAssignment,

        [Parameter()]
        [System.Boolean]
        $PermanentActiveAssignmentisExpirationRequired,

        [Parameter()]
        [System.String]
        $ExpireActiveAssignment,

        [Parameter()]
        [System.Boolean]
        $AssignmentReqMFA,

        [Parameter()]
        [System.Boolean]
        $AssignmentReqJustification,

        [Parameter()]
        [System.Boolean]
        $EligibilityAssignmentReqMFA,

        [Parameter()]
        [System.Boolean]
        $EligibilityAssignmentReqJustification,

        [Parameter()]
        [System.Boolean]
        $EligibleAlertNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $EligibleAlertNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $EligibleAlertNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $EligibleAssigneeNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $EligibleAssigneeNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $EligibleAssigneeNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $EligibleApproveNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $EligibleApproveNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $EligibleApproveNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $ActiveAlertNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActiveAlertNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActiveAlertNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $ActiveAssigneeNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActiveAssigneeNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActiveAssigneeNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $ActiveApproveNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActiveApproveNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActiveApproveNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $EligibleAssignmentAlertNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $EligibleAssignmentAlertNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $EligibleAssignmentAlertNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $EligibleAssignmentAssigneeNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $EligibleAssignmentAssigneeNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $EligibleAssignmentAssigneeNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $AuthenticationContextRequired,

        [Parameter()]
        [System.String]
        $AuthenticationContextId,

        [Parameter()]
        [System.String]
        $AuthenticationContextName,

        [Parameter()]
        [ValidateSet('Present')]
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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of AAD PIM Group Setting with Id {$Id} and DisplayName {$DisplayName}"

    if (-not $Script:exportedInstance -or $Script:exportedInstance.Id -ne $Id)
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

        $Policy = $null
        if ([System.String]::IsNullOrEmpty($GroupId))
        {
            Write-Verbose 'GroupID was NULL, looking up group'
            $Filter = "DisplayName eq '" + $($DisplayName -replace "'", "''") + "'"
            $GroupId = (Get-MgGroup -Filter $Filter).Id
        }
        if ($Id -notmatch '^Group_[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}_[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}_(owner|member)$')
        {
            Write-Verbose "ID was NOT match {$id}, groupid {$groupID}, RoleDefinitionId {$RoleDefinitionId}"
            $Policy = Get-MgPolicyRoleManagementPolicyAssignment `
                -All `
                -Filter "scopeId eq '$groupId' and scopeType eq 'Group' and roleDefinitionId eq '$RoleDefinitionId'" `
                -ExpandProperty "policy(`$expand=rules)" `
                -ErrorAction SilentlyContinue
        }
        else
        {
            $Policy = Get-MgPolicyRoleManagementPolicyAssignment `
                -UnifiedRoleManagementPolicyAssignmentId $Id `
                -ExpandProperty "policy(`$expand=rules)" `
                -ErrorAction SilentlyContinue
        }
    }
    else
    {
        $Policy = $Script:exportedInstance
    }
    $nullReturn = $PSBoundParameters

    if ($null -eq $Policy.policy.rules)
    {
        Write-Verbose 'No Policy Rules found, returning null'
        return $nullReturn
    }

    #Rules
    $role = $Policy.policy.rules

    if ($Script:ExportMode)
    {
        $ActivationMaxDurationValue = ($role | Where-Object { $_.Id -eq 'Expiration_EndUser_Assignment' }).maximumDuration
        $ActivationReqJustificationValue = (($role | Where-Object { $_.Id -eq 'Enablement_EndUser_Assignment' }).enabledRules) -contains 'Justification'
        $ActivationReqTicketValue = (($role | Where-Object { $_.Id -eq 'Enablement_EndUser_Assignment' }).enabledRules) -contains 'Ticketing'
        $ActivationReqMFAValue = (($role | Where-Object { $_.Id -eq 'Enablement_EndUser_Assignment' }).enabledRules) -contains 'MultiFactorAuthentication'
        $AuthenticationContextValue = ($role | Where-Object { $_.Id -eq 'AuthenticationContext_EndUser_Assignment' })
        $ApprovaltoActivateValue = (($role | Where-Object { $_.Id -eq 'Approval_EndUser_Assignment' }).setting.isApprovalRequired)
        $ActivateApproversValue = (($role | Where-Object { $_.Id -eq 'Approval_EndUser_Assignment' }).setting.approvalStages.primaryApprovers.id)
    }
    else
    {
        $ActivationMaxDurationValue = ($role | Where-Object { $_.Id -eq 'Expiration_EndUser_Assignment' }).AdditionalProperties.maximumDuration
        $ActivationReqJustificationValue = (($role | Where-Object { $_.Id -eq 'Enablement_EndUser_Assignment' }).AdditionalProperties.enabledRules) -contains 'Justification'
        $ActivationReqTicketValue = (($role | Where-Object { $_.Id -eq 'Enablement_EndUser_Assignment' }).AdditionalProperties.enabledRules) -contains 'Ticketing'
        $ActivationReqMFAValue = (($role | Where-Object { $_.Id -eq 'Enablement_EndUser_Assignment' }).AdditionalProperties.enabledRules) -contains 'MultiFactorAuthentication'
        $AuthenticationContextValue = ($role | Where-Object { $_.Id -eq 'AuthenticationContext_EndUser_Assignment' }).AdditionalProperties
        $ApprovaltoActivateValue = (($role | Where-Object { $_.Id -eq 'Approval_EndUser_Assignment' }).AdditionalProperties.setting.isApprovalRequired)
        [array]$ActivateApproversValue = (($role | Where-Object { $_.Id -eq 'Approval_EndUser_Assignment' }).AdditionalProperties.setting.approvalStages.primaryApprovers)
    }
    $AuthenticationContextRequiredValue = $AuthenticationContextValue.isEnabled
    if ($AuthenticationContextRequiredValue)
    {
        $AuthenticationContextIdValue = $AuthenticationContextValue.claimValue
        $AuthenticationContextNameValue = (Get-MgBetaIdentityConditionalAccessAuthenticationContextClassReference -AuthenticationContextClassReferenceId $AuthenticationContextIdValue).DisplayName
    }

    [string[]]$ActivateApprover = @()
    foreach ($Item in $ActivateApproversValue.id)
    {
        try
        {
            $user = Get-MgUser -UserId $Item -ErrorAction Stop
            $ActivateApprover += $user.UserPrincipalName
        }
        catch
        {
            try
            {
                $group = Get-MgGroup -GroupId $Item -ErrorAction stop
                $ActivateApprover += $group.DisplayName
            }
            catch
            {
                Write-Verbose -Message "Error: $($Error[0])"
            }
        }
    }

    if ($Script:ExportMode)
    {
        $PermanentEligibleAssignmentisExpirationRequiredValue = ($role | Where-Object { $_.Id -eq 'Expiration_Admin_Eligibility' }).isExpirationRequired
        $ExpireEligibleAssignmentValue = ($role | Where-Object { $_.Id -eq 'Expiration_Admin_Eligibility' }).maximumDuration
        $PermanentActiveAssignmentisExpirationRequiredValue = ($role | Where-Object { $_.Id -eq 'Expiration_Admin_Assignment' }).isExpirationRequired
        $ExpireActiveAssignmentValue = ($role | Where-Object { $_.Id -eq 'Expiration_Admin_Assignment' }).maximumDuration
        $AssignmentReqMFAValue = (($role | Where-Object { $_.Id -eq 'Enablement_Admin_Assignment' }).enabledRules) -contains 'MultiFactorAuthentication'
        $AssignmentReqJustificationValue = (($role | Where-Object { $_.Id -eq 'Enablement_Admin_Assignment' }).enabledRules) -contains 'Justification'
        $EligibilityAssignmentReqMFAValue = (($role | Where-Object { $_.Id -eq 'Enablement_Admin_Eligibility' }).enabledRules) -contains 'MultiFactorAuthentication'
        $EligibilityAssignmentReqJustificationValue = (($role | Where-Object { $_.Id -eq 'Enablement_Admin_Eligibility' }).enabledRules) -contains 'Justification'
        $EligibleAlertNotificationDefaultRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Eligibility' }).isDefaultRecipientsEnabled
        [string[]]$EligibleAlertNotificationAdditionalRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Eligibility' }).notificationRecipients
        $EligibleAlertNotificationOnlyCriticalValue = (($role | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Eligibility' }).notificationLevel) -contains ('Critical')
        $EligibleAssigneeNotificationDefaultRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Eligibility' }).isDefaultRecipientsEnabled
        [string[]]$EligibleAssigneeNotificationAdditionalRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Eligibility' }).notificationRecipients
        $EligibleAssigneeNotificationOnlyCriticalValue = (($role | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Eligibility' }).notificationLevel) -contains ('Critical')
        $EligibleApproveNotificationDefaultRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Eligibility' }).isDefaultRecipientsEnabled
        [string[]]$EligibleApproveNotificationAdditionalRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Eligibility' }).notificationRecipients
        $EligibleApproveNotificationOnlyCriticalValue = (($role | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Eligibility' }).notificationLevel) -contains ('Critical')
        $ActiveAlertNotificationDefaultRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Assignment' }).isDefaultRecipientsEnabled
        [string[]]$ActiveAlertNotificationAdditionalRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Assignment' }).notificationRecipients
        $ActiveAlertNotificationOnlyCriticalValue = (($role | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Assignment' }).notificationLevel) -contains ('Critical')
        $ActiveAssigneeNotificationDefaultRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Assignment' }).isDefaultRecipientsEnabled
        [string[]]$ActiveAssigneeNotificationAdditionalRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Assignment' }).notificationRecipients
        $ActiveAssigneeNotificationOnlyCriticalValue = (($role | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Assignment' }).notificationLevel) -contains ('Critical')
        $ActiveApproveNotificationDefaultRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Assignment' }).isDefaultRecipientsEnabled
        [string[]]$ActiveApproveNotificationAdditionalRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Assignment' }).notificationRecipients
        $ActiveApproveNotificationOnlyCriticalValue = (($role | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Assignment' }).notificationLevel) -contains ('Critical')
        $EligibleAssignmentAlertNotificationDefaultRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Admin_EndUser_Assignment' }).isDefaultRecipientsEnabled
        [string[]]$EligibleAssignmentAlertNotificationAdditionalRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Admin_EndUser_Assignment' }).notificationRecipients
        $EligibleAssignmentAlertNotificationOnlyCriticalValue = (($role | Where-Object { $_.Id -eq 'Notification_Admin_EndUser_Assignment' }).notificationLevel) -contains ('Critical')
        $EligibleAssignmentAssigneeNotificationDefaultRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Requestor_EndUser_Assignment' }).isDefaultRecipientsEnabled
        [string[]]$EligibleAssignmentAssigneeNotificationAdditionalRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Requestor_EndUser_Assignment' }).notificationRecipients
        $EligibleAssignmentAssigneeNotificationOnlyCriticalValue = (($role | Where-Object { $_.Id -eq 'Notification_Requestor_EndUser_Assignment' }).notificationLevel) -contains ('Critical')
    }
    else
    {
        $PermanentEligibleAssignmentisExpirationRequiredValue = ($role | Where-Object { $_.Id -eq 'Expiration_Admin_Eligibility' }).AdditionalProperties.isExpirationRequired
        $ExpireEligibleAssignmentValue = ($role | Where-Object { $_.Id -eq 'Expiration_Admin_Eligibility' }).AdditionalProperties.maximumDuration
        $PermanentActiveAssignmentisExpirationRequiredValue = ($role | Where-Object { $_.Id -eq 'Expiration_Admin_Assignment' }).AdditionalProperties.isExpirationRequired
        $ExpireActiveAssignmentValue = ($role | Where-Object { $_.Id -eq 'Expiration_Admin_Assignment' }).AdditionalProperties.maximumDuration
        $AssignmentReqMFAValue = (($role | Where-Object { $_.Id -eq 'Enablement_Admin_Assignment' }).AdditionalProperties.enabledRules) -contains 'MultiFactorAuthentication'
        $AssignmentReqJustificationValue = (($role | Where-Object { $_.Id -eq 'Enablement_Admin_Assignment' }).AdditionalProperties.enabledRules) -contains 'Justification'
        $EligibilityAssignmentReqMFAValue = (($role | Where-Object { $_.Id -eq 'Enablement_Admin_Eligibility' }).AdditionalProperties.enabledRules) -contains 'MultiFactorAuthentication'
        $EligibilityAssignmentReqJustificationValue = (($role | Where-Object { $_.Id -eq 'Enablement_Admin_Eligibility' }).AdditionalProperties.enabledRules) -contains 'Justification'
        $EligibleAlertNotificationDefaultRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Eligibility' }).AdditionalProperties.isDefaultRecipientsEnabled
        [string[]]$EligibleAlertNotificationAdditionalRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Eligibility' }).AdditionalProperties.notificationRecipients
        $EligibleAlertNotificationOnlyCriticalValue = (($role | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Eligibility' }).AdditionalProperties.notificationLevel) -contains ('Critical')
        $EligibleAssigneeNotificationDefaultRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Eligibility' }).AdditionalProperties.isDefaultRecipientsEnabled
        [string[]]$EligibleAssigneeNotificationAdditionalRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Eligibility' }).AdditionalProperties.notificationRecipients
        $EligibleAssigneeNotificationOnlyCriticalValue = (($role | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Eligibility' }).AdditionalProperties.notificationLevel) -contains ('Critical')
        $EligibleApproveNotificationDefaultRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Eligibility' }).AdditionalProperties.isDefaultRecipientsEnabled
        [string[]]$EligibleApproveNotificationAdditionalRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Eligibility' }).AdditionalProperties.notificationRecipients
        $EligibleApproveNotificationOnlyCriticalValue = (($role | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Eligibility' }).AdditionalProperties.notificationLevel) -contains ('Critical')
        $ActiveAlertNotificationDefaultRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Assignment' }).AdditionalProperties.isDefaultRecipientsEnabled
        [string[]]$ActiveAlertNotificationAdditionalRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Assignment' }).AdditionalProperties.notificationRecipients
        $ActiveAlertNotificationOnlyCriticalValue = (($role | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Assignment' }).AdditionalProperties.notificationLevel) -contains ('Critical')
        $ActiveAssigneeNotificationDefaultRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Assignment' }).AdditionalProperties.isDefaultRecipientsEnabled
        [string[]]$ActiveAssigneeNotificationAdditionalRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Assignment' }).AdditionalProperties.notificationRecipients
        $ActiveAssigneeNotificationOnlyCriticalValue = (($role | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Assignment' }).AdditionalProperties.notificationLevel) -contains ('Critical')
        $ActiveApproveNotificationDefaultRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Assignment' }).AdditionalProperties.isDefaultRecipientsEnabled
        [string[]]$ActiveApproveNotificationAdditionalRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Assignment' }).AdditionalProperties.notificationRecipients
        $ActiveApproveNotificationOnlyCriticalValue = (($role | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Assignment' }).AdditionalProperties.notificationLevel) -contains ('Critical')
        $EligibleAssignmentAlertNotificationDefaultRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Admin_EndUser_Assignment' }).AdditionalProperties.isDefaultRecipientsEnabled
        [string[]]$EligibleAssignmentAlertNotificationAdditionalRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Admin_EndUser_Assignment' }).AdditionalProperties.notificationRecipients
        $EligibleAssignmentAlertNotificationOnlyCriticalValue = (($role | Where-Object { $_.Id -eq 'Notification_Admin_EndUser_Assignment' }).AdditionalProperties.notificationLevel) -contains ('Critical')
        $EligibleAssignmentAssigneeNotificationDefaultRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Requestor_EndUser_Assignment' }).AdditionalProperties.isDefaultRecipientsEnabled
        [string[]]$EligibleAssignmentAssigneeNotificationAdditionalRecipientValue = ($role | Where-Object { $_.Id -eq 'Notification_Requestor_EndUser_Assignment' }).AdditionalProperties.notificationRecipients
        $EligibleAssignmentAssigneeNotificationOnlyCriticalValue = (($role | Where-Object { $_.Id -eq 'Notification_Requestor_EndUser_Assignment' }).AdditionalProperties.notificationLevel) -contains ('Critical')
    }

    try
    {
        Write-Verbose -Message "Found configuration of Rule $($DisplayName)"
        $result = @{
            Id                                                        = $Id
            DisplayName                                               = $DisplayName
            RoleDefinitionId                                          = $RoleDefinitionId
            ActivationMaxDuration                                     = $ActivationMaxDurationValue
            ActivationReqJustification                                = $ActivationReqJustificationValue
            ActivationReqTicket                                       = $ActivationReqTicketValue
            ActivationReqMFA                                          = $ActivationReqMFAValue
            ApprovaltoActivate                                        = $ApprovaltoActivateValue
            ActivateApprover                                          = [System.String[]]$ActivateApprover
            PermanentEligibleAssignmentisExpirationRequired           = $PermanentEligibleAssignmentisExpirationRequiredValue
            ExpireEligibleAssignment                                  = $ExpireEligibleAssignmentValue
            PermanentActiveAssignmentisExpirationRequired             = $PermanentActiveAssignmentisExpirationRequiredValue
            ExpireActiveAssignment                                    = $ExpireActiveAssignmentValue
            AssignmentReqMFA                                          = $AssignmentReqMFAValue
            AssignmentReqJustification                                = $AssignmentReqJustificationValue
            EligibilityAssignmentReqMFA                               = $EligibilityAssignmentReqMFAValue
            EligibilityAssignmentReqJustification                     = $EligibilityAssignmentReqJustificationValue
            EligibleAlertNotificationDefaultRecipient                 = $EligibleAlertNotificationDefaultRecipientValue
            EligibleAlertNotificationAdditionalRecipient              = [System.String[]]$EligibleAlertNotificationAdditionalRecipientValue
            EligibleAlertNotificationOnlyCritical                     = $EligibleAlertNotificationOnlyCriticalValue
            EligibleAssigneeNotificationDefaultRecipient              = $EligibleAssigneeNotificationDefaultRecipientValue
            EligibleAssigneeNotificationAdditionalRecipient           = [System.String[]]$EligibleAssigneeNotificationAdditionalRecipientValue
            EligibleAssigneeNotificationOnlyCritical                  = $EligibleAssigneeNotificationOnlyCriticalValue
            EligibleApproveNotificationDefaultRecipient               = $EligibleApproveNotificationDefaultRecipientValue
            EligibleApproveNotificationAdditionalRecipient            = [System.String[]]$EligibleApproveNotificationAdditionalRecipientValue
            EligibleApproveNotificationOnlyCritical                   = $EligibleApproveNotificationOnlyCriticalValue
            ActiveAlertNotificationDefaultRecipient                   = $ActiveAlertNotificationDefaultRecipientValue
            ActiveAlertNotificationAdditionalRecipient                = [System.String[]]$ActiveAlertNotificationAdditionalRecipientValue
            ActiveAlertNotificationOnlyCritical                       = $ActiveAlertNotificationOnlyCriticalValue
            ActiveAssigneeNotificationDefaultRecipient                = $ActiveAssigneeNotificationDefaultRecipientValue
            ActiveAssigneeNotificationAdditionalRecipient             = [System.String[]]$ActiveAssigneeNotificationAdditionalRecipientValue
            ActiveAssigneeNotificationOnlyCritical                    = $ActiveAssigneeNotificationOnlyCriticalValue
            ActiveApproveNotificationDefaultRecipient                 = $ActiveApproveNotificationDefaultRecipientValue
            ActiveApproveNotificationAdditionalRecipient              = [System.String[]]$ActiveApproveNotificationAdditionalRecipientValue
            ActiveApproveNotificationOnlyCritical                     = $ActiveApproveNotificationOnlyCriticalValue
            EligibleAssignmentAlertNotificationDefaultRecipient       = $EligibleAssignmentAlertNotificationDefaultRecipientValue
            EligibleAssignmentAlertNotificationAdditionalRecipient    = [System.String[]]$EligibleAssignmentAlertNotificationAdditionalRecipientValue
            EligibleAssignmentAlertNotificationOnlyCritical           = $EligibleAssignmentAlertNotificationOnlyCriticalValue
            EligibleAssignmentAssigneeNotificationDefaultRecipient    = $EligibleAssignmentAssigneeNotificationDefaultRecipientValue
            EligibleAssignmentAssigneeNotificationAdditionalRecipient = [System.String[]]$EligibleAssignmentAssigneeNotificationAdditionalRecipientValue
            EligibleAssignmentAssigneeNotificationOnlyCritical        = $EligibleAssignmentAssigneeNotificationOnlyCriticalValue
            AuthenticationContextRequired                             = $AuthenticationContextRequiredValue
            AuthenticationContextId                                   = $AuthenticationContextIdValue
            AuthenticationContextName                                 = $AuthenticationContextNameValue
            Ensure                                                    = 'Present'
            ApplicationId                                             = $ApplicationId
            TenantId                                                  = $TenantId
            CertificateThumbprint                                     = $CertificateThumbprint
            ApplicationSecret                                         = $ApplicationSecret
            Credential                                                = $Credential
            ManagedIdentity                                           = $ManagedIdentity.IsPresent
            AccessTokens                                              = $AccessTokens
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
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $ActivationMaxDuration,

        [Parameter(Mandatory = $true)]
        [ValidateSet('owner', 'member')]
        [System.String]
        $RoleDefinitionId,

        [Parameter()]
        [System.Boolean]
        $ActivationReqJustification,

        [Parameter()]
        [System.Boolean]
        $ActivationReqTicket,

        [Parameter()]
        [System.Boolean]
        $ActivationReqMFA,

        [Parameter()]
        [System.Boolean]
        $ApprovaltoActivate,

        [Parameter()]
        [System.String[]]
        $ActivateApprover,

        [Parameter()]
        [System.Boolean]
        $PermanentEligibleAssignmentisExpirationRequired,

        [Parameter()]
        [System.String]
        $ExpireEligibleAssignment,

        [Parameter()]
        [System.Boolean]
        $PermanentActiveAssignmentisExpirationRequired,

        [Parameter()]
        [System.String]
        $ExpireActiveAssignment,

        [Parameter()]
        [System.Boolean]
        $AssignmentReqMFA,

        [Parameter()]
        [System.Boolean]
        $AssignmentReqJustification,

        [Parameter()]
        [System.Boolean]
        $EligibilityAssignmentReqMFA,

        [Parameter()]
        [System.Boolean]
        $EligibilityAssignmentReqJustification,

        [Parameter()]
        [System.Boolean]
        $EligibleAlertNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $EligibleAlertNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $EligibleAlertNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $EligibleAssigneeNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $EligibleAssigneeNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $EligibleAssigneeNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $EligibleApproveNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $EligibleApproveNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $EligibleApproveNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $ActiveAlertNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActiveAlertNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActiveAlertNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $ActiveAssigneeNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActiveAssigneeNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActiveAssigneeNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $ActiveApproveNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActiveApproveNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActiveApproveNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $EligibleAssignmentAlertNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $EligibleAssignmentAlertNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $EligibleAssignmentAlertNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $EligibleAssignmentAssigneeNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $EligibleAssignmentAssigneeNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $EligibleAssignmentAssigneeNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $AuthenticationContextRequired,

        [Parameter()]
        [System.String]
        $AuthenticationContextId,

        [Parameter()]
        [System.String]
        $AuthenticationContextName,

        [Parameter()]
        [ValidateSet('Present')]
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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of the Azure AD PIM Group for group DisplayName {$DisplayName} and RoleDefinitionId {$RoleDefinitionId}"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies
    #$PSBoundParameters.Remove('AuthenticationContextName') | Out-Null

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $Policy = $null

    if ([System.String]::IsNullOrEmpty($GroupId))
    {
        $Filter = "DisplayName eq '" + $DisplayName + "'"
        $GroupId = (Get-MgGroup -Filter $Filter).Id
    }

    if ($Id -notmatch '^Group_[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}_[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}_(owner|member)$')
    {
        $Policy = Get-MgPolicyRoleManagementPolicyAssignment `
            -All `
            -Filter "scopeId eq '$groupId' and scopeType eq 'Group' and roleDefinitionId eq '$RoleDefinitionId'" `
            -ExpandProperty "policy(`$expand=rules)" `
            -ErrorAction SilentlyContinue
    }
    else
    {
        $Policy = Get-MgPolicyRoleManagementPolicyAssignment `
            -UnifiedRoleManagementPolicyAssignmentId $Id `
            -ExpandProperty "policy(`$expand=rules)" `
            -ErrorAction SilentlyContinue
    }

    #Rules
    $roles = $Policy.policy.rules

    foreach ($role in $roles)
    {
        $odatatype = $role.AdditionalProperties.'@odata.type'
        if ($role.id -match 'Notification_Admin_Admin_Eligibility')
        {
            if ($PSBoundParameters.ContainsKey('EligibleAlertNotificationOnlyCritical') `
                    -and $PSBoundParameters.ContainsKey('EligibleAlertNotificationDefaultRecipient') `
                    -and $PSBoundParameters.ContainsKey('EligibleAlertNotificationAdditionalRecipient'))
            {
                Write-Verbose -Message 'Handle Send notifications when members are assigned as eligible to this role: Role assignment alert'
                $notificationLevel = if ($EligibleAlertNotificationOnlyCritical -eq 'True')
                {
                    'Critical'
                }
                else
                {
                    'All'
                }
                $isDefaultRecipientsEnabled = $EligibleAlertNotificationDefaultRecipient
                $notificationRecipients = @($EligibleAlertNotificationAdditionalRecipient)
                $params = @{
                    '@odata.type'                = $odatatype
                    'recipientType'              = 'Admin'
                    'notificationType'           = 'Email'
                    'notificationLevel'          = $notificationLevel
                    'isDefaultRecipientsEnabled' = $isDefaultRecipientsEnabled
                    'notificationRecipients'     = $notificationRecipients
                    target                       = @{
                        '@odata.type' = '#microsoft.graph.unifiedRoleManagementPolicyRuleTarget'
                    }
                }
            }
        }
        elseif ($role.id -match 'Notification_Requestor_Admin_Eligibility')
        {
            if ($PSBoundParameters.ContainsKey('EligibleAssigneeNotificationOnlyCritical') `
                    -and $PSBoundParameters.ContainsKey('EligibleAssigneeNotificationDefaultRecipient') `
                    -and $PSBoundParameters.ContainsKey('EligibleAssigneeNotificationAdditionalRecipient'))
            {
                Write-Verbose -Message 'Handle Send notifications when members are assigned as eligible to this role: Notification to the assigned user (assignee)'
                $notificationLevel = if ($EligibleAssigneeNotificationOnlyCritical -eq 'True')
                {
                    'Critical'
                }
                else
                {
                    'All'
                }
                $isDefaultRecipientsEnabled = $EligibleAssigneeNotificationDefaultRecipient
                $notificationRecipients = @($EligibleAssigneeNotificationAdditionalRecipient)
                $params = @{
                    '@odata.type'                = $odatatype
                    'recipientType'              = 'Requestor'
                    'notificationType'           = 'Email'
                    'notificationLevel'          = $notificationLevel
                    'isDefaultRecipientsEnabled' = $isDefaultRecipientsEnabled
                    'notificationRecipients'     = $notificationRecipients
                    target                       = @{
                        '@odata.type' = '#microsoft.graph.unifiedRoleManagementPolicyRuleTarget'
                    }
                }
            }
        }
        elseif ($role.id -match 'Notification_Approver_Admin_Eligibility')
        {
            if ($PSBoundParameters.ContainsKey('EligibleApproveNotificationOnlyCritical') `
                    -and $PSBoundParameters.ContainsKey('EligibleApproveNotificationDefaultRecipient') `
                    -and $PSBoundParameters.ContainsKey('EligibleApproveNotificationAdditionalRecipient'))
            {
                Write-Verbose -Message 'Handle Send notifications when members are assigned as eligible to this role: Request to approve a role assignment renewal/extension'
                $notificationLevel = if ($EligibleApproveNotificationOnlyCritical -eq 'True')
                {
                    'Critical'
                }
                else
                {
                    'All'
                }
                $isDefaultRecipientsEnabled = $EligibleApproveNotificationDefaultRecipient
                $notificationRecipients = @($EligibleApproveNotificationAdditionalRecipient)
                $params = @{
                    '@odata.type'                = $odatatype
                    'recipientType'              = 'Approver'
                    'notificationType'           = 'Email'
                    'notificationLevel'          = $notificationLevel
                    'isDefaultRecipientsEnabled' = $isDefaultRecipientsEnabled
                    'notificationRecipients'     = $notificationRecipients
                    target                       = @{
                        '@odata.type' = '#microsoft.graph.unifiedRoleManagementPolicyRuleTarget'
                    }
                }
            }
        }
        elseif ($role.id -match 'Notification_Admin_Admin_Assignment')
        {
            if ($PSBoundParameters.ContainsKey('ActiveAlertNotificationOnlyCritical') `
                    -and $PSBoundParameters.ContainsKey('ActiveAlertNotificationDefaultRecipient') `
                    -and $PSBoundParameters.ContainsKey('ActiveAlertNotificationAdditionalRecipient'))
            {
                Write-Verbose -Message 'Handle Send notifications when members are assigned as active to this role: Role assignment alert'
                $notificationLevel = if ($ActiveAlertNotificationOnlyCritical -eq 'True')
                {
                    'Critical'
                }
                else
                {
                    'All'
                }
                $isDefaultRecipientsEnabled = $ActiveAlertNotificationDefaultRecipient
                $notificationRecipients = @($ActiveAlertNotificationAdditionalRecipient)
                $params = @{
                    '@odata.type'                = $odatatype
                    'recipientType'              = 'Admin'
                    'notificationType'           = 'Email'
                    'notificationLevel'          = $notificationLevel
                    'isDefaultRecipientsEnabled' = $isDefaultRecipientsEnabled
                    'notificationRecipients'     = $notificationRecipients
                    target                       = @{
                        '@odata.type' = '#microsoft.graph.unifiedRoleManagementPolicyRuleTarget'
                    }
                }
            }
        }
        elseif ($role.id -match 'Notification_Requestor_Admin_Assignment')
        {
            if ($PSBoundParameters.ContainsKey('ActiveAssigneeNotificationOnlyCritical') `
                    -and $PSBoundParameters.ContainsKey('ActiveAssigneeNotificationDefaultRecipient') `
                    -and $PSBoundParameters.ContainsKey('ActiveAssigneeNotificationAdditionalRecipient'))
            {
                Write-Verbose -Message 'Handle Send notifications when members are assigned as active to this role: Notification to the assigned user (assignee)'
                $notificationLevel = if ($ActiveAssigneeNotificationOnlyCritical -eq 'True')
                {
                    'Critical'
                }
                else
                {
                    'All'
                }
                $isDefaultRecipientsEnabled = $ActiveAssigneeNotificationDefaultRecipient
                $notificationRecipients = @($ActiveAssigneeNotificationAdditionalRecipient)
                $params = @{
                    '@odata.type'                = $odatatype
                    'recipientType'              = 'Requestor'
                    'notificationType'           = 'Email'
                    'notificationLevel'          = $notificationLevel
                    'isDefaultRecipientsEnabled' = $isDefaultRecipientsEnabled
                    'notificationRecipients'     = $notificationRecipients
                    target                       = @{
                        '@odata.type' = '#microsoft.graph.unifiedRoleManagementPolicyRuleTarget'
                    }
                }
            }
        }
        elseif ($role.id -match 'Notification_Approver_Admin_Assignment')
        {
            if ($PSBoundParameters.ContainsKey('ActiveApproveNotificationOnlyCritical') `
                    -and $PSBoundParameters.ContainsKey('ActiveApproveNotificationDefaultRecipient') `
                    -and $PSBoundParameters.ContainsKey('ActiveApproveNotificationAdditionalRecipient'))
            {
                Write-Verbose -Message 'Handle Send notifications when members are assigned as active to this role: Request to approve a role assignment renewal/extension'
                $notificationLevel = if ($ActiveApproveNotificationOnlyCritical -eq 'True')
                {
                    'Critical'
                }
                else
                {
                    'All'
                }
                $isDefaultRecipientsEnabled = $ActiveApproveNotificationDefaultRecipient
                $notificationRecipients = @($ActiveApproveNotificationAdditionalRecipient)
                $params = @{
                    '@odata.type'                = $odatatype
                    'recipientType'              = 'Approver'
                    'notificationType'           = 'Email'
                    'notificationLevel'          = $notificationLevel
                    'isDefaultRecipientsEnabled' = $isDefaultRecipientsEnabled
                    'notificationRecipients'     = $notificationRecipients
                    target                       = @{
                        '@odata.type' = '#microsoft.graph.unifiedRoleManagementPolicyRuleTarget'
                    }
                }
            }
        }
        elseif ($role.id -match 'Notification_Admin_EndUser_Assignment')
        {
            if ($PSBoundParameters.ContainsKey('EligibleAssignmentAlertNotificationOnlyCritical') `
                    -and $PSBoundParameters.ContainsKey('EligibleAssignmentAlertNotificationDefaultRecipient') `
                    -and $PSBoundParameters.ContainsKey('EligibleAssignmentAlertNotificationAdditionalRecipient'))
            {
                Write-Verbose -Message 'Handle Send notifications when eligible members activate this role: Role activation alert'
                $notificationLevel = if ($EligibleAssignmentAlertNotificationOnlyCritical -eq 'True')
                {
                    'Critical'
                }
                else
                {
                    'All'
                }
                $isDefaultRecipientsEnabled = $EligibleAssignmentAlertNotificationDefaultRecipient
                $notificationRecipients = @($EligibleAssignmentAlertNotificationAdditionalRecipient)
                $params = @{
                    '@odata.type'                = $odatatype
                    'recipientType'              = 'Admin'
                    'notificationType'           = 'Email'
                    'notificationLevel'          = $notificationLevel
                    'isDefaultRecipientsEnabled' = $isDefaultRecipientsEnabled
                    'notificationRecipients'     = $notificationRecipients
                    target                       = @{
                        '@odata.type' = '#microsoft.graph.unifiedRoleManagementPolicyRuleTarget'
                    }
                }
            }
        }
        elseif ($role.id -match 'Notification_Requestor_EndUser_Assignment')
        {
            if ($PSBoundParameters.ContainsKey('EligibleAssignmentAssigneeNotificationOnlyCritical') `
                    -and $PSBoundParameters.ContainsKey('EligibleAssignmentAssigneeNotificationDefaultRecipient') `
                    -and $PSBoundParameters.ContainsKey('EligibleAssignmentAssigneeNotificationAdditionalRecipient'))
            {
                Write-Verbose -Message 'Handle Send notifications when eligible members activate this role: Notification to activated user (requestor)'
                $notificationLevel = if ($EligibleAssignmentAssigneeNotificationOnlyCritical -eq 'True')
                {
                    'Critical'
                }
                else
                {
                    'All'
                }
                $isDefaultRecipientsEnabled = $EligibleAssignmentAssigneeNotificationDefaultRecipient
                $notificationRecipients = @($EligibleAssignmentAssigneeNotificationAdditionalRecipient)
                $params = @{
                    '@odata.type'                = $odatatype
                    'recipientType'              = 'Requestor'
                    'notificationType'           = 'Email'
                    'notificationLevel'          = $notificationLevel
                    'isDefaultRecipientsEnabled' = $isDefaultRecipientsEnabled
                    'notificationRecipients'     = $notificationRecipients
                    target                       = @{
                        '@odata.type' = '#microsoft.graph.unifiedRoleManagementPolicyRuleTarget'
                    }
                }
            }
        }

        elseif ($role.id -match 'Expiration_EndUser_Assignment')
        {
            if ($PSBoundParameters.ContainsKey('ActivationMaxDuration'))
            {
                Write-Verbose -Message 'Handle Activation: Activation maximum duration (hours)'
                $params = @{
                    '@odata.type'     = $odatatype
                    'id'              = $role.Id
                    'maximumDuration' = $ActivationMaxDuration
                    target            = @{
                        '@odata.type' = '#microsoft.graph.unifiedRoleManagementPolicyRuleTarget'
                    }
                }
            }
        }
        elseif ($role.id -match 'Enablement_EndUser_Assignment')
        {
            if ($PSBoundParameters.ContainsKey('ActivationReqJustification') `
                    -and $PSBoundParameters.ContainsKey('ActivationReqTicket') `
                    -and $PSBoundParameters.ContainsKey('ActivationReqMFA'))
            {
                Write-Verbose -Message 'Handle Activation: Require justification on activation'
                [String[]]$enabledrules = @()
                if ($ActivationReqJustification)
                {
                    $enabledrules += 'Justification'
                }
                if ($ActivationReqTicket)
                {
                    $enabledrules += 'Ticketing'
                }
                if ($ActivationReqMFA)
                {
                    $enabledrules += 'MultiFactorAuthentication'
                }
                $params = @{
                    '@odata.type'  = $odatatype
                    'id'           = $role.Id
                    'enabledRules' = $enabledrules
                    target         = @{
                        '@odata.type' = '#microsoft.graph.unifiedRoleManagementPolicyRuleTarget'
                    }
                }
            }
        }

        elseif ($role.Id -match 'Approval_EndUser_Assignment')
        {
            if ($PSBoundParameters.ContainsKey('ApprovaltoActivate') `
                    -and $PSBoundParameters.ContainsKey('ActivateApprover'))
            {
                Write-Verbose -Message 'Handle Activation: Require approval to activate / Approvers'
                $isApprovalRequired = $ApprovaltoActivate
                if ($ActivateApprover.Count -gt 0)
                {
                    $primaryApprovers = @()
                    foreach ($item in $ActivateApprover)
                    {
                        #is not a guid try with user
                        $Filter = "UserPrincipalName eq '" + $item + "'"
                        $user = Get-MgUser -Filter $Filter
                        if ($null -ne $user)
                        {
                            $ActivateApprovers = @{}
                            $ActivateApprovers.Add('@odata.type', '#microsoft.graph.singleUser')
                            $ActivateApprovers.Add('userId', $user.Id)
                            $primaryApprovers += $ActivateApprovers
                            $user = $null
                        }
                        else
                        {
                            Write-Verbose -Message "User '$item' not found, trying with group"

                            $Filter = "displayName eq '" + $item + "'"
                            $group = Get-MgGroup -Filter $Filter
                            if ($null -ne $group)
                            {
                                $ActivateApprovers = @{}
                                $ActivateApprovers.Add('@odata.type', '#microsoft.graph.groupMembers')
                                $ActivateApprovers.Add('groupId', $group.Id)
                                $primaryApprovers += $ActivateApprovers
                                $group = $null
                            }
                            else
                            {
                                throw "Group '$item' not found. Cannot add as approver."
                            }
                        }
                    }
                }
                $approvalStages = @{}
                $approvalStages.Add('approvalStageTimeOutInDays', '1')
                $approvalStages.Add('isApproverJustificationRequired', 'true')
                $approvalStages.Add('escalationTimeInMinutes', '0')
                $approvalStages.Add('isEscalationEnabled', 'False')

                if ($primaryApprovers.Count -gt 0)
                {
                    $approvalStages.Add('primaryApprovers', @($primaryApprovers))
                }
                else
                {
                    $approvalStages.Add('primaryApprovers', @())
                }
                $approvalStages.Add('escalationApprovers', @())

                $setting = @{}
                $setting.Add('isApprovalRequired', $isApprovalRequired)
                $setting.Add('isApprovalRequiredForExtension', 'false')
                $setting.Add('isRequestorJustificationRequired', 'true')
                $setting.Add('approvalMode', 'SingleStage')
                $setting.Add('approvalStages', @($approvalStages))

                $params = @{
                    '@odata.type' = $odatatype
                    'id'          = $role.Id
                    'setting'     = $setting
                    target        = @{
                        '@odata.type' = '#microsoft.graph.unifiedRoleManagementPolicyRuleTarget'
                    }
                }
            }
        }

        elseif ($role.id -match 'Expiration_Admin_Eligibility')
        {
            if ($PSBoundParameters.ContainsKey('PermanentEligibleAssignmentisExpirationRequired') `
                    -and $PSBoundParameters.ContainsKey('ExpireEligibleAssignment'))
            {
                Write-Verbose -Message 'Handle Assignment: Allow permanent eligible assignment / Expire eligible assignments after'
                $params = @{
                    '@odata.type'          = $odatatype
                    'id'                   = $role.Id
                    'isExpirationRequired' = $PermanentEligibleAssignmentisExpirationRequired
                    'maximumDuration'      = $ExpireEligibleAssignment
                    target                 = @{
                        '@odata.type' = 'microsoft.graph.unifiedRoleManagementPolicyRuleTarget'
                    }
                }
            }
        }

        elseif ($role.id -match 'Expiration_Admin_Assignment')
        {
            if ($PSBoundParameters.ContainsKey('PermanentActiveAssignmentisExpirationRequired') `
                    -and $PSBoundParameters.ContainsKey('ExpireActiveAssignment'))
            {
                Write-Verbose -Message 'Handle Assignment: Allow permanent active assignment / Expire active assignments after'
                $params = @{
                    '@odata.type'          = $odatatype
                    'id'                   = $role.Id
                    'isExpirationRequired' = $PermanentActiveAssignmentisExpirationRequired
                    'maximumDuration'      = $ExpireActiveAssignment
                    target                 = @{
                        '@odata.type' = 'microsoft.graph.unifiedRoleManagementPolicyRuleTarget'
                    }
                }
            }
        }

        elseif ($role.id -match 'Enablement_Admin_Assignment')
        {
            if ($PSBoundParameters.ContainsKey('AssignmentReqJustification') `
                    -and $PSBoundParameters.ContainsKey('AssignmentReqMFA'))
            {
                Write-Verbose -Message 'Handle Assignment: Require Azure Multi-Factor Authentication on active assignment / Require justification on active assignment'
                [String[]]$enabledrules = @()
                if ($AssignmentReqJustification)
                {
                    $enabledrules += 'Justification'
                }
                if ($AssignmentReqMFA)
                {
                    $enabledrules += 'MultiFactorAuthentication'
                }
                $params = @{
                    '@odata.type'  = $odatatype
                    'id'           = $role.Id
                    'enabledRules' = $enabledrules
                    target         = @{
                        '@odata.type' = '#microsoft.graph.unifiedRoleManagementPolicyRuleTarget'
                    }
                }
            }
        }
        elseif ($role.id -match 'Enablement_Admin_Eligibility')
        {
            if ($PSBoundParameters.ContainsKey('EligibilityAssignmentReqJustification') `
                    -and $PSBoundParameters.ContainsKey('EligibilityAssignmentReqMFA'))
            {
                Write-Verbose -Message 'Handle Assignment: Require Azure Multi-Factor Authentication on eligibility / Require justification on eligibility'
                [String[]]$enabledrules = @()
                if ($EligibilityAssignmentReqJustification)
                {
                    $enabledrules += 'Justification'
                }
                if ($EligibilityAssignmentReqMFA)
                {
                    $enabledrules += 'MultiFactorAuthentication'
                }
                $params = @{
                    '@odata.type'  = $odatatype
                    'id'           = $role.Id
                    'enabledRules' = $enabledrules
                    target         = @{
                        '@odata.type' = '#microsoft.graph.unifiedRoleManagementPolicyRuleTarget'
                    }
                }
            }
        }
        elseif ($role.Id -match 'AuthenticationContext_EndUser_Assignment')
        {
            if ($PSBoundParameters.ContainsKey('AuthenticationContextRequired') `
                    -and $PSBoundParameters.ContainsKey('AuthenticationContextId'))
            {
                $params = @{
                    '@odata.type' = $odatatype
                    'id'          = $role.Id
                    'isEnabled'   = (-not [System.String]::IsNullOrEmpty($AuthenticationContextId))
                    'claimValue'  = $AuthenticationContextId
                    target        = @{
                        '@odata.type' = 'microsoft.graph.unifiedRoleManagementPolicyRuleTarget'
                    }
                }
            }
        }

        if ($params.Count -gt 0)
        {
            try
            {
                Update-MgBetaPolicyRoleManagementPolicyRule `
                    -UnifiedRoleManagementPolicyId $Policy.Policyid `
                    -UnifiedRoleManagementPolicyRuleId $role.id `
                    -BodyParameter $params `
                    -ErrorAction Stop
            }
            catch
            {
                throw $_
            }
            $params = @{}
        }
    }
}
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $ActivationMaxDuration,

        [Parameter(Mandatory = $true)]
        [ValidateSet('owner', 'member')]
        [System.String]
        $RoleDefinitionId,

        [Parameter()]
        [System.Boolean]
        $ActivationReqJustification,

        [Parameter()]
        [System.Boolean]
        $ActivationReqTicket,

        [Parameter()]
        [System.Boolean]
        $ActivationReqMFA,

        [Parameter()]
        [System.Boolean]
        $ApprovaltoActivate,

        [Parameter()]
        [System.String[]]
        $ActivateApprover,

        [Parameter()]
        [System.Boolean]
        $PermanentEligibleAssignmentisExpirationRequired,

        [Parameter()]
        [System.String]
        $ExpireEligibleAssignment,

        [Parameter()]
        [System.Boolean]
        $PermanentActiveAssignmentisExpirationRequired,

        [Parameter()]
        [System.String]
        $ExpireActiveAssignment,

        [Parameter()]
        [System.Boolean]
        $AssignmentReqMFA,

        [Parameter()]
        [System.Boolean]
        $AssignmentReqJustification,

        [Parameter()]
        [System.Boolean]
        $EligibilityAssignmentReqMFA,

        [Parameter()]
        [System.Boolean]
        $EligibilityAssignmentReqJustification,

        [Parameter()]
        [System.Boolean]
        $EligibleAlertNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $EligibleAlertNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $EligibleAlertNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $EligibleAssigneeNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $EligibleAssigneeNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $EligibleAssigneeNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $EligibleApproveNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $EligibleApproveNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $EligibleApproveNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $ActiveAlertNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActiveAlertNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActiveAlertNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $ActiveAssigneeNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActiveAssigneeNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActiveAssigneeNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $ActiveApproveNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActiveApproveNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActiveApproveNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $EligibleAssignmentAlertNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $EligibleAssignmentAlertNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $EligibleAssignmentAlertNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $EligibleAssignmentAssigneeNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $EligibleAssignmentAssigneeNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $EligibleAssignmentAssigneeNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $AuthenticationContextRequired,

        [Parameter()]
        [System.String]
        $AuthenticationContextId,

        [Parameter()]
        [System.String]
        $AuthenticationContextName,

        [Parameter()]
        [ValidateSet('Present')]
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

    if ($filter -notlike '*DynamicMembership*')
    {
        if (-not [string]::IsNullOrEmpty($filter))
        {
            $Filter = "$Filter and"
        }
        $Filter = "$Filter NOT(groupTypes/any(x:x eq 'DynamicMembership'))"
    }

    $ExportParameters = @{
        Filter           = $Filter
        All              = [switch]$true
        Property         = 'displayname,Id'
        CountVariable    = 'CountVar'
        ConsistencyLevel = 'eventual'
        ErrorAction      = 'Stop'
        Sort             = 'displayname'
    }

    try
    {
        $Script:ExportMode = $true
        [array] $Script:exportedGroups = Get-MgGroup @ExportParameters
        $Script:exportedGroups = $Script:exportedGroups | Where-Object -FilterScript {
            -not ($_.MailEnabled -and ($null -eq $_.GroupTypes -or $_.GroupTypes.Length -eq 0)) -and `
                -not ($_.MailEnabled -and $_.SecurityEnabled)
        }

        $j = 1
        if ($Script:exportedGroups.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $batchRequests = @()
        foreach ($group in $Script:exportedGroups)
        {
            $batchRequests += @{
                id     = $group.Id
                method = 'GET'
                url    = "/policies/roleManagementPolicyAssignments?filter=scopeId eq '$($group.Id)' and scopeType eq 'Group'&`$expand=policy(`$expand=rules)"
            }
        }

        $batchResponses = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests -AsList

        $dscContent = [System.Text.StringBuilder]::new()
        foreach ($group in $Script:exportedGroups)
        {
            $response = $batchResponses.Where({ $_.id -eq $group.Id })
            $getValue = $response.body.value
            Write-M365DSCHost -Message "    |---[$j/$($Script:exportedGroups.Count)] $($group.DisplayName)" -DeferWrite

            $i = 1

            if ($getValue.Length -eq 0)
            {
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
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
                Write-M365DSCHost -Message "        |---[$i/$($getValue.Count)] $($config.Id)" -DeferWrite

                $Params = @{
                    Id                    = $config.Id
                    RoleDefinitionId      = $config.roleDefinitionId
                    DisplayName           = $group.DisplayName
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    ApplicationSecret     = $ApplicationSecret
                    Credential            = $Credential
                    AccessTokens          = $AccessTokens
                }

                $Script:exportedInstance = $config
                $Results = Get-TargetResource @Params
                if ($Results.Ensure -eq 'Present')
                {
                    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                        -ConnectionMode $ConnectionMode `
                        -ModulePath $PSScriptRoot `
                        -Results $Results `
                        -Credential $Credential
                    [void]$dscContent.Append($currentDSCBlock)
                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                        -FileName $Global:PartialExportFileName
                }
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
                $i++
            }
            $j++
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
