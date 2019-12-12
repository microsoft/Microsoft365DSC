[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Office365.psm1" `
            -Resolve)
)
$GenericStubPath = (Join-Path -Path $PSScriptRoot `
    -ChildPath "..\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-O365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "SCComplianceCase" -GenericStubModule $GenericStubPath
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

        Mock -CommandName Remove-ComplianceCase -MockWith {
            return @{

            }
        }

        Mock -CommandName New-ComplianceCase -MockWith {
            return @{

            }
        }

        Mock -CommandName Set-ComplianceCase -MockWith {
            return @{

            }
        }

        # Test contexts
        Context -Name "Case doesn't already exists and should be Active" -Fixture {
            $testParams = @{
                Name               = "TestCase"
                Description        = "This is a test Case"
                Status             = "Active"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-ComplianceCase -MockWith {
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

        Context -Name "Case doesn't already exist and should be Closed" -Fixture {
            $testParams = @{
                Name               = "TestCase"
                Description        = "This is a test Case"
                Status             = "Closed"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-ComplianceCase -MockWith {
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

        Context -Name "Case already exists, is Active, but should be closed" -Fixture {
            $testParams = @{
                Name               = "TestCase"
                Description        = "This is a test Case"
                Status             = "Closed"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-ComplianceCase -MockWith {
                return @{
                    Name        = "TestCase"
                    Description = ""
                    Status      = "Active"
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $False
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "Case already exists, is Closed, but should be Active" -Fixture {
            $testParams = @{
                Name               = "TestCase"
                Description        = "This is a test Case"
                Status             = "Active"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-ComplianceCase -MockWith {
                return @{
                    Name        = "TestCase"
                    Description = "This is a test Case"
                    Status      = "Closed"
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $False
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "Case should not exist, but is does" -Fixture {
            $testParams = @{
                Ensure             = "Absent"
                Name               = "TestCase"
                Status             = "Active"
                Description        = "This is a test Case"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-ComplianceCase -MockWith {
                return @{
                    Name        = "TestCase"
                    Status      = "Active"
                    Description = "This is a test Case"
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

            $testCase1 = @{
                Name        = "TestCase1"
                Status      = "Active"
                Description = "This is a test Case (1)"
            }

            $testCase2 = @{
                Name        = "TestCase2"
                Status      = "Active"
                Description = "This is a test Case (2)"
            }

            Mock -CommandName Get-ComplianceCase -ParameterFilter { $Name -eq "TestCase1" }  -MockWith {
                return $testCase1
            }

            Mock -CommandName Get-ComplianceCase -ParameterFilter { $Name -eq "TestCase2" } -MockWith {
                return $testCase2
            }

            It "Should Reverse Engineer resource from the Export method when single result" {
                Mock -CommandName Get-ComplianceCase -MockWith {
                    return $testCase1
                }

                $exported = Export-TargetResource @testParams
                ([regex]::Matches($exported, " SCComplianceCase " )).Count | Should Be 1
                $exported.Contains("TestCase1") | Should Be $true
            }

            It "Should Reverse Engineer resource from the Export method when multiple results" {
                Mock -CommandName Get-ComplianceCase -MockWith {
                    return @($testCase1, $testCase2)
                }

                $exported = Export-TargetResource @testParams
                ([regex]::Matches($exported, " SCComplianceCase " )).Count | Should Be 2
                $exported.Contains("TestCase1") | Should Be $true
                $exported.Contains("TestCase2") | Should Be $true
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
