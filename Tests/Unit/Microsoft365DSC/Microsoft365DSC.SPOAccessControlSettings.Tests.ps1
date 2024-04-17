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
    -DscResource 'SPOAccessControlSettings' -GenericStubModule $GenericStubPath

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

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'PNP AccessControl settings are not configured' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential                   = $Credential
                    IsSingleInstance             = 'Yes'
                    DisplayStartASiteOption      = $false
                    StartASiteFormUrl            = 'https://o365dsc1.sharepoint.com'
                    IPAddressEnforcement         = $false
                    #IPAddressAllowList           = "" #would generate an error while writing this resource
                    IPAddressWACTokenLifetime    = 15
                    DisallowInfectedFileDownload = $false
                    ExternalServicesEnabled      = $true
                    EmailAttestationRequired     = $false
                    EmailAttestationReAuthDays   = 30
                }

                Mock -CommandName Set-PnPTenant -MockWith {
                    return @{
                        DisplayStartASiteOption      = $false
                        StartASiteFormUrl            = 'https://o365dsc1.sharepoint.com'
                        IPAddressEnforcement         = $false
                        #IPAddressAllowList           = "" #would generate an error while writing this resource
                        IPAddressWACTokenLifetime    = 15
                        DisallowInfectedFileDownload = $false
                        ExternalServicesEnabled      = $true
                        EmailAttestationRequired     = $false
                        EmailAttestationReAuthDays   = 30
                    }
                }

                Mock -CommandName Get-PnPTenant -MockWith {
                    return @{
                        DisplayStartASiteOption      = $true
                        StartASiteFormUrl            = 'https://o365dsc1.sharepoint.com'
                        IPAddressEnforcement         = $false
                        #IPAddressAllowList           = "" #would generate an error while writing this resource
                        IPAddressWACTokenLifetime    = 20
                        DisallowInfectedFileDownload = $false
                        ExternalServicesEnabled      = $true
                        EmailAttestationRequired     = $false
                        EmailAttestationReAuthDays   = 29
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Sets the tenant AccessControl settings in Set method' {
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

                Mock -CommandName Get-PnPTenant -MockWith {
                    return @{
                        DisplayStartASiteOption      = $false
                        StartASiteFormUrl            = 'https://o365dsc1.sharepoint.com'
                        IPAddressEnforcement         = $false
                        #IPAddressAllowList           = "" #would generate an error while writing this resource
                        IPAddressWACTokenLifetime    = 15
                        DisallowInfectedFileDownload = $false
                        ExternalServicesEnabled      = $true
                        EmailAttestationRequired     = $false
                        EmailAttestationReAuthDays   = 30
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }#inmodulescope
}#describe

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
