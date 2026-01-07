Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADGroupEligibilityScheduleSettings'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupDisplayName,

        [Parameter()]
        [System.String]
        $RuleType,

        [Parameter(Mandatory = $true)]
        [ValidateSet('member', 'owner')]
        [System.String]
        $PIMGroupRole,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExpirationRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $NotificationRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnablementRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ApprovalRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AuthenticationContextRule,

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

    try
    {
        if ($null -eq $Script:exportedInstance)
        {

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

            $nullResult = $PSBoundParameters

            #get groupId
            if ($GroupDisplayName.Contains("'"))
            {
                $GroupDisplayName = $GroupDisplayName -replace "'", "''"
            }
            $filter = "DisplayName eq '$GroupDisplayName'"
            $Group = Get-MgGroup -Filter $filter -ErrorAction Stop
            if ($Group.Count -gt 1)
            {
                throw "Duplicate AzureAD Groups named $GroupDisplayName exist in tenant"
            }

            $getValue = $null

            $assignment = Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter "scopeId eq '$($group.Id)' and scopeType eq 'Group' and RoleDefinitionId eq '$PIMGroupRole'"
            if ($null -eq $assignment)
            {
                Write-Verbose -Message "Could not find an Azure AD PIM Group with DisplayName {$GroupDisplayName} and Id {$id}."
                return $nullResult
            }

            $policyId = $assignment.PolicyId

            $getValue = Get-MgBetaPolicyRoleManagementPolicyRule `
                -UnifiedRoleManagementPolicyId $policyId `
                -UnifiedRoleManagementPolicyRuleId $Id -ErrorAction SilentlyContinue

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Azure AD Group PIM Policy Rule with Id {$Id} and PolicyId {$policyId}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id

        Write-Verbose -Message "An Azure AD Role Management Policy Rule with Id {$Id} and PolicyId {$policyId} was found"
        $rule = Get-M365DSCRoleManagementPolicyRuleObject -Rule $getValue

        $results = @{
            Id                        = $Id
            GroupDisplayName          = $groupDisplayName
            RuleType                  = $rule.ruleType
            PIMGroupRole              = $PIMGroupRole
            ExpirationRule            = $rule.expirationRule
            NotificationRule          = $rule.notificationRule
            EnablementRule            = $rule.enablementRule
            ApprovalRule              = $rule.approvalRule
            AuthenticationContextRule = $rule.authenticationContextRule
            Credential                = $Credential
            ApplicationId             = $ApplicationId
            TenantId                  = $TenantId
            ApplicationSecret         = $ApplicationSecret
            CertificateThumbprint     = $CertificateThumbprint
            ManagedIdentity           = $ManagedIdentity.IsPresent
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
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupDisplayName,

        [Parameter()]
        [System.String]
        $RuleType,

        [Parameter(Mandatory = $true)]
        [ValidateSet('member', 'owner')]
        [System.String]
        $PIMGroupRole,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExpirationRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $NotificationRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnablementRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ApprovalRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AuthenticationContextRule,

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

    Write-Verbose -Message "Setting configuration of the AAD Group Eligibility Schedule Settings with Id {$Id} and GroupDisplayName {$GroupDisplayName}"

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

    Write-Verbose -Message "Updating the Azure AD PIM Group Management Policy Rule with Id {$($currentInstance.Id)}"
    $body = @{
        '@odata.type' = $ruleType
    }

    if ($ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyExpirationRule')
    {
        $expirationRuleHashmap = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $expirationRule
        # add all the properties to the body
        foreach ($key in $expirationRuleHashmap.Keys)
        {
            $body.Add($key, $expirationRuleHashmap.$key)
        }
    }

    if ($ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyNotificationRule')
    {
        $notificationRuleHashmap = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $notificationRule
        # add all the properties to the body
        foreach ($key in $notificationRuleHashmap.Keys)
        {
            $body.Add($key, $notificationRuleHashmap.$key)
        }
    }

    if ($ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyEnablementRule')
    {
        $enablementRuleHashmap = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $enablementRule
        # add all the properties to the body
        foreach ($key in $enablementRuleHashmap.Keys)
        {
            $body.Add($key, $enablementRuleHashmap.$key)
        }
    }

    if ($ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyApprovalRule')
    {
        $approvalRuleHashmap = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $approvalRule
        # add all the properties to the body
        foreach ($key in $approvalRuleHashmap.Keys)
        {
            $body.Add($key, $approvalRuleHashmap.$key)
        }
    }

    if ($ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyAuthenticationContextRule')
    {
        $authenticationContextRuleHashmap = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $authenticationContextRule
        # add all the properties to the body
        foreach ($key in $authenticationContextRuleHashmap.Keys)
        {
            $body.Add($key, $authenticationContextRuleHashmap.$key)
        }
    }

    if ($GroupDisplayName.Contains("'"))
        {
            $GroupDisplayName = $GroupDisplayName -replace "'", "''"
        }
    $filter = "DisplayName eq '$GroupDisplayName'"
    $Group = Get-MgGroup -Filter $filter -ErrorAction Stop
    if ($Group.Length -gt 1)
    {
        throw "Duplicate AzureAD Groups named $GroupDisplayName exist in tenant"
    }

    $assignment = Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter "scopeId eq '$($group.Id)' and scopeType eq 'Group' and RoleDefinitionId eq '$PIMGroupRole'"
    if ($null -eq $assignment)
    {
        Write-Verbose -Message "Could not find an Azure AD PIM Group with DisplayName {$GroupDisplayName} and Id {$id}."
        return $nullResult
    }

    $policyId = $assignment.PolicyId

    Update-MgBetaPolicyRoleManagementPolicyRule `
        -UnifiedRoleManagementPolicyId $policyId `
        -UnifiedRoleManagementPolicyRuleId $currentInstance.Id `
        -BodyParameter $body
    #endregion
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupDisplayName,

        [Parameter()]
        [System.String]
        $RuleType,

        [Parameter(Mandatory = $true)]
        [ValidateSet('member', 'owner')]
        [System.String]
        $PIMGroupRole,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExpirationRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $NotificationRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnablementRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ApprovalRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AuthenticationContextRule,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $Script:ExportMode = $true
        $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/privilegedAccess/aadGroups/resources"
        [array]$groups = (Invoke-MgGraphRequest -Method GET -Uri $uri -ErrorAction SilentlyContinue).value

        $dscContent = [System.Text.StringBuilder]::new()
        Write-M365DSCHost -Message "`r`n" -DeferWrite
        $j = 1
        $PIMGroupRole = @("member", "owner")

        $batchRequests = @()
        foreach ($group in $groups)
        {
            $batchRequests += @{
                id     = $group.Id
                method = 'GET'
                url    = "/policies/roleManagementPolicyAssignments?filter=scopeId eq '$($group.Id)' and scopeType eq 'Group'&`$expand=policy(`$expand=rules)"
            }
        }

        $batchResponses = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests

        foreach ($group in $groups)
        {
            foreach ($PIMRole in $PIMGroupRole)
            {
                $assignment = ($batchResponses | Where-Object { $_.id -eq $group.Id }).body.value `
                    | Where-Object { $_.roleDefinitionId -eq $PIMRole }
                $rules = $assignment.policy.rules

                Write-M365DSCHost -Message  "    |---[$j/$($groups.Count * 2)] $($group.displayName) ($PIMRole)`r`n" -DeferWrite
                $i = 1
                foreach ($rule in $rules)
                {
                    if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                    {
                        $Global:M365DSCExportResourceInstancesCount++
                    }
                    Write-M365DSCHost -Message "        |---[$i/$($rules.Count)] $($group.DisplayName)_$($rule.Id)" -DeferWrite
                    $Params = @{
                        GroupDisplayName      = $group.DisplayName
                        Id                    = $rule.Id
                        PIMGroupRole          = $PIMRole
                        ApplicationId         = $ApplicationId
                        TenantId              = $TenantId
                        CertificateThumbprint = $CertificateThumbprint
                        ApplicationSecret     = $ApplicationSecret
                        Credential            = $Credential
                        ManagedIdentity       = $ManagedIdentity.IsPresent
                        AccessTokens          = $AccessTokens
                    }

                    $Script:exportedInstance = $rule
                    $Results = Get-TargetResource @Params

                    if ($null -ne $Results.ExpirationRule)
                    {
                        $complexMapping = @(
                            @{
                                Name            = 'expirationRule'
                                CimInstanceName = 'AADRoleManagementPolicyExpirationRule'
                                IsRequired      = $False
                            }
                        )
                        $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                            -ComplexObject $Results.ExpirationRule`
                            -CIMInstanceName 'AADRoleManagementPolicyExpirationRule' `
                            -ComplexTypeMapping $complexMapping

                        if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                        {
                            $Results.ExpirationRule = $complexTypeStringResult
                        }
                        else
                        {
                            $Results.Remove('ExpirationRule') | Out-Null
                        }
                    }

                    if ($null -ne $Results.NotificationRule)
                    {
                        $complexMapping = @(
                            @{
                                Name            = 'notificationRule'
                                CimInstanceName = 'AADRoleManagementPolicyNotificationRule'
                                IsRequired      = $False
                            }
                        )
                        $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                            -ComplexObject $Results.NotificationRule`
                            -CIMInstanceName 'AADRoleManagementPolicyNotificationRule' `
                            -ComplexTypeMapping $complexMapping

                        if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                        {
                            $Results.NotificationRule = $complexTypeStringResult
                        }
                        else
                        {
                            $Results.Remove('NotificationRule') | Out-Null
                        }
                    }

                    if ($null -ne $Results.EnablementRule)
                    {
                        $complexMapping = @(
                            @{
                                Name            = 'enablementRule'
                                CimInstanceName = 'AADRoleManagementPolicyEnablementRule'
                                IsRequired      = $False
                            }
                        )
                        $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                            -ComplexObject $Results.EnablementRule`
                            -CIMInstanceName 'AADRoleManagementPolicyEnablementRule' `
                            -ComplexTypeMapping $complexMapping

                        if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                        {
                            $Results.EnablementRule = $complexTypeStringResult
                        }
                        else
                        {
                            $Results.Remove('EnablementRule') | Out-Null
                        }
                    }

                    if ($null -ne $Results.AuthenticationContextRule)
                    {
                        $complexMapping = @(
                            @{
                                Name            = 'authenticationContextRule'
                                CimInstanceName = 'AADRoleManagementPolicyAuthenticationContextRule'
                                IsRequired      = $False
                            }
                        )
                        $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                            -ComplexObject $Results.AuthenticationContextRule`
                            -CIMInstanceName 'AADRoleManagementPolicyAuthenticationContextRule' `
                            -ComplexTypeMapping $complexMapping

                        if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                        {
                            $Results.AuthenticationContextRule = $complexTypeStringResult
                        }
                        else
                        {
                            $Results.Remove('AuthenticationContextRule') | Out-Null
                        }
                    }

                    if ($null -ne $Results.ApprovalRule)
                    {
                        $complexMapping = @(
                            @{
                                Name            = 'approvalRule'
                                CimInstanceName = 'AADRoleManagementPolicyApprovalRule'
                                IsRequired      = $False
                            }
                            @{
                                Name            = 'setting'
                                CimInstanceName = 'AADRoleManagementPolicyApprovalSettings'
                                IsRequired      = $False
                            }
                            @{
                                Name            = 'approvalStages'
                                CimInstanceName = 'AADRoleManagementPolicyApprovalStage'
                                IsRequired      = $False
                            }
                            @{
                                Name            = 'escalationApprovers'
                                CimInstanceName = 'AADRoleManagementPolicySubjectSet'
                                IsRequired      = $False
                            }
                            @{
                                Name            = 'primaryApprovers'
                                CimInstanceName = 'AADRoleManagementPolicySubjectSet'
                                IsRequired      = $False
                            }
                        )
                        $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                            -ComplexObject $Results.ApprovalRule`
                            -CIMInstanceName 'AADRoleManagementPolicyApprovalRule' `
                            -ComplexTypeMapping $complexMapping

                        if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                        {
                            $Results.ApprovalRule = $complexTypeStringResult
                        }
                        else
                        {
                            $Results.Remove('ApprovalRule') | Out-Null
                        }
                    }

                    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                        -ConnectionMode $ConnectionMode `
                        -ModulePath $PSScriptRoot `
                        -Results $Results `
                        -Credential $Credential `
                        -NoEscape @('ExpirationRule', 'NotificationRule', 'EnablementRule', 'ApprovalRule', 'AuthenticationContextRule')

                    $dscContent.Append($currentDSCBlock) | Out-Null
                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                        -FileName $Global:PartialExportFileName
                    Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
                    $i++
                }
                $j++
            }
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


function Get-M365DSCRoleManagementPolicyRuleObject
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter()]
        $Rule
    )

    if ($null -eq $Rule)
    {
        return $null
    }

    if ($Script:ExportMode)
    {
        $values = @{
            id       = $Rule.id
            ruleType = $Rule.'@odata.type'
        }
    }
    else
    {
        $values = @{
            id       = $Rule.id
            ruleType = $Rule.AdditionalProperties.'@odata.type'
        }
    }

    if ($values.ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyExpirationRule')
    {
        if ($Script:ExportMode)
        {
            $expirationRule = @{
                isExpirationRequired = $Rule.isExpirationRequired
                maximumDuration      = $Rule.maximumDuration
            }
        }
        else
        {
            $expirationRule = @{
                isExpirationRequired = $Rule.AdditionalProperties.isExpirationRequired
                maximumDuration      = $Rule.AdditionalProperties.maximumDuration
            }
        }

        $values.Add('expirationRule', $expirationRule)
    }

    if ($values.ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyNotificationRule')
    {
        if ($Script:ExportMode)
        {
            $notificationRule = @{
                notificationType           = $Rule.notificationType
                recipientType              = $Rule.recipientType
                notificationLevel          = $Rule.notificationLevel
                isDefaultRecipientsEnabled = $Rule.isDefaultRecipientsEnabled
                notificationRecipients     = [array]$Rule.notificationRecipients
            }
        }
        else
        {
            $notificationRule = @{
                notificationType           = $Rule.AdditionalProperties.notificationType
                recipientType              = $Rule.AdditionalProperties.recipientType
                notificationLevel          = $Rule.AdditionalProperties.notificationLevel
                isDefaultRecipientsEnabled = $Rule.AdditionalProperties.isDefaultRecipientsEnabled
                notificationRecipients     = [array]$Rule.AdditionalProperties.notificationRecipients
            }
        }
        $values.Add('notificationRule', $notificationRule)
    }

    if ($values.ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyEnablementRule')
    {
        if ($Script:ExportMode)
        {
            $enablementRule = @{
                enabledRules = [array]$Rule.enabledRules
            }
        }
        else
        {
            $enablementRule = @{
                enabledRules = [array]$Rule.AdditionalProperties.enabledRules
            }
        }
        $values.Add('enablementRule', $enablementRule)
    }

    if ($values.ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyApprovalRule')
    {
        $approvalStages = @()
        if ($Script:ExportMode)
        {
            $foreachApprovalStages = $Rule.setting.approvalStages
        }
        else
        {
            $foreachApprovalStages = $Rule.AdditionalProperties.setting.approvalStages
        }
        foreach ($stage in $foreachApprovalStages)
        {
            $primaryApprovers = @()
            foreach ($approver in $stage.primaryApprovers)
            {
                $primaryApprover = @{
                    odataType = $approver.'@odata.type'
                }
                $primaryApprovers += $primaryApprover
            }

            $escalationApprovers = @()
            foreach ($approver in $stage.escalationApprovers)
            {
                $escalationApprover = @{
                    odataType = $approver.'@odata.type'
                }
                $escalationApprovers += $escalationApprover
            }

            $approvalStage = @{
                approvalStageTimeOutInDays      = $stage.approvalStageTimeOutInDays
                escalationTimeInMinutes         = $stage.escalationTimeInMinutes
                isApproverJustificationRequired = $stage.isApproverJustificationRequired
                isEscalationEnabled             = $stage.isEscalationEnabled
                escalationApprovers             = [array]$escalationApprovers
                primaryApprovers                = [array]$primaryApprovers
            }

            $approvalStages += $approvalStage
        }

        if ($Script:ExportMode)
        {
            $setting = @{
                approvalMode                     = $Rule.setting.approvalMode
                isApprovalRequired               = $Rule.setting.isApprovalRequired
                isApprovalRequiredForExtension   = $Rule.setting.isApprovalRequiredForExtension
                isRequestorJustificationRequired = $Rule.setting.isRequestorJustificationRequired
                approvalStages                   = [array]$approvalStages
            }
        }
        else
        {
            $setting = @{
                approvalMode                     = $Rule.AdditionalProperties.setting.approvalMode
                isApprovalRequired               = $Rule.AdditionalProperties.setting.isApprovalRequired
                isApprovalRequiredForExtension   = $Rule.AdditionalProperties.setting.isApprovalRequiredForExtension
                isRequestorJustificationRequired = $Rule.AdditionalProperties.setting.isRequestorJustificationRequired
                approvalStages                   = [array]$approvalStages
            }
        }
        $approvalRule = @{
            setting = $setting
        }
        $values.Add('ApprovalRule', $approvalRule)
    }

    if ($values.ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyAuthenticationContextRule')
    {
        if ($Script:ExportMode)
        {
            $authenticationContextRule = @{
                isEnabled  = $Rule.isEnabled
                claimValue = $Rule.claimValue
            }
        }
        else
        {
            $authenticationContextRule = @{
                isEnabled  = $Rule.AdditionalProperties.isEnabled
                claimValue = $Rule.AdditionalProperties.claimValue
            }
        }
        $values.Add('authenticationContextRule', $authenticationContextRule)
    }

    return $values
}

Export-ModuleMember -Function *-TargetResource
