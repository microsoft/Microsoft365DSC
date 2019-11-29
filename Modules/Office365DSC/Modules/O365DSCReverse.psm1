function Start-O365ConfigurationExtract
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter()]
        [Switch]
        $Quiet,

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
        $Path,

        [Parameter()]
        [System.String]
        $FileName,

        [Parameter()]
        [ValidateRange(1,100)]
        $MaxProcesses,

        [Parameter()]
        [ValidateSet('SPO','EXO','SC','OD','O365','TEAMS')]
        [System.String[]]
        $Workloads
    )

    $organization = ""
    $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the O365DSC part of O365DSC.onmicrosoft.com)
    if ($GlobalAdminAccount.UserName.Contains("@"))
    {
        $organization = $GlobalAdminAccount.UserName.Split("@")[1]

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

    $DSCContent = "param (`r`n"
    $DSCContent += "    [parameter()]`r`n"
    $DSCContent += "    [System.Management.Automation.PSCredential]`r`n"
    $DSCContent += "    `$GlobalAdminAccount`r`n"
    $DSCContent += ")`r`n`r`n"

    $ConfigName = "O365TenantConfig"
    if (-not [System.String]::IsNullOrEmpty($FileName))
    {
        $FileParts = $FileName.Split('.')
        $ConfigName = $FileName.Replace('.' + $FileParts[$FileParts.Length -1], "")
    }
    $DSCContent += "Configuration $ConfigName`r`n{`r`n"
    $DSCContent += "    param (`r`n"
    $DSCContent += "        [parameter()]`r`n"
    $DSCContent += "        [System.Management.Automation.PSCredential]`r`n"
    $DSCContent += "        `$GlobalAdminAccount`r`n"
    $DSCContent += "    )`r`n`r`n"
    $DSCContent += "    Import-DSCResource -ModuleName Office365DSC`r`n`r`n"
    $DSCContent += "    if (`$null -eq `$GlobalAdminAccount)`r`n"
    $DSCContent += "    {`r`n"
    $DSCContent += "        <# Credentials #>`r`n"
    $DSCContent += "    }`r`n"
    $DSCContent += "    else`r`n"
    $DSCContent += "    {`r`n"
    $DSCContent += "        `$Credsglobaladmin = `$GlobalAdminAccount`r`n"
    $DSCContent += "    }`r`n`r`n"
    $DSCContent += "    `$OrganizationName = `$Credsglobaladmin.UserName.Split('@')[1]`r`n"
    $DSCContent += "    Node localhost`r`n"
    $DSCContent += "    {`r`n"

    Add-ConfigurationDataEntry -Node "localhost" `
                                   -Key "ServerNumber" `
                                   -Value "0" `
                                   -Description "Default Value Used to Ensure a Configuration Data File is Generated"

    # Obtain central administration url from a User Principal Name
    $centralAdminUrl = Get-SPOAdministrationUrl -GlobalAdminAccount $GlobalAdminAccount

    # Add the GlobalAdminAccount to the Credentials List
    Save-Credentials -UserName "globaladmin"

    #region "O365AdminAuditLogConfig"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckO365AdminAuditLogConfig")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("O365")))
    {
        Write-Information "Extracting O365AdminAuditLogConfig..."
        try
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform ExchangeOnline `
                              -ErrorAction SilentlyContinue

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
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "EXOAcceptedDomain"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOAcceptedDomain")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        Write-Information "Extracting EXOAcceptedDomain..."

        $ModulePath = Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\DSCResources\MSFT_EXOAcceptedDomain\MSFT_EXOAcceptedDomain.psm1" `
                                -Resolve

        Import-Module $ModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "EXOAntiPhishPolicy"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOAntiPhishPolicy")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        Write-Information "Extracting EXOAntiPhishPolicy..."

        $ModulePath = Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\DSCResources\MSFT_EXOAntiPhishPolicy\MSFT_EXOAntiPhishPolicy.psm1" `
                                -Resolve

        Import-Module $ModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "EXOAntiPhishRule"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOAntiPhishRule")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        Write-Information "Extracting EXOAntiPhishRule..."

        $ModulePath = Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\DSCResources\MSFT_EXOAntiPhishRule\MSFT_EXOAntiPhishRule.psm1" `
                                -Resolve

        Import-Module $ModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "EXOOrganizationConfig"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOOrganizationConfig")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        Write-Information "Extracting EXOOrganizationConfig..."
        try
        {
            $ModulePath = Join-Path -Path $PSScriptRoot `
                                    -ChildPath "..\DSCResources\MSFT_EXOOrganizationConfig\MSFT_EXOOrganizationConfig.psm1" `
                                    -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }

    #region "EXOAtpPolicyForO365"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOAtpPolicyForO365")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        try
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform ExchangeOnline `
                              -ErrorAction SilentlyContinue

            if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-AtpPolicyForO365)
            {
                Write-Information "Extracting EXOAtpPolicyForO365..."
                $EXOAtpPolicyForO365ModulePath = Join-Path -Path $PSScriptRoot `
                                                        -ChildPath "..\DSCResources\MSFT_EXOAtpPolicyForO365\MSFT_EXOAtpPolicyForO365.psm1" `
                                                        -Resolve

                Import-Module $EXOAtpPolicyForO365ModulePath | Out-Null

                $ATPPolicies = Get-AtpPolicyForO365
                foreach ($atpPolicy in $ATPPolicies)
                {
                    $partialContent = Export-TargetResource -IsSingleInstance "Yes" `
                                                            -GlobalAdminAccount $GlobalAdminAccount `
                                                            -Identity $atpPolicy.Identity

                    if ($partialContent.ToLower().IndexOf($organization.ToLower()) -gt 0)
                    {
                        $partialContent = $partialContent -ireplace [regex]::Escape($organization), "`$OrganizationName"
                    }
                    $DSCContent += $partialContent
                }
            }
            else
            {
                Write-Warning "The specified Tenant is not registered for ATP, and therefore can't extract policies"
            }
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "EXOCASMailboxPlan"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOCASMailboxPlan")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        Write-Information "Extracting EXOCASMailboxPlan..."
        try
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform ExchangeOnline `
                              -ErrorAction SilentlyContinue

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
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "EXOClientAccessRule"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOClientAccessRule")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        Write-Information "Extracting EXOClientAccessRule..."
        try
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform ExchangeOnline `
                              -ErrorAction SilentlyContinue

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
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "EXODkimSigningConfig"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXODkimSigningConfig")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        Write-Information "Extracting EXODkimSigningConfig..."
        try
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform ExchangeOnline `
                              -ErrorAction SilentlyContinue

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
                if ($partialContent.ToLower().IndexOf($organization.ToLower()) -gt 0)
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape($organization), "`$OrganizationName"
                }
                if ($partialContent.ToLower().IndexOf($principal.ToLower() + ".") -gt 0)
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape($principal + "."), "`$(`$OrganizationName.Split('.')[0])."
                }
                $DSCContent += $partialContent
                $i++
            }
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "EXOHostedConnectionFilterPolicy"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOHostedConnectionFilterPolicy")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        Write-Information "Extracting EXOHostedConnectionFilterPolicy..."
        try
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform ExchangeOnline `
                              -ErrorAction SilentlyContinue

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
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "EXOHostedContentFilterPolicy"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOHostedContentFilterPolicy")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        Write-Information "Extracting EXOHostedContentFilterPolicy..."
        try
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform ExchangeOnline `
                              -ErrorAction SilentlyContinue
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
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "EXOHostedContentFilterRule"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOHostedContentFilterRule")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        Write-Information "Extracting EXOHostedContentFilterRule..."
        try
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform ExchangeOnline `
                              -ErrorAction SilentlyContinue

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
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "EXOHostedOutboundSpamFilterPolicy"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOHostedOutboundSpamFilterPolicy")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        Write-Information "Extracting EXOHostedOutboundSpamFilterPolicy..."
        try
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform ExchangeOnline `
                              -ErrorAction SilentlyContinue

            $EXOHostedOutboundSpamFilterPolicyModulePath = Join-Path -Path $PSScriptRoot `
                                                        -ChildPath "..\DSCResources\MSFT_EXOHostedOutboundSpamFilterPolicy\MSFT_EXOHostedOutboundSpamFilterPolicy.psm1" `
                                                        -Resolve

            Import-Module $EXOHostedOutboundSpamFilterPolicyModulePath | Out-Null
            $DSCContent += Export-TargetResource -IsSingleInstance "Yes" -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "EXOSafeAttachmentPolicy"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOSafeAttachmentPolicy")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        try
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform ExchangeOnline `
                              -ErrorAction SilentlyContinue

            if (Confirm-ImportedCmdletIsAvailable -CmdletName 'Get-SafeAttachmentPolicy')
            {
                Write-Information "Extracting EXOSafeAttachmentPolicy..."
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
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "EXOSafeAttachmentRule"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOSafeAttachmentRule")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        try
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform ExchangeOnline `
                              -ErrorAction SilentlyContinue

            if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-SafeAttachmentRule)
            {
                Write-Information "Extracting EXOSafeAttachmentRule..."
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
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "EXOSafeLinksPolicy"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOSafeLinksPolicy")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        try
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform ExchangeOnline `
                              -ErrorAction SilentlyContinue

            if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-SafeAttachmentRule)
            {
                Write-Information "Extracting EXOSafeLinksPolicy..."
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
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "EXOSafeLinksRule"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOSafeLinksRule")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        try
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform ExchangeOnline `
                              -ErrorAction SilentlyContinue

            if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-SafeAttachmentRule)
            {
                Write-Information "Extracting EXOSafeLinksRule..."
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
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "EXOMailTips"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOMailTips")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        Write-Information "Extracting EXOMailTips..."
        try
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform ExchangeOnline `
                              -ErrorAction SilentlyContinue

            $OrgConfig = Get-OrganizationConfig
            $organizationName = $OrgConfig.Name

            $EXOMailTipsModulePath = Join-Path -Path $PSScriptRoot `
                                            -ChildPath "..\DSCResources\MSFT_EXOMailTips\MSFT_EXOMailTips.psm1" `
                                            -Resolve

            Import-Module $EXOMailTipsModulePath | Out-Null
            $partialContent = Export-TargetResource -Organization $organizationName -GlobalAdminAccount $GlobalAdminAccount
            if ($partialContent.ToLower().IndexOf($organization.ToLower()) -gt 0)
            {
                $partialContent = $partialContent -ireplace [regex]::Escape("`"" + $organization + "`""), "`$OrganizationName"
            }
            if ($partialContent.ToLower().IndexOf($organization.ToLower()) -gt 0)
            {
                $partialContent = $partialContent -ireplace [regex]::Escape($organization), "`$OrganizationName"
            }
            if ($partialContent.ToLower().IndexOf($principal.ToLower() + ".") -gt 0)
            {
                $partialContent = $partialContent -ireplace [regex]::Escape($principal + "."), "`$(`$OrganizationName.Split('.')[0])."
            }
            $DSCContent += $partialContent
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "EXOSharedMailbox"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOSharedMailbox")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        Write-Information "Extracting EXOSharedMailbox..."
        try
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform ExchangeOnline `
                              -ErrorAction SilentlyContinue

            $EXOSharedMailboxModulePath = Join-Path -Path $PSScriptRoot `
                                                    -ChildPath "..\DSCResources\MSFT_EXOSharedMailbox\MSFT_EXOSharedMailbox.psm1" `
                                                    -Resolve

            Import-Module $EXOSharedMailboxModulePath | Out-Null

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
                    $partialContent = Export-TargetResource -DisplayName $mailboxName -GlobalAdminAccount $GlobalAdminAccount
                    if ($partialContent.ToLower().IndexOf("@" + $organization.ToLower()) -gt 0)
                    {
                        $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$OrganizationName"
                    }
                }

                $DSCContent += $partialContent
                $i++
            }
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "O365User"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckO365User")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("O365")))
    {
        Write-Information "Extracting O365User..."
        $O365UserModulePath = Join-Path -Path $PSScriptRoot `
                                        -ChildPath "..\DSCResources\MSFT_O365USer\MSFT_O365USer.psm1" `
                                        -Resolve

        Import-Module $O365UserModulePath | Out-Null
        Test-MSCloudLogin -Platform MSOnline -CloudCredential $GlobalAdminAccount

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
                if ($partialContent.ToLower().IndexOf($organization.ToLower()) -gt 0)
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape($organization), "`$OrganizationName"
                    $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$OrganizationName"
                }

                if ($partialContent.ToLower().IndexOf($principal.ToLower()) -gt 0)
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape($principal.ToLower()), "`$(`$OrganizationName.Split('.')[0])"
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
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("O365")))
    {
        Write-Information "Extracting O365Group..."
        $O365GroupModulePath = Join-Path -Path $PSScriptRoot `
                                         -ChildPath "..\DSCResources\MSFT_O365Group\MSFT_O365Group.psm1" `
                                         -Resolve

        Import-Module $O365GroupModulePath | Out-Null

        # Other Groups
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform AzureAD
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
            if ($partialContent.ToLower().IndexOf($organization.ToLower()) -gt 0)
            {
                $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$OrganizationName"
            }
            if ($partialContent.ToLower().IndexOf($principal.ToLower()) -gt 0)
            {
                $partialContent = $partialContent -ireplace [regex]::Escape("@" + $principal), "@`$(`$OrganizationName.Split('.')[0])"
            }
            $DSCContent += $partialContent
            $i++
        }
    }
    #endregion

    #region "EXOMailboxSettings"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckEXOMailboxSettings")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        Write-Information "Extracting EXOMailboxSettings..."
        $EXOMailboxSettingsModulePath = Join-Path -Path $PSScriptRoot `
                                                  -ChildPath "..\DSCResources\MSFT_EXOMailboxSettings\MSFT_EXOMailboxSettings.psm1" `
                                                  -Resolve

        Import-Module $EXOMailboxSettingsModulePath | Out-Null
        try
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform ExchangeOnline `
                              -ErrorAction SilentlyContinue

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
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "ODSettings"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckODSettings")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("OD")))
    {
        try
        {

            $ODSettingsModulePath = Join-Path -Path $PSScriptRoot `
                                            -ChildPath "..\DSCResources\MSFT_ODSettings\MSFT_ODSettings.psm1" `
                                            -Resolve

            Import-Module $ODSettingsModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region SCAuditConfigurationPolicy
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSCAuditConfigurationPolicy")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        Write-Information "Extracting SCAuditConfigurationPolicy..."

        $ModulePath = Join-Path -Path $PSScriptRoot `
                                                   -ChildPath "..\DSCResources\MSFT_SCAuditConfigurationPolicy\MSFT_SCAuditConfigurationPolicy.psm1" `
                                                   -Resolve

        Import-Module $ModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "SCComplianceCase"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSCComplianceCase")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        Write-Information "Extracting SCComplianceCase..."

        $SCComplianceCaseModulePath = Join-Path -Path $PSScriptRoot `
                                                   -ChildPath "..\DSCResources\MSFT_SCComplianceCase\MSFT_SCComplianceCase.psm1" `
                                                   -Resolve

        Import-Module $SCComplianceCaseModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region SCCaseHoldPolicy
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSCCaseHoldPolicy")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        Write-Information "Extracting SCCaseHoldPolicy..."

        $SCCaseHoldPolicyModulePath = Join-Path -Path $PSScriptRoot `
                                                   -ChildPath "..\DSCResources\MSFT_SCCaseHoldPolicy\MSFT_SCCaseHoldPolicy.psm1" `
                                                   -Resolve

        Import-Module $SCCaseHoldPolicyModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "SCCaseHoldRule"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSCCaseHoldRule")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        Write-Information "Extracting SCCaseHoldRule..."
        $SCCaseHoldRuleModulePath = Join-Path -Path $PSScriptRoot `
                                                   -ChildPath "..\DSCResources\MSFT_SCCaseHoldRule\MSFT_SCCaseHoldRule.psm1" `
                                                   -Resolve

        Import-Module $SCCaseHoldRuleModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }

    #region "SCComplianceSearch"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSCComplianceSearch")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        Write-Information "Extracting SCComplianceSearch..."
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform SecurityComplianceCenter `
                          -ErrorAction SilentlyContinue

        $SCComplianceCSearchModulePath = Join-Path -Path $PSScriptRoot `
                                                   -ChildPath "..\DSCResources\MSFT_SCComplianceSearch\MSFT_SCComplianceSearch.psm1" `
                                                   -Resolve

        Import-Module $SCComplianceCSearchModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "SCComplianceSearchAction"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSCComplianceSearchAction")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        Write-Information "Extracting SCComplianceSearchAction..."
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform SecurityComplianceCenter `
                          -ErrorAction SilentlyContinue

        $SCComplianceCSearchActionModulePath = Join-Path -Path $PSScriptRoot `
                                                   -ChildPath "..\DSCResources\MSFT_SCComplianceSearchAction\MSFT_SCComplianceSearchAction.psm1" `
                                                   -Resolve

        Import-Module $SCComplianceCSearchActionModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "SCComplianceTag"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSCComplianceTag")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCComplianceTag..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                                            -ChildPath "..\DSCResources\MSFT_SCComplianceTag\MSFT_SCComplianceTag.psm1" `
                                            -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Security and Compliance Center"
        }
    }
    #endregion

    #region "SCDLPCompliancePolicy"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSCDLPCompliancePolicy")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCDLPCompliancePolicy..."
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform SecurityComplianceCenter `
                              -ErrorAction SilentlyContinue

            $SCDLPCompliancePolicyModulePath = Join-Path -Path $PSScriptRoot `
                                            -ChildPath "..\DSCResources\MSFT_SCDLPCompliancePolicy\MSFT_SCDLPCompliancePolicy.psm1" `
                                            -Resolve

            Import-Module $SCDLPCompliancePolicyModulePath | Out-Null
            $policies = Get-DLPCompliancePolicy | Where-Object -FilterScript {$_.Mode -ne 'PendingDeletion'}

            $totalPolicies = $policies.Length
            if ($null -eq $totalPolicies)
            {
                $totalPolicies = 1
            }
            $i = 1
            foreach ($policy in $policies)
            {
                Write-Information "    - [$i/$($totalPolicies)] $($policy.Name)"
                $partialContent = Export-TargetResource -Name $policy.Name -GlobalAdminAccount $GlobalAdminAccount
                $DSCContent += $partialContent
                $i++
            }
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Security and Compliance Center"
        }
    }
    #endregion

    #region "SCDLPComplianceRule"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSCDLPComplianceRule")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        Write-Information "Extracting SCDLPComplianceRule..."
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform SecurityComplianceCenter `
                          -ErrorAction SilentlyContinue

        $SCDLPComplianceRuleModulePath = Join-Path -Path $PSScriptRoot `
                                                   -ChildPath "..\DSCResources\MSFT_SCDLPComplianceRule\MSFT_SCDLPComplianceRule.psm1" `
                                                   -Resolve

        Import-Module $SCDLPComplianceRuleModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "SCFilePlanPropertyAuthority"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSCFilePlanPropertyAuthority")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        Write-Information "Extracting SCFilePlanPropertyAuthority..."
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform SecurityComplianceCenter `
                          -ErrorAction SilentlyContinue

        $ModulePath = Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\DSCResources\MSFT_SCFilePlanPropertyAuthority\MSFT_SCFilePlanPropertyAuthority.psm1" `
                                -Resolve

        Import-Module $ModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "SCFilePlanPropertyCategory"
    if (($null -ne $ComponentsToExtract -and
    $ComponentsToExtract.Contains("chckSCFilePlanPropertyCategory")) -or
    $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        Write-Information "Extracting SCFilePlanPropertyCategory..."
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                        -Platform SecurityComplianceCenter `
                        -ErrorAction SilentlyContinue

        $ModulePath = Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\DSCResources\MSFT_SCFilePlanPropertyCategory\MSFT_SCFilePlanPropertyCategory.psm1" `
                                -Resolve

        Import-Module $ModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "SCFilePlanPropertyCitation"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSCFilePlanPropertyCitation")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        Write-Information "Extracting SCFilePlanPropertyCitation..."
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform SecurityComplianceCenter `
                          -ErrorAction SilentlyContinue

        $ModulePath = Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\DSCResources\MSFT_SCFilePlanPropertyCitation\MSFT_SCFilePlanPropertyCitation.psm1" `
                                -Resolve

        Import-Module $ModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "SCFilePlanPropertyDepartment"
    if (($null -ne $ComponentsToExtract -and
    $ComponentsToExtract.Contains("chckSCFilePlanPropertyDepartment")) -or
    $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        Write-Information "Extracting SCFilePlanPropertyDepartment..."
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                        -Platform SecurityComplianceCenter `
                        -ErrorAction SilentlyContinue

        $ModulePath = Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\DSCResources\MSFT_SCFilePlanPropertyDepartment\MSFT_SCFilePlanPropertyDepartment.psm1" `
                                -Resolve

        Import-Module $ModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "SCFilePlanPropertyReferenceId"
    if (($null -ne $ComponentsToExtract -and
    $ComponentsToExtract.Contains("chckSCFilePlanPropertyReferenceId")) -or
    $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        Write-Information "Extracting SCFilePlanPropertyReferenceId..."
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                        -Platform SecurityComplianceCenter `
                        -ErrorAction SilentlyContinue

        $ModulePath = Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\DSCResources\MSFT_SCFilePlanPropertyReferenceId\MSFT_SCFilePlanPropertyReferenceId.psm1" `
                                -Resolve

        Import-Module $ModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "SCFilePlanPropertySubCategory"
    if (($null -ne $ComponentsToExtract -and
    $ComponentsToExtract.Contains("chckSCFilePlanPropertySubCategory")) -or
    $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        Write-Information "Extracting SCFilePlanPropertySubCategory..."
        Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                          -Platform SecurityComplianceCenter `
                          -ErrorAction SilentlyContinue

        $ModulePath = Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\DSCResources\MSFT_SCFilePlanPropertySubCategory\MSFT_SCFilePlanPropertySubCategory.psm1" `
                                -Resolve

        Import-Module $ModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "SCRetentionCompliancePolicy"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSCRetentionCompliancePolicy")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCRetentionCompliancePolicy..."
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform SecurityComplianceCenter `
                              -ErrorAction SilentlyContinue

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

                if ($partialContent.ToLower().Contains($organization.ToLower()) -or `
                $partialContent.ToLower().Contains($principal.ToLower()))
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$(`$OrganizationName)"
                }
                $DSCContent += $partialContent
                $i++
            }
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "SCRetentionComplianceRule"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSCRetentionComplianceRule")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCRetentionComplianceRule..."
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform SecurityComplianceCenter `
                              -ErrorAction SilentlyContinue

            $SCRetentionComplianceRuleModulePath = Join-Path -Path $PSScriptRoot `
                                                -ChildPath "..\DSCResources\MSFT_SCRetentionComplianceRule\MSFT_SCRetentionComplianceRule.psm1" `
                                                -Resolve

            Import-Module $SCRetentionComplianceRuleModulePath | Out-Null
            $policies = Get-RetentionCompliancePolicy

            $j = 1
            $policiesLength = $policies.Length
            if ($null -eq $policiesLength)
            {
                $policiesLength = 1
            }
            foreach($policy in $policies)
            {
                $rules = Get-RetentionComplianceRule -Policy $policy.Name
                Write-Information "    - Policy [$j/$($policiesLength)] $($policy.Name)"
                $i = 1
                $rulesLength = $rules.Length
                if ($null -eq $rulesLength)
                {
                    $rulesLength = 1
                }
                foreach ($rule in $rules)
                {
                    Write-Information "        - [$i/$($rulesLength)] $($rule.Name)"
                    $partialContent = Export-TargetResource -Name $rule.Name -Policy $rule.Policy -GlobalAdminAccount $GlobalAdminAccount
                    if ($partialContent.ToLower().Contains($organization.ToLower()) -or `
                    $partialContent.ToLower().Contains($principal.ToLower()))
                    {
                        $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$(`$OrganizationName)"
                    }
                    $DSCContent += $partialContent
                    $i++
                }
                $j++
            }
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "SCSupervisoryReviewPolicy"
    if (($null -ne $ComponentsToExtract -and
    $ComponentsToExtract.Contains("chckSCSupervisoryReviewPolicy")) -or
    $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCSupervisoryReviewPolicy..."
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform SecurityComplianceCenter `
                              -ErrorAction SilentlyContinue

            $SCSCSupervisoryReviewPolicyModulePath = Join-Path -Path $PSScriptRoot `
                                                -ChildPath "..\DSCResources\MSFT_SCSupervisoryReviewPolicy\MSFT_SCSupervisoryReviewPolicy.psm1" `
                                                -Resolve

            Import-Module $SCSCSupervisoryReviewPolicyModulePath | Out-Null
            $policies = Get-SupervisoryReviewPolicyV2

            $totalPolicies = $policies.Length
            if ($null -eq $totalPolicies)
            {
                $totalPolicies = 1
            }
            $i = 1
            foreach ($policy in $policies)
            {
                Write-Information "    - [$i/$($totalPolicies)] $($policy.Name)"
                $partialContent = Export-TargetResource -Name $policy.Name -Reviewers "ReverseDSC" -GlobalAdminAccount $GlobalAdminAccount

                if ($partialContent.ToLower().Contains($organization.ToLower()) -or `
                $partialContent.ToLower().Contains($principal.ToLower()))
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$(`$OrganizationName)"
                }
                $DSCContent += $partialContent
                $i++
            }
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "SCSupervisoryReviewRule"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSCSupervisoryReviewRule")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCSupervisoryReviewRule..."
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform SecurityComplianceCenter `
                              -ErrorAction SilentlyContinue

            $SCSupervisoryReviewRuleModulePath = Join-Path -Path $PSScriptRoot `
                                                -ChildPath "..\DSCResources\MSFT_SCSupervisoryReviewRule\MSFT_SCSupervisoryReviewRule.psm1" `
                                                -Resolve

            Import-Module $SCSupervisoryReviewRuleModulePath | Out-Null
            $rules = Get-SupervisoryReviewRule

            $totalRules = $rules.Length
            if ($null -eq $totalRules)
            {
                $totalRules = 1
            }
            $i = 1
            foreach ($rule in $rules)
            {
                Write-Information "    - [$i/$totalRules] $($rule.Name)"
                $partialContent = Export-TargetResource -Name $rule.Name -Policy $rule.Policy -GlobalAdminAccount $GlobalAdminAccount
                if ($partialContent.ToLower().Contains($organization.ToLower()) -or `
                    $partialContent.ToLower().Contains($principal.ToLower()))
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$(`$OrganizationName)"
                }
                $DSCContent += $partialContent
                $i++
            }
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online"
        }
    }
    #endregion

    #region "SPOAccessControlSettings"
    if (($null -ne $ComponentsToExtract -and
    $ComponentsToExtract.Contains("chckSPOAccessControlSettings")) -or
    $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        Write-Information "Extracting SPOAccessControlSettings..."

        $ModulePath = Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\DSCResources\MSFT_SPOAccessControlSettings\MSFT_SPOAccessControlSettings.psm1" `
                                -Resolve

        Import-Module $ModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region SPOApp
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOApp")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        Write-Information "Extracting SPOApp..."
        $SPOAppModulePath = Join-Path -Path $PSScriptRoot `
                                      -ChildPath "..\DSCResources\MSFT_SPOApp\MSFT_SPOApp.psm1" `
                                      -Resolve

        Import-Module $SPOAppModulePath | Out-Null
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform PnP
        try
        {
            $tenantAppCatalogUrl = Get-PnPTenantAppCatalogUrl
            Test-MSCloudLogin -ConnectionUrl $tenantAppCatalogUrl `
                              -CloudCredential $GlobalAdminAccount `
                              -Platform PnP

            if (-not [string]::IsNullOrEmpty($tenantAppCatalogUrl))
            {
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
                                                                -Path ("`$PSScriptRoot\" + $file.Name) `
                                                                -GlobalAdminAccount $GlobalAdminAccount
                    }
                    else
                    {
                        # Case - Where file name doesn't match the App's Title in the catalog
                        $app = Get-PnpApp -Identity $file.Title -ErrorAction SilentlyContinue

                        $partialContent = Export-TargetResource -Identity $app.Title `
                                                                -Path ("`$PSScriptRoot\" + $file.Name) `
                                                                -GlobalAdminAccount $GlobalAdminAccount
                    }

                    $DSCContent += $partialContent
                    $i++
                }

                Test-MSCloudLogin -ConnectionUrl $tenantAppCatalogUrl `
                                -CloudCredential $GlobalAdminAccount `
                                -Platform PnP

                foreach ($file in $allFiles)
                {
                    $appInstanceUrl = $tenantAppCatalogPath + "/AppCatalog/" + $file.Name
                    $appFileName = $appInstanceUrl.Split('/')[$appInstanceUrl.Split('/').Length -1]
                    Get-PnPFile -Url $appInstanceUrl -Path $env:Temp -Filename $appFileName -AsFile | Out-Null
                }
            }
            else
            {
                Write-Information "    * App Catalog is not configured on tenant. Cannot extract information about SharePoint apps."
            }
        }
        catch
        {
            throw $_
        }
    }
    #endregion

    #region "SPOSite"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOSite")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        Write-Information "Extracting SPOSite..."
        $SPOSiteModulePath = Join-Path -Path $PSScriptRoot `
                                       -ChildPath "..\DSCResources\MSFT_SPOSite\MSFT_SPOSite.psm1" `
                                       -Resolve

        Import-Module $SPOSiteModulePath | Out-Null

        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform SharePointOnline
        $invalidTemplates = @("SRCHCEN#0", "GROUP#0", "SPSMSITEHOST#0", "POINTPUBLISHINGHUB#0", "POINTPUBLISHINGTOPIC#0")
        $sites = Get-SPOSite -Limit All | Where-Object -FilterScript { $_.Template -notin $invalidTemplates }

        $partialContent = ""
        $i = 1
        foreach ($site in $sites)
        {
            Write-Information "    - [$i/$($sites.Length)] $($site.Url)"
            $partialContent = Export-TargetResource -Url $site.Url `
                                                    -Owner "Reverse" `
                                                    -GlobalAdminAccount $GlobalAdminAccount

            if ($partialContent.ToLower().Contains($principal.ToLower() + ".sharepoint.com"))
            {
                $partialContent = $partialContent -ireplace [regex]::Escape($principal + ".sharepoint.com"), "`$(`$OrganizationName.Split('.')[0]).sharepoint.com"
            }
            if($partialContent.ToLower().Contains("@" + $organization.ToLower()))
            {
                $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$OrganizationName"
            }
            if($partialContent.ToLower().Contains("@" + $principal.ToLower()))
            {
                $partialContent = $partialContent -ireplace [regex]::Escape("@" + $principal), "@`$OrganizationName.Split('.')[0])"
            }
            $DSCContent += $partialContent
            $i++
        }
    }
    #endregion

    #region SPOSharingSettings
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOSharingSettings")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        Write-Information "Extracting SPOSharingSettings..."

        $ModulePath = Join-Path -Path $PSScriptRoot `
                                                   -ChildPath "..\DSCResources\MSFT_SPOSharingSettings\MSFT_SPOSharingSettings.psm1" `
                                                   -Resolve

        Import-Module $ModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region SPOPropertyBag
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOPropertyBag")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        Write-Information "Extracting SPOPropertyBag..."

        $SPOPropertyBagModulePath = Join-Path -Path $PSScriptRoot `
                                                   -ChildPath "..\DSCResources\MSFT_SPOPropertyBag\MSFT_SPOPropertyBag.psm1" `
                                                   -Resolve

        Import-Module $SPOPropertyBagModulePath | Out-Null
        $partialContent = Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount -MaxProcesses $MaxProcesses
        if ($partialContent.ToLower().Contains($organization.ToLower()) -or `
            $partialContent.ToLower().Contains($principal.ToLower()))
        {
            $partialContent = $partialContent -ireplace [regex]::Escape('https://' + $principal + '.sharepoint.com/'), "https://`$(`$OrganizationName.Split('.')[0]).sharepoint.com/"
            $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$(`$OrganizationName)"
        }
        $DSCContent += $partialContent
    }
    #endregion

    #region "SPOHubSite"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOHubSite")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        Write-Information "Extracting SPOHubSite..."
        $SPOHubSiteModulePath = Join-Path -Path $PSScriptRoot `
                                        -ChildPath "..\DSCResources\MSFT_SPOHubSite\MSFT_SPOHubSite.psm1" `
                                        -Resolve

        Import-Module $SPOHubSiteModulePath | Out-Null
        $partialContent = ""
        if ($centralAdminUrl)
        {
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform SharePointOnline

            $hubSites = Get-SPOHubSite

            $i = 1
            foreach ($hub in $hubSites)
            {
                Write-Information "    - [$i/$($hubSites.Length)] $($hub.SiteUrl)"
                $partialContent = Export-TargetResource -Url $hub.SiteUrl -GlobalAdminAccount $GlobalAdminAccount
                if ($partialContent.ToLower().Contains($organization.ToLower()) -or `
                    $partialContent.ToLower().Contains($principal.ToLower()))
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape('https://' + $principal + '.sharepoint.com/'), "https://`$(`$OrganizationName.Split('.')[0]).sharepoint.com/"
                    $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$(`$OrganizationName)"
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
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
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
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform PnP
        $SearchConfig = [Xml] (Get-PnPSearchConfiguration -Scope Subscription)
        $sources =  $SearchConfig.SearchConfigurationSettings.SearchQueryConfigurationSettings.SearchQueryConfigurationSettings.Sources.Source

        $partialContent = ""
        $i = 1
        $sourcesLength = $sources.Length
        if ($null -eq $sourcesLength)
        {
            $sourcesLength = 1
        }
        foreach ($source in $sources)
        {
            $mapping = $InfoMapping | Where-Object -FilterScript { $_.ProviderID -eq $source.ProviderId }
            Write-Information "    - [$i/$($sourcesLength)] $($source.Name)"
            $partialContent = Export-TargetResource -Name $source.Name `
                                                    -Protocol $mapping.Protocol `
                                                    -GlobalAdminAccount $GlobalAdminAccount

            $DSCContent += $partialContent
            $i++
        }
    }
    #endregion

    #region "SPOSearchManagedProperty"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOSearchManagedProperty")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        Write-Information "Extracting SPOSearchManagedProperty..."
        $SPOSearchManagedPropertyModulePath = Join-Path -Path $PSScriptRoot `
                                                        -ChildPath "..\DSCResources\MSFT_SPOSearchManagedProperty\MSFT_SPOSearchManagedProperty.psm1" `
                                                        -Resolve

        Import-Module $SPOSearchManagedPropertyModulePath | Out-Null
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform PnP
        $SearchConfig = [Xml] (Get-PnPSearchConfiguration -Scope Subscription)
        $properties =  $SearchConfig.SearchConfigurationSettings.SearchSchemaConfigurationSettings.ManagedProperties.dictionary.KeyValueOfstringManagedPropertyInfoy6h3NzC8

        $partialContent = ""
        $i = 1
        $propertiesLength = $properties.Length
        if ($null -eq $propertiesLength)
        {
            $propertiesLength = 1
        }
        foreach ($property in $properties)
        {
            Write-Information "    - [$i/$($propertiesLength)] $($property.Value.Name)"
            $partialContent = Export-TargetResource -Name $property.Value.Name `
                                                    -Type $property.Value.ManagedType `
                                                    -GlobalAdminAccount $GlobalAdminAccount

            $DSCContent += $partialContent
            $i++
        }
    }
    #endregion

    #region SPOSiteAuditSetting
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOSiteAuditSettings")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        Write-Information "Extracting SPOSiteAuditSettings..."

        $SPOSiteAuditSettingModulePath = Join-Path -Path $PSScriptRoot `
                                                   -ChildPath "..\DSCResources\MSFT_SPOSiteAuditSettings\MSFT_SPOSiteAuditSettings.psm1" `
                                                   -Resolve

        Import-Module $SPOSiteAuditSettingModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region SPOSiteDesign
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOSiteDesign")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        Write-Information "Extracting SPOSiteDesign..."
        $SPOSiteDesignModulePath = Join-Path -Path $PSScriptRoot `
                                                        -ChildPath "..\DSCResources\MSFT_SPOSiteDesign\MSFT_SPOSiteDesign.psm1" `
                                                        -Resolve

        Import-Module $SPOSiteDesignModulePath | Out-Null
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform PnP

        $siteDesigns = Get-PnPSiteDesign

        $partialContent = ""
        $i = 1
        foreach ($siteDesign in $siteDesigns)
        {
            Write-Information "    - [$i/$($siteDesigns.Length)] $($siteDesign.Title)"
            $partialContent = Export-TargetResource -Title $siteDesign.Title `
                                                    -GlobalAdminAccount $GlobalAdminAccount

            $DSCContent += $partialContent
            $i++
        }
    }
    #endregion

    #region SPOSiteDesignRights
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOSiteDesignRights")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        Write-Information "Extracting SPOSiteDesignRights..."
        $SPOSiteDesignModulePath = Join-Path -Path $PSScriptRoot `
                                                        -ChildPath "..\DSCResources\MSFT_SPOSiteDesignRights\MSFT_SPOSiteDesignRights.psm1" `
                                                        -Resolve

        Import-Module $SPOSiteDesignModulePath | Out-Null
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform PnP

        $siteDesigns = Get-PnPSiteDesign

        $partialContent = ""
        $i = 1
        foreach ($siteDesign in $siteDesigns)
        {
            Write-Information "    - [$i/$($siteDesigns.Length)] $($siteDesign.Title)"
            $partialContent += Export-TargetResource -SiteDesignTitle $siteDesign.Title `
                                                     -GlobalAdminAccount $GlobalAdminAccount

            $DSCContent += $partialContent
            $i++
        }
    }
    #endregion

    #region SPOStorageEntity
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOStorageEntity")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        Write-Information "Extracting SPOStorageEntity..."
        $SPOModulePath = Join-Path -Path $PSScriptRoot `
                                    -ChildPath "..\DSCResources\MSFT_SPOStorageEntity\MSFT_SPOStorageEntity.psm1" `
                                    -Resolve

        Import-Module $SPOModulePath | Out-Null

        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform PnP

        $storageEntities = Get-PnPStorageEntity

        $i = 1
        foreach ($storageEntity in $storageEntities)
        {
            Write-Information "    [$i/$($storageEntities.Length)] {$($storageEntity.Key)}"
            $partialContent = Export-TargetResource -Key $storageEntity.Key `
                                                 -SiteUrl $centralAdminUrl `
                                                 -GlobalAdminAccount $GlobalAdminAccount
            if ($partialContent.ToLower().Contains("https://" + $principal.ToLower()))
            {
                # If we are already looking at the Admin Center URL, don't replace the full path;
                if ($partialContent.ToLower().Contains("https://" + $principal.ToLower() + "-admin.sharepoint.com"))
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape("https://" + $principal.ToLower() + "-admin.sharepoint.com"), "https://`$(`$OrganizationName.Split('.')[0])-admin.sharepoint.com"
                }
                else
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape("https://" + $principal.ToLower()), "`$(`$OrganizationName.Split('.')[0])-admin.sharepoint.com"
                }
            }
            if($partialContent.ToLower().Contains($principal.ToLower()))
            {
                $partialContent = $partialContent -ireplace [regex]::Escape($principal), "`$(`$OrganizationName.Split('.')[0])"
            }
            $DSCContent += $partialContent
            $i++
        }
    }
    #endregion

    #region SPOTenantCDNPolicy
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOTenantCDNPolicy")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        Write-Information "Extracting SPOTenantCDNPolicy..."

        $ModulePath = Join-Path -Path $PSScriptRoot `
                                                   -ChildPath "..\DSCResources\MSFT_SPOTenantCDNPolicy\MSFT_SPOTenantCDNPolicy.psm1" `
                                                   -Resolve

        Import-Module $ModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region SPOTenantSettings
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOTenantSettings")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        Write-Information "Extracting SPOTenantSettings..."
        $SPOModulePath = Join-Path -Path $PSScriptRoot `
                                    -ChildPath "..\DSCResources\MSFT_SPOTenantSettings\MSFT_SPOTenantSettings.psm1" `
                                    -Resolve

        Import-Module $SPOModulePath | Out-Null

        $DSCContent += Export-TargetResource -IsSingleInstance 'Yes' `
                                             -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region SPOTheme
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOTheme")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        Write-Information "Extracting SPOTheme..."

        $ModulePath = Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\DSCResources\MSFT_SPOTheme\MSFT_SPOTheme.psm1" `
                                -Resolve

        Import-Module $ModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region SPOUserProfileProperty
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckSPOUserProfileProperty")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        Write-Information "Extracting SPOUserProfileProperty..."

        $ModulePath = Join-Path -Path $PSScriptRoot `
                                                   -ChildPath "..\DSCResources\MSFT_SPOUserProfileProperty\MSFT_SPOUserProfileProperty.psm1" `
                                                   -Resolve

        Import-Module $ModulePath | Out-Null
        $partialContent = Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount -MaxProcesses $MaxProcesses
        if ($partialContent.ToLower().Contains($organization.ToLower()) -or `
        $partialContent.ToLower().Contains($principal.ToLower()))
        {
            $partialContent = $partialContent -ireplace [regex]::Escape('https://' + $principal + '.sharepoint.com/'), "https://`$(`$OrganizationName.Split('.')[0]).sharepoint.com/"
            $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$(`$OrganizationName)"
        }
        $DSCContent += $partialContent
    }
    #endregion

    #region "TeamsTeam"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckTeamsTeam")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsTeam..."
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform MicrosoftTeams
            $TeamsModulePath = Join-Path -Path $PSScriptRoot `
                                        -ChildPath "..\DSCResources\MSFT_TeamsTeam\MSFT_TeamsTeam.psm1" `
                                        -Resolve

            Import-Module $TeamsModulePath | Out-Null
            $teams = Get-Team
            $i = 1
            foreach ($team in $teams)
            {
                Write-Information "    - [$i/$($teams.Length)] $($team.DisplayName)"
                $partialContent = Export-TargetResource -DisplayName $team.DisplayName `
                                                    -GlobalAdminAccount $GlobalAdminAccount
                if ($partialContent.ToLower().Contains("@" + $organization.ToLower()))
                {
                    $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$OrganizationName"
                }
                $DSCContent += $partialContent
                $i++
            }
        }
        catch
        {
            Write-Verbose $_
        }
    }
    #endregion

    #region "TeamsChannel"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckTeamsChannel")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsChannel..."
            Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                              -Platform MicrosoftTeams
            $TeamsChannelModulePath = Join-Path -Path $PSScriptRoot `
                                            -ChildPath "..\DSCResources\MSFT_TeamsChannel\MSFT_TeamsChannel.psm1" `
                                            -Resolve

            Import-Module $TeamsChannelModulePath | Out-Null
            $teams = Get-Team
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
        catch
        {
            Write-Verbose $_
        }
    }
    #endregion

    #region "TeamsUser"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckTeamsUser")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {

        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                          -Platform MicrosoftTeams
        Write-Information "Extracting TeamsUser..."
        $ModulePath = Join-Path -Path $PSScriptRoot `
                                        -ChildPath "..\DSCResources\MSFT_TeamsUser\MSFT_TeamsUser.psm1" `
                                        -Resolve

        Import-Module $ModulePath | Out-Null
        $DSCContent += Export-TargetResource -MaxProcesses $MaxProcesses `
                                             -GlobalAdminAccount $GlobalAdminAccount
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
                $credsContent += "        " + (Resolve-Credentials $credential) + " = Get-Credential -Message `"Global Admin credentials`""
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
    $DSCContent += "$ConfigName -ConfigurationData .\ConfigurationData.psd1 -GlobalAdminAccount `$GlobalAdminAccount"
    #endregion

    $shouldOpenOutputDirectory = !$Quiet
    #region Prompt the user for a location to save the extract and generate the files
    if ($null -eq $Path -or "" -eq $Path)
    {
        $shouldOpenOutputDirectory = $true
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
        foreach ($fileToCopy in $filesToDownload)
        {
            $filePath = Join-Path $env:Temp $fileToCopy.Name -Resolve
            $destPath = Join-Path $OutputDSCPath $fileToCopy.Name
            Copy-Item -Path $filePath -Destination $destPath
        }
    }
    #endregion

    if (-not [System.String]::IsNullOrEmpty($FileName))
    {
        $outputDSCFile = $OutputDSCPath + $FileName
    }
    else
    {
        $outputDSCFile = $OutputDSCPath + "Office365TenantConfig.ps1"
    }
    $DSCContent | Out-File $outputDSCFile

    if (!$AzureAutomation)
    {
        $outputConfigurationData = $OutputDSCPath + "ConfigurationData.psd1"
        New-ConfigurationDataDocument -Path $outputConfigurationData
    }

    if ($shouldOpenOutputDirectory)
    {
        Invoke-Item -Path $OutputDSCPath
    }
}
