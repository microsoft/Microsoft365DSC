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
    -DscResource 'EXOPartnerApplication' -GenericStubModule $GenericStubPath
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

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'Partner Application should exist. Partner Application is missing. Test should fail.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                                = 'Contoso HRApp'
                    ApplicationIdentifier               = '00000006-0000-0dd1-ac00-000000000000'
                    AcceptSecurityIdentifierInformation = $false
                    AccountType                         = 'OrganizationalAccount'
                    Enabled                             = $true
                    Ensure                              = 'Present'
                    Credential                          = $Credential
                }

                Mock -CommandName Get-PartnerApplication -MockWith {
                    return @{
                        Name                                = 'Contoso Different HRApp'
                        ApplicationIdentifier               = '00000006-0000-0dd1-ac00-000000000000'
                        AcceptSecurityIdentifierInformation = $false
                        AccountType                         = 'OrganizationalAccount'
                        Enabled                             = $true
                    }
                }

                Mock -CommandName Set-PartnerApplication -MockWith {
                    return @{
                        Name                                = 'Contoso HRApp'
                        ApplicationIdentifier               = '00000006-0000-0dd1-ac00-000000000000'
                        AcceptSecurityIdentifierInformation = $false
                        AccountType                         = 'OrganizationalAccount'
                        Enabled                             = $true
                        Ensure                              = 'Present'
                        Credential                          = $Credential
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
        }

        Context -Name 'Partner Application should exist. Partner Application exists. Test should pass.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                                = 'Contoso HRApp'
                    ApplicationIdentifier               = '00000006-0000-0dd1-ac00-000000000000'
                    AcceptSecurityIdentifierInformation = $false
                    AccountType                         = 'OrganizationalAccount'
                    Enabled                             = $true
                    Ensure                              = 'Present'
                    Credential                          = $Credential
                }

                Mock -CommandName Get-PartnerApplication -MockWith {
                    return @{
                        Name                                = 'Contoso HRApp'
                        ApplicationIdentifier               = '00000006-0000-0dd1-ac00-000000000000'
                        AcceptSecurityIdentifierInformation = $false
                        AccountType                         = 'OrganizationalAccount'
                        Enabled                             = $true
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Partner Application should exist. Partner Application exists, AccountType mismatch. Test should fail.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                                = 'Contoso HRApp'
                    ApplicationIdentifier               = '00000006-0000-0dd1-ac00-000000000000'
                    AcceptSecurityIdentifierInformation = $false
                    AccountType                         = 'OrganizationalAccount'
                    Enabled                             = $true
                    Ensure                              = 'Present'
                    Credential                          = $Credential
                }

                Mock -CommandName Get-PartnerApplication -MockWith {
                    return @{
                        Name                                = 'Contoso HRApp'
                        ApplicationIdentifier               = '00000006-0000-0dd1-ac00-000000000000'
                        AcceptSecurityIdentifierInformation = $false
                        AccountType                         = 'ConsumerAccount'
                        Enabled                             = $true
                    }
                }

                Mock -CommandName Set-PartnerApplication -MockWith {
                    return @{
                        Name                                = 'Contoso HRApp'
                        ApplicationIdentifier               = '00000006-0000-0dd1-ac00-000000000000'
                        AcceptSecurityIdentifierInformation = $false
                        AccountType                         = 'OrganizationalAccount'
                        Enabled                             = $true
                        Ensure                              = 'Present'
                        Credential                          = $Credential
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

                $PartnerApplication = @{
                    Name                                = 'Contoso HRApp'
                    ApplicationIdentifier               = '00000006-0000-0dd1-ac00-000000000000'
                    AcceptSecurityIdentifierInformation = $false
                    AccountType                         = 'OrganizationalAccount'
                    Enabled                             = $true
                }
                Mock -CommandName Get-PartnerApplication -MockWith {
                    return $PartnerApplication
                }
            }

            It 'Should Reverse Engineer resource from the Export method when single' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
