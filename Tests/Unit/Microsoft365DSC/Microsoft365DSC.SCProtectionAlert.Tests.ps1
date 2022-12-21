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
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin', $secpasswd)


            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
            }

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
        Context -Name "Protection Alert doesn't already exists and should be Active" -Fixture {
            BeforeAll {
                $testParams = @{
                    AggregationType         = "None";
                    Category                = "ThreatManagement";
                    Comment                 = "User has been detected as sending suspicious messages outside the organization and will be restricted if this activity continues. -V1.0.0.1";
                    Credential              = $Credential
                    Ensure                  = "Present";
                    IsSystemRule            = $False;
                    Name                    = "Suspicious email sending patterns detected";
                    NotificationEnabled     = $True;
                    NotifyUser              = @("test.alert@contoso.onmicrosoft.com");
                    NotifyUserOnFilterMatch = $False;
                    Operation               = @("CompromisedWarningAccount");
                    Scenario                = "AuditProtectionAlert";
                    Severity                = "Medium";
                    StreamType              = "Activity";
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
            }
        }


        Context -Name 'Protection Alert already exists' -Fixture {
            BeforeAll {
                $testParams = @{
                    AggregationType         = "None";
                    Category                = "ThreatManagement";
                    Comment                 = "User has been detected as sending suspicious messages outside the organization and will be restricted if this activity continues. -V1.0.0.1";
                    Credential              = $Credential
                    Ensure                  = "Present";
                    IsSystemRule            = $False;
                    Name                    = "Suspicious email sending patterns detected";
                    NotificationEnabled     = $True;
                    NotifyUser              = @("test.alert@contoso.onmicrosoft.com");
                    NotifyUserOnFilterMatch = $False;
                    Operation               = @("CompromisedWarningAccount");
                    Scenario                = "AuditProtectionAlert";
                    Severity                = "Medium";
                    StreamType              = "Activity";
                    ThreatType              = "Activity";
                }

                Mock -CommandName Get-ProtectionAlert -MockWith {
                    return @{
                        AggregationType         = "None";
                        Category                = "ThreatManagement";
                        Comment                 = "Other Comment";
                        IsSystemRule            = $False;
                        Name                    = "Suspicious email sending patterns detected";
                        NotificationEnabled     = $False;
                        NotifyUser              = @("other.alert@contoso.onmicrosoft.com");
                        NotifyUserOnFilterMatch = $False;
                        Operation               = @("CompromisedWarningAccount");
                        Scenario                = "AuditProtectionAlert";
                        Severity                = "Medium";
                        StreamType              = "Activity";
                        ThreatType              = "Activity";
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $False
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name "Protection Alert already exists but shouldn't" -Fixture {
            BeforeAll {
                $testParams = @{
                        Credential              = $Credential
                        Ensure                  = 'Absent'
                        Name                    = 'Suspicious'
                    }
                }

                Mock -CommandName Get-ProtectionAlert -MockWith {
                    return @{
                        Name                    = 'Suspicious'
                    }
                }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $False
            }

            It 'Should remove it from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
