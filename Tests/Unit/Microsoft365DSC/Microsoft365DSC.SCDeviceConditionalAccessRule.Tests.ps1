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

$CurrentScriptPath = $PSCommandPath.Split('\')
$CurrentScriptName = $CurrentScriptPath[$CurrentScriptPath.Length -1]
$ResourceName      = $CurrentScriptName.Split('.')[1]
$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource $ResourceName -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName New-DeviceConditionalAccessRule -MockWith {
            }

            Mock -CommandName Set-DeviceConditionalAccessRule -MockWith {
            }

            Mock -CommandName Remove-DeviceConditionalAccessRule -MockWith {
            }

            Mock -Command Get-MgGroup -MockWith {
                return @{
                    Id = "33333-33333-33333-33333-33333"
                    DisplayName = 'Communications'
                }
            }

            Mock -CommandName Get-DeviceConditionalAccessPolicy -MockWith {
                return @{
                    Name = 'MyPolicy'
                    Id   = '12345-12345-12345-12345-12345'
                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name "The instance should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowAppStore             = $True;
                    AllowAssistantWhileLocked = $True;
                    AllowConvenienceLogon     = $True;
                    AllowDiagnosticSubmission = $True;
                    AllowiCloudBackup         = $True;
                    AllowiCloudDocSync        = $True;
                    AllowiCloudPhotoSync      = $True;
                    AllowJailbroken           = $True;
                    AllowPassbookWhileLocked  = $True;
                    AllowScreenshot           = $True;
                    AllowSimplePassword       = $True;
                    AllowVideoConferencing    = $True;
                    AllowVoiceAssistant       = $True;
                    AllowVoiceDialing         = $True;
                    BluetoothEnabled          = $True;
                    CameraEnabled             = $True;
                    EnableRemovableStorage    = $True;
                    ForceAppStorePassword     = $False;
                    ForceEncryptedBackup      = $False;
                    Name                      = "MyPolicy{394b}";
                    PasswordRequired          = $False;
                    PhoneMemoryEncrypted      = $False;
                    Policy                    = "MyPolicy";
                    RequireEmailProfile       = $False;
                    SmartScreenEnabled        = $False;
                    SystemSecurityTLS         = $False;
                    TargetGroups              = @("Communications");
                    WLANEnabled               = $True;
                    Ensure                    = 'Present'
                    Credential                = $Credential;
                }

                Mock -CommandName Get-DeviceConditionalAccessRule -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create a new instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-DeviceConditionalAccessRule -Exactly 1
            }
        }

        Context -Name "The instance exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowAppStore             = $True;
                    AllowAssistantWhileLocked = $True;
                    AllowConvenienceLogon     = $True;
                    AllowDiagnosticSubmission = $True;
                    AllowiCloudBackup         = $True;
                    AllowiCloudDocSync        = $True;
                    AllowiCloudPhotoSync      = $True;
                    AllowJailbroken           = $True;
                    AllowPassbookWhileLocked  = $True;
                    AllowScreenshot           = $True;
                    AllowSimplePassword       = $True;
                    AllowVideoConferencing    = $True;
                    AllowVoiceAssistant       = $True;
                    AllowVoiceDialing         = $True;
                    BluetoothEnabled          = $True;
                    CameraEnabled             = $True;
                    EnableRemovableStorage    = $True;
                    ForceAppStorePassword     = $False;
                    ForceEncryptedBackup      = $False;
                    Name                      = "MyPolicy{394b}";
                    PasswordRequired          = $False;
                    PhoneMemoryEncrypted      = $False;
                    Policy                    = "MyPolicy";
                    RequireEmailProfile       = $False;
                    SmartScreenEnabled        = $False;
                    SystemSecurityTLS         = $False;
                    TargetGroups              = @("Communications");
                    WLANEnabled               = $True;
                    Ensure                    = 'Absent'
                    Credential                = $Credential;
                }

                Mock -CommandName Get-DeviceConditionalAccessRule -MockWith {
                    return @{
                        Id                        = '11111-11111-11111-11111-11111'
                        Name                      = 'MyPolicy{394b}'
                        TargetGroups              = @('22222-22222-22222-22222-22222')
                        AllowAppStore             = $True;
                        AllowAssistantWhileLocked = $True;
                        AllowConvenienceLogon     = $True;
                        AllowDiagnosticSubmission = $True;
                        AllowiCloudBackup         = $True;
                        AllowiCloudDocSync        = $True;
                        AllowiCloudPhotoSync      = $True;
                        AllowJailbroken           = $True;
                        AllowPassbookWhileLocked  = $True;
                        AllowScreenshot           = $True;
                        AllowSimplePassword       = $True;
                        AllowVideoConferencing    = $True;
                        AllowVoiceAssistant       = $True;
                        AllowVoiceDialing         = $True;
                        BluetoothEnabled          = $True;
                        CameraEnabled             = $True;
                        EnableRemovableStorage    = $True;
                        ForceAppStorePassword     = $False;
                        ForceEncryptedBackup      = $False;
                        PasswordRequired          = $False;
                        PhoneMemoryEncrypted      = $False;
                        RequireEmailProfile       = $False;
                        SmartScreenEnabled        = $False;
                        SystemSecurityTLS         = $False;
                        WLANEnabled               = $True;
                    }
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-DeviceConditionalAccessRule -Exactly 1
            }
        }

        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowAppStore             = $True;
                    AllowAssistantWhileLocked = $True;
                    AllowConvenienceLogon     = $True;
                    AllowDiagnosticSubmission = $True;
                    AllowiCloudBackup         = $True;
                    AllowiCloudDocSync        = $True;
                    AllowiCloudPhotoSync      = $True;
                    AllowJailbroken           = $True;
                    AllowPassbookWhileLocked  = $True;
                    AllowScreenshot           = $True;
                    AllowSimplePassword       = $True;
                    AllowVideoConferencing    = $True;
                    AllowVoiceAssistant       = $True;
                    AllowVoiceDialing         = $True;
                    BluetoothEnabled          = $True;
                    CameraEnabled             = $True;
                    EnableRemovableStorage    = $True;
                    ForceAppStorePassword     = $False;
                    ForceEncryptedBackup      = $False;
                    Name                      = "MyPolicy{394b}";
                    PasswordRequired          = $False;
                    PhoneMemoryEncrypted      = $False;
                    Policy                    = "MyPolicy";
                    RequireEmailProfile       = $False;
                    SmartScreenEnabled        = $False;
                    SystemSecurityTLS         = $False;
                    TargetGroups              = @("Communications");
                    WLANEnabled               = $True;
                    Ensure                    = 'Present'
                    Credential                = $Credential;
                }

                Mock -CommandName Get-DeviceConditionalAccessRule -MockWith {
                    return @{
                        Id                        = '11111-11111-11111-11111-11111'
                        Name                      = 'MyPolicy{394b}'
                        TargetGroups              = @('22222-22222-22222-22222-22222')
                        AllowAppStore             = $True;
                        AllowAssistantWhileLocked = $True;
                        AllowConvenienceLogon     = $True;
                        AllowDiagnosticSubmission = $True;
                        AllowiCloudBackup         = $True;
                        AllowiCloudDocSync        = $True;
                        AllowiCloudPhotoSync      = $True;
                        AllowJailbroken           = $True;
                        AllowPassbookWhileLocked  = $True;
                        AllowScreenshot           = $True;
                        AllowSimplePassword       = $True;
                        AllowVideoConferencing    = $True;
                        AllowVoiceAssistant       = $True;
                        AllowVoiceDialing         = $True;
                        BluetoothEnabled          = $True;
                        CameraEnabled             = $True;
                        EnableRemovableStorage    = $True;
                        ForceAppStorePassword     = $False;
                        ForceEncryptedBackup      = $False;
                        PasswordRequired          = $False;
                        PhoneMemoryEncrypted      = $False;
                        RequireEmailProfile       = $False;
                        SmartScreenEnabled        = $False;
                        SystemSecurityTLS         = $False;
                        WLANEnabled               = $True;
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The instance exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowAppStore             = $True;
                    AllowAssistantWhileLocked = $True;
                    AllowConvenienceLogon     = $True;
                    AllowDiagnosticSubmission = $True;
                    AllowiCloudBackup         = $True;
                    AllowiCloudDocSync        = $True;
                    AllowiCloudPhotoSync      = $True;
                    AllowJailbroken           = $True;
                    AllowPassbookWhileLocked  = $True;
                    AllowScreenshot           = $True;
                    AllowSimplePassword       = $True;
                    AllowVideoConferencing    = $True;
                    AllowVoiceAssistant       = $True;
                    AllowVoiceDialing         = $True;
                    BluetoothEnabled          = $True;
                    CameraEnabled             = $True;
                    EnableRemovableStorage    = $True;
                    ForceAppStorePassword     = $False;
                    ForceEncryptedBackup      = $False;
                    Name                      = "MyPolicy{394b}";
                    PasswordRequired          = $False;
                    PhoneMemoryEncrypted      = $False;
                    Policy                    = "MyPolicy";
                    RequireEmailProfile       = $False;
                    SmartScreenEnabled        = $False;
                    SystemSecurityTLS         = $False;
                    TargetGroups              = @("Communications");
                    WLANEnabled               = $True;
                    Ensure                    = 'Present'
                    Credential                = $Credential;
                }

                Mock -CommandName Get-DeviceConditionalAccessRule -MockWith {
                    return @{
                        Id                        = '11111-11111-11111-11111-11111'
                        Name                      = 'MyPolicy{394b}'
                        TargetGroups              = @('22222-22222-22222-22222-22222')
                        AllowAppStore             = $True;
                        AllowAssistantWhileLocked = $True;
                        AllowConvenienceLogon     = $True;
                        AllowDiagnosticSubmission = $True;
                        AllowiCloudBackup         = $True;
                        AllowiCloudDocSync        = $True;
                        AllowiCloudPhotoSync      = $True;
                        AllowJailbroken           = $True;
                        AllowPassbookWhileLocked  = $True;
                        AllowScreenshot           = $False; #Drift
                        AllowSimplePassword       = $True;
                        AllowVideoConferencing    = $True;
                        AllowVoiceAssistant       = $True;
                        AllowVoiceDialing         = $True;
                        BluetoothEnabled          = $True;
                        CameraEnabled             = $True;
                        EnableRemovableStorage    = $True;
                        ForceAppStorePassword     = $False;
                        ForceEncryptedBackup      = $False;
                        PasswordRequired          = $False;
                        PhoneMemoryEncrypted      = $False;
                        RequireEmailProfile       = $False;
                        SmartScreenEnabled        = $False;
                        SystemSecurityTLS         = $False;
                        WLANEnabled               = $True;
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-DeviceConditionalAccessRule -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential                = $Credential;
                }

                Mock -CommandName Get-DeviceConditionalAccessRule -MockWith {
                    return @{
                        Id                        = '11111-11111-11111-11111-11111'
                        Name                      = 'MyPolicy{394b}'
                        TargetGroups              = @('22222-22222-22222-22222-22222')
                        AllowAppStore             = $True;
                        AllowAssistantWhileLocked = $True;
                        AllowConvenienceLogon     = $True;
                        AllowDiagnosticSubmission = $True;
                        AllowiCloudBackup         = $True;
                        AllowiCloudDocSync        = $True;
                        AllowiCloudPhotoSync      = $True;
                        AllowJailbroken           = $True;
                        AllowPassbookWhileLocked  = $True;
                        AllowScreenshot           = $False; #Drift
                        AllowSimplePassword       = $True;
                        AllowVideoConferencing    = $True;
                        AllowVoiceAssistant       = $True;
                        AllowVoiceDialing         = $True;
                        BluetoothEnabled          = $True;
                        CameraEnabled             = $True;
                        EnableRemovableStorage    = $True;
                        ForceAppStorePassword     = $False;
                        ForceEncryptedBackup      = $False;
                        PasswordRequired          = $False;
                        PhoneMemoryEncrypted      = $False;
                        RequireEmailProfile       = $False;
                        SmartScreenEnabled        = $False;
                        SystemSecurityTLS         = $False;
                        WLANEnabled               = $True;
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
