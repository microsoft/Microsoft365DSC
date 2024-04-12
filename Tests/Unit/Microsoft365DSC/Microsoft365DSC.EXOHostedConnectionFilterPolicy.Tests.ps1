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
    -DscResource 'EXOHostedConnectionFilterPolicy' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName New-HostedConnectionFilterPolicy -MockWith {
            }

            Mock -CommandName Set-HostedConnectionFilterPolicy -MockWith {
            }

            Mock -CommandName Remove-HostedConnectionFilterPolicy -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'HostedConnectionFilterPolicy creation.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure           = 'Present'
                    Identity         = 'TestPolicy'
                    Credential       = $Credential
                    AdminDisplayName = 'This policiy is a test'
                    EnableSafeList   = $true
                    IPAllowList      = @('192.168.1.100', '10.1.1.0/24', '172.16.5.1-172.16.5.150')
                    IPBlockList      = @('10.1.1.13', '172.16.5.2')
                    MakeDefault      = $false
                }

                Mock -CommandName Get-HostedConnectionFilterPolicy -MockWith {
                    return @{
                        Identity = 'SomeOtherPolicy'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'HostedConnectionFilterPolicy update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure           = 'Present'
                    Identity         = 'TestPolicy'
                    Credential       = $Credential
                    AdminDisplayName = 'This policiy is a test'
                    EnableSafeList   = $true
                    IPAllowList      = @('192.168.1.100', '10.1.1.0/24', '172.16.5.1-172.16.5.150')
                    IPBlockList      = @('10.1.1.13', '172.16.5.2')
                    MakeDefault      = $false
                }

                Mock -CommandName Get-HostedConnectionFilterPolicy -MockWith {
                    return @{
                        Ensure           = 'Present'
                        Identity         = 'TestPolicy'
                        Credential       = $Credential
                        AdminDisplayName = 'This policiy is a test'
                        EnableSafeList   = $true
                        IPAllowList      = @('192.168.1.100', '10.1.1.0/24', '172.16.5.1-172.16.5.150')
                        IPBlockList      = @('10.1.1.13', '172.16.5.2')
                        MakeDefault      = $false
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'HostedConnectionFilterPolicy update needed.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure           = 'Present'
                    Identity         = 'TestPolicy'
                    Credential       = $Credential
                    AdminDisplayName = 'This policiy is a test'
                    EnableSafeList   = $true
                    IPAllowList      = @('192.168.1.100', '10.1.1.0/24', '172.16.5.1-172.16.5.150')
                    IPBlockList      = @('10.1.1.13', '172.16.5.2')
                    MakeDefault      = $false
                }

                Mock -CommandName Get-HostedConnectionFilterPolicy -MockWith {
                    return @{
                        Ensure           = 'Present'
                        Identity         = 'TestPolicy'
                        Credential       = $Credential
                        AdminDisplayName = 'This different description'
                        EnableSafeList   = $false
                        IPAllowList      = @('192.168.1.100')
                        IPBlockList      = @('10.1.1.13')
                        MakeDefault      = $false
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'HostedConnectionFilterPolicy removal.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure     = 'Absent'
                    Identity   = 'TestPolicy'
                    Credential = $Credential
                }

                Mock -CommandName Get-HostedConnectionFilterPolicy -MockWith {
                    return @{
                        Identity = 'TestPolicy'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-HostedConnectionFilterPolicy -MockWith {
                    return @{
                        Identity = 'TestPolicy'
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
