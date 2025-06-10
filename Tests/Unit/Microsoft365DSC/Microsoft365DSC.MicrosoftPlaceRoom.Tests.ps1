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
    -DscResource 'MicrosoftPlaceRoom' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Invoke-MgGraphRequest -MockWith {
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstances = $null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'Room does not exist but should' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity              = 'room-001'
                    DisplayName           = 'Conference Room A'
                    Address               = '123 Main Street'
                    City                  = 'Seattle'
                    State                 = 'Washington'
                    CountryOrRegion       = 'United States'
                    PostalCode            = '98101'
                    Phone                 = '+1-555-0123'
                    GeoCoordinates        = '47.6062,-122.3321'
                    Capacity              = 12
                    BuildingId            = 'building-001'
                    Floor                 = '2'
                    FloorLabel            = 'Second Floor'
                    Label                 = 'Conference Room A'
                    IsWheelChairAccessible = $true
                    AudioDeviceName       = 'AudioSystem-A'
                    VideoDeviceName       = 'VideoSystem-A'
                    DisplayDeviceName     = 'Display-A'
                    MTREnabled            = $true
                    Tags                  = @('Conference', 'Video', 'Whiteboard')
                    Ensure                = 'Present'
                    Credential            = $Credential
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return $null
                } -ParameterFilter { $Uri -eq "https://graph.microsoft.com/beta/places/room-001" }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the room from the Set method' {
                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return @{ id = 'room-001' }
                } -ParameterFilter { $Uri -eq "https://graph.microsoft.com/beta/places" -and $Method -eq 'POST' }

                Set-TargetResource @testParams
                Should -Invoke -CommandName Invoke-MgGraphRequest -Exactly 1 -ParameterFilter { $Method -eq 'POST' }
            }
        }

        Context -Name 'Room exists and is in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity              = 'room-001'
                    DisplayName           = 'Conference Room A'
                    Address               = '123 Main Street'
                    City                  = 'Seattle'
                    State                 = 'Washington'
                    CountryOrRegion       = 'United States'
                    PostalCode            = '98101'
                    Phone                 = '+1-555-0123'
                    GeoCoordinates        = '47.6062,-122.3321'
                    Capacity              = 12
                    BuildingId            = 'building-001'
                    Floor                 = '2'
                    FloorLabel            = 'Second Floor'
                    Label                 = 'Conference Room A'
                    IsWheelChairAccessible = $true
                    AudioDeviceName       = 'AudioSystem-A'
                    VideoDeviceName       = 'VideoSystem-A'
                    DisplayDeviceName     = 'Display-A'
                    MTREnabled            = $true
                    Tags                  = @('Conference', 'Video', 'Whiteboard')
                    Ensure                = 'Present'
                    Credential            = $Credential
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return @{
                        '@odata.type' = '#microsoft.graph.room'
                        id = 'room-001'
                        displayName = 'Conference Room A'
                        placeType = 'Room'
                        address = @{
                            street = '123 Main Street'
                            city = 'Seattle'
                            state = 'Washington'
                            countryOrRegion = 'United States'
                            postalCode = '98101'
                        }
                        phone = '+1-555-0123'
                        geoCoordinates = @{
                            latitude = 47.6062
                            longitude = -122.3321
                        }
                        capacity = 12
                        building = 'building-001'
                        floor = '2'
                        floorLabel = 'Second Floor'
                        label = 'Conference Room A'
                        isWheelChairAccessible = $true
                        audioDeviceName = 'AudioSystem-A'
                        videoDeviceName = 'VideoSystem-A'
                        displayDeviceName = 'Display-A'
                        mtrEnabled = $true
                        tags = @('Conference', 'Video', 'Whiteboard')
                    }
                } -ParameterFilter { $Uri -eq "https://graph.microsoft.com/beta/places/room-001" }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Room exists but should not' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity   = 'room-001'
                    Ensure     = 'Absent'
                    Credential = $Credential
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return @{
                        '@odata.type' = '#microsoft.graph.room'
                        id = 'room-001'
                        displayName = 'Conference Room A'
                        placeType = 'Room'
                    }
                } -ParameterFilter { $Uri -eq "https://graph.microsoft.com/beta/places/room-001" }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the room from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Invoke-MgGraphRequest -Exactly 1 -ParameterFilter { $Method -eq 'DELETE' }
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @Credential
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}