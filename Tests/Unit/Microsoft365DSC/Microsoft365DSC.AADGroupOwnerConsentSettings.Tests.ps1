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
    -DscResource "AADGroupOwnerConsentSettings" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "f@kepassword1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Get-MgGroupSettingTemplateGroupSettingTemplate -MockWith {
            }

            Mock -CommandName Get-MgGroupSettingTemplateGroupSettingTemplate -ParameterFilter {$GroupSettingTemplateId -eq 'dffd5d46-495d-40a9-8e21-954ff55e198a'} -MockWith {
                return @{
                    DisplayName = 'Consent Policy Settings'
                    Id          = 'dffd5d46-495d-40a9-8e21-954ff55e198a'
                    Values      = @(
                        [pscustomobject]@{Name='EnableGroupSpecificConsent';DefaultValue=$null},
                        [pscustomobject]@{Name='BlockUserConsentForRiskyApps';DefaultValue=$true},
                        [pscustomobject]@{Name='EnableAdminConsentRequests';DefaultValue=$false},
                        [pscustomobject]@{Name='ConstrainGroupSpecificConsentToMembersOfGroupId';DefaultValue=$null}
                    )
                }
            }

            Mock -CommandName Get-MgGroupSetting -MockWith {
            }

            Mock -CommandName Get-MgGroup -MockWith {
            }

            Mock -CommandName Update-MgGroupSetting -MockWith {
            }

            Mock -CommandName New-MgGroupSetting -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            #Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }
        # Test contexts
        Context -Name "The AADGroupOwnerConsentSettings should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                                  = "Yes"
                    EnableGroupSpecificConsent                        = $false
                    BlockUserConsentForRiskyApps                      = $true
                    EnableAdminConsentRequests                        = $false
                    ConstrainGroupSpecificConsentToMembersOfGroupName = ''      # value is only relevant if EnableGroupSpecificConsent is true. See example 2
                    Ensure                                            = "Present"
                    Credential                                        = $Credential;
                }

                Mock -CommandName Get-MgGroupSetting -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgGroupSetting -Exactly 1
            }
        }

        Context -Name "The AADGroupOwnerConsentSettings Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                                  = "Yes"
                    EnableGroupSpecificConsent                        = $false
                    BlockUserConsentForRiskyApps                      = $true
                    EnableAdminConsentRequests                        = $false
                    ConstrainGroupSpecificConsentToMembersOfGroupName = ''      # value is only relevant if EnableGroupSpecificConsent is true. See example 2
                    Ensure                                            = "Present"
                    Credential                                        = $Credential;
                }

                Mock -CommandName Get-MgGroupSetting -ParameterFilter {$GroupSettingId -eq 'dffd5d46-495d-40a9-8e21-954ff55e198a'} -MockWith {
                    return @{
                        DisplayName = 'Consent Policy Settings'
                        Id          = 'dffd5d46-495d-40a9-8e21-954ff55e198a'
                        Values      = @(
                            [pscustomobject]@{Name='EnableGroupSpecificConsent';Value=$false},
                            [pscustomobject]@{Name='BlockUserConsentForRiskyApps';Value=$true},
                            [pscustomobject]@{Name='EnableAdminConsentRequests';Value=$false},
                            [pscustomobject]@{Name='ConstrainGroupSpecificConsentToMembersOfGroupId';Value=$null}
                        )
                    }
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADGroupOwnerConsentSettings Exists with a constrain-group and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                                  = "Yes"
                    EnableGroupSpecificConsent                        = $true
                    BlockUserConsentForRiskyApps                      = $true
                    EnableAdminConsentRequests                        = $false
                    ConstrainGroupSpecificConsentToMembersOfGroupName = 'Fake Group'      # value is only relevant if EnableGroupSpecificConsent is true. See example 2
                    Ensure = "Present"
                    Credential = $Credential;
                }
                Mock -CommandName Get-MgGroupSetting -ParameterFilter {$GroupSettingId -eq 'dffd5d46-495d-40a9-8e21-954ff55e198a'} -MockWith {
                    return @{
                        DisplayName = 'Consent Policy Settings'
                        Id          = 'dffd5d46-495d-40a9-8e21-954ff55e198a'
                        Values      = @(
                            [pscustomobject]@{Name='EnableGroupSpecificConsent';Value=$true},
                            [pscustomobject]@{Name='BlockUserConsentForRiskyApps';Value=$true},
                            [pscustomobject]@{Name='EnableAdminConsentRequests';Value=$false},
                            [pscustomobject]@{Name='ConstrainGroupSpecificConsentToMembersOfGroupId';Value='111-111111-1111-1111-111111'}
                        )
                    }
                }

                Mock -CommandName Get-MgGroup -Mockwith {
                    return [pscustomobject]@{
                        DisplayName     = 'Fake Group'
                        Id              = '111-111111-1111-1111-111111'
                        SecurityEnabled = $true
                    }
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADGroupOwnerConsentSettings Exists and Values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                                  = "Yes"
                    EnableGroupSpecificConsent                        = $false
                    BlockUserConsentForRiskyApps                      = $true
                    EnableAdminConsentRequests                        = $true
                    ConstrainGroupSpecificConsentToMembersOfGroupName = ''      # value is only relevant if EnableGroupSpecificConsent is true. See example 2
                    Ensure                                            = 'Present'
                    Credential                                        = $Credential;
                }

                Mock -CommandName Get-MgGroupSetting -ParameterFilter {$GroupSettingId -eq 'dffd5d46-495d-40a9-8e21-954ff55e198a'} -MockWith {
                    return @{
                        DisplayName = 'Consent Policy Settings'
                        Id          = 'dffd5d46-495d-40a9-8e21-954ff55e198a'
                        Values      = @(
                            [pscustomobject]@{Name='EnableGroupSpecificConsent';Value=$false},
                            [pscustomobject]@{Name='BlockUserConsentForRiskyApps';Value=$true},
                            [pscustomobject]@{Name='EnableAdminConsentRequests';Value=$false},
                            [pscustomobject]@{Name='ConstrainGroupSpecificConsentToMembersOfGroupId';Value=$null}
                        )
                    }
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Update the GroupSetting from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgGroupSetting -Exactly 1
            }
        }

        Context -Name "The AADGroupOwnerConsentSettings Exists with a constrain-group and Values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                                  = "Yes"
                    EnableGroupSpecificConsent                        = $true
                    BlockUserConsentForRiskyApps                      = $true
                    EnableAdminConsentRequests                        = $false
                    ConstrainGroupSpecificConsentToMembersOfGroupName = 'Another Fake Group'      # value is only relevant if EnableGroupSpecificConsent is true. See example 2
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgGroupSetting -ParameterFilter {$GroupSettingId -eq 'dffd5d46-495d-40a9-8e21-954ff55e198a'} -MockWith {
                    return @{
                        DisplayName = 'Consent Policy Settings'
                        Id          = 'dffd5d46-495d-40a9-8e21-954ff55e198a'
                        Values      = @(
                            [pscustomobject]@{Name='EnableGroupSpecificConsent';Value=$true},
                            [pscustomobject]@{Name='BlockUserConsentForRiskyApps';Value=$true},
                            [pscustomobject]@{Name='EnableAdminConsentRequests';Value=$false},
                            [pscustomobject]@{Name='ConstrainGroupSpecificConsentToMembersOfGroupId';Value='111-111111-1111-1111-111111'}
                        )
                    }
                }

                Mock -CommandName Get-MgGroup -ParameterFilter {$GroupId -eq '111-111111-1111-1111-111111'} -Mockwith {
                    return [pscustomobject]@{
                        DisplayName     = 'Fake Group'
                        Id              = '111-111111-1111-1111-111111'
                        SecurityEnabled = $true
                    }
                }
                <#
                Mock -CommandName Get-MgGroup -ParameterFilter {$Filter -eq "DisplayName eq 'Fake Group'"} -Mockwith {
                    return [pscustomobject]@{
                        DisplayName     = 'Fake Group'
                        Id              = '111-111111-1111-1111-111111'
                        SecurityEnabled = $true
                    }
                }
                #>
                Mock -CommandName Get-MgGroup -ParameterFilter {$Filter -eq "DisplayName eq 'Another Fake Group'"} -Mockwith {
                    return [pscustomobject]@{
                        DisplayName     = 'Another Fake Group'
                        Id              = '222-111111-2222-2222-111111'
                        SecurityEnabled = $true
                    }
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                Should -Invoke -CommandName Get-MgGroupSetting -Exactly 1
                Should -Invoke -CommandName Get-MgGroup -Exactly 1
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Update the GroupSetting from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Get-MgGroup -Exactly 2 # 1st for Get-TargetResource (pre-existing value), 2nd for Set-TargetResource (new value)
                Should -Invoke -CommandName Update-MgGroupSetting -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }
                Mock -CommandName Get-MgGroupSetting -ParameterFilter {$GroupSettingId -eq 'dffd5d46-495d-40a9-8e21-954ff55e198a'} -MockWith {
                    return @{
                        DisplayName = 'Consent Policy Settings'
                        Id          = 'dffd5d46-495d-40a9-8e21-954ff55e198a'
                        Values      = @(
                            [pscustomobject]@{Name='EnableGroupSpecificConsent';Value=$true},
                            [pscustomobject]@{Name='BlockUserConsentForRiskyApps';Value=$true},
                            [pscustomobject]@{Name='EnableAdminConsentRequests';Value=$false},
                            [pscustomobject]@{Name='ConstrainGroupSpecificConsentToMembersOfGroupId';Value='111-111111-1111-1111-111111'}
                        )
                    }
                }
                Mock -CommandName Get-MgGroup -ParameterFilter {$GroupId -eq '111-111111-1111-1111-111111'} -MockWith {
                    return [pscustomobject]@{
                        Id              = '111-111111-1111-1111-111111'
                        DisplayName     = 'Fake Export Group'
                        SecurityEnabled = $true
                    }
                }
            }
            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                Should -Invoke -CommandName Get-MgGroupSetting -Exactly 1
                Should -Invoke -CommandName Get-MgGroup -Exactly 1
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
