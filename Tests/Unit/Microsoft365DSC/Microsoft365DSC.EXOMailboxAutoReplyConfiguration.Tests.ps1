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
    -DscResource 'EXOMalwareFilterPolicy' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName New-MalwareFilterPolicy -MockWith {
            }

            Mock -CommandName Set-MalwareFilterPolicy -MockWith {
            }

            Mock -CommandName Remove-MalwareFilterPolicy -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Write-Warning -MockWith {
            }
        }

        # Test contexts
        Context -Name 'MalwareFilterPolicy creation.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                                 = 'Present'
                    Credential                             = $Credential
                    Identity                               = 'TestMalwareFilterPolicy'
                    AdminDisplayName                       = 'TestPolicy'
                    CustomExternalBody                     = 'This is a custom external body'
                    CustomExternalSubject                  = 'This is a custom external subject'
                    CustomFromAddress                      = 'customnotification@contoso.org'
                    CustomFromName                         = 'customnotifications'
                    CustomInternalBody                     = 'This is a custom internal body'
                    CustomInternalSubject                  = 'This is a custom internal subject'
                    CustomNotifications                    = $true
                    EnableExternalSenderAdminNotifications = $true
                    EnableFileFilter                       = $true
                    EnableInternalSenderAdminNotifications = $true
                    ExternalSenderAdminAddress             = 'notifications@contoso.org'
                    FileTypes                              = @('.bat', '.rar')
                    InternalSenderAdminAddress             = 'internalnotifications@contoso.org'
                    MakeDefault                            = $False
                    ZapEnabled                             = $true
                }


                Mock -CommandName Get-MalwareFilterPolicy -MockWith {
                    return @{
                        Identity = 'SomeOtherMalwareFilterPolicy'
                    }
                }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }

        }

        Context -Name 'MalwareFilterPolicy update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                                 = 'Present'
                    Credential                             = $Credential
                    Identity                               = 'TestMalwareFilterPolicy'
                    AdminDisplayName                       = 'TestPolicy'
                    CustomExternalBody                     = 'This is a custom external body'
                    CustomExternalSubject                  = 'This is a custom external subject'
                    CustomFromAddress                      = 'customnotification@contoso.org'
                    CustomFromName                         = 'customnotifications'
                    CustomInternalBody                     = 'This is a custom internal body'
                    CustomInternalSubject                  = 'This is a custom internal subject'
                    CustomNotifications                    = $true
                    EnableExternalSenderAdminNotifications = $true
                    EnableFileFilter                       = $true
                    EnableInternalSenderAdminNotifications = $true
                    ExternalSenderAdminAddress             = 'notifications@contoso.org'
                    FileTypes                              = @('.bat', '.rar')
                    InternalSenderAdminAddress             = 'internalnotifications@contoso.org'
                    MakeDefault                            = $False
                    ZapEnabled                             = $true
                }

                Mock -CommandName Get-MalwareFilterPolicy -MockWith {
                    return @{
                        Ensure                                 = 'Present'
                        Credential                             = $Credential
                        Identity                               = 'TestMalwareFilterPolicy'
                        AdminDisplayName                       = 'TestPolicy'
                        CustomExternalBody                     = 'This is a custom external body'
                        CustomExternalSubject                  = 'This is a custom external subject'
                        CustomFromAddress                      = 'customnotification@contoso.org'
                        CustomFromName                         = 'customnotifications'
                        CustomInternalBody                     = 'This is a custom internal body'
                        CustomInternalSubject                  = 'This is a custom internal subject'
                        CustomNotifications                    = $true
                        EnableExternalSenderAdminNotifications = $true
                        EnableFileFilter                       = $true
                        EnableInternalSenderAdminNotifications = $true
                        ExternalSenderAdminAddress             = 'notifications@contoso.org'
                        FileTypes                              = @('.bat', '.rar')
                        InternalSenderAdminAddress             = 'internalnotifications@contoso.org'
                        IsDefault                              = $False
                        ZapEnabled                             = $true
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'MalwareFilterPolicy update needed.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                                 = 'Present'
                    Credential                             = $Credential
                    Identity                               = 'TestMalwareFilterPolicy'
                    AdminDisplayName                       = 'TestPolicy'
                    CustomExternalBody                     = 'This is a custom external body'
                    CustomExternalSubject                  = 'This is a custom external subject'
                    CustomFromAddress                      = 'customnotification@contoso.org'
                    CustomFromName                         = 'customnotifications'
                    CustomInternalBody                     = 'This is a custom internal body'
                    CustomInternalSubject                  = 'This is a custom internal subject'
                    CustomNotifications                    = $true
                    EnableExternalSenderAdminNotifications = $true
                    EnableFileFilter                       = $true
                    EnableInternalSenderAdminNotifications = $true
                    ExternalSenderAdminAddress             = 'notifications@contoso.org'
                    FileTypes                              = @('.bat', '.rar')
                    InternalSenderAdminAddress             = 'internalnotifications@contoso.org'
                    MakeDefault                            = $False
                    ZapEnabled                             = $true
                }

                Mock -CommandName Get-MalwareFilterPolicy -MockWith {
                    return @{
                        Ensure                                 = 'Present'
                        Credential                             = $Credential
                        Identity                               = 'TestMalwareFilterPolicy'
                        AdminDisplayName                       = 'TestPolicy'
                        CustomExternalBody                     = 'This is a custom external body'
                        CustomExternalSubject                  = 'This is a custom external subject'
                        CustomFromAddress                      = 'customnotification@contoso.org'
                        CustomFromName                         = 'customnotifications'
                        CustomInternalBody                     = 'This is a custom internal body'
                        CustomInternalSubject                  = 'This is a custom internal subject'
                        CustomNotifications                    = $false
                        EnableExternalSenderAdminNotifications = $true
                        EnableFileFilter                       = $true
                        EnableInternalSenderAdminNotifications = $true
                        ExternalSenderAdminAddress             = 'notifications@contoso.org'
                        FileTypes                              = @('.cmd', '.rar')
                        InternalSenderAdminAddress             = 'internalnotifications@contoso.org'
                        IsDefault                              = $False
                        ZapEnabled                             = $true
                    }
                }

                Mock -CommandName Set-MalwareFilterPolicy -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Successfully call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'MalwareFilterPolicy removal.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure     = 'Absent'
                    Credential = $Credential
                    Identity   = 'TestMalwareFilterPolicy'
                }

                Mock -CommandName Get-MalwareFilterPolicy -MockWith {
                    return @{
                        Identity = 'TestMalwareFilterPolicy'
                    }
                }

                Mock -CommandName Remove-MalwareFilterPolicy -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the Policy in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MalwareFilterPolicy -MockWith {
                    return @{
                        Identity                               = 'TestMalwareFilterPolicy'
                        AdminDisplayName                       = 'TestPolicy'
                        CustomExternalBody                     = 'This is a custom external body'
                        CustomExternalSubject                  = 'This is a custom external subject'
                        CustomFromAddress                      = 'customnotification@contoso.org'
                        CustomFromName                         = 'customnotifications'
                        CustomInternalBody                     = 'This is a custom internal body'
                        CustomInternalSubject                  = 'This is a custom internal subject'
                        CustomNotifications                    = $false
                        EnableExternalSenderAdminNotifications = $true
                        EnableFileFilter                       = $true
                        EnableInternalSenderAdminNotifications = $true
                        ExternalSenderAdminAddress             = 'notifications@contoso.org'
                        FileTypes                              = @('.cmd', '.rar')
                        InternalSenderAdminAddress             = 'internalnotifications@contoso.org'
                        IsDefault                              = $False
                        ZapEnabled                             = $true
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
