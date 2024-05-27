<#
This example removes a Device Remediation.
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
        IntuneDeviceRemediation 'ConfigureDeviceRemediation'
        {
            Id          = '00000000-0000-0000-0000-000000000000'
            DisplayName = 'Device remediation'
            Ensure      = 'Absent'
            Credential  = $Credscredential
        }
    }
}
