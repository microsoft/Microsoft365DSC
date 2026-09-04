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

# Clear the schema cache to ensure the regenerated schema is loaded
[Microsoft365DSC.Cache.CacheManager]::ClearSchema()

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Start-Sleep -MockWith {
            }

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-MSCloudLoginConnectionProfile -MockWith {
                return @{
                    ResourceUrl = 'https://graph.microsoft.com/'
                }
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Invoke-MgGraphRequest -MockWith {
                param($Method, $Uri, $Body)
                if ($Method -eq 'GET' -and $Uri -like '*/applications?*filter=applicationTemplateId*')
                {
                    return @{
                        value = @(
                            @{
                                id                  = 'bf21f7e9-9d25-4da2-82ab-7fdd85049f83'
                                displayName         = 'ContosoPrivateApp'
                                applicationTemplateId = '8adf8e6e-67b2-4cf2-a259-e3dc5476c621'
                                onPremisesPublishing = @{
                                    applicationType           = 'nonwebapp'
                                    isAccessibleViaZTNAClient = $true
                                    isDnsResolutionEnabled    = $false
                                }
                            }
                        )
                    }
                }
                elseif ($Method -eq 'GET' -and $Uri -like '*/connectorGroup*')
                {
                    return @{
                        name = 'Private Access ConnectorGroup'
                        id   = 'daf709c2-6072-414f-b08c-bb2a80c631c'
                    }
                }
                elseif ($Method -eq 'GET' -and $Uri -like '*/applicationSegments*')
                {
                    return @{
                        value = @(
                            @{
                                id              = '2b52958c-9d0c-449d-a985-c29d488a6335'
                                destinationHost = 'fileserver.contoso.local'
                                destinationType = 'fqdn'
                                ports           = @('445-445', '3389-3389')
                                protocol        = 'tcp'
                            }
                        )
                    }
                }
                return $null
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstances = $null
            $Script:ExportMode = $false
        }

        Context -Name 'The instance exists and values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName              = 'ContosoPrivateApp'
                    ApplicationType          = 'nonwebapp'
                    IsAccessibleViaZTNAClient = $true
                    ConnectorGroupName       = 'Private Access ConnectorGroup'
                    IsDnsResolutionEnabled   = $false
                    Segments                 = [CimInstance[]]@(
                        New-CimInstance -ClassName MSFT_AADGSAPrivateAccessApplicationSegment -Property @{
                            DestinationHost = 'fileserver.contoso.local'
                            DestinationType = 'fqdn'
                            Ports           = @('445-445', '3389-3389')
                            Protocol        = 'tcp'
                        } -ClientOnly
                    )
                    Ensure                   = 'Present'
                    Credential               = $Credential
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The instance exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName              = 'ContosoPrivateApp'
                    ApplicationType          = 'nonwebapp'
                    IsAccessibleViaZTNAClient = $true
                    ConnectorGroupName       = 'Private Access ConnectorGroup'
                    IsDnsResolutionEnabled   = $false
                    Segments                 = [CimInstance[]]@(
                        New-CimInstance -ClassName MSFT_AADGSAPrivateAccessApplicationSegment -Property @{
                            DestinationHost = 'fileserver.contoso.local'
                            DestinationType = 'fqdn'
                            Ports           = @('445-445', '3389-3389')
                            Protocol        = 'tcp,udp' # Drift
                        } -ClientOnly
                    )
                    Ensure                   = 'Present'
                    Credential               = $Credential
                }
            }

            It 'Should return values from the Get method' {
                (Get-TargetResource @testParams).DisplayName | Should -Be 'ContosoPrivateApp'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Invoke-MgGraphRequest -Times 1 -ParameterFilter {
                    $Method -eq 'PATCH'
                }
            }
        }

        Context -Name 'The instance does not exist' -Fixture {
            BeforeAll {
                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    param($Method, $Uri, $Body)
                    if ($Method -eq 'GET' -and $Uri -like '*/applications?*filter=applicationTemplateId*')
                    {
                        return @{
                            value = @()
                        }
                    }
                    if ($Method -eq 'POST' -and $Uri -like '*/instantiate')
                    {
                        return @{
                            application = @{
                                objectId    = 'new-app-id-1234'
                                displayName = 'ContosoPrivateApp'
                            }
                        }
                    }
                    if ($Method -eq 'GET' -and $Uri -like '*/connectorGroups*filter=name*')
                    {
                        return @{
                            value = @(
                                @{
                                    id   = 'daf709c2-6072-414f-b08c-bb2a80c631c'
                                    name = 'Private Access ConnectorGroup'
                                }
                            )
                        }
                    }
                    return $null
                }

                $testParams = @{
                    DisplayName              = 'ContosoPrivateApp'
                    ApplicationType          = 'nonwebapp'
                    IsAccessibleViaZTNAClient = $true
                    ConnectorGroupName       = 'Private Access ConnectorGroup'
                    Segments                 = [CimInstance[]]@(
                        New-CimInstance -ClassName MSFT_AADGSAPrivateAccessApplicationSegment -Property @{
                            DestinationHost = 'fileserver.contoso.local'
                            DestinationType = 'fqdn'
                            Ports           = @('445-445')
                            Protocol        = 'tcp'
                        } -ClientOnly
                    )
                    Ensure                   = 'Present'
                    Credential               = $Credential
                }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method to create the application' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Invoke-MgGraphRequest -Times 1 -ParameterFilter {
                    $Method -eq 'POST' -and $Uri -like '*/instantiate'
                }
            }
        }

        Context -Name 'The onPremisesPublishing sub-resource is not immediately available after creation' -Fixture {
            BeforeAll {
                $Script:onPremPatchAttempts = 0
                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    param($Method, $Uri, $Body)
                    if ($Method -eq 'GET' -and $Uri -like '*/applications?*filter=applicationTemplateId*')
                    {
                        return @{
                            value = @()
                        }
                    }
                    if ($Method -eq 'POST' -and $Uri -like '*/instantiate')
                    {
                        return @{
                            application = @{
                                objectId    = 'new-app-id-1234'
                                displayName = 'ContosoPrivateApp'
                            }
                        }
                    }
                    if ($Method -eq 'PATCH' -and $Uri -like '*/applications/new-app-id-1234/onPremisesPublishing')
                    {
                        $Script:onPremPatchAttempts++
                        if ($Script:onPremPatchAttempts -lt 3)
                        {
                            throw 'Response status code does not indicate success: InternalServerError (Internal Server Error).'
                        }
                        return $null
                    }
                    return $null
                }

                $testParams = @{
                    DisplayName              = 'ContosoPrivateApp'
                    ApplicationType          = 'nonwebapp'
                    IsAccessibleViaZTNAClient = $true
                    Ensure                   = 'Present'
                    Credential               = $Credential
                }
            }

            It 'Should retry the onPremisesPublishing PATCH until it succeeds' {
                { Set-TargetResource @testParams } | Should -Not -Throw
                $Script:onPremPatchAttempts | Should -Be 3
                Should -Invoke -CommandName Start-Sleep -Times 2
            }
        }

        Context -Name 'The instance exists but should be absent' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'ContosoPrivateApp'
                    Ensure      = 'Absent'
                    Credential  = $Credential
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method to delete the application' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Invoke-MgGraphRequest -Times 1 -ParameterFilter {
                    $Method -eq 'DELETE'
                }
            }
        }

        Context -Name 'The application GET requests always select onPremisesPublishing explicitly' -Fixture {
            BeforeAll {
                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    param($Method, $Uri, $Body)
                    if ($Method -eq 'GET' -and $Uri -like '*/applications?*filter=applicationTemplateId*')
                    {
                        return @{
                            value = @(
                                @{
                                    id                    = 'bf21f7e9-9d25-4da2-82ab-7fdd85049f83'
                                    displayName           = 'ContosoPrivateApp'
                                    applicationTemplateId = '8adf8e6e-67b2-4cf2-a259-e3dc5476c621'
                                    onPremisesPublishing  = @{
                                        applicationType           = 'nonwebapp'
                                        isAccessibleViaZTNAClient = $true
                                        isDnsResolutionEnabled    = $false
                                    }
                                }
                            )
                        }
                    }
                    return $null
                }

                $testParams = @{
                    DisplayName = 'ContosoPrivateApp'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }
            }

            It 'Should include $select=onPremisesPublishing on the filter lookup and return the correct values' {
                $result = Get-TargetResource @testParams
                $result.ApplicationType | Should -Be 'nonwebapp'
                $result.IsAccessibleViaZTNAClient | Should -Be $true
                Should -Invoke -CommandName Invoke-MgGraphRequest -Times 1 -ParameterFilter {
                    $Method -eq 'GET' -and $Uri -like '*filter=applicationTemplateId*' -and $Uri -like '*$select=*onPremisesPublishing*'
                }
            }
        }

        Context -Name 'The ObjectId no longer exists but the application can still be found by DisplayName' -Fixture {
            BeforeAll {
                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    param($Method, $Uri, $Body)
                    if ($Method -eq 'GET' -and $Uri -like '*/applications/stale-object-id-0000*')
                    {
                        throw 'Request_ResourceNotFound'
                    }
                    if ($Method -eq 'GET' -and $Uri -like '*/applications?*filter=applicationTemplateId*')
                    {
                        return @{
                            value = @(
                                @{
                                    id                    = 'bf21f7e9-9d25-4da2-82ab-7fdd85049f83'
                                    displayName           = 'ContosoPrivateApp'
                                    applicationTemplateId = '8adf8e6e-67b2-4cf2-a259-e3dc5476c621'
                                    onPremisesPublishing  = @{
                                        applicationType           = 'nonwebapp'
                                        isAccessibleViaZTNAClient = $true
                                        isDnsResolutionEnabled    = $false
                                    }
                                }
                            )
                        }
                    }
                    if ($Method -eq 'GET' -and $Uri -like '*/connectorGroup*')
                    {
                        return @{
                            name = 'Private Access ConnectorGroup'
                            id   = 'daf709c2-6072-414f-b08c-bb2a80c631c'
                        }
                    }
                    if ($Method -eq 'GET' -and $Uri -like '*/applicationSegments*')
                    {
                        return @{
                            value = @()
                        }
                    }
                    return $null
                }

                $testParams = @{
                    DisplayName              = 'ContosoPrivateApp'
                    ApplicationType          = 'nonwebapp'
                    IsAccessibleViaZTNAClient = $true
                    ConnectorGroupName       = 'Private Access ConnectorGroup'
                    IsDnsResolutionEnabled   = $false
                    ObjectId                 = 'stale-object-id-0000'
                    Ensure                   = 'Present'
                    Credential               = $Credential
                }
            }

            It 'Should fall back to the DisplayName lookup and return Present from the Get method' {
                $result = Get-TargetResource @testParams
                $result.Ensure | Should -Be 'Present'
                $result.ObjectId | Should -Be 'bf21f7e9-9d25-4da2-82ab-7fdd85049f83'
            }
        }

        Context -Name 'The current segment destinationType is returned as the Graph wire value ip' -Fixture {
            BeforeAll {
                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    param($Method, $Uri, $Body)
                    if ($Method -eq 'GET' -and $Uri -like '*/applications?*filter=applicationTemplateId*')
                    {
                        return @{
                            value = @(
                                @{
                                    id                    = 'bf21f7e9-9d25-4da2-82ab-7fdd85049f83'
                                    displayName           = 'ContosoPrivateApp'
                                    applicationTemplateId = '8adf8e6e-67b2-4cf2-a259-e3dc5476c621'
                                    onPremisesPublishing  = @{
                                        applicationType           = 'nonwebapp'
                                        isAccessibleViaZTNAClient = $true
                                        isDnsResolutionEnabled    = $false
                                    }
                                }
                            )
                        }
                    }
                    elseif ($Method -eq 'GET' -and $Uri -like '*/connectorGroup*')
                    {
                        return @{
                            name = 'Private Access ConnectorGroup'
                            id   = 'daf709c2-6072-414f-b08c-bb2a80c631c'
                        }
                    }
                    elseif ($Method -eq 'GET' -and $Uri -like '*/applicationSegments*')
                    {
                        return @{
                            value = @(
                                @{
                                    id              = '2b52958c-9d0c-449d-a985-c29d488a6335'
                                    destinationHost = '10.0.0.5'
                                    destinationType = 'ip'
                                    ports           = @('443-443')
                                    protocol        = 'tcp'
                                }
                            )
                        }
                    }
                    return $null
                }

                $testParams = @{
                    DisplayName              = 'ContosoPrivateApp'
                    ApplicationType          = 'nonwebapp'
                    IsAccessibleViaZTNAClient = $true
                    ConnectorGroupName       = 'Private Access ConnectorGroup'
                    IsDnsResolutionEnabled   = $false
                    Segments                 = [CimInstance[]]@(
                        New-CimInstance -ClassName MSFT_AADGSAPrivateAccessApplicationSegment -Property @{
                            DestinationHost = '10.0.0.5'
                            DestinationType = 'ipAddress'
                            Ports           = @('443-443')
                            Protocol        = 'tcp'
                        } -ClientOnly
                    )
                    Ensure                   = 'Present'
                    Credential               = $Credential
                }
            }

            It 'Should translate the wire value ip to the schema value ipAddress in the Get method' {
                (Get-TargetResource @testParams).Segments[0].DestinationType | Should -Be 'ipAddress'
            }

            It 'Should return true from the Test method since ipAddress and ip represent the same value' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The application has no connector group or segments assigned' -Fixture {
            BeforeAll {
                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    param($Method, $Uri, $Body)
                    if ($Method -eq 'GET' -and $Uri -like '*/applications?*filter=applicationTemplateId*')
                    {
                        return @{
                            value = @(
                                @{
                                    id                    = 'bf21f7e9-9d25-4da2-82ab-7fdd85049f83'
                                    displayName           = 'ContosoPrivateApp'
                                    applicationTemplateId = '8adf8e6e-67b2-4cf2-a259-e3dc5476c621'
                                    onPremisesPublishing  = @{
                                        applicationType           = 'nonwebapp'
                                        isAccessibleViaZTNAClient = $true
                                        isDnsResolutionEnabled    = $false
                                    }
                                }
                            )
                        }
                    }
                    elseif ($Method -eq 'GET' -and ($Uri -like '*/connectorGroup*' -or $Uri -like '*/applicationSegments*'))
                    {
                        throw 'Response status code does not indicate success: NotFound (Not Found).'
                    }
                    return $null
                }

                $testParams = @{
                    DisplayName              = 'ContosoPrivateApp'
                    ApplicationType          = 'nonwebapp'
                    IsAccessibleViaZTNAClient = $true
                    IsDnsResolutionEnabled   = $false
                    Ensure                   = 'Present'
                    Credential               = $Credential
                }
            }

            It 'Should not throw and return an empty ConnectorGroupName and Segments from the Get method' {
                $result = Get-TargetResource @testParams
                $result.Ensure | Should -Be 'Present'
                $result.ConnectorGroupName | Should -BeNullOrEmpty
                $result.Segments | Should -BeNullOrEmpty
            }
        }

        Context -Name 'Export-TargetResource does not reuse the incomplete list item and re-fetches onPremisesPublishing per instance' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    param($Method, $Uri, $Body)
                    if ($Method -eq 'GET' -and $Uri -like '*/applications?*filter=applicationTemplateId*')
                    {
                        # Mirrors real Graph behaviour: $select is rejected together with $filter for this collection, so onPremisesPublishing is never in the list response.
                        return @{
                            value = @(
                                @{
                                    id                    = 'bf21f7e9-9d25-4da2-82ab-7fdd85049f83'
                                    displayName           = 'ContosoPrivateApp'
                                    applicationTemplateId = '8adf8e6e-67b2-4cf2-a259-e3dc5476c621'
                                }
                            )
                        }
                    }
                    if ($Method -eq 'GET' -and $Uri -like '*/applications/bf21f7e9-9d25-4da2-82ab-7fdd85049f83?*')
                    {
                        if ($Uri -notlike '*$select=*onPremisesPublishing*')
                        {
                            throw 'Test setup error: per-item GET must select onPremisesPublishing'
                        }
                        return @{
                            id                    = 'bf21f7e9-9d25-4da2-82ab-7fdd85049f83'
                            displayName           = 'ContosoPrivateApp'
                            applicationTemplateId = '8adf8e6e-67b2-4cf2-a259-e3dc5476c621'
                            onPremisesPublishing  = @{
                                applicationType           = 'nonwebapp'
                                isAccessibleViaZTNAClient = $true
                                isDnsResolutionEnabled    = $false
                            }
                        }
                    }
                    return $null
                }

                $testParams = @{
                    Credential = $Credential
                }
            }

            It 'Should include ApplicationType and IsAccessibleViaZTNAClient in the exported content' {
                $result = Export-TargetResource @testParams
                $result | Should -Match "ApplicationType\s*=\s*`"nonwebapp`""
                $result | Should -Match 'IsAccessibleViaZTNAClient\s*=\s*\$True'
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
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
