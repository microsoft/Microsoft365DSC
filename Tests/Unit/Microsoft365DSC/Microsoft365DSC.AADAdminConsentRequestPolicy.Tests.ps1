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

            Mock -Command Get-MgUser -MockWith {
                return @{
                    Id = '12345-12345-12345-12345-12345'
                    UserPrincipalName = 'John.Smith@contoso.com'
                }
            }

            Mock -Command Get-MgGroup -MockWith {
                return @{
                    Id          = '12345-12345-12345-12345-12345'
                    DisplayName = 'Communications'
                }
            }

            Mock -Command Get-MgBetaRoleManagementDirectoryRoleDefinition -MockWith {
                return @{
                    Id          = '12345-12345-12345-12345-12345'
                    DisplayName = 'Attack Payload Author'
                }
            }

            Mock -CommandName Invoke-MgGraphRequest -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts

        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance    = 'Yes'
                    IsEnabled             = $True;
                    NotifyReviewers       = $False;
                    RemindersEnabled      = $True;
                    RequestDurationInDays = 30;
                    Reviewers             =                 @(
                        (New-CimInstance -ClassName MSFT_AADAdminConsentRequestPolicyReviewer -Property @{
                            ReviewerType = 'User'
                            ReviewerId   = 'John.Smith@contoso.com'
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_AADAdminConsentRequestPolicyReviewer -Property @{
                            ReviewerType = 'Group'
                            ReviewerId   = 'Communications'
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_AADAdminConsentRequestPolicyReviewer -Property @{
                            ReviewerType = 'Role'
                            ReviewerId   = 'Attack Payload Author'
                        } -ClientOnly)
                    );
                    Credential          = $Credential;
                }

                Mock -CommandName Get-MgBetaPolicyAdminConsentRequestPolicy -MockWith {
                    return @{
                        IsEnabled             = $true
                        NotifyReviewers       = $False;
                        RemindersEnabled      = $True;
                        RequestDurationInDays = 30;
                        Reviewers             =                 @(
                            @{
                                Query = "/v1.0/users/e362df2b-8f61-4e5a-9e5e-c6069f3ed2ee"
                                QueryType = 'MicrosoftGraph'
                                QueryRoot = ''
                            },
                            @{
                                Query = "/v1.0/groups/1bb47df7-d3fa-4ba8-bdbd-e9fc7541fa18/transitiveMembers/microsoft.graph.user"
                                QueryType = 'MicrosoftGraph'
                                QueryRoot = ''
                            }
                            @{
                                Query = "/beta/roleManagement/directory/roleAssignments?`$filter=roleDefinitionId eq '9c6df0f2-1e7c-4dc3-b195-66dfbd24aa8f'"
                                QueryType = 'MicrosoftGraph'
                                QueryRoot = ''
                            }
                        );
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
                    IsSingleInstance    = 'Yes'
                    IsEnabled             = $True;
                    NotifyReviewers       = $False;
                    RemindersEnabled      = $True;
                    RequestDurationInDays = 30;
                    Reviewers             =                 @(
                        (New-CimInstance -ClassName MSFT_AADAdminConsentRequestPolicyReviewer -Property @{
                            ReviewerType = 'User'
                            ReviewerId   = 'AlexW@contoso.com' # Drift
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_AADAdminConsentRequestPolicyReviewer -Property @{
                            ReviewerType = 'Group'
                            ReviewerId   = 'Communications'
                        } -ClientOnly)
                        (New-CimInstance -ClassName MSFT_AADAdminConsentRequestPolicyReviewer -Property @{
                            ReviewerType = 'Role'
                            ReviewerId   = 'Attack Payload Author'
                        } -ClientOnly)
                    );
                    Credential          = $Credential;
                }

                Mock -CommandName Get-MgBetaPolicyAdminConsentRequestPolicy -MockWith {
                    return @{
                        IsEnabled             = $true
                        NotifyReviewers       = $False;
                        RemindersEnabled      = $True;
                        RequestDurationInDays = 30;
                        Reviewers             =                 @(
                            @{
                                Query = "/v1.0/users/e362df2b-8f61-4e5a-9e5e-c6069f3ed2ee"
                                QueryType = 'MicrosoftGraph'
                                QueryRoot = ''
                            },
                            @{
                                Query = "/v1.0/groups/1bb47df7-d3fa-4ba8-bdbd-e9fc7541fa18/transitiveMembers/microsoft.graph.user"
                                QueryType = 'MicrosoftGraph'
                                QueryRoot = ''
                            }
                            @{
                                Query = "/beta/roleManagement/directory/roleAssignments?`$filter=roleDefinitionId eq '9c6df0f2-1e7c-4dc3-b195-66dfbd24aa8f'"
                                QueryType = 'MicrosoftGraph'
                                QueryRoot = ''
                            }
                        );
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Invoke-MgGraphRequest -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential  = $Credential;
                }

                Mock -CommandName Get-MgBetaPolicyAdminConsentRequestPolicy -MockWith {
                    return @{
                        IsEnabled             = $true
                        NotifyReviewers       = $False;
                        RemindersEnabled      = $True;
                        RequestDurationInDays = 30;
                        Reviewers             =                 @(
                            @{
                                Query = "/v1.0/users/e362df2b-8f61-4e5a-9e5e-c6069f3ed2ee"
                                QueryType = 'MicrosoftGraph'
                                QueryRoot = ''
                            },
                            @{
                                Query = "/v1.0/groups/1bb47df7-d3fa-4ba8-bdbd-e9fc7541fa18/transitiveMembers/microsoft.graph.user"
                                QueryType = 'MicrosoftGraph'
                                QueryRoot = ''
                            }
                            @{
                                Query = "/beta/roleManagement/directory/roleAssignments?`$filter=roleDefinitionId eq '9c6df0f2-1e7c-4dc3-b195-66dfbd24aa8f'"
                                QueryType = 'MicrosoftGraph'
                                QueryRoot = ''
                            }
                        );
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
