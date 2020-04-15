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
    -DscResource "O365OrgCustomizationSetting" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        # Test contexts
        Context -Name "When Organization Customization should be enabled" -Fixture {
            $testParams = @{
                IsSingleInstance   = "Yes"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-OrganizationConfig -MockWith {
                return @{
                    IsDehydrated = $true
                }
            }

            Mock -CommandName Enable-OrganizationCustomization -MockWith {
                return $null
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should return false from the Test method" {
                (Test-TargetResource @testParams) | Should Be $false
            }

            It "Should enable Organization Customization from the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Enable-OrganizationCustomization
            }
        }

        # Test contexts
        Context -Name "When Organization Config is not available" -Fixture {
            $testParams = @{
                IsSingleInstance   = "Yes"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-OrganizationConfig -MockWith {
                return $null
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }
        }

        Context -Name "When Organization Customization is already enabled" -Fixture {
            $testParams = @{
                IsSingleInstance   = "Yes"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-OrganizationConfig -MockWith {
                return @{
                    IsDehydrated = $false
                }
            }

            Mock -CommandName Enable-OrganizationCustomization -MockWith {
                return $null
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-OrganizationConfig -MockWith {
                return @{
                    IsDehydrated = $false
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                $returnValue = Export-TargetResource @testParams
                $returnValue | Should Not Be ""
            }

            Mock -CommandName Get-OrganizationConfig -MockWith {
                return @{
                    IsDehydrated = $true
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                $returnValue = Export-TargetResource @testParams
                $returnValue | Should Be ""
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
