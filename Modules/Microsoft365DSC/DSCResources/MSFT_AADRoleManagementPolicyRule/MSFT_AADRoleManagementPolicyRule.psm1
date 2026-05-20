Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADRoleManagementPolicyRule'

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
        $RoleDisplayName,

        [Parameter()]
        [System.String]
        $RuleType,

        [Parameter()]
        [System.String]
        $PolicyId,

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

    Write-Verbose -Message "Getting configuration for the Azure AD Role Management Policy Rule with Id {$Id} and Role DisplayName {$RoleDisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
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

            if ($null -eq $Script:allDirectoryRoles)
            {
                $Script:allDirectoryRoles = Get-MgBetaRoleManagementDirectoryRoleDefinition -All
            }

            if ($null -eq $Script:allPolicyAssignments)
            {
                $Script:allPolicyAssignments = Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter "scopeId eq '/' and scopeType eq 'DirectoryRole'"
            }

            $getValue = $null
            $role = $Script:allDirectoryRoles | Where-Object { $_.DisplayName -eq $($RoleDisplayName -replace "'", "''") }
            if ($null -eq $role)
            {
                Write-Verbose -Message "Could not find an Azure AD Role Management Definition with DisplayName {$RoleDisplayName}"
                return $nullResult
            }

            $assignment = $Script:allPolicyAssignments | Where-Object { $_.RoleDefinitionId -eq $role.Id }
            if ($null -eq $assignment)
            {
                Write-Verbose -Message "Could not find an Azure AD Role Management Policy Assignment with RoleDefinitionId {$role.Id}"
                return $nullResult
            }

            $policyId = $assignment.PolicyId
            $getValue = Get-MgBetaPolicyRoleManagementPolicyRule `
                -UnifiedRoleManagementPolicyId $policyId `
                -UnifiedRoleManagementPolicyRuleId $id -ErrorAction SilentlyContinue

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Azure AD Role Management Policy Rule with Id {$id} and PolicyId {$policyId}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }

        Write-Verbose -Message "An Azure AD Role Management Policy Rule with Id {$id} and PolicyId {$policyId} was found"

        $complexRule = [ordered]@{
            id       = $getValue.id
            ruleType = $getValue.AdditionalProperties.'@odata.type'
        }

        if ($complexRule.ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyExpirationRule')
        {
            $complexExpirationRule = [ordered]@{
                isExpirationRequired = $getValue.AdditionalProperties.isExpirationRequired
                maximumDuration      = $getValue.AdditionalProperties.maximumDuration
            }
            $complexRule.Add('ExpirationRule', $complexExpirationRule)
        }

        if ($complexRule.ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyNotificationRule')
        {
            $complexNotificationRule = [ordered]@{
                isDefaultRecipientsEnabled = $getValue.AdditionalProperties.isDefaultRecipientsEnabled
                notificationLevel          = $getValue.AdditionalProperties.notificationLevel
                notificationRecipients     = [array]$getValue.AdditionalProperties.notificationRecipients
                notificationType           = $getValue.AdditionalProperties.notificationType
                recipientType              = $getValue.AdditionalProperties.recipientType
            }
            $complexRule.Add('NotificationRule', $complexNotificationRule)
        }

        if ($complexRule.ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyEnablementRule')
        {
            $complexEnablementRule = @{
                enabledRules = [array]$getValue.AdditionalProperties.enabledRules
            }
            $complexRule.Add('EnablementRule', $complexEnablementRule)
        }

        if ($complexRule.ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyApprovalRule')
        {
            $approvalStages = @()
            foreach ($stage in $getValue.AdditionalProperties.setting.approvalStages)
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

                $approvalStage = [ordered]@{
                    approvalStageTimeOutInDays      = $stage.approvalStageTimeOutInDays
                    escalationApprovers             = [array]$escalationApprovers
                    escalationTimeInMinutes         = $stage.escalationTimeInMinutes
                    isApproverJustificationRequired = $stage.isApproverJustificationRequired
                    isEscalationEnabled             = $stage.isEscalationEnabled
                    primaryApprovers                = [array]$primaryApprovers
                }

                $approvalStages += $approvalStage
            }
            $setting = [ordered]@{
                approvalMode                     = $getValue.AdditionalProperties.setting.approvalMode
                approvalStages                   = [array]$approvalStages
                isApprovalRequired               = $getValue.AdditionalProperties.setting.isApprovalRequired
                isApprovalRequiredForExtension   = $getValue.AdditionalProperties.setting.isApprovalRequiredForExtension
                isRequestorJustificationRequired = $getValue.AdditionalProperties.setting.isRequestorJustificationRequired
            }
            $complexApprovalRule = @{
                setting = $setting
            }
            $complexRule.Add('ApprovalRule', $complexApprovalRule)
        }

        if ($complexRule.ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyAuthenticationContextRule')
        {
            $complexAuthenticationContextRule = [ordered]@{
                claimValue = $getValue.AdditionalProperties.claimValue
                isEnabled  = $getValue.AdditionalProperties.isEnabled
            }
            $complexRule.Add('AuthenticationContextRule', $complexAuthenticationContextRule)
        }

        $results = @{
            Id                        = $Id
            PolicyId                  = $PolicyId
            RoleDisplayName           = $RoleDisplayName
            RuleType                  = $complexRule.RuleType
            ExpirationRule            = $complexRule.ExpirationRule
            NotificationRule          = $complexRule.NotificationRule
            EnablementRule            = $complexRule.EnablementRule
            ApprovalRule              = $complexRule.ApprovalRule
            AuthenticationContextRule = $complexRule.AuthenticationContextRule
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
        $RoleDisplayName,

        [Parameter()]
        [System.String]
        $RuleType,

        [Parameter()]
        [System.String]
        $PolicyId,

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

    Write-Verbose -Message "Updating the Azure AD Role Management Policy Rule with Id {$($currentInstance.Id)}"
    $body = @{
        '@odata.type' = $ruleType
    }

    if ($ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyExpirationRule')
    {
        $expirationRuleHashmap = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $ExpirationRule
        # add all the properties to the body
        foreach ($key in $expirationRuleHashmap.Keys)
        {
            $body.Add($key, $expirationRuleHashmap.$key)
        }
    }

    if ($ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyNotificationRule')
    {
        $notificationRuleHashmap = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $NotificationRule
        $body += $notificationRuleHashmap
    }

    if ($ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyEnablementRule')
    {
        $enablementRuleHashmap = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $EnablementRule
        $body += $enablementRuleHashmap
    }

    if ($ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyApprovalRule')
    {
        $approvalRuleHashmap = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $ApprovalRule
        $body += $approvalRuleHashmap
    }

    if ($ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyAuthenticationContextRule')
    {
        $authenticationContextRuleHashmap = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $AuthenticationContextRule
        $body += $authenticationContextRuleHashmap
    }

    Update-MgBetaPolicyRoleManagementPolicyRule `
        -UnifiedRoleManagementPolicyId $currentInstance.policyId `
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
        $RoleDisplayName,

        [Parameter()]
        [System.String]
        $RuleType,

        [Parameter()]
        [System.String]
        $PolicyId,

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

    $dscContent = [System.Text.StringBuilder]::new()
    Write-M365DSCHost -Message "`r`n" -DeferWrite
    try
    {
        [array] $roles = Get-MgBetaRoleManagementDirectoryRoleDefinition -Filter $Filter -All
        [array]$Script:allPolicyAssignments = Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter "scopeId eq '/' and scopeType eq 'DirectoryRole'"

        $j = 1
        foreach ($role in $roles)
        {
            $assignment = $Script:allPolicyAssignments | Where-Object { $_.RoleDefinitionId -eq $role.Id }
            $policyId = $assignment.PolicyId
            $rules = Get-MgBetaPolicyRoleManagementPolicyRule `
                -UnifiedRoleManagementPolicyId $policyId

            Write-M365DSCHost -Message "    |---[$j/$($roles.Count)] $($role.displayName)"
            $i = 1
            foreach ($rule in $rules)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }
                Write-M365DSCHost -Message "        |---[$i/$($rules.Count)] $($role.DisplayName)_$($rule.Id)" -DeferWrite
                $Params = @{
                    RoleDisplayName       = $role.DisplayName
                    Id                    = $rule.Id
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    ApplicationSecret     = $ApplicationSecret
                    Credential            = $Credential
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    AccessTokens          = $AccessTokens
                }

                $Script:exportedInstance = $rule
                $Script:currentAssignment = $assignment
                $Results = Get-TargetResource @Params

                if ($null -ne $Results.ExpirationRule)
                {
                    $complexMapping = @(
                        @{
                            Name            = 'ExpirationRule'
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
                            Name            = 'NotificationRule'
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
                            Name            = 'EnablementRule'
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
                            Name            = 'AuthenticationContextRule'
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
                            Name            = 'ApprovalRule'
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
                        -ComplexObject $Results.ApprovalRule `
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
