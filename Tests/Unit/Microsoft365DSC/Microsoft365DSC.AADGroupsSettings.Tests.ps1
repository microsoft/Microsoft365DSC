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
    -DscResource "AADGroupsSettings" -GenericStubModule $GenericStubPath
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

            try
            {
                Add-Type -PassThru -TypeDefinition @"
                    namespace Contoso.Model.AADGroupsSettings {
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
                                    if (keyName == "UsageGuidelinesUrl")
                                    {
                                        return "https://contoso.com/usage";
                                    }
                                    else if (keyName == "AllowToAddGuests")
                                    {
                                        return "true";
                                    }
                                    else if (keyName == "GroupCreationAllowedGroupId")
                                    {
                                        return "12345-12345-12345-12345-12345";
                                    }
                                    else if (keyName == "GuestUsageGuidelinesUrl")
                                    {
                                        return "https://contoso.com/guestusage";
                                    }
                                    else if (keyName == "AllowGuestsToAccessGroups")
                                    {
                                        return "true";
                                    }
                                    else if (keyName == "AllowGuestsToBeGroupOwner")
                                    {
                                        return "true";
                                    }
                                    else if (keyName == "EnableGroupCreation")
                                    {
                                        return "true";
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
            catch
            {
                Write-Verbose -Message "Type already loaded"
            }

            Mock -CommandName "Get-AzureADGroup" -MockWith {
                return @{
                    ObjectId = "12345-12345-12345-12345-12345"
                    DisplayName = "All Company"
                }
            }
        }

        # Test contexts
        Context -Name "The Policy should exist but it DOES NOT" -Fixture {
                BeforeAll {
                $Script:calledOnceAlready = $false
                $testParams = @{
                    AllowGuestsToAccessGroups     = $True;
                    AllowGuestsToBeGroupOwner     = $True;
                    AllowToAddGuests              = $True;
                    EnableGroupCreation           = $True;
                    Ensure                        = "Present";
                    GlobalAdminAccount            = $GlobalAdminAccount;
                    GroupCreationAllowedGroupName = "All Company";
                    GuestUsageGuidelinesUrl       = "https://contoso.com/guestusage";
                    IsSingleInstance              = "Yes";
                    UsageGuidelinesUrl            = "https://contoso.com/usage";
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }
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
                        $setting = New-Object 'Contoso.Model.AADGroupsSettings.DirectorySetting'
                        return $setting
                    }
                }
            }
            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                Should -Invoke -CommandName "Get-AzureADDirectorySetting" -Exactly 1
            }

            It 'Should return true from the Test method' {
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
                        $setting = New-Object 'Contoso.Model.AADGroupsSettings.DirectorySetting'
                        return $setting
                    }
                }
            }
            It 'Should create and set the settings the Set method' {
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
                    Ensure                        = "Absent"
                    GlobalAdminAccount            = $GlobalAdminAccount;
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-AzureADDirectorySetting -MockWith {
                    $setting = New-Object 'Contoso.Model.AADGroupsSettings.DirectorySetting'
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

            It 'Should Prevent Remove the Policy from the Set method' {
                {Set-TargetResource @testParams} | Should -Throw "The AADGroupsSettings resource cannot delete existing Directory Setting entries. Please specify Present."
            }
        }
        Context -Name "The Policy Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowGuestsToAccessGroups     = $True;
                    AllowGuestsToBeGroupOwner     = $True;
                    AllowToAddGuests              = $True;
                    EnableGroupCreation           = $True;
                    Ensure                        = "Present";
                    GlobalAdminAccount            = $GlobalAdminAccount;
                    GroupCreationAllowedGroupName = "All Company";
                    GuestUsageGuidelinesUrl       = "https://contoso.com/guestusage";
                    IsSingleInstance              = "Yes";
                    UsageGuidelinesUrl            = "https://contoso.com/usage";
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-AzureADDirectorySetting -MockWith {
                    $setting = New-Object 'Contoso.Model.AADGroupsSettings.DirectorySetting'
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
                    AllowGuestsToAccessGroups     = $True;
                    AllowGuestsToBeGroupOwner     = $True;
                    AllowToAddGuests              = $True;
                    EnableGroupCreation           = $False; #Drift
                    Ensure                        = "Present";
                    GlobalAdminAccount            = $GlobalAdminAccount;
                    GroupCreationAllowedGroupName = "All Company";
                    GuestUsageGuidelinesUrl       = "https://contoso.com/guestusage";
                    IsSingleInstance              = "Yes";
                    UsageGuidelinesUrl            = "https://contoso.com/usage";
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-AzureADDirectorySetting -MockWith {
                    $setting = New-Object 'Contoso.Model.AADGroupsSettings.DirectorySetting'
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

                Mock -CommandName Get-AzureADDirectorySetting -MockWith {
                    $setting = New-Object 'Contoso.Model.AADGroupsSettings.DirectorySetting'
                    return $setting
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
