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
    -DscResource "IntuneDeviceConfigurationVpnPolicyWindows10" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "f@kepassword1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgBetaDeviceManagementDeviceConfigurationAssignment -MockWith {
            }

        }
        # Test contexts
        Context -Name "The IntuneDeviceConfigurationVpnPolicyWindows10 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    associatedApps = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindows10AssociatedApps -Property @{
                            identifier = "FakeStringValue"
                            appType = "desktop"
                        } -ClientOnly)
                    )
                    authenticationMethod = "certificate"
                    connectionName = "FakeStringValue"
                    connectionType = "pulseSecure"
                    cryptographySuite = (New-CimInstance -ClassName MSFT_MicrosoftGraphcryptographySuite -Property @{
                        cipherTransformConstants = "aes256"
                        encryptionMethod = "aes256"
                        pfsGroup = "pfs1"
                        dhGroup = "group1"
                        integrityCheckMethod = "sha2_256"
                        authenticationTransformConstants = "md5_96"
                    } -ClientOnly)
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    dnsRules = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphvpnDnsRule -Property @{
                            servers = @("FakeStringValue")
                            proxyServerUri = "FakeStringValue"
                            name = "FakeStringValue"
                            persistent = $True
                            autoTrigger = $True
                        } -ClientOnly)
                    )
                    dnsSuffixes = @("FakeStringValue")
                    enableAlwaysOn = $True
                    enableConditionalAccess = $True
                    enableDeviceTunnel = $True
                    enableDnsRegistration = $True
                    enableSingleSignOnWithAlternateCertificate = $True
                    enableSplitTunneling = $True
                    id = "FakeStringValue"
                    microsoftTunnelSiteId = "FakeStringValue"
                    onlyAssociatedAppsCanUseConnection = $True
                    profileTarget = "user"
                    proxyServer = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindows10VpnProxyServer -Property @{
                        bypassProxyServerForLocalAddress = $True
                        address = "FakeStringValue"
                        automaticConfigurationScriptUrl = "FakeStringValue"
                        automaticallyDetectProxySettings = $True
                        port = 25
                        odataType = "#microsoft.graph.windows10VpnProxyServer"
                    } -ClientOnly)
                    rememberUserCredentials = $True
                    routes = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphvpnRoute -Property @{
                            prefixSize = 25
                            destinationPrefix = "FakeStringValue"
                        } -ClientOnly)
                    )
                    serverCollection = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphvpnServer -Property @{
                            isDefaultServer = $True
                            description = "FakeStringValue"
                            address = "FakeStringValue"
                        } -ClientOnly)
                    )
                    singleSignOnEku = (New-CimInstance -ClassName MSFT_MicrosoftGraphextendedKeyUsage -Property @{
                        objectIdentifier = "FakeStringValue"
                        name = "FakeStringValue"
                    } -ClientOnly)
                    singleSignOnIssuerHash = "FakeStringValue"
                    trafficRules = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphvpnTrafficRule -Property @{
                            remotePortRanges = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphnumberRange -Property @{
                                    lowerNumber = 25
                                    upperNumber = 25
                                } -ClientOnly)
                            )
                            name = "FakeStringValue"
                            appId = "FakeStringValue"
                            localPortRanges = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphnumberRange -Property @{
                                    lowerNumber = 25
                                    upperNumber = 25
                                } -ClientOnly)
                            )
                            appType = "none"
                            localAddressRanges = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphiPv4Range -Property @{
                                    cidrAddress = "FakeStringValue"
                                    upperAddress = "FakeStringValue"
                                    lowerAddress = "FakeStringValue"
                                    odataType = "#microsoft.graph.iPv4CidrRange"
                                } -ClientOnly)
                            )
                            remoteAddressRanges = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphiPv4Range -Property @{
                                    cidrAddress = "FakeStringValue"
                                    upperAddress = "FakeStringValue"
                                    lowerAddress = "FakeStringValue"
                                    odataType = "#microsoft.graph.iPv4CidrRange"
                                } -ClientOnly)
                            )
                            claims = "FakeStringValue"
                            protocols = 25
                            routingPolicyType = "none"
                            vpnTrafficDirection = "outbound"
                        } -ClientOnly)
                    )
                    trustedNetworkDomains = @("FakeStringValue")
                    windowsInformationProtectionDomain = "FakeStringValue"
                    Ensure = "Present"
                    Credential = $Credential;
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

        Context -Name "The IntuneDeviceConfigurationVpnPolicyWindows10 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    associatedApps = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindows10AssociatedApps -Property @{
                            identifier = "FakeStringValue"
                            appType = "desktop"
                        } -ClientOnly)
                    )
                    authenticationMethod = "certificate"
                    connectionName = "FakeStringValue"
                    connectionType = "pulseSecure"
                    cryptographySuite = (New-CimInstance -ClassName MSFT_MicrosoftGraphcryptographySuite -Property @{
                        cipherTransformConstants = "aes256"
                        encryptionMethod = "aes256"
                        pfsGroup = "pfs1"
                        dhGroup = "group1"
                        integrityCheckMethod = "sha2_256"
                        authenticationTransformConstants = "md5_96"
                    } -ClientOnly)
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    dnsRules = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphvpnDnsRule -Property @{
                            servers = @("FakeStringValue")
                            proxyServerUri = "FakeStringValue"
                            name = "FakeStringValue"
                            persistent = $True
                            autoTrigger = $True
                        } -ClientOnly)
                    )
                    dnsSuffixes = @("FakeStringValue")
                    enableAlwaysOn = $True
                    enableConditionalAccess = $True
                    enableDeviceTunnel = $True
                    enableDnsRegistration = $True
                    enableSingleSignOnWithAlternateCertificate = $True
                    enableSplitTunneling = $True
                    id = "FakeStringValue"
                    microsoftTunnelSiteId = "FakeStringValue"
                    onlyAssociatedAppsCanUseConnection = $True
                    profileTarget = "user"
                    proxyServer = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindows10VpnProxyServer -Property @{
                        bypassProxyServerForLocalAddress = $True
                        address = "FakeStringValue"
                        automaticConfigurationScriptUrl = "FakeStringValue"
                        automaticallyDetectProxySettings = $True
                        port = 25
                        odataType = "#microsoft.graph.windows10VpnProxyServer"
                    } -ClientOnly)
                    rememberUserCredentials = $True
                    routes = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphvpnRoute -Property @{
                            prefixSize = 25
                            destinationPrefix = "FakeStringValue"
                        } -ClientOnly)
                    )
                    serverCollection = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphvpnServer -Property @{
                            isDefaultServer = $True
                            description = "FakeStringValue"
                            address = "FakeStringValue"
                        } -ClientOnly)
                    )
                    singleSignOnEku = (New-CimInstance -ClassName MSFT_MicrosoftGraphextendedKeyUsage -Property @{
                        objectIdentifier = "FakeStringValue"
                        name = "FakeStringValue"
                    } -ClientOnly)
                    singleSignOnIssuerHash = "FakeStringValue"
                    trafficRules = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphvpnTrafficRule -Property @{
                            remotePortRanges = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphnumberRange -Property @{
                                    lowerNumber = 25
                                    upperNumber = 25
                                } -ClientOnly)
                            )
                            name = "FakeStringValue"
                            appId = "FakeStringValue"
                            localPortRanges = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphnumberRange -Property @{
                                    lowerNumber = 25
                                    upperNumber = 25
                                } -ClientOnly)
                            )
                            appType = "none"
                            localAddressRanges = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphiPv4Range -Property @{
                                    cidrAddress = "FakeStringValue"
                                    upperAddress = "FakeStringValue"
                                    lowerAddress = "FakeStringValue"
                                    odataType = "#microsoft.graph.iPv4CidrRange"
                                } -ClientOnly)
                            )
                            remoteAddressRanges = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphiPv4Range -Property @{
                                    cidrAddress = "FakeStringValue"
                                    upperAddress = "FakeStringValue"
                                    lowerAddress = "FakeStringValue"
                                    odataType = "#microsoft.graph.iPv4CidrRange"
                                } -ClientOnly)
                            )
                            claims = "FakeStringValue"
                            protocols = 25
                            routingPolicyType = "none"
                            vpnTrafficDirection = "outbound"
                        } -ClientOnly)
                    )
                    trustedNetworkDomains = @("FakeStringValue")
                    windowsInformationProtectionDomain = "FakeStringValue"
                    Ensure = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            dnsRules = @(
                                @{
                                    servers = @("FakeStringValue")
                                    proxyServerUri = "FakeStringValue"
                                    name = "FakeStringValue"
                                    persistent = $True
                                    autoTrigger = $True
                                }
                            )
                            authenticationMethod = "certificate"
                            proxyServer = @{
                                bypassProxyServerForLocalAddress = $True
                                '@odata.type' = "#microsoft.graph.windows10VpnProxyServer"
                                address = "FakeStringValue"
                                automaticConfigurationScriptUrl = "FakeStringValue"
                                automaticallyDetectProxySettings = $True
                                port = 25
                            }
                            rememberUserCredentials = $True
                            enableDnsRegistration = $True
                            associatedApps = @(
                                @{
                                    identifier = "FakeStringValue"
                                    appType = "desktop"
                                }
                            )
                            routes = @(
                                @{
                                    prefixSize = 25
                                    destinationPrefix = "FakeStringValue"
                                }
                            )
                            trustedNetworkDomains = @("FakeStringValue")
                            enableDeviceTunnel = $True
                            singleSignOnIssuerHash = "FakeStringValue"
                            singleSignOnEku = @{
                                objectIdentifier = "FakeStringValue"
                                name = "FakeStringValue"
                            }
                            microsoftTunnelSiteId = "FakeStringValue"
                            enableSingleSignOnWithAlternateCertificate = $True
                            onlyAssociatedAppsCanUseConnection = $True
                            dnsSuffixes = @("FakeStringValue")
                            profileTarget = "user"
                            enableAlwaysOn = $True
                            servers = @(
                                @{
                                    isDefaultServer = $True
                                    description = "FakeStringValue"
                                    address = "FakeStringValue"
                                }
                            )
                            connectionType = "pulseSecure"
                            connectionName = "FakeStringValue"
                            cryptographySuite = @{
                                cipherTransformConstants = "aes256"
                                encryptionMethod = "aes256"
                                pfsGroup = "pfs1"
                                dhGroup = "group1"
                                integrityCheckMethod = "sha2_256"
                                authenticationTransformConstants = "md5_96"
                            }
                            trafficRules = @(
                                @{
                                    remotePortRanges = @(
                                        @{
                                            lowerNumber = 25
                                            upperNumber = 25
                                        }
                                    )
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    localPortRanges = @(
                                        @{
                                            lowerNumber = 25
                                            upperNumber = 25
                                        }
                                    )
                                    appType = "none"
                                    localAddressRanges = @(
                                        @{
                                            cidrAddress = "FakeStringValue"
                                            upperAddress = "FakeStringValue"
                                            lowerAddress = "FakeStringValue"
                                            '@odata.type' = "#microsoft.graph.iPv4CidrRange"
                                        }
                                    )
                                    remoteAddressRanges = @(
                                        @{
                                            cidrAddress = "FakeStringValue"
                                            upperAddress = "FakeStringValue"
                                            lowerAddress = "FakeStringValue"
                                            '@odata.type' = "#microsoft.graph.iPv4CidrRange"
                                        }
                                    )
                                    claims = "FakeStringValue"
                                    protocols = 25
                                    routingPolicyType = "none"
                                    vpnTrafficDirection = "outbound"
                                }
                            )
                            windowsInformationProtectionDomain = "FakeStringValue"
                            enableConditionalAccess = $True
                            '@odata.type' = "#microsoft.graph.windows10VpnConfiguration"
                            enableSplitTunneling = $True
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"

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
        Context -Name "The IntuneDeviceConfigurationVpnPolicyWindows10 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    associatedApps = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindows10AssociatedApps -Property @{
                            identifier = "FakeStringValue"
                            appType = "desktop"
                        } -ClientOnly)
                    )
                    authenticationMethod = "certificate"
                    connectionName = "FakeStringValue"
                    connectionType = "pulseSecure"
                    cryptographySuite = (New-CimInstance -ClassName MSFT_MicrosoftGraphcryptographySuite -Property @{
                        cipherTransformConstants = "aes256"
                        encryptionMethod = "aes256"
                        pfsGroup = "pfs1"
                        dhGroup = "group1"
                        integrityCheckMethod = "sha2_256"
                        authenticationTransformConstants = "md5_96"
                    } -ClientOnly)
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    dnsRules = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphvpnDnsRule -Property @{
                            servers = @("FakeStringValue")
                            proxyServerUri = "FakeStringValue"
                            name = "FakeStringValue"
                            persistent = $True
                            autoTrigger = $True
                        } -ClientOnly)
                    )
                    dnsSuffixes = @("FakeStringValue")
                    enableAlwaysOn = $True
                    enableConditionalAccess = $True
                    enableDeviceTunnel = $True
                    enableDnsRegistration = $True
                    enableSingleSignOnWithAlternateCertificate = $True
                    enableSplitTunneling = $True
                    id = "FakeStringValue"
                    microsoftTunnelSiteId = "FakeStringValue"
                    onlyAssociatedAppsCanUseConnection = $True
                    profileTarget = "user"
                    proxyServer = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindows10VpnProxyServer -Property @{
                        bypassProxyServerForLocalAddress = $True
                        address = "FakeStringValue"
                        automaticConfigurationScriptUrl = "FakeStringValue"
                        automaticallyDetectProxySettings = $True
                        port = 25
                        odataType = "#microsoft.graph.windows10VpnProxyServer"
                    } -ClientOnly)
                    rememberUserCredentials = $True
                    routes = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphvpnRoute -Property @{
                            prefixSize = 25
                            destinationPrefix = "FakeStringValue"
                        } -ClientOnly)
                    )
                    serverCollection = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphvpnServer -Property @{
                            isDefaultServer = $True
                            description = "FakeStringValue"
                            address = "FakeStringValue"
                        } -ClientOnly)
                    )
                    singleSignOnEku = (New-CimInstance -ClassName MSFT_MicrosoftGraphextendedKeyUsage -Property @{
                        objectIdentifier = "FakeStringValue"
                        name = "FakeStringValue"
                    } -ClientOnly)
                    singleSignOnIssuerHash = "FakeStringValue"
                    trafficRules = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphvpnTrafficRule -Property @{
                            remotePortRanges = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphnumberRange -Property @{
                                    lowerNumber = 25
                                    upperNumber = 25
                                } -ClientOnly)
                            )
                            name = "FakeStringValue"
                            appId = "FakeStringValue"
                            localPortRanges = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphnumberRange -Property @{
                                    lowerNumber = 25
                                    upperNumber = 25
                                } -ClientOnly)
                            )
                            appType = "none"
                            localAddressRanges = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphiPv4Range -Property @{
                                    cidrAddress = "FakeStringValue"
                                    upperAddress = "FakeStringValue"
                                    lowerAddress = "FakeStringValue"
                                    odataType = "#microsoft.graph.iPv4CidrRange"
                                } -ClientOnly)
                            )
                            remoteAddressRanges = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphiPv4Range -Property @{
                                    cidrAddress = "FakeStringValue"
                                    upperAddress = "FakeStringValue"
                                    lowerAddress = "FakeStringValue"
                                    odataType = "#microsoft.graph.iPv4CidrRange"
                                } -ClientOnly)
                            )
                            claims = "FakeStringValue"
                            protocols = 25
                            routingPolicyType = "none"
                            vpnTrafficDirection = "outbound"
                        } -ClientOnly)
                    )
                    trustedNetworkDomains = @("FakeStringValue")
                    windowsInformationProtectionDomain = "FakeStringValue"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            dnsRules = @(
                                @{
                                    servers = @("FakeStringValue")
                                    proxyServerUri = "FakeStringValue"
                                    name = "FakeStringValue"
                                    persistent = $True
                                    autoTrigger = $True
                                }
                            )
                            authenticationMethod = "certificate"
                            proxyServer = @{
                                bypassProxyServerForLocalAddress = $True
                                '@odata.type' = "#microsoft.graph.windows10VpnProxyServer"
                                address = "FakeStringValue"
                                automaticConfigurationScriptUrl = "FakeStringValue"
                                automaticallyDetectProxySettings = $True
                                port = 25
                            }
                            rememberUserCredentials = $True
                            enableDnsRegistration = $True
                            associatedApps = @(
                                @{
                                    identifier = "FakeStringValue"
                                    appType = "desktop"
                                }
                            )
                            routes = @(
                                @{
                                    prefixSize = 25
                                    destinationPrefix = "FakeStringValue"
                                }
                            )
                            trustedNetworkDomains = @("FakeStringValue")
                            enableDeviceTunnel = $True
                            singleSignOnIssuerHash = "FakeStringValue"
                            singleSignOnEku = @{
                                objectIdentifier = "FakeStringValue"
                                name = "FakeStringValue"
                            }
                            microsoftTunnelSiteId = "FakeStringValue"
                            enableSingleSignOnWithAlternateCertificate = $True
                            onlyAssociatedAppsCanUseConnection = $True
                            dnsSuffixes = @("FakeStringValue")
                            profileTarget = "user"
                            enableAlwaysOn = $True
                            servers = @(
                                @{
                                    isDefaultServer = $True
                                    description = "FakeStringValue"
                                    address = "FakeStringValue"
                                }
                            )
                            connectionType = "pulseSecure"
                            connectionName = "FakeStringValue"
                            cryptographySuite = @{
                                cipherTransformConstants = "aes256"
                                encryptionMethod = "aes256"
                                pfsGroup = "pfs1"
                                dhGroup = "group1"
                                integrityCheckMethod = "sha2_256"
                                authenticationTransformConstants = "md5_96"
                            }
                            trafficRules = @(
                                @{
                                    remotePortRanges = @(
                                        @{
                                            lowerNumber = 25
                                            upperNumber = 25
                                        }
                                    )
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    localPortRanges = @(
                                        @{
                                            lowerNumber = 25
                                            upperNumber = 25
                                        }
                                    )
                                    appType = "none"
                                    localAddressRanges = @(
                                        @{
                                            cidrAddress = "FakeStringValue"
                                            upperAddress = "FakeStringValue"
                                            lowerAddress = "FakeStringValue"
                                            '@odata.type' = "#microsoft.graph.iPv4CidrRange"
                                        }
                                    )
                                    remoteAddressRanges = @(
                                        @{
                                            cidrAddress = "FakeStringValue"
                                            upperAddress = "FakeStringValue"
                                            lowerAddress = "FakeStringValue"
                                            '@odata.type' = "#microsoft.graph.iPv4CidrRange"
                                        }
                                    )
                                    claims = "FakeStringValue"
                                    protocols = 25
                                    routingPolicyType = "none"
                                    vpnTrafficDirection = "outbound"
                                }
                            )
                            windowsInformationProtectionDomain = "FakeStringValue"
                            enableConditionalAccess = $True
                            '@odata.type' = "#microsoft.graph.windows10VpnConfiguration"
                            enableSplitTunneling = $True
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneDeviceConfigurationVpnPolicyWindows10 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    associatedApps = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindows10AssociatedApps -Property @{
                            identifier = "FakeStringValue"
                            appType = "desktop"
                        } -ClientOnly)
                    )
                    authenticationMethod = "certificate"
                    connectionName = "FakeStringValue"
                    connectionType = "pulseSecure"
                    cryptographySuite = (New-CimInstance -ClassName MSFT_MicrosoftGraphcryptographySuite -Property @{
                        cipherTransformConstants = "aes256"
                        encryptionMethod = "aes256"
                        pfsGroup = "pfs1"
                        dhGroup = "group1"
                        integrityCheckMethod = "sha2_256"
                        authenticationTransformConstants = "md5_96"
                    } -ClientOnly)
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    dnsRules = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphvpnDnsRule -Property @{
                            servers = @("FakeStringValue")
                            proxyServerUri = "FakeStringValue"
                            name = "FakeStringValue"
                            persistent = $True
                            autoTrigger = $True
                        } -ClientOnly)
                    )
                    dnsSuffixes = @("FakeStringValue")
                    enableAlwaysOn = $True
                    enableConditionalAccess = $True
                    enableDeviceTunnel = $True
                    enableDnsRegistration = $True
                    enableSingleSignOnWithAlternateCertificate = $True
                    enableSplitTunneling = $True
                    id = "FakeStringValue"
                    microsoftTunnelSiteId = "FakeStringValue"
                    onlyAssociatedAppsCanUseConnection = $True
                    profileTarget = "user"
                    proxyServer = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindows10VpnProxyServer -Property @{
                        bypassProxyServerForLocalAddress = $True
                        address = "FakeStringValue"
                        automaticConfigurationScriptUrl = "FakeStringValue"
                        automaticallyDetectProxySettings = $True
                        port = 25
                        odataType = "#microsoft.graph.windows10VpnProxyServer"
                    } -ClientOnly)
                    rememberUserCredentials = $True
                    routes = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphvpnRoute -Property @{
                            prefixSize = 25
                            destinationPrefix = "FakeStringValue"
                        } -ClientOnly)
                    )
                    serverCollection = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphvpnServer -Property @{
                            isDefaultServer = $True
                            description = "FakeStringValue"
                            address = "FakeStringValue"
                        } -ClientOnly)
                    )
                    singleSignOnEku = (New-CimInstance -ClassName MSFT_MicrosoftGraphextendedKeyUsage -Property @{
                        objectIdentifier = "FakeStringValue"
                        name = "FakeStringValue"
                    } -ClientOnly)
                    singleSignOnIssuerHash = "FakeStringValue"
                    trafficRules = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphvpnTrafficRule -Property @{
                            remotePortRanges = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphnumberRange -Property @{
                                    lowerNumber = 25
                                    upperNumber = 25
                                } -ClientOnly)
                            )
                            name = "FakeStringValue"
                            appId = "FakeStringValue"
                            localPortRanges = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphnumberRange -Property @{
                                    lowerNumber = 25
                                    upperNumber = 25
                                } -ClientOnly)
                            )
                            appType = "none"
                            localAddressRanges = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphiPv4Range -Property @{
                                    cidrAddress = "FakeStringValue"
                                    upperAddress = "FakeStringValue"
                                    lowerAddress = "FakeStringValue"
                                    odataType = "#microsoft.graph.iPv4CidrRange"
                                } -ClientOnly)
                            )
                            remoteAddressRanges = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphiPv4Range -Property @{
                                    cidrAddress = "FakeStringValue"
                                    upperAddress = "FakeStringValue"
                                    lowerAddress = "FakeStringValue"
                                    odataType = "#microsoft.graph.iPv4CidrRange"
                                } -ClientOnly)
                            )
                            claims = "FakeStringValue"
                            protocols = 25
                            routingPolicyType = "none"
                            vpnTrafficDirection = "outbound"
                        } -ClientOnly)
                    )
                    trustedNetworkDomains = @("FakeStringValue")
                    windowsInformationProtectionDomain = "FakeStringValue"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            dnsRules = @(
                                @{
                                    servers = @("FakeStringValue")
                                    name = "FakeStringValue"
                                    proxyServerUri = "FakeStringValue"
                                }
                            )
                            singleSignOnEku = @{
                                objectIdentifier = "FakeStringValue"
                                name = "FakeStringValue"
                            }
                            singleSignOnIssuerHash = "FakeStringValue"
                            associatedApps = @(
                                @{
                                    identifier = "FakeStringValue"
                                    appType = "desktop"
                                }
                            )
                            trustedNetworkDomains = @("FakeStringValue")
                            routes = @(
                                @{
                                    prefixSize = 7
                                    destinationPrefix = "FakeStringValue"
                                }
                            )
                            microsoftTunnelSiteId = "FakeStringValue"
                            connectionName = "FakeStringValue"
                            dnsSuffixes = @("FakeStringValue")
                            profileTarget = "user"
                            authenticationMethod = "certificate"
                            servers = @(
                                @{
                                    description = "FakeStringValue"
                                    address = "FakeStringValue"
                                }
                            )
                            connectionType = "pulseSecure"
                            trafficRules = @(
                                @{
                                    remotePortRanges = @(
                                        @{
                                            lowerNumber = 7
                                            upperNumber = 7
                                        }
                                    )
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    localPortRanges = @(
                                        @{
                                            lowerNumber = 7
                                            upperNumber = 7
                                        }
                                    )
                                    appType = "none"
                                    localAddressRanges = @(
                                        @{
                                            cidrAddress = "FakeStringValue"
                                            upperAddress = "FakeStringValue"
                                            lowerAddress = "FakeStringValue"
                                            '@odata.type' = "#microsoft.graph.iPv4CidrRange"
                                        }
                                    )
                                    remoteAddressRanges = @(
                                        @{
                                            cidrAddress = "FakeStringValue"
                                            upperAddress = "FakeStringValue"
                                            lowerAddress = "FakeStringValue"
                                            '@odata.type' = "#microsoft.graph.iPv4CidrRange"
                                        }
                                    )
                                    claims = "FakeStringValue"
                                    protocols = 7
                                    routingPolicyType = "none"
                                    vpnTrafficDirection = "outbound"
                                }
                            )
                            windowsInformationProtectionDomain = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.windows10VpnConfiguration"
                            proxyServer = @{
                                port = 7
                                automaticConfigurationScriptUrl = "FakeStringValue"
                                address = "FakeStringValue"
                                '@odata.type' = "#microsoft.graph.windows10VpnProxyServer"
                            }
                            cryptographySuite = @{
                                cipherTransformConstants = "aes256"
                                encryptionMethod = "aes256"
                                pfsGroup = "pfs1"
                                dhGroup = "group1"
                                integrityCheckMethod = "sha2_256"
                                authenticationTransformConstants = "md5_96"
                            }
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"
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
                            dnsRules = @(
                                @{
                                    servers = @("FakeStringValue")
                                    proxyServerUri = "FakeStringValue"
                                    name = "FakeStringValue"
                                    persistent = $True
                                    autoTrigger = $True
                                }
                            )
                            authenticationMethod = "certificate"
                            proxyServer = @{
                                bypassProxyServerForLocalAddress = $True
                                '@odata.type' = "#microsoft.graph.windows10VpnProxyServer"
                                address = "FakeStringValue"
                                automaticConfigurationScriptUrl = "FakeStringValue"
                                automaticallyDetectProxySettings = $True
                                port = 25
                            }
                            rememberUserCredentials = $True
                            enableDnsRegistration = $True
                            associatedApps = @(
                                @{
                                    identifier = "FakeStringValue"
                                    appType = "desktop"
                                }
                            )
                            routes = @(
                                @{
                                    prefixSize = 25
                                    destinationPrefix = "FakeStringValue"
                                }
                            )
                            trustedNetworkDomains = @("FakeStringValue")
                            enableDeviceTunnel = $True
                            singleSignOnIssuerHash = "FakeStringValue"
                            singleSignOnEku = @{
                                objectIdentifier = "FakeStringValue"
                                name = "FakeStringValue"
                            }
                            microsoftTunnelSiteId = "FakeStringValue"
                            enableSingleSignOnWithAlternateCertificate = $True
                            onlyAssociatedAppsCanUseConnection = $True
                            dnsSuffixes = @("FakeStringValue")
                            profileTarget = "user"
                            enableAlwaysOn = $True
                            servers = @(
                                @{
                                    isDefaultServer = $True
                                    description = "FakeStringValue"
                                    address = "FakeStringValue"
                                }
                            )
                            connectionType = "pulseSecure"
                            connectionName = "FakeStringValue"
                            cryptographySuite = @{
                                cipherTransformConstants = "aes256"
                                encryptionMethod = "aes256"
                                pfsGroup = "pfs1"
                                dhGroup = "group1"
                                integrityCheckMethod = "sha2_256"
                                authenticationTransformConstants = "md5_96"
                            }
                            trafficRules = @(
                                @{
                                    remotePortRanges = @(
                                        @{
                                            lowerNumber = 25
                                            upperNumber = 25
                                        }
                                    )
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    localPortRanges = @(
                                        @{
                                            lowerNumber = 25
                                            upperNumber = 25
                                        }
                                    )
                                    appType = "none"
                                    localAddressRanges = @(
                                        @{
                                            cidrAddress = "FakeStringValue"
                                            upperAddress = "FakeStringValue"
                                            lowerAddress = "FakeStringValue"
                                            '@odata.type' = "#microsoft.graph.iPv4CidrRange"
                                        }
                                    )
                                    remoteAddressRanges = @(
                                        @{
                                            cidrAddress = "FakeStringValue"
                                            upperAddress = "FakeStringValue"
                                            lowerAddress = "FakeStringValue"
                                            '@odata.type' = "#microsoft.graph.iPv4CidrRange"
                                        }
                                    )
                                    claims = "FakeStringValue"
                                    protocols = 25
                                    routingPolicyType = "none"
                                    vpnTrafficDirection = "outbound"
                                }
                            )
                            windowsInformationProtectionDomain = "FakeStringValue"
                            enableConditionalAccess = $True
                            '@odata.type' = "#microsoft.graph.windows10VpnConfiguration"
                            enableSplitTunneling = $True
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"

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
