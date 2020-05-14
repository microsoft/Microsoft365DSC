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
    -DscResource "EXOPartnerApplication" -GenericStubModule $GenericStubPath
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
        Context -Name "Partner Application should exist. Partner Application is missing. Test should fail." -Fixture {
            $testParams = @{
                Name                                = "Contoso HRApp"
                ApplicationIdentifier               = "00000006-0000-0dd1-ac00-000000000000"
                AcceptSecurityIdentifierInformation = $false
                AccountType                         = "OrganizationalAccount"
                Enabled                             = $true
                Ensure                              = 'Present'
                GlobalAdminAccount                  = $GlobalAdminAccount
            }

            Mock -CommandName Get-PartnerApplication -MockWith {
                return @{
                    Name                                = "Contoso Different HRApp"
                    ApplicationIdentifier               = "00000006-0000-0dd1-ac00-000000000000"
                    AcceptSecurityIdentifierInformation = $false
                    AccountType                         = "OrganizationalAccount"
                    Enabled                             = $true
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-PartnerApplication -MockWith {
                return @{
                    Name                                = "Contoso HRApp"
                    ApplicationIdentifier               = "00000006-0000-0dd1-ac00-000000000000"
                    AcceptSecurityIdentifierInformation = $false
                    AccountType                         = "OrganizationalAccount"
                    Enabled                             = $true
                    Ensure                              = 'Present'
                    GlobalAdminAccount                  = $GlobalAdminAccount
                }
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }
        }

        Context -Name "Partner Application should exist. Partner Application exists. Test should pass." -Fixture {
            $testParams = @{
                Name                                = "Contoso HRApp"
                ApplicationIdentifier               = "00000006-0000-0dd1-ac00-000000000000"
                AcceptSecurityIdentifierInformation = $false
                AccountType                         = "OrganizationalAccount"
                Enabled                             = $true
                Ensure                              = 'Present'
                GlobalAdminAccount                  = $GlobalAdminAccount
            }

            Mock -CommandName Get-PartnerApplication -MockWith {
                return @{
                    Name                                = "Contoso HRApp"
                    ApplicationIdentifier               = "00000006-0000-0dd1-ac00-000000000000"
                    AcceptSecurityIdentifierInformation = $false
                    AccountType                         = "OrganizationalAccount"
                    Enabled                             = $true
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "Partner Application should exist. Partner Application exists, AccountType mismatch. Test should fail." -Fixture {
            $testParams = @{
                Name                                = "Contoso HRApp"
                ApplicationIdentifier               = "00000006-0000-0dd1-ac00-000000000000"
                AcceptSecurityIdentifierInformation = $false
                AccountType                         = "OrganizationalAccount"
                Enabled                             = $true
                Ensure                              = 'Present'
                GlobalAdminAccount                  = $GlobalAdminAccount
            }

            Mock -CommandName Get-PartnerApplication -MockWith {
                return @{
                    Name                                = "Contoso HRApp"
                    ApplicationIdentifier               = "00000006-0000-0dd1-ac00-000000000000"
                    AcceptSecurityIdentifierInformation = $false
                    AccountType                         = "ConsumerAccount"
                    Enabled                             = $true
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-PartnerApplication -MockWith {
                return @{
                    Name                                = "Contoso HRApp"
                    ApplicationIdentifier               = "00000006-0000-0dd1-ac00-000000000000"
                    AcceptSecurityIdentifierInformation = $false
                    AccountType                         = "OrganizationalAccount"
                    Enabled                             = $true
                    Ensure                              = 'Present'
                    GlobalAdminAccount                  = $GlobalAdminAccount
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

            $PartnerApplication = @{
                Name                                = "Contoso HRApp"
                ApplicationIdentifier               = "00000006-0000-0dd1-ac00-000000000000"
                AcceptSecurityIdentifierInformation = $false
                AccountType                         = "OrganizationalAccount"
                Enabled                             = $true
            }

            It "Should Reverse Engineer resource from the Export method when single" {
                Mock -CommandName Get-PartnerApplication -MockWith {
                    return $PartnerApplication
                }

                $exported = Export-TargetResource @testParams
                ([regex]::Matches($exported, " EXOPartnerApplication " )).Count | Should Be 1
                $exported.Contains("OrganizationalAccount") | Should Be $true
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
