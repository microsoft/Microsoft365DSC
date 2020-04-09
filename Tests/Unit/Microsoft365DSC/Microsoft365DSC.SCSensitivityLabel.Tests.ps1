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
    -DscResource "SCSensitivityLabel" -GenericStubModule $GenericStubPath
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

        Mock -CommandName Remove-Label -MockWith {
        }

        Mock -CommandName New-Label -MockWith {
            return @{

            }
        }

        Mock -CommandName Set-Label -MockWith {
            return @{

            }
        }

        # Test contexts
        Context -Name "Label doesn't already exist" -Fixture {
            $testParams = @{
                Name               = "TestLabel"
                Comment            = "This is a test label"
                Tooltip            = "Test tool tip"
                DisplayName        = "Test label"
                ParentId           = "TestLabel"
                AdvancedSettings   = (New-CimInstance -ClassName MSFT_SCLabelSetting -Property @{
                        Key   = "LabelStatus"
                        Value = "Enabled"
                    } -clientOnly)
                LocaleSettings     = (New-CimInstance -ClassName MSFT_SCLabelLocaleSettings -Property @{
                        LocaleKey = "DisplayName"
                        Settings  = (New-CimInstance -ClassName MSFT_SCLabelSetting -Property @{
                                Key   = "en-us"
                                Value = "English DisplayName"
                            } -ClientOnly)
                    } -clientOnly)
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-Label -MockWith {
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

        Context -Name "Label already exists" -Fixture {
            $testParams = @{
                Name               = "TestLabel"
                Comment            = "This is a test label"
                ToolTip            = "Test tool tip"
                DisplayName        = "Test label"
                ParentId           = "MyLabel"

                AdvancedSettings   = (New-CimInstance -ClassName MSFT_SCLabelSetting -Property @{
                        Key   = "LabelStatus"
                        Value = "Enabled"
                    } -clientOnly)

                LocaleSettings     = (New-CimInstance -ClassName MSFT_SCLabelLocaleSettings -Property @{
                        LocaleKey = "DisplayName"
                        Settings  = (New-CimInstance -ClassName MSFT_SCLabelSetting -Property @{
                                Key   = "en-us"
                                Value = "English DisplayName"
                            } -ClientOnly)
                    } -clientOnly)

                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-Label -MockWith {
                return @{
                    Name           = "TestLabel"
                    Comment        = "Updated comment"
                    ToolTip        = "Test tool tip"
                    DisplayName    = "Test label"
                    ParentId       = "MyLabel"
                    Priority       = "2"
                    Settings       = '{"Key": "LabelStatus",
                                        "Value": "Enabled"}'
                    LocaleSettings = '{"LocaleKey":"DisplayName",
                                         "Settings":[
                                         {"Key":"en-us","Value":"English Display Names"}]}'

                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "Label should not exist" -Fixture {
            $testParams = @{
                Name               = "TestLabel"
                ParentId           = "MyLabel"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Absent"
            }

            Mock -CommandName Get-Label -MockWith {
                return @{
                    ParentId = "MyLabel"
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Get-Label -MockWith {
                $null
            }

            It 'Should delete from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }
        }


        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }
            Mock -CommandName Get-Label  -MockWith {
                return @{
                    Name           = "TestRule"
                    Settings       = '{"Key": "LabelStatus",
                                        "Value": "Enabled"}'
                    LocaleSettings = '{"LocaleKey":"DisplayName",
                                         "Settings":[
                                         {"Key":"en-us","Value":"English Display Names"}]}'
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
