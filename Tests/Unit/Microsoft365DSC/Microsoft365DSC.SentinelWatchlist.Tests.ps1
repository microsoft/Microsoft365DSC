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
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@o365DSC.onmicrosoft.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Get-AzResource -MockWith {
                return @{
                    ResourceGroupName = "MyResourceGroup"
                    Name              = 'MySentinelWorkspace'
                    ResourceId        = "name/part/resourceId/"
                }
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
                    Alias                 = "MyAlias";
                    DefaultDuration       = "P1DT3H";
                    Description           = "My description";
                    DisplayName           = "My Display Name";
                    Ensure                = "Present";
                    ItemsSearchKey        = "Test";
                    Name                  = "MyWatchList";
                    NumberOfLinesToSkip   = 1;
                    RawContent            = 'MyContent'
                    ResourceGroupName     = "MyResourceGroup";
                    SourceType            = "Local";
                    SubscriptionId        = "20f41296-9edc-4374-b5e0-b1c1aa07e7d3";
                    TenantId              = $TenantId;
                    WorkspaceName         = "MyWorkspace";
                    Credential            = $Credential;
                }

                Mock -CommandName Invoke-AzRest -MockWith {
                    return @{
                        statuscode = 200
                    }
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
                Should -Invoke -CommandName Invoke-AzRest -Exactly 1
            }
        }

        Context -Name "The instance exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Alias                 = "MyAlias";
                    DefaultDuration       = "P1DT3H";
                    Description           = "My description";
                    DisplayName           = "My Display Name";
                    Ensure                = "Absent";
                    ItemsSearchKey        = "Test";
                    Name                  = "MyWatchList";
                    NumberOfLinesToSkip   = 1;
                    RawContent            = 'MyContent'
                    ResourceGroupName     = "MyResourceGroup";
                    SourceType            = "Local";
                    SubscriptionId        = "20f41296-9edc-4374-b5e0-b1c1aa07e7d3";
                    TenantId              = $TenantId;
                    WorkspaceName         = "MyWorkspace";
                    Credential            = $Credential;
                }

                Mock -CommandName Invoke-AzRest -MockWith {
                    return @{
                        StatusCode = '200'
                        Content = @"
{"value":[
{
      "id": "/subscriptions/xxxx/resourceGroups/xxxx/providers/Microsoft.OperationalInsights/workspaces/xxxx/providers/Microsoft.SecurityInsights/Watchlists/xxxx",
      "name": "MyWatchList",
      "type": "Microsoft.SecurityInsights/Watchlists",
      "properties": {
        "watchlistId": "xxxx",
        "displayName": "My Display Name",
        "provider": "Microsoft",
        "sourceType": "Local",
        "itemsSearchKey": "Test",
        "created": "2024-10-01T16:40:07.5468197-04:00",
        "updated": "2024-10-01T16:58:54.4225042-04:00",
        "createdBy": {
          "objectId": "xxxx",
          "name": "xxxx"
        },
        "updatedBy": {
          "objectId": "xxxx",
          "name": "xxxx"
        },
        "description": "My description",
        "watchlistType": "watchlist",
        "watchlistAlias": "MyAlias",
        "isDeleted": false,
        "labels": [],
        "defaultDuration": "P1DT3H",
        "tenantId": "xxx",
        "numberOfLinesToSkip": 1,
        "provisioningState": "Succeeded",
        "sasUri": "",
        "watchlistCategory": "General"
      }
    }]}
"@
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
                Should -Invoke -CommandName Invoke-AzRest -Exactly 1
            }
        }

        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Alias                 = "MyAlias";
                    DefaultDuration       = "P1DT3H";
                    Description           = "My description";
                    DisplayName           = "My Display Name";
                    Ensure                = "Present";
                    ItemsSearchKey        = "Test";
                    Name                  = "MyWatchList";
                    NumberOfLinesToSkip   = 1;
                    RawContent            = 'MyContent'
                    ResourceGroupName     = "MyResourceGroup";
                    SourceType            = "Local";
                    SubscriptionId        = "20f41296-9edc-4374-b5e0-b1c1aa07e7d3";
                    TenantId              = $TenantId;
                    WorkspaceName         = "MyWorkspace";
                    Credential            = $Credential;
                }

                Mock -CommandName Invoke-AzRest -MockWith {
                    return @{
                        StatusCode = '200'
                        Content = @"
{"value":[
{
      "id": "/subscriptions/xxxx/resourceGroups/xxxx/providers/Microsoft.OperationalInsights/workspaces/xxxx/providers/Microsoft.SecurityInsights/Watchlists/xxxx",
      "name": "MyWatchList",
      "type": "Microsoft.SecurityInsights/Watchlists",
      "properties": {
        "watchlistId": "xxxx",
        "displayName": "My Display Name",
        "provider": "Microsoft",
        "sourceType": "Local",
        "itemsSearchKey": "Test",
        "created": "2024-10-01T16:40:07.5468197-04:00",
        "updated": "2024-10-01T16:58:54.4225042-04:00",
        "createdBy": {
          "objectId": "xxxx",
          "name": "xxxx"
        },
        "updatedBy": {
          "objectId": "xxxx",
          "name": "xxxx"
        },
        "description": "My description",
        "watchlistType": "watchlist",
        "watchlistAlias": "MyAlias",
        "isDeleted": false,
        "labels": [],
        "defaultDuration": "P1DT3H",
        "tenantId": "xxx",
        "numberOfLinesToSkip": 1,
        "provisioningState": "Succeeded",
        "sasUri": "",
        "watchlistCategory": "General"
      }
    }]}
"@
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
                    Alias                 = "MyAlias";
                    DefaultDuration       = "P1DT3H";
                    Description           = "My description";
                    DisplayName           = "My Display Name";
                    Ensure                = "Present";
                    ItemsSearchKey        = "Test";
                    Name                  = "MyWatchList";
                    NumberOfLinesToSkip   = 0; # Drift
                    RawContent            = 'MyContent'
                    ResourceGroupName     = "MyResourceGroup";
                    SourceType            = "Local";
                    SubscriptionId        = "20f41296-9edc-4374-b5e0-b1c1aa07e7d3";
                    TenantId              = $TenantId;
                    WorkspaceName         = "MyWorkspace";
                    Credential            = $Credential;
                }

                Mock -CommandName Invoke-AzRest -MockWith {
                    return @{
                        StatusCode = '200'
                        Content = @"
{"value":[
{
      "id": "/subscriptions/xxxx/resourceGroups/xxxx/providers/Microsoft.OperationalInsights/workspaces/xxxx/providers/Microsoft.SecurityInsights/Watchlists/xxxx",
      "name": "MyWatchList",
      "type": "Microsoft.SecurityInsights/Watchlists",
      "properties": {
        "watchlistId": "xxxx",
        "displayName": "My Display Name",
        "provider": "Microsoft",
        "sourceType": "Local",
        "itemsSearchKey": "Test",
        "created": "2024-10-01T16:40:07.5468197-04:00",
        "updated": "2024-10-01T16:58:54.4225042-04:00",
        "createdBy": {
          "objectId": "xxxx",
          "name": "xxxx"
        },
        "updatedBy": {
          "objectId": "xxxx",
          "name": "xxxx"
        },
        "description": "My description",
        "watchlistType": "watchlist",
        "watchlistAlias": "MyAlias",
        "isDeleted": false,
        "labels": [],
        "defaultDuration": "P1DT3H",
        "tenantId": "xxx",
        "numberOfLinesToSkip": 1,
        "provisioningState": "Succeeded",
        "sasUri": "",
        "watchlistCategory": "General"
      }
    }]}
"@
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
                Should -Invoke -CommandName Invoke-AzRest -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{                    
                    Credential            = $Credential;
                }

                Mock -CommandName Invoke-AzRest -MockWith {
                    return @{
                        StatusCode = '200'
                        Content = @"
{"value":[
{
      "id": "/subscriptions/xxxx/resourceGroups/xxxx/providers/Microsoft.OperationalInsights/workspaces/xxxx/providers/Microsoft.SecurityInsights/Watchlists/xxxx",
      "name": "MyWatchList",
      "type": "Microsoft.SecurityInsights/Watchlists",
      "properties": {
        "watchlistId": "xxxx",
        "displayName": "My Display Name",
        "provider": "Microsoft",
        "sourceType": "Local",
        "itemsSearchKey": "Test",
        "created": "2024-10-01T16:40:07.5468197-04:00",
        "updated": "2024-10-01T16:58:54.4225042-04:00",
        "createdBy": {
          "objectId": "xxxx",
          "name": "xxxx"
        },
        "updatedBy": {
          "objectId": "xxxx",
          "name": "xxxx"
        },
        "description": "My description",
        "watchlistType": "watchlist",
        "watchlistAlias": "MyAlias",
        "isDeleted": false,
        "labels": [],
        "defaultDuration": "P1DT3H",
        "tenantId": "xxx",
        "numberOfLinesToSkip": 1,
        "provisioningState": "Succeeded",
        "sasUri": "",
        "watchlistCategory": "General"
      }
    }]}
"@
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
