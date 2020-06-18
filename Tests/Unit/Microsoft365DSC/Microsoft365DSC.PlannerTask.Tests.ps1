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
    -DscResource "PlannerTask" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Connect-Graph -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the Task doesn't exist but it should" -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId                = "1234567890"
                    Title                 = "Contoso Task"
                    Priority              = 5
                    PercentComplete       = 75
                    StartDateTime         = "2020-06-09"
                    Ensure                = "Present"
                    ApplicationId         = "1234567890"
                    GlobalAdminAccount    = $GlobalAdminAccount
                }

                Mock -CommandName Get-MgPlannerTask -MockWith {
                    return $null
                }
                try
                {
                    Add-Type -TypeDefinition @"
                        public class PlannerTaskObject
                        {
                            public string Title {get;set;}
                            public string PlanId {get;set;}
                            public string TaskId {
                                get{ return "12345"; }
                                set{}
                            }
                            public string Notes {get;set;}
                            public string BucketId {
                                get{ return "Bucket12345"; }
                                set{}
                            }
                            public string ETag {get;set;}
                            public string[] Assignments {get;set;}
                            public System.Collections.Hashtable[] Attachments {get;set;}
                            public System.Collections.Hashtable[] Checklist {get;set;}
                            public string StartDateTime {
                                get{ return "2020-06-09"; }
                                set{}
                            }
                            public string DueDateTime {get;set;}
                            public string[] Categories {get;set;}
                            public string CompletedDateTime {get;set;}
                            public int PercentComplete {
                                get{ return 75; }
                                set{}
                            }
                            public int Priority {
                                get { return 5; }
                                set {}
                            }
                            public string ConversationThreadId {get;set;}
                            public string OrderHint {get;set;}
                            public void Create(System.Management.Automation.PSCredential GlobalAdminAccount, string ApplicationId){}
                            public void Update(System.Management.Automation.PSCredential GlobalAdminAccount, string ApplicationId){}
                            public string GetTaskCategoryNameByColor(string ColorName){return "";}
                            public string GetTaskColorNameByCategory(string CategoryName){return "";}
                            public void PopulateById(System.Management.Automation.PSCredential GlobalAdminAccount, string ApplicationId, string TaskId){}
                            public void UpdateDetails(System.Management.Automation.PSCredential GlobalAdminAccount, string ApplicationId){}
                            public void Delete(System.Management.Automation.PSCredential GlobalAdminAccount, string ApplicationId, string TaskId){}
                        }
"@
                }
                catch
                {
                    throw $_
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should create the Task in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Task exists and is NOT in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId                = "1234567890"
                    TaskId                = "12345"
                    Title                 = "Contoso Task"
                    Priority              = 4
                    PercentComplete       = 75
                    StartDateTime         = "2020-06-09"
                    Ensure                = "Present"
                    ApplicationId         = "1234567890"
                    GlobalAdminAccount    = $GlobalAdminAccount
                }

                Mock -CommandName Get-MgPlannerTask -MockWith {
                    return @{
                        PlanId                = "1234567890"
                        Title                 = "Contoso Task"
                        Id                    = "12345"
                        Priority              = 5
                        PercentComplete       = 75
                        StartDateTime         = "2020-06-09"
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $False
            }

            It "Should update the settings from the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Task exists and is IN the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId                = "1234567890"
                    Title                 = "Contoso Task"
                    TaskId                = "12345"
                    Priority              = 5
                    PercentComplete       = 75
                    StartDateTime         = "2020-06-09"
                    Bucket                = 'Bucket12345'
                    Ensure                = "Present"
                    ApplicationId         = "1234567890"
                    GlobalAdminAccount    = $GlobalAdminAccount
                }

                Mock -CommandName Get-MgPlannerTask -MockWith {
                    return @{
                        PlanId                = "1234567890"
                        Title                 = "Contoso Task"
                        Priority              = 5
                        Id                    = "12345"
                        PercentComplete       = 75
                        StartDateTime         = "2020-06-09"
                        BucketId              = 'Bucket12345'
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return true from the Set method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "Task exists but it should not" -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId                = "1234567890"
                    Title                 = "Contoso Task"
                    TaskId                = "12345"
                    Priority              = 5
                    PercentComplete       = 75
                    StartDateTime         = "2020-06-09"
                    Ensure                = "Absent"
                    ApplicationId         = "1234567890"
                    GlobalAdminAccount    = $GlobalAdminAccount
                }

                Mock -CommandName Get-MgPlannerTask -MockWith {
                    return @{
                        PlanId                = "1234567890"
                        Title                 = "Contoso Task"
                        Id                    = "12345"
                        Priority              = 5
                        PercentComplete       = 75
                        StartDateTime         = "2020-06-09"
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Set method" {
                Test-TargetResource @testParams | Should -Be $False
            }
        }

        Context -Name "Task is need to be part of a Bucket by ID and is in Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId                = "1234567890"
                    TaskId                = "12345"
                    Title                 = "Contoso Task"
                    Bucket                = "Bucket12345"
                    Priority              = 5
                    PercentComplete       = 75
                    StartDateTime         = "2020-06-09"
                    Ensure                = "Present"
                    ApplicationId         = "1234567890"
                    GlobalAdminAccount    = $GlobalAdminAccount
                }

                Mock -CommandName Get-MgPlannerTask -MockWith {
                    return @{
                        PlanId                = "1234567890"
                        Title                 = "Contoso Task"
                        BucketId              = "Bucket12345"
                        Id                    = "12345"
                        Priority              = 5
                        PercentComplete       = 75
                        StartDateTime         = "2020-06-09"
                    }
                }

                Mock -CommandName Get-MgPlannerPlanBucket -MockWith {
                    return @{
                        Id                    = "Bucket12345"
                        Name                  = "TestBucket"
                    }
                }
            }

            It "Should return 'Bucket12345' as the Bucket Value" {
                (Get-TargetResource @testParams).Bucket | Should -Be 'Bucket12345'
            }

            It "Should return True from the Test method" {
                Test-TargetResource @testParams | Should -Be $True
            }
        }


        Context -Name "Task is need to be part of a Bucket by Name and is NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId                = "1234567890"
                    TaskId                = "12345"
                    Title                 = "Contoso Task"
                    Bucket                = "TestBucket"
                    Priority              = 5
                    PercentComplete       = 75
                    StartDateTime         = "2020-06-09"
                    Ensure                = "Present"
                    ApplicationId         = "1234567890"
                    GlobalAdminAccount    = $GlobalAdminAccount
                }

                Mock -CommandName Get-MgPlannerTask -MockWith {
                    return @{
                        PlanId                = "1234567890"
                        Title                 = "Contoso Task"
                        Id                    = "12345"
                        Priority              = 5
                        PercentComplete       = 75
                        StartDateTime         = "2020-06-09"
                    }
                }

                Mock -CommandName Get-MgPlannerPlanBucket -MockWith {
                    return $null
                }
            }

            It "Should return True from the Test method" {
                Test-TargetResource @testParams | Should -Be $False
            }
        }

        Context -Name "Task should not be part of a Bucket but it IS" -Fixture {
            BeforeAll {
                $testParams = @{
                    PlanId                = "1234567890"
                    TaskId                = "12345"
                    Title                 = "Contoso Task"
                    Priority              = 5
                    PercentComplete       = 75
                    StartDateTime         = "2020-06-09"
                    Ensure                = "Present"
                    ApplicationId         = "1234567890"
                    GlobalAdminAccount    = $GlobalAdminAccount
                }

                Mock -CommandName Get-MgPlannerTask -MockWith {
                    return @{
                        PlanId                = "1234567890"
                        Title                 = "Contoso Task"
                        BucketId              = "Bucket12345"
                        Id                    = "12345"
                        Priority              = 5
                        PercentComplete       = 75
                        StartDateTime         = "2020-06-09"
                    }
                }

                Mock -CommandName Get-MgPlannerPlanBucket -MockWith {
                    return @{
                        Id                    = "Bucket12345"
                        Name                  = "TestBucket"
                    }
                }
            }

            It "Should return 'TestBucket' as the Bucket Value" {
                (Get-TargetResource @testParams).Bucket | Should -Be 'Bucket12345'
            }

            It "Should return False from the Test method" {
                Test-TargetResource @testParams | Should -Be $False
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplicationId         = "1234567890"
                    GlobalAdminAccount    = $GlobalAdminAccount
                }

                Mock -CommandName Get-MgPlannerTask -MockWith {
                    return @{
                        PlanId                = "1234567890"
                        Title                 = "Contoso Task"
                        Priority              = 5
                        PercentComplete       = 75
                        StartDateTime         = "2020-06-09"
                    }
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
