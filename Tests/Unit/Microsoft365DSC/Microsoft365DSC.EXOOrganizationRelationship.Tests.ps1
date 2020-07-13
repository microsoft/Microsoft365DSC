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
    -DscResource "EXOOrganizationRelationship" -GenericStubModule $GenericStubPath
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
        }

        # Test contexts
        Context -Name "Organization Relationship should exist. Organization Relationship is missing. Test should fail." -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                = 'Contoso'
                    DomainNames         = 'contoso.com'
                    FreeBusyAccessLevel = 'AvailabilityOnly'
                    Ensure              = 'Present'
                    GlobalAdminAccount  = $GlobalAdminAccount
                }

                Mock -CommandName Get-OrganizationRelationship -MockWith {
                    return @{
                        Name                = 'ContosoDifferent'
                        DomainNames         = 'different.contoso.com'
                        FreeBusyAccessLevel = 'AvailabilityOnly'
                    }
                }

                Mock -CommandName Set-OrganizationRelationship -MockWith {
                    return @{
                        FreeBusyAccessLevel = 'AvailabilityOnly'
                        Ensure              = 'Present'
                        GlobalAdminAccount  = $GlobalAdminAccount
                        Name                = 'Contoso'
                        DomainNames         = 'contoso.com'
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

        Context -Name "Organization Relationship should exist. Organization Relationship exists. Test should pass." -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                = 'Contoso'
                    DomainNames         = 'contoso.com'
                    FreeBusyAccessLevel = 'AvailabilityOnly'
                    Ensure              = 'Present'
                    GlobalAdminAccount  = $GlobalAdminAccount
                }

                Mock -CommandName Get-OrganizationRelationship -MockWith {
                    return @{
                        Name                = 'Contoso'
                        DomainNames         = 'contoso.com'
                        FreeBusyAccessLevel = 'AvailabilityOnly'
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

        Context -Name "Organization Relationship should exist. Organization Relationship exists, FreeBusyAccessLevel mismatch. Test should fail." -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                = 'Contoso'
                    DomainNames         = 'contoso.com'
                    FreeBusyAccessLevel = 'AvailabilityOnly'
                    Ensure              = 'Present'
                    GlobalAdminAccount  = $GlobalAdminAccount
                }

                Mock -CommandName Get-OrganizationRelationship -MockWith {
                    return @{
                        Name                = 'Contoso'
                        DomainNames         = 'contoso.com'
                        FreeBusyAccessLevel = 'None'
                    }
                }

                Mock -CommandName Set-OrganizationRelationship -MockWith {
                    return @{
                        Name                = 'Contoso'
                        DomainNames         = 'contoso.com'
                        FreeBusyAccessLevel = 'AvailabilityOnly'
                        Ensure              = 'Present'
                        GlobalAdminAccount  = $GlobalAdminAccount
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

                $OrgRelationship = @{
                    Name                = 'ContosoDifferent1'
                    DomainNames         = @('different1.contoso.com')
                    FreeBusyAccessLevel = 'AvailabilityOnly'
                }
                Mock -CommandName Get-OrganizationRelationship -MockWith {
                    return $OrgRelationship
                }
            }

            It "Should Reverse Engineer resource from the Export method when single" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
