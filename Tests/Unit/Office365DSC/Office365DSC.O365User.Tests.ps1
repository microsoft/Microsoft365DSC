[CmdletBinding()]
param(
    [Parameter()]
    [string] 
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
                                         -ChildPath "..\Stubs\Office365.psm1" `
                                         -Resolve)
)

Import-Module -Name (Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\UnitTestHelper.psm1" `
                                -Resolve)

$Global:DscHelper = New-O365DscUnitTestHelper -StubModule $CmdletModule `
                                              -DscResource "O365User"
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        # Test contexts 
        Context -Name "When the site doesn't already exist" -Fixture {
            $testParams = @{
                UserPrincipalName = "JohnSmith@contoso.onmicrosoft.com"
                DisplayName = "John Smith"
                FirstName = "John"
                LastName = "Smith"
                UsageLocation = "US"
                LicenseAssignment = "CONTOSO:ENTERPRISE_PREMIUM"
                Password = $GlobalAdminAccount
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName New-MSOLUser -MockWith { 
                
            }
            
            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent" 
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
