function Start-O365ConfigurationExtract
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String[]]
        $ComponentsToExtract,

        [Parameter()]
        [Switch]
        $AllComponents,

        [Parameter()]
        [System.String]
        $Path
    )

    $organization = ""
    $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the O365DSC part of O365DSC.onmicrosoft.com)
    if ($GlobalAdminAccount.UserName.Contains("@"))
    {
        $organization = $GlobalAdminAccount.UserName.Split("@")[1]
        Add-ConfigurationDataEntry -Node "NonNodeData" `
                                   -Key "OrganizationName" `
                                   -Value $organization `
                                   -Description "Name of the Organization"

        if ($organization.IndexOf(".") -gt 0)
        {
            $principal = $organization.Split(".")[0]
        }
    }

    $filesToDownload = @() # List of files to download in the destination folder;

    $InformationPreference = "Continue"
    $VerbosePreference = "SilentlyContinue"
    $WarningPreference = "SilentlyContinue"
    $AzureAutomation = $false
    $DSCContent = "Configuration O365TenantConfig `r`n{`r`n"
    $DSCContent += "    Import-DSCResource -ModuleName Office365DSC`r`n`r`n"
    $DSCContent += "    <# Credentials #>`r`n"
    $DSCContent += "    Node localhost`r`n"
    $DSCContent += "    {`r`n"

    Add-ConfigurationDataEntry -Node "localhost" `
                                   -Key "ServerNumber" `
                                   -Value "0" `
                                   -Description "Default Valus Used to Ensure a Configuration Data File is Generated"
    # Obtain central administration url from a User Principal Name
    $centralAdminUrl = $null
    $NeedToConnectToO365Admin = $false
    foreach ($Component in $ComponentsToExtract)
    {
        if ($Component -like 'chckO365*')
        {
            $NeedToConnectToO365Admin = $true
            break
        }
    }
    if ($NeedToConnectToO365Admin -or $AllComponents)
    {
        Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount
    }

    $centralAdminUrl = Get-SPOAdministrationUrl -GlobalAdminAccount $GlobalAdminAccount

    # Add the GlobalAdminAccount to the Credentials List
    Save-Credentials -UserName "globaladmin"

    #region "O365AdminAuditLogConfig"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckO365AdminAuditLogConfig")) -or
        $AllComponents)
    {
        Write-Information "Extracting O365AdminAuditLogConfig..."
        Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
        $O365AdminAuditLogConfig = Get-AdminAuditLogConfig

        $O365AdminAuditLogConfigModulePath = Join-Path -Path $PSScriptRoot `
                                                       -ChildPath "..\DSCResources\MSFT_O365AdminAuditLogConfig\MSFT_O365AdminAuditLogConfig.psm1" `
                                                       -Resolve

        $value = "Disabled"
        if ($O365AdminAuditLogConfig.UnifiedAuditLogIngestionEnabled)
        {
            $value = "Enabled"
        }

        Import-Module $O365AdminAuditLogConfigModulePath | Out-Null
        $DSCContent += Export-TargetResource -UnifiedAuditLogIngestionEnabled $value -GlobalAdminAccount $GlobalAdminAccount -IsSingleInstance 'Yes'
    }
    #endregion

    #region "EXOAtpPolicyForO365"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOAtpPolicyForO365")) -or
        $AllComponents)
    {
        if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-AtpPolicyForO365)
        {
            Write-Information "Extracting EXOAtpPolicyForO365..."
            $EXOAtpPolicyForO365ModulePath = Join-Path -Path $PSScriptRoot `
                                                       -ChildPath "..\DSCResources\MSFT_EXOAtpPolicyForO365\MSFT_EXOAtpPolicyForO365.psm1" `
                                                       -Resolve

            Import-Module $EXOAtpPolicyForO365ModulePath | Out-Null
            $DSCContent += Export-TargetResource -IsSingleInstance "Yes" -GlobalAdminAccount $GlobalAdminAccount
        }
        else
        {
            Write-Information "The specified Tenant is not registered for ATP, and therefore can't extract policies"
        }
    }
    #endregion

    #region "EXOCASMailboxPlan"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOCASMailboxPlan")) -or
        $AllComponents)
    {
        Write-Information "Extracting EXOCASMailboxPlan..."
        Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
        $CASMailboxPlans = Get-CASMailboxPlan
        $EXOCASMailboxPlanModulePath = Join-Path -Path $PSScriptRoot `
                                                -ChildPath "..\DSCResources\MSFT_EXOCASMailboxPlan\MSFT_EXOCASMailboxPlan.psm1" `
                                                -Resolve

        Import-Module $EXOCASMailboxPlanModulePath | Out-Null

        foreach ($CASMailboxPlan in $CASMailboxPlans)
        {
            $DSCContent += Export-TargetResource -Identity $CASMailboxPlan.Identity -GlobalAdminAccount $GlobalAdminAccount
        }
    }
    #endregion

    #region "EXOClientAccessRule"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOClientAccessRule")) -or
        $AllComponents)
    {
        Write-Information "Extracting EXOClientAccessRule..."
        Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
        $ClientAccessRules = Get-ClientAccessRule
        $EXOClientAccessRuleModulePath = Join-Path -Path $PSScriptRoot `
                                                -ChildPath "..\DSCResources\MSFT_EXOClientAccessRule\MSFT_EXOClientAccessRule.psm1" `
                                                -Resolve

        Import-Module $EXOClientAccessRuleModulePath | Out-Null
        foreach ($ClientAccessRule in $ClientAccessRules)
        {
            $DSCContent += Export-TargetResource -Identity $ClientAccessRule.Identity -Action $ClientAccessRule.Action -GlobalAdminAccount $GlobalAdminAccount
        }
    }
    #endregion

    #region "EXODkimSigningConfig"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXODkimSigningConfig")) -or
        $AllComponents)
    {
        Write-Information "Extracting EXODkimSigningConfig..."
        Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
        $DkimSigningConfigs = Get-DkimSigningConfig
        $EXODkimSigningConfigModulePath = Join-Path -Path $PSScriptRoot `
                                                    -ChildPath "..\DSCResources\MSFT_EXODkimSigningConfig\MSFT_EXODkimSigningConfig.psm1" `
                                                    -Resolve

        Import-Module $EXODkimSigningConfigModulePath | Out-Null
        $i = 1
        foreach ($DkimSigningConfig in $DkimSigningConfigs)
        {
            Write-Verbose -Message "    - [$i/$($DkimSigningConfigs.Length)] $($DkimSigningConfig.Identity)}"

            $partialContent = Export-TargetResource -Identity $DkimSigningConfig.Identity -GlobalAdminAccount $GlobalAdminAccount
            if ($partialContent.ToLower().IndexOf($organization) -gt 0)
            {
                $partialContent = $partialContent -ireplace [regex]::Escape($organization), "`$(`$ConfigurationData.NonNodeData.OrganizationName)"
            }
            $DSCContent += $partialContent
            $i++
        }
    }
    #endregion

    #region "EXOHostedConnectionFilterPolicy"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOHostedConnectionFilterPolicy")) -or
        $AllComponents)
    {
        Write-Information "Extracting EXOHostedConnectionFilterPolicy..."
        Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
        $HostedConnectionFilterPolicys = Get-HostedConnectionFilterPolicy
        $EXOHostedConnectionFilterPolicyModulePath = Join-Path -Path $PSScriptRoot `
                                                    -ChildPath "..\DSCResources\MSFT_EXOHostedConnectionFilterPolicy\MSFT_EXOHostedConnectionFilterPolicy.psm1" `
                                                    -Resolve

        Import-Module $EXOHostedConnectionFilterPolicyModulePath | Out-Null
        foreach ($HostedConnectionFilterPolicy in $HostedConnectionFilterPolicys)
        {
            $DSCContent += Export-TargetResource -Identity $HostedConnectionFilterPolicy.Identity -GlobalAdminAccount $GlobalAdminAccount
        }
    }
    #endregion

    #region "EXOHostedContentFilterPolicy"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOHostedContentFilterPolicy")) -or
        $AllComponents)
    {
        Write-Information "Extracting EXOHostedContentFilterPolicy..."
        Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
        $HostedContentFilterPolicies = Get-HostedContentFilterPolicy
        $EXOHostedContentFilterPolicyModulePath = Join-Path -Path $PSScriptRoot `
                                                    -ChildPath "..\DSCResources\MSFT_EXOHostedContentFilterPolicy\MSFT_EXOHostedContentFilterPolicy.psm1" `
                                                    -Resolve

        Import-Module $EXOHostedContentFilterPolicyModulePath | Out-Null
        foreach ($HostedContentFilterPolicy in $HostedContentFilterPolicies)
        {
            $DSCContent += Export-TargetResource -Identity $HostedContentFilterPolicy.Identity -GlobalAdminAccount $GlobalAdminAccount
        }
    }
    #endregion

    #region "EXOHostedContentFilterRule"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOHostedContentFilterRule")) -or
        $AllComponents)
    {
        Write-Information "Extracting EXOHostedContentFilterRule..."
        Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
        $HostedContentFilterRules = Get-HostedContentFilterRule
        $EXOHostedContentFilterRuleModulePath = Join-Path -Path $PSScriptRoot `
                                                    -ChildPath "..\DSCResources\MSFT_EXOHostedContentFilterRule\MSFT_EXOHostedContentFilterRule.psm1" `
                                                    -Resolve

        Import-Module $EXOHostedContentFilterRuleModulePath | Out-Null
        foreach ($HostedContentFilterRule in $HostedContentFilterRules)
        {
            $DSCContent += Export-TargetResource -Identity $HostedContentFilterRule.Identity -HostedContentFilterPolicy $HostedContentFilterRule.HostedContentFilterPolicy -GlobalAdminAccount $GlobalAdminAccount
        }
    }
    #endregion

    #region "EXOHostedOutboundSpamFilterPolicy"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOHostedOutboundSpamFilterPolicy")) -or
        $AllComponents)
    {
        Write-Information "Extracting EXOHostedOutboundSpamFilterPolicy..."
        $EXOHostedOutboundSpamFilterPolicyModulePath = Join-Path -Path $PSScriptRoot `
                                                    -ChildPath "..\DSCResources\MSFT_EXOHostedOutboundSpamFilterPolicy\MSFT_EXOHostedOutboundSpamFilterPolicy.psm1" `
                                                    -Resolve

        Import-Module $EXOHostedOutboundSpamFilterPolicyModulePath | Out-Null
        $DSCContent += Export-TargetResource -IsSingleInstance "Yes" -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "EXOSafeAttachmentPolicy"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOSafeAttachmentPolicy")) -or
        $AllComponents)
    {
        if (Confirm-ImportedCmdletIsAvailable -CmdletName GetSafeAttachmentPolicy)
        {
            Write-Information "Extracting EXOSafeAttachmentPolicy..."
            Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
            $SafeAttachmentPolicies = Get-SafeAttachmentPolicy
            $EXOSafeAttachmentPolicyModulePath = Join-Path -Path $PSScriptRoot `
                                                        -ChildPath "..\DSCResources\MSFT_EXOSafeAttachmentPolicy\MSFT_EXOSafeAttachmentPolicy.psm1" `
                                                        -Resolve

            Import-Module $EXOSafeAttachmentPolicyModulePath | Out-Null
            foreach ($SafeAttachmentPolicy in $SafeAttachmentPolicies)
            {
                $DSCContent += Export-TargetResource -Identity $SafeAttachmentPolicy.Identity -GlobalAdminAccount $GlobalAdminAccount
            }
        }
        else
        {
            Write-Information "The current tenant doesn't have access to Safe Attachment Policy APIs."
        }
    }
    #endregion

    #region "EXOSafeAttachmentRule"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOSafeAttachmentRule")) -or
        $AllComponents)
    {
        if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-SafeAttachmentRule)
        {
            Write-Information "Extracting EXOSafeAttachmentRule..."
            Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
            $SafeAttachmentRules = Get-SafeAttachmentRule
            $EXOSafeAttachmentRuleModulePath = Join-Path -Path $PSScriptRoot `
                                                        -ChildPath "..\DSCResources\MSFT_EXOSafeAttachmentRule\MSFT_EXOSafeAttachmentRule.psm1" `
                                                        -Resolve

            Import-Module $EXOSafeAttachmentRuleModulePath | Out-Null
            foreach ($SafeAttachmentRule in $SafeAttachmentRules)
            {
                $DSCContent += Export-TargetResource -Identity $SafeAttachmentRule.Identity -SafeAttachmentPolicy $SafeAttachmentRule.SafeAttachmentPolicy -GlobalAdminAccount $GlobalAdminAccount
            }
        }
        else
        {
            Write-Information "The current tenant doesn't have access to the Safe Attachment Rule API"
        }
    }
    #endregion

    #region "EXOSafeLinksPolicy"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOSafeLinksPolicy")) -or
        $AllComponents)
    {
        if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-SafeAttachmentRule)
        {
            Write-Information "Extracting EXOSafeLinksPolicy..."
            Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
            $SafeLinksPolicies = Get-SafeLinksPolicy
            $EXOSafeLinksPolicyModulePath = Join-Path -Path $PSScriptRoot `
                                                        -ChildPath "..\DSCResources\MSFT_EXOSafeLinksPolicy\MSFT_EXOSafeLinksPolicy.psm1" `
                                                        -Resolve

            Import-Module $EXOSafeLinksPolicyModulePath | Out-Null
            foreach($SafeLinksPolicy in $SafeLinksPolicies)
            {
                $DSCContent += Export-TargetResource -Identity $SafeLinksPolicy.Identity -GlobalAdminAccount $GlobalAdminAccount
            }
        }
        else
        {
            Write-Information "The current tenant is not registered to allow for Safe Attachment Rules."
        }
    }
    #endregion

    #region "EXOSafeLinksRule"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOSafeLinksRule")) -or
        $AllComponents)
    {
        if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-SafeAttachmentRule)
        {
            Write-Information "Extracting EXOSafeLinksRule..."
            Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
            $SafeLinksRules = Get-SafeLinksRule
            $EXOSafeLinksRuleModulePath = Join-Path -Path $PSScriptRoot `
                                                        -ChildPath "..\DSCResources\MSFT_EXOSafeLinksRule\MSFT_EXOSafeLinksRule.psm1" `
                                                        -Resolve

            Import-Module $EXOSafeLinksRuleModulePath | Out-Null
            foreach ($SafeLinksRule in $SafeLinksRules)
            {
                $DSCContent += Export-TargetResource -Identity $SafeLinksRule.Identity -SafeLinksPolicy $SafeLinksRule.SafeLinksPolicy -GlobalAdminAccount $GlobalAdminAccount
            }
        }
        else
        {
            Write-Information "The current tenant is not registered to allow for Safe Links Rules."
        }
    }
    #endregion

    #region "EXOMailTips"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOMailTips")) -or
        $AllComponents)
    {
        Write-Information "Extracting EXOMailTips..."
        Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
        $OrgConfig = Get-OrganizationConfig
        $organizationName = $OrgConfig.Name

        $EXOMailTipsModulePath = Join-Path -Path $PSScriptRoot `
                                           -ChildPath "..\DSCResources\MSFT_EXOMailTips\MSFT_EXOMailTips.psm1" `
                                           -Resolve

        Import-Module $EXOMailTipsModulePath | Out-Null
        $partialContent = Export-TargetResource -Organization $organizationName -GlobalAdminAccount $GlobalAdminAccount
        if ($partialContent.ToLower().IndexOf($organization) -gt 0)
        {
            $partialContent = $partialContent -ireplace [regex]::Escape("`"" + $organization + "`""), "`$ConfigurationData.NonNodeData.OrganizationName"
        }
        if ($partialContent.ToLower().IndexOf($organization) -gt 0)
        {
            $partialContent = $partialContent -ireplace [regex]::Escape($organization), "`$(`$ConfigurationData.NonNodeData.OrganizationName)"
        }
        $DSCContent += $partialContent
    }
    #endregion

    #region "EXOSharedMailbox"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOSharedMailbox")) -or
        $AllComponents)
    {
        Write-Information "Extracting EXOSharedMailbox..."
        $EXOSharedMailboxModulePath = Join-Path -Path $PSScriptRoot `
                                                -ChildPath "..\DSCResources\MSFT_EXOSharedMailbox\MSFT_EXOSharedMailbox.psm1" `
                                                -Resolve

        Import-Module $EXOSharedMailboxModulePath | Out-Null
        Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
        $mailboxes = Get-Mailbox
        $mailboxes = $mailboxes | Where-Object -FilterScript { $_.RecipientTypeDetails -eq "SharedMailbox" }

        $i = 1
        $total = $mailboxes.Length
        if ($null -eq $total -and $null -ne $mailboxes)
        {
            $total = 1
        }
        foreach ($mailbox in $mailboxes)
        {
            Write-Information "    - [$i/$total] $($mailbox.Name)"
            $mailboxName = $mailbox.Name
            if ($mailboxName)
            {
                $DSCContent += Export-TargetResource -DisplayName $mailboxName -GlobalAdminAccount $GlobalAdminAccount
            }
            $i++
        }
    }
    #endregion

    #region "O365User"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckO365User")) -or
        $AllComponents)
    {
        Write-Information "Extracting O365User..."
        $O365UserModulePath = Join-Path -Path $PSScriptRoot `
                                        -ChildPath "..\DSCResources\MSFT_O365USer\MSFT_O365USer.psm1" `
                                        -Resolve

        Import-Module $O365UserModulePath | Out-Null
        Connect-MsolService -Credential $GlobalAdminAccount

        $users = Get-MsolUser
        $partialContent = ""
        $i = 1
        foreach ($user in $users)
        {
            Write-Information "    - [$i/$($users.Length)] $($user.UserPrincipalName)"
            $userUPN = $user.UserPrincipalName
            if ($userUPN)
            {
                $partialContent = Export-TargetResource -UserPrincipalName $userUPN -GlobalAdminAccount $GlobalAdminAccount
                if ($partialContent.ToLower().IndexOf($organization) -gt 0)
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape($organization), "`$(`$ConfigurationData.NonNodeData.OrganizationName)"
                }
                if ($partialContent.ToLower().IndexOf($organization) -gt 0)
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape($organization + ":"), "`$(`$ConfigurationData.NonNodeData.OrganizationName):"
                    $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$(`$ConfigurationData.NonNodeData.OrganizationName)"
                }
                $DSCContent += $partialContent
            }
            $i++
        }
    }
    #endregion

    #region "O365Group"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckO365Group")) -or
        $AllComponents)
    {
        Write-Information "Extracting O365Group..."
        $O365GroupModulePath = Join-Path -Path $PSScriptRoot `
                                         -ChildPath "..\DSCResources\MSFT_O365Group\MSFT_O365Group.psm1" `
                                         -Resolve

        Import-Module $O365GroupModulePath | Out-Null

        # Other Groups
        Connect-AzureAD -Credential $GlobalAdminAccount
        $groups = Get-AzureADGroup | Where-Object -FilterScript {
                                         $_.MailNickName -ne "00000000-0000-0000-0000-000000000000"
                                     }

        $i = 1
        foreach ($group in $groups)
        {
            $partialContent = ""
            Write-Information "    - [$i/$($groups.Length)] $($group.DisplayName)"
            $partialContent += Export-TargetResource -DisplayName $group.DisplayName `
                                                 -ManagedBy "DummyUser" `
                                                 -MailNickName $group.MailNickName `
                                                 -GlobalAdminAccount $GlobalAdminAccount
            if ($partialContent.ToLower().IndexOf($organization) -gt 0)
            {
                $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$(`$ConfigurationData.NonNodeData.OrganizationName)"
            }
            $DSCContent += $partialContent
            $i++
        }
    }
    #endregion

    #region "EXOMailboxSettings"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOMailboxSettings")) -or
        $AllComponents)
    {
        Write-Information "Extracting EXOMailboxSettings..."
        $EXOMailboxSettingsModulePath = Join-Path -Path $PSScriptRoot `
                                                  -ChildPath "..\DSCResources\MSFT_EXOMailboxSettings\MSFT_EXOMailboxSettings.psm1" `
                                                  -Resolve

        Import-Module $EXOMailboxSettingsModulePath | Out-Null
        Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
        $mailboxes = Get-Mailbox

        $i = 1
        foreach ($mailbox in $mailboxes)
        {
            Write-Information "    - [$i/$($mailboxes.Length)] $($mailbox.Name)"
            $mailboxName = $mailbox.Name
            if ($mailboxName)
            {
                $DSCContent += Export-TargetResource -DisplayName $mailboxName -GlobalAdminAccount $GlobalAdminAccount
            }
            $i++
        }
    }
    #endregion

    #region "ODSettings"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckODSettings")) -or
        $AllComponents)
    {
        Write-Information "Extracting ODSettings..."
        $ODSettingsModulePath = Join-Path -Path $PSScriptRoot `
                                        -ChildPath "..\DSCResources\MSFT_ODSettings\MSFT_ODSettings.psm1" `
                                        -Resolve

        Import-Module $ODSettingsModulePath | Out-Null
        $partialContent = ""
        if ($centralAdminUrl)
        {
            $partialContent = Export-TargetResource -CentralAdminUrl $centralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
            if ($partialContent.ToLower().Contains($centralAdminUrl.ToLower()))
            {
                $partialContent = $partialContent -ireplace [regex]::Escape("`"" + $centralAdminUrl + "`""), "`$ConfigurationData.NonNodeData.OrganizationName + `"-admin.sharepoint.com`""
            }
            $DSCContent += $partialContent
        }
    }
    #endregion

    $NeedToConnectToSecurityAndCompliance = $false
    foreach ($Component in $ComponentsToExtract)
    {
        if ($Component -like 'chckSC*')
        {
            $NeedToConnectToSecurityAndCompliance = $true
            break
        }
    }
    if ($NeedToConnectToSecurityAndCompliance -or $AllComponents)
    {
        Test-SecurityAndComplianceConnection -GlobalAdminAccount $GlobalAdminAccount
    }

    #region "SCRetentionCompliancePolicy"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSCRetentionCompliancePolicy")) -or
        $AllComponents)
    {
        Write-Information "Extracting SCRetentionCompliancePolicy..."
        $SCRetentionCompliancePolicyModulePath = Join-Path -Path $PSScriptRoot `
                                        -ChildPath "..\DSCResources\MSFT_SCRetentionCompliancePolicy\MSFT_SCRetentionCompliancePolicy.psm1" `
                                        -Resolve

        Import-Module $SCRetentionCompliancePolicyModulePath | Out-Null
        $policies = Get-RetentionCompliancePolicy

        $i = 1
        foreach ($policy in $policies)
        {
            Write-Information "    - [$i/$($policies.Length)] $($policy.Name)"
            $partialContent = Export-TargetResource -Name $policy.Name -GlobalAdminAccount $GlobalAdminAccount
            $DSCContent += $partialContent
            $i++
        }
    }
    #endregion

    #region "SCRetentionComplianceRule"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSCRetentionComplianceRule")) -or
        $AllComponents)
    {
        Write-Information "Extracting SCRetentionComplianceRule..."
        $SCRetentionComplianceRuleModulePath = Join-Path -Path $PSScriptRoot `
                                            -ChildPath "..\DSCResources\MSFT_SCRetentionComplianceRule\MSFT_SCRetentionComplianceRule.psm1" `
                                            -Resolve

        Import-Module $SCRetentionComplianceRuleModulePath | Out-Null
        $rules = Get-RetentionComplianceRule

        $i = 1
        foreach ($rule in $rules)
        {
            Write-Information "    - [$i/$($rules.Length)] $($rule.Name)"
            $partialContent = Export-TargetResource -Name $rule.Name -Policy $rule.Policy -GlobalAdminAccount $GlobalAdminAccount
            $DSCContent += $partialContent
            $i++
        }
    }
    #endregion

    #region SPOApp
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOApp")) -or
        $AllComponents)
    {
        Write-Information "Extracting SPOApp..."
        $SPOAppModulePath = Join-Path -Path $PSScriptRoot `
                                                     -ChildPath "..\DSCResources\MSFT_SPOApp\MSFT_SPOApp.psm1" `
                                                     -Resolve

        Import-Module $SPOAppModulePath | Out-Null
        Test-PnPOnlineConnection -SiteUrl $centralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
        try
        {
            $tenantAppCatalogUrl = Get-PnPTenantAppCatalogUrl
            Test-PnPOnlineConnection -SiteUrl $tenantAppCatalogUrl -GlobalAdminAccount $GlobalAdminAccount

            $spfxFiles = Find-PnPFile -List "AppCatalog" -Match '*.sppkg'
            $appFiles = Find-PnPFile -List "AppCatalog" -Match '*.app'
            $allFiles = $spfxFiles + $appFiles
            $tenantAppCatalogPath = $tenantAppCatalogUrl.Replace("https://", "")
            $tenantAppCatalogPath = $tenantAppCatalogPath.Replace($tenantAppCatalogPath.Split('/')[0], "")

            $partialContent = ""
            $i = 1
            foreach ($file in $allFiles)
            {
                Write-Information "    - [$i/$($allFiles.Length)] $($file.Name)"
                $filesToDownload += @{Name = $file.Name; Site = $tenantAppCatalogUrl}

                $identity = $file.Name.ToLower().Replace(".app", "").Replace(".sppkg", "")
                $app = Get-PnpApp -Identity $identity -ErrorAction SilentlyContinue

                if ($null -ne $app)
                {
                    $partialContent = Export-TargetResource -Identity $identity `
                                                            -Path ("`$(`$ConfigurationData.NonNodeData.AppsLocation)" + $file.Name) `
                                                            -CentralAdminUrl $centralAdminUrl `
                                                            -GlobalAdminAccount $GlobalAdminAccount
                }
                else
                {
                    # Case - Where file name doesn't match the App's Title in the catalog
                    $app = Get-PnpApp -Identity $file.Title -ErrorAction SilentlyContinue

                    $partialContent = Export-TargetResource -Identity $app.Title `
                                                            -Path ("`$(`$ConfigurationData.NonNodeData.AppsLocation)" + $file.Name) `
                                                            -CentralAdminUrl $centralAdminUrl `
                                                            -GlobalAdminAccount $GlobalAdminAccount
                }

                if ($partialContent.ToLower().Contains($centralAdminUrl.ToLower()))
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape('"' + $centralAdminUrl + '"'), "`$ConfigurationData.NonNodeData.OrganizationName + `"-admin.sharepoint.com`""
                }
                $DSCContent += $partialContent
                $i++
            }

            Test-PnPOnlineConnection -SiteUrl $tenantAppCatalogUrl -GlobalAdminAccount $GlobalAdminAccount
            foreach ($file in $allFiles)
            {
                $appInstanceUrl = $tenantAppCatalogPath + "/AppCatalog/" + $file.Name
                $fileName = $appInstanceUrl.Split('/')[$appInstanceUrl.Split('/').Length -1]
                Get-PnPFile -Url $appInstanceUrl -Path $env:Temp -Filename $fileName -AsFile | Out-Null
            }
        }
        catch
        {
            Write-Information "    * App Catalog is not configured on tenant. Cannot extract information about SharePoint apps."
        }
    }
    #endregion

    #region "SPOSite"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOSite")) -or
        $AllComponents)
    {
        Write-Information "Extracting SPOSite..."
        $SPOSiteModulePath = Join-Path -Path $PSScriptRoot `
                                       -ChildPath "..\DSCResources\MSFT_SPOSite\MSFT_SPOSite.psm1" `
                                       -Resolve

        Import-Module $SPOSiteModulePath | Out-Null

        Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
        $invalidTemplates = @("SRCHCEN#0", "GROUP#0", "SPSMSITEHOST#0", "POINTPUBLISHINGHUB#0", "POINTPUBLISHINGTOPIC#0")
        $sites = Get-SPOSite -Limit All | Where-Object -FilterScript { $_.Template -notin $invalidTemplates }

        $partialContent = ""
        $i = 1
        foreach ($site in $sites)
        {
            Write-Information "    - [$i/$($sites.Length)] $($site.Url)"
            $partialContent = Export-TargetResource -Url $site.Url `
                                                    -CentralAdminUrl $centralAdminUrl `
                                                    -GlobalAdminAccount $GlobalAdminAccount

            if ($partialContent.ToLower().Contains($centralAdminUrl.ToLower()))
            {
                $partialContent = $partialContent -ireplace [regex]::Escape('"' + $centralAdminUrl + '"'), "`$ConfigurationData.NonNodeData.OrganizationName + `"-admin.sharepoint.com`""
                $partialContent = $partialContent -ireplace [regex]::Escape($organization), "`$(`$ConfigurationData.NonNodeData.OrganizationName)"
            }
            $DSCContent += $partialContent
            $i++
        }
    }
    #endregion

    #region "SPOHubSite"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOHubSite")) -or
        $AllComponents)
    {
        Write-Information "Extracting SPOHubSite..."
        $SPOHubSiteModulePath = Join-Path -Path $PSScriptRoot `
                                        -ChildPath "..\DSCResources\MSFT_SPOHubSite\MSFT_SPOHubSite.psm1" `
                                        -Resolve

        Import-Module $SPOHubSiteModulePath | Out-Null
        $partialContent = ""
        if ($centralAdminUrl)
        {
            Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
            $hubSites = Get-SPOHubSite

            $i = 1
            foreach ($hub in $hubSites)
            {
                Write-Information "    - [$i/$($hubSites.Length)] $($hub.SiteUrl)"
                $partialContent = Export-TargetResource -Url $hub.SiteUrl -CentralAdminUrl $centralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
                if ($partialContent.ToLower().Contains($centralAdminUrl.ToLower()))
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape("`"" + $centralAdminUrl + "`""), "`$ConfigurationData.NonNodeData.OrganizationName + `"-admin.sharepoint.com`""
                    $partialContent = $partialContent -ireplace [regex]::Escape('https://' + $principal + '.sharepoint.com/'), "https://`$(`$ConfigurationData.NonNodeData.OrganizationName.Split('.')[0]).sharepoint.com/"
                }
                $DSCContent += $partialContent
                $i++
            }
        }
    }
    #endregion

    #region "SPOSearchResultSource"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOSearchResultSource")) -or
        $AllComponents)
    {
        $InfoMapping = @(
        @{
            Protocol    = "Local"
            Type        = "SharePoint"
            ProviderID  = "fa947043-6046-4f97-9714-40d4c113963d"
        },
        @{
            Protocol    = "Remote"
            Type        = "SharePoint"
            ProviderID  = "1e0c8601-2e5d-4ccb-9561-53743b5dbde7"
        },
        @{
            Protocol    = "Exchange"
            Type        = "SharePoint"
            ProviderID  = "3a17e140-1574-4093-bad6-e19cdf1c0122"
        },
        @{
            Protocol    = "OpenSearch"
            Type        = "SharePoint"
            ProviderID  = "3a17e140-1574-4093-bad6-e19cdf1c0121"
        },
        @{
            Protocol   = "Local"
            Type       = "People"
            ProviderID = "e4bcc058-f133-4425-8ffc-1d70596ffd33"
        },
        @{
            Protocol   = "Remote"
            Type       = "People"
            ProviderID = "e377caaa-fcaf-4a1b-b7a1-e69a506a07aa"
        }
        )
        Write-Information "Extracting SPOSearchResultSource..."
        $SPOSearchResultSourceModulePath = Join-Path -Path $PSScriptRoot `
                                                        -ChildPath "..\DSCResources\MSFT_SPOSearchResultSource\MSFT_SPOSearchResultSource.psm1" `
                                                        -Resolve

        Import-Module $SPOSearchResultSourceModulePath | Out-Null
        Test-PnPOnlineConnection -SiteUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
        $SearchConfig = [Xml] (Get-PnPSearchConfiguration -Scope Subscription)
        $sources =  $SearchConfig.SearchConfigurationSettings.SearchQueryConfigurationSettings.SearchQueryConfigurationSettings.Sources.Source

        $partialContent = ""
        $i = 1
        foreach ($source in $sources)
        {
            $mapping = $InfoMapping | Where-Object -FilterScript { $_.ProviderID -eq $source.ProviderId }
            Write-Information "    - [$i/$($sources.Length)] $($source.Name)"
            $partialContent = Export-TargetResource -Name $source.Name `
                                                    -Protocol $mapping.Protocol `
                                                    -CentralAdminUrl $centralAdminUrl `
                                                    -GlobalAdminAccount $GlobalAdminAccount

            if ($partialContent.ToLower().Contains($centralAdminUrl.ToLower()))
            {
                $partialContent = $partialContent -ireplace [regex]::Escape('"' + $centralAdminUrl + '"'), "`$ConfigurationData.NonNodeData.OrganizationName + `"-admin.sharepoint.com`""
            }
            $DSCContent += $partialContent
            $i++
        }
    }
    #endregion

    #region "SPOSearchManagedProperty"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOSearchManagedProperty")) -or
        $AllComponents)
    {
        Write-Information "Extracting SPOSearchManagedProperty..."
        $SPOSearchManagedPropertyModulePath = Join-Path -Path $PSScriptRoot `
                                                        -ChildPath "..\DSCResources\MSFT_SPOSearchManagedProperty\MSFT_SPOSearchManagedProperty.psm1" `
                                                        -Resolve

        Import-Module $SPOSearchManagedPropertyModulePath | Out-Null
        Test-PnPOnlineConnection -SiteUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
        $SearchConfig = [Xml] (Get-PnPSearchConfiguration -Scope Subscription)
        $properties =  $SearchConfig.SearchConfigurationSettings.SearchSchemaConfigurationSettings.ManagedProperties.dictionary.KeyValueOfstringManagedPropertyInfoy6h3NzC8

        $partialContent = ""
        $i = 1
        foreach ($property in $properties)
        {
            Write-Information "    - [$i/$($properties.Length)] $($property.Value.Name)"
            $partialContent = Export-TargetResource -Name $property.Value.Name `
                                                    -Type $property.Value.ManagedType `
                                                    -CentralAdminUrl $centralAdminUrl `
                                                    -GlobalAdminAccount $GlobalAdminAccount

            if ($partialContent.ToLower().Contains($centralAdminUrl.ToLower()))
            {
                $partialContent = $partialContent -ireplace [regex]::Escape('"' + $centralAdminUrl + '"'), "`$ConfigurationData.NonNodeData.OrganizationName + `"-admin.sharepoint.com`""
            }
            $DSCContent += $partialContent
            $i++
        }
    }
    #endregion

    #region SPOSiteDesign
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOSiteDesign")) -or
        $AllComponents)
    {
        Write-Information "Extracting SPOSiteDesign..."
        $SPOSiteDesignModulePath = Join-Path -Path $PSScriptRoot `
                                                        -ChildPath "..\DSCResources\MSFT_SPOSiteDesign\MSFT_SPOSiteDesign.psm1" `
                                                        -Resolve

        Import-Module $SPOSiteDesignModulePath | Out-Null
        Test-PnPOnlineConnection -SiteUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

        $siteDesigns = Get-PnPSiteDesign

        $partialContent = ""
        $i = 1
        foreach ($siteDesign in $siteDesigns)
        {
            Write-Information "    - [$i/$($siteDesigns.Length)] $($siteDesign.Title)"
            $partialContent = Export-TargetResource -Title $siteDesign.Title `
                                                    -CentralAdminUrl $centralAdminUrl `
                                                    -GlobalAdminAccount $GlobalAdminAccount

            if ($partialContent.ToLower().Contains($centralAdminUrl.ToLower()))
            {
                $partialContent = $partialContent -ireplace [regex]::Escape('"' + $centralAdminUrl + '"'), "`$ConfigurationData.NonNodeData.OrganizationName + `"-admin.sharepoint.com`""
            }
            $DSCContent += $partialContent
            $i++
        }
    }
    #endregion

    #region SPOSiteDesignRights
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOSiteDesignRights")) -or
        $AllComponents)
    {
        Write-Information "Extracting SPOSiteDesignRights..."
        $SPOSiteDesignModulePath = Join-Path -Path $PSScriptRoot `
                                                        -ChildPath "..\DSCResources\MSFT_SPOSiteDesignRights\MSFT_SPOSiteDesignRights.psm1" `
                                                        -Resolve

        Import-Module $SPOSiteDesignModulePath | Out-Null
        Test-PnPOnlineConnection -SiteUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

        $siteDesigns = Get-PnPSiteDesign

        $partialContent = ""
        $i = 1
        foreach ($siteDesign in $siteDesigns)
        {
            Write-Information "    - [$i/$($siteDesigns.Length)] $($siteDesign.Title)"
            $partialContent += Export-TargetResource -SiteDesignTitle $siteDesign.Title `
                                                 -CentralAdminUrl $centralAdminUrl `
                                                 -GlobalAdminAccount $GlobalAdminAccount

            if ($partialContent.ToLower().Contains($centralAdminUrl.ToLower()))
            {
                $partialContent = $partialContent -ireplace [regex]::Escape('"' + $centralAdminUrl + '"'), "`$ConfigurationData.NonNodeData.OrganizationName + `"-admin.sharepoint.com`""
            }
            $DSCContent += $partialContent
            $i++
        }
    }
    #endregion

    #region SPOStorageEntity
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOStorageEntity")) -or
        $AllComponents)
    {
        Write-Information "Extracting SPOStorageEntity..."
        $SPOModulePath = Join-Path -Path $PSScriptRoot `
                                    -ChildPath "..\DSCResources\MSFT_SPOStorageEntity\MSFT_SPOStorageEntity.psm1" `
                                    -Resolve

        Import-Module $SPOModulePath | Out-Null

        Test-PnPOnlineConnection -SiteUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

        $storageEntities = Get-PnPStorageEntity

        foreach ($storageEntity in $storageEntities)
        {
            Write-Information "    Storage Entity {$($storageEntity.Key)}"
            $DSCContent += Export-TargetResource -Key $storageEntity.Key `
                                                -CentralAdminUrl $centralAdminUrl `
                                                -GlobalAdminAccount $GlobalAdminAccount
        }
    }
    #endregion

    $NeedToConnectToTeams = $false
    foreach ($Component in $ComponentsToExtract)
    {
        if ($Component -like 'chckTeams*')
        {
            $NeedToConnectToTeams = $true
            break
        }
    }
    if ($NeedToConnectToTeams -or $AllComponents)
    {
        Test-TeamsServiceConnection -GlobalAdminAccount $GlobalAdminAccount
        $Teams = Get-Team
    }

    #region "TeamsTeam"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckTeamsTeam")) -or
        $AllComponents)
    {
        Write-Information "Extracting TeamsTeam..."
        $TeamsModulePath = Join-Path -Path $PSScriptRoot `
                                    -ChildPath "..\DSCResources\MSFT_TeamsTeam\MSFT_TeamsTeam.psm1" `
                                    -Resolve

        Import-Module $TeamsModulePath | Out-Null

        $i = 1
        foreach ($team in $teams)
        {
            Write-Information "    - [$i/$($teams.Length)] $($team.DisplayName)"
            $DSCContent += Export-TargetResource -DisplayName $team.DisplayName `
                                                 -GlobalAdminAccount $GlobalAdminAccount
            $i++
        }
    }
    #endregion

    #region "TeamsChannel"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckTeamsChannel")) -or
        $AllComponents)
    {
        Write-Information "Extracting TeamsChannel..."
        $TeamsChannelModulePath = Join-Path -Path $PSScriptRoot `
                                        -ChildPath "..\DSCResources\MSFT_TeamsChannel\MSFT_TeamsChannel.psm1" `
                                        -Resolve

        Import-Module $TeamsChannelModulePath | Out-Null
        $j = 1
        foreach ($team in $Teams)
        {
            $channels = Get-TeamChannel -GroupId $team.GroupId
            $i = 1
            Write-Information "    > [$j/$($Teams.Length)] Team {$($team.DisplayName)}"
            foreach ($channel in $channels)
            {
                Write-Information "        - [$i/$($channels.Length)] $($channel.DisplayName)"
                $DSCContent += Export-TargetResource -TeamName $team.DisplayName `
                                                     -DisplayName $channel.DisplayName `
                                                     -GlobalAdminAccount $GlobalAdminAccount
                $i++
            }
            $j++
        }
    }
    #endregion

    #region "TeamsUser"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckTeamsUser")) -or
        $AllComponents)
    {
        Write-Information "Extracting TeamsUser..."
        $TeamsModulePath = Join-Path -Path $PSScriptRoot `
                                        -ChildPath "..\DSCResources\MSFT_TeamsUser\MSFT_TeamsUser.psm1" `
                                        -Resolve

        Import-Module $TeamsModulePath | Out-Null
        $j = 1
        foreach ($team in $Teams)
        {
            try
            {
                $users = Get-TeamUser -GroupId $team.GroupId
                $i = 1
                Write-Information "    > [$j/$($Teams.Length)] Team {$($team.DisplayName)}"
                foreach ($user in $users)
                {
                    Write-Information "        - [$i/$($users.Length)] $($user.User)"
                    $partialContent = Export-TargetResource -TeamName $team.DisplayName `
                                                        -User $user.User `
                                                        -GlobalAdminAccount $GlobalAdminAccount
                    if ($partialContent.ToLower().Contains($principal.ToLower()))
                    {
                        $partialContent = $partialContent -ireplace [regex]::Escape($organization), "`$(`$ConfigurationData.NonNodeData.OrganizationName)"
                    }
                    $DSCContent += $partialContent
                    $i++
                }
            }
            catch
            {
                Write-Information "The current User doesn't have the required permissions to extract Users for Team {$($team.DisplayName)}."
            }
            $j++
        }
    }
    #endregion

    # Close the Node and Configuration declarations
    $DSCContent += "    }`r`n"
    $DSCContent += "}`r`n"

    #region Add the Prompt for Required Credentials at the top of the Configuration
    $credsContent = ""
    foreach ($credential in $Global:CredsRepo)
    {
        if (!$credential.ToLower().StartsWith("builtin"))
        {
            if (!$AzureAutomation)
            {
                $credsContent += "    " + (Resolve-Credentials $credential) + " = Get-Credential -Message `"Global Admin credentials`"`r`n"
            }
            else
            {
                $resolvedName = (Resolve-Credentials $credential)
                $credsContent += "    " + $resolvedName + " = Get-AutomationPSCredential -Name " + ($resolvedName.Replace("$", "")) + "`r`n"
            }
        }
    }
    $credsContent += "`r`n"
    $startPosition = $DSCContent.IndexOf("<# Credentials #>") + 19
    $DSCContent = $DSCContent.Insert($startPosition, $credsContent)
    $DSCContent += "O365TenantConfig -ConfigurationData .\ConfigurationData.psd1"
    #endregion

    #region Prompt the user for a location to save the extract and generate the files
    if ($null -eq $Path)
    {
        $OutputDSCPath = Read-Host "Destination Path"
    }
    else
    {
        $OutputDSCPath = $Path
    }

    while ((Test-Path -Path $OutputDSCPath -PathType Container -ErrorAction SilentlyContinue) -eq $false)
    {
        try
        {
            Write-Information "Directory `"$OutputDSCPath`" doesn't exist; creating..."
            New-Item -Path $OutputDSCPath -ItemType Directory | Out-Null
            if ($?) {break}
        }
        catch
        {
            Write-Warning "$($_.Exception.Message)"
            Write-Warning "Could not create folder $OutputDSCPath!"
        }
        $OutputDSCPath = Read-Host "Please Provide Output Folder for DSC Configuration (Will be Created as Necessary)"
    }
    <## Ensures the path we specify ends with a Slash, in order to make sure the resulting file path is properly structured. #>
    if (!$OutputDSCPath.EndsWith("\") -and !$OutputDSCPath.EndsWith("/"))
    {
        $OutputDSCPath += "\"
    }
    #endregion

    #region Copy Downloaded files back into output folder
    if ($filesToDownload.Count -gt 0)
    {
        Add-ConfigurationDataEntry -Node "NonNodeData" `
                                   -Key "AppsLocation" `
                                   -Value $OutputDSCPath `
                                   -Description "Location of the .app and .sppkg packages"
        foreach ($fileToCopy in $filesToDownload)
        {
            $filePath = Join-Path $env:Temp $fileToCopy.Name -Resolve
            $destPath = Join-Path $OutputDSCPath $fileToCopy.Name
            Copy-Item -Path $filePath -Destination $destPath
        }
    }
    #endregion

    $outputDSCFile = $OutputDSCPath + "Office365TenantConfig.ps1"
    $DSCContent | Out-File $outputDSCFile

    if (!$AzureAutomation)
    {
        $outputConfigurationData = $OutputDSCPath + "ConfigurationData.psd1"
        New-ConfigurationDataDocument -Path $outputConfigurationData
    }
    Invoke-Item -Path $OutputDSCPath
}
