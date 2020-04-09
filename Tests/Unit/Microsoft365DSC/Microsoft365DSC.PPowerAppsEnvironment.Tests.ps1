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
    -DscResource "PPPowerAppsEnvironment" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Remove-AdminPowerAppEnvironment -MockWith {
            return @{

            }
        }

        Mock -CommandName New-AdminPowerAppEnvironment -MockWith {
            return @{

            }
        }

        # Test contexts
        Context -Name "Environment doesn't already exist" -Fixture {
            $testParams = @{
                DisplayName        = "Test Environment"
                Location           = 'canada'
                EnvironmentSKU     = 'production'
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-AdminPowerAppEnvironment -MockWith {
                return $null
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should create the environment in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName New-AdminPowerAppEnvironment -Exactly 1
            }
        }

        Context -Name "Environment already exists but is NOT in the Desired State" -Fixture {
            $testParams = @{
                DisplayName        = "Test Environment"
                Location           = 'canada'
                EnvironmentSKU     = 'production'
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-AdminPowerAppEnvironment -MockWith {
                return @{
                    DisplayName     = "Test Environment"
                    Location        = 'unitedstates'
                    EnvironmentType = 'production'
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should not do anything in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Remove-AdminPowerAppEnvironment -Exactly 0
                Assert-MockCalled -CommandName New-AdminPowerAppEnvironment -Exactly 0
            }
        }

        Context -Name "Environment already exists but IS ALREADY in the Desired State" -Fixture {
            $testParams = @{
                DisplayName        = "Test Environment"
                Location           = 'canada'
                EnvironmentSKU     = 'production'
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-AdminPowerAppEnvironment -MockWith {
                return @{
                    DisplayName     = "Test Environment"
                    Location        = 'canada'
                    EnvironmentType = 'production'
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "Environment already exists but SHOULD NOT" -Fixture {
            $testParams = @{
                DisplayName        = "Test Environment"
                Location           = 'canada'
                EnvironmentSKU     = 'production'
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Absent"
            }

            Mock -CommandName Get-AdminPowerAppEnvironment -MockWith {
                return @{
                    DisplayName     = "Test Environment"
                    Location        = 'canada'
                    EnvironmentType = 'production'
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should delete the environment in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Remove-AdminPowerAppEnvironment -Exactly 1
                Assert-MockCalled -CommandName New-AdminPowerAppEnvironment -Exactly 0
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-AdminPowerAppEnvironment -MockWith {
                return @{
                    DisplayName     = "Test Environment"
                    Location        = 'canada'
                    EnvironmentType = 'production'
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
