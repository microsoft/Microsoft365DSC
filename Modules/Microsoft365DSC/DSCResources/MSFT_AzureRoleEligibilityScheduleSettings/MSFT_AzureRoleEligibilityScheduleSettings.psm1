Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AzureRoleEligibilityScheduleSettings'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $RoleDefinitionDisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ScopeId,

        [Parameter()]
        [System.String]
        $PolicyId,

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
        $ActivationReqAuthContext,

        [Parameter()]
        [System.String]
        $ActivationAuthContextId,

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
        $ActivationAlertNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActivationAlertNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActivationAlertNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $ActivationAssigneeNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActivationAssigneeNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActivationAssigneeNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $ActivationApproveNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActivationApproveNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActivationApproveNotificationOnlyCritical,

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

    Write-Verbose -Message "Getting configuration of Azure Role Eligibility Schedule Settings for Role {$RoleDefinitionDisplayName} at Scope {$ScopeId}"

    if ($null -eq $Script:exportedInstance)
    {
        $null = New-M365DSCConnection -Workload 'Azure' `
            -InboundParameters $PSBoundParameters

        $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

        $nullReturn = $PSBoundParameters

        $apiVersion = '2020-10-01'
        $uri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)$ScopeId/providers/Microsoft.Authorization/roleManagementPolicyAssignments?api-version=$apiVersion"
        $response = Invoke-AzRestMethod -Uri $uri -Method GET
        $assignments = (ConvertFrom-Json $response.Content).value

        if ($null -eq $assignments -or $assignments.Count -eq 0)
        {
            Write-Verbose -Message "No role management policy assignments found at scope {$ScopeId}."
            return $nullReturn
        }

        $assignment = $assignments | Where-Object {
            $_.properties.roleDefinitionDisplayName -eq $RoleDefinitionDisplayName -or
            $_.properties.policyAssignmentProperties.roleDefinition.displayName -eq $RoleDefinitionDisplayName
        }

        if ($null -eq $assignment)
        {
            $roleDefUri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)$ScopeId/providers/Microsoft.Authorization/roleDefinitions?api-version=$apiVersion&`$filter=roleName eq '$RoleDefinitionDisplayName'"
            $roleDefResponse = Invoke-AzRestMethod -Uri $roleDefUri -Method GET
            $roleDefinitions = (ConvertFrom-Json $roleDefResponse.Content).value

            if ($null -ne $roleDefinitions -and $roleDefinitions.Count -gt 0)
            {
                $roleDefId = $roleDefinitions[0].id
                $assignment = $assignments | Where-Object {
                    $_.properties.roleDefinitionId -eq $roleDefId
                }
            }
        }

        if ($null -eq $assignment)
        {
            Write-Verbose -Message "Could not find role management policy assignment for role {$RoleDefinitionDisplayName} at scope {$ScopeId}."
            return $nullReturn
        }

        $policyIdValue = $assignment.properties.policyId.Split('/')[-1]

        $policyUri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)$ScopeId/providers/Microsoft.Authorization/roleManagementPolicies/$($policyIdValue)?api-version=$apiVersion"
        $policyResponse = Invoke-AzRestMethod -Uri $policyUri -Method GET
        $policy = ConvertFrom-Json $policyResponse.Content

        if ($null -eq $policy -or $null -eq $policy.properties -or $null -eq $policy.properties.rules)
        {
            Write-Verbose -Message "Could not retrieve role management policy {$policyIdValue} at scope {$ScopeId}."
            return $nullReturn
        }

        $rules = $policy.properties.rules
    }
    else
    {
        $rules = $Script:exportedInstance.rules
        $policyIdValue = $Script:exportedInstance.policyId
    }

    $nullReturn = $PSBoundParameters

    if ($null -eq $rules -or $rules.Count -eq 0)
    {
        Write-Verbose -Message 'No Policy Rules found, returning null'
        return $nullReturn
    }

    try
    {
        # Extract activation settings
        $ActivationMaxDuration = ($rules | Where-Object { $_.id -eq 'Expiration_EndUser_Assignment' }).maximumDuration
        $ActivationReqJustification = (($rules | Where-Object { $_.id -eq 'Enablement_EndUser_Assignment' }).enabledRules) -contains 'Justification'
        $ActivationReqTicket = (($rules | Where-Object { $_.id -eq 'Enablement_EndUser_Assignment' }).enabledRules) -contains 'Ticketing'
        $ActivationReqMFA = (($rules | Where-Object { $_.id -eq 'Enablement_EndUser_Assignment' }).enabledRules) -contains 'MultiFactorAuthentication'
        $ApprovaltoActivate = ($rules | Where-Object { $_.id -eq 'Approval_EndUser_Assignment' }).setting.isApprovalRequired
        $ActivationReqAuthContext = ($rules | Where-Object { $_.id -eq 'AuthenticationContext_EndUser_Assignment' }).isEnabled
        $ActivationAuthContextId = ($rules | Where-Object { $_.id -eq 'AuthenticationContext_EndUser_Assignment' }).claimValue
        [string[]]$ActivateApprover = @()
        $approverEntries = ($rules | Where-Object { $_.id -eq 'Approval_EndUser_Assignment' }).setting.approvalStages
        if ($null -ne $approverEntries -and $approverEntries.Count -gt 0)
        {
            foreach ($approver in $approverEntries[0].primaryApprovers)
            {
                if (-not [System.String]::IsNullOrEmpty($approver.id))
                {
                    $directoryObject = Get-MgBetaDirectoryObjectById -Ids $approver.id -ErrorAction SilentlyContinue
                    if ($null -ne $directoryObject)
                    {
                        $odataType = $directoryObject['@odata.type']
                        if (-not [System.String]::IsNullOrEmpty($odataType) -and $odataType.Split('.').Count -ge 3)
                        {
                            $objectType = $odataType.Split('.')[2]
                            if ($objectType -eq 'user')
                            {
                                $ActivateApprover += $directoryObject['userPrincipalName']
                            }
                            else
                            {
                                $ActivateApprover += $directoryObject['displayName']
                            }
                        }
                        else
                        {
                            Write-Verbose -Message "Could not determine type for approver with Id {$($approver.id)}"
                        }
                    }
                    else
                    {
                        Write-Verbose -Message "Could not resolve approver with Id {$($approver.id)}"
                    }
                }
            }
        }

        # Extract eligible assignment settings
        $PermanentEligibleAssignmentisExpirationRequired = ($rules | Where-Object { $_.id -eq 'Expiration_Admin_Eligibility' }).isExpirationRequired
        $ExpireEligibleAssignment = ($rules | Where-Object { $_.id -eq 'Expiration_Admin_Eligibility' }).maximumDuration

        # Extract active assignment settings
        $PermanentActiveAssignmentisExpirationRequired = ($rules | Where-Object { $_.id -eq 'Expiration_Admin_Assignment' }).isExpirationRequired
        $ExpireActiveAssignment = ($rules | Where-Object { $_.id -eq 'Expiration_Admin_Assignment' }).maximumDuration
        $AssignmentReqMFA = (($rules | Where-Object { $_.id -eq 'Enablement_Admin_Assignment' }).enabledRules) -contains 'MultiFactorAuthentication'
        $AssignmentReqJustification = (($rules | Where-Object { $_.id -eq 'Enablement_Admin_Assignment' }).enabledRules) -contains 'Justification'

        # Extract eligible assignment enablement settings
        $EligibilityAssignmentReqMFA = (($rules | Where-Object { $_.id -eq 'Enablement_Admin_Eligibility' }).enabledRules) -contains 'MultiFactorAuthentication'
        $EligibilityAssignmentReqJustification = (($rules | Where-Object { $_.id -eq 'Enablement_Admin_Eligibility' }).enabledRules) -contains 'Justification'

        # Extract notification settings for eligible assignments
        $EligibleAlertNotificationDefaultRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Admin_Admin_Eligibility' }).isDefaultRecipientsEnabled
        [string[]]$EligibleAlertNotificationAdditionalRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Admin_Admin_Eligibility' }).notificationRecipients
        $EligibleAlertNotificationOnlyCritical = (($rules | Where-Object { $_.id -eq 'Notification_Admin_Admin_Eligibility' }).notificationLevel) -eq 'Critical'
        $EligibleAssigneeNotificationDefaultRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Requestor_Admin_Eligibility' }).isDefaultRecipientsEnabled
        [string[]]$EligibleAssigneeNotificationAdditionalRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Requestor_Admin_Eligibility' }).notificationRecipients
        $EligibleAssigneeNotificationOnlyCritical = (($rules | Where-Object { $_.id -eq 'Notification_Requestor_Admin_Eligibility' }).notificationLevel) -eq 'Critical'
        $EligibleApproveNotificationDefaultRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Approver_Admin_Eligibility' }).isDefaultRecipientsEnabled
        [string[]]$EligibleApproveNotificationAdditionalRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Approver_Admin_Eligibility' }).notificationRecipients
        $EligibleApproveNotificationOnlyCritical = (($rules | Where-Object { $_.id -eq 'Notification_Approver_Admin_Eligibility' }).notificationLevel) -eq 'Critical'

        # Extract notification settings for active assignments
        $ActiveAlertNotificationDefaultRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Admin_Admin_Assignment' }).isDefaultRecipientsEnabled
        [string[]]$ActiveAlertNotificationAdditionalRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Admin_Admin_Assignment' }).notificationRecipients
        $ActiveAlertNotificationOnlyCritical = (($rules | Where-Object { $_.id -eq 'Notification_Admin_Admin_Assignment' }).notificationLevel) -eq 'Critical'
        $ActiveAssigneeNotificationDefaultRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Requestor_Admin_Assignment' }).isDefaultRecipientsEnabled
        [string[]]$ActiveAssigneeNotificationAdditionalRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Requestor_Admin_Assignment' }).notificationRecipients
        $ActiveAssigneeNotificationOnlyCritical = (($rules | Where-Object { $_.id -eq 'Notification_Requestor_Admin_Assignment' }).notificationLevel) -eq 'Critical'
        $ActiveApproveNotificationDefaultRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Approver_Admin_Assignment' }).isDefaultRecipientsEnabled
        [string[]]$ActiveApproveNotificationAdditionalRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Approver_Admin_Assignment' }).notificationRecipients
        $ActiveApproveNotificationOnlyCritical = (($rules | Where-Object { $_.id -eq 'Notification_Approver_Admin_Assignment' }).notificationLevel) -eq 'Critical'

        # Extract notification settings for activation
        $ActivationAlertNotificationDefaultRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Admin_EndUser_Assignment' }).isDefaultRecipientsEnabled
        [string[]]$ActivationAlertNotificationAdditionalRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Admin_EndUser_Assignment' }).notificationRecipients
        $ActivationAlertNotificationOnlyCritical = (($rules | Where-Object { $_.id -eq 'Notification_Admin_EndUser_Assignment' }).notificationLevel) -eq 'Critical'
        $ActivationAssigneeNotificationDefaultRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Requestor_EndUser_Assignment' }).isDefaultRecipientsEnabled
        [string[]]$ActivationAssigneeNotificationAdditionalRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Requestor_EndUser_Assignment' }).notificationRecipients
        $ActivationAssigneeNotificationOnlyCritical = (($rules | Where-Object { $_.id -eq 'Notification_Requestor_EndUser_Assignment' }).notificationLevel) -eq 'Critical'
        $ActivationApproveNotificationDefaultRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Approver_EndUser_Assignment' }).isDefaultRecipientsEnabled
        [string[]]$ActivationApproveNotificationAdditionalRecipient = ($rules | Where-Object { $_.id -eq 'Notification_Approver_EndUser_Assignment' }).notificationRecipients
        $ActivationApproveNotificationOnlyCritical = (($rules | Where-Object { $_.id -eq 'Notification_Approver_EndUser_Assignment' }).notificationLevel) -eq 'Critical'

        Write-Verbose -Message "Found configuration for Role {$RoleDefinitionDisplayName} at Scope {$ScopeId}"
        $result = @{
            RoleDefinitionDisplayName                                 = $RoleDefinitionDisplayName
            ScopeId                                                   = $ScopeId
            PolicyId                                                  = $policyIdValue
            ActivationMaxDuration                                     = $ActivationMaxDuration
            ActivationReqJustification                                = $ActivationReqJustification
            ActivationReqTicket                                       = $ActivationReqTicket
            ActivationReqMFA                                          = $ActivationReqMFA
            ApprovaltoActivate                                        = $ApprovaltoActivate
            ActivateApprover                                          = [System.String[]]$ActivateApprover
            ActivationReqAuthContext                                  = $ActivationReqAuthContext
            ActivationAuthContextId                                   = $ActivationAuthContextId
            PermanentEligibleAssignmentisExpirationRequired           = $PermanentEligibleAssignmentisExpirationRequired
            ExpireEligibleAssignment                                  = $ExpireEligibleAssignment
            PermanentActiveAssignmentisExpirationRequired             = $PermanentActiveAssignmentisExpirationRequired
            ExpireActiveAssignment                                    = $ExpireActiveAssignment
            AssignmentReqMFA                                          = $AssignmentReqMFA
            AssignmentReqJustification                                = $AssignmentReqJustification
            EligibilityAssignmentReqMFA                               = $EligibilityAssignmentReqMFA
            EligibilityAssignmentReqJustification                     = $EligibilityAssignmentReqJustification
            EligibleAlertNotificationDefaultRecipient                 = $EligibleAlertNotificationDefaultRecipient
            EligibleAlertNotificationAdditionalRecipient              = [System.String[]]$EligibleAlertNotificationAdditionalRecipient
            EligibleAlertNotificationOnlyCritical                     = $EligibleAlertNotificationOnlyCritical
            EligibleAssigneeNotificationDefaultRecipient              = $EligibleAssigneeNotificationDefaultRecipient
            EligibleAssigneeNotificationAdditionalRecipient           = [System.String[]]$EligibleAssigneeNotificationAdditionalRecipient
            EligibleAssigneeNotificationOnlyCritical                  = $EligibleAssigneeNotificationOnlyCritical
            EligibleApproveNotificationDefaultRecipient               = $EligibleApproveNotificationDefaultRecipient
            EligibleApproveNotificationAdditionalRecipient            = [System.String[]]$EligibleApproveNotificationAdditionalRecipient
            EligibleApproveNotificationOnlyCritical                   = $EligibleApproveNotificationOnlyCritical
            ActiveAlertNotificationDefaultRecipient                   = $ActiveAlertNotificationDefaultRecipient
            ActiveAlertNotificationAdditionalRecipient                = [System.String[]]$ActiveAlertNotificationAdditionalRecipient
            ActiveAlertNotificationOnlyCritical                       = $ActiveAlertNotificationOnlyCritical
            ActiveAssigneeNotificationDefaultRecipient                = $ActiveAssigneeNotificationDefaultRecipient
            ActiveAssigneeNotificationAdditionalRecipient             = [System.String[]]$ActiveAssigneeNotificationAdditionalRecipient
            ActiveAssigneeNotificationOnlyCritical                    = $ActiveAssigneeNotificationOnlyCritical
            ActiveApproveNotificationDefaultRecipient                 = $ActiveApproveNotificationDefaultRecipient
            ActiveApproveNotificationAdditionalRecipient              = [System.String[]]$ActiveApproveNotificationAdditionalRecipient
            ActiveApproveNotificationOnlyCritical                     = $ActiveApproveNotificationOnlyCritical
            ActivationAlertNotificationDefaultRecipient               = $ActivationAlertNotificationDefaultRecipient
            ActivationAlertNotificationAdditionalRecipient            = [System.String[]]$ActivationAlertNotificationAdditionalRecipient
            ActivationAlertNotificationOnlyCritical                   = $ActivationAlertNotificationOnlyCritical
            ActivationAssigneeNotificationDefaultRecipient            = $ActivationAssigneeNotificationDefaultRecipient
            ActivationAssigneeNotificationAdditionalRecipient         = [System.String[]]$ActivationAssigneeNotificationAdditionalRecipient
            ActivationAssigneeNotificationOnlyCritical                = $ActivationAssigneeNotificationOnlyCritical
            ActivationApproveNotificationDefaultRecipient             = $ActivationApproveNotificationDefaultRecipient
            ActivationApproveNotificationAdditionalRecipient          = [System.String[]]$ActivationApproveNotificationAdditionalRecipient
            ActivationApproveNotificationOnlyCritical                 = $ActivationApproveNotificationOnlyCritical
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $RoleDefinitionDisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ScopeId,

        [Parameter()]
        [System.String]
        $PolicyId,

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
        $ActivationReqAuthContext,

        [Parameter()]
        [System.String]
        $ActivationAuthContextId,

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
        $ActivationAlertNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActivationAlertNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActivationAlertNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $ActivationAssigneeNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActivationAssigneeNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActivationAssigneeNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $ActivationApproveNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActivationApproveNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActivationApproveNotificationOnlyCritical,

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

    Write-Verbose -Message "Setting configuration of Azure Role Eligibility Schedule Settings for Role {$RoleDefinitionDisplayName} at Scope {$ScopeId}"

    try
    {
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

        $policyIdValue = $currentInstance.PolicyId
        if ([System.String]::IsNullOrEmpty($policyIdValue))
        {
            throw "Could not find role management policy for role {$RoleDefinitionDisplayName} at scope {$ScopeId}"
        }

        # Get the full policy to retrieve all current rules
        $apiVersion = '2020-10-01'
        $policyUri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)$ScopeId/providers/Microsoft.Authorization/roleManagementPolicies/$($policyIdValue)?api-version=$apiVersion"
        $policyResponse = Invoke-AzRestMethod -Uri $policyUri -Method GET
        $policy = ConvertFrom-Json $policyResponse.Content
        $rules = $policy.properties.rules
        $ruleModified = $false

        foreach ($currentRule in $rules)
        {
            $params = @{}

            if ($currentRule.id -eq 'Notification_Admin_Admin_Eligibility')
            {
                if ($PSBoundParameters.ContainsKey('EligibleAlertNotificationOnlyCritical') `
                        -or $PSBoundParameters.ContainsKey('EligibleAlertNotificationDefaultRecipient') `
                        -or $PSBoundParameters.ContainsKey('EligibleAlertNotificationAdditionalRecipient'))
                {
                    Write-Verbose -Message 'Handle Send notifications when members are assigned as eligible to this role: Role assignment alert'
                    $onlyCritical = if ($PSBoundParameters.ContainsKey('EligibleAlertNotificationOnlyCritical')) { $EligibleAlertNotificationOnlyCritical } else { $currentRule.notificationLevel -eq 'Critical' }
                    $defaultRecipient = if ($PSBoundParameters.ContainsKey('EligibleAlertNotificationDefaultRecipient')) { $EligibleAlertNotificationDefaultRecipient } else { $currentRule.isDefaultRecipientsEnabled }
                    $additionalRecipient = if ($PSBoundParameters.ContainsKey('EligibleAlertNotificationAdditionalRecipient')) { @($EligibleAlertNotificationAdditionalRecipient) } else { @($currentRule.notificationRecipients) }
                    $notificationLevel = if ($onlyCritical)
                    {
                        'Critical'
                    }
                    else
                    {
                        'All'
                    }
                    $params = @{
                        ruleType                 = $currentRule.ruleType
                        id                       = $currentRule.id
                        notificationType         = 'Email'
                        recipientType            = 'Admin'
                        notificationLevel        = $notificationLevel
                        isDefaultRecipientsEnabled = $defaultRecipient
                        notificationRecipients   = [System.Collections.ArrayList]@($additionalRecipient)
                        target                   = $currentRule.target
                    }
                }
            }
            elseif ($currentRule.id -eq 'Notification_Requestor_Admin_Eligibility')
            {
                if ($PSBoundParameters.ContainsKey('EligibleAssigneeNotificationOnlyCritical') `
                        -or $PSBoundParameters.ContainsKey('EligibleAssigneeNotificationDefaultRecipient') `
                        -or $PSBoundParameters.ContainsKey('EligibleAssigneeNotificationAdditionalRecipient'))
                {
                    Write-Verbose -Message 'Handle Send notifications when members are assigned as eligible to this role: Notification to the assigned user (assignee)'
                    $onlyCritical = if ($PSBoundParameters.ContainsKey('EligibleAssigneeNotificationOnlyCritical')) { $EligibleAssigneeNotificationOnlyCritical } else { $currentRule.notificationLevel -eq 'Critical' }
                    $defaultRecipient = if ($PSBoundParameters.ContainsKey('EligibleAssigneeNotificationDefaultRecipient')) { $EligibleAssigneeNotificationDefaultRecipient } else { $currentRule.isDefaultRecipientsEnabled }
                    $additionalRecipient = if ($PSBoundParameters.ContainsKey('EligibleAssigneeNotificationAdditionalRecipient')) { @($EligibleAssigneeNotificationAdditionalRecipient) } else { @($currentRule.notificationRecipients) }
                    $notificationLevel = if ($onlyCritical)
                    {
                        'Critical'
                    }
                    else
                    {
                        'All'
                    }
                    $params = @{
                        ruleType                 = $currentRule.ruleType
                        id                       = $currentRule.id
                        notificationType         = 'Email'
                        recipientType            = 'Requestor'
                        notificationLevel        = $notificationLevel
                        isDefaultRecipientsEnabled = $defaultRecipient
                        notificationRecipients   = [System.Collections.ArrayList]@($additionalRecipient)
                        target                   = $currentRule.target
                    }
                }
            }
            elseif ($currentRule.id -eq 'Notification_Approver_Admin_Eligibility')
            {
                if ($PSBoundParameters.ContainsKey('EligibleApproveNotificationOnlyCritical') `
                        -or $PSBoundParameters.ContainsKey('EligibleApproveNotificationDefaultRecipient') `
                        -or $PSBoundParameters.ContainsKey('EligibleApproveNotificationAdditionalRecipient'))
                {
                    Write-Verbose -Message 'Handle Send notifications when members are assigned as eligible to this role: Request to approve a role assignment renewal/extension'
                    $onlyCritical = if ($PSBoundParameters.ContainsKey('EligibleApproveNotificationOnlyCritical')) { $EligibleApproveNotificationOnlyCritical } else { $currentRule.notificationLevel -eq 'Critical' }
                    $defaultRecipient = if ($PSBoundParameters.ContainsKey('EligibleApproveNotificationDefaultRecipient')) { $EligibleApproveNotificationDefaultRecipient } else { $currentRule.isDefaultRecipientsEnabled }
                    $additionalRecipient = if ($PSBoundParameters.ContainsKey('EligibleApproveNotificationAdditionalRecipient')) { @($EligibleApproveNotificationAdditionalRecipient) } else { @($currentRule.notificationRecipients) }
                    $notificationLevel = if ($onlyCritical)
                    {
                        'Critical'
                    }
                    else
                    {
                        'All'
                    }
                    $params = @{
                        ruleType                 = $currentRule.ruleType
                        id                       = $currentRule.id
                        notificationType         = 'Email'
                        recipientType            = 'Approver'
                        notificationLevel        = $notificationLevel
                        isDefaultRecipientsEnabled = $defaultRecipient
                        notificationRecipients   = [System.Collections.ArrayList]@($additionalRecipient)
                        target                   = $currentRule.target
                    }
                }
            }
            elseif ($currentRule.id -eq 'Notification_Admin_Admin_Assignment')
            {
                if ($PSBoundParameters.ContainsKey('ActiveAlertNotificationOnlyCritical') `
                        -or $PSBoundParameters.ContainsKey('ActiveAlertNotificationDefaultRecipient') `
                        -or $PSBoundParameters.ContainsKey('ActiveAlertNotificationAdditionalRecipient'))
                {
                    Write-Verbose -Message 'Handle Send notifications when members are assigned as active to this role: Role assignment alert'
                    $onlyCritical = if ($PSBoundParameters.ContainsKey('ActiveAlertNotificationOnlyCritical')) { $ActiveAlertNotificationOnlyCritical } else { $currentRule.notificationLevel -eq 'Critical' }
                    $defaultRecipient = if ($PSBoundParameters.ContainsKey('ActiveAlertNotificationDefaultRecipient')) { $ActiveAlertNotificationDefaultRecipient } else { $currentRule.isDefaultRecipientsEnabled }
                    $additionalRecipient = if ($PSBoundParameters.ContainsKey('ActiveAlertNotificationAdditionalRecipient')) { @($ActiveAlertNotificationAdditionalRecipient) } else { @($currentRule.notificationRecipients) }
                    $notificationLevel = if ($onlyCritical)
                    {
                        'Critical'
                    }
                    else
                    {
                        'All'
                    }
                    $params = @{
                        ruleType                 = $currentRule.ruleType
                        id                       = $currentRule.id
                        notificationType         = 'Email'
                        recipientType            = 'Admin'
                        notificationLevel        = $notificationLevel
                        isDefaultRecipientsEnabled = $defaultRecipient
                        notificationRecipients   = [System.Collections.ArrayList]@($additionalRecipient)
                        target                   = $currentRule.target
                    }
                }
            }
            elseif ($currentRule.id -eq 'Notification_Requestor_Admin_Assignment')
            {
                if ($PSBoundParameters.ContainsKey('ActiveAssigneeNotificationOnlyCritical') `
                        -or $PSBoundParameters.ContainsKey('ActiveAssigneeNotificationDefaultRecipient') `
                        -or $PSBoundParameters.ContainsKey('ActiveAssigneeNotificationAdditionalRecipient'))
                {
                    Write-Verbose -Message 'Handle Send notifications when members are assigned as active to this role: Notification to the assigned user (assignee)'
                    $onlyCritical = if ($PSBoundParameters.ContainsKey('ActiveAssigneeNotificationOnlyCritical')) { $ActiveAssigneeNotificationOnlyCritical } else { $currentRule.notificationLevel -eq 'Critical' }
                    $defaultRecipient = if ($PSBoundParameters.ContainsKey('ActiveAssigneeNotificationDefaultRecipient')) { $ActiveAssigneeNotificationDefaultRecipient } else { $currentRule.isDefaultRecipientsEnabled }
                    $additionalRecipient = if ($PSBoundParameters.ContainsKey('ActiveAssigneeNotificationAdditionalRecipient')) { @($ActiveAssigneeNotificationAdditionalRecipient) } else { @($currentRule.notificationRecipients) }
                    $notificationLevel = if ($onlyCritical)
                    {
                        'Critical'
                    }
                    else
                    {
                        'All'
                    }
                    $params = @{
                        ruleType                 = $currentRule.ruleType
                        id                       = $currentRule.id
                        notificationType         = 'Email'
                        recipientType            = 'Requestor'
                        notificationLevel        = $notificationLevel
                        isDefaultRecipientsEnabled = $defaultRecipient
                        notificationRecipients   = [System.Collections.ArrayList]@($additionalRecipient)
                        target                   = $currentRule.target
                    }
                }
            }
            elseif ($currentRule.id -eq 'Notification_Approver_Admin_Assignment')
            {
                if ($PSBoundParameters.ContainsKey('ActiveApproveNotificationOnlyCritical') `
                        -or $PSBoundParameters.ContainsKey('ActiveApproveNotificationDefaultRecipient') `
                        -or $PSBoundParameters.ContainsKey('ActiveApproveNotificationAdditionalRecipient'))
                {
                    Write-Verbose -Message 'Handle Send notifications when members are assigned as active to this role: Request to approve a role assignment renewal/extension'
                    $onlyCritical = if ($PSBoundParameters.ContainsKey('ActiveApproveNotificationOnlyCritical')) { $ActiveApproveNotificationOnlyCritical } else { $currentRule.notificationLevel -eq 'Critical' }
                    $defaultRecipient = if ($PSBoundParameters.ContainsKey('ActiveApproveNotificationDefaultRecipient')) { $ActiveApproveNotificationDefaultRecipient } else { $currentRule.isDefaultRecipientsEnabled }
                    $additionalRecipient = if ($PSBoundParameters.ContainsKey('ActiveApproveNotificationAdditionalRecipient')) { @($ActiveApproveNotificationAdditionalRecipient) } else { @($currentRule.notificationRecipients) }
                    $notificationLevel = if ($onlyCritical)
                    {
                        'Critical'
                    }
                    else
                    {
                        'All'
                    }
                    $params = @{
                        ruleType                 = $currentRule.ruleType
                        id                       = $currentRule.id
                        notificationType         = 'Email'
                        recipientType            = 'Approver'
                        notificationLevel        = $notificationLevel
                        isDefaultRecipientsEnabled = $defaultRecipient
                        notificationRecipients   = [System.Collections.ArrayList]@($additionalRecipient)
                        target                   = $currentRule.target
                    }
                }
            }
            elseif ($currentRule.id -eq 'Notification_Admin_EndUser_Assignment')
            {
                if ($PSBoundParameters.ContainsKey('ActivationAlertNotificationOnlyCritical') `
                        -or $PSBoundParameters.ContainsKey('ActivationAlertNotificationDefaultRecipient') `
                        -or $PSBoundParameters.ContainsKey('ActivationAlertNotificationAdditionalRecipient'))
                {
                    Write-Verbose -Message 'Handle Send notifications when eligible members activate this role: Role activation alert'
                    $onlyCritical = if ($PSBoundParameters.ContainsKey('ActivationAlertNotificationOnlyCritical')) { $ActivationAlertNotificationOnlyCritical } else { $currentRule.notificationLevel -eq 'Critical' }
                    $defaultRecipient = if ($PSBoundParameters.ContainsKey('ActivationAlertNotificationDefaultRecipient')) { $ActivationAlertNotificationDefaultRecipient } else { $currentRule.isDefaultRecipientsEnabled }
                    $additionalRecipient = if ($PSBoundParameters.ContainsKey('ActivationAlertNotificationAdditionalRecipient')) { @($ActivationAlertNotificationAdditionalRecipient) } else { @($currentRule.notificationRecipients) }
                    $notificationLevel = if ($onlyCritical)
                    {
                        'Critical'
                    }
                    else
                    {
                        'All'
                    }
                    $params = @{
                        ruleType                 = $currentRule.ruleType
                        id                       = $currentRule.id
                        notificationType         = 'Email'
                        recipientType            = 'Admin'
                        notificationLevel        = $notificationLevel
                        isDefaultRecipientsEnabled = $defaultRecipient
                        notificationRecipients   = [System.Collections.ArrayList]@($additionalRecipient)
                        target                   = $currentRule.target
                    }
                }
            }
            elseif ($currentRule.id -eq 'Notification_Requestor_EndUser_Assignment')
            {
                if ($PSBoundParameters.ContainsKey('ActivationAssigneeNotificationOnlyCritical') `
                        -or $PSBoundParameters.ContainsKey('ActivationAssigneeNotificationDefaultRecipient') `
                        -or $PSBoundParameters.ContainsKey('ActivationAssigneeNotificationAdditionalRecipient'))
                {
                    Write-Verbose -Message 'Handle Send notifications when eligible members activate this role: Notification to activated user (requestor)'
                    $onlyCritical = if ($PSBoundParameters.ContainsKey('ActivationAssigneeNotificationOnlyCritical')) { $ActivationAssigneeNotificationOnlyCritical } else { $currentRule.notificationLevel -eq 'Critical' }
                    $defaultRecipient = if ($PSBoundParameters.ContainsKey('ActivationAssigneeNotificationDefaultRecipient')) { $ActivationAssigneeNotificationDefaultRecipient } else { $currentRule.isDefaultRecipientsEnabled }
                    $additionalRecipient = if ($PSBoundParameters.ContainsKey('ActivationAssigneeNotificationAdditionalRecipient')) { @($ActivationAssigneeNotificationAdditionalRecipient) } else { @($currentRule.notificationRecipients) }
                    $notificationLevel = if ($onlyCritical)
                    {
                        'Critical'
                    }
                    else
                    {
                        'All'
                    }
                    $params = @{
                        ruleType                 = $currentRule.ruleType
                        id                       = $currentRule.id
                        notificationType         = 'Email'
                        recipientType            = 'Requestor'
                        notificationLevel        = $notificationLevel
                        isDefaultRecipientsEnabled = $defaultRecipient
                        notificationRecipients   = [System.Collections.ArrayList]@($additionalRecipient)
                        target                   = $currentRule.target
                    }
                }
            }
            elseif ($currentRule.id -eq 'Notification_Approver_EndUser_Assignment')
            {
                if ($PSBoundParameters.ContainsKey('ActivationApproveNotificationOnlyCritical') `
                        -or $PSBoundParameters.ContainsKey('ActivationApproveNotificationDefaultRecipient') `
                        -or $PSBoundParameters.ContainsKey('ActivationApproveNotificationAdditionalRecipient'))
                {
                    Write-Verbose -Message 'Handle Send notifications when eligible members activate this role: Notification to approvers'
                    $onlyCritical = if ($PSBoundParameters.ContainsKey('ActivationApproveNotificationOnlyCritical')) { $ActivationApproveNotificationOnlyCritical } else { $currentRule.notificationLevel -eq 'Critical' }
                    $defaultRecipient = if ($PSBoundParameters.ContainsKey('ActivationApproveNotificationDefaultRecipient')) { $ActivationApproveNotificationDefaultRecipient } else { $currentRule.isDefaultRecipientsEnabled }
                    $additionalRecipient = if ($PSBoundParameters.ContainsKey('ActivationApproveNotificationAdditionalRecipient')) { @($ActivationApproveNotificationAdditionalRecipient) } else { @($currentRule.notificationRecipients) }
                    $notificationLevel = if ($onlyCritical)
                    {
                        'Critical'
                    }
                    else
                    {
                        'All'
                    }
                    $params = @{
                        ruleType                 = $currentRule.ruleType
                        id                       = $currentRule.id
                        notificationType         = 'Email'
                        recipientType            = 'Approver'
                        notificationLevel        = $notificationLevel
                        isDefaultRecipientsEnabled = $defaultRecipient
                        notificationRecipients   = [System.Collections.ArrayList]@($additionalRecipient)
                        target                   = $currentRule.target
                    }
                }
            }
            elseif ($currentRule.id -eq 'Expiration_EndUser_Assignment')
            {
                if ($PSBoundParameters.ContainsKey('ActivationMaxDuration'))
                {
                    Write-Verbose -Message 'Handle Activation: Activation maximum duration (hours)'
                    $params = @{
                        ruleType        = $currentRule.ruleType
                        id              = $currentRule.id
                        maximumDuration = $ActivationMaxDuration
                        target          = $currentRule.target
                    }
                }
            }
            elseif ($currentRule.id -eq 'Enablement_EndUser_Assignment')
            {
                if ($PSBoundParameters.ContainsKey('ActivationReqJustification') `
                        -or $PSBoundParameters.ContainsKey('ActivationReqTicket') `
                        -or $PSBoundParameters.ContainsKey('ActivationReqMFA'))
                {
                    Write-Verbose -Message 'Handle Activation: Require justification / ticket / MFA on activation'
                    $reqJustification = if ($PSBoundParameters.ContainsKey('ActivationReqJustification')) { $ActivationReqJustification } else { ($currentRule.enabledRules) -contains 'Justification' }
                    $reqTicket = if ($PSBoundParameters.ContainsKey('ActivationReqTicket')) { $ActivationReqTicket } else { ($currentRule.enabledRules) -contains 'Ticketing' }
                    $reqMFA = if ($PSBoundParameters.ContainsKey('ActivationReqMFA')) { $ActivationReqMFA } else { ($currentRule.enabledRules) -contains 'MultiFactorAuthentication' }
                    [String[]]$enabledrules = @()
                    if ($reqJustification)
                    {
                        $enabledrules += 'Justification'
                    }
                    if ($reqTicket)
                    {
                        $enabledrules += 'Ticketing'
                    }
                    if ($reqMFA)
                    {
                        $enabledrules += 'MultiFactorAuthentication'
                    }
                    $params = @{
                        ruleType     = $currentRule.ruleType
                        id           = $currentRule.id
                        enabledRules = [System.Collections.ArrayList]@($enabledrules)
                        target       = $currentRule.target
                    }
                }
            }
            elseif ($currentRule.id -eq 'Approval_EndUser_Assignment')
            {
                if ($PSBoundParameters.ContainsKey('ApprovaltoActivate') `
                        -and $PSBoundParameters.ContainsKey('ActivateApprover'))
                {
                    Write-Verbose -Message 'Handle Activation: Require approval to activate / Approvers'
                    $primaryApprovers = @()
                    if ($ActivateApprover.Count -gt 0)
                    {
                        foreach ($item in $ActivateApprover)
                        {
                            $Filter = "UserPrincipalName eq '$($item -replace "'", "''")'"
                            $user = Get-MgUser -Filter $Filter -ErrorAction SilentlyContinue
                            if ($null -ne $user)
                            {
                                $primaryApprovers += @{
                                    id       = $user.Id
                                    userType = 'User'
                                    isBackup = $false
                                }
                            }
                            else
                            {
                                Write-Verbose -Message "User '$item' not found, trying with group"
                                $Filter = "displayName eq '$($item -replace "'", "''")'"
                                $group = Get-MgGroup -Filter $Filter -ErrorAction SilentlyContinue
                                if ($null -ne $group)
                                {
                                    $primaryApprovers += @{
                                        id       = $group.Id
                                        userType = 'Group'
                                        isBackup = $false
                                    }
                                }
                                else
                                {
                                    throw "Approver '$item' not found as user or group. Cannot add as approver."
                                }
                            }
                        }
                    }

                    $approvalStages = @{
                        approvalStageTimeOutInDays     = 1
                        isApproverJustificationRequired = $true
                        escalationTimeInMinutes        = 0
                        isEscalationEnabled            = $false
                        primaryApprovers               = [System.Collections.ArrayList]@($primaryApprovers)
                        escalationApprovers            = [System.Collections.ArrayList]@()
                    }

                    $setting = @{
                        isApprovalRequired              = $ApprovaltoActivate
                        isApprovalRequiredForExtension  = $false
                        isRequestorJustificationRequired = $true
                        approvalMode                    = 'SingleStage'
                        approvalStages                  = [System.Collections.ArrayList]@($approvalStages)
                    }

                    $params = @{
                        ruleType = $currentRule.ruleType
                        id       = $currentRule.id
                        setting  = $setting
                        target   = $currentRule.target
                    }
                }
            }
            elseif ($currentRule.id -eq 'Expiration_Admin_Eligibility')
            {
                if ($PSBoundParameters.ContainsKey('PermanentEligibleAssignmentisExpirationRequired') `
                        -and $PSBoundParameters.ContainsKey('ExpireEligibleAssignment'))
                {
                    Write-Verbose -Message 'Handle Assignment: Allow permanent eligible assignment / Expire eligible assignments after'
                    $params = @{
                        ruleType             = $currentRule.ruleType
                        id                   = $currentRule.id
                        isExpirationRequired = $PermanentEligibleAssignmentisExpirationRequired
                        maximumDuration      = $ExpireEligibleAssignment
                        target               = $currentRule.target
                    }
                }
            }
            elseif ($currentRule.id -eq 'Expiration_Admin_Assignment')
            {
                if ($PSBoundParameters.ContainsKey('PermanentActiveAssignmentisExpirationRequired') `
                        -and $PSBoundParameters.ContainsKey('ExpireActiveAssignment'))
                {
                    Write-Verbose -Message 'Handle Assignment: Allow permanent active assignment / Expire active assignments after'
                    $params = @{
                        ruleType             = $currentRule.ruleType
                        id                   = $currentRule.id
                        isExpirationRequired = $PermanentActiveAssignmentisExpirationRequired
                        maximumDuration      = $ExpireActiveAssignment
                        target               = $currentRule.target
                    }
                }
            }
            elseif ($currentRule.id -eq 'Enablement_Admin_Assignment')
            {
                if ($PSBoundParameters.ContainsKey('AssignmentReqJustification') `
                        -or $PSBoundParameters.ContainsKey('AssignmentReqMFA'))
                {
                    Write-Verbose -Message 'Handle Assignment: Require MFA / justification on active assignment'
                    $reqJustification = if ($PSBoundParameters.ContainsKey('AssignmentReqJustification')) { $AssignmentReqJustification } else { ($currentRule.enabledRules) -contains 'Justification' }
                    $reqMFA = if ($PSBoundParameters.ContainsKey('AssignmentReqMFA')) { $AssignmentReqMFA } else { ($currentRule.enabledRules) -contains 'MultiFactorAuthentication' }
                    [String[]]$enabledrules = @()
                    if ($reqJustification)
                    {
                        $enabledrules += 'Justification'
                    }
                    if ($reqMFA)
                    {
                        $enabledrules += 'MultiFactorAuthentication'
                    }
                    $params = @{
                        ruleType     = $currentRule.ruleType
                        id           = $currentRule.id
                        enabledRules = [System.Collections.ArrayList]@($enabledrules)
                        target       = $currentRule.target
                    }
                }
            }
            elseif ($currentRule.id -eq 'Enablement_Admin_Eligibility')
            {
                if ($PSBoundParameters.ContainsKey('EligibilityAssignmentReqJustification') `
                        -or $PSBoundParameters.ContainsKey('EligibilityAssignmentReqMFA'))
                {
                    Write-Verbose -Message 'Handle Assignment: Require MFA / justification on eligible assignment'
                    $reqJustification = if ($PSBoundParameters.ContainsKey('EligibilityAssignmentReqJustification')) { $EligibilityAssignmentReqJustification } else { ($currentRule.enabledRules) -contains 'Justification' }
                    $reqMFA = if ($PSBoundParameters.ContainsKey('EligibilityAssignmentReqMFA')) { $EligibilityAssignmentReqMFA } else { ($currentRule.enabledRules) -contains 'MultiFactorAuthentication' }
                    [String[]]$enabledrules = @()
                    if ($reqJustification)
                    {
                        $enabledrules += 'Justification'
                    }
                    if ($reqMFA)
                    {
                        $enabledrules += 'MultiFactorAuthentication'
                    }
                    $params = @{
                        ruleType     = $currentRule.ruleType
                        id           = $currentRule.id
                        enabledRules = [System.Collections.ArrayList]@($enabledrules)
                        target       = $currentRule.target
                    }
                }
            }
            elseif ($currentRule.id -eq 'AuthenticationContext_EndUser_Assignment')
            {
                if ($PSBoundParameters.ContainsKey('ActivationReqAuthContext'))
                {
                    Write-Verbose -Message 'Handle Activation: Require authentication context'
                    $claimValue = $currentRule.claimValue
                    if ($PSBoundParameters.ContainsKey('ActivationAuthContextId'))
                    {
                        $claimValue = $ActivationAuthContextId
                    }
                    $params = @{
                        ruleType   = $currentRule.ruleType
                        id         = $currentRule.id
                        isEnabled  = $ActivationReqAuthContext
                        claimValue = $claimValue
                        target     = $currentRule.target
                    }
                }
            }

            if ($params.Count -gt 0)
            {
                # Replace the rule in the array with the updated version
                for ($i = 0; $i -lt $policy.properties.rules.Count; $i++)
                {
                    if ($policy.properties.rules[$i].id -eq $currentRule.id)
                    {
                        $policy.properties.rules[$i] = $params
                        $ruleModified = $true
                        break
                    }
                }
            }
        }

        if ($ruleModified)
        {
            $updateBody = @{
                properties = @{
                    rules = [System.Collections.ArrayList]@($policy.properties.rules)
                }
            }

            $payload = ConvertTo-Json $updateBody -Depth 20 -Compress
            Write-Verbose -Message "Updating policy {$policyIdValue} at scope {$ScopeId}"
            $null = Invoke-AzRestMethod -Uri $policyUri -Method PATCH -Payload $payload
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
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
        $RoleDefinitionDisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ScopeId,

        [Parameter()]
        [System.String]
        $PolicyId,

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
        $ActivationReqAuthContext,

        [Parameter()]
        [System.String]
        $ActivationAuthContextId,

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
        $ActivationAlertNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActivationAlertNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActivationAlertNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $ActivationAssigneeNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActivationAssigneeNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActivationAssigneeNotificationOnlyCritical,

        [Parameter()]
        [System.Boolean]
        $ActivationApproveNotificationDefaultRecipient,

        [Parameter()]
        [System.String[]]
        $ActivationApproveNotificationAdditionalRecipient,

        [Parameter()]
        [System.Boolean]
        $ActivationApproveNotificationOnlyCritical,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'Azure' `
        -InboundParameters $PSBoundParameters

    $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
        $apiVersion = '2020-10-01'

        if ($Filter -eq 'ModifiedOnly')
        {
            Write-Verbose -Message 'ModifiedOnly filter specified: only policies with lastModifiedDateTime set (customised from defaults) will be exported.'
        }
        else
        {
            Write-Verbose -Message 'No ModifiedOnly filter: all policies including unchanged defaults will be exported.'
        }

        # Collect all scopes to enumerate
        $scopes = @()

        # Add subscriptions
        $subUri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)subscriptions?api-version=2022-12-01"
        $subResponse = Invoke-AzRestMethod -Uri $subUri -Method GET
        $subscriptions = (ConvertFrom-Json $subResponse.Content).value

        foreach ($sub in $subscriptions)
        {
            $scopes += @{
                ScopeId     = "subscriptions/$($sub.subscriptionId)"
                DisplayName = $sub.displayName
                ScopeType   = 'Subscription'
            }

            # Add resource groups under each subscription
            $rgUri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)subscriptions/$($sub.subscriptionId)/resourcegroups?api-version=2021-04-01"
            $rgResponse = Invoke-AzRestMethod -Uri $rgUri -Method GET
            $resourceGroups = (ConvertFrom-Json $rgResponse.Content).value

            foreach ($rg in $resourceGroups)
            {
                $scopes += @{
                    ScopeId     = "subscriptions/$($sub.subscriptionId)/resourceGroups/$($rg.name)"
                    DisplayName = $rg.name
                    ScopeType   = 'ResourceGroup'
                }
            }
        }

        # Add management groups
        $mgUri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)providers/Microsoft.Management/managementGroups?api-version=2021-04-01"
        $mgResponse = Invoke-AzRestMethod -Uri $mgUri -Method GET
        $managementGroups = (ConvertFrom-Json $mgResponse.Content).value

        foreach ($mg in $managementGroups)
        {
            $scopes += @{
                ScopeId     = "providers/Microsoft.Management/managementGroups/$($mg.name)"
                DisplayName = $mg.properties.displayName
                ScopeType   = 'ManagementGroup'
            }
        }

        [System.Collections.Generic.List[hashtable]] $exportedInstances = [System.Collections.Generic.List[hashtable]]::new()
        $dscContent = [System.Text.StringBuilder]::new()
        Write-M365DSCHost -Message "`r`n" -DeferWrite
        $j = 1

        foreach ($scopeInfo in $scopes)
        {
            $currentScope = $scopeInfo.ScopeId
            Write-M365DSCHost -Message "    |---[$j/$($scopes.Count)] $($scopeInfo.ScopeType): $($scopeInfo.DisplayName)`r`n" -DeferWrite

            # Get role management policy assignments for this scope
            $assignUri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)$currentScope/providers/Microsoft.Authorization/roleManagementPolicyAssignments?api-version=$apiVersion"
            $assignResponse = Invoke-AzRestMethod -Uri $assignUri -Method GET
            $assignments = (ConvertFrom-Json $assignResponse.Content).value

            if ($null -eq $assignments -or $assignments.Count -eq 0)
            {
                $j++
                continue
            }

            # Bulk-fetch all role management policies for this scope in a single API call
            $bulkPolicyUri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)$currentScope/providers/Microsoft.Authorization/roleManagementPolicies?api-version=$apiVersion"
            $bulkPolicyResponse = Invoke-AzRestMethod -Uri $bulkPolicyUri -Method GET
            $allPolicies = $null
            if ($null -ne $bulkPolicyResponse -and -not [System.String]::IsNullOrEmpty($bulkPolicyResponse.Content))
            {
                $allPolicies = (ConvertFrom-Json $bulkPolicyResponse.Content).value
            }

            if ($null -eq $allPolicies)
            {
                Write-Verbose -Message "Could not retrieve role management policies at scope {$currentScope}. Skipping."
                $j++
                continue
            }

            # Build a lookup hashtable keyed by policy name for fast matching
            $policyLookup = @{}
            foreach ($pol in $allPolicies)
            {
                $policyName = $pol.name
                $policyLookup[$policyName] = $pol
            }

            # Phase 1: Collect valid (filtered) instances for this scope
            $scopeInstances = [System.Collections.Generic.List[hashtable]]::new()
            foreach ($assignment in $assignments)
            {
                $roleDisplayName = $null
                if ($null -ne $assignment.properties.policyAssignmentProperties -and
                    $null -ne $assignment.properties.policyAssignmentProperties.roleDefinition)
                {
                    $roleDisplayName = $assignment.properties.policyAssignmentProperties.roleDefinition.displayName
                }

                if ([System.String]::IsNullOrEmpty($roleDisplayName))
                {
                    $roleDefId = $assignment.properties.roleDefinitionId
                    if (-not [System.String]::IsNullOrEmpty($roleDefId))
                    {
                        $roleDefUri = "$((Get-MSCloudLoginConnectionProfile -Workload Azure).ManagementUrl)$roleDefId`?api-version=$apiVersion"
                        $roleDefResponse = Invoke-AzRestMethod -Uri $roleDefUri -Method GET
                        $roleDef = ConvertFrom-Json $roleDefResponse.Content
                        $roleDisplayName = $roleDef.properties.roleName
                    }
                }

                if ([System.String]::IsNullOrEmpty($roleDisplayName))
                {
                    continue
                }

                $assignmentPolicyId = $assignment.properties.policyId.Split('/')[-1]

                # Look up policy from bulk-fetched results instead of individual API call
                $policyContent = $policyLookup[$assignmentPolicyId]

                if ($null -eq $policyContent -or $null -eq $policyContent.properties -or $null -eq $policyContent.properties.rules)
                {
                    Write-Verbose -Message "Policy {$assignmentPolicyId} not found in bulk response for scope {$currentScope}. Skipping."
                    continue
                }

                # When the 'ModifiedOnly' sentinel filter is specified, skip policies that have
                # not been customised from Azure defaults (lastModifiedDateTime is null).
                # Without this filter, all policies (including default/unchanged) are exported.
                $lastModifiedDateTime = $policyContent.properties.lastModifiedDateTime
                if ($Filter -eq 'ModifiedOnly' -and $null -eq $lastModifiedDateTime)
                {
                    Write-Verbose -Message "ModifiedOnly filter active: Policy {$assignmentPolicyId} has not been modified from Azure defaults. Skipping."
                    continue
                }

                $scopeInstances.Add(@{
                    RoleDisplayName = $roleDisplayName
                    PolicyId        = $assignmentPolicyId
                    Rules           = $policyContent.properties.rules
                })
            }

            # Add scope instances to the global exported instances collection
            foreach ($inst in $scopeInstances)
            {
                $exportedInstances.Add($inst)
            }

            # Phase 2: Export collected instances
            $i = 1
            foreach ($instance in $scopeInstances)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                Write-M365DSCHost -Message "        |---[$i/$($scopeInstances.Count)] $($instance.RoleDisplayName)" -DeferWrite

                $Params = @{
                    RoleDefinitionDisplayName = $instance.RoleDisplayName
                    ScopeId                   = $currentScope
                    ApplicationId             = $ApplicationId
                    TenantId                  = $TenantId
                    CertificateThumbprint     = $CertificateThumbprint
                    ApplicationSecret         = $ApplicationSecret
                    Credential                = $Credential
                    ManagedIdentity           = $ManagedIdentity.IsPresent
                    AccessTokens              = $AccessTokens
                }

                $Script:exportedInstance = @{
                    rules    = $instance.Rules
                    policyId = $instance.PolicyId
                }
                $Results = Get-TargetResource @Params

                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential

                [void]$dscContent.Append($currentDSCBlock)
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
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
