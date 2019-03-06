function DisplayGUI()
{
    #region Global
    $firstColumnLeft = 10
    $secondColumnLeft = 280
    $thirdColumnLeft = 540
    $topBannerHeight = 70
    #endregion


    $form = New-Object System.Windows.Forms.Form
    $screens = [System.Windows.Forms.Screen]::AllScreens
    $form.Width = $screens[0].Bounds.Width
    $form.Height = $screens[0].Bounds.Height - 60
    $form.WindowState = [System.Windows.Forms.FormWindowState]::Maximized

    $panelMain = New-Object System.Windows.Forms.Panel
    $panelMain.Width = $form.Width
    $panelMain.Height = $form.Height
    $panelMain.AutoScroll = $true

    #region Information Architecture
    $imgO365 = New-Object System.Windows.Forms.PictureBox
    imgO365.ImageLocation = "../../../../Images/Office365.jpg"
    $imgO365.Left = $firstColumnLeft
    $imgO365.Top = $topBannerHeight
    $panelMain.Controls.Add($imgO365)

    $pnlO365 = New-Object System.Windows.Forms.Panel
    $pnlO365.Top = 30 + $topBannerHeight
    $pnlO365.Left = $firstColumnLeft
    $pnlO365.Height = 80
    $pnlO365.Width = 220
    $pnlO365.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

    $chckO365AdminAuditLogConfig = New-Object System.Windows.Forms.CheckBox
    $chckO365AdminAuditLogConfig.Top = 0
    $chckO365AdminAuditLogConfig.AutoSize = $true;
    $chckO365AdminAuditLogConfig.Name = "chckO365AdminAuditLogConfig"
    $chckO365AdminAuditLogConfig.Checked = $true
    $chckO365AdminAuditLogConfig.Text = "Admin Audit Log Config"
    $pnlO365.Controls.Add($chckO365AdminAuditLogConfig)

    $chckQuotaTemplates = New-Object System.Windows.Forms.CheckBox
    $chckQuotaTemplates.Top = 20
    $chckQuotaTemplates.AutoSize = $true;
    $chckQuotaTemplates.Name = "chckQuotaTemplates"
    $chckQuotaTemplates.Checked = $true
    $chckQuotaTemplates.Text = "Quota Templates"
    $panelInformationArchitecture.Controls.Add($chckQuotaTemplates);

    $chckSiteCollection = New-Object System.Windows.Forms.CheckBox
    $chckSiteCollection.Top = 40
    $chckSiteCollection.AutoSize = $true;
    $chckSiteCollection.Name = "chckSiteCollection"
    $chckSiteCollection.Checked = $true
    $chckSiteCollection.Text = "Site Collections (SPSite)"
    $panelInformationArchitecture.Controls.Add($chckSiteCollection)

    $chckSPWeb = New-Object System.Windows.Forms.CheckBox
    $chckSPWeb.Top = 60
    $chckSPWeb.AutoSize = $true;
    $chckSPWeb.Name = "chckSPWeb"
    $chckSPWeb.Checked = $false
    $chckSPWeb.Text = "Subsites (SPWeb)"
    $panelInformationArchitecture.Controls.Add($chckSPWeb)

    $panelMain.Controls.Add($panelInformationArchitecture)
    #endregion

    #region Security
    $labelSecurity = New-Object System.Windows.Forms.Label
    $labelSecurity.Text = "Security:"
    $labelSecurity.AutoSize = $true
    $labelSecurity.Top = 120 + $topBannerHeight
    $labelSecurity.Left = $firstColumnLeft
    $labelSecurity.Font = [System.Drawing.Font]::new($labelSecurity.Font.Name, 14, [System.Drawing.FontStyle]::Bold)
    $panelMain.Controls.Add($labelSecurity)

    $panelSecurity = New-Object System.Windows.Forms.Panel
    $panelSecurity.Top = 150 + $topBannerHeight
    $panelSecurity.Left = $firstColumnLeft
    $panelSecurity.AutoSize = $true
    $panelSecurity.Width = 220
    $panelSecurity.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

    $chckFarmAdmin = New-Object System.Windows.Forms.CheckBox
    $chckFarmAdmin.Top = 0
    $chckFarmAdmin.AutoSize = $true;
    $chckFarmAdmin.Name = "chckFarmAdmin"
    $chckFarmAdmin.Checked = $true
    $chckFarmAdmin.Text = "Farm Administrators"
    $panelSecurity.Controls.Add($chckFarmAdmin);

    $chckManagedAccount = New-Object System.Windows.Forms.CheckBox
    $chckManagedAccount.Top = 20
    $chckManagedAccount.AutoSize = $true;
    $chckManagedAccount.Name = "chckManagedAccount"
    $chckManagedAccount.Checked = $true
    $chckManagedAccount.Text = "Managed Accounts"
    $panelSecurity.Controls.Add($chckManagedAccount);

    $chckPasswordChange = New-Object System.Windows.Forms.CheckBox
    $chckPasswordChange.Top = 40
    $chckPasswordChange.AutoSize = $true;
    $chckPasswordChange.Name = "chckPasswordChange"
    $chckPasswordChange.Checked = $true
    $chckPasswordChange.Text = "Password Change Settings"
    $panelSecurity.Controls.Add($chckPasswordChange);

    $chckRemoteTrust = New-Object System.Windows.Forms.CheckBox
    $chckRemoteTrust.Top = 60
    $chckRemoteTrust.AutoSize = $true;
    $chckRemoteTrust.Name = "chckRemoteTrust"
    $chckRemoteTrust.Checked = $true
    $chckRemoteTrust.Text = "Remote Farm Trust"
    $panelSecurity.Controls.Add($chckRemoteTrust);

    $chckSASecurity = New-Object System.Windows.Forms.CheckBox
    $chckSASecurity.Top = 80
    $chckSASecurity.AutoSize = $true;
    $chckSASecurity.Name = "chckSASecurity"
    $chckSASecurity.Checked = $true
    $chckSASecurity.Text = "Service Applications Security"
    $panelSecurity.Controls.Add($chckSASecurity)

    $chckTrustedIdentity = New-Object System.Windows.Forms.CheckBox
    $chckTrustedIdentity.Top = 100
    $chckTrustedIdentity.AutoSize = $true;
    $chckTrustedIdentity.Name = "chckTrustedIdentity"
    $chckTrustedIdentity.Checked = $true
    $chckTrustedIdentity.Text = "Trusted Identity Token Issuer"
    $panelSecurity.Controls.Add($chckTrustedIdentity);

    $panelMain.Controls.Add($panelSecurity)
    #endregion

    #region Service Applications
    $labelSA = New-Object System.Windows.Forms.Label
    $labelSA.Text = "Service Applications:"
    $labelSA.AutoSize = $true
    $labelSA.Top = 285 + $topBannerHeight
    $labelSA.Left = $firstColumnLeft
    $labelSA.Font = [System.Drawing.Font]::new($labelSA.Font.Name, 14, [System.Drawing.FontStyle]::Bold)
    $panelMain.Controls.Add($labelSA)

    $panelSA = New-Object System.Windows.Forms.Panel
    $panelSA.Top = 315 + $topBannerHeight
    $panelSA.Left = $firstColumnLeft
    $panelSA.AutoSize = $true
    $panelSA.Width = 220
    $panelSA.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

    $chckSAAccess = New-Object System.Windows.Forms.CheckBox
    $chckSAAccess.Top = 0
    $chckSAAccess.AutoSize = $true;
    $chckSAAccess.Name = "chckSAAccess"
    $chckSAAccess.Checked = $true
    $chckSAAccess.Text = "Access Services"
    $panelSA.Controls.Add($chckSAAccess);

    $chckSAAccess2010 = New-Object System.Windows.Forms.CheckBox
    $chckSAAccess2010.Top = 20
    $chckSAAccess2010.AutoSize = $true;
    $chckSAAccess2010.Name = "chckSAAccess2010"
    $chckSAAccess2010.Checked = $true
    $chckSAAccess2010.Text = "Access Services 2010"
    $panelSA.Controls.Add($chckSAAccess2010);

    $chckSAAppMan= New-Object System.Windows.Forms.CheckBox
    $chckSAAppMan.Top = 40
    $chckSAAppMan.AutoSize = $true;
    $chckSAAppMan.Name = "chckSAAppMan"
    $chckSAAppMan.Checked = $true
    $chckSAAppMan.Text = "App Management"
    $panelSA.Controls.Add($chckSAAppMan);

    $chckSABCS = New-Object System.Windows.Forms.CheckBox
    $chckSABCS.Top = 60
    $chckSABCS.AutoSize = $true;
    $chckSABCS.Name = "chckSABCS"
    $chckSABCS.Checked = $true
    $chckSABCS.Text = "Business Connectivity Services"
    $panelSA.Controls.Add($chckSABCS);

    $chckSAExcel = New-Object System.Windows.Forms.CheckBox
    $chckSAExcel.Top = 80
    $chckSAExcel.AutoSize = $true;
    $chckSAExcel.Name = "chckSAExcel"
    $chckSAExcel.Checked = $true
    $chckSAExcel.Text = "Excel Services"
    $panelSA.Controls.Add($chckSAExcel);

    $chckSAMachine = New-Object System.Windows.Forms.CheckBox
    $chckSAMachine.Top = 100
    $chckSAMachine.AutoSize = $true;
    $chckSAMachine.Name = "chckSAMachine"
    $chckSAMachine.Checked = $true
    $chckSAMachine.Text = "Machine Translation"
    $panelSA.Controls.Add($chckSAMachine);

    $chckSAMMS = New-Object System.Windows.Forms.CheckBox
    $chckSAMMS.Top = 120
    $chckSAMMS.AutoSize = $true;
    $chckSAMMS.Name = "chckSAMMS"
    $chckSAMMS.Checked = $true
    $chckSAMMS.Text = "Managed Metadata"
    $panelSA.Controls.Add($chckSAMMS);

    $chckSAPerformance = New-Object System.Windows.Forms.CheckBox
    $chckSAPerformance.Top = 140
    $chckSAPerformance.AutoSize = $true;
    $chckSAPerformance.Name = "chckSAWord"
    $chckSAPerformance.Checked = $true
    $chckSAPerformance.Text = "PerformancePoint"
    $panelSA.Controls.Add($chckSAPerformance);

    $chckSAPublish = New-Object System.Windows.Forms.CheckBox
    $chckSAPublish.Top = 160
    $chckSAPublish.AutoSize = $true;
    $chckSAPublish.Name = "chckSAPublish"
    $chckSAPublish.Checked = $true
    $chckSAPublish.Text = "Publish"
    $panelSA.Controls.Add($chckSAPublish);

    $chckSASecureStore = New-Object System.Windows.Forms.CheckBox
    $chckSASecureStore.Top = 180
    $chckSASecureStore.AutoSize = $true;
    $chckSASecureStore.Name = "chckSASecureStore"
    $chckSASecureStore.Checked = $true
    $chckSASecureStore.Text = "Secure Store"
    $panelSA.Controls.Add($chckSASecureStore);

    $chckSAState = New-Object System.Windows.Forms.CheckBox
    $chckSAState.Top = 200
    $chckSAState.AutoSize = $true;
    $chckSAState.Name = "chckSAState"
    $chckSAState.Checked = $true
    $chckSAState.Text = "State Service Application"
    $panelSA.Controls.Add($chckSAState);

    $chckSASub = New-Object System.Windows.Forms.CheckBox
    $chckSASub.Top = 220
    $chckSASub.AutoSize = $true;
    $chckSASub.Name = "chckSASub"
    $chckSASub.Checked = $true
    $chckSASub.Text = "Subscription settings"
    $panelSA.Controls.Add($chckSASub);

    $chckSAUsage = New-Object System.Windows.Forms.CheckBox
    $chckSAUsage.AutoSize = $true;
    $chckSAUsage.Top = 240;
    $chckSAUsage.Name = "chckSAUsage"
    $chckSAUsage.Checked = $true
    $chckSAUsage.Text = "Usage Service Application"
    $panelSA.Controls.Add($chckSAUsage);

    $chckSAVisio = New-Object System.Windows.Forms.CheckBox
    $chckSAVisio.Top = 260
    $chckSAVisio.AutoSize = $true;
    $chckSAVisio.Name = "chckSAVisio"
    $chckSAVisio.Checked = $true
    $chckSAVisio.Text = "Visio Graphics"
    $panelSA.Controls.Add($chckSAVisio);

    $chckSAWord = New-Object System.Windows.Forms.CheckBox
    $chckSAWord.Top = 280
    $chckSAWord.AutoSize = $true;
    $chckSAWord.Name = "chckSAWord"
    $chckSAWord.Checked = $true
    $chckSAWord.Text = "Word Automation"
    $panelSA.Controls.Add($chckSAWord);

    $chckSAWork = New-Object System.Windows.Forms.CheckBox
    $chckSAWork.Top = 300
    $chckSAWork.AutoSize = $true;
    $chckSAWork.Name = "chckSAWork"
    $chckSAWork.Checked = $true
    $chckSAWork.Text = "Work Management"
    $panelSA.Controls.Add($chckSAWork);

    $panelMain.Controls.Add($panelSA)
    #endregion

    #region Search
    $labelSearch = New-Object System.Windows.Forms.Label
    $labelSearch.Top = $topBannerHeight
    $labelSearch.Text = "Search:"
    $labelSearch.AutoSize = $true
    $labelSearch.Left = $secondColumnLeft
    $labelSearch.Font = [System.Drawing.Font]::new($labelSearch.Font.Name, 14, [System.Drawing.FontStyle]::Bold)
    $panelMain.Controls.Add($labelSearch)

    $panelSearch = New-Object System.Windows.Forms.Panel
    $panelSearch.Top = 30 + $topBannerHeight
    $panelSearch.Left = $secondColumnLeft
    $panelSearch.AutoSize = $true
    $panelSearch.Width = 220
    $panelSearch.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

    $chckSearchContentSource = New-Object System.Windows.Forms.CheckBox
    $chckSearchContentSource.Top = 0
    $chckSearchContentSource.AutoSize = $true;
    $chckSearchContentSource.Name = "chckSearchContentSource"
    $chckSearchContentSource.Checked = $true
    $chckSearchContentSource.Text = "Content Sources"
    $panelSearch.Controls.Add($chckSearchContentSource);

    $chckSearchCrawlRule = New-Object System.Windows.Forms.CheckBox
    $chckSearchCrawlRule.Top = 20
    $chckSearchCrawlRule.AutoSize = $true;
    $chckSearchCrawlRule.Name = "chckSearchCrawlRule"
    $chckSearchCrawlRule.Checked = $true
    $chckSearchCrawlRule.Text = "Crawl Rules"
    $panelSearch.Controls.Add($chckSearchCrawlRule);

    $chckSearchCrawlerImpact = New-Object System.Windows.Forms.CheckBox
    $chckSearchCrawlerImpact.Top = 40
    $chckSearchCrawlerImpact.AutoSize = $true;
    $chckSearchCrawlerImpact.Name = "chckSearchCrawlerImpact"
    $chckSearchCrawlerImpact.Checked = $true
    $chckSearchCrawlerImpact.Text = "Crawler Impact Rules"
    $panelSearch.Controls.Add($chckSearchCrawlerImpact);

    $chckSearchFileTypes = New-Object System.Windows.Forms.CheckBox
    $chckSearchFileTypes.Top = 60
    $chckSearchFileTypes.AutoSize = $true;
    $chckSearchFileTypes.Name = "chckSearchFileTypes"
    $chckSearchFileTypes.Checked = $false
    $chckSearchFileTypes.Text = "File Types"
    $panelSearch.Controls.Add($chckSearchFileTypes);

    $chckSearchIndexPart = New-Object System.Windows.Forms.CheckBox
    $chckSearchIndexPart.Top = 80
    $chckSearchIndexPart.AutoSize = $true;
    $chckSearchIndexPart.Name = "chckSearchIndexPart"
    $chckSearchIndexPart.Checked = $true
    $chckSearchIndexPart.Text = "Index Partitions"
    $panelSearch.Controls.Add($chckSearchIndexPart);

    $chckManagedProp = New-Object System.Windows.Forms.CheckBox
    $chckManagedProp.Top = 100
    $chckManagedProp.AutoSize = $true;
    $chckManagedProp.Name = "chckManagedProp"
    $chckManagedProp.Checked = $false
    $chckManagedProp.Text = "Managed Properties"
    $panelSearch.Controls.Add($chckManagedProp);

    $chckSearchResultSources = New-Object System.Windows.Forms.CheckBox
    $chckSearchResultSources.Top = 120
    $chckSearchResultSources.AutoSize = $true;
    $chckSearchResultSources.Name = "chckSearchResultSources"
    $chckSearchResultSources.Checked = $true
    $chckSearchResultSources.Text = "Result Sources"
    $panelSearch.Controls.Add($chckSearchResultSources);

    $chckSearchSA = New-Object System.Windows.Forms.CheckBox
    $chckSearchSA.Top = 140
    $chckSearchSA.AutoSize = $true;
    $chckSearchSA.Name = "chckSearchSA"
    $chckSearchSA.Checked = $true
    $chckSearchSA.Text = "Search Service Applications"
    $panelSearch.Controls.Add($chckSearchSA);

    $chckSearchTopo = New-Object System.Windows.Forms.CheckBox
    $chckSearchTopo.Top = 160
    $chckSearchTopo.AutoSize = $true
    $chckSearchTopo.Name = "chckSearchTopo"
    $chckSearchTopo.Checked = $true
    $chckSearchTopo.Text = "Topology"
    $panelSearch.Controls.Add($chckSearchTopo);

    $panelMain.Controls.Add($panelSearch)
    #endregion

    #region Web Applications
    $labelWebApplications = New-Object System.Windows.Forms.Label
    $labelWebApplications.Text = "Web Applications:"
    $labelWebApplications.AutoSize = $true
    $labelWebApplications.Top = $panelSearch.Height + $topBannerHeight + 40
    $labelWebApplications.Left = $secondColumnLeft
    $labelWebApplications.Font = [System.Drawing.Font]::new($labelWebApplications.Font.Name, 14, [System.Drawing.FontStyle]::Bold)
    $panelMain.Controls.Add($labelWebApplications)

    $panelWebApp = New-Object System.Windows.Forms.Panel
    $panelWebApp.Top = $panelSearch.Height + $topBannerHeight + 70
    $panelWebApp.Left = $secondColumnLeft
    $panelWebApp.AutoSize = $true
    $panelWebApp.Width = 220
    $panelWebApp.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

    $chckWAAppDomain = New-Object System.Windows.Forms.CheckBox
    $chckWAAppDomain.Top = 0
    $chckWAAppDomain.AutoSize = $true;
    $chckWAAppDomain.Name = "chckWAAppDomain"
    $chckWAAppDomain.Checked = $true
    $chckWAAppDomain.Text = "App Domain"
    $panelWebApp.Controls.Add($chckWAAppDomain);

    $chckWABlockedFiles = New-Object System.Windows.Forms.CheckBox
    $chckWABlockedFiles.Top = 20
    $chckWABlockedFiles.AutoSize = $true;
    $chckWABlockedFiles.Name = "chckWABlockedFiles"
    $chckWABlockedFiles.Checked = $true
    $chckWABlockedFiles.Text = "Blocked File Types"
    $panelWebApp.Controls.Add($chckWABlockedFiles);

    $chckWAExtension = New-Object System.Windows.Forms.CheckBox
    $chckWAExtension.Top = 40
    $chckWAExtension.AutoSize = $true;
    $chckWAExtension.Name = "chckWAExtension"
    $chckWAExtension.Checked = $true
    $chckWAExtension.Text = "Extensions"
    $panelWebApp.Controls.Add($chckWAExtension);

    $chckWAGeneral = New-Object System.Windows.Forms.CheckBox
    $chckWAGeneral.Top = 60
    $chckWAGeneral.AutoSize = $true;
    $chckWAGeneral.Name = "chckWAGeneral"
    $chckWAGeneral.Checked = $true
    $chckWAGeneral.Text = "General Settings"
    $panelWebApp.Controls.Add($chckWAGeneral);

    $chckWebAppPerm = New-Object System.Windows.Forms.CheckBox
    $chckWebAppPerm.Top = 80
    $chckWebAppPerm.AutoSize = $true
    $chckWebAppPerm.Name = "chckWebAppPerm"
    $chckWebAppPerm.Checked = $true
    $chckWebAppPerm.Text = "Permissions"
    $panelWebApp.Controls.Add($chckWebAppPerm);

    $chckWebAppPolicy = New-Object System.Windows.Forms.CheckBox
    $chckWebAppPolicy.Top = 100
    $chckWebAppPolicy.AutoSize = $true;
    $chckWebAppPolicy.Name = "chckWebAppPolicy"
    $chckWebAppPolicy.Checked = $true
    $chckWebAppPolicy.Text = "Policies"
    $panelWebApp.Controls.Add($chckWebAppPolicy);

    $chckWAProxyGroup = New-Object System.Windows.Forms.CheckBox
    $chckWAProxyGroup.Top = 120
    $chckWAProxyGroup.AutoSize = $true;
    $chckWAProxyGroup.Name = "chckWAProxyGroup"
    $chckWAProxyGroup.Checked = $true
    $chckWAProxyGroup.Text = "Proxy Groups"
    $panelWebApp.Controls.Add($chckWAProxyGroup);

    $chckWADeletion = New-Object System.Windows.Forms.CheckBox
    $chckWADeletion.Top = 140
    $chckWADeletion.AutoSize = $true;
    $chckWADeletion.Name = "chckWADeletion"
    $chckWADeletion.Checked = $true
    $chckWADeletion.Text = "Site Usage and Deletion"
    $panelWebApp.Controls.Add($chckWADeletion);

    $chckWAThrottling = New-Object System.Windows.Forms.CheckBox
    $chckWAThrottling.Top = 160
    $chckWAThrottling.AutoSize = $true;
    $chckWAThrottling.Name = "chckWAThrottling"
    $chckWAThrottling.Checked = $true
    $chckWAThrottling.Text = "Throttling Settings"
    $panelWebApp.Controls.Add($chckWAThrottling);

    $chckWebApp = New-Object System.Windows.Forms.CheckBox
    $chckWebApp.Top = 180
    $chckWebApp.AutoSize = $true;
    $chckWebApp.Name = "chckWebApp"
    $chckWebApp.Checked = $true
    $chckWebApp.Text = "Web Applications"
    $panelWebApp.Controls.Add($chckWebApp);

    $chckWAWorkflow = New-Object System.Windows.Forms.CheckBox
    $chckWAWorkflow.Top = 200
    $chckWAWorkflow.AutoSize = $true;
    $chckWAWorkflow.Name = "chckWAWorkflow"
    $chckWAWorkflow.Checked = $true
    $chckWAWorkflow.Text = "Workflow Settings"
    $panelWebApp.Controls.Add($chckWAWorkflow);

    $panelMain.Controls.Add($panelWebApp)
    #endregion

    #region Customization
    $labelCustomization = New-Object System.Windows.Forms.Label
    $labelCustomization.Text = "Customization:"
    $labelCustomization.AutoSize = $true
    $labelCustomization.Top = $panelWebApp.Top + $panelWebApp.Height + 10
    $labelCustomization.Left = $secondColumnLeft
    $labelCustomization.Font = [System.Drawing.Font]::new($labelCustomization.Font.Name, 14, [System.Drawing.FontStyle]::Bold)
    $panelMain.Controls.Add($labelCustomization)

    $panelCustomization = New-Object System.Windows.Forms.Panel
    $panelCustomization.Top = $panelWebApp.Top + $panelWebApp.Height + 40
    $panelCustomization.Left = $secondColumnLeft
    $panelCustomization.Height = 80
    $panelCustomization.Width = 220
    $panelCustomization.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

    $chckAppCatalog = New-Object System.Windows.Forms.CheckBox
    $chckAppCatalog.Top = 0
    $chckAppCatalog.AutoSize = $true;
    $chckAppCatalog.Name = "chckAppCatalog"
    $chckAppCatalog.Checked = $true
    $chckAppCatalog.Text = "App Catalog"
    $panelCustomization.Controls.Add($chckAppCatalog);

    $chckAppDomain = New-Object System.Windows.Forms.CheckBox
    $chckAppDomain.Top = 20
    $chckAppDomain.AutoSize = $true;
    $chckAppDomain.Name = "chckAppDomain"
    $chckAppDomain.Checked = $true
    $chckAppDomain.Text = "App Domain"
    $panelCustomization.Controls.Add($chckAppDomain);

    $chckAppStore = New-Object System.Windows.Forms.CheckBox
    $chckAppStore.Top = 40
    $chckAppStore.AutoSize = $true
    $chckAppStore.Name = "chckAppStore"
    $chckAppStore.Checked = $true
    $chckAppStore.Text = "App Store Settings"
    $panelCustomization.Controls.Add($chckAppStore);

    $chckFarmSolution = New-Object System.Windows.Forms.CheckBox
    $chckFarmSolution.Top = 60
    $chckFarmSolution.AutoSize = $true;
    $chckFarmSolution.Name = "chckFarmSolution"
    $chckFarmSolution.Checked = $true
    $chckFarmSolution.Text = "Farm Solutions"
    $panelCustomization.Controls.Add($chckFarmSolution);

    $panelMain.Controls.Add($panelCustomization)
    #endregion

    #region Configuration
    $labelConfiguration = New-Object System.Windows.Forms.Label
    $labelConfiguration.Text = "Configuration:"
    $labelConfiguration.AutoSize = $true
    $labelConfiguration.Top = $topBannerHeight
    $labelConfiguration.Left = $thirdColumnLeft
    $labelConfiguration.Font = [System.Drawing.Font]::new($labelConfiguration.Font.Name, 14, [System.Drawing.FontStyle]::Bold)
    $panelMain.Controls.Add($labelConfiguration)

    $panelConfig = New-Object System.Windows.Forms.Panel
    $panelConfig.Top = 30 + $topBannerHeight
    $panelConfig.Left = $thirdColumnLeft
    $panelConfig.AutoSize = $true
    $panelConfig.Width = 400
    $panelConfig.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

    $chckAlternateUrl = New-Object System.Windows.Forms.CheckBox
    $chckAlternateUrl.Top = 0
    $chckAlternateUrl.AutoSize = $true;
    $chckAlternateUrl.Name = "chckAlternateUrl"
    $chckAlternateUrl.Checked = $true
    $chckAlternateUrl.Text = "Alternate URL"
    $panelConfig.Controls.Add($chckAlternateUrl);

    $chckAntivirus = New-Object System.Windows.Forms.CheckBox
    $chckAntivirus.Top = 20
    $chckAntivirus.AutoSize = $true;
    $chckAntivirus.Name = "chckAntivirus"
    $chckAntivirus.Checked = $true
    $chckAntivirus.Text = "Antivirus Settings"
    $panelConfig.Controls.Add($chckAntivirus);

    $chckBlobCache = New-Object System.Windows.Forms.CheckBox
    $chckBlobCache.Top = 40
    $chckBlobCache.AutoSize = $true;
    $chckBlobCache.Name = "chckBlobCache"
    $chckBlobCache.Checked = $true
    $chckBlobCache.Text = "Blob Cache Settings"
    $panelConfig.Controls.Add($chckBlobCache);

    $chckCacheAccounts = New-Object System.Windows.Forms.CheckBox
    $chckCacheAccounts.Top = 60
    $chckCacheAccounts.AutoSize = $true;
    $chckCacheAccounts.Name = "chckCacheAccounts"
    $chckCacheAccounts.Checked = $true
    $chckCacheAccounts.Text = "Cache Accounts"
    $panelConfig.Controls.Add($chckCacheAccounts);

    $chckDiagLogging = New-Object System.Windows.Forms.CheckBox
    $chckDiagLogging.Top = 80
    $chckDiagLogging.AutoSize = $true;
    $chckDiagLogging.Name = "chckDiagLogging"
    $chckDiagLogging.Checked = $true
    $chckDiagLogging.Text = "Diagnostic Logging"
    $panelConfig.Controls.Add($chckDiagLogging);

    $chckDistributedCache= New-Object System.Windows.Forms.CheckBox
    $chckDistributedCache.Top = 100
    $chckDistributedCache.AutoSize = $true;
    $chckDistributedCache.Name = "chckDistributedCache"
    $chckDistributedCache.Checked = $true
    $chckDistributedCache.Text = "Distributed Cache Service"
    $panelConfig.Controls.Add($chckDistributedCache);

    $chckFarmConfig = New-Object System.Windows.Forms.CheckBox
    $chckFarmConfig.Top = 120
    $chckFarmConfig.AutoSize = $true;
    $chckFarmConfig.Name = "chckFarmConfig"
    $chckFarmConfig.Checked = $true
    $chckFarmConfig.Text = "Farm Configuration"
    $panelConfig.Controls.Add($chckFarmConfig);

    $chckFarmPropBag = New-Object System.Windows.Forms.CheckBox
    $chckFarmPropBag.Top = 140
    $chckFarmPropBag.AutoSize = $true;
    $chckFarmPropBag.Name = "chckFarmPropBag"
    $chckFarmPropBag.Checked = $true
    $chckFarmPropBag.Text = "Farm Property Bag"
    $panelConfig.Controls.Add($chckFarmPropBag);

    $chckFeature = New-Object System.Windows.Forms.CheckBox
    $chckFeature.Top = 160
    $chckFeature.AutoSize = $true;
    $chckFeature.Name = "chckFeature"
    $chckFeature.Checked = $false
    $chckFeature.Text = "Features"
    $panelConfig.Controls.Add($chckFeature);

    $chckHealth = New-Object System.Windows.Forms.CheckBox
    $chckHealth.Top = 180
    $chckHealth.AutoSize = $true;
    $chckHealth.Name = "chckHealth"
    $chckHealth.Checked = $false
    $chckHealth.Text = "Health Analyzer Rule States"
    $panelConfig.Controls.Add($chckHealth);

    $chckIRM = New-Object System.Windows.Forms.CheckBox
    $chckIRM.Top = 200
    $chckIRM.AutoSize = $true;
    $chckIRM.Name = "chckIRM"
    $chckIRM.Checked = $true
    $chckIRM.Text = "Information Rights Management Settings"
    $panelConfig.Controls.Add($chckIRM);

    $chckManagedPaths = New-Object System.Windows.Forms.CheckBox
    $chckManagedPaths.Top = 220
    $chckManagedPaths.AutoSize = $true;
    $chckManagedPaths.Name = "chckManagedPaths"
    $chckManagedPaths.Checked = $true
    $chckManagedPaths.Text = "Managed Paths"
    $panelConfig.Controls.Add($chckManagedPaths);

    $chckOOS = New-Object System.Windows.Forms.CheckBox
    $chckOOS.Top = 240
    $chckOOS.AutoSize = $true;
    $chckOOS.Name = "chckOOS"
    $chckOOS.Checked = $true
    $chckOOS.Text = "Office Online Server Bindings"
    $panelConfig.Controls.Add($chckOOS);

    $chckOutgoingEmail = New-Object System.Windows.Forms.CheckBox
    $chckOutgoingEmail.Top = 260
    $chckOutgoingEmail.AutoSize = $true;
    $chckOutgoingEmail.Name = "chckOutgoingEmail"
    $chckOutgoingEmail.Checked = $true
    $chckOutgoingEmail.Text = "Outgoing Email Settings"
    $panelConfig.Controls.Add($chckOutgoingEmail);

    $chckServiceAppPool = New-Object System.Windows.Forms.CheckBox
    $chckServiceAppPool.Top = 280
    $chckServiceAppPool.AutoSize = $true;
    $chckServiceAppPool.Name = "chckServiceAppPool"
    $chckServiceAppPool.Checked = $true
    $chckServiceAppPool.Text = "Service Application Pools"
    $panelConfig.Controls.Add($chckServiceAppPool);

    $chckServiceInstance = New-Object System.Windows.Forms.CheckBox
    $chckServiceInstance.Top = 300
    $chckServiceInstance.AutoSize = $true;
    $chckServiceInstance.Name = "chckServiceInstance"
    $chckServiceInstance.Checked = $true
    $chckServiceInstance.Text = "Service Instances"
    $panelConfig.Controls.Add($chckServiceInstance);

    $chckSessionState= New-Object System.Windows.Forms.CheckBox
    $chckSessionState.Top = 320
    $chckSessionState.AutoSize = $true;
    $chckSessionState.Name = "chckSessionState"
    $chckSessionState.Checked = $true
    $chckSessionState.Text = "Session State Service"
    $panelConfig.Controls.Add($chckSessionState);

    $chckDatabaseAAG= New-Object System.Windows.Forms.CheckBox
    $chckDatabaseAAG.Top = 340
    $chckDatabaseAAG.AutoSize = $true;
    $chckDatabaseAAG.Name = "chckDatabaseAAG"
    $chckDatabaseAAG.Checked = $false
    $chckDatabaseAAG.Text = "SQL Always On Availability Groups"
    $panelConfig.Controls.Add($chckDatabaseAAG);

    $chckTimerJob = New-Object System.Windows.Forms.CheckBox
    $chckTimerJob.Top = 360
    $chckTimerJob.AutoSize = $true;
    $chckTimerJob.Name = "chckTimerJob"
    $chckTimerJob.Checked = $false
    $chckTimerJob.Text = "Timer Job States"
    $panelConfig.Controls.Add($chckTimerJob);

    $panelMain.Controls.Add($panelConfig)
    #endregion

    #region User Profile Service
    $lblUPS = New-Object System.Windows.Forms.Label
    $lblUPS.Top = $panelConfig.Height + $topBannerHeight + 40
    $lblUPS.Text = "User Profile:"
    $lblUPS.AutoSize = $true
    $lblUPS.Left = $thirdColumnLeft
    $lblUPS.Font = [System.Drawing.Font]::new($lblUPS.Font.Name, 14, [System.Drawing.FontStyle]::Bold)
    $panelMain.Controls.Add($lblUPS)

    $panelUPS = New-Object System.Windows.Forms.Panel
    $panelUPS.Top = $panelConfig.Height + $topBannerHeight + 70
    $panelUPS.Left = $thirdColumnLeft
    $panelUPS.AutoSize = $true
    $panelUPS.Width = 400
    $panelUPS.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

    $chckUPSProp = New-Object System.Windows.Forms.CheckBox
    $chckUPSProp.Top = 0
    $chckUPSProp.AutoSize = $true;
    $chckUPSProp.Name = "chckUPSProp"
    $chckUPSProp.Checked = $false
    $chckUPSProp.Text = "Profile Properties"
    $panelUPS.Controls.Add($chckUPSProp);

    $chckUPSSection = New-Object System.Windows.Forms.CheckBox
    $chckUPSSection.Top = 20
    $chckUPSSection.AutoSize = $true
    $chckUPSSection.Name = "chckUPSSection"
    $chckUPSSection.Checked = $false
    $chckUPSSection.Text = "Profile Sections"
    $panelUPS.Controls.Add($chckUPSSection);

    $chckUPSSync = New-Object System.Windows.Forms.CheckBox
    $chckUPSSync.Top = 40
    $chckUPSSync.AutoSize = $true;
    $chckUPSSync.Name = "chckUPSSync"
    $chckUPSSync.Checked = $true
    $chckUPSSync.Text = "Synchronization Connections"
    $panelUPS.Controls.Add($chckUPSSync);

    $chckUPSA = New-Object System.Windows.Forms.CheckBox
    $chckUPSA.Top = 60
    $chckUPSA.AutoSize = $true;
    $chckUPSA.Name = "chckUPSA"
    $chckUPSA.Checked = $true
    $chckUPSA.Text = "User Profile Service Applications"
    $panelUPS.Controls.Add($chckUPSA);

    $chckUPSPermissions = New-Object System.Windows.Forms.CheckBox
    $chckUPSPermissions.Top = 80
    $chckUPSPermissions.AutoSize = $true;
    $chckUPSPermissions.Name = "chckUPSPermissions"
    $chckUPSPermissions.Checked = $true
    $chckUPSPermissions.Text = "User Profile Service Permissions"
    $panelUPS.Controls.Add($chckUPSPermissions);

    $panelMain.Controls.Add($panelUPS)
    #endregion

    #region Extraction Modes
    $liteComponents = @($chckSAAccess, $chckSAAccess2010, $chckAlternateURL, $chckAntivirus, $chckAppCatalog, $chckAppDomain, $chckSAAppMan, $chckAppStore, $chckSABCS, $chckBlobCache, $chckCacheAccounts, $chckContentDB, $chckDiagLogging, $chckDistributedCache, $chckSAExcel, $chckFarmConfig, $chckFarmAdmin, $chckFarmPropBag, $chckFarmSolution, $chckIRM, $chckSAMachine, $chckManagedAccount, $chckSAMMS, $chckManagedPaths, $chckOutgoingEmail, $chckSAPerformance, $chckSAPublish, $chckQuotaTemplates, $chckSearchContentSource, $chckSearchIndexPart, $chckSearchSA, $chckSearchTopo, $chckSASecureStore, $chckServiceAppPool, $chckWAProxyGroup, $chckServiceInstance, $chckSAState, $chckSiteCollection, $chckSessionState, $chckSASub, $chckUPSA, $chckSAVisio, $chckWebApp, $chckWebAppPerm, $chckWebAppPolicy, $chckSAWord, $chckSAWork, $chckSearchIndexPart, $chckWAAppDomain, $chckSessionState, $chckSAUsage)
    $defaultComponents = @($chckSAAccess, $chckSAAccess2010, $chckAlternateURL, $chckAntivirus, $chckAppCatalog, $chckAppDomain, $chckSAAppMan, $chckAppStore, $chckSABCS, $chckBlobCache, $chckCacheAccounts, $chckContentDB, $chckDiagLogging, $chckDistributedCache, $chckSAExcel, $chckFarmConfig, $chckFarmAdmin, $chckFarmPropBag, $chckFarmSolution, $chckIRM, $chckSAMachine, $chckManagedAccount, $chckSAMMS, $chckManagedPaths, $chckOutgoingEmail, $chckSAPerformance, $chckSAPublish, $chckQuotaTemplates, $chckSearchContentSource, $chckSearchIndexPart, $chckSearchSA, $chckSearchTopo, $chckSASecureStore, $chckServiceAppPool, $chckWAProxyGroup, $chckServiceInstance, $chckSAState, $chckSiteCollection, $chckSessionState, $chckSASub, $chckUPSA, $chckSAVisio, $chckWebApp, $chckWebAppPerm, $chckWebAppPolicy, $chckSAWord, $chckSAWork, $chckOOS, $chckPasswordChange, $chckRemoteTrust, $chckSearchCrawlerImpact, $chckSearchCrawlRule, $chckSearchResultSources, $chckSASecurity, $chckTrustedIdentity, $chckUPSPermissions, $chckUPSSync, $chckWABlockedFiles, $chckWAGeneral, $chckWAProxyGroup, $chckWADeletion, $chckWAThrottling, $chckWAWorkflow, $chckSearchIndexPart, $chckWAAppDomain, $chckWAExtension, $chckSessionState, $chckSAUsage)
    #endregion

    #region Top Menu
    $panelMenu = New-Object System.Windows.Forms.Panel
    $panelMenu.Height = $topBannerHeight
    $panelMenu.Width = $form.Width
    $panelMenu.BackColor = [System.Drawing.Color]::Silver

    $lblMode = New-Object System.Windows.Forms.Label
    $lblMode.Top = 25
    $lblMode.Text = "Extraction Modes:"
    $lblMode.AutoSize = $true
    $lblMode.Left = 10
    $lblMode.Font = [System.Drawing.Font]::new($lblMode.Font.Name, 8, [System.Drawing.FontStyle]::Bold)
    $panelMenu.Controls.Add($lblMode)

    $btnLite = New-Object System.Windows.Forms.Button
    $btnLite.Width = 50
    $btnLite.Top = 20
    $btnLite.Left = 120
    $btnLite.Text = "Lite"
    $btnLite.Add_Click({SelectComponentsForMode(1)})
    $panelMenu.Controls.Add($btnLite);

    $btnDefault = New-Object System.Windows.Forms.Button
    $btnDefault.Width = 50
    $btnDefault.Top = 20
    $btnDefault.Left = 170
    $btnDefault.Text = "Default"
    $btnDefault.Add_Click({SelectComponentsForMode(2)})
    $panelMenu.Controls.Add($btnDefault);

    $btnFull = New-Object System.Windows.Forms.Button
    $btnFull.Width = 50
    $btnFull.Top = 20
    $btnFull.Left = 220
    $btnFull.Text = "Full"
    $btnFull.Add_Click({SelectComponentsForMode(3)})
    $panelMenu.Controls.Add($btnFull);

    $btnClear = New-Object System.Windows.Forms.Button
    $btnClear.Width = 90
    $btnClear.Top = 20
    $btnClear.Left = 270
    $btnClear.BackColor = [System.Drawing.Color]::IndianRed
    $btnClear.ForeColor = [System.Drawing.Color]::White
    $btnClear.Text = "Unselect All"
    $btnClear.Add_Click({SelectComponentsForMode(0)})
    $panelMenu.Controls.Add($btnClear);

    $chckStandAlone = New-Object System.Windows.Forms.CheckBox
    $chckStandAlone.Width = 90
    $chckStandAlone.Top = 5
    $chckStandAlone.Left = 370
    $chckStandAlone.Text = "Standalone"
    $panelMenu.Controls.Add($chckStandAlone)

    $chckAzure = New-Object System.Windows.Forms.CheckBox
    $chckAzure.Width = 90
    $chckAzure.Top = 25
    $chckAzure.Left = 370
    $chckAzure.Text = "Azure"
    $panelMenu.Controls.Add($chckAzure)

    $chckRequiredUsers = New-Object System.Windows.Forms.CheckBox
    $chckRequiredUsers.Width = 200
    $chckRequiredUsers.Top = 45
    $chckRequiredUsers.Left = 370
    $chckRequiredUsers.Checked = $true
    $chckRequiredUsers.Text = "Generate Required Users Script"
    $panelMenu.Controls.Add($chckRequiredUsers)

    $lblFarmAccount = New-Object System.Windows.Forms.Label
    $lblFarmAccount.Text = "Farm Account:"
    $lblFarmAccount.Top = 10
    $lblFarmAccount.Left = 560
    $lblFarmAccount.Width = 90
    $lblFarmAccount.TextAlign = [System.Drawing.ContentAlignment]::TopRight
    $lblFarmAccount.Font = [System.Drawing.Font]::new($lblFarmAccount.Font.Name, 8, [System.Drawing.FontStyle]::Bold)
    $panelMenu.Controls.Add($lblFarmAccount)

    $txtFarmAccount = New-Object System.Windows.Forms.Textbox
    $txtFarmAccount.Text = "$($env:USERDOMAIN)\$($env:USERNAME)"
    $txtFarmAccount.Top = 5
    $txtFarmAccount.Left = 650
    $txtFarmAccount.Width = 150
    $txtFarmAccount.Font = [System.Drawing.Font]::new($txtFarmAccount.Font.Name, 10)
    $panelMenu.Controls.Add($txtFarmAccount)

    $lblPassword = New-Object System.Windows.Forms.Label
    $lblPassword.Text = "Password:"
    $lblPassword.Top = 47
    $lblPassword.Left = 560
    $lblPassword.Width = 90
    $lblPassword.TextAlign = [System.Drawing.ContentAlignment]::TopRight
    $lblPassword.Font = [System.Drawing.Font]::new($lblPassword.Font.Name, 8, [System.Drawing.FontStyle]::Bold)
    $panelMenu.Controls.Add($lblPassword)

    $txtPassword = New-Object System.Windows.Forms.Textbox
    $txtPassword.Top = 40
    $txtPassword.Left = 650
    $txtPassword.Width = 150
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
            $form.Hide();
            Get-SPReverseDSC;
        }
        else
        {
            [System.Windows.Forms.MessageBox]::Show("Please provide a password for the Farm Account")
        }
    })
    $panelMenu.Controls.Add($btnExtract);

    $panelMain.Controls.Add($panelMenu);
    #endregion

    $panelMain.AutoScroll = $true
    $form.Controls.Add($panelMain)
    $form.Text = "ReverseDSC for SharePoint - v" + $Script:version
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $form.ShowDialog()
}
