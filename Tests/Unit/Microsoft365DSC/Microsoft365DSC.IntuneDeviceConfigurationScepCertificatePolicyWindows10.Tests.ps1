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
    -DscResource "IntuneDeviceConfigurationScepCertificatePolicyWindows10" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "f@kepassword1" -AsPlainText -Force
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
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementDeviceConfigurationAssignment -MockWith {
            }

            Mock -CommandName Get-DeviceConfigurationPolicyRootCertificateId -MockWith {
                return "00000000-0000-0000-0000-000000000000"
            }

            Mock -CommandName Update-DeviceConfigurationPolicyRootCertificateId -MockWith {
            }
        }
        # Test contexts
        Context -Name "The IntuneDeviceConfigurationScepCertificatePolicyWindows10 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    CertificateStore = "user"
                    certificateValidityPeriodScale = "days"
                    certificateValidityPeriodValue = 25
                    customSubjectAlternativeNames = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomSubjectAlternativeName -Property @{
                            sanType = "none"
                            name = "FakeStringValue"
                        } -ClientOnly)
                    )
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    extendedKeyUsages = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphextendedKeyUsage -Property @{
                            objectIdentifier = "FakeStringValue"
                            name = "FakeStringValue"
                        } -ClientOnly)
                    )
                    HashAlgorithm = "sha1"
                    id = "FakeStringValue"
                    KeySize = "size1024"
                    keyStorageProvider = "useTpmKspOtherwiseUseSoftwareKsp"
                    KeyUsage = @("keyEncipherment")
                    renewalThresholdPercentage = 25
                    ScepServerUrls = @("FakeStringValue")
                    SubjectAlternativeNameFormatString = "FakeStringValue"
                    subjectAlternativeNameType = "none"
                    subjectNameFormat = "commonName"
                    SubjectNameFormatString = "FakeStringValue"
                    RootCertificateId = "00000000-0000-0000-0000-000000000000"
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

        Context -Name "The IntuneDeviceConfigurationScepCertificatePolicyWindows10 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    CertificateStore = "user"
                    certificateValidityPeriodScale = "days"
                    certificateValidityPeriodValue = 25
                    customSubjectAlternativeNames = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomSubjectAlternativeName -Property @{
                            sanType = "none"
                            name = "FakeStringValue"
                        } -ClientOnly)
                    )
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    extendedKeyUsages = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphextendedKeyUsage -Property @{
                            objectIdentifier = "FakeStringValue"
                            name = "FakeStringValue"
                        } -ClientOnly)
                    )
                    HashAlgorithm = "sha1"
                    id = "FakeStringValue"
                    KeySize = "size1024"
                    keyStorageProvider = "useTpmKspOtherwiseUseSoftwareKsp"
                    KeyUsage = @("keyEncipherment")
                    renewalThresholdPercentage = 25
                    ScepServerUrls = @("FakeStringValue")
                    SubjectAlternativeNameFormatString = "FakeStringValue"
                    subjectAlternativeNameType = "none"
                    subjectNameFormat = "commonName"
                    SubjectNameFormatString = "FakeStringValue"
                    RootCertificateId = "00000000-0000-0000-0000-000000000000"
                    Ensure = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            subjectAlternativeNameType = "none"
                            keyUsage = "keyEncipherment"
                            subjectAlternativeNameFormatString = "FakeStringValue"
                            certificateValidityPeriodScale = "days"
                            keyStorageProvider = "useTpmKspOtherwiseUseSoftwareKsp"
                            '@odata.type' = "#microsoft.graph.windows81SCEPCertificateProfile"
                            scepServerUrls = @("FakeStringValue")
                            renewalThresholdPercentage = 25
                            certificateValidityPeriodValue = 25
                            hashAlgorithm = "sha1"
                            keySize = "size1024"
                            subjectNameFormatString = "FakeStringValue"
                            subjectNameFormat = "commonName"
                            certificateStore = "user"
                            extendedKeyUsages = @(
                                @{
                                    objectIdentifier = "FakeStringValue"
                                    name = "FakeStringValue"
                                }
                            )
                            customSubjectAlternativeNames = @(
                                @{
                                    sanType = "none"
                                    name = "FakeStringValue"
                                }
                            )
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
        Context -Name "The IntuneDeviceConfigurationScepCertificatePolicyWindows10 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    CertificateStore = "user"
                    certificateValidityPeriodScale = "days"
                    certificateValidityPeriodValue = 25
                    customSubjectAlternativeNames = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomSubjectAlternativeName -Property @{
                            sanType = "none"
                            name = "FakeStringValue"
                        } -ClientOnly)
                    )
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    extendedKeyUsages = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphextendedKeyUsage -Property @{
                            objectIdentifier = "FakeStringValue"
                            name = "FakeStringValue"
                        } -ClientOnly)
                    )
                    HashAlgorithm = "sha1"
                    id = "FakeStringValue"
                    KeySize = "size1024"
                    keyStorageProvider = "useTpmKspOtherwiseUseSoftwareKsp"
                    KeyUsage = @("keyEncipherment")
                    renewalThresholdPercentage = 25
                    ScepServerUrls = @("FakeStringValue")
                    SubjectAlternativeNameFormatString = "FakeStringValue"
                    subjectAlternativeNameType = "none"
                    subjectNameFormat = "commonName"
                    SubjectNameFormatString = "FakeStringValue"
                    RootCertificateId = "00000000-0000-0000-0000-000000000000"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            subjectAlternativeNameType = "none"
                            keyUsage = "keyEncipherment"
                            subjectAlternativeNameFormatString = "FakeStringValue"
                            certificateValidityPeriodScale = "days"
                            keyStorageProvider = "useTpmKspOtherwiseUseSoftwareKsp"
                            '@odata.type' = "#microsoft.graph.windows81SCEPCertificateProfile"
                            scepServerUrls = @("FakeStringValue")
                            renewalThresholdPercentage = 25
                            certificateValidityPeriodValue = 25
                            hashAlgorithm = "sha1"
                            keySize = "size1024"
                            subjectNameFormatString = "FakeStringValue"
                            subjectNameFormat = "commonName"
                            certificateStore = "user"
                            extendedKeyUsages = @(
                                @{
                                    objectIdentifier = "FakeStringValue"
                                    name = "FakeStringValue"
                                }
                            )
                            customSubjectAlternativeNames = @(
                                @{
                                    sanType = "none"
                                    name = "FakeStringValue"
                                }
                            )
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

        Context -Name "The IntuneDeviceConfigurationScepCertificatePolicyWindows10 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    CertificateStore = "user"
                    certificateValidityPeriodScale = "days"
                    certificateValidityPeriodValue = 25
                    customSubjectAlternativeNames = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomSubjectAlternativeName -Property @{
                            sanType = "none"
                            name = "FakeStringValue"
                        } -ClientOnly)
                    )
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    extendedKeyUsages = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphextendedKeyUsage -Property @{
                            objectIdentifier = "FakeStringValue"
                            name = "FakeStringValue"
                        } -ClientOnly)
                    )
                    HashAlgorithm = "sha1"
                    id = "FakeStringValue"
                    KeySize = "size1024"
                    keyStorageProvider = "useTpmKspOtherwiseUseSoftwareKsp"
                    KeyUsage = @("keyEncipherment")
                    renewalThresholdPercentage = 25
                    ScepServerUrls = @("FakeStringValue")
                    SubjectAlternativeNameFormatString = "FakeStringValue"
                    subjectAlternativeNameType = "none"
                    subjectNameFormat = "commonName"
                    SubjectNameFormatString = "FakeStringValue"
                    RootCertificateId = "00000000-0000-0000-0000-000000000000"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            subjectAlternativeNameType = "none"
                            keyUsage = "keyEncipherment"
                            subjectAlternativeNameFormatString = "FakeStringValue"
                            certificateValidityPeriodScale = "days"
                            keyStorageProvider = "useTpmKspOtherwiseUseSoftwareKsp"
                            '@odata.type' = "#microsoft.graph.windows81SCEPCertificateProfile"
                            scepServerUrls = @("FakeStringValue")
                            renewalThresholdPercentage = 7
                            certificateValidityPeriodValue = 7
                            hashAlgorithm = "sha1"
                            keySize = "size1024"
                            subjectNameFormatString = "FakeStringValue"
                            subjectNameFormat = "commonName"
                            certificateStore = "user"
                            extendedKeyUsages = @(
                                @{
                                    objectIdentifier = "FakeStringValue"
                                    name = "FakeStringValue"
                                }
                            )
                            customSubjectAlternativeNames = @(
                                @{
                                    sanType = "none"
                                    name = "FakeStringValue"
                                }
                            )
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
                            subjectAlternativeNameType = "none"
                            keyUsage = "keyEncipherment"
                            subjectAlternativeNameFormatString = "FakeStringValue"
                            certificateValidityPeriodScale = "days"
                            keyStorageProvider = "useTpmKspOtherwiseUseSoftwareKsp"
                            '@odata.type' = "#microsoft.graph.windows81SCEPCertificateProfile"
                            scepServerUrls = @("FakeStringValue")
                            renewalThresholdPercentage = 25
                            certificateValidityPeriodValue = 25
                            hashAlgorithm = "sha1"
                            keySize = "size1024"
                            subjectNameFormatString = "FakeStringValue"
                            subjectNameFormat = "commonName"
                            certificateStore = "user"
                            extendedKeyUsages = @(
                                @{
                                    objectIdentifier = "FakeStringValue"
                                    name = "FakeStringValue"
                                }
                            )
                            customSubjectAlternativeNames = @(
                                @{
                                    sanType = "none"
                                    name = "FakeStringValue"
                                }
                            )
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
