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
    -DscResource "EXOManagementRole" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Close-SessionsAndReturnError -MockWith {

        }

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Get-PSSession -MockWith {

        }

        Mock -CommandName Remove-PSSession -MockWith {

        }

        # Test contexts
        Context -Name "Management Role should exist. Management Role is missing. Test should fail." -Fixture {
            $testParams = @{
                Name               = "Contoso Management Role"
                Parent             = "Journaling"
                Description        = "This is the Contoso Management Role"
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-ManagementRole -MockWith {
                return @{
                    Name                = "Contoso Differet Management Role"
                    Parent              = "Journaling"
                    Description         = "This is the Different Contoso Management Role"
                    FreeBusyAccessLevel = 'AvailabilityOnly'
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName New-ManagementRole -MockWith {
                return @{
                    Name               = "Contoso Management Role"
                    Parent             = "Journaling"
                    Description        = "This is the Contoso Management Role"
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

        Context -Name "Management Role should exist. Management Role exists. Test should pass." -Fixture {
            $testParams = @{
                Name               = "Contoso Management Role"
                Parent             = "Journaling"
                Description        = "This is the Contoso Management Role"
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-ManagementRole -MockWith {
                return @{
                    Name        = "Contoso Management Role"
                    Parent      = "Journaling"
                    Description = "This is the Contoso Management Role"
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "Management Role should exist. Management Role exists, Description mismatch. Test should fail." -Fixture {
            $testParams = @{
                Name               = "Contoso Management Role"
                Parent             = "Journaling"
                Description        = "This is the Contoso Management Role"
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-ManagementRole -MockWith {
                return @{
                    Name        = "Contoso Management Role"
                    Parent      = "Journaling"
                    Description = "This is the Different Contoso Management Role"
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName New-ManagementRole -MockWith {
                return @{
                    Name               = "Contoso Management Role"
                    Parent             = "Journaling"
                    Description        = "This is the Contoso Management Role"
                    Ensure             = 'Present'
                    GlobalAdminAccount = $GlobalAdminAccount
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

            $ManagementRole = @{
                Name        = "Contoso Management Role"
                Parent      = "Journaling"
                Description = "This is the Contoso Management Role"
            }

            It "Should Reverse Engineer resource from the Export method when single" {
                Mock -CommandName Get-ManagementRole -MockWith {
                    return $ManagementRole
                }

                $exported = Export-TargetResource @testParams
                ([regex]::Matches($exported, " EXOManagementRole " )).Count | Should Be 1
                $exported.Contains("Journaling") | Should Be $true
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
