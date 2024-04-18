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
    -DscResource 'TeamsAppSetupPolicy' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'f@kepassword1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Set-CsTeamsAppSetupPolicy -MockWith {
            }

            Mock -CommandName New-CsTeamsAppSetupPolicy -MockWith {
            }

            Mock -CommandName Remove-CsTeamsAppSetupPolicy -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            $fakeAssembly = @"
                namespace Microsoft.Teams.Policy.Administration.Cmdlets.Core
                {
                    public class AppPreset
                    {
                        public AppPreset(string appInstance)
                        {}
                    }

                    public class PinnedApp
                    {
                        public PinnedApp(string appInstance, int order)
                        {}
                    }
                }
"@
            try
            {
                Add-Type -TypeDefinition $fakeAssembly -ErrorAction SilentlyContinue
            }
            catch
            {

            }
        }

        # Test contexts
        Context -Name 'The policy should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowSideLoading     = $True;
                    AllowUserPinning     = $True;
                    AppPresetList        = "com.microsoft.teamspace.tab.vsts";
                    Credential           = $Credential;
                    Description          = "My Description";
                    Ensure               = "Present";
                    Identity             = "Test";
                    PinnedAppBarApps     = @("14d6962d-6eeb-4f48-8890-de55454bb136","86fcd49b-61a2-4701-b771-54728cd291fb","2a84919f-59d8-4441-a975-2a8c2643b741","ef56c0de-36fc-4ef8-b417-3d82ba9d073c","20c3440d-c67e-4420-9f80-0e50c39693df","5af6a76b-40fc-4ba1-af29-8f49b08e44fd");
                }

                Mock -CommandName Get-CsTeamsAppSetupPolicy -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-CsTeamsAppSetupPolicy -Exactly 1
            }
        }

        Context -Name 'The policy exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowSideLoading     = $True;
                    AllowUserPinning     = $True;
                    AppPresetList        = "com.microsoft.teamspace.tab.vsts";
                    Credential           = $Credential;
                    Description          = "My Description";
                    Ensure               = "Absent";
                    Identity             = "Test";
                    PinnedAppBarApps     = @("14d6962d-6eeb-4f48-8890-de55454bb136","86fcd49b-61a2-4701-b771-54728cd291fb");
                }

                Mock -CommandName Get-CsTeamsAppSetupPolicy -MockWith {
                    return @{
                        AllowSideLoading     = $True;
                        AllowUserPinning     = $True;
                        AppPresetList        = @(
                            @{
                                Id = "com.microsoft.teamspace.tab.vsts"
                            }
                        );
                        Description          = "My Description";
                        Identity             = "Test";
                        PinnedAppBarApps     = @(
                            @{
                                Id = "14d6962d-6eeb-4f48-8890-de55454bb136"
                                Order = 1
                            },
                            @{
                                Id = "86fcd49b-61a2-4701-b771-54728cd291fb"
                                Order = 2
                            }
                        )
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-CsTeamsAppSetupPolicy -Exactly 1
            }
        }

        Context -Name 'The policy Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowSideLoading     = $True;
                    AllowUserPinning     = $True;
                    AppPresetList        = "com.microsoft.teamspace.tab.vsts";
                    Credential           = $Credential;
                    Description          = "My Description";
                    Ensure               = "Present";
                    Identity             = "Test";
                    PinnedAppBarApps     = @("14d6962d-6eeb-4f48-8890-de55454bb136","86fcd49b-61a2-4701-b771-54728cd291fb");
                }

                Mock -CommandName Get-CsTeamsAppSetupPolicy -MockWith {
                    return @{
                        AllowSideLoading     = $True;
                        AllowUserPinning     = $True;
                        AppPresetList        = @(
                            @{
                                Id = "com.microsoft.teamspace.tab.vsts"
                            }
                        );
                        Description          = "My Description";
                        Identity             = "Test";
                        PinnedAppBarApps     = @(
                            @{
                                Id = "14d6962d-6eeb-4f48-8890-de55454bb136"
                                Order = 1
                            },
                            @{
                                Id = "86fcd49b-61a2-4701-b771-54728cd291fb"
                                Order = 2
                            }
                        )
                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The policy exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowSideLoading     = $True;
                    AllowUserPinning     = $True;
                    AppPresetList        = "com.microsoft.teamspace.tab.vsts";
                    Credential           = $Credential;
                    Description          = "My Description";
                    Ensure               = "Present";
                    Identity             = "Test";
                    PinnedAppBarApps     = @("14d6962d-6eeb-4f48-8890-de55454bb136","86fcd49b-61a2-4701-b771-54728cd291fb");
                }

                Mock -CommandName Get-CsTeamsAppSetupPolicy -MockWith {
                    return @{
                        AllowSideLoading     = $True;
                        AllowUserPinning     = $True;
                        AppPresetList        = @(
                            @{
                                Id = "com.microsoft.fake.app" #drift
                            }
                        );
                        Description          = "My Description";
                        Identity             = "Test";
                        PinnedAppBarApps     = @(
                            @{
                                Id = "14d6962d-6eeb-4f48-8890-de55454bb136"
                                Order = 1
                            },
                            @{
                                Id = "86fcd49b-61a2-4701-b771-54728cd291fb"
                                Order = 2
                            }
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

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsTeamsAppSetupPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-CsTeamsAppSetupPolicy -MockWith {
                    return @{
                        AllowSideLoading     = $True;
                        AllowUserPinning     = $True;
                        AppPresetList        = @(
                            @{
                                Id = "com.microsoft.teamspace.tab.vsts"
                            }
                        );
                        Description          = "My Description";
                        Identity             = "Test";
                        PinnedAppBarApps     = @(
                            @{
                                Id = "14d6962d-6eeb-4f48-8890-de55454bb136"
                                Order = 1
                            },
                            @{
                                Id = "86fcd49b-61a2-4701-b771-54728cd291fb"
                                Order = 2
                            }
                        )
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
