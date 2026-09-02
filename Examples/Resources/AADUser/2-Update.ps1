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
        AADUser 'ConfigureJohnSMith'
        {
            UserPrincipalName  = "John.Smith@$TenantId"
            FirstName          = "John"
            LastName           = "Smith"
            DisplayName        = "John J. Smith"
            City               = "Ottawa" # Updated
            Country            = "Canada"
            Office             = "Ottawa - Queen"
            UsageLocation      = "US"
            CustomSecurityAttributes = @(
                MSFT_AADUserAttributeSet{
                    AttributeSetName = 'Engineering'
                    AttributeValues  = @(
                        MSFT_AADUserAttributeValue{
                            AttributeName    = 'Project'
                            StringArrayValue = @('Baker', 'Cascade', 'Denali') # Updated
                        }
                        MSFT_AADUserAttributeValue{
                            AttributeName = 'Datacenter'
                            StringValue   = 'Portland' # Updated
                        }
                    )
                }
            )
            Ensure             = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
