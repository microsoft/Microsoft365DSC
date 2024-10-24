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
    -DscResource 'EXOServicePrincipal' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@contoso.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Remove-ServicePrincipal -MockWith {
                return $null
            }

            Mock -CommandName Set-ServicePrincipal -MockWith {
                return $null
            }

            Mock -CommandName New-ServicePrincipal -MockWith {
                return $null
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
                    AppId                = "703005d9-c467-413e-a085-295c3e09e6cb";
                    Credential           = $Credscredential;
                    DisplayName          = "Aditya";
                    Ensure               = "Present";
                    Identity             = "6dfb8885-0297-42e6-9c81-7bf7ee15551d";
                }

                Mock -CommandName Get-ServicePrincipal -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create a new instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-ServicePrincipal -Exactly 1
            }
        }

        Context -Name "The instance exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AppId                = "703005d9-c467-413e-a085-295c3e09e6cb";
                    Credential           = $Credscredential;
                    DisplayName          = "Aditya";
                    Ensure               = "Absent";
                    Identity             = "6dfb8885-0297-42e6-9c81-7bf7ee15551d";
                }

                Mock -CommandName Get-ServicePrincipal -MockWith {
                    return @{
                        AppId                = "703005d9-c467-413e-a085-295c3e09e6cb";
                        Credential           = $Credscredential;
                        DisplayName          = "Aditya";
                        Ensure               = "Present";
                        Identity             = "6dfb8885-0297-42e6-9c81-7bf7ee15551d";
                    }
                }

            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-ServicePrincipal -Exactly 1
            }
        }

        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AppId                = "703005d9-c467-413e-a085-295c3e09e6cb";
                    Credential           = $Credscredential;
                    DisplayName          = "Aditya";
                    Ensure               = "Present";
                    Identity             = "6dfb8885-0297-42e6-9c81-7bf7ee15551d";
                }

                Mock -CommandName Get-ServicePrincipal -MockWith {
                    return @{
                        AppId                = "703005d9-c467-413e-a085-295c3e09e6cb";
                        Credential           = $Credscredential;
                        DisplayName          = "Aditya";
                        Ensure               = "Present";
                        Identity             = "6dfb8885-0297-42e6-9c81-7bf7ee15551d";
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
                    AppId                = "703005d9-c467-413e-a085-295c3e09e6cb";
                    Credential           = $Credscredential;
                    DisplayName          = "Aditya Mukund";  #Drift
                    Ensure               = "Present";
                    Identity             = "6dfb8885-0297-42e6-9c81-7bf7ee15551d";
                }

                Mock -CommandName Get-ServicePrincipal -MockWith {
                    return @{
                        AppId                = "703005d9-c467-413e-a085-295c3e09e6cb";
                        Credential           = $Credscredential;
                        DisplayName          = "Aditya";
                        Ensure               = "Present";
                        Identity             = "6dfb8885-0297-42e6-9c81-7bf7ee15551d";
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
                Should -Invoke -CommandName Set-ServicePrincipal -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential  = $Credential;
                }

                Mock -CommandName Get-ServicePrincipal -MockWith {
                    return @{
                        AppId                = "703005d9-c467-413e-a085-295c3e09e6cb";
                        Credential           = $Credscredential;
                        DisplayName          = "Aditya";
                        Ensure               = "Present";
                        Identity             = "6dfb8885-0297-42e6-9c81-7bf7ee15551d";
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
