<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC
    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        AADGroup 'MyGroups'
        {
            DisplayName     = "DSCGroup"
            Description     = "Microsoft DSC Group Updated" # Updated Property
            SecurityEnabled = $True
            MailEnabled     = $True
            GroupTypes      = @("Unified")
            MailNickname    = "M365DSC"
            Visibility      = "Private"
            Owners          = @("AdeleV@$Domain")
            Ensure          = "Present"
            Credential      = $Credscredential
        }
    }
}
