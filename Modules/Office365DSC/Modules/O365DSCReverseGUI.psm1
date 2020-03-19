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

        #region Exchange
        $imgExo = New-Object System.Windows.Forms.PictureBox
        $imagePath = $PSScriptRoot + "\..\Dependencies\Images\Exchange.jpg"
        $imgExo.ImageLocation = $imagePath
        $imgExo.Left = $firstColumnLeft
        $imgExo.Top = $topBannerHeight
        $imgExo.AutoSize = $true
        $pnlMain.Controls.Add($imgExo)

        $pnlExo = New-Object System.Windows.Forms.Panel
        $pnlExo.Top = 88 + $topBannerHeight
        $pnlExo.Left = $firstColumnLeft
        $pnlExo.Height = 860
        $pnlExo.Width = 300
        $pnlExo.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

        $chckEXOAcceptedDomain = New-Object System.Windows.Forms.CheckBox
        $chckEXOAcceptedDomain.Top = 0
        $chckEXOAcceptedDomain.AutoSize = $true;
        $chckEXOAcceptedDomain.Name = "chckEXOAcceptedDomain"
        $chckEXOAcceptedDomain.Checked = $true
        $chckEXOAcceptedDomain.Text = "Accepted Domains"
        $pnlExo.Controls.Add($chckEXOAcceptedDomain)

        $chckEXOActiveSyncDeviceAccessRule = New-Object System.Windows.Forms.CheckBox
        $chckEXOActiveSyncDeviceAccessRule.Top = 20
        $chckEXOActiveSyncDeviceAccessRule.AutoSize = $true;
        $chckEXOActiveSyncDeviceAccessRule.Name = "chckEXOActiveSyncDeviceAccessRule"
        $chckEXOActiveSyncDeviceAccessRule.Checked = $true
        $chckEXOActiveSyncDeviceAccessRule.Text = "Active Sync Device Access Rule"
        $pnlExo.Controls.Add($chckEXOActiveSyncDeviceAccessRule)

        $chckEXOAddressBookPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOAddressBookPolicy.Top = 40
        $chckEXOAddressBookPolicy.AutoSize = $true;
        $chckEXOAddressBookPolicy.Name = "chckEXOAddressBookPolicy"
        $chckEXOAddressBookPolicy.Checked = $true
        $chckEXOAddressBookPolicy.Text = "Address Book Policy"
        $pnlExo.Controls.Add($chckEXOAddressBookPolicy)

        $chckEXOAddressList = New-Object System.Windows.Forms.CheckBox
        $chckEXOAddressList.Top = 60
        $chckEXOAddressList.AutoSize = $true;
        $chckEXOAddressList.Name = "chckEXOAddressList"
        $chckEXOAddressList.Checked = $true
        $chckEXOAddressList.Text = "Address Lists"
        $pnlExo.Controls.Add($chckEXOAddressList)

        $chckEXOAtpPolicyForO365 = New-Object System.Windows.Forms.CheckBox
        $chckEXOAtpPolicyForO365.Top = 80
        $chckEXOAtpPolicyForO365.AutoSize = $true;
        $chckEXOAtpPolicyForO365.Name = "chckEXOAtpPolicyForO365"
        $chckEXOAtpPolicyForO365.Checked = $true
        $chckEXOAtpPolicyForO365.Text = "Advanced Threat Protection Policies"
        $pnlExo.Controls.Add($chckEXOAtpPolicyForO365)

        $chckEXOAntiPhishPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOAntiPhishPolicy.Top = 100
        $chckEXOAntiPhishPolicy.AutoSize = $true;
        $chckEXOAntiPhishPolicy.Name = "chckEXOAntiPhishPolicy"
        $chckEXOAntiPhishPolicy.Checked = $true
        $chckEXOAntiPhishPolicy.Text = "Anti-Phish Policies"
        $pnlExo.Controls.Add($chckEXOAntiPhishPolicy)

        $chckEXOAntiPhishRule = New-Object System.Windows.Forms.CheckBox
        $chckEXOAntiPhishRule.Top = 120
        $chckEXOAntiPhishRule.AutoSize = $true;
        $chckEXOAntiPhishRule.Name = "chckEXOAntiPhishRule"
        $chckEXOAntiPhishRule.Checked = $true
        $chckEXOAntiPhishRule.Text = "Anti-Phish Rules"
        $pnlExo.Controls.Add($chckEXOAntiPhishRule)

        $chckEXOApplicationAccessPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOApplicationAccessPolicy.Top = 140
        $chckEXOApplicationAccessPolicy.AutoSize = $true;
        $chckEXOApplicationAccessPolicy.Name = "chckEXOApplicationAccessPolicy"
        $chckEXOApplicationAccessPolicy.Checked = $true
        $chckEXOApplicationAccessPolicy.Text = "Application Access Policies"
        $pnlExo.Controls.Add($chckEXOApplicationAccessPolicy)

        $chckEXOAvailabilityAddressSpace = New-Object System.Windows.Forms.CheckBox
        $chckEXOAvailabilityAddressSpace.Top = 160
        $chckEXOAvailabilityAddressSpace.AutoSize = $true;
        $chckEXOAvailabilityAddressSpace.Name = "chckEXOAvailabilityAddressSpace"
        $chckEXOAvailabilityAddressSpace.Checked = $true
        $chckEXOAvailabilityAddressSpace.Text = "Availability Address Spaces"
        $pnlExo.Controls.Add($chckEXOAvailabilityAddressSpace)

        $chckEXOAvailabilityConfig = New-Object System.Windows.Forms.CheckBox
        $chckEXOAvailabilityConfig.Top = 180
        $chckEXOAvailabilityConfig.AutoSize = $true;
        $chckEXOAvailabilityConfig.Name = "chckEXOAvailabilityConfig"
        $chckEXOAvailabilityConfig.Checked = $true
        $chckEXOAvailabilityConfig.Text = "Availability Config"
        $pnlExo.Controls.Add($chckEXOAvailabilityConfig)

        $chckEXOClientAccessRule = New-Object System.Windows.Forms.CheckBox
        $chckEXOClientAccessRule.Top = 200
        $chckEXOClientAccessRule.AutoSize = $true;
        $chckEXOClientAccessRule.Name = "chckEXOClientAccessRule"
        $chckEXOClientAccessRule.Checked = $true
        $chckEXOClientAccessRule.Text = "Client Access Rule"
        $pnlExo.Controls.Add($chckEXOClientAccessRule)

        $chckEXOCASMailboxPlan = New-Object System.Windows.Forms.CheckBox
        $chckEXOCASMailboxPlan.Top = 220
        $chckEXOCASMailboxPlan.AutoSize = $true;
        $chckEXOCASMailboxPlan.Name = "chckEXOCASMailboxPlan"
        $chckEXOCASMailboxPlan.Checked = $true
        $chckEXOCASMailboxPlan.Text = "Client Access Service Mailbox Plan"
        $pnlExo.Controls.Add($chckEXOCASMailboxPlan)

        $chckEXODkimSigningConfig = New-Object System.Windows.Forms.CheckBox
        $chckEXODkimSigningConfig.Top = 240
        $chckEXODkimSigningConfig.AutoSize = $true;
        $chckEXODkimSigningConfig.Name = "chckEXODkimSigningConfig"
        $chckEXODkimSigningConfig.Checked = $true
        $chckEXODkimSigningConfig.Text = "DKIM Signing Configuration"
        $pnlExo.Controls.Add($chckEXODkimSigningConfig)

        $chckEXOEmailAddressPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOEmailAddressPolicy.Top = 260
        $chckEXOEmailAddressPolicy.AutoSize = $true;
        $chckEXOEmailAddressPolicy.Name = "chckEXOEmailAddressPolicy"
        $chckEXOEmailAddressPolicy.Checked = $true
        $chckEXOEmailAddressPolicy.Text = "Email Address Policies"
        $pnlExo.Controls.Add($chckEXOEmailAddressPolicy)

        $chckEXOGlobalAddressList = New-Object System.Windows.Forms.CheckBox
        $chckEXOGlobalAddressList.Top = 280
        $chckEXOGlobalAddressList.AutoSize = $true;
        $chckEXOGlobalAddressList.Name = "chckEXOGlobalAddressList"
        $chckEXOGlobalAddressList.Checked = $true
        $chckEXOGlobalAddressList.Text = "Global Address Lists"
        $pnlExo.Controls.Add($chckEXOGlobalAddressList)

        $chckEXOHostedConnectionFilterPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOHostedConnectionFilterPolicy.Top = 300
        $chckEXOHostedConnectionFilterPolicy.AutoSize = $true;
        $chckEXOHostedConnectionFilterPolicy.Name = "chckEXOHostedConnectionFilterPolicy"
        $chckEXOHostedConnectionFilterPolicy.Checked = $true
        $chckEXOHostedConnectionFilterPolicy.Text = "Hosted Connection Filter Policy"
        $pnlExo.Controls.Add($chckEXOHostedConnectionFilterPolicy)

        $chckEXOHostedContentFilterPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOHostedContentFilterPolicy.Top = 320
        $chckEXOHostedContentFilterPolicy.AutoSize = $true;
        $chckEXOHostedContentFilterPolicy.Name = "chckEXOHostedContentFilterPolicy"
        $chckEXOHostedContentFilterPolicy.Checked = $true
        $chckEXOHostedContentFilterPolicy.Text = "Hosted Content Filter Policy"
        $pnlExo.Controls.Add($chckEXOHostedContentFilterPolicy)

        $chckEXOHostedContentFilterRule = New-Object System.Windows.Forms.CheckBox
        $chckEXOHostedContentFilterRule.Top = 340
        $chckEXOHostedContentFilterRule.AutoSize = $true;
        $chckEXOHostedContentFilterRule.Name = "chckEXOHostedContentFilterRule"
        $chckEXOHostedContentFilterRule.Checked = $true
        $chckEXOHostedContentFilterRule.Text = "Hosted Content Filter Rule"
        $pnlExo.Controls.Add($chckEXOHostedContentFilterRule)

        $chckEXOHostedOutboundSpamFilterPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOHostedOutboundSpamFilterPolicy.Top = 360
        $chckEXOHostedOutboundSpamFilterPolicy.AutoSize = $true;
        $chckEXOHostedOutboundSpamFilterPolicy.Name = "chckEXOHostedOutboundSpamFilterPolicy"
        $chckEXOHostedOutboundSpamFilterPolicy.Checked = $true
        $chckEXOHostedOutboundSpamFilterPolicy.Text = "Hosted Outbound Spam Filter Policy"
        $pnlExo.Controls.Add($chckEXOHostedOutboundSpamFilterPolicy)

        $chckEXOInboundConnector = New-Object System.Windows.Forms.CheckBox
        $chckEXOInboundConnector.Top = 380
        $chckEXOInboundConnector.AutoSize = $true;
        $chckEXOInboundConnector.Name = "chckEXOInboundConnector"
        $chckEXOInboundConnector.Checked = $true
        $chckEXOInboundConnector.Text = "Inbound Connectors"
        $pnlExo.Controls.Add($chckEXOInboundConnector)

        $chckEXOIntraOrganizationConnector = New-Object System.Windows.Forms.CheckBox
        $chckEXOIntraOrganizationConnector.Top = 400
        $chckEXOIntraOrganizationConnector.AutoSize = $true;
        $chckEXOIntraOrganizationConnector.Name = "chckEXOIntraOrganizationConnector"
        $chckEXOIntraOrganizationConnector.Checked = $true
        $chckEXOIntraOrganizationConnector.Text = "Intra-Organization Connectors"
        $pnlExo.Controls.Add($chckEXOIntraOrganizationConnector)

        $chckEXOMailboxSettings = New-Object System.Windows.Forms.CheckBox
        $chckEXOMailboxSettings.Top = 420
        $chckEXOMailboxSettings.AutoSize = $true;
        $chckEXOMailboxSettings.Name = "chckEXOMailboxSettings"
        $chckEXOMailboxSettings.Checked = $true
        $chckEXOMailboxSettings.Text = "Mailbox Settings"
        $pnlExo.Controls.Add($chckEXOMailboxSettings)

        $chckEXOMailTips = New-Object System.Windows.Forms.CheckBox
        $chckEXOMailTips.Top = 440
        $chckEXOMailTips.AutoSize = $true;
        $chckEXOMailTips.Name = "chckEXOMailTips"
        $chckEXOMailTips.Checked = $true
        $chckEXOMailTips.Text = "Mail Tips"
        $pnlExo.Controls.Add($chckEXOMailTips);

        $chckEXOMalwareFilterPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOMalwareFilterPolicy.Top = 460
        $chckEXOMalwareFilterPolicy.AutoSize = $true;
        $chckEXOMalwareFilterPolicy.Name = "chckEXOMalwareFilterPolicy"
        $chckEXOMalwareFilterPolicy.Checked = $true
        $chckEXOMalwareFilterPolicy.Text = "Malware Filter Policy"
        $pnlExo.Controls.Add($chckEXOMalwareFilterPolicy);

        $chckEXOMalwareFilterRule = New-Object System.Windows.Forms.CheckBox
        $chckEXOMalwareFilterRule.Top = 480
        $chckEXOMalwareFilterRule.AutoSize = $true;
        $chckEXOMalwareFilterRule.Name = "chckEXOMalwareFilterRule"
        $chckEXOMalwareFilterRule.Checked = $true
        $chckEXOMalwareFilterRule.Text = "Malware Filter Rule"
        $pnlExo.Controls.Add($chckEXOMalwareFilterRule);

        $chckEXOManagementRole = New-Object System.Windows.Forms.CheckBox
        $chckEXOManagementRole.Top = 500
        $chckEXOManagementRole.AutoSize = $true;
        $chckEXOManagementRole.Name = "chckEXOManagementRole"
        $chckEXOManagementRole.Checked = $true
        $chckEXOManagementRole.Text = "Management Roles"
        $pnlExo.Controls.Add($chckEXOManagementRole);

        $chckEXOMobileDeviceMailboxPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOMobileDeviceMailboxPolicy.Top = 520
        $chckEXOMobileDeviceMailboxPolicy.AutoSize = $true;
        $chckEXOMobileDeviceMailboxPolicy.Name = "chckEXOMobileDeviceMailboxPolicy"
        $chckEXOMobileDeviceMailboxPolicy.Checked = $true
        $chckEXOMobileDeviceMailboxPolicy.Text = "Mobile Device Mailbox Policy"
        $pnlExo.Controls.Add($chckEXOMobileDeviceMailboxPolicy);

        $chckEXOOfflineAddressBook = New-Object System.Windows.Forms.CheckBox
        $chckEXOOfflineAddressBook.Top = 540
        $chckEXOOfflineAddressBook.AutoSize = $true;
        $chckEXOOfflineAddressBook.Name = "chckEXOOfflineAddressBook"
        $chckEXOOfflineAddressBook.Checked = $true
        $chckEXOOfflineAddressBook.Text = "Offline Address Book"
        $pnlExo.Controls.Add($chckEXOOfflineAddressBook);

        $chckEXOOnPremisesOrganization = New-Object System.Windows.Forms.CheckBox
        $chckEXOOnPremisesOrganization.Top = 560
        $chckEXOOnPremisesOrganization.AutoSize = $true;
        $chckEXOOnPremisesOrganization.Name = "chckEXOOnPremisesOrganization"
        $chckEXOOnPremisesOrganization.Checked = $true
        $chckEXOOnPremisesOrganization.Text = "On-Premises Organizations"
        $pnlExo.Controls.Add($chckEXOOnPremisesOrganization)

        $chckEXOOrganizationConfig = New-Object System.Windows.Forms.CheckBox
        $chckEXOOrganizationConfig.Top = 580
        $chckEXOOrganizationConfig.AutoSize = $true;
        $chckEXOOrganizationConfig.Name = "chckEXOOrganizationConfig"
        $chckEXOOrganizationConfig.Checked = $true
        $chckEXOOrganizationConfig.Text = "Organization Config"
        $pnlExo.Controls.Add($chckEXOOrganizationConfig);

        $chckEXOOrganizationRelationship = New-Object System.Windows.Forms.CheckBox
        $chckEXOOrganizationRelationship.Top = 600
        $chckEXOOrganizationRelationship.AutoSize = $true;
        $chckEXOOrganizationRelationship.Name = "chckEXOOrganizationRelationship"
        $chckEXOOrganizationRelationship.Checked = $true
        $chckEXOOrganizationRelationship.Text = "Organization Relationships"
        $pnlExo.Controls.Add($chckEXOOrganizationRelationship)

        $chckEXOOutboundConnector = New-Object System.Windows.Forms.CheckBox
        $chckEXOOutboundConnector.Top = 620
        $chckEXOOutboundConnector.AutoSize = $true;
        $chckEXOOutboundConnector.Name = "chckEXOOutboundConnector"
        $chckEXOOutboundConnector.Checked = $true
        $chckEXOOutboundConnector.Text = "Outbound Connectors"
        $pnlExo.Controls.Add($chckEXOOutboundConnector)

        $chckEXOOwaMailboxPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOOwaMailboxPolicy.Top = 640
        $chckEXOOwaMailboxPolicy.AutoSize = $true;
        $chckEXOOwaMailboxPolicy.Name = "chckEXOOwaMailboxPolicy"
        $chckEXOOwaMailboxPolicy.Checked = $true
        $chckEXOOwaMailboxPolicy.Text = "OWA Mailbox Policies"
        $pnlExo.Controls.Add($chckEXOOwaMailboxPolicy)

        $chckEXOPartnerApplication = New-Object System.Windows.Forms.CheckBox
        $chckEXOPartnerApplication.Top = 660
        $chckEXOPartnerApplication.AutoSize = $true;
        $chckEXOPartnerApplication.Name = "chckEXOPartnerApplication"
        $chckEXOPartnerApplication.Checked = $true
        $chckEXOPartnerApplication.Text = "Partner Applications"
        $pnlExo.Controls.Add($chckEXOPartnerApplication)

        $chckEXOPolicyTipConfig = New-Object System.Windows.Forms.CheckBox
        $chckEXOPolicyTipConfig.Top = 680
        $chckEXOPolicyTipConfig.AutoSize = $true;
        $chckEXOPolicyTipConfig.Name = "chckEXOPolicyTipConfig"
        $chckEXOPolicyTipConfig.Checked = $true
        $chckEXOPolicyTipConfig.Text = "Policy Tip Configs"
        $pnlExo.Controls.Add($chckEXOPolicyTipConfig)

        $chckEXORemoteDomain = New-Object System.Windows.Forms.CheckBox
        $chckEXORemoteDomain.Top = 700
        $chckEXORemoteDomain.AutoSize = $true;
        $chckEXORemoteDomain.Name = "chckEXORemoteDomain"
        $chckEXORemoteDomain.Checked = $true
        $chckEXORemoteDomain.Text = "Remote Domains"
        $pnlExo.Controls.Add($chckEXORemoteDomain)

        $chckEXORoleAssignmentPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXORoleAssignmentPolicy.Top = 720
        $chckEXORoleAssignmentPolicy.AutoSize = $true;
        $chckEXORoleAssignmentPolicy.Name = "chckEXORoleAssignmentPolicy"
        $chckEXORoleAssignmentPolicy.Checked = $true
        $chckEXORoleAssignmentPolicy.Text = "Role Assignment Policies"
        $pnlExo.Controls.Add($chckEXORoleAssignmentPolicy)

        $chckEXOSafeAttachmentPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOSafeAttachmentPolicy.Top = 740
        $chckEXOSafeAttachmentPolicy.AutoSize = $true;
        $chckEXOSafeAttachmentPolicy.Name = "chckEXOSafeAttachmentPolicy"
        $chckEXOSafeAttachmentPolicy.Checked = $true
        $chckEXOSafeAttachmentPolicy.Text = "Safe Attachment Policy"
        $pnlExo.Controls.Add($chckEXOSafeAttachmentPolicy)

        $chckEXOSafeAttachmentRule = New-Object System.Windows.Forms.CheckBox
        $chckEXOSafeAttachmentRule.Top = 760
        $chckEXOSafeAttachmentRule.AutoSize = $true;
        $chckEXOSafeAttachmentRule.Name = "chckEXOSafeAttachmentRule"
        $chckEXOSafeAttachmentRule.Checked = $true
        $chckEXOSafeAttachmentRule.Text = "Safe Attachment Rule"
        $pnlExo.Controls.Add($chckEXOSafeAttachmentRule)

        $chckEXOSafeLinksPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOSafeLinksPolicy.Top = 780
        $chckEXOSafeLinksPolicy.AutoSize = $true;
        $chckEXOSafeLinksPolicy.Name = "chckEXOSafeLinksPolicy"
        $chckEXOSafeLinksPolicy.Checked = $true
        $chckEXOSafeLinksPolicy.Text = "Safe Links Policy"
        $pnlExo.Controls.Add($chckEXOSafeLinksPolicy)

        $chckEXOSafeLinksRule = New-Object System.Windows.Forms.CheckBox
        $chckEXOSafeLinksRule.Top = 800
        $chckEXOSafeLinksRule.AutoSize = $true;
        $chckEXOSafeLinksRule.Name = "chckEXOSafeLinksRule"
        $chckEXOSafeLinksRule.Checked = $true
        $chckEXOSafeLinksRule.Text = "Safe Links Rule"
        $pnlExo.Controls.Add($chckEXOSafeLinksRule)

        $chckEXOSharedMailbox = New-Object System.Windows.Forms.CheckBox
        $chckEXOSharedMailbox.Top = 820
        $chckEXOSharedMailbox.AutoSize = $true;
        $chckEXOSharedMailbox.Name = "chckEXOSharedMailbox"
        $chckEXOSharedMailbox.Checked = $true
        $chckEXOSharedMailbox.Text = "Shared Mailboxes"
        $pnlExo.Controls.Add($chckEXOSharedMailbox)

        $chckEXOSharingPolicy = New-Object System.Windows.Forms.CheckBox
        $chckEXOSharingPolicy.Top = 840
        $chckEXOSharingPolicy.AutoSize = $true;
        $chckEXOSharingPolicy.Name = "chckEXOSharingPolicy"
        $chckEXOSharingPolicy.Checked = $true
        $chckEXOSharingPolicy.Text = "Sharing Policies"
        $pnlExo.Controls.Add($chckEXOSharingPolicy)

        $chckAllEXO = New-Object System.Windows.Forms.CheckBox
        $chckAllEXO.Left = $FirstColumnLeft + 280
        $chckAllEXO.Top = $topBannerHeight + 40
        $chckAllEXO.Checked = $true
        $chckAllEXO.AutoSize = $true
        $chckAllEXO.Add_CheckedChanged( { SectionChanged -Control $chckAllEXO -Panel $pnlEXO })
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
        $pnlSPO.Height = 340
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
        $chckSPOHubSite.Checked = $true
        $chckSPOHubSite.Enabled = $true
        $chckSPOHubSite.Text = "Hub Sites"
        $pnlSPO.Controls.Add($chckSPOHubSite)

        $chckSPOHomeSite = New-Object System.Windows.Forms.CheckBox
        $chckSPOHomeSite.Top = 60
        $chckSPOHomeSite.AutoSize = $true;
        $chckSPOHomeSite.Name = "chckSPOHomeSite"
        $chckSPOHomeSite.Checked = $true
        $chckSPOHomeSite.Enabled = $true
        $chckSPOHomeSite.Text = "Home Sites"
        $pnlSPO.Controls.Add($chckSPOHomeSite)

        $chckSPOPropertyBag = New-Object System.Windows.Forms.CheckBox
        $chckSPOPropertyBag.Top = 80
        $chckSPOPropertyBag.AutoSize = $true;
        $chckSPOPropertyBag.Name = "chckSPOPropertyBag"
        $chckSPOPropertyBag.Checked = $true
        $chckSPOPropertyBag.Text = "Property Bags"
        $pnlSPO.Controls.Add($chckSPOPropertyBag)

        $chckSPOSearchManagedProperty = New-Object System.Windows.Forms.CheckBox
        $chckSPOSearchManagedProperty.Top = 100
        $chckSPOSearchManagedProperty.AutoSize = $true;
        $chckSPOSearchManagedProperty.Name = "chckSPOSearchManagedProperty"
        $chckSPOSearchManagedProperty.Checked = $true
        $chckSPOSearchManagedProperty.Text = "Search Managed Properties"
        $pnlSPO.Controls.Add($chckSPOSearchManagedProperty)

        $chckSPOSearchResultSource = New-Object System.Windows.Forms.CheckBox
        $chckSPOSearchResultSource.Top = 120
        $chckSPOSearchResultSource.AutoSize = $true;
        $chckSPOSearchResultSource.Name = "chckSPOSearchResultSource"
        $chckSPOSearchResultSource.Checked = $true
        $chckSPOSearchResultSource.Text = "Search Result Sources"
        $pnlSPO.Controls.Add($chckSPOSearchResultSource)

        $chckSPOSharingSettings = New-Object System.Windows.Forms.CheckBox
        $chckSPOSharingSettings.Top = 140
        $chckSPOSharingSettings.AutoSize = $true;
        $chckSPOSharingSettings.Name = "chckSPOSharingSettings"
        $chckSPOSharingSettings.Checked = $true
        $chckSPOSharingSettings.Enabled = $true
        $chckSPOSharingSettings.Text = "Sharing Settings"
        $pnlSPO.Controls.Add($chckSPOSharingSettings)

        $chckSPOSite = New-Object System.Windows.Forms.CheckBox
        $chckSPOSite.Top = 160
        $chckSPOSite.AutoSize = $true;
        $chckSPOSite.Name = "chckSPOSite"
        $chckSPOSite.Checked = $true
        $chckSPOSite.Enabled = $true
        $chckSPOSite.Text = "Site Collections"
        $pnlSPO.Controls.Add($chckSPOSite)

        $chckSPOSiteDesign = New-Object System.Windows.Forms.CheckBox
        $chckSPOSiteDesign.Top = 200
        $chckSPOSiteDesign.AutoSize = $true;
        $chckSPOSiteDesign.Name = "chckSPOSiteDesign"
        $chckSPOSiteDesign.Checked = $true
        $chckSPOSiteDesign.Text = "Site Designs"
        $pnlSPO.Controls.Add($chckSPOSiteDesign)

        $chckSPOSiteDesignRights = New-Object System.Windows.Forms.CheckBox
        $chckSPOSiteDesignRights.Top = 220
        $chckSPOSiteDesignRights.AutoSize = $true;
        $chckSPOSiteDesignRights.Name = "chckSPOSiteDesignRights"
        $chckSPOSiteDesignRights.Checked = $true
        $chckSPOSiteDesignRights.Text = "Site Design Rights"
        $pnlSPO.Controls.Add($chckSPOSiteDesignRights)

        $chckSPOSiteGroup = New-Object System.Windows.Forms.CheckBox
        $chckSPOSiteGroup.Top = 240
        $chckSPOSiteGroup.AutoSize = $true;
        $chckSPOSiteGroup.Name = "chckSPOSiteGroup"
        $chckSPOSiteGroup.Checked = $true
        $chckSPOSiteGroup.Enabled = $true
        $chckSPOSiteGroup.Text = "Site Groups"
        $pnlSPO.Controls.Add($chckSPOSiteGroup)

        $chckSPOStorageEntity = New-Object System.Windows.Forms.CheckBox
        $chckSPOStorageEntity.Top = 260
        $chckSPOStorageEntity.AutoSize = $true;
        $chckSPOStorageEntity.Name = "chckSPOStorageEntity"
        $chckSPOStorageEntity.Checked = $true
        $chckSPOStorageEntity.Text = "Storage Entity"
        $pnlSPO.Controls.Add($chckSPOStorageEntity)

        $chckSPOTenantCDNPolicy = New-Object System.Windows.Forms.CheckBox
        $chckSPOTenantCDNPolicy.Top = 280
        $chckSPOTenantCDNPolicy.AutoSize = $true;
        $chckSPOTenantCDNPolicy.Name = "chckSPOTenantCDNPolicy"
        $chckSPOTenantCDNPolicy.Checked = $true
        $chckSPOTenantCDNPolicy.Text = "Tenant CDN Policies"
        $pnlSPO.Controls.Add($chckSPOTenantCDNPolicy)

        $chckSPOTenantSettings = New-Object System.Windows.Forms.CheckBox
        $chckSPOTenantSettings.Top = 300
        $chckSPOTenantSettings.AutoSize = $true;
        $chckSPOTenantSettings.Name = "chckSPOTenantSettings"
        $chckSPOTenantSettings.Checked = $true
        $chckSPOTenantSettings.Text = "Tenant Settings"
        $pnlSPO.Controls.Add($chckSPOTenantSettings)

        $chckSPOTheme = New-Object System.Windows.Forms.CheckBox
        $chckSPOTheme.Top = 320
        $chckSPOTheme.AutoSize = $true;
        $chckSPOTheme.Name = "chckSPOTheme"
        $chckSPOTheme.Checked = $true
        $chckSPOTheme.Text = "Themes"
        $pnlSPO.Controls.Add($chckSPOTheme)

        $chckSPOUserProfileProperty = New-Object System.Windows.Forms.CheckBox
        $chckSPOUserProfileProperty.Top = 340
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
        $chckAllSharePoint.Add_CheckedChanged( { SectionChanged -Control $chckAllSharePoint -Panel $pnlSPO })
        $pnlMain.Controls.Add($chckAllSharePoint)
        #endregion

        #region Security and Compliance
        $imgSC = New-Object System.Windows.Forms.PictureBox
        $imagePath = $PSScriptRoot + "\..\Dependencies\Images\SecurityAndCompliance.png"
        $imgSC.ImageLocation = $imagePath
        $imgSC.Left = $SecondColumnLeft
        $imgSC.Top = $topBannerHeight + $pnlSPO.Height + $imgSPO.Height + 60
        $imgSC.AutoSize = $true
        $pnlMain.Controls.Add($imgSC)

        $pnlSC = New-Object System.Windows.Forms.Panel
        $pnlSC.Top = $pnlSPO.Height + $topBannerHeight + $imgSPO.Height + $imgSC.Height + 100
        $pnlSC.Left = $SecondColumnLeft

        $pnlSC.Height = 400
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

        $chckSCFilePlanPropertyAuthority = New-Object System.Windows.Forms.CheckBox
        $chckSCFilePlanPropertyAuthority.Top = 180
        $chckSCFilePlanPropertyAuthority.AutoSize = $true;
        $chckSCFilePlanPropertyAuthority.Name = "chckSCFilePlanPropertyAuthority"
        $chckSCFilePlanPropertyAuthority.Checked = $true
        $chckSCFilePlanPropertyAuthority.Text = "File Plan Property Authority"
        $pnlSC.Controls.Add($chckSCFilePlanPropertyAuthority)

        $chckSCFilePlanPropertyCategory = New-Object System.Windows.Forms.CheckBox
        $chckSCFilePlanPropertyCategory.Top = 200
        $chckSCFilePlanPropertyCategory.AutoSize = $true;
        $chckSCFilePlanPropertyCategory.Name = "chckSCFilePlanPropertyCategory"
        $chckSCFilePlanPropertyCategory.Checked = $true
        $chckSCFilePlanPropertyCategory.Text = "File Plan Property Category"
        $pnlSC.Controls.Add($chckSCFilePlanPropertyCategory)

        $chckSCFilePlanPropertyCitation = New-Object System.Windows.Forms.CheckBox
        $chckSCFilePlanPropertyCitation.Top = 220
        $chckSCFilePlanPropertyCitation.AutoSize = $true;
        $chckSCFilePlanPropertyCitation.Name = "chckSCFilePlanPropertyCitation"
        $chckSCFilePlanPropertyCitation.Checked = $true
        $chckSCFilePlanPropertyCitation.Text = "File Plan Property Citation"
        $pnlSC.Controls.Add($chckSCFilePlanPropertyCitation)

        $chckSCFilePlanPropertyDepartment = New-Object System.Windows.Forms.CheckBox
        $chckSCFilePlanPropertyDepartment.Top = 240
        $chckSCFilePlanPropertyDepartment.AutoSize = $true;
        $chckSCFilePlanPropertyDepartment.Name = "chckSCFilePlanPropertyDepartment"
        $chckSCFilePlanPropertyDepartment.Checked = $true
        $chckSCFilePlanPropertyDepartment.Text = "File Plan Property Department"
        $pnlSC.Controls.Add($chckSCFilePlanPropertyDepartment)

        $chckSCFilePlanPropertyReferenceId = New-Object System.Windows.Forms.CheckBox
        $chckSCFilePlanPropertyReferenceId.Top = 260
        $chckSCFilePlanPropertyReferenceId.AutoSize = $true;
        $chckSCFilePlanPropertyReferenceId.Name = "chckSCFilePlanPropertyReferenceId"
        $chckSCFilePlanPropertyReferenceId.Checked = $true
        $chckSCFilePlanPropertyReferenceId.Text = "File Plan Property Reference ID"
        $pnlSC.Controls.Add($chckSCFilePlanPropertyReferenceId)

        $chckSCFilePlanPropertySubCategory= New-Object System.Windows.Forms.CheckBox
        $chckSCFilePlanPropertySubCategory.Top = 280
        $chckSCFilePlanPropertySubCategory.AutoSize = $true;
        $chckSCFilePlanPropertySubCategory.Name = "chckSCFilePlanPropertySubCategory"
        $chckSCFilePlanPropertySubCategory.Checked = $true
        $chckSCFilePlanPropertySubCategory.Text = "File Plan Property Sub-Category"
        $pnlSC.Controls.Add($chckSCFilePlanPropertySubCategory)

        $chckSCRetentionCompliancePolicy = New-Object System.Windows.Forms.CheckBox
        $chckSCRetentionCompliancePolicy.Top = 300
        $chckSCRetentionCompliancePolicy.AutoSize = $true;
        $chckSCRetentionCompliancePolicy.Name = "chckSCRetentionCompliancePolicy"
        $chckSCRetentionCompliancePolicy.Checked = $true
        $chckSCRetentionCompliancePolicy.Text = "Retention Compliance Policy"
        $pnlSC.Controls.Add($chckSCRetentionCompliancePolicy)

        $chckSCRetentionComplianceRule = New-Object System.Windows.Forms.CheckBox
        $chckSCRetentionComplianceRule.Top = 320
        $chckSCRetentionComplianceRule.AutoSize = $true;
        $chckSCRetentionComplianceRule.Name = "chckSCRetentionComplianceRule"
        $chckSCRetentionComplianceRule.Checked = $true
        $chckSCRetentionComplianceRule.Text = "Retention Compliance Rule"
        $pnlSC.Controls.Add($chckSCRetentionComplianceRule)

        $chckSCSensitivityLabel = New-Object System.Windows.Forms.CheckBox
        $chckSCSensitivityLabel.Top = 340
        $chckSCSensitivityLabel.AutoSize = $true;
        $chckSCSensitivityLabel.Name = "chckSCSensitivityLabel"
        $chckSCSensitivityLabel.Checked = $true
        $chckSCSensitivityLabel.Text = "Sensitivity Label"
        $pnlSC.Controls.Add($chckSCSensitivityLabel)

        $chckSCSupervisoryReviewPolicy = New-Object System.Windows.Forms.CheckBox
        $chckSCSupervisoryReviewPolicy.Top = 360
        $chckSCSupervisoryReviewPolicy.AutoSize = $true;
        $chckSCSupervisoryReviewPolicy.Name = "chckSCSupervisoryReviewPolicy"
        $chckSCSupervisoryReviewPolicy.Checked = $true
        $chckSCSupervisoryReviewPolicy.Text = "Supervisory Review Policy"
        $pnlSC.Controls.Add($chckSCSupervisoryReviewPolicy)

        $chckSCSupervisoryReviewRule = New-Object System.Windows.Forms.CheckBox
        $chckSCSupervisoryReviewRule.Top = 380
        $chckSCSupervisoryReviewRule.AutoSize = $true;
        $chckSCSupervisoryReviewRule.Name = "chckSCSupervisoryReviewRule"
        $chckSCSupervisoryReviewRule.Checked = $true
        $chckSCSupervisoryReviewRule.Text = "Supervisory Review Rule"
        $pnlSC.Controls.Add($chckSCSupervisoryReviewRule)

        $chckAllSC = New-Object System.Windows.Forms.CheckBox
        $chckAllSC.Left = $SecondColumnLeft + 280
        $chckAllSC.Top = $topBannerHeight + 475
        $chckAllSC.Checked = $true
        $chckAllSC.AutoSize = $true
        $chckAllSC.Add_CheckedChanged( { SectionChanged -Control $chckAllSC -Panel $pnlSC })
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
        $pnlTeams.Height = 340
        $pnlTeams.Width = 300
        $pnlTeams.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

        $chckTeamsCallingPolicy = New-Object System.Windows.Forms.CheckBox
        $chckTeamsCallingPolicy.Top = 0
        $chckTeamsCallingPolicy.AutoSize = $true;
        $chckTeamsCallingPolicy.Name = "chckTeamsCallingPolicy"
        $chckTeamsCallingPolicy.Checked = $true
        $chckTeamsCallingPolicy.Text = "Calling Policies"
        $pnlTeams.Controls.Add($chckTeamsCallingPolicy)

        $chckTeamsChannel = New-Object System.Windows.Forms.CheckBox
        $chckTeamsChannel.Top = 20
        $chckTeamsChannel.AutoSize = $true;
        $chckTeamsChannel.Name = "chckTeamsChannel"
        $chckTeamsChannel.Checked = $true
        $chckTeamsChannel.Text = "Channels"
        $pnlTeams.Controls.Add($chckTeamsChannel)

        $chckTeamsChannelsPolicy = New-Object System.Windows.Forms.CheckBox
        $chckTeamsChannelsPolicy.Top = 40
        $chckTeamsChannelsPolicy.AutoSize = $true;
        $chckTeamsChannelsPolicy.Name = "chckTeamsChannelsPolicy"
        $chckTeamsChannelsPolicy.Checked = $true
        $chckTeamsChannelsPolicy.Text = "Channel Policies"
        $pnlTeams.Controls.Add($chckTeamsChannelsPolicy)

        $chckTeamsClientConfiguration = New-Object System.Windows.Forms.CheckBox
        $chckTeamsClientConfiguration.Top = 60
        $chckTeamsClientConfiguration.AutoSize = $true;
        $chckTeamsClientConfiguration.Name = "chckTeamsClientConfiguration"
        $chckTeamsClientConfiguration.Checked = $true
        $chckTeamsClientConfiguration.Text = "Client Configuration"
        $pnlTeams.Controls.Add($chckTeamsClientConfiguration)

        $chckTeamsEmergencyCallingPolicy = New-Object System.Windows.Forms.CheckBox
        $chckTeamsEmergencyCallingPolicy.Top = 80
        $chckTeamsEmergencyCallingPolicy.AutoSize = $true;
        $chckTeamsEmergencyCallingPolicy.Name = "chckTeamsEmergencyCallingPolicy"
        $chckTeamsEmergencyCallingPolicy.Checked = $true
        $chckTeamsEmergencyCallingPolicy.Text = "Emergency Calling Policies"
        $pnlTeams.Controls.Add($chckTeamsEmergencyCallingPolicy)

        $chckTeamsCallRoutingPolicy = New-Object System.Windows.Forms.CheckBox
        $chckTeamsCallRoutingPolicy.Top = 100
        $chckTeamsCallRoutingPolicy.AutoSize = $true;
        $chckTeamsCallRoutingPolicy.Name = "chckTeamsEmergencyCallRoutingPolicy"
        $chckTeamsCallRoutingPolicy.Checked = $true
        $chckTeamsCallRoutingPolicy.Text = "Emergency Call Routing Policies"
        $pnlTeams.Controls.Add($chckTeamsCallRoutingPolicy)

        $chckTeamsGuestCallingConfiguration = New-Object System.Windows.Forms.CheckBox
        $chckTeamsGuestCallingConfiguration.Top = 120
        $chckTeamsGuestCallingConfiguration.AutoSize = $true;
        $chckTeamsGuestCallingConfiguration.Name = "chckTeamsGuestCallingConfiguration"
        $chckTeamsGuestCallingConfiguration.Checked = $true
        $chckTeamsGuestCallingConfiguration.Text = "Guest Calling Configuration"
        $pnlTeams.Controls.Add($chckTeamsGuestCallingConfiguration)

        $chckTeamsGuestMeetingConfiguration = New-Object System.Windows.Forms.CheckBox
        $chckTeamsGuestMeetingConfiguration.Top = 140
        $chckTeamsGuestMeetingConfiguration.AutoSize = $true;
        $chckTeamsGuestMeetingConfiguration.Name = "chckTeamsGuestMeetingConfiguration"
        $chckTeamsGuestMeetingConfiguration.Checked = $true
        $chckTeamsGuestMeetingConfiguration.Text = "Guest Meeting Configuration"
        $pnlTeams.Controls.Add($chckTeamsGuestMeetingConfiguration)

        $chckTeamsGuestMessagingConfiguration = New-Object System.Windows.Forms.CheckBox
        $chckTeamsGuestMessagingConfiguration.Top = 160
        $chckTeamsGuestMessagingConfiguration.AutoSize = $true;
        $chckTeamsGuestMessagingConfiguration.Name = "chckTeamsGuestMessagingConfiguration"
        $chckTeamsGuestMessagingConfiguration.Checked = $true
        $chckTeamsGuestMessagingConfiguration.Text = "Guest Messaging Configuration"
        $pnlTeams.Controls.Add($chckTeamsGuestMessagingConfiguration)

        $chckTeamsMeetingBroadcastConfiguration = New-Object System.Windows.Forms.CheckBox
        $chckTeamsMeetingBroadcastConfiguration.Top = 180
        $chckTeamsMeetingBroadcastConfiguration.AutoSize = $true;
        $chckTeamsMeetingBroadcastConfiguration.Name = "chckTeamsMeetingBroadcastConfiguration"
        $chckTeamsMeetingBroadcastConfiguration.Checked = $true
        $chckTeamsMeetingBroadcastConfiguration.Text = "Meeting Broadcast Configuration"
        $pnlTeams.Controls.Add($chckTeamsMeetingBroadcastConfiguration)

        $chckTeamsMeetingBroadcastPolicy = New-Object System.Windows.Forms.CheckBox
        $chckTeamsMeetingBroadcastPolicy.Top = 200
        $chckTeamsMeetingBroadcastPolicy.AutoSize = $true;
        $chckTeamsMeetingBroadcastPolicy.Name = "chckTeamsMeetingBroadcastPolicy"
        $chckTeamsMeetingBroadcastPolicy.Checked = $true
        $chckTeamsMeetingBroadcastPolicy.Text = "Meeting Broadcast Policies"
        $pnlTeams.Controls.Add($chckTeamsMeetingBroadcastPolicy)

        $chckTeamsMeetingConfiguration = New-Object System.Windows.Forms.CheckBox
        $chckTeamsMeetingConfiguration.Top = 220
        $chckTeamsMeetingConfiguration.AutoSize = $true;
        $chckTeamsMeetingConfiguration.Name = "chckTeamsMeetingConfiguration"
        $chckTeamsMeetingConfiguration.Checked = $true
        $chckTeamsMeetingConfiguration.Text = "Meeting Configuration"
        $pnlTeams.Controls.Add($chckTeamsMeetingConfiguration)

        $chckTeamsMeetingPolicy = New-Object System.Windows.Forms.CheckBox
        $chckTeamsMeetingPolicy.Top = 240
        $chckTeamsMeetingPolicy.AutoSize = $true;
        $chckTeamsMeetingPolicy.Name = "chckTeamsMeetingPolicy"
        $chckTeamsMeetingPolicy.Checked = $true
        $chckTeamsMeetingPolicy.Text = "Meeting Policies"
        $pnlTeams.Controls.Add($chckTeamsMeetingPolicy)

        $chckTeamsMessagingPolicy = New-Object System.Windows.Forms.CheckBox
        $chckTeamsMessagingPolicy.Top = 260
        $chckTeamsMessagingPolicy.AutoSize = $true;
        $chckTeamsMessagingPolicy.Name = "chckTeamsMessagingPolicy"
        $chckTeamsMessagingPolicy.Checked = $true
        $chckTeamsMessagingPolicy.Text = "Messaging Policies"
        $pnlTeams.Controls.Add($chckTeamsMessagingPolicy)

        $chckTeamsTeam = New-Object System.Windows.Forms.CheckBox
        $chckTeamsTeam.Top = 280
        $chckTeamsTeam.AutoSize = $true;
        $chckTeamsTeam.Name = "chckTeamsTeam"
        $chckTeamsTeam.Checked = $true
        $chckTeamsTeam.Text = "Teams"
        $pnlTeams.Controls.Add($chckTeamsTeam)

        $chckTeamsUpgradeConfiguration = New-Object System.Windows.Forms.CheckBox
        $chckTeamsUpgradeConfiguration.Top = 300
        $chckTeamsUpgradeConfiguration.AutoSize = $true;
        $chckTeamsUpgradeConfiguration.Name = "chckTeamsUpgradeConfiguration"
        $chckTeamsUpgradeConfiguration.Checked = $true
        $chckTeamsUpgradeConfiguration.Text = "Upgrade Configuration"
        $pnlTeams.Controls.Add($chckTeamsUpgradeConfiguration)

        $chckTeamsUser = New-Object System.Windows.Forms.CheckBox
        $chckTeamsUser.Top = 320
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
        $chckAllTeams.Add_CheckedChanged( { SectionChanged -Control $chckAllTeams -Panel $pnlTeams })
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
        $chckAllOD.Add_CheckedChanged( { SectionChanged -Control $chckAllOD -Panel $pnlOD })
        $pnlMain.Controls.Add($chckAllOD)
        #endregion

        #region PowerApps
        $imgPP = New-Object System.Windows.Forms.PictureBox
        $imagePath = $PSScriptRoot + "\..\Dependencies\Images\PowerApps.png"
        $imgPP.ImageLocation = $imagePath
        $imgPP.Left = $fourthColumnLeft
        $imgPP.Top = $topBannerHeight + $pnlOd.Height + 100
        $imgPP.AutoSize = $true
        $pnlMain.Controls.Add($imgPP)

        $pnlPP = New-Object System.Windows.Forms.Panel
        $pnlPP.Top = 88 + $topBannerHeight + $pnlOD.Height + 100
        $pnlPP.Left = $fourthColumnLeft
        $pnlPP.Height = 20
        $pnlPP.Width = 300
        $pnlPP.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

        $chckPPPowerAppsEnvironment = New-Object System.Windows.Forms.CheckBox
        $chckPPPowerAppsEnvironment.Top = 0
        $chckPPPowerAppsEnvironment.AutoSize = $true;
        $chckPPPowerAppsEnvironment.Name = "chckPPPowerAppsEnvironment"
        $chckPPPowerAppsEnvironment.Checked = $true
        $chckPPPowerAppsEnvironment.Text = "PowerApps Environment"
        $pnlPP.Controls.Add($chckPPPowerAppsEnvironment)

        $chckAllPP = New-Object System.Windows.Forms.CheckBox
        $chckAllPP.Left = $fourthColumnLeft + 280
        $chckAllPP.Top = $topBannerHeight + $pnlOD.Height + 135
        $chckAllPP.Checked = $true
        $chckAllPP.AutoSize = $true
        $chckAllPP.Add_CheckedChanged( { SectionChanged -Control $chckAllPP -Panel $pnlPP })
        $pnlMain.Controls.Add($chckAllPP)
        #endregion

        #region Office 365
        $imgO365 = New-Object System.Windows.Forms.PictureBox
        $imagePath = $PSScriptRoot + "\..\Dependencies\Images\Office365.jpg"
        $imgO365.ImageLocation = $imagePath
        $imgO365.Left = $fourthColumnLeft
        $imgO365.Top = $topBannerHeight + $pnlOD.Height + $pnlPP.Height + 195
        $imgO365.AutoSize = $true
        $pnlMain.Controls.Add($imgO365)

        $pnlO365 = New-Object System.Windows.Forms.Panel
        $pnlO365.Top = $topBannerHeight + $pnlOD.Height + $pnlPP.Height + 290
        $pnlO365.Left = $fourthColumnLeft
        $pnlO365.Height = 80
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

        $chckO365OrgCustomizationSetting = New-Object System.Windows.Forms.CheckBox
        $chckO365OrgCustomizationSetting.Top = 40
        $chckO365OrgCustomizationSetting.AutoSize = $true;
        $chckO365OrgCustomizationSetting.Name = "chckO365OrgCustomizationSetting"
        $chckO365OrgCustomizationSetting.Checked = $true
        $chckO365OrgCustomizationSetting.Text = "Organization Customization Settings"
        $pnlO365.Controls.Add($chckO365OrgCustomizationSetting);

        $chckO365User = New-Object System.Windows.Forms.CheckBox
        $chckO365User.Top = 60
        $chckO365User.AutoSize = $true;
        $chckO365User.Name = "chckO365User"
        $chckO365User.Checked = $true
        $chckO365User.Text = "Users"
        $pnlO365.Controls.Add($chckO365User)

        $chckAllO365 = New-Object System.Windows.Forms.CheckBox
        $chckAllO365.Left = $fourthColumnLeft + 280
        $chckAllO365.Top = $topBannerHeight + $pnlOD.Height + $pnlPP.Height + 235
        $chckAllO365.Checked = $true
        $chckAllO365.AutoSize = $true
        $chckAllO365.Add_CheckedChanged( { SectionChanged -Control $chckAllO365 -Panel $pnlO365 })
        $pnlMain.Controls.Add($chckAllO365)
        #endregion

        $pnlMain.Controls.Add($pnlO365)
        $pnlMain.Controls.Add($pnlExo)
        $pnlMain.Controls.Add($pnlOD)
        $pnlMain.Controls.Add($pnlPP)
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
        $btnClear.Add_Click( { SelectComponentsForMode($pnlMain, 0) })
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
        $txtTenantAdmin.Width = 345
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
        $txtPassword.Width = 345
        $txtPassword.PasswordChar = "*"
        $txtPassword.Font = [System.Drawing.Font]::new($txtPassword.Font.Name, 10)
        $txtPassword.Add_KeyDown( {
                if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Enter)
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
        $btnExtract.Add_Click( {
                if ($txtPassword.Text.Length -gt 0)
                {
                    $form.Hide()
                    $SelectedComponents = @()
                    foreach ($panel in ($form.Controls[0].Controls | Where-Object -FilterScript { $_.GetType().Name -eq "Panel" }))
                    {
                        foreach ($checkbox in ($panel.Controls | Where-Object -FilterScript { $_.GetType().Name -eq "Checkbox" }))
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
                        New-Office365DSCLogEntry -Error $_ -Message $Message_ -Source "[O365DSCReverseGUI]"
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

function SelectComponentsForMode($panelMain, $mode)
{
    $components = $null
    if ($mode -eq 1)
    {
        $components = $liteComponents
    }
    elseif ($mode -eq 2)
    {
        $components = $defaultComponents
    }
    foreach ($parent in $panelMain.Controls)
    {
        if ($parent.GetType().ToString() -eq "System.Windows.Forms.Panel")
        {
            foreach ($control in ([System.Windows.Forms.Panel]$parent).Controls)
            {
                try
                {
                    if ($mode -ne 3)
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
        elseif ($parent.GetType().ToString() -eq "System.Windows.Forms.Checkbox")
        {
            ([System.Windows.Forms.Checkbox]$parent).Checked = $false
        }
    }
    foreach ($control in $components)
    {
        try
        {
            $control.Checked = $true
        }
        catch
        {

        }
    }
}
