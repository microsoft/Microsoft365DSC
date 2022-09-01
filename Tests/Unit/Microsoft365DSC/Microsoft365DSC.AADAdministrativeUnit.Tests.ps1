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
    -DscResource "AADAdministrativeUnit" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Update-MgDirectoryAdministrativeUnit -MockWith {
            }

            Mock -CommandName New-MgDirectoryAdministrativeUnit -MockWith {
            }

            Mock -CommandName Remove-MgDirectoryAdministrativeUnit -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }
        # Test contexts
        Context -Name "The AADAdministrativeUnit should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Extensions =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphextension -Property @{
                            CIMType = "MSFT_MicrosoftGraphextension"
                            Name = "Extensions"
                            isArray = $True

                            } -ClientOnly)
                        )
                        Id = "FakeStringValue"
                        Members =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdirectoryobject -Property @{
                            CIMType = "MSFT_MicrosoftGraphdirectoryobject"
                            Name = "Members"
                            isArray = $True

                            } -ClientOnly)
                        )
                        ScopedRoleMembers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphscopedrolemembership -Property @{
                            CIMType = "MSFT_MicrosoftGraphscopedrolemembership"
                            Name = "ScopedRoleMembers"
                            isArray = $True

                            } -ClientOnly)
                        )
                        Visibility = "FakeStringValue"

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDirectoryAdministrativeUnit -MockWith {
                    return $null
                }
            }
            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgDirectoryAdministrativeUnit -Exactly 1
            }
        }

        Context -Name "The AADAdministrativeUnit exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Extensions =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphextension -Property @{
                            CIMType = "MSFT_MicrosoftGraphextension"
                            Name = "Extensions"
                            isArray = $True

                            } -ClientOnly)
                        )
                        Id = "FakeStringValue"
                        Members =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdirectoryobject -Property @{
                            CIMType = "MSFT_MicrosoftGraphdirectoryobject"
                            Name = "Members"
                            isArray = $True

                            } -ClientOnly)
                        )
                        ScopedRoleMembers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphscopedrolemembership -Property @{
                            CIMType = "MSFT_MicrosoftGraphscopedrolemembership"
                            Name = "ScopedRoleMembers"
                            isArray = $True

                            } -ClientOnly)
                        )
                        Visibility = "FakeStringValue"

                    Ensure                        = "Absent"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDirectoryAdministrativeUnit -MockWith {
                    return @{
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Extensions =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphextension -Property @{
                            CIMType = "MSFT_MicrosoftGraphextension"
                            Name = "Extensions"
                            isArray = $True

                            } -ClientOnly)
                        )
                        Id = "FakeStringValue"
                        Members =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdirectoryobject -Property @{
                            CIMType = "MSFT_MicrosoftGraphdirectoryobject"
                            Name = "Members"
                            isArray = $True

                            } -ClientOnly)
                        )
                        ScopedRoleMembers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphscopedrolemembership -Property @{
                            CIMType = "MSFT_MicrosoftGraphscopedrolemembership"
                            Name = "ScopedRoleMembers"
                            isArray = $True

                            } -ClientOnly)
                        )
                        Visibility = "FakeStringValue"

                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgDirectoryAdministrativeUnit -Exactly 1
            }
        }
        Context -Name "The AADAdministrativeUnit Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Extensions =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphextension -Property @{
                            CIMType = "MSFT_MicrosoftGraphextension"
                            Name = "Extensions"
                            isArray = $True

                            } -ClientOnly)
                        )
                        Id = "FakeStringValue"
                        Members =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdirectoryobject -Property @{
                            CIMType = "MSFT_MicrosoftGraphdirectoryobject"
                            Name = "Members"
                            isArray = $True

                            } -ClientOnly)
                        )
                        ScopedRoleMembers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphscopedrolemembership -Property @{
                            CIMType = "MSFT_MicrosoftGraphscopedrolemembership"
                            Name = "ScopedRoleMembers"
                            isArray = $True

                            } -ClientOnly)
                        )
                        Visibility = "FakeStringValue"

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDirectoryAdministrativeUnit -MockWith {
                    return @{
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Extensions =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphextension -Property @{
                            CIMType = "MSFT_MicrosoftGraphextension"
                            Name = "Extensions"
                            isArray = $True

                            } -ClientOnly)
                        )
                        Id = "FakeStringValue"
                        Members =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdirectoryobject -Property @{
                            CIMType = "MSFT_MicrosoftGraphdirectoryobject"
                            Name = "Members"
                            isArray = $True

                            } -ClientOnly)
                        )
                        ScopedRoleMembers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphscopedrolemembership -Property @{
                            CIMType = "MSFT_MicrosoftGraphscopedrolemembership"
                            Name = "ScopedRoleMembers"
                            isArray = $True

                            } -ClientOnly)
                        )
                        Visibility = "FakeStringValue"

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADAdministrativeUnit exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Extensions =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphextension -Property @{
                            CIMType = "MSFT_MicrosoftGraphextension"
                            Name = "Extensions"
                            isArray = $True

                            } -ClientOnly)
                        )
                        Id = "FakeStringValue"
                        Members =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdirectoryobject -Property @{
                            CIMType = "MSFT_MicrosoftGraphdirectoryobject"
                            Name = "Members"
                            isArray = $True

                            } -ClientOnly)
                        )
                        ScopedRoleMembers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphscopedrolemembership -Property @{
                            CIMType = "MSFT_MicrosoftGraphscopedrolemembership"
                            Name = "ScopedRoleMembers"
                            isArray = $True

                            } -ClientOnly)
                        )
                        Visibility = "FakeStringValue"

                    Ensure                = "Present"
                    Credential            = $Credential;
                }

                Mock -CommandName Get-MgDirectoryAdministrativeUnit -MockWith {
                    return @{
                        AdditionalProperties =@{
                            Visibility = "FakeStringValue"
                            ScopedRoleMembers =@(
                                @{
                                isArray = $True
                                Name = "ScopedRoleMembers"

                                }
                            )
                            Members =@(
                                @{
                                isArray = $True
                                Name = "Members"

                                }
                            )
                            Extensions =@(
                                @{
                                isArray = $True
                                Name = "Extensions"

                                }
                            )
                            '@odata.type' = "#microsoft.graph."

                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"

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
                Should -Invoke -CommandName Update-MgDirectoryAdministrativeUnit -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDirectoryAdministrativeUnit -MockWith {
                    return @{
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Extensions =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphextension -Property @{
                            CIMType = "MSFT_MicrosoftGraphextension"
                            Name = "Extensions"
                            isArray = $True

                            } -ClientOnly)
                        )
                        Id = "FakeStringValue"
                        Members =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdirectoryobject -Property @{
                            CIMType = "MSFT_MicrosoftGraphdirectoryobject"
                            Name = "Members"
                            isArray = $True

                            } -ClientOnly)
                        )
                        ScopedRoleMembers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphscopedrolemembership -Property @{
                            CIMType = "MSFT_MicrosoftGraphscopedrolemembership"
                            Name = "ScopedRoleMembers"
                            isArray = $True

                            } -ClientOnly)
                        )
                        Visibility = "FakeStringValue"

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
