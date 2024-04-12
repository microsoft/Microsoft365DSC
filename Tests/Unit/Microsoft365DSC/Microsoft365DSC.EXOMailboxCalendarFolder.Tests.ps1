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
    -DscResource 'EXOMailboxCalendarFolder' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Set-MailboxCalendarFolder -MockWith {
                return $null
            }

            Mock -CommandName Get-Mailbox -MockWith {
                return @{
                    Id                = '12345-12345-12345-12345-12345'
                    UserPrincipalName = "Bob.Houle@contoso.com"
                }
            }
        }

        # Test contexts
        Context -Name 'Settings are not in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    DetailLevel          = "AvailabilityOnly";
                    Ensure               = "Present";
                    Identity             = "john.smith:\Calendar";
                    PublishDateRangeFrom = "ThreeMonths";
                    PublishDateRangeTo   = "ThreeMonths";
                    PublishEnabled       = $False;
                    SearchableUrlEnabled = $False;
                }

                Mock -CommandName Get-MailboxCalendarFolder -MockWith {
                    return @{
                        DetailLevel          = "AvailabilityOnly";
                        Identity             = "john.smith:\Calendar";
                        PublishDateRangeFrom = "ThreeMonths";
                        PublishDateRangeTo   = "SixMonths"; #Drift
                        PublishEnabled       = $False;
                        SearchableUrlEnabled = $False;
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-MailboxCalendarFolder -Exactly 1
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Settings are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    DetailLevel          = "AvailabilityOnly";
                    Ensure               = "Present";
                    Identity             = "john.smith:\Calendar";
                    PublishDateRangeFrom = "ThreeMonths";
                    PublishDateRangeTo   = "ThreeMonths";
                    PublishEnabled       = $False;
                    SearchableUrlEnabled = $False;
                }

                Mock -CommandName Get-MailboxCalendarFolder -MockWith {
                    return @{
                        DetailLevel          = "AvailabilityOnly";
                        Identity             = "john.smith:\Calendar";
                        PublishDateRangeFrom = "ThreeMonths";
                        PublishDateRangeTo   = "ThreeMonths"
                        PublishEnabled       = $False;
                        SearchableUrlEnabled = $False;
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name "User doesn't exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    DetailLevel          = "AvailabilityOnly";
                    Ensure               = "Present";
                    Identity             = "john.smith:\Calendar";
                    PublishDateRangeFrom = "ThreeMonths";
                    PublishDateRangeTo   = "ThreeMonths";
                    PublishEnabled       = $False;
                    SearchableUrlEnabled = $False;
                }

                Mock -CommandName Get-MailboxCalendarFolder -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MailboxFolderStatistics -MockWith {
                    return @{
                        FolderType  = "Calendar";
                        Name        = "Calendar";
                    }
                }

                Mock -CommandName Get-MailboxCalendarFolder -MockWith {
                    return @{
                        DetailLevel          = "AvailabilityOnly";
                        Identity             = "john.smith:\Calendar";
                        PublishDateRangeFrom = "ThreeMonths";
                        PublishDateRangeTo   = "ThreeMonths"
                        PublishEnabled       = $False;
                        SearchableUrlEnabled = $False;
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
