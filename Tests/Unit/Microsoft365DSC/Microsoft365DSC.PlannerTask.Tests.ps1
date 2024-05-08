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
    -DscResource 'PlannerTask' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString ((New-Guid).ToString()) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName Connect-Graph -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgUser -MockWith {
                return @{
                    UserPrincipalName = 'john.smith@contoso.com'
                    Id                = '12345-12345-12345-12345-12345'
                }
            }
        }

        # Test contexts
        Context -Name "When the Task doesn't exist but it should" -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId          = '1234567890'
                    Title           = 'Contoso Task'
                    Priority        = 5
                    Bucket          = '1234'
                    PercentComplete = 75
                    StartDateTime   = '2020-06-09'
                    DueDateTime     = '2020-06-10'
                    AssignedUsers   = @('john.smith@contoso.com')
                    Ensure          = 'Present'
                    Credential      = $Credential
                }

                Mock -CommandName Get-MgPlannerTask -MockWith {
                    return $null
                }

                Mock -CommandName Get-MgPlannerTaskDetail -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the Task in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Task exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId          = '1234567890'
                    TaskId          = '12345'
                    Title           = 'Contoso Task'
                    Priority        = 4
                    AssignedUsers   = @('john.smith@contoso.com')
                    PercentComplete = 75
                    Categories      = @('Pink')
                    StartDateTime   = '2020-06-09'
                    DueDateTime     = '2020-06-10'
                    Ensure          = 'Present'
                    Credential      = $Credential
                }

                Mock -CommandName Get-MgPlannerTask -MockWith {
                    return @{
                        PlanId          = '1234567890'
                        Title           = 'Contoso Task'
                        Id              = '12345'
                        Priority        = 5
                        PercentComplete = 75
                        StartDateTime   = '2020-06-09'
                    }
                }

                Mock -CommandName Get-MgPlannerTaskDetail -MockWith {
                    return @{
                        CheckList = @()
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $False
            }

            It 'Should update the settings from the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Task exists and is IN the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId          = '1234567890'
                    Title           = 'Contoso Task'
                    TaskId          = '12345'
                    Priority        = 5
                    AssignedUsers   = @('john.smith@contoso.com')
                    PercentComplete = 75
                    Categories      = @('Pink')
                    StartDateTime   = '2020-06-09'
                    DueDateTime     = '2020-06-10'
                    Bucket          = 'Bucket12345'
                    Ensure          = 'Present'
                    Credential      = $Credential
                }

                Mock -CommandName Get-MgPlannerTask -MockWith {
                    return @{
                        PlanId          = '1234567890'
                        Title           = 'Contoso Task'
                        Priority        = 5
                        Id              = '12345'
                        PercentComplete = 75
                        StartDateTime   = '2020-06-09'
                        DueDateTime     = '2020-06-10'
                        BucketId        = 'Bucket12345'
                        Assignments     = @{
                            AdditionalProperties = @{
                                'john.smith@contoso.com' = @{}
                            }
                        }
                        AppliedCategories = @{
                            AdditionalProperties = @{
                                Category1 = $true
                            }
                        }
                    }
                }

                Mock -CommandName Get-MgPlannerTaskDetail -MockWith {
                    return @{
                        CheckList = @()
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Set method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Task exists but it should not' -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId          = '1234567890'
                    Title           = 'Contoso Task'
                    TaskId          = '12345'
                    Priority        = 5
                    AssignedUsers   = @('john.smith@contoso.com')
                    PercentComplete = 75
                    Categories      = @('Pink')
                    StartDateTime   = '2020-06-09'
                    DueDateTime     = '2020-06-10'
                    Ensure          = 'Absent'
                    Credential      = $Credential
                }

                Mock -CommandName Get-MgPlannerTask -MockWith {
                    return @{
                        PlanId          = '1234567890'
                        Title           = 'Contoso Task'
                        Priority        = 5
                        Id              = '12345'
                        PercentComplete = 75
                        StartDateTime   = '2020-06-09'
                        DueDateTime     = '2020-06-10'
                        BucketId        = 'Bucket12345'
                        Assignments     = @{
                            AdditionalProperties = @{
                                'john.smith@contoso.com' = @{}
                            }
                        }
                        AppliedCategories = @{
                            AdditionalProperties = @{
                                Category1 = $true
                            }
                        }
                    }
                }

                Mock -CommandName Get-MgPlannerTaskDetail -MockWith {
                    return @{
                        CheckList = @()
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Set method' {
                Test-TargetResource @testParams | Should -Be $False
            }
        }

        Context -Name 'Task is need to be part of a Bucket by ID and is in Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId          = '1234567890'
                    TaskId          = '12345'
                    Title           = 'Contoso Task'
                    Bucket          = 'Bucket12345'
                    Priority        = 5
                    AssignedUsers   = @('john.smith@contoso.com')
                    PercentComplete = 75
                    Categories      = @('Pink')
                    StartDateTime   = '2020-06-09'
                    DueDateTime     = '2020-06-10'
                    Ensure          = 'Present'
                    Credential      = $Credential
                }

                Mock -CommandName Get-MgPlannerTask -MockWith {
                    return @{
                        PlanId          = '1234567890'
                        Title           = 'Contoso Task'
                        Priority        = 5
                        Id              = '12345'
                        PercentComplete = 75
                        StartDateTime   = '2020-06-09'
                        DueDateTime     = '2020-06-10'
                        BucketId        = 'Bucket12345'
                        Assignments     = @{
                            AdditionalProperties = @{
                                'john.smith@contoso.com' = @{}
                            }
                        }
                        AppliedCategories = @{
                            AdditionalProperties = @{
                                Category1 = $true
                            }
                        }
                    }
                }

                Mock -CommandName Get-MgPlannerPlanBucket -MockWith {
                    return @{
                        Id   = 'Bucket12345'
                        Name = 'TestBucket'
                    }
                }

                Mock -CommandName Get-MgPlannerTaskDetail -MockWith {
                    return @{
                        CheckList = @()
                    }
                }
            }

            It "Should return 'Bucket12345' as the Bucket Value" {
                (Get-TargetResource @testParams).Bucket | Should -Be 'Bucket12345'
            }

            It 'Should return True from the Test method' {
                Test-TargetResource @testParams | Should -Be $True
            }
        }


        Context -Name 'Task is need to be part of a Bucket by Name and is NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId          = '1234567890'
                    TaskId          = '12345'
                    Title           = 'Contoso Task'
                    Bucket          = 'TestBucket'
                    Priority        = 5
                    AssignedUsers   = @('john.smith@contoso.com')
                    PercentComplete = 75
                    Categories      = @('Pink')
                    StartDateTime   = '2020-06-09'
                    DueDateTime     = '2020-06-10'
                    Ensure          = 'Present'
                    Credential      = $Credential
                }

                Mock -CommandName Get-MgPlannerTask -MockWith {
                    return @{
                        PlanId          = '1234567890'
                        Title           = 'Contoso Task'
                        Id              = '12345'
                        Priority        = 5
                        PercentComplete = 75
                        StartDateTime   = '2020-06-09'
                    }
                }

                Mock -CommandName Get-MgPlannerPlanBucket -MockWith {
                    return $null
                }

                Mock -CommandName Get-MgPlannerTaskDetail -MockWith {
                    return @{
                        CheckList = @()
                    }
                }
            }

            It 'Should return True from the Test method' {
                Test-TargetResource @testParams | Should -Be $False
            }
        }

        Context -Name 'Task should not be part of a Bucket but it IS' -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId          = '1234567890'
                    TaskId          = '12345'
                    Title           = 'Contoso Task'
                    Priority        = 5
                    AssignedUsers   = @('john.smith@contoso.com')
                    PercentComplete = 75
                    Categories      = @('Pink')
                    StartDateTime   = '2020-06-09'
                    DueDateTime     = '2020-06-10'
                    Ensure          = 'Present'
                    Credential      = $Credential
                }

                Mock -CommandName Get-MgPlannerTask -MockWith {
                    return @{
                        PlanId          = '1234567890'
                        Title           = 'Contoso Task'
                        BucketId        = 'Bucket12345'
                        Id              = '12345'
                        Priority        = 5
                        PercentComplete = 75
                        StartDateTime   = '2020-06-09'
                    }
                }

                Mock -CommandName Get-MgPlannerPlanBucket -MockWith {
                    return @{
                        Id   = 'Bucket12345'
                        Name = 'TestBucket'
                    }
                }

                Mock -CommandName Get-MgPlannerTaskDetail -MockWith {
                    return @{
                        CheckList = @()
                    }
                }
            }

            It "Should return 'TestBucket' as the Bucket Value" {
                (Get-TargetResource @testParams).Bucket | Should -Be 'Bucket12345'
            }

            It 'Should return False from the Test method' {
                Test-TargetResource @testParams | Should -Be $False
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @(
                        @{
                            DisplayName = 'Contoso Group'
                            Id          = '12345-12345-12345-12345-12345'
                        }
                    )
                }

                Mock -CommandName Get-MgGroupPlannerPlan -MockWith {
                    return @{
                        Title = 'Contoso Plan'
                        Id    = '1234567890'
                        Owner = '12345-12345-12345-12345-12345'
                    }
                }

                Mock -CommandName Get-MgGroupPlannerPlanTask -MockWith {
                    return @(
                        @{
                            PlanId          = '1234567890'
                            Title           = 'Contoso Task'
                            Priority        = 5
                            PercentComplete = 75
                            StartDateTime   = '2020-06-09'
                        }
                    )
                }

                Mock -CommandName Get-MgPlannerTaskDetail -MockWith {
                    return @{
                        CheckList = @()
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
