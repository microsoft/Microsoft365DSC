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

$CurrentScriptPath = $PSCommandPath.Split('\')
$CurrentScriptName = $CurrentScriptPath[$CurrentScriptPath.Length -1]
$ResourceName      = $CurrentScriptName.Split('.')[1]
$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource $ResourceName -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name "The instance should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    BillingAccount        = "1e5b9e50-a1ea-581e-fb3a-778b93a06854:6487d5cf-0a7b-42e6-9549-23cavvvvvvv_2019-05-31";
                    DisplayName           = "MyAction";
                    Notification          = (New-CimInstance -ClassName MSFT_AzureBillingAccountScheduledActionNotification -Property @{
                        subject = 'Cost Alert'
                        message = 'This is my demo message!'
                        to = @('john.smith@contoso.com')
                    } -ClientOnly)
                    NotificationEmail     = "alert@contoso.com";
                    Schedule              = (New-CIMInstance -ClassName MSFT_AzureBillingAccountScheduledActionSchedule -Property @{
                        daysOfWeek = @('Wednesday')
                        startDate = '2024-11-06T13:00:00Z'
                        endDate = '2025-11-06T05:00:00Z'
                        frequency = 'Weekly'
                        dayOfMonth = 0
                        hourOfDay = 13
                    } -ClientOnly)
                    Status                = "Enabled";
                    View                  = "/providers/Microsoft.Billing/billingAccounts/xxxxx:xxxxx_xxxxx/providers/Microsoft.CostManagement/views/ms:AccumulatedCosts";
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                Mock -CommandName Invoke-AzRest -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create a new instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Invoke-AzRest -Exactly 2
            }
        }

        Context -Name "The instance exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    BillingAccount        = "1e5b9e50-a1ea-581e-fb3a-778b93a06854:6487d5cf-0a7b-42e6-9549-23cavvvvvvv_2019-05-31";
                    DisplayName           = "MyAction";
                    Notification          = (New-CimInstance -ClassName MSFT_AzureBillingAccountScheduledActionNotification -Property @{
                        subject = 'Cost Alert'
                        message = 'This is my demo message!'
                        to = @('john.smith@contoso.com')
                    } -ClientOnly)
                    NotificationEmail     = "alert@contoso.com";
                    Schedule              = (New-CIMInstance -ClassName MSFT_AzureBillingAccountScheduledActionSchedule -Property @{
                        daysOfWeek = @('Wednesday')
                        startDate = '2024-11-06T13:00:00Z'
                        endDate = '2025-11-06T05:00:00Z'
                        frequency = 'Weekly'
                        dayOfMonth = 0
                        hourOfDay = 13
                    } -ClientOnly)
                    Status                = "Enabled";
                    View                  = "/providers/Microsoft.Billing/billingAccounts/xxxxx:xxxxx_xxxxx/providers/Microsoft.CostManagement/views/ms:AccumulatedCosts";
                    Ensure              = 'Absent'
                    Credential          = $Credential;
                }

                Mock -CommandName Invoke-AzRest -MockWith {
                    return @{
                        content = ConvertTo-Json(
                            @{
                                value = @(
                                @{
                                    id = "12345-12345-12345-12345-12345"
                                    name = 'MyAction'
                                    kind = "Email"
                                    properties = @{
                                        displayName = "MyAction"
                                        scope = "/providers/Microsoft.Billing/billingAccounts/1e5b9e50-a1ea-581e-fb3a-778b93a06854:6487d5cf-0a7b-42e6-9549-23cavvvvvvv_2019-05-31"
                                        status = "Enabled"
                                        viewId = "/providers/Microsoft.Billing/billingAccounts/xxxxx:xxxxx_xxxxx/providers/Microsoft.CostManagement/views/ms:AccumulatedCosts";
                                        schedule = @{
                                            daysOfWeek = @('Wednesday')
                                            startDate = '2024-11-06T13:00:00Z'
                                            endDate = '2025-11-06T05:00:00Z'
                                            frequency = 'Weekly'
                                            dayOfMonth = 0
                                            hourOfDay = 13
                                        }
                                        notification = @{
                                            subject = 'Cost Alert'
                                            message = 'This is my demo message!'
                                            to = @('john.smith@contoso.com')
                                        }
                                        notificationEmail = "alert@contoso.com";
                                    }
                                }
                                )
                            }
                        ) -Depth 10 -Compress
                    }
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Invoke-AzRest -Exactly 2
            }
        }

        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    BillingAccount        = "1e5b9e50-a1ea-581e-fb3a-778b93a06854:6487d5cf-0a7b-42e6-9549-23cavvvvvvv_2019-05-31";
                    DisplayName           = "MyAction";
                    Notification          = (New-CimInstance -ClassName MSFT_AzureBillingAccountScheduledActionNotification -Property @{
                        subject = 'Cost Alert'
                        message = 'This is my demo message!'
                        to = @('john.smith@contoso.com')
                    } -ClientOnly)
                    NotificationEmail     = "alert@contoso.com";
                    Schedule              = (New-CIMInstance -ClassName MSFT_AzureBillingAccountScheduledActionSchedule -Property @{
                        daysOfWeek = @('Wednesday')
                        startDate = '2024-11-06T13:00:00Z'
                        endDate = '2025-11-06T05:00:00Z'
                        frequency = 'Weekly'
                        dayOfMonth = 0
                        hourOfDay = 13
                    } -ClientOnly)
                    Status                = "Enabled";
                    View                  = "/providers/Microsoft.Billing/billingAccounts/xxxxx:xxxxx_xxxxx/providers/Microsoft.CostManagement/views/ms:AccumulatedCosts";
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                Mock -CommandName Invoke-AzRest -MockWith {
                    return @{
                        content = ConvertTo-Json(
                            @{
                                value = @(
                                @{
                                    id = "12345-12345-12345-12345-12345"
                                    name = 'MyAction'
                                    kind = "Email"
                                    properties = @{
                                        displayName = "MyAction"
                                        scope = "/providers/Microsoft.Billing/billingAccounts/1e5b9e50-a1ea-581e-fb3a-778b93a06854:6487d5cf-0a7b-42e6-9549-23cavvvvvvv_2019-05-31"
                                        status = "Enabled"
                                        viewId = "/providers/Microsoft.Billing/billingAccounts/xxxxx:xxxxx_xxxxx/providers/Microsoft.CostManagement/views/ms:AccumulatedCosts";
                                        schedule = @{
                                            daysOfWeek = @('Wednesday')
                                            startDate = '2024-11-06T13:00:00Z'
                                            endDate = '2025-11-06T05:00:00Z'
                                            frequency = 'Weekly'
                                            dayOfMonth = 0
                                            hourOfDay = 13
                                        }
                                        notification = @{
                                            subject = 'Cost Alert'
                                            message = 'This is my demo message!'
                                            to = @('john.smith@contoso.com')
                                        }
                                        notificationEmail = "alert@contoso.com";
                                    }
                                }
                                )
                            }
                        ) -Depth 10 -Compress
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The instance exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    BillingAccount        = "1e5b9e50-a1ea-581e-fb3a-778b93a06854:6487d5cf-0a7b-42e6-9549-23cavvvvvvv_2019-05-31";
                    DisplayName           = "MyAction";
                    Notification          = (New-CimInstance -ClassName MSFT_AzureBillingAccountScheduledActionNotification -Property @{
                        subject = 'Cost Alert'
                        message = 'This is my demo message!'
                        to = @('john.smith@contoso.com')
                    } -ClientOnly)
                    NotificationEmail     = "alert@contoso.com";
                    Schedule              = (New-CIMInstance -ClassName MSFT_AzureBillingAccountScheduledActionSchedule -Property @{
                        daysOfWeek = @('Wednesday')
                        startDate = '2024-11-06T13:00:00Z'
                        endDate = '2025-11-06T05:00:00Z'
                        frequency = 'Weekly'
                        dayOfMonth = 0
                        hourOfDay = 13
                    } -ClientOnly)
                    Status                = "Disabled"; # Drift
                    View                  = "/providers/Microsoft.Billing/billingAccounts/xxxxx:xxxxx_xxxxx/providers/Microsoft.CostManagement/views/ms:AccumulatedCosts";
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                Mock -CommandName Invoke-AzRest -MockWith {
                    return @{
                        content = ConvertTo-Json(
                            @{
                                value = @(
                                @{
                                    id = "12345-12345-12345-12345-12345"
                                    name = 'MyAction'
                                    kind = "Email"
                                    properties = @{
                                        displayName = "MyAction"
                                        scope = "/providers/Microsoft.Billing/billingAccounts/1e5b9e50-a1ea-581e-fb3a-778b93a06854:6487d5cf-0a7b-42e6-9549-23cavvvvvvv_2019-05-31"
                                        status = "Enabled"
                                        viewId = "/providers/Microsoft.Billing/billingAccounts/xxxxx:xxxxx_xxxxx/providers/Microsoft.CostManagement/views/ms:AccumulatedCosts";
                                        schedule = @{
                                            daysOfWeek = @('Wednesday')
                                            startDate = '2024-11-06T13:00:00Z'
                                            endDate = '2025-11-06T05:00:00Z'
                                            frequency = 'Weekly'
                                            dayOfMonth = 0
                                            hourOfDay = 13
                                        }
                                        notification = @{
                                            subject = 'Cost Alert'
                                            message = 'This is my demo message!'
                                            to = @('john.smith@contoso.com')
                                        }
                                        notificationEmail = "alert@contoso.com";
                                    }
                                }
                                )
                            }
                        ) -Depth 10 -Compress
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Invoke-AzRest -Exactly 2
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential  = $Credential;
                }

                Mock -CommandName Get-M365DSCAzureBillingAccount -MockWith {
                    return @{
                        value = @{
                            name = "1e5b9e50-a1ea-581e-fb3a-778b93a06854:6487d5cf-0a7b-42e6-9549-23cavvvvvvv_2019-05-31"
                            properties = @{
                                displayName = "MyBillingAccount"
                            }
                        }
                    }
                }
                Mock -CommandName Invoke-AzRest -MockWith {
                    return @{
                        content = ConvertTo-Json(
                            @{
                                value = @(
                                @{
                                    id = "12345-12345-12345-12345-12345"
                                    name = 'MyAction'
                                    kind = "Email"
                                    properties = @{
                                        displayName = "MyAction"
                                        scope = "/providers/Microsoft.Billing/billingAccounts/1e5b9e50-a1ea-581e-fb3a-778b93a06854:6487d5cf-0a7b-42e6-9549-23cavvvvvvv_2019-05-31"
                                        status = "Enabled"
                                        viewId = "/providers/Microsoft.Billing/billingAccounts/xxxxx:xxxxx_xxxxx/providers/Microsoft.CostManagement/views/ms:AccumulatedCosts";
                                        schedule = @{
                                            daysOfWeek = @('Wednesday')
                                            startDate = '2024-11-06T13:00:00Z'
                                            endDate = '2025-11-06T05:00:00Z'
                                            frequency = 'Weekly'
                                            dayOfMonth = 0
                                            hourOfDay = 13
                                        }
                                        notification = @{
                                            subject = 'Cost Alert'
                                            message = 'This is my demo message!'
                                            to = @('john.smith@contoso.com')
                                        }
                                        notificationEmail = "alert@contoso.com";
                                    }
                                }
                                )
                            }
                        ) -Depth 10 -Compress
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
