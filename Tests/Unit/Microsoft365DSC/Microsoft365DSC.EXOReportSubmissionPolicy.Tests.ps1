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
    -DscResource 'EXOReportSubmissionPolicy' -GenericStubModule $GenericStubPath
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

            Mock -CommandName New-ReportSubmissionPolicy -MockWith {
            }

            Mock -CommandName Set-ReportSubmissionPolicy -MockWith {
            }

            Mock -CommandName Remove-ReportSubmissionPolicy -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Write-Warning -MockWith {
            }
        }

        # Test contexts
        Context -Name 'ReportSubmissionPolicy creation.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                                 = 'Present'
                    Credential                             = $Credential
                    IsSingleInstance                       = 'Yes'
                    DisableQuarantineReportingOption       = $False
                    EnableCustomNotificationSender         = $False
                    EnableOrganizationBranding             = $False
                    EnableReportToMicrosoft                = $True
                    EnableThirdPartyAddress                = $False
                    EnableUserEmailNotification            = $False
                    PostSubmitMessageEnabled               = $True
                    PreSubmitMessageEnabled                = $True
                    ReportJunkToCustomizedAddress          = $False
                    ReportNotJunkToCustomizedAddress       = $False
                    ReportPhishToCustomizedAddress         = $False
                }


                Mock -CommandName Get-ReportSubmissionPolicy -MockWith {
                    return $null
                }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-ReportSubmissionPolicy' -Exactly 1
            }

        }

        Context -Name 'ReportSubmissionPolicy update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                                 = 'Present'
                    Credential                             = $Credential
                    IsSingleInstance                       = 'Yes'
                    DisableQuarantineReportingOption       = $False
                    EnableCustomNotificationSender         = $False
                    EnableOrganizationBranding             = $False
                    EnableReportToMicrosoft                = $True
                    EnableThirdPartyAddress                = $False
                    EnableUserEmailNotification            = $False
                    PostSubmitMessageEnabled               = $True
                    PreSubmitMessageEnabled                = $True
                    ReportJunkToCustomizedAddress          = $False
                    ReportNotJunkToCustomizedAddress       = $False
                    ReportPhishToCustomizedAddress         = $False
                }

                Mock -CommandName Get-ReportSubmissionPolicy -MockWith {
                    return @{
                        Ensure                                 = 'Present'
                        Credential                             = $Credential
                        IsSingleInstance                       = 'Yes'
                        DisableQuarantineReportingOption       = $False
                        EnableCustomNotificationSender         = $False
                        EnableOrganizationBranding             = $False
                        EnableReportToMicrosoft                = $True
                        EnableThirdPartyAddress                = $False
                        EnableUserEmailNotification            = $False
                        PostSubmitMessageEnabled               = $True
                        PreSubmitMessageEnabled                = $True
                        ReportJunkToCustomizedAddress          = $False
                        ReportNotJunkToCustomizedAddress       = $False
                        ReportPhishToCustomizedAddress         = $False
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'ReportSubmissionPolicy update needed.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                                 = 'Present'
                    Credential                             = $Credential
                    IsSingleInstance                       = 'Yes'
                    DisableQuarantineReportingOption       = $False
                    EnableCustomNotificationSender         = $False
                    EnableOrganizationBranding             = $False
                    EnableReportToMicrosoft                = $True
                    EnableThirdPartyAddress                = $False
                    EnableUserEmailNotification            = $False
                    PostSubmitMessageEnabled               = $True
                    PreSubmitMessageEnabled                = $True
                    ReportJunkToCustomizedAddress          = $False
                    ReportNotJunkToCustomizedAddress       = $False
                    ReportPhishToCustomizedAddress         = $False
                }

                Mock -CommandName Get-ReportSubmissionPolicy -MockWith {
                    return @{
                        Ensure                                 = 'Present'
                        Credential                             = $Credential
                        IsSingleInstance                       = 'Yes'
                        DisableQuarantineReportingOption       = $False
                        EnableCustomNotificationSender         = $False
                        EnableOrganizationBranding             = $False
                        EnableReportToMicrosoft                = $False
                        EnableThirdPartyAddress                = $False
                        EnableUserEmailNotification            = $False
                        PostSubmitMessageEnabled               = $False
                        PreSubmitMessageEnabled                = $False
                        ReportJunkToCustomizedAddress          = $False
                        ReportNotJunkToCustomizedAddress       = $False
                        ReportPhishToCustomizedAddress         = $False
                    }
                }

                Mock -CommandName Set-ReportSubmissionPolicy -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Successfully call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Set-ReportSubmissionPolicy' -Exactly 1
            }
        }

        Context -Name 'ReportSubmissionPolicy removal.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                  = 'Absent'
                    Credential              = $Credential
                    IsSingleInstance        = 'Yes'
                    EnableReportToMicrosoft = $True
                }

                Mock -CommandName Get-ReportSubmissionPolicy -MockWith {
                    return @{
                        EnableReportToMicrosoft = $True
                    }
                }

                Mock -CommandName Remove-ReportSubmissionPolicy -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the Policy in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Remove-ReportSubmissionPolicy' -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-ReportSubmissionPolicy -MockWith {
                    return @{
                        DisableQuarantineReportingOption       = $False
                        EnableCustomNotificationSender         = $False
                        EnableOrganizationBranding             = $False
                        EnableReportToMicrosoft                = $True
                        EnableThirdPartyAddress                = $False
                        EnableUserEmailNotification            = $False
                        PostSubmitMessageEnabled               = $True
                        PreSubmitMessageEnabled                = $True
                        ReportJunkToCustomizedAddress          = $False
                        ReportNotJunkToCustomizedAddress       = $False
                        ReportPhishToCustomizedAddress         = $False
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
