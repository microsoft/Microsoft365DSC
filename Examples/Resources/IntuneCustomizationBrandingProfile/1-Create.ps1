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
        IntuneCustomizationBrandingProfile "IntuneCustomizationBrandingProfile-Company"
        {
            ApplicationId                  = $ApplicationId;
            Assignments                    = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    dataType = "#microsoft.graph.groupAssignmentTarget"
                    groupId = "00000000-0000-0000-0000-000000000000"
                    deviceAndAppManagementAssignmentFilterType = "none"
                    groupDisplayName = "Include"
                }
            );
            CertificateThumbprint          = $CertificateThumbprint;
            CompanyPortalBlockedActions    = @(
                MSFT_MicrosoftGraphcompanyPortalBlockedAction{
                    Action = "remove"
                    OwnerType = "company"
                    Platform = "windows10AndLater"
                }
            );
            ContactITEmailAddress          = "test@company.com";
            ContactITName                  = "Contact_Name";
            ContactITNotes                 = "Additional information";
            ContactITPhoneNumber           = "+10000000";
            CustomCanSeePrivacyMessage     = "**Bold subhead example with some *emphasis*** and [a link](http://microsoft.com)";
            CustomCantSeePrivacyMessage    = "**Bold subhead example with some *emphasis*** and [a link](http://microsoft.com)";
            DisableDeviceCategorySelection = $False;
            DisplayName                    = "Company";
            EnrollmentAvailability         = "availableWithPrompts";
            Ensure                         = "Present";
            LandingPageCustomizedImage     = MSFT_MicrosoftGraphMimeContent{
                Type = "image/jpeg"
                Value = "Base64EncodedString"
            };
            LightBackgroundLogo            = MSFT_MicrosoftGraphMimeContent{
                Type = "image/png"
                Value = "Base64EncodedString"
            };
            OnlineSupportSiteName          = "Website";
            OnlineSupportSiteUrl           = "https://website.com";
            PrivacyUrl                     = "https://www.example.com";
            ProfileDescription             = "";
            ProfileName                    = "IntuneCustomizationBrandingProfile_1";
            RoleScopeTagIds                = @("0");
            ShowAzureADEnterpriseApps      = $True;
            ShowConfigurationManagerApps   = $True;
            ShowDisplayNameNextToLogo      = $True;
            ShowLogo                       = $True;
            ShowOfficeWebApps              = $True;
            TenantId                       = $TenantId;
            ThemeColor                     = MSFT_MicrosoftGraphRgbColor{
                B = 198
                G = 114
                R = 0
            };
            ThemeColorLogo                 = MSFT_MicrosoftGraphMimeContent{
                Type = "image/png"
                Value = "Base64EncodedString"
            };
        }
    }
}
