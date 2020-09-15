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
    -DscResource "AADServicePrincipal" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin@contoso.com", $secpasswd)

            Mock -CommandName Test-MSCloudLogin -MockWith {

            }

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

            }

            Mock -CommandName Set-AzureADServicePrincipal -MockWith {

            }

            Mock -CommandName Remove-AzureADServicePrincipal -MockWith {

            }

            Mock -CommandName New-AzureADServicePrincipal -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }

        # Test contexts
        Context -Name "The service principal should exist but it does not" -Fixture {
            BeforeAll {
                $testParams = @{
                    AppId                         = "b4f08c68-7276-4cb8-b9ae-e75fca5ff834"
                    DisplayName                   = "App1"
                    AlternativeNames              = "AlternativeName1","AlternativeName2"
                    AccountEnabled                = $true
                    AppRoleAssignmentRequired     = $false
                    ErrorUrl                      = ""
                    Homepage                      = "https://app1.contoso.com"
                    LogoutUrl                     = "https://app1.contoso.com/logout"
                    PublisherName                 = "Contoso"
                    ReplyURLs                     = "https://app1.contoso.com"
                    SamlMetadataURL               = ""
                    ServicePrincipalNames         = "b4f08c68-7276-4cb8-b9ae-e75fca5ff834", "https://app1.contoso.com"
                    ServicePrincipalType          = "Application"
                    Tags                          = "{WindowsAzureActiveDirectoryIntegratedApp}"
                    Ensure                        = "Present"
                    GlobalAdminAccount            = $credsGlobalAdmin
                }

                Mock -CommandName Get-AzureADServicePrincipal -MockWith {
                    return $null
                }
            }

            It "Should return values from the get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                Should -Invoke -CommandName "Get-AzureADServicePrincipal" -Exactly 1
            }
            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should create the application from the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "New-AzureADServicePrincipal" -Exactly 1
            }
        }

        Context -Name "The application exists but it should not" -Fixture {
            BeforeAll {
                $testParams = @{
                    AppId                         = "b4f08c68-7276-4cb8-b9ae-e75fca5ff834"
                    DisplayName                   = "App1"
                    AlternativeNames              = "AlternativeName1","AlternativeName2"
                    AccountEnabled                = $true
                    AppRoleAssignmentRequired     = $false
                    ErrorUrl                      = ""
                    Homepage                      = "https://app1.contoso.com"
                    LogoutUrl                     = "https://app1.contoso.com/logout"
                    PublisherName                 = "Contoso"
                    ReplyURLs                     = "https://app1.contoso.com"
                    SamlMetadataURL               = ""
                    ServicePrincipalNames         = "b4f08c68-7276-4cb8-b9ae-e75fca5ff834", "https://app1.contoso.com"
                    ServicePrincipalType          = "Application"
                    Tags                          = "{WindowsAzureActiveDirectoryIntegratedApp}"
                    Ensure                        = "Absent"
                    GlobalAdminAccount            = $credsGlobalAdmin
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-AzureADServicePrincipal -MockWith {
                    $AADSP = New-Object PSCustomObject
                    $AADSP | Add-Member -MemberType NoteProperty -Name AppId -Value "b4f08c68-7276-4cb8-b9ae-e75fca5ff834"
                    $AADSP | Add-Member -MemberType NoteProperty -Name ObjectID -Value "5dcb2237-c61b-4258-9c85-eae2aaeba9d6"
                    $AADSP | Add-Member -MemberType NoteProperty -Name DisplayName -Value "App1"
                    $AADSP | Add-Member -MemberType NoteProperty -Name AlternativeNames -Value "AlternativeName1","AlternativeName2"
                    $AADSP | Add-Member -MemberType NoteProperty -Name AccountEnabled -Value $true
                    $AADSP | Add-Member -MemberType NoteProperty -Name AppRoleAssignmentRequired -Value $false
                    $AADSP | Add-Member -MemberType NoteProperty -Name ErrorUrl -Value ""
                    $AADSP | Add-Member -MemberType NoteProperty -Name Homepage -Value "https://app1.contoso.com"
                    $AADSP | Add-Member -MemberType NoteProperty -Name LogoutUrl -Value "https://app1.contoso.com/logout"
                    $AADSP | Add-Member -MemberType NoteProperty -Name PublisherName -Value "Contoso"
                    $AADSP | Add-Member -MemberType NoteProperty -Name ReplyURLs -Value "https://app1.contoso.com"
                    $AADSP | Add-Member -MemberType NoteProperty -Name SamlMetadataURL -Value ""
                    $AADSP | Add-Member -MemberType NoteProperty -Name ServicePrincipalNames -Value "b4f08c68-7276-4cb8-b9ae-e75fca5ff834", "https://app1.contoso.com"
                    $AADSP | Add-Member -MemberType NoteProperty -Name ServicePrincipalType -Value "Application"
                    $AADSP | Add-Member -MemberType NoteProperty -Name Tags -Value "{WindowsAzureActiveDirectoryIntegratedApp}"
                    return $AADSP
                }
            }

            It "Should return values from the get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                Should -Invoke -CommandName "Get-AzureADServicePrincipal" -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the app from the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "Remove-AzureADServicePrincipal" -Exactly 1
            }
        }
        Context -Name "The app exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AppId                         = "b4f08c68-7276-4cb8-b9ae-e75fca5ff834"
                    DisplayName                   = "App1"
                    AlternativeNames              = "AlternativeName1","AlternativeName2"
                    AccountEnabled                = $true
                    AppRoleAssignmentRequired     = $false
                    ErrorUrl                      = ""
                    Homepage                      = "https://app1.contoso.com"
                    LogoutUrl                     = "https://app1.contoso.com/logout"
                    PublisherName                 = "Contoso"
                    ReplyURLs                     = "https://app1.contoso.com"
                    SamlMetadataURL               = ""
                    ServicePrincipalNames         = "b4f08c68-7276-4cb8-b9ae-e75fca5ff834", "https://app1.contoso.com"
                    ServicePrincipalType          = "Application"
                    Tags                          = "{WindowsAzureActiveDirectoryIntegratedApp}"
                    Ensure                        = "Present"
                    GlobalAdminAccount            = $credsGlobalAdmin
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-AzureADServicePrincipal -MockWith {
                    $AADSP = New-Object PSCustomObject
                    $AADSP | Add-Member -MemberType NoteProperty -Name AppId -Value "b4f08c68-7276-4cb8-b9ae-e75fca5ff834"
                    $AADSP | Add-Member -MemberType NoteProperty -Name ObjectID -Value "5dcb2237-c61b-4258-9c85-eae2aaeba9d6"
                    $AADSP | Add-Member -MemberType NoteProperty -Name DisplayName -Value "App1"
                    $AADSP | Add-Member -MemberType NoteProperty -Name AlternativeNames -Value "AlternativeName1","AlternativeName2"
                    $AADSP | Add-Member -MemberType NoteProperty -Name AccountEnabled -Value $true
                    $AADSP | Add-Member -MemberType NoteProperty -Name AppRoleAssignmentRequired -Value $false
                    $AADSP | Add-Member -MemberType NoteProperty -Name ErrorUrl -Value ""
                    $AADSP | Add-Member -MemberType NoteProperty -Name Homepage -Value "https://app1.contoso.com"
                    $AADSP | Add-Member -MemberType NoteProperty -Name LogoutUrl -Value "https://app1.contoso.com/logout"
                    $AADSP | Add-Member -MemberType NoteProperty -Name PublisherName -Value "Contoso"
                    $AADSP | Add-Member -MemberType NoteProperty -Name ReplyURLs -Value "https://app1.contoso.com"
                    $AADSP | Add-Member -MemberType NoteProperty -Name SamlMetadataURL -Value ""
                    $AADSP | Add-Member -MemberType NoteProperty -Name ServicePrincipalNames -Value "b4f08c68-7276-4cb8-b9ae-e75fca5ff834", "https://app1.contoso.com"
                    $AADSP | Add-Member -MemberType NoteProperty -Name ServicePrincipalType -Value "Application"
                    $AADSP | Add-Member -MemberType NoteProperty -Name Tags -Value "{WindowsAzureActiveDirectoryIntegratedApp}"
                    return $AADSP
                }
            }

            It "Should return Values from the get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-AzureADServicePrincipal" -Exactly 1
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "Values are not in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AppId                         = "b4f08c68-7276-4cb8-b9ae-e75fca5ff834"
                    DisplayName                   = "App1"
                    AlternativeNames              = "AlternativeName1","AlternativeName2","AlternativeName3" #drift
                    AccountEnabled                = $true
                    AppRoleAssignmentRequired     = $false
                    ErrorUrl                      = ""
                    Homepage                      = "https://app1.contoso.com"
                    LogoutUrl                     = "https://app1.contoso.com/logout"
                    PublisherName                 = "Contoso"
                    ReplyURLs                     = "https://app1.contoso.com"
                    SamlMetadataURL               = ""
                    ServicePrincipalNames         = "b4f08c68-7276-4cb8-b9ae-e75fca5ff834", "https://app1.contoso.com"
                    ServicePrincipalType          = "Application"
                    Tags                          = "{WindowsAzureActiveDirectoryIntegratedApp}"
                    Ensure                        = "Present"
                    GlobalAdminAccount            = $credsGlobalAdmin
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-AzureADServicePrincipal -MockWith {
                    $AADSP = New-Object PSCustomObject
                    $AADSP | Add-Member -MemberType NoteProperty -Name AppId -Value "b4f08c68-7276-4cb8-b9ae-e75fca5ff834"
                    $AADSP | Add-Member -MemberType NoteProperty -Name ObjectID -Value "5dcb2237-c61b-4258-9c85-eae2aaeba9d6"
                    $AADSP | Add-Member -MemberType NoteProperty -Name AlternativeNames -Value "AlternativeName1","AlternativeName2"
                    $AADSP | Add-Member -MemberType NoteProperty -Name AccountEnabled -Value $true
                    $AADSP | Add-Member -MemberType NoteProperty -Name AppRoleAssignmentRequired -Value $false
                    $AADSP | Add-Member -MemberType NoteProperty -Name ErrorUrl -Value ""
                    $AADSP | Add-Member -MemberType NoteProperty -Name Homepage -Value "https://app1.contoso.com"
                    $AADSP | Add-Member -MemberType NoteProperty -Name LogoutUrl -Value "https://app1.contoso.com/logout"
                    $AADSP | Add-Member -MemberType NoteProperty -Name PublisherName -Value "Contoso"
                    $AADSP | Add-Member -MemberType NoteProperty -Name ReplyURLs -Value "https://app1.contoso.com"
                    $AADSP | Add-Member -MemberType NoteProperty -Name SamlMetadataURL -Value ""
                    $AADSP | Add-Member -MemberType NoteProperty -Name ServicePrincipalNames -Value "b4f08c68-7276-4cb8-b9ae-e75fca5ff834", "https://app1.contoso.com"
                    $AADSP | Add-Member -MemberType NoteProperty -Name ServicePrincipalType -Value "Application"
                    $AADSP | Add-Member -MemberType NoteProperty -Name Tags -Value "{WindowsAzureActiveDirectoryIntegratedApp}"
                    return $AADSP
                }
            }

            It "Should return values from the get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-AzureADServicePrincipal" -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Set-AzureADServicePrincipal' -Exactly 1
            }
        }

        Context -Name "ReverseDSC tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-AzureADServicePrincipal -MockWith {
                    $AADSP = New-Object PSCustomObject
                    $AADSP | Add-Member -MemberType NoteProperty -Name AppId -Value "b4f08c68-7276-4cb8-b9ae-e75fca5ff834"
                    $AADSP | Add-Member -MemberType NoteProperty -Name ObjectID -Value "5dcb2237-c61b-4258-9c85-eae2aaeba9d6"
                    $AADSP | Add-Member -MemberType NoteProperty -Name DisplayName -Value "App1"
                    $AADSP | Add-Member -MemberType NoteProperty -Name AlternativeNames -Value "AlternativeName1","AlternativeName2"
                    $AADSP | Add-Member -MemberType NoteProperty -Name AccountEnabled -Value $true
                    $AADSP | Add-Member -MemberType NoteProperty -Name AppRoleAssignmentRequired -Value $false
                    $AADSP | Add-Member -MemberType NoteProperty -Name ErrorUrl -Value ""
                    $AADSP | Add-Member -MemberType NoteProperty -Name Homepage -Value "https://app1.contoso.com"
                    $AADSP | Add-Member -MemberType NoteProperty -Name LogoutUrl -Value "https://app1.contoso.com/logout"
                    $AADSP | Add-Member -MemberType NoteProperty -Name PublisherName -Value "Contoso"
                    $AADSP | Add-Member -MemberType NoteProperty -Name ReplyURLs -Value "https://app1.contoso.com"
                    $AADSP | Add-Member -MemberType NoteProperty -Name SamlMetadataURL -Value ""
                    $AADSP | Add-Member -MemberType NoteProperty -Name ServicePrincipalNames -Value "b4f08c68-7276-4cb8-b9ae-e75fca5ff834", "https://app1.contoso.com"
                    $AADSP | Add-Member -MemberType NoteProperty -Name ServicePrincipalType -Value "Application"
                    $AADSP | Add-Member -MemberType NoteProperty -Name Tags -Value "{WindowsAzureActiveDirectoryIntegratedApp}"
                    return $AADSP
                }
            }

            It "Should reverse engineer resource from the export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
