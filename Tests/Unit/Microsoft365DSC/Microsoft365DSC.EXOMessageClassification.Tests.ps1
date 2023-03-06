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
    -DscResource 'EXOMessageClassification' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@contoso.onmicrosoft.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName New-MessageClassification -MockWith {
            }

            Mock -CommandName Set-MessageClassification -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name "Instance doesn't exist and it should" -Fixture {
            BeforeAll {
                $testParams = @{
                    ClassificationID            = '00a71ebb-b13d-4f23-9eee-daba7a1f2336'
                    Credential                  = $Credential
                    DisplayName                 = 'Nik Classification'
                    DisplayPrecedence           = 'Medium'
                    Ensure                      = 'Present'
                    Identity                    = 'Default\NikClassification'
                    Name                        = 'NikClassification'
                    PermissionMenuVisible       = $True
                    RecipientDescription        = 'test'
                    RetainClassificationEnabled = $True
                    SenderDescription           = 'test'
                }

                Mock -CommandName Get-MessageClassification -MockWith {
                    return $null
                }
            }

            It 'Should return False from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should call the New- cmdlet' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MessageClassification' -Exactly 1
            }
        }

        Context -Name 'Instance already exists and should be updated' -Fixture {
            BeforeAll {
                $testParams = @{
                    ClassificationID            = '00a71ebb-b13d-4f23-9eee-daba7a1f2336'
                    Credential                  = $Credential
                    DisplayName                 = 'Nik Classification'
                    DisplayPrecedence           = 'Medium'
                    Ensure                      = 'Present'
                    Identity                    = 'Default\NikClassification'
                    Name                        = 'NikClassification'
                    PermissionMenuVisible       = $True
                    RecipientDescription        = 'test'
                    RetainClassificationEnabled = $True
                    SenderDescription           = 'test'
                }

                Mock -CommandName Get-MessageClassification -MockWith {
                    return @{
                        ClassificationID            = '00a71ebb-b13d-4f23-9eee-daba7a1f2336'
                        DisplayName                 = 'Nik Classification'
                        DisplayPrecedence           = 'Medium'
                        Identity                    = 'Default\NikClassification'
                        Name                        = 'NikClassification'
                        PermissionMenuVisible       = $False; #Drift
                        RecipientDescription        = 'test'
                        RetainClassificationEnabled = $True
                        SenderDescription           = 'test'
                    }
                }
            }

            It 'Should return False from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should set Call into the Set- command exactly once' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Set-MessageClassification' -Exactly 1
            }
        }

        Context -Name 'Instance exists and it should not' -Fixture {
            BeforeAll {
                $testParams = @{
                    ClassificationID            = '00a71ebb-b13d-4f23-9eee-daba7a1f2336'
                    Credential                  = $Credential
                    DisplayName                 = 'Nik Classification'
                    DisplayPrecedence           = 'Medium'
                    Ensure                      = 'Absent'
                    Identity                    = 'Default\NikClassification'
                    Name                        = 'NikClassification'
                    PermissionMenuVisible       = $True
                    RecipientDescription        = 'test'
                    RetainClassificationEnabled = $True
                    SenderDescription           = 'test'
                }

                Mock -CommandName Get-MessageClassification -MockWith {
                    return @{
                        ClassificationID            = '00a71ebb-b13d-4f23-9eee-daba7a1f2336'
                        DisplayName                 = 'Nik Classification'
                        DisplayPrecedence           = 'Medium'
                        Identity                    = 'Default\NikClassification'
                        Name                        = 'NikClassification'
                        PermissionMenuVisible       = $True
                        RecipientDescription        = 'test'
                        RetainClassificationEnabled = $True
                        SenderDescription           = 'test'
                    }
                }

                Mock -CommandName Remove-MessageClassification -MockWith {

                }
            }

            It 'Should return present from the Get-TargetResource function' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should call into the Remove- cmdlet once' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Remove-MessageClassification' -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MessageClassification -MockWith {
                    return @{
                        ClassificationID            = '00a71ebb-b13d-4f23-9eee-daba7a1f2336'
                        DisplayName                 = 'Nik Classification'
                        DisplayPrecedence           = 'Medium'
                        Identity                    = 'Default\NikClassification'
                        Name                        = 'NikClassification'
                        PermissionMenuVisible       = $True
                        RecipientDescription        = 'test'
                        RetainClassificationEnabled = $True
                        SenderDescription           = 'test'
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
