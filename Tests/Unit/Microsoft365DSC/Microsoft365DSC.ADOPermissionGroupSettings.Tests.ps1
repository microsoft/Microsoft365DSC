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

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts

        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowPermissions     = @(
                        (New-Ciminstance -className MSFT_ADOPermission -Property @{
                            NamespaceId = '5a27515b-ccd7-42c9-84f1-54c998f03866'
                            DisplayName = 'Edit identity information'
                            Bit         = '2'
                            Token       = 'f6492b10-7ae8-4641-8208-ff5c364a6154\dbe6034e-8fbe-4d6e-a7f3-07a7e70816c9'
                        } -ClientOnly)
                    );
                    Credential           = $Credential;
                    DenyPermissions      = @();
                    Descriptor           = "vssgp.Uy0xLTktMTU1MTM3NDI0NS0yNzEyNzI0MzgtMzkwMDMyNjIxNC0yMTgxNjI3NzQwLTkxMDg0NDI0NC0xLTgyODcyNzAzNC0yOTkzNjA0MTcxLTI5MjUwMjk4ODgtNTY0MDg1OTcy";
                    GroupName            = "[O365DSC-DEV]\My Test Group";
                    OrganizationName     = "O365DSC-DEV";
                }

                Mock -CommandName Invoke-M365DSCAzureDevOPSWebRequest -MockWith {
                    return @{
                        value = @{
                            token ='f6492b10-7ae8-4641-8208-ff5c364a6154\dbe6034e-8fbe-4d6e-a7f3-07a7e70816c9'
                            acesDictionary = @(
                                @{
                                    descriptor = @{
                                        Allow = 2
                                        Deny  = 0
                                    }
                                }
                            )
                        }
                        principalName = "[O365DSC-DEV]\My Test Group"
                        Descriptor    = "vssgp.Uy0xLTktMTU1MTM3NDI0NS0yNzEyNzI0MzgtMzkwMDMyNjIxNC0yMTgxNjI3NzQwLTkxMDg0NDI0NC0xLTgyODcyNzAzNC0yOTkzNjA0MTcxLTI5MjUwMjk4ODgtNTY0MDg1OTcy";
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
                    AllowPermissions     = @(
                        (New-Ciminstance -className MSFT_ADOPermission -Property @{
                            NamespaceId = '5a27515b-ccd7-42c9-84f1-54c998f03866'
                            DisplayName = 'Edit identity information'
                            Bit         = '8' # Drift
                            Token       = 'f6492b10-7ae8-4641-8208-ff5c364a6154\dbe6034e-8fbe-4d6e-a7f3-07a7e70816c9'
                        } -ClientOnly)
                    );
                    Credential           = $Credential;
                    DenyPermissions      = @();
                    Descriptor           = "vssgp.Uy0xLTktMTU1MTM3NDI0NS0yNzEyNzI0MzgtMzkwMDMyNjIxNC0yMTgxNjI3NzQwLTkxMDg0NDI0NC0xLTgyODcyNzAzNC0yOTkzNjA0MTcxLTI5MjUwMjk4ODgtNTY0MDg1OTcy";
                    GroupName            = "[O365DSC-DEV]\My Test Group";
                    OrganizationName     = "O365DSC-DEV";
                }

                Mock -CommandName Invoke-M365DSCAzureDevOPSWebRequest -MockWith {
                    return @{
                        value = @{
                            token ='f6492b10-7ae8-4641-8208-ff5c364a6154\dbe6034e-8fbe-4d6e-a7f3-07a7e70816c9'
                            acesDictionary = @(
                                @{
                                    descriptor = @{
                                        Allow = 2
                                        Deny  = 0
                                    }
                                }
                            )
                        principalName = "[O365DSC-DEV]\My Test Group"
                        Descriptor    = "vssgp.Uy0xLTktMTU1MTM3NDI0NS0yNzEyNzI0MzgtMzkwMDMyNjIxNC0yMTgxNjI3NzQwLTkxMDg0NDI0NC0xLTgyODcyNzAzNC0yOTkzNjA0MTcxLTI5MjUwMjk4ODgtNTY0MDg1OTcy";
                        }                        
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential  = $Credential;
                }

                Mock -CommandName Invoke-M365DSCAzureDevOPSWebRequest -MockWith {
                    return @{
                        value = @{
                            token ='f6492b10-7ae8-4641-8208-ff5c364a6154\dbe6034e-8fbe-4d6e-a7f3-07a7e70816c9'
                            acesDictionary = @(
                                @{
                                    descriptor = @{
                                        Allow = 2
                                        Deny  = 0
                                    }
                                }
                            )
                            principalName = "[O365DSC-DEV]\My Test Group"
                            Descriptor    = "vssgp.Uy0xLTktMTU1MTM3NDI0NS0yNzEyNzI0MzgtMzkwMDMyNjIxNC0yMTgxNjI3NzQwLTkxMDg0NDI0NC0xLTgyODcyNzAzNC0yOTkzNjA0MTcxLTI5MjUwMjk4ODgtNTY0MDg1OTcy";
                            AccountName = 'O365DSC-Dev'
                        }
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
