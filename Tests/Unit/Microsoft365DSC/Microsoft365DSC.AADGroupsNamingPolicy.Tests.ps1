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
    -DscResource "AADGroupsNamingPolicy" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

            }

            Mock -CommandName Set-AzureADDirectorySetting -MockWith {

            }

            Mock -CommandName Remove-AzureADDirectorySetting -MockWith {

            }

            Mock -CommandName New-AzureADDirectorySetting -MockWith {

            }

            Mock -CommandName Get-AzureADDirectorySettingTemplate -MockWith {
                $object = [PSCustomObject]::new()
                $object | Add-Member -MemberType ScriptMethod -Name "CreateDirectorySetting" -Value {return [PSCustomObject]::new()} -PassThru
                return $object
            }

            Add-Type -PassThru -TypeDefinition @"
                namespace Contoso.Model {
                    public class SettingValue {
                        public string Name {get; set;}
                        public string Value {get; set;}
                    }

                    public class DirectorySetting {

                        public System.Collections.Generic.List<SettingValue> Values {get; set;}
                        public System.Collections.Generic.List<SettingValue> _values = new System.Collections.Generic.List<SettingValue>();
                        public string this[string keyName]
                        {
                            get {
                                if (keyName == "CustomBlockedWordsList")
                                {
                                    return "CEO,Test";
                                }
                                else if (keyName == "PrefixSuffixNamingRequirement")
                                {
                                    return "[Title]Bob[Company][GroupName][Office]Nik";
                                }
                                return "";
                            }
                            set {}
                        }
                        public string DisplayName {get {return "Group.Unified";}}
                        public string Id {get {return "12345-12345-12345-12345-12345";}}

                        public DirectorySetting (){}
                    }
                }
"@
    }

        # Test contexts
        Context -Name "The Policy should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $Script:calledOnceAlready = $false
                $testParams = @{
                    IsSingleInstance              = "Yes";
                    PrefixSuffixNamingRequirement = "[Title]Bob[Company][GroupName][Office]Nik"
                    CustomBlockedWordsList        = @("CEO", "Test")
                    Ensure                        = "Present"
                    GlobalAdminAccount            = $GlobalAdminAccount;
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                Should -Invoke -CommandName "Get-AzureADDirectorySetting" -Exactly 1
            }


            BeforeEach {
                Mock -CommandName Get-AzureADDirectorySetting -MockWith {
                    if (-not $Script:calledOnceAlready)
                    {
                        $Script:calledOnceAlready = $true
                        return $null
                    }
                    else
                    {
                        $setting = New-Object 'Contoso.Model.DirectorySetting'
                        return $setting
                    }
                }
            }
            It 'Should return false from the Test method' {
                $Script:calledOnceAlready = $false
                Test-TargetResource @testParams | Should -Be $false
            }

            BeforeEach {
                Mock -CommandName Get-AzureADDirectorySetting -MockWith {
                    if (-not $Script:calledOnceAlready)
                    {
                        $Script:calledOnceAlready = $true
                        return $null
                    }
                    else
                    {
                        $setting = New-Object 'Contoso.Model.DirectorySetting'
                        return $setting
                    }
                }
            }
            It 'Should Create the Policy from the Set method' {
                $Script:calledOnceAlready = $false
                Set-TargetResource @testParams
                Should -Invoke -CommandName "New-AzureADDirectorySetting" -Exactly 1
                Should -Invoke -CommandName "Set-AzureADDirectorySetting" -Exactly 1
            }
        }

        Context -Name "The Policy exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance              = "Yes";
                    PrefixSuffixNamingRequirement = "[Title]Bob[Company][GroupName][Office]Nik"
                    CustomBlockedWordsList        = @("CEO", "Test")
                    Ensure                        = "Absent"
                    GlobalAdminAccount            = $GlobalAdminAccount;
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-AzureADDirectorySetting -MockWith {
                    $setting = New-Object 'Contoso.Model.DirectorySetting'
                    return $setting
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                Should -Invoke -CommandName "Get-AzureADDirectorySetting" -Exactly 1
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "Remove-AzureADDirectorySetting" -Exactly 1
            }
        }
        Context -Name "The Policy Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance              = "Yes";
                    PrefixSuffixNamingRequirement = "[Title]Bob[Company][GroupName][Office]Nik"
                    CustomBlockedWordsList        = @("CEO", "Test")
                    Ensure                        = "Present"
                    GlobalAdminAccount            = $GlobalAdminAccount;
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-AzureADDirectorySetting -MockWith {
                    $setting = New-Object 'Contoso.Model.DirectorySetting'
                    return $setting
                }
            }

            It "Should return Values from the Get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-AzureADDirectorySetting" -Exactly 1
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "Values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance              = "Yes";
                    PrefixSuffixNamingRequirement = "[GroupName]Drift" #Drift
                    CustomBlockedWordsList        = @("CEO", "Test")
                    Ensure                        = "Present"
                    GlobalAdminAccount            = $GlobalAdminAccount;
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-AzureADDirectorySetting -MockWith {
                    $setting = New-Object 'Contoso.Model.DirectorySetting'
                    return $setting
                }
            }

            It "Should return Values from the Get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-AzureADDirectorySetting" -Exactly 1
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Set-AzureADDirectorySetting' -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-AzureADDirectorySetting -MockWith {
                    $setting = New-Object 'Contoso.Model.DirectorySetting'
                    return $setting
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
