[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath "..\..\Unit" `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath "\Stubs\Microsoft365.psm1" `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath "\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "O365Group" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }

        # Test contexts
        Context -Name "When the group doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = "Test Group"
                    MailNickName       = "TestGroup"
                    Description        = "This is a test"
                    ManagedBy          = "JohnSmith@contoso.onmicrosoft.com"
                    Ensure             = "Present"
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-AzureADGroup -MockWith {
                    return $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "Should create the Group from the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "When the group already exists" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = "Test Group"
                    MailNickName       = "TestGroup"
                    ManagedBy          = "Bob.Houle@contoso.onmicrosoft.com"
                    Description        = "This is a test"
                    Ensure             = "Present"
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-AzureADGroup -MockWith {
                    return @{
                        DisplayName  = "Test Group"
                        ObjectId     = "a53dbbd6-7e9b-4df9-841a-a2c3071a1770"
                        Members      = @("John.Smith@contoso.onmcirosoft.com")
                        MailNickName = "TestGroup"
                        Owners       = @("Bob.Houle@contoso.onmcirosoft.com")
                        Description  = "This is a test"
                    }
                }

                Mock -CommandName Get-AzureADGroupMember -MockWith {
                    return @{
                        UserPrincipalName = "John.smith@contoso.onmicrosoft.com"
                    }
                }

                Mock -CommandName Get-AzureADGroupOwner -MockWith {
                    return @{
                        UserPrincipalName = "Bob.Houle@contoso.onmicrosoft.com"
                    }
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -be $true
            }

            It "Should update the new Group in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Office 365 Group - When the group already exists but with different members" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName        = "Test Group"
                    MailNickName       = "TestGroup"
                    Description        = "This is a test"
                    Members            = @("GoodUser1", "GoodUser2")
                    ManagedBy          = @("JohnSmith@contoso.onmicrosoft.com", "Bob.Houle@contoso.onmicrosoft.com")
                    Ensure             = "Present"
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-UnifiedGroupLinks
                {
                    return (@{
                            LinkType = "Members"
                            Identity = "Test Group"
                            Name     = "GoodUser1"
                        },
                        @{
                            LinkType = "Members"
                            Identity = "Test Group"
                            Name     = "BadUser1"
                        },
                        @{
                            LinkType = "Members"
                            Identity = "Test Group"
                            Name     = "GoodUser2"
                        })
                }

                Mock -CommandName Get-AzureADGroup -MockWith {
                    return @{
                        DisplayName  = "Test Group"
                        MailNickName = "TestGroup"
                        Description  = "This is a test"
                        ObjectID     = "a53dbbd6-7e9b-4df9-841a-a2c3071a1770"
                    }
                }

                Mock -CommandName New-UnifiedGroup -MockWith {

                }

                Mock -CommandName Add-UnifiedGroupLinks -MockWith {

                }

                Mock -CommandName Remove-UnifiedGroupLinks -MockWith {

                }

                Mock -CommandName Get-AzureADGroupMember -MockWith {
                    return @(
                        @{
                            UserPrincipalName = "JohnSmith@contoso.onmicrosoft.com"
                        },
                        @{
                            UserPrincipalName = "SecondUser@contoso.onmicrosoft.com"
                        }
                    )
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -be $false
            }

            It "Should update the membership list in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-AzureADGroup -MockWith {
                    return @{
                        DisplayName  = "Test Group"
                        MailNickName = "TestGroup"
                        Description  = "This is a test"
                        ObjectID     = "a53dbbd6-7e9b-4df9-841a-a2c3071a1770"
                    }
                }

                Mock -CommandName Get-AzureADGroupMember -MockWith {
                    return @(
                        @{
                            UserPrincipalName = "JohnSmith@contoso.onmicrosoft.com"
                        },
                        @{
                            UserPrincipalName = "SecondUser@contoso.onmicrosoft.com"
                        }
                    )
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
