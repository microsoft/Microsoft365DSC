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
    -DscResource "IntuneDeviceEnrollmentPlatformRestriction" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin@mydomain.com", $secpasswd)

            #Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
             #   return @{}
            #}

           #Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            #}

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Update-MgDeviceManagementDeviceEnrollmentConfiguration -MockWith {
            }
            Mock -CommandName New-MgDeviceManagementDeviceEnrollmentConfiguration -MockWith {
            }
            Mock -CommandName Remove-MgDeviceManagementDeviceEnrollmentConfiguration -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the restriction doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    AndroidPersonalDeviceEnrollmentBlocked       = $False;
                    AndroidPlatformBlocked                       = $False;
                    Description                                  = "";
                    DisplayName                                  = "My DSC Restriction";
                    Ensure                                       = "Present"
                    Credential                           = $Credential;
                    iOSOSMaximumVersion                          = "11.0";
                    iOSOSMinimumVersion                          = "9.0";
                    iOSPersonalDeviceEnrollmentBlocked           = $False;
                    iOSPlatformBlocked                           = $False;
                    MacPersonalDeviceEnrollmentBlocked           = $False;
                    MacPlatformBlocked                           = $True;
                    WindowsMobilePersonalDeviceEnrollmentBlocked = $False;
                    WindowsMobilePlatformBlocked                 = $True;
                    WindowsPersonalDeviceEnrollmentBlocked       = $True;
                    WindowsPlatformBlocked                       = $False;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should create the restriction from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "New-MgDeviceManagementDeviceEnrollmentConfiguration" -Exactly 1
            }
        }

        Context -Name "When the restriction already exists and is NOT in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    AndroidPersonalDeviceEnrollmentBlocked       = $False;
                    AndroidPlatformBlocked                       = $False;
                    Description                                  = "";
                    DisplayName                                  = "My DSC Restriction";
                    Ensure                                       = "Present"
                    Credential                           = $Credential;
                    iOSOSMaximumVersion                          = "11.0";
                    iOSOSMinimumVersion                          = "9.0";
                    iOSPersonalDeviceEnrollmentBlocked           = $False;
                    iOSPlatformBlocked                           = $False;
                    MacPersonalDeviceEnrollmentBlocked           = $False;
                    MacPlatformBlocked                           = $True;
                    WindowsMobilePersonalDeviceEnrollmentBlocked = $False;
                    WindowsMobilePlatformBlocked                 = $True;
                    WindowsPersonalDeviceEnrollmentBlocked       = $True;
                    WindowsPlatformBlocked                       = $False;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return @{
                        DisplayName              = "My DSC Restriction";
                        Description              = "";
                        id                       = "12345-12345-12345-12345-12345"
                        AdditionalProperties = @{
                            '@odata.type'            = '#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration'
                            AndroidRestriction       = @{
                                PersonalDeviceEnrollmentBlocked = $True; #Drift
                                PlatformBlocked                 = $False;
                            }
                            iOSRestriction           = @{
                                OSMaximumVersion                = "11.0";
                                OSMinimumVersion                = "9.0";
                                PersonalDeviceEnrollmentBlocked = $False;
                                PlatformBlocked                 = $False;
                            }
                            macOSRestriction         = @{
                                PersonalDeviceEnrollmentBlocked = $False;
                                PlatformBlocked                 = $True;
                            }
                            windowsMobileRestriction = @{
                                PersonalDeviceEnrollmentBlocked = $False;
                                PlatformBlocked                 = $True;
                            }
                            WindowsRestriction       = @{
                                PersonalDeviceEnrollmentBlocked = $True;
                                PlatformBlocked                 = $False;
                            }
                        }
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should update the restriction from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgDeviceManagementDeviceEnrollmentConfiguration -Exactly 1
            }
        }

        Context -Name "When the restriction already exists and IS in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    AndroidPersonalDeviceEnrollmentBlocked       = $False;
                    AndroidPlatformBlocked                       = $False;
                    Description                                  = "";
                    DisplayName                                  = "My DSC Restriction";
                    Ensure                                       = "Present"
                    Credential                           = $Credential;
                    iOSOSMaximumVersion                          = "11.0";
                    iOSOSMinimumVersion                          = "9.0";
                    iOSPersonalDeviceEnrollmentBlocked           = $False;
                    iOSPlatformBlocked                           = $False;
                    MacPersonalDeviceEnrollmentBlocked           = $False;
                    MacPlatformBlocked                           = $True;
                    WindowsMobilePersonalDeviceEnrollmentBlocked = $False;
                    WindowsMobilePlatformBlocked                 = $True;
                    WindowsPersonalDeviceEnrollmentBlocked       = $True;
                    WindowsPlatformBlocked                       = $False;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return @{
                        id                       = "12345-12345-12345-12345-12345"
                        Description              = "";
                        DisplayName              = "My DSC Restriction";
                        AdditionalProperties = @{
                            '@odata.type'            = '#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration'

                            AndroidRestriction       = @{
                                PersonalDeviceEnrollmentBlocked = $False;
                                PlatformBlocked                 = $False;
                                OSMinimumVersion                = ""
                                OSMaximumVersion                = ""
                            }
                            iOSRestriction           = @{
                                OSMaximumVersion                = "11.0";
                                OSMinimumVersion                = "9.0";
                                PersonalDeviceEnrollmentBlocked = $False;
                                PlatformBlocked                 = $False;
                            }
                            macOSRestriction         = @{
                                PersonalDeviceEnrollmentBlocked = $False;
                                PlatformBlocked                 = $True;
                                OSMinimumVersion                = ""
                                OSMaximumVersion                = ""
                            }
                            windowsMobileRestriction = @{
                                PersonalDeviceEnrollmentBlocked = $False;
                                PlatformBlocked                 = $True;
                                OSMinimumVersion                = ""
                                OSMaximumVersion                = ""
                            }
                            WindowsRestriction       = @{
                                PersonalDeviceEnrollmentBlocked = $True;
                                PlatformBlocked                 = $False;
                                OSMinimumVersion                = ""
                                OSMaximumVersion                = ""
                            }
                        }
                    }
                }
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "When the restriction exists and it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AndroidPersonalDeviceEnrollmentBlocked       = $False;
                    AndroidPlatformBlocked                       = $False;
                    Description                                  = "";
                    DisplayName                                  = "My DSC Restriction";
                    Ensure                                       = "Absent"
                    Credential                           = $Credential;
                    iOSOSMaximumVersion                          = "11.0";
                    iOSOSMinimumVersion                          = "9.0";
                    iOSPersonalDeviceEnrollmentBlocked           = $False;
                    iOSPlatformBlocked                           = $False;
                    MacPersonalDeviceEnrollmentBlocked           = $False;
                    MacPlatformBlocked                           = $True;
                    WindowsMobilePersonalDeviceEnrollmentBlocked = $False;
                    WindowsMobilePlatformBlocked                 = $True;
                    WindowsPersonalDeviceEnrollmentBlocked       = $True;
                    WindowsPlatformBlocked                       = $False;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return @{
                        id                       = "12345-12345-12345-12345-12345"
                        DisplayName              = "My DSC Restriction";
                        Description              = "";
                        AdditionalProperties = @{
                            '@odata.type'            = '#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration'
                            AndroidRestriction       = @{
                                PersonalDeviceEnrollmentBlocked = $False;
                                PlatformBlocked                 = $False;
                            }
                            iOSRestriction           = @{
                                OSMaximumVersion                = "11.0";
                                OSMinimumVersion                = "9.0";
                                PersonalDeviceEnrollmentBlocked = $False;
                                PlatformBlocked                 = $False;
                            }
                            macOSRestriction         = @{
                                PersonalDeviceEnrollmentBlocked = $False;
                                PlatformBlocked                 = $True;
                            }
                            windowsMobileRestriction = @{
                                PersonalDeviceEnrollmentBlocked = $False;
                                PlatformBlocked                 = $True;
                            }
                            WindowsRestriction       = @{
                                PersonalDeviceEnrollmentBlocked = $True;
                                PlatformBlocked                 = $False;
                            }
                        }
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should remove the restriction from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgDeviceManagementDeviceEnrollmentConfiguration -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return @{
                        id                       = "12345-12345-12345-12345-12345"
                        Description              = "";
                        DisplayName              = "My DSC Restriction";
                        AdditionalProperties = @{
                            '@odata.type'            = '#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration'
                            AndroidRestriction       = @{
                                PersonalDeviceEnrollmentBlocked = $False;
                                PlatformBlocked                 = $False;
                            }
                            iOSRestriction           = @{
                                OSMaximumVersion                = "11.0";
                                OSMinimumVersion                = "9.0";
                                PersonalDeviceEnrollmentBlocked = $False;
                                PlatformBlocked                 = $False;
                            }
                            macOSRestriction         = @{
                                PersonalDeviceEnrollmentBlocked = $False;
                                PlatformBlocked                 = $True;
                            }
                            windowsMobileRestriction = @{
                                PersonalDeviceEnrollmentBlocked = $False;
                                PlatformBlocked                 = $True;
                            }
                            WindowsRestriction       = @{
                                PersonalDeviceEnrollmentBlocked = $True;
                                PlatformBlocked                 = $False;
                            }
                        }
                    }
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
