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
    -DscResource "SCFilePlanPropertyCitation" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Remove-FilePlanPropertyCitation -MockWith {
            return @{

            }
        }

        Mock -CommandName New-FilePlanPropertyCitation -MockWith {
            return @{

            }
        }

        Mock -CommandName Set-FilePlanPropertyCitation -MockWith {
            return @{

            }
        }

        # Test contexts
        Context -Name "Citation doesn't already exist" -Fixture {
            $testParams = @{
                Name                 = "Demo Citation"
                CitationURL          = "https://contoso.com/Citation"
                CitationJurisdiction = "State"
                GlobalAdminAccount   = $GlobalAdminAccount
                Ensure               = "Present"
            }

            Mock -CommandName Get-FilePlanPropertyCitation -MockWith {
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

        Context -Name "Citation already exists, but need to update properties" -Fixture {
            $testParams = @{
                Name                 = "Demo Citation"
                CitationURL          = "https://contoso.com/Citation"
                CitationJurisdiction = "State"
                GlobalAdminAccount   = $GlobalAdminAccount
                Ensure               = "Present"
            }

            Mock -CommandName Get-FilePlanPropertyCitation -MockWith {
                return @{
                    Name                 = "Demo Citation"
                    CitationURL          = "https://contoso.com/Different"
                    CitationJurisdiction = "State"
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

        Context -Name "Citation should not exist" -Fixture {
            $testParams = @{
                Name                 = "Demo Citation"
                CitationURL          = "https://contoso.com/Citation"
                CitationJurisdiction = "State"
                GlobalAdminAccount   = $GlobalAdminAccount
                Ensure               = "Present"
            }

            Mock -CommandName Get-FilePlanPropertyCitation -MockWith {
                return @{
                    Name                 = "Demo Citation"
                    CitationURL          = "https://contoso.com/Different"
                    CitationJurisdiction = "State"
                }
            }

            It 'Should return False from the Test method' {
                Test-TargetResource @testParams | Should Be $False
            }

            It 'Should delete from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
