[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Microsoft365.psm1" `
            -Resolve)
)
$GenericStubPath = (Join-Path -Path $PSScriptRoot `
    -ChildPath "..\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "TeamsTenantDialPlan" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {
        }

        Mock -CommandName Set-CsTenantDialPlan -MockWith {
        }

        Mock -CommandName Remove-CsTenantDialPlan -MockWith {
        }

        Mock -CommandName New-CsTenantDialPlan -MockWith {
        }

        # Test contexts
        Context -Name "The dial plan doesn't exist" -Fixture {
            $testParams = @{
                Identity            = "TestPlan";
                Ensure              = 'Present'
                GlobalAdminAccount  = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsTenantDialPlan -MockWith {
                return $null
            }

            It "Should return false from the Test method" {
                [boolean] $result = Test-TargetResource @testParams
                $result | Should be $false
            }

            It "Should return False for the Ensure property from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Absent'
            }

            It "Create the dial plan Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled New-CsTenantDialPlan -Exactly 1
            }
        }

        Context -Name "The dial plan exists but is NOT in the Desired State" -Fixture {
            $testParams = @{
                Identity           = "Test";
                Description        = "TestDescription";
                Ensure             = "Present"
                NormalizationRules = @(New-CimInstance -ClassName MSFT_TeamsVoiceNormalizationRule -Property @{
                    Pattern = '^00(\d+)$'
                    Description = 'None'
                    Identity = 'TestNotExisting'
                    Translation = '+$1'
                    Priority = 0
                    IsInternalExtension = $False
                } -ClientOnly;
                New-CimInstance -ClassName MSFT_TeamsVoiceNormalizationRule -Property @{
                    Pattern = '^00(\d+)$'
                    Description = 'None'
                    Identity = 'TestNotExisting2'
                    Translation = '+$1'
                    Priority = 0
                    IsInternalExtension = $False
                } -ClientOnly;)
                GlobalAdminAccount = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsTenantDialPlan -MockWith {
                return @{
                    Identity           = 'Test'
                    Description        = "TestDescription";
                    NormalizationRules = @{
                        Pattern = '^00(\d+)$'
                        Description = 'None'
                        Name = 'TestNotExisting'
                        Translation = '+$1'
                        Priority = 0
                        IsInternalExtension = $False
                    }
                }
            }
            It "Should return false from the Test method" {
                [boolean] $result = Test-TargetResource @testParams
                $result | Should be $false
            }

            It "Should return True for the Ensure property from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }

            It "Updates in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled Set-CsTenantDialPlan -Exactly 1
            }
        }

        Context -Name "The dial plan exists and IS in the Desired State" -Fixture {
            $testParams = @{
                Identity           = "Test";
                Description        = "TestDescription";
                Ensure             = "Present"
                NormalizationRules = @(New-CimInstance -ClassName MSFT_TeamsVoiceNormalizationRule -Property @{
                    Pattern = '^00(\d+)$'
                    Description = 'None'
                    Identity = 'TestNotExisting'
                    Translation = '+$1'
                    Priority = 0
                    IsInternalExtension = $False
                } -ClientOnly;
                New-CimInstance -ClassName MSFT_TeamsVoiceNormalizationRule -Property @{
                    Pattern = '^00(\d+)$'
                    Description = 'None'
                    Identity = 'TestNotExisting2'
                    Translation = '+$1'
                    Priority = 0
                    IsInternalExtension = $False
                } -ClientOnly;)
                GlobalAdminAccount = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsTenantDialPlan -MockWith {
                return @{
                    Identity           = 'Test'
                    Description        = "TestDescription";
                    NormalizationRules = @(@{
                        Pattern = '^00(\d+)$'
                        Description = 'None'
                        Name = 'TestNotExisting'
                        Translation = '+$1'
                        Priority = 0
                        IsInternalExtension = $False
                    },
                    @{
                        Pattern = '^00(\d+)$'
                        Description = 'None'
                        Name = 'TestNotExisting2'
                        Translation = '+$1'
                        Priority = 0
                        IsInternalExtension = $False
                    }
                    )
                }
            }
            It "Should return true from the Test method" {
                [boolean] $result = Test-TargetResource @testParams
                $result | Should be $true
            }

            It "Should return True for the Ensure property from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }
        }

        Context -Name "The dial plan exists but it SHOULD NOT" -Fixture {
            $testParams = @{
                Identity           = "Test";
                Description        = "TestDescription";
                Ensure             = "Absent"
                GlobalAdminAccount = $GlobalAdminAccount;
            }

            Mock -CommandName Get-CsTenantDialPlan -MockWith {
                return @{
                    Identity           = 'Test'
                    Description        = "TestDescription";
                    NormalizationRules = @(@{
                        Pattern = '^00(\d+)$'
                        Description = 'None'
                        Name = 'TestNotExisting'
                        Translation = '+$1'
                        Priority = 0
                        IsInternalExtension = $False
                    },
                    @{
                        Pattern = '^00(\d+)$'
                        Description = 'None'
                        Name = 'TestNotExisting2'
                        Translation = '+$1'
                        Priority = 0
                        IsInternalExtension = $False
                    }
                    )
                }
            }

            It "Should return false from the Test method" {
                [boolean] $result = Test-TargetResource @testParams
                $result | Should be $false
            }

            It "Should return True for the Ensure property from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }


            It "Remove the dial plan in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled Remove-CsTenantDialPlan -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
