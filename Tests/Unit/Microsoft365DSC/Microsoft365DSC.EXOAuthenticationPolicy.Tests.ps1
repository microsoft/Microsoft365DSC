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
    -DscResource "EXOAuthenticationPolicy" -GenericStubModule $GenericStubPath
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
                return "Credential"
            }

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

            }
        }

        # Test contexts
        Context -Name "Authentication Policy should exist. Authentication Policy is missing. Test should fail." -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity                                = "Contoso Auth Policy"
                    AllowBasicAuthActiveSync                = $False
                    AllowBasicAuthAutodiscover              = $False
                    AllowBasicAuthImap                      = $False
                    AllowBasicAuthMapi                      = $False
                    AllowBasicAuthOfflineAddressBook        = $False
                    AllowBasicAuthOutlookService            = $False
                    AllowBasicAuthPop                       = $False
                    AllowBasicAuthPowerShell                = $False
                    AllowBasicAuthReportingWebServices      = $False
                    AllowBasicAuthRpc                       = $False
                    AllowBasicAuthSmtp                      = $False
                    AllowBasicAuthWebServices               = $False
                    Ensure                                  = 'Present'
                    Credential                              = $Credential
                }

                Mock -CommandName Get-AuthenticationPolicy -MockWith {
                    return $null
                }

                Mock -CommandName Set-AuthenticationPolicy -MockWith {
                    return @{
                        Identity                            = "Contoso Auth Policy"
                        AllowBasicAuthActiveSync            = $False
                        AllowBasicAuthAutodiscover          = $False
                        AllowBasicAuthImap                  = $False
                        AllowBasicAuthMapi                  = $False
                        AllowBasicAuthOfflineAddressBook    = $False
                        AllowBasicAuthOutlookService        = $False
                        AllowBasicAuthPop                   = $False
                        AllowBasicAuthPowerShell            = $False
                        AllowBasicAuthReportingWebServices  = $False
                        AllowBasicAuthRpc                   = $False
                        AllowBasicAuthSmtp                  = $False
                        AllowBasicAuthWebServices           = $False
                        Ensure                              = 'Present'
                        Credential                          = $Credential
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }
        }

        Context -Name "Authentication Policy should exist. Authentication Policy does exists. Test should pass." -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity                                = "Contoso Auth Policy"
                    AllowBasicAuthActiveSync                = $False
                    AllowBasicAuthAutodiscover              = $False
                    AllowBasicAuthImap                      = $False
                    AllowBasicAuthMapi                      = $False
                    AllowBasicAuthOfflineAddressBook        = $False
                    AllowBasicAuthOutlookService            = $False
                    AllowBasicAuthPop                       = $False
                    AllowBasicAuthPowerShell                = $False
                    AllowBasicAuthReportingWebServices      = $False
                    AllowBasicAuthRpc                       = $False
                    AllowBasicAuthSmtp                      = $False
                    AllowBasicAuthWebServices               = $False
                    Ensure                                  = 'Present'
                    Credential                              = $Credential
                }

                Mock -CommandName Get-AuthenticationPolicy -MockWith {
                    return @{
                        Identity                            = "Contoso Auth Policy"
                        AllowBasicAuthActiveSync            = $False
                        AllowBasicAuthAutodiscover          = $False
                        AllowBasicAuthImap                  = $False
                        AllowBasicAuthMapi                  = $False
                        AllowBasicAuthOfflineAddressBook    = $False
                        AllowBasicAuthOutlookService        = $False
                        AllowBasicAuthPop                   = $False
                        AllowBasicAuthPowerShell            = $False
                        AllowBasicAuthReportingWebServices  = $False
                        AllowBasicAuthRpc                   = $False
                        AllowBasicAuthSmtp                  = $False
                        AllowBasicAuthWebServices           = $False
                        Ensure                              = 'Present'
                        Credential                          = $Credential
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "Authentication Policy should exist. Authentication Policy exists, AllowBasicAuthPop mismatch. Test should fail." -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity                                = "Contoso Auth Policy"
                    AllowBasicAuthActiveSync                = $False
                    AllowBasicAuthAutodiscover              = $False
                    AllowBasicAuthImap                      = $False
                    AllowBasicAuthMapi                      = $False
                    AllowBasicAuthOfflineAddressBook        = $False
                    AllowBasicAuthOutlookService            = $False
                    AllowBasicAuthPop                       = $False
                    AllowBasicAuthPowerShell                = $False
                    AllowBasicAuthReportingWebServices      = $False
                    AllowBasicAuthRpc                       = $False
                    AllowBasicAuthSmtp                      = $False
                    AllowBasicAuthWebServices               = $False
                    Ensure                                  = 'Present'
                    Credential                              = $Credential
                }

                Mock -CommandName Get-AuthenticationPolicy -MockWith {
                    return @{
                        Identity                            = "Contoso Auth Policy"
                        AllowBasicAuthActiveSync            = $False
                        AllowBasicAuthAutodiscover          = $False
                        AllowBasicAuthImap                  = $False
                        AllowBasicAuthMapi                  = $False
                        AllowBasicAuthOfflineAddressBook    = $False
                        AllowBasicAuthOutlookService        = $False
                        AllowBasicAuthPop                   = $True
                        AllowBasicAuthPowerShell            = $False
                        AllowBasicAuthReportingWebServices  = $False
                        AllowBasicAuthRpc                   = $False
                        AllowBasicAuthSmtp                  = $False
                        AllowBasicAuthWebServices           = $False
                        Ensure                              = 'Present'
                        Credential                          = $Credential
                    }
                }

                Mock -CommandName Set-AuthenticationPolicy -MockWith {
                    return @{
                        Identity                            = "Contoso Auth Policy"
                        AllowBasicAuthActiveSync            = $False
                        AllowBasicAuthAutodiscover          = $False
                        AllowBasicAuthImap                  = $False
                        AllowBasicAuthMapi                  = $False
                        AllowBasicAuthOfflineAddressBook    = $False
                        AllowBasicAuthOutlookService        = $False
                        AllowBasicAuthPop                   = $False
                        AllowBasicAuthPowerShell            = $False
                        AllowBasicAuthReportingWebServices  = $False
                        AllowBasicAuthRpc                   = $False
                        AllowBasicAuthSmtp                  = $False
                        AllowBasicAuthWebServices           = $False
                        Ensure                              = 'Present'
                        Credential                          = $Credential
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential                              = $Credential
                }

                $AuthPolicy = @{
                    Identity                                = "Contoso Auth Policy"
                    AllowBasicAuthActiveSync                = $False
                    AllowBasicAuthAutodiscover              = $False
                    AllowBasicAuthImap                      = $False
                    AllowBasicAuthMapi                      = $False
                    AllowBasicAuthOfflineAddressBook        = $False
                    AllowBasicAuthOutlookService            = $False
                    AllowBasicAuthPop                       = $False
                    AllowBasicAuthPowerShell                = $False
                    AllowBasicAuthReportingWebServices      = $False
                    AllowBasicAuthRpc                       = $False
                    AllowBasicAuthSmtp                      = $False
                    AllowBasicAuthWebServices               = $False
                }
                Mock -CommandName Get-AuthenticationPolicy -MockWith {
                    return $AuthPolicy
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
