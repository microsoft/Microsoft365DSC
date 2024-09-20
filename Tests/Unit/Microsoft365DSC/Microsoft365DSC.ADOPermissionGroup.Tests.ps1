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

$CurrentScriptPath = $PSCommandPath.Split('\')
$CurrentScriptName = $CurrentScriptPath[$CurrentScriptPath.Length -1]
$ResourceName      = $CurrentScriptName.Split('.')[1]
$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource $ResourceName -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name "The instance should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description         = "Test Description";
                    DisplayName         = "TestGroup";
                    Level               = "Organization";
                    Members             = @("john.smith@contoso.com");
                    OrganizationName    = "TestOrg";
                    PrincipalName       = "[TestOrg]\TestGroup";
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                Mock -CommandName Invoke-M365DSCAzureDevOPSWebRequest -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name "The instance exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description         = "Test Description";
                    DisplayName         = "TestGroup";
                    Level               = "Organization";
                    Members             = @("john.smith@contoso.com");
                    OrganizationName    = "TestOrg";
                    PrincipalName       = "[TestOrg]\TestGroup";
                    Ensure              = 'Absent'
                    Credential          = $Credential;
                }

                Mock -CommandName Invoke-M365DSCAzureDevOPSWebRequest -MockWith {
                    if ($Script:count -eq 0)
                    {
                        $Script:count++
                        return @{
                            Value = @{
                                PrincipalName = '[TestOrg]\TestGroup'
                                Domain        = 'vstfs:///Framework/IdentityDomain/'
                                OriginId      = '12345-12345-12345-12345-12345'
                            }
                        }
                    }
                    elseif ($Script:count -eq 1)
                    {
                        $Script:count++
                        return @{
                            Members = @(
                                @{
                                    User = @{
                                        principalName = "john.smith@contoso.com"
                                    }
                                }
                            )
                        }
                    }
                }
            }
            It 'Should return Values from the Get method' {
                $Script:count = 0
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should return false from the Test method' {
                $Script:count = 0
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the instance from the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description         = "Test Description";
                    DisplayName         = "TestGroup";
                    Level               = "Organization";
                    Members             = @("john.smith@contoso.com");
                    OrganizationName    = "TestOrg";
                    PrincipalName       = "[TestOrg]\TestGroup";
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                $Script:count = 0
                Mock -CommandName Invoke-M365DSCAzureDevOPSWebRequest -MockWith {
                    if ($Script:count -eq 0)
                    {
                        $Script:count++
                        return @{
                            Value = @{
                                PrincipalName = '[TestOrg]\TestGroup'
                                Domain        = 'vstfs:///Framework/IdentityDomain/'
                                OriginId      = '12345-12345-12345-12345-12345'
                                Description   = 'Test Description'
                                DisplayName   = 'TestGroup'
                            }
                        }
                    }
                    elseif ($Script:count -eq 1)
                    {
                        $Script:count++
                        return @{
                            Members = @(
                                @{
                                    User = @{
                                        principalName = "john.smith@contoso.com"
                                    }
                                }
                            )
                        }
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The instance exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description         = "Test Description";
                    DisplayName         = "TestGroup";
                    Level               = "Organization";
                    Members             = @("john.smith@contoso.com");
                    OrganizationName    = "TestOrg";
                    PrincipalName       = "[TestOrg]\TestGroup";
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                $Script:count = 0
                Mock -CommandName Invoke-M365DSCAzureDevOPSWebRequest -MockWith {
                    if ($Script:count -eq 0)
                    {
                        $Script:count++
                        return @{
                            Value = @{
                                PrincipalName = '[TestOrg]\TestGroup'
                                Domain        = 'vstfs:///Framework/IdentityDomain/'
                                OriginId      = '12345-12345-12345-12345-12345'
                                Description   = 'Test Description'
                                DisplayName   = 'TestGroup'
                            }
                        }
                    }
                    elseif ($Script:count -eq 1)
                    {
                        $Script:count++
                        return @{
                            Members = @(
                                @{
                                    User = @{
                                        principalName = "bob.houle@contoso.com" # drift
                                    }
                                }
                            )
                        }
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential          = $Credential;
                }

                $Script:count = 0
                Mock -CommandName Invoke-M365DSCAzureDevOPSWebRequest -MockWith {
                    if ($Script:count -eq 0)
                    {
                        $Script:count++
                        return @{
                            id = '12345-12345-12345-12345-12346'
                        }
                    }
                    elseif ($Script:count -eq 1)
                    {
                        $Script:count++
                        return @(
                        @{
                            Value = @{
                                accountName = 'MyOrg'
                            }
                        }
                        )
                    }
                    elseif ($Script:count -eq 2)
                    {
                        $Script:count++
                        return @{
                            Value = @{
                                PrincipalName = '[TestOrg]\TestGroup'
                                Domain        = 'vstfs:///Framework/IdentityDomain/'
                                OriginId      = '12345-12345-12345-12345-12345'
                                Description   = 'Test Description'
                                DisplayName   = 'TestGroup'
                            }
                        }
                    }
                    elseif ($Script:count -eq 3)
                    {
                        $Script:count++
                        return @{
                            Members = @(
                                @{
                                    User = @{
                                        principalName = "john.smith@contoso.com"
                                    }
                                }
                            )
                        }
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
