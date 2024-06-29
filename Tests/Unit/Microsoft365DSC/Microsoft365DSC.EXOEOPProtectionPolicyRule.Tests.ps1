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
    -DscResource "EXOEOPProtectionPolicyRule" -GenericStubModule $GenericStubPath
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

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Set-EOPProtectionPolicyRule -MockWith {
                return $null
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts

        Context -Name "The EXOEOPProtectionPolicyRule exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                    = 'Present'
                    Credential                = $Credential;
                    ExceptIfRecipientDomainIs = @("contoso.onmicrosoft.com");
                    Identity                  = "Strict Preset Security Policy";
                    Name                      = "Strict Preset Security Policy";
                    Priority                  = 0;
                    State                     = "Disabled";
                }

                Mock -CommandName Get-EOPProtectionPolicyRule -MockWith {
                    return @{
                    Identity                  = "Strict Preset Security Policy"
                    Name                      = "Strict Preset Security Policy"
                    ExceptIfRecipientDomainIs = @("contoso.onmicrosoft.com")
                    Comments                  = "FakeStringValue"
                    Priority                  = 0
                    State                     = "Enabled";
                    }
                }

                Mock -CommandName Disable-EOPProtectionPolicyRule -MockWith {
                    return $null
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
                Should -Invoke -CommandName Disable-EOPProtectionPolicyRule -Exactly 1
            }
        }
        Context -Name "The EXOEOPProtectionPolicyRule Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                    = 'Present'
                    Credential                = $Credential;
                    ExceptIfRecipientDomainIs = @("contoso.onmicrosoft.com");
                    Identity                  = "Strict Preset Security Policy";
                    Name                      = "Strict Preset Security Policy";
                    Priority                  = 0;
                    State                     = "Disabled";
                }

                Mock -CommandName Get-EOPProtectionPolicyRule -MockWith {
                    return @{
                    Identity                  = "Strict Preset Security Policy"
                    Name                      = "Strict Preset Security Policy"
                    ExceptIfRecipientDomainIs = @("contoso.onmicrosoft.com")
                    Comments                  = "FakeStringValue"
                    Priority                  = 0
                    State                     = "Disabled";
                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The EXOEOPProtectionPolicyRule exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                    = 'Present'
                    Credential                = $Credential;
                    ExceptIfRecipientDomainIs = @("contoso1.onmicrosoft.com");
                    Identity                  = "Strict Preset Security Policy 2";
                    Name                      = "Strict Preset Security Policy";
                    Priority                  = 0;
                    State                     = "Disabled";
                }

                Mock -CommandName Get-EOPProtectionPolicyRule -MockWith {
                    return @{
                    Identity                  = "Strict Preset Security Policy"
                    Name                      = "Strict Preset Security Policy"
                    ExceptIfRecipientDomainIs = @("contoso.onmicrosoft.com")
                    Comments                  = "FakeStringValue"
                    Priority                  = 0
                    State                     = "Disabled"
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
                Should -Invoke -CommandName Set-EOPProtectionPolicyRule -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-EOPProtectionPolicyRule -MockWith {
                    return @{
                        Identity                  = "Strict Preset Security Policy"
                        Name                      = "Strict Preset Security Policy"
                        ExceptIfRecipientDomainIs = @("contoso.onmicrosoft.com")
                        Comments                  = "FakeStringValue"
                        Priority                  = 0
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
