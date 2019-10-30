function SectionChanged
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Windows.Forms.CheckBox]
        $Control,

        [Parameter(Mandatory = $true)]
        [System.Windows.Forms.Panel]
        $Panel
    )

    foreach ($pnlControl in $Panel.Controls)
    {
        if ($pnlControl.GetType().ToString() -eq "System.Windows.Forms.Checkbox")
        {
            # TODO remove exception after the SPO Management Shell bug is fixed;
            if ($pnlControl.Name -ne 'chckSPOSite' -and $pnlControl.Name -ne 'chckSPOHubSite')
            {
                $pnlControl.Checked = $Control.Checked
            }
        }
    }
}
function Show-O365GUI
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.String]
        $Path
    )
    try
    {
        [CmdletBinding()]
        #region Global
        $firstColumnLeft = 10
        $secondColumnLeft = 340
        $thirdColumnLeft = 680
        $fourthColumnLeft = 1020
        $topBannerHeight = 70
        #endregion

        $form = New-Object System.Windows.Forms.Form
        $screens = [System.Windows.Forms.Screen]::AllScreens
        $form.Width = $screens[0].Bounds.Width
        $form.Height = $screens[0].Bounds.Height - 60
        $form.BackColor = [System.Drawing.Color]::White
        $form.WindowState = [System.Windows.Forms.FormWindowState]::Maximized

        $pnlMain = New-Object System.Windows.Forms.Panel
        $pnlMain.Width = $form.Width
        $pnlMain.Height = $form.Height
        $pnlMain.AutoScroll = $true

        #region Office 365
        $imgO365 = New-Object System.Windows.Forms.PictureBox
        $imagePath = $PSScriptRoot + "\..\Dependencies\Images\Office365.jpg"
        $imgO365.ImageLocation = $imagePath
        $imgO365.Left = $firstColumnLeft
        $imgO365.Top = $topBannerHeight
        $imgO365.AutoSize = $true
        $pnlMain.Controls.Add($imgO365)

        $pnlO365 = New-Object System.Windows.Forms.Panel
        $pnlO365.Top = 88 + $topBannerHeight
        $pnlO365.Left = $firstColumnLeft
        $pnlO365.Height = 60
        $pnlO365.Width = 300
        $pnlO365.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

        $chckO365AdminAuditLogConfig = New-Object System.Windows.Forms.CheckBox
        $chckO365AdminAuditLogConfig.Top = 0
        $chckO365AdminAuditLogConfig.AutoSize = $true;
        $chckO365AdminAuditLogConfig.Name = "chckO365AdminAuditLogConfig"
        $chckO365AdminAuditLogConfig.Checked = $true
        $chckO365AdminAuditLogConfig.Text = "Admin Audit Log Config"
        $pnlO365.Controls.Add($chckO365AdminAuditLogConfig)

        $chckO365Group = New-Object System.Windows.Forms.CheckBox
        $chckO365Group.Top = 20
        $chckO365Group.AutoSize = $true;
        $chckO365Group.Name = "chckO365Group"
        $chckO365Group.Checked = $true
        $chckO365Group.Text = "Groups"
        $pnlO365.Controls.Add($chckO365Group);

        $chckO365User = New-Object System.Windows.Forms.CheckBox
        $chckO365User.Top = 40
        $chckO365User.AutoSize = $true;
        $chckO365User.Name = "chckO365User"
        $chckO365User.Checked = $true
        $chckO365User.Text = "Users"
        $pnlO365.Controls.Add($chckO365User)

        $chckAllO365 = New-Object System.Windows.Forms.CheckBox
        $chckAllO365.Left = $FirstColumnLeft + 280
        $chckAllO365.Top = $topBannerHeight + 40
        $chckAllO365.Checked = $true
        $chckAllO365.AutoSize = $true
        $chckAllO365.Add_CheckedChanged({SectionChanged -Control $chckAllO365 -Panel $pnlO365})
        $pnlMain.Controls.Add($chckAllO365)
        #endregion

        #region Exchange
        $imgExo = New-Object System.Windows.Forms.PictureBox
        $imagePath = $PSScriptRoot + "\..\Dependencies\Images\Exchange.jpg"
        $imgExo.ImageLocation = $imagePath
        $imgExo.Left = $firstColumnLeft
        $imgExo.Top = 300 + $topBannerHeight
        $imgExo.AutoSize = $true
        $pnlMain.Controls.Add($imgExo)

        $pnlExo = New-Object System.Windows.Forms.Panel
        $pnlExo.Top = 388 + $topBannerHeight
        $pnlExo.Left = $firstColumnLeft
        $pnlExo.Height = 320
        $pnlExo.Width = 300
        $pnlExo.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

        $chckEXOAtpPolicyForO365 = New-Object System.Windows.Forms.CheckBox
        $chckEXOAtpPolicyForO365.Top = 0
        $chckEXOAtpPolicyForO365.AutoSize = $true;
        $chckEXOAtpPolicyForO365.Name = "chckEXOAtpPolicyForO365"
        $chckEXOAtpPolicyForO365.Checked = $true
        $chckEXOAtpPolicyForO365.Text = "Advanced Threat Protection Policies"
        $pnlExo.Controls.Add($chckEXOAtpPolicyForO365)

        $chckEXOClientAccessRule = New-Object System.Windows.Forms.CheckBox
        $chckEXOClientAccessRule.Top = 20
        $chckEXOClientAccessRule.AutoSize = $true;
        $chckEXOClientAccessRule.Name = "chckEXOClientAccessRule"
        $chckEXOClientAccessRule.Checked = $true
        $chckEXOClientAccessRule.Text = "Client Access Rule"
        $pnlExo.Controls.Add($chckEXOClientAccessRule)

        $chckEXOCASMailboxPlan = New-Object System.Windows.Forms.CheckBox
        $chckEXOCASMailboxPlan.Top = 40
        $chckEXOCASMailboxPlan.AutoSize = $true;
        $chckEXOCASMailboxPlan.Name = "chckEXOCASMailboxPlan"
        $chckEXOCASMailboxPlan.Checked = $true
        $chckEXOCASMailboxPlan.Text = "Client Access Service Mailbox Plan"
        $pnlExo.Controls.Add($chckEXOCASMailboxPlan)

        $chckEXODkimSigningConfig = New-Object System.Windows.Forms.CheckBox
        $chckEXODkimSigningConfig.Top = 60
        $chckEXODkimSigningConfig.AutoSize = $true;
        $chckEXODkimSigningConfig.Name = "chckEXODkimSigningConfig"
        $chckEXODkimSigningConfig.Checked = $true
        $chckEXODkimSigningConfig.Text = "DKIM Signing Configuration"
        $pnlExo.Controls.Add($chckEXODkimSigningConfig)

        $chckEXOHostedConnectionFilterPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOHostedConnectionFilterPolicy.Top = 80
        $chckEXOHostedConnectionFilterPolicy.AutoSize = $true;
        $chckEXOHostedConnectionFilterPolicy.Name = "chckEXOHostedConnectionFilterPolicy"
        $chckEXOHostedConnectionFilterPolicy.Checked = $true
        $chckEXOHostedConnectionFilterPolicy.Text = "Hosted Connection Filter Policy"
        $pnlExo.Controls.Add($chckEXOHostedConnectionFilterPolicy)

        $chckEXOHostedContentFilterPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOHostedContentFilterPolicy.Top = 100
        $chckEXOHostedContentFilterPolicy.AutoSize = $true;
        $chckEXOHostedContentFilterPolicy.Name = "chckEXOHostedContentFilterPolicy"
        $chckEXOHostedContentFilterPolicy.Checked = $true
        $chckEXOHostedContentFilterPolicy.Text = "Hosted Content Filter Policy"
        $pnlExo.Controls.Add($chckEXOHostedContentFilterPolicy)

        $chckEXOHostedContentFilterRule = New-Object System.Windows.Forms.CheckBox
        $chckEXOHostedContentFilterRule.Top = 120
        $chckEXOHostedContentFilterRule.AutoSize = $true;
        $chckEXOHostedContentFilterRule.Name = "chckEXOHostedContentFilterRule"
        $chckEXOHostedContentFilterRule.Checked = $true
        $chckEXOHostedContentFilterRule.Text = "Hosted Content Filter Rule"
        $pnlExo.Controls.Add($chckEXOHostedContentFilterRule)

        $chckEXOMailboxSettings = New-Object System.Windows.Forms.CheckBox
        $chckEXOMailboxSettings.Top = 140
        $chckEXOMailboxSettings.AutoSize = $true;
        $chckEXOMailboxSettings.Name = "chckEXOMailboxSettings"
        $chckEXOMailboxSettings.Checked = $true
        $chckEXOMailboxSettings.Text = "Mailbox Settings"
        $pnlExo.Controls.Add($chckEXOMailboxSettings)

        $chckEXOMailTips = New-Object System.Windows.Forms.CheckBox
        $chckEXOMailTips.Top = 160
        $chckEXOMailTips.AutoSize = $true;
        $chckEXOMailTips.Name = "chckEXOMailTips"
        $chckEXOMailTips.Checked = $true
        $chckEXOMailTips.Text = "Mail Tips"
        $pnlExo.Controls.Add($chckEXOMailTips);

        $chckEXOOrganizationConfig = New-Object System.Windows.Forms.CheckBox
        $chckEXOOrganizationConfig.Top = 180
        $chckEXOOrganizationConfig.AutoSize = $true;
        $chckEXOOrganizationConfig.Name = "chckEXOOrganizationConfig"
        $chckEXOOrganizationConfig.Checked = $true
        $chckEXOOrganizationConfig.Text = "Organization Config"
        $pnlExo.Controls.Add($chckEXOOrganizationConfig);

        $chckEXOOutboundSpamFilterPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOOutboundSpamFilterPolicy.Top = 200
        $chckEXOOutboundSpamFilterPolicy.AutoSize = $true;
        $chckEXOOutboundSpamFilterPolicy.Name = "chckEXOOutboundSpamFilterPolicy"
        $chckEXOOutboundSpamFilterPolicy.Checked = $true
        $chckEXOOutboundSpamFilterPolicy.Text = "Outbound Spam Filter Policy"
        $pnlExo.Controls.Add($chckEXOOutboundSpamFilterPolicy)

        $chckEXOSafeAttachmentPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOSafeAttachmentPolicy.Top = 220
        $chckEXOSafeAttachmentPolicy.AutoSize = $true;
        $chckEXOSafeAttachmentPolicy.Name = "chckEXOSafeAttachmentPolicy"
        $chckEXOSafeAttachmentPolicy.Checked = $true
        $chckEXOSafeAttachmentPolicy.Text = "Safe Attachment Policy"
        $pnlExo.Controls.Add($chckEXOSafeAttachmentPolicy)

        $chckEXOSafeAttachmentRule = New-Object System.Windows.Forms.CheckBox
        $chckEXOSafeAttachmentRule.Top = 240
        $chckEXOSafeAttachmentRule.AutoSize = $true;
        $chckEXOSafeAttachmentRule.Name = "chckEXOSafeAttachmentRule"
        $chckEXOSafeAttachmentRule.Checked = $true
        $chckEXOSafeAttachmentRule.Text = "Safe Attachment Rule"
        $pnlExo.Controls.Add($chckEXOSafeAttachmentRule)

        $chckEXOSafeLinksPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOSafeLinksPolicy.Top = 260
        $chckEXOSafeLinksPolicy.AutoSize = $true;
        $chckEXOSafeLinksPolicy.Name = "chckEXOSafeLinksPolicy"
        $chckEXOSafeLinksPolicy.Checked = $true
        $chckEXOSafeLinksPolicy.Text = "Safe Links Policy"
        $pnlExo.Controls.Add($chckEXOSafeLinksPolicy)

        $chckEXOSafeLinksRule = New-Object System.Windows.Forms.CheckBox
        $chckEXOSafeLinksRule.Top = 280
        $chckEXOSafeLinksRule.AutoSize = $true;
        $chckEXOSafeLinksRule.Name = "chckEXOSafeLinksRule"
        $chckEXOSafeLinksRule.Checked = $true
        $chckEXOSafeLinksRule.Text = "Safe Links Rule"
        $pnlExo.Controls.Add($chckEXOSafeLinksRule)

        $chckEXOSharedMailbox = New-Object System.Windows.Forms.CheckBox
        $chckEXOSharedMailbox.Top = 300
        $chckEXOSharedMailbox.AutoSize = $true;
        $chckEXOSharedMailbox.Name = "chckEXOSharedMailbox"
        $chckEXOSharedMailbox.Checked = $true
        $chckEXOSharedMailbox.Text = "Shared Mailboxes"
        $pnlExo.Controls.Add($chckEXOSharedMailbox)

        $chckAllEXO = New-Object System.Windows.Forms.CheckBox
        $chckAllEXO.Left = $FirstColumnLeft + 280
        $chckAllEXO.Top = $topBannerHeight + 340
        $chckAllEXO.Checked = $true
        $chckAllEXO.AutoSize = $true
        $chckAllEXO.Add_CheckedChanged({SectionChanged -Control $chckAllEXO -Panel $pnlEXO})
        $pnlMain.Controls.Add($chckAllEXO)
        #endregion

        #region SharePoint
        $imgSPO = New-Object System.Windows.Forms.PictureBox
        $imagePath = $PSScriptRoot + "\..\Dependencies\Images\SharePoint.jpg"
        $imgSPO.ImageLocation = $imagePath
        $imgSPO.Left = $SecondColumnLeft
        $imgSPO.Top = $topBannerHeight
        $imgSPO.AutoSize = $true
        $pnlMain.Controls.Add($imgSPO)

        $pnlSPO = New-Object System.Windows.Forms.Panel
        $pnlSPO.Top = 88 + $topBannerHeight
        $pnlSPO.Left = $SecondColumnLeft
        $pnlSPO.Height = 300
        $pnlSPO.Width = 300
        $pnlSPO.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

        $chckSPOAccessControlSettings = New-Object System.Windows.Forms.CheckBox
        $chckSPOAccessControlSettings.Top = 0
        $chckSPOAccessControlSettings.AutoSize = $true;
        $chckSPOAccessControlSettings.Name = "chckSPOAccessControlSettings"
        $chckSPOAccessControlSettings.Checked = $true
        $chckSPOAccessControlSettings.Text = "Access Control Settings"
        $pnlSPO.Controls.Add($chckSPOAccessControlSettings)

        $chckSPOApp = New-Object System.Windows.Forms.CheckBox
        $chckSPOApp.Top = 20
        $chckSPOApp.AutoSize = $true;
        $chckSPOApp.Name = "chckSPOApp"
        $chckSPOApp.Checked = $true
        $chckSPOApp.Text = "Apps"
        $pnlSPO.Controls.Add($chckSPOApp)

        $chckSPOHubSite = New-Object System.Windows.Forms.CheckBox
        $chckSPOHubSite.Top = 40
        $chckSPOHubSite.AutoSize = $true;
        $chckSPOHubSite.Name = "chckSPOHubSite"
        $chckSPOHubSite.Checked = $false #TODO enable after SPO Mgmt Shell bug is fixed
        $chckSPOHubSite.Enabled = $false #TODO enable after SPO Mgmt Shell bug is fixed
        $chckSPOHubSite.Text = "Hub Sites"
        $pnlSPO.Controls.Add($chckSPOHubSite)

        $chckSPOPropertyBag= New-Object System.Windows.Forms.CheckBox
        $chckSPOPropertyBag.Top = 60
        $chckSPOPropertyBag.AutoSize = $true;
        $chckSPOPropertyBag.Name = "chckSPOPropertyBag"
        $chckSPOPropertyBag.Checked = $true
        $chckSPOPropertyBag.Text = "Property Bags"
        $pnlSPO.Controls.Add($chckSPOPropertyBag)

        $chckSPOSearchManagedProperty = New-Object System.Windows.Forms.CheckBox
        $chckSPOSearchManagedProperty.Top = 80
        $chckSPOSearchManagedProperty.AutoSize = $true;
        $chckSPOSearchManagedProperty.Name = "chckSPOSearchManagedProperty"
        $chckSPOSearchManagedProperty.Checked = $true
        $chckSPOSearchManagedProperty.Text = "Search Managed Properties"
        $pnlSPO.Controls.Add($chckSPOSearchManagedProperty)

        $chckSPOSearchResultSource = New-Object System.Windows.Forms.CheckBox
        $chckSPOSearchResultSource.Top = 100
        $chckSPOSearchResultSource.AutoSize = $true;
        $chckSPOSearchResultSource.Name = "chckSPOSearchResultSource"
        $chckSPOSearchResultSource.Checked = $true
        $chckSPOSearchResultSource.Text = "Search Result Sources"
        $pnlSPO.Controls.Add($chckSPOSearchResultSource)

        $chckSPOSharingSettings = New-Object System.Windows.Forms.CheckBox
        $chckSPOSharingSettings.Top = 120
        $chckSPOSharingSettings.AutoSize = $true;
        $chckSPOSharingSettings.Name = "chckSPOSharingSettings"
        $chckSPOSharingSettings.Checked = $true
        $chckSPOSharingSettings.Enabled = $true
        $chckSPOSharingSettings.Text = "Sharing Settings"
        $pnlSPO.Controls.Add($chckSPOSharingSettings)

        $chckSPOSite = New-Object System.Windows.Forms.CheckBox
        $chckSPOSite.Top = 140
        $chckSPOSite.AutoSize = $true;
        $chckSPOSite.Name = "chckSPOSite"
        $chckSPOSite.Checked = $false #TODO enable after SPO Mgmt Shell bug is fixed
        $chckSPOSite.Enabled = $false #TODO enable after SPO Mgmt Shell bug is fixed
        $chckSPOSite.Text = "Site Collections"
        $pnlSPO.Controls.Add($chckSPOSite)

        $chckSPOSiteAuditSettings = New-Object System.Windows.Forms.CheckBox
        $chckSPOSiteAuditSettings.Top = 160
        $chckSPOSiteAuditSettings.AutoSize = $true;
        $chckSPOSiteAuditSettings.Name = "chckSPOSiteAuditSettings"
        $chckSPOSiteAuditSettings.Checked = $true
        $chckSPOSiteAuditSettings.Text = "Site Audit Settings"
        $pnlSPO.Controls.Add($chckSPOSiteAuditSettings)

        $chckSPOSiteDesignRights = New-Object System.Windows.Forms.CheckBox
        $chckSPOSiteDesignRights.Top = 180
        $chckSPOSiteDesignRights.AutoSize = $true;
        $chckSPOSiteDesignRights.Name = "chckSPOSiteDesignRights"
        $chckSPOSiteDesignRights.Checked = $true
        $chckSPOSiteDesignRights.Text = "Site Design Rights"
        $pnlSPO.Controls.Add($chckSPOSiteDesignRights)

        $chckSPOStorageEntity= New-Object System.Windows.Forms.CheckBox
        $chckSPOStorageEntity.Top = 200
        $chckSPOStorageEntity.AutoSize = $true;
        $chckSPOStorageEntity.Name = "chckSPOStorageEntity"
        $chckSPOStorageEntity.Checked = $true
        $chckSPOStorageEntity.Text = "Storage Entity"
        $pnlSPO.Controls.Add($chckSPOStorageEntity)

        $chckSPOTenantCDNPolicy = New-Object System.Windows.Forms.CheckBox
        $chckSPOTenantCDNPolicy.Top = 220
        $chckSPOTenantCDNPolicy.AutoSize = $true;
        $chckSPOTenantCDNPolicy.Name = "chckSPOTenantCDNPolicy"
        $chckSPOTenantCDNPolicy.Checked = $true
        $chckSPOTenantCDNPolicy.Text = "Tenant CDN Policies"
        $pnlSPO.Controls.Add($chckSPOTenantCDNPolicy)

        $chckSPOTenantSettings = New-Object System.Windows.Forms.CheckBox
        $chckSPOTenantSettings.Top = 240
        $chckSPOTenantSettings.AutoSize = $true;
        $chckSPOTenantSettings.Name = "chckSPOTenantSettings"
        $chckSPOTenantSettings.Checked = $true
        $chckSPOTenantSettings.Text = "Tenant Settings"
        $pnlSPO.Controls.Add($chckSPOTenantSettings)

        $chckSPOTheme = New-Object System.Windows.Forms.CheckBox
        $chckSPOTheme.Top = 260
        $chckSPOTheme.AutoSize = $true;
        $chckSPOTheme.Name = "chckSPOTheme"
        $chckSPOTheme.Checked = $true
        $chckSPOTheme.Text = "Themes"
        $pnlSPO.Controls.Add($chckSPOTheme)

        $chckSPOUserProfileProperty = New-Object System.Windows.Forms.CheckBox
        $chckSPOUserProfileProperty.Top = 280
        $chckSPOUserProfileProperty.AutoSize = $true;
        $chckSPOUserProfileProperty.Name = "chckSPOUserProfileProperty"
        $chckSPOUserProfileProperty.Checked = $true
        $chckSPOUserProfileProperty.Text = "User Profile Properties"
        $pnlSPO.Controls.Add($chckSPOUserProfileProperty)

        $chckAllSharePoint = New-Object System.Windows.Forms.CheckBox
        $chckAllSharePoint.Left = $SecondColumnLeft + 280
        $chckAllSharePoint.Top = $topBannerHeight + 40
        $chckAllSharePoint.Checked = $true
        $chckAllSharePoint.AutoSize = $true
        $chckAllSharePoint.Add_CheckedChanged({SectionChanged -Control $chckAllSharePoint -Panel $pnlSPO})
        $pnlMain.Controls.Add($chckAllSharePoint)
        #endregion

        #region Security and Compliance
        $imgSC = New-Object System.Windows.Forms.PictureBox
        $imagePath = $PSScriptRoot + "\..\Dependencies\Images\SecurityAndCompliance.png"
        $imgSC.ImageLocation = $imagePath
        $imgSC.Left = $SecondColumnLeft
        $imgSC.Top = $topBannerHeight + $pnlSPO.Height + $imgSPO.Height + 75
        $imgSC.AutoSize = $true
        $pnlMain.Controls.Add($imgSC)

        $pnlSC = New-Object System.Windows.Forms.Panel
        $pnlSC.Top = $pnlSPO.Height + $topBannerHeight + $imgSPO.Height + $imgSC.Height + 125
        $pnlSC.Left = $SecondColumnLeft

        $pnlSC.Height = 260
        $pnlSC.Width = 300
        $pnlSC.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

        $chckSCAuditConfigurationPolicy = New-Object System.Windows.Forms.CheckBox
        $chckSCAuditConfigurationPolicy.Top = 0
        $chckSCAuditConfigurationPolicy.AutoSize = $true;
        $chckSCAuditConfigurationPolicy.Name = "chckSCAuditConfigurationPolicy"
        $chckSCAuditConfigurationPolicy.Checked = $true
        $chckSCAuditConfigurationPolicy.Text = "Audit Configuration Policies"
        $pnlSC.Controls.Add($chckSCAuditConfigurationPolicy)

        $chckSCCaseHoldPolicy = New-Object System.Windows.Forms.CheckBox
        $chckSCCaseHoldPolicy.Top = 20
        $chckSCCaseHoldPolicy.AutoSize = $true;
        $chckSCCaseHoldPolicy.Name = "chckSCCaseHoldPolicy"
        $chckSCCaseHoldPolicy.Checked = $true
        $chckSCCaseHoldPolicy.Text = "Case Hold Policy"
        $pnlSC.Controls.Add($chckSCCaseHoldPolicy)

        $chckSCCaseHoldRule = New-Object System.Windows.Forms.CheckBox
        $chckSCCaseHoldRule.Top = 40
        $chckSCCaseHoldRule.AutoSize = $true;
        $chckSCCaseHoldRule.Name = "chckSCCaseHoldRule"
        $chckSCCaseHoldRule.Checked = $true
        $chckSCCaseHoldRule.Text = "Case Hold Rule"
        $pnlSC.Controls.Add($chckSCCaseHoldRule)

        $chckSCComplianceCase = New-Object System.Windows.Forms.CheckBox
        $chckSCComplianceCase.Top = 60
        $chckSCComplianceCase.AutoSize = $true;
        $chckSCComplianceCase.Name = "chckSCComplianceCase"
        $chckSCComplianceCase.Checked = $true
        $chckSCComplianceCase.Text = "Compliance Case"
        $pnlSC.Controls.Add($chckSCComplianceCase)

        $chckSCComplianceSearch = New-Object System.Windows.Forms.CheckBox
        $chckSCComplianceSearch.Top = 80
        $chckSCComplianceSearch.AutoSize = $true;
        $chckSCComplianceSearch.Name = "chckSCComplianceSearch"
        $chckSCComplianceSearch.Checked = $true
        $chckSCComplianceSearch.Text = "Compliance Search"
        $pnlSC.Controls.Add($chckSCComplianceSearch)

        $chckSCComplianceSearchAction = New-Object System.Windows.Forms.CheckBox
        $chckSCComplianceSearchAction.Top = 100
        $chckSCComplianceSearchAction.AutoSize = $true;
        $chckSCComplianceSearchAction.Name = "chckSCComplianceSearchAction"
        $chckSCComplianceSearchAction.Checked = $true
        $chckSCComplianceSearchAction.Text = "Compliance Search Action"
        $pnlSC.Controls.Add($chckSCComplianceSearchAction)

        $chckSCComplianceTag = New-Object System.Windows.Forms.CheckBox
        $chckSCComplianceTag.Top = 120
        $chckSCComplianceTag.AutoSize = $true;
        $chckSCComplianceTag.Name = "chckSCComplianceTag"
        $chckSCComplianceTag.Checked = $true
        $chckSCComplianceTag.Text = "Compliance Tag"
        $pnlSC.Controls.Add($chckSCComplianceTag)

        $chckSCDLPCompliancePolicy = New-Object System.Windows.Forms.CheckBox
        $chckSCDLPCompliancePolicy.Top = 140
        $chckSCDLPCompliancePolicy.AutoSize = $true;
        $chckSCDLPCompliancePolicy.Name = "chckSCDLPCompliancePolicy"
        $chckSCDLPCompliancePolicy.Checked = $true
        $chckSCDLPCompliancePolicy.Text = "Data Loss Prevention Compliance Policy"
        $pnlSC.Controls.Add($chckSCDLPCompliancePolicy)

        $chckSCDLPComplianceRule = New-Object System.Windows.Forms.CheckBox
        $chckSCDLPComplianceRule.Top = 160
        $chckSCDLPComplianceRule.AutoSize = $true;
        $chckSCDLPComplianceRule.Name = "chckSCDLPComplianceRule"
        $chckSCDLPComplianceRule.Checked = $true
        $chckSCDLPComplianceRule.Text = "Data Loss Prevention Compliance Rule"
        $pnlSC.Controls.Add($chckSCDLPComplianceRule)

        $chckSCRetentionCompliancePolicy = New-Object System.Windows.Forms.CheckBox
        $chckSCRetentionCompliancePolicy.Top = 180
        $chckSCRetentionCompliancePolicy.AutoSize = $true;
        $chckSCRetentionCompliancePolicy.Name = "chckSCRetentionCompliancePolicy"
        $chckSCRetentionCompliancePolicy.Checked = $true
        $chckSCRetentionCompliancePolicy.Text = "Retention Compliance Policy"
        $pnlSC.Controls.Add($chckSCRetentionCompliancePolicy)

        $chckSCRetentionComplianceRule = New-Object System.Windows.Forms.CheckBox
        $chckSCRetentionComplianceRule.Top = 200
        $chckSCRetentionComplianceRule.AutoSize = $true;
        $chckSCRetentionComplianceRule.Name = "chckSCRetentionComplianceRule"
        $chckSCRetentionComplianceRule.Checked = $true
        $chckSCRetentionComplianceRule.Text = "Retention Compliance Rule"
        $pnlSC.Controls.Add($chckSCRetentionComplianceRule)

        $chckSCSupervisoryReviewPolicy = New-Object System.Windows.Forms.CheckBox
        $chckSCSupervisoryReviewPolicy.Top = 220
        $chckSCSupervisoryReviewPolicy.AutoSize = $true;
        $chckSCSupervisoryReviewPolicy.Name = "chckSCSupervisoryReviewPolicy"
        $chckSCSupervisoryReviewPolicy.Checked = $true
        $chckSCSupervisoryReviewPolicy.Text = "Supervisory Review Policy"
        $pnlSC.Controls.Add($chckSCSupervisoryReviewPolicy)

        $chckSCSupervisoryReviewRule = New-Object System.Windows.Forms.CheckBox
        $chckSCSupervisoryReviewRule.Top = 240
        $chckSCSupervisoryReviewRule.AutoSize = $true;
        $chckSCSupervisoryReviewRule.Name = "chckSCSupervisoryReviewRule"
        $chckSCSupervisoryReviewRule.Checked = $true
        $chckSCSupervisoryReviewRule.Text = "Supervisory Review Rule"
        $pnlSC.Controls.Add($chckSCSupervisoryReviewRule)

        $chckAllSC = New-Object System.Windows.Forms.CheckBox
        $chckAllSC.Left = $SecondColumnLeft + 280
        $chckAllSC.Top = $topBannerHeight + 440
        $chckAllSC.Checked = $true
        $chckAllSC.AutoSize = $true
        $chckAllSC.Add_CheckedChanged({SectionChanged -Control $chckAllSC -Panel $pnlSC})
        $pnlMain.Controls.Add($chckAllSC)
        #endregion

        #region Teams
        $imgTeams = New-Object System.Windows.Forms.PictureBox
        $imagePath = $PSScriptRoot + "\..\Dependencies\Images\Teams.jpg"
        $imgTeams.ImageLocation = $imagePath
        $imgTeams.Left = $ThirdColumnLeft
        $imgTeams.Top = $topBannerHeight
        $imgTeams.AutoSize = $true
        $pnlMain.Controls.Add($imgTeams)

        $pnlTeams = New-Object System.Windows.Forms.Panel
        $pnlTeams.Top = 88 + $topBannerHeight
        $pnlTeams.Left = $ThirdColumnLeft
        $pnlTeams.Height = 60
        $pnlTeams.Width = 300
        $pnlTeams.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

        $chckTeamsChannel = New-Object System.Windows.Forms.CheckBox
        $chckTeamsChannel.Top = 0
        $chckTeamsChannel.AutoSize = $true;
        $chckTeamsChannel.Name = "chckTeamsChannel"
        $chckTeamsChannel.Checked = $true
        $chckTeamsChannel.Text = "Channels"
        $pnlTeams.Controls.Add($chckTeamsChannel)

        $chckTeamsTeam = New-Object System.Windows.Forms.CheckBox
        $chckTeamsTeam.Top = 20
        $chckTeamsTeam.AutoSize = $true;
        $chckTeamsTeam.Name = "chckTeamsTeam"
        $chckTeamsTeam.Checked = $true
        $chckTeamsTeam.Text = "Teams"
        $pnlTeams.Controls.Add($chckTeamsTeam)

        $chckTeamsUser = New-Object System.Windows.Forms.CheckBox
        $chckTeamsUser.Top = 40
        $chckTeamsUser.AutoSize = $true;
        $chckTeamsUser.Name = "chckTeamsUser"
        $chckTeamsUser.Checked = $true
        $chckTeamsUser.Text = "Users"
        $pnlTeams.Controls.Add($chckTeamsUser)

        $chckAllTeams = New-Object System.Windows.Forms.CheckBox
        $chckAllTeams.Left = $thirdColumnLeft + 280
        $chckAllTeams.Top = $topBannerHeight + 40
        $chckAllTeams.Checked = $true
        $chckAllTeams.AutoSize = $true
        $chckAllTeams.Add_CheckedChanged({SectionChanged -Control $chckAllTeams -Panel $pnlTeams})
        $pnlMain.Controls.Add($chckAllTeams)
        #endregion


        #region OneDrive
        $imgOD = New-Object System.Windows.Forms.PictureBox
        $imagePath = $PSScriptRoot + "\..\Dependencies\Images\OneDrive.jpg"
        $imgOD.ImageLocation = $imagePath
        $imgOD.Left = $fourthColumnLeft
        $imgOD.Top = $topBannerHeight
        $imgOD.AutoSize = $true
        $pnlMain.Controls.Add($imgOD)

        $pnlOD = New-Object System.Windows.Forms.Panel
        $pnlOD.Top = 88 + $topBannerHeight
        $pnlOD.Left = $fourthColumnLeft
        $pnlOD.Height = 20
        $pnlOD.Width = 300
        $pnlOD.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

        $chckODSettings = New-Object System.Windows.Forms.CheckBox
        $chckODSettings.Top = 0
        $chckODSettings.AutoSize = $true;
        $chckODSettings.Name = "chckODSettings"
        $chckODSettings.Checked = $false #TODO - Reactivate after SPO Mgmt Shell bug fix
        $chckODSettings.Enabled = $false #TODO - Reactivate after SPO Mgmt Shell bug fix
        $chckODSettings.Text = "OneDrive Settings"
        $pnlOD.Controls.Add($chckODSettings)

        $chckAllOD = New-Object System.Windows.Forms.CheckBox
        $chckAllOD.Left = $fourthColumnLeft + 280
        $chckAllOD.Top = $topBannerHeight + 40
        $chckAllOD.Enabled = $false #TODO - Reactivate after SPO Mgmt Shell bug fix
        $chckAllOD.Checked = $false #TODO - Reactivate after SPO Mgmt Shell bug fix
        $chckAllOD.AutoSize = $true
        $chckAllOD.Add_CheckedChanged({SectionChanged -Control $chckAllOD -Panel $pnlOD})
        $pnlMain.Controls.Add($chckAllOD)
        #endregion

        $pnlMain.Controls.Add($pnlO365)
        $pnlMain.Controls.Add($pnlExo)
        $pnlMain.Controls.Add($pnlOD)
        $pnlMain.Controls.Add($pnlSPO)
        $pnlMain.Controls.Add($pnlSC)
        $pnlMain.Controls.Add($pnlTeams)

        #region Extraction Modes
        $liteComponents = @()
        $defaultComponents = @()
        #endregion

        #region Top Menu
        $panelMenu = New-Object System.Windows.Forms.Panel
        $panelMenu.Height = $topBannerHeight
        $panelMenu.Width = $form.Width
        $panelMenu.BackColor = [System.Drawing.Color]::Silver

        $btnClear = New-Object System.Windows.Forms.Button
        $btnClear.Width = 150
        $btnClear.Top = 5
        $btnClear.Height = 60
        $btnClear.Left = 700
        $btnClear.BackColor = [System.Drawing.Color]::IndianRed
        $btnClear.ForeColor = [System.Drawing.Color]::White
        $btnClear.Text = "Unselect All"
        $btnClear.Add_Click({SelectComponentsForMode($pnlMain, 0)})
        $panelMenu.Controls.Add($btnClear);

        $lblFarmAccount = New-Object System.Windows.Forms.Label
        $lblFarmAccount.Text = "Tenant Admin:"
        $lblFarmAccount.Top = 10
        $lblFarmAccount.Left = 940
        $lblFarmAccount.AutoSize = $true
        $lblFarmAccount.TextAlign = [System.Drawing.ContentAlignment]::TopRight
        $lblFarmAccount.Font = [System.Drawing.Font]::new($lblFarmAccount.Font.Name, 8, [System.Drawing.FontStyle]::Bold)
        $panelMenu.Controls.Add($lblFarmAccount)

        $txtTenantAdmin = New-Object System.Windows.Forms.Textbox
        $txtTenantAdmin.Top = 5
        $txtTenantAdmin.Left = 1060
        $txtTenantAdmin.Width = 175
        $txtTenantAdmin.Font = [System.Drawing.Font]::new($txtTenantAdmin.Font.Name, 10)
        $panelMenu.Controls.Add($txtTenantAdmin)

        $lblPassword = New-Object System.Windows.Forms.Label
        $lblPassword.Text = "Password:"
        $lblPassword.Top = 47
        $lblPassword.Left = 940
        $lblPassword.AutoSize = $true
        $lblPassword.TextAlign = [System.Drawing.ContentAlignment]::TopRight
        $lblPassword.Font = [System.Drawing.Font]::new($lblPassword.Font.Name, 8, [System.Drawing.FontStyle]::Bold)
        $panelMenu.Controls.Add($lblPassword)

        $txtPassword = New-Object System.Windows.Forms.Textbox
        $txtPassword.Top = 40
        $txtPassword.Left = 1060
        $txtPassword.Width = 175
        $txtPassword.PasswordChar = "*"
        $txtPassword.Font = [System.Drawing.Font]::new($txtPassword.Font.Name, 10)
        $txtPassword.Add_KeyDown({
            if($_.KeyCode -eq [System.Windows.Forms.Keys]::Enter)
            {
                $btnExtract.PerformClick()
            }
        })
        $panelMenu.Controls.Add($txtPassword)

        $btnExtract = New-Object System.Windows.Forms.Button
        $btnExtract.Width = 178
        $btnExtract.Height = 70
        $btnExtract.Top = 0
        $btnExtract.Left = $form.Width - 200
        $btnExtract.BackColor = [System.Drawing.Color]::ForestGreen
        $btnExtract.ForeColor = [System.Drawing.Color]::White
        $btnExtract.Text = "Start Extraction"
        $btnExtract.Add_Click({
            if($txtPassword.Text.Length -gt 0)
            {
                $form.Hide()
                $SelectedComponents = @()
                foreach ($panel in ($form.Controls[0].Controls | Where-Object -FilterScript { $_.GetType().Name -eq "Panel"}))
                {
                    foreach ($checkbox in ($panel.Controls | Where-Object -FilterScript { $_.GetType().Name -eq "Checkbox"}))
                    {
                        if ($checkbox.Checked)
                        {
                            $SelectedComponents += $checkbox.Name
                        }
                    }
                }

                try
                {
                    $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ($txtTenantAdmin.Text, (ConvertTo-SecureString -String $txtPassword.Text -AsPlainText -Force))
                    Start-O365ConfigurationExtract -GlobalAdminAccount $GlobalAdminAccount `
                                                   -ComponentsToExtract $SelectedComponents `
                                                   -Path $Path
                }
                catch
                {
                    $Message = "Could not initiate the ReverseDSC Extraction"
                    New-Office365DSCLogEntry -Error $_ -Message $Message_
                }
            }
            else
            {
                [System.Windows.Forms.MessageBox]::Show("Please provide a password for the Tenant Admin Account")
            }
        })
        $panelMenu.Controls.Add($btnExtract);

        $pnlMain.Controls.Add($panelMenu);
        #endregion

        $pnlMain.AutoScroll = $true
        $form.Controls.Add($pnlMain)
        $form.ActiveControl = $txtTenantAdmin
        $form.Text = "ReverseDSC for Office 365"
        $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
        $return = $form.ShowDialog()
    }
    catch
    {

    }
}

function SelectComponentsForMode($panelMain, $mode){
    $components = $null
    if($mode -eq 1)
    {
        $components = $liteComponents
    }
    elseif($mode -eq 2)
    {
        $components = $defaultComponents
    }
    foreach($parent in $panelMain.Controls)
    {
        if($parent.GetType().ToString() -eq "System.Windows.Forms.Panel")
        {
            foreach($control in ([System.Windows.Forms.Panel]$parent).Controls){
                try{
                    if($mode -ne 3)
                    {
                        $control.Checked = $false
                    }
                    else
                    {
                        $control.Checked = $true
                    }
                }
                catch
                {
                    Write-Verbose $_
                }
            }
        }
        elseif($parent.GetType().ToString() -eq "System.Windows.Forms.Checkbox")
        {
            ([System.Windows.Forms.Checkbox]$parent).Checked = $false
        }
    }
    foreach($control in $components)
    {
        try{
            $control.Checked = $true
        }
        catch
        {

        }
    }
}
