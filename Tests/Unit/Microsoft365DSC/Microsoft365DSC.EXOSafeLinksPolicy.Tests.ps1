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
    -DscResource 'EXOSafeLinksPolicy' -GenericStubModule $GenericStubPath
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

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'SafeLinksPolicy creation.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                        = 'Present'
                    Identity                      = 'TestSafeLinksPolicy'
                    Credential                    = $Credential
                    AdminDisplayName              = 'Test SafeLinks Policy'
                    CustomNotificationText        = ''
                    DoNotRewriteUrls              = @('test.contoso.com', 'test.fabrikam.org')
                    EnableForInternalSenders      = $false
                    EnableSafeLinksForEmail       = $false
                    EnableSafeLinksForTeams       = $false
                    EnableOrganizationBranding    = $false
                    ScanUrls                      = $false
                    UseTranslatedNotificationText = $false
                }

                Mock -CommandName Get-SafeLinksPolicy -MockWith {
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

        Context -Name 'SafeLinksPolicy update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                        = 'Present'
                    Identity                      = 'TestSafeLinksPolicy'
                    Credential                    = $Credential
                    AdminDisplayName              = 'Test SafeLinks Policy'
                    CustomNotificationText        = ''
                    DoNotRewriteUrls              = @('test.contoso.com', 'test.fabrikam.org')
                    EnableForInternalSenders      = $false
                    EnableSafeLinksForEmail       = $false
                    EnableSafeLinksForTeams       = $false
                    EnableOrganizationBranding    = $false
                    ScanUrls                      = $false
                    UseTranslatedNotificationText = $false
                }

                Mock -CommandName Get-SafeLinksPolicy -MockWith {
                    return @{
                        Identity                      = 'TestSafeLinksPolicy'
                        AdminDisplayName              = 'Test SafeLinks Policy'
                        CustomNotificationText        = ''
                        DoNotRewriteUrls              = @('test.contoso.com', 'test.fabrikam.org')
                        EnableForInternalSenders      = $false
                        EnableSafeLinksForEmail       = $false
                        EnableSafeLinksForTeams       = $false
                        EnableOrganizationBranding    = $false
                        ScanUrls                      = $false
                        UseTranslatedNotificationText = $false
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'SafeLinksPolicy update needed.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                        = 'Present'
                    Identity                      = 'TestSafeLinksPolicy'
                    Credential                    = $Credential
                    AdminDisplayName              = 'Test SafeLinks Policy'
                    CustomNotificationText        = ''
                    DoNotRewriteUrls              = @('test.contoso.com', 'test.fabrikam.org')
                    EnableForInternalSenders      = $false
                    EnableSafeLinksForEmail       = $false
                    EnableSafeLinksForTeams       = $false
                    EnableOrganizationBranding    = $false
                    ScanUrls                      = $false
                    UseTranslatedNotificationText = $false
                }

                Mock -CommandName Get-SafeLinksPolicy -MockWith {
                    return @{
                        Ensure                        = 'Present'
                        Identity                      = 'TestSafeLinksPolicy'
                        Credential                    = $Credential
                        AdminDisplayName              = 'Test SafeLinks Policy'
                        CustomNotificationText        = 'This is a custom notification text'
                        DoNotRewriteUrls              = @('test1.contoso.com', 'test.fabrikam.org')
                        EnableForInternalSenders      = $true
                        EnableSafeLinksForEmail       = $true
                        EnableSafeLinksForTeams       = $true
                        EnableOrganizationBranding    = $true
                        ScanUrls                      = $true
                        UseTranslatedNotificationText = $true
                    }
                }

                Mock -CommandName Set-SafeLinksPolicy -MockWith {
                    return @{
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

        Context -Name 'SafeLinksPolicy removal.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                        = 'Absent'
                    Identity                      = 'TestSafeLinksPolicy'
                    Credential                    = $Credential
                    AdminDisplayName              = 'Test SafeLinks Policy'
                    CustomNotificationText        = ''
                    DoNotRewriteUrls              = @('test.contoso.com', 'test.fabrikam.org')
                    EnableForInternalSenders      = $false
                    EnableSafeLinksForEmail       = $false
                    EnableSafeLinksForTeams       = $false
                    EnableOrganizationBranding    = $false
                    ScanUrls                      = $false
                    UseTranslatedNotificationText = $false
                }

                Mock -CommandName Get-SafeLinksPolicy -MockWith {
                    return @{
                        Identity = 'TestSafeLinksPolicy'
                    }
                }

                Mock -CommandName Remove-SafeLinksPolicy -MockWith {
                    return @{

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

                Mock -CommandName Confirm-ImportedCmdletIsAvailable -MockWith {
                    return $true
                }

                Mock -CommandName Get-SafeLinksPolicy -MockWith {
                    return @{
                        Identity                      = 'TestSafeLinksPolicy'
                        AdminDisplayName              = 'Test SafeLinks Policy'
                        CustomNotificationText        = ''
                        DoNotRewriteUrls              = @('test.contoso.com', 'test.fabrikam.org')
                        EnableForInternalSenders      = $false
                        EnableSafeLinksForEmail       = $false
                        EnableSafeLinksForTeams       = $false
                        EnableOrganizationBranding    = $false
                        ScanUrls                      = $false
                        UseTranslatedNotificationText = $false
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
