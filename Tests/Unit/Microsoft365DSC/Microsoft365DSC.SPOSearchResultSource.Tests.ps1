[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Microsoft365DSC.psm1" `
            -Resolve)
)
$GenericStubPath = (Join-Path -Path $PSScriptRoot `
    -ChildPath "..\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "SPOSearchResultSource" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }
        $existingValueXML = "<SearchConfigurationSettings xmlns=`"http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Portability`" xmlns:i=`"http://www.w3.org/2001/XMLSchema-instance`">
        <SearchQueryConfigurationSettings><SearchQueryConfigurationSettings>
        <BestBets xmlns:d4p1=`"http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08`" />
        <DefaultSourceId>00000000-0000-0000-0000-000000000000</DefaultSourceId>
        <DefaultSourceIdSet>true</DefaultSourceIdSet>
        <DeployToParent>false</DeployToParent>
        <DisableInheritanceOnImport>false</DisableInheritanceOnImport>
        <QueryRuleGroups xmlns:d4p1=`"http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08`" />
        <QueryRules xmlns:d4p1=`"http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08`" />
        <ResultTypes xmlns:d4p1=`"http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration`" />
        <Sources xmlns:d4p1=`"http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration.Query`">
        <d4p1:Source>
        <d4p1:ConnectionUrlTemplate></d4p1:ConnectionUrlTemplate>
        <d4p1:CreatedDate>2019-03-01T09:18:13.00</d4p1:CreatedDate>
        <d4p1:Description>New Result Source</d4p1:Description>
        <d4p1:Id>4483418f-8ccc-4628-b9de-0a89be1e14e8</d4p1:Id>
        <d4p1:Name>This is a Test</d4p1:Name>
        <d4p1:ProviderId>fa947043-6046-4f97-9714-40d4c113963d</d4p1:ProviderId>
        <d6p1:ParentType xmlns:d6p1=`"http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08`">
        <d6p1:Id>Source</d6p1:Id>
        <d6p1:QueryPropertyExpressions>
        <d6p1:MaxSize>2147483647</d6p1:MaxSize>
        <d6p1:OrderedItems /></d6p1:QueryPropertyExpressions>
        <d6p1:_IsReadOnly>true</d6p1:_IsReadOnly>
        <d6p1:_QueryTemplate></d6p1:_QueryTemplate>
        <d6p1:_SourceId nil=`"true`" />
        </d6p1:ParentType>
        </d4p1:Source>
        </Sources>
        <UserSegments xmlns:d4p1=`"http://www.microsoft.com/sharepoint/search/KnownTypes/2008/08`" />
        </SearchQueryConfigurationSettings></SearchQueryConfigurationSettings>
        <SearchRankingModelConfigurationSettings>
        <RankingModels xmlns:d3p1=`"http://schemas.microsoft.com/2003/10/Serialization/Arrays`" />
        </SearchRankingModelConfigurationSettings>
        <SearchSchemaConfigurationSettings>
        <Aliases xmlns:d3p1=`"http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration`">
        <d3p1:LastItemName i:nil=`"true`" />
        <d3p1:dictionary xmlns:d4p1=`"http://schemas.microsoft.com/2003/10/Serialization/Arrays`" />
        </Aliases>
        <CategoriesAndCrawledProperties xmlns:d3p1=`"http://schemas.microsoft.com/2003/10/Serialization/Arrays`" />
        <CrawledProperties xmlns:d3p1=`"http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration`" i:nil=`"true`" />
        <ManagedProperties xmlns:d3p1=`"http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration`">
        <d3p1:LastItemName i:nil=`"true`" />
        <d3p1:dictionary xmlns:d4p1=`"http://schemas.microsoft.com/2003/10/Serialization/Arrays`" />
        <d3p1:TotalCount>0</d3p1:TotalCount>
        </ManagedProperties>
        <Mappings xmlns:d3p1=`"http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration`">
        <d3p1:LastItemName i:nil=`"true`" />
        <d3p1:dictionary xmlns:d4p1=`"http://schemas.microsoft.com/2003/10/Serialization/Arrays`" />
        </Mappings>
        <Overrides xmlns:d3p1=`"http://schemas.datacontract.org/2004/07/Microsoft.Office.Server.Search.Administration`">
        <d3p1:LastItemName i:nil=`"true`" />
        <d3p1:dictionary xmlns:d4p1=`"http://schemas.microsoft.com/2003/10/Serialization/Arrays`" />
        </Overrides>
        </SearchSchemaConfigurationSettings>
        <SearchSubscriptionSettingsConfigurationSettings i:nil=`"true`" />
        <SearchTaxonomyConfigurationSettings i:nil=`"true`" />
        </SearchConfigurationSettings>"

        # Test contexts
        Context -Name "When the Result Source doesn't already exist" -Fixture {
            $testParams = @{
                Name               = "TestRS"
                Description        = "New Result Source"
                Protocol           = "Local"
                SourceURL          = ""
                Type               = "SharePoint"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $xmlTemplatePath = Join-Path -Path $PSScriptRoot `
                -ChildPath "..\..\..\Modules\Microsoft365DSC\Dependencies\SearchConfigurationSettings.xml" `
                -Resolve
            $emptyXMLTemplate = Get-Content $xmlTemplatePath
            Mock -CommandName Get-PnPSearchConfiguration -MockWith {

                return $emptyXMLTemplate
            }

            Mock -CommandName Set-PnPSearchConfiguration -MockWith {

            }

            It "Should return Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Creates the result source in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "When the Result Source already exists" -Fixture {
            $Script:RecentExtract = $null
            $testParams = @{
                Name               = "This is a Test"
                Description        = "New Result Source"
                Protocol           = "Local"
                Type               = "SharePoint"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }
            Mock -CommandName Get-PnPSearchConfiguration -MockWith {
                return $existingValueXML
            }

            Mock -CommandName Set-PnPSearchConfiguration -MockWith {

            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }

            It "Update the managed property in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount          = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPSearchConfiguration -MockWith {
                return $existingValueXML
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
