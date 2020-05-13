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
    -DscResource "EXOAvailabilityConfig" -GenericStubModule $GenericStubPath
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
        Context -Name "AvailabilityConfig should exist. OrgWideAccount is missing. Test should fail." -Fixture {
            $testParams = @{
                OrgWideAccount     = 'johndoe'
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-AvailabilityConfig -MockWith {
                return @{
                    OrgWideAccount = 'meganb'
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-AvailabilityConfig -MockWith {
                return @{
                    OrgWideAccount     = 'johndoe'
                    Ensure             = 'Present'
                    GlobalAdminAccount = $GlobalAdminAccount
                }
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }
        }

        Context -Name "AvailabilityConfig doesn't exist." -Fixture {
            $testParams = @{
                OrgWideAccount     = 'johndoe'
                Ensure             = 'Absent'
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-AvailabilityConfig -MockWith {
                return @{
                    OrgWideAccount = 'meganb'
                }
            }

            It "Should return Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }
        }

        Context -Name "AvailabilityConfig should exist. AvailabilityConfig exists. Test should pass." -Fixture {
            $testParams = @{
                OrgWideAccount     = 'johndoe'
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-AvailabilityConfig -MockWith {
                return @{
                    OrgWideAccount = 'johndoe'
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            $AvailabilityConfig = @{
                OrgWideAccount = "johndoe"
            }

            It "Should Reverse Engineer resource from the Export method" {
                Mock -CommandName Get-AvailabilityConfig -MockWith {
                    return $AvailabilityConfig
                }

                $exported = Export-TargetResource @testParams
                ([regex]::Matches($exported, " EXOAvailabilityConfig " )).Count | Should Be 1
                $exported.Contains("johndoe") | Should Be $true
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
