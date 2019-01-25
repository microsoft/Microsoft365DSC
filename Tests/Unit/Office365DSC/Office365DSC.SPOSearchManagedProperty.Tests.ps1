[CmdletBinding()]
param(
    [Parameter()]
    [string] 
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
                                         -ChildPath "..\Stubs\Office365DSC.psm1" `
                                         -Resolve)
)

Import-Module -Name (Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\UnitTestHelper.psm1" `
                                -Resolve)

$Global:DscHelper = New-O365DscUnitTestHelper -StubModule $CmdletModule `
                                                -DscResource "SPOSearchManagedProperty"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-PnPOnlineConnection -MockWith {

        }

        # Test contexts 
        Context -Name "When the Managed Property doesn't already exist" -Fixture {
            $testParams = @{
                Name ="TestMP"
                Type = "Text"
                Description = "This is a test"
                Searchable = $false
                FullTextContext = 0
                Queryable = $false
                Retrievable = $false
                AllowMultipleValues = $false
                Refinable = "No"
                Sortable = "No"
                Safe = $false
                Aliases = @("Alias1")
                TokenNormalization = $true
                CompleteMatching = $false
                LanguageNeutralTokenization = $true
                FinerQueryTokenization = $false
                CompanyNameExtraction = $true
                Ensure = "Present"
                GlobalAdminAccount = $Global:AdminAccount
                CentralAdminUrl = "https://contoso-admin.sharepoint.com"
            }

            Mock -CommandName Get-PnPSearchConfiguration -MockWith { 
                $xmlTemplatePath = Join-Path -Path $PSScriptRoot `
                                    -ChildPath "..\..\..\Modules\Office365DSC\Dependencies\SearchConfiguration.xml" `
                                    -Resolve
                return (Get-Content $xmlTemplatePath)
            }

            Mock -CommandName Set-PnPSearchConfiguration -MockWith { 

            }
            
            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present" 
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Creates the managed property in the Set method" {
                Set-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
