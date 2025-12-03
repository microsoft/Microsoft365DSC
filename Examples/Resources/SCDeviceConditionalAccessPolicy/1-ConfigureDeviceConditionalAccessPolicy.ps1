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
        SCDeviceConditionalAccessPolicy 'ConfigureDeviceConditionalAccessPolicy'
        {
            Name                 = "Human Resources"
            Comment              = "Device Conditional Access Policy for Human Resources department"
            Enabled              = $True
            Ensure               = "Present"
            Credential           = $Credscredential
        }
    }
}
