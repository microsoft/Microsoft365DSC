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
    -DscResource 'IntuneCorporateDeviceIdentifier' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString ((New-Guid).ToString()) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Invoke-MgGraphRequest -MockWith {
                return @{
                    value = @(
                        @{
                            id                         = '12345-67890'
                            importedDeviceIdentifier   = 'ABC123456'
                            importedDeviceIdentityType = 'serialNumber'
                            description                = 'Corporate laptop'
                            platform                   = 'windows'
                            enrollmentState            = 'notContacted'
                            lastModifiedDateTime       = '2024-01-01T00:00:00Z'
                            createdDateTime            = '2024-01-01T00:00:00Z'
                        }
                    )
                }
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstances = $null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "When no devices exist in Intune" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Devices          = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntuneDeviceIdentifier -Property @{
                            importedDeviceIdentifier   = 'ABC123456'
                            importedDeviceIdentityType = 'serialNumber'
                            description                = 'Corporate laptop'
                            platform                   = 'windows'
                        } -ClientOnly)
                    )
                    Ensure           = 'Present'
                    Credential       = $Credential
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return @{
                        value = @()
                    }
                }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should add devices from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Invoke-MgGraphRequest' -ParameterFilter {
                    $Method -eq 'POST' -and $Uri -like '*importDeviceIdentityList*'
                }
            }
        }

        Context -Name 'When devices exist and match the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Devices          = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntuneDeviceIdentifier -Property @{
                            importedDeviceIdentifier   = 'ABC123456'
                            importedDeviceIdentityType = 'serialNumber'
                            description                = 'Corporate laptop'
                            platform                   = 'windows'
                        } -ClientOnly)
                    )
                    Ensure           = 'Present'
                    Credential       = $Credential
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return @{
                        value = @(
                            @{
                                id                         = '12345-67890'
                                importedDeviceIdentifier   = 'ABC123456'
                                importedDeviceIdentityType = 'serialNumber'
                                description                = 'Corporate laptop'
                                platform                   = 'windows'
                                enrollmentState            = 'notContacted'
                                lastModifiedDateTime       = '2024-01-01T00:00:00Z'
                                createdDateTime            = '2024-01-01T00:00:00Z'
                            }
                        )
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When devices exist but do not match desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Devices          = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntuneDeviceIdentifier -Property @{
                            importedDeviceIdentifier   = 'XYZ987654'
                            importedDeviceIdentityType = 'serialNumber'
                            description                = 'Executive laptop'
                            platform                   = 'macos'
                        } -ClientOnly)
                    )
                    Ensure           = 'Present'
                    Credential       = $Credential
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    param($Method, $Uri)

                    if ($Method -eq 'GET')
                    {
                        return @{
                            value = @(
                                @{
                                    id                         = '12345-67890'
                                    importedDeviceIdentifier   = 'ABC123456'
                                    importedDeviceIdentityType = 'serialNumber'
                                    description          = 'Corporate laptop'
                                    platform             = 'windows'
                                    enrollmentState      = 'notContacted'
                                    lastModifiedDateTime = '2024-01-01T00:00:00Z'
                                    createdDateTime      = '2024-01-01T00:00:00Z'
                                }
                            )
                        }
                    }
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should add new device and remove old device from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Invoke-MgGraphRequest' -ParameterFilter {
                    $Method -eq 'POST' -and $Uri -like '*importDeviceIdentityList*'
                }
                Should -Invoke -CommandName 'Invoke-MgGraphRequest' -ParameterFilter {
                    $Method -eq 'DELETE' -and $Uri -like '*importedDeviceIdentities/*'
                }
            }
        }

        Context -Name 'When Ensure is Absent and devices exist' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Ensure           = 'Absent'
                    Credential       = $Credential
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    param($Method, $Uri)

                    if ($Method -eq 'GET')
                    {
                        return @{
                            value = @(
                                @{
                                    id                         = '12345-67890'
                                    importedDeviceIdentifier   = 'ABC123456'
                                    importedDeviceIdentityType = 'serialNumber'
                                    description                = 'Corporate laptop'
                                    platform                   = 'windows'
                                    enrollmentState            = 'notContacted'
                                    lastModifiedDateTime       = '2024-01-01T00:00:00Z'
                                    createdDateTime            = '2024-01-01T00:00:00Z'
                                }
                            )
                        }
                    }
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove all devices from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Invoke-MgGraphRequest' -ParameterFilter {
                    $Method -eq 'DELETE' -and $Uri -like '*importedDeviceIdentities/*'
                } -Exactly 1
            }
        }

        Context -Name 'When Ensure is Absent and no devices exist' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Ensure           = 'Absent'
                    Credential       = $Credential
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return @{
                        value = @()
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return @{
                        value = @(
                            @{
                                id                         = '12345-67890'
                                importedDeviceIdentifier   = 'ABC123456'
                                importedDeviceIdentityType = 'serialNumber'
                                description                = 'Corporate laptop'
                                platform                   = 'windows'
                                enrollmentState            = 'notContacted'
                                lastModifiedDateTime       = '2024-01-01T00:00:00Z'
                                createdDateTime            = '2024-01-01T00:00:00Z'
                            }
                        )
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
