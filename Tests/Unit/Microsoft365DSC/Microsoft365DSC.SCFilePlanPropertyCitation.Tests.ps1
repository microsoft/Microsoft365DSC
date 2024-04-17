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
    -DscResource 'SCFilePlanPropertyCitation' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Remove-FilePlanPropertyCitation -MockWith {
                return @{

                }
            }

            Mock -CommandName New-FilePlanPropertyCitation -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-FilePlanPropertyCitation -MockWith {
                return @{

                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "Citation doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                 = 'Demo Citation'
                    CitationURL          = 'https://contoso.com/Citation'
                    CitationJurisdiction = 'State'
                    Credential           = $Credential
                    Ensure               = 'Present'
                }

                Mock -CommandName Get-FilePlanPropertyCitation -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Citation already exists, but need to update properties' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                 = 'Demo Citation'
                    CitationURL          = 'https://contoso.com/Citation'
                    CitationJurisdiction = 'State'
                    Credential           = $Credential
                    Ensure               = 'Present'
                }

                Mock -CommandName Get-FilePlanPropertyCitation -MockWith {
                    return @{
                        Name                 = 'Demo Citation'
                        CitationURL          = 'https://contoso.com/Different'
                        CitationJurisdiction = 'State'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Citation should not exist' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                 = 'Demo Citation'
                    CitationURL          = 'https://contoso.com/Citation'
                    CitationJurisdiction = 'State'
                    Credential           = $Credential
                    Ensure               = 'Present'
                }

                Mock -CommandName Get-FilePlanPropertyCitation -MockWith {
                    return @{
                        Name                 = 'Demo Citation'
                        CitationURL          = 'https://contoso.com/Different'
                        CitationJurisdiction = 'State'
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
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                It 'Should Reverse Engineer resource from the Export method' {
                    $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
                }
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
