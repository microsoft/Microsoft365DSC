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
        EXOMailContact 'TestMailContact'
        {
            Alias                       = 'TestMailContact'
            Credential                  = $Credscredential
            DisplayName                 = 'My Test Contact'
            Ensure                      = 'Absent'
            ExternalEmailAddress        = 'SMTP:test@tailspintoys.com'
            Name                        = 'My Test Contact'
            OrganizationalUnit          = $Domain
            SendModerationNotifications = 'Always'
            UsePreferMessageFormat      = $false # Updated Property
            CustomAttribute1            = 'Custom Value 1'
            ExtensionCustomAttribute5   = 'Extension Custom Value 1', 'Extension Custom Value 2'
        }
    }
}
