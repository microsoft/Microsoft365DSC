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
function Show-M365DSCGUI
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
        $fifthColumnLeft = 1360
        $topBannerHeight = 110
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

        #region EXO
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
        $pnlExo.Height = 350
        $pnlExo.Width = 300
        $pnlExo.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
        $pnlExo.AutoScroll = $true
        $pnlEXONextControlPosition = -20

        $chckAllEXO = New-Object System.Windows.Forms.CheckBox
        $chckAllEXO.Left = $FirstColumnLeft + 280
        $chckAllEXO.Top = $topBannerHeight + 40
        $chckAllEXO.Checked = $true
        $chckAllEXO.AutoSize = $true
        $chckAllEXO.Add_CheckedChanged( { SectionChanged -Control $chckAllEXO -Panel $pnlEXO })
        $pnlMain.Controls.Add($chckAllEXO)
        #endregion

        #region SPO
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
        $pnlSPO.Height = 350
        $pnlSPO.Width = 300
        $pnlSPO.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
        $pnlSPO.AutoScroll = $true
        $pnlSPONextControlPosition = -20

        $chckAllSharePoint = New-Object System.Windows.Forms.CheckBox
        $chckAllSharePoint.Left = $SecondColumnLeft + 280
        $chckAllSharePoint.Top = $topBannerHeight + 40
        $chckAllSharePoint.Checked = $true
        $chckAllSharePoint.AutoSize = $true
        $chckAllSharePoint.Add_CheckedChanged( { SectionChanged -Control $chckAllSharePoint -Panel $pnlSPO })
        $pnlMain.Controls.Add($chckAllSharePoint)
        #endregion

        #region SecurityCompliance
        $imgSC = New-Object System.Windows.Forms.PictureBox
        $imagePath = $PSScriptRoot + "\..\Dependencies\Images\SecurityAndCompliance.png"
        $imgSC.ImageLocation = $imagePath
        $imgSC.Left = $FirstColumnLeft
        $imgSC.Top = $pnlEXO.Height + 205
        $imgSC.AutoSize = $true
        $pnlMain.Controls.Add($imgSC)

        $pnlSC = New-Object System.Windows.Forms.Panel
        $pnlSC.Top = $pnlEXO.Height + 300
        $pnlSC.Left = $FirstColumnLeft
        $pnlSC.Height = 350
        $pnlSC.Width = 300
        $pnlSC.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
        $pnlSC.AutoScroll = $true
        $pnlSCNextControlPosition = -20

        $chckAllSC = New-Object System.Windows.Forms.CheckBox
        $chckAllSC.Left = $FirstColumnLeft + 280
        $chckAllSC.Top = $imgSC.Top + 30
        $chckAllSC.Checked = $true
        $chckAllSC.AutoSize = $true
        $chckAllSC.Add_CheckedChanged( { SectionChanged -Control $chckAllSC -Panel $pnlSC })
        $pnlMain.Controls.Add($chckAllSC)
        #endregion

        #region Teams
        $imgTeams = New-Object System.Windows.Forms.PictureBox
        $imagePath = $PSScriptRoot + "\..\Dependencies\Images\Teams.jpg"
        $imgTeams.ImageLocation = $imagePath
        $imgTeams.Left = $SecondColumnLeft
        $imgTeams.Top = $pnlSPO.Height + 205
        $imgTeams.AutoSize = $true
        $pnlMain.Controls.Add($imgTeams)

        $pnlTeams = New-Object System.Windows.Forms.Panel
        $pnlTeams.Top = $pnlSPO.Height + 300
        $pnlTeams.Left = $secondColumnLeft
        $pnlTeams.Height = 350
        $pnlTeams.Width = 300
        $pnlTeams.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
        $pnlTeams.AutoScroll = $true
        $pnlTeamsNextControlPosition = -20

        $chckAllTeams = New-Object System.Windows.Forms.CheckBox
        $chckAllTeams.Left = $SecondColumnLeft + 280
        $chckAllTeams.Top = $imgTeams.Top + 30
        $chckAllTeams.Checked = $true
        $chckAllTeams.AutoSize = $true
        $chckAllTeams.Add_CheckedChanged( { SectionChanged -Control $chckAllTeams -Panel $pnlTeams })
        $pnlMain.Controls.Add($chckAllTeams)
        #endregion

        #region PowerApps
        $imgPP = New-Object System.Windows.Forms.PictureBox
        $imagePath = $PSScriptRoot + "\..\Dependencies\Images\PowerApps.png"
        $imgPP.ImageLocation = $imagePath
        $imgPP.Left = $thirdColumnLeft
        $imgPP.Top = $topBannerHeight
        $imgPP.AutoSize = $true
        $pnlMain.Controls.Add($imgPP)

        $pnlPP = New-Object System.Windows.Forms.Panel
        $pnlPP.Top = 88 + $topBannerHeight
        $pnlPP.Left = $thirdColumnLeft
        $pnlPP.Height = 100
        $pnlPP.Width = 300
        $pnlPP.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
        $pnlPP.AutoScroll = $true
        $pnlPPNextControlPosition = -20

        $chckAllPP = New-Object System.Windows.Forms.CheckBox
        $chckAllPP.Left = $thirdColumnLeft + 280
        $chckAllPP.Top = $topBannerHeight + 40
        $chckAllPP.Checked = $true
        $chckAllPP.AutoSize = $true
        $chckAllPP.Add_CheckedChanged( { SectionChanged -Control $chckAllPP -Panel $pnlPP })
        $pnlMain.Controls.Add($chckAllPP)
        #endregion

        #region Planner
        $imgPlanner = New-Object System.Windows.Forms.PictureBox
        $imagePath = $PSScriptRoot + "\..\Dependencies\Images\Planner.png"
        $imgPlanner.ImageLocation = $imagePath
        $imgPlanner.Left = $thirdColumnLeft
        $imgPlanner.Top = $pnlPP.Height + 205
        $imgPlanner.AutoSize = $true
        $pnlMain.Controls.Add($imgPlanner)

        $pnlPlanner = New-Object System.Windows.Forms.Panel
        $pnlPlanner.Top = $pnlPP.Height + 300
        $pnlPlanner.Left = $thirdColumnLeft
        $pnlPlanner.Height = 150
        $pnlPlanner.Width = 300
        $pnlPlanner.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
        $pnlPlanner.AutoScroll = $true
        $pnlPlannerNextControlPosition = -20

        $chckAllPlanner = New-Object System.Windows.Forms.CheckBox
        $chckAllPlanner.Left = $thirdColumnLeft + 280
        $chckAllPlanner.Top = $topBannerHeight + $PnlPP.Height + $imgPP.Height + 100
        $chckAllPlanner.Checked = $true
        $chckAllPlanner.AutoSize = $true
        $chckAllPlanner.Add_CheckedChanged( { SectionChanged -Control $chckAllPlanner -Panel $pnlPlanner })
        $pnlMain.Controls.Add($chckAllPlanner)
        #endregion

        #region Office365
        $imgO365 = New-Object System.Windows.Forms.PictureBox
        $imagePath = $PSScriptRoot + "\..\Dependencies\Images\Office365.jpg"
        $imgO365.ImageLocation = $imagePath
        $imgO365.Left = $thirdColumnLeft
        $imgO365.Top = $pnlPP.Height + $pnlPlanner.Height + 300
        $imgO365.AutoSize = $true
        $pnlMain.Controls.Add($imgO365)

        $pnlO365 = New-Object System.Windows.Forms.Panel
        $pnlO365.Top = $imgO365.Top + 98
        $pnlO365.Left = $thirdColumnLeft
        $pnlO365.Height = 350
        $pnlO365.Width = 300
        $pnlO365.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
        $pnlO365.AutoScroll = $true
        $pnlO365NextControlPosition = -20

        $chckAllO365 = New-Object System.Windows.Forms.CheckBox
        $chckAllO365.Left = $thirdColumnLeft + 280
        $chckAllO365.Top = $imgO365.Top + 35
        $chckAllO365.Checked = $true
        $chckAllO365.AutoSize = $true
        $chckAllO365.Add_CheckedChanged( { SectionChanged -Control $chckAllO365 -Panel $pnlO365 })
        $pnlMain.Controls.Add($chckAllO365)
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
        $pnlOD.Height = 350
        $pnlOD.Width = 300
        $pnlOD.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
        $pnlOD.AutoScroll = $true
        $pnlODNextControlPosition = -20

        $chckAllOD = New-Object System.Windows.Forms.CheckBox
        $chckAllOD.Left = $fourthColumnLeft + 280
        $chckAllOD.Top = $topBannerHeight + 40
        $chckAllOD.Enabled = $false #TODO - Reactivate after SPO Mgmt Shell bug fix
        $chckAllOD.Checked = $false #TODO - Reactivate after SPO Mgmt Shell bug fix
        $chckAllOD.AutoSize = $true
        $chckAllOD.Add_CheckedChanged( { SectionChanged -Control $chckAllOD -Panel $pnlOD })
        $pnlMain.Controls.Add($chckAllOD)
        #endregion

        #region AzureAD
        $imgAAD = New-Object System.Windows.Forms.PictureBox
        $imagePath = $PSScriptRoot + "\..\Dependencies\Images\AzureAD.jpg"
        $imgAAD.ImageLocation = $imagePath
        $imgAAD.Left = $fourthColumnLeft
        $imgAAD.Top = $pnlOD.Height + 205
        $imgAAD.AutoSize = $true
        $pnlMain.Controls.Add($imgAAD)

        $pnlAAD = New-Object System.Windows.Forms.Panel
        $pnlAAD.Top = $pnlOD.Height + 300
        $pnlAAD.Left = $fourthColumnLeft
        $pnlAAD.Height = 350
        $pnlAAD.Width = 300
        $pnlAAD.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
        $pnlAAD.AutoScroll = $true
        $pnlAADNextControlPosition = -20

        $chckAllAAD = New-Object System.Windows.Forms.CheckBox
        $chckAllAAD.Left = $fourthColumnLeft + 280
        $chckAllAAD.Top = $imgAAD.Top + 35
        $chckAllAAD.Enabled = $true
        $chckAllAAD.Checked = $true
        $chckAllAAD.AutoSize = $true
        $chckAllAAD.Add_CheckedChanged( { SectionChanged -Control $chckAllAAD -Panel $pnlAAD })
        $pnlMain.Controls.Add($chckAllAAD)
        #endregion

        $allResources = Get-ChildItem -Path ($PSScriptRoot + "\..\DSCResources\")

        foreach ($resource in $allResources)
        {
            $resourceName = $resource.Name.Replace("MSFT_", "")
            $currentControlTop = 0
            if ($resourceName.StartsWith("AAD"))
            {
                $panel = $pnlAAD
                $pnlAADNextControlPosition += 20
                $currentControlTop = $pnlAADNextControlPosition
            }
            elseif ($resourceName.StartsWith("EXO"))
            {
                $panel = $pnlExo
                $pnlEXONextControlPosition += 20
                $currentControlTop = $pnlEXONextControlPosition
            }
            elseif ($resourceName.StartsWith("SPO"))
            {
                $panel = $pnlSPO
                $pnlSPONextControlPosition += 20
                $currentControlTop = $pnlSPONextControlPosition
            }
            elseif ($resourceName.StartsWith("SC"))
            {
                $panel = $pnlSC
                $pnlSCNextControlPosition += 20
                $currentControlTop = $pnlSCNextControlPosition
            }
            elseif ($resourceName.StartsWith("Teams"))
            {
                $panel = $pnlTeams
                $pnlTeamsNextControlPosition += 20
                $currentControlTop = $pnlTeamsNextControlPosition
            }
            elseif ($resourceName.StartsWith("PP"))
            {
                $panel = $pnlPP
                $pnlPPNextControlPosition += 20
                $currentControlTop = $pnlPPNextControlPosition
            }
            elseif ($resourceName.StartsWith("Planner"))
            {
                $panel = $pnlPlanner
                $pnlPlannerNextControlPosition += 20
                $currentControlTop = $pnlPlannerNextControlPosition
            }
            elseif ($resourceName.StartsWith("OD"))
            {
                $panel = $pnlOD
                $pnlODNextControlPosition += 20
                $currentControlTop = $pnlODNextControlPosition
            }
            elseif ($resourceName.StartsWith("O365"))
            {
                $panel = $pnlO365
                $pnlO365NextControlPosition += 20
                $currentControlTop = $pnlO365NextControlPosition
            }

            $ModeIdentifier = [System.Windows.Forms.PictureBox]::new()
            $ModeIdentifier.Height = 15
            $ModeIdentifier.Width = 15
            $checked = $true
            $ModeIdentifier.ImageLocation = $PSScriptRoot + "\..\Dependencies\Images\lite.png"
            if ($Global:DefaultComponents.Contains($resourceName))
            {
                $ModeIdentifier.ImageLocation = $PSScriptRoot + "\..\Dependencies\Images\default.png"
            }
            elseif ($Global:FullComponents.Contains($resourceName))
            {
                $ModeIdentifier.ImageLocation = $PSScriptRoot + "\..\Dependencies\Images\full.png"
                $checked = $false
            }

            $chckBox = [System.Windows.Forms.CheckBox]::New()
            $chckBox.Name = "chck" + $resourceName
            $chckBox.AutoSize = $true
            $chckBox.Text = $resourceName
            $chckBox.Left = 20
            $chckBox.Checked = $checked
            $chckBox.Top = $currentControlTop

            $ModeIdentifier.Top = $currentControlTop + 1
            $panel.Controls.Add($ModeIdentifier)
            $panel.Controls.Add($chckBox)
        }

        $pnlMain.Controls.Add($pnlO365)
        $pnlMain.Controls.Add($pnlExo)
        $pnlMain.Controls.Add($pnlOD)
        $pnlMain.Controls.Add($pnlPP)
        $pnlMain.Controls.Add($pnlPlanner)
        $pnlMain.Controls.Add($pnlSPO)
        $pnlMain.Controls.Add($pnlSC)
        $pnlMain.Controls.Add($pnlTeams)
        $pnlMain.Controls.Add($pnlAAD)

        #region Top Menu
        $panelMenu = New-Object System.Windows.Forms.Panel
        $panelMenu.Height = $topBannerHeight
        $panelMenu.Width = $form.Width
        $panelMenu.BackColor = [System.Drawing.Color]::Silver

        $lblExtraction = New-Object System.Windows.Forms.Label
        $lblExtraction.Text = "Extraction Modes:"
        $lblExtraction.Font = [System.Drawing.Font]::new($lblExtraction.Font.Name, 8, [System.Drawing.FontStyle]::Bold)
        $lblExtraction.Top = 5
        $lblExtraction.Autosize = $true
        $lblExtraction.Left = 15
        $panelMenu.Controls.Add($lblExtraction)

        $imgLite = New-Object System.Windows.Forms.PictureBox
        $imglite.Width = 15
        $imgLite.Height = 15
        $imgLite.BackColor = [System.Drawing.Color]::Transparent
        $imgLite.ImageLocation = $PSScriptRoot + "\..\Dependencies\Images\lite.png"
        $imgLite.Top = 5
        $imgLite.Left = 115
        $panelMenu.Controls.Add($imgLite)

        $radLite = New-Object System.Windows.Forms.RadioButton
        $radLite.Text = "Lite"
        $radLite.Name = "radExtractionMode"
        $radLite.AutoSize = $true
        $radLite.Top = 5
        $radLite.Left = 130
        $radLite.Add_Click( {
                SelectComponentsForMode -PanelMain $pnlMain -Mode 1 -ControlsToSkip ($Global:DefaultComponents + $Global:FullComponents);
            })
        $panelMenu.Controls.Add($radLite)

        $imgLite2 = New-Object System.Windows.Forms.PictureBox
        $imglite2.Width = 15
        $imgLite2.Height = 15
        $imgLite2.BackColor = [System.Drawing.Color]::Transparent
        $imgLite2.ImageLocation = $PSScriptRoot + "\..\Dependencies\Images\lite.png"
        $imgLite2.Top = 25
        $imgLite2.Left = 100
        $panelMenu.Controls.Add($imgLite2)

        $imgDefault = New-Object System.Windows.Forms.PictureBox
        $imgDefault.Width = 15
        $imgDefault.Height = 15
        $imgDefault.BackColor = [System.Drawing.Color]::Transparent
        $imgDefault.ImageLocation = $PSScriptRoot + "\..\Dependencies\Images\default.png"
        $imgDefault.Top = 25
        $imgDefault.Left = 115
        $panelMenu.Controls.Add($imgDefault)

        $radDefault = New-Object System.Windows.Forms.RadioButton
        $radDefault.Text = "Default"
        $radDefault.Checked = $true
        $radDefault.Name = "radExtractionMode"
        $radDefault.AutoSize = $true
        $radDefault.Top = 25
        $radDefault.Left = 130
        $radDefault.Add_Click( { SelectComponentsForMode -PanelMain $pnlMain -Mode 2 -ControlsToSkip $Global:FullComponents; })
        $panelMenu.Controls.Add($radDefault)

        $imgLite3 = New-Object System.Windows.Forms.PictureBox
        $imgLite3.Width = 15
        $imgLite3.Height = 15
        $imgLite3.BackColor = [System.Drawing.Color]::Transparent
        $imgLite3.ImageLocation = $PSScriptRoot + "\..\Dependencies\Images\lite.png"
        $imgLite3.Top = 45
        $imgLite3.Left = 85
        $panelMenu.Controls.Add($imgLite3)

        $imgDefault2 = New-Object System.Windows.Forms.PictureBox
        $imgDefault2.Width = 15
        $imgDefault2.Height = 15
        $imgDefault2.BackColor = [System.Drawing.Color]::Transparent
        $imgDefault2.ImageLocation = $PSScriptRoot + "\..\Dependencies\Images\default.png"
        $imgDefault2.Top = 45
        $imgDefault2.Left = 100
        $panelMenu.Controls.Add($imgDefault2)

        $imgFull = New-Object System.Windows.Forms.PictureBox
        $imgFull.Width = 15
        $imgFull.Height = 15
        $imgFull.BackColor = [System.Drawing.Color]::Transparent
        $imgFull.ImageLocation = $PSScriptRoot + "\..\Dependencies\Images\full.png"
        $imgFull.Top = 45
        $imgFull.Left = 115
        $panelMenu.Controls.Add($imgFull)

        $radFull = New-Object System.Windows.Forms.RadioButton
        $radFull.Text = "Full"
        $radFull.Name = "radExtractionMode"
        $radFull.AutoSize = $true
        $radFull.Top = 45
        $radFull.Left = 130
        $radFull.Add_Click( { SelectComponentsForMode -PanelMain $pnlMain -Mode 3 -ControlsToSkip @() })
        $panelMenu.Controls.Add($radFull)

        $btnClear = New-Object System.Windows.Forms.Button
        $btnClear.Width = 150
        $btnClear.Top = 5
        $btnClear.Height = 60
        $btnClear.Left = 195
        $btnClear.BackColor = [System.Drawing.Color]::IndianRed
        $btnClear.ForeColor = [System.Drawing.Color]::White
        $btnClear.Text = "Unselect All"
        $btnClear.Add_Click( { SelectComponentsForMode -PanelMain $pnlMain -Mode 0 -ControlsToSkip @() })
        $panelMenu.Controls.Add($btnClear);

        #region ServicePrincipal Info
        $lblApplicationId = New-Object System.Windows.Forms.Label
        $lblApplicationId.Text = "Application Id:"
        $lblApplicationId.Top = 10
        $lblApplicationId.Left = 350
        $lblApplicationId.Width = 80
        $lblApplicationId.TextAlign = [System.Drawing.ContentAlignment]::TopRight
        $lblApplicationId.Font = [System.Drawing.Font]::new($lblApplicationId.Font.Name, 8, [System.Drawing.FontStyle]::Bold)
        $panelMenu.Controls.Add($lblApplicationId)

        $txtApplicationId = New-Object System.Windows.Forms.Textbox
        $txtApplicationId.Top = 5
        $txtApplicationId.Left = 440
        $txtApplicationId.Width = 150
        $txtApplicationId.Font = [System.Drawing.Font]::new($txtApplicationId.Font.Name, 10)
        $panelMenu.Controls.Add($txtApplicationId)

        $lblTenantId = New-Object System.Windows.Forms.Label
        $lblTenantId.Text = "Tenant Id:"
        $lblTenantId.Top = 35
        $lblTenantId.Left = 350
        $lblTenantId.Width = 80
        $lblTenantId.TextAlign = [System.Drawing.ContentAlignment]::TopRight
        $lblTenantId.Font = [System.Drawing.Font]::new($lblTenantId.Font.Name, 8, [System.Drawing.FontStyle]::Bold)
        $panelMenu.Controls.Add($lblTenantId)

        $txtTenantId = New-Object System.Windows.Forms.Textbox
        $txtTenantId.Top = 35
        $txtTenantId.Left = 440
        $txtTenantId.Width = 150
        $txtTenantId.Font = [System.Drawing.Font]::new($txtTenantId.Font.Name, 10)
        $panelMenu.Controls.Add($txtTenantId)

        $lblCertThumb = New-Object System.Windows.Forms.Label
        $lblCertThumb.Text = "Certificate Thumbprint:"
        $lblCertThumb.Top = 10
        $lblCertThumb.Left = 625
        $lblCertThumb.Width = 120
        $lblCertThumb.TextAlign = [System.Drawing.ContentAlignment]::TopRight
        $lblCertThumb.Font = [System.Drawing.Font]::new($lblCertThumb.Font.Name, 8, [System.Drawing.FontStyle]::Bold)
        $panelMenu.Controls.Add($lblCertThumb)

        $txtCertThumb = New-Object System.Windows.Forms.Textbox
        $txtCertThumb.Top = 5
        $txtCertThumb.Left = 750
        $txtCertThumb.Width = 150
        $txtCertThumb.Font = [System.Drawing.Font]::new($txtCertThumb.Font.Name, 10)
        $panelMenu.Controls.Add($txtCertThumb)

        $lblCertPath = New-Object System.Windows.Forms.Label
        $lblCertPath.Text = "Certificate Path:"
        $lblCertPath.Top = 35
        $lblCertPath.Left = 625
        $lblCertPath.Width = 120
        $lblCertPath.TextAlign = [System.Drawing.ContentAlignment]::TopRight
        $lblCertPath.Font = [System.Drawing.Font]::new($lblCertPath.Font.Name, 8, [System.Drawing.FontStyle]::Bold)
        $panelMenu.Controls.Add($lblCertPath)

        $txtCertFile = New-Object System.Windows.Forms.Textbox
        $txtCertFile.Top = 35
        $txtCertFile.Left = 750
        $txtCertFile.Width = 150
        $txtCertFile.Font = [System.Drawing.Font]::new($txtCertFile.Font.Name, 10)
        $panelMenu.Controls.Add($txtCertFile)
        #endregion

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

        $lblCertPassword = New-Object System.Windows.Forms.Label
        $lblCertPassword.Text = "Certificate Password:"
        $lblCertPassword.Top = 80
        $lblCertPassword.Left = 940
        $lblCertPassword.AutoSize = $true
        $lblCertPassword.TextAlign = [System.Drawing.ContentAlignment]::TopRight
        $lblCertPassword.Font = [System.Drawing.Font]::new($lblCertPassword.Font.Name, 8, [System.Drawing.FontStyle]::Bold)
        $panelMenu.Controls.Add($lblCertPassword)

        $txtCertPassword = New-Object System.Windows.Forms.Textbox
        $txtCertPassword.Top = 75
        $txtCertPassword.Left = 1060
        $txtCertPassword.Width = 345
        $txtCertPassword.PasswordChar = "*"
        $txtCertPassword.Font = [System.Drawing.Font]::new($txtCertPassword.Font.Name, 10)
        $txtCertPassword.Add_KeyDown( {
                if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Enter)
                {
                    $btnExtract.PerformClick()
                }
            })
        $panelMenu.Controls.Add($txtCertPassword)

        $btnExtract = New-Object System.Windows.Forms.Button
        $btnExtract.Width = 178
        $btnExtract.Height = 70
        $btnExtract.Top = 0
        $btnExtract.Left = $form.Width - 200
        $btnExtract.BackColor = [System.Drawing.Color]::ForestGreen
        $btnExtract.ForeColor = [System.Drawing.Color]::White
        $btnExtract.Text = "Start Extraction"
        $btnExtract.Add_Click( {
                $form.Hide()
                $SelectedComponents = @()
                foreach ($panel in ($form.Controls[0].Controls | Where-Object -FilterScript { $_.GetType().Name -eq "Panel" }))
                {
                    foreach ($checkbox in ($panel.Controls | Where-Object -FilterScript { $_.GetType().Name -eq "Checkbox" }))
                    {
                        if ($checkbox.Checked)
                        {
                            $SelectedComponents += $checkbox.Name.Replace("chck", "")
                        }
                    }
                }

                try
                {
                    if ($txtPassword.Text.Length -gt 0)
                    {
                        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ($txtTenantAdmin.Text, (ConvertTo-SecureString -String $txtPassword.Text -AsPlainText -Force))
                    }
                    $CertPasswordcreds = $null
                    if (-not [System.String]::IsNullOrEmpty($txtCertPassword.Text))
                    {
                        [securestring]$secStringPassword = ConvertTo-SecureString $txtCertPassword.Text -AsPlainText -Force
                        [pscredential]$CertPasswordcreds = New-Object System.Management.Automation.PSCredential ("M365DSCExport", $secStringPassword)
                    }
                    Start-M365DSCConfigurationExtract -GlobalAdminAccount $GlobalAdminAccount `
                        -ApplicationId $txtApplicationId.Text `
                        -TenantId $txtTenantId.Text `
                        -CertificateThumbprint $txtCertThumb.Text `
                        -CertificatePath $txtCertFile.Text `
                        -CertificatePassword $CertPasswordcreds `
                        -ComponentsToExtract $SelectedComponents `
                        -Path $Path
                }
                catch
                {
                    $Message = "Could not initiate the ReverseDSC Extraction"
                    New-M365DSCLogEntry -Error $_ -Message $Message_ -Source "[M365DSCReverseGUI]"
                }
            })
        $panelMenu.Controls.Add($btnExtract);

        $pnlMain.Controls.Add($panelMenu);
        #endregion

        $version = (Get-Module 'Microsoft365DSC').Version
        $lblVersion = New-Object System.Windows.Forms.Label
        $lblVersion.Text = "v" + $version
        $lblVersion.Top = $pnlMain.Height - 25
        $lblVersion.Left = $pnlMain.Width - 70
        $lblVersion.AutoSize = $true
        $pnlMain.Controls.Add($lblVersion)

        $pnlMain.AutoScroll = $true
        $form.Controls.Add($pnlMain)
        $form.ActiveControl = $txtTenantAdmin
        $form.Text = "Microsoft365DSC - Extract Configuration"
        $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
        $return = $form.ShowDialog()
    }
    catch
    {

    }
}

function SelectComponentsForMode
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [System.Windows.Forms.Panel]
        $PanelMain,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $Mode,

        [Parameter()]
        [System.String[]]
        $ControlsToSkip
    )
    foreach ($parent in $panelMain.Controls)
    {
        if ($parent.GetType().ToString() -eq "System.Windows.Forms.Panel")
        {
            foreach ($control in ([System.Windows.Forms.Panel]$parent).Controls)
            {
                if ($control.GetType().Name -eq 'Checkbox')
                {
                    try
                    {
                        if ($mode -ne 3 -and $ControlsToSkip.Contains($control.Name.Replace("chck", "")) -or $mode -eq 0)
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
