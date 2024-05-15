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
    -DscResource 'IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-GUID).ToString() -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-MgBetaDeviceManagementDeviceConfigurationAssignment -MockWith {
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
        Context -Name 'The IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10 should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    bandwidthMode                                             = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationBandwidth -Property @{
                            maximumBackgroundBandwidthPercentage = 25
                            bandwidthForegroundPercentageHours   = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationBandwidthBusinessHoursLimit -Property @{
                                    bandwidthBeginBusinessHours             = 25
                                    bandwidthPercentageOutsideBusinessHours = 25
                                    bandwidthPercentageDuringBusinessHours  = 25
                                    bandwidthEndBusinessHours               = 25
                                } -ClientOnly)
                            bandwidthBackgroundPercentageHours   = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationBandwidthBusinessHoursLimit -Property @{
                                    bandwidthBeginBusinessHours             = 25
                                    bandwidthPercentageOutsideBusinessHours = 25
                                    bandwidthPercentageDuringBusinessHours  = 25
                                    bandwidthEndBusinessHours               = 25
                                } -ClientOnly)
                            maximumForegroundBandwidthPercentage = 25
                            odataType                            = '#microsoft.graph.deliveryOptimizationBandwidthAbsolute'
                        } -ClientOnly)
                    cacheServerBackgroundDownloadFallbackToHttpDelayInSeconds = 25
                    cacheServerForegroundDownloadFallbackToHttpDelayInSeconds = 25
                    cacheServerHostNames                                      = @('FakeStringValue')
                    deliveryOptimizationMode                                  = 'userDefined'
                    description                                               = 'FakeStringValue'
                    displayName                                               = 'FakeStringValue'
                    groupIdSource                                             = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationGroupIdSource -Property @{
                            groupIdCustom       = 'FakeStringValue'
                            groupIdSourceOption = 'notConfigured'
                            odataType           = '#microsoft.graph.deliveryOptimizationGroupIdCustom'
                        } -ClientOnly)
                    id                                                        = 'FakeStringValue'
                    maximumCacheAgeInDays                                     = 25
                    maximumCacheSize                                          = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationMaxCacheSize -Property @{
                            odataType                  = '#microsoft.graph.deliveryOptimizationMaxCacheSizeAbsolute'
                            maximumCacheSizePercentage = 25
                        } -ClientOnly)
                    minimumBatteryPercentageAllowedToUpload                   = 25
                    minimumDiskSizeAllowedToPeerInGigabytes                   = 25
                    minimumFileSizeToCacheInMegabytes                         = 25
                    minimumRamAllowedToPeerInGigabytes                        = 25
                    modifyCacheLocation                                       = 'FakeStringValue'
                    restrictPeerSelectionBy                                   = 'notConfigured'
                    supportsScopeTags                                         = $True
                    vpnPeerCaching                                            = 'notConfigured'
                    Ensure                                                    = 'Present'
                    Credential                                                = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name 'The IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10 exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    bandwidthMode                                             = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationBandwidth -Property @{
                            maximumBackgroundBandwidthPercentage = 25
                            bandwidthForegroundPercentageHours   = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationBandwidthBusinessHoursLimit -Property @{
                                    bandwidthBeginBusinessHours             = 25
                                    bandwidthPercentageOutsideBusinessHours = 25
                                    bandwidthPercentageDuringBusinessHours  = 25
                                    bandwidthEndBusinessHours               = 25
                                } -ClientOnly)
                            bandwidthBackgroundPercentageHours   = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationBandwidthBusinessHoursLimit -Property @{
                                    bandwidthBeginBusinessHours             = 25
                                    bandwidthPercentageOutsideBusinessHours = 25
                                    bandwidthPercentageDuringBusinessHours  = 25
                                    bandwidthEndBusinessHours               = 25
                                } -ClientOnly)
                            maximumForegroundBandwidthPercentage = 25
                            odataType                            = '#microsoft.graph.deliveryOptimizationBandwidthAbsolute'
                        } -ClientOnly)
                    cacheServerBackgroundDownloadFallbackToHttpDelayInSeconds = 25
                    cacheServerForegroundDownloadFallbackToHttpDelayInSeconds = 25
                    cacheServerHostNames                                      = @('FakeStringValue')
                    deliveryOptimizationMode                                  = 'userDefined'
                    description                                               = 'FakeStringValue'
                    displayName                                               = 'FakeStringValue'
                    groupIdSource                                             = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationGroupIdSource -Property @{
                            groupIdCustom       = 'FakeStringValue'
                            groupIdSourceOption = 'notConfigured'
                            odataType           = '#microsoft.graph.deliveryOptimizationGroupIdCustom'
                        } -ClientOnly)
                    id                                                        = 'FakeStringValue'
                    maximumCacheAgeInDays                                     = 25
                    maximumCacheSize                                          = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationMaxCacheSize -Property @{
                            odataType                  = '#microsoft.graph.deliveryOptimizationMaxCacheSizeAbsolute'
                            maximumCacheSizePercentage = 25
                        } -ClientOnly)
                    minimumBatteryPercentageAllowedToUpload                   = 25
                    minimumDiskSizeAllowedToPeerInGigabytes                   = 25
                    minimumFileSizeToCacheInMegabytes                         = 25
                    minimumRamAllowedToPeerInGigabytes                        = 25
                    modifyCacheLocation                                       = 'FakeStringValue'
                    restrictPeerSelectionBy                                   = 'notConfigured'
                    supportsScopeTags                                         = $True
                    vpnPeerCaching                                            = 'notConfigured'
                    Ensure                                                    = 'Absent'
                    Credential                                                = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            cacheServerForegroundDownloadFallbackToHttpDelayInSeconds = 25
                            maximumCacheAgeInDays                                     = 25
                            cacheServerHostNames                                      = @('FakeStringValue')
                            groupIdSource                                             = @{
                                groupIdCustom       = 'FakeStringValue'
                                groupIdSourceOption = 'notConfigured'
                                '@odata.type'       = '#microsoft.graph.deliveryOptimizationGroupIdCustom'
                            }
                            vpnPeerCaching                                            = 'notConfigured'
                            minimumFileSizeToCacheInMegabytes                         = 25
                            maximumCacheSize                                          = @{
                                '@odata.type'              = '#microsoft.graph.deliveryOptimizationMaxCacheSizeAbsolute'
                                maximumCacheSizePercentage = 25
                            }
                            '@odata.type'                                             = '#microsoft.graph.windowsDeliveryOptimizationConfiguration'
                            minimumBatteryPercentageAllowedToUpload                   = 25
                            minimumRamAllowedToPeerInGigabytes                        = 25
                            cacheServerBackgroundDownloadFallbackToHttpDelayInSeconds = 25
                            deliveryOptimizationMode                                  = 'userDefined'
                            modifyCacheLocation                                       = 'FakeStringValue'
                            bandwidthMode                                             = @{
                                maximumBackgroundBandwidthPercentage = 25
                                bandwidthForegroundPercentageHours   = @{
                                    bandwidthBeginBusinessHours             = 25
                                    bandwidthPercentageOutsideBusinessHours = 25
                                    bandwidthPercentageDuringBusinessHours  = 25
                                    bandwidthEndBusinessHours               = 25
                                }
                                bandwidthBackgroundPercentageHours   = @{
                                    bandwidthBeginBusinessHours             = 25
                                    bandwidthPercentageOutsideBusinessHours = 25
                                    bandwidthPercentageDuringBusinessHours  = 25
                                    bandwidthEndBusinessHours               = 25
                                }
                                maximumForegroundBandwidthPercentage = 25
                                '@odata.type'                        = '#microsoft.graph.deliveryOptimizationBandwidthAbsolute'
                            }
                            minimumDiskSizeAllowedToPeerInGigabytes                   = 25
                            restrictPeerSelectionBy                                   = 'notConfigured'
                        }
                        description          = 'FakeStringValue'
                        displayName          = 'FakeStringValue'
                        id                   = 'FakeStringValue'
                        supportsScopeTags    = $True

                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }
        Context -Name 'The IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10 Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    bandwidthMode                                             = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationBandwidth -Property @{
                            maximumBackgroundBandwidthPercentage = 25
                            bandwidthForegroundPercentageHours   = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationBandwidthBusinessHoursLimit -Property @{
                                    bandwidthBeginBusinessHours             = 25
                                    bandwidthPercentageOutsideBusinessHours = 25
                                    bandwidthPercentageDuringBusinessHours  = 25
                                    bandwidthEndBusinessHours               = 25
                                } -ClientOnly)
                            bandwidthBackgroundPercentageHours   = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationBandwidthBusinessHoursLimit -Property @{
                                    bandwidthBeginBusinessHours             = 25
                                    bandwidthPercentageOutsideBusinessHours = 25
                                    bandwidthPercentageDuringBusinessHours  = 25
                                    bandwidthEndBusinessHours               = 25
                                } -ClientOnly)
                            maximumForegroundBandwidthPercentage = 25
                            odataType                            = '#microsoft.graph.deliveryOptimizationBandwidthAbsolute'
                        } -ClientOnly)
                    cacheServerBackgroundDownloadFallbackToHttpDelayInSeconds = 25
                    cacheServerForegroundDownloadFallbackToHttpDelayInSeconds = 25
                    cacheServerHostNames                                      = @('FakeStringValue')
                    deliveryOptimizationMode                                  = 'userDefined'
                    description                                               = 'FakeStringValue'
                    displayName                                               = 'FakeStringValue'
                    groupIdSource                                             = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationGroupIdSource -Property @{
                            groupIdCustom       = 'FakeStringValue'
                            groupIdSourceOption = 'notConfigured'
                            odataType           = '#microsoft.graph.deliveryOptimizationGroupIdCustom'
                        } -ClientOnly)
                    id                                                        = 'FakeStringValue'
                    maximumCacheAgeInDays                                     = 25
                    maximumCacheSize                                          = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationMaxCacheSize -Property @{
                            odataType                  = '#microsoft.graph.deliveryOptimizationMaxCacheSizeAbsolute'
                            maximumCacheSizePercentage = 25
                        } -ClientOnly)
                    minimumBatteryPercentageAllowedToUpload                   = 25
                    minimumDiskSizeAllowedToPeerInGigabytes                   = 25
                    minimumFileSizeToCacheInMegabytes                         = 25
                    minimumRamAllowedToPeerInGigabytes                        = 25
                    modifyCacheLocation                                       = 'FakeStringValue'
                    restrictPeerSelectionBy                                   = 'notConfigured'
                    supportsScopeTags                                         = $True
                    vpnPeerCaching                                            = 'notConfigured'
                    Ensure                                                    = 'Present'
                    Credential                                                = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            cacheServerForegroundDownloadFallbackToHttpDelayInSeconds = 25
                            maximumCacheAgeInDays                                     = 25
                            cacheServerHostNames                                      = @('FakeStringValue')
                            groupIdSource                                             = @{
                                groupIdCustom       = 'FakeStringValue'
                                groupIdSourceOption = 'notConfigured'
                                '@odata.type'       = '#microsoft.graph.deliveryOptimizationGroupIdCustom'
                            }
                            vpnPeerCaching                                            = 'notConfigured'
                            minimumFileSizeToCacheInMegabytes                         = 25
                            maximumCacheSize                                          = @{
                                '@odata.type'              = '#microsoft.graph.deliveryOptimizationMaxCacheSizeAbsolute'
                                maximumCacheSizePercentage = 25
                            }
                            '@odata.type'                                             = '#microsoft.graph.windowsDeliveryOptimizationConfiguration'
                            minimumBatteryPercentageAllowedToUpload                   = 25
                            minimumRamAllowedToPeerInGigabytes                        = 25
                            cacheServerBackgroundDownloadFallbackToHttpDelayInSeconds = 25
                            deliveryOptimizationMode                                  = 'userDefined'
                            modifyCacheLocation                                       = 'FakeStringValue'
                            bandwidthMode                                             = @{
                                maximumBackgroundBandwidthPercentage = 25
                                bandwidthForegroundPercentageHours   = @{
                                    bandwidthBeginBusinessHours             = 25
                                    bandwidthPercentageOutsideBusinessHours = 25
                                    bandwidthPercentageDuringBusinessHours  = 25
                                    bandwidthEndBusinessHours               = 25
                                }
                                bandwidthBackgroundPercentageHours   = @{
                                    bandwidthBeginBusinessHours             = 25
                                    bandwidthPercentageOutsideBusinessHours = 25
                                    bandwidthPercentageDuringBusinessHours  = 25
                                    bandwidthEndBusinessHours               = 25
                                }
                                maximumForegroundBandwidthPercentage = 25
                                '@odata.type'                        = '#microsoft.graph.deliveryOptimizationBandwidthAbsolute'
                            }
                            minimumDiskSizeAllowedToPeerInGigabytes                   = 25
                            restrictPeerSelectionBy                                   = 'notConfigured'
                        }
                        description          = 'FakeStringValue'
                        displayName          = 'FakeStringValue'
                        id                   = 'FakeStringValue'
                        supportsScopeTags    = $True

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The IntuneDeviceConfigurationDeliveryOptimizationPolicyWindows10 exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    bandwidthMode                                             = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationBandwidth -Property @{
                            maximumBackgroundBandwidthPercentage = 25
                            bandwidthForegroundPercentageHours   = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationBandwidthBusinessHoursLimit -Property @{
                                    bandwidthBeginBusinessHours             = 25
                                    bandwidthPercentageOutsideBusinessHours = 25
                                    bandwidthPercentageDuringBusinessHours  = 25
                                    bandwidthEndBusinessHours               = 25
                                } -ClientOnly)
                            bandwidthBackgroundPercentageHours   = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationBandwidthBusinessHoursLimit -Property @{
                                    bandwidthBeginBusinessHours             = 25
                                    bandwidthPercentageOutsideBusinessHours = 25
                                    bandwidthPercentageDuringBusinessHours  = 25
                                    bandwidthEndBusinessHours               = 25
                                } -ClientOnly)
                            maximumForegroundBandwidthPercentage = 25
                            odataType                            = '#microsoft.graph.deliveryOptimizationBandwidthAbsolute'
                        } -ClientOnly)
                    cacheServerBackgroundDownloadFallbackToHttpDelayInSeconds = 25
                    cacheServerForegroundDownloadFallbackToHttpDelayInSeconds = 25
                    cacheServerHostNames                                      = @('FakeStringValue')
                    deliveryOptimizationMode                                  = 'userDefined'
                    description                                               = 'FakeStringValue'
                    displayName                                               = 'FakeStringValue'
                    groupIdSource                                             = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationGroupIdSource -Property @{
                            groupIdCustom       = 'FakeStringValue'
                            groupIdSourceOption = 'notConfigured'
                            odataType           = '#microsoft.graph.deliveryOptimizationGroupIdCustom'
                        } -ClientOnly)
                    id                                                        = 'FakeStringValue'
                    maximumCacheAgeInDays                                     = 25
                    maximumCacheSize                                          = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeliveryOptimizationMaxCacheSize -Property @{
                            odataType                  = '#microsoft.graph.deliveryOptimizationMaxCacheSizeAbsolute'
                            maximumCacheSizePercentage = 25
                        } -ClientOnly)
                    minimumBatteryPercentageAllowedToUpload                   = 25
                    minimumDiskSizeAllowedToPeerInGigabytes                   = 25
                    minimumFileSizeToCacheInMegabytes                         = 25
                    minimumRamAllowedToPeerInGigabytes                        = 25
                    modifyCacheLocation                                       = 'FakeStringValue'
                    restrictPeerSelectionBy                                   = 'notConfigured'
                    supportsScopeTags                                         = $True
                    vpnPeerCaching                                            = 'notConfigured'
                    Ensure                                                    = 'Present'
                    Credential                                                = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            cacheServerForegroundDownloadFallbackToHttpDelayInSeconds = 7
                            maximumCacheAgeInDays                                     = 7
                            cacheServerHostNames                                      = @('FakeStringValue')
                            groupIdSource                                             = @{
                                groupIdCustom       = 'FakeStringValue'
                                groupIdSourceOption = 'notConfigured'
                                '@odata.type'       = '#microsoft.graph.deliveryOptimizationGroupIdCustom'
                            }
                            vpnPeerCaching                                            = 'notConfigured'
                            minimumFileSizeToCacheInMegabytes                         = 7
                            maximumCacheSize                                          = @{
                                '@odata.type'              = '#microsoft.graph.deliveryOptimizationMaxCacheSizeAbsolute'
                                maximumCacheSizePercentage = 7
                            }
                            '@odata.type'                                             = '#microsoft.graph.windowsDeliveryOptimizationConfiguration'
                            minimumBatteryPercentageAllowedToUpload                   = 7
                            minimumRamAllowedToPeerInGigabytes                        = 7
                            cacheServerBackgroundDownloadFallbackToHttpDelayInSeconds = 7
                            deliveryOptimizationMode                                  = 'userDefined'
                            modifyCacheLocation                                       = 'FakeStringValue'
                            bandwidthMode                                             = @{
                                maximumBackgroundBandwidthPercentage = 7
                                bandwidthForegroundPercentageHours   = @{
                                    bandwidthBeginBusinessHours             = 7
                                    bandwidthPercentageOutsideBusinessHours = 7
                                    bandwidthPercentageDuringBusinessHours  = 7
                                    bandwidthEndBusinessHours               = 7
                                }
                                bandwidthBackgroundPercentageHours   = @{
                                    bandwidthBeginBusinessHours             = 7
                                    bandwidthPercentageOutsideBusinessHours = 7
                                    bandwidthPercentageDuringBusinessHours  = 7
                                    bandwidthEndBusinessHours               = 7
                                }
                                maximumForegroundBandwidthPercentage = 7
                                '@odata.type'                        = '#microsoft.graph.deliveryOptimizationBandwidthAbsolute'
                            }
                            minimumDiskSizeAllowedToPeerInGigabytes                   = 7
                            restrictPeerSelectionBy                                   = 'notConfigured'
                        }
                        description          = 'FakeStringValue'
                        displayName          = 'FakeStringValue'
                        id                   = 'FakeStringValue'
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
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
                        AdditionalProperties = @{
                            cacheServerForegroundDownloadFallbackToHttpDelayInSeconds = 25
                            maximumCacheAgeInDays                                     = 25
                            cacheServerHostNames                                      = @('FakeStringValue')
                            groupIdSource                                             = @{
                                groupIdCustom       = 'FakeStringValue'
                                groupIdSourceOption = 'notConfigured'
                                '@odata.type'       = '#microsoft.graph.deliveryOptimizationGroupIdCustom'
                            }
                            vpnPeerCaching                                            = 'notConfigured'
                            minimumFileSizeToCacheInMegabytes                         = 25
                            maximumCacheSize                                          = @{
                                '@odata.type'              = '#microsoft.graph.deliveryOptimizationMaxCacheSizeAbsolute'
                                maximumCacheSizePercentage = 25
                            }
                            '@odata.type'                                             = '#microsoft.graph.windowsDeliveryOptimizationConfiguration'
                            minimumBatteryPercentageAllowedToUpload                   = 25
                            minimumRamAllowedToPeerInGigabytes                        = 25
                            cacheServerBackgroundDownloadFallbackToHttpDelayInSeconds = 25
                            deliveryOptimizationMode                                  = 'userDefined'
                            modifyCacheLocation                                       = 'FakeStringValue'
                            bandwidthMode                                             = @{
                                maximumBackgroundBandwidthPercentage = 25
                                bandwidthForegroundPercentageHours   = @{
                                    bandwidthBeginBusinessHours             = 25
                                    bandwidthPercentageOutsideBusinessHours = 25
                                    bandwidthPercentageDuringBusinessHours  = 25
                                    bandwidthEndBusinessHours               = 25
                                }
                                bandwidthBackgroundPercentageHours   = @{
                                    bandwidthBeginBusinessHours             = 25
                                    bandwidthPercentageOutsideBusinessHours = 25
                                    bandwidthPercentageDuringBusinessHours  = 25
                                    bandwidthEndBusinessHours               = 25
                                }
                                maximumForegroundBandwidthPercentage = 25
                                '@odata.type'                        = '#microsoft.graph.deliveryOptimizationBandwidthAbsolute'
                            }
                            minimumDiskSizeAllowedToPeerInGigabytes                   = 25
                            restrictPeerSelectionBy                                   = 'notConfigured'
                        }
                        description          = 'FakeStringValue'
                        displayName          = 'FakeStringValue'
                        id                   = 'FakeStringValue'
                        supportsScopeTags    = $True

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
