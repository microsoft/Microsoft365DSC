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
    -DscResource "EXOSafeLinksPolicy" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

            }

            Mock -CommandName New-SafeLinksPolicy -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-SafeLinksPolicy -MockWith {
                return @{

                }
            }
        }

        # Test contexts
        Context -Name "SafeLinksPolicy creation." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                   = 'Present'
                    Identity                 = 'TestSafeLinksPolicy'
                    GlobalAdminAccount       = $GlobalAdminAccount
                    AdminDisplayName         = 'Test SafeLinks Policy'
                    DoNotAllowClickThrough   = $true
                    DoNotRewriteUrls         = @('test.contoso.com', 'test.fabrikam.org')
                    DoNotTrackUserClicks     = $true
                    EnableForInternalSenders = $false
                    IsEnabled                = $false
                    ScanUrls                 = $false
                }

                Mock -CommandName Get-SafeLinksPolicy -MockWith {
                    return @{
                        Identity = 'SomeOtherPolicy'
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

        Context -Name "SafeLinksPolicy update not required." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                   = 'Present'
                    Identity                 = 'TestSafeLinksPolicy'
                    GlobalAdminAccount       = $GlobalAdminAccount
                    AdminDisplayName         = 'Test SafeLinks Policy'
                    DoNotAllowClickThrough   = $true
                    DoNotRewriteUrls         = @('test.contoso.com', 'test.fabrikam.org')
                    DoNotTrackUserClicks     = $true
                    EnableForInternalSenders = $false
                    IsEnabled                = $false
                    ScanUrls                 = $false
                }

                Mock -CommandName Get-SafeLinksPolicy -MockWith {
                    return @{
                        Identity                 = 'TestSafeLinksPolicy'
                        AdminDisplayName         = 'Test SafeLinks Policy'
                        DoNotAllowClickThrough   = $true
                        DoNotRewriteUrls         = @('test.contoso.com', 'test.fabrikam.org')
                        DoNotTrackUserClicks     = $true
                        EnableForInternalSenders = $false
                        IsEnabled                = $false
                        ScanUrls                 = $false
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "SafeLinksPolicy update needed." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                   = 'Present'
                    Identity                 = 'TestSafeLinksPolicy'
                    GlobalAdminAccount       = $GlobalAdminAccount
                    AdminDisplayName         = 'Test SafeLinks Policy'
                    DoNotAllowClickThrough   = $true
                    DoNotRewriteUrls         = @('test.contoso.com', 'test.fabrikam.org')
                    DoNotTrackUserClicks     = $true
                    EnableForInternalSenders = $false
                    IsEnabled                = $false
                    ScanUrls                 = $false
                }

                Mock -CommandName Get-SafeLinksPolicy -MockWith {
                    return @{
                        Ensure                   = 'Present'
                        Identity                 = 'TestSafeLinksPolicy'
                        GlobalAdminAccount       = $GlobalAdminAccount
                        AdminDisplayName         = 'Test SafeLinks Policy'
                        DoNotAllowClickThrough   = $true
                        DoNotRewriteUrls         = @('test1.contoso.com', 'test.fabrikam.org')
                        DoNotTrackUserClicks     = $true
                        EnableForInternalSenders = $true
                        IsEnabled                = $true
                        ScanUrls                 = $true
                    }
                }

                Mock -CommandName Set-SafeLinksPolicy -MockWith {
                    return @{
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

        Context -Name "SafeLinksPolicy removal." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                   = 'Absent'
                    Identity                 = 'TestSafeLinksPolicy'
                    GlobalAdminAccount       = $GlobalAdminAccount
                    AdminDisplayName         = 'Test SafeLinks Policy'
                    DoNotAllowClickThrough   = $true
                    DoNotRewriteUrls         = @('test.contoso.com', 'test.fabrikam.org')
                    DoNotTrackUserClicks     = $true
                    EnableForInternalSenders = $false
                    IsEnabled                = $false
                    ScanUrls                 = $false
                }

                Mock -CommandName Get-SafeLinksPolicy -MockWith {
                    return @{
                        Identity = 'TestSafeLinksPolicy'
                    }
                }

                Mock -CommandName Remove-SafeLinksPolicy -MockWith {
                    return @{

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
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-SafeLinksPolicy -MockWith {
                    return @{
                        Identity                 = 'TestSafeLinksPolicy'
                        AdminDisplayName         = 'Test SafeLinks Policy'
                        DoNotAllowClickThrough   = $true
                        DoNotRewriteUrls         = @('test.contoso.com', 'test.fabrikam.org')
                        DoNotTrackUserClicks     = $true
                        EnableForInternalSenders = $false
                        IsEnabled                = $false
                        ScanUrls                 = $false
                    }
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
