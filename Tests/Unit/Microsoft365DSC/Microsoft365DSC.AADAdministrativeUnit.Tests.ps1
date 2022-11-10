[CmdletBinding()]
param(
)
# adding BeforeAll to comply with Pester v5.x
BeforeAll {
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

    # *-MgAdministrativeUnit* cmdlets are only available in the beta profile
    Select-MgProfile -Name beta

    $Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
        -DscResource "AADAdministrativeUnit" -GenericStubModule $GenericStubPath
}
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)


            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }


            Mock -CommandName Invoke-MgGraphRequest -MockWith {

            }

            # Note: Only the Graph beta profile provides cmdlets xxx-MgAdministrativeUnit(xxx) that accommodate the preview AU membership feature

            Mock -CommandName Update-MgAdministrativeUnit -MockWith {

            }

            Mock -CommandName Remove-MgAdministrativeUnit -MockWith {

            }

            Mock -CommandName New-MgAdministrativeUnit -MockWith {

            }

            Mock -CommandName New-MgAdministrativeUnitMemberByRef -MockWith {

            }

            Mock -CommandName New-MgAdministrativeUnitScopedRoleMember -MockWith {

            }

            Mock -CommandName Remove-MgAdministrativeUnit -MockWith {

            }

            Mock -CommandName Remove-MgAdministrativeUnitMemberByRef -MockWith {

            }

            Mock -CommandName Remove-MgAdministrativeUnitScopedRoleMember -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                Select-MgProfile beta
                return "Credential"
            }
        }
        # Test contexts
        Context -Name "The AU should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        Description = "FakeStringValue1"
                        DisplayName = "FakeStringValue1"
                        Id = "FakeStringValue1"
                        Visibility = "Public"

                        Ensure                        = "Present"
                        Credential                    = $Credential;
                    }

                Mock -CommandName Get-MgAdministrativeUnit -MockWith {
                    return $null
                }
            }
            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the AU from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgAdministrativeUnit -Exactly 1
            }
        }

        Context -Name "The AU exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        Description = "FakeStringValue2"
                        DisplayName = "FakeStringValue2"
                        Id = "FakeStringValue2"

                        Ensure                        = "Absent"
                        Credential                    = $Credential;
                    }

                Mock -CommandName Get-MgAdministrativeUnit -MockWith {
                    return [pscustomobject]@{
                        Description = "FakeStringValue2"
                        DisplayName = "FakeStringValue2"
                        Id = "FakeStringValue2"
                    }
                }
                Mock -CommandName Get-MgAdministrativeUnitMember -MockWith {
                    return $null
                }
                Mock -CommandName Get-MgAdministrativeUnitScopedRoleMember -MockWith {
                    return $null
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the AU from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgAdministrativeUnit -Exactly 1
            }
        }
        Context -Name "The AU Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        Description = "DSCAU"
                        DisplayName = "DSCAU"
                        Id = "DSCAU"
                        Members =@(
                                    (New-CimInstance -ClassName MSFT_MicrosoftGraphdirectoryobject -Property @{
                                            Identity = "John.Doe@mytenant.com"
                                            Type     = "User"
                                        } -ClientOnly)
                                )
                        ScopedRoleMembers =@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphScopedRoleMembership -Property @{
                                        RoleName = "User Administrator"
                                        RoleMemberInfo = (New-CimInstance -ClassName MSFT_MicrosoftGraphIdentity -Property @{
                                            Identity = "John.Doe@mytenant.com"
                                            Type     = "User"
                                        } -ClientOnly)
                                    } -ClientOnly)
                            )
                        <#
                        Extensions =@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphExtension -Property @{
                                    Id = '0123456789'
                                    Properties = (New-CimInstance -ClassName MSFT_KeyValuePair -Property @{
                                        SomeAttribute = "somevalue"
                                    } -ClientOnly)
                                } -ClientOnly)
                            )
                        #>
                        Visibility = "Public"

                        Ensure                        = "Present";
                        Credential                    = $Credential;
                }

                Mock -CommandName Get-MgAdministrativeUnit -MockWith {
                    return [pscustomobject]@{
                        Description = "DSCAU"
                        DisplayName = "DSCAU"
                        Id = "DSCAU"
                        <#
                        Extensions =@(
                            [pscustomobject]@{
                                Id = '0123456789'
                                SomeAttribute = "somevalue"
                            }
                        )
                        #>
                        Members = @(
                            [pscustomobject]@{Id = "1234567890"}
                        )
                        ScopedRoleMembers = @(
                            [pscustomobject]@{
                                RoleId = '12345-67890'
                                RoleMemberInfo = @(
                                    [pscustomobject]@{
                                        DisplayName = "John Doe"
                                        Id          = "1234567890"
                                    }
                                )
                            }
                        )
                        Visibility = "Public"
                    }
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return [pscustomobject]@{
                        '@odata.type' = "#microsoft.graph.user"
                        DisplayName = "John Doe"
                        UserPrincipalName = "John.Doe@mytenant.com"
                        Id          = "1234567890"
                    }
                }

                Mock -CommandName Get-MgAdministrativeUnitMember -MockWith {
                    return [pscustomobject]{
                        Id = "1234567890"
                    }
                }

                Mock -CommandName Get-MgAdministrativeUnitScopedRoleMember -MockWith {
                    return [pscustomobject]@{
                        RoleId = '12345-67890'
                        RoleMemberINfo = [pscustomobject]@{
                            DisplayName = "John Doe"
                            Id          = "1234567890"
                        }
                    }
                }

                Mock -CommandName Get-MgDirectoryRole -MockWith {
                    return [pscustomobject]@{
                        Id = '12345-67890'
                        DisplayName = 'User Administrator'
                    }
                }

            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AU exists and values (Members) are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = "DSCAU2"
                    DisplayName = "DSCAU2"
                    <#
                    Extensions =@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphextension -Property @{
                            Id = '0123456789'
                            Properties = (New-CimInstance -ClassName MSFT_KeyValuePair -Property @{
                                SomeAttribute = "somevalue"
                            } -ClientOnly)
                        } -ClientOnly)
                    )
                    #>
                    Id = "DSCAU2"
                    Members =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdirectoryobject -Property @{
                                    Identity = "John.Doe@mytenant.com"
                                    Type     = "User"
                                } -ClientOnly)
                        )
                    ScopedRoleMembers =@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphScopedRoleMembership -Property @{
                                RoleName = "User Administrator"
                                RoleMemberInfo = (New-CimInstance -ClassName MSFT_MicrosoftGraphIdentity -Property @{
                                    Identity = "John.Doe@mytenant.com"
                                    Type     = "User"
                                } -ClientOnly)
                            } -ClientOnly)
                    )
                    Visibility = "Public"

                    Ensure                        = "Present";
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgAdministrativeUnit -MockWith {
                    return [pscustomobject]@{
                        Description = "DSCAU2"
                        DisplayName = "DSCAU2"
                        Id = "DSCAU2"
                        Visibility = "Public"
                        Members = $null
                        ScopedRoleMembers = @(
                            [pscustomobject]@{
                                RoleId = '12345-67890'
                                RoleMemberInfo = [pscustomobject]@(
                                    @{
                                        DisplayName = "John Doe"
                                        Id          = "1234567890"
                                    }
                                )
                            }
                        )
                        <#
                        Extensions =@(
                            [pscustomobject]@{
                                Id = "FakeExtensionIdentity"
                                SomeAttribute = "SomeValue"
                            }
                        )
                        #>
                        '@odata.type' = "#microsoft.graph.administrativeunit"

                    }
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return [pscustomobject]@{
                        Id                = "1234567890"
                        DisplayName       = "John Doe"
                        UserPrincipalName = "John.Doe@mytenant.com"
                    }
                }

                Mock -CommandName Get-MgAdministrativeUnitMember -MockWith {
                    return $null
                }

                Mock -CommandName Get-MgAdministrativeUnitScopedRoleMember -MockWith {
                    return [pscustomobject]@{
                        RoleId = '12345-67890'
                        RoleMemberInfo = [pscustomobject]@{
                            DisplayName = "John Doe"
                            Id          = "1234567890"
                        }
                    }
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return [pscustomobject]@{
                        '@odata.type' = "#microsoft.graph.user"
                        DisplayName       = "John Doe"
                        UserPrincipalName = "John.Doe@mytenant.com"
                        Id                = "1234567890"
                    }
                }

                Mock -CommandName Get-MgDirectoryRole -MockWith {
                    return [pscustomobject]@{
                        Id = '12345-67890'
                        DisplayName = 'User Administrator'
                    }
                }
           }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgAdministrativeUnitMemberByRef -Exactly 1
            }
        }

        Context -Name "The AU exists and values (ScopedRoleMembers) are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = "DSCAU"
                    DisplayName = "DSCAU"
                    Id = "DSCAU"
                    <#
                    Extensions =@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphextension -Property @{
                            Id = '0123456789'
                            Properties = (New-CimInstance -ClassName MSFT_KeyValuePair -Property @{
                                SomeAttribute = "somevalue"
                            } -ClientOnly)
                        } -ClientOnly)
                    )
                    #>
                    Members =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdirectoryobject -Property @{
                                    Identity = "John.Doe@mytenant.com"
                                    Type     = "User"
                                } -ClientOnly)
                        )
                    ScopedRoleMembers =@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphScopedRoleMembership -Property @{
                                RoleName = "User Administrator"
                                RoleMemberInfo = (New-CimInstance -ClassName MSFT_MicrosoftGraphIdentity -Property @{
                                    Identity = "John.Doe@mytenant.com"
                                    Type     = "User"
                                } -ClientOnly)
                            } -ClientOnly)
                    )
                    Visibility = "Public"
                    Ensure                        = "Present";
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgAdministrativeUnit -MockWith {
                    return [pscustomobject]@{
                        Description = "DSCAU"
                        DisplayName = "DSCAU"
                        Id = "DSCAU"
                        Visibility = "Public"
                        Members = @(
                            [pscustomobject]@{Id = '1234567890'}
                        )
                        ScopedRoleMembers = $null
                        <#
                        Extensions =@(
                            [pscustomobject]@{
                                Id = "FakeExtensionId"
                                SomeAttribute = "SomeValue"
                            }
                        )
                        #>
                        '@odata.type' = "#microsoft.graph."
                    }
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return [pscustomobject]@{
                        '@odata.type' = "#microsoft.graph.user"
                        DisplayName = "John Doe"
                        UserPrincipalName = "John.Doe@mytenant.com"
                        Id          = "1234567890"
                    }
                }

                Mock -CommandName Get-MgAdministrativeUnitMember -MockWith {
                    return [pscustomobject]@{
                        Id = "1234567890"
                    }
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return [pscustomobject]@{
                        Id                = "1234567890"
                        DisplayName       = "John Doe"
                        UserPrincipalName = "John.Doe@mytenant.com"
                    }
                }

                Mock -CommandName Get-MgAdministrativeUnitScopedRoleMember -MockWith {
                }


                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return [pscustomobject]@{
                        '@odata.type' = "#microsoft.graph.user"
                        DisplayName = "John Doe"
                        UserPrincipalName = "John.Doe@mytenant.com"
                        Id          = "1234567890"
                    }
                }

                Mock -CommandName Get-MgDirectoryRole -MockWith {
                    return [pscustomobject]@{
                        Id = '12345-67890'
                        DisplayName = 'User Administrator'
                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgAdministrativeUnitScopedRoleMember -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgAdministrativeUnit -MockWith {
                    return [pscustomobject]@{
                        Description = "ExportDSCAU"
                        DisplayName = "ExportDSCAU"
                        <#
                        Extensions =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphextension -Property @{
                            CIMType = "MSFT_MicrosoftGraphextension"
                            Name = "Extensions"
                            isArray = $True

                            } -ClientOnly)
                        )
                        #>
                        Id = "ExportDSCAU"
                        Members = @(
                            [pscustomobject]@{Id = "1234567890"}
                        )
                        ScopedRoleMembers = @(
                            [pscustomobject]@{
                                RoleId = '12345-67890'
                                RoleMemberInfo = [pscustomobject]@{
                                    DisplayName = "John Doe"
                                    Id          = "1234567890"
                                }
                            }
                        )
                        Visibility = "Public"

                    }
                }

                Mock -CommandName Get-MgAdministrativeUnitMember -MockWith {
                    return [pscustomobject]@{
                        Id = "1234567890"
                    }
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return [pscustomobject]@{
                        Id                = "1234567890"
                        DisplayName       = "John Doe"
                        UserPrincipalName = "John.Doe@mytenant.com"
                    }
                }

                Mock -CommandName Get-MgAdministrativeUnitScopedRoleMember -MockWith {
                    return [pscustomobject]@{
                        RoleId = '12345-67890'
                        RoleMemberInfo = [pscustomobject]@{
                            DisplayName = "John Doe"
                            Id          = "1234567890"
                        }
                    }
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return [pscustomobject]@{
                        '@odata.type' = "#microsoft.graph.user"
                        DisplayName = "John Doe"
                        UserPrincipalName = "John.Doe@mytenant.com"
                        Id          = "1234567890"
                    }
                }

                Mock -CommandName Get-MgDirectoryRole -MockWith {
                    return [pscustomobject]@{
                        Id = '12345-67890'
                        DisplayName = 'User Administrator'
                    }
                }
            }
            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
