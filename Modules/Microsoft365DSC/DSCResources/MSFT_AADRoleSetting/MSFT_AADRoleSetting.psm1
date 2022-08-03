function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Displayname,

        [Parameter()]
        [System.String]
        $ActivationMaxDuration,

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
        $ElegibilityAssignmentReqMFA,

        [Parameter()]
        [System.Boolean]
        $ElegibilityAssignmentReqJustification,

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

    Write-Verbose -Message "Getting configuration of Role"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

    Select-MgProfile -Name 'beta'
    $MaximumFunctionCount = 32000

    Write-Verbose -Message "Getting configuration of Role"

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

    $nullReturn = $null

    function getUserUPN{
        [CmdletBinding()]
        param (
            [Parameter()]
            [string]
            $Id
        )
        $user = Get-MgUser -UserId $Id
        return $user
    }

    #get role
    [string]$Filter = $null
    $Filter = "scopeId eq '/' and scopeType eq 'DirectoryRole' and RoleDefinitionId eq '" + $Id + "'"
    $Policy = Get-MgPolicyRoleManagementPolicyAssignment -Filter $Filter
    $RoleDefinition = Get-MgRoleManagementDirectoryRoleDefinition -UnifiedRoleDefinitionId $Id
    #get Policyrule
    $role = Get-MgPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $Policy.Policyid

    $Displayname = $RoleDefinition.DisplayName
    $ActivationMaxDuration = ($role | Where-Object{$_.Id -eq "Expiration_EndUser_Assignment"}).AdditionalProperties.maximumDuration
    $ActivationReqJustification = (($role | Where-Object{$_.Id -eq "Enablement_EndUser_Assignment"}).AdditionalProperties.enabledRules) -contains "Justification"
    $ActivationReqTicket = (($role | Where-Object{$_.Id -eq "Enablement_EndUser_Assignment"}).AdditionalProperties.enabledRules) -contains "Ticketing"
    $ActivationReqMFA = (($role | Where-Object{$_.Id -eq "Enablement_EndUser_Assignment"}).AdditionalProperties.enabledRules) -contains "MultiFactorAuthentication"
    $ApprovaltoActivate = (($role | Where-Object{$_.Id -eq "Approval_EndUser_Assignment"}).AdditionalProperties.setting.isApprovalRequired)
    [array]$ActivateApprovers = (($role | Where-Object{$_.Id -eq "Approval_EndUser_Assignment"}).AdditionalProperties.setting.approvalStages.primaryApprovers)
    [string[]]$ActivateApprover = @()
    foreach($Item in $ActivateApprovers.id){
        $ActivateApprover += (getUserUPN -Id $Item).UserPrincipalName
    }
    $PermanentEligibleAssignmentisExpirationRequired = ($role | Where-Object{$_.Id -eq "Expiration_Admin_Eligibility"}).AdditionalProperties.isExpirationRequired
    $ExpireEligibleAssignment = ($role | Where-Object{$_.Id -eq "Expiration_Admin_Eligibility"}).AdditionalProperties.maximumDuration
    $PermanentActiveAssignmentisExpirationRequired = ($role | Where-Object{$_.Id -eq "Expiration_Admin_Assignment"}).AdditionalProperties.isExpirationRequired
    $ExpireActiveAssignment = ($role | Where-Object{$_.Id -eq "Expiration_Admin_Assignment"}).AdditionalProperties.maximumDuration
    $AssignmentReqMFA = (($role | Where-Object{$_.Id -eq "Enablement_Admin_Assignment"}).AdditionalProperties.enabledRules) -contains "MultiFactorAuthentication"
    $AssignmentReqJustification = (($role | Where-Object{$_.Id -eq "Enablement_Admin_Assignment"}).AdditionalProperties.enabledRules) -contains "Justification"
    $ElegibilityAssignmentReqMFA = (($role | Where-Object{$_.Id -eq "Enablement_Admin_Eligibility"}).AdditionalProperties.enabledRules) -contains "MultiFactorAuthentication"
    $ElegibilityAssignmentReqJustification = (($role | Where-Object{$_.Id -eq "Enablement_Admin_Eligibility"}).AdditionalProperties.enabledRules) -contains "Justification"
    $EligibleAlertNotificationDefaultRecipient = ($role | Where-Object{$_.Id -eq "Notification_Admin_Admin_Eligibility"}).AdditionalProperties.isDefaultRecipientsEnabled
    [string[]]$EligibleAlertNotificationAdditionalRecipient = ($role | Where-Object{$_.Id -eq "Notification_Admin_Admin_Eligibility"}).AdditionalProperties.notificationRecipients
    $EligibleAlertNotificationOnlyCritical = (($role | Where-Object{$_.Id -eq "Notification_Admin_Admin_Eligibility"}).AdditionalProperties.notificationLevel) -contains ("Critical")
    $EligibleAssigneeNotificationDefaultRecipient = ($role | Where-Object{$_.Id -eq "Notification_Requestor_Admin_Eligibility"}).AdditionalProperties.isDefaultRecipientsEnabled
    [string[]]$EligibleAssigneeNotificationAdditionalRecipient = ($role | Where-Object{$_.Id -eq "Notification_Requestor_Admin_Eligibility"}).AdditionalProperties.notificationRecipients
    $EligibleAssigneeNotificationOnlyCritical = (($role | Where-Object{$_.Id -eq "Notification_Requestor_Admin_Eligibility"}).AdditionalProperties.notificationLevel) -contains ("Critical")
    $EligibleApproveNotificationDefaultRecipient = ($role | Where-Object{$_.Id -eq "Notification_Approver_Admin_Eligibility"}).AdditionalProperties.isDefaultRecipientsEnabled
    [string[]]$EligibleApproveNotificationAdditionalRecipient = ($role | Where-Object{$_.Id -eq "Notification_Approver_Admin_Eligibility"}).AdditionalProperties.notificationRecipients
    $EligibleApproveNotificationOnlyCritical = (($role | Where-Object{$_.Id -eq "Notification_Approver_Admin_Eligibility"}).AdditionalProperties.notificationLevel) -contains ("Critical")
    $ActiveAlertNotificationDefaultRecipient = ($role | Where-Object{$_.Id -eq "Notification_Admin_Admin_Assignment"}).AdditionalProperties.isDefaultRecipientsEnabled
    [string[]]$ActiveAlertNotificationAdditionalRecipient = ($role | Where-Object{$_.Id -eq "Notification_Admin_Admin_Assignment"}).AdditionalProperties.notificationRecipients
    $ActiveAlertNotificationOnlyCritical = (($role | Where-Object{$_.Id -eq "Notification_Admin_Admin_Assignment"}).AdditionalProperties.notificationLevel) -contains ("Critical")
    $ActiveAssigneeNotificationDefaultRecipient = ($role | Where-Object{$_.Id -eq "Notification_Requestor_Admin_Assignment"}).AdditionalProperties.isDefaultRecipientsEnabled
    [string[]]$ActiveAssigneeNotificationAdditionalRecipient = ($role | Where-Object{$_.Id -eq "Notification_Requestor_Admin_Assignment"}).AdditionalProperties.notificationRecipients
    $ActiveAssigneeNotificationOnlyCritical = (($role | Where-Object{$_.Id -eq "Notification_Requestor_Admin_Assignment"}).AdditionalProperties.notificationLevel) -contains ("Critical")
    $ActiveApproveNotificationDefaultRecipient = ($role | Where-Object{$_.Id -eq "Notification_Approver_Admin_Assignment"}).AdditionalProperties.isDefaultRecipientsEnabled
    [string[]]$ActiveApproveNotificationAdditionalRecipient = ($role | Where-Object{$_.Id -eq "Notification_Approver_Admin_Assignment"}).AdditionalProperties.notificationRecipients
    $ActiveApproveNotificationOnlyCritical = (($role | Where-Object{$_.Id -eq "Notification_Approver_Admin_Assignment"}).AdditionalProperties.notificationLevel) -contains ("Critical")
    $EligibleAssignmentAlertNotificationDefaultRecipient = ($role | Where-Object{$_.Id -eq "Notification_Admin_EndUser_Assignment"}).AdditionalProperties.isDefaultRecipientsEnabled
    [string[]]$EligibleAssignmentAlertNotificationAdditionalRecipient = ($role | Where-Object{$_.Id -eq "Notification_Admin_EndUser_Assignment"}).AdditionalProperties.notificationRecipients
    $EligibleAssignmentAlertNotificationOnlyCritical = (($role | Where-Object{$_.Id -eq "Notification_Admin_EndUser_Assignment"}).AdditionalProperties.notificationLevel) -contains ("Critical")
    $EligibleAssignmentAssigneeNotificationDefaultRecipient = ($role | Where-Object{$_.Id -eq "Notification_Requestor_EndUser_Assignment"}).AdditionalProperties.isDefaultRecipientsEnabled
    [string[]]$EligibleAssignmentAssigneeNotificationAdditionalRecipient = ($role | Where-Object{$_.Id -eq "Notification_Requestor_EndUser_Assignment"}).AdditionalProperties.notificationRecipients
    $EligibleAssignmentAssigneeNotificationOnlyCritical = (($role | Where-Object{$_.Id -eq "Notification_Requestor_EndUser_Assignment"}).AdditionalProperties.notificationLevel) -contains ("Critical")

    try{
            Write-Verbose -Message "Found configuration of Rule $($Displayname)"

                $result = @{
                Id                                                          = $Id
                Displayname                                                 = $Displayname
                ActivationMaxDuration                                       = $ActivationMaxDuration
                ActivationReqJustification                                  = $ActivationReqJustification
                ActivationReqTicket                                         = $ActivationReqTicket
                ActivationReqMFA                                            = $ActivationReqMFA
                ApprovaltoActivate                                          = $ApprovaltoActivate
                ActivateApprover                                            = [System.String[]]$ActivateApprover
                PermanentEligibleAssignmentisExpirationRequired             = $PermanentEligibleAssignmentisExpirationRequired
                ExpireEligibleAssignment                                    = $ExpireEligibleAssignment
                PermanentActiveAssignmentisExpirationRequired               = $PermanentActiveAssignmentisExpirationRequired
                ExpireActiveAssignment                                      = $ExpireActiveAssignment
                AssignmentReqMFA                                            = $AssignmentReqMFA
                AssignmentReqJustification                                  = $AssignmentReqJustification
                ElegibilityAssignmentReqMFA                                 = $ElegibilityAssignmentReqMFA
                ElegibilityAssignmentReqJustification                       = $ElegibilityAssignmentReqJustification
                EligibleAlertNotificationDefaultRecipient                   = $EligibleAlertNotificationDefaultRecipient
                EligibleAlertNotificationAdditionalRecipient                = [System.String[]]$EligibleAlertNotificationAdditionalRecipient
                EligibleAlertNotificationOnlyCritical                       = $EligibleAlertNotificationOnlyCritical
                EligibleAssigneeNotificationDefaultRecipient                = $EligibleAssigneeNotificationDefaultRecipient
                EligibleAssigneeNotificationAdditionalRecipient             = [System.String[]]$EligibleAssigneeNotificationAdditionalRecipient
                EligibleAssigneeNotificationOnlyCritical                    = $EligibleAssigneeNotificationOnlyCritical
                EligibleApproveNotificationDefaultRecipient                 = $EligibleApproveNotificationDefaultRecipient
                EligibleApproveNotificationAdditionalRecipient              = [System.String[]]$EligibleApproveNotificationAdditionalRecipient
                EligibleApproveNotificationOnlyCritical                     = $EligibleApproveNotificationOnlyCritical
                ActiveAlertNotificationDefaultRecipient                     = $ActiveAlertNotificationDefaultRecipient
                ActiveAlertNotificationAdditionalRecipient                  = [System.String[]]$ActiveAlertNotificationAdditionalRecipient
                ActiveAlertNotificationOnlyCritical                         = $ActiveAlertNotificationOnlyCritical
                ActiveAssigneeNotificationDefaultRecipient                  = $ActiveAssigneeNotificationDefaultRecipient
                ActiveAssigneeNotificationAdditionalRecipient               = [System.String[]]$ActiveAssigneeNotificationAdditionalRecipient
                ActiveAssigneeNotificationOnlyCritical                      = $ActiveAssigneeNotificationOnlyCritical
                ActiveApproveNotificationDefaultRecipient                   = $ActiveApproveNotificationDefaultRecipient
                ActiveApproveNotificationAdditionalRecipient                = [System.String[]]$ActiveApproveNotificationAdditionalRecipient
                ActiveApproveNotificationOnlyCritical                       = $ActiveApproveNotificationOnlyCritical
                EligibleAssignmentAlertNotificationDefaultRecipient         = $EligibleAssignmentAlertNotificationDefaultRecipient
                EligibleAssignmentAlertNotificationAdditionalRecipient      = [System.String[]]$EligibleAssignmentAlertNotificationAdditionalRecipient
                EligibleAssignmentAlertNotificationOnlyCritical             = $EligibleAssignmentAlertNotificationOnlyCritical
                EligibleAssignmentAssigneeNotificationDefaultRecipient      = $EligibleAssignmentAssigneeNotificationDefaultRecipient
                EligibleAssignmentAssigneeNotificationAdditionalRecipient   = [System.String[]]$EligibleAssignmentAssigneeNotificationAdditionalRecipient
                EligibleAssignmentAssigneeNotificationOnlyCritical          = $EligibleAssignmentAssigneeNotificationOnlyCritical
                ApplicationId                                               = $ApplicationId
                TenantId                                                    = $TenantId
                CertificateThumbprint                                       = $CertificateThumbprint
                ApplicationSecret                                           = $ApplicationSecret
                Credential                                                  = $Credential
            }
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
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
        $Id,

        [Parameter()]
        [System.String]
        $Displayname,

        [Parameter()]
        [System.String]
        $ActivationMaxDuration,

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
        $ElegibilityAssignmentReqMFA,

        [Parameter()]
        [System.Boolean]
        $ElegibilityAssignmentReqJustification,

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

    Write-Verbose -Message "Setting configuration of Role settings"

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

    function GetUserID {
        [CmdletBinding()]
        param (
            [Parameter()]
            [String]
            $UPN
        )
        $Filter = "UserPrincipalName eq '" + $UPN + "'"
        $user = Get-MgUser -Filter $Filter
        return $user
    }

    #get role
    [string]$Filter = $null
    $Filter = "scopeId eq '/' and scopeType eq 'DirectoryRole' and RoleDefinitionId eq '" + $Id + "'"
    $Policy = Get-MgPolicyRoleManagementPolicyAssignment -Filter $Filter
    #get Policyrule
    $roles = Get-MgPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $Policy.Policyid

    foreach($role in $roles){
        $odatatype = $role.AdditionalProperties.'@odata.type'
        if($role.id -match "Notification_Admin_Admin_Eligibility"){
            if($PSBoundParameters.ContainsKey('EligibleAlertNotificationOnlyCritical') `
            -and $PSBoundParameters.ContainsKey('EligibleAlertNotificationDefaultRecipient') `
            -and $PSBoundParameters.ContainsKey('EligibleAlertNotificationAdditionalRecipient')){
                Write-Verbose -Message "Handle Send notifications when members are assigned as eligible to this role: Role assignment alert"
                $notificationLevel = if($EligibleAlertNotificationOnlyCritical -eq "True"){"Critical"}else{"All"}
                $isDefaultRecipientsEnabled = $EligibleAlertNotificationDefaultRecipient
                $notificationRecipients = @($EligibleAlertNotificationAdditionalRecipient)
                $params = @{
                    "@odata.type" = $odatatype
                    "recipientType" = "Admin"
                    "notificationType" = "Email"
                    "notificationLevel" = $notificationLevel
                    "isDefaultRecipientsEnabled" = $isDefaultRecipientsEnabled
                    "notificationRecipients" = $notificationRecipients
                    target = @{
                        "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
                    }
                }
            }
        }
        elseif($role.id -match "Notification_Requestor_Admin_Eligibility"){
            if($PSBoundParameters.ContainsKey('EligibleAssigneeNotificationOnlyCritical') `
            -and $PSBoundParameters.ContainsKey('EligibleAssigneeNotificationDefaultRecipient') `
            -and $PSBoundParameters.ContainsKey('EligibleAssigneeNotificationAdditionalRecipient')){
                Write-Verbose -Message "Handle Send notifications when members are assigned as eligible to this role: Notification to the assigned user (assignee)"
                $notificationLevel = if($EligibleAssigneeNotificationOnlyCritical -eq "True"){"Critical"}else{"All"}
                $isDefaultRecipientsEnabled = $EligibleAssigneeNotificationDefaultRecipient
                $notificationRecipients = @($EligibleAssigneeNotificationAdditionalRecipient)
                $params = @{
                    "@odata.type" = $odatatype
                    "recipientType" = "Requestor"
                    "notificationType" = "Email"
                    "notificationLevel" = $notificationLevel
                    "isDefaultRecipientsEnabled" = $isDefaultRecipientsEnabled
                    "notificationRecipients" = $notificationRecipients
                    target = @{
                        "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
                    }
                }
            }
        }
        elseif($role.id -match "Notification_Approver_Admin_Eligibility"){
            if($PSBoundParameters.ContainsKey('EligibleApproveNotificationOnlyCritical') `
            -and $PSBoundParameters.ContainsKey('EligibleApproveNotificationDefaultRecipient') `
            -and $PSBoundParameters.ContainsKey('EligibleApproveNotificationAdditionalRecipient')){
                Write-Verbose -Message "Handle Send notifications when members are assigned as eligible to this role: Request to approve a role assignment renewal/extension"
                $notificationLevel = if($EligibleApproveNotificationOnlyCritical -eq "True"){"Critical"}else{"All"}
                $isDefaultRecipientsEnabled = $EligibleApproveNotificationDefaultRecipient
                $notificationRecipients = @($EligibleApproveNotificationAdditionalRecipient)
                $params = @{
                    "@odata.type" = $odatatype
                    "recipientType" = "Approver"
                    "notificationType" = "Email"
                    "notificationLevel" = $notificationLevel
                    "isDefaultRecipientsEnabled" = $isDefaultRecipientsEnabled
                    "notificationRecipients" = $notificationRecipients
                    target = @{
                        "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
                    }
                }
            }
        }
        elseif($role.id -match "Notification_Admin_Admin_Assignment"){
            if($PSBoundParameters.ContainsKey('ActiveAlertNotificationOnlyCritical') `
            -and $PSBoundParameters.ContainsKey('ActiveAlertNotificationDefaultRecipient') `
            -and $PSBoundParameters.ContainsKey('ActiveAlertNotificationAdditionalRecipient')){
                Write-Verbose -Message "Handle Send notifications when members are assigned as active to this role: Role assignment alert"
                $notificationLevel = if($ActiveAlertNotificationOnlyCritical -eq "True"){"Critical"}else{"All"}
                $isDefaultRecipientsEnabled = $ActiveAlertNotificationDefaultRecipient
                $notificationRecipients = @($ActiveAlertNotificationAdditionalRecipient)
                $params = @{
                    "@odata.type" = $odatatype
                    "recipientType" = "Admin"
                    "notificationType" = "Email"
                    "notificationLevel" = $notificationLevel
                    "isDefaultRecipientsEnabled" = $isDefaultRecipientsEnabled
                    "notificationRecipients" = $notificationRecipients
                    target = @{
                        "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
                    }
                }
            }
        }
        elseif($role.id -match "Notification_Requestor_Admin_Assignment"){
            if($PSBoundParameters.ContainsKey('ActiveAssigneeNotificationOnlyCritical') `
            -and $PSBoundParameters.ContainsKey('ActiveAssigneeNotificationDefaultRecipient') `
            -and $PSBoundParameters.ContainsKey('ActiveAssigneeNotificationAdditionalRecipient')){
                Write-Verbose -Message "Handle Send notifications when members are assigned as active to this role: Notification to the assigned user (assignee)"
                $notificationLevel = if($ActiveAssigneeNotificationOnlyCritical -eq "True"){"Critical"}else{"All"}
                $isDefaultRecipientsEnabled = $ActiveAssigneeNotificationDefaultRecipient
                $notificationRecipients = @($ActiveAssigneeNotificationAdditionalRecipient)
                $params = @{
                    "@odata.type" = $odatatype
                    "recipientType" = "Requestor"
                    "notificationType" = "Email"
                    "notificationLevel" = $notificationLevel
                    "isDefaultRecipientsEnabled" = $isDefaultRecipientsEnabled
                    "notificationRecipients" = $notificationRecipients
                    target = @{
                        "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
                    }
                }
            }
        }
        elseif($role.id -match "Notification_Approver_Admin_Assignment"){
            if($PSBoundParameters.ContainsKey('ActiveApproveNotificationOnlyCritical') `
            -and $PSBoundParameters.ContainsKey('ActiveApproveNotificationDefaultRecipient') `
            -and $PSBoundParameters.ContainsKey('ActiveApproveNotificationAdditionalRecipient')){
                Write-Verbose -Message "Handle Send notifications when members are assigned as active to this role: Request to approve a role assignment renewal/extension"
                $notificationLevel = if($ActiveApproveNotificationOnlyCritical -eq "True"){"Critical"}else{"All"}
                $isDefaultRecipientsEnabled = $ActiveApproveNotificationDefaultRecipient
                $notificationRecipients = @($ActiveApproveNotificationAdditionalRecipient)
                $params = @{
                    "@odata.type" = $odatatype
                    "recipientType" = "Approver"
                    "notificationType" = "Email"
                    "notificationLevel" = $notificationLevel
                    "isDefaultRecipientsEnabled" = $isDefaultRecipientsEnabled
                    "notificationRecipients" = $notificationRecipients
                    target = @{
                        "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
                    }
                }
            }
        }
        elseif($role.id -match "Notification_Admin_EndUser_Assignment"){
            if($PSBoundParameters.ContainsKey('EligibleAssignmentAlertNotificationOnlyCritical') `
            -and $PSBoundParameters.ContainsKey('EligibleAssignmentAlertNotificationDefaultRecipient') `
            -and $PSBoundParameters.ContainsKey('EligibleAssignmentAlertNotificationAdditionalRecipient')){
                Write-Verbose -Message "Handle Send notifications when eligible members activate this role: Role activation alert"
                $notificationLevel = if($EligibleAssignmentAlertNotificationOnlyCritical -eq "True"){"Critical"}else{"All"}
                $isDefaultRecipientsEnabled = $EligibleAssignmentAlertNotificationDefaultRecipient
                $notificationRecipients = @($EligibleAssignmentAlertNotificationAdditionalRecipient)
                $params = @{
                    "@odata.type" = $odatatype
                    "recipientType" = "Admin"
                    "notificationType" = "Email"
                    "notificationLevel" = $notificationLevel
                    "isDefaultRecipientsEnabled" = $isDefaultRecipientsEnabled
                    "notificationRecipients" = $notificationRecipients
                    target = @{
                        "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
                    }
                }
            }
        }
        elseif($role.id -match "Notification_Requestor_EndUser_Assignment"){
            if($PSBoundParameters.ContainsKey('EligibleAssignmentAssigneeNotificationOnlyCritical') `
            -and $PSBoundParameters.ContainsKey('EligibleAssignmentAssigneeNotificationDefaultRecipient') `
            -and $PSBoundParameters.ContainsKey('EligibleAssignmentAssigneeNotificationAdditionalRecipient')){
                Write-Verbose -Message "Handle Send notifications when eligible members activate this role: Notification to activated user (requestor)"
                $notificationLevel = if($EligibleAssignmentAssigneeNotificationOnlyCritical -eq "True"){"Critical"}else{"All"}
                $isDefaultRecipientsEnabled = $EligibleAssignmentAssigneeNotificationDefaultRecipient
                $notificationRecipients = @($EligibleAssignmentAssigneeNotificationAdditionalRecipient)
                $params = @{
                    "@odata.type" = $odatatype
                    "recipientType" = "Requestor"
                    "notificationType" = "Email"
                    "notificationLevel" = $notificationLevel
                    "isDefaultRecipientsEnabled" = $isDefaultRecipientsEnabled
                    "notificationRecipients" = $notificationRecipients
                    target = @{
                        "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
                    }
                }
            }
        }

        elseif($role.id -match "Expiration_EndUser_Assignment"){
            if($PSBoundParameters.ContainsKey('ActivationMaxDuration')){
                Write-Verbose -Message "Handle Activation: Activation maximum duration (hours)"
                $params = @{
                    "@odata.type" = $odatatype
                    "id" = $role.Id
                    "maximumDuration" = $ActivationMaxDuration
                    target = @{
                        "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
                    }
                }
            }
        }
        elseif($role.id -match "Enablement_EndUser_Assignment"){
            if($PSBoundParameters.ContainsKey('ActivationReqJustification') `
            -and $PSBoundParameters.ContainsKey('ActivationReqTicket') `
            -and $PSBoundParameters.ContainsKey('ActivationReqMFA')){
                Write-Verbose -Message "Handle Activation: Require justification on activation"
                [String[]]$enabledrules = @()
                if($ActivationReqJustification){$enabledrules += "Justification"}
                if($ActivationReqTicket){$enabledrules += "Ticketing"}
                if($ActivationReqMFA){$enabledrules += "MultiFactorAuthentication"}
                $params = @{
                    "@odata.type" = $odatatype
                    "id" = $role.Id
                    "enabledRules" = $enabledrules
                    target = @{
                        "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
                    }
                }
            }
        }

        elseif($role.Id -match "Approval_EndUser_Assignment"){
            if($PSBoundParameters.ContainsKey('ApprovaltoActivate') `
            -and $PSBoundParameters.ContainsKey('ActivateApprover')){
                Write-Verbose -Message "Handle Activation: Require approval to activate / Approvers"
                $isApprovalRequired = $ApprovaltoActivate
                if($ActivateApprover.count -gt 0){
                    $primaryApprovers = @()
                    foreach($UPN in $ActivateApprover){
                        $ActivateApprovers = @{}
                        $ActivateApprovers.Add("@odata.type","#microsoft.graph.singleUser")
                        $ActivateApprovers.Add("userId",(GetUserID -UPN $UPN).Id)
                        $primaryApprovers += $ActivateApprovers
                    }
                }
                $approvalStages = @{}
                $approvalStages.Add("approvalStageTimeOutInDays","1")
                $approvalStages.Add("isApproverJustificationRequired","true")
                $approvalStages.Add("escalationTimeInMinutes","0")
                $approvalStages.Add("isEscalationEnabled","False")
                if($primaryApprovers.Count -gt 0){
                    $approvalStages.Add("primaryApprovers",@($primaryApprovers))
                }
                else{
                    $approvalStages.Add("primaryApprovers",@())
                }
                $approvalStages.Add("escalationApprovers",@())

                $setting = @{}
                $setting.Add("isApprovalRequired",$isApprovalRequired)
                $setting.Add("isApprovalRequiredForExtension","false")
                $setting.Add("isRequestorJustificationRequired","true")
                $setting.Add("approvalMode","SingleStage")
                $setting.Add("approvalStages",@($approvalStages))

                $params = @{
                    "@odata.type" = $odatatype
                    "id" = $role.Id
                    "setting" = $setting
                    target = @{
                        "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
                    }
                }
            }
        }

        elseif($role.id -match "Expiration_Admin_Eligibility"){
            if($PSBoundParameters.ContainsKey('PermanentEligibleAssignmentisExpirationRequired') `
            -and $PSBoundParameters.ContainsKey('ExpireEligibleAssignment')){
                Write-Verbose -Message "Handle Assignment: Allow permanent eligible assignment / Expire eligible assignments after"
                $params = @{
                    "@odata.type" = $odatatype
                    "id" = $role.Id
                    "isExpirationRequired" = $PermanentEligibleAssignmentisExpirationRequired
                    "maximumDuration" = $ExpireEligibleAssignment
                    target = @{
                        "@odata.type" = "microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
                    }
                }
            }
        }

        elseif($role.id -match "Expiration_Admin_Assignment"){
            if($PSBoundParameters.ContainsKey('PermanentActiveAssignmentisExpirationRequired') `
            -and $PSBoundParameters.ContainsKey('ExpireActiveAssignment')){
                Write-Verbose -Message "Handle Assignment: Allow permanent active assignment / Expire active assignments after"
                $params = @{
                    "@odata.type" = $odatatype
                    "id" = $role.Id
                    "isExpirationRequired" = $PermanentActiveAssignmentisExpirationRequired
                    "maximumDuration" = $ExpireActiveAssignment
                    target = @{
                        "@odata.type" = "microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
                    }
                }
            }
        }

        elseif($role.id -match "Enablement_Admin_Assignment"){
            if($PSBoundParameters.ContainsKey('AssignmentReqJustification') `
            -and $PSBoundParameters.ContainsKey('AssignmentReqMFA')){
                Write-Verbose -Message "Handle Assignment: Require Azure Multi-Factor Authentication on active assignment / Require justification on active assignment"
                [String[]]$enabledrules = @()
                if($AssignmentReqJustification){$enabledrules += "Justification"}
                if($AssignmentReqMFA){$enabledrules += "MultiFactorAuthentication"}
                $params = @{
                    "@odata.type" = $odatatype
                    "id" = $role.Id
                    "enabledRules" = $enabledrules
                    target = @{
                        "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
                    }
                }
            }
        }

        elseif($role.id -match "Enablement_Admin_Eligibility"){
            if($PSBoundParameters.ContainsKey('ElegibilityAssignmentReqJustification') `
            -and $PSBoundParameters.ContainsKey('ElegibilityAssignmentReqMFA')){
                Write-Verbose -Message "Handle Assignment: Require Azure Multi-Factor Authentication on elegibility / Require justification on elegibility"
                [String[]]$enabledrules = @()
                if($ElegibilityAssignmentReqJustification){$enabledrules += "Justification"}
                if($ElegibilityAssignmentReqMFA){$enabledrules += "MultiFactorAuthentication"}
                $params = @{
                    "@odata.type" = $odatatype
                    "id" = $role.Id
                    "enabledRules" = $enabledrules
                    target = @{
                        "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
                    }
                }
            }
        }

        if($params.Count -gt 0){
            try{
                Update-MgPolicyRoleManagementPolicyRule `
                -UnifiedRoleManagementPolicyId $Policy.Policyid `
                -UnifiedRoleManagementPolicyRuleId $role.id `
                -BodyParameter $params `
                -ErrorAction Stop


            }
            catch{
                Write-Verbose -Message "Problem on set $($role.id) for Policy $($Policy.PolicyId)"
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Displayname,

        [Parameter()]
        [System.String]
        $ActivationMaxDuration,

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
        $ElegibilityAssignmentReqMFA,

        [Parameter()]
        [System.Boolean]
        $ElegibilityAssignmentReqJustification,

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

    Write-Verbose -Message "Testing configuration of Role Assignment"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('Id') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

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
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

    Select-MgProfile -Name 'beta'
    $MaximumFunctionCount = 32000

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
        [array]$roles = Get-MgRoleManagementDirectoryRoleDefinition -UnifiedRoleDefinitionId "9360feb5-f418-4baa-8175-e2a00bac4301" -ErrorAction Stop
        $i = 1
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($role in $roles)
        {
            Write-Host "    |---[$i/$($roles.Count)] $($role.DisplayName)" -NoNewline
            $Params = @{
                Id                      = $role.Id
                ApplicationId           = $ApplicationId
                TenantId                = $TenantId
                CertificateThumbprint   = $CertificateThumbprint
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName

            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }

    catch
    {
        Write-Host $_
        Write-Host $Global:M365DSCEmojiRedX
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
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
