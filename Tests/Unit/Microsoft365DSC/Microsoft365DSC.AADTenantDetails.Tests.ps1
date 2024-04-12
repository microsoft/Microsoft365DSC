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
    -DscResource 'AADTenantDetails' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@contoso.onmicrosoft.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaOrganization -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'Values should exist but it does not' -Fixture {
            BeforeAll {
                $testParams = @{
                    TechnicalNotificationMails           = 'exapmle@contoso.com'
                    SecurityComplianceNotificationPhones = '+1123456789'
                    SecurityComplianceNotificationMails  = 'exapmle@contoso.com'
                    MarketingNotificationEmails          = 'exapmle@contoso.com'
                    Credential                           = $Credential
                    IsSingleInstance                     = 'Yes'
                }

                Mock -CommandName Get-MgBetaOrganization -MockWith {
                    $result = @{
                        MarketingNotificationEmails          = ''
                        SecurityComplianceNotificationMails  = ''
                        SecurityComplianceNotificationPhones = ''
                        TechnicalNotificationMails           = ''
                    }
                    return $result
                }
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name 'Values exists but it should not' -Fixture {
            BeforeAll {
                $testParams = @{
                    TechnicalNotificationMails           = 'exapmle@contoso.com'
                    SecurityComplianceNotificationPhones = '+1123456789'
                    SecurityComplianceNotificationMails  = 'exapmle@contoso.com'
                    Credential                           = $Credential
                    IsSingleInstance                     = 'Yes'
                }

                Mock -CommandName Get-MgBetaOrganization -MockWith {
                    $AADTenantDetails = New-Object PSCustomObject
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name MarketingNotificationEmails -Value '' #should not be
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name SecurityComplianceNotificationMails -Value ''
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name SecurityComplianceNotificationPhones -Value ''
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name TechnicalNotificationMails -Value ''

                    return $AADTenantDetails
                }
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }
        Context -Name 'Values exists and values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    TechnicalNotificationMails           = 'exapmle@contoso.com'
                    SecurityComplianceNotificationPhones = '+1123456789'
                    SecurityComplianceNotificationMails  = 'exapmle@contoso.com'
                    MarketingNotificationEmails          = 'exapmle@contoso.com'
                    Credential                           = $Credential
                    IsSingleInstance                     = 'Yes'
                }

                Mock -CommandName Get-MgBetaOrganization -MockWith {
                    $AADTenantDetails = New-Object PSCustomObject
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name MarketingNotificationEmails -Value 'exapmle@contoso.com'
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name SecurityComplianceNotificationMails -Value 'exapmle@contoso.com'
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name SecurityComplianceNotificationPhones -Value '+1123456789'
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name TechnicalNotificationMails -Value 'exapmle@contoso.com'
                    return $AADTenantDetails
                }
            }

            It 'Should return Values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgBetaOrganization' -Exactly 1
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Values are not in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    TechnicalNotificationMails           = 'exapmle@contoso.com'
                    SecurityComplianceNotificationPhones = '+1123456789'
                    SecurityComplianceNotificationMails  = 'exapmle@contoso.com'
                    MarketingNotificationEmails          = 'NOTexapmle@contoso.com' #Drift
                    Credential                           = $Credential
                    IsSingleInstance                     = 'Yes'
                }

                Mock -CommandName Get-MgBetaOrganization -MockWith {
                    $AADTenantDetails = New-Object PSCustomObject
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name MarketingNotificationEmails -Value 'exapmle@contoso.com'
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name SecurityComplianceNotificationMails -Value 'exapmle@contoso.com'
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name SecurityComplianceNotificationPhones -Value '+1123456789'
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name TechnicalNotificationMails -Value 'exapmle@contoso.com'
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name Id -Value '12345-12345-12345-12345-12345'
                    return $AADTenantDetails
                }
            }

            It 'Should return values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgBetaOrganization' -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Update-MgBetaOrganization' -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaOrganization -MockWith {
                    $AADTenantDetails = New-Object PSCustomObject
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name IsSingleInstance -Value 'Yes'
                    return $AADTenantDetails
                }
            }

            It 'Should reverse engineer resource from the export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
