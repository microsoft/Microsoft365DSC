[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
    -ChildPath '..\..\Unit' `
    -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Microsoft365.psm1' `
        -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Generic.psm1' `
        -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\UnitTestHelper.psm1' `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource 'O365Group' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "When the group doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName  = 'Test Group'
                    MailNickName = 'TestGroup'
                    Description  = 'This is a test'
                    ManagedBy    = 'JohnSmith@contoso.onmicrosoft.com'
                    Ensure       = 'Present'
                    Credential   = $Credential
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should create the Group from the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'When the group already exists' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName  = 'Test Group'
                    MailNickName = 'TestGroup'
                    ManagedBy    = 'Bob.Houle@contoso.onmicrosoft.com'
                    Description  = 'This is a test'
                    Ensure       = 'Present'
                    Credential   = $Credential
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        DisplayName  = 'Test Group'
                        Id           = 'a53dbbd6-7e9b-4df9-841a-a2c3071a1770'
                        Members      = @('John.Smith@contoso.onmcirosoft.com')
                        MailNickName = 'TestGroup'
                        Owners       = @('Bob.Houle@contoso.onmcirosoft.com')
                        Description  = 'This is a test'
                    }
                }

                Mock -CommandName Get-MgGroupMember -MockWith {
                    return @{
                        AdditionalProperties = @{
                            UserPrincipalName = 'John.smith@contoso.onmicrosoft.com'
                        }
                    }
                }

                Mock -CommandName Get-MgGroupOwner -MockWith {
                    return @{
                        AdditionalProperties = @{
                            UserPrincipalName = 'Bob.Houle@contoso.onmicrosoft.com'
                        }
                    }
                }
            }

            Mock -CommandName Get-MgUser -MockWith {
                return @{
                    Id = '12345-12345-12345-12345-12345'
                }
            }
            Mock -CommandName New-MgGroupOwnerByRef -MockWith {
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should update the new Group in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Office 365 Group - When the group already exists but with different members' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName  = 'Test Group'
                    MailNickName = 'TestGroup'
                    Description  = 'This is a test'
                    Members      = @('GoodUser1', 'GoodUser2')
                    ManagedBy    = @('JohnSmith@contoso.onmicrosoft.com', 'Bob.Houle@contoso.onmicrosoft.com')
                    Ensure       = 'Present'
                    Credential   = $Credential
                }

                Mock -CommandName Get-MgGroupMember
                {
                    return (@{
                            Identity = 'Test Group'
                            Name     = 'GoodUser1'
                        },
                        @{
                            LinkType = 'Members'
                            Identity = 'Test Group'
                            Name     = 'BadUser1'
                        },
                        @{
                            LinkType = 'Members'
                            Identity = 'Test Group'
                            Name     = 'GoodUser2'
                        })
                }

                Mock -CommandName Get-MgGroupOwner
                {
                    return @(@{
                            AdditionalProperties = @{
                                UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                            }
                        },
                        @{
                            AdditionalProperties = @{
                                UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                            }
                        })
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        Id = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName New-MgGroupOwnerByRef -MockWith {

                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        DisplayName  = 'Test Group'
                        MailNickName = 'TestGroup'
                        Description  = 'This is a test'
                        ID           = 'a53dbbd6-7e9b-4df9-841a-a2c3071a1770'
                    }
                }

                Mock -CommandName New-MgGroup -MockWith {

                }

                Mock -CommandName New-MgGroupMember -MockWith {

                }

                Mock -CommandName New-MgGroupMember -MockWith {

                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {

                }

                Mock -CommandName Get-MgGroupMember -MockWith {
                    return @(
                        @{
                            AdditionalProperties = @{
                                UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                            }
                        },
                        @{
                            AdditionalProperties = @{
                                UserPrincipalName = 'SecondUser@contoso.onmicrosoft.com'
                            }
                        }
                    )
                }

                Mock -CommandName Get-MgGroupOwner -MockWith {
                    return @{
                        AdditionalProperties = @{
                            UserPrincipalName = 'Bob.Houle@contoso.onmicrosoft.com'
                        }
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the membership list in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        DisplayName  = 'Test Group'
                        MailNickName = 'TestGroup'
                        Description  = 'This is a test'
                        ID           = 'a53dbbd6-7e9b-4df9-841a-a2c3071a1770'
                    }
                }

                Mock -CommandName Get-MgGroupMember -MockWith {
                    return @(
                        @{
                            AdditionalProperties = @{
                                UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                            }
                        },
                        @{
                            AdditionalProperties = @{
                                UserPrincipalName = 'SecondUser@contoso.onmicrosoft.com'
                            }
                        }
                    )
                }

                Mock -CommandName Get-MgGroupOwner -MockWith {
                    return @{
                        AdditionalProperties = @{
                            UserPrincipalName = 'Bob.Houle@contoso.onmicrosoft.com'
                        }
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
