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
    -DscResource "SCComplianceTag" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Import-PSSession -MockWith {

            }

            Mock -CommandName New-PSSession -MockWith {

            }

            Mock -CommandName Remove-ComplianceTag -MockWith {
                return @{

                }
            }

            Mock -CommandName New-ComplianceTag -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-ComplianceTag -MockWith {
                return @{

                }
            }
        }

        # Test contexts
        Context -Name "Rule doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Name               = "TestRule"
                    Comment            = "This is a test Rule"
                    RetentionAction    = "Keep"
                    RetentionDuration  = "1025"
                    FilePlanProperty   = (New-CimInstance -ClassName MSFT_SCFilePlanProperty -Property @{
                            FilePlanPropertyDepartment = "Legal"
                        } -ClientOnly)
                    GlobalAdminAccount = $GlobalAdminAccount
                    RetentionType      = "ModificationAgeInDays"
                    Ensure             = "Present"
                }

                Mock -CommandName Get-ComplianceTag -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Rule already exists" -Fixture {
            BeforeAll {
                $testParams = @{
                    Name               = "TestRule"
                    Comment            = "This is a test Rule"
                    RetentionAction    = "Keep"
                    RetentionDuration  = "1025"
                    FilePlanProperty   = (New-CimInstance -ClassName MSFT_SCFilePlanProperty -Property @{
                            FilePlanPropertyDepartment  = "DemoDept"
                            FilePlanPropertyCitation    = "DemoCit"
                            FilePlanPropertyReferenceId = "DemoRef"
                            FilePlanPropertyAuthority   = "DemoAuth"
                            FilePlanPropertyCategory    = "DemoCat"
                            FilePlanPropertySubcategory = "DemoSub"
                        } -ClientOnly)
                    GlobalAdminAccount = $GlobalAdminAccount
                    RetentionType      = "ModificationAgeInDays"
                    Ensure             = "Present"
                }

                Mock -CommandName Get-ComplianceTag -MockWith {
                    return @{
                        Name              = "TestRule"
                        Comment           = "This is a test Rule"
                        RetentionAction   = "Keep"
                        RetentionDuration = "1025"
                        FilePlanMetadata  = '{"Settings":[
                            {"Key":"FilePlanPropertyDepartment","Value":"DemoDept"},
                            {"Key":"FilePlanPropertyCitation","Value":"DemoCit"},
                            {"Key":"FilePlanPropertyReferenceId","Value":"DemoRef"},
                            {"Key":"FilePlanPropertyAuthority","Value":"DemoAuth"},
                            {"Key":"FilePlanPropertyCategory","Value":"DemoCat"},
                            {"Key":"FilePlanPropertySubcategory","Value":"DemoSub"}]}'
                        RetentionType     = "ModificationAgeInDays"
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "Rule should not exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure             = "Absent"
                    Name               = "TestRule"
                    Comment            = "This is a test Rule"
                    RetentionAction    = "Keep"
                    FilePlanProperty   = (New-CimInstance -ClassName MSFT_SCFilePlanProperty -Property @{
                            FilePlanPropertyDepartment = "Legal"
                        } -ClientOnly)
                    RetentionDuration  = "1025"
                    GlobalAdminAccount = $GlobalAdminAccount
                    RetentionType      = "ModificationAgeInDays"
                }

                Mock -CommandName Get-ComplianceTag -MockWith {
                    return @{
                        Name              = "TestRule"
                        Comment           = "This is a test Rule"
                        RetentionAction   = "Keep"
                        RetentionDuration = "1025"
                        FilePlanMetadata  = '{"Settings":[
                            {"Key":"FilePlanPropertyDepartment","Value":"DemoDept"},
                            {"Key":"FilePlanPropertyCitation","Value":"DemoCit"},
                            {"Key":"FilePlanPropertyReferenceId","Value":"DemoRef"},
                            {"Key":"FilePlanPropertyAuthority","Value":"DemoAuth"},
                            {"Key":"FilePlanPropertyCategory","Value":"DemoCat"},
                            {"Key":"FilePlanPropertySubcategory","Value":"DemoSub"}]}'
                        RetentionType     = "ModificationAgeInDays"
                    }
                }
            }

            It 'Should return False from the Test method' {
                Test-TargetResource @testParams | Should -Be $False
            }

            It 'Should delete from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-ComplianceTag -Exactly 1
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
