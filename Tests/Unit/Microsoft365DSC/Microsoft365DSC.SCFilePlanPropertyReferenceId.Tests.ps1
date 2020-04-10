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
    -DscResource "SCFilePlanPropertyReferenceId" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Remove-FilePlanPropertyReferenceId -MockWith {
            return @{

            }
        }

        Mock -CommandName New-FilePlanPropertyReferenceId -MockWith {
            return @{

            }
        }

        # Test contexts
        Context -Name "ReferenceId doesn't already exist" -Fixture {
            $testParams = @{
                Name               = "Demo ReferenceId"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-FilePlanPropertyReferenceId -MockWith {
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

        Context -Name "ReferenceId already exists" -Fixture {
            $testParams = @{
                Name               = "Demo ReferenceId"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-FilePlanPropertyReferenceId -MockWith {
                return @{
                    DisplayName = "Demo ReferenceId"
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Should do nothing from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "ReferenceId should not exist" -Fixture {
            $testParams = @{
                Name               = "Demo ReferenceId"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Absent"
            }

            Mock -CommandName Get-FilePlanPropertyReferenceId -MockWith {
                return @{
                    DisplayName = "Demo ReferenceId"
                }
            }

            It 'Should return False from the Test method' {
                Test-TargetResource @testParams | Should Be $False
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
            }

            Mock -CommandName Get-FilePlanPropertyReferenceId -MockWith {
                return @{
                    DisplayName = "Demo ReferenceId"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
