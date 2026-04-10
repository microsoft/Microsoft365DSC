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
    -DscResource "IntuneAlertRuleWindows365" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-MSCloudLoginConnectionProfile -MockWith {
            }

            Mock -CommandName Reset-MSCloudLoginConnectionProfileContext -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementMonitoringAlertRule -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementMonitoringAlertRule -MockWith {
            }

            $defaultBody = @{
                AlertRuleTemplate = "cloudPcInaccessibleScenario"
                Conditions = @(
                    @{
                        aggregation = "affectedCloudPcPercentage"
                        conditionCategory = "cloudPcConnectionErrors"
                        operator = "greaterOrEqual"
                        relationshipType = "or"
                        thresholdValue = "25"
                    }
                )
                Description = "FakeStringValue"
                DisplayName = "FakeStringValue"
                Enabled = $True
                Id = "00000000-0000-0000-0000-000000000000"
                IsSystemRule = $True
                NotificationChannels = @(
                    @{
                        notificationChannelType = "email"
                        notificationReceivers = @(
                            @{
                                contactInformation = "FakeStringValue"
                                locale = "en-us"
                            }
                        )
                    }
                )
                Severity = "warning"
                Threshold = $null
            }

            Mock -CommandName Get-MgBetaDeviceManagementMonitoringAlertRule -MockWith {
                return $defaultBody
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstance = $null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "The IntuneAlertRuleWindows365 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AlertRuleTemplate = "cloudPcInaccessibleScenario"
                    Conditions = [CimInstance[]]@(
                        New-CimInstance -ClassName MSFT_IntuneAlertRuleCondition -Property @{
                            Aggregation       = "affectedCloudPcPercentage"
                            ConditionCategory = "cloudPcConnectionErrors"
                            Operator          = "greaterOrEqual"
                            RelationshipType  = "or"
                            ThresholdValue = "25"
                        } -ClientOnly
                    )
                    Enabled = $True
                    NotificationChannels = [CimInstance[]]@(
                        New-CimInstance -ClassName MSFT_IntuneAlertRuleNotificationChannel -Property @{
                            NotificationChannelType = "email"
                            NotificationReceivers   = [CimInstance[]]@(
                                New-CimInstance -ClassName MSFT_IntuneAlertRuleNotificationChannelReceiver -Property @{
                                    ContactInformation = "FakeStringValue"
                                    Locale             = "en-us"
                                } -ClientOnly
                            )
                        } -ClientOnly
                    )
                    Severity = "warning"
                    Ensure = "Present"
                    Credential = $Credential;
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneAlertRuleWindows365 exists as default template and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AlertRuleTemplate = "cloudPcInaccessibleScenario"
                    Conditions = [CimInstance[]]@(
                        New-CimInstance -ClassName MSFT_IntuneAlertRuleCondition -Property @{
                            Aggregation       = "affectedCloudPcPercentage"
                            ConditionCategory = "cloudPcConnectionErrors"
                            Operator          = "greaterOrEqual"
                            RelationshipType  = "or"
                            ThresholdValue = "25"
                        } -ClientOnly
                    )
                    Enabled = $False # Drift
                    NotificationChannels = [CimInstance[]]@(
                        New-CimInstance -ClassName MSFT_IntuneAlertRuleNotificationChannel -Property @{
                            NotificationChannelType = "email"
                            NotificationReceivers   = [CimInstance[]]@(
                                New-CimInstance -ClassName MSFT_IntuneAlertRuleNotificationChannelReceiver -Property @{
                                    ContactInformation = "FakeStringValue"
                                    Locale             = "en-us"
                                } -ClientOnly
                            )
                        } -ClientOnly
                    )
                    Severity = "warning"
                    Ensure = "Present"
                    Credential = $Credential;
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
                Should -Invoke -CommandName New-MgBetaDeviceManagementMonitoringAlertRule -Exactly 1
            }
        }

        Context -Name "The IntuneAlertRuleWindows365 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AlertRuleTemplate = "cloudPcInaccessibleScenario"
                    Conditions = [CimInstance[]]@(
                        New-CimInstance -ClassName MSFT_IntuneAlertRuleCondition -Property @{
                            Aggregation       = "affectedCloudPcPercentage"
                            ConditionCategory = "cloudPcConnectionErrors"
                            Operator          = "greaterOrEqual"
                            RelationshipType  = "or"
                            ThresholdValue = "25"
                        } -ClientOnly
                    )
                    Enabled = $False # Drift
                    NotificationChannels = [CimInstance[]]@(
                        New-CimInstance -ClassName MSFT_IntuneAlertRuleNotificationChannel -Property @{
                            NotificationChannelType = "email"
                            NotificationReceivers   = [CimInstance[]]@(
                                New-CimInstance -ClassName MSFT_IntuneAlertRuleNotificationChannelReceiver -Property @{
                                    ContactInformation = "FakeStringValue"
                                    Locale             = "en-us"
                                } -ClientOnly
                            )
                        } -ClientOnly
                    )
                    Severity = "warning"
                    Ensure = "Present"
                    Credential = $Credential;
                }

                $defaultBody.Id = "111111111-1111-1111-1111-111111111111"
                Mock -CommandName Get-MgBetaDeviceManagementMonitoringAlertRule -MockWith {
                    return $defaultBody
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
                Should -Invoke -CommandName Update-MgBetaDeviceManagementMonitoringAlertRule -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
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
