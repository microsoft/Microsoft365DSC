function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $groupDisplayName,

        [Parameter()]
        [System.String]
        $ruleType,

        [Parameter(Mandatory = $true)]
        [ValidateSet('member', 'owner')]
        [System.String]
        $PIMGroupRole,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $expirationRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $notificationRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $enablementRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $approvalRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $authenticationContextRule,

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

        $nullResult = $PSBoundParameters

        #get groupId
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
            -UnifiedRoleManagementPolicyRuleId $id -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Azure AD Group PIM Policy Rule with Id {$id} and PolicyId {$policyId}."
            return $nullResult
        }

        Write-Verbose -Message "An Azure AD Role Management Policy Rule with Id {$id} and PolicyId {$policyId} was found"
        $rule = Get-M365DSCRoleManagementPolicyRuleObject -Rule $getValue

        $results = @{
            id                        = $id
            groupDisplayName          = $groupDisplayName
            ruleType                  = $rule.ruleType
            PIMGroupRole              = $PIMGroupRole
            expirationRule            = $rule.expirationRule
            notificationRule          = $rule.notificationRule
            enablementRule            = $rule.enablementRule
            approvalRule              = $rule.approvalRule
            authenticationContextRule = $rule.authenticationContextRule
            Credential                = $Credential
            ApplicationId             = $ApplicationId
            TenantId                  = $TenantId
            ApplicationSecret         = $ApplicationSecret
            CertificateThumbprint     = $CertificateThumbprint
            ManagedIdentity           = $ManagedIdentity.IsPresent
        }

        return [System.Collections.Hashtable] $results
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
        $id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $groupDisplayName,

        [Parameter()]
        [System.String]
        $ruleType,

        [Parameter(Mandatory = $true)]
        [ValidateSet('member', 'owner')]
        [System.String]
        $PIMGroupRole,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $expirationRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $notificationRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $enablementRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $approvalRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $authenticationContextRule,

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

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

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
        $id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $groupDisplayName,

        [Parameter()]
        [System.String]
        $ruleType,

        [Parameter(Mandatory = $true)]
        [ValidateSet('member', 'owner')]
        [System.String]
        $PIMGroupRole,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $expirationRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $notificationRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $enablementRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $approvalRule,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $authenticationContextRule,

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

    Write-Verbose -Message "Testing configuration of the Azure AD PIM Group Management Policy Rule with Id {$Id} and DisplayName {$groupDisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($null -ne $source -and $source.GetType().Name -like '*CimInstance*')
        {
            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-not $testResult)
            {
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.Remove('Id') | Out-Null
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
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
        $Uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/privilegedAccess/aadGroups/resources"
        [array] $PIMgroups = (Invoke-GraphRequest -Method GET -Uri $uri -ErrorAction SilentlyContinue).value

        if($Filter.Length -gt 0)
        {
            $filtergroup = Get-MgGroup -Filter $Filter -ErrorAction Stop
            if($filtergroup.Length -gt 1)
            {
                throw "Duplicate AzureAD Groups named $($Filter.AADGroupEligibilityScheduleSettings) exist in tenant"
            }
            [array] $groups = $PIMgroups | Where-Object { $_.id -eq $filtergroup.id }
            if($groups.Count -eq 0)
            {
                throw "No AzureAD Groups named $($Filter.AADGroupEligibilityScheduleSettings) exist in tenant"
            }
        }
        else{
            [array] $groups = $PIMgroups
        }

        $dscContent = [System.Text.StringBuilder]::new()
        Write-M365DSCHost -Message "`r`n" -DeferWrite
        $j = 1
        $PIMGroupRole = @("member", "owner")

        foreach ($group in $groups)
        {
            foreach ($PIMRole in $PIMGroupRole){
                $assignment = Get-MgBetaPolicyRoleManagementPolicyAssignment -Filter "scopeId eq '$($group.Id)' and scopeType eq 'Group' and RoleDefinitionId eq '$PIMRole'"
                $policyId = $assignment.PolicyId
                $rules = Get-MgBetaPolicyRoleManagementPolicyRule `
                    -UnifiedRoleManagementPolicyId $policyId

                Write-M365DSCHost -Message  "    |---[$j/$($groups.Count * 2)] $($group.displayName) ($PIMRole)"
                $i = 1
                foreach ($rule in $rules)
                {
                    if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                    {
                        $Global:M365DSCExportResourceInstancesCount++
                    }
                    Write-M365DSCHost -Message "        |---[$i/$($rules.Count)] $($group.displayName)_$($rule.id)" -DeferWrite
                    $Params = @{
                        GroupDisplayName      = $group.displayName
                        id                    = $rule.id
                        PIMGroupRole          = $PIMRole
                        ApplicationId         = $ApplicationId
                        TenantId              = $TenantId
                        CertificateThumbprint = $CertificateThumbprint
                        ApplicationSecret     = $ApplicationSecret
                        Credential            = $Credential
                        Managedidentity       = $ManagedIdentity.IsPresent
                        AccessTokens          = $AccessTokens
                    }

                    $Results = Get-TargetResource @Params


                    if ($null -ne $Results.expirationRule)
                    {
                        $complexMapping = @(
                            @{
                                Name            = 'expirationRule'
                                CimInstanceName = 'AADRoleManagementPolicyExpirationRule'
                                IsRequired      = $False
                            }
                        )
                        $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                            -ComplexObject $Results.expirationRule`
                            -CIMInstanceName 'AADRoleManagementPolicyExpirationRule' `
                            -ComplexTypeMapping $complexMapping

                        if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                        {
                            $Results.expirationRule = $complexTypeStringResult
                        }
                        else
                        {
                            $Results.Remove('expirationRule') | Out-Null
                        }
                    }

                    if ($null -ne $Results.notificationRule)
                    {
                        $complexMapping = @(
                            @{
                                Name            = 'notificationRule'
                                CimInstanceName = 'AADRoleManagementPolicyNotificationRule'
                                IsRequired      = $False
                            }
                        )
                        $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                            -ComplexObject $Results.notificationRule`
                            -CIMInstanceName 'AADRoleManagementPolicyNotificationRule' `
                            -ComplexTypeMapping $complexMapping

                        if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                        {
                            $Results.notificationRule = $complexTypeStringResult
                        }
                        else
                        {
                            $Results.Remove('notificationRule') | Out-Null
                        }
                    }


                    if ($null -ne $Results.enablementRule)
                    {
                        $complexMapping = @(
                            @{
                                Name            = 'enablementRule'
                                CimInstanceName = 'AADRoleManagementPolicyEnablementRule'
                                IsRequired      = $False
                            }
                        )
                        $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                            -ComplexObject $Results.enablementRule`
                            -CIMInstanceName 'AADRoleManagementPolicyEnablementRule' `
                            -ComplexTypeMapping $complexMapping

                        if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                        {
                            $Results.enablementRule = $complexTypeStringResult
                        }
                        else
                        {
                            $Results.Remove('enablementRule') | Out-Null
                        }
                    }

                    if ($null -ne $Results.authenticationContextRule)
                    {
                        $complexMapping = @(
                            @{
                                Name            = 'authenticationContextRule'
                                CimInstanceName = 'AADRoleManagementPolicyAuthenticationContextRule'
                                IsRequired      = $False
                            }
                        )
                        $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                            -ComplexObject $Results.authenticationContextRule`
                            -CIMInstanceName 'AADRoleManagementPolicyAuthenticationContextRule' `
                            -ComplexTypeMapping $complexMapping

                        if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                        {
                            $Results.authenticationContextRule = $complexTypeStringResult
                        }
                        else
                        {
                            $Results.Remove('authenticationContextRule') | Out-Null
                        }
                    }

                    if ($null -ne $Results.approvalRule)
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
                            -ComplexObject $Results.approvalRule`
                            -CIMInstanceName 'AADRoleManagementPolicyApprovalRule' `
                            -ComplexTypeMapping $complexMapping

                        if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                        {
                            $Results.approvalRule = $complexTypeStringResult
                        }
                        else
                        {
                            $Results.Remove('approvalRule') | Out-Null
                        }
                    }

                    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                        -ConnectionMode $ConnectionMode `
                        -ModulePath $PSScriptRoot `
                        -Results $Results `
                        -Credential $Credential `
                        -NoEscape @('expirationRule', 'notificationRule', 'enablementRule', 'approvalRule', 'authenticationContextRule')

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
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
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

    $odataType = '@odata.type'
    $values = @{
        id       = $Rule.id
        ruleType = $Rule.AdditionalProperties.$odataType
    }

    if ($values.ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyExpirationRule')
    {
        $expirationRule = @{
            isExpirationRequired = $Rule.AdditionalProperties.isExpirationRequired
            maximumDuration      = $Rule.AdditionalProperties.maximumDuration
        }
        $values.Add('expirationRule', $expirationRule)
    }

    if ($values.ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyNotificationRule')
    {
        $notificationRule = @{
            notificationType           = $Rule.AdditionalProperties.notificationType
            recipientType              = $Rule.AdditionalProperties.recipientType
            notificationLevel          = $Rule.AdditionalProperties.notificationLevel
            isDefaultRecipientsEnabled = $Rule.AdditionalProperties.isDefaultRecipientsEnabled
            notificationRecipients     = [array]$Rule.AdditionalProperties.notificationRecipients
        }
        $values.Add('notificationRule', $notificationRule)
    }

    if ($values.ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyEnablementRule')
    {
        $enablementRule = @{
            enabledRules = [array]$Rule.AdditionalProperties.enabledRules
        }
        $values.Add('enablementRule', $enablementRule)
    }

    if ($values.ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyApprovalRule')
    {
        $approvalStages = @()
        foreach ($stage in $Rule.AdditionalProperties.setting.approvalStages)
        {
            $primaryApprovers = @()
            foreach ($approver in $stage.primaryApprovers)
            {
                $primaryApprover = @{
                    odataType = $approver.$odataType
                }
                $primaryApprovers += $primaryApprover
            }

            $escalationApprovers = @()
            foreach ($approver in $stage.escalationApprovers)
            {
                $escalationApprover = @{
                    odataType = $approver.$odataType
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
        $setting = @{
            approvalMode                     = $Rule.AdditionalProperties.setting.approvalMode
            isApprovalRequired               = $Rule.AdditionalProperties.setting.isApprovalRequired
            isApprovalRequiredForExtension   = $Rule.AdditionalProperties.setting.isApprovalRequiredForExtension
            isRequestorJustificationRequired = $Rule.AdditionalProperties.setting.isRequestorJustificationRequired
            approvalStages                   = [array]$approvalStages
        }
        $approvalRule = @{
            setting = $setting
        }
        $values.Add('approvalRule', $approvalRule)
    }

    if ($values.ruleType -eq '#microsoft.graph.unifiedRoleManagementPolicyAuthenticationContextRule')
    {
        $authenticationContextRule = @{
            isEnabled  = $Rule.AdditionalProperties.isEnabled
            claimValue = $Rule.AdditionalProperties.claimValue
        }
        $values.Add('authenticationContextRule', $authenticationContextRule)
    }


    return $values
}

Export-ModuleMember -Function *-TargetResource
