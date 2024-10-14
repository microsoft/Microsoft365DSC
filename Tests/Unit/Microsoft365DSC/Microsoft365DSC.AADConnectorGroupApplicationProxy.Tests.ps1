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
    -DscResource "AADConnectorGroupApplicationProxy" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaOnPremisePublishingProfileConnectorGroup -MockWith {
            }

            Mock -CommandName New-MgBetaOnPremisePublishingProfileConnectorGroup -MockWith {
            }

            Mock -CommandName Remove-MgBetaOnPremisePublishingProfileConnectorGroup -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

<<<<<<<< HEAD:Tests/Unit/Microsoft365DSC/Microsoft365DSC.AADConnectorGroupApplicationProxy.Tests.ps1
            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
========
             # Mock Write-Host to hide output during the tests
             Mock -CommandName Write-Host -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementDerivedCredential -MockWith {
            }
            Mock -CommandName New-MgBetaDeviceManagementDerivedCredential -MockWith {
            }
            Mock -CommandName Remove-MgBetaDeviceManagementDerivedCredential -MockWith {
>>>>>>>> Dev:Tests/Unit/Microsoft365DSC/Microsoft365DSC.IntuneDerivedCredential.Tests.ps1
            }

            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
<<<<<<<< HEAD:Tests/Unit/Microsoft365DSC/Microsoft365DSC.AADConnectorGroupApplicationProxy.Tests.ps1
        Context -Name "The AADConnectorGroupApplicationProxy should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Id = "FakeStringValue"
                    Name = "FakeStringValue"
                    Region = "nam"
                    Ensure = "Present"
                    Credential = $Credential;
========
        Context -Name " 1. The instance should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure               = 'Present'
                    DisplayName          = "K5";
                    HelpUrl              = "http://www.ff.com/";
                    Id                   = "a409d85f-2a49-440d-884a-80fb52a557ab";
                    Issuer               = "purebred";
                    NotificationType     = "email";
                    Credential           = $Credential
>>>>>>>> Dev:Tests/Unit/Microsoft365DSC/Microsoft365DSC.IntuneDerivedCredential.Tests.ps1
                }

                Mock -CommandName Get-MgBetaOnPremisePublishingProfileConnectorGroup -MockWith {
                    return $null
                }
            }
            It ' 1.1 Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It ' 1.2 Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
<<<<<<<< HEAD:Tests/Unit/Microsoft365DSC/Microsoft365DSC.AADConnectorGroupApplicationProxy.Tests.ps1
            It 'Should Create the group from the Set method' {
========

            It ' 1.3 Should create a new instance from the Set method' {
>>>>>>>> Dev:Tests/Unit/Microsoft365DSC/Microsoft365DSC.IntuneDerivedCredential.Tests.ps1
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaOnPremisePublishingProfileConnectorGroup -Exactly 1
            }
        }

<<<<<<<< HEAD:Tests/Unit/Microsoft365DSC/Microsoft365DSC.AADConnectorGroupApplicationProxy.Tests.ps1
        Context -Name "The AADConnectorGroupApplicationProxy exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Id = "FakeStringValue"
                    Name = "FakeStringValue"
                    Region = "nam"
                    Ensure = "Absent"
                    Credential = $Credential;
========
        Context -Name " 2. The instance exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure               = 'Absent'
                    DisplayName          = "K5";
                    HelpUrl              = "http://www.ff.com/";
                    Id                   = "a409d85f-2a49-440d-884a-80fb52a557ab";
                    Issuer               = "purebred";
                    NotificationType     = "email";
                    Credential           = $Credential
>>>>>>>> Dev:Tests/Unit/Microsoft365DSC/Microsoft365DSC.IntuneDerivedCredential.Tests.ps1
                }

                Mock -CommandName Get-MgBetaOnPremisePublishingProfileConnectorGroup -MockWith {
                    return @{
<<<<<<<< HEAD:Tests/Unit/Microsoft365DSC/Microsoft365DSC.AADConnectorGroupApplicationProxy.Tests.ps1
                        Id = "FakeStringValue"
                        Name = "FakeStringValue"
                        Region = "nam"
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
========
                        DisplayName          = "K5";
                        HelpUrl              = "http://www.ff.com/";
                        Id                   = "a409d85f-2a49-440d-884a-80fb52a557ab";
                        Issuer               = "purebred";
                        NotificationType     = "email";
                    }
                }
            }
            It ' 2.1 Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It ' 2.2 Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It ' 2.3 Should remove the instance from the Set method' {
>>>>>>>> Dev:Tests/Unit/Microsoft365DSC/Microsoft365DSC.IntuneDerivedCredential.Tests.ps1
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaOnPremisePublishingProfileConnectorGroup -Exactly 1
            }
        }
<<<<<<<< HEAD:Tests/Unit/Microsoft365DSC/Microsoft365DSC.AADConnectorGroupApplicationProxy.Tests.ps1
        Context -Name "The AADConnectorGroupApplicationProxy Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Id = "FakeStringValue"
                    Name = "FakeStringValue"
                    Region = "nam"
                    Ensure = "Present"
                    Credential = $Credential;
========

        Context -Name " 3. The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure               = 'Present'
                    DisplayName          = "K5";
                    HelpUrl              = "http://www.ff.com/";
                    Id                   = "a409d85f-2a49-440d-884a-80fb52a557ab";
                    Issuer               = "purebred";
                    NotificationType     = "email";
                    Credential           = $Credential
>>>>>>>> Dev:Tests/Unit/Microsoft365DSC/Microsoft365DSC.IntuneDerivedCredential.Tests.ps1
                }

                Mock -CommandName Get-MgBetaOnPremisePublishingProfileConnectorGroup -MockWith {
                    return @{
<<<<<<<< HEAD:Tests/Unit/Microsoft365DSC/Microsoft365DSC.AADConnectorGroupApplicationProxy.Tests.ps1
                        Id = "FakeStringValue"
                        Name = "FakeStringValue"
                        Region = "nam"

========
                        Ensure               = 'Present'
                        DisplayName          = "K5";
                        HelpUrl              = "http://www.ff.com/";
                        Id                   = "a409d85f-2a49-440d-884a-80fb52a557ab";
                        Issuer               = "purebred";
                        NotificationType     = "email";
>>>>>>>> Dev:Tests/Unit/Microsoft365DSC/Microsoft365DSC.IntuneDerivedCredential.Tests.ps1
                    }
                }
            }

<<<<<<<< HEAD:Tests/Unit/Microsoft365DSC/Microsoft365DSC.AADConnectorGroupApplicationProxy.Tests.ps1

            It 'Should return true from the Test method' {
========
            It ' 3.0 Should return true from the Test method' {
>>>>>>>> Dev:Tests/Unit/Microsoft365DSC/Microsoft365DSC.IntuneDerivedCredential.Tests.ps1
                Test-TargetResource @testParams | Should -Be $true
            }
        }

<<<<<<<< HEAD:Tests/Unit/Microsoft365DSC/Microsoft365DSC.AADConnectorGroupApplicationProxy.Tests.ps1
        Context -Name "The AADConnectorGroupApplicationProxy exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Id = "FakeStringValue"
                    Name = "FakeStringValue"
                    Region = "nam"
                    Ensure = 'Present'
                    Credential = $Credential;
========
        Context -Name " 4. The instance exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure               = 'Present'
                    DisplayName          = "K5";
                    HelpUrl              = "http://www.ff.com/";
                    Id                   = "a409d85f-2a49-440d-884a-80fb52a557ab";
                    Issuer               = "purebred";
                    NotificationType     = "email";
                    Credential           = $Credential
>>>>>>>> Dev:Tests/Unit/Microsoft365DSC/Microsoft365DSC.IntuneDerivedCredential.Tests.ps1
                }

                Mock -CommandName Get-MgBetaOnPremisePublishingProfileConnectorGroup -MockWith {
                    return @{
<<<<<<<< HEAD:Tests/Unit/Microsoft365DSC/Microsoft365DSC.AADConnectorGroupApplicationProxy.Tests.ps1
                        Id = "FakeStringValue"
                        Name = "NewFakeStringValue"
                        Region = "nam"
========
                        DisplayName          = "K5 drift"; #drift
                        HelpUrl              = "http://www.ff.com/";
                        Id                   = "a409d85f-2a49-440d-884a-80fb52a557ab";
                        Issuer               = "purebred";
                        NotificationType     = "email";
>>>>>>>> Dev:Tests/Unit/Microsoft365DSC/Microsoft365DSC.IntuneDerivedCredential.Tests.ps1
                    }
                }
            }

            It ' 4.1 Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It ' 4.2 Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

<<<<<<<< HEAD:Tests/Unit/Microsoft365DSC/Microsoft365DSC.AADConnectorGroupApplicationProxy.Tests.ps1
            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaOnPremisePublishingProfileConnectorGroup -Exactly 1
            }
========
            # Update is not allowed on DerivedCredential resource so it should be called 0 times.
>>>>>>>> Dev:Tests/Unit/Microsoft365DSC/Microsoft365DSC.IntuneDerivedCredential.Tests.ps1
        }

        Context -Name ' 5. ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaOnPremisePublishingProfileConnectorGroup -MockWith {
                    return @{
<<<<<<<< HEAD:Tests/Unit/Microsoft365DSC/Microsoft365DSC.AADConnectorGroupApplicationProxy.Tests.ps1
                        Id = "FakeStringValue"
                        Name = "FakeStringValue"
                        Region = "nam"

========
                        DisplayName          = "K5";
                        HelpUrl              = "http://www.ff.com/";
                        Id                   = "a409d85f-2a49-440d-884a-80fb52a557ab";
                        Issuer               = "purebred";
                        NotificationType     = "email";
>>>>>>>> Dev:Tests/Unit/Microsoft365DSC/Microsoft365DSC.IntuneDerivedCredential.Tests.ps1
                    }
                }
            }
            It ' 5.0 Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
