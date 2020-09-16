[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath "..\..\Unit" `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath "\Stubs\Microsoft365.psm1" `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath "\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "AADTenantDetails" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin@contoso.onmicrosoft.com", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Get-AzureADTenantDetail -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

            }

            Mock -CommandName Set-AzureADTenantDetail -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }

        # Test contexts
        Context -Name "Values should exist but it does not" -Fixture {
            BeforeAll {
                $testParams = @{
                    TechnicalNotificationMails             = "exapmle@contoso.com"
                    SecurityComplianceNotificationPhones   = "+1123456789"
                    SecurityComplianceNotificationMails    = "exapmle@contoso.com"
                    MarketingNotificationEmails            = "exapmle@contoso.com"
                    GlobalAdminAccount                     = $GlobalAdminAccount
                    IsSingleInstance                       = 'Yes'
                }

                Mock -CommandName Get-AzureADTenantDetail -MockWith {
                    return $null
                }
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name "Values exists but it should not" -Fixture {
            BeforeAll {
                $testParams = @{
                    TechnicalNotificationMails             = "exapmle@contoso.com"
                    SecurityComplianceNotificationPhones   = "+1123456789"
                    SecurityComplianceNotificationMails    = "exapmle@contoso.com"
                    MarketingNotificationEmails            = "exapmle@contoso.com"
                    GlobalAdminAccount                     = $GlobalAdminAccount
                    IsSingleInstance                       = 'Yes'
                }

                Mock -CommandName Get-AzureADTenantDetail -MockWith {
                    $AADTenantDetails = New-Object PSCustomObject
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name MarketingNotificationEmails -Value "exapmle@contoso.com"
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name SecurityComplianceNotificationMails -Value "exapmle@contoso.com"
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name SecurityComplianceNotificationPhones -Value "+1123456789"
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name TechnicalNotificationMails -Value "exapmle@contoso.com"
                    return $AADTenantDetails
                }
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }
        Context -Name "Values exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    TechnicalNotificationMails             = "exapmle@contoso.com"
                    SecurityComplianceNotificationPhones   = "+1123456789"
                    SecurityComplianceNotificationMails    = "exapmle@contoso.com"
                    MarketingNotificationEmails            = "exapmle@contoso.com"
                    GlobalAdminAccount                     = $GlobalAdminAccount
                    IsSingleInstance                       = 'Yes'
                }

                Mock -CommandName Get-AzureADTenantDetail -MockWith {
                    $AADTenantDetails = New-Object PSCustomObject
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name MarketingNotificationEmails -Value "exapmle@contoso.com"
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name SecurityComplianceNotificationMails -Value "exapmle@contoso.com"
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name SecurityComplianceNotificationPhones -Value "+1123456789"
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name TechnicalNotificationMails -Value "exapmle@contoso.com"
                    return $AADTenantDetails
                }
            }

            It "Should return Values from the get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-AzureADTenantDetail" -Exactly 1
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "Values are not in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    TechnicalNotificationMails             = "exapmle@contoso.com"
                    SecurityComplianceNotificationPhones   = "+1123456789"
                    SecurityComplianceNotificationMails    = "exapmle@contoso.com"
                    MarketingNotificationEmails            = "NOTexapmle@contoso.com" #Drift
                    GlobalAdminAccount                     = $GlobalAdminAccount
                    IsSingleInstance                       = 'Yes'
                }

                Mock -CommandName Get-AzureADTenantDetail -MockWith {
                    $AADTenantDetails = New-Object PSCustomObject
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name MarketingNotificationEmails -Value "exapmle@contoso.com"
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name SecurityComplianceNotificationMails -Value "exapmle@contoso.com"
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name SecurityComplianceNotificationPhones -Value "+1123456789"
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name TechnicalNotificationMails -Value "exapmle@contoso.com"
                    return $AADTenantDetails
                }
            }

            It "Should return values from the get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-AzureADTenantDetail" -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Set-AzureADTenantDetail' -Exactly 1
            }
        }

        Context -Name "ReverseDSC tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-AzureADTenantDetail -MockWith {
                    $AADTenantDetails = New-Object PSCustomObject
                    $AADTenantDetails | Add-Member -MemberType NoteProperty -Name IsSingleInstance -Value 'Yes'
                    return $AADTenantDetails
                }
            }

            It "Should reverse engineer resource from the export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
