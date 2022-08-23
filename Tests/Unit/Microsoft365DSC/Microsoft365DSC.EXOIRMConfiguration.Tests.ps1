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
    -DscResource "EXOIRMConfiguration" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

            }

            Mock -CommandName Set-IRMConfiguration -MockWith {

            }
        }

        # Test contexts
        Context -Name "Configuration needs updating" -Fixture {
            BeforeAll {
                $testParams = @{
                    AutomaticServiceUpdateEnabled              = $True;
                    AzureRMSLicensingEnabled                   = $True;
                    Credential                                 = $Credential;
                    DecryptAttachmentForEncryptOnly            = $False;
                    EDiscoverySuperUserEnabled                 = $True;
                    EnablePdfEncryption                        = $False;
                    Ensure                                     = "Present";
                    Identity                                   = "Test Config";
                    InternalLicensingEnabled                   = $True;
                    JournalReportDecryptionEnabled             = $True;
                    LicensingLocation                          = @("https://contoso.com/_wmcs/licensing");
                    RejectIfRecipientHasNoRights               = $False;
                    SearchEnabled                              = $True;
                    SimplifiedClientAccessDoNotForwardDisabled = $False;
                    SimplifiedClientAccessEnabled              = $True;
                    SimplifiedClientAccessEncryptOnlyDisabled  = $False;
                    TransportDecryptionSetting                 = "Optional";
                }

                Mock -CommandName Get-IRMConfiguration  -MockWith {
                    return @{
                        AutomaticServiceUpdateEnabled              = $True;
                        AzureRMSLicensingEnabled                   = $True;
                        DecryptAttachmentForEncryptOnly            = $False;
                        EDiscoverySuperUserEnabled                 = $True;
                        EnablePdfEncryption                        = $True; #Drift
                        Identity                                   = "Test Config";
                        InternalLicensingEnabled                   = $True;
                        JournalReportDecryptionEnabled             = $True;
                        LicensingLocation                          = @("https://contoso.com/_wmcs/licensing");
                        RejectIfRecipientHasNoRights               = $False;
                        SearchEnabled                              = $True;
                        SimplifiedClientAccessDoNotForwardDisabled = $False;
                        SimplifiedClientAccessEnabled              = $True;
                        SimplifiedClientAccessEncryptOnlyDisabled  = $False;
                        TransportDecryptionSetting                 = "Optional";
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-IRMConfiguration -Exactly 1
            }
        }

        Context -Name "Update not required." -Fixture {
            BeforeAll {
                $testParams = @{
                    AutomaticServiceUpdateEnabled              = $True;
                    AzureRMSLicensingEnabled                   = $True;
                    Credential                                 = $Credential;
                    DecryptAttachmentForEncryptOnly            = $False;
                    EDiscoverySuperUserEnabled                 = $True;
                    EnablePdfEncryption                        = $False;
                    Ensure                                     = "Present";
                    Identity                                   = "Test Config";
                    InternalLicensingEnabled                   = $True;
                    JournalReportDecryptionEnabled             = $True;
                    LicensingLocation                          = @("https://contoso.com/_wmcs/licensing");
                    RejectIfRecipientHasNoRights               = $False;
                    SearchEnabled                              = $True;
                    SimplifiedClientAccessDoNotForwardDisabled = $False;
                    SimplifiedClientAccessEnabled              = $True;
                    SimplifiedClientAccessEncryptOnlyDisabled  = $False;
                    TransportDecryptionSetting                 = "Optional";
                }

                Mock -CommandName Get-IRMConfiguration  -MockWith {
                    return @{
                        AutomaticServiceUpdateEnabled              = $True;
                        AzureRMSLicensingEnabled                   = $True;
                        DecryptAttachmentForEncryptOnly            = $False;
                        EDiscoverySuperUserEnabled                 = $True;
                        EnablePdfEncryption                        = $False
                        Identity                                   = "Test Config";
                        InternalLicensingEnabled                   = $True;
                        JournalReportDecryptionEnabled             = $True;
                        LicensingLocation                          = @("https://contoso.com/_wmcs/licensing");
                        RejectIfRecipientHasNoRights               = $False;
                        SearchEnabled                              = $True;
                        SimplifiedClientAccessDoNotForwardDisabled = $False;
                        SimplifiedClientAccessEnabled              = $True;
                        SimplifiedClientAccessEncryptOnlyDisabled  = $False;
                        TransportDecryptionSetting                 = "Optional";
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
