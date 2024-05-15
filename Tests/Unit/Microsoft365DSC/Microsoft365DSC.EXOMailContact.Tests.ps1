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
    -DscResource 'EXOMailContact' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
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

            Mock -CommandName New-MailContact -MockWith {
            }

            Mock -CommandName Set-MailContact -MockWith {
            }

            Mock -CommandName Remove-MailContact -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "Instance should exist but doesn't." -Fixture {
            BeforeAll {
                $testParams = @{
                    Alias                       = 'TestMailContact'
                    Credential                  = $Credential
                    DisplayName                 = 'My Test Contact'
                    Ensure                      = 'Present'
                    ExternalEmailAddress        = 'SMTP:test@tailspintoys.com'
                    MacAttachmentFormat         = 'BinHex'
                    MessageBodyFormat           = 'TextAndHtml'
                    MessageFormat               = 'Mime'
                    ModeratedBy                 = @()
                    ModerationEnabled           = $False
                    Name                        = 'My Test Contact'
                    OrganizationalUnit          = 'nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/tailspintoys.com'
                    SendModerationNotifications = 'Always'
                    UsePreferMessageFormat      = $True
                }

                Mock -CommandName Get-MailContact -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create from the Set method' {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName New-MailContact -Exactly 1
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
        }

        Context -Name 'Instance already exists but is NOT in the desired state.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Alias                       = 'TestMailContact'
                    Credential                  = $Credential
                    DisplayName                 = 'My Test Contact'
                    Ensure                      = 'Present'
                    ExternalEmailAddress        = 'SMTP:test@tailspintoys.com'
                    MacAttachmentFormat         = 'BinHex'
                    MessageBodyFormat           = 'TextAndHtml'
                    MessageFormat               = 'Mime'
                    ModeratedBy                 = @()
                    ModerationEnabled           = $False
                    Name                        = 'My Test Contact'
                    OrganizationalUnit          = 'nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/tailspintoys.com'
                    SendModerationNotifications = 'Always'
                    UsePreferMessageFormat      = $True
                }

                Mock -CommandName Get-MailContact -MockWith {
                    return @{
                        Alias                       = 'TestMailContact'
                        DisplayName                 = 'My Test Contact'
                        ExternalEmailAddress        = 'SMTP:test@tailspintoys.com'
                        MacAttachmentFormat         = 'BinHex'
                        MessageBodyFormat           = 'Text'; #Drift
                        MessageFormat               = 'Text'; #Drift
                        ModeratedBy                 = @()
                        ModerationEnabled           = $False
                        Name                        = 'My Test Contact'
                        OrganizationalUnit          = 'nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/tailspintoys.com'
                        SendModerationNotifications = 'Always'
                        UsePreferMessageFormat      = $True
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Set-MailContact -Exactly 1
            }
        }

        Context -Name 'Instance already exists and is in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Alias                       = 'TestMailContact'
                    Credential                  = $Credential
                    DisplayName                 = 'My Test Contact'
                    Ensure                      = 'Present'
                    ExternalEmailAddress        = 'SMTP:test@tailspintoys.com'
                    MacAttachmentFormat         = 'BinHex'
                    MessageBodyFormat           = 'TextAndHtml'
                    MessageFormat               = 'Mime'
                    ModeratedBy                 = @()
                    ModerationEnabled           = $False
                    Name                        = 'My Test Contact'
                    OrganizationalUnit          = 'nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/tailspintoys.com'
                    SendModerationNotifications = 'Always'
                    UsePreferMessageFormat      = $True
                }

                Mock -CommandName Get-MailContact -MockWith {
                    return @{
                        Alias                       = 'TestMailContact'
                        DisplayName                 = 'My Test Contact'
                        ExternalEmailAddress        = 'SMTP:test@tailspintoys.com'
                        MacAttachmentFormat         = 'BinHex'
                        MessageBodyFormat           = 'TextAndHtml'
                        MessageFormat               = 'Mime'
                        ModeratedBy                 = @()
                        ModerationEnabled           = $False
                        Name                        = 'My Test Contact'
                        OrganizationalUnit          = 'nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/tailspintoys.com'
                        SendModerationNotifications = 'Always'
                        UsePreferMessageFormat      = $True
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Instance should NOT exist but it does' -Fixture {
            BeforeAll {
                $testParams = @{
                    Alias                       = 'TestMailContact'
                    Credential                  = $Credential
                    DisplayName                 = 'My Test Contact'
                    Ensure                      = 'Absent'
                    ExternalEmailAddress        = 'SMTP:test@tailspintoys.com'
                    MacAttachmentFormat         = 'BinHex'
                    MessageBodyFormat           = 'TextAndHtml'
                    MessageFormat               = 'Mime'
                    ModeratedBy                 = @()
                    ModerationEnabled           = $False
                    Name                        = 'My Test Contact'
                    OrganizationalUnit          = 'nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/tailspintoys.com'
                    SendModerationNotifications = 'Always'
                    UsePreferMessageFormat      = $True
                }

                Mock -CommandName Get-MailContact -MockWith {
                    return @{
                        Alias                       = 'TestMailContact'
                        DisplayName                 = 'My Test Contact'
                        ExternalEmailAddress        = 'SMTP:test@tailspintoys.com'
                        MacAttachmentFormat         = 'BinHex'
                        MessageBodyFormat           = 'TextAndHtml'
                        MessageFormat               = 'Mime'
                        ModeratedBy                 = @()
                        ModerationEnabled           = $False
                        Name                        = 'My Test Contact'
                        OrganizationalUnit          = 'nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/tailspintoys.com'
                        SendModerationNotifications = 'Always'
                        UsePreferMessageFormat      = $True
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should remove from the Set method' {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Remove-MailContact -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MailContact -MockWith {
                    return @{
                        Alias                       = 'TestMailContact'
                        DisplayName                 = 'My Test Contact'
                        ExternalEmailAddress        = 'SMTP:test@tailspintoys.com'
                        MacAttachmentFormat         = 'BinHex'
                        MessageBodyFormat           = 'TextAndHtml'
                        MessageFormat               = 'Mime'
                        ModeratedBy                 = @()
                        ModerationEnabled           = $False
                        Name                        = 'My Test Contact'
                        OrganizationalUnit          = 'nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/tailspintoys.com'
                        SendModerationNotifications = 'Always'
                        UsePreferMessageFormat      = $True
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
