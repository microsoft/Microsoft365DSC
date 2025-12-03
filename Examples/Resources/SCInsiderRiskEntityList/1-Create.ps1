<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC
    node localhost
    {
        SCInsiderRiskEntityList "SCInsiderRiskEntityList-MyFileType"
        {
            ApplicationId                          = $ApplicationId;
            CertificateThumbprint                  = $CertificateThumbprint;
            Description                            = "Test file type";
            DisplayName                            = "MyFileType";
            Ensure                                 = "Present";
            FileTypes                              = @(".exe",".cmd",".bat");
            Keywords                               = @();
            ListType                               = "CustomFileTypeLists";
            Name                                   = "MyFileTypeList";
            TenantId                               = $OrganizationName;
        }
    }
}
