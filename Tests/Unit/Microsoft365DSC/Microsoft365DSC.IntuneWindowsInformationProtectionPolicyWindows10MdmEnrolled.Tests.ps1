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
    -DscResource 'IntuneWindowsInformationProtectionPolicyWindows10MdmEnrolled' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'f@kepassword1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy -MockWith {
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name 'The IntuneWindowsInformationProtectionPolicyWindows10MdmEnrolled should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AzureRightsManagementServicesAllowed   = $True
                    DataRecoveryCertificate                = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionDataRecoveryCertificate -Property @{
                            Description        = 'FakeStringValue'
                            ExpirationDateTime = '2023-01-01T00:00:00.0000000+00:00'
                            SubjectName        = 'FakeStringValue'
                        } -ClientOnly)
                    Description                            = 'FakeStringValue'
                    DisplayName                            = 'FakeStringValue'
                    EnforcementLevel                       = 'noProtection'
                    EnterpriseDomain                       = 'FakeStringValue'
                    EnterpriseInternalProxyServers         = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    EnterpriseIPRanges                     = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionIPRangeCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Ranges      = [CIMInstance[]]@(New-CimInstance -ClassName MSFT_MicrosoftGraphipRange -Property @{
                                    CidrAddress  = 'FakeStringValue'
                                    UpperAddress = 'FakeStringValue'
                                    LowerAddress = 'FakeStringValue'
                                    odataType    = '#microsoft.graph.iPv4CidrRange'
                                } -ClientOnly)
                        } -ClientOnly)
                    )
                    EnterpriseIPRangesAreAuthoritative     = $True
                    EnterpriseNetworkDomainNames           = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    EnterpriseProtectedDomainNames         = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    EnterpriseProxiedDomains               = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionProxiedDomainCollection -Property @{
                            DisplayName    = 'FakeStringValue'
                            ProxiedDomains = (New-CimInstance -ClassName MSFT_MicrosoftGraphproxiedDomain -Property @{
                                    Proxy           = 'FakeStringValue'
                                    IpAddressOrFQDN = 'FakeStringValue'
                                } -ClientOnly)
                        } -ClientOnly)
                    )
                    EnterpriseProxyServers                 = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    EnterpriseProxyServersAreAuthoritative = $True
                    ExemptApps                             = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionApp -Property @{
                            BinaryVersionLow  = 'FakeStringValue'
                            Description       = 'FakeStringValue'
                            odataType         = '#microsoft.graph.windowsInformationProtectionDesktopApp'
                            BinaryName        = 'FakeStringValue'
                            BinaryVersionHigh = 'FakeStringValue'
                            Denied            = $True
                            PublisherName     = 'FakeStringValue'
                            ProductName       = 'FakeStringValue'
                            DisplayName       = 'FakeStringValue'
                        } -ClientOnly)
                    )
                    IconsVisible                           = $True
                    Id                                     = 'FakeStringValue'
                    IndexingEncryptedStoresOrItemsBlocked  = $True
                    NeutralDomainResources                 = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    ProtectedApps                          = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionApp -Property @{
                            BinaryVersionLow  = 'FakeStringValue'
                            Description       = 'FakeStringValue'
                            odataType         = '#microsoft.graph.windowsInformationProtectionDesktopApp'
                            BinaryName        = 'FakeStringValue'
                            BinaryVersionHigh = 'FakeStringValue'
                            Denied            = $True
                            PublisherName     = 'FakeStringValue'
                            ProductName       = 'FakeStringValue'
                            DisplayName       = 'FakeStringValue'
                        } -ClientOnly)
                    )
                    ProtectionUnderLockConfigRequired      = $True
                    RevokeOnUnenrollDisabled               = $True
                    SmbAutoEncryptedFileExtensions         = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    Ensure                                 = 'Present'
                    Credential                             = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy -MockWith {
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
                Should -Invoke -CommandName New-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy -Exactly 1
            }
        }

        Context -Name 'The IntuneWindowsInformationProtectionPolicyWindows10MdmEnrolled exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AzureRightsManagementServicesAllowed   = $True
                    DataRecoveryCertificate                = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionDataRecoveryCertificate -Property @{
                            Description        = 'FakeStringValue'
                            ExpirationDateTime = '2023-01-01T00:00:00.0000000+00:00'
                            SubjectName        = 'FakeStringValue'
                        } -ClientOnly)
                    Description                            = 'FakeStringValue'
                    DisplayName                            = 'FakeStringValue'
                    EnforcementLevel                       = 'noProtection'
                    EnterpriseDomain                       = 'FakeStringValue'
                    EnterpriseInternalProxyServers         = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    EnterpriseIPRanges                     = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionIPRangeCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Ranges      = (New-CimInstance -ClassName MSFT_MicrosoftGraphipRange -Property @{
                                    CidrAddress  = 'FakeStringValue'
                                    UpperAddress = 'FakeStringValue'
                                    LowerAddress = 'FakeStringValue'
                                    odataType    = '#microsoft.graph.iPv4CidrRange'
                                } -ClientOnly)
                        } -ClientOnly)
                    )
                    EnterpriseIPRangesAreAuthoritative     = $True
                    EnterpriseNetworkDomainNames           = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    EnterpriseProtectedDomainNames         = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    EnterpriseProxiedDomains               = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionProxiedDomainCollection -Property @{
                            DisplayName    = 'FakeStringValue'
                            ProxiedDomains = (New-CimInstance -ClassName MSFT_MicrosoftGraphproxiedDomain -Property @{
                                    Proxy           = 'FakeStringValue'
                                    IpAddressOrFQDN = 'FakeStringValue'
                                } -ClientOnly)
                        } -ClientOnly)
                    )
                    EnterpriseProxyServers                 = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    EnterpriseProxyServersAreAuthoritative = $True
                    ExemptApps                             = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionApp -Property @{
                            BinaryVersionLow  = 'FakeStringValue'
                            Description       = 'FakeStringValue'
                            odataType         = '#microsoft.graph.windowsInformationProtectionDesktopApp'
                            BinaryName        = 'FakeStringValue'
                            BinaryVersionHigh = 'FakeStringValue'
                            Denied            = $True
                            PublisherName     = 'FakeStringValue'
                            ProductName       = 'FakeStringValue'
                            DisplayName       = 'FakeStringValue'
                        } -ClientOnly)
                    )
                    IconsVisible                           = $True
                    Id                                     = 'FakeStringValue'
                    IndexingEncryptedStoresOrItemsBlocked  = $True
                    NeutralDomainResources                 = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    ProtectedApps                          = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionApp -Property @{
                            BinaryVersionLow  = 'FakeStringValue'
                            Description       = 'FakeStringValue'
                            odataType         = '#microsoft.graph.windowsInformationProtectionDesktopApp'
                            BinaryName        = 'FakeStringValue'
                            BinaryVersionHigh = 'FakeStringValue'
                            Denied            = $True
                            PublisherName     = 'FakeStringValue'
                            ProductName       = 'FakeStringValue'
                            DisplayName       = 'FakeStringValue'
                        } -ClientOnly)
                    )
                    ProtectionUnderLockConfigRequired      = $True
                    RevokeOnUnenrollDisabled               = $True
                    SmbAutoEncryptedFileExtensions         = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    Ensure                                 = 'Absent'
                    Credential                             = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy -MockWith {
                    return @{
                        AdditionalProperties                   = @{
                            '@odata.type' = '#microsoft.graph.MdmWindowsInformationProtectionPolicy'
                        }
                        AzureRightsManagementServicesAllowed   = $True
                        DataRecoveryCertificate                = @{
                            Description        = 'FakeStringValue'
                            ExpirationDateTime = '2023-01-01T00:00:00.0000000+00:00'
                            SubjectName        = 'FakeStringValue'
                        }
                        Description                            = 'FakeStringValue'
                        DisplayName                            = 'FakeStringValue'
                        EnforcementLevel                       = 'noProtection'
                        EnterpriseDomain                       = 'FakeStringValue'
                        EnterpriseInternalProxyServers         = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        EnterpriseIPRanges                     = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Ranges      = @(
                                    @{
                                        AdditionalProperties = @{
                                            cidrAddress   = 'FakeStringValue'
                                            upperAddress  = 'FakeStringValue'
                                            lowerAddress  = 'FakeStringValue'
                                            '@odata.type' = '#microsoft.graph.iPv4CidrRange'
                                        }
                                    }
                                )
                            }
                        )
                        EnterpriseIPRangesAreAuthoritative     = $True
                        EnterpriseNetworkDomainNames           = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        EnterpriseProtectedDomainNames         = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        EnterpriseProxiedDomains               = @(
                            @{
                                DisplayName    = 'FakeStringValue'
                                ProxiedDomains = @(
                                    @{
                                        Proxy           = 'FakeStringValue'
                                        IpAddressOrFQDN = 'FakeStringValue'
                                    }
                                )
                            }
                        )
                        EnterpriseProxyServers                 = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        EnterpriseProxyServersAreAuthoritative = $True
                        ExemptApps                             = @(
                            @{
                                Description          = 'FakeStringValue'
                                AdditionalProperties = @{
                                    binaryName        = 'FakeStringValue'
                                    binaryVersionLow  = 'FakeStringValue'
                                    binaryVersionHigh = 'FakeStringValue'
                                    '@odata.type'     = '#microsoft.graph.windowsInformationProtectionDesktopApp'
                                }
                                Denied               = $True
                                PublisherName        = 'FakeStringValue'
                                ProductName          = 'FakeStringValue'
                                DisplayName          = 'FakeStringValue'
                            }
                        )
                        IconsVisible                           = $True
                        Id                                     = 'FakeStringValue'
                        IndexingEncryptedStoresOrItemsBlocked  = $True
                        NeutralDomainResources                 = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        ProtectedApps                          = @(
                            @{
                                Description          = 'FakeStringValue'
                                AdditionalProperties = @{
                                    binaryName        = 'FakeStringValue'
                                    binaryVersionLow  = 'FakeStringValue'
                                    binaryVersionHigh = 'FakeStringValue'
                                    '@odata.type'     = '#microsoft.graph.windowsInformationProtectionDesktopApp'
                                }
                                Denied               = $True
                                PublisherName        = 'FakeStringValue'
                                ProductName          = 'FakeStringValue'
                                DisplayName          = 'FakeStringValue'
                            }
                        )
                        ProtectionUnderLockConfigRequired      = $True
                        RevokeOnUnenrollDisabled               = $True
                        SmbAutoEncryptedFileExtensions         = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )

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
                Should -Invoke -CommandName Remove-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy -Exactly 1
            }
        }
        Context -Name 'The IntuneWindowsInformationProtectionPolicyWindows10MdmEnrolled Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AzureRightsManagementServicesAllowed   = $True
                    DataRecoveryCertificate                = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionDataRecoveryCertificate -Property @{
                            Description        = 'FakeStringValue'
                            ExpirationDateTime = '2023-01-01T00:00:00.0000000+00:00'
                            SubjectName        = 'FakeStringValue'
                        } -ClientOnly)
                    Description                            = 'FakeStringValue'
                    DisplayName                            = 'FakeStringValue'
                    EnforcementLevel                       = 'noProtection'
                    EnterpriseDomain                       = 'FakeStringValue'
                    EnterpriseInternalProxyServers         = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    EnterpriseIPRanges                     = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionIPRangeCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Ranges      = (New-CimInstance -ClassName MSFT_MicrosoftGraphipRange -Property @{
                                    CidrAddress  = 'FakeStringValue'
                                    UpperAddress = 'FakeStringValue'
                                    LowerAddress = 'FakeStringValue'
                                    odataType    = '#microsoft.graph.iPv4CidrRange'
                                } -ClientOnly)
                        } -ClientOnly)
                    )
                    EnterpriseIPRangesAreAuthoritative     = $True
                    EnterpriseNetworkDomainNames           = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    EnterpriseProtectedDomainNames         = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    EnterpriseProxiedDomains               = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionProxiedDomainCollection -Property @{
                            DisplayName    = 'FakeStringValue'
                            ProxiedDomains = (New-CimInstance -ClassName MSFT_MicrosoftGraphproxiedDomain -Property @{
                                    Proxy           = 'FakeStringValue'
                                    IpAddressOrFQDN = 'FakeStringValue'
                                } -ClientOnly)
                        } -ClientOnly)
                    )
                    EnterpriseProxyServers                 = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    EnterpriseProxyServersAreAuthoritative = $True
                    ExemptApps                             = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionApp -Property @{
                            BinaryVersionLow  = 'FakeStringValue'
                            Description       = 'FakeStringValue'
                            odataType         = '#microsoft.graph.windowsInformationProtectionDesktopApp'
                            BinaryName        = 'FakeStringValue'
                            BinaryVersionHigh = 'FakeStringValue'
                            Denied            = $True
                            PublisherName     = 'FakeStringValue'
                            ProductName       = 'FakeStringValue'
                            DisplayName       = 'FakeStringValue'
                        } -ClientOnly)
                    )
                    IconsVisible                           = $True
                    Id                                     = 'FakeStringValue'
                    IndexingEncryptedStoresOrItemsBlocked  = $True
                    NeutralDomainResources                 = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    ProtectedApps                          = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionApp -Property @{
                            BinaryVersionLow  = 'FakeStringValue'
                            Description       = 'FakeStringValue'
                            odataType         = '#microsoft.graph.windowsInformationProtectionDesktopApp'
                            BinaryName        = 'FakeStringValue'
                            BinaryVersionHigh = 'FakeStringValue'
                            Denied            = $True
                            PublisherName     = 'FakeStringValue'
                            ProductName       = 'FakeStringValue'
                            DisplayName       = 'FakeStringValue'
                        } -ClientOnly)
                    )
                    ProtectionUnderLockConfigRequired      = $True
                    RevokeOnUnenrollDisabled               = $True
                    SmbAutoEncryptedFileExtensions         = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    Ensure                                 = 'Present'
                    Credential                             = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy -MockWith {
                    return @{
                        AdditionalProperties                   = @{
                            '@odata.type' = '#microsoft.graph.MdmWindowsInformationProtectionPolicy'
                        }
                        AzureRightsManagementServicesAllowed   = $True
                        DataRecoveryCertificate                = @{
                            Description        = 'FakeStringValue'
                            ExpirationDateTime = '2023-01-01T00:00:00.0000000+00:00'
                            SubjectName        = 'FakeStringValue'
                        }
                        Description                            = 'FakeStringValue'
                        DisplayName                            = 'FakeStringValue'
                        EnforcementLevel                       = 'noProtection'
                        EnterpriseDomain                       = 'FakeStringValue'
                        EnterpriseInternalProxyServers         = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        EnterpriseIPRanges                     = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Ranges      = @(
                                    @{
                                        AdditionalProperties = @{
                                            cidrAddress   = 'FakeStringValue'
                                            upperAddress  = 'FakeStringValue'
                                            lowerAddress  = 'FakeStringValue'
                                            '@odata.type' = '#microsoft.graph.iPv4CidrRange'
                                        }
                                    }
                                )
                            }
                        )
                        EnterpriseIPRangesAreAuthoritative     = $True
                        EnterpriseNetworkDomainNames           = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        EnterpriseProtectedDomainNames         = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        EnterpriseProxiedDomains               = @(
                            @{
                                DisplayName    = 'FakeStringValue'
                                ProxiedDomains = @(
                                    @{
                                        Proxy           = 'FakeStringValue'
                                        IpAddressOrFQDN = 'FakeStringValue'
                                    }
                                )
                            }
                        )
                        EnterpriseProxyServers                 = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        EnterpriseProxyServersAreAuthoritative = $True
                        ExemptApps                             = @(
                            @{
                                Description          = 'FakeStringValue'
                                AdditionalProperties = @{
                                    binaryName        = 'FakeStringValue'
                                    binaryVersionLow  = 'FakeStringValue'
                                    binaryVersionHigh = 'FakeStringValue'
                                    '@odata.type'     = '#microsoft.graph.windowsInformationProtectionDesktopApp'
                                }
                                Denied               = $True
                                PublisherName        = 'FakeStringValue'
                                ProductName          = 'FakeStringValue'
                                DisplayName          = 'FakeStringValue'
                            }
                        )
                        IconsVisible                           = $True
                        Id                                     = 'FakeStringValue'
                        IndexingEncryptedStoresOrItemsBlocked  = $True
                        NeutralDomainResources                 = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        ProtectedApps                          = @(
                            @{
                                Description          = 'FakeStringValue'
                                AdditionalProperties = @{
                                    binaryName        = 'FakeStringValue'
                                    binaryVersionLow  = 'FakeStringValue'
                                    binaryVersionHigh = 'FakeStringValue'
                                    '@odata.type'     = '#microsoft.graph.windowsInformationProtectionDesktopApp'
                                }
                                Denied               = $True
                                PublisherName        = 'FakeStringValue'
                                ProductName          = 'FakeStringValue'
                                DisplayName          = 'FakeStringValue'
                            }
                        )
                        ProtectionUnderLockConfigRequired      = $True
                        RevokeOnUnenrollDisabled               = $True
                        SmbAutoEncryptedFileExtensions         = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The IntuneWindowsInformationProtectionPolicyWindows10MdmEnrolled exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AzureRightsManagementServicesAllowed   = $True
                    DataRecoveryCertificate                = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionDataRecoveryCertificate -Property @{
                            Description        = 'FakeStringValue'
                            ExpirationDateTime = '2023-01-01T00:00:00.0000000+00:00'
                            SubjectName        = 'FakeStringValue'
                        } -ClientOnly)
                    Description                            = 'FakeStringValue'
                    DisplayName                            = 'FakeStringValue'
                    EnforcementLevel                       = 'noProtection'
                    EnterpriseDomain                       = 'FakeStringValue'
                    EnterpriseInternalProxyServers         = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    EnterpriseIPRanges                     = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionIPRangeCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Ranges      = (New-CimInstance -ClassName MSFT_MicrosoftGraphipRange -Property @{
                                    CidrAddress  = 'FakeStringValue'
                                    UpperAddress = 'FakeStringValue'
                                    LowerAddress = 'FakeStringValue'
                                    odataType    = '#microsoft.graph.iPv4CidrRange'
                                } -ClientOnly)
                        } -ClientOnly)
                    )
                    EnterpriseIPRangesAreAuthoritative     = $True
                    EnterpriseNetworkDomainNames           = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    EnterpriseProtectedDomainNames         = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    EnterpriseProxiedDomains               = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionProxiedDomainCollection -Property @{
                            DisplayName    = 'FakeStringValue'
                            ProxiedDomains = (New-CimInstance -ClassName MSFT_MicrosoftGraphproxiedDomain -Property @{
                                    Proxy           = 'FakeStringValue'
                                    IpAddressOrFQDN = 'FakeStringValue'
                                } -ClientOnly)
                        } -ClientOnly)
                    )
                    EnterpriseProxyServers                 = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    EnterpriseProxyServersAreAuthoritative = $True
                    ExemptApps                             = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionApp -Property @{
                            BinaryVersionLow  = 'FakeStringValue'
                            Description       = 'FakeStringValue'
                            odataType         = '#microsoft.graph.windowsInformationProtectionDesktopApp'
                            BinaryName        = 'FakeStringValue'
                            BinaryVersionHigh = 'FakeStringValue'
                            Denied            = $True
                            PublisherName     = 'FakeStringValue'
                            ProductName       = 'FakeStringValue'
                            DisplayName       = 'FakeStringValue'
                        } -ClientOnly)
                    )
                    IconsVisible                           = $True
                    Id                                     = 'FakeStringValue'
                    IndexingEncryptedStoresOrItemsBlocked  = $True
                    NeutralDomainResources                 = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    ProtectedApps                          = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionApp -Property @{
                            BinaryVersionLow  = 'FakeStringValue'
                            Description       = 'FakeStringValue'
                            odataType         = '#microsoft.graph.windowsInformationProtectionDesktopApp'
                            BinaryName        = 'FakeStringValue'
                            BinaryVersionHigh = 'FakeStringValue'
                            Denied            = $True
                            PublisherName     = 'FakeStringValue'
                            ProductName       = 'FakeStringValue'
                            DisplayName       = 'FakeStringValue'
                        } -ClientOnly)
                    )
                    ProtectionUnderLockConfigRequired      = $True
                    RevokeOnUnenrollDisabled               = $True
                    SmbAutoEncryptedFileExtensions         = @(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsInformationProtectionResourceCollection -Property @{
                            DisplayName = 'FakeStringValue'
                            Resources   = @('FakeStringValue')
                        } -ClientOnly)
                    )
                    Ensure                                 = 'Present'
                    Credential                             = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy -MockWith {
                    return @{
                        DataRecoveryCertificate        = @{
                            Description        = 'FakeStringValue'
                            ExpirationDateTime = '2023-01-01T00:00:00.0000000+00:00'
                            SubjectName        = 'FakeStringValue'
                        }
                        Description                    = 'FakeStringValue'
                        DisplayName                    = 'FakeStringValue'
                        EnforcementLevel               = 'noProtection'
                        EnterpriseDomain               = 'FakeStringValue'
                        EnterpriseInternalProxyServers = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        EnterpriseIPRanges             = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Ranges      = @(
                                    @{
                                        AdditionalProperties = @{
                                            cidrAddress   = 'FakeStringValue'
                                            upperAddress  = 'FakeStringValue'
                                            lowerAddress  = 'FakeStringValue'
                                            '@odata.type' = '#microsoft.graph.iPv4CidrRange'
                                        }
                                    }
                                )
                            }
                        )
                        EnterpriseNetworkDomainNames   = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        EnterpriseProtectedDomainNames = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        EnterpriseProxiedDomains       = @(
                            @{
                                DisplayName    = 'FakeStringValue'
                                ProxiedDomains = @(
                                    @{
                                        Proxy           = 'FakeStringValue'
                                        IpAddressOrFQDN = 'FakeStringValue'
                                    }
                                )
                            }
                        )
                        EnterpriseProxyServers         = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        ExemptApps                     = @(
                            @{
                                AdditionalProperties = @{
                                    binaryName        = 'FakeStringValue'
                                    binaryVersionLow  = 'FakeStringValue'
                                    binaryVersionHigh = 'FakeStringValue'
                                    '@odata.type'     = '#microsoft.graph.windowsInformationProtectionDesktopApp'
                                }
                                PublisherName        = 'FakeStringValue'
                                Description          = 'FakeStringValue'
                                DisplayName          = 'FakeStringValue'
                                ProductName          = 'FakeStringValue'
                            }
                        )
                        Id                             = 'FakeStringValue'
                        NeutralDomainResources         = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        ProtectedApps                  = @(
                            @{
                                AdditionalProperties = @{
                                    binaryName        = 'FakeStringValue'
                                    binaryVersionLow  = 'FakeStringValue'
                                    binaryVersionHigh = 'FakeStringValue'
                                    '@odata.type'     = '#microsoft.graph.windowsInformationProtectionDesktopApp'
                                }
                                PublisherName        = 'FakeStringValue'
                                Description          = 'FakeStringValue'
                                DisplayName          = 'FakeStringValue'
                                ProductName          = 'FakeStringValue'
                            }
                        )
                        SmbAutoEncryptedFileExtensions = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
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
                Should -Invoke -CommandName Update-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceAppManagementMdmWindowsInformationProtectionPolicy -MockWith {
                    return @{
                        AdditionalProperties                   = @{
                            '@odata.type' = '#microsoft.graph.MdmWindowsInformationProtectionPolicy'
                        }
                        AzureRightsManagementServicesAllowed   = $True
                        DataRecoveryCertificate                = @{
                            Description        = 'FakeStringValue'
                            ExpirationDateTime = '2023-01-01T00:00:00.0000000+00:00'
                            SubjectName        = 'FakeStringValue'
                        }
                        Description                            = 'FakeStringValue'
                        DisplayName                            = 'FakeStringValue'
                        EnforcementLevel                       = 'noProtection'
                        EnterpriseDomain                       = 'FakeStringValue'
                        EnterpriseInternalProxyServers         = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        EnterpriseIPRanges                     = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Ranges      = @(
                                    @{
                                        AdditionalProperties = @{
                                            cidrAddress   = 'FakeStringValue'
                                            upperAddress  = 'FakeStringValue'
                                            lowerAddress  = 'FakeStringValue'
                                            '@odata.type' = '#microsoft.graph.iPv4CidrRange'
                                        }
                                    }
                                )
                            }
                        )
                        EnterpriseIPRangesAreAuthoritative     = $True
                        EnterpriseNetworkDomainNames           = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        EnterpriseProtectedDomainNames         = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        EnterpriseProxiedDomains               = @(
                            @{
                                DisplayName    = 'FakeStringValue'
                                ProxiedDomains = @(
                                    @{
                                        Proxy           = 'FakeStringValue'
                                        IpAddressOrFQDN = 'FakeStringValue'
                                    }
                                )
                            }
                        )
                        EnterpriseProxyServers                 = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        EnterpriseProxyServersAreAuthoritative = $True
                        ExemptApps                             = @(
                            @{
                                Description          = 'FakeStringValue'
                                AdditionalProperties = @{
                                    binaryName        = 'FakeStringValue'
                                    binaryVersionLow  = 'FakeStringValue'
                                    binaryVersionHigh = 'FakeStringValue'
                                    '@odata.type'     = '#microsoft.graph.windowsInformationProtectionDesktopApp'
                                }
                                Denied               = $True
                                PublisherName        = 'FakeStringValue'
                                ProductName          = 'FakeStringValue'
                                DisplayName          = 'FakeStringValue'
                            }
                        )
                        IconsVisible                           = $True
                        Id                                     = 'FakeStringValue'
                        IndexingEncryptedStoresOrItemsBlocked  = $True
                        NeutralDomainResources                 = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )
                        ProtectedApps                          = @(
                            @{
                                Description          = 'FakeStringValue'
                                AdditionalProperties = @{
                                    binaryName        = 'FakeStringValue'
                                    binaryVersionLow  = 'FakeStringValue'
                                    binaryVersionHigh = 'FakeStringValue'
                                    '@odata.type'     = '#microsoft.graph.windowsInformationProtectionDesktopApp'
                                }
                                Denied               = $True
                                PublisherName        = 'FakeStringValue'
                                ProductName          = 'FakeStringValue'
                                DisplayName          = 'FakeStringValue'
                            }
                        )
                        ProtectionUnderLockConfigRequired      = $True
                        RevokeOnUnenrollDisabled               = $True
                        SmbAutoEncryptedFileExtensions         = @(
                            @{
                                DisplayName = 'FakeStringValue'
                                Resources   = @('FakeStringValue')
                            }
                        )

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
