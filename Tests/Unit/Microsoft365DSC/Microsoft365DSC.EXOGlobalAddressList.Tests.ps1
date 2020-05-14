[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Microsoft365.psm1" `
            -Resolve)
)

$GenericStubPath = (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\Stubs\Generic.psm1" `
        -Resolve)
Import-Module -Name (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "EXOGlobalAddressList" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Get-PSSession -MockWith {

        }

        Mock -CommandName Remove-PSSession -MockWith {

        }

        # Test contexts
        Context -Name "Global Address List should exist. Global Address List is missing. Test should fail." -Fixture {
            $testParams = @{
                Name                       = 'Contoso GAL'
                ConditionalCompany         = 'Contoso'
                ConditionalDepartment      = "HR"
                ConditionalStateOrProvince = "US"
                IncludedRecipients         = "AllRecipients"
                Ensure                     = 'Present'
                GlobalAdminAccount         = $GlobalAdminAccount
            }

            Mock -CommandName Get-GlobalAddressList -MockWith {
                return @{
                    Name                       = 'Contoso Different GAL'
                    ConditionalCompany         = 'Contoso'
                    ConditionalDepartment      = "Finance"
                    ConditionalStateOrProvince = "DE"
                    IncludedRecipients         = "AllRecipients"
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-GlobalAddressList -MockWith {
                return @{
                    Name                       = 'Contoso GAL'
                    ConditionalCompany         = 'Contoso'
                    ConditionalDepartment      = "HR"
                    ConditionalStateOrProvince = "US"
                    IncludedRecipients         = "AllRecipients"
                    Ensure                     = 'Present'
                    GlobalAdminAccount         = $GlobalAdminAccount
                }
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }
        }

        Context -Name "Global Address List should exist. Global Address List exists. Test should pass." -Fixture {
            $testParams = @{
                Name                       = 'Contoso GAL'
                ConditionalCompany         = 'Contoso'
                ConditionalDepartment      = "HR"
                ConditionalStateOrProvince = "US"
                IncludedRecipients         = "AllRecipients"
                Ensure                     = 'Present'
                GlobalAdminAccount         = $GlobalAdminAccount
            }

            Mock -CommandName Get-GlobalAddressList -MockWith {
                return @{
                    Name                       = 'Contoso GAL'
                    ConditionalCompany         = 'Contoso'
                    ConditionalDepartment      = "HR"
                    ConditionalStateOrProvince = "US"
                    IncludedRecipients         = "AllRecipients"
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "Global Address List should exist. Global Address List exists, ConditionalDepartment mismatch. Test should fail." -Fixture {
            $testParams = @{
                Name                       = 'Contoso GAL'
                ConditionalCompany         = 'Contoso'
                ConditionalDepartment      = "HR"
                ConditionalStateOrProvince = "US"
                IncludedRecipients         = "AllRecipients"
                Ensure                     = 'Present'
                GlobalAdminAccount         = $GlobalAdminAccount
            }

            Mock -CommandName Get-GlobalAddressList -MockWith {
                return @{
                    Name                       = 'Contoso GAL'
                    ConditionalCompany         = 'Contoso'
                    ConditionalDepartment      = "Finance"
                    ConditionalStateOrProvince = "US"
                    IncludedRecipients         = "AllRecipients"
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-GlobalAddressList -MockWith {
                return @{
                    Name                       = 'Contoso GAL'
                    ConditionalCompany         = 'Contoso'
                    ConditionalDepartment      = "HR"
                    ConditionalStateOrProvince = "US"
                    IncludedRecipients         = "AllRecipients"
                    GlobalAdminAccount         = $GlobalAdminAccount
                }
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            $GlobalAddressList = @{
                Name                       = 'Contoso GAL'
                ConditionalCompany         = 'Contoso'
                ConditionalDepartment      = "HR"
                ConditionalStateOrProvince = "US"
                IncludedRecipients         = "AllRecipients"
            }

            It "Should Reverse Engineer resource from the Export method when single" {
                Mock -CommandName Get-GlobalAddressList -MockWith {
                    return $GlobalAddressList
                }

                $exported = Export-TargetResource @testParams
                ([regex]::Matches($exported, " EXOGlobalAddressList " )).Count | Should Be 1
                $exported.Contains("HR") | Should Be $true
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
