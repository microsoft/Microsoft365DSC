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
    -DscResource 'AADExternalIdentityPolicy' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
            Mock -CommandName Update-MgBetaPolicyExternalIdentityPolicy -MockWith {
            }
        }

        Context -Name 'The instance exists and values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                  = 'Yes'
                    AllowDeletedIdentitiesDataRemoval = $False;
                    AllowExternalIdentitiesToLeave    = $True;
                    Credential                        = $Credential
                }
                Mock -CommandName Get-MgBetaPolicyExternalIdentityPolicy -MockWith {
                    return @{
                        Id                                = 'externalidentitypolicy'
                        DisplayName                       = 'External Identity Policy'
                        AllowDeletedIdentitiesDataRemoval = $False;
                        AllowExternalIdentitiesToLeave    = $True;
                    }
                }
            }

            It 'Should return Values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgBetaPolicyExternalIdentityPolicy' -Exactly 1
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Values are not in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                  = 'Yes'
                    AllowDeletedIdentitiesDataRemoval = $False;
                    AllowExternalIdentitiesToLeave    = $True;
                    Credential                        = $Credential
                }
                Mock -CommandName Get-MgBetaPolicyExternalIdentityPolicy -MockWith {
                    return @{
                        Id                                = 'externalidentitypolicy'
                        DisplayName                       = 'External Identity Policy'
                        AllowDeletedIdentitiesDataRemoval = $True; #drift
                        AllowExternalIdentitiesToLeave    = $True;
                    }
                }
            }

            It 'Should return values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgBetaPolicyExternalIdentityPolicy' -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Update-MgBetaPolicyExternalIdentityPolicy' -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaPolicyExternalIdentityPolicy -MockWith {
                    return @{
                        Id                                = 'externalidentitypolicy'
                        DisplayName                       = 'External Identity Policy'
                        AllowDeletedIdentitiesDataRemoval = $True; #drift
                        AllowExternalIdentitiesToLeave    = $True;
                    }
                }
            }

            It 'Should reverse engineer resource from the export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
