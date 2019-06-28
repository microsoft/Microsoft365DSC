[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Office365.psm1" `
            -Resolve)
)

Import-Module -Name (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-O365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "SCSupervisoryReviewPolicy"
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-SecurityAndComplianceConnection -MockWith {

        }

        Mock -CommandName Import-PSSession -MockWith {

        }

        Mock -CommandName New-PSSession -MockWith {

        }

        Mock -CommandName Remove-SupervisoryReviewPolicyV2 -MockWith {

        }

        Mock -CommandName Set-SupervisoryReviewPolicyV2 -MockWith {

        }

        Mock -CommandName New-SupervisoryReviewPolicyV2 -MockWith {
            return @{

            }
        }

        # Test contexts
        Context -Name "Policy doesn't already exist" -Fixture {
            $testParams = @{
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
                Name               = 'TestPolicy'
                Reviewers          = @("admin@contoso.com")
            }

            Mock -CommandName Get-SupervisoryReviewPolicyV2 -MockWith {
                return $null
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Policy already exists" -Fixture {
            $testParams = @{
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
                Name               = 'TestPolicy'
                Reviewers          = @("admin@contoso.com")
            }

            Mock -CommandName Get-SupervisoryReviewPolicyV2 -MockWith {
                return @{
                    Name      = "TestPolicy"
                    Comment   = "Hello World"
                    Reviewers = @("admin@contoso.com")
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Should recreate from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "Policy should not exist" -Fixture {
            $testParams = @{
                Ensure             = 'Absent'
                GlobalAdminAccount = $GlobalAdminAccount
                Name               = 'TestPolicy'
                Reviewers          = @("admin@contoso.com")
            }

            Mock -CommandName Get-SupervisoryReviewPolicyV2 -MockWith {
                return @{
                    Name      = "TestPolicy"
                    Comment   = "Hello World"
                    Reviewers = @("admin@contoso.com")
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It 'Should delete from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
                Name               = "Test Policy"
                Reviewers          = @("admin@contoso.com")
            }

            Mock -CommandName Get-SupervisoryReviewPolicyV2 -MockWith {
                return @{
                    Name      = "TestPolicy"
                    Comment   = "Hello World"
                    Reviewers = @("admin@contoso.com")
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
