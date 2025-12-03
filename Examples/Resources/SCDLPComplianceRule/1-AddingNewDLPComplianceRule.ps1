<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SCDLPComplianceRule 'ConfigureDLPComplianceRule'
        {
            Name                                = 'Low volume EU Sensitive content found'
            Policy                              = 'General Data Protection Regulation (GDPR)'
            AccessScope                         = 'InOrganization'
            BlockAccess                         = $True
            BlockAccessScope                    = 'All'
            AdvancedRule                        = "`"{\r\n  \`"Version\`": \`"1.0\`",\r\n  \`"Condition\`": {\r\n    \`"Operator\`": \`"And\`",\r\n    \`"SubConditions\`": [\r\n      {\r\n        \`"ConditionName\`": \`"AccessScope\`",\r\n        \`"Value\`": \`"InOrganization\`"\r\n      },\r\n      {\r\n        \`"ConditionName\`": \`"ContentContainsSensitiveInformation\`",\r\n        \`"Value\`": {\r\n          \`"maxconfidence\`": \`"100\`",\r\n          \`"name\`": \`"EU Debit Card Number\`",\r\n          \`"maxcount\`": \`"9\`",\r\n          \`"minconfidence\`": \`"75\`",\r\n          \`"classifiertype\`": \`"Content\`",\r\n          \`"mincount\`": \`"1\`",\r\n          \`"confidencelevel\`": \`"Medium\`"\r\n        }\r\n      }\r\n    ]\r\n  }\r\n}`"";
            ContentContainsSensitiveInformation = MSFT_SCDLPContainsSensitiveInformation
            {
                SensitiveInformation = @(
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
            }
            Disabled                            = $False
            DocumentIsPasswordProtected         = $False
            DocumentIsUnsupported               = $False
            ExceptIfDocumentIsPasswordProtected = $False
            ExceptIfDocumentIsUnsupported       = $False
            ExceptIfHasSenderOverride           = $False
            ExceptIfProcessingLimitExceeded     = $False
            GenerateIncidentReport              = @('SiteAdmin')
            HasSenderOverride                   = $False
            IncidentReportContent               = @('DocumentLastModifier', 'Detections', 'Severity', 'DetectionDetails', 'OriginalContent')
            NotifyUser                          = @('LastModifier')
            ProcessingLimitExceeded             = $False
            RemoveRMSTemplate                   = $False
            ReportSeverityLevel                 = 'Low'
            StopPolicyProcessing                = $False
            Ensure                              = 'Present'
            Credential                          = $Credscredential
        }
    }
}
