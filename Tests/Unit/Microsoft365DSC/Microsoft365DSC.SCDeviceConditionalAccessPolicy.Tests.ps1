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
    -DscResource "SCDeviceConditionalAccessPolicy" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Import-PSSession -MockWith {

        }

        Mock -CommandName New-PSSession -MockWith {

        }

        Mock -CommandName Remove-DeviceConditionalAccessPolicy -MockWith {
            # This mock should not return anything. Remove-* are normally void methods without any return types
        }

        Mock -CommandName Set-DeviceConditionalAccessPolicy -MockWith {

        }

        Mock -CommandName New-DeviceConditionalAccessPolicy -MockWith {
            return @{
                # This mock can simply return an empty object for the purpose of these tests.
            }
        }

        # Test contexts
        Context -Name "The Conditional Device Access Policy doesn't already exist" -Fixture {
            $testParams = @{
                Name               = 'TestPolicy'
                Comment            = 'This is a test comment'
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-DeviceConditionalAccessPolicy -MockWith {
                return $null # Policy Not found, therefore return null
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams

                # Because the policy was not found, the set method should attempt to create it;
                # Therefore we want to assess that the New-* method was called exactly once;
                Assert-MockCalled -CommandName 'New-DeviceConditionalAccessPolicy' -Exactly 1
            }
        }

        Context -Name "The Conditional Device Access Policy already exists and it is already in the Desired State" -Fixture {
            $testParams = @{
                Name               = 'TestPolicy'
                Comment            = 'This is a test comment'
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-DeviceConditionalAccessPolicy -MockWith {
                return @{
                    Name    = 'TestPolicy'
                    Comment = 'This is a test comment'
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "The Conditional Device Access Policy already exists and it is NOT in the Desired State" -Fixture {
            $testParams = @{
                Name               = 'TestPolicy'
                Comment            = 'This is a test comment'
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-DeviceConditionalAccessPolicy -MockWith {
                return @{
                    Name    = 'TestPolicy'
                    # Returns a drift in the comments property because it needs to not be in desired state
                    Comment = 'This is a DRIFT'
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
            It 'Should update the policy in the Set method' {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName "Set-DeviceConditionalAccessPolicy" -Exactly 1
            }
        }

        Context -Name "The Conditional Device Access Policy Exists but it Should NOT" -Fixture {
            $testParams = @{
                Name               = 'TestPolicy'
                Comment            = 'This is a test comment'
                Ensure             = 'Absent'
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-DeviceConditionalAccessPolicy -MockWith {
                return @{
                    Name    = 'TestPolicy'
                    Comment = 'This is a test comment'
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It 'Should Delete from the Set method' {
                Set-TargetResource @testParams
            # Because the policy was not found, the set method should attempt to delete it;
            # Therefore we want to assess that the Remove-* method was called exactly once;
                Assert-MockCalled -CommandName 'Remove-DeviceConditionalAccessPolicy' -Exactly 1
            }


        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-DeviceConditionalAccessPolicy -MockWith {
                return @{
                    Name    = 'TestPolicy'
                    Comment = 'This is a test comment'
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
