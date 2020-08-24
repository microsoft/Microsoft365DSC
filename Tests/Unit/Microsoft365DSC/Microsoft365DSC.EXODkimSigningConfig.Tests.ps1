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
    -DscResource "EXODkimSigningConfig" -GenericStubModule $GenericStubPath
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

            Mock -CommandName New-DkimSigningConfig -MockWith {

            }

            Mock -CommandName Set-DkimSigningConfig -MockWith {

            }

            Mock -CommandName Remove-DkimSigningConfig -MockWith {

            }

            Mock -CommandName Confirm-ImportedCmdletIsAvailable -MockWith {
                return $true
            }
        }

        # Test contexts
        Context -Name "DkimSigningConfig creation." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                 = 'Present'
                    Identity               = 'contoso.com'
                    GlobalAdminAccount     = $GlobalAdminAccount
                    AdminDisplayName       = 'contoso.com DKIM Config'
                    BodyCanonicalization   = 'Relaxed'
                    Enabled                = $false
                    HeaderCanonicalization = 'Relaxed'
                    KeySize                = 1024
                }

                Mock -CommandName Get-DkimSigningConfig -MockWith {
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

        Context -Name "DkimSigningConfig update not required." -Fixture {
            BeforeAll {
                    $testParams = @{
                    Ensure                 = 'Present'
                    Identity               = 'contoso.com'
                    GlobalAdminAccount     = $GlobalAdminAccount
                    AdminDisplayName       = 'contoso.com DKIM Config'
                    BodyCanonicalization   = 'Relaxed'
                    Enabled                = $false
                    HeaderCanonicalization = 'Relaxed'
                    KeySize                = 1024
                }

                Mock -CommandName Get-DkimSigningConfig -MockWith {
                    return @{
                        Ensure                 = 'Present'
                        Identity               = 'contoso.com'
                        GlobalAdminAccount     = $GlobalAdminAccount
                        AdminDisplayName       = 'contoso.com DKIM Config'
                        BodyCanonicalization   = 'Relaxed'
                        Enabled                = $false
                        HeaderCanonicalization = 'Relaxed'
                        KeySize                = 1024
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "DkimSigningConfig update needed." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                 = 'Present'
                    Identity               = 'contoso.com'
                    GlobalAdminAccount     = $GlobalAdminAccount
                    AdminDisplayName       = 'contoso.com DKIM Config'
                    BodyCanonicalization   = 'Relaxed'
                    Enabled                = $true
                    HeaderCanonicalization = 'Relaxed'
                    KeySize                = 1024
                }

                Mock -CommandName Get-DkimSigningConfig -MockWith {
                    return @{
                        Ensure                 = 'Present'
                        Identity               = 'contoso.com'
                        GlobalAdminAccount     = $GlobalAdminAccount
                        AdminDisplayName       = 'contoso.com DKIM Config'
                        BodyCanonicalization   = 'Simple'
                        Enabled                = $false
                        HeaderCanonicalization = 'Simple'
                        KeySize                = 1024
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

        Context -Name "DkimSigningConfig removal." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure             = 'Absent'
                    Identity           = 'contoso.com'
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-DkimSigningConfig -MockWith {
                    return @{
                        Identity = 'contoso.com'
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

                Mock -CommandName Get-DkimSigningConfig -MockWith {
                    return @{
                        Identity = 'contoso.com'
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
