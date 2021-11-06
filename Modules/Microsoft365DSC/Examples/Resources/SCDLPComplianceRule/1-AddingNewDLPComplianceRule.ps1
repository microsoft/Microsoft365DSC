<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SCDLPComplianceRule 'ConfigureDLPComplianceRule'
        {
            AccessScope                         = "InOrganization"
            BlockAccess                         = $True
            BlockAccessScope                    = "All"
            ContentContainsSensitiveInformation = @(
                MSFT_SCDLPSensitiveInformation
                {
                    name           = 'EU Debit Card Number'
                    id             = '0e9b3178-9678-47dd-a509-37222ca96b42'
                    maxconfidence  = '100'
                    minconfidence  = '75'
                    classifiertype = 'Content'
                    mincount       = '1'
                    maxcount       = '9'
                }
            )
            Disabled                            = $False
            DocumentIsPasswordProtected         = $False
            DocumentIsUnsupported               = $False
            ExceptIfDocumentIsPasswordProtected = $False
            ExceptIfDocumentIsUnsupported       = $False
            ExceptIfHasSenderOverride           = $False
            ExceptIfProcessingLimitExceeded     = $False
            GenerateIncidentReport              = @("SiteAdmin")
            HasSenderOverride                   = $False
            IncidentReportContent               = @("DocumentLastModifier", "Detections", "Severity", "DetectionDetails", "OriginalContent")
            Name                                = "Low volume EU Sensitive content found"
            NotifyUser                          = @("LastModifier")
            Policy                              = "General Data Protection Regulation (GDPR)"
            ProcessingLimitExceeded             = $False
            RemoveRMSTemplate                   = $False
            ReportSeverityLevel                 = "Low"
            StopPolicyProcessing                = $False
            Ensure                              = "Present"
            Credential                          = $Credsglobaladmin
        }
    }
}
