[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Microsoft365.psm1" `
            -Resolve)
)
$GenericStubPath = (Join-Path -Path $PSScriptRoot `
    -ChildPath "..\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "PlannerTask" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Connect-Graph -MockWith {
        }

        Mock -CommandName New-MGPlannerTask -MockWith {
        }

        Mock -CommandName Update-MGPlannerTask -MockWith {
        }

        Mock -CommandName New-M365DSCConnection -MockWith {
        }

        # Test contexts
        Context -Name "When the Task doesn't exist but it should" -Fixture {

            Mock -CommandName Get-MgPlannerTask -MockWith {
                return $null
            }
            $testParams = @{
                PlanId                = "1234567890"
                Title                 = "Contoso Task"
                Priority              = 5
                PercentComplete       = 75
                StartDateTime         = "2020-06-09"
                Ensure                = "Present"
                ApplicationId         = "1234567890"
                TenantId              = "1234567890"
                CertificateThumbprint = "1234567890"
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should create the Task in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName New-MGPlannerTask -Exactly 1
            }
        }

        Context -Name "Task exists and is NOT in the Desired State" -Fixture {
            Mock -CommandName Get-MgPlannerTask -MockWith {
                return @{
                    PlanId                = "1234567890"
                    Title                 = "Contoso Task"
                    Id                    = "12345"
                    Priority              = 6 # Drift
                    PercentComplete       = 75
                    StartDateTime         = "2020-06-09"
                }
            }
            $testParams = @{
                PlanId                = "1234567890"
                TaskId                = "12345"
                Title                 = "Contoso Task"
                Priority              = 5
                PercentComplete       = 75
                StartDateTime         = "2020-06-09"
                Ensure                = "Present"
                ApplicationId         = "1234567890"
                TenantId              = "1234567890"
                CertificateThumbprint = "1234567890"
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $False
            }

            It "Should update the settings from the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Update-MGPlannerTask -Exactly 1
            }
        }

        Context -Name "Task exists and is IN the Desired State" -Fixture {
            Mock -CommandName Get-MgPlannerTask -MockWith {
                return @{
                    PlanId                = "1234567890"
                    Title                 = "Contoso Task"
                    Priority              = 5
                    Id                    = "12345"
                    PercentComplete       = 75
                    StartDateTime         = "2020-06-09"
                }
            }
            $testParams = @{
                PlanId                = "1234567890"
                Title                 = "Contoso Task"
                TaskId                = "12345"
                Priority              = 5
                PercentComplete       = 75
                StartDateTime         = "2020-06-09"
                Ensure                = "Present"
                ApplicationId         = "1234567890"
                TenantId              = "1234567890"
                CertificateThumbprint = "1234567890"
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }

            It "Should return true from the Set method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "Task exists but it should not" -Fixture {
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
            $testParams = @{
                PlanId                = "1234567890"
                Title                 = "Contoso Task"
                TaskId                = "12345"
                Priority              = 5
                PercentComplete       = 75
                StartDateTime         = "2020-06-09"
                Ensure                = "Absent"
                ApplicationId         = "1234567890"
                TenantId              = "1234567890"
                CertificateThumbprint = "1234567890"
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }

            It "Should return false from the Set method" {
                Test-TargetResource @testParams | Should Be $False
            }
        }

        Context -Name "Task is need to be part of a Bucket by ID and is in Desired State" -Fixture {
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
                TenantId              = "1234567890"
                CertificateThumbprint = "1234567890"
            }

            It "Should return 'Bucket12345' as the Bucket Value" {
                (Get-TargetResource @testParams).Bucket | Should Be 'Bucket12345'
            }

            It "Should return True from the Test method" {
                Test-TargetResource @testParams | Should Be $True
            }
        }

        Context -Name "Task is need to be part of a Bucket by Name and is in Desired State" -Fixture {
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
                TenantId              = "1234567890"
                CertificateThumbprint = "1234567890"
            }

            It "Should return 'TestBucket' as the Bucket Value" {
                (Get-TargetResource @testParams).Bucket | Should Be 'TestBucket'
            }

            It "Should return True from the Test method" {
                Test-TargetResource @testParams | Should Be $True
            }
        }

        Context -Name "Task is need to be part of a Bucket by Name and is NOT" -Fixture {
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
                return @{
                    Id                    = "Bucket12345"
                    Name                  = "TestBucket"
                }
            }

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
                TenantId              = "1234567890"
                CertificateThumbprint = "1234567890"
            }

            It "Should return 'TestBucket' as the Bucket Value" {
                (Get-TargetResource @testParams).Bucket | Should Be $null
            }

            It "Should return True from the Test method" {
                Test-TargetResource @testParams | Should Be $False
            }
        }

        Context -Name "Task should not be part of a Bucket but it IS" -Fixture {
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

            $testParams = @{
                PlanId                = "1234567890"
                TaskId                = "12345"
                Title                 = "Contoso Task"
                Priority              = 5
                PercentComplete       = 75
                StartDateTime         = "2020-06-09"
                Ensure                = "Present"
                ApplicationId         = "1234567890"
                TenantId              = "1234567890"
                CertificateThumbprint = "1234567890"
            }

            It "Should return 'TestBucket' as the Bucket Value" {
                (Get-TargetResource @testParams).Bucket | Should Be 'Bucket12345'
            }

            It "Should return False from the Test method" {
                Test-TargetResource @testParams | Should Be $False
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            Mock -CommandName Get-MgPlannerTask -MockWith {
                return @{
                    PlanId                = "1234567890"
                    Title                 = "Contoso Task"
                    Priority              = 5
                    PercentComplete       = 75
                    StartDateTime         = "2020-06-09"
                }
            }
            $testParams = @{
                ApplicationId         = "1234567890"
                TenantId              = "1234567890"
                CertificateThumbprint = "1234567890"
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
