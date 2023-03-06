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
    -DscResource 'SCProtectionAlert' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Import-PSSession -MockWith {
            }

            Mock -CommandName New-PSSession -MockWith {
            }

            Mock -CommandName Remove-ProtectionAlert -MockWith {
                return @{

                }
            }

            Mock -CommandName New-ProtectionAlert -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-ProtectionAlert -MockWith {
                return @{

                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name "Protection Alert doesn't exist but should exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    AggregationType         = "None";
                    Category                = "ThreatManagement";
                    Comment                 = "User has been detected as sending suspicious messages outside the organization and will be restricted if this activity continues. -V1.0.0.1";
                    Credential              = $Credential
                    Ensure                  = "Present";
                    Name                    = "Suspicious email sending patterns detected";
                    NotificationEnabled     = $True;
                    NotifyUser              = @("test.alert@contoso.onmicrosoft.com");
                    NotifyUserOnFilterMatch = $False;
                    Operation               = @("CompromisedWarningAccount");
                    Severity                = "Medium";
                    ThreatType              = "Activity";
                }

                Mock -CommandName Get-ProtectionAlert -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-ProtectionAlert -Exactly 1
            }
        }


        Context -Name 'Protection Alert alert exists but with wrong parameters' -Fixture {
            BeforeAll {
                $testParams = @{
                    AggregationType         = "None";
                    Category                = "ThreatManagement";
                    Comment                 = "User has been detected as sending suspicious messages outside the organization and will be restricted if this activity continues. -V1.0.0.1";
                    Credential              = $Credential
                    Ensure                  = "Present";
                    Name                    = "Suspicious email sending patterns detected";
                    NotificationEnabled     = $True;
                    NotifyUser              = @("test.alert@contoso.onmicrosoft.com");
                    NotifyUserOnFilterMatch = $False;
                    Operation               = @("CompromisedWarningAccount");
                    Severity                = "Medium";
                    ThreatType              = "Activity";
                }

                Mock -CommandName Get-ProtectionAlert -MockWith {
                    return @{
                        AggregationType         = "None";
                        Category                = "ThreatManagement";
                        Comment                 = "Other Comment";
                        Name                    = "Suspicious email sending patterns detected";
                        NotificationEnabled     = $False;
                        NotifyUser              = @("other.alert@contoso.onmicrosoft.com");
                        NotifyUserOnFilterMatch = $False;
                        Operation               = @("CompromisedWarningAccount");
                        Severity                = "Medium";
                        ThreatType              = "Activity";
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $False
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-ProtectionAlert -Exactly 1
            }
        }

        Context -Name 'Protection Alert exists but should not exist' -Fixture {
            BeforeAll {
                $testParams = @{
                    AggregationType         = "None";
                    Category                = "ThreatManagement";
                    Comment                 = "User has been detected as sending suspicious messages outside the organization and will be restricted if this activity continues. -V1.0.0.1";
                    Credential              = $Credential
                    Ensure                  = "Absent";
                    Name                    = "Suspicious email sending patterns detected";
                    NotificationEnabled     = $True;
                    NotifyUser              = @("test.alert@contoso.onmicrosoft.com");
                    NotifyUserOnFilterMatch = $False;
                    Operation               = @("CompromisedWarningAccount");
                    Severity                = "Medium";
                    ThreatType              = "Activity";
                }

                Mock -CommandName Get-ProtectionAlert -MockWith {
                    return @{
                        AggregationType         = "None";
                        Category                = "ThreatManagement";
                        Comment                 = "Other Comment";
                        Name                    = "Suspicious email sending patterns detected";
                        NotificationEnabled     = $False;
                        NotifyUser              = @("other.alert@contoso.onmicrosoft.com");
                        NotifyUserOnFilterMatch = $False;
                        Operation               = @("CompromisedWarningAccount");
                        Severity                = "Medium";
                        ThreatType              = "Activity";
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $False
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-ProtectionAlert -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-ProtectionAlert -MockWith {
                    return @{
                        AggregationType         = "None";
                        Category                = "ThreatManagement";
                        Comment                 = "Other Comment";
                        Name                    = "Suspicious email sending patterns detected";
                        NotificationEnabled     = $False;
                        NotifyUser              = @("other.alert@contoso.onmicrosoft.com");
                        NotifyUserOnFilterMatch = $False;
                        Operation               = @("CompromisedWarningAccount");
                        Severity                = "Medium";
                        ThreatType              = "Activity";
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
