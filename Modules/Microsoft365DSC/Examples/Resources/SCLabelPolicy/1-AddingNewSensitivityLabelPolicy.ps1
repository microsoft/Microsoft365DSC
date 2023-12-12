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

    node localhost
    {
        SCLabelPolicy 'ConfigureLabelPolicy'
        {
            Name             = "DemoLabelPolicy"
            Comment          = "Demo Label policy comment"
            Labels           = @("Personal", "General")
            ExchangeLocation = @("All")
            AdvancedSettings = @(
                MSFT_SCLabelSetting
                {
                    Key   = "AllowedLevel"
                    Value = @("Sensitive", "Classified")
                }
                MSFT_SCLabelSetting
                {
                    Key   = "LabelStatus"
                    Value = "Enabled"
                }
            )
            Ensure           = "Present"
            Credential       = $Credscredential
        }
    }
}
