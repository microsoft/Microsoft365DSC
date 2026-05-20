Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADRoleSetting'

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

    Write-Verbose -Message "Getting configuration of the AAD Role Setting with Id {$Id} and DisplayName {$DisplayName}"

    if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
    {
        $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters

        Write-Verbose -Message 'Getting configuration of Role'

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

        if ($null -eq $Script:RoleDefinitions)
        {
            $Script:RoleDefinitions = [System.Collections.Generic.Dictionary[string, hashtable]]::new()
            $allRoleDefinitions = Get-MgBetaRoleManagementDirectoryRoleDefinition -All -Property 'id,displayName'
            foreach ($roleDefinition in $allRoleDefinitions)
            {
                $Script:RoleDefinitions[$roleDefinition.Id] = @{
                    Id          = $roleDefinition.Id
                    DisplayName = $roleDefinition.DisplayName
                }
            }
        }

        $RoleDefinition = $null
        if (-not [System.String]::IsNullOrEmpty($Id))
        {
            $RoleDefinition = $Script:RoleDefinitions[$Id]
        }

        if ($null -eq $RoleDefinition -and -not [System.String]::IsNullOrEmpty($DisplayName))
        {
            $RoleDefinition = ($Script:RoleDefinitions.GetEnumerator() | Where-Object { $_.Value.DisplayName -eq ($RoleDefinition.DisplayName -replace "'", "''") }).Value
        }
    }
    else
    {
        $RoleDefinition = $Script:exportedInstance
    }

    $nullReturn = $PSBoundParameters
    if ($null -eq $RoleDefinition)
    {
        return $nullReturn
    }

    try
    {
        if ($null -eq $Script:PolicyAssignments)
        {
            $Script:PolicyAssignments = [System.Collections.Generic.Dictionary[string, string]]::new()
            $allFilter = "scopeId eq '/' and scopeType eq 'DirectoryRole'"
            $assignments = Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter $allFilter -All -Property 'roleDefinitionId,policyId'
            foreach ($assignment in $assignments)
            {
                $Script:PolicyAssignments[$assignment.RoleDefinitionId] = $assignment.PolicyId
            }
        }

        $policyId = $Script:PolicyAssignments[$RoleDefinition.Id]
    }
    catch
    {
        if ($_ -match 'The tenant needs an AAD Premium 2 license')
        {
            Write-Warning -Message 'WARNING: AAD Premium License is required to get the role'
            return $nullReturn
        }
    }

    if ($null -eq $policyId)
    {
        return $nullReturn
    }

    if ($null -eq $Script:Policies)
    {
        $Script:Policies = [System.Collections.Generic.Dictionary[string, object]]::new()
        $allPolicies = Get-MgBetaPolicyRoleManagementPolicy -Filter "scopeId eq '/' and scopeType eq 'DirectoryRole'" -ExpandProperty 'rules' -Property 'Id,rules'
        foreach ($policy in $allPolicies)
        {
            $Script:Policies[$policy.Id] = $policy
        }
    }

    # Get Policy Rule
    $rule = $Script:Policies[$policyId].Rules

    $DisplayName = $RoleDefinition.DisplayName
    $ActivationMaxDuration = ($rule | Where-Object { $_.Id -eq 'Expiration_EndUser_Assignment' }).AdditionalProperties.maximumDuration
    $ActivationReqJustification = (($rule | Where-Object { $_.Id -eq 'Enablement_EndUser_Assignment' }).AdditionalProperties.enabledRules) -contains 'Justification'
    $ActivationReqTicket = (($rule | Where-Object { $_.Id -eq 'Enablement_EndUser_Assignment' }).AdditionalProperties.enabledRules) -contains 'Ticketing'
    $ActivationReqMFA = (($rule | Where-Object { $_.Id -eq 'Enablement_EndUser_Assignment' }).AdditionalProperties.enabledRules) -contains 'MultiFactorAuthentication'
    $AuthenticationContext = ($rule | Where-Object { $_.Id -eq 'AuthenticationContext_EndUser_Assignment' }).AdditionalProperties
    $AuthenticationContextRequired = $AuthenticationContext.isEnabled
    if ($AuthenticationContextRequired)
    {
        $AuthenticationContextId = $AuthenticationContext.claimValue
        $AuthenticationContextName = (Get-MgBetaIdentityConditionalAccessAuthenticationContextClassReference -AuthenticationContextClassReferenceId $AuthenticationContextId).DisplayName
    }
    $ApprovaltoActivate = (($rule | Where-Object { $_.Id -eq 'Approval_EndUser_Assignment' }).AdditionalProperties.setting.isApprovalRequired)
    [array]$ActivateApprovers = (($rule | Where-Object { $_.Id -eq 'Approval_EndUser_Assignment' }).AdditionalProperties.setting.approvalStages.primaryApprovers)
    [string[]]$ActivateApprover = @()
    foreach ($Item in $ActivateApprovers.id)
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
    $PermanentEligibleAssignmentisExpirationRequired = ($rule | Where-Object { $_.Id -eq 'Expiration_Admin_Eligibility' }).AdditionalProperties.isExpirationRequired
    $ExpireEligibleAssignment = ($rule | Where-Object { $_.Id -eq 'Expiration_Admin_Eligibility' }).AdditionalProperties.maximumDuration
    $PermanentActiveAssignmentisExpirationRequired = ($rule | Where-Object { $_.Id -eq 'Expiration_Admin_Assignment' }).AdditionalProperties.isExpirationRequired
    $ExpireActiveAssignment = ($rule | Where-Object { $_.Id -eq 'Expiration_Admin_Assignment' }).AdditionalProperties.maximumDuration
    $AssignmentReqMFA = (($rule | Where-Object { $_.Id -eq 'Enablement_Admin_Assignment' }).AdditionalProperties.enabledRules) -contains 'MultiFactorAuthentication'
    $AssignmentReqJustification = (($rule | Where-Object { $_.Id -eq 'Enablement_Admin_Assignment' }).AdditionalProperties.enabledRules) -contains 'Justification'
    $EligibilityAssignmentReqMFA = (($rule | Where-Object { $_.Id -eq 'Enablement_Admin_Eligibility' }).AdditionalProperties.enabledRules) -contains 'MultiFactorAuthentication'
    $EligibilityAssignmentReqJustification = (($rule | Where-Object { $_.Id -eq 'Enablement_Admin_Eligibility' }).AdditionalProperties.enabledRules) -contains 'Justification'
    $EligibleAlertNotificationDefaultRecipient = ($rule | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Eligibility' }).AdditionalProperties.isDefaultRecipientsEnabled
    [string[]]$EligibleAlertNotificationAdditionalRecipient = ($rule | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Eligibility' }).AdditionalProperties.notificationRecipients
    $EligibleAlertNotificationOnlyCritical = (($rule | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Eligibility' }).AdditionalProperties.notificationLevel) -contains ('Critical')
    $EligibleAssigneeNotificationDefaultRecipient = ($rule | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Eligibility' }).AdditionalProperties.isDefaultRecipientsEnabled
    [string[]]$EligibleAssigneeNotificationAdditionalRecipient = ($rule | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Eligibility' }).AdditionalProperties.notificationRecipients
    $EligibleAssigneeNotificationOnlyCritical = (($rule | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Eligibility' }).AdditionalProperties.notificationLevel) -contains ('Critical')
    $EligibleApproveNotificationDefaultRecipient = ($rule | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Eligibility' }).AdditionalProperties.isDefaultRecipientsEnabled
    [string[]]$EligibleApproveNotificationAdditionalRecipient = ($rule | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Eligibility' }).AdditionalProperties.notificationRecipients
    $EligibleApproveNotificationOnlyCritical = (($rule | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Eligibility' }).AdditionalProperties.notificationLevel) -contains ('Critical')
    $ActiveAlertNotificationDefaultRecipient = ($rule | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Assignment' }).AdditionalProperties.isDefaultRecipientsEnabled
    [string[]]$ActiveAlertNotificationAdditionalRecipient = ($rule | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Assignment' }).AdditionalProperties.notificationRecipients
    $ActiveAlertNotificationOnlyCritical = (($rule | Where-Object { $_.Id -eq 'Notification_Admin_Admin_Assignment' }).AdditionalProperties.notificationLevel) -contains ('Critical')
    $ActiveAssigneeNotificationDefaultRecipient = ($rule | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Assignment' }).AdditionalProperties.isDefaultRecipientsEnabled
    [string[]]$ActiveAssigneeNotificationAdditionalRecipient = ($rule | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Assignment' }).AdditionalProperties.notificationRecipients
    $ActiveAssigneeNotificationOnlyCritical = (($rule | Where-Object { $_.Id -eq 'Notification_Requestor_Admin_Assignment' }).AdditionalProperties.notificationLevel) -contains ('Critical')
    $ActiveApproveNotificationDefaultRecipient = ($rule | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Assignment' }).AdditionalProperties.isDefaultRecipientsEnabled
    [string[]]$ActiveApproveNotificationAdditionalRecipient = ($rule | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Assignment' }).AdditionalProperties.notificationRecipients
    $ActiveApproveNotificationOnlyCritical = (($rule | Where-Object { $_.Id -eq 'Notification_Approver_Admin_Assignment' }).AdditionalProperties.notificationLevel) -contains ('Critical')
    $EligibleAssignmentAlertNotificationDefaultRecipient = ($rule | Where-Object { $_.Id -eq 'Notification_Admin_EndUser_Assignment' }).AdditionalProperties.isDefaultRecipientsEnabled
    [string[]]$EligibleAssignmentAlertNotificationAdditionalRecipient = ($rule | Where-Object { $_.Id -eq 'Notification_Admin_EndUser_Assignment' }).AdditionalProperties.notificationRecipients
    $EligibleAssignmentAlertNotificationOnlyCritical = (($rule | Where-Object { $_.Id -eq 'Notification_Admin_EndUser_Assignment' }).AdditionalProperties.notificationLevel) -contains ('Critical')
    $EligibleAssignmentAssigneeNotificationDefaultRecipient = ($rule | Where-Object { $_.Id -eq 'Notification_Requestor_EndUser_Assignment' }).AdditionalProperties.isDefaultRecipientsEnabled
    [string[]]$EligibleAssignmentAssigneeNotificationAdditionalRecipient = ($rule | Where-Object { $_.Id -eq 'Notification_Requestor_EndUser_Assignment' }).AdditionalProperties.notificationRecipients
    $EligibleAssignmentAssigneeNotificationOnlyCritical = (($rule | Where-Object { $_.Id -eq 'Notification_Requestor_EndUser_Assignment' }).AdditionalProperties.notificationLevel) -contains ('Critical')

    try
    {
        Write-Verbose -Message "Found configuration of Rule $($DisplayName)"
        $result = @{
            Id                                                        = $Id
            DisplayName                                               = $DisplayName
            ActivationMaxDuration                                     = $ActivationMaxDuration
            ActivationReqJustification                                = $ActivationReqJustification
            ActivationReqTicket                                       = $ActivationReqTicket
            ActivationReqMFA                                          = $ActivationReqMFA
            ApprovaltoActivate                                        = $ApprovaltoActivate
            ActivateApprover                                          = [System.String[]]$ActivateApprover
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
            EligibleAssignmentAlertNotificationDefaultRecipient       = $EligibleAssignmentAlertNotificationDefaultRecipient
            EligibleAssignmentAlertNotificationAdditionalRecipient    = [System.String[]]$EligibleAssignmentAlertNotificationAdditionalRecipient
            EligibleAssignmentAlertNotificationOnlyCritical           = $EligibleAssignmentAlertNotificationOnlyCritical
            EligibleAssignmentAssigneeNotificationDefaultRecipient    = $EligibleAssignmentAssigneeNotificationDefaultRecipient
            EligibleAssignmentAssigneeNotificationAdditionalRecipient = [System.String[]]$EligibleAssignmentAssigneeNotificationAdditionalRecipient
            EligibleAssignmentAssigneeNotificationOnlyCritical        = $EligibleAssignmentAssigneeNotificationOnlyCritical
            AuthenticationContextRequired                             = $AuthenticationContextRequired
            AuthenticationContextId                                   = $AuthenticationContextId
            AuthenticationContextName                                 = $AuthenticationContextName
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

    Write-Verbose -Message "Setting configuration of Role settings: $DisplayName"

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

    #get role
    $RoleDefinition = Get-MgBetaRoleManagementDirectoryRoleDefinition -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'"

    $Policy = $null
    if (-not [System.String]::IsNullOrEmpty($Id))
    {
        $Filter = "scopeId eq '/' and scopeType eq 'DirectoryRole' and RoleDefinitionId eq '" + $Id + "'"
        $Policy = Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter $Filter
    }
    else
    {
        Write-Verbose -Message "Finding Policy Assignment by Role Definition Id {$($RoleDefinition.Id)}"
        $Filter = "scopeId eq '/' and scopeType eq 'DirectoryRole' and RoleDefinitionId eq '$($RoleDefinition.Id)'"
        $Policy = Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter $Filter
    }
    #get Policyrule
    $roles = Get-MgBetaPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $Policy.PolicyId `
        -ErrorAction SilentlyContinue

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
                    'isEnabled'   = $true
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

    try
    {
        Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter "scopeId eq '/' and scopeType eq 'DirectoryRole'" -ErrorAction Stop | Out-Null
    }
    catch
    {
        if ($_.ErrorDetails.Message -like '*The tenant needs to have Microsoft Entra*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) AAD Premium License is required to get the role."
            return ''
        }
    }
    try
    {
        [array] $exportedInstances = Get-MgBetaRoleManagementDirectoryRoleDefinition -Filter $Filter -Sort DisplayName -ErrorAction Stop
        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        Write-M365DSCHost -Message "`r`n" -DeferWrite
        foreach ($role in $exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($exportedInstances.Count)] $($role.DisplayName)" -DeferWrite
            $Params = @{
                Id                    = $role.Id
                DisplayName           = $role.DisplayName
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                ApplicationSecret     = $ApplicationSecret
                Credential            = $Credential
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $role
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
