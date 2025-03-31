[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
    -ChildPath '..\..\Unit' `
    -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Microsoft365.psm1' `
        -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Generic.psm1' `
        -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\UnitTestHelper.psm1' `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource 'IntuneDeviceFeaturesConfigurationPolicyIOS' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString ((New-Guid).ToString()) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementDeviceCompliancePolicyAssignment -MockWith {

                return @()
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "When the IntuneDeviceFeaturesConfigurationPolicyIOS doesn't already exist" -Fixture {
            BeforeAll {
               $testParams = @{
                    Description                                  = 'FakeStringValue'
                    DisplayName                                  = 'FakeStringValue'
                    Id                                           = 'FakeStringValue'
                    RoleScopeTagIds = @('Tag1', 'Tag2')
                    AirPrintDestinations = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_AirPrintDestination `
                        -Property @{
                            port = 0
                            resourcePath = 'printers/xerox_Phase'
                            forceTls = $False
                            ipAddress = '1.0.0.1'
                        } -ClientOnly)
                    )

                    AssetTagTemplate                             = 'FakeStringValue'
                    ContentFilterSettings                        = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosWebContentFilterSpecificWebsitesAccess `
                        -Property @{
                            dataType = '#microsoft.graph.iosWebContentFilterAutoFilter'
                            allowedUrls = @(
                                'https://www.fakeallowed.com'
                            )
                            blockedUrls = @(
                                'https://www.fakeblocked.com'
                            )
                        } -ClientOnly)
                    )
                    LockScreenFootnote                           = 'FakeStringValue'
                    HomeScreenDockIcons                          = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosHomeScreenApp `
                        -Property @{
                            bundleID = 'com.apple.store.Jolly'
                            displayName = 'Apple Store'
                            isWebClip = $False
                        } -ClientOnly)
                    )
                    HomeScreenGridWidth                          = 5
                    HomeScreenGridHeight                         = 6
                    HomeScreenPages                              = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosHomeScreenItem `
                        -Property @{
                            icons = [CimInstance[]]@(
                                (New-CimInstance `
                                -ClassName MSFT_iosHomeScreenApp `
                                -Property @{
                                    bundleID = 'com.apple.AppStore'
                                    displayName = 'App Store'
                                    isWebClip = $False
                                } -ClientOnly)
                            )
                        } -ClientOnly)
                    )
                    NotificationSettings                         = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosNotificationSettings `
                        -Property @{
                            alertType = 'banner'
                            enabled = $True
                            showOnLockScreen = $True
                            badgesEnabled = $True
                            soundsEnabled = $True
                            publisher = 'fakepublisher'
                            bundleID = 'app.id'
                            showInNotificationCenter = $True
                            previewVisibility = 'hideWhenLocked'
                            appName = 'fakeapp'
                        } -ClientOnly)
                    )
                    SingleSignOnSettings                         = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosSingleSignOnSettings `
                        -Property @{
                            allowedAppsList = [CimInstance[]]@(
                                (New-CimInstance `
                                -ClassName MSFT_appListItem `
                                -Property @{
                                    appId = 'com.microsoft.companyportal'
                                    name = 'Intune Company Portal'
                                } -ClientOnly)
                            )
                            allowedUrls = @('https://www.fakeurl.com')
                            kerberosRealm = 'fakerealm.com'
                            displayName = 'iOS-DeviceFeatures-ContentSettingsSpecificSites'
                            kerberosPrincipalName = 'userPrincipalName'
                        } -ClientOnly)
                    )
                    WallpaperDisplayLocation                     = 'notConfigured'
                    WallpaperImage                               = @()
                    IosSingleSignOnExtension                     = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosSingleSignOnExtension `
                        -Property @{
                            dataType = '#microsoft.graph.iosCredentialSingleSignOnExtension'
                            extensionIdentifier = 'com.example.sso.credential'
                            domains = @('fakedomain.com')
                            configurations = [CimInstance[]]@(
                                (New-CimInstance `
                                -ClassName MSFT_keyTypedValuePair `
                                -Property @{
                                    key = 'myString'
                                    dataType = '#microsoft.graph.keyStringValuePair'
                                    value = 'myvalue'
                                } -ClientOnly)

                                (New-CimInstance `
                                -ClassName MSFT_keyTypedValuePair `
                                -Property @{
                                    key = 'mybool'
                                    dataType = '#microsoft.graph.keyBooleanValuePair'
                                    value = $True
                                } -ClientOnly)

                                (New-CimInstance `
                                -ClassName MSFT_keyTypedValuePair `
                                -Property @{
                                    key = 'myInt'
                                    dataType = '#microsoft.graph.keyIntegerValuePair'
                                    value = 4
                                } -ClientOnly)
                            )
                            teamIdentifier                     = '4HMSJJRMAD'
                            realm                              = 'EXAMPLE.COM'
                        } -ClientOnly)
                    )
                    Assignments                                = @()                                                                                      

                    Ensure                                     = 'Present'
                    Credential                                 = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the IntuneDeviceFeaturesConfigurationPolicyIOS from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgBetaDeviceManagementDeviceConfiguration' -Exactly 1
            }
        }

        Context -Name 'When the IntuneDeviceFeaturesConfigurationPolicyIOS already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
               $testParams = @{                                 
                    Assignments              = @()
                    Description              = 'FakeStringValue'
                    DisplayName              = 'FakeStringValue'
                    Id                       = 'ab915bca-1234-4b11-8acb-719a771139bc'
                    TenantId                 = $OrganizationName;
                    WallpaperDisplayLocation = 'notConfigured';  
                    AirPrintDestinations = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_AirPrintDestination `
                        -Property @{
                            port = 0
                            resourcePath = 'printers/xerox_Phase'
                            forceTls = $False
                            ipAddress = '1.0.0.1'
                        } -ClientOnly)
                    )
                   ContentFilterSettings                        = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosWebContentFilterSpecificWebsitesAccess `
                        -Property @{
                            dataType = '#microsoft.graph.iosWebContentFilterAutoFilter'
                            allowedUrls = @(
                                'https://www.fakeallowed.com'
                            )
                            blockedUrls = @(
                                'https://www.fakeblocked.com'
                            )
                        } -ClientOnly)
                    )
                    HomeScreenDockIcons                          = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosHomeScreenApp `
                        -Property @{
                            bundleID = 'com.apple.store.Jolly'
                            displayName = 'Apple Store'
                            isWebClip = $False
                        } -ClientOnly)
                    ) 
                    HomeScreenPages                              = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosHomeScreenItem `
                        -Property @{
                            icons = [CimInstance[]]@(
                                (New-CimInstance `
                                -ClassName MSFT_iosHomeScreenApp `
                                -Property @{
                                    bundleID = 'com.apple.AppStore'
                                    displayName = 'App Store'
                                    isWebClip = $False
                                } -ClientOnly)
                            )
                        } -ClientOnly)
                    )
                    NotificationSettings                         = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosNotificationSettings `
                        -Property @{
                            alertType = 'banner'
                            enabled = $True
                            showOnLockScreen = $True
                            badgesEnabled = $True
                            soundsEnabled = $True
                            publisher = 'fakepublisher'
                            bundleID = 'app.id'
                            showInNotificationCenter = $True
                            previewVisibility = 'hideWhenLocked'
                            appName = 'fakeapp'
                        } -ClientOnly)
                    )
                    SingleSignOnSettings                         = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosSingleSignOnSettings `
                        -Property @{
                            allowedAppsList = [CimInstance[]]@(
                                (New-CimInstance `
                                -ClassName MSFT_appListItem `
                                -Property @{
                                    appId = 'com.microsoft.companyportal'
                                    name = 'Intune Company Portal'
                                } -ClientOnly)
                            )
                            allowedUrls = @('https://www.fakeurl.com')
                            kerberosRealm = 'fakerealm.com'
                            displayName = 'iOS-DeviceFeatures-ContentSettingsSpecificSites'
                            kerberosPrincipalName = 'userPrincipalName'
                        } -ClientOnly)
                    )
                    IosSingleSignOnExtension = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosCredentialSingleSignOnExtension `
                        -Property @{
                            dataType           = '#microsoft.graph.iosCredentialSingleSignOnExtension'
                            extensionIdentifier = 'com.example.sso.credential'
                            teamIdentifier      = '4HMSJJRMAD'
                            realm              = 'EXAMPLE.COM'
                            domains            = @('example.com')
                        } -ClientOnly)
                    )                                               
                    Ensure                                       = 'Present'
                    Credential                                   = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                   return @{
                        DisplayName                             = 'FakeStringValue'
                        Description                             = 'FakeStringValue - CHANGED' #changed
                        Id                                      = 'ab915bca-1234-4b11-8acb-719a771139bc'
                        AdditionalProperties                    = @{
                            '@odata.type'              = '#microsoft.graph.iosDeviceFeaturesConfiguration'
                            wallpaperDisplayLocation   = 'notConfigured'
                            airPrintDestinations      = @(
                                @{
                                    ipAddress     = '1.0.0.1'
                                    resourcePath  = 'printers/xerox_Phase'
                                    port          = 0
                                    forceTls      = $false
                                }
                            )
                            contentFilterSettings     = @{
                                    '@odata.Type' = '#microsoft.graph.iosWebContentFilterAutoFilter'
                                    allowedUrls = @(
                                        'https://www.fakeallowed.com'
                                    )
                                    blockedUrls = @(
                                        'https://www.fakeblocked.com'
                                    )
                            }
                            homeScreenDockIcons       = @(
                                @{
                                    '@odata.type'   = '#microsoft.graph.iosHomeScreenApp'
                                    displayName   = 'Apple Store'
                                    bundleID      = 'com.apple.store.Jolly'
                                    isWebClip     = $false
                                }
                            )
                            homeScreenPages           = @(
                                @{
                                    icons = @(
                                        @{
                                            '@odata.type'   = '#microsoft.graph.iosHomeScreenApp'
                                            displayName   = 'App Store'
                                            bundleID      = 'com.apple.AppStore'
                                            isWebClip     = $false
                                        }
                                    )
                                }
                            )
                            notificationSettings      = @(
                                @{
                                    bundleID               = 'app.id'
                                    appName                = 'fakeapp'
                                    publisher              = 'fakepublisher'
                                    enabled                = $true
                                    showInNotificationCenter = $true
                                    showOnLockScreen       = $true
                                    alertType              = 'banner'
                                    badgesEnabled          = $true
                                    soundsEnabled          = $true
                                    previewVisibility      = 'hideWhenLocked'
                                }
                            )
                            singleSignOnSettings      = @{
                                allowedUrls            = @('https://www.fakeurl.com')
                                displayName            = 'iOS-DeviceFeatures-ContentSettingsSpecificSites'
                                kerberosPrincipalName  = 'userPrincipalName'
                                kerberosRealm          = 'fakerealm.com'
                                allowedAppsList        = @(
                                    @{
                                        name   = 'Intune Company Portal'
                                        appId  = 'com.microsoft.companyportal'
                                    }
                                )
                            }
                            iosSingleSignOnExtension = @{
                                '@odata.type' = '#microsoft.graph.iosCredentialSingleSignOnExtension'
                                extensionIdentifier = 'com.example.sso.credential'
                                teamIdentifier      = '4HMSJJRMAD'
                                realm               = 'EXAMPLE.COM'
                                domains             = @('example.com')
                            }
                        #end additionalproperties
                        }
                    }
            }
        }

            It 'Should return Present from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present' #-Displayname 'FakeStringValue').Ensure | Should -Be 'Present' #
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the IntuneDeviceFeaturesConfigurationPolicyIOS from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
               
            }
        }

       Context -Name 'When the policy already exists and IS in the Desired State' -Fixture {
            BeforeAll {
               $testParams = @{                                 
                    Assignments              = @()
                    Description              = 'FakeStringValue'
                    DisplayName              = 'FakeStringValue'
                    Id                       = 'ab915bca-1234-4b11-8acb-719a771139bc'
                    TenantId                 = $OrganizationName;
                    WallpaperDisplayLocation = 'notConfigured';  
                    AirPrintDestinations = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_AirPrintDestination `
                        -Property @{
                            port = 0
                            resourcePath = 'printers/xerox_Phase'
                            forceTls = $False
                            ipAddress = '1.0.0.1'
                        } -ClientOnly)
                    )
                   ContentFilterSettings                        = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosWebContentFilterSpecificWebsitesAccess `
                        -Property @{
                            dataType = '#microsoft.graph.iosWebContentFilterAutoFilter'
                            allowedUrls = @(
                                'https://www.fakeallowed.com'
                            )
                            blockedUrls = @(
                                'https://www.fakeblocked.com'
                            )
                        } -ClientOnly)
                    )
                    HomeScreenDockIcons                          = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosHomeScreenApp `
                        -Property @{
                            bundleID = 'com.apple.store.Jolly'
                            displayName = 'Apple Store'
                            isWebClip = $False
                        } -ClientOnly)
                    ) 
                    HomeScreenPages                              = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosHomeScreenItem `
                        -Property @{
                            icons = [CimInstance[]]@(
                                (New-CimInstance `
                                -ClassName MSFT_iosHomeScreenApp `
                                -Property @{
                                    bundleID = 'com.apple.AppStore'
                                    displayName = 'App Store'
                                    isWebClip = $False
                                } -ClientOnly)
                            )
                        } -ClientOnly)
                    )
                    NotificationSettings                         = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosNotificationSettings `
                        -Property @{
                            alertType = 'banner'
                            enabled = $True
                            showOnLockScreen = $True
                            badgesEnabled = $True
                            soundsEnabled = $True
                            publisher = 'fakepublisher'
                            bundleID = 'app.id'
                            showInNotificationCenter = $True
                            previewVisibility = 'hideWhenLocked'
                            appName = 'fakeapp'
                        } -ClientOnly)
                    )
                    SingleSignOnSettings                         = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosSingleSignOnSettings `
                        -Property @{
                            allowedAppsList = [CimInstance[]]@(
                                (New-CimInstance `
                                -ClassName MSFT_appListItem `
                                -Property @{
                                    appId = 'com.microsoft.companyportal'
                                    name = 'Intune Company Portal'
                                } -ClientOnly)
                            )
                            allowedUrls = @('https://www.fakeurl.com')
                            kerberosRealm = 'fakerealm.com'
                            displayName = 'iOS-DeviceFeatures-ContentSettingsSpecificSites'
                            kerberosPrincipalName = 'userPrincipalName'
                        } -ClientOnly)
                    )
                    IosSingleSignOnExtension = [CimInstance[]]@(
                        (New-CimInstance `
                        -ClassName MSFT_iosCredentialSingleSignOnExtension `
                        -Property @{
                            dataType           = '#microsoft.graph.iosCredentialSingleSignOnExtension'
                            extensionIdentifier = 'com.example.sso.credential'
                            teamIdentifier      = '4HMSJJRMAD'
                            realm              = 'EXAMPLE.COM'
                            domains            = @('example.com')
                        } -ClientOnly)
                    )                                               
                    Ensure                                       = 'Present'
                    Credential                                   = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                   return @{
                        DisplayName                             = 'FakeStringValue'
                        Description                             = 'FakeStringValue'
                        Id                                      = 'ab915bca-1234-4b11-8acb-719a771139bc'
                        AdditionalProperties                    = @{
                            '@odata.type'              = '#microsoft.graph.iosDeviceFeaturesConfiguration'
                            wallpaperDisplayLocation   = 'notConfigured'
                            airPrintDestinations      = @(
                                @{
                                    ipAddress     = '1.0.0.1'
                                    resourcePath  = 'printers/xerox_Phase'
                                    port          = 0
                                    forceTls      = $false
                                }
                            )
                            contentFilterSettings     = @{
                                    '@odata.Type' = '#microsoft.graph.iosWebContentFilterAutoFilter'
                                    allowedUrls = @(
                                        'https://www.fakeallowed.com'
                                    )
                                    blockedUrls = @(
                                        'https://www.fakeblocked.com'
                                    )
                            }
                            homeScreenDockIcons       = @(
                                @{
                                    '@odata.type'   = '#microsoft.graph.iosHomeScreenApp'
                                    displayName   = 'Apple Store'
                                    bundleID      = 'com.apple.store.Jolly'
                                    isWebClip     = $false
                                }
                            )
                            homeScreenPages           = @(
                                @{
                                    icons = @(
                                        @{
                                            '@odata.type'   = '#microsoft.graph.iosHomeScreenApp'
                                            displayName   = 'App Store'
                                            bundleID      = 'com.apple.AppStore'
                                            isWebClip     = $false
                                        }
                                    )
                                }
                            )
                            notificationSettings      = @(
                                @{
                                    bundleID               = 'app.id'
                                    appName                = 'fakeapp'
                                    publisher              = 'fakepublisher'
                                    enabled                = $true
                                    showInNotificationCenter = $true
                                    showOnLockScreen       = $true
                                    alertType              = 'banner'
                                    badgesEnabled          = $true
                                    soundsEnabled          = $true
                                    previewVisibility      = 'hideWhenLocked'
                                }
                            )
                            singleSignOnSettings      = @{
                                allowedUrls            = @('https://www.fakeurl.com')
                                displayName            = 'iOS-DeviceFeatures-ContentSettingsSpecificSites'
                                kerberosPrincipalName  = 'userPrincipalName'
                                kerberosRealm          = 'fakerealm.com'
                                allowedAppsList        = @(
                                    @{
                                        name   = 'Intune Company Portal'
                                        appId  = 'com.microsoft.companyportal'
                                    }
                                )
                            }
                            iosSingleSignOnExtension = @{
                                '@odata.type' = '#microsoft.graph.iosCredentialSingleSignOnExtension'
                                extensionIdentifier = 'com.example.sso.credential'
                                teamIdentifier      = '4HMSJJRMAD'
                                realm               = 'EXAMPLE.COM'
                                domains             = @('example.com')
                            }
                        #end additionalproperties
                        }
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the policy exists and it SHOULD NOT' -Fixture {
            BeforeAll {
               $testParams = @{
                    Description                                  = 'FakeStringValue'
                    DisplayName                                  = 'FakeStringValue'
                    Id                                           = 'FakeStringValue'
                    RoleScopeTagIds                              = @('0')
                    WallpaperDisplayLocation                     = 'notConfigured'
                    Assignments                                  = @()                                                                                      
                    Ensure                                       = 'Absent'
                    Credential                                   = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                   return @{
                        DisplayName                             = 'FakeStringValue'
                        Description                             = 'FakeStringValue'
                        Id                                      = 'FakeStringValue'
                        RoleScopeTagIds                         = @('0')
                        AdditionalProperties                    = @{
                            '@odata.type'              = '#microsoft.graph.iosDeviceFeaturesConfiguration'
                            wallpaperDisplayLocation   = 'notConfigured'
                        }
                    }
                }
            }

            It 'Should return Present from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the IntuneDeviceFeaturesConfigurationPolicyIOS from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        DisplayName                               = 'FakeStringValue'
                        Description                               = 'FakeStringValue'
                        Id                                        = 'FakeStringValue'
                        RoleScopeTagIds                           = @('0')
                        AdditionalProperties                      = @{
                            '@odata.type'             = '#microsoft.graph.iosDeviceFeaturesConfiguration'
                            airPrintDestinations      = @(
                                @{
                                    ipAddress     = '1.0.0.1'
                                    resourcePath  = 'printers/xerox_Phase'
                                    port          = 0
                                    forceTls      = $false
                                }
                            )
                            assetTagTemplate          = 'Asset #123abc'
                            lockScreenFootnote        = 'If Lost, Return to'
                            homeScreenGridWidth       = 4
                            homeScreenGridHeight      = 5
                            wallpaperDisplayLocation  = 'notConfigured'
                            contentFilterSettings     = @{
                                '@odata.Type' = '#microsoft.graph.iosWebContentFilterAutoFilter'
                                allowedUrls = @(
                                    'https://www.fakeallowed.com'
                                )
                                blockedUrls = @(
                                    'https://www.fakeblocked.com'
                                )
                            }
                            homeScreenDockIcons       = @(
                                @{
                                    '@odata.type'   = '#microsoft.graph.iosHomeScreenApp'
                                    displayName   = 'Apple Store'
                                    bundleID      = 'com.apple.store.Jolly'
                                    isWebClip     = $false
                                }
                            )
                            homeScreenPages           = @(
                                @{
                                    icons = @(
                                        @{
                                            '@odata.type'   = '#microsoft.graph.iosHomeScreenApp'
                                            displayName   = 'App Store'
                                            bundleID      = 'com.apple.AppStore'
                                            isWebClip     = $false
                                        }
                                    )
                                }
                            )
                            notificationSettings      = @(
                                @{
                                    bundleID               = 'app.id'
                                    appName                = 'fakeapp'
                                    publisher              = 'fakepublisher'
                                    enabled                = $true
                                    showInNotificationCenter = $true
                                    showOnLockScreen       = $true
                                    alertType              = 'banner'
                                    badgesEnabled          = $true
                                    soundsEnabled          = $true
                                    previewVisibility      = 'hideWhenLocked'
                                }
                            )
                            singleSignOnSettings      = @{
                                allowedUrls            = @('https://www.fakeurl.com')
                                displayName            = 'iOS-DeviceFeatures-ContentSettingsSpecificSites'
                                kerberosPrincipalName  = 'userPrincipalName'
                                kerberosRealm          = 'fakerealm.com'
                                allowedAppsList        = @(
                                    @{
                                        name   = 'Intune Company Portal'
                                        appId  = 'com.microsoft.companyportal'
                                    }
                                )
                            }  
                            iosCredentialSingleSignOnExtension = @{
                                '@odata.type'        = '#microsoft.graph.iosCredentialSingleSignOnExtension'
                                extensionIdentifier  = 'com.example.sso.credential'
                                teamIdentifier       = '4HMSJJRMAD'
                                domains             = @('example.com')
                                realm               = 'EXAMPLE.COM'
                                configurations      = @(
                                @{
                                    '@odata.type' = '#microsoft.graph.keyStringValuePair'
                                    key          = 'myString'
                                    value        = 'myvalue'
                                }
                                @{
                                    '@odata.type' = '#microsoft.graph.keyBooleanValuePair'
                                    key          = 'mybool'
                                    value        = $true
                                }
                                @{
                                    '@odata.type' = '#microsoft.graph.keyIntegerValuePair'
                                    key          = 'myInt'
                                    value        = 4
                                }
                            )
                            } 
                        }
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope