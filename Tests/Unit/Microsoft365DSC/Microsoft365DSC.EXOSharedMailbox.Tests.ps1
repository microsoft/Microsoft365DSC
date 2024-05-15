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
    -DscResource 'EXOSharedMailbox' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@contoso.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
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
        Context -Name "Mailbox doesn't exist and it should" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = 'Test Shared Mailbox'
                    PrimarySMTPAddress = 'Testh@contoso.onmicrosoft.com'
                    Ensure             = 'Present'
                    Credential         = $Credential
                }

                Mock -CommandName Get-Mailbox -MockWith {
                    return $null
                }

                Mock -CommandName New-Mailbox -MockWith {

                }

                Mock -CommandName Set-Mailbox -MockWith {

                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should create the Shared Mailbox in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Mailbox already exists and it should' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = 'Test Shared Mailbox'
                    PrimarySMTPAddress = 'Test@contoso.onmicrosoft.com'
                    Ensure             = 'Present'
                    Credential         = $Credential
                }

                Mock -CommandName Get-Mailbox -MockWith {
                    return @{
                        Identity             = 'Test Shared Mailbox'
                        RecipientTypeDetails = 'SharedMailbox'
                        Alias                = 'test'
                        EmailAddresses       = @('smtp:user@contoso.onmicrosoft.com', 'SMTP:test@contoso.onmicrosoft.com')
                        PrimarySMTPAddress   = 'test@contoso.onmicrosoft.com'
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return True from the Test method' {
                Test-TargetResource @testParams | Should -Be $True
            }
            It 'Should return false from the Test method' {
                $testParams.PrimarySMTPAddress = 'test@contoso1.onmicrosoft.com'
                Test-TargetResource @testParams | Should -Be $False
            }
        }

        Context -Name 'Alias is Contained in the PrimarySMTP Address' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = 'Test Shared Mailbox'
                    PrimarySMTPAddress = 'Test@contoso.onmicrosoft.com'
                    EmailAddresses     = @('Test@contoso.onmicrosoft.com')
                    Ensure             = 'Present'
                    Credential         = $Credential
                }

                It 'Should throw an error from the Set method' {
                    { Set-TargetResource @testParams } | Should Throw 'You cannot have the EmailAddresses list contain the PrimarySMTPAddress'
                }
            }
        }

        Context -Name 'Mailbox exists but it should not' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = 'Test Shared Mailbox'
                    PrimarySMTPAddress = 'Test@contoso.onmicrosoft.com'
                    EmailAddresses     = @('User1@contoso.onmicrosoft.com')
                    Ensure             = 'Absent'
                    Credential         = $Credential
                }

                Mock -CommandName Get-Mailbox -MockWith {
                    return @{
                        Identity             = 'Test Shared Mailbox'
                        RecipientTypeDetails = 'SharedMailbox'
                        Alias                = 'test'
                        EmailAddresses       = @('smtp:user@contoso.onmicrosoft.com', 'SMTP:test@contoso.onmicrosoft.com')
                        PrimarySMTPAddress   = 'test@contoso.onmicrosoft.com'
                    }
                }

                Mock -CommandName Remove-Mailbox -MockWith {
                    return $null
                }
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-Mailbox -Times 1
            }
        }

        Context -Name 'EmailAddresses are specified' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = 'Test Shared Mailbox'
                    PrimarySMTPAddress = 'Test@contoso.onmicrosoft.com'
                    EmailAddresses     = @('User1@contoso.onmicrosoft.com')
                    Ensure             = 'Present'
                    Credential         = $Credential
                }

                Mock -CommandName Get-Mailbox -MockWith {
                    return @{
                        Identity             = 'Test Shared Mailbox'
                        RecipientTypeDetails = 'SharedMailbox'
                        Alias                = 'test'
                        EmailAddresses       = @('smtp:user@contoso.onmicrosoft.com', 'SMTP:test@contoso.onmicrosoft.com')
                        PrimarySMTPAddress   = 'test@contoso.onmicrosoft.com'
                    }
                }
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Primary Smtp Address different' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = 'Test Shared Mailbox'
                    PrimarySMTPAddress = 'Test@contoso1.onmicrosoft.com'
                    Alias                = 'test'
                    EmailAddresses     = @('smtp:user@contoso.onmicrosoft.com', 'SMTP:test@contoso.onmicrosoft.com')
                    Ensure             = 'Present'
                    Credential         = $Credential
                }

                Mock -CommandName Get-Mailbox -MockWith {
                    return @{
                        Identity             = 'Test Shared Mailbox'
                        RecipientTypeDetails = 'SharedMailbox'
                        Alias                = 'test'
                        EmailAddresses       = @('smtp:user@contoso.onmicrosoft.com', 'SMTP:test@contoso.onmicrosoft.com')
                        PrimarySMTPAddress   = 'test@contoso.onmicrosoft.com'
                    }
                }
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

                Mock -CommandName Get-Mailbox -MockWith {
                    return @{
                        Name                 = 'Test Shared Mailbox'
                        RecipientTypeDetails = 'SharedMailbox'
                        Alias                = 'test'
                        DisplayName          = 'Test Shared Mailbox'
                        PrimarySMTPAddress   = 'Testh@contoso.onmicrosoft.com'
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
