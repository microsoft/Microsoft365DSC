[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath "..\..\Unit" `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath "\Stubs\Microsoft365.psm1" `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath "\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "EXOOMEConfiguration" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

            }

            Mock -CommandName Set-OMEConfiguration -MockWith {

            }
        }

        # Test contexts
        Context -Name "Configuration needs updating" -Fixture {
            BeforeAll {
                $testParams = @{
                    BackgroundColor      = "Navy";
                    Credential           = $Credential;
                    DisclaimerText       = "Test Text";
                    EmailText            = "Email";
                    Ensure               = "Present";
                    Identity             = "OME Configuration";
                    IntroductionText     = "Hello World";
                    OTPEnabled           = $True;
                    PortalText           = "Portal Text";
                    PrivacyStatementUrl  = "Privacy";
                    ReadButtonText       = "Read";
                    SocialIdSignIn       = $True;
                }

                Mock -CommandName Get-OMEConfiguration  -MockWith {
                    return @{
                        BackgroundColor      = "Navy";
                        DisclaimerText       = "Test Text";
                        EmailText            = "Email";
                        Identity             = "OME Configuration";
                        IntroductionText     = "Hello World";
                        OTPEnabled           = $False; #drift
                        PortalText           = "Portal Text";
                        PrivacyStatementUrl  = "Privacy";
                        ReadButtonText       = "Read";
                        SocialIdSignIn       = $True;
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-OMEConfiguration -Exactly 1
            }
        }

        Context -Name "Update not required." -Fixture {
            BeforeAll {
                $testParams = @{
                    BackgroundColor      = "Navy";
                    Credential           = $Credential;
                    DisclaimerText       = "Test Text";
                    EmailText            = "Email";
                    Ensure               = "Present";
                    Identity             = "OME Configuration";
                    IntroductionText     = "Hello World";
                    OTPEnabled           = $True;
                    PortalText           = "Portal Text";
                    PrivacyStatementUrl  = "Privacy";
                    ReadButtonText       = "Read";
                    SocialIdSignIn       = $True;
                }

                Mock -CommandName Get-OMEConfiguration  -MockWith {
                    return @{
                        BackgroundColor      = "Navy";
                        DisclaimerText       = "Test Text";
                        EmailText            = "Email";
                        Identity             = "OME Configuration";
                        IntroductionText     = "Hello World";
                        OTPEnabled           = $True
                        PortalText           = "Portal Text";
                        PrivacyStatementUrl  = "Privacy";
                        ReadButtonText       = "Read";
                        SocialIdSignIn       = $True;
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
