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
        [ValidateRange(1, 100)]
        $MaxProcesses = 16,

        [Parameter()]
        [ValidateSet('SPO', 'EXO', 'SC', 'OD', 'O365', 'TEAMS', 'PP')]
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
        $ConfigName = $FileName.Replace('.' + $FileParts[$FileParts.Length - 1], "")
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
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_O365AdminAuditLogConfig\MSFT_O365AdminAuditLogConfig.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]O365AdminAuditLogConfig"
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

        try
        {
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_EXOAntiPhishRule\MSFT_EXOAntiPhishRule.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXOAntiPhishRule"
        }
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
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXOOrganizationConfig"
        }
    }

    #region "EXOAtpPolicyForO365"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckEXOAtpPolicyForO365")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        try
        {
            if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-AtpPolicyForO365)
            {
                Write-Information "Extracting EXOAtpPolicyForO365..."
                $ModulePath = Join-Path -Path $PSScriptRoot `
                    -ChildPath "..\DSCResources\MSFT_EXOAtpPolicyForO365\MSFT_EXOAtpPolicyForO365.psm1" `
                    -Resolve

                Import-Module $ModulePath | Out-Null

                $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
            }
            else
            {
                Write-Warning -Message "The specified Tenant is not registered for ATP, and therefore can't extract policies"
            }
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXOAtpPolicyForO365"
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
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_EXOCASMailboxPlan\MSFT_EXOCASMailboxPlan.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null

            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXOCASMailboxPlan"
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
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_EXOClientAccessRule\MSFT_EXOClientAccessRule.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXOClientAccessRule"
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
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_EXODkimSigningConfig\MSFT_EXODkimSigningConfig.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXODkimSigningConfig"
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

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_EXOHostedConnectionFilterPolicy\MSFT_EXOHostedConnectionFilterPolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXOHostedConnectionFilterPolicy"
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
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_EXOHostedContentFilterPolicy\MSFT_EXOHostedContentFilterPolicy.psm1" `
                -Resolve
            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXOHostedCOntentFilterPolicy"
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
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_EXOHostedContentFilterRule\MSFT_EXOHostedContentFilterRule.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount

        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXOHostedContentFilterRule"
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
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_EXOHostedOutboundSpamFilterPolicy\MSFT_EXOHostedOutboundSpamFilterPolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -IsSingleInstance "Yes" -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXOHostedOutboundSpamFilterPolicy"
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
            Write-Information "Extracting EXOSafeAttachmentPolicy..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_EXOSafeAttachmentPolicy\MSFT_EXOSafeAttachmentPolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXOSafeAttachmentPolicy"
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
            Write-Information "Extracting EXOSafeAttachmentRule..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_EXOSafeAttachmentRule\MSFT_EXOSafeAttachmentRule.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXOSafeAttachmentRule"
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
            Write-Information "Extracting EXOSafeLinksPolicy..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_EXOSafeLinksPolicy\MSFT_EXOSafeLinksPolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXOSafeLinksPolicy"
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
            Write-Information "Extracting EXOSafeLinksRule..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_EXOSafeLinksRule\MSFT_EXOSafeLinksRule.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXOSafeLinksRule"
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
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_EXOMailTips\MSFT_EXOMailTips.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXOMailTips"
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
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_EXOSharedMailbox\MSFT_EXOSharedMailbox.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXOSharedMailbox"
        }
    }
    #endregion

    #region "O365User"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckO365User")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("O365")))
    {
        try
        {
            Write-Information "Extracting O365User..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_O365USer\MSFT_O365USer.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]O365User"
        }
    }
    #endregion

    #region "O365Group"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckO365Group")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("O365")))
    {
        Write-Information "Extracting O365Group..."
        $ModulePath = Join-Path -Path $PSScriptRoot `
            -ChildPath "..\DSCResources\MSFT_O365Group\MSFT_O365Group.psm1" `
            -Resolve

        Import-Module $ModulePath | Out-Null

        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "O365OrgCustomizationSetting"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckO365OrgCustomizationSetting")) -or
            $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("O365")))
    {
        try
        {
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_O365OrgCustomizationSetting\MSFT_O365OrgCustomizationSetting.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]O365OrgCustomizationSetting"
        }
    }
    #endregion


    #region "EXOMailboxSettings"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckEXOMailboxSettings")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("EXO")))
    {
        try
        {
            Write-Information "Extracting EXOMailboxSettings..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
            -ChildPath "..\DSCResources\MSFT_EXOMailboxSettings\MSFT_EXOMailboxSettings.psm1" `
            -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -DisplayName $mailboxName -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]EXOMailboxSettings"
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

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_ODSettings\MSFT_ODSettings.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]ODsettings"
        }
    }
    #endregion

    #region PPPowerAppsEnvironment
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckPPPowerAppsEnvironment")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("PP")))
    {
        Write-Information "Extracting PPowerAppsEnvironment..."

        $ModulePath = Join-Path -Path $PSScriptRoot `
            -ChildPath "..\DSCResources\MSFT_PPPowerAppsEnvironment\MSFT_PPPowerAppsEnvironment.psm1" `
            -Resolve

        Import-Module $ModulePath | Out-Null
        $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region SCAuditConfigurationPolicy
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSCAuditConfigurationPolicy")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCAuditConfigurationPolicy..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCAuditConfigurationPolicy\MSFT_SCAuditConfigurationPolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]SCAuditConfigurationPolicy"
        }
    }
    #endregion

    #region "SCComplianceCase"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSCComplianceCase")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCComplianceCase..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCComplianceCase\MSFT_SCComplianceCase.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]SCComplianceCase"
        }
    }
    #endregion

    #region SCCaseHoldPolicy
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSCCaseHoldPolicy")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCCaseHoldPolicy..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCCaseHoldPolicy\MSFT_SCCaseHoldPolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]SCCaseHoldPolicy"
        }
    }
    #endregion

    #region "SCCaseHoldRule"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSCCaseHoldRule")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCCaseHoldRule..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCCaseHoldRule\MSFT_SCCaseHoldRule.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]SCCaseHoldRule"
        }
    }

    #region "SCComplianceSearch"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSCComplianceSearch")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCComplianceSearch..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCComplianceSearch\MSFT_SCComplianceSearch.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]SCComplianceSearch"
        }
    }
    #endregion

    #region "SCComplianceSearchAction"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSCComplianceSearchAction")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCComplianceSearchAction..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCComplianceSearchAction\MSFT_SCComplianceSearchAction.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]SCComplianceSearchAction"
        }
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
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Security and Compliance Center" -Source "[O365DSCReverse]SCComplianceTag"
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

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCDLPCompliancePolicy\MSFT_SCDLPCompliancePolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Security and Compliance Center" -Source "[O365DSCReverse]SCDLPCompliancePolicy"
        }
    }
    #endregion

    #region "SCDLPComplianceRule"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSCDLPComplianceRule")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCDLPComplianceRule..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCDLPComplianceRule\MSFT_SCDLPComplianceRule.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Security and Compliance Center" -Source "[O365DSCReverse]SCDLPComplianceRule"
        }
    }
    #endregion

    #region "SCFilePlanPropertyAuthority"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSCFilePlanPropertyAuthority")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCFilePlanPropertyAuthority..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCFilePlanPropertyAuthority\MSFT_SCFilePlanPropertyAuthority.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Security and Compliance Center" -Source "[O365DSCReverse]SCFilePlanPropertyAuthority"
        }
    }
    #endregion

    #region "SCFilePlanPropertyCategory"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSCFilePlanPropertyCategory")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCFilePlanPropertyCategory..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCFilePlanPropertyCategory\MSFT_SCFilePlanPropertyCategory.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Security and Compliance Center" -Source "[O365DSCReverse]SCFilePlanPropertyCategory"
        }
    }
    #endregion

    #region "SCFilePlanPropertyCitation"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSCFilePlanPropertyCitation")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCFilePlanPropertyCitation..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCFilePlanPropertyCitation\MSFT_SCFilePlanPropertyCitation.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Security and Compliance Center" -Source "[O365DSCReverse]SCFilePlanPropertyCitation"
        }
    }
    #endregion

    #region "SCFilePlanPropertyDepartment"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSCFilePlanPropertyDepartment")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCFilePlanPropertyDepartment..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCFilePlanPropertyDepartment\MSFT_SCFilePlanPropertyDepartment.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Security and Compliance Center" -Source "[O365DSCReverse]SCFilePlanPropertyDepartment"
        }
    }
    #endregion

    #region "SCFilePlanPropertyReferenceId"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSCFilePlanPropertyReferenceId")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCFilePlanPropertyReferenceId..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCFilePlanPropertyReferenceId\MSFT_SCFilePlanPropertyReferenceId.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Security and Compliance Center" -Source "[O365DSCReverse]SCFilePlanPropertyReferenceId"
        }
    }
    #endregion

    #region "SCFilePlanPropertySubCategory"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSCFilePlanPropertySubCategory")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCFilePlanPropertySubCategory..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCFilePlanPropertySubCategory\MSFT_SCFilePlanPropertySubCategory.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Security and Compliance Center" -Source "[O365DSCReverse]SCFilePlanPropertySubCategory"
        }
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

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCRetentionCompliancePolicy\MSFT_SCRetentionCompliancePolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource  -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]SCRetentionCompliancePolicy"
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

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCRetentionComplianceRule\MSFT_SCRetentionComplianceRule.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent  += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]SCRetentionComplianceRule"
        }
    }
    #endregion

    #region "SCSensitivityLabel"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSCSensitivityLabel")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SC")))
    {
        try
        {
            Write-Information "Extracting SCSensitivityLabel..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCSensitivityLabel\MSFT_SCSensitivityLabel.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]SCSensitivityLabel"
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

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCSupervisoryReviewPolicy\MSFT_SCSupervisoryReviewPolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]SCSupervisoryReviewPolicy"
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

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SCSupervisoryReviewRule\MSFT_SCSupervisoryReviewRule.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]SCSupervisoryReviewRule"
        }
    }
    #endregion

    #region "SPOAccessControlSettings"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOAccessControlSettings")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOAccessControlSettings..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOAccessControlSettings\MSFT_SPOAccessControlSettings.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to Exchange Online" -Source "[O365DSCReverse]SPOAccessControlSettings"
        }
    }
    #endregion

    #region SPOApp
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOApp")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOApp..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOApp\MSFT_SPOApp.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]SPOApp"
        }
    }
    #endregion

    #region "SPOSite"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOSite")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOSite..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOSite\MSFT_SPOSite.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]SPOSite"
        }
    }
    #endregion

    #region SPOSharingSettings
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOSharingSettings")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOSharingSettings..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOSharingSettings\MSFT_SPOSharingSettings.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]SPOSharingSettings"
        }
    }
    #endregion

    #region SPOPropertyBag
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOPropertyBag")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOPropertyBag..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOPropertyBag\MSFT_SPOPropertyBag.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount -MaxProcesses $MaxProcesses
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]SPOPropertyBag"
        }
    }
    #endregion

    #region "SPOHubSite"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOHubSite")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOHubSite..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOHubSite\MSFT_SPOHubSite.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]SPOHubSite"
        }
    }
    #endregion

    #region "SPOSearchResultSource"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOSearchResultSource")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOSearchResultSource..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOSearchResultSource\MSFT_SPOSearchResultSource.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource-GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]SPOSearchResultSource"
        }
    }
    #endregion

    #region "SPOSearchManagedProperty"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOSearchManagedProperty")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOSearchManagedProperty..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOSearchManagedProperty\MSFT_SPOSearchManagedProperty.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]SPOSearchManagedProperty"
        }
    }
    #endregion

    #region SPOSiteAuditSetting
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOSiteAuditSettings")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOSiteAuditSettings..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOSiteAuditSettings\MSFT_SPOSiteAuditSettings.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]SPOSiteAuditSetting"
        }
    }
    #endregion

    #region SPOSiteDesign
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOSiteDesign")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOSiteDesign..."
            $ModuelPath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOSiteDesign\MSFT_SPOSiteDesign.psm1" `
                -Resolve

            Import-Module $ModuelPath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]SPOSiteDesign"
        }
    }
    #endregion

    #region SPOSiteDesignRights
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOSiteDesignRights")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOSiteDesignRights..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOSiteDesignRights\MSFT_SPOSiteDesignRights.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]SPOSiteDesignRights"
        }
    }
    #endregion

    #region SPOSiteGroups
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOSiteGroup")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOSiteGroups..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOSiteGroup\MSFT_SPOSiteGroup.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]SPOSiteGroup"
        }
    }
    #endregion

    #region SPOStorageEntity
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOStorageEntity")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOStorageEntity..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOStorageEntity\MSFT_SPOStorageEntity.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]SPOStorageEntity"
        }
    }
    #endregion

    #region SPOTenantCDNPolicy
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOTenantCDNPolicy")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOTenantCDNPolicy..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOTenantCDNPolicy\MSFT_SPOTenantCDNPolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]SPOTenantCDNPolicy"
        }
    }
    #endregion

    #region SPOTenantSettings
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOTenantSettings")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOTenantSettings..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOTenantSettings\MSFT_SPOTenantSettings.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null

            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]SPOTenantSettings"
        }
    }
    #endregion

    #region SPOTheme
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOTheme")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOTheme..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOTheme\MSFT_SPOTheme.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]SPOTheme"
        }
    }
    #endregion

    #region SPOUserProfileProperty
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckSPOUserProfileProperty")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("SPO")))
    {
        try
        {
            Write-Information "Extracting SPOUserProfileProperty..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_SPOUserProfileProperty\MSFT_SPOUserProfileProperty.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount -MaxProcesses $MaxProcesses
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]SPOUserProfileProperty"
        }
    }
    #endregion

    #region "TeamsUpgradeConfiguration"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckTeamsUpgradeConfiguration")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsUpgradeConfiguration..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsUpgradeConfiguration\MSFT_TeamsUpgradeConfiguration.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsUpgradeConfiguration"
        }
    }
    #endregion

    #region TeamsClientConfiguration
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckTeamsClientConfiguration")) -or
            $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsClientConfiguration..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsClientConfiguration\MSFT_TeamsClientConfiguration.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsClientConfiguration"
        }
    }
    #endregion

    #region TeamsGuestCallingConfiguration
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckTeamsGuestCallingConfiguration")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsGuestCallingConfiguration..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsGuestCallingConfiguration\MSFT_TeamsGuestCallingConfiguration.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsGuestCallingConfiguration"
        }
    }
    #endregion

    #region TeamsCallingPolicy
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckTeamsCallingPolicy")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsCallingPolicy..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsCallingPolicy\MSFT_TeamsCallingPolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsCallingPolicy"
        }
    }
    #endregion

    #region TeamsGuestMessagingConfiguration
    if (($null -ne $ComponentsToExtract -and
    $ComponentsToExtract.Contains("chckTeamsGuestMessagingConfiguration")) -or
    $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsGuestMessagingConfiguration..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsGuestMessagingConfiguration\MSFT_TeamsGuestMessagingConfiguration.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsGuestMessagingConfiguration"
        }
    }
    #endregion

    #region TeamsGuestMeetingConfiguraton
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckTeamsGuestMeetingConfiguration")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsGuestMeetingConfiguration..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsGuestMeetingConfiguration\MSFT_TeamsGuestMeetingConfiguration.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsGuestMeetingConfiguration"
        }
    }
    #endregion

    #region TeamsMessagingPolicy
    if (($null -ne $ComponentsToExtract -and
    $ComponentsToExtract.Contains("chckTeamsMessagingPolicy")) -or
    $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsMessagingPolicy..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsMessagingPolicy\MSFT_TeamsMessagingPolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsMessagingPolicy"
        }
    }
    #endregion

    #region TeamsChannelsPolicy
    if (($null -ne $ComponentsToExtract -and
    $ComponentsToExtract.Contains("chckTeamsChannelsPolicy")) -or
    $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsChannelsPolicy..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsChannelsPolicy\MSFT_TeamsChannelsPolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsChannelPolicy"
        }
    }
    #endregion

    #region TeamsMeetingPolicy
    if (($null -ne $ComponentsToExtract -and
    $ComponentsToExtract.Contains("chckTeamsMeetingPolicy")) -or
    $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsMeetingPolicy..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsMeetingPolicy\MSFT_TeamsMeetingPolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsMeetingPolicy"
        }
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
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsTeam\MSFT_TeamsTeam.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsTeam"
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

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsChannel\MSFT_TeamsChannel.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsChannel"
        }
    }
    #endregion

    #region "TeamsMeetingBroadcastConfiguration"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckTeamsMeetingBroadcastConfiguration")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsMeetingBroadcastConfiguration..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsMeetingBroadcastConfiguration\MSFT_TeamsMeetingBroadcastConfiguration.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsMeetingBroadcastConfiguration"
        }
    }
    #endregion

    #region TeamsEmergencyCallingPolicy
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckTeamsEmergencyCallingPolicy")) -or
    $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsEmergencyCallingPolicy..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsEmergencyCallingPolicy\MSFT_TeamsEmergencyCallingPolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsEmergencyCallingPolicy"
        }
    }
    #endregion

    #region "TeamsMeetingBroadcastPolicy"
    if (($null -ne $ComponentsToExtract -and
        $ComponentsToExtract.Contains("chckTeamsMeetingBroadcastPolicy")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsMeetingBroadcastPolicy..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsMeetingBroadcastPolicy\MSFT_TeamsMeetingBroadcastPolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsMeetingBroadcastPolicy"
        }
    }
    #endregion

    #region TeamsUpgradeConfiguration
    if (($null -ne $ComponentsToExtract -and
    $ComponentsToExtract.Contains("chckTeamsUpgradeConfiguration")) -or
    $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsUpgradeConfiguration..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsUpgradeConfiguration\MSFT_TeamsUpgradeConfiguration.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsUpgradeConfiguration"
        }
    }
    #endregion

    #region TeamsEmergencyCallRoutingPolicy
    if (($null -ne $ComponentsToExtract -and
    $ComponentsToExtract.Contains("chckTeamsEmergencyCallRoutingPolicy")) -or
    $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsEmergencyCallRoutingPolicy..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsEmergencyCallRoutingPolicy\MSFT_TeamsEmergencyCallRoutingPolicy.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsEmergencyCallRoutingPolicy"
        }
    }
    #endregion

    #region "TeamsUser"
    if (($null -ne $ComponentsToExtract -and
            $ComponentsToExtract.Contains("chckTeamsUser")) -or
        $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {

        try
        {
            Write-Information "Extracting TeamsUser..."
            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsUser\MSFT_TeamsUser.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -MaxProcesses $MaxProcesses `
                -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsUser"
        }
    }
    #endregion

    #region TeamsMeetingConfiguration
    if (($null -ne $ComponentsToExtract -and
    $ComponentsToExtract.Contains("chckTeamsMeetingConfiguration")) -or
    $AllComponents -or ($null -ne $Workloads -and $Workloads.Contains("TEAMS")))
    {
        try
        {
            Write-Information "Extracting TeamsMeetingConfiguration..."

            $ModulePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\DSCResources\MSFT_TeamsMeetingConfiguration\MSFT_TeamsMeetingConfiguration.psm1" `
                -Resolve

            Import-Module $ModulePath | Out-Null
            $DSCContent += Export-TargetResource -GlobalAdminAccount $GlobalAdminAccount
        }
        catch
        {
            New-Office365DSCLogEntry -Error $_ -Message "Could not connect to PnP" -Source "[O365DSCReverse]TeamsMeetingConfiguration"
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
    if ([System.String]::IsNullOrEmpty($Path))
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
            if ($?)
            { break
            }
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
