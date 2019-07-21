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
    -DscResource "SCSensitivityLabel"
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

        Mock -CommandName Remove-Label -MockWith {
            return @{

            }
        }

        Mock -CommandName New-Label -MockWith {
            return @{

            }
        }

        Mock -CommandName Set-Label -MockWith {
            return @{

            }
        }

        # Test contexts
        Context -Name "Label doesn't already exist" -Fixture {
            $testParams = @{
                Name               = "TestLabel"
                Comment            = "This is a test label"
                ToolTip            = "Test tool tip"
                DisplayName        = "Test label"
                ParentId           = "TestLabel"
                Priority           = 0
                Disabled           = $false
                AdvancedSettings   = "AdvancedSettings stuff"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-Label -MockWith {
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

        Context -Name "Label already exists" -Fixture {
            $testParams = @{
                Name               = "TestLabel"
                Comment            = "This is a test label"
                ToolTip            = "Test tool tip"
                DisplayName        = "Test label"
                ParentId           = "TestLabel"
                Priority           = 0
                Disabled           = $false
                AdvancedSettings   = "AdvancedSettings stuff"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-Label -MockWith {
                return @{
                Name               = "TestLabel"
                Comment            = "This is a test label"
                ToolTip            = "Test tool tip"
                DisplayName        = "Test label"
                ParentId           = "TestLabel"
                Priority           = 0
                Disabled           = $false
                AdvancedSettings   = "AdvancedSettings stuff"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "Label should not exist" -Fixture {
            $testParams = @{
                Name               = "TestLabel"
                Comment            = "This is a test label"
                ToolTip            = "Test tool tip"
                DisplayName        = "Test label"
                ParentId           = "TestLabel"
                Priority           = 0
                Disabled           = $false
                AdvancedSettings   = "AdvancedSettings stuff"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-Label -MockWith {
                return @{

                }
            }

            It 'Should return True from the Test method' {
                Test-TargetResource @testParams | Should Be $True
            }

            It 'Should delete from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
                Name               = "TestRule"
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
