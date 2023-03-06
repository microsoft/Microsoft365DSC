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
    -DscResource 'EXOSafeAttachmentPolicy' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName New-SafeAttachmentPolicy -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-SafeAttachmentPolicy -MockWith {
                return @{

                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'SafeAttachmentPolicy creation.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure           = 'Present'
                    Identity         = 'TestSafeAttachmentPolicy'
                    Credential       = $Credential
                    AdminDisplayName = 'Test Safe Attachment Policy'
                    Action           = 'Block'
                    Enable           = $true
                    Redirect         = $true
                    RedirectAddress  = 'test@contoso.com'
                }

                Mock -CommandName Get-SafeAttachmentPolicy -MockWith {
                    return @{
                        Identity = 'SomeOtherPolicy'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'SafeAttachmentPolicy update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure           = 'Present'
                    Identity         = 'TestSafeAttachmentPolicy'
                    Credential       = $Credential
                    AdminDisplayName = 'Test Safe Attachment Policy'
                    Action           = 'Block'
                    Enable           = $true
                    Redirect         = $true
                    RedirectAddress  = 'test@contoso.com'
                }

                Mock -CommandName Get-SafeAttachmentPolicy -MockWith {
                    return @{
                        Ensure           = 'Present'
                        Identity         = 'TestSafeAttachmentPolicy'
                        Credential       = $Credential
                        AdminDisplayName = 'Test Safe Attachment Policy'
                        Action           = 'Block'
                        Enable           = $true
                        Redirect         = $true
                        RedirectAddress  = 'test@contoso.com'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'SafeAttachmentPolicy update needed.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure           = 'Present'
                    Identity         = 'TestSafeAttachmentPolicy'
                    Credential       = $Credential
                    AdminDisplayName = 'Test Safe Attachment Policy'
                    Action           = 'Block'
                    Enable           = $true
                    Redirect         = $true
                    RedirectAddress  = 'test@contoso.com'
                }

                Mock -CommandName Get-SafeAttachmentPolicy -MockWith {
                    return @{
                        Ensure           = 'Present'
                        Identity         = 'TestSafeAttachmentPolicy'
                        Credential       = $Credential
                        AdminDisplayName = 'Test Safe Attachment Policy'
                        Action           = 'Block'
                        Enable           = $false
                        Redirect         = $false
                    }
                }

                Mock -CommandName Set-SafeAttachmentPolicy -MockWith {
                    return @{
                    }
                }
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'SafeAttachmentPolicy removal.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure     = 'Absent'
                    Identity   = 'TestSafeAttachmentPolicy'
                    Credential = $Credential
                }

                Mock -CommandName Get-SafeAttachmentPolicy -MockWith {
                    return @{
                        Identity = 'TestSafeAttachmentPolicy'
                    }
                }

                Mock -CommandName Remove-SafeAttachmentPolicy -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Confirm-ImportedCmdletIsAvailable -MockWith {
                    return $true
                }

                Mock -CommandName Get-SafeAttachmentPolicy -MockWith {
                    return @{
                        Identity = 'TestSafeAttachmentPolicy'
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
