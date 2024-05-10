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
    -DscResource 'EXOPlace' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Set-Place -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'Instance is already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AudioDeviceName        = "MyAudioDevice";
                    Capacity               = 10;
                    City                   = "";
                    Credential             = $Credential;
                    DisplayDeviceName      = "DisplayDeviceName";
                    Ensure                 = "Present";
                    Identity               = "MyRoom@$contoso.com";
                    IsWheelChairAccessible = $True;
                    MTREnabled             = $False;
                    ParentType             = "None";
                    Phone                  = "555-555-5555";
                    Tags                   = @("Tag1", "Tag2");
                    VideoDeviceName        = "VideoDevice";
                }

                Mock -CommandName Get-Place -MockWith {
                    return @{
                        AudioDeviceName        = "MyAudioDevice";
                        Capacity               = 10;
                        City                   = "";
                        DisplayDeviceName      = "DisplayDeviceName";
                        Identity               = "MyRoom@$contoso.com";
                        IsWheelChairAccessible = $True;
                        MTREnabled             = $False;
                        ParentType             = "None";
                        Phone                  = "555-555-5555";
                        Tags                   = @("Tag1", "Tag2");
                        VideoDeviceName        = "VideoDevice";
                   }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should not update anything in the Set Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Instance is NOT already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AudioDeviceName        = "MyAudioDevice";
                    Capacity               = 10;
                    City                   = "";
                    Credential             = $Credential;
                    DisplayDeviceName      = "DisplayDeviceName";
                    Ensure                 = "Present";
                    Identity               = "MyRoom@$contoso.com";
                    IsWheelChairAccessible = $True;
                    MTREnabled             = $False;
                    ParentType             = "None";
                    Phone                  = "555-555-5555";
                    Tags                   = @("Tag1", "Tag2");
                    VideoDeviceName        = "VideoDevice";
                }

                Mock -CommandName Get-Place -MockWith {
                    return @(
                        @{
                            AudioDeviceName        = "MyAudioDevice";
                            Capacity               = 15; #Drift
                            City                   = "";
                            DisplayDeviceName      = "DisplayDeviceName";
                            Identity               = "MyRoom@$contoso.com";
                            IsWheelChairAccessible = $True;
                            MTREnabled             = $False;
                            ParentType             = "None";
                            Phone                  = "555-555-5555";
                            Tags                   = @("Tag1", "Tag2");
                            VideoDeviceName        = "VideoDevice";
                        }
                    )
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should not update anything in the Set Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should update the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-Place -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }
                Mock -CommandName Get-Place -MockWith {
                    return @(
                        @{
                            AudioDeviceName        = "MyAudioDevice";
                            Capacity               = 15; #Drift
                            City                   = "";
                            DisplayDeviceName      = "DisplayDeviceName";
                            Identity               = "MyRoom@$contoso.com";
                            IsWheelChairAccessible = $True;
                            MTREnabled             = $False;
                            ParentType             = "None";
                            Phone                  = "555-555-5555";
                            Tags                   = @("Tag1", "Tag2");
                            VideoDeviceName        = "VideoDevice";
                        }
                    )
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
