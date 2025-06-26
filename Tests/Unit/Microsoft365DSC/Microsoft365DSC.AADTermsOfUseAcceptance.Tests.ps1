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
    -DscResource "AADTermsOfUseAcceptance" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mytenant.onmicrosoft.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgAgreementAcceptance -MockWith {
            }

            Mock -CommandName New-MgAgreementAcceptance -MockWith {
            }

            Mock -CommandName Remove-MgAgreementAcceptance -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
                return "AADTermsOfUseAcceptance 'Export-Test' { AgreementId = '12345678-1234-1234-1234-123456789012'; UserId = '87654321-4321-4321-4321-210987654321'; Ensure = 'Present' }"
            }

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

        }

        # Test contexts
        Context -Name "The AADTermsOfUseAcceptance should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AgreementId           = '12345678-1234-1234-1234-123456789012'
                    UserId                = '87654321-4321-4321-4321-210987654321'
                    State                 = 'accepted'
                    Ensure                = 'Present'
                    Credential            = $Credential
                }

                Mock -CommandName Get-MgAgreementAcceptance -MockWith {
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
                Should -Invoke -CommandName New-MgAgreementAcceptance -Exactly 1
            }
        }

        Context -Name "The AADTermsOfUseAcceptance exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AgreementId           = '12345678-1234-1234-1234-123456789012'
                    UserId                = '87654321-4321-4321-4321-210987654321'
                    State                 = 'accepted'
                    Ensure                = 'Absent'
                    Credential            = $Credential
                }

                Mock -CommandName Get-MgAgreementAcceptance -MockWith {
                    return @{
                        Id                  = 'FakeStringValue'
                        AgreementId         = '12345678-1234-1234-1234-123456789012'
                        UserId              = '87654321-4321-4321-4321-210987654321'
                        AgreementFileId     = 'file-id-123'
                        UserPrincipalName   = 'user@example.com'
                        UserDisplayName     = 'Test User'
                        UserEmail           = 'user@example.com'
                        RecordedDateTime    = Get-Date
                        ExpirationDateTime  = (Get-Date).AddYears(1)
                        State               = 'accepted'
                        DeviceId            = 'device-123'
                        DeviceDisplayName   = 'Test Device'
                        DeviceOSType        = 'Windows'
                        DeviceOSVersion     = '10.0.19041'
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return True from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgAgreementAcceptance -Exactly 1
            }
        }

        Context -Name "The AADTermsOfUseAcceptance Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AgreementId           = '12345678-1234-1234-1234-123456789012'
                    UserId                = '87654321-4321-4321-4321-210987654321'
                    State                 = 'accepted'
                    Ensure                = 'Present'
                    Credential            = $Credential
                }

                Mock -CommandName Get-MgAgreementAcceptance -MockWith {
                    return @{
                        Id                  = 'FakeStringValue'
                        AgreementId         = '12345678-1234-1234-1234-123456789012'
                        UserId              = '87654321-4321-4321-4321-210987654321'
                        AgreementFileId     = 'file-id-123'
                        UserPrincipalName   = 'user@example.com'
                        UserDisplayName     = 'Test User'
                        UserEmail           = 'user@example.com'
                        RecordedDateTime    = Get-Date
                        ExpirationDateTime  = (Get-Date).AddYears(1)
                        State               = 'accepted'
                        DeviceId            = 'device-123'
                        DeviceDisplayName   = 'Test Device'
                        DeviceOSType        = 'Windows'
                        DeviceOSVersion     = '10.0.19041'
                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADTermsOfUseAcceptance exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AgreementId           = '12345678-1234-1234-1234-123456789012'
                    UserId                = '87654321-4321-4321-4321-210987654321'
                    State                 = 'declined'
                    Ensure                = 'Present'
                    Credential            = $Credential
                }

                Mock -CommandName Get-MgAgreementAcceptance -MockWith {
                    return @{
                        Id                  = 'FakeStringValue'
                        AgreementId         = '12345678-1234-1234-1234-123456789012'
                        UserId              = '87654321-4321-4321-4321-210987654321'
                        AgreementFileId     = 'file-id-123'
                        UserPrincipalName   = 'user@example.com'
                        UserDisplayName     = 'Test User'
                        UserEmail           = 'user@example.com'
                        RecordedDateTime    = Get-Date
                        ExpirationDateTime  = (Get-Date).AddYears(1)
                        State               = 'accepted'
                        DeviceId            = 'device-123'
                        DeviceDisplayName   = 'Test Device'
                        DeviceOSType        = 'Windows'
                        DeviceOSVersion     = '10.0.19041'
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
                Should -Invoke -CommandName Update-MgAgreementAcceptance -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgAgreement -MockWith {
                    return @(
                        @{
                            Id          = '12345678-1234-1234-1234-123456789012'
                            DisplayName = 'Test Agreement'
                        }
                    )
                }

                Mock -CommandName Get-MgAgreementAcceptance -MockWith {
                    return @(
                        @{
                            Id                  = 'FakeStringValue'
                            AgreementId         = '12345678-1234-1234-1234-123456789012'
                            UserId              = '87654321-4321-4321-4321-210987654321'
                            UserPrincipalName   = 'user@example.com'
                            UserDisplayName     = 'Test User'
                            UserEmail           = 'user@example.com'
                            RecordedDateTime    = Get-Date
                            ExpirationDateTime  = (Get-Date).AddYears(1)
                            State               = 'accepted'
                            DeviceId            = 'device-123'
                            DeviceDisplayName   = 'Test Device'
                            DeviceOSType        = 'Windows'
                            DeviceOSVersion     = '10.0.19041'
                            AgreementFileId     = 'file-id-123'
                        }
                    )
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