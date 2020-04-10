[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Microsoft365.psm1" `
            -Resolve)
)
$GenericStubPath = (Join-Path -Path $PSScriptRoot `
    -ChildPath "..\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "SCDLPCompliancePolicy" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Import-PSSession -MockWith {

        }

        Mock -CommandName New-PSSession -MockWith {

        }

        Mock -CommandName Remove-DLPCompliancePolicy -MockWith {

        }

        Mock -CommandName New-DLPCompliancePolicy -MockWith {
            return @{

            }
        }

        # Test contexts
        Context -Name "Policy doesn't already exist" -Fixture {
            $testParams = @{
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
                Priority           = 1
                SharePointLocation = "https://contoso.sharepoint.com/sites/demo"
                Name               = 'TestPolicy'
            }

            Mock -CommandName Get-DLPCompliancePolicy -MockWith {
                return $null
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Policy already exists" -Fixture {
            $testParams = @{
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
                Priority           = 1
                Mode               = "Enable"
                SharePointLocation = @("https://contoso.sharepoint.com/sites/demo")
                Name               = 'TestPolicy'
            }

            Mock -CommandName Get-DLPCompliancePolicy -MockWith {
                return @{
                    Name               = "TestPolicy"
                    Priority           = 1
                    Mode               = "Enable"
                    SharePointLocation = @(
                        @{
                            Name = "https://contoso.sharepoint.com/sites/demo"
                        }
                    )
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Should recreate from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "Policy should not exist" -Fixture {
            $testParams = @{
                Ensure             = 'Absent'
                GlobalAdminAccount = $GlobalAdminAccount
                SharePointLocation = "https://contoso.sharepoint.com/sites/demo"
                Name               = 'TestPolicy'
            }

            Mock -CommandName Get-DLPCompliancePolicy -MockWith {
                return @{
                    Name = "TestPolicy"
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It 'Should delete from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "Policy Exists but Needs to Update Settings" -Fixture {
            $testParams = @{
                Ensure                      = 'Present'
                GlobalAdminAccount          = $GlobalAdminAccount
                SharePointLocation          = @("https://contoso.sharepoint.com/sites/demo", "https://northwind.com")
                SharePointLocationException = @("https://contoso.sharepoint.com/sites/ex", "https://northwind.com/ex")
                OneDriveLocation            = @("https://contoso.sharepoint.com/sites/demo", "https://northwind.com")
                ExchangeLocation            = @("https://owa.contoso.com")
                OneDriveLocationException   = @("https://tailspin.com/sites/", "https://tailspin.com/od")
                TeamsLocation               = @("john.smith@contoso.com", "jane.doe@contoso.com")
                TeamsLocationException      = @("https://contoso.sharepoint.com/sites/ex", "https://northwind.com/ex")
                Name                        = 'TestPolicy'
            }

            Mock -CommandName Get-DLPCompliancePolicy -MockWith {
                return @{
                    Name                        = "TestPolicy"
                    ExchangeLocation            = @("https://owa.tailspin.com")
                    SharePointLocation          = @(
                        @{
                            Name = "https://contoso.sharepoint.com/sites/demo"
                        },
                        @{
                            Name = "https://tailspin.com"
                        }
                    )
                    SharePointLocationException = @("https://contoso.sharepoint.com/od", "https://northwind.com/ex")
                    OneDriveLocation            = @(
                        @{
                            Name = "https://contoso.sharepoint.com/sites/demo"
                        },
                        @{
                            Name = 'https://tailspin.com'
                        }
                    )
                    OneDriveLocationException   = @("https://tailspin.com/sites/", "https://tailspin.com")
                    TeamsLocation               = @(
                        @{
                            Name = "john.smith@contoso.com"
                        },
                        @{
                            Name = 'bob.houle@contoso.com'
                        }
                    )
                    TeamsLocationException      = @("https://tailspin.com/sites/", "https://tailspin.com")
                }
            }

            It 'Should update location from the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-DLPCompliancePolicy -MockWith {
                return @{
                    Name                        = "TestPolicy"
                    ExchangeLocation            = @("https://owa.tailspin.com")
                    SharePointLocation          = @(
                        @{
                            Name = "https://contoso.sharepoint.com/sites/demo"
                        },
                        @{
                            Name = "https://tailspin.com"
                        }
                    )
                    SharePointLocationException = @("https://contoso.sharepoint.com/od", "https://northwind.com/ex")
                    OneDriveLocation            = @(
                        @{
                            Name = "https://contoso.sharepoint.com/sites/demo"
                        },
                        @{
                            Name = 'https://tailspin.com'
                        }
                    )
                    OneDriveLocationException   = @("https://tailspin.com/sites/", "https://tailspin.com")
                    TeamsLocation               = @(
                        @{
                            Name = "john.smith@contoso.com"
                        },
                        @{
                            Name = 'bob.houle@contoso.com'
                        }
                    )
                    TeamsLocationException      = @("https://tailspin.com/sites/", "https://tailspin.com")
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
