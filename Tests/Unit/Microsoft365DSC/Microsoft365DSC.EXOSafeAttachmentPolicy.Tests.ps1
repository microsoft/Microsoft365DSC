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
    -DscResource "EXOSafeAttachmentPolicy" -GenericStubModule $GenericStubPath
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

        Mock -CommandName New-SafeAttachmentPolicy -MockWith {
            return @{

            }
        }

        Mock -CommandName Set-SafeAttachmentPolicy -MockWith {
            return @{

            }
        }

        # Test contexts
        Context -Name "SafeAttachmentPolicy creation." -Fixture {
            $testParams = @{
                Ensure             = 'Present'
                Identity           = 'TestSafeAttachmentPolicy'
                GlobalAdminAccount = $GlobalAdminAccount
                AdminDisplayName   = 'Test Safe Attachment Policy'
                Action             = 'Block'
                Enable             = $true
                Redirect           = $true
                RedirectAddress    = 'test@contoso.com'
            }

            Mock -CommandName Get-SafeAttachmentPolicy -MockWith {
                return @{
                    Identity = 'SomeOtherPolicy'
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "SafeAttachmentPolicy update not required." -Fixture {
            $testParams = @{
                Ensure             = 'Present'
                Identity           = 'TestSafeAttachmentPolicy'
                GlobalAdminAccount = $GlobalAdminAccount
                AdminDisplayName   = 'Test Safe Attachment Policy'
                Action             = 'Block'
                Enable             = $true
                Redirect           = $true
                RedirectAddress    = 'test@contoso.com'
            }

            Mock -CommandName Get-SafeAttachmentPolicy -MockWith {
                return @{
                    Ensure             = 'Present'
                    Identity           = 'TestSafeAttachmentPolicy'
                    GlobalAdminAccount = $GlobalAdminAccount
                    AdminDisplayName   = 'Test Safe Attachment Policy'
                    Action             = 'Block'
                    Enable             = $true
                    Redirect           = $true
                    RedirectAddress    = 'test@contoso.com'
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "SafeAttachmentPolicy update needed." -Fixture {
            $testParams = @{
                Ensure             = 'Present'
                Identity           = 'TestSafeAttachmentPolicy'
                GlobalAdminAccount = $GlobalAdminAccount
                AdminDisplayName   = 'Test Safe Attachment Policy'
                Action             = 'Block'
                Enable             = $true
                Redirect           = $true
                RedirectAddress    = 'test@contoso.com'
            }

            Mock -CommandName Get-SafeAttachmentPolicy -MockWith {
                return @{
                    Ensure             = 'Present'
                    Identity           = 'TestSafeAttachmentPolicy'
                    GlobalAdminAccount = $GlobalAdminAccount
                    AdminDisplayName   = 'Test Safe Attachment Policy'
                    Action             = 'Block'
                    Enable             = $false
                    Redirect           = $false
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-SafeAttachmentPolicy -MockWith {
                return @{

                }
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "SafeAttachmentPolicy removal." -Fixture {
            $testParams = @{
                Ensure             = 'Absent'
                Identity           = 'TestSafeAttachmentPolicy'
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-SafeAttachmentPolicy -MockWith {
                return @{
                    Identity = 'TestSafeAttachmentPolicy'
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Remove-SafeAttachmentPolicy -MockWith {
                return @{

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

            Mock -CommandName Get-SafeAttachmentPolicy -MockWith {
                return @{
                    Identity = 'TestSafeAttachmentPolicy'
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
