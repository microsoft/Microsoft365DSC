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
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaApplication -MockWith {
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
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
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
                Should -Invoke -CommandName 'Get-MgApplication' -Exactly 2
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
                    AppRoles                  = @(
                        New-CimInstance -ClassName MSFT_MicrosoftGraphappRole -Property @{
                            AllowedMemberTypes = @('Application')
                            Id = 'Task Reader'
                            IsEnabled = $True
                            Origin = 'Application'
                            Description = 'Readers have ability to read task'
                            Value = 'Task.Read'
                            DisplayName = 'Readers'
                        } -ClientOnly
                        New-CimInstance -ClassName MSFT_MicrosoftGraphappRole @{
                            AllowedMemberTypes = @('Application')
                            Id = 'Task Writer'
                            IsEnabled = $True
                            Origin = 'Application'
                            Description = 'Writers have ability to write task'
                            Value = 'Task.Write'
                            DisplayName = 'Writers'
                        } -ClientOnly
                    )
                    PasswordCredentials       = @(
                        New-CimInstance -ClassName MSFT_MicrosoftGraphpasswordCredential -Property @{
                            KeyId = 'keyid'
                            EndDateTime = '2025-03-15T19:50:29.0310000+00:00'
                            Hint = 'VsO'
                            DisplayName = 'Super Secret'
                            StartDateTime = '2024-09-16T19:50:29.0310000+00:00'
                        } -ClientOnly
                    )
                    KeyCredentials = @(
                        New-CimInstance -ClassName MSFT_MicrosoftGraphkeyCredential -Property @{
                            Usage = 'Verify'
                            StartDateTime = '2024-09-25T09:13:11.0000000+00:00'
                            Type = 'AsymmetricX509Cert'
                            KeyId = 'Key ID'
                            EndDateTime = '2025-09-25T09:33:11.0000000+00:00'
                            DisplayName = 'anexas_test_2'
                        } -ClientOnly
                    )
                    OptionalClaims = New-CimInstance -ClassName MSFT_MicrosoftGraphoptionalClaims -Property @{
                        Saml2Token = [CimInstance[]]@(
                            New-CimInstance -ClassName MSFT_MicrosoftGraphOptionalClaim -Property @{
                                Name = 'groups'
                                Essential = $False
                            } -ClientOnly
                        )
                        AccessToken = [CimInstance[]]@(
                            New-CimInstance -ClassName MSFT_MicrosoftGraphOptionalClaim -Property @{
                                Name = 'groups'
                                Essential = $False
                            } -ClientOnly
                        )
                        IdToken = [CimInstance[]]@(
                            New-CimInstance -ClassName MSFT_MicrosoftGraphOptionalClaim -Property @{
                                Name = 'acrs'
                                Essential = $False
                            } -ClientOnly
                            New-CimInstance -ClassName MSFT_MicrosoftGraphOptionalClaim -Property @{
                                Name = 'groups'
                                Essential = $False
                            } -ClientOnly
                        )
                    } -ClientOnly
                    AuthenticationBehaviors   = New-CimInstance -ClassName MSFT_MicrosoftGraphAuthenticationBehaviors -Property @{
                             blockAzureADGraphAccess       = $false
                             removeUnverifiedEmailClaim    = $true
                             requireClientServicePrincipal = $false
                     } -ClientOnly
                    Api = New-CimInstance -ClassName MSFT_MicrosoftGraphapiApplication -Property @{
                        PreAuthorizedApplications = [CimInstance[]]@(
                            New-CimInstance -ClassName MSFT_MicrosoftGraphPreAuthorizedApplication  -Property @{
                                AppId = '12345-12345-12345-12345-12345'
                                PermissionIds = @('12345-12345-12345-12345-12345')
                            } -ClientOnly
                        )
                        
                    } -ClientOnly
                    Ensure                    = 'Present'
                    Credential                = $Credential
                }

                Mock -CommandName Get-MgBetaApplication -MockWith {
                    $AADApp = New-Object PSCustomObject
                    $AADApp | Add-Member -MemberType NoteProperty -Name DisplayName -Value 'App1'
                    $AADApp | Add-Member -MemberType NoteProperty -Name Id -Value '5dcb2237-c61b-4258-9c85-eae2aaeba9d6'
                    $AADApp | Add-Member -MemberType NoteProperty -Name AppId -Value '5dcb2237-c61b-4258-9c85-eae2aaeba9d6'
                    $AADApp | Add-Member -MemberType NoteProperty -Name AuthenticationBehaviors -Value @{
                         blockAzureADGraphAccess       = $false
                         removeUnverifiedEmailClaim    = $true
                         requireClientServicePrincipal = $false
                    }
                    return $AADApp
                }
                Mock -CommandName Get-MgApplication -MockWith {
                    $AADApp = New-Object PSCustomObject
                    $AADApp | Add-Member -MemberType NoteProperty -Name DisplayName -Value 'App1'
                    $AADApp | Add-Member -MemberType NoteProperty -Name Id -Value '5dcb2237-c61b-4258-9c85-eae2aaeba9d6'
                    $AADApp | Add-Member -MemberType NoteProperty -Name Description -Value 'App description'
                    $AADApp | Add-Member -MemberType NoteProperty -Name GroupMembershipClaims -Value 0
                    $AADApp | Add-Member -MemberType NoteProperty -Name SignInAudience -Value 'AzureADMyOrg'
                    $AADApp | Add-Member -MemberType NoteProperty -Name OptionalClaims -Value @{
                            Saml2Token = @(
                                @{
                                    Name = 'groups'
                                    Essential = $False
                                }
                            )
                            AccessToken = @(
                                @{
                                    Name = 'groups'
                                    Essential = $False
                                }
                            )
                            IdToken = @(
                                @{
                                    Name = 'acrs'
                                    Essential = $False
                                }
                                @{
                                    Name = 'groups'
                                    Essential = $False
                                }
                            )
                    }
                    $AADApp | Add-Member -MemberType NoteProperty -Name Web -Value @{
                        HomepageUrl  = 'https://app.contoso.com'
                        LogoutURL    = 'https://app.contoso.com/logout'
                        RedirectUris = @('https://app.contoso.com')
                    }
                    $AADApp | Add-Member -MemberType NoteProperty -Name AppRoles -Value @(
                        @{
                            AllowedMemberTypes = @('Application')
                            Id = 'Task Reader'
                            IsEnabled = $True
                            Origin = 'Application'
                            Description = 'Readers have ability to read task'
                            Value = 'Task.Read'
                            DisplayName = 'Readers'
                        }
                        @{
                            AllowedMemberTypes = @('Application')
                            Id = 'Task Writer'
                            IsEnabled = $True
                            Origin = 'Application'
                            Description = 'Writers have ability to write task'
                            Value = 'Task.Write'
                            DisplayName = 'Writers'
                        }
                    )
                    $AADApp | Add-Member -MemberType NoteProperty -Name KeyCredentials -Value @{
                        Usage = 'Verify'
                        StartDateTime = '2024-09-25T09:13:11.0000000+00:00'
                        Type = 'AsymmetricX509Cert'
                        KeyId = 'Key ID'
                        EndDateTime = '2025-09-25T09:33:11.0000000+00:00'
                        DisplayName = 'anexas_test_2'
                    }
                    $AADApp | Add-Member -MemberType NoteProperty -Name PasswordCredentials -Value @{
                        KeyId = 'keyid'
                        EndDateTime = '2025-03-15T19:50:29.0310000+00:00'
                        Hint = 'VsO'
                        DisplayName = 'Super Secret'
                        StartDateTime = '2024-09-16T19:50:29.0310000+00:00'
                    }
                    $AADApp | Add-Member -MemberType NoteProperty -Name API -Value @{
                        KnownClientApplications = ''
                        PreAuthorizedApplications = @(
                            @{
                                AppId = '12345-12345-12345-12345-12345'
                                PermissionIds = @('12345-12345-12345-12345-12345')
                            }
                        )
                    }
                    $AADApp | Add-Member -MemberType NoteProperty -Name IdentifierUris -Value 'https://app.contoso.com'
                    $AADApp | Add-Member -MemberType NoteProperty -Name Oauth2RequirePostResponse -Value $false
                    $AADApp | Add-Member -MemberType NoteProperty -Name PublicClient -Value $false
                    return $AADApp
                }
            }

            It 'Should return Values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgApplication' -Exactly 2
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
                Should -Invoke -CommandName 'Get-MgApplication' -Exactly 2
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Update-MgApplication' -Exactly 1
            }
        }

        Context -Name 'Assigning Authentication Behaviors to a new Application' -Fixture {
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
                    AuthenticationBehaviors   = New-CimInstance -ClassName MSFT_MicrosoftGraphAuthenticationBehaviors -Property @{
                            blockAzureADGraphAccess       = $false
                            removeUnverifiedEmailClaim    = $true
                            requireClientServicePrincipal = $false
                    } -ClientOnly
                    Ensure                  = 'Present'
                    Credential              = $Credential
                }

                Mock -CommandName Get-MgApplication -MockWith {
                    return $null
                }

                Mock -CommandName Get-MgBetaApplication -MockWith {
                    return @{
                        id = '12345-12345-12345-12345-12345'
                        appId = '12345-12345-12345-12345-12345'
                        DisplayName               = 'App1'
                        AuthenticationBehaviours = @{
                            blockAzureADGraphAccess       = $false
                            removeUnverifiedEmailClaim    = $true
                            requireClientServicePrincipal = $false
                        }
                        
                    }
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
                Should -Invoke -CommandName 'Update-MgBetaApplication' -Exactly 1
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
