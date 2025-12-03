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
        SCAutoSensitivityLabelRule 'TestRule'
        {
            Comment                             = 'Detects when 1 to 9 credit card numbers are contained in Exchange items'
            ContentContainsSensitiveInformation = MSFT_SCDLPContainsSensitiveInformation
            {
                operator = 'And'
                Groups   =
                @(MSFT_SCDLPContainsSensitiveInformationGroup
                    {
                        operator             = 'And'
                        name                 = 'Default'
                        SensitiveInformation = @(
                            MSFT_SCDLPSensitiveInformation
                            {
                                name           = 'Credit Card Number'
                                id             = '50842eb7-edc8-4019-85dd-5a5c1f2bb085'
                                maxconfidence  = '100'
                                minconfidence  = '85'
                                classifiertype = 'Content'
                                mincount       = '1'
                                maxcount       = '9'
                            }
                        )
                    }
                )
            }
            Credential                          = $Credscredential
            Disabled                            = $False
            DocumentIsPasswordProtected         = $False
            DocumentIsUnsupported               = $False
            Ensure                              = 'Present'
            ExceptIfDocumentIsPasswordProtected = $False
            ExceptIfDocumentIsUnsupported       = $False
            ExceptIfProcessingLimitExceeded     = $False
            Name                                = 'My Test Rule'
            Policy                              = 'My Test Policy'
            ProcessingLimitExceeded             = $False
            ReportSeverityLevel                 = 'Low'
            Workload                            = 'Exchange'
        }
    }
}
