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
    -DscResource 'EXOSharingPolicy' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
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

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'Sharing Policy should exist. Sharing Policy is missing. Test should fail.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name       = 'Contoso Sharing'
                    Domains    = 'mail.contoso.com: CalendarSharingFreeBusyDetail'
                    Enabled    = $true
                    Default    = $false
                    Ensure     = 'Present'
                    Credential = $Credential
                }

                Mock -CommandName Get-SharingPolicy -MockWith {
                    return @{
                        Name                = 'ContosoDifferent'
                        Domains             = 'different.contoso.com: CalendarSharingFreeBusyDetail'
                        Enabled             = $true
                        Default             = $false
                        FreeBusyAccessLevel = 'AvailabilityOnly'
                    }
                }

                Mock -CommandName Set-SharingPolicy -MockWith {
                    return @{
                        Name       = 'Contoso Sharing'
                        Domains    = 'mail.contoso.com: CalendarSharingFreeBusyDetail'
                        Enabled    = $true
                        Default    = $false
                        Ensure     = 'Present'
                        Credential = $Credential
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
        }

        Context -Name 'Sharing Policy should exist. Sharing Policy exists. Test should pass.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name       = 'Contoso Sharing'
                    Domains    = 'mail.contoso.com: CalendarSharingFreeBusyDetail'
                    Enabled    = $true
                    Default    = $false
                    Ensure     = 'Present'
                    Credential = $Credential
                }

                Mock -CommandName Get-SharingPolicy -MockWith {
                    return @{
                        Name    = 'Contoso Sharing'
                        Domains = 'mail.contoso.com: CalendarSharingFreeBusyDetail'
                        Enabled = $true
                        Default = $false
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Sharing Policy should exist. Sharing Policy exists, Domains mismatch. Test should fail.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name       = 'Contoso Sharing'
                    Domains    = 'mail.contoso.com: CalendarSharingFreeBusyDetail'
                    Enabled    = $true
                    Default    = $false
                    Ensure     = 'Present'
                    Credential = $Credential
                }

                Mock -CommandName Get-SharingPolicy -MockWith {
                    return @{
                        Name    = 'Contoso Sharing'
                        Domains = 'different.contoso.com: CalendarSharingFreeBusyDetail'
                        Enabled = $true
                        Default = $false
                    }
                }

                Mock -CommandName Set-SharingPolicy -MockWith {
                    return @{
                        Name       = 'Contoso Sharing'
                        Domains    = 'mail.contoso.com: CalendarSharingFreeBusyDetail'
                        Enabled    = $true
                        Default    = $false
                        Ensure     = 'Present'
                        Credential = $Credential
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

                $SharingPolicy = @{
                    Name    = 'ContosoSharing1'
                    Domains = 'mail.contoso.com: CalendarSharingFreeBusyDetail'
                    Enabled = $true
                    Default = $false
                }

                Mock -CommandName Get-SharingPolicy -MockWith {
                    return $SharingPolicy
                }
            }

            It 'Should Reverse Engineer resource from the Export method when single' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
