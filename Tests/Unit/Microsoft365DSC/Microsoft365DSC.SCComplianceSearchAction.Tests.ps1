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
    -DscResource "SCComplianceSearchAction" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)


            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }

            Mock -CommandName Import-PSSession -MockWith {

            }

            Mock -CommandName New-PSSession -MockWith {

            }

            Mock -CommandName Get-ComplianceCase {
                return @{
                    Name = "Test Compliance Case"
                }
            }

            Mock -CommandName Remove-ComplianceSearchAction -MockWith {
                return @{

                }
            }

            Mock -CommandName New-ComplianceSearchAction -MockWith {
                return @{

                }
            }
        }

        # Test contexts
        Context -Name "Action doesn't already exist" -Fixture {
            BeforeEach {
                $testParams = @{
                    IncludeSharePointDocumentVersions   = $False;
                    Action                              = "Export";
                    SearchName                          = "Test Search";
                    GlobalAdminAccount                  = $GlobalAdminAccount;
                    FileTypeExclusionsForUnindexedItems = $null;
                    IncludeCredential                   = $False;
                    RetryOnError                        = $False;
                    ActionScope                         = "IndexedItemsOnly";
                    Ensure                              = "Present";
                    EnableDedupe                        = $False;
                }

                Mock -CommandName Get-ComplianceSearchAction -MockWith {
                    return $null
                }

                Mock -CommandName Get-ComplianceSearch -MockWith {
                    return $null
                }
            }

            It '[Export]Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It '[Export]Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "[Export]Should call the Set method" {
                Set-TargetResource @testParams
            }

            BeforeEach {
                $testParams = @{
                    IncludeSharePointDocumentVersions   = $False;
                    Action                              = "Retention";
                    SearchName                          = "Test Search";
                    GlobalAdminAccount                  = $GlobalAdminAccount;
                    FileTypeExclusionsForUnindexedItems = $null;
                    IncludeCredential                   = $False;
                    RetryOnError                        = $False;
                    ActionScope                         = "IndexedItemsOnly";
                    Ensure                              = "Present";
                    EnableDedupe                        = $False;
                }

                Mock -CommandName Get-ComplianceSearchAction -MockWith {
                    return $null
                }
            }

            It '[Retention]Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It '[Retention]Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "[Retention]Should call the Set method" {
                Set-TargetResource @testParams
            }

            BeforeEach {
                $testParams = @{
                    Action             = "Purge";
                    SearchName         = "Test Search";
                    GlobalAdminAccount = $GlobalAdminAccount;
                    IncludeCredential  = $False;
                    RetryOnError       = $False;
                    Ensure             = "Present";
                }

                Mock -CommandName Get-ComplianceSearchAction -MockWith {
                    return $null
                }
            }

            It '[Purge]Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It '[Purge]Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "[Purge]Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Action already exists" -Fixture {
            BeforeAll {
                $testParams = @{
                    IncludeSharePointDocumentVersions   = $False;
                    Action                              = "Retention";
                    SearchName                          = "Test Search";
                    GlobalAdminAccount                  = $GlobalAdminAccount;
                    FileTypeExclusionsForUnindexedItems = $null;
                    IncludeCredential                   = $False;
                    RetryOnError                        = $False;
                    ActionScope                         = "IndexedItemsOnly";
                    Ensure                              = "Present";
                    EnableDedupe                        = $False;
                }

                Mock -CommandName Get-ComplianceSearch -MockWith {
                    return @{
                        Name = "Test Search"
                    }
                }

                Mock -CommandName Get-ComplianceSearchAction -MockWith {
                    return @{
                        IncludeSharePointDocumentVersions   = $False;
                        Action                              = "Export";
                        SearchName                          = "Test Search";
                        FileTypeExclusionsForUnindexedItems = $null;
                        IncludeCredential                   = $False;
                        Retry                               = $False;
                        ActionScope                         = "IndexedItemsOnly";
                        EnableDedupe                        = $False;
                        Results                             = 'Container url:
                        https://contoso.blob.core.windows.net/267bbbb1-2630-41ba-d56b-08d73612df43;
                        SAS token: <Specify -IncludeCredential parameter to show the SAS token>;
                        Scenario: RetentionReports; Scope: IndexedItemsOnly; Scope details:
                        AllUnindexed; Max unindexed size: 0; File type exclusions for unindexed: <null>;
                        Total sources: 0; Include SharePoint versions: False; Enable dedupe: False;
                        Reference action: "<null>"; Region: ; Started sources: 1; Succeeded sources: 1;
                        Failed sources: 0; Total estimated bytes: 259,252; Total estimated items: 3;
                        Total transferred bytes: 259,252; Total transferred items: 3; Progress: 100.00
                        %; Completed time: 2019-09-10 5:18:34 PM; Duration: 00:00:16.6967563; Export
                        status: Completed;'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "Action is set to 'Purge'" -Fixture {
            BeforeAll {
                $testParams = @{
                    Action                              = "Purge";
                    SearchName                          = "Test Search";
                    GlobalAdminAccount                  = $GlobalAdminAccount;
                    Ensure                              = "Present";
                }

                Mock -CommandName Get-ComplianceSearch -MockWith {
                    return @{
                        Name = "Test Search"
                    }
                }

                Mock -CommandName Get-ComplianceSearchAction -MockWith {
                    return @{
                        IncludeSharePointDocumentVersions   = $False;
                        Action                              = "Purge";
                        SearchName                          = "Test Search";
                        FileTypeExclusionsForUnindexedItems = $null;
                        IncludeCredential                   = $False;
                        Retry                               = $False;
                        ActionScope                         = "IndexedItemsOnly";
                        EnableDedupe                        = $False;
                        Results                             = 'Container url:
                        https://gabwedisccan.blob.core.windows.net/267bbbb1-2630-41ba-d56b-08d73612df43;
                        SAS token: <Specify -IncludeCredential parameter to show the SAS token>;
                        Scenario: RetentionReports; Purge Type: Delete; Scope: IndexedItemsOnly; Scope details:
                        AllUnindexed; Max unindexed size: 0; File type exclusions for unindexed: <null>;
                        Total sources: 0; Include SharePoint versions: False; Enable dedupe: False;
                        Reference action: "<null>"; Region: ; Started sources: 1; Succeeded sources: 1;
                        Failed sources: 0; Total estimated bytes: 259,252; Total estimated items: 3;
                        Total transferred bytes: 259,252; Total transferred items: 3; Progress: 100.00
                        %; Completed time: 2019-09-10 5:18:34 PM; Duration: 00:00:16.6967563; Export
                        status: Completed;'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "Action already exists, but need to update properties" -Fixture {
            BeforeAll {
                $testParams = @{
                    IncludeSharePointDocumentVersions   = $False;
                    Action                              = "Retention";
                    SearchName                          = "Test Search";
                    GlobalAdminAccount                  = $GlobalAdminAccount;
                    FileTypeExclusionsForUnindexedItems = $null;
                    IncludeCredential                   = $True;
                    RetryOnError                        = $True;
                    ActionScope                         = "IndexedItemsOnly";
                    Ensure                              = "Present";
                    EnableDedupe                        = $True;
                }

                Mock -CommandName Get-ComplianceSearch -MockWith {
                    return @{
                        Name = "Test Search"
                    }
                }

                Mock -CommandName Get-ComplianceSearchAction -MockWith {
                    return @{
                        IncludeSharePointDocumentVersions   = $False;
                        Action                              = "Export";
                        SearchName                          = "Test Search";
                        FileTypeExclusionsForUnindexedItems = $null;
                        IncludeCredential                   = $False;
                        Retry                               = $False;
                        ActionScope                         = "IndexedItemsOnly";
                        EnableDedupe                        = $False;
                        Results                             = 'Container url:
                            https://gabwedisccan.blob.core.windows.net/267bbbb1-2630-41ba-d56b-08d73612df43;
                            SAS token: <Specify -IncludeCredential parameter to show the SAS token>;
                            Scenario: RetentionReports; Scope: IndexedItemsOnly; Scope details:
                            AllUnindexed; Max unindexed size: 0; File type exclusions for unindexed: <null>;
                            Total sources: 0; Include SharePoint versions: False; Enable dedupe: False;
                            Reference action: "<null>"; Region: ; Started sources: 1; Succeeded sources: 1;
                            Failed sources: 0; Total estimated bytes: 259,252; Total estimated items: 3;
                            Total transferred bytes: 259,252; Total transferred items: 3; Progress: 100.00
                            %; Completed time: 2019-09-10 5:18:34 PM; Duration: 00:00:16.6967563; Export
                            status: Completed'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update properties from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "Action should not exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    IncludeSharePointDocumentVersions   = $False;
                    Action                              = "Retention";
                    SearchName                          = "Test Search";
                    GlobalAdminAccount                  = $GlobalAdminAccount;
                    FileTypeExclusionsForUnindexedItems = $null;
                    IncludeCredential                   = $True;
                    RetryOnError                        = $True;
                    ActionScope                         = "IndexedItemsOnly";
                    Ensure                              = "Absent";
                    EnableDedupe                        = $True;
                }

                Mock -CommandName Get-ComplianceSearch -MockWith {
                    return @{
                        Name = "Test Search"
                    }
                }

                Mock -CommandName Get-ComplianceSearchAction -MockWith {
                    return @{
                        IncludeSharePointDocumentVersions   = $False;
                        Action                              = "Export";
                        SearchName                          = "Test Search";
                        FileTypeExclusionsForUnindexedItems = $null;
                        IncludeCredential                   = $False;
                        Retry                               = $False;
                        ActionScope                         = "IndexedItemsOnly";
                        EnableDedupe                        = $False;
                        Results                             = 'Container url:
                                https://gabwedisccan.blob.core.windows.net/267bbbb1-2630-41ba-d56b-08d73612df43;
                                SAS token: <Specify -IncludeCredential parameter to show the SAS token>;
                                Scenario: RetentionReports; Scope: IndexedItemsOnly; Scope details:
                                AllUnindexed; Max unindexed size: 0; File type exclusions for unindexed: <null>;
                                Total sources: 0; Include SharePoint versions: False; Enable dedupe: False;
                                Reference action: "<null>"; Region: ; Started sources: 1; Succeeded sources: 1;
                                Failed sources: 0; Total estimated bytes: 259,252; Total estimated items: 3;
                                Total transferred bytes: 259,252; Total transferred items: 3; Progress: 100.00
                                %; Completed time: 2019-09-10 5:18:34 PM; Duration: 00:00:16.6967563; Export
                                status: Completed'
                    }
                }
            }

            It 'Should return False from the Test method' {
                Test-TargetResource @testParams | Should -Be $False
            }

            It 'Should delete from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
