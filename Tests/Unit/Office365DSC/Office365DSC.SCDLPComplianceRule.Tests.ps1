[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Office365.psm1" `
            -Resolve)
)

Import-Module -Name (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-O365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "SCDLPComplianceRule"
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Import-PSSession -MockWith {

        }

        Mock -CommandName New-PSSession -MockWith {

        }

        Mock -CommandName Remove-DLPComplianceRule -MockWith {

        }

        Mock -CommandName New-DLPComplianceRule -MockWith {
            return @{

            }
        }

        # Test contexts
        Context -Name "Rule doesn't already exist but should" -Fixture {
            $testParams = @{
                Ensure                              = 'Present'
                Policy                              = "MyParentPolicy"
                Comment                             = "";
                ContentContainsSensitiveInformation = (New-CimInstance -ClassName MSFT_SCDLPSensitiveInformation -Property @{
                    name                = "rulename"
                    maxcount            = "10"
                    mincount            = "0"
                } -ClientOnly)
                BlockAccess                         = $False;
                Name                                = 'TestPolicy'
            }

            Mock -CommandName Get-DLPComplianceRule -MockWith {
                return $null
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Rule already exists, and should" -Fixture {
            $testParams = @{
                Ensure                              = 'Present'
                Policy                              = "MyParentPolicy"
                Comment                             = "";
                ContentContainsSensitiveInformation = (New-CimInstance -ClassName MSFT_SCDLPSensitiveInformation -Property @{
                    maxconfidence = "100";
                    id = "eefbb00e-8282-433c-8620-8f1da3bffdb2";
                    minconfidence = "75";
                    rulePackId = "00000000-0000-0000-0000-000000000000";
                    classifiertype = "Content";
                    name = "Argentina National Identity (DNI) Number";
                    mincount = "1";
                    maxcount = "9";
                } -ClientOnly)
                BlockAccess                         = $False;
                Name                                = 'TestPolicy'
            }

            Mock -CommandName Get-DLPComplianceRule -MockWith {
                return @{
                    Name                                = "TestPolicy"
                    Comment                             = "New Comment"
                    Policy                              = "MyParentPolicy"
                    ContentContainsSensitiveInformation = @{maxconfidence = "100"; id = "eefbb00e-8282-433c-8620-8f1da3bffdb2"; minconfidence = "75"; rulePackId = "00000000-0000-0000-0000-000000000000"; classifiertype = "Content"; name = "Argentina National Identity (DNI) Number"; mincount = "1"; maxcount = "9"; };
                    BlockAccess                         = $False;
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Should recreate from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "Rule should not exist" -Fixture {
            $testParams = @{
                Ensure                              = 'Absent'
                Policy                              = "MyParentPolicy"
                Comment                             = "";
                ContentContainsSensitiveInformation = @{maxconfidence = "100"; id = "eefbb00e-8282-433c-8620-8f1da3bffdb2"; minconfidence = "75"; rulePackId = "00000000-0000-0000-0000-000000000000"; classifiertype = "Content"; name = "Argentina National Identity (DNI) Number"; mincount = "1"; maxcount = "9"; };
                BlockAccess                         = $False;
                Name                                = 'TestPolicy'
            }

            Mock -CommandName Get-DLPComplianceRule -MockWith {
                return @{
                    Name = "TestPolicy"
                    Policy                              = "MyParentPolicy"
                    Comment                             = "";
                    ContentContainsSensitiveInformation = (New-CimInstance -ClassName MSFT_SCDLPSensitiveInformation -Property @{
                        name                = "rulename"
                        maxcount            = "10"
                        mincount            = "0"
                    } -ClientOnly)
                    BlockAccess                         = $False;
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It 'Should delete from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
                Name               = "Test Policy"
            }

            Mock -CommandName Get-DLPComplianceRule -MockWith {
                return @{
                    Name = "TestPolicy"
                    Policy                              = "MyParentPolicy"
                    Comment                             = "";
                    ContentContainsSensitiveInformation = (New-CimInstance -ClassName MSFT_SCDLPSensitiveInformation -Property @{
                        name                = "rulename"
                        maxcount            = "10"
                        mincount            = "0"
                    } -ClientOnly)
                    BlockAccess                         = $False;
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
