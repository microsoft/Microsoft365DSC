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
    -DscResource 'EXOOMEConfiguration' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Set-OMEConfiguration -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'Configuration needs updating' -Fixture {
            BeforeAll {
                $testParams = @{
                    BackgroundColor     = 'Navy'
                    Credential          = $Credential
                    DisclaimerText      = 'Test Text'
                    EmailText           = 'Email'
                    Ensure              = 'Present'
                    Identity            = 'OME Configuration'
                    IntroductionText    = 'Hello World'
                    OTPEnabled          = $True
                    PortalText          = 'Portal Text'
                    PrivacyStatementUrl = 'Privacy'
                    ReadButtonText      = 'Read'
                    SocialIdSignIn      = $True
                }

                Mock -CommandName Get-OMEConfiguration -MockWith {
                    return @{
                        BackgroundColor     = 'Navy'
                        DisclaimerText      = 'Test Text'
                        EmailText           = 'Email'
                        Identity            = 'OME Configuration'
                        IntroductionText    = 'Hello World'
                        OTPEnabled          = $False; #drift
                        PortalText          = 'Portal Text'
                        PrivacyStatementUrl = 'Privacy'
                        ReadButtonText      = 'Read'
                        SocialIdSignIn      = $True
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-OMEConfiguration -Exactly 1
            }
        }

        Context -Name 'Update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    BackgroundColor     = 'Navy'
                    Credential          = $Credential
                    DisclaimerText      = 'Test Text'
                    EmailText           = 'Email'
                    Ensure              = 'Present'
                    Identity            = 'OME Configuration'
                    IntroductionText    = 'Hello World'
                    OTPEnabled          = $True
                    PortalText          = 'Portal Text'
                    PrivacyStatementUrl = 'Privacy'
                    ReadButtonText      = 'Read'
                    SocialIdSignIn      = $True
                }

                Mock -CommandName Get-OMEConfiguration  -MockWith {
                    return @{
                        BackgroundColor     = 'Navy'
                        DisclaimerText      = 'Test Text'
                        EmailText           = 'Email'
                        Identity            = 'OME Configuration'
                        IntroductionText    = 'Hello World'
                        OTPEnabled          = $True
                        PortalText          = 'Portal Text'
                        PrivacyStatementUrl = 'Privacy'
                        ReadButtonText      = 'Read'
                        SocialIdSignIn      = $True
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-OMEConfiguration  -MockWith {
                    return @{
                        BackgroundColor     = 'Navy'
                        DisclaimerText      = 'Test Text'
                        EmailText           = 'Email'
                        Identity            = 'OME Configuration'
                        IntroductionText    = 'Hello World'
                        OTPEnabled          = $True
                        PortalText          = 'Portal Text'
                        PrivacyStatementUrl = 'Privacy'
                        ReadButtonText      = 'Read'
                        SocialIdSignIn      = $True
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
