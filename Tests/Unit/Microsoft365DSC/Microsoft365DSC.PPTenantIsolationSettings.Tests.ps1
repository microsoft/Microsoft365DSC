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
    -DscResource 'PPTenantIsolationSettings' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@contoso.onmicrosoft.com', $secpasswd)

            Mock -CommandName Get-MgContext -MockWith {
                return @{
                    TenantId = '12345678-1234-1234-1234-123456789012'
                }
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            $Global:PartialExportFileName = 'c:\TestPath'

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            function New-HashFromTenantName
            {
                param
                (
                    [Parameter(Mandatory = $true)]
                    [System.String]
                    $TenantName
                )

                $stringAsStream = [System.IO.MemoryStream]::new()
                $writer = [System.IO.StreamWriter]::new($stringAsStream)
                $writer.Write($TenantName)
                $writer.Flush()
                $stringAsStream.Position = 0
                $hash = (Get-FileHash -InputStream $stringAsStream).Hash

                $hashAsGuid = '{0}-{1}-{2}-{3}-{4}' -f $hash.Substring(0, 8), $hash.Substring(8, 4), $hash.Substring(12, 4), $hash.Substring(16, 4), $hash.Substring(20, 12)

                return $hashAsGuid
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'PP Tenant Isolation settings are not configured' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Enable           = $true
                    Rules            = @(
                        (New-CimInstance -ClassName MSFT_PPTenantRule -Property @{
                            TenantName = 'contoso.onmicrosoft.com'
                            Direction  = 'Outbound'
                        } -ClientOnly)
                    )
                    Credential       = $Credscredential
                }

                Mock -CommandName Set-PowerAppTenantIsolationPolicy -MockWith {
                }

                Mock -CommandName Invoke-WebRequest -MockWith {
                    if ($Uri -match 'https://login.windows.net/([A-Za-z0-9.]*)/.well-known/openid-configuration')
                    {
                        $tenantid = (New-HashFromTenantName -TenantName $Matches[1])
                        $returnval = '{{"token_endpoint":"https://login.windows.net/{0}/oauth2/token"}}' -f $tenantid
                        return $returnval
                    }
                    else
                    {
                        return $null
                    }
                }

                Mock -CommandName Get-PowerAppTenantIsolationPolicy -MockWith {
                    return @{
                        properties = @{
                            tenantId       = '12345678-1234-1234-1234-123456789012'
                            isDisabled     = $true
                            allowedTenants = @()
                        }
                    }
                }
            }

            It 'Should return Enabled=False from the Get method' {
                (Get-TargetResource @testParams).Enabled | Should -Be $false
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should enable the isolation settings and create a rule in Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Set-PowerAppTenantIsolationPolicy' -Exactly 1
            }
        }

        Context -Name 'PP Tenant Isolation settings are correctly configured' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Enable           = $true
                    Rules            = @(
                        (New-CimInstance -ClassName MSFT_PPTenantRule -Property @{
                            TenantName = 'contoso.onmicrosoft.com'
                            Direction  = 'Outbound'
                        } -ClientOnly)
                    )
                    Credential       = $Credscredential
                }

                Mock -CommandName Set-PowerAppTenantIsolationPolicy -MockWith {
                }

                Mock -CommandName Invoke-WebRequest -MockWith {
                    if ($Uri -match 'https://login.windows.net/([A-Za-z0-9.]*)/.well-known/openid-configuration')
                    {
                        $tenantid = (New-HashFromTenantName -TenantName $Matches[1])
                        $returnval = '{{"token_endpoint":"https://login.windows.net/{0}/oauth2/token"}}' -f $tenantid
                        return $returnval
                    }
                    else
                    {
                        return $null
                    }
                }

                Mock -CommandName Get-PowerAppTenantIsolationPolicy -MockWith {
                    return @{
                        properties = @{
                            tenantId       = '12345678-1234-1234-1234-123456789012'
                            isDisabled     = $false
                            allowedTenants = @(
                                @{
                                    tenantId   = New-HashFromTenantName -TenantName 'contoso.onmicrosoft.com'
                                    tenantName = 'Contoso'
                                    direction  = @{
                                        inbound  = $false
                                        outbound = $true
                                    }
                                }
                            )
                        }
                    }
                }
            }

            It 'Should return Enabled=True and 1 rule from the Get method' {
                $result = Get-TargetResource @testParams
                $result.Enabled | Should -Be $true
                $result.Rules.Count | Should -Be 1
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'PP Tenant Isolation settings are enabled, but with the incorrect rules' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Enable           = $false
                    Rules            = @(
                        (New-CimInstance -ClassName MSFT_PPTenantRule -Property @{
                            TenantName = 'contoso.onmicrosoft.com'
                            Direction  = 'Both'
                        } -ClientOnly)
                    )
                    Credential       = $Credscredential
                }

                Mock -CommandName Set-PowerAppTenantIsolationPolicy -MockWith {
                    $global:M365DSCTenantId = $TenantIsolationPolicy.properties.allowedTenants[0].tenantId
                }

                Mock -CommandName Invoke-WebRequest -MockWith {
                    if ($Uri -match 'https://login.windows.net/([A-Za-z0-9.]*)/.well-known/openid-configuration')
                    {
                        $tenantid = (New-HashFromTenantName -TenantName $Matches[1])
                        $returnval = '{{"token_endpoint":"https://login.windows.net/{0}/oauth2/token"}}' -f $tenantid
                        return $returnval
                    }
                    else
                    {
                        return $null
                    }
                }

                Mock -CommandName Get-PowerAppTenantIsolationPolicy -MockWith {
                    return @{
                        properties = @{
                            tenantId       = '12345678-1234-1234-1234-123456789012'
                            isDisabled     = $false
                            allowedTenants = @(
                                @{
                                    tenantId   = New-HashFromTenantName -TenantName 'fabrikam.onmicrosoft.com'
                                    tenantName = 'Fabrikam'
                                    direction  = @{
                                        inbound  = $false
                                        outbound = $true
                                    }
                                }
                            )
                        }
                    }
                }
            }

            It 'Should return Enabled=True and 1 rule from the Get method' {
                $result = Get-TargetResource @testParams
                $result.Enabled | Should -Be $true
                $result.Rules.Count | Should -Be 1
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            $global:M365DSCTenantId = ''
            It 'Should enable the isolation settings and create a rule in Set method' {
                Set-TargetResource @testParams
                $global:M365DSCTenantId | Should -Be (New-HashFromTenantName -TenantName 'contoso.onmicrosoft.com')
                Should -Invoke -CommandName 'Set-PowerAppTenantIsolationPolicy' -Exactly 1
            }
        }

        Context -Name 'PP Tenant Isolation settings RulesToInclude specified, but rule is not included' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Enable           = $true
                    RulesToInclude   = @(
                        (New-CimInstance -ClassName MSFT_PPTenantRule -Property @{
                            TenantName = 'contoso.onmicrosoft.com'
                            Direction  = 'Both'
                        } -ClientOnly)
                    )
                    Credential       = $Credscredential
                }

                Mock -CommandName Set-PowerAppTenantIsolationPolicy -MockWith {
                    $global:M365DSCTenantIds = $TenantIsolationPolicy.properties.allowedTenants.tenantId
                }

                Mock -CommandName Invoke-WebRequest -MockWith {
                    if ($Uri -match 'https://login.windows.net/([A-Za-z0-9.]*)/.well-known/openid-configuration')
                    {
                        $tenantid = (New-HashFromTenantName -TenantName $Matches[1])
                        $returnval = '{{"token_endpoint":"https://login.windows.net/{0}/oauth2/token"}}' -f $tenantid
                        return $returnval
                    }
                    else
                    {
                        return $null
                    }
                }

                Mock -CommandName Get-PowerAppTenantIsolationPolicy -MockWith {
                    return @{
                        properties = @{
                            tenantId       = '12345678-1234-1234-1234-123456789012'
                            isDisabled     = $false
                            allowedTenants = @(
                                @{
                                    tenantId   = New-HashFromTenantName -TenantName 'fabrikam.onmicrosoft.com'
                                    tenantName = 'Fabrikam'
                                    direction  = @{
                                        inbound  = $false
                                        outbound = $true
                                    }
                                }
                            )
                        }
                    }
                }
            }

            It 'Should return Enabled=True and 1 rule from the Get method' {
                $result = Get-TargetResource @testParams
                $result.Enabled | Should -Be $true
                $result.Rules.Count | Should -Be 1
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            $global:M365DSCTenantIds = ''
            It 'Should add a rule in Set method' {
                Set-TargetResource @testParams
                $global:M365DSCTenantIds.Count | Should -Be 2
                Should -Invoke -CommandName 'Set-PowerAppTenantIsolationPolicy' -Exactly 1
            }
        }

        Context -Name 'PP Tenant Isolation settings RulesToInclude specified and rule is included' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Enable           = $true
                    RulesToInclude   = @(
                        (New-CimInstance -ClassName MSFT_PPTenantRule -Property @{
                            TenantName = 'contoso.onmicrosoft.com'
                            Direction  = 'Both'
                        } -ClientOnly)
                    )
                    Credential       = $Credscredential
                }

                Mock -CommandName Set-PowerAppTenantIsolationPolicy -MockWith {
                    $global:M365DSCTenantIds = $TenantIsolationPolicy.properties.allowedTenants.tenantId
                }

                Mock -CommandName Invoke-WebRequest -MockWith {
                    if ($Uri -match 'https://login.windows.net/([A-Za-z0-9.]*)/.well-known/openid-configuration')
                    {
                        $tenantid = (New-HashFromTenantName -TenantName $Matches[1])
                        $returnval = '{{"token_endpoint":"https://login.windows.net/{0}/oauth2/token"}}' -f $tenantid
                        return $returnval
                    }
                    else
                    {
                        return $null
                    }
                }

                Mock -CommandName Get-PowerAppTenantIsolationPolicy -MockWith {
                    return @{
                        properties = @{
                            tenantId       = '12345678-1234-1234-1234-123456789012'
                            isDisabled     = $false
                            allowedTenants = @(
                                @{
                                    tenantId   = New-HashFromTenantName -TenantName 'contoso.onmicrosoft.com'
                                    tenantName = 'Contoso'
                                    direction  = @{
                                        inbound  = $true
                                        outbound = $true
                                    }
                                }
                            )
                        }
                    }
                }
            }

            It 'Should return Enabled=True and 1 rule from the Get method' {
                $result = Get-TargetResource @testParams
                $result.Enabled | Should -Be $true
                $result.Rules.Count | Should -Be 1
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'PP Tenant Isolation settings RulesToExclude specified, but rule is included' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Enable           = $true
                    RulesToExclude   = @(
                        (New-CimInstance -ClassName MSFT_PPTenantRule -Property @{
                            TenantName = 'contoso.onmicrosoft.com'
                            Direction  = 'Both'
                        } -ClientOnly)
                    )
                    Credential       = $Credscredential
                }

                Mock -CommandName Set-PowerAppTenantIsolationPolicy -MockWith {
                    $global:M365DSCTenantIds = $TenantIsolationPolicy.properties.allowedTenants.tenantId
                }

                Mock -CommandName Invoke-WebRequest -MockWith {
                    if ($Uri -match 'https://login.windows.net/([A-Za-z0-9.]*)/.well-known/openid-configuration')
                    {
                        $tenantid = (New-HashFromTenantName -TenantName $Matches[1])
                        $returnval = '{{"token_endpoint":"https://login.windows.net/{0}/oauth2/token"}}' -f $tenantid
                        return $returnval
                    }
                    else
                    {
                        return $null
                    }
                }

                Mock -CommandName Get-PowerAppTenantIsolationPolicy -MockWith {
                    return @{
                        properties = @{
                            tenantId       = '12345678-1234-1234-1234-123456789012'
                            isDisabled     = $false
                            allowedTenants = @(
                                @{
                                    tenantId   = New-HashFromTenantName -TenantName 'fabrikam.onmicrosoft.com'
                                    tenantName = 'Fabrikam'
                                    direction  = @{
                                        inbound  = $false
                                        outbound = $true
                                    }
                                }
                                @{
                                    tenantId   = New-HashFromTenantName -TenantName 'contoso.onmicrosoft.com'
                                    tenantName = 'Contoso'
                                    direction  = @{
                                        inbound  = $false
                                        outbound = $true
                                    }
                                }
                            )
                        }
                    }
                }
            }

            It 'Should return Enabled=True and 1 rule from the Get method' {
                $result = Get-TargetResource @testParams
                $result.Enabled | Should -Be $true
                $result.Rules.Count | Should -Be 2
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            $global:M365DSCTenantIds = ''
            It 'Should remove a rule in Set method' {
                Set-TargetResource @testParams
                $global:M365DSCTenantIds.Count | Should -Be 1
                Should -Invoke -CommandName 'Set-PowerAppTenantIsolationPolicy' -Exactly 1
            }
        }

        Context -Name 'PP Tenant Isolation settings RulesToExclude specified and rule is not included' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Enable           = $true
                    RulesToExclude   = @(
                        (New-CimInstance -ClassName MSFT_PPTenantRule -Property @{
                            TenantName = 'contoso.onmicrosoft.com'
                            Direction  = 'Both'
                        } -ClientOnly)
                    )
                    Credential       = $Credscredential
                }

                Mock -CommandName Set-PowerAppTenantIsolationPolicy -MockWith {
                    $global:M365DSCTenantIds = $TenantIsolationPolicy.properties.allowedTenants.tenantId
                }

                Mock -CommandName Invoke-WebRequest -MockWith {
                    if ($Uri -match 'https://login.windows.net/([A-Za-z0-9.]*)/.well-known/openid-configuration')
                    {
                        $tenantid = (New-HashFromTenantName -TenantName $Matches[1])
                        $returnval = '{{"token_endpoint":"https://login.windows.net/{0}/oauth2/token"}}' -f $tenantid
                        return $returnval
                    }
                    else
                    {
                        return $null
                    }
                }

                Mock -CommandName Get-PowerAppTenantIsolationPolicy -MockWith {
                    return @{
                        properties = @{
                            tenantId       = '12345678-1234-1234-1234-123456789012'
                            isDisabled     = $false
                            allowedTenants = @(
                                @{
                                    tenantId   = New-HashFromTenantName -TenantName 'fabrikam.onmicrosoft.com'
                                    tenantName = 'Fabrikam'
                                    direction  = @{
                                        inbound  = $true
                                        outbound = $true
                                    }
                                }
                            )
                        }
                    }
                }
            }

            It 'Should return Enabled=True and 1 rule from the Get method' {
                $result = Get-TargetResource @testParams
                $result.Enabled | Should -Be $true
                $result.Rules.Count | Should -Be 1
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

                Mock -CommandName Invoke-WebRequest -MockWith {
                    if ($Uri -match 'https://login.windows.net/([A-Za-z0-9.]*)/.well-known/openid-configuration')
                    {
                        $tenantid = (New-HashFromTenantName -TenantName $Matches[1])
                        $returnval = '{{"token_endpoint":"https://login.windows.net/{0}/oauth2/token"}}' -f $tenantid
                        return $returnval
                    }
                    else
                    {
                        return $null
                    }
                }

                Mock -CommandName Get-PowerAppTenantIsolationPolicy -MockWith {
                    return @{
                        properties = @{
                            tenantId       = '12345678-1234-1234-1234-123456789012'
                            isDisabled     = $false
                            allowedTenants = @(
                                @{
                                    tenantId   = New-HashFromTenantName -TenantName 'fabrikam.onmicrosoft.com'
                                    tenantName = 'Fabrikam'
                                    direction  = @{
                                        inbound  = $false
                                        outbound = $true
                                    }
                                }
                                @{
                                    tenantId   = New-HashFromTenantName -TenantName 'contoso.onmicrosoft.com'
                                    tenantName = 'Contoso'
                                    direction  = @{
                                        inbound  = $false
                                        outbound = $true
                                    }
                                }
                            )
                        }
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    } #inmodulescope
} #describe

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
