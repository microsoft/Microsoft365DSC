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
    -DscResource 'EXOTransportConfig' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Set-TransportConfig -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                        = 'Yes'
                    ClearCategories                         = $True
                    ConvertDisclaimerWrapperToEml           = $False
                    DSNConversionMode                       = 'PreserveDSNBody'
                    ExternalDelayDsnEnabled                 = $True
                    ExternalDsnLanguageDetectionEnabled     = $True
                    ExternalDsnSendHtml                     = $True
                    ExternalPostmasterAddress               = 'postmaster@contoso.com'
                    HeaderPromotionModeSetting              = 'NoCreate'
                    InternalDelayDsnEnabled                 = $True
                    InternalDsnLanguageDetectionEnabled     = $True
                    InternalDsnSendHtml                     = $True
                    JournalingReportNdrTo                   = '<>'
                    JournalMessageExpirationDays            = 0
                    MaxRecipientEnvelopeLimit               = 'Unlimited'
                    ReplyAllStormBlockDurationHours         = 6
                    ReplyAllStormDetectionMinimumRecipients = 2500
                    ReplyAllStormDetectionMinimumReplies    = 10
                    ReplyAllStormProtectionEnabled          = $True
                    Rfc2231EncodingEnabled                  = $False
                    SmtpClientAuthenticationDisabled        = $True
                    Credential                              = $Credential
                }

                Mock -CommandName Get-TransportConfig -MockWith {
                    return @{
                        ClearCategories                         = $True
                        ConvertDisclaimerWrapperToEml           = $False
                        DSNConversionMode                       = 'PreserveDSNBody'
                        ExternalDelayDsnEnabled                 = $True
                        ExternalDsnLanguageDetectionEnabled     = $True
                        ExternalDsnSendHtml                     = $True
                        ExternalPostmasterAddress               = 'postmaster@contoso.com'
                        HeaderPromotionModeSetting              = 'NoCreate'
                        InternalDelayDsnEnabled                 = $True
                        InternalDsnLanguageDetectionEnabled     = $True
                        InternalDsnSendHtml                     = $True
                        JournalingReportNdrTo                   = '<>'
                        JournalMessageExpirationDays            = 0
                        MaxRecipientEnvelopeLimit               = 'Unlimited'
                        ReplyAllStormBlockDurationHours         = 6
                        ReplyAllStormDetectionMinimumRecipients = 2500
                        ReplyAllStormDetectionMinimumReplies    = 10
                        ReplyAllStormProtectionEnabled          = $True
                        Rfc2231EncodingEnabled                  = $False
                        SmtpClientAuthenticationDisabled        = $True
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Values from the Get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-TransportConfig'
            }
        }

        Context -Name 'Values are not in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                        = 'Yes'
                    ClearCategories                         = $True
                    ConvertDisclaimerWrapperToEml           = $False
                    DSNConversionMode                       = 'PreserveDSNBody'
                    ExternalDelayDsnEnabled                 = $True
                    ExternalDsnLanguageDetectionEnabled     = $True
                    ExternalDsnSendHtml                     = $True
                    ExternalPostmasterAddress               = 'postmaster@contoso.com'
                    HeaderPromotionModeSetting              = 'NoCreate'
                    InternalDelayDsnEnabled                 = $True
                    InternalDsnLanguageDetectionEnabled     = $True
                    InternalDsnSendHtml                     = $True
                    JournalingReportNdrTo                   = '<>'
                    JournalMessageExpirationDays            = 0
                    MaxRecipientEnvelopeLimit               = 'Unlimited'
                    ReplyAllStormBlockDurationHours         = 6
                    ReplyAllStormDetectionMinimumRecipients = 2500
                    ReplyAllStormDetectionMinimumReplies    = 10
                    ReplyAllStormProtectionEnabled          = $True
                    Rfc2231EncodingEnabled                  = $False
                    SmtpClientAuthenticationDisabled        = $True
                    Credential                              = $Credential
                }

                Mock -CommandName Get-TransportConfig -MockWith {
                    return @{
                        ClearCategories                         = $False
                        ConvertDisclaimerWrapperToEml           = $False
                        DSNConversionMode                       = 'PreserveDSNBody'
                        ExternalDelayDsnEnabled                 = $True
                        ExternalDsnLanguageDetectionEnabled     = $True
                        ExternalDsnSendHtml                     = $True
                        ExternalPostmasterAddress               = 'postmaster@fabrikam.com'
                        HeaderPromotionModeSetting              = 'NoCreate'
                        InternalDelayDsnEnabled                 = $True
                        InternalDsnLanguageDetectionEnabled     = $True
                        InternalDsnSendHtml                     = $True
                        JournalingReportNdrTo                   = '<>'
                        JournalMessageExpirationDays            = 0
                        MaxRecipientEnvelopeLimit               = 'Unlimited'
                        ReplyAllStormBlockDurationHours         = 4
                        ReplyAllStormDetectionMinimumRecipients = 2500
                        ReplyAllStormDetectionMinimumReplies    = 10
                        ReplyAllStormProtectionEnabled          = $True
                        Rfc2231EncodingEnabled                  = $False
                        SmtpClientAuthenticationDisabled        = $True
                        Credential                              = $Credential
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Set-TransportConfig' -Exactly 1
            }

            It 'Should return Values from the Get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-TransportConfig'
            }
        }

        Context -Name 'Get command returns null' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                        = 'Yes'
                    ClearCategories                         = $True
                    ConvertDisclaimerWrapperToEml           = $False
                    DSNConversionMode                       = 'PreserveDSNBody'
                    ExternalDelayDsnEnabled                 = $True
                    ExternalDsnLanguageDetectionEnabled     = $True
                    ExternalDsnSendHtml                     = $True
                    ExternalPostmasterAddress               = 'postmaster@contoso.com'
                    HeaderPromotionModeSetting              = 'NoCreate'
                    InternalDelayDsnEnabled                 = $True
                    InternalDsnLanguageDetectionEnabled     = $True
                    InternalDsnSendHtml                     = $True
                    JournalingReportNdrTo                   = '<>'
                    JournalMessageExpirationDays            = 0
                    MaxRecipientEnvelopeLimit               = 'Unlimited'
                    ReplyAllStormBlockDurationHours         = 6
                    ReplyAllStormDetectionMinimumRecipients = 2500
                    ReplyAllStormDetectionMinimumReplies    = 10
                    ReplyAllStormProtectionEnabled          = $True
                    Rfc2231EncodingEnabled                  = $False
                    SmtpClientAuthenticationDisabled        = $True
                    Credential                              = $Credential
                }

                Mock -CommandName Get-TransportConfig -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Set-TransportConfig' -Exactly 1
            }

            It 'Should return Values from the Get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-TransportConfig'
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-TransportConfig -MockWith {
                    return @{
                        ClearCategories                         = $True
                        ConvertDisclaimerWrapperToEml           = $False
                        DSNConversionMode                       = 'PreserveDSNBody'
                        ExternalDelayDsnEnabled                 = $True
                        ExternalDsnLanguageDetectionEnabled     = $True
                        ExternalDsnSendHtml                     = $True
                        ExternalPostmasterAddress               = 'postmaster@contoso.com'
                        HeaderPromotionModeSetting              = 'NoCreate'
                        InternalDelayDsnEnabled                 = $True
                        InternalDsnLanguageDetectionEnabled     = $True
                        InternalDsnSendHtml                     = $True
                        JournalingReportNdrTo                   = '<>'
                        JournalMessageExpirationDays            = 0
                        MaxRecipientEnvelopeLimit               = 'Unlimited'
                        ReplyAllStormBlockDurationHours         = 6
                        ReplyAllStormDetectionMinimumRecipients = 2500
                        ReplyAllStormDetectionMinimumReplies    = 10
                        ReplyAllStormProtectionEnabled          = $True
                        Rfc2231EncodingEnabled                  = $False
                        SmtpClientAuthenticationDisabled        = $True
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
