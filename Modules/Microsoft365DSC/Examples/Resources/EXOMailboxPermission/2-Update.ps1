<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOMailboxPermission "TestPermission"
        {
            AccessRights         = @("FullAccess","ReadPermission");
            Credential           = $credsCredential;
            Deny                 = $True; # Updated Property
            Ensure               = "Present";
            Identity             = "AlexW@$Domain";
            InheritanceType      = "All";
            User                 = "NT AUTHORITY\SELF";
        }
    }
}
