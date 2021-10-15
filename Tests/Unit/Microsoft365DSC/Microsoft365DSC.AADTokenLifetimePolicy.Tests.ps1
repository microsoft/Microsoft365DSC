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
    -DscResource "AADTokenLifetimePolicy" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

            }

            Mock -CommandName Update-MgPolicyTokenLifetimePolicy -MockWith {

            }

            Mock -CommandName Remove-MgPolicyTokenLifetimePolicy -MockWith {

            }

            Mock -CommandName New-MgPolicyTokenLifetimePolicy -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }

        # Test contexts
        Context -Name "The Policy should exist but it does not" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName           = "PolicyDisplayName"
                    Description           = "My token"
                    Definition            = @('{"TokenIssuancePolicy":{"Version": 1,"SigningAlgorithm": "http://www.w3.org/2000/09/xmldsig#rsa-sha1","TokenResponseSigningPolicy": "TokenOnly","SamlTokenVersion": "2.0"}}')
                    IsOrganizationDefault = $false
                    Ensure                = "Present"
                    Credential    = $credsGlobalAdmin
                }

                Mock -CommandName Get-MgPolicyTokenLifetimePolicy -MockWith {
                    return $null
                }
            }

            It "Should return values from the get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                Should -Invoke -CommandName "Get-MgPolicyTokenLifetimePolicy" -Exactly 1
            }
            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should create the Policy from the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "New-MgPolicyTokenLifetimePolicy" -Exactly 1
            }
        }
        Context -Name "The Policy exists but it should not" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName           = "PolicyDisplayName"
                    Definition            = @('{"TokenIssuancePolicy":{"Version": 1,"SigningAlgorithm": "http://www.w3.org/2000/09/xmldsig#rsa-sha1","TokenResponseSigningPolicy": "TokenOnly","SamlTokenVersion": "2.0"}}')
                    IsOrganizationDefault = $false
                    Description           = "My token"
                    Ensure                = "Absent"
                    Credential    = $credsGlobalAdmin
                }

                Mock -CommandName Get-MgPolicyTokenLifetimePolicy -MockWith {
                    $AADPolicy = New-Object PSCustomObject
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name DisplayName -Value "PolicyDisplayName"
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name ID -Value "78a80fa1-8ced-4019-94d8-2e0130644496"
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name Definition -Value @('{"TokenIssuancePolicy":{"Version": 1,"SigningAlgorithm": "http://www.w3.org/2000/09/xmldsig#rsa-sha1","TokenResponseSigningPolicy": "TokenOnly","SamlTokenVersion": "2.0"}}')
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name isOrganizationDefault -Value "false"

                    return $AADPolicy
                }
            }

            It "Should return values from the get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                Should -Invoke -CommandName "Get-MgPolicyTokenLifetimePolicy" -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the app from the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "Remove-MgPolicyTokenLifetimePolicy" -Exactly 1
            }
        }

        Context -Name "The Policy exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName           = "PolicyDisplayName"
                    Definition            = @('{"TokenIssuancePolicy":{"Version": 1,"SigningAlgorithm": "http://www.w3.org/2000/09/xmldsig#rsa-sha1","TokenResponseSigningPolicy": "TokenOnly","SamlTokenVersion": "2.0"}}')
                    IsOrganizationDefault = $false
                    Description           = "My token"
                    Ensure                = "Present"
                    Credential    = $credsGlobalAdmin
                }

                Mock -CommandName Get-MgPolicyTokenLifetimePolicy -MockWith {
                    $AADPolicy = New-Object PSCustomObject
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name DisplayName -Value "PolicyDisplayName"
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name ID -Value "78a80fa1-8ced-4019-94d8-2e0130644496"
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name Definition -Value @('{"TokenIssuancePolicy":{"Version": 1,"SigningAlgorithm": "http://www.w3.org/2000/09/xmldsig#rsa-sha1","TokenResponseSigningPolicy": "TokenOnly","SamlTokenVersion": "2.0"}}')
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name isOrganizationDefault -Value "false"
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name Description -Value "My token"

                    return $AADPolicy
                }
            }

            It "Should return Values from the get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-MgPolicyTokenLifetimePolicy" -Exactly 1
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "Values are not in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName           = "PolicyDisplayName1"
                    Definition            = @('{"TokenIssuancePolicy":{"Version": 1,"SigningAlgorithm": "http://www.w3.org/2000/09/xmldsig#rsa-sha1","TokenResponseSigningPolicy": "TokenOnly","SamlTokenVersion": "2.0"}}')
                    IsOrganizationDefault = $true
                    Description           = "My token"
                    Ensure                = "Present"
                    Credential    = $credsGlobalAdmin
                }

                Mock -CommandName Get-MgPolicyTokenLifetimePolicy -MockWith {
                    $AADPolicy = New-Object PSCustomObject
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name DisplayName -Value "PolicyDisplayName"
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name ID -Value "78a80fa1-8ced-4019-94d8-2e0130644496"
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name Definition -Value @('{"TokenIssuancePolicy":{"Version": 1,"SigningAlgorithm": "http://www.w3.org/2000/09/xmldsig#rsa-sha1","TokenResponseSigningPolicy": "TokenOnly","SamlTokenVersion": "2.0"}}')
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name isOrganizationDefault -Value "false"

                    return $AADPolicy
                }
            }

            It "Should return values from the get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-MgPolicyTokenLifetimePolicy" -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "Update-MgPolicyTokenLifetimePolicy" -Exactly 1
            }
        }

        Context -Name "ReverseDSC tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgPolicyTokenLifetimePolicy -MockWith {
                    $AADPolicy = New-Object PSCustomObject
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name DisplayName -Value "PolicyDisplayName"
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name ID -Value "78a80fa1-8ced-4019-94d8-2e0130644496"
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name Definition -Value '{{"TokenIssuancePolicy": {"Version": 1,"SigningAlgorithm": "http://www.w3.org/2000/09/xmldsig#rsa-sha1","TokenResponseSigningPolicy": "TokenOnly","SamlTokenVersion": "2.0"}}}'
                    $AADPolicy | Add-Member -MemberType NoteProperty -Name isOrganizationDefault -Value "false"

                    return $AADPolicy
                }
            }

            It "Should reverse engineer resource from the export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
