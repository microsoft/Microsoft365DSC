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
    -DscResource 'AADApplication' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgApplication -MockWith {
            }

            Mock -CommandName Remove-MgApplication -MockWith {
            }

            Mock -CommandName MgBetaDirectoryDeletedItemAsApplication -MockWith {
            }

            Mock -CommandName New-MgApplication -MockWith {
                return @{
                    ID    = '12345-12345-12345-12345-12345'
                    AppId = '12345-12345-12345-12345-12345'
                }
            }

            Mock -CommandName Get-MgServicePrincipal -MockWith {
                $servicePrincipal = New-Object PSCustomObject
                $servicePrincipal | Add-Member -MemberType NoteProperty -Name DisplayName -Value 'Microsoft Graph'
                $servicePrincipal | Add-Member -MemberType NoteProperty -Name ObjectID -Value '12345-12345-12345-12345-12345'
                return $servicePrincipal
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Start-Sleep -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'The application should exist but it does not' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName               = 'App1'
                    AvailableToOtherTenants   = $false
                    Description               = 'App description'
                    GroupMembershipClaims     = '0'
                    Homepage                  = 'https://app.contoso.com'
                    IdentifierUris            = 'https://app.contoso.com'
                    KnownClientApplications   = ''
                    LogoutURL                 = 'https://app.contoso.com/logout'
                    PublicClient              = $false
                    ReplyURLs                 = @('https://app.contoso.com')
                    Ensure                    = 'Present'
                    Credential                = $Credential
                }

                Mock -CommandName Get-MgApplication -MockWith {
                    return $null
                }
            }

            It 'Should return values from the get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                Should -Invoke -CommandName 'Get-MgApplication' -Exactly 1
            }
            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should create the application from the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgApplication' -Exactly 1
            }
        }

        Context -Name 'The application exists but it should not' -Fixture {
            BeforeAll {
                $testParams = @{
                    ObjectId                  = '5dcb2237-c61b-4258-9c85-eae2aaeba9d6'
                    DisplayName               = 'App1'
                    AvailableToOtherTenants   = $false
                    Description               = 'App description'
                    GroupMembershipClaims     = '0'
                    Homepage                  = 'https://app.contoso.com'
                    IdentifierUris            = 'https://app.contoso.com'
                    KnownClientApplications   = ''
                    LogoutURL                 = 'https://app.contoso.com/logout'
                    PublicClient              = $false
                    ReplyURLs                 = 'https://app.contoso.com'
                    Ensure                    = 'Absent'
                    Credential                = $Credential
                }

                Mock -CommandName Get-MgApplication -MockWith {
                    $AADApp = New-Object PSCustomObject
                    $AADApp | Add-Member -MemberType NoteProperty -Name DisplayName -Value 'App1'
                    $AADApp | Add-Member -MemberType NoteProperty -Name Id -Value '5dcb2237-c61b-4258-9c85-eae2aaeba9d6'
                    $AADApp | Add-Member -MemberType NoteProperty -Name AvailableToOtherTenants -Value $false
                    $AADApp | Add-Member -MemberType NoteProperty -Name Description -Value 'App description'
                    $AADApp | Add-Member -MemberType NoteProperty -Name GroupMembershipClaims -Value 0
                    $AADApp | Add-Member -MemberType NoteProperty -Name Homepage -Value 'https://app.contoso.com'
                    $AADApp | Add-Member -MemberType NoteProperty -Name IdentifierUris -Value 'https://app.contoso.com'
                    $AADApp | Add-Member -MemberType NoteProperty -Name KnownClientApplications -Value ''
                    $AADApp | Add-Member -MemberType NoteProperty -Name LogoutURL -Value 'https://app.contoso.com/logout'
                    $AADApp | Add-Member -MemberType NoteProperty -Name Oauth2RequirePostResponse -Value $false
                    $AADApp | Add-Member -MemberType NoteProperty -Name PublicClient -Value $false
                    $AADApp | Add-Member -MemberType NoteProperty -Name ReplyURLs -Value 'https://app.contoso.com'
                    $AADApp | Add-Member -MemberType NoteProperty -Name SamlMetadataUrl -Value ''
                    return $AADApp
                }
            }

            It 'Should return values from the get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                Should -Invoke -CommandName 'Get-MgApplication' -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the app from the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Remove-MgApplication' -Exactly 1
            }
        }
        Context -Name 'The app exists and values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName               = 'App1'
                    AvailableToOtherTenants   = $false
                    Description               = 'App description'
                    GroupMembershipClaims     = '0'
                    Homepage                  = 'https://app.contoso.com'
                    IdentifierUris            = 'https://app.contoso.com'
                    KnownClientApplications   = ''
                    LogoutURL                 = 'https://app.contoso.com/logout'
                    PublicClient              = $false
                    ReplyURLs                 = 'https://app.contoso.com'
                    Ensure                    = 'Present'
                    Credential                = $Credential
                }

                Mock -CommandName Get-MgApplication -MockWith {
                    $AADApp = New-Object PSCustomObject
                    $AADApp | Add-Member -MemberType NoteProperty -Name DisplayName -Value 'App1'
                    $AADApp | Add-Member -MemberType NoteProperty -Name Id -Value '5dcb2237-c61b-4258-9c85-eae2aaeba9d6'
                    $AADApp | Add-Member -MemberType NoteProperty -Name Description -Value 'App description'
                    $AADApp | Add-Member -MemberType NoteProperty -Name GroupMembershipClaims -Value 0
                    $AADApp | Add-Member -MemberType NoteProperty -Name SignInAudience -Value 'AzureADMyOrg'
                    $AADApp | Add-Member -MemberType NoteProperty -Name Web -Value @{
                        HomepageUrl  = 'https://app.contoso.com'
                        LogoutURL    = 'https://app.contoso.com/logout'
                        RedirectUris = @('https://app.contoso.com')
                    }
                    $AADApp | Add-Member -MemberType NoteProperty -Name IdentifierUris -Value 'https://app.contoso.com'
                    $AADApp | Add-Member -MemberType NoteProperty -Name API -Value @{
                        KnownClientApplications = ''
                    }
                    $AADApp | Add-Member -MemberType NoteProperty -Name Oauth2RequirePostResponse -Value $false
                    $AADApp | Add-Member -MemberType NoteProperty -Name PublicClient -Value $false
                    return $AADApp
                }
            }

            It 'Should return Values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgApplication' -Exactly 1
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Values are not in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName               = 'App1'
                    AvailableToOtherTenants   = $false
                    Description               = 'App description'
                    GroupMembershipClaims     = '0'
                    Homepage                  = 'https://app1.contoso.com' #drift
                    IdentifierUris            = 'https://app.contoso.com'
                    KnownClientApplications   = ''
                    LogoutURL                 = 'https://app.contoso.com/logout'
                    PublicClient              = $false
                    ReplyURLs                 = 'https://app.contoso.com'
                    Ensure                    = 'Present'
                    Credential                = $Credential
                }

                Mock -CommandName Get-MgApplication -MockWith {
                    $AADApp = New-Object PSCustomObject
                    $AADApp | Add-Member -MemberType NoteProperty -Name DisplayName -Value 'App1'
                    $AADApp | Add-Member -MemberType NoteProperty -Name Id -Value '5dcb2237-c61b-4258-9c85-eae2aaeba9d6'
                    $AADApp | Add-Member -MemberType NoteProperty -Name AvailableToOtherTenants -Value $false
                    $AADApp | Add-Member -MemberType NoteProperty -Name Description -Value 'App description'
                    $AADApp | Add-Member -MemberType NoteProperty -Name GroupMembershipClaims -Value 0
                    $AADApp | Add-Member -MemberType NoteProperty -Name Homepage -Value 'https://app.contoso.com'
                    $AADApp | Add-Member -MemberType NoteProperty -Name IdentifierUris -Value 'https://app.contoso.com'
                    $AADApp | Add-Member -MemberType NoteProperty -Name KnownClientApplications -Value ''
                    $AADApp | Add-Member -MemberType NoteProperty -Name LogoutURL -Value 'https://app.contoso.com/logout'
                    $AADApp | Add-Member -MemberType NoteProperty -Name Oauth2RequirePostResponse -Value $false
                    $AADApp | Add-Member -MemberType NoteProperty -Name PublicClient -Value $false
                    $AADApp | Add-Member -MemberType NoteProperty -Name ReplyURLs -Value 'https://app.contoso.com'
                    return $AADApp
                }
            }

            It 'Should return values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgApplication' -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Update-MgApplication' -Exactly 1
            }
        }

        Context -Name 'Assigning Permissions to a new Application' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName               = 'App1'
                    AvailableToOtherTenants   = $false
                    Description               = 'App description'
                    GroupMembershipClaims     = '0'
                    IdentifierUris            = 'https://app.contoso.com'
                    KnownClientApplications   = ''
                    LogoutURL                 = 'https://app.contoso.com/logout'
                    PublicClient              = $false
                    ReplyURLs                 = 'https://app.contoso.com'
                    Permissions               = @(New-CimInstance -ClassName MSFT_AADApplicationPermission -Property @{
                            Name                = 'User.Read'
                            Type                = 'Delegated'
                            SourceAPI           = 'Microsoft Graph'
                            AdminConsentGranted = $false
                        } -ClientOnly
                        New-CimInstance -ClassName MSFT_AADApplicationPermission -Property @{
                            Name                = 'User.ReadWrite.All'
                            type                = 'Delegated'
                            SourceAPI           = 'Microsoft Graph'
                            AdminConsentGranted = $True
                        } -ClientOnly
                        New-CimInstance -ClassName MSFT_AADApplicationPermission -Property @{
                            Name                = 'User.Read.All'
                            type                = 'AppOnly'
                            SourceAPI           = 'Microsoft Graph'
                            AdminConsentGranted = $True
                        } -ClientOnly
                    )
                    Ensure                  = 'Present'
                    Credential              = $Credential
                }

                Mock -CommandName Get-MgApplication -MockWith {
                    return $null
                }
            }

            It 'Should return values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgApplication' -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the new method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgApplication' -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgApplication -MockWith {
                    $AADApp = New-Object PSCustomObject
                    $AADApp | Add-Member -MemberType NoteProperty -Name DisplayName -Value 'App1'
                    $AADApp | Add-Member -MemberType NoteProperty -Name Id -Value '5dcb2237-c61b-4258-9c85-eae2aaeba9d6'
                    $AADApp | Add-Member -MemberType NoteProperty -Name AvailableToOtherTenants -Value $false
                    $AADApp | Add-Member -MemberType NoteProperty -Name Description -Value 'App description'
                    $AADApp | Add-Member -MemberType NoteProperty -Name GroupMembershipClaims -Value 0
                    $AADApp | Add-Member -MemberType NoteProperty -Name Homepage -Value 'https://app.contoso.com'
                    $AADApp | Add-Member -MemberType NoteProperty -Name IdentifierUris -Value 'https://app.contoso.com'
                    $AADApp | Add-Member -MemberType NoteProperty -Name KnownClientApplications -Value ''
                    $AADApp | Add-Member -MemberType NoteProperty -Name LogoutURL -Value 'https://app.contoso.com/logout'
                    $AADApp | Add-Member -MemberType NoteProperty -Name Oauth2RequirePostResponse -Value $false
                    $AADApp | Add-Member -MemberType NoteProperty -Name PublicClient -Value $false
                    $AADApp | Add-Member -MemberType NoteProperty -Name ReplyURLs -Value 'https://app.contoso.com'
                    return $AADApp
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
